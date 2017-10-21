create BIGFILE tablespace PR_PROPERTY_DATA2 
  datafile '/ssd01/oradata/vis11/pr_property_data2.dbf' 
  SIZE 11G AUTOEXTEND ON;
  
create BIGFILE tablespace PR_CORP_DATA2 
  datafile '/ssd01/oradata/vis11/pr_corp_data2.dbf' 
  SIZE 3G AUTOEXTEND ON;
  
create BIGFILE tablespace MLS_DATA2 
  datafile '/ssd01/oradata/vis11/mls_data2.dbf' 
  SIZE 1G AUTOEXTEND ON;
  
create BIGFILE tablespace RNT_DATA2 
  datafile '/ssd01/oradata/vis11/rnt_data2.dbf' 
  SIZE 1G AUTOEXTEND ON;

create tablespace MGT_DATA2 
  datafile '/ssd01/oradata/vis11/mgt_data2.dbf' 
  SIZE 500M AUTOEXTEND ON;

create tablespace SPATIAL_INDEX2 
  datafile '/ssd01/oradata/vis11/spatial_index2.dbf' 
  SIZE 1G AUTOEXTEND ON;
  
create tablespace SPATIAL_WORK2 
  datafile '/ssd01/oradata/vis11/spatial_work2.dbf' 
  SIZE 1G AUTOEXTEND ON; 

