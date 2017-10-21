create user rntmgr1 identified by &1
default tablespace rnt_data1
temporary tablespace temp;

alter user rntmgr1 quota unlimited on rnt_data1;
alter user rntmgr1 quota unlimited on mls_data1;
alter user rntmgr1 quota unlimited on mgt_data1;
alter user rntmgr1 quota unlimited on pr_property_data1;
alter user rntmgr1 quota unlimited on pr_corp_data1;


grant create session to rntmgr1;
grant create table to rntmgr1;
grant create procedure to rntmgr1;
grant create sequence to rntmgr1;
grant create view to rntmgr1;	
grant create type to rntmgr1;

grant create trigger to rntmgr1;
grant create materialized view to rntmgr1;
grant execute on DBMS_CRYPTO to rntmgr1;

GRANT EXECUTE ON CTX_CLS    TO rntmgr1;
GRANT EXECUTE ON CTX_DDL    TO rntmgr1;
GRANT EXECUTE ON CTX_DOC    TO rntmgr1;
GRANT EXECUTE ON CTX_OUTPUT TO rntmgr1;
GRANT EXECUTE ON CTX_QUERY  TO rntmgr1;
GRANT EXECUTE ON CTX_REPORT TO rntmgr1;
GRANT EXECUTE ON CTX_THES   TO rntmgr1;

GRANT READ, WRITE ON DIRECTORY dpump_dir1 to rntmgr1;
