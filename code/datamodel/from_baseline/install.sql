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
@@business_units_data.sql
@@lookup_data.sql

@@1_1_RNT_PROPERTIES_PKG.pks
@@1_1_RNT_PROPERTIES_PKG.pkb
 
spool off

