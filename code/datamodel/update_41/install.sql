REM Copyright Visulate 2007
set echo on
set feedback on
spool install_41.lst

@@1_table.sql
@@rnt_business_units_pkg.sql
@@rnt_users_pkg.sql
@@rnt_user_mail_pkg.sql

spool off

