REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn rntmgr/rntmgr

@@set_prop_id.sql
@@update.sql

spool off

