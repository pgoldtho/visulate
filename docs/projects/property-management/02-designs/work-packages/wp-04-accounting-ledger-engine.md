---
id: wp-04-accounting-ledger-engine
title: "Work Package 04: General Ledger, Billing & Double-Entry Accounting Service"
status: pending
phase: design
slug: property-management
target_repo: visulate
branch: feat/wp-04-accounting-ledger-engine
design_doc: docs/projects/property-management/02-designs/02-application-services-tdd.md
dependencies:
  - wp-01-schema
  - wp-03-backend-domain-services
scope:
  - accounting
  - ledger
  - billing
  - plsql-disposition
---

# Work Package 04: General Ledger, Billing & Double-Entry Accounting Service

## 1. Objective & Deliverables Overview
Deconstruct and replace legacy Oracle PL/SQL packages `RNT_LEDGER_PKG` (1,187 LOC), `RNT_ACCOUNTS_RECEIVABLE_PKG` (1,070 LOC), and `RNT_PAYMENTS_PKG` (420 LOC). Implement the TypeScript double-entry accounting engine, monthly rent roll generator, payment allocation FIFO engine, and accounts payable bill manager.

### Key Target Files to Create:
1. `packages/server/src/domains/accounting/accounting.service.ts`: Atomic journal entries, debit/credit balancing validation, trial balance calculation.
2. `packages/server/src/domains/billing/billing.service.ts`: Monthly rent roll batching, fee adjustments, and AR aging calculations.
3. `packages/server/src/domains/payments/payment.service.ts`: Payment recording and FIFO allocation against open AR records with row-locking (`FOR UPDATE`).
4. `packages/server/src/domains/payables/payable.service.ts`: Supplier invoice recording and contractor disbursement tracking.
5. `packages/server/src/api/routes/accounting.router.ts`: REST endpoints for ledger journals, trial balance, and AR/AP operations.
6. `packages/server/tests/accounting_engine.test.ts`: Automated financial integrity and double-entry balancing test suite.

---

## 2. PL/SQL Package Deconstruction & Rules
- **`RNT_LEDGER_PKG`**:
  - Legacy `GEN_LEDGER_ENTRY` queried `RNT_PT_RULES` for debit and credit account IDs and inserted into `RNT_LEDGER_ENTRIES`.
  - Target: `AccountingService.recordJournalEntry()` validates `debitAccount != creditAccount`, amount > 0, and commits inside an atomic transaction.
- **`RNT_ACCOUNTS_RECEIVABLE_PKG`**:
  - Legacy generated monthly rent charges for all active leases.
  - Target: `BillingService.generateMonthlyRentRoll(businessId, targetMonth)` queries active leases, generates `rnt_accounts_receivable` entries, and creates matching ledger entries.
- **`RNT_PAYMENTS_PKG`**:
  - Legacy allocated payment against open AR charges.
  - Target: `PaymentService.allocatePayment()` locks the payment and matching open AR rows (`SELECT ... FOR UPDATE`), allocates payment amounts in FIFO order of due date, updates `ar.amount_paid` and `ar.status` (`OPEN`, `PARTIAL`, `PAID`), and logs `rnt_payment_allocations` records.

---

## 3. Core Implementation Contracts & Logic

### 3.1 Accounting Service Contract
```typescript
export interface JournalEntryInput {
  businessId: bigint;
  entryDate: string;
  paymentTypeId: bigint;
  amount: number;
  propertyId?: bigint;
  arId?: bigint;
  apId?: bigint;
  payAllocId?: bigint;
}

export interface PaymentAllocationResult {
  paymentId: bigint;
  allocatedAmount: number;
  remainingUnallocated: number;
  allocations: Array<{
    payAllocId: bigint;
    arId: bigint;
    allocatedAmount: number;
    newArStatus: 'OPEN' | 'PARTIAL' | 'PAID';
  }>;
}
```

### 3.2 Trial Balance Invariant
```sql
-- Trial balance must evaluate to exactly 0.00 across all accounts
SELECT 
  sum(CASE WHEN a.account_type IN ('ASSET', 'EXPENSE') THEN l.amount ELSE -l.amount END) AS net_balance
FROM rnt_ledger_entries l
JOIN rnt_accounts a ON l.debit_account = a.account_id
WHERE l.business_id = :businessId;
```

---

## 4. Acceptance Criteria & Automated Verification Commands
1. [ ] Double-entry engine rejects unbalanced postings or postings where `debit_account == credit_account`.
2. [ ] Payment allocation correctly handles partial payments, full payments, and multi-invoice allocations.
3. [ ] Monthly rent roll batching creates exact AR charges without duplicate entries for the same month.
4. [ ] Automated test suite execution:
   ```bash
   npm --prefix packages/server test -- --grep "Accounting|Billing|Payment"
   ```
