create user rntmgr2 identified by &1
default tablespace rnt_data2
temporary tablespace temp;

alter user rntmgr2 quota unlimited on rnt_data2;
alter user rntmgr2 quota unlimited on mls_data2;
alter user rntmgr2 quota unlimited on mgt_data2;
alter user rntmgr2 quota unlimited on pr_property_data2;
alter user rntmgr2 quota unlimited on pr_corp_data2;
alter user rntmgr2 quota unlimited on spatial_index2;
alter user rntmgr2 quota unlimited on spatial_work2;


grant create session to rntmgr2;
grant create table to rntmgr2;
grant create procedure to rntmgr2;
grant create sequence to rntmgr2;
grant create view to rntmgr2;	
grant create type to rntmgr2;
grant create synonym to rntmgr2;

grant create trigger to rntmgr2;
grant create materialized view to rntmgr2;
grant execute on DBMS_CRYPTO to rntmgr2;

GRANT EXECUTE ON CTX_CLS    TO rntmgr2;
GRANT EXECUTE ON CTX_DDL    TO rntmgr2;
GRANT EXECUTE ON CTX_DOC    TO rntmgr2;
GRANT EXECUTE ON CTX_OUTPUT TO rntmgr2;
GRANT EXECUTE ON CTX_QUERY  TO rntmgr2;
GRANT EXECUTE ON CTX_REPORT TO rntmgr2;
GRANT EXECUTE ON CTX_THES   TO rntmgr2;

GRANT READ, WRITE ON DIRECTORY dpump_dir1 to rntmgr2;
