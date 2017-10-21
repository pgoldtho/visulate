REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn testrntmgr/testrntmgr

PROMPT Need  GRANT CREATE TYPE TO TESTRNTMGR

@@update.sql
@@rnt_accounts_receivable_pkg.sql
@@rnt_gen_periods_pkg.sql


spool off

