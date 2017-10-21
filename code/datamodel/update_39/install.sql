REM Copyright Visulate 2007
set echo on
set feedback on
spool install_39.lst

@@rnt_accounts_receivable_pkg.sql
@@compile.sql

spool off

