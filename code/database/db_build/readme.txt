create separte tablespaces for
 - PR_BUILDING_DATA
 - PR_CORPORATE_DATA
 - MLS_DATA
 - RNT_DATA
 
 create RNTMGR1 schema  
 
 Export the RNTMGR schema using data pump

 
Import building and corporate data into RNTMGR1 mapping to new tablespaces
  Export production rnt and mls objects using data pump
Import mls and rnt data into RNTMGR1 mapping to new tablespaces
 
@/home/pgoldtho/visulate/visulate/code/database/plsql/rnt_ledger_pkg

@types
conn sys
@acl

exec dbms_utility.compile_schema(schema=>'RNTMGR2')
drop materialized view PR_ZIPCODE_SUMMARY_MV;	
drop materialized view PR_COUNTY_SUMMARY_MV;	
drop materialized view PR_UCODE_SUMMARY_MV;	
drop materialized view PR_VALUE_SUMMARY_MV;	
drop materialized view PR_CITY_SUMMARY_MV;	
select object_name, object_type from user_objects where status='INVALID';

exec dbms_utility.analyze_schema('RNTMGR1', 'COMPUTE')



update 193
