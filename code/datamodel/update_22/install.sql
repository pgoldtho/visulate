REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn rntmgr/rntmgr

@@update.sql
@@rnt_loans_pkg.sql
@@rnt_accounts_receivable_pkg.sql
@@view.sql

spool off

