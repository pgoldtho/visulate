create user rntmgr identified by &1
default tablespace rnt_data
temporary tablespace temp;

alter user rntmgr quota unlimited on rnt_data;
alter user rntmgr quota unlimited on mls_data;
alter user rntmgr quota unlimited on mgt_data;
alter user rntmgr quota unlimited on pr_property_data;
alter user rntmgr quota unlimited on pr_corp_data;
alter user rntmgr quota unlimited on spatial_index;
alter user rntmgr quota unlimited on spatial_work;


grant create session to rntmgr;
grant create table to rntmgr;
grant create procedure to rntmgr;
grant create sequence to rntmgr;
grant create view to rntmgr;	
grant create type to rntmgr;
grant create synonym to rntmgr;

grant create trigger to rntmgr;
grant create materialized view to rntmgr;
grant execute on DBMS_CRYPTO to rntmgr;

GRANT EXECUTE ON CTX_CLS    TO rntmgr;
GRANT EXECUTE ON CTX_DDL    TO rntmgr;
GRANT EXECUTE ON CTX_DOC    TO rntmgr;
GRANT EXECUTE ON CTX_OUTPUT TO rntmgr;
GRANT EXECUTE ON CTX_QUERY  TO rntmgr;
GRANT EXECUTE ON CTX_REPORT TO rntmgr;
GRANT EXECUTE ON CTX_THES   TO rntmgr;


