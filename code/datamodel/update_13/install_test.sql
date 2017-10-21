REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn testrntmgr/testrntmgr


@@set_prop_id.sql
@@update.sql


spool off

