REM Copyright Visulate 2007
set echo on
set feedback on
spool test_install.lst
conn testrntmgr/testrntmgr

@@data.sql
@@objects.sql

spool off

