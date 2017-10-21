REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn rntmgr/rntmgr

PROMPT Need  GRANT CREATE TYPE TO RNTMGR

@@rnt_suppliers_pkg.sql

spool off

