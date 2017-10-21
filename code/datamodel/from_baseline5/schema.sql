create user rntmgr40 identified by rentman1
default tablespace users
temporary tablespace temp;

alter user rntmgr40 quota unlimited on users;

grant create session to rntmgr40;
grant create table to rntmgr40;
grant create procedure to rntmgr40;
grant create sequence to rntmgr40;
grant create view to rntmgr40;
