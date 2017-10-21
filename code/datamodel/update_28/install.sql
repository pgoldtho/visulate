REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn rntmgr/rntmgr

PROMPT Need  GRANT CREATE TYPE TO RNTMGR

@@object_types.sql
@@rnt_summary_pkg.sql

spool off

