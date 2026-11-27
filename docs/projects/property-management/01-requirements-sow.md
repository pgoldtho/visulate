---
status: approved
phase: requirements
slug: property-management
project_type: modernization
source_db: pdb21 (production reference) / pdb22 (testbed)
source_schemas:
  - RNTMGR2
source_dialect: oracle
target_db: postgres
target_dialect: postgres
---

# Property Management — Requirements Specification

## Overview

- [Overview](#overview)
  - [Problem Description](#problem-description)
  - [Solution](#solution)
  - [Business Need](#business-need)
  - [Bug Reference](#bug-reference)
- [Requirements](#requirements)
  - [Functional Requirements](#functional-requirements)
    - [1. Customer Requirement](#1-customer-requirement)
    - [2. Use Cases](#2-use-cases)
    - [3. Functionality and Feature Description](#3-functionality-and-feature-description)
    - [4. Preconditions and Assumptions](#4-preconditions-and-assumptions)
    - [5. Limitations](#5-limitations)
    - [6. Dependencies and Impact Analysis](#6-dependencies-and-impact-analysis)
    - [7. Known issues](#7-known-issues)
  - [User Interface Requirements](#user-interface-requirements)
  - [Performance Requirements](#performance-requirements)
- [Design](#design)
  - [Data Model](#data-model)
    - [Schema Changes](#schema-changes)
    - [Seed Data](#seed-data)
    - [Data Upgrade](#data-upgrade)
  - [Code](#code)
    - [APIs](#apis)
    - [Non-API Code Changes](#non-api-code-changes)
  - [User Interface](#user-interface-1)
- [Test Plans](#test-plans)

### Problem Description
The legacy Visulate property management application couples operational rental management, county public records, corporate entity tracking, and real estate MLS listings into a single monolithic Oracle 19c database schema (`RNTMGR2`) and a procedural PHP 5 / Smarty codebase (`visulate`). 

#### Legacy Architectural Debt & Monolithic Coupling
The schema co-locates four distinct functional sub-systems under a single namespace:
1. **Property Management (`RNT_*`)**: Operational workflows for residential and commercial units, tenant leasing, invoicing (AR), bill payments (AP), and general ledger double-entry journals.
2. **Florida Public Records (`PR_*`, `SUNBIZ_*`)**: County parcel records, tax assessments, deed sales, and corporate filings (~15 GB+ across 44.2M tax records and 9.2M parcels in production).
3. **MLS RETS Feed Ingestion (`MLS_*`)**: Multiple Listing Service property listings, RETS XML ingest packages, and photo blobs (~3.1 GB archive).
4. **Database-Driven CMS / Wiki (`RNT_MENU_*`)**: Dynamic database-managed navigation menus, tabs, and page content rendered through procedural PHP scripts.

#### Dual-Environment Staging Context: Production Reference (`pdb21`) vs. Testbed (`pdb22`)
An exhaustive reevaluation of the Oracle environments revealed a fundamental distinction between the production database and the local development testbed:
- **`pdb21` (Full Production Environment Reference)**:
  - Contains the **complete, full-scale production dataset** across all sub-systems (147 tables, 2,428 columns, 270 indexes, 52 sequences, and only 3 invalid objects).
  - Houses the complete public records dataset: **9,210,182 properties** in `PR_PROPERTIES`, **44,209,094 tax assessment rows** in `PR_TAXES`, **8,116,437 deed sales** in `PR_PROPERTY_SALES`, and **2,075,597 archived MLS listings** in `MLS_LISTINGS_ARCHIVE`.
  - The total database segment footprint in `pdb21` exceeds **17 GB+** across all tablespaces.
  - Contains one internal Oracle system logging table exclusive to production: `DBTOOLS$MCP_LOG` (29 rows; internal Master Control Program log, out of scope).
- **`pdb22` (Historical Staging / Rehearsal Testbed)**:
  - Populated from a **partial database export/dump file that strictly contained only `RNT_*` operational tables**.
  - All public records (`PR_*`), MLS feeds (`MLS_*`), corporate registries (`SUNBIZ_*`), and demographic microdata tables in `pdb22` were empty (**0 rows**).
  - Contains three legacy auxiliary tables exclusive to `pdb22`: `RNT_COUNTY_DESCRIPTIONS` (67 rows), `RNT_MLS_COUNTY_PAGES` (19 rows), and `RNT_TAX_SOURCES` (22 rows). These tables were experimental CMS and county scraping metadata created on legacy branches, are absent from production `pdb21`, and are confirmed **OUT OF SCOPE**.

#### Critical Foreign Key Correlation & Spatial Extraction Impact
The fact that `pdb22` was loaded from an `RNT_*`-only dump had a critical impact on initial ETL discovery:
- In `RNT_PROPERTIES`, the column `PROP_ID` is a foreign key to `PR_PROPERTIES.PROP_ID`.
- `RNT_PROPERTIES` itself does **not** possess a native spatial geometry column; rather, parcel centroids and boundaries are maintained in `PR_PROPERTIES` (`GEO_LOCATION` and `GEO_COORDINATES` as Oracle `SDO_GEOMETRY`).
- When extraction queries executed in `pdb22` performed a `LEFT JOIN PR_PROPERTIES pr ON p.PROP_ID = pr.PROP_ID` to extract spatial Well-Known Text via `SDO_UTIL.TO_WKTGEOMETRY(COALESCE(pr.GEO_LOCATION, pr.GEO_COORDINATES))`, the join yielded `NULL` for every single property because `PR_PROPERTIES` had 0 rows.
- In the full production environment (`pdb21`), `PR_PROPERTIES` contains **9.2M rows**. Joining `RNT_PROPERTIES` against `PR_PROPERTIES` in `pdb21` successfully resolves the actual parcel geometries, allowing the ETL pipeline to populate PostGIS `geometry(Point, 4326)` coordinates with complete fidelity.

#### Measured Production Operational Baseline (`pdb21.RNTMGR2`)
Deterministic assessment of the operational `RNT_*` domain in production `pdb21` establishes the exact, verified data baseline:
- **Core Operational Tables**: 32 active domain tables.
- **Total Operational Records**: **~260,000 records** (segment size < 450 MB).
- **Key Table Volumes (Exact Production Counts)**:
  - `RNT_LEDGER_ENTRIES`: 97,660 rows (Double-entry journal records)
  - `RNT_PAYMENT_ALLOCATIONS`: 58,577 rows (Payment-to-charge reconciliation links)
  - `RNT_ACCOUNTS_PAYABLE`: 29,042 rows (Vendor bills and disbursements)
  - `RNT_PT_RULES`: 21,280 rows (General Ledger posting rules per business unit)
  - `RNT_PAYMENTS`: 17,420 rows (Tenant receipts and payments)
  - `RNT_ACCOUNTS_RECEIVABLE`: 10,108 rows (Incurred rent charges and fees)
  - `RNT_ACCOUNTS`: 8,059 rows (Chart of accounts across business units)
  - `RNT_ACCOUNT_BALANCES`: 7,950 rows (Deprecated physical cache; replaced by dynamic ANSI view)
  - `RNT_PROPERTY_EXPENSES`: 4,777 rows (Property expense events)
  - `RNT_BU_SUPPLIERS`: 1,776 rows (Supplier-to-business-unit assignments)
  - `RNT_PROPERTY_UNITS`: 1,528 rows (Rentable unit inventory)
  - `RNT_TENANT`: 964 rows (Active and historical tenant profiles)
  - `RNT_AGREEMENT_ACTIONS`: 961 rows (Lease contract actions and notices)
  - `RNT_TENANCY_AGREEMENT`: 883 rows (Lease contracts)
  - `RNT_SUPPLIERS_ALL`: 827 rows (Master contractor and supplier directory)
  - `RNT_PEOPLE_BU`: 809 rows (Person-to-business-unit assignments)
  - `RNT_PROPERTIES`: 768 rows (Active managed rental properties)
  - `RNT_PROPERTY_LINKS`: 648 rows (Property document and resource links)
  - `RNT_PEOPLE`: 610 rows (Contact and individual directory)
  - `RNT_PROPERTY_ESTIMATES`: 577 rows (Property valuation estimates)
  - `RNT_PROPERTY_PHOTOS`: 529 rows (Property photo metadata and files)
  - `RNT_PROPERTY_VALUE`: 392 rows (Historical valuation records)
  - `RNT_ACCOUNT_PERIODS`: 299 rows (Accounting periods across business units)
  - `RNT_USER_ASSIGNMENTS`: 290 rows (User role assignments)
  - `RNT_BUSINESS_UNITS`: 229 rows (Operational business units / owner portfolios)
  - `RNT_EXPENSE_ITEMS`: 162 rows (Itemized AP expense lines)
  - `RNT_USERS`: 106 rows (User login accounts)
  - Auxiliary Lookups: `RNT_DEFAULT_PT_RULES` (140), `RNT_LOOKUP_VALUES` (93), `RNT_DEFAULT_ACCOUNTS` (53), `RNT_PAYMENT_TYPES` (57), `RNT_ERROR_DESCRIPTION` (40), `RNT_LEADS` (38), `RNT_LOANS` (36), `RNT_SUPPLIER_TYPES` (20), `RNT_LEAD_ACTIONS` (17), `RNT_DOC_TEMPLATES` (15), `RNT_SECTION8_OFFICES_BU` (14), `RNT_USER_ROLES` (10), `RNT_SECTION8_OFFICES` (5).
- **External Geography Tables (Decoupled Reference Data)**:
  - `RNT_CITIES` (33,154 rows), `RNT_ZIPCODES` (41,754 rows), and `RNT_CITY_ZIPCODES` (41,754 rows) are external US geography reference datasets. In the modern architecture, PostGIS provides direct geospatial lookup, geocoding, and spatial containment, eliminating the need to maintain static geographic copies in the transactional property management schema.

#### Legacy Codebase Profile (`visulate` Repository)
- **Total Source Files**: 644 files (146,674 lines of code).
- **Primary Languages**: PHP (237 files, 61,486 lines), SQL/PLSQL (144 files, 49,714 lines), Smarty Templates (179 files, 17,290 lines).
- **Architecture**: Procedural PHP 5 scripts tightly coupled to direct OCI8 database connections, Oracle sequence `.NEXTVAL` idioms, and server-side Smarty rendering.

#### Historical Operational Cutoff & Coexistence
Due to security and maintenance hurdles with the legacy PHP 5 infrastructure, the organization migrated daily operational property management to Yardi Voyager at the beginning of 2026. However, business stakeholders strongly prefer the streamlined Visulate property management workflows and custom double-entry ledger capabilities. Historical data in Oracle is frozen and complete through **December 31, 2025**. The modernized Visulate application will operate in parallel with Yardi for a period of several months, using AI-assisted ingestion to backfill 2026–2027 transactions before executing a final operational cutover back to Visulate.

**Deterministic Discovery Baselines:**
- [codebase-inventory.md](./03-artifacts/codebase-inventory.md)
- [db-assessment-rntmgr2.md](./03-artifacts/db-assessment-rntmgr2.md)

---

### Solution
Extract the operational **Property Management** bounded context from the monolithic Oracle schema and procedural PHP codebase into an independent, modern, cloud-native web application backed by **PostgreSQL 16+ (with PostGIS)**, a modular API service layer (TypeScript or Python), and a responsive **Nuxt 3 / Vue 3 / Tailwind CSS / shadcn-vue** frontend. 

The target system enforces clean domain boundaries across 32 active operational tables, encapsulates accounting logic in a modern double-entry ledger engine, replaces static balance caches with dynamic SQL views (`v_account_period_balances`), streams historical data via a zero-dependency native Python ETL pipeline, and embeds purposeful multimodal AI helpers to dramatically reduce administrative manual workload.

```
               +-----------------------------------------------------+
               |                   MODERN CLIENT                     |
               |       Nuxt 3 / Vue 3 / Tailwind / shadcn-vue        |
               +--------------------------+--------------------------+
                                          |
                                          | HTTPS / REST / JSON
                                          v
+------------------------------------------------------------------------------------+
|                    PROPERTY MANAGEMENT MODERN SERVICE TIER                         |
|                                                                                    |
|  +---------------------+   +---------------------+   +--------------------------+  |
|  |  Properties & Units |   | Tenancy & Agreements|   | Accounting & Ledgers     |  |
|  |  Service Module     |   | Service Module      |   | Service Module           |  |
|  +---------------------+   +---------------------+   +--------------------------+  |
|                                                                                    |
|  +------------------------------------------------------------------------------+  |
|  |                              AI ASSISTANT ENGINE                             |  |
|  |  - Multimodal OCR / Intelligent Invoice & Bill Intake                        |  |
|  |  - Smart Payment Matching & FIFO Receivable Allocator                        |  |
|  |  - Conversational Natural Language Transaction Logger                        |  |
|  |  - Yardi Interim Statement & Rent Roll Backfill Ingestion (2026-2027)        |  |
|  +------------------------------------------------------------------------------+  |
+------------------------------------------------------------------------------------+
                                          |
                                          | PostgreSQL 16+ Pool (with PostGIS)
                                          v
               +-----------------------------------------------------+
               |              TARGET POSTGRESQL DATABASE             |
               |       32 Operational Tables (Strict FKs & Checks)   |
               |       Dynamic Dynamic Balances View (v_account_*)   |
               +-----------------------------------------------------+
```

#### Scope Boundaries: In-Scope vs. Out-of-Scope

| Functional Domain / Sub-System | In-Scope | Out-of-Scope | Modern Strategy / Technical Approach |
| :--- | :---: | :---: | :--- |
| **Operational Property Management (`RNT_*`)** | **YES** | | 32 operational tables migrated to PostgreSQL 16+ with strict types, UUIDs/identities, and triggers. |
| **General Ledger & Double-Entry Accounting** | **YES** | | Dynamic balance calculations (`v_account_period_balances`), balanced ledger entries, and FIFO payment allocations. |
| **Florida Public Records (`PR_*`, `SUNBIZ_*`)** | | **YES** | Excluded from property management bounded context (~15 GB in production). Loose references via `prop_id`. |
| **MLS Listings & RETS Feeds (`MLS_*`)** | | **YES** | Excluded from property management bounded context (~3.1 GB archive). |
| **Dynamic CMS & Menus (`RNT_MENUS*`, `RNT_*_PAGES`)** | | **YES** | Legacy database-managed navigation retired; replaced with client-side Vue Router routes. |
| **Staging-Only Metadata (`RNT_COUNTY_DESCRIPTIONS`, etc.)** | | **YES** | Auxiliary scraping tables unique to `pdb22` staging are retired. |
| **External Geographic Copies (`RNT_CITIES`, `RNT_ZIPCODES`)** | | **YES** | Static copies retired in favor of native PostGIS spatial functions and external address lookups. |
| **Multimodal AI Intake & Copilot** | **YES** | | OCR bill intake, smart payment matching, and natural language quick logging. |
| **Yardi Parallel Period Ingest (2026–2027)** | **YES** | | Automated AI ingestion tool to backfill Yardi operational activity before final cutover. |

---

### Business Need
1. **Eliminate Legacy Infrastructure Vulnerabilities**: PHP 5 and unsupported OCI8 extensions present acute security liabilities and lack vendor support.
2. **Mitigate Single-Point-of-Failure Overhead**: Running public records aggregation, MLS feed crawlers, and financial ledgers in a single Oracle instance creates severe database contention and exorbitant cloud licensing costs.
3. **Regain Operational Velocity**: Replace 179 cumbersome Smarty templates with a modern Vue 3 / Nuxt 3 single-page dashboard designed for high developer productivity and rapid feature iterations.
4. **Drastic Administrative Automation**: Automate repetitive monthly leasing, payment allocation, and contractor invoice processing through purpose-built AI helpers.

---

### Bug Reference
- **VIS-MIG-001**: Monolithic schema coupling between `RNT_*` operational tables and `PR_*` public record tables.
- **VIS-MIG-002**: Invalid materialized views (`RNT_TENANCY_AGREEMENT_V`, `RNT_PROP_SUMMARY_MV`) and PL/SQL package dependencies on deprecated Oracle network packages.
- **VIS-MIG-003**: Insecure plaintext credential fallbacks and MD5 password hashing in legacy connection layers.
- **VIS-MIG-004**: Credit-only account dropout bug in legacy account balance aggregation joins (remediated via unified CTE in `v_account_period_balances`).
- **VIS-MIG-005**: Null spatial geometry extraction in staging testbed (`pdb22`) due to missing `PR_PROPERTIES` data (remediated by referencing production `pdb21` with 9.2M parcel records and standardizing extraction to `COALESCE(pr.GEO_LOCATION, pr.GEO_COORDINATES)`).
- **VIS-MIG-006**: SQL injection vulnerability via string interpolation of `date_cutoff` in migration ETL scripts (remediated via parameterized bind variables `:date_cutoff` and `%s`).
- **VIS-MIG-007**: Silent historical accounts receivable record loss due to non-nullable `agreement_id` constraint and restrictive ETL filters (remediated by making `agreement_id` nullable, adding `business_id` and `tenant_id`, and removing the filter).

---

## Requirements

### Functional Requirements

#### 1. Customer Requirement
The modernized system must provide 100% operational feature parity with the legacy Visulate Property Management application while offering an intuitive, high-performance web experience. Key stakeholder requirements include:
- Complete portfolio visibility across business units, properties, and rental units.
- End-to-end leasing workflows: applicant lead capture, lease contract lifecycle, tenant communications, and Section 8 voucher tracking.
- Strict double-entry general ledger accounting compliant with standard GAAP chart-of-accounts conventions.
- Automated receivable aging, invoice generation, payment allocation (FIFO), and payable expense disbursement.
- Zero data loss and verified mathematical reconciliation of all historical transactions through December 31, 2025 across all ~260,000 operational records.
- Seamless coexistence with Yardi Voyager during the parallel-run transition, supported by automated ingestion of 2026–2027 interim activity.

#### 2. Use Cases

##### Use Case 1: Tenant Lease Onboarding & Rent Charge Generation
1. **Actor**: Property Manager
2. **Workflow**:
   1. Property Manager selects a vacant property unit and initiates "New Lease Agreement".
   2. Property Manager selects or creates a Tenant record (person details, SSN/tax ID, contact info).
   3. Property Manager specifies lease parameters: agreement date, start date, end date, monthly rent amount, security deposit amount, and payment frequency.
   4. System validates dates and creates the `rnt_tenancy_agreement` record.
   5. System automatically generates initial Accounts Receivable invoice items for first month rent and security deposit.
   6. System posts corresponding debit/credit entries to the General Ledger according to default posting rules (e.g., DR 1200 Accounts Receivable / CR 4100 Rental Revenue).
   7. Property Manager verifies generated lease schedule and confirms unit status transitions from "Vacant" to "Occupied".

##### Use Case 2a: Payment Record Generation
1. **Actor**: Property Manager / Bookkeeper
2. **Workflow**:
   1. Bookkeeper navigates to the Receivables screen at the beginning of the month and clicks on the update invoices button.
   2. System reviews existing tenancy agreements and creates records for rents to be collected.

##### Use Case 2b: Tenant Payment Receipt & FIFO Accounts Receivable Allocation
1. **Actor**: Property Manager / Bookkeeper
2. **Workflow**:
   1. Bookkeeper navigates to the Receivables screen and logs an incoming payment ($1,450.00 via Zelle/Check) linked to a Tenant/Tenancy Agreement.
   2. System records the `rnt_payments` entry with payment date, payment type, reference number, and amount.
   3. System queries open `rnt_accounts_receivable` items for the agreement ordered by due date ascending (FIFO).
   4. System automatically suggests allocations matching the payment amount against outstanding invoices (e.g. $1,400.00 rent + $50.00 late fee). It also allows partial payments to be applied to an invoice.
   5. Bookkeeper reviews and confirms allocations; system writes `rnt_payment_allocations` records.
   6. System automatically executes balance reconciliation: updates `amount_paid` on each invoice, transitions fully satisfied items to `status = 'PAID'` (or `PARTIAL`), and updates payment status.
   7. System posts matching journal entries (DR 1110 Operating Cash / CR 1200 Accounts Receivable).

##### Use Case 3: Supplier Bill Ingestion & Accounts Payable Disbursement
1. **Actor**: Property Manager / Bookkeeper
2. **Workflow**:
   1. User uploads a PDF or photographed vendor bill (e.g., plumbing repair invoice for $350.00).
   2. AI Multimodal Intake parses supplier name, invoice number, due date, property/unit, and line item amounts.
   3. System displays side-by-side draft verification modal. User reviews pre-populated fields and clicks "Confirm Bill".
   4. System records `rnt_accounts_payable` and `rnt_expense_items` linked to the designated `rnt_suppliers_all` vendor and property.
   5. System posts unbilled AP journal entries (DR 5200 Repairs & Maintenance / CR 2100 Accounts Payable).
   6. When payment is disbursed (check/ach), user marks bill as paid; system updates AP record and posts disbursement journal (DR 2100 Accounts Payable / CR 1110 Operating Cash).

##### Use Case 4: General Ledger Double-Entry Period Closing & Trial Balance Reporting
1. **Actor**: Property Manager / Bookkeeper
2. **Workflow**:
   1. Accountant selects accounting period (e.g. December 2025) and initiates Trial Balance review.
   2. System queries dynamic ANSI view `v_account_period_balances`.
   3. The view computes debit and credit sums through a unified `UNION ALL` CTE, ensuring liability, equity, revenue, and asset accounts accurately reflect activity regardless of debit/credit exclusivity.
   4. System calculates cumulative net balance: `opening_balance + total_debit - total_credit` (or inverted for credit-normal accounts).
   5. System verifies the fundamental accounting equation: `SUM(Debits) - SUM(Credits) = 0.00`.
   6. Accountant reviews balance sheet and income statement exports with zero discrepancy.

##### Use Case 5: AI Multimodal Invoice Intake & Draft Verification
1. **Actor**: Property Manager
2. **Workflow**:
   1. User drags and drops a batch of supplier bills (PDF/JPEG) into the intake dropzone.
   2. Service invokes multimodal LLM extraction pipeline with structured JSON schema.
   3. System extracts supplier name, tax ID, invoice date, due date, line items, amounts, and detected property address.
   4. System fuzzy-matches extracted vendor name against `rnt_suppliers_all` and address against `rnt_properties`.
   5. User reviews matched records with visual confidence score badges.
   6. User clicks "Approve Batch" to generate transactional AP bills and GL ledger journals in a single atomic database transaction.

##### Use Case 6: AI Chat-to-Transaction Payment Logging
1. **Actor**: Property Manager on Mobile
2. **Workflow**:
   1. Property Manager types natural language prompt into the conversational assistant: *"Daryl Terrace paid their $1,250 rent for November on the 23rd via Zelle."*
   2. Assistant resolves contextual entity: identifies property at "2354 Daryl Terrace", retrieves active tenancy agreement for tenant, and identifies November rent charge ($1,250.00).
   3. Assistant presents confirmation card: *"Record $1,250.00 Zelle payment on Nov 23, 2026 for Agreement #402 (Tenant: John Doe)? Allocation: $1,250.00 to Nov Rent (AR #10842)."*
   4. Manager taps "Confirm".
   5. System executes payment transaction, allocates receivable, reconciles balance, and returns real-time statement summary.

##### Use Case 7: AI-Assisted Yardi Interim Data Ingestion & Backfill (2026–2027)
1. **Actor**: Systems Administrator 
2. **Workflow**:
   1. Administrator exports monthly Yardi Voyager rent rolls, tenant ledgers, and expense reports (CSV/Excel/PDF) for 2026 through 2027.
   2. Administrator uploads reports to the Yardi Onboarding Ingest tool.
   3. AI parser extracts historical lease renewals, rental charge schedules, payments collected, and maintenance disbursements.
   4. Parser maps Yardi tenant IDs and property codes to Visulate `rnt_properties` and `rnt_tenant` records.
   5. System performs automated reconciliation dry-run, highlighting any unmatched tenant records or discrepancy amounts.
   6. Administrator confirms import; system writes backfill records into `rnt_accounts_receivable`, `rnt_payments`, `rnt_payment_allocations`, and `rnt_ledger_entries`.

##### Use Case 8: Natural language queries
1. **Actor**: Property Manager
2. **Workflow**:
   1. Property Manager types natural language prompt into the conversational assistant example: *"How old is that AC at Daryl Terrace"*
   2. Assistant resolves contextual entity: identifies property at "2354 Daryl Terrace" and the intent: investigate maintenance records to find Air Conditioning references (e.g. AC, outside unit, air handler ... etc).
   3. Assistant makes an API call or assembles a SQL query to find the requested information.
   4. Assistant formats and presents the result.

---

#### 3. Functionality and Feature Description

##### Current behavior
- Monolithic schema coupling `RNT_*`, `PR_*`, and `MLS_*` tables in `RNTMGR2`.
- Direct procedural PHP 5 scripts calling Oracle via `oci_parse()` and `oci_execute()`.
- Server-side rendering using 179 Smarty template files and dynamic menu tables (`RNT_MENUS`).
- Accounting balance inquiries rely on a physical, denormalized balance cache table (`RNT_ACCOUNT_BALANCES`) populated by complex PL/SQL triggers, leading to synchronization drift.
- Synchronous outbound network requests (`UTL_HTTP`) and email dispatch (`UTL_SMTP`) executing inside database transactions.
- Security constraints rely on legacy DES/MD5 password hashes and unencrypted SSN fields.

##### New functionality
- Standalone PostgreSQL 16+ database schema encompassing 32 active operational tables with zero foreign key ties to public records.
- Modern TypeScript/Python domain service architecture providing structured, validated REST APIs with OpenAPI documentation.
- Modern Nuxt 3 / Vue 3 / Tailwind CSS / shadcn-vue frontend with client-side reactive routing and role-based views.
- Dynamic double-entry accounting view `v_account_period_balances` replacing `RNT_ACCOUNT_BALANCES`, utilizing a unified `UNION ALL` CTE that preserves credit-only accounts without null-join dropouts.
- Automated post-ETL status and payment allocation reconciliation via `reconcile_post_etl_balances()`.
- PostGIS `geometry(Point, 4326)` spatial point mapping with automated Well-Known Text (WKT) transformation from production `PR_PROPERTIES` via `COALESCE(pr.GEO_LOCATION, pr.GEO_COORDINATES)`.
- Asynchronous email and background notification queue replacing database PL/SQL network calls.
- Pure Python streaming ETL pipeline (`python-oracledb` thin mode + `psycopg3` direct memory COPY) with dynamic sequence synchronization (`tools/migration/reset-sequences.sql`).
- Modernized security: bcrypt/Argon2 password hashing with `requires_password_reset = true` flag for migrated accounts, and column-level encryption (`pgcrypto`) for sensitive PII (SSN/Tax ID).

##### Accounting Business Rules & Posting Rules Matrix

| Rule Code | Rule Description | Debit Account Type / Default Account | Credit Account Type / Default Account | Financial Impact |
| :--- | :--- | :--- | :--- | :--- |
| **ARS** | Accounts Receivable Scheduled (Rent Invoicing) | Accounts Receivable (`1200`) | Rental Revenue (`4100`) | Increases AR, increases revenue |
| **ARP** | Accounts Receivable Payment (Tenant Rent Payment) | Operating Bank Account (`1110`) | Accounts Receivable (`1200`) | Increases cash, decreases AR |
| **APS** | Accounts Payable Scheduled (Vendor Bill Invoiced) | Expense Account (e.g. Repairs `5200`) | Accounts Payable (`2100`) | Increases expense, increases AP |
| **APP** | Accounts Payable Payment (Disbursement to Vendor) | Accounts Payable (`2100`) | Operating Bank Account (`1110`) | Decreases AP, decreases cash |
| **DEP** | Security Deposit Received | Escrow Bank Account (`1120`) | Tenant Security Deposits Liability (`2200`) | Increases escrow cash, increases liability |
| **DPR** | Security Deposit Refund | Tenant Security Deposits Liability (`2200`) | Escrow Bank Account (`1120`) | Decreases liability, decreases escrow cash |

##### Payment Allocation & Reconciliation Rules Matrix

| Payment vs. Invoiced Amount | Status Assigned (`rnt_accounts_receivable`) | Status Assigned (`rnt_payments`) | Allocation Logic |
| :--- | :--- | :--- | :--- |
| `amount_paid == 0.00` | `OPEN` | `UNALLOCATED` | Zero allocation recorded. Incurred charge remains open. |
| `0.00 < amount_paid < amount` | `PARTIAL` | `PARTIAL` | Oldest open AR invoice partially satisfied; remainder remains `OPEN`. |
| `amount_paid == amount` | `PAID` | `ALLOCATED` | Invoice fully satisfied; balance closed out to 0.00. |
| `amount_paid > amount` (Overpayment) | `PAID` | `OVERALLOCATED` / `CREDIT` | Invoice marked `PAID`; excess unallocated amount credited to tenant deposit/advance rent. |

##### Role-Based Access Control (RBAC) Matrix

| User Role | Properties & Units | Tenancy & Leases | AR Invoicing & Payments | AP Bills & Disbursements | General Ledger & Period Close | AI Helpers & OCR Intake |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **Administrator** | Full Access | Full Access | Full Access | Full Access | Full Access | Full Access |
| **Property Manager** | View / Edit | View / Edit / Create | View / Log Payment | View / Create Bill | View Reports | Full Access |
| **Bookkeeper / Accountant** | View Only | View Only | Full Access | Full Access | Full Access | Verify & Post |
| **Maintenance Contractor** | View Assigned | None | None | Submit Bill / View Status | None | Upload Bill |
| **Tenant** | View Leased Unit | View Own Lease | Pay Online / View AR | None | None | Chat Assistant |

##### New concepts
- **Business Unit (`rnt_business_units`)**: Multi-tenant or corporate entity partition isolating properties, accounts, and bank ledgers.
- **Dynamic Double-Entry Balance**: Virtual calculation of account balances derived dynamically from journal line items using `v_account_period_balances` instead of physical table triggers.
- **FIFO Allocation Engine**: First-In, First-Out reconciliation engine that attributes incoming payments to the oldest outstanding rent charges.
- **Multimodal AI Intake Draft**: Staging state for vendor bills, leases, or Yardi report records where AI-extracted fields are held for one-click human verification prior to transactional commit.
- **PostGIS EWKT (SRID 4326)**: Extended Well-Known Text coordinate standard used to represent latitude and longitude points in PostgreSQL.

##### User Interface
- Modern, clean, responsive dashboard built with **Nuxt 3 / Vue 3 / Tailwind CSS / shadcn-vue**.
- Componentized views: Portfolio Explorer (Properties/Units), Tenancy Management (Leases/Rent Rolls), Financials Hub (AR Aging, AP Disbursements, GL Trial Balance), and AI Command Center.
- Contextual modal drawers for quick actions (Log Payment, Create Lease, Upload Bill).
- Conversational transaction interface integrated as an omnipresent command bar (`Cmd+K`).

---

#### 4. Preconditions and Assumptions
1. **Multi-Environment Separation**:
   - `pdb21` is the full production environment reference containing complete public records and operational data.
   - `pdb22` serves as the isolated rehearsal testbed containing the `RNT_*` dump.
   - All tools, connection profiles, and automation scripts must be parameterized and read configuration from environment variables.
2. **Zero Client Footprint ETL Architecture**:
   - Extraction and streaming to PostgreSQL must use pure Python (`python-oracledb` thin mode + `psycopg3` direct memory COPY).
   - Zero installation of proprietary Oracle Instant Client libraries, C compilers, or Perl modules (Ora2Pg).
3. **Subsystem Boundary Decoupling**:
   - The Property Management domain operates autonomously without hard foreign keys to `PR_*` or `MLS_*` tables.
   - Any external parcel references are retained as optional integer identifiers (`prop_id`).
4. **Spatial Geometry Resolution**:
   - Production spatial coordinates for `rnt_properties` are extracted by joining `RNT_PROPERTIES.PROP_ID` to `PR_PROPERTIES.PROP_ID` in `pdb21` via `SDO_UTIL.TO_WKTGEOMETRY(COALESCE(pr.GEO_LOCATION, pr.GEO_COORDINATES))`.
5. **Historical Cutoff & Coexistence Window**:
   - Legacy Oracle data is frozen as of December 31, 2025.
   - Target application operates in parallel with Yardi Voyager during a multi-month transition.
   - Interim transactions (2026–2027) will be backfilled via the AI Yardi ingestion module.
6. **PII & Credential Modernization**:
   - Sensitive tax IDs (`ssn`) will be protected using `pgcrypto` column-level encryption or secure masking.
   - Legacy password hashes are marked with `requires_password_reset = true` to force bcrypt password reset upon first modern login.

---

#### 5. Limitations
1. **Public Records & MLS Exclusions**: Public county records (9.2M in `PR_PROPERTIES`, 44.2M in `PR_TAXES`), corporate registries (`SUNBIZ_*`), and RETS MLS ingestion pipelines are strictly excluded from the property management database and application.
2. **Read-Only Historical Source**: The source Oracle database will be treated as read-only during migration dry runs and cutover; no write-backs or dual-writes to Oracle will be performed.
3. **Legacy CMS Deprecation**: Oracle tables managing menus and tabs (`RNT_MENUS`, `RNT_MENU_PAGES`) as well as staging-only CMS tables (`RNT_COUNTY_DESCRIPTIONS`, `RNT_MLS_COUNTY_PAGES`, `RNT_TAX_SOURCES`) are retired; client navigation is handled entirely via Vue 3 client-side routing.
4. **Binary Photo Transition**: Existing binary images in `RNT_PROPERTY_PHOTOS` are temporarily migrated into PostgreSQL `bytea` columns with an architectural transition path to AWS S3 / Cloudflare R2 object storage URLs.

---

#### 6. Dependencies and Impact Analysis
- **Database Extensions**: PostgreSQL 16+ requires `postgis`, `pgcrypto`, and `uuid-ossp` extensions enabled.
- **Python Runtime**: Python 3.11+ runtime for migration tooling with dependencies `python-oracledb>=2.0.0`, `psycopg[binary]>=3.1.0`, and `python-dotenv>=1.0.0`.
- **Node.js Runtime**: Node.js 20+ LTS runtime for Nuxt 3 web frontend and TypeScript API services.
- **External Email & Storage Services**: Outbound emails transition from Oracle `UTL_SMTP` to modern transactional SMTP/API providers (e.g., SendGrid, AWS SES).
- **Public Records Decoupling**: Property records decouple from `PR_PROPERTIES`; search features query PostGIS coordinates rather than county GIS tables.

---

#### 7. Known issues
- **Remediated Blocker: Dynamic Balances View Credit Dropout**: Previously, months with only credit activity (common in Liability, Equity, and Revenue accounts) dropped out due to null left joins. Resolved via a unified `UNION ALL` CTE in `v_account_period_balances`.
- **Remediated Blocker: Historical AR/AP Delinquency Distortion**: Bulk streaming initially loaded open statuses with zero amounts paid. Resolved via automated post-ETL reconciliation function `reconcile_post_etl_balances()`.
- **Remediated Blocker: PostGIS EWKT SRID 4326 Mismatch**: SDO WKT lacked SRID prefixes, causing PostGIS COPY errors. Resolved by prepending `'SRID=4326;' ||`.
- **Remediated Issue: Missing Coordinate Extraction in Staging (`pdb22`)**: Staging dump lacked `PR_*` records, causing spatial extraction joins to return NULL. Resolved by confirming `pdb21` as the production reference with 9.2M `PR_PROPERTIES` records and standardizing extraction to `COALESCE(pr.GEO_LOCATION, pr.GEO_COORDINATES)`.
- **Remediated Vulnerability: SQL Injection via date_cutoff**: Parameterized with bind variables `:date_cutoff` in Oracle extraction queries and `%s` in post-ETL PostgreSQL reconciliation.
- **Remediated Security: Legacy Password Upgrade Enforcement**: In `001_initial_schema.sql` and `etl_pipeline.py`, added `requires_password_reset = true` on imported accounts to force modern credential upgrade upon initial login.
- **Remediated Issue: Historical AR Record Loss & Schema Alignment**: In `001_initial_schema.sql`, made `rnt_accounts_receivable.agreement_id` nullable, ensured `business_id` and `tenant_id` are populated, and eliminated the restrictive agreement ID filter in `etl_pipeline.py`.
- **Remediated Contract: rnt_pt_rules Alignment**: Aligned design documents and service layer to query `rnt_pt_rules` with `business_id`, `payment_type_id`, `transaction_type`, `debit_account`, and `credit_account`.
- **Remediated Constraint: Ledger Accounts Distinct Constraint**: Added `CONSTRAINT rnt_ledger_distinct_accounts CHECK (debit_account <> credit_account)` to `001_initial_schema.sql`.
- **Remediated Parity: View Definitions Alignment**: Aligned `v_ar_aging` and `v_active_tenancy_agreements` in `01-core-schema-tdd.md` with `002_views.sql` to include `business_id`.
- **Open Item: Production Endpoint Credentials**: Network peering, hostnames, and credentials for the production Oracle database endpoint (`pdb21`) must be configured in production CI/CD before cutover rehearsal.
- **Open Item: S3 Bucket Provisioning**: Cloud object storage bucket must be provisioned for high-resolution property photo offloading.

---

### User Interface Requirements
1. **Design System & Aesthetics**: Nuxt 3 / Vue 3 styled with Tailwind CSS and `shadcn-vue` component primitives, adhering to clean, accessible modern enterprise dashboard standards.
2. **Responsive Layout**: Fluid design supporting desktop workstations, tablets, and mobile devices (mobile view optimized for field property managers logging payments and maintenance).
3. **Key Functional Screens**:
   - **Dashboard**: High-level portfolio metrics (Occupancy rate, total collections this month, delinquent AR balance, pending AP bills).
   - **Property Portfolio Explorer**: Searchable, filterable list and map view (PostGIS points) of properties and units with rental rates, square footage, and amenities.
   - **Tenancy Hub**: Lease agreement explorer, active tenant roster, upcoming renewals, and Section 8 voucher tracking.
   - **Financials / Billing**:
     - Accounts Receivable aging breakdown (30/60/90+ days), tenant statements, and payment entry modal with auto-FIFO allocation preview.
     - Accounts Payable bill inbox with approval status, expense categorization, and contractor check/disbursement generator.
     - General Ledger Trial Balance and period closing review screen powered by `v_account_period_balances`.
   - **AI Document Intake**: Drag-and-drop receipt/bill intake center featuring side-by-side PDF preview and extracted field verification.
   - **Conversational Command Bar**: Omnipresent quick-action assistant (`Cmd+K`) supporting natural language payment logging and inquiries.
4. **Accessibility & Compliance**: Strict adherence to WCAG 2.1 AA contrast ratios, screen reader semantics, and keyboard-first navigation shortcuts.

---

### Performance Requirements
- **Downtime Tolerance / Cutover Window**: Target operational migration duration < 30 minutes; zero downtime for end users due to the ongoing parallel operation with Yardi.
- **RPO / RTO Targets**:
  - **RPO (Recovery Point Objective)**: 0 hours (historical operational data frozen through December 31, 2025; 2026–2027 transactions backfilled via verified AI intake).
  - **RTO (Recovery Time Objective)**: < 2 hours for complete end-to-end extraction, loading, sequence synchronization, and financial reconciliation.
- **Measured Production Operational Volumes (from `pdb21` Baseline)**:
  - Source Monolithic Footprint: 147 tables, >17 GB total segment size.
  - In-Scope Operational Property Management: 32 active operational tables, **~260,000 records** (< 450 MB total data segment size).
- **Streaming ETL Throughput**:
  - Direct memory `psycopg3` COPY streaming achieves **15,000 to 30,000 rows/second**, streaming the entire operational dataset (~260k rows) in 15 to 25 seconds.
- **API & Query Latency Targets**:
  - Standard REST API p95 response time: < 100ms.
  - Complex GL Trial Balance query execution (`v_account_period_balances`): < 150ms.
  - Full-text search and spatial proximity search (PostGIS GiST): < 50ms.

---

## Design

**Referenced Technical Design Documents:**
- [Technical Design Document: Core Schema & Entity Model](./02-designs/01-core-schema-tdd.md)
- [Technical Design Document: Application Services, PL/SQL Disposition & AI Helpers](./02-designs/02-application-services-tdd.md)
- [Data Migration & Cutover Plan: Oracle to PostgreSQL](./02-designs/data-migration-plan.md)
- [Self-Contained AI-Executable Implementation Plan](./02-designs/implementation-plan.md)
- [Work Package 01 Spec: Target PostgreSQL Schema & Migration Scripts](./02-designs/work-packages/wp-01-schema.md)
- [Work Package 02 Spec: Native Python Data Extraction & Streaming ETL Pipeline](./02-designs/work-packages/wp-02-data-migration.md)
- [Work Package 03 Spec: Core Property, Tenancy & Contact Backend Services](./02-designs/work-packages/wp-03-backend-domain-services.md)
- [Work Package 04 Spec: General Ledger, Billing & Double-Entry Accounting Service](./02-designs/work-packages/wp-04-accounting-ledger-engine.md)
- [Work Package 05 Spec: Document OCR, Smart Payment Allocation & Natural Language Copilot](./02-designs/work-packages/wp-05-ai-intake-copilot.md)
- [Work Package 06 Spec: Responsive Nuxt 3 / Vue 3 / shadcn-vue UI & Dashboard](./02-designs/work-packages/wp-06-web-frontend.md)
- [Work Package 07 Spec: End-to-End Financial Integrity & Data Reconciliation Suite](./02-designs/work-packages/wp-07-verification-reconciliation.md)

---

### Data Model

#### Schema Changes
The operational target schema on PostgreSQL 16+ establishes 32 cleanly decoupled operational tables grouped into four functional domains, completely eliminating foreign key ties to `PR_*` and `MLS_*` tables:
1. **Business Units & Security**: `rnt_business_units`, `rnt_users` (with `requires_password_reset`), `rnt_user_roles`, `rnt_user_assignments`, `rnt_people`, `rnt_people_bu`.
2. **Properties & Units**: `rnt_properties` (with PostGIS `geometry(Point, 4326)`), `rnt_property_units`, `rnt_property_value`, `rnt_property_photos`, `rnt_property_expenses`.
3. **Tenancy & Leasing**: `rnt_tenant`, `rnt_tenancy_agreement`, `rnt_agreement_actions`, `rnt_leads`, `rnt_lead_actions`, `rnt_doc_templates`, `rnt_section8_offices`, `rnt_section8_offices_bu`.
4. **Accounting & Ledgers**: `rnt_accounts`, `rnt_account_periods`, `rnt_payment_types`, `rnt_pt_rules` (keyed by `business_id`, `payment_type_id`, and `transaction_type`), `rnt_accounts_receivable` (with `business_id`, `tenant_id`, and nullable `agreement_id`), `rnt_payments`, `rnt_payment_allocations`, `rnt_accounts_payable`, `rnt_expense_items`, `rnt_suppliers_all`, `rnt_bu_suppliers`, `rnt_ledger_entries` (enforcing distinct debit/credit accounts), `rnt_loans`.

All tables include `created_at` and `updated_at` timestamps managed via automated trigger `set_updated_at()` for optimistic concurrency. Primary keys utilize standard 64-bit integer identities (`BIGINT GENERATED BY DEFAULT AS IDENTITY`).

The legacy static table `RNT_ACCOUNT_BALANCES` is replaced by the dynamic ANSI view `v_account_period_balances` defined in `packages/database/migrations/002_views.sql`, featuring a unified `UNION ALL` CTE that correctly balances Asset, Liability, Equity, Revenue, and Expense accounts.

*For complete table DDL listings and column definitions, see [Technical Design Document: Core Schema & Entity Model](./02-designs/01-core-schema-tdd.md) and [Work Package 01 Spec](./02-designs/work-packages/wp-01-schema.md).*

#### Seed Data
Pre-configured JSON fixtures are provided in `packages/database/seeds/` to ensure immediate operational readiness:
- `default_accounts.json`: Standard Chart of Accounts containing 39 accounts across Asset (`1100`-`1200`), Liability (`2100`-`2200`), Equity (`3100`), Revenue (`4100`-`4200`), and Expense (`5100`-`6800`) categories.
- `default_pt_rules.json`: Complete posting rule matrix defining debit/credit accounts for all transaction types (`ARS`, `ARP`, `APS`, `APP`, `DEP`, `DPR`).
- `payment_types.json`: Payment type lookup definitions, depreciation schedules, and Net Operating Income (NOI) calculation flags.

*For fixture formats and seeding scripts, see `packages/database/src/seed.ts` and [Work Package 01 Spec](./02-designs/work-packages/wp-01-schema.md).*

#### Data Upgrade
Historical data is migrated using a high-performance native Python streaming ETL pipeline (`tools/migration/etl_pipeline.py`):
1. **5-Tier Topological Streaming**: Tables are extracted from Oracle and loaded into PostgreSQL in strict dependency order (Tier 1: Foundations & Lookups -> Tier 2: Properties & Units -> Tier 3: Tenancies & Payables -> Tier 4: Receivables & Payments -> Tier 5: Ledger Entries & Allocations).
2. **Zero-Disk In-Memory COPY**: Streams records directly from `python-oracledb` cursors into `psycopg3` memory buffers (`io.StringIO`), piping into PostgreSQL `COPY FROM STDIN` with zero intermediate disk staging.
3. **Session Replication Role**: Bulk streaming temporarily disables constraint triggers (`SET session_replication_role = 'replica'`) and resets to `'origin'` upon completion.
4. **Sequence Resynchronization**: `tools/migration/reset-sequences.sql` dynamically advances all identity sequences to `COALESCE(MAX(pk), 0) + 1` across all tables.
5. **Post-ETL Balance & Status Reconciliation**: Executes `reconcile_post_etl_balances()` to calculate `amount_paid`, assign `PAID`/`PARTIAL`/`OPEN` statuses, and sync allocation links.

*For end-to-end extraction scripts, memory buffers, and runbooks, see [Data Migration & Cutover Plan](./02-designs/data-migration-plan.md) and [Work Package 02 Spec](./02-designs/work-packages/wp-02-data-migration.md).*

---

### Code

#### APIs
The application backend replaces legacy procedural PHP scripts with modular TypeScript or Python domain services exposing RESTful endpoints:
- **Property Management Service**: Endpoints for properties, units, valuation logs, and PostGIS proximity queries (`/api/v1/properties`, `/api/v1/properties/:id/units`).
- **Tenancy & Leasing Service**: Endpoints for tenant onboarding, lease lifecycle, renewal actions, and Section 8 housing vouchers (`/api/v1/tenancies`, `/api/v1/tenants`).
- **Billing & Accounting Engine**: Endpoints for Accounts Receivable invoicing, payment logging, automated FIFO allocation, Accounts Payable bills, and period closing trial balance reports (`/api/v1/accounting/ar`, `/api/v1/accounting/payments`, `/api/v1/accounting/trial-balance`).
- **AI Copilot & Intake Service**: Endpoints for document OCR parsing, bank statement matching, conversational intent processing, and Yardi report ingestion (`/api/v1/ai/ocr-intake`, `/api/v1/ai/chat-transaction`).

*For API signatures, OpenAPI contracts, and auth schemas, see [Technical Design Document: Application Services](./02-designs/02-application-services-tdd.md).*

#### Non-API Code Changes

##### PL/SQL Package Disposition Strategy
The 148 legacy PL/SQL packages/bodies in `RNTMGR2` are systematically refactored or retired:

| Legacy PL/SQL Package | Lines of Code | Target Disposition | Rationale & Modern Implementation |
| :--- | ---: | :--- | :--- |
| `RNT_LEDGER_PKG` | 1,240 | **Move to Application Service** | Complex double-entry validation, journal posting, and amount lookups refactored into TypeScript Accounting Service (`wp-04`). |
| `RNT_ACCOUNTS_RECEIVABLE_PKG` | 890 | **Move to Application Service** | Rent invoicing, payment allocation, and aging logic moved to API service with explicit database transactions (`wp-04`). |
| `RNT_ACCOUNTS_PAYABLE_PKG` | 740 | **Move to Application Service** | Vendor bill management and payment disbursements implemented in TypeScript AP domain service (`wp-04`). |
| `RNT_USER_MAIL_PKG` | 310 | **Move to Background Worker** | Synchronous Oracle `UTL_SMTP` calls retired in favor of asynchronous BullMQ/Celery worker with SendGrid/SES. |
| `RNT_SUMMARY_PKG` / `RNT_ACCOUNT_BALANCES_PKG` | 1,450 | **Replace with SQL ANSI View** | Physical balance cache retired; replaced with high-speed dynamic SQL view `v_account_period_balances`. |
| `MLS_*_PKG` / `PR_RETS_PKG` | 8,600 | **Retire from Scope** | MLS RETS ingestion feeds excluded from the Property Management bounded context. |
| Auto-generated CRUD packages (50+) | ~11,000 | **Retire** | Replaced with modern ORM/query builder (e.g., Prisma, Kysely, or Drizzle) in TypeScript service layer. |

##### Work Breakdown Structure (Work Packages)
The project is organized into seven modular, AI-executable work packages:
- **[wp-01-schema](./02-designs/work-packages/wp-01-schema.md)**: Target PostgreSQL Schema, PostGIS DDL, 32 Operational Tables, Views & Seeds (`status: review`).
- **[wp-02-data-migration](./02-designs/work-packages/wp-02-data-migration.md)**: Zero-Dependency Native Python Streaming ETL Pipeline & Sequence Reset (`status: review`).
- **[wp-03-backend-domain-services](./02-designs/work-packages/wp-03-backend-domain-services.md)**: Core Property, Tenancy & Contact Backend Services (`status: pending`).
- **[wp-04-accounting-ledger-engine](./02-designs/work-packages/wp-04-accounting-ledger-engine.md)**: General Ledger, Billing & Double-Entry Accounting Service (`status: pending`).
- **[wp-05-ai-intake-copilot](./02-designs/work-packages/wp-05-ai-intake-copilot.md)**: Multimodal OCR Intake, Smart Payment Allocation & Yardi Ingest (`status: pending`).
- **[wp-06-web-frontend](./02-designs/work-packages/wp-06-web-frontend.md)**: Responsive Nuxt 3 / Vue 3 / shadcn-vue Web Dashboard (`status: pending`).
- **[wp-07-verification-reconciliation](./02-designs/work-packages/wp-07-verification-reconciliation.md)**: End-to-End Financial Integrity & Data Reconciliation Suite (`status: pending`).

*For execution phases, dependency graphs, and automated verification commands, see [Self-Contained Implementation Plan](./02-designs/implementation-plan.md).*

---

### User Interface
The user interface is engineered as a modern, reactive single-page application using **Nuxt 3 (Vue 3)** with **Tailwind CSS** and **shadcn-vue** components:
- Replaces 179 legacy Smarty templates and dynamic Oracle menu tables (`RNT_MENUS*`) with client-side routing and reactive Pinia state stores.
- Unified App Shell featuring responsive sidebar navigation, global tenant/property search, notifications bell, and user profile avatar.
- Interactive data tables with client-side sorting, column filtering, pagination, and CSV/PDF export.
- Embedded document viewer with canvas annotation for reviewing uploaded vendor bills and OCR draft matches.

*For wireframes, screen flows, and component specs, see [Technical Design Document: Application Services](./02-designs/02-application-services-tdd.md) and [Work Package 06 Spec](./02-designs/work-packages/wp-06-web-frontend.md).*

---

## Test Plans

The testing strategy spans automated unit tests, schema validation, data migration reconciliation, and end-to-end functional workflows:

### 1. Functional Acceptance Tests
- **Lease Lifecycle & Billing**: Verify that creating a tenancy agreement automatically schedules recurring AR charges and updates unit occupancy status (`packages/backend/tests/leases.test.ts`).
- **FIFO Payment Allocation**: Verify that logging a payment allocates funds against the oldest open invoices and correctly sets `PAID` or `PARTIAL` status (`packages/backend/tests/allocations.test.ts`).
- **Double-Entry Journal Integrity**: Verify that every financial transaction creates balanced debit and credit entries (`SUM(amount) = 0.00` across entry pairs) and distinct accounts.

### 2. Schema Validation & Constraint Verification
- Automated test suite `packages/database/tests/schema_validation.test.ts` executes against target PostgreSQL instance:
  - Validates existence and column types for all 32 operational tables.
  - Confirms foreign key cascading and nullability constraints (including nullable `agreement_id` on `rnt_accounts_receivable`).
  - Verifies PostGIS extension and `geometry(Point, 4326)` column definitions.
  - Validates `requires_password_reset` column on `rnt_users` and distinct debit/credit constraint on `rnt_ledger_entries`.
  - Validates `set_updated_at()` trigger execution on row update.

### 3. Data Migration & Financial Reconciliation Tests
Automated cross-engine verification executed via `tools/migration/verify-reconciliation.py`:
- **Dual-Database Row Count Matching**: Exact row-count parity checks between Oracle source (`RNTMGR2`) and PostgreSQL across all 32 migrated operational tables (~260k total operational records).
- **Zero-Variance Trial Balance Reconciliation**: Executes trial balance queries on both Oracle (`RNT_LEDGER_PKG`) and PostgreSQL (`v_account_period_balances`) for all historical periods through 2025-12-31; asserts zero cent variance across debits and credits.
- **AP/AR Status Reconciliation**: Verifies that `reconcile_post_etl_balances()` leaves zero historical invoices with corrupt open status where matching allocations exist.
- **Spatial Geometry Validation**: Executes `ST_IsValid(geom)` and SRID verification (`ST_SRID(geom) = 4326`) for all migrated property points.

### 4. Performance & Cutover Dry-Run Rehearsals
- **ETL Throughput Benchmark**: Automated execution of `./tools/migration/run-dryrun.sh testbed` validating completion within 30 seconds.
- **Sequence Reset Verification**: Asserts that `SELECT MAX(id) FROM table` is strictly less than `nextval(pg_get_serial_sequence('table', 'id'))` across all 32 tables.

---

- **Approval Status**: Draft — approve via Workbench **Approve Requirements** button or Git PR merge to unlock Technical Design.
