---
title: "Technical Design Document: Application Services, PL/SQL Disposition & AI Helpers"
status: draft
phase: design
slug: property-management
doc_type: tdd
subsystem: application-services
source_db: pdb22
source_schema: RNTMGR2
target_db: postgres
target_stack: TypeScript / Node.js (or Python FastAPI) + Nuxt 3 / Vue 3 / shadcn-vue
---

# Technical Design Document: Application Services, PL/SQL Disposition & AI Helpers

## 1. Context & Architecture Overview

The legacy `visulate` application combined procedural PHP 5 classes (`code/php/classes/database/`), Smarty HTML templates, and 148 Oracle PL/SQL packages/bodies in schema `RNTMGR2`. 

This Technical Design Document defines the modern target application architecture:
1. **Modular Service Tier**: Bounded-context domain services managing business logic and database interactions with transactional safety.
2. **PL/SQL Disposition Strategy**: Systematic migration of procedural PL/SQL packages (`RNT_LEDGER_PKG`, `RNT_ACCOUNTS_RECEIVABLE_PKG`, `RNT_PAYMENTS_PKG`) into domain services, and retirement of database-level network/mail calls (`UTL_SMTP`, `UTL_HTTP`).
3. **RESTful API Contracts**: Standardized JSON endpoints with input validation and optimistic locking via `updated_at`.
4. **Workload-Reducing AI Assistant Engine**: Purpose-built AI modules for document intake, smart payment matching, natural language transaction processing, and legacy Yardi 2026–2027 data backfill.
5. **Modern Client Tier**: Responsive Nuxt 3 / Vue 3 / shadcn-vue frontend replacing all legacy PHP scripts and database-driven menus.

---

## 2. High-Level System Architecture

```
                          +--------------------------------------------------+
                          |                   CLIENT TIER                    |
                          |      Nuxt 3 / Vue 3 / Tailwind + shadcn-vue      |
                          |   (Dashboard, Leases, Invoicing, AI Copilot)     |
                          +-------------------------+------------------------+
                                                    |
                                                    | HTTPS / JSON / JWT
                                                    v
+---------------------------------------------------------------------------------------------------+
|                                     API & DOMAIN SERVICE TIER                                     |
|                                                                                                   |
|  +--------------------+  +----------------------+  +---------------------+  +------------------+  |
|  | Properties & Units |  | Tenancy & Agreements |  | Billing & AR        |  | Accounts Payable |  |
|  | Service            |  | Service              |  | Service             |  | Service          |  |
|  +--------------------+  +----------------------+  +---------------------+  +------------------+  |
|                                                                                                   |
|  +----------------------------------------------+  +-------------------------------------------+  |
|  | General Ledger & Accounting Service          |  | Background Worker (BullMQ / Async Queue)  |  |
|  | - Double-Entry Engine                        |  | - Email & Webhook Notifications           |  |
|  | - Payment Allocations & Trial Balance        |  | - S3 Document Archival                    |  |
|  +----------------------------------------------+  +-------------------------------------------+  |
|                                                                                                   |
|  +---------------------------------------------------------------------------------------------+  |
|  |                                  AI ASSISTANT ENGINE                                        |  |
|  |  [Document Intake OCR]       [Payment Matching]      [NL Transaction Copilot] [Yardi Ingest]|  |
|  +---------------------------------------------------------------------------------------------+  |
+---------------------------------------------------+-----------------------------------------------+
                                                    |
                                                    | PostgreSQL Connection Pool (Prisma / Drizzle)
                                                    v
                          +--------------------------------------------------+
                          |             POSTGRESQL 16+ DATABASE              |
                          |                  (with PostGIS)                  |
                          |      Strict FKs, CHECK constraints, Clock Ts     |
                          +--------------------------------------------------+
```

---

## 3. PL/SQL Disposition & Package Deconstruction

The deterministic database assessment identified 148 PL/SQL packages/bodies. The migration disposes of them through three distinct strategies:

| Oracle PL/SQL Package | Lines of Code | Original Responsibility | Target Disposition Strategy | Target Location |
| :--- | ---: | :--- | :--- | :--- |
| `RNT_LEDGER_PKG` | 1,187 | General ledger journal creation, trial balance calculation, posting rules lookup, debit/credit balancing | **Move to Service Layer** | `AccountingService.recordLedgerEntry()` in backend domain service with explicit atomic DB transactions |
| `RNT_ACCOUNTS_RECEIVABLE_PKG` | 1,070 | Rent roll generation, fee assessment, discount adjustments, invoice aging | **Move to Service Layer** | `BillingService.generateMonthlyRentRoll()` & `BillingService.assessLateFees()` |
| `RNT_PAYMENTS_PKG` | 420 | Payment receipt, allocation against open AR records, balance calculation | **Move to Service Layer** | `PaymentService.allocatePayment()` with row-locking (`FOR UPDATE`) |
| `RNT_ACCOUNTS_PAYABLE_PKG` | 594 | Supplier bill recording, payment disbursements, check printing logic | **Move to Service Layer** | `PayablesService.recordBill()` & `PayablesService.disbursePayment()` |
| `RNT_PROPERTIES_PKG` | 818 | Property CRUD, address validation, unit rollups | **Retire & Replace with ORM** | Standard repository layer (`PropertyRepository`) |
| `RNT_TENANCY_AGREEMENT_PKG` | 424 | Lease CRUD, expiration checks, renewal calculation | **Move to Service Layer** | `TenancyService.createLease()` & `TenancyService.renewLease()` |
| `RNT_USER_MAIL_PKG` & `SEND_MAIL` | 205 | Synchronous database email dispatch via `UTL_SMTP` | **Retire from DB** | Modern asynchronous background worker (BullMQ) + SendGrid / AWS SES API |
| `RNT_SUMMARY_PKG` | 455 | Hierarchical rollup queries with `CONNECT BY` | **Rewrite to ANSI SQL** | PostgreSQL `WITH RECURSIVE` CTE in analytical repository |
| Dynamic Menu Packages (`RNT_MENUS_*`) | 350 | Dynamic database-driven menu hierarchy | **Retire completely** | Statically declared client-side routes in Nuxt 3 navigation components |
| CRUD helper packages (60+ packages) | ~18,000 | Automated table wrappers generated by legacy tools | **Retire completely** | Replaced by clean TypeScript domain models and PostgreSQL DDL |

### 3.1 Detailed Deconstruction: `RNT_LEDGER_PKG` -> `AccountingService`
In legacy Oracle, `RNT_LEDGER_PKG.GEN_LEDGER_ENTRY` queried `RNT_PT_RULES` to determine debit and credit accounts, then inserted ledger rows.
In the modernized architecture, `AccountingService` queries `rnt_pt_rules` using `business_id`, `payment_type_id`, and `transaction_type` (`APS`, `APP`, `ARS`, `ARP`, `DEP`), verifying that debit and credit accounts are distinct:

```typescript
export interface JournalEntryInput {
  businessId: bigint;
  entryDate: Date;
  description: string;
  amount: number;
  paymentTypeId: bigint;
  transactionType: 'APS' | 'APP' | 'ARS' | 'ARP' | 'DEP';
  propertyId?: bigint;
  arId?: bigint;
  apId?: bigint;
  payAllocId?: bigint;
}

export class AccountingService {
  constructor(private db: DatabasePool) {}

  /**
   * Atomic double-entry ledger posting.
   * Enforces: Debit Account != Credit Account, Amount > 0, balanced entries.
   */
  async recordJournalEntry(tx: Transaction, entry: JournalEntryInput): Promise<bigint> {
    // 1. Fetch posting rules matching business unit, payment type, and transaction type
    const rule = await tx.one(
      `SELECT debit_account, credit_account 
       FROM rnt_pt_rules 
       WHERE business_id = $1 AND payment_type_id = $2 AND transaction_type = $3`,
      [entry.businessId, entry.paymentTypeId, entry.transactionType]
    );

    // 2. Validate accounts
    if (rule.debit_account === rule.credit_account) {
      throw new DomainError('Debit and Credit accounts must be distinct');
    }

    // 3. Insert General Ledger record
    const result = await tx.one(
      `INSERT INTO rnt_ledger_entries (
        business_id, entry_date, description, debit_account, credit_account,
        amount, payment_type_id, property_id, ar_id, ap_id, pay_alloc_id
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
      RETURNING ledger_id`,
      [
        entry.businessId,
        entry.entryDate,
        entry.description,
        rule.debit_account,
        rule.credit_account,
        entry.amount,
        entry.paymentTypeId,
        entry.propertyId ?? null,
        entry.arId ?? null,
        entry.apId ?? null,
        entry.payAllocId ?? null
      ]
    );

    return result.ledger_id;
  }
}
```

### 3.2 Detailed Deconstruction: `RNT_PAYMENTS_PKG` -> `PaymentService`
Payment allocation in legacy PL/SQL used cursor loops over open receivables. In the target service, it executes within an atomic transaction with row locking (`SELECT FOR UPDATE`), seamlessly matching tenant AR charges with or without an active lease agreement:

```typescript
export class PaymentService {
  constructor(
    private db: DatabasePool,
    private accountingService: AccountingService
  ) {}

  /**
   * Allocates a payment against open accounts receivable records in FIFO order.
   */
  async allocatePayment(paymentId: bigint, customAllocations?: Map<bigint, number>): Promise<void> {
    await this.db.transaction(async (tx) => {
      // Lock payment record and fetch tenant business association
      const payment = await tx.one(
        `SELECT p.payment_id, p.tenant_id, p.amount, p.allocated_amount, t.business_id 
         FROM rnt_payments p
         JOIN rnt_tenant t ON p.tenant_id = t.tenant_id
         WHERE p.payment_id = $1 FOR UPDATE`,
        [paymentId]
      );

      let unallocated = Number(payment.amount) - Number(payment.allocated_amount);
      if (unallocated <= 0) return;

      // Fetch open AR records for this tenant (with or without direct lease agreement link)
      const openArItems = await tx.manyOrNone(
        `SELECT ar.ar_id, ar.amount, ar.amount_paid, (ar.amount - ar.amount_paid) AS balance,
                ar.business_id, ar.payment_type_id
         FROM rnt_accounts_receivable ar
         LEFT JOIN rnt_tenancy_agreement ta ON ar.agreement_id = ta.agreement_id
         WHERE COALESCE(ar.tenant_id, ta.tenant_id) = $1 AND ar.status IN ('OPEN', 'PARTIAL')
         ORDER BY ar.due_date ASC FOR UPDATE`,
        [payment.tenant_id]
      );

      for (const ar of openArItems) {
        if (unallocated <= 0) break;
        const balance = Number(ar.balance);
        const applyAmount = Math.min(unallocated, balance);

        // Record allocation
        const alloc = await tx.one(
          `INSERT INTO rnt_payment_allocations (payment_id, ar_id, amount)
           VALUES ($1, $2, $3) RETURNING pay_alloc_id`,
          [paymentId, ar.ar_id, applyAmount]
        );

        // Update AR balance
        const newPaid = Number(ar.amount_paid) + applyAmount;
        const newStatus = newPaid >= Number(ar.amount) ? 'PAID' : 'PARTIAL';
        await tx.none(
          `UPDATE rnt_accounts_receivable 
           SET amount_paid = $1, status = $2, updated_at = clock_timestamp() 
           WHERE ar_id = $3`,
          [newPaid, newStatus, ar.ar_id]
        );

        // Generate matching General Ledger entry (ARP: Accounts Receivable Payment)
        await this.accountingService.recordJournalEntry(tx, {
          businessId: ar.business_id,
          entryDate: new Date(),
          description: `Payment allocation for AR #${ar.ar_id}`,
          amount: applyAmount,
          paymentTypeId: ar.payment_type_id,
          transactionType: 'ARP',
          payAllocId: alloc.pay_alloc_id,
          arId: ar.ar_id
        });

        unallocated -= applyAmount;
      }

      // Update payment record allocated_amount
      await tx.none(
        `UPDATE rnt_payments 
         SET allocated_amount = amount - $1, updated_at = clock_timestamp() 
         WHERE payment_id = $2`,
        [unallocated, paymentId]
      );
    });
  }
}
```

---

## 4. RESTful API Interface Specifications

All endpoints use standard JSON payloads, require Bearer JWT authentication, and enforce business unit tenancy scoping.

### 4.1 Property & Unit Endpoints
- `GET /api/v1/properties`: Lists properties with unit counts, occupancy rates, and thumbnail URLs.
- `POST /api/v1/properties`: Creates a new property with geocoded PostGIS point.
- `GET /api/v1/properties/:id`: Detailed view including unit list, financial summary, and photo gallery.
- `PUT /api/v1/properties/:id`: Updates property metadata (supports optimistic lock check via `updated_at`).
- `GET /api/v1/properties/:id/units`: Returns all units for a given property with occupancy status.
- `POST /api/v1/properties/:id/units`: Adds a rentable unit.

### 4.2 Tenancy & Lease Endpoints
- `GET /api/v1/agreements/active`: Returns all current lease agreements with tenant details.
- `POST /api/v1/agreements`: Creates a new tenancy agreement and marks unit as occupied.
- `POST /api/v1/agreements/:id/actions`: Logs an agreement event (renewal notice, inspection, violation).
- `GET /api/v1/tenants`: Tenant directory with contact details and active lease references.

### 4.3 Billing, Payments & Ledger Endpoints
- `POST /api/v1/billing/generate-rent-roll`: Batch creates monthly AR records for active leases.
- `GET /api/v1/billing/ar/aging`: Returns aged receivables (Current, 1-30, 31-60, 61-90, 90+ days) scoped by business unit.
- `POST /api/v1/payments`: Records a payment receipt and triggers automated allocation.
- `GET /api/v1/ledger/trial-balance`: Calculates debit and credit balances by account period.
- `GET /api/v1/ledger/property/:id`: Returns property-level Profit & Loss statement.

---

## 5. Workload-Reducing AI Helpers Specification

The application integrates four purpose-built AI helpers:

### 5.1 AI Helper 1: Document Intake & Bill OCR
- **Capability**: Processes uploaded PDFs or images of vendor bills, utility invoices, and hand-annotated receipts.
- **Implementation**: Multimodal vision model (e.g. Gemini 1.5 Pro) with structured schema output.
- **Workflow**:
  1. User uploads bill scan/photo.
  2. Worker invokes AI extractor with schema: `{ supplierName: string, invoiceNumber: string, invoiceDate: string, dueDate: string, totalAmount: number, propertyAddress: string, lineItems: Array<{ description: string, amount: number }> }`.
  3. System matches `supplierName` against `rnt_suppliers_all` and `propertyAddress` against `rnt_properties`.
  4. Presents pre-populated draft Accounts Payable record in UI for 1-click user approval.

### 5.2 AI Helper 2: Smart Payment Matching & Allocation Recommender
- **Capability**: Analyzes raw bank statement lines, Zelle notifications, and wire records.
- **Implementation**: Embedding + fuzzy text matching against tenant names, phone numbers, and lease rent amounts.
- **Workflow**:
  1. Intake parses notification: `"Zelle from JANE DOE memo: Rent unit 2B - $1,450.00"`.
  2. Matches tenant `"JANE DOE"` -> Tenant ID `104` with monthly rent `$1,450.00` on Unit 2B.
  3. Prepares atomic payment insertion and allocation payload.
  4. Flags discrepancies (e.g. partial payment of `$1,200.00` vs `$1,450.00` balance) with recommended ledger split.

### 5.3 AI Helper 3: Natural Language Transaction Copilot ("Chat-to-Transaction")
- **Capability**: Conversational interface enabling operators to log rent receipts or expenses via natural language.
- **Example Prompt**: *"Daryl Terrace paid their rent on the 23rd"*
- **Resolution Strategy**:
  1. **Entity Extraction**: Resolves `"Daryl Terrace"` to Property ID `42` (`2354 Daryl Terrace`), finds active lease for Unit 1.
  2. **Temporal Resolution**: Resolves `"on the 23rd"` relative to current system date to `2026-11-23`.
  3. **Confirmation Dialog**: Generates structured interactive card in UI:
     - **Tenant**: Robert Johnson
     - **Unit**: 2354 Daryl Terrace
     - **Date**: Nov 23, 2026
     - **Amount**: $1,650.00 (Standard Monthly Rent)
  4. **Commit**: Upon user click of **[Confirm & Post]**, calls `PaymentService.allocatePayment()` and displays confirmed ledger entry.

### 5.4 AI Helper 4: Legacy Yardi 2026–2027 Onboarding Ingestion
- **Capability**: Ingests monthly rent roll reports, general ledger exports, and tenant ledger statements from Yardi (used during the interim parallel period).
- **Implementation**: Structured document parser mapping Yardi column formats to target PostgreSQL entities.
- **Backfill Logic**:
  1. Accepts CSV or PDF export of Yardi tenant ledger.
  2. Validates tenant identifiers against `rnt_tenant.people_id`.
  3. Synthesizes retroactive AR records, payment allocations, and general ledger journal entries for calendar years 2026 and 2027.
  4. Produces deterministic reconciliation report showing exact match with Yardi closing balances.

---

## 6. Security, Authentication & Multi-Tenancy

1. **Authentication**: Stateless Bearer JWT tokens signed with RS256 or HS256 secret. Passwords hashed using `bcrypt` (work factor 12) or `argon2id`. Users imported from legacy Oracle with `requires_password_reset = true` are forced into the password reset flow on first login before receiving an active session token.
2. **Multi-Tenancy (Business Unit Scoping)**:
   - All queries enforce `WHERE business_id = :current_user_business_id`.
   - PostgreSQL Row Level Security (RLS) can be optionally enabled on tables referencing `business_id` as defense-in-depth:
     ```sql
     ALTER TABLE rnt_properties ENABLE ROW LEVEL SECURITY;
     CREATE POLICY property_isolation_policy ON rnt_properties
       USING (business_id = NULLIF(current_setting('app.current_business_id', true), '')::bigint);
     ```
3. **Role-Based Access Control (RBAC)**:
   - `ADMIN`: Full access to business units, chart of accounts, users, and audit logs.
   - `PROPERTY_MANAGER`: Full access to properties, units, tenants, leases, and AR/AP operations.
   - `ACCOUNTANT`: Full access to GL, trial balances, payment allocations, and financial reporting.
   - `VIEWER`: Read-only access to property lists and tenant directories.

---

## 7. Automated Testing & Verification Strategy

1. **Unit Tests**:
   - `AccountingServiceTest`: Verify that every ledger posting generates matching debits and credits, queries `rnt_pt_rules` with `business_id`, `payment_type_id`, and `transaction_type`, and throws on unbalanced or identical debit/credit inputs.
   - `PaymentServiceTest`: Test FIFO allocation logic, partial payment handling, and overpayment credits across all tenant AR charges.
2. **Integration Tests**:
   - End-to-end API lifecycle test: Create Business Unit -> Create Property & Unit -> Create Tenant & Lease -> Generate AR Rent Roll -> Post Payment & Allocation -> Verify GL Trial Balance = 0.
3. **AI Helper Evals**:
   - Gold-standard test suite of 25 varied invoice images and 25 payment memo text snippets to verify extraction precision > 98%.
