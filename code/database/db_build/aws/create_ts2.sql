create BIGFILE tablespace PR_PROPERTY_DATA 
  datafile '/u02/app/oradata/vis13/pr_property_data.dbf' 
  SIZE 11G AUTOEXTEND ON;
  
create BIGFILE tablespace PR_CORP_DATA 
  datafile '/u02/app/oradata/vis13/pr_corp_data.dbf' 
  SIZE 3G AUTOEXTEND ON;
  
create BIGFILE tablespace MLS_DATA 
  datafile '/u02/app/oradata/vis13/mls_data.dbf' 
  SIZE 1G AUTOEXTEND ON;
  
create BIGFILE tablespace RNT_DATA 
  datafile '/u02/app/oradata/vis13/rnt_data.dbf' 
  SIZE 1G AUTOEXTEND ON;

create tablespace MGT_DATA 
  datafile '/u02/app/oradata/vis13/mgt_data.dbf' 
  SIZE 500M AUTOEXTEND ON;

create tablespace SPATIAL_INDEX 
  datafile '/u02/app/oradata/vis13/spatial_index.dbf' 
  SIZE 1G AUTOEXTEND ON;
  
create tablespace SPATIAL_WORK 
  datafile '/u02/app/oradata/vis13/spatial_work.dbf' 
  SIZE 1G AUTOEXTEND ON; 

