REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn testrntmgr/&1


@@update.sql

spool off

