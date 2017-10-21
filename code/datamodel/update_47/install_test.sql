REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn testrntmgr/testrntmgr

@@agr_actions_data.sql
@@rnt_accounts_payable_pkg.sql


spool off

