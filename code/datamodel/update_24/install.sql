REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn rntmgr/rntmgr

PROMPT Need  GRANT CREATE TYPE TO RNTMGR

@@update.sql
@@rnt_accounts_receivable_pkg.sql
@@rnt_gen_periods_pkg.sql



spool off

