REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn testrntmgr/testrntmgr

@@rnt_accounts_receivable_pkg.sql
@@compile.sql

spool off

