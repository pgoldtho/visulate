REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn testrntmgr/testrntmgr

PROMPT Need  GRANT CREATE TYPE TO TESTRNTMGR

@@user_table.sql
@@views.sql
@@rnt_users_pkg.sql
@@send_mail.sql
@@update.sql

spool off

