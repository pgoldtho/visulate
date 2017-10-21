REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn testrntmgr/testrntmgr

@@rnt_tenancy_agreement_pkg.sql
SHOW ERRORS;
@@rnt_agreement_actions_pkg.sql
SHOW ERRORS;
ALTER VIEW RNT_TENANCY_AGREEMENT_V COMPILE;

spool off

