REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn testrntmgr/testrntmgr

@@table_view.sql
@@rnt_expense_items_pkg.sql


spool off

