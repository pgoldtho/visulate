create user rntdemo identified by &1
default tablespace users
temporary tablespace temp;

alter user rntdemo quota unlimited on users;

grant create session to rntdemo;
grant create table to rntdemo;
grant create procedure to rntdemo;
grant create sequence to rntdemo;
grant create view to rntdemo;	
grant create type to rntdemo;
grant create synonym to rntdemo;

grant create trigger to rntdemo;
grant create materialized view to rntdemo;

GRANT EXECUTE ON CTX_CLS    TO rntdemo;
GRANT EXECUTE ON CTX_DDL    TO rntdemo;
GRANT EXECUTE ON CTX_DOC    TO rntdemo;
GRANT EXECUTE ON CTX_OUTPUT TO rntdemo;
GRANT EXECUTE ON CTX_QUERY  TO rntdemo;
GRANT EXECUTE ON CTX_REPORT TO rntdemo;
GRANT EXECUTE ON CTX_THES   TO rntdemo;