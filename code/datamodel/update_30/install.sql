REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst

@@supplier_index.sql

select object_name, object_type
from user_objects
where status = 'INVALID';

spool off

