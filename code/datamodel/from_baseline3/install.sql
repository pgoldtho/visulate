REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
@@schema.sql
conn rntmgr2/rntmgr2

@@tables.sql
@@sequences.sql
@@views.sql
@@packages.sql
@@users_data.sql
@@lookup_data.sql

@@1_RNT_USERS_PKG.sql 
spool off

