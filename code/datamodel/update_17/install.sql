REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn rntmgr/rntmgr

@@rnt_properties_pkg.sql

spool off
