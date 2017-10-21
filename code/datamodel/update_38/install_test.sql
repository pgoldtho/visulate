REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn testrntmgr/testrntmgr

@@01_objects.sql
@@02_drop_constraint.sql
@@03_data-people_many_to_many.sql
@@04_data-roles.sql
@@05_data-section8_many_to_many.sql
@@06_data-suppliers_to_level2.sql
@@07_views.sql
@@08_rnt_obfurcation_password_pkg.sql
@@09_rnt_user_mail_pkg.sql
@@11_rnt_users_pkg.sql
@@12_rnt_bu_suppliers_pkg.sql
@@13_rnt_people_pkg.sql
@@14_rnt_section8_offices_pkg.sql
@@15_rnt_suppliers_all_pkg.sql
@@16_last-drop.sql


spool off

