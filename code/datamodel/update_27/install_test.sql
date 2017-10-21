REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn testrntmgr/testrntmgr

PROMPT Need  GRANT CREATE TYPE TO TESTRNTMGR

@@object_types.sql
@@rnt_summary_pkg.sql



spool off

