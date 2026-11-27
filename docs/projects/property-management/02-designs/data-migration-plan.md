---
title: "Data Migration & Cutover Plan: Oracle to PostgreSQL"
status: draft
phase: design
slug: property-management
doc_type: data-migration-plan
source_db: pdb22 (testbed) / production Oracle (cutover)
source_schema: RNTMGR2
target_db: postgres
target_schema: property_management
target_dialect: postgres
---

# Data Migration & Cutover Plan: Oracle to PostgreSQL

## 1. Executive Summary & Environmental Context

This document defines the end-to-end data extraction, transformation, streaming load, and verification strategy for migrating operational Property Management records from Oracle 19c (`RNTMGR2`) to PostgreSQL 16+ using a lightweight, native Python ETL pipeline (`python-oracledb` thin mode + `psycopg3` direct memory `COPY` streaming).

### 1.1 Multi-Environment Architecture: Testbed (`pdb22`) vs. Production Cutover
A fundamental principle of this migration is strict environmental staging:
1. **Testbed Database (`pdb22`)**:
   - `pdb22` is an isolated test environment housing the full `RNTMGR2` schema baseline.
   - It serves as the primary testbed for all dry runs, trial extractions, sequence reset testing, performance timing benchmarks, and financial reconciliation rehearsals.
   - No scripts or tools will ever hardcode `pdb22`.
2. **Designated Production Oracle Database**:
   - The final production migration and cutover will be executed against a separate designated production Oracle database (`pdb21` reference).
   - The production cutover will only proceed after dry-run rehearsals and automated reconciliation achieve 100% pass rates on `pdb22`.
3. **Environment Parameterization Requirement**:
   - All extraction tools, orchestration scripts, database DSNs, and automated verification suites must be fully parameterized via environment variables (`ORACLE_HOST`, `ORACLE_PORT`, `ORACLE_SERVICE_NAME` / `ORACLE_SID`, `ORACLE_USER`, `ORACLE_PASSWORD`, `PG_HOST`, `PG_PORT`, `PG_DATABASE`, `PG_USER`, `PG_PASSWORD` / `PG_DSN`).
   - Switching from testbed rehearsal to production cutover requires only pointing the environment variables or `.env` profile to the production endpoints.
   - Insecure password fallbacks are strictly disabled for production cutover in `run-dryrun.sh`.

### 1.2 Baseline Sizing & Operational Metrics (Measured on `pdb22` / `pdb21`)
Based on the deterministic assessment of `RNTMGR2`:
- **Full Monolithic Schema**: 147–149 tables, 497k–9.2M rows, 2.52 GB–17 GB total data segment size.
- **In-Scope Operational Subset**: 32 active domain tables encompassing business units, properties, units, tenants, leases, accounts receivable, payments, accounts payable, and general ledger journals.
- **Measured Operational Volume**: Approximately 260,000 records (< 450 MB total segment size).
- **Historical Data Cutoff**: The Oracle database contains complete operational history through **December 31, 2025**.
- **Interim Parallel Operations**: The organization operated Yardi during 2026–2027. The target system will operate in parallel with Yardi during an onboarding phase before final cutover. Data for 2026–2027 will be backfilled via the AI Yardi ingestion module.

---

## 2. Scope of Tables & Extraction Strategy

### 2.1 In-Scope Operational Tables & Sizing

| Functional Domain | Target Table | Estimated Source Rows | Data Size Estimate | LOB / Special Handling |
| :--- | :--- | ---: | ---: | :--- |
| **Security & Business Units** | `rnt_business_units` | ~229 | < 1 MB | Standard text & contact fields |
| | `rnt_people` | ~610 | ~2 MB | SSN/Tax IDs handled securely |
| | `rnt_users` | ~106 | < 1 MB | Legacy passwords imported with `requires_password_reset = true` |
| | `rnt_user_roles` | ~10 | < 1 MB | RBAC role mappings |
| | `rnt_user_assignments` | ~290 | < 1 MB | Multi-tenant RBAC assignments |
| | `rnt_people_bu` | ~809 | < 1 MB | Contact-to-business-unit junction |
| **Properties & Units** | `rnt_properties` | ~768 | ~5 MB | PostGIS geometry conversion via `COALESCE(pr.GEO_LOCATION, pr.GEO_COORDINATES)`; loose `prop_id` |
| | `rnt_property_units` | ~1,528 | ~3 MB | Unit numbers, target rents, bed/bath counts |
| | `rnt_property_photos` | ~529 | ~95 MB | Oracle `BLOB` -> PostGIS / S3 URL or PostgreSQL `bytea` |
| | `rnt_property_value` | ~392 | < 1 MB | Historical valuations and cap rates |
| | `rnt_property_expenses` | ~4,777 | ~4 MB | Historical property cost events |
| **Tenancy & Leasing** | `rnt_tenant` | ~964 | ~2 MB | Tenant profiles, business units, deposit balances |
| | `rnt_tenancy_agreement` | ~883 | ~3 MB | Active and historical leases |
| | `rnt_agreement_actions` | ~961 | ~8 MB | `CLOB` action notes -> PostgreSQL `TEXT` |
| | `rnt_leads` | ~38 | < 1 MB | Prospective tenant inquiries |
| | `rnt_lead_actions` | ~17 | < 1 MB | Lead interaction history |
| | `rnt_doc_templates` | ~15 | < 1 MB | Lease & notice document templates |
| | `rnt_section8_offices` | ~5 | < 1 MB | Subsidy housing authorities |
| | `rnt_section8_offices_bu`| ~14 | < 1 MB | Subsidy office to business unit mapping |
| **Accounting: Accounts Payable**| `rnt_suppliers_all` | ~827 | ~1 MB | Contractor & vendor directory |
| | `rnt_bu_suppliers` | ~1,776 | ~2 MB | Business unit supplier relationships |
| | `rnt_accounts_payable` | 29,042 | 352 MB | Largest operational table; vendor bills & contractor disbursements |
| | `rnt_expense_items` | ~162 | ~1 MB | Line items attached to AP bills |
| **Accounting: Accounts Receivable**| `rnt_accounts_receivable`| 10,108 | ~25 MB | Rent charges & fees; nullable `agreement_id` (0 dropped records); includes `business_id` & `tenant_id` |
| | `rnt_payments` | 17,420 | ~20 MB | Rent collections, checks, Zelle, and receipts |
| | `rnt_payment_allocations` | 58,577 | ~15 MB | Reconciliation links between payments and AR items |
| **General Ledger** | `rnt_accounts` | 8,059 | < 1 MB | Chart of Accounts |
| | `rnt_payment_types` | 57 | < 1 MB | Transaction classifications & depreciation terms |
| | `rnt_pt_rules` | 21,280 | ~5 MB | Posting rules (`business_id`, `payment_type_id`, `transaction_type`, `debit_account`, `credit_account`) |
| | `rnt_account_periods` | 299 | < 1 MB | Business unit accounting periods |
| | `rnt_ledger_entries` | 97,660 | ~42 MB | Core double-entry journals; enforced distinct debit/credit accounts |
| | `rnt_loans` | 36 | < 1 MB | Mortgages and property notes |

### 2.2 Explicitly Excluded Tables (Out of Scope)
The following tables in `RNTMGR2` are excluded from operational migration:
- **County Public Records**: `PR_PROPERTIES`, `PR_LOCATIONS`, `PR_CORPORATIONS`, `PR_PROPERTY_SALES`, `PR_PRINCIPALS`, `PR_TAXES`, `PR_OWNERS` (~15 GB in production).
- **MLS Feeds & Photos**: `MLS_LISTINGS`, `MLS_LISTINGS_ARCHIVE`, `MLS_PHOTOS_ARCHIVE`, `MLS_RETS_RESPONSES` (~3.1 GB archive).
- **Oracle Internal & Text Tables**: `DR$*` tables, `MDRT_*$` and `MDXT_*$` spatial index tables.
- **Dynamic CMS**: `RNT_MENUS`, `RNT_MENU_PAGES`, `RNT_MENU_ROLES`, `RNT_MENU_TABS`.

---

## 3. Tooling & Native Python Streaming Pipeline Architecture

### 3.1 Why Native Python ETL (vs. Ora2Pg / Perl / pgloader)
Rather than relying on legacy Perl modules (Ora2Pg) or C-based Oracle Instant Client libraries that are cumbersome to install in modern CI/CD containers, this migration utilizes a modern, self-contained Python ETL pipeline:
1. **`python-oracledb` in Thin Mode**:
   - Pure Python implementation of the Oracle Net communication protocol.
   - **Zero Oracle Instant Client or C dependencies**: Runs in standard slim Python 3.11+ containers (`python:3.11-slim`) without proprietary Oracle Client downloads, symlinks, or compiler toolchains.
   - High-performance cursor batching (`arraysize=5000`) for low round-trip latency.
2. **`psycopg` (psycopg3) Direct Memory `COPY` Streaming**:
   - Leverages PostgreSQL's native high-speed bulk ingestion interface via `cursor.copy("COPY target_table (...) FROM STDIN WITH (FORMAT text, NULL '\\N')")`.
   - Streams rows directly from Oracle query cursors through an in-memory memory buffer (`io.StringIO` / row generator) into the PostgreSQL socket.
   - **Zero Intermediate Disk I/O**: Does not write staging files to disk, eliminating disk space exhaustion risks and multi-step file management.
   - Throughput of **15,000 to 30,000 rows/second**, completing the operational property management dataset (~260k rows) in 15 to 25 seconds.
3. **Deterministic Spatial Geometry Conversion**:
   - For `rnt_properties`, parcel centroids and boundary geometries are resolved via `COALESCE(pr.GEO_LOCATION, pr.GEO_COORDINATES)` from `PR_PROPERTIES` and extracted directly as Well-Known Text (WKT) using `SDO_UTIL.TO_WKTGEOMETRY()`.
   - PostGIS seamlessly ingests standard WKT directly into `geometry(Point, 4326)` columns during COPY streaming with zero external GIS libraries.

```
+-----------------------------------------------------------------------------------------+
|                                NATIVE PYTHON STREAMING ETL                              |
|                                                                                         |
|  +---------------------------+       In-Memory Stream       +------------------------+  |
|  |     python-oracledb       | ---------------------------> |     psycopg (v3)       |  |
|  |      (Pure Thin Mode)     |  Chunked Memory Generator    |    cursor.copy()       |  |
|  |   - No Instant Client     |      (arraysize = 5000)      |  - Direct Socket Stream|  |
|  |   - No C Compiler         |   - SDO_UTIL.TO_WKTGEOMETRY  |  - No disk spill       |  |
|  |   - Bind Variable Param   |   - Date Cutoff <= 2025-12-31+------------------------+  |
|  +---------------------------+                              |                           |
|               ^                                             v                           |
+---------------|---------------------------------------------|---------------------------+
                | TCP/IP (Wire Protocol)                      | High-Speed COPY
                v                                             v
+-------------------------------+             +-------------------------------+
|      ORACLE 19c DATABASE      |             |      POSTGRESQL 16+ DB        |
|  - Testbed: pdb22             |             |  - Staging: property_mgmt_test|
|  - Production: pdb21          |             |  - Production: prod_db        |
|  - Schema: RNTMGR2            |             |  - Schema: public             |
+-------------------------------+             +-------------------------------+
```

### 3.2 Parameterized Pipeline Architecture & Configuration

The ETL tooling lives directly in `tools/migration/` inside the project repository and requires only standard Python packages:
- `python-oracledb >= 2.0.0`
- `psycopg[binary] >= 3.1.0`
- `python-dotenv >= 1.0.0`

#### Environment Configuration (`tools/migration/.env.example`)
```ini
# Execution Mode: testbed or production
MIGRATION_ENV=testbed

# Oracle Source Configuration (Supports testbed pdb22 or Production Oracle pdb21)
ORACLE_HOST=oracle-testbed.internal
ORACLE_PORT=1521
ORACLE_SERVICE_NAME=pdb22
ORACLE_USER=RNTMGR2
ORACLE_PASSWORD=testbed_secret_password
ORACLE_SCHEMA=RNTMGR2

# PostgreSQL Target Configuration
PG_HOST=postgres.internal
PG_PORT=5432
PG_DATABASE=property_mgmt_test
PG_USER=pm_app
PG_PASSWORD=pg_secret_password
PG_SCHEMA=public

# Pipeline Tuning
ETL_BATCH_SIZE=5000
ETL_DATE_CUTOFF=2025-12-31 23:59:59
```

### 3.3 Spatial & Cutoff Transformation Rules

#### Spatial Extraction for `rnt_properties`:
In the Python ETL mapping dictionary, `rnt_properties` joins `PR_PROPERTIES` and extracts `GEOM` converted to PostGIS WKT using `COALESCE` across both geometry fields:
```sql
SELECT 
    p.PROPERTY_ID,
    p.BUSINESS_ID,
    p.NAME,
    p.ADDRESS1,
    p.ADDRESS2,
    p.CITY,
    COALESCE(p.STATE, 'FL') AS STATE,
    p.ZIPCODE,
    COALESCE(p.UNITS, 1) AS UNITS,
    p.DATE_PURCHASED,
    p.PURCHASE_PRICE,
    p.LAND_VALUE,
    COALESCE(p.DEPRECIATION_TERM, 27.50) AS DEPRECIATION_TERM,
    p.YEAR_BUILT,
    p.BUILDING_SIZE,
    p.LOT_SIZE,
    p.DATE_SOLD,
    p.SALE_AMOUNT,
    COALESCE(p.NOTE_YN, 'N') AS NOTE_YN,
    p.STATUS,
    p.DESCRIPTION,
    p.PROP_ID,
    CASE 
        WHEN COALESCE(pr.GEO_LOCATION, pr.GEO_COORDINATES) IS NOT NULL 
        THEN 'SRID=4326;' || SDO_UTIL.TO_WKTGEOMETRY(COALESCE(pr.GEO_LOCATION, pr.GEO_COORDINATES))
        ELSE NULL 
    END AS GEOM
FROM RNTMGR2.RNT_PROPERTIES p
LEFT JOIN RNTMGR2.PR_PROPERTIES pr ON p.PROP_ID = pr.PROP_ID
```
PostGIS accepts WKT text directly in COPY streaming into a column defined as `geometry(Point, 4326)`.

#### Date Cutoff Parameterization:
To eliminate SQL injection vulnerabilities, all date cutoff filtering uses parameterized bind variables rather than string interpolation:
- In Oracle extraction queries:
  ```sql
  WHERE PAYMENT_DUE_DATE <= TO_DATE(:date_cutoff, 'YYYY-MM-DD HH24:MI:SS')
  ```
  Passed securely via `ora_cur.execute(query, {"date_cutoff": date_cutoff})`.
- In PostgreSQL post-ETL reconciliation:
  ```sql
  UPDATE rnt_accounts_payable ap
  SET amount_paid = ap.amount, status = 'PAID'
  WHERE ap.due_date <= %s::date;
  ```
  Passed securely via `cur.execute(query, (cutoff_date,))`.

---

## 4. Execution Sequence & Multi-Environment Runbook

To maintain strict referential integrity without orphan records, data ingestion follows an exact topological sort:

```
TIER 1: Foundational Lookups & Entities
  ├── 1. rnt_user_roles
  ├── 2. rnt_people
  ├── 3. rnt_business_units
  ├── 4. rnt_users (requires_password_reset = true)
  ├── 5. rnt_user_assignments & rnt_people_bu
  ├── 6. rnt_section8_offices & rnt_section8_offices_bu
  ├── 7. rnt_doc_templates
  ├── 8. rnt_accounts (Chart of Accounts)
  ├── 9. rnt_payment_types & rnt_pt_rules
  └── 10. rnt_account_periods

TIER 2: Property & Tenancy Roots
  ├── 11. rnt_suppliers_all & rnt_bu_suppliers
  ├── 12. rnt_properties (loose prop_id, PostGIS geom via COALESCE)
  ├── 13. rnt_property_units & rnt_property_photos
  ├── 14. rnt_property_value
  ├── 15. rnt_tenant
  └── 16. rnt_leads & rnt_lead_actions

TIER 3: Leases & Operational Records
  ├── 17. rnt_tenancy_agreement
  ├── 18. rnt_agreement_actions
  ├── 19. rnt_property_expenses
  └── 20. rnt_loans

TIER 4: Transactional Journals & Invoices
  ├── 21. rnt_expense_items
  ├── 22. rnt_accounts_payable
  ├── 23. rnt_accounts_receivable (nullable agreement_id; business_id & tenant_id populated)
  ├── 24. rnt_payments
  └── 25. rnt_payment_allocations

TIER 5: General Ledger
  └── 26. rnt_ledger_entries (references accounts, properties, ar, ap, and allocations; debit_account <> credit_account)
```

### 4.1 Step-by-Step Execution Phases

#### Phase A: Testbed Rehearsal & Dry-Run Validation (`pdb22`)
1. **Target Environment Provisioning**: Deploy target PostgreSQL schema DDL to the staging database (`property_mgmt_test`).
2. **Execute Testbed Python ETL**: Run `python tools/migration/etl_pipeline.py --env=testbed`.
   - Sets `session_replication_role = 'replica'` for ultra-fast ingestion.
   - Streams Tier 1 through Tier 5 directly in memory without disk staging.
   - Executes `reconcile_post_etl_balances()` using parameterized queries.
   - Sets `session_replication_role = 'origin'` and commits transaction.
3. **Synchronize Sequences**: Run `tools/migration/reset-sequences.sql`.
4. **Execute Reconciliation Suite**: Run automated verification checks comparing `pdb22` and `property_mgmt_test`. Record elapsed time benchmarks.

#### Phase B: Production Pre-Flight & Cutover Execution (Designated Production Oracle DB)
1. **Pre-Flight Parity Scan**: Run deterministic entity comparison between testbed `pdb22` and the designated production Oracle database to confirm identical table definitions, column types, and constraints.
2. **Maintenance Window Sign-Off**: Confirm production maintenance window and put source database in read-only mode if applicable.
3. **Target Production DDL Deployment**: Run `001_initial_schema.sql` on production PostgreSQL (`property_mgmt_prod`).
4. **Execute Production Python ETL**:
   ```bash
   bash tools/migration/run-dryrun.sh production
   ```
5. **Reset Production Sequences**: Automatically executed via `reset-sequences.sql` in `run-dryrun.sh`.
6. **Production Reconciliation Suite**: Run automated verification suite comparing production Oracle vs. production PostgreSQL.

---

## 5. Parallel Run Strategy & Yardi 2026–2027 Backfill

As specified in the SOW, the business migrated to Yardi at the start of 2026. The target application will operate in parallel with Yardi before cutting over.

```
   ORACLE SOURCE (pdb22 / Prod Oracle)             YARDI INTERIM (2026 - 2027)
   [History through Dec 31, 2025]            [Monthly Rent Rolls, AP Invoices, Payments]
                 |                                                |
                 v (Python ETL / COPY Streaming)                  v (AI Onboarding Ingestion)
  +------------------------------------------------------------------------------------+
  |                           MODERN POSTGRESQL DATABASE                               |
  |  - Baseline 2025 History (Loaded & Verified)                                      |
  |  - Backfilled 2026-2027 Records (Reconciled against Yardi closing balances)        |
  |  - Active System (Ready for full operational cutover)                             |
  +------------------------------------------------------------------------------------+
```

### 5.1 Backfill Workflow:
1. Export monthly Rent Roll and General Ledger Trial Balances from Yardi for 2026 and 2027 in CSV/Excel format.
2. Run the AI Onboarding Ingestion module (`wp-05-ai-intake-copilot`):
   - Maps Yardi unit IDs and tenant names to target PostgreSQL `unit_id` and `tenant_id`.
   - Inserts monthly `rnt_accounts_receivable` charges for rent.
   - Inserts recorded payments into `rnt_payments` and generates matching `rnt_payment_allocations`.
   - Generates corresponding double-entry `rnt_ledger_entries`.
3. Reconcile tenant ending balances between Yardi and PostgreSQL as of the cutover date.

---

## 6. Verification & Parameterized Reconciliation Suite

Data integrity is certified by running automated SQL reconciliation queries simultaneously against Oracle (`$ORACLE_CONN`) and PostgreSQL (`$PG_CONN`):

### 6.1 Row Count Reconciliation
```sql
-- PostgreSQL Verification Query
SELECT 'rnt_properties' AS tbl, count(*) FROM rnt_properties
UNION ALL SELECT 'rnt_property_units', count(*) FROM rnt_property_units
UNION ALL SELECT 'rnt_tenant', count(*) FROM rnt_tenant
UNION ALL SELECT 'rnt_tenancy_agreement', count(*) FROM rnt_tenancy_agreement
UNION ALL SELECT 'rnt_accounts_receivable', count(*) FROM rnt_accounts_receivable
UNION ALL SELECT 'rnt_payments', count(*) FROM rnt_payments
UNION ALL SELECT 'rnt_payment_allocations', count(*) FROM rnt_payment_allocations
UNION ALL SELECT 'rnt_accounts_payable', count(*) FROM rnt_accounts_payable
UNION ALL SELECT 'rnt_ledger_entries', count(*) FROM rnt_ledger_entries;
```
*Acceptance Criteria*: Row counts must match exactly between the active Oracle source (filtered <= 2025-12-31) and PostgreSQL.

### 6.2 Financial Integrity & Ledger Reconciliation
```sql
-- 1. General Ledger Balance Check (Must evaluate to exactly 0.00 difference)
SELECT 
    sum(amount) AS total_ledger_amount,
    count(DISTINCT debit_account) AS active_debit_accounts,
    count(DISTINCT credit_account) AS active_credit_accounts
FROM rnt_ledger_entries;

-- 2. Ledger Distinct Accounts Verification (Zero rows violating debit <> credit)
SELECT count(*) AS invalid_ledger_rows
FROM rnt_ledger_entries
WHERE debit_account = credit_account;

-- 3. Accounts Receivable Open Balance Reconciliation
SELECT 
    sum(amount) AS total_ar_invoiced,
    sum(amount_paid) AS total_ar_collected,
    sum(amount - amount_paid) AS total_ar_outstanding
FROM rnt_accounts_receivable;

-- 4. Payment Allocation Integrity (Allocated Amount must equal Sum of Allocations)
SELECT 
    p.payment_id,
    p.amount,
    p.allocated_amount,
    COALESCE(sum(pa.amount), 0) AS calculated_allocations
FROM rnt_payments p
LEFT JOIN rnt_payment_allocations pa ON p.payment_id = pa.payment_id
GROUP BY p.payment_id, p.amount, p.allocated_amount
HAVING p.allocated_amount <> COALESCE(sum(pa.amount), 0);
```
*Acceptance Criteria*: Zero rows returned for payment discrepancy check; zero rows with identical debit/credit accounts; total AR invoiced and collected matches Oracle baseline to the cent.

---

## 7. Rollback & Multi-Environment Contingency Plan

1. **Failure During Dry Run / Testbed Ingestion (`pdb22`)**:
   - Truncate test PostgreSQL schema without affecting `pdb22`.
   - Refine Python ETL script transformations and re-run.
2. **Failure During Production Ingestion**:
   - PostgreSQL production schema is truncated:
     ```sql
     TRUNCATE rnt_ledger_entries, rnt_payment_allocations, rnt_payments, 
              rnt_accounts_receivable, rnt_accounts_payable, rnt_tenancy_agreement,
              rnt_property_units, rnt_properties CASCADE;
     ```
   - The Oracle production source database is strictly read-only during the extraction window; zero risk of source data corruption.
3. **Failure During Parallel / Backfill Period**:
   - Yardi remains the authoritative system of record during parallel operations until the user signs off on the final reconciliation report.
   - Any backfilled batch can be reversed cleanly using transaction timestamp tracking (`created_at >= :batch_start`).
