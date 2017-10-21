REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn rntmgr/rntmgr


@@rnt_suppliers_v.sql
@@rnt_account_payable_pkg.sql 
@@rnt_summary_pkg.sql 



spool off

