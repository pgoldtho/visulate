---
title: "Implementation Plan: Property Management Modernization"
status: ready_for_review
phase: design
slug: property-management
doc_type: implementation-plan
source_db: pdb22
source_schema: RNTMGR2
target_db: postgres
target_engine: PostgreSQL 16+ with PostGIS
target_repos:
  - visulate
---

# Implementation Plan: Property Management Modernization

## 1. Executive Summary & Work Breakdown Overview

This document provides a self-contained, AI-executable roadmap for implementing the **Property Management Modernization** project. Each work package is designed with complete context, code templates, deterministic schemas, automated test commands, and dedicated standalone specification files so it can be executed independently by Visulate agents or external AI coding tools (Claude Code, Cursor, Codex, Copilot Workspace).

### Work Package Dependency Graph
```
[wp-01-schema] Target PostgreSQL DDL & Migrations
       │
       ├───────────────────────────────────────────┬───────────────────────────────────────────┐
       ▼                                           ▼                                           ▼
[wp-02-data-migration] Native Python ETL Pipeline   [wp-03-backend-domain-services] Core API & Repos
       │                                           │
       │                                           ▼
       │                                [wp-04-accounting-ledger-engine] GL & Invoicing
       │                                           │
       ├───────────────────────────────────────────┴───────────────────────────────────────────┐
       ▼                                           ▼                                           ▼
[wp-07-verification-reconciliation]      [wp-05-ai-intake-copilot]       [wp-06-web-frontend]
Automated Financial Reconciliation       Document OCR, Payments & Yardi   Nuxt 3 / Vue 3 UI & Dashboard
```

### Summary of Work Packages

| ID | Title | Target Branch | Dependencies | Standalone AI Spec | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `wp-01-schema` | Target PostgreSQL Schema & Migration Scripts | `feat/wp-01-schema` | None | [`work-packages/wp-01-schema.md`](work-packages/wp-01-schema.md) | Ready |
| `wp-02-data-migration` | Oracle to PostgreSQL Data Extraction & Loading Pipeline | `feat/wp-02-data-migration` | `wp-01-schema` | [`work-packages/wp-02-data-migration.md`](work-packages/wp-02-data-migration.md) | Ready |
| `wp-03-backend-domain-services` | Core Property, Tenancy & Contact Backend Services | `feat/wp-03-backend-domain-services` | `wp-01-schema` | [`work-packages/wp-03-backend-domain-services.md`](work-packages/wp-03-backend-domain-services.md) | Ready |
| `wp-04-accounting-ledger-engine` | General Ledger, Billing & Double-Entry Accounting Service | `feat/wp-04-accounting-ledger-engine` | `wp-01-schema`, `wp-03-backend-domain-services` | [`work-packages/wp-04-accounting-ledger-engine.md`](work-packages/wp-04-accounting-ledger-engine.md) | Ready |
| `wp-05-ai-intake-copilot` | Document OCR, Smart Payment Allocation & Natural Language Copilot | `feat/wp-05-ai-intake-copilot` | `wp-03-backend-domain-services`, `wp-04-accounting-ledger-engine` | [`work-packages/wp-05-ai-intake-copilot.md`](work-packages/wp-05-ai-intake-copilot.md) | Ready |
| `wp-06-web-frontend` | Responsive Nuxt 3 / Vue 3 / shadcn-vue UI & Management Dashboard | `feat/wp-06-web-frontend` | `wp-03-backend-domain-services`, `wp-04-accounting-ledger-engine` | [`work-packages/wp-06-web-frontend.md`](work-packages/wp-06-web-frontend.md) | Ready |
| `wp-07-verification-reconciliation` | End-to-End Financial Integrity & Data Reconciliation Suite | `feat/wp-07-verification-reconciliation` | `wp-02-data-migration`, `wp-04-accounting-ledger-engine` | [`work-packages/wp-07-verification-reconciliation.md`](work-packages/wp-07-verification-reconciliation.md) | Ready |

---

## 2. Work Package Specifications

---

### Work Package 1: Target PostgreSQL DDL & Migrations (`wp-01-schema`)

- **Package ID**: `wp-01-schema`
- **Title**: Target PostgreSQL Schema & Migration Scripts
- **Target Repo**: `visulate`
- **Suggested Branch**: `feat/wp-01-schema`
- **Design Document**: `docs/projects/property-management/02-designs/01-core-schema-tdd.md`
- **Standalone Spec**: `docs/projects/property-management/02-designs/work-packages/wp-01-schema.md`
- **Dependencies**: None
- **Scope Tags**: `["schema", "database", "postgis", "ddl"]`

#### Goal
Create deterministic database migration scripts establishing the clean, standalone `property_management` schema in PostgreSQL 16+ with PostGIS, strict foreign keys, CHECK constraints, automatic `updated_at` triggers, and zero legacy dependencies on public records (`PR_*`) or MLS tables.

#### Source Context
- **Source Tables**: `pdb22.RNTMGR2`: 32 operational tables: `RNT_USER_ROLES`, `RNT_PEOPLE`, `RNT_BUSINESS_UNITS`, `RNT_USERS`, `RNT_USER_ASSIGNMENTS`, `RNT_PEOPLE_BU`, `RNT_SECTION8_OFFICES`, `RNT_SECTION8_OFFICES_BU`, `RNT_DOC_TEMPLATES`, `RNT_PROPERTIES`, `RNT_PROPERTY_UNITS`, `RNT_PROPERTY_PHOTOS`, `RNT_PROPERTY_VALUE`, `RNT_PROPERTY_EXPENSES`, `RNT_EXPENSE_ITEMS`, `RNT_LOANS`, `RNT_TENANT`, `RNT_TENANCY_AGREEMENT`, `RNT_AGREEMENT_ACTIONS`, `RNT_LEADS`, `RNT_LEAD_ACTIONS`, `RNT_ACCOUNTS`, `RNT_ACCOUNT_PERIODS`, `RNT_PAYMENT_TYPES`, `RNT_PT_RULES`, `RNT_ACCOUNTS_RECEIVABLE`, `RNT_PAYMENTS`, `RNT_PAYMENT_ALLOCATIONS`, `RNT_ACCOUNTS_PAYABLE`, `RNT_SUPPLIERS_ALL`, `RNT_BU_SUPPLIERS`, `RNT_LEDGER_ENTRIES`.
- **Decoupling Rule**: `rnt_properties.prop_id` becomes a nullable `BIGINT` without a foreign key to `pr_properties`.

#### Exact Target Files to Create
1. `packages/database/migrations/001_initial_schema.sql`: Full DDL script defining all 32 operational tables, extensions, indexes, and triggers.
2. `packages/database/migrations/002_views.sql`: ANSI SQL views replacing legacy `(+)` outer joins (`v_active_tenancy_agreements`, `v_ar_aging`, `v_account_period_balances`).
3. `packages/database/src/migrate.ts`: Node.js migration runner script.
4. `packages/database/tests/schema_validation.test.ts`: Automated schema structural integrity tests.

#### Acceptance Criteria & Verification Commands
- [ ] PostGIS and pgcrypto extensions install successfully without errors.
- [ ] All 32 operational tables, primary keys, identity sequences, and foreign keys create cleanly.
- [ ] Automated verification command:
  ```bash
  npm --prefix packages/database test
  ```

---

### Work Package 2: Oracle to PostgreSQL Data Extraction & Migration Pipeline (`wp-02-data-migration`)

- **Package ID**: `wp-02-data-migration`
- **Title**: Oracle to PostgreSQL Data Extraction & Loading Pipeline
- **Target Repo**: `visulate`
- **Suggested Branch**: `feat/wp-02-data-migration`
- **Design Document**: `docs/projects/property-management/02-designs/data-migration-plan.md`
- **Standalone Spec**: `docs/projects/property-management/02-designs/work-packages/wp-02-data-migration.md`
- **Dependencies**: `["wp-01-schema"]`
- **Scope Tags**: `["data-migration", "etl", "python", "psycopg3"]`

#### Goal
Develop and execute a self-contained, native Python streaming ETL pipeline using `python-oracledb` in pure thin mode (zero Oracle Instant Client or C dependencies) and `psycopg3` direct memory `COPY` streaming to extract historical operational data from Oracle `pdb22.RNTMGR2` up to the cutoff date of December 31, 2025, stream into PostgreSQL, and synchronize all sequence counters.

#### Source Context
- Monolithic schema contains 497,076 rows (2.52 GB). Filtered operational tables contain ~70k–100k rows (< 450 MB).
- Tables to extract: All operational entities across Tiers 1–5 (`RNT_BUSINESS_UNITS`, `RNT_PEOPLE`, `RNT_USERS`, `RNT_USER_ROLES`, `RNT_USER_ASSIGNMENTS`, `RNT_PEOPLE_BU`, `RNT_SECTION8_OFFICES`, `RNT_SECTION8_OFFICES_BU`, `RNT_DOC_TEMPLATES`, `RNT_PROPERTIES`, `RNT_PROPERTY_UNITS`, `RNT_PROPERTY_PHOTOS`, `RNT_PROPERTY_VALUE`, `RNT_TENANT`, `RNT_LEADS`, `RNT_LEAD_ACTIONS`, `RNT_TENANCY_AGREEMENT`, `RNT_AGREEMENT_ACTIONS`, `RNT_PROPERTY_EXPENSES`, `RNT_LOANS`, `RNT_ACCOUNTS`, `RNT_ACCOUNT_PERIODS`, `RNT_PAYMENT_TYPES`, `RNT_PT_RULES`, `RNT_ACCOUNTS_RECEIVABLE`, `RNT_PAYMENTS`, `RNT_PAYMENT_ALLOCATIONS`, `RNT_SUPPLIERS_ALL`, `RNT_BU_SUPPLIERS`, `RNT_ACCOUNTS_PAYABLE`, `RNT_EXPENSE_ITEMS`, `RNT_LEDGER_ENTRIES`).
- Spatial conversion: `SDO_UTIL.TO_WKTGEOMETRY` prepended with `SRID=4326;` converts Oracle `SDO_GEOMETRY` directly into PostGIS EWKT for `rnt_properties.geom`.
- Cutoff filtering: Transactions up to `2025-12-31 23:59:59` to maintain pre-Yardi baseline.

#### Exact Target Files to Create
1. `tools/migration/etl_pipeline.py`: Python streaming ETL tool utilizing `python-oracledb` (thin mode) and `psycopg3` `cursor.copy()` memory buffers with post-streaming balance reconciliations.
2. `tools/migration/config.py`: Parameterized configuration parser loading Oracle and PostgreSQL credentials from environment variables / `.env`.
3. `tools/migration/requirements.txt`: Python dependencies (`python-oracledb>=2.0.0`, `psycopg[binary]>=3.1.0`, `python-dotenv>=1.0.0`).
4. `tools/migration/reset-sequences.sql`: Dynamic PL/pgSQL script updating all PostgreSQL identity sequences to `MAX(id) + 1` across `current_schema()`.
5. `tools/migration/run-dryrun.sh`: Automated multi-environment dry-run execution script (`testbed` vs `production`).

#### Acceptance Criteria & Verification Commands
- [ ] Pipeline executes with pure Python thin mode without requiring Oracle Instant Client or C libraries.
- [ ] Memory buffer streaming achieves > 10,000 rows/second directly into PostgreSQL without writing staging files to disk.
- [ ] Spatial geometries in `rnt_properties` convert cleanly to PostGIS `geometry(Point, 4326)`.
- [ ] Data loads cleanly with zero constraint violations under `session_replication_role = 'replica'`.
- [ ] Post-streaming AR/AP status and payment allocated amounts reconcile accurately against allocations and ledger journals.
- [ ] All identity sequences reset to `MAX(id) + 1` dynamically.
- [ ] Automated verification command:
  ```bash
  python tools/migration/etl_pipeline.py --env=testbed && psql -d property_mgmt_test -f tools/migration/reset-sequences.sql
  ```

---

### Work Package 3: Backend Domain Services & REST APIs (`wp-03-backend-domain-services`)

- **Package ID**: `wp-03-backend-domain-services`
- **Title**: Core Property, Tenancy & Contact Backend Services
- **Target Repo**: `visulate`
- **Suggested Branch**: `feat/wp-03-backend-domain-services`
- **Design Document**: `docs/projects/property-management/02-designs/02-application-services-tdd.md`
- **Standalone Spec**: `docs/projects/property-management/02-designs/work-packages/wp-03-backend-domain-services.md`
- **Dependencies**: `["wp-01-schema"]`
- **Scope Tags**: `["backend", "domain-services", "api", "typescript"]`

#### Goal
Implement the core TypeScript backend service layer for Properties, Units, Tenants, Leases, and Contacts, replacing legacy PHP classes (`rnt_properties.class.php`, `rnt_tenants.class.php`, `rnt_agreement.class.php`) and providing secure, authenticated REST APIs.

#### Source Context
- Legacy PHP files: `code/php/classes/database/rnt_properties.class.php`, `rnt_tenants.class.php`, `rnt_agreement.class.php`.
- Key entities: Properties (with PostGIS geocoding), Units (amenities, status transitions), Tenants, Leases.

#### Exact Target Files to Create
1. `packages/server/src/domains/properties/property.service.ts`: Property and Unit CRUD, occupancy tracking, PostGIS queries.
2. `packages/server/src/domains/tenancy/tenancy.service.ts`: Tenant lifecycle, agreement creation, renewals, action logging.
3. `packages/server/src/domains/contacts/contact.service.ts`: People directory and business unit management.
4. `packages/server/src/api/routes/property.router.ts`: Fastify/Express REST endpoints.
5. `packages/server/src/api/routes/tenancy.router.ts`: Tenancy agreement REST endpoints.
6. `packages/server/tests/property.service.test.ts`: Unit and integration test suite.

#### Acceptance Criteria & Verification Commands
- [ ] 100% test coverage for Property and Agreement creation workflows.
- [ ] Optimistic concurrency control verifies `updated_at` timestamps on update.
- [ ] Automated verification command:
  ```bash
  npm --prefix packages/server test -- --grep "Property|Tenancy"
  ```

---

### Work Package 4: General Ledger, Billing & Double-Entry Accounting Engine (`wp-04-accounting-ledger-engine`)

- **Package ID**: `wp-04-accounting-ledger-engine`
- **Title**: General Ledger, Billing & Double-Entry Accounting Service
- **Target Repo**: `visulate`
- **Suggested Branch**: `feat/wp-04-accounting-ledger-engine`
- **Design Document**: `docs/projects/property-management/02-designs/02-application-services-tdd.md`
- **Standalone Spec**: `docs/projects/property-management/02-designs/work-packages/wp-04-accounting-ledger-engine.md`
- **Dependencies**: `["wp-01-schema", "wp-03-backend-domain-services"]`
- **Scope Tags**: `["accounting", "ledger", "billing", "plsql-disposition"]`

#### Goal
Implement the financial accounting engine in the service tier, completely deconstructing and replacing legacy Oracle PL/SQL packages `RNT_LEDGER_PKG`, `RNT_ACCOUNTS_RECEIVABLE_PKG`, and `RNT_PAYMENTS_PKG`. Enforces double-entry debit/credit balancing, automated rent roll generation, and payment allocation.

#### Source Context
- Legacy packages: `RNT_LEDGER_PKG` (1,187 LOC), `RNT_ACCOUNTS_RECEIVABLE_PKG` (1,070 LOC), `RNT_PAYMENTS_PKG` (420 LOC).
- Core tables: `rnt_accounts`, `rnt_payment_types`, `rnt_pt_rules`, `rnt_accounts_receivable`, `rnt_payments`, `rnt_payment_allocations`, `rnt_ledger_entries`.

#### Exact Target Files to Create
1. `packages/server/src/domains/accounting/accounting.service.ts`: Atomic journal entries, debit/credit validation, trial balance calculation.
2. `packages/server/src/domains/billing/billing.service.ts`: Monthly rent roll batching, fee adjustments, AR aging.
3. `packages/server/src/domains/payments/payment.service.ts`: Payment recording and FIFO allocation against open AR items.
4. `packages/server/src/domains/payables/payable.service.ts`: Vendor bill recording and contractor disbursement tracking.
5. `packages/server/src/api/routes/accounting.router.ts`: REST endpoints for ledger journals, trial balance, and AR/AP operations.
6. `packages/server/tests/accounting_engine.test.ts`: Rigorous financial integrity tests (debit == credit, allocation limits).

#### Acceptance Criteria & Verification Commands
- [ ] All journal postings guarantee Debit == Credit and reject unbalanced entries.
- [ ] Payment allocation correctly updates AR `amount_paid` and status (`PARTIAL` / `PAID`).
- [ ] Automated verification command:
  ```bash
  npm --prefix packages/server test -- --grep "Accounting|Billing|Payment"
  ```

---

### Work Package 5: Workload-Reducing AI Assistant Engine (`wp-05-ai-intake-copilot`)

- **Package ID**: `wp-05-ai-intake-copilot`
- **Title**: Document OCR, Smart Payment Allocation & Natural Language Copilot
- **Target Repo**: `visulate`
- **Suggested Branch**: `feat/wp-05-ai-intake-copilot`
- **Design Document**: `docs/projects/property-management/02-designs/02-application-services-tdd.md`
- **Standalone Spec**: `docs/projects/property-management/02-designs/work-packages/wp-05-ai-intake-copilot.md`
- **Dependencies**: `["wp-03-backend-domain-services", "wp-04-accounting-ledger-engine"]`
- **Scope Tags**: `["ai", "ocr", "multimodal", "copilot", "yardi-ingest"]`

#### Goal
Build the embedded AI capabilities specified in Section 3.4 of the SOW:
1. Intelligent Intake & OCR for vendor bills and handwritten receipts.
2. Smart payment matching against bank/Zelle feeds.
3. Natural Language Transaction Copilot ("Daryl Terrace paid their rent on the 23rd" -> interactive confirmation card -> database commit).
4. Yardi 2026–2027 interim report parser for historical backfill.

#### Exact Target Files to Create
1. `packages/server/src/ai/document_intake.service.ts`: Multimodal vision extractor for bills and invoices.
2. `packages/server/src/ai/payment_matcher.service.ts`: Fuzzy matcher for Zelle/bank transactions.
3. `packages/server/src/ai/transaction_copilot.service.ts`: NLP intent parser for conversational rent logging.
4. `packages/server/src/ai/yardi_ingestion.service.ts`: Parser for Yardi rent roll and ledger exports (2026-2027 backfill).
5. `packages/server/tests/ai_copilot.test.ts`: Evaluation test suite against sample documents and prompts.

#### Acceptance Criteria & Verification Commands
- [ ] "Daryl Terrace paid their rent on the 23rd" parses to correct property, active lease, and rent amount.
- [ ] Yardi ingestion parses sample CSV and outputs matching draft AR and payment records.
- [ ] Automated verification command:
  ```bash
  npm --prefix packages/server test -- --grep "AI"
  ```

---

### Work Package 6: Modern Web Application Frontend (`wp-06-web-frontend`)

- **Package ID**: `wp-06-web-frontend`
- **Title**: Responsive Nuxt 3 / Vue 3 / shadcn-vue UI & Management Dashboard
- **Target Repo**: `visulate`
- **Suggested Branch**: `feat/wp-06-web-frontend`
- **Design Document**: `docs/projects/property-management/02-designs/02-application-services-tdd.md`
- **Standalone Spec**: `docs/projects/property-management/02-designs/work-packages/wp-06-web-frontend.md`
- **Dependencies**: `["wp-03-backend-domain-services", "wp-04-accounting-ledger-engine"]`
- **Scope Tags**: `["frontend", "ui", "vue", "nuxt", "tailwind", "shadcn-vue"]`

#### Goal
Build the modern, responsive web application in **Nuxt 3** (Vue 3, `<script setup lang="ts">`) with Tailwind CSS and shadcn-vue, replacing all legacy Smarty templates (`code/php/templates/`) and dynamic Oracle CMS menu tables (`RNT_MENUS*`) with typed, reactive, modular component screens and embedded AI assistants.

#### Source Context
- Legacy templates: 179 Smarty `.tpl` files in `code/php/templates/`.
- Dynamic menus in Oracle `RNT_MENUS` replaced with modern static layout, Pinia state, and RBAC navigation.

#### Exact Target Files to Create
1. `packages/web/nuxt.config.ts`: Nuxt 3 configuration enabling Tailwind CSS, Pinia, shadcn-vue aliases, and runtime API proxies.
2. `packages/web/layouts/default.vue`: Core application layout with responsive navigation sidebar and business unit context switcher.
3. `packages/web/pages/properties/index.vue`: Property list grid/table view with occupancy status badges and PostGIS map toggle.
4. `packages/web/pages/properties/[id].vue`: Property detail view with unit matrix, lease rollups, and financial metrics.
5. `packages/web/pages/billing/index.vue`: Rent roll batch generator, AR aging summary cards, and invoice allocation table.
6. `packages/web/pages/accounting/trial-balance.vue`: Interactive General Ledger trial balance with debit/credit balance verification.
7. `packages/web/components/ai/TransactionCopilotModal.vue`: Modal dialog powered by shadcn-vue for natural language rent/expense logging.
8. `packages/web/components/ai/BillIntakeDropzone.vue`: Drag-and-drop OCR bill intake with structured field review form.
9. `packages/web/stores/copilot.ts`: Pinia store for copilot transactions and parsing state.
10. `packages/web/tests/frontend.spec.ts`: Vitest UI component test suite with `@vue/test-utils`.

#### Acceptance Criteria & Verification Commands
- [ ] Nuxt 3 production build completes cleanly.
- [ ] Type checks pass with zero Vue SFC compilation errors (`npx nuxi typecheck`).
- [ ] Responsive navigation functions seamlessly on mobile and desktop without server roundtrips.
- [ ] Automated verification command:
  ```bash
  npm --prefix packages/web run build && npm --prefix packages/web test
  ```

---

### Work Package 7: Automated Reconciliation & Financial Parity (`wp-07-verification-reconciliation`)

- **Package ID**: `wp-07-verification-reconciliation`
- **Title**: End-to-End Financial Integrity & Data Reconciliation Suite
- **Target Repo**: `visulate`
- **Suggested Branch**: `feat/wp-07-verification-reconciliation`
- **Design Document**: `docs/projects/property-management/02-designs/data-migration-plan.md`
- **Standalone Spec**: `docs/projects/property-management/02-designs/work-packages/wp-07-verification-reconciliation.md`
- **Dependencies**: `["wp-02-data-migration", "wp-04-accounting-ledger-engine"]`
- **Scope Tags**: `["qa", "reconciliation", "audit", "financial-parity"]`

#### Goal
Create deterministic data reconciliation tooling that connects simultaneously to Oracle `pdb22` and target PostgreSQL to verify 100% row count parity, zero trial balance discrepancies, and exact payment allocation reconciliation.

#### Exact Target Files to Create
1. `tools/reconciliation/reconcile_row_counts.ts`: Automated table-by-table record count comparator.
2. `tools/reconciliation/reconcile_ledger.ts`: General Ledger debits/credits trial balance validator.
3. `tools/reconciliation/reconcile_tenant_balances.ts`: Individual tenant AR balance verifier.
4. `tools/reconciliation/generate_audit_report.ts`: Markdown audit report generator.
5. `tools/reconciliation/run_all_checks.ts`: Unified test runner.

#### Acceptance Criteria & Verification Commands
- [ ] Total trial balance difference between debits and credits is exactly `$0.00`.
- [ ] 100% of migrated Oracle operational rows accounted for.
- [ ] Automated verification command:
  ```bash
  npx ts-node tools/reconciliation/run_all_checks.ts --source=pdb22 --target=property_mgmt
  ```
