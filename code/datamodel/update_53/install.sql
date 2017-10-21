REM Copyright Visulate 2007
set echo on
set feedback on
spool install_43.lst

@@table.sql
@@rnt_expense_items_v.sql
@@rnt_expense_items_pkg.sql


spool off

