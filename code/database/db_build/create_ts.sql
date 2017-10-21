create BIGFILE tablespace PR_PROPERTY_DATA1 
  datafile '/ssd1/oradata/vis12/pr_property_data.dbf' 
  SIZE 11G AUTOEXTEND ON;
  
create BIGFILE tablespace PR_CORP_DATA1 
  datafile '/ssd1/oradata/vis12/pr_corp_data.dbf' 
  SIZE 3G AUTOEXTEND ON;
  
create BIGFILE tablespace MLS_DATA1 
  datafile '/ssd1/oradata/vis12/mls_data.dbf' 
  SIZE 1G AUTOEXTEND ON;
  
create BIGFILE tablespace RNT_DATA1 
  datafile '/ssd1/oradata/vis12/rnt_data.dbf' 
  SIZE 1G AUTOEXTEND ON;

create tablespace MGT_DATA1 
  datafile '/ssd1/oradata/vis12/mgt_data.dbf' 
  SIZE 500M AUTOEXTEND ON;

create tablespace SPATIAL_INDEX1 
  datafile '/ssd1/oradata/vis12/spatial_index.dbf' 
  SIZE 1G AUTOEXTEND ON;
  
create tablespace SPATIAL_WORK1 
  datafile '/ssd1/oradata/vis12/spatial_work.dbf' 
  SIZE 1G AUTOEXTEND ON; 

