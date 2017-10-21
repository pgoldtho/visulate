REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn rntmgr/rntmgr

@@rnt_accounts_payable_const_pkg.sql
@@update.sql
@@rnt_accounts_payable_pkg.sql
@@rnt_properties_pkg.sql

spool off

