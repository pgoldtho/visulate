create user rntmgr identified by rntmgr
default tablespace users
temporary tablespace temp;

alter user rntmgr quota unlimited on users;

grant create session to rntmgr;
grant create table to rntmgr;
grant create procedure to rntmgr;
grant create sequence to rntmgr;
grant create view to rntmgr;