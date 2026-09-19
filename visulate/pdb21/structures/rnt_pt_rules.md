# Table Structure: RNT_PT_RULES (RNTMGR2.RNT_PT_RULES)

## Purpose
`RNT_PT_RULES` (Payment Transaction Rules) is the configuration table driving Visulate's automated double-entry General Ledger posting engine. It maps operational property events (rent invoices, maintenance bills, tenant receipts, vendor payments, and deposits) to specific Debit and Credit GL accounts.

## Schema Definition
- **Table Name**: `RNT_PT_RULES`
- **Owner**: `RNTMGR2`
- **Primary Key**: `(BUSINESS_ID, PAYMENT_TYPE_ID, TRANSACTION_TYPE)`
- **Tablespace**: `MGT_DATA2`
- **Row Count**: ~21,280 rows

## Key Columns
- `BUSINESS_ID` (FK `RNT_BUSINESS_UNITS`): The business unit / client portfolio this rule applies to, ensuring multi-tenant chart of accounts isolation.
- `PAYMENT_TYPE_ID` (FK `RNT_PAYMENT_TYPES`): The type of payment (e.g. Rent, Late Fee, Security Deposit, Maintenance, Loan Interest).
- `TRANSACTION_TYPE` (VARCHAR2): Transaction stage indicator constrained by `RNT_PT_RULES_CK1`:
  - `ARS`: Accounts Receivable Scheduled (rent invoice created)
  - `ARP`: Accounts Receivable Paid (payment collected & allocated)
  - `APS`: Accounts Payable Scheduled (vendor invoice/expense registered)
  - `APP`: Accounts Payable Paid (vendor bill paid & allocated)
  - `DEP`: Deposit transaction
- `DEBIT_ACCOUNT` (FK `RNT_ACCOUNTS`): The GL account to debit when this transaction triggers.
- `CREDIT_ACCOUNT` (FK `RNT_ACCOUNTS`): The GL account to credit when this transaction triggers.

## Operational Lifecycle & Dependencies
1. **Initialization**: When a new business unit is created in `RNT_BUSINESS_UNITS`, default rules are cloned from `RNT_DEFAULT_PT_RULES` into `RNT_PT_RULES` via `RNT_PT_RULES_PKG`.
2. **Execution Triggers**:
   - `RNT_ACCOUNTS_RECEIVABLE_PKG`: Looks up `ARS` rules when generating invoices.
   - `RNT_LEDGER_PKG`: Looks up `ARP`, `APS`, `APP`, and `DEP` rules when transactions are scheduled or payments are allocated (`RNT_PAYMENT_ALLOCATIONS`) to insert balanced double-entry rows into `RNT_LEDGER_ENTRIES`.
