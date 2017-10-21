  CREATE UNIQUE INDEX "RNTMGR"."MLS_BROKERS_PK" ON "RNTMGR"."MLS_BROKERS" ("BROKER_UID", "SOURCE_ID")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000075658C00022$$" ON "RNTMGR"."MLS_LISTINGS" (                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS"                                                                                                                
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000075658C00023$$" ON "RNTMGR"."MLS_LISTINGS" (                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS"                                                                                                                
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."MLS_LISTINGS_PK" ON "RNTMGR"."MLS_LISTINGS" ("MLS_ID")                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 2097152 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."MLS_LISTINGS_U1" ON "RNTMGR"."MLS_LISTINGS" ("SOURCE_ID", "MLS_NUMBER")                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 917504 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."MLS_LISTINGS_R1" ON "RNTMGR"."MLS_LISTINGS" ("PROP_ID")                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 589824 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."MLS_LISTINGS_N1" ON "RNTMGR"."MLS_LISTINGS" ("PRICE")                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 393216 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."MLS_LISTINGS_N2" ON "RNTMGR"."MLS_LISTINGS" ("LISTING_STATUS")                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 655360 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."MLS_LISTINGS_N3" ON "RNTMGR"."MLS_LISTINGS" ("IDX_YN")                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 393216 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."MLS_LISTINGS_N4" ON "RNTMGR"."MLS_LISTINGS" ("QUERY_TYPE")                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 917504 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."MLS_LISTINGS_N5" ON "RNTMGR"."MLS_LISTINGS" ("LISTING_TYPE")                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 524288 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000075671C00022$$" ON "RNTMGR"."MLS_LISTINGS_ARCHIVE" (                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS"                                                                                                                
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000075671C00023$$" ON "RNTMGR"."MLS_LISTINGS_ARCHIVE" (                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS"                                                                                                                
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."MLS_PHOTOS_PK" ON "RNTMGR"."MLS_PHOTOS" ("MLS_ID", "PHOTO_SEQ")                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 6291456 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."MLS_PRICE_RANGES_PK" ON "RNTMGR"."MLS_PRICE_RANGES"
  ("ZCODE", "LISTING_TYPE", "QUERY_TYPE", "RANGE_DATE", "SOURCE_ID", "COUNTY", "STATE")                                                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 3145728 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000075681C00006$$" ON "RNTMGR"."MLS_RETS_RESPONSES" (                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS"                                                                                                                
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_BUILDINGS_PK" ON "RNTMGR"."PR_BUILDINGS" ("BUILDING_ID")                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 8388608 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_BUILDINGS_U1" ON "RNTMGR"."PR_BUILDINGS" ("PROP_ID", "BUILDING_NAME")                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 22020096 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_BUILDING_FEATURES_PK" ON "RNTMGR"."PR_BUILDING_FEATURES" ("FCODE", "BUILDING_ID")                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 92274688 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_BUILDING_FEATURES_N1" ON "RNTMGR"."PR_BUILDING_FEATURES" ("BUILDING_ID")                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 54525952 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_BUILDING_USAGE_PK" ON "RNTMGR"."PR_BUILDING_USAGE" ("UCODE", "BUILDING_ID")                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 16777216 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_BUILDING_USAGE_N1" ON "RNTMGR"."PR_BUILDING_USAGE" ("BUILDING_ID")                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 8388608 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_CITY_ZIPCODES_PK" ON "RNTMGR"."PR_CITY_ZIPCODES" ("CITY_ID", "ZIPCODE")                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 2097152 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_CITY_ZIPCODES_N1" ON "RNTMGR"."PR_CITY_ZIPCODES" ("ZIPCODE")                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 2097152 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_CORPORATE_LOCATIONS_PK" ON "RNTMGR"."PR_CORPORATE_LOCATIONS"
  ("LOC_ID", "CORP_NUMBER", "LOC_TYPE")                                                                                                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 167772160 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_CORPORATE_LOCATIONS_F1" ON "RNTMGR"."PR_CORPORATE_LOCATIONS" ("CORP_NUMBER")                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 100663296 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_CORPORATE_POSITIONS_PK" ON "RNTMGR"."PR_CORPORATE_POSITIONS" ("CORP_NUMBER", "PN_ID")            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 134217728 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_CORPORATE_POSITIONS_F1" ON "RNTMGR"."PR_CORPORATE_POSITIONS" ("PN_ID")                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 83886080 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_CORPORATIONS_PK" ON "RNTMGR"."PR_CORPORATIONS" ("CORP_NUMBER")                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 49283072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_CORPORATIONS_N1" ON "RNTMGR"."PR_CORPORATIONS" ("NAME")                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 109051904 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_CORPORATIONS_R1" ON "RNTMGR"."PR_CORPORATIONS" ("OWNER_ID")                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_DEED_CODES_PK" ON "RNTMGR"."PR_DEED_CODES" ("DEED_CODE")                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_FEATURE_CODES_PK" ON "RNTMGR"."PR_FEATURE_CODES" ("FCODE")                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_FEATURE_CODES_N1" ON "RNTMGR"."PR_FEATURE_CODES" ("PARENT_FCODE")                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_GIS_COORDS_N1" ON "RNTMGR"."PR_GIS_COORDS" ("SOURCE_ID", "SOURCE_PK")                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 31457280 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000075717C00016$$" ON "RNTMGR"."PR_LOCATIONS" (                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS"                                                                                                                
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000075717C00017$$" ON "RNTMGR"."PR_LOCATIONS" (                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS"                                                                                                                
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_LOCATIONS_PK" ON "RNTMGR"."PR_LOCATIONS" ("LOC_ID")                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 75497472 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_LOCATIONS_U1" ON "RNTMGR"."PR_LOCATIONS" ("ADDRESS1", "ADDRESS2", "ZIPCODE")                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 129368064 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_LOCATIONS_F1" ON "RNTMGR"."PR_LOCATIONS" ("PROP_ID")                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 4194304 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_OWNERS_PK" ON "RNTMGR"."PR_OWNERS" ("OWNER_ID")                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 35651584 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_OWNERS_N1" ON "RNTMGR"."PR_OWNERS" ("OWNER_NAME")                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 75497472 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_PRINCIPALS_PK" ON "RNTMGR"."PR_PRINCIPALS" ("PN_ID")                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 56623104 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_PRINCIPALS_U1" ON "RNTMGR"."PR_PRINCIPALS" ("PN_TYPE", "PN_NAME")                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 133496832 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_PRINCIPAL_LOCATIONS_PK" ON "RNTMGR"."PR_PRINCIPAL_LOCATIONS" ("LOC_ID", "PN_ID")                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 142606336 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_PRINCIPAL_LOCATIONS_F1" ON "RNTMGR"."PR_PRINCIPAL_LOCATIONS" ("PN_ID")                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 134217728 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000075734C00018$$" ON "RNTMGR"."PR_PROPERTIES" (                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS"                                                                                                                
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000075734C00019$$" ON "RNTMGR"."PR_PROPERTIES" (                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS"                                                                                                                
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_PROPERTIES_PK" ON "RNTMGR"."PR_PROPERTIES" ("PROP_ID")                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 29360128 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_PROPERTIES_U2" ON "RNTMGR"."PR_PROPERTIES" ("ADDRESS1", "ADDRESS2", "ZIPCODE")                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 75497472 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_PROPERTIES_N1" ON "RNTMGR"."PR_PROPERTIES" ("SOURCE_PK")                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 36700160 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_PROPERTIES_N2" ON "RNTMGR"."PR_PROPERTIES" ("ZIPCODE")                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 25165824 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_PROPERTY_LINKS_PK" ON "RNTMGR"."PR_PROPERTY_LINKS" ("PROP_ID", "URL")                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 17825792 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_PROPERTY_LISTINGS_PK" ON "RNTMGR"."PR_PROPERTY_LISTINGS" ("PROP_ID", "BUSINESS_ID", "LISTING_DATE
")                                                                                                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_PROPERTY_LISTINGS_N1" ON "RNTMGR"."PR_PROPERTY_LISTINGS" ("BUSINESS_ID")                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_PROPERTY_OWNERS_PK" ON "RNTMGR"."PR_PROPERTY_OWNERS" ("OWNER_ID", "PROP_ID")                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 39845888 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_PROPERTY_OWNERS_N1" ON "RNTMGR"."PR_PROPERTY_OWNERS" ("PROP_ID")                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 29360128 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_PROPERTY_OWNERS_N2" ON "RNTMGR"."PR_PROPERTY_OWNERS" ("MAILING_ID")                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 28311552 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_PROPERTY_PHOTOS_PK" ON "RNTMGR"."PR_PROPERTY_PHOTOS" ("PROP_ID", "URL")                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 117374976 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_PROPERTY_SALES_N1" ON "RNTMGR"."PR_PROPERTY_SALES" ("NEW_OWNER_ID")                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 78643200 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_PROPERTY_SALES_N2" ON "RNTMGR"."PR_PROPERTY_SALES" ("OLD_OWNER_ID")                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 63963136 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_PROPERTY_SALES_N3" ON "RNTMGR"."PR_PROPERTY_SALES" ("DEED_CODE")                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 56623104 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_PROPERTY_SALES_PK" ON "RNTMGR"."PR_PROPERTY_SALES" ("PROP_ID", "NEW_OWNER_ID", "SALE_DATE")      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 134217728 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_PROPERTY_USAGE_PK" ON "RNTMGR"."PR_PROPERTY_USAGE" ("UCODE", "PROP_ID")                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 29360128 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_PROPERTY_USAGE_N1" ON "RNTMGR"."PR_PROPERTY_USAGE" ("PROP_ID")                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 25165824 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_PROP_CLASS_PK" ON "RNTMGR"."PR_PROP_CLASS" ("PROP_CLASS")                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_SOURCES_PK" ON "RNTMGR"."PR_SOURCES" ("SOURCE_ID")                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_SOURCES_U1" ON "RNTMGR"."PR_SOURCES" ("SOURCE_NAME")                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_TAXES_PK" ON "RNTMGR"."PR_TAXES" ("PROP_ID", "TAX_YEAR")                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 27262976 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_UCODE_DATA_PK" ON "RNTMGR"."PR_UCODE_DATA" ("CITY_ID", "UCODE")                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_USAGE_CODES_PK" ON "RNTMGR"."PR_USAGE_CODES" ("UCODE")                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_PROPERTY_CODES_U1" ON "RNTMGR"."PR_USAGE_CODES" ("PARENT_UCODE")                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_VALUES_PK" ON "RNTMGR"."PR_VALUES" ("CITY_ID", "UCODE", "PROP_CLASS", "YEAR")                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 327680 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_VOLUSIA_IDS_N1" ON "RNTMGR"."PR_VOLUSIA_IDS" ("FULL_PARCEL_ID")                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 20971520 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_VOLUSIA_IDS_N2" ON "RNTMGR"."PR_VOLUSIA_IDS" ("PARCEL_ID")                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 20971520 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_VOLUSIA_IDS_U1" ON "RNTMGR"."PR_VOLUSIA_IDS" ("ALT_KEY")                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 12582912 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_VOLUSIA_IDS_N3" ON "RNTMGR"."PR_VOLUSIA_IDS" ("SHORT_PARCEL_ID")                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 11534336 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_ACCOUNTS_PK" ON "RNTMGR"."RNT_ACCOUNTS" ("ACCOUNT_ID")                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 196608 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_ACCOUNTS_U1" ON "RNTMGR"."RNT_ACCOUNTS" ("ACCOUNT_NUMBER", "BUSINESS_ID")                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 196608 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_ACCOUNTS_N1" ON "RNTMGR"."RNT_ACCOUNTS" ("BUSINESS_ID")                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 196608 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_ACCOUNTS_PAYABLE_PK" ON "RNTMGR"."RNT_ACCOUNTS_PAYABLE" ("AP_ID")                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 125829120 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_ACCOUNTS_PAYABLE_I1" ON "RNTMGR"."RNT_ACCOUNTS_PAYABLE" ("PAYMENT_TYPE_ID", "SUPPLIER_ID", "PAYMENT_PRO
PERTY_ID", "BUSINESS_ID", "RECORD_TYPE", "AP_ID")                                                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 917504 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_ACCOUNTS_PAYABLE_N1" ON "RNTMGR"."RNT_ACCOUNTS_PAYABLE" ("PAYMENT_PROPERTY_ID")                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 458752 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_ACCOUNTS_PAYABLE_N2" ON "RNTMGR"."RNT_ACCOUNTS_PAYABLE" ("LOAN_ID")                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_ACCOUNTS_PAYABLE_N3" ON "RNTMGR"."RNT_ACCOUNTS_PAYABLE" ("SUPPLIER_ID")                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 458752 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_ACCOUNTS_PAYABLE_N4" ON "RNTMGR"."RNT_ACCOUNTS_PAYABLE" ("EXPENSE_ID")                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 458752 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_ACCOUNTS_RECEIVABLE_PK" ON "RNTMGR"."RNT_ACCOUNTS_RECEIVABLE" ("AR_ID")                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 196608 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_ACCOUNTS_RECEIVABLE_I1" ON "RNTMGR"."RNT_ACCOUNTS_RECEIVABLE" ("AR_ID", "PAYMENT_TYPE", "TENANT_ID", "A
GREEMENT_ID", "LOAN_ID", "BUSINESS_ID", "IS_GENERATED_YN", "AGREEMENT_ACTION_ID", "PAYMENT_PROPERTY_ID", "SOURCE_PAYMENT_ID", "RECOR
D_TYPE")                                                                                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 524288 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_ACCOUNTS_RECEIVABLE_N1" ON "RNTMGR"."RNT_ACCOUNTS_RECEIVABLE" ("SOURCE_PAYMENT_ID")                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_ACCOUNTS_RECEIVABLE_N2" ON "RNTMGR"."RNT_ACCOUNTS_RECEIVABLE" ("LOAN_ID")                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_ACCOUNTS_RECEIVABLE_N3" ON "RNTMGR"."RNT_ACCOUNTS_RECEIVABLE" ("PAYMENT_TYPE")                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 196608 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_ACCOUNTS_RECEIVABLE_N4" ON "RNTMGR"."RNT_ACCOUNTS_RECEIVABLE" ("AGREEMENT_ACTION_ID")                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_ACCOUNTS_RECEIVABLE_N5" ON "RNTMGR"."RNT_ACCOUNTS_RECEIVABLE" ("TENANT_ID")                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 196608 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_ACCOUNTS_RECEIVABLE_N6" ON "RNTMGR"."RNT_ACCOUNTS_RECEIVABLE" ("PAYMENT_PROPERTY_ID")                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 196608 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_ACCOUNT_BALANCES_PK" ON "RNTMGR"."RNT_ACCOUNT_BALANCES" ("ACCOUNT_ID", "PERIOD_ID")             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 196608 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_ACCOUNT_BALANCES_N1" ON "RNTMGR"."RNT_ACCOUNT_BALANCES" ("PERIOD_ID")                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 196608 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_ACCOUNT_PERIODS_PK" ON "RNTMGR"."RNT_ACCOUNT_PERIODS" ("PERIOD_ID")                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_ACCOUNT_PERIODS_U1" ON "RNTMGR"."RNT_ACCOUNT_PERIODS" ("BUSINESS_ID", "START_DATE")             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_ACCOUNT_TYPES_PK" ON "RNTMGR"."RNT_ACCOUNT_TYPES" ("ACCOUNT_TYPE")                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000075811C00008$$" ON "RNTMGR"."RNT_AGREEMENT_ACTIONS" (                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS"                                                                                                                
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_AGREEMENT_ACTIONS_UK1" ON "RNTMGR"."RNT_AGREEMENT_ACTIONS" ("AGREEMENT_ID", "ACTION_DATE", "ACTI
ON_TYPE")                                                                                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_AGREEMENT_ACTIONS_PK" ON "RNTMGR"."RNT_AGREEMENT_ACTIONS" ("ACTION_ID")                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_BUSINESS_UNITS_PK" ON "RNTMGR"."RNT_BUSINESS_UNITS" ("BUSINESS_ID")                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_BUSINESS_UNITS_U1" ON "RNTMGR"."RNT_BUSINESS_UNITS" ("PARENT_BUSINESS_ID", "BUSINESS_NAME")     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_BU_SUPPLIERS_U1" ON "RNTMGR"."RNT_BU_SUPPLIERS" ("BUSINESS_ID", "SUPPLIER_ID")                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_BU_SUPPLIERS_PK" ON "RNTMGR"."RNT_BU_SUPPLIERS" ("BU_SUPPLIER_ID")                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_BU_SUPPLIERS_N1" ON "RNTMGR"."RNT_BU_SUPPLIERS" ("SUPPLIER_ID")                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000075823C00005$$" ON "RNTMGR"."RNT_CITIES" (                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS"                                                                                                                
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_CITES_PK" ON "RNTMGR"."RNT_CITIES" ("CITY_ID")                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 589824 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_CITIES_U1" ON "RNTMGR"."RNT_CITIES" ("NAME", "COUNTY", "STATE")                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 2097152 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_CITIES_N1" ON "RNTMGR"."RNT_CITIES" ("COUNTY")                                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 983040 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_CITIES_N2" ON "RNTMGR"."RNT_CITIES" ("STATE")                                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 851968 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_CITY_ZIPCODES_PK" ON "RNTMGR"."RNT_CITY_ZIPCODES" ("CITY_ID", "ZIPCODE")                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 2097152 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_CITY_ZIPCODES_N1" ON "RNTMGR"."RNT_CITY_ZIPCODES" ("ZIPCODE")                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 2097152 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_DEFAULT_ACCOUNTS_PK" ON "RNTMGR"."RNT_DEFAULT_ACCOUNTS" ("ACCOUNT_NUMBER")                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_DEFAULT_ACCOUNTS_U1" ON "RNTMGR"."RNT_DEFAULT_ACCOUNTS" ("NAME")                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_DEFAULT_ACCOUNTS_N1" ON "RNTMGR"."RNT_DEFAULT_ACCOUNTS" ("ACCOUNT_TYPE")                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_DEFAULT_PT_RULES_PK" ON "RNTMGR"."RNT_DEFAULT_PT_RULES" ("PAYMENT_TYPE_ID", "TRANSACTION_TYPE") 
                                                                                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000075839C00004$$" ON "RNTMGR"."RNT_DOC_TEMPLATES" (                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS"                                                                                                                
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_DOC_TEMPLATES_PK" ON "RNTMGR"."RNT_DOC_TEMPLATES" ("TEMPLATE_ID")                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_DOC_TEMPLATES_U1" ON "RNTMGR"."RNT_DOC_TEMPLATES" ("NAME", "BUSINESS_ID")                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_ERROR_DESCRIPTION_U1" ON "RNTMGR"."RNT_ERROR_DESCRIPTION" ("ERROR_CODE")                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_ERROR_DESCRIPTION_PK" ON "RNTMGR"."RNT_ERROR_DESCRIPTION" ("ERROR_ID")                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_EXPENSE_ITEMS_PK" ON "RNTMGR"."RNT_EXPENSE_ITEMS" ("EXPENSE_ITEM_ID")                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_EXPENSE_ITEMS_U1" ON "RNTMGR"."RNT_EXPENSE_ITEMS" ("EXPENSE_ID", "SUPPLIER_ID", "ITEM_NAME")    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_EXPENSE_ITEMS_N1" ON "RNTMGR"."RNT_EXPENSE_ITEMS" ("SUPPLIER_ID")                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_LEDGER_ENTRIES_PK" ON "RNTMGR"."RNT_LEDGER_ENTRIES" ("LEDGER_ID")                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 2097152 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_LOANS_UK2" ON "RNTMGR"."RNT_LOANS" ("PROPERTY_ID", "POSITION")                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_LOANS_PK" ON "RNTMGR"."RNT_LOANS" ("LOAN_ID")                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_LOOKUP_TYPES_U1" ON "RNTMGR"."RNT_LOOKUP_TYPES" ("LOOKUP_TYPE_CODE")                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_LOOKUP_TYPES_PK" ON "RNTMGR"."RNT_LOOKUP_TYPES" ("LOOKUP_TYPE_ID")                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_LOOKUP_VALUES_U1" ON "RNTMGR"."RNT_LOOKUP_VALUES" ("LOOKUP_TYPE_ID", "LOOKUP_CODE")             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_LOOKUP_VALUES_PK" ON "RNTMGR"."RNT_LOOKUP_VALUES" ("LOOKUP_VALUE_ID")                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_MENUS_PK" ON "RNTMGR"."RNT_MENUS" ("TAB_NAME", "MENU_NAME")                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_MENU_LINKS_PK" ON "RNTMGR"."RNT_MENU_LINKS" ("TAB_NAME", "MENU_NAME", "LINK_TITLE")             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000075866C00008$$" ON "RNTMGR"."RNT_MENU_PAGES" (                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS"                                                                                                                
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000075866C00009$$" ON "RNTMGR"."RNT_MENU_PAGES" (                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS"                                                                                                                
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_MENU_PAGES_PK" ON "RNTMGR"."RNT_MENU_PAGES" ("TAB_NAME", "MENU_NAME", "PAGE_NAME", "SUB_PAGE")  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_MENU_ROLES_PK" ON "RNTMGR"."RNT_MENU_ROLES" ("TAB_NAME", "ROLE_ID")                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_MENU_ROLES_N1" ON "RNTMGR"."RNT_MENU_ROLES" ("ROLE_ID")                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_MENU_TABS_PK" ON "RNTMGR"."RNT_MENU_TABS" ("TAB_NAME")                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_MENU_TABS_N1" ON "RNTMGR"."RNT_MENU_TABS" ("PARENT_TAB")                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_PAYMENTS_UK1" ON "RNTMGR"."RNT_PAYMENTS" ("PAYMENT_DATE", "DESCRIPTION")                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 2097152 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_PAYMENTS_PK" ON "RNTMGR"."RNT_PAYMENTS" ("PAYMENT_ID")                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 262144 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_PAYMENTS_N1" ON "RNTMGR"."RNT_PAYMENTS" ("TENANT_ID")                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_PAYMENT_ALLOC_PK" ON "RNTMGR"."RNT_PAYMENT_ALLOCATIONS" ("PAY_ALLOC_ID")                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 720896 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_PAYMENT_ALLOCATIONS_I1" ON "RNTMGR"."RNT_PAYMENT_ALLOCATIONS" ("PAY_ALLOC_ID", "PAYMENT_ID", "AR_ID", "
AP_ID")                                                                                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 1048576 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_PAYMENT_ALLOC_N1" ON "RNTMGR"."RNT_PAYMENT_ALLOCATIONS" ("PAYMENT_ID")                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 262144 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_PAYMENT_ALLOC_N2" ON "RNTMGR"."RNT_PAYMENT_ALLOCATIONS" ("AP_ID")                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 458752 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_PAYMENT_ALLOC_N3" ON "RNTMGR"."RNT_PAYMENT_ALLOCATIONS" ("AR_ID")                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 262144 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_PAYMENT_TYPES_UK1" ON "RNTMGR"."RNT_PAYMENT_TYPES" ("PAYMENT_TYPE_NAME")                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_PAYMENT_TYPES_PK" ON "RNTMGR"."RNT_PAYMENT_TYPES" ("PAYMENT_TYPE_ID")                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_PEOPLE_PK" ON "RNTMGR"."RNT_PEOPLE" ("PEOPLE_ID")                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_PEOPLE_BU_U1" ON "RNTMGR"."RNT_PEOPLE_BU" ("PEOPLE_ID", "BUSINESS_ID")                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_PEOPLE_BU_PK" ON "RNTMGR"."RNT_PEOPLE_BU" ("PEOPLE_BUSINESS_ID")                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_PEOPLE_BU_N1" ON "RNTMGR"."RNT_PEOPLE_BU" ("BUSINESS_ID")                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_PROPERTIES_PK" ON "RNTMGR"."RNT_PROPERTIES" ("PROPERTY_ID")                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_PROPERTIES_I1" ON "RNTMGR"."RNT_PROPERTIES" ("BUSINESS_ID")                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_PROPERTIES_UK1" ON "RNTMGR"."RNT_PROPERTIES" ("BUSINESS_ID", "ADDRESS1", "ZIPCODE")             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_PROPERTIES_I2" ON "RNTMGR"."RNT_PROPERTIES" ("PROP_ID")                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_PROPERTY_ESTIMATES_PK" ON "RNTMGR"."RNT_PROPERTY_ESTIMATES" ("PROPERTY_ESTIMATES_ID")           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_PROPERTY_ESTIMATES_U1" ON "RNTMGR"."RNT_PROPERTY_ESTIMATES" ("PROPERTY_ID", "BUSINESS_ID", "ESTI
MATE_YEAR", "ESTIMATE_TITLE")                                                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_PROPERTY_ESTIMATES_N1" ON "RNTMGR"."RNT_PROPERTY_ESTIMATES" ("BUSINESS_ID")                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_PROPERTY_HISTORY_UK1" ON "RNTMGR"."RNT_PROPERTY_EXPENSES" ("PROPERTY_ID", "EVENT_DATE", "UNIT_ID
", "DESCRIPTION")                                                                                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 165 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 327680 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_PROPERTY_EXPENSES_PK" ON "RNTMGR"."RNT_PROPERTY_EXPENSES" ("EXPENSE_ID")                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_PROPERTY_EXPENSES_N1" ON "RNTMGR"."RNT_PROPERTY_EXPENSES" ("UNIT_ID")                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_PROPERTY_EXPENSES_N3" ON "RNTMGR"."RNT_PROPERTY_EXPENSES" ("LOAN_ID")                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_PROPERTY_LINKS_PK" ON "RNTMGR"."RNT_PROPERTY_LINKS" ("PROPERTY_LINK_ID")                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_PROPERTY_PHOTOS_PK" ON "RNTMGR"."RNT_PROPERTY_PHOTOS" ("PHOTO_ID")                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_PROPERTY_PHOTOS_N1" ON "RNTMGR"."RNT_PROPERTY_PHOTOS" ("PROPERTY_ID")                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_PROPERTY_UNITS_UK1" ON "RNTMGR"."RNT_PROPERTY_UNITS" ("PROPERTY_ID", "UNIT_NAME")               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_PROPERTY_UNITS_PK" ON "RNTMGR"."RNT_PROPERTY_UNITS" ("UNIT_ID")                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_PROPERTY_VALUE_UK1" ON "RNTMGR"."RNT_PROPERTY_VALUE" ("PROPERTY_ID", "VALUE_DATE", "VALUE_METHOD
")                                                                                                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_PROPERTY_VALUE_PK" ON "RNTMGR"."RNT_PROPERTY_VALUE" ("VALUE_ID")                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_PT_RULES_PK" ON "RNTMGR"."RNT_PT_RULES" ("BUSINESS_ID", "PAYMENT_TYPE_ID", "TRANSACTION_TYPE")  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 524288 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_SECTION8_OFFICES_PK" ON "RNTMGR"."RNT_SECTION8_OFFICES" ("SECTION8_ID")                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_SECTION8_OFFICES_BU_U1" ON "RNTMGR"."RNT_SECTION8_OFFICES_BU" ("SECTION8_ID", "BUSINESS_ID")    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_SECTION8_OFFICES_BU_PK" ON "RNTMGR"."RNT_SECTION8_OFFICES_BU" ("SECTION8_BUSINESS_ID")          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_SECTION8_OFFICES_BU_N1" ON "RNTMGR"."RNT_SECTION8_OFFICES_BU" ("BUSINESS_ID")                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_SUPPLIERS_ALL_U1" ON "RNTMGR"."RNT_SUPPLIERS_ALL" ("SUPPLIER_TYPE_ID", "NAME", "CITY", "PHONE1")
                                                                                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_CONTRACTORS_ALL_PK" ON "RNTMGR"."RNT_SUPPLIERS_ALL" ("SUPPLIER_ID")                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_CONTRACTORS_PK" ON "RNTMGR"."RNT_SUPPLIERS_OLD" ("SUPPLIER_ID")                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_CONTRACTORS_UK1" ON "RNTMGR"."RNT_SUPPLIERS_OLD" ("NAME", "BUSINESS_ID")                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_CONTRACTORS_N1" ON "RNTMGR"."RNT_SUPPLIERS_OLD" ("BUSINESS_ID")                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_SUPPLIER_TYPES_PK" ON "RNTMGR"."RNT_SUPPLIER_TYPES" ("SUPPLIER_TYPE_ID")                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_TENANCY_AGREEMENT_UK1" ON "RNTMGR"."RNT_TENANCY_AGREEMENT" ("UNIT_ID", "DATE_AVAILABLE")        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_TENANCY_AGREEMENT_PK" ON "RNTMGR"."RNT_TENANCY_AGREEMENT" ("AGREEMENT_ID")                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_TENANT_PK" ON "RNTMGR"."RNT_TENANT" ("TENANT_ID")                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_TENANT_U1" ON "RNTMGR"."RNT_TENANT" ("AGREEMENT_ID", "PEOPLE_ID")                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_TENANT_N1" ON "RNTMGR"."RNT_TENANT" ("SECTION8_ID")                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_TENANT_N2" ON "RNTMGR"."RNT_TENANT" ("PEOPLE_ID")                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_USER_U1" ON "RNTMGR"."RNT_USERS" ("USER_LOGIN")                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_USER_PK" ON "RNTMGR"."RNT_USERS" ("USER_ID")                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_USER_ASSIGNMENTS_PK" ON "RNTMGR"."RNT_USER_ASSIGNMENTS" ("USER_ASSIGN_ID")                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_USER_ASSIGNMENTS_U1" ON "RNTMGR"."RNT_USER_ASSIGNMENTS" ("ROLE_ID", "USER_ID", "BUSINESS_ID")   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_USER_ASSIGNMENTS_N1" ON "RNTMGR"."RNT_USER_ASSIGNMENTS" ("BUSINESS_ID")                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_USER_ASSIGNMENTS_N2" ON "RNTMGR"."RNT_USER_ASSIGNMENTS" ("USER_ID")                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_USER_REGISTRY_U1" ON "RNTMGR"."RNT_USER_REGISTRY" ("USER_HASH_VALUE")                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_USER_REGISTRY_PK" ON "RNTMGR"."RNT_USER_REGISTRY" ("USER_REGISTRY_ID")                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_USER_ROLES_U1" ON "RNTMGR"."RNT_USER_ROLES" ("ROLE_CODE")                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_USER_ROLES_PK" ON "RNTMGR"."RNT_USER_ROLES" ("ROLE_ID")                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000075961C00012$$" ON "RNTMGR"."RNT_ZIPCODES" (                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS"                                                                                                                
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000075961C00013$$" ON "RNTMGR"."RNT_ZIPCODES" (                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS"                                                                                                                
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."RNT_ZIPCODES_PK" ON "RNTMGR"."RNT_ZIPCODES" ("ZIPCODE")                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 2097152 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."DR$PR_OWNER_X1$X" ON "RNTMGR"."DR$PR_OWNER_X1$I" ("DR$TOKEN", "DR$TOKEN_TYPE", "DR$ROWID")          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS COMPRESS 2                                                                  
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."DR$PR_OWNER_X1$R" ON "RNTMGR"."DR$PR_OWNER_X1$I" ("DR$ROWID")                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."DR$PR_PROPERTIES_X1$X" ON "RNTMGR"."DR$PR_PROPERTIES_X1$I" ("DR$TOKEN", "DR$TOKEN_TYPE", "DR$ROWID")
                                                                                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS COMPRESS 2                                                                  
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."DR$PR_PROPERTIES_X1$R" ON "RNTMGR"."DR$PR_PROPERTIES_X1$I" ("DR$ROWID")                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."DR$PR_PROPERTIES_X101" ON "RNTMGR"."DR$PR_PROPERTIES_X1$I" ("DR$TOKEN", "DR$TOKEN_TYPE", "CITY", "DR
$ROWID")                                                                                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS COMPRESS 2                                                                  
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_LOCATIONS_FB1" ON "RNTMGR"."PR_LOCATIONS" ("RNTMGR"."PR_RECORDS_PKG"."STANDARD_SUFFIX"("ADDRESS1"))     
  PCTFREE 10 INITRANS 2 MAXTRANS 167 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 103940096 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000076179C00003$$" ON "RNTMGR"."MDRT_12992$" (                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS"                                                                                                                
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_PROPERTIES_FB1" ON "RNTMGR"."PR_PROPERTIES" ("RNTMGR"."PR_RECORDS_PKG"."STANDARD_SUFFIX"("ADDRESS1"))   
  PCTFREE 10 INITRANS 2 MAXTRANS 167 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 40894464 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_PROPERTIES_FB2" ON "RNTMGR"."PR_PROPERTIES" ("RNTMGR"."PR_RECORDS_PKG"."SQFT_CLASS"("SQ_FT"))           
  PCTFREE 10 INITRANS 2 MAXTRANS 167 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 32505856 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000076191C00003$$" ON "RNTMGR"."MDRT_1299E$" (                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS"                                                                                                                
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."I_SNAP$_PR_SALES_MV" ON "RNTMGR"."PR_SALES_MV" (SYS_OP_MAP_NONNULL("YEAR"), SYS_OP_MAP_NONNULL("MONT
H_YEAR"), SYS_OP_MAP_NONNULL("DISPLAY_DATE"), SYS_OP_MAP_NONNULL("CITY"))                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 2097152 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."I_SNAP$_PR_LAND_SALES_MV" ON "RNTMGR"."PR_LAND_SALES_MV" (SYS_OP_MAP_NONNULL("UCODE"), SYS_OP_MAP_NO
NNULL("SALES_YEAR"), SYS_OP_MAP_NONNULL("DESCRIPTION"))                                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000076317C00009$$" ON "RNTMGR"."PR_GEO" (                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                                                                                
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "PR_LOADER"                                                                                                            
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000076317C00010$$" ON "RNTMGR"."PR_GEO" (                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                                                                                
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "PR_LOADER"                                                                                                            
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_C0011541" ON "RNTMGR"."PR_GEO" ("ID")                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "PR_LOADER" ;                                                                                                          
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_NAL_N1" ON "RNTMGR"."PR_NAL" ("CO_NO")                                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "PR_LOADER" ;                                                                                                          
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_SDF_N1" ON "RNTMGR"."PR_SDF" ("CO_NO", "PARCEL_ID")                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "PR_LOADER" ;                                                                                                          
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_GEO_N1" ON "RNTMGR"."PR_GEO" ("PARCELNO")                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "PR_LOADER" ;                                                                                                          
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000076317C00017$$" ON "RNTMGR"."PR_GEO" (                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                                                                                
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "PR_LOADER"                                                                                                            
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000076317C00018$$" ON "RNTMGR"."PR_GEO" (                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                                                                                
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "PR_LOADER"                                                                                                            
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_MILLAGE_RATES_PK" ON "RNTMGR"."PR_MILLAGE_RATES" ("ID", "YEAR")                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "PR_LOADER" ;                                                                                                          
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_NAL_N2" ON "RNTMGR"."PR_NAL" ("PHY_CITY")                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "PR_LOADER" ;                                                                                                          
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."RNT_CITIES_N3" ON "RNTMGR"."RNT_CITIES" ("NAME")                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."I_SNAP$_PR_UCODE_SUMMARY_M" ON "RNTMGR"."PR_UCODE_SUMMARY_MV" (SYS_OP_MAP_NONNULL("ZIPCODE"), SYS_OP
_MAP_NONNULL("UCODE"))                                                                                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000075734C00042$$" ON "RNTMGR"."PR_PROPERTIES" (                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                                                                                
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS"                                                                                                                
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."SYS_IL0000075734C00043$$" ON "RNTMGR"."PR_PROPERTIES" (                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                                                                                
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS"                                                                                                                
  PARALLEL (DEGREE 0 INSTANCES 0) ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE UNIQUE INDEX "RNTMGR"."PR_PROPERTY_VALUES_PK" ON "RNTMGR"."PR_PROPERTY_VALUES" ("PROP_ID")                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."MLS_LISTINGS_SIDX" ON "RNTMGR"."MLS_LISTINGS" ("GEO_LOCATION")                                             
   INDEXTYPE IS "MDSYS"."SPATIAL_INDEX" ;                                                                                           
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."ZIPCODE_SIDX" ON "RNTMGR"."RNT_ZIPCODES" ("GEO_LOCATION")                                                  
   INDEXTYPE IS "MDSYS"."SPATIAL_INDEX" ;                                                                                           
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_OWNER_X1" ON "RNTMGR"."PR_OWNERS" ("OWNER_NAME")                                                        
   INDEXTYPE IS "CTXSYS"."CTXCAT" ;                                                                                                 
                                                                                                                                    
                                                                                                                                    
  CREATE INDEX "RNTMGR"."PR_PROPERTIES_X1" ON "RNTMGR"."PR_PROPERTIES" ("ADDRESS1")                                                 
   INDEXTYPE IS "CTXSYS"."CTXCAT"  PARAMETERS ('index set pr_city_iset');                                                           
                                                                                                                                    
SQL> spool off