REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn testrntmgr/testrntmgr

@@addBID.sql
@@update.sql


spool off

