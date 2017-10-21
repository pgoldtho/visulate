REM Copyright Visulate 2007
set echo on
set feedback on
spool install_54.lst
conn testrntmgr/testrntmgr

@@tables.sql
@@rnt_expense_items_pkg.sql
@@rnt_property_photos_pkg.sql


spool off

