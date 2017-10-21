REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn testrntmgr/testrntmgr

@@update.sql
@@rnt_section8_offices_pkg.sql
@@append_section8.sql
@@add_fk.sql

spool off

