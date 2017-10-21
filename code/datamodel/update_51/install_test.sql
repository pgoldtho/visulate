REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn testrntmgr/testrntmgr

@@update.sql
@@rnt_expense_items.sql
@@rnt_expense_items_v.sql
@@rnt_expense_items_seq.sql
@@rnt_expense_items_pkg.sql


spool off

