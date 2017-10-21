REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
@@schema.sql
conn rntmgr40/rentman1

@@tables.sql
@@sequences.sql
@@views.sql
@@packages.sql
@@users_data.sql
@@lookup_data.sql

spool off

