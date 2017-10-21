REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
@@schema.sql
conn rntmgr/rntmgr

@@tables.sql
@@sequences.sql
@@views.sql
@@packages.sql
@@users_data.sql
@@lookup_data.sql

@@RNT_USERS_PKG.pks
@@RNT_USERS_PKG.pkb

@@2_RNT_TENANCY_AGREEMENT.sql
@@2_RNT_TENANCY_AGREEMENT_PKG.pks
@@2_RNT_TENANCY_AGREEMENT_PKG.pkb
@@2_RNT_TENANCY_AGREEMENT_V.sql
@@3_packages.sql 
spool off

