# General Ledger (GL) Accounting Architecture in RNTMGR2

## 1. Multi-Tenant Chart of Accounts (`RNT_ACCOUNTS`)
- **Business Unit Scoping**: Every account in `RNT_ACCOUNTS` is scoped to a specific `BUSINESS_ID` (`RNT_BUSINESS_UNITS`), enabling separate financial books for each property owner or portfolio.
- **Account Types**: Accounts map to generic accounting categories via `RNT_ACCOUNT_TYPES` (Asset, Liability, Equity, Revenue, Expense).
- **Template Seeding**: A default chart of accounts is maintained in `RNT_DEFAULT_ACCOUNTS` and cloned into `RNT_ACCOUNTS` when initializing a new business unit.
- **Sub-Ledger Linkage**: Accounts can link to specific users (`RNT_USER_ASSIGNMENTS`) or tenants/contractors (`RNT_PEOPLE_BU`) for sub-ledger accounting.

## 2. Automated Posting Rules Engine (`RNT_PT_RULES`)
Posting rules determine how operational events automatically translate into balanced double-entry GL transactions.
- **Seeded Defaults**: Cloned from `RNT_DEFAULT_PT_RULES` for each business unit.
- **Rule Triggers**: Mapped by `PAYMENT_TYPE_ID` (`RNT_PAYMENT_TYPES`) and `TRANSACTION_TYPE`:
  - `AR Scheduled`: Generated when rent or fees are scheduled in `RNT_ACCOUNTS_RECEIVABLE`.
    - *Debit*: Accounts Receivable (Asset)
    - *Credit*: Rental Income (Revenue)
  - `AR Paid`: Generated when rent is collected and allocated in `RNT_PAYMENT_ALLOCATIONS`.
    - *Debit*: Cash / Bank Account (Asset)
    - *Credit*: Accounts Receivable (Asset)
  - `AP Scheduled`: Generated when an expense or invoice is registered in `RNT_ACCOUNTS_PAYABLE`.
    - *Debit*: Expense / Property Improvement Account (Expense/Asset)
    - *Credit*: Accounts Payable (Liability)
  - `AP Paid`: Generated when an outgoing payment is disbursed and allocated in `RNT_PAYMENT_ALLOCATIONS`.
    - *Debit*: Accounts Payable (Liability)
    - *Credit*: Cash / Operating Account (Asset)

## 3. Accounting Periods & Integrity Control (`RNT_ACCOUNT_PERIODS`, `RNT_ACCOUNT_BALANCES`)
- **Period Management**: Uniquely identified by `BUSINESS_ID` and period start date.
- **Period Status**: Controlled by `STATUS` (`OPEN` vs. `CLOSED`). Updates, postings, or modifications to closed periods are blocked by PL/SQL package validation.
- **Period Close & Balances**: At period close, `RNT_ACCOUNT_BALANCES` snapshots the final ending balance for each account to carry forward into subsequent periods.

## 4. Double-Entry Journal & Reporting (`RNT_LEDGER_ENTRIES`, `RNT_LEDGER_TRANSACTIONS_V`)
- **Base Storage (`RNT_LEDGER_ENTRIES`)**: Stores ledger rows with explicit debit account (`DR_ACCOUNT_ID`), credit account (`CR_ACCOUNT_ID`), amount, transaction date, and period ID.
- **Normalized View (`RNT_LEDGER_TRANSACTIONS_V`)**: Denormalizes each entry into two balanced line items (one for debit, one for credit) to support traditional T-accounts, trial balance generation, and income statement/balance sheet reporting.
- **PL/SQL Package Orchestration**: Coordinated by `RNT_LEDGER_PKG`, `RNT_ACCOUNTS_RECEIVABLE_PKG`, and `RNT_ACCOUNTS_PAYABLE_PKG`.
