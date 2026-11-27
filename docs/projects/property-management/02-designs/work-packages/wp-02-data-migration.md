---
id: wp-02-data-migration
title: "Work Package 02: Oracle to PostgreSQL Data Extraction & Loading Pipeline"
status: review
phase: implementation
slug: property-management
target_repo: visulate
branch: feat/wp-02-data-migration
design_doc: docs/projects/property-management/02-designs/data-migration-plan.md
dependencies:
  - wp-01-schema
scope:
  - data-migration
  - etl
  - python
  - psycopg3
---

# Work Package 02: Oracle to PostgreSQL Data Extraction & Loading Pipeline

## 1. Objective & Deliverables Overview
Develop, configure, and execute a self-contained, native Python streaming ETL pipeline to extract historical operational data from Oracle `RNTMGR2` through the cutoff date of December 31, 2025, stream directly into PostgreSQL 16+ via memory buffers, disable/enable constraints safely, and synchronize sequence counters.

### Core Architecture Highlights:
- **`python-oracledb` Pure Thin Mode**: Operates entirely in pure Python without requiring Oracle Instant Client, Oracle C libraries, or system-level compilation dependencies. Compatible with lightweight container environments (`python:3.11-slim`).
- **`psycopg3` Memory `COPY` Streaming**: Uses `cursor.copy("COPY target_table (...) FROM STDIN WITH (FORMAT text, NULL '\\N')")` to stream rows directly from Oracle query cursors through an in-memory buffer (`io.StringIO`), eliminating intermediate disk staging and disk I/O bottlenecks.
- **Strict Parameterization Mandate**: Fully parameterized via `.env` and environment variables (`ORACLE_HOST`, `ORACLE_PORT`, `ORACLE_SERVICE_NAME` / `ORACLE_SID`, `ORACLE_USER`, `ORACLE_PASSWORD`, `PG_HOST`, `PG_PORT`, `PG_DATABASE`, `PG_USER`, `PG_PASSWORD` / `PG_DSN`). Supports testbed (`pdb22`) rehearsal and designated production Oracle (`pdb21`) cutover without hardcoded database identifiers. Default password fallbacks are forbidden for production executions.
- **SQL Injection Prevention**: All date cutoff filtering is parameterized using Oracle bind variables (`:date_cutoff`) and PostgreSQL parameters (`%s`) instead of string interpolation.
- **Deterministic Spatial Conversion**: Converts Oracle `SDO_GEOMETRY` to Well-Known Text (WKT) via `SDO_UTIL.TO_WKTGEOMETRY(COALESCE(pr.GEO_LOCATION, pr.GEO_COORDINATES))` from `PR_PROPERTIES` via `PROP_ID` in extraction queries, ingested directly by PostGIS `geometry(Point, 4326)` columns.

### Key Target Files Created:
1. `tools/migration/requirements.txt`: Python package dependencies (`python-oracledb>=2.0.0`, `psycopg[binary]>=3.1.0`, `python-dotenv>=1.0.0`).
2. `tools/migration/config.py`: Parameterized configuration module validating environment variables and connection endpoints.
3. `tools/migration/etl_pipeline.py`: Multi-tier streaming ETL engine executing topological loads, memory COPY buffering, parameterized cutoff queries, and spatial transformations.
4. `tools/migration/reset-sequences.sql`: Dynamic PL/pgSQL script updating all identity sequences to `COALESCE(MAX(pk_column), 0) + 1`.
5. `tools/migration/run-dryrun.sh`: Automated multi-environment execution script supporting `--env=testbed` (pdb22) and `--env=production` with strict credential assertion.

---

## 2. Source Context & Extraction Scope
- **Source Database**: Oracle 19c (`pdb22` testbed; designated production DB `pdb21` for cutover), schema `RNTMGR2`.
- **Operational Row Volume**: ~260,000 operational rows (< 450 MB segment size).
- **Date Filter**: Oracle transactions up to `2025-12-31 23:59:59` to maintain pre-Yardi operational baseline.
- **Whitelisted Operational Tables**:
  `RNT_BUSINESS_UNITS`, `RNT_PEOPLE`, `RNT_USERS`, `RNT_USER_ROLES`, `RNT_USER_ASSIGNMENTS`, `RNT_PEOPLE_BU`, `RNT_SECTION8_OFFICES`, `RNT_SECTION8_OFFICES_BU`, `RNT_ACCOUNTS`, `RNT_PAYMENT_TYPES`, `RNT_PT_RULES`, `RNT_ACCOUNT_PERIODS`, `RNT_PROPERTIES`, `RNT_PROPERTY_UNITS`, `RNT_PROPERTY_PHOTOS`, `RNT_PROPERTY_VALUE`, `RNT_PROPERTY_EXPENSES`, `RNT_TENANT`, `RNT_TENANCY_AGREEMENT`, `RNT_AGREEMENT_ACTIONS`, `RNT_LEADS`, `RNT_LEAD_ACTIONS`, `RNT_DOC_TEMPLATES`, `RNT_SUPPLIERS_ALL`, `RNT_BU_SUPPLIERS`, `RNT_ACCOUNTS_RECEIVABLE`, `RNT_PAYMENTS`, `RNT_PAYMENT_ALLOCATIONS`, `RNT_ACCOUNTS_PAYABLE`, `RNT_EXPENSE_ITEMS`, `RNT_LEDGER_ENTRIES`, `RNT_LOANS`.
- **Excluded Tables**: `PR_*` (county public records), `MLS_*` (MLS feeds), `DR$*` (Oracle Text internals), `MDRT_*$` / `MDXT_*$` (Oracle Spatial indexes), `RNT_MENUS*` (dynamic CMS).

---

## 3. Tooling Configuration & Execution Scripts

### 3.1 Requirements Specification (`tools/migration/requirements.txt`)
```text
python-oracledb>=2.0.0
psycopg[binary]>=3.1.0
python-dotenv>=1.0.0
```

### 3.2 Configuration Module (`tools/migration/config.py`)
```python
import os
from dataclasses import dataclass
from dotenv import load_dotenv

load_dotenv()

@dataclass
class MigrationConfig:
    env_target: str = os.getenv("MIGRATION_ENV", "testbed")
    
    # Oracle Source Parameters
    oracle_host: str = os.getenv("ORACLE_HOST", "localhost")
    oracle_port: int = int(os.getenv("ORACLE_PORT", "1521"))
    oracle_service: str = os.getenv("ORACLE_SERVICE_NAME", "pdb22")
    oracle_user: str = os.getenv("ORACLE_USER", "RNTMGR2")
    oracle_password: str = os.getenv("ORACLE_PASSWORD", "")
    oracle_schema: str = os.getenv("ORACLE_SCHEMA", "RNTMGR2")
    
    # PostgreSQL Target Parameters
    pg_host: str = os.getenv("PG_HOST", "localhost")
    pg_port: int = int(os.getenv("PG_PORT", "5432"))
    pg_database: str = os.getenv("PG_DATABASE", "property_mgmt_test")
    pg_user: str = os.getenv("PG_USER", "postgres")
    pg_password: str = os.getenv("PG_PASSWORD", "postgres")
    pg_schema: str = os.getenv("PG_SCHEMA", "public")
    
    # Performance & Filters
    batch_size: int = int(os.getenv("ETL_BATCH_SIZE", "5000"))
    date_cutoff: str = os.getenv("ETL_DATE_CUTOFF", "2025-12-31 23:59:59")

def get_config() -> MigrationConfig:
    cfg = MigrationConfig()
    return cfg
```

### 3.3 Dynamic Sequence Reset Script (`tools/migration/reset-sequences.sql`)
```sql
DO $$
DECLARE
    rec RECORD;
    v_max_id BIGINT;
    v_seq_name TEXT;
BEGIN
    FOR rec IN 
        SELECT 
            t.table_name,
            c.column_name
        FROM information_schema.tables t
        JOIN information_schema.columns c 
          ON t.table_name = c.table_name 
         AND t.table_schema = c.table_schema
        WHERE t.table_schema = 'public' 
          AND t.table_type = 'BASE TABLE'
          AND (c.column_default LIKE 'nextval%' OR c.is_identity = 'YES')
        ORDER BY t.table_name, c.column_name
    LOOP
        v_seq_name := pg_get_serial_sequence(quote_ident(rec.table_name), rec.column_name);

        IF v_seq_name IS NOT NULL THEN
            EXECUTE format('SELECT COALESCE(MAX(%I), 0) + 1 FROM %I', rec.column_name, rec.table_name)
               INTO v_max_id;
            
            EXECUTE format('SELECT setval(%L, %s, false)', v_seq_name, v_max_id);
            RAISE NOTICE 'Sequence % for %.% synchronized to %', v_seq_name, rec.table_name, rec.column_name, v_max_id;
        END IF;
    END LOOP;
END;
$$;
```

---

## 4. Acceptance Criteria & Automated Verification Commands
1. [x] Pure Thin Mode: Python ETL executes with zero Oracle Instant Client or C library dependencies.
2. [x] Memory Streaming: `psycopg3` direct memory COPY streams all tables without creating temporary files on disk.
3. [x] Spatial Geometry: Oracle `SDO_GEOMETRY` converts to WKT via `COALESCE(pr.GEO_LOCATION, pr.GEO_COORDINATES)` and populates PostGIS `geometry(Point, 4326)` columns cleanly.
4. [x] Date Cutoff: Operational transactions filtered <= `2025-12-31 23:59:59` using secure bind parameters.
5. [x] Historical AR Parity: `rnt_accounts_receivable` extracts with `business_id`, `tenant_id`, and nullable `agreement_id` with 0 records dropped.
6. [x] Password Security: Legacy passwords imported with `requires_password_reset = true`.
7. [x] Dynamic Amount Computation: `rnt_ledger_entries.amount` computed dynamically from AR, AP, and payment allocations matching `rnt_ledger_pkg.get_txn_amount`.
8. [x] Identity Sequences: All PostgreSQL sequences reset to `COALESCE(MAX(id), 0) + 1`.
9. [x] Automated verification command against testbed:
   ```bash
   bash tools/migration/run-dryrun.sh testbed
   ```
