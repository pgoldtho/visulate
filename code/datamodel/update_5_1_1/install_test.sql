REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn testrntmgr/testrntmgr


@@package.sql
@@payment_types.sql

spool off

