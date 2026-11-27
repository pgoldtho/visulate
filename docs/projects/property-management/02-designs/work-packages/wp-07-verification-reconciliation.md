---
id: wp-07-verification-reconciliation
title: "Work Package 07: End-to-End Financial Integrity & Data Reconciliation Suite"
status: pending
phase: design
slug: property-management
target_repo: visulate
branch: feat/wp-07-verification-reconciliation
design_doc: docs/projects/property-management/02-designs/data-migration-plan.md
dependencies:
  - wp-02-data-migration
  - wp-04-accounting-ledger-engine
scope:
  - qa
  - reconciliation
  - audit
  - financial-parity
---

# Work Package 07: End-to-End Financial Integrity & Data Reconciliation Suite

## 1. Objective & Deliverables Overview
Develop the deterministic automated data reconciliation and financial verification test suite. The suite executes simultaneous SQL assertions across Oracle (`pdb22.RNTMGR2`) and the target PostgreSQL database to certify 100% row count parity, zero trial balance discrepancies, and complete payment allocation consistency.

### Key Target Files to Create:
1. `tools/reconciliation/reconcile_row_counts.ts`: Automated table-by-table record count comparison script.
2. `tools/reconciliation/reconcile_ledger.ts`: General Ledger debits/credits trial balance validator.
3. `tools/reconciliation/reconcile_tenant_balances.ts`: Individual tenant AR balance and aging comparison script.
4. `tools/reconciliation/generate_audit_report.ts`: Markdown audit certification report generator.
5. `tools/reconciliation/run_all_checks.ts`: Unified CLI test runner with pass/fail exit codes.

---

## 2. Core Reconciliation Assertions & Queries

### 2.1 Operational Row Count Assertion
Compares record counts filtered through the cutoff date `2025-12-31`:
```typescript
export interface TableParityResult {
  tableName: string;
  oracleCount: number;
  postgresCount: number;
  difference: number;
  passed: boolean;
}
```
Tables evaluated: `rnt_business_units`, `rnt_people`, `rnt_users`, `rnt_properties`, `rnt_property_units`, `rnt_tenant`, `rnt_tenancy_agreement`, `rnt_accounts_receivable`, `rnt_payments`, `rnt_payment_allocations`, `rnt_accounts_payable`, `rnt_ledger_entries`.

### 2.2 Financial Integrity & Ledger Parity Assertions
1. **General Ledger Net Trial Balance**:
   $$\sum \text{Debits} - \sum \text{Credits} = \$0.00$$
2. **Accounts Receivable Parity**:
   $$\sum (\text{amount} - \text{amount\_paid}) = \text{Target AR Outstanding}$$
3. **Payment Allocation Integrity**:
   $$\forall p \in \text{Payments}: p.\text{allocated\_amount} = \sum_{a \in \text{Allocations}(p)} a.\text{amount}$$
   (Zero orphaned payment allocations or over-allocated payments allowed).

---

## 3. Audit Report Format
The suite generates an automated Markdown report (`03-artifacts/financial-audit-report.md`) detailing:
- Exact table-by-table count comparisons.
- Total ledger trial balance variance ($0.00 required).
- AR aging summary comparison.
- Timestamp and verification sign-off block.

---

## 4. Acceptance Criteria & Automated Verification Commands
1. [ ] Operational table row counts between Oracle (<= 2025-12-31) and PostgreSQL match 100% with zero unaccounted records.
2. [ ] Total trial balance difference between debits and credits is exactly `$0.00`.
3. [ ] All payment allocations match their parent payment allocated amount with zero orphan records.
4. [ ] Automated CLI reconciliation command completes with exit code 0:
   ```bash
   npx ts-node tools/reconciliation/run_all_checks.ts --source=pdb22 --target=property_mgmt
   ```
