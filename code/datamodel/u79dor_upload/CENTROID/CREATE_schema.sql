DEFINE CODEOWNER='&1'
DEFINE PSWD='&2'
drop   user &CODEOWNER. cascade;
create user &CODEOWNER 
       identified by &PSWD. 
       default tablespace users 
       temporary tablespace temp;
grant connect to &CODEOWNER;
grant create procedure to &CODEOWNER;
grant create public synonym to &CODEOWNER;
grant create sequence to &CODEOWNER;
grant create synonym to &CODEOWNER;
grant create table to &CODEOWNER;
grant create trigger to &CODEOWNER;
grant create type to &CODEOWNER;
grant create view to &CODEOWNER;
grant debug any procedure to &CODEOWNER.;
grant debug connect session to &CODEOWNER.;
grant execute on MDSYS.MD          to &&CODEOWNER. WITH GRANT OPTION;
grant execute on MDSYS.SDO_3GL     to &&CODEOWNER. WITH GRANT OPTION;
grant execute on MDSYS.VERTEX_TYPE to &&CODEOWNER. WITH GRANT OPTION;
grant execute on sys.utl_smtp     to public;
grant exp_full_database to &CODEOWNER.;
grant imp_full_database to &CODEOWNER.;
grant query rewrite to &CODEOWNER;
grant resource to &CODEOWNER;
grant select on MDSYS.SDO_COORD_REF_SYS to public;
grant select on sys.dba_recyclebin to &&CODEOWNER.;
grant select on sys.dba_registry to public;
grant SELECT_CATALOG_ROLE to &CODEOWNER;
quit;
