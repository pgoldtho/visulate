REM Copyright Visulate 2007
set echo on
set feedback on
spool install_40.lst

@@rnt_accounts_payable_const_pkg.sql
@@indexes.sql

spool off

