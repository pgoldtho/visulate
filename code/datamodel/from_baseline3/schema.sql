create user rntmgr2 identified by rntmgr2
default tablespace users
temporary tablespace temp;

alter user rntmgr2 quota unlimited on users;

grant create session to rntmgr2;
grant create table to rntmgr2;
grant create procedure to rntmgr2;
grant create sequence to rntmgr2;
grant create view to rntmgr2;
