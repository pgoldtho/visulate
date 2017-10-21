REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn testrntmgr/testrntmgr

@@rnt_accounts_payable_const_pkg.sql
@@indexes.sql

spool off

