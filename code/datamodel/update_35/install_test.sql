REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn testrntmgr/testrntmgr

@@update.sql
@@data-rnt_supplier_type.sql
@@error_messages.sql
@@rnt_bu_suppliers_pkg.sql
@@rnt_suppliers_all_pkg.sql
@@insert_suppliers.sql
@@insert_suppliers_bu.sql
@@update_rnt_account_payable.sql
@@fks.sql

spool off

