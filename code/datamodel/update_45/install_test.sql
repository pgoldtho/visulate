REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn testrntmgr/testrntmgr

@@rnt_accounts_payable_pkg.sql
@@rnt_summary_pkg.sql

spool off

