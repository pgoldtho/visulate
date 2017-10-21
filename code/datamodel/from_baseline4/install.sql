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

spool off

