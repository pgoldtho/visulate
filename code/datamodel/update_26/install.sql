REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn rntmgr/rntmgr

PROMPT Need  GRANT CREATE TYPE TO RNTMGR

@@rnt_accounts_payable_pkg.sql
@@rnt_accounts_receivable_pkg.sql
@@rnt_agreement_actions_pkg.sql
@@rnt_business_units_pkg.sql
@@rnt_error_description_pkg.sql
@@rnt_loans_pkg.sql
@@rnt_payments_pkg.sql
@@rnt_payment_allocations_pkg.sql
@@rnt_people_pkg.sql
@@rnt_properties_pkg.sql
@@rnt_property_expenses_pkg.sql
@@rnt_property_units_pkg.sql
@@rnt_section8_offices_pkg.sql
@@rnt_suppliers_pkg.sql
@@rnt_tenancy_agreement_pkg.sql
@@rnt_tenant_pkg.sql
@@rnt_users_pkg.sql
@@rnt_user_assignments_pkg.sql


spool off

