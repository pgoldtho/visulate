REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn rntmgr/rntmgr


@@package.sql
@@payment_types.sql

spool off

