---
id: wp-01-schema
title: "Work Package 01: Target PostgreSQL Schema & Migration Scripts"
status: review
phase: implementation
slug: property-management
target_repo: visulate
branch: feat/wp-01-schema
design_doc: docs/projects/property-management/02-designs/01-core-schema-tdd.md
dependencies: []
scope:
  - schema
  - database
  - postgis
  - ddl
  - seeds
---

# Work Package 01: Target PostgreSQL Schema & Migration Scripts

## 1. Objective & Deliverables Overview
Implement the deterministic target PostgreSQL 16+ DDL migrations, PostGIS spatial extensions, relational constraints, foreign keys, CHECK constraints, automated `updated_at` triggers, and JSON seed data mappings for the Property Management bounded context. This establishes the structural foundation in `packages/database/` with zero legacy dependencies on county public records (`PR_*`) or MLS feeds (`MLS_*`).

Following the comprehensive parity review against the Oracle 19c (`pdb22.RNTMGR2`) baseline schema (57 `RNT_*` tables), this work package consolidates:
- **32 Active Operational Tables** (20 baseline operational tables + 12 parity operational additions).
- **5 Tables Replaced by Modern PostgreSQL Idioms / Enums / Dynamic Views** (Category B).
- **2 Seed Data Mappings** externalized as deterministic JSON fixtures (Category C).
- **18 Retired Legacy Subsystems** explicitly pruned from scope (Category D).

### Key Target Files to Create / Maintain:
1. `packages/database/migrations/001_initial_schema.sql`: Full DDL script creating extensions, trigger functions, sequences, and all target operational tables with primary/foreign keys, security flags (`requires_password_reset`), ledger debit/credit distinction checks, and indexes.
2. `packages/database/migrations/002_views.sql`: ANSI SQL views replacing legacy Oracle `(+)` outer joins and dynamic ledger balance views (`v_active_tenancy_agreements`, `v_ar_aging`, `v_account_period_balances`, `v_ledger_transactions`, `v_properties_summary`).
3. `packages/database/seeds/default_accounts.json`: Standard chart of accounts seed definitions (39 core accounts).
4. `packages/database/seeds/default_pt_rules.json`: Default debit/credit accounting transaction routing rules across payment types.
5. `packages/database/seeds/payment_types.json`: Standard catalog of transaction classifications with depreciation metadata.
6. `packages/database/src/migrate.ts`: Deterministic Node.js / TypeScript migration runner script.
7. `packages/database/src/seed.ts`: Seed runner populating default accounting rules and business unit initial charts.
8. `packages/database/tests/schema_validation.test.ts`: Automated test suite validating table structures, constraint rules, seed loads, and PostGIS spatial indexing.

---

## 2. Source Context, Scope Parity & Architecture Dispositions

### 2.1 Complete Schema Scope (57 Oracle RNT_* Tables)

| Category | Disposition | Count | Table Names |
| :--- | :--- | :---: | :--- |
| **Active Operational** | Migrated to Target PostgreSQL DDL | **32** | `rnt_business_units`, `rnt_people`, `rnt_users`, `rnt_user_roles`, `rnt_user_assignments`, `rnt_people_bu`, `rnt_properties`, `rnt_property_units`, `rnt_property_value`, `rnt_property_photos`, `rnt_property_expenses`, `rnt_expense_items`, `rnt_tenant`, `rnt_tenancy_agreement`, `rnt_agreement_actions`, `rnt_leads`, `rnt_lead_actions`, `rnt_section8_offices`, `rnt_section8_offices_bu`, `rnt_doc_templates`, `rnt_accounts`, `rnt_account_periods`, `rnt_payment_types`, `rnt_pt_rules`, `rnt_accounts_receivable`, `rnt_payments`, `rnt_payment_allocations`, `rnt_accounts_payable`, `rnt_ledger_entries`, `rnt_loans`, `rnt_suppliers_all`, `rnt_bu_suppliers` *(Note: `rnt_loans` and `rnt_expense_items` included)* |
| **Category B** | Replaced by Enums, Constraints & Dynamic Views | **5** | `RNT_ACCOUNT_TYPES`, `RNT_LOOKUP_TYPES`, `RNT_LOOKUP_VALUES`, `RNT_SUPPLIER_TYPES`, `RNT_ACCOUNT_BALANCES` |
| **Category C** | Seed Data Externalized to JSON | **2** | `RNT_DEFAULT_ACCOUNTS`, `RNT_DEFAULT_PT_RULES` |
| **Category D** | Retired Legacy Subsystems | **18** | Dynamic CMS Navigation (6), Public Geographic Portal (6), Legacy Auth/Error (2), Obsolete/Discontinued (4) |
| **Total** | | **57** | **100% Accounted For** |

---

### 2.2 Category B Dispositions: Enums, Domain Constraints & Dynamic Views

1. **`RNT_ACCOUNT_TYPES`**:
   - *Legacy Role*: 6-row lookup table (`Asset`, `Liability`, `Equity`, `Revenue`, `Expense`, `Cost of Goods Sold`).
   - *Target Disposition*: Replaced by a PostgreSQL `CHECK (account_type IN ('ASSET', 'LIABILITY', 'EQUITY', 'REVENUE', 'EXPENSE'))` constraint on `rnt_accounts` and TypeScript enum `AccountType`.
2. **`RNT_LOOKUP_TYPES` & `RNT_LOOKUP_VALUES`**:
   - *Legacy Role*: Generic key-value entity tables (8 types, 93 values) storing state lists, tenant statuses, and action categories.
   - *Target Disposition*: Replaced by strongly-typed PostgreSQL `CHECK` constraints on parent entities (e.g., `status VARCHAR(20) CHECK (status IN ('OPEN', 'PARTIAL', 'PAID', 'CANCELLED', 'WRITEOFF'))`), enhancing query execution performance and eliminating unnecessary runtime joins.
3. **`RNT_SUPPLIER_TYPES`**:
   - *Legacy Role*: 20-row contractor specialty classification table.
   - *Target Disposition*: Replaced by `supplier_category VARCHAR(32)` on `rnt_suppliers_all` with predefined domain values (`CONTRACTOR`, `UTILITY`, `MAINTENANCE`, `LEGAL`, `MUNICIPAL`, `INSURANCE`, `OTHER`).
4. **`RNT_ACCOUNT_BALANCES`**:
   - *Legacy Role*: 7,950 pre-calculated balance snapshot rows per period.
   - *Target Disposition*: Replaced by dynamic SQL view `v_account_period_balances` computed directly from `rnt_ledger_entries`. This eliminates batch synchronization latency, reconciliation drift, and race conditions when posting transactions.

---

### 2.3 Category D Dispositions: Retired Legacy Subsystems (18 Tables)

1. **Dynamic CMS Menu & Page Subsystem (6 tables)**:
   - Tables: `RNT_MENUS`, `RNT_MENU_LINKS`, `RNT_MENU_PAGES`, `RNT_MENU_ROLES`, `RNT_MENU_TABS`, `RNT_MLS_COUNTY_PAGES`.
   - *Rationale*: Legacy procedural CMS rendering engine (circa 2007-2009) where HTML pages and tabs were stored in CLOBs. Modernized into Vue 3 / Nuxt 3 single-page application navigation with static file layouts, Pinia auth store, and route guards.
2. **Public Geographic Portal Subsystem (6 tables)**:
   - Tables: `RNT_CITIES`, `RNT_ZIPCODES`, `RNT_CITY_ZIPCODES`, `RNT_REGIONS`, `RNT_COUNTY_DESCRIPTIONS`, `RNT_CITY_MEDIA`.
   - *Rationale*: Legacy static geographic tables (41k+ ZIP codes and 33k+ cities) duplicated public boundary data. Decoupled from core rental management; address validation and geocoding are offloaded to PostGIS and standard modern external services (USPS / Census API / Nominatim).
3. **Legacy Auth & Error Logging (2 tables)**:
   - Tables: `RNT_USER_REGISTRY`, `RNT_ERROR_DESCRIPTION`.
   - *Rationale*: Legacy email confirmation token table and Oracle numeric error message table replaced by modern OAuth2/JWT tokens and structured JSON API error payloads.
4. **Obsolete & Discontinued Entities (4 tables)**:
   - `RNT_SUPPLIERS_OLD`: Redundant archival predecessor to `RNT_SUPPLIERS_ALL`.
   - `RNT_TAX_SOURCES`: Obsolete integration feed discontinued in 2012.
   - `RNT_PROPERTY_LINKS`: External hyperlinks replaced by document attachment metadata in `rnt_properties`.
   - `RNT_PROPERTY_ESTIMATES`: Deprecated manual forecast table replaced by `rnt_property_value` historical valuation and automated financial analytics.

---

### 2.4 Decoupling Rules for External Dependencies
- **`rnt_properties.prop_id`**: Nullable `BIGINT` without hard foreign key constraint to legacy `PR_PROPERTIES`.
- **`rnt_lead_actions.broker_id`**: Replaced by `assigned_user_id BIGINT REFERENCES rnt_users(user_id)` for internal agents; `broker_id BIGINT` retained as an unconstrained identifier for historical auditability without dependency on `PR_LICENSED_AGENTS`.
- **`SDO_GEOMETRY` Migration**: Converted to PostGIS `geometry(Point, 4326)` with standard GiST spatial indexes.

---

## 3. Deterministic DDL & SQL Contracts

### 3.1 Extensions & Common Functions (`001_initial_schema.sql`)
```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Generic row update timestamp trigger function
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = clock_timestamp();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

---

### 3.2 Operational Additions: DDL & Constraints

#### 1. User Assignments (`rnt_user_assignments`)
Multi-tenant RBAC junction associating users with specific business units under defined roles.
```sql
CREATE TABLE rnt_user_assignments (
    user_assign_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    role_id BIGINT NOT NULL REFERENCES rnt_user_roles(role_id) ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES rnt_users(user_id) ON DELETE CASCADE,
    business_id BIGINT NOT NULL REFERENCES rnt_business_units(business_id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    CONSTRAINT rnt_user_assignments_u1 UNIQUE (role_id, user_id, business_id)
);

CREATE INDEX idx_rnt_user_assignments_business ON rnt_user_assignments(business_id);
CREATE INDEX idx_rnt_user_assignments_user ON rnt_user_assignments(user_id);

COMMENT ON TABLE rnt_user_assignments IS 'Associates users with roles and business units for multi-tenant RBAC.';
```

#### 2. People Business Unit Junction (`rnt_people_bu`)
Many-to-many junction establishing which contacts, tenants, and owners belong to which business units.
```sql
CREATE TABLE rnt_people_bu (
    people_business_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    people_id BIGINT NOT NULL REFERENCES rnt_people(people_id) ON DELETE CASCADE,
    business_id BIGINT NOT NULL REFERENCES rnt_business_units(business_id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    CONSTRAINT rnt_people_bu_u1 UNIQUE (people_id, business_id)
);

CREATE INDEX idx_rnt_people_bu_business ON rnt_people_bu(business_id);
CREATE INDEX idx_rnt_people_bu_people ON rnt_people_bu(people_id);

COMMENT ON TABLE rnt_people_bu IS 'Associates people directory contacts with specific business units.';
```

#### 3. Business Unit Suppliers (`rnt_bu_suppliers`)
Associates approved vendors, contractors, and utility suppliers with specific operating entities.
```sql
CREATE TABLE rnt_bu_suppliers (
    bu_supplier_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    business_id BIGINT NOT NULL REFERENCES rnt_business_units(business_id) ON DELETE CASCADE,
    supplier_id BIGINT NOT NULL REFERENCES rnt_suppliers_all(supplier_id) ON DELETE CASCADE,
    tax_identifier VARCHAR(32), -- Specific 1099 SSN/EIN used by this BU
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    CONSTRAINT rnt_bu_suppliers_u1 UNIQUE (business_id, supplier_id)
);

CREATE INDEX idx_rnt_bu_suppliers_supplier ON rnt_bu_suppliers(supplier_id);
CREATE INDEX idx_rnt_bu_suppliers_business ON rnt_bu_suppliers(business_id);

CREATE TRIGGER trg_rnt_bu_suppliers_updated_at
BEFORE UPDATE ON rnt_bu_suppliers
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

COMMENT ON TABLE rnt_bu_suppliers IS 'Approved supplier and vendor relationships configured per business unit.';
```

#### 4. Accounting Periods (`rnt_account_periods`)
Accounting period lockouts preventing transactional modifications to historical closed periods.
```sql
CREATE TABLE rnt_account_periods (
    period_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    business_id BIGINT NOT NULL REFERENCES rnt_business_units(business_id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE,
    closed_yn VARCHAR(1) NOT NULL DEFAULT 'N' CHECK (closed_yn IN ('Y', 'N')),
    closed_at TIMESTAMPTZ,
    closed_by BIGINT REFERENCES rnt_users(user_id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    CONSTRAINT rnt_account_periods_u1 UNIQUE (business_id, start_date)
);

CREATE INDEX idx_rnt_account_periods_business ON rnt_account_periods(business_id);

CREATE TRIGGER trg_rnt_account_periods_updated_at
BEFORE UPDATE ON rnt_account_periods
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

COMMENT ON TABLE rnt_account_periods IS 'Accounting periods for business units; closed periods lock out financial modifications.';
```

#### 5. Property Valuation History (`rnt_property_value`)
Historical valuation log over time tracking comparable estimates, actual sale prices, and NOI capitalization values.
```sql
CREATE TABLE rnt_property_value (
    value_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    property_id BIGINT NOT NULL REFERENCES rnt_properties(property_id) ON DELETE CASCADE,
    value_date DATE NOT NULL,
    value_method VARCHAR(30) NOT NULL CHECK (value_method IN ('SALE', 'ESTIMATE', 'CAP_RATE', 'APPRAISAL')),
    value NUMERIC(12, 2) NOT NULL CHECK (value >= 0),
    cap_rate NUMERIC(5, 4), -- e.g. 0.0650 for 6.50%
    created_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    CONSTRAINT rnt_property_value_uk1 UNIQUE (property_id, value_date, value_method)
);

CREATE INDEX idx_rnt_property_value_property ON rnt_property_value(property_id);
CREATE INDEX idx_rnt_property_value_date ON rnt_property_value(value_date);

COMMENT ON TABLE rnt_property_value IS 'Historical valuation records tracking sales, appraisals, estimates, and cap rates.';
```

#### 6. Section 8 Housing Offices (`rnt_section8_offices`)
Master lookup catalog of government Section 8 housing authorities and voucher programs.
```sql
CREATE TABLE rnt_section8_offices (
    section8_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    section_name VARCHAR(64) NOT NULL UNIQUE,
    contact_name VARCHAR(128),
    phone VARCHAR(32),
    email VARCHAR(256),
    address1 VARCHAR(128),
    city VARCHAR(64),
    state VARCHAR(2) NOT NULL DEFAULT 'FL',
    zipcode VARCHAR(10),
    created_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp()
);

CREATE TRIGGER trg_rnt_section8_offices_updated_at
BEFORE UPDATE ON rnt_section8_offices
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

COMMENT ON TABLE rnt_section8_offices IS 'Directory of Section 8 housing subsidy authorities and voucher programs.';
```

#### 7. Section 8 Business Unit Junction (`rnt_section8_offices_bu`)
Associates Section 8 housing offices with specific property management business units.
```sql
CREATE TABLE rnt_section8_offices_bu (
    section8_business_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    section8_id BIGINT NOT NULL REFERENCES rnt_section8_offices(section8_id) ON DELETE CASCADE,
    business_id BIGINT NOT NULL REFERENCES rnt_business_units(business_id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    CONSTRAINT rnt_section8_offices_bu_u1 UNIQUE (section8_id, business_id)
);

CREATE INDEX idx_rnt_section8_bu_business ON rnt_section8_offices_bu(business_id);
CREATE INDEX idx_rnt_section8_bu_office ON rnt_section8_offices_bu(section8_id);

COMMENT ON TABLE rnt_section8_offices_bu IS 'Associates Section 8 housing offices with operating business units.';
```

#### 8. Document Templates (`rnt_doc_templates`)
Rental management document templates for tenancy agreements, notices, and receipts.
```sql
CREATE TABLE rnt_doc_templates (
    template_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    business_id BIGINT REFERENCES rnt_business_units(business_id) ON DELETE CASCADE, -- NULL indicates global template
    template_type VARCHAR(32) NOT NULL DEFAULT 'LEASE' CHECK (template_type IN ('LEASE', 'NOTICE', 'INVOICE', 'RECEIPT', 'CUSTOM')),
    content TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    CONSTRAINT rnt_doc_templates_u1 UNIQUE (name, business_id)
);

CREATE INDEX idx_rnt_doc_templates_business ON rnt_doc_templates(business_id);

CREATE TRIGGER trg_rnt_doc_templates_updated_at
BEFORE UPDATE ON rnt_doc_templates
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

COMMENT ON TABLE rnt_doc_templates IS 'Document and notice templates configurable globally or per business unit.';
```

#### 9. Lead Actions & CRM Log (`rnt_lead_actions`)
Interaction audit log tracking activities, calls, emails, offers, and tours for prospective tenant leads.
```sql
CREATE TABLE rnt_lead_actions (
    action_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    lead_id BIGINT NOT NULL REFERENCES rnt_leads(lead_id) ON DELETE CASCADE,
    action_date TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    action_type VARCHAR(32) NOT NULL CHECK (action_type IN ('PHONE_CALL', 'EMAIL', 'LETTER', 'REFERRAL', 'OFFER', 'COUNTER_OFFER', 'SALE_AGREED', 'INSPECTION', 'WITHDRAWN', 'CLOSING')),
    assigned_user_id BIGINT REFERENCES rnt_users(user_id) ON DELETE SET NULL,
    broker_id BIGINT, -- Unconstrained legacy identifier preserved without FK to external tables
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp()
);

CREATE INDEX idx_rnt_lead_actions_lead ON rnt_lead_actions(lead_id);
CREATE INDEX idx_rnt_lead_actions_date ON rnt_lead_actions(action_date);

COMMENT ON TABLE rnt_lead_actions IS 'Interaction history and CRM activity log for rental and sales leads.';
```

---

### 3.3 Core Table Baseline Specifications (Summary)
- **`rnt_business_units`**: `business_id BIGINT PRIMARY KEY`, `business_name VARCHAR(128) NOT NULL`, `tax_id VARCHAR(32)`, `address1 VARCHAR(128)`, `city VARCHAR(64)`, `state VARCHAR(2)`, `zipcode VARCHAR(10)`.
- **`rnt_users`**: `user_id BIGINT PRIMARY KEY`, `username VARCHAR(64) UNIQUE`, `password_hash VARCHAR(256)`, `email VARCHAR(256) UNIQUE`, `is_active BOOLEAN`, `requires_password_reset BOOLEAN NOT NULL DEFAULT FALSE`.
- **`rnt_properties`**: `property_id BIGINT PRIMARY KEY`, `business_id BIGINT NOT NULL REFERENCES rnt_business_units`, `name VARCHAR(64)`, `address1 VARCHAR(60) NOT NULL`, `city VARCHAR(60) NOT NULL`, `state VARCHAR(2) NOT NULL`, `zipcode VARCHAR(10) NOT NULL`, `units INTEGER NOT NULL DEFAULT 1 CHECK (units >= 1)`, `geom geometry(Point, 4326)`, `prop_id BIGINT`.
- **`rnt_property_units`**: `unit_id BIGINT PRIMARY KEY`, `property_id BIGINT NOT NULL REFERENCES rnt_properties ON DELETE CASCADE`, `unit_name VARCHAR(32) NOT NULL`, `beds NUMERIC(3, 1)`, `baths NUMERIC(3, 1)`, `status VARCHAR(16) NOT NULL DEFAULT 'VACANT' CHECK (status IN ('VACANT', 'OCCUPIED', 'RENOVATION', 'INACTIVE'))`.
- **`rnt_tenant`**: `tenant_id BIGINT PRIMARY KEY`, `people_id BIGINT NOT NULL REFERENCES rnt_people`, `business_id BIGINT NOT NULL REFERENCES rnt_business_units`, `section8_id BIGINT REFERENCES rnt_section8_offices(section8_id)`, `deposit_balance NUMERIC(10, 2) DEFAULT 0`, `status VARCHAR(16) NOT NULL DEFAULT 'ACTIVE'`.
- **`rnt_tenancy_agreement`**: `agreement_id BIGINT PRIMARY KEY`, `unit_id BIGINT NOT NULL REFERENCES rnt_property_units`, `tenant_id BIGINT REFERENCES rnt_tenant`, `amount NUMERIC(10, 2) NOT NULL CHECK (amount >= 0)`, `start_date DATE NOT NULL`, `end_date DATE`, `status VARCHAR(16) NOT NULL DEFAULT 'ACTIVE'`.
- **`rnt_accounts`**: `account_id BIGINT PRIMARY KEY`, `business_id BIGINT NOT NULL REFERENCES rnt_business_units`, `account_number VARCHAR(32) NOT NULL`, `account_name VARCHAR(128) NOT NULL`, `account_type VARCHAR(32) NOT NULL CHECK (account_type IN ('ASSET', 'LIABILITY', 'EQUITY', 'REVENUE', 'EXPENSE'))`.
- **`rnt_payment_types`**: `payment_type_id BIGINT PRIMARY KEY`, `business_id BIGINT NOT NULL REFERENCES rnt_business_units`, `payment_type_name VARCHAR(64) NOT NULL`, `depreciation_term NUMERIC(5, 2) DEFAULT 0`, `payable_yn VARCHAR(1) NOT NULL DEFAULT 'Y'`, `receivable_yn VARCHAR(1) NOT NULL DEFAULT 'N'`.
- **`rnt_pt_rules`**: `rule_id BIGINT PRIMARY KEY`, `business_id BIGINT NOT NULL REFERENCES rnt_business_units`, `payment_type_id BIGINT NOT NULL REFERENCES rnt_payment_types`, `transaction_type VARCHAR(8) NOT NULL CHECK (transaction_type IN ('APS', 'APP', 'ARS', 'ARP', 'DEP'))`, `debit_account BIGINT NOT NULL REFERENCES rnt_accounts(account_id)`, `credit_account BIGINT NOT NULL REFERENCES rnt_accounts(account_id)`.
- **`rnt_accounts_receivable`**: `ar_id BIGINT PRIMARY KEY`, `business_id BIGINT NOT NULL REFERENCES rnt_business_units`, `tenant_id BIGINT REFERENCES rnt_tenant`, `agreement_id BIGINT REFERENCES rnt_tenancy_agreement(agreement_id) ON DELETE SET NULL`, `payment_type_id BIGINT NOT NULL REFERENCES rnt_payment_types`, `due_date DATE NOT NULL`, `amount NUMERIC(12, 2) NOT NULL CHECK (amount > 0)`, `amount_paid NUMERIC(12, 2) NOT NULL DEFAULT 0.00`, `status VARCHAR(16) NOT NULL DEFAULT 'OPEN' CHECK (status IN ('OPEN', 'PARTIAL', 'PAID', 'CANCELLED', 'WRITEOFF'))`.
- **`rnt_payments`**: `payment_id BIGINT PRIMARY KEY`, `tenant_id BIGINT NOT NULL REFERENCES rnt_tenant`, `payment_date DATE NOT NULL`, `amount NUMERIC(12, 2) NOT NULL CHECK (amount > 0)`, `allocated_amount NUMERIC(12, 2) NOT NULL DEFAULT 0.00 CHECK (allocated_amount <= amount)`, `payment_method VARCHAR(32) NOT NULL`.
- **`rnt_payment_allocations`**: `pay_alloc_id BIGINT PRIMARY KEY`, `payment_id BIGINT NOT NULL REFERENCES rnt_payments ON DELETE CASCADE`, `ar_id BIGINT NOT NULL REFERENCES rnt_accounts_receivable`, `amount NUMERIC(12, 2) NOT NULL CHECK (amount > 0)`.
- **`rnt_accounts_payable`**: `ap_id BIGINT PRIMARY KEY`, `business_id BIGINT NOT NULL REFERENCES rnt_business_units`, `supplier_id BIGINT REFERENCES rnt_suppliers_all`, `property_id BIGINT REFERENCES rnt_properties`, `due_date DATE NOT NULL`, `amount NUMERIC(12, 2) NOT NULL CHECK (amount > 0)`, `status VARCHAR(16) NOT NULL DEFAULT 'OPEN'`.
- **`rnt_ledger_entries`**: `ledger_id BIGINT PRIMARY KEY`, `business_id BIGINT NOT NULL REFERENCES rnt_business_units`, `entry_date DATE NOT NULL`, `description TEXT NOT NULL`, `debit_account BIGINT NOT NULL REFERENCES rnt_accounts`, `credit_account BIGINT NOT NULL REFERENCES rnt_accounts`, `amount NUMERIC(12, 2) NOT NULL CHECK (amount > 0)`, `property_id BIGINT REFERENCES rnt_properties`, `ar_id BIGINT REFERENCES rnt_accounts_receivable`, `ap_id BIGINT REFERENCES rnt_accounts_payable`, `pay_alloc_id BIGINT REFERENCES rnt_payment_allocations`, `CONSTRAINT rnt_ledger_distinct_accounts CHECK (debit_account <> credit_account)`.

---

### 3.4 ANSI SQL Views (`002_views.sql`)
Replaces legacy Oracle `(+)` outer joins with standard ANSI joins and replaces the `RNT_ACCOUNT_BALANCES` table with a dynamic balance view:

```sql
-- Dynamic Account Balances View (replaces RNT_ACCOUNT_BALANCES table)
CREATE OR REPLACE VIEW v_account_period_balances AS
WITH account_entries AS (
    SELECT 
        le.business_id,
        le.debit_account AS account_id,
        DATE_TRUNC('month', le.entry_date)::DATE AS period_month,
        le.amount AS debit_amount,
        0.00::NUMERIC(12,2) AS credit_amount
    FROM rnt_ledger_entries le
    UNION ALL
    SELECT 
        le.business_id,
        le.credit_account AS account_id,
        DATE_TRUNC('month', le.entry_date)::DATE AS period_month,
        0.00::NUMERIC(12,2) AS debit_amount,
        le.amount AS credit_amount
    FROM rnt_ledger_entries le
),
period_sums AS (
    SELECT 
        ae.business_id,
        ae.account_id,
        ae.period_month,
        SUM(ae.debit_amount) AS total_debit,
        SUM(ae.credit_amount) AS total_credit
    FROM account_entries ae
    GROUP BY ae.business_id, ae.account_id, ae.period_month
)
SELECT 
    a.account_id,
    a.business_id,
    a.account_number,
    a.account_name,
    a.account_type,
    ps.period_month,
    ps.total_debit,
    ps.total_credit,
    CASE 
        WHEN a.account_type IN ('ASSET', 'EXPENSE') 
            THEN ps.total_debit - ps.total_credit
        ELSE ps.total_credit - ps.total_debit
    END AS net_balance
FROM rnt_accounts a
JOIN period_sums ps ON a.account_id = ps.account_id AND a.business_id = ps.business_id;
```

---

## 4. Acceptance Criteria & Automated Verification Commands

1. [x] **Extension Verification**: `uuid-ossp`, `postgis`, and `pgcrypto` installed and active in target PostgreSQL.
2. [x] **Operational Table Coverage**: All 32 active operational tables created with identity sequences, primary keys, foreign keys, and indexes.
3. [x] **Audit Trigger Operation**: `trg_*_updated_at` triggers verified to update `updated_at` automatically on modification.
4. [x] **Security Constraints**: `requires_password_reset` present on `rnt_users`; distinct debit/credit constraint enforced on `rnt_ledger_entries`.
5. [x] **Seed Data Integrity**: Seed runner successfully parses `default_accounts.json` and `default_pt_rules.json` and initializes default business unit charts.
6. [x] **Decoupling Parity**: Schema inspection confirms 0 foreign keys pointing to legacy `PR_*` or `MLS_*` tables.
7. [ ] **Verification Command**:
   ```bash
   npm --prefix packages/database install
   npm --prefix packages/database run test:schema
   npm --prefix packages/database run seed:dry-run
   ```
