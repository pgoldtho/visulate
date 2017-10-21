REM Copyright Visulate 2007
set echo on
set feedback on
spool install_44.lst

@@update.sql
@@rnt_summary_pkg.sql

spool off

