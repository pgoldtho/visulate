create user testrntmgr identified by testrntmgr
default tablespace users
temporary tablespace temp;

alter user testrntmgr quota unlimited on users;

grant create session to testrntmgr;
grant create table to testrntmgr;
grant create procedure to testrntmgr;
grant create sequence to testrntmgr;
grant create view to testrntmgr;