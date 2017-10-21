REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn testrntmgr/testrntmgr


@@crea_tables.sql
@@view.sql
@@seq.sql
@@rnt_property_estimates_pkg.sql
@@rnt_property_links_pkg.sql

spool off

