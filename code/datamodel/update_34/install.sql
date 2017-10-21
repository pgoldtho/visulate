REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn rntmgr/rntmgr

@@update.sql
@@rnt_accounts_payable_pkg.sql
@@rnt_error_description_pkg.sql
@@compile.sql
@@data.sql



spool off

