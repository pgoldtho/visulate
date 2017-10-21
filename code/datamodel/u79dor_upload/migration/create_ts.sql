create BIGFILE tablespace PR_PROPERTY_DATA2 
  datafile '/u02/app/oracle/oradata/vis11/pr_property_data2.dbf' 
  SIZE 11G AUTOEXTEND ON;
  
create BIGFILE tablespace PR_CORP_DATA2 
  datafile '/u02/app/oracle/oradata/vis11/pr_corp_data2.dbf' 
  SIZE 3G AUTOEXTEND ON;
  
create BIGFILE tablespace MLS_DATA2 
  datafile '/u02/app/oracle/oradata/vis11/mls_data2.dbf' 
  SIZE 1G AUTOEXTEND ON;
  
create BIGFILE tablespace RNT_DATA2 
  datafile '/u02/app/oracle/oradata/vis11/rnt_data2.dbf' 
  SIZE 5G AUTOEXTEND ON;

create tablespace MGT_DATA2 
  datafile '/u02/app/oracle/oradata/vis11/mgt_data2.dbf' 
  SIZE 200M AUTOEXTEND ON;

