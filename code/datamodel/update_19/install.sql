REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn rntmgr/rntmgr

@@rnt_tenancy_agreement_pkg.sql

spool off

