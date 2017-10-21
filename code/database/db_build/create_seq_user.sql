create user rntmgr_seq identified by rntmgr_seq 
default tablespace users
temporary tablespace temp;

alter user rntmgr_seq quota unlimited on users;


grant create session to rntmgr_seq;
grant create table to rntmgr_seq;
grant create sequence to rntmgr_seq;

GRANT READ, WRITE ON DIRECTORY dpump_dir1 to rntmgr_seq;
