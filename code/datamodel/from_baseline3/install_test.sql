REM Copyright Visulate 2007
set echo on
set feedback on
spool test_install.lst
@@schema_test.sql
conn testrntmgr/testrntmgr

@@tables.sql
@@sequences.sql
@@views.sql
@@packages.sql
@@users_data.sql
@@lookup_data.sql

@@1_RNT_USERS_PKG.sql 
spool off

