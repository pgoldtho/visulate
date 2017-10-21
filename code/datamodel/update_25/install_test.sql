REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn testrntmgr/testrntmgr

PROMPT Need  GRANT CREATE TYPE TO TESTRNTMGR

@@update.sql


spool off

