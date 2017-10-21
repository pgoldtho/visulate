set define '^'
@@data_model.sql
@@seed_data.sql
@@seed_data_pt
@@views.sql
@@rnt_account_balances_pkg.sql
@@rnt_account_types_pkg.sql
@@rnt_accounts_payable_pkg.sql
@@rnt_accounts_pkg.sql
@@rnt_accounts_receivable_pkg.sql
@@rnt_business_units_pkg.sql
@@rnt_default_accounts_pkg.sql
@@rnt_default_pt_rules_pkg.sql
@@rnt_payment_allocations_pkg.sql
@@rnt_pt_rules_pkg.sql
@@rnt_ledger_entries_pkg
@@rnt_account_periods_pkg
@@rnt_ledger_pkg

exec dbms_utility.compile_schema(schema=>'RNTMGR')
