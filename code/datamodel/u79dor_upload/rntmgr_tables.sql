  CREATE TABLE "RNTMGR"."BRD_BEDS"
   (	"SOURCE_PK" NUMBER(10,0),                                                                                                     
	"TOTAL_BEDROOMS" NUMBER,                                                                                                           
	"TOTAL_BATHROOMS" NUMBER                                                                                                           
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                                                                  
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 4194304 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                                                                                   
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                                                                 
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                                                                         
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."BRD_USECODES"                                                                                              
   (	"SOURCE_PK" NUMBER(10,0),                                                                                                      
	"USECODE" NUMBER(10,0)                                                                                                             
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 6291456 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                                                                    
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
 CELL_FLASH_CACHE DEFAULT)                                                                                                          
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."BRVD_GEO"                                                                                                  
   (	"RENUM" FLOAT(49),                                                                                                             
	"LONGITUDE" FLOAT(49),                                                                                                             
	"LATITUDE" FLOAT(49)                                                                                                               
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 9437184 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                                                                  
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."MLS_BROKERS"                                                                                               
   (	"BROKER_UID" VARCHAR2(64) NOT NULL ENABLE,                                                                                                                             
	"SOURCE_ID" NUMBER NOT NULL ENABLE,                                                                                                
	"NAME" VARCHAR2(128) NOT NULL ENABLE,                                                                                              
	"PHONE" VARCHAR2(16),                                                                                                              
	"URL" VARCHAR2(128),                                                                                                               
	 CONSTRAINT "MLS_BROKERS_PK" PRIMARY KEY ("BROKER_UID", "SOURCE_ID")                                                                                                             
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                                                                         
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                                                                 
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "MLS_BROKERS_R1" FOREIGN KEY ("SOURCE_ID")                                                                                                                              
	  REFERENCES "RNTMGR"."PR_SOURCES" ("SOURCE_ID") ENABLE                                                                                                                                 
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                                                                
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                                                                                  
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                                                                
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                                                                        
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."MLS_LISTINGS"                                                                                              
   (	"MLS_ID" NUMBER NOT NULL ENABLE,                                                                                               
	"PROP_ID" NUMBER NOT NULL ENABLE,                                                                                                  
	"SOURCE_ID" NUMBER NOT NULL ENABLE,                                                                                                
	"MLS_NUMBER" NUMBER NOT NULL ENABLE,                                                                                               
	"QUERY_TYPE" VARCHAR2(32) NOT NULL ENABLE,                                                                                         
	"LISTING_TYPE" VARCHAR2(16) NOT NULL ENAB                                                                                          
LE,                                                                                                                                 
	"LISTING_STATUS" VARCHAR2(16) NOT NULL ENABLE,                                                                                     
	"PRICE" NUMBER NOT NULL ENABLE,                                                                                                    
	"IDX_YN" VARCHAR2(1) NOT NULL ENABLE,                                                                                              
	"LISTING_BROKER" VARCHAR2(64) NOT NULL ENABLE,                                                                                     
	"LISTING_DATE" DATE NOT NULL ENABLE,                                                                                               
	"SHORT_DESC" VARCHAR2(128) NOT NULL ENABLE,                                                                                        
                                                                                                                                    
	"LINK_TEXT" VARCHAR2(64) NOT NULL ENABLE,                                                                                          
	"DESCRIPTION" VARCHAR2(4000) NOT NULL ENABLE,                                                                                      
	"LAST_ACTIVE" DATE NOT NULL ENABLE,                                                                                                
	"GEO_LOCATION" "SDO_GEOMETRY",                                                                                                     
	 CONSTRAINT "MLS_LISTINGS_PK" PRIMARY KEY ("MLS_ID")                                                                               
  USING INDEX PCTFREE 10 INITRANS 2 MAXTR                                                                                           
ANS 255 COMPUTE STATISTICS                                                                                                          
  STORAGE(INITIAL 2097152 NEXT 1048576 MINEXTENTS 1                                                                                 
MAXEXTENTS 2147483645                                                                                                               
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH                                                                                
_CACHE DEFAULT)                                                                                                                     
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "MLS_LISTINGS_U1" UNIQUE ("SOURCE_ID", "                                                                               
MLS_NUMBER")                                                                                                                        
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 25                                                                                     
5 COMPUTE STATISTICS                                                                                                                
  STORAGE(INITIAL 917504 NEXT 1048576 MINEXTENTS 1 MAXEXTE                                                                          
NTS 2147483645                                                                                                                      
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
                                                                                                                                    
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
DEFAULT)                                                                                                                            
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "MLS_LISTINGS_R1" FOREIGN K                                                                                            
EY ("SOURCE_ID")                                                                                                                    
	  REFERENCES "RNTMGR"."PR_SOURCES" ("SOURC                                                                                         
E_ID") ENABLE,                                                                                                                      
	 CONSTRAINT "MLS_LISTINGS_R2" FOREIGN KEY (                                                                                        
"PROP_ID")                                                                                                                          
	  REFERENCES "RNTMGR"."PR_PROPERTIES" ("PROP_ID"                                                                                   
) ENABLE                                                                                                                            
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 18874368 NEXT 1048576 MINEXTENT                                                                                   
S 1 MAXEXTENTS 2147483645                                                                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_F                                                                                    
LASH_CACHE DEFAULT)                                                                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."MLS_LISTINGS_ARCHIVE"                                                                                      
   (	"MLS_ID" NUMBER,                                                                                                               
	"PROP_ID" NUMBER,                                                                                                                  
	"SOURCE_ID" NUMBER,                                                                                                                
	"MLS_NUMBER" NUMBER,                                                                                                               
	"QUERY_TYPE" VARCHAR2(32),                                                                                                         
	"LISTING_TYPE" VARCHAR2(16),                                                                                                       
	"LISTING_STATUS" VARCHAR2(16),                                                                                                     
	"PRICE" NUMBER,                                                                                                                    
	"IDX_YN" VARCHAR2(1),                                                                                                              
	"LISTING_BROKER" VARCHAR2(64),                                                                                                     
	"LISTING_DATE" DATE,                                                                                                               
	"SHORT_DESC" VARCHAR2(128),                                                                                                        
	"LINK_TEXT" VARCHAR2(64),                                                                                                          
	"DESCRIPTION" VARCHAR2(4000),                                                                                                      
	"LAST_ACTIVE" DATE,                                                                                                                
	"GEO_LOCATION" "SDO_GEOMETRY"                                                                                                      
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 282525696 NEXT 1048576 MINEXT                                                                                     
ENTS 1 MAXEXTENTS 2147483645                                                                                                        
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CEL                                                                                       
L_FLASH_CACHE DEFAULT)                                                                                                              
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."MLS_PHOTOS"                                                                                                
   (	"MLS_ID" NUMBER NOT NULL ENABLE,                                                                                               
	"PHOTO_SEQ" NUMBER NOT NULL ENABLE,                                                                                                
	"PHOTO_URL" VARCHAR2(256) NOT NULL ENABLE,                                                                                         
                                                                                                                                    
	"PHOTO_DESC" VARCHAR2(256),                                                                                                        
	 CONSTRAINT "MLS_PHOTOS_PK" PRIMARY KEY ("MLS_ID                                                                                   
", "PHOTO_SEQ")                                                                                                                     
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS                                                                                        
 255 COMPUTE STATISTICS                                                                                                             
  STORAGE(INITIAL 6291456 NEXT 1048576 MINEXTENTS 1 MAX                                                                             
EXTENTS 2147483645                                                                                                                  
  PCTINCREASE 0 FREELISTS 1 FREELIST GROU                                                                                           
PS 1                                                                                                                                
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CA                                                                             
CHE DEFAULT)                                                                                                                        
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "MLS_PHOTOS_R1" FOREIGN KEY ("MLS_ID")                                                                                 
	  REFERENCES "RNTMGR"."MLS_LISTINGS" ("MLS_                                                                                        
ID") ENABLE                                                                                                                         
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 8388608 NEXT 1048576 MINEXTE                                                                                      
NTS 1 MAXEXTENTS 2147483645                                                                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL                                                                                      
_FLASH_CACHE DEFAULT)                                                                                                               
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."MLS_PHOTOS_ARCHIVE"                                                                                        
   (	"MLS_ID" NUMBER,                                                                                                               
	"PHOTO_SEQ" NUMBER,                                                                                                                
	"PHOTO_URL" VARCHAR2(256),                                                                                                         
	"PHOTO_DESC" VARCHAR2(256)                                                                                                         
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 94371840 NEXT 1048576 MINEXTENT                                                                                   
S 1 MAXEXTENTS 2147483645                                                                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_F                                                                                    
LASH_CACHE DEFAULT)                                                                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."MLS_PRICE_RANGES"                                                                                          
   (	"ZCODE" VARCHAR2(64) NOT NULL ENABLE,                                                                                          
	"LISTING_TYPE" VARCHAR2(16) NOT NULL ENABLE,                                                                                       
	"QUERY_TYPE" VARCHAR2(32) NOT NULL ENABLE,                                                                                         
                                                                                                                                    
	"RANGE_DATE" DATE NOT NULL ENABLE,                                                                                                 
	"SOURCE_ID" NUMBER NOT NULL ENABLE,                                                                                                
	"COUNTY" VARCHAR2(25) NOT NULL ENABLE,                                                                                             
	"STATE" VARCHAR2(2) NOT NULL ENABLE,                                                                                               
	"CURRENT_YN" VARCHAR2(1) NOT NULL ENABLE,                                                                                          
	"NAME" VARCHAR2(64) NOT NULL ENABLE,                                                                                               
	"A_MAX" NUMBER NOT NULL ENABLE,                                                                                                    
	"A_MEDIAN" NUMBER NOT NULL ENABLE,                                                                                                 
	"A_MIN" NUMBER NOT NULL ENABLE,                                                                                                    
	"B_MEDIAN" NUMBER NOT NULL ENABLE,                                                                                                 
	"C_MAX" NUMBER NOT NULL ENABLE,                                                                                                    
	"C_MEDIAN" NUMBER NOT NULL ENABLE,                                                                                                 
	"C_MIN" NUMBER NOT NULL ENABLE,                                                                                                    
	"TOTAL" NUMBER NOT NULL ENABLE,                                                                                                    
	 CONSTRAINT "MLS_PRICE_RANGES_PK" PRIMA                                                                                            
RY KEY ("ZCODE", "LISTING_TYPE", "QUERY_                                                                                            
TYPE", "RANGE_DATE", "SOURCE_ID", "COUNT                                                                                            
Y", "STATE")                                                                                                                        
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 25                                                                                     
5 COMPUTE STATISTICS                                                                                                                
  STORAGE(INITIAL 3145728 NEXT 1048576 MINEXTENTS 1 MAXEXT                                                                          
ENTS 2147483645                                                                                                                     
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
1                                                                                                                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
 DEFAULT)                                                                                                                           
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "MLS_PRICE_RANGES_R1" FOREIGN KEY ("SOURCE_ID"                                                                         
)                                                                                                                                   
	  REFERENCES "RNTMGR"."PR_SOURCES" ("SOURCE_ID") ENABLE                                                                            
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
                                                                                                                                    
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 4194304 NEXT 1048576 MINEXTENTS 1 MAXEXTE                                                                         
NTS 2147483645                                                                                                                      
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
                                                                                                                                    
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
DEFAULT)                                                                                                                            
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."MLS_RETS_RESPONSES"                                                                                        
   (	"MLS_NUMBER" NUMBER NOT NULL ENABLE,                                                                                           
	"DATE_FOUND" DATE NOT NULL ENABLE,                                                                                                 
	"QUERY_TYPE" VARCHAR2(32) NOT NULL ENABLE,                                                                                         
	"PROCESSED_YN" VARCHAR2(1) NOT NULL ENABLE,                                                                                        
	"RESPONSE" "SYS"."XMLTYPE" ,                                                                                                       
	"SOURCE_ID" NUMBER                                                                                                                 
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 40894464 NEXT 1048576 MINEXTENT                                                                                   
S 1 MAXEXTENTS 2147483645                                                                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_F                                                                                    
LASH_CACHE DEFAULT)                                                                                                                 
  TABLESPACE "USERS"                                                                                                                
 XMLTYPE COLUMN "RESPONSE" STORE AS BASICFILE CLOB (                                                                                
  TABLESPACE "USERS" ENABLE STORAGE IN ROW CH                                                                                       
UNK 8192 PCTVERSION 10                                                                                                              
  NOCACHE LOGGING                                                                                                                   
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTE                                                                          
NTS 2147483645                                                                                                                      
  PCTINCREASE 0 FREELISTS 4 FREELIST GROUPS 1                                                                                       
                                                                                                                                    
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
DEFAULT)) ;                                                                                                                         
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_BUILDINGS"                                                                                              
   (	"BUILDING_ID" NUMBER NOT NULL ENABLE,                                                                                          
	"PROP_ID" NUMBER NOT NULL ENABLE,                                                                                                  
	"BUILDING_NAME" VARCHAR2(64) NOT NULL ENABLE,                                                                                      
	"YEAR_BUILT" NUMBER(4,0),                                                                                                          
	"SQ_FT" NUMBER(8,0),                                                                                                               
	 CONSTRAINT "PR_BUILDINGS_PK" PRIMARY K                                                                                            
EY ("BUILDING_ID")                                                                                                                  
  USING INDEX PCTFREE 10 INITRANS 2 MAXTR                                                                                           
ANS 255 COMPUTE STATISTICS                                                                                                          
  STORAGE(INITIAL 8388608 NEXT 1048576 MINEXTENTS 1                                                                                 
MAXEXTENTS 2147483645                                                                                                               
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH                                                                                
_CACHE DEFAULT)                                                                                                                     
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "PR_BUILDINGS_FK1" FOREIGN KEY ("PROP_ID                                                                               
")                                                                                                                                  
	  REFERENCES "RNTMGR"."PR_PROPERTIES" ("PROP_ID") ENABLE                                                                           
                                                                                                                                    
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 25                                                                                      
5                                                                                                                                   
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 17825792 NEXT 1048576 MINEXTENTS 1 MAXE                                                                           
XTENTS 2147483645                                                                                                                   
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUP                                                                                          
S 1                                                                                                                                 
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CAC                                                                            
HE DEFAULT)                                                                                                                         
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_BUILDING_FEATURES"                                                                                      
   (	"FCODE" NUMBER NOT NULL ENABLE,                                                                                                
	"BUILDING_ID" NUMBER NOT NULL ENABLE,                                                                                              
	 CONSTRAINT "PR_BUILDING_FEATURES_PK" PRIMARY KEY ("                                                                               
FCODE", "BUILDING_ID")                                                                                                              
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE                                                                            
STATISTICS                                                                                                                          
  STORAGE(INITIAL 92274688 NEXT 1048576 MINEXTEN                                                                                    
TS 1 MAXEXTENTS 2147483645                                                                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_                                                                                     
FLASH_CACHE DEFAULT)                                                                                                                
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "PR_BUILDING_FEATURES_FK2" FOREIGN                                                                                     
KEY ("BUILDING_ID")                                                                                                                 
	  REFERENCES "RNTMGR"."PR_BUILDINGS" ("                                                                                            
BUILDING_ID") ENABLE,                                                                                                               
	 CONSTRAINT "PR_BUILDING_FEATURES_FK1" FOREIGN KEY ("FCO                                                                           
DE")                                                                                                                                
	  REFERENCES "RNTMGR"."PR_FEATURE_CODES" ("FCODE") ENA                                                                             
BLE                                                                                                                                 
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS                                                                                         
 255                                                                                                                                
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 37748736 NEXT 1048576 MINEXTENTS 1 M                                                                              
AXEXTENTS 2147483645                                                                                                                
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_                                                                               
CACHE DEFAULT)                                                                                                                      
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_BUILDING_USAGE"                                                                                         
   (	"UCODE" NUMBER NOT NULL ENABLE,                                                                                                
	"BUILDING_ID" NUMBER NOT NULL ENABLE,                                                                                              
	 CONSTRAINT "PR_BUILDING_USAGE_PK" PRIMARY KEY ("UCODE"                                                                            
, "BUILDING_ID")                                                                                                                    
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRAN                                                                                         
S 255 COMPUTE STATISTICS                                                                                                            
  STORAGE(INITIAL 16777216 NEXT 1048576 MINEXTENTS 1 M                                                                              
AXEXTENTS 2147483645                                                                                                                
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_                                                                               
CACHE DEFAULT)                                                                                                                      
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "PR_BUILDING_USAGE_FK2" FOREIGN KEY ("BUI                                                                              
LDING_ID")                                                                                                                          
	  REFERENCES "RNTMGR"."PR_BUILDINGS" ("BUILDING_                                                                                   
ID") ENABLE,                                                                                                                        
	 CONSTRAINT "PR_BUILDING_USAGE_FK1" FOREIGN K                                                                                      
EY ("UCODE")                                                                                                                        
	  REFERENCES "RNTMGR"."PR_USAGE_CODES" ("UCODE                                                                                     
") ENABLE                                                                                                                           
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 7340032 NEXT 1048576 MINEXTENT                                                                                    
S 1 MAXEXTENTS 2147483645                                                                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_F                                                                                    
LASH_CACHE DEFAULT)                                                                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_CITY_ZIPCODES"                                                                                          
   (	"CITY_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"ZIPCODE" VARCHAR2(7) NOT NULL ENABLE,                                                                                             
	 CONSTRAINT "PR_CITY_ZIPCODES_PK" PRIMARY KEY ("CITY_                                                                              
ID", "ZIPCODE")                                                                                                                     
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS                                                                                        
 255 COMPUTE STATISTICS                                                                                                             
  STORAGE(INITIAL 2097152 NEXT 1048576 MINEXTENTS 1 MAX                                                                             
EXTENTS 2147483645                                                                                                                  
  PCTINCREASE 0 FREELISTS 1 FREELIST GROU                                                                                           
PS 1                                                                                                                                
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CA                                                                             
CHE DEFAULT)                                                                                                                        
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "PR_CITY_ZIPCODES_R1" FOREIGN KEY ("CITY_ID                                                                            
")                                                                                                                                  
	  REFERENCES "RNTMGR"."RNT_CITIES" ("CITY_ID") ENABLE                                                                              
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 851968 NEXT 1048576 MI                                                                                            
NEXTENTS 1 MAXEXTENTS 2147483645                                                                                                    
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
 CELL_FLASH_CACHE DEFAULT)                                                                                                          
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_COMMERCIAL_SALES_MV"                                                                                    
   (	"UCODE" NUMBER NOT NULL ENABLE,                                                                                                
	"SALES_YEAR" VARCHAR2(4),                                                                                                          
	"DESCRIPTION" VARCHAR2(128) NOT NULL ENABL                                                                                         
E,                                                                                                                                  
	"SALES_COUNT" NUMBER,                                                                                                              
	"TOTAL_SALES" NUMBER,                                                                                                              
	"AVG_PRICE" NUMBER                                                                                                                 
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 327680 NEXT 1048576 MINEXTEN                                                                                      
TS 1 MAXEXTENTS 2147483645                                                                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_                                                                                     
FLASH_CACHE DEFAULT)                                                                                                                
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_COMMERCIAL_SUMMARY_MV"                                                                                  
   (	"YEAR" VARCHAR2(4),                                                                                                            
	"SALES_COUNT" NUMBER,                                                                                                              
	"TOTAL_SALES" NUMBER,                                                                                                              
	"AVG_PRICE" NUMBER                                                                                                                 
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTR                                                                                            
ANS 255                                                                                                                             
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 M                                                                                 
AXEXTENTS 2147483645                                                                                                                
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_                                                                               
CACHE DEFAULT)                                                                                                                      
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_CORPORATE_LOCATIONS"                                                                                    
   (	"LOC_ID" NUMBER NOT NULL ENABLE,                                                                                               
	"CORP_NUMBER" VARCHAR2(12) NOT NULL ENABLE,                                                                                        
	"LOC_TYPE" VARCHAR2(4) NOT NULL ENABLE,                                                                                            
	 CONSTRAINT "PR_CORPORATE_LOCATIONS_PK" P                                                                                          
RIMARY KEY ("LOC_ID", "CORP_NUMBER", "LO                                                                                            
C_TYPE")                                                                                                                            
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 CO                                                                                 
MPUTE STATISTICS                                                                                                                    
  STORAGE(INITIAL 167772160 NEXT 1048576 M                                                                                          
INEXTENTS 1 MAXEXTENTS 2147483645                                                                                                   
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAUL                                                                                            
T CELL_FLASH_CACHE DEFAULT)                                                                                                         
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 109051904 NEXT 1048576                                                                                            
MINEXTENTS 1 MAXEXTENTS 2147483645                                                                                                  
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
                                                                                                                                    
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
DEFAULT)                                                                                                                            
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_CORPORATE_POSITIONS"                                                                                    
   (	"CORP_NUMBER" VARCHAR2(12) NOT NULL ENABLE,                                                                                    
                                                                                                                                    
	"PN_ID" NUMBER NOT NULL ENABLE,                                                                                                    
	"TITLE_CODE" VARCHAR2(4),                                                                                                          
	 CONSTRAINT "PR_CORPORATE_POSITIONS_PK" PRIMARY KEY ("CO                                                                           
RP_NUMBER", "PN_ID")                                                                                                                
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE ST                                                                         
ATISTICS                                                                                                                            
  STORAGE(INITIAL 134217728 NEXT 1048576 MINEXTENT                                                                                  
S 1 MAXEXTENTS 2147483645                                                                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_F                                                                                    
LASH_CACHE DEFAULT)                                                                                                                 
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 117440512 NEXT 1048576 MINEXTEN                                                                                   
TS 1 MAXEXTENTS 2147483645                                                                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_                                                                                     
FLASH_CACHE DEFAULT)                                                                                                                
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_CORPORATIONS"                                                                                           
   (	"CORP_NUMBER" VARCHAR2(12) NOT NULL ENABLE,                                                                                    
	"NAME" VARCHAR2(192) NOT NULL ENABLE,                                                                                              
	"STATUS" VARCHAR2(1) NOT NULL ENABLE,                                                                                              
	"FILING_TYPE" VARCHAR2(15),                                                                                                        
	"FILING_DATE" DATE,                                                                                                                
	"FEI_NUMBER" VARCHAR2(14),                                                                                                         
	"OWNER_ID" NUMBER,                                                                                                                 
	 CONSTRAINT "PR_CORPORATIONS_PK" PRIMARY KE                                                                                        
Y ("CORP_NUMBER")                                                                                                                   
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRA                                                                                          
NS 255 COMPUTE STATISTICS                                                                                                           
  STORAGE(INITIAL 49283072 NEXT 1048576 MINEXTENTS 1                                                                                
MAXEXTENTS 2147483645                                                                                                               
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH                                                                                
_CACHE DEFAULT)                                                                                                                     
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRAN                                                                                          
S 255                                                                                                                               
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 142606336 NEXT 1048576 MINEXTENTS 1                                                                               
 MAXEXTENTS 2147483645                                                                                                              
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLAS                                                                                 
H_CACHE DEFAULT)                                                                                                                    
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_DEED_CODES"                                                                                             
   (	"DEED_CODE" VARCHAR2(16) NOT NULL ENABLE,                                                                                      
	"DESCRIPTION" VARCHAR2(64) NOT NULL ENABLE,                                                                                        
	"DEFINITION" VARCHAR2(4000),                                                                                                       
	 CONSTRAINT "PR_DEED_CODES_PK" PRIMARY KEY ("DEED_CO                                                                               
DE")                                                                                                                                
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUT                                                                             
E STATISTICS                                                                                                                        
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENT                                                                                      
S 1 MAXEXTENTS 2147483645                                                                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_F                                                                                    
LASH_CACHE DEFAULT)                                                                                                                 
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1                                                                                   
 MAXEXTENTS 2147483645                                                                                                              
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLAS                                                                                 
H_CACHE DEFAULT)                                                                                                                    
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_FEATURE_CODES"                                                                                          
   (	"FCODE" NUMBER NOT NULL ENABLE,                                                                                                
	"DESCRIPTION" VARCHAR2(128) NOT NULL ENABLE,                                                                                       
	"PARENT_FCODE" NUMBER,                                                                                                             
	 CONSTRAINT "PR_FEATURE_CODES_PK" PRIMARY KE                                                                                       
Y ("FCODE")                                                                                                                         
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255                                                                                    
 COMPUTE STATISTICS                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENT                                                                         
S 2147483645                                                                                                                        
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
 CELL_FLASH_CACHE DEFAULT)                                                                                                          
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "PR_FEATURE_CODES_FK1" FOREIG                                                                                          
N KEY ("PARENT_FCODE")                                                                                                              
	  REFERENCES "RNTMGR"."PR_FEATURE_CODES" ("FCODE") ENABL                                                                           
E                                                                                                                                   
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 2                                                                                       
55                                                                                                                                  
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXT                                                                            
ENTS 2147483645                                                                                                                     
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
1                                                                                                                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
 DEFAULT)                                                                                                                           
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_GIS_COORDS"                                                                                             
   (	"SOURCE_ID" NUMBER,                                                                                                            
	"SOURCE_PK" VARCHAR2(32),                                                                                                          
	"LAT" NUMBER,                                                                                                                      
	"LON" NUMBER,                                                                                                                      
	"PROCESSED_YN" VARCHAR2(1) DEFAULT 'N'                                                                                             
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 50331648 NEXT 1048576 MINEXTENTS                                                                                  
 1 MAXEXTENTS 2147483645                                                                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FL                                                                                   
ASH_CACHE DEFAULT)                                                                                                                  
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_LAND_SALES_MV"                                                                                          
   (	"UCODE" NUMBER NOT NULL ENABLE,                                                                                                
	"SALES_YEAR" VARCHAR2(4),                                                                                                          
	"DESCRIPTION" VARCHAR2(128) NOT NULL ENABLE,                                                                                       
	"SALES_COUNT" NUMBER,                                                                                                              
	"TOTAL_SALES" NUMBER,                                                                                                              
	"AVG_PRICE" NUMBER                                                                                                                 
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRA                                                                                           
NS 255                                                                                                                              
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 M                                                                                
AXEXTENTS 2147483645                                                                                                                
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_                                                                               
CACHE DEFAULT)                                                                                                                      
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_LAND_SUMMARY_MV"                                                                                        
   (	"YEAR" VARCHAR2(4),                                                                                                            
	"SALES_COUNT" NUMBER,                                                                                                              
	"TOTAL_SALES" NUMBER,                                                                                                              
	"AVG_PRICE" NUMBER                                                                                                                 
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 25                                                                                      
5                                                                                                                                   
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTE                                                                           
NTS 2147483645                                                                                                                      
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
                                                                                                                                    
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
DEFAULT)                                                                                                                            
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_LOCATIONS"                                                                                              
   (	"LOC_ID" NUMBER NOT NULL ENABLE,                                                                                               
	"ADDRESS1" VARCHAR2(42) NOT NULL ENABLE                                                                                            
,                                                                                                                                   
	"ADDRESS2" VARCHAR2(42),                                                                                                           
	"CITY" VARCHAR2(28),                                                                                                               
	"STATE" VARCHAR2(2),                                                                                                               
	"ZIPCODE" NUMBER(5,0),                                                                                                             
	"ZIP4" NUMBER(4,0),                                                                                                                
	"COUNTRY" VARCHAR2(2),                                                                                                             
	"PROP_ID" NUMBER,                                                                                                                  
	"GEO_LOCATION" "SDO_GEOMETRY",                                                                                                     
	"GEO_FOUND_YN" VARCHAR2(1) DEFAULT 'Y' NOT NULL ENABLE,                                                                            
	 CONSTRAINT "PR_LOCATIONS_PK" PRIMARY KE                                                                                           
Y ("LOC_ID")                                                                                                                        
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 25                                                                                     
5 COMPUTE STATISTICS                                                                                                                
  STORAGE(INITIAL 75497472 NEXT 1048576 MINEXTENTS 1 MAXEX                                                                          
TENTS 2147483645                                                                                                                    
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
 1                                                                                                                                  
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACH                                                                           
E DEFAULT)                                                                                                                          
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "PR_LOCATIONS_U1" UNIQUE ("ADDRESS1", "ADDRES                                                                          
S2", "ZIPCODE")                                                                                                                     
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS                                                                                        
 255 COMPUTE STATISTICS                                                                                                             
  STORAGE(INITIAL 129368064 NEXT 1048576 MINEXTENTS 1 M                                                                             
AXEXTENTS 2147483645                                                                                                                
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_                                                                               
CACHE DEFAULT)                                                                                                                      
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "PR_LOCATIONS_F1" FOREIGN KEY ("PROP_ID")                                                                              
                                                                                                                                    
	  REFERENCES "RNTMGR"."PR_PROPERTIES" ("PROP_ID") ENABLE N                                                                         
OVALIDATE                                                                                                                           
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 268435456 NEXT 1048576 MINEXTE                                                                                    
NTS 1 MAXEXTENTS 2147483645                                                                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL                                                                                      
_FLASH_CACHE DEFAULT)                                                                                                               
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_OWNERS"                                                                                                 
   (	"OWNER_ID" NUMBER NOT NULL ENABLE,                                                                                             
	"OWNER_NAME" VARCHAR2(64) NOT NULL ENABL                                                                                           
E,                                                                                                                                  
	"OWNER_TYPE" VARCHAR2(8),                                                                                                          
	 CONSTRAINT "PR_OWNERS_PK" PRIMARY KEY ("OWNER_                                                                                    
ID")                                                                                                                                
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUT                                                                             
E STATISTICS                                                                                                                        
  STORAGE(INITIAL 35651584 NEXT 1048576 MINEXT                                                                                      
ENTS 1 MAXEXTENTS 2147483645                                                                                                        
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CEL                                                                                       
L_FLASH_CACHE DEFAULT)                                                                                                              
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 75497472 NEXT 1048576 MINEXT                                                                                      
ENTS 1 MAXEXTENTS 2147483645                                                                                                        
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CEL                                                                                       
L_FLASH_CACHE DEFAULT)                                                                                                              
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_PRINCIPALS"                                                                                             
   (	"PN_ID" NUMBER NOT NULL ENABLE,                                                                                                
	"PN_TYPE" VARCHAR2(1) NOT NULL ENABLE,                                                                                             
                                                                                                                                    
	"PN_NAME" VARCHAR2(42) NOT NULL ENABLE,                                                                                            
	 CONSTRAINT "PR_PRINCIPALS_PK" PRIMARY KEY ("PN_ID")                                                                               
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRAN                                                                                         
S 255 COMPUTE STATISTICS                                                                                                            
  STORAGE(INITIAL 56623104 NEXT 1048576 MINEXTENTS 1 M                                                                              
AXEXTENTS 2147483645                                                                                                                
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_                                                                               
CACHE DEFAULT)                                                                                                                      
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "PR_PRINCIPALS_U1" UNIQUE ("PN_TYPE", "PN                                                                              
_NAME")                                                                                                                             
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COM                                                                                
PUTE STATISTICS                                                                                                                     
  STORAGE(INITIAL 133496832 NEXT 1048576 MI                                                                                         
NEXTENTS 1 MAXEXTENTS 2147483645                                                                                                    
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
 CELL_FLASH_CACHE DEFAULT)                                                                                                          
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 134217728 NEXT 1048576 M                                                                                          
INEXTENTS 1 MAXEXTENTS 2147483645                                                                                                   
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAUL                                                                                            
T CELL_FLASH_CACHE DEFAULT)                                                                                                         
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_PRINCIPAL_LOCATIONS"                                                                                    
   (	"LOC_ID" NUMBER NOT NULL ENABLE,                                                                                               
	"PN_ID" NUMBER NOT NULL ENABLE,                                                                                                    
	 CONSTRAINT "PR_PRINCIPAL_LOCATIONS_PK" PRIMARY KEY ("L                                                                            
OC_ID", "PN_ID")                                                                                                                    
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRAN                                                                                         
S 255 COMPUTE STATISTICS                                                                                                            
  STORAGE(INITIAL 142606336 NEXT 1048576 MINEXTENTS 1                                                                               
MAXEXTENTS 2147483645                                                                                                               
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH                                                                                
_CACHE DEFAULT)                                                                                                                     
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRAN                                                                                          
S 255                                                                                                                               
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 83886080 NEXT 1048576 MINEXTENTS 1                                                                                
MAXEXTENTS 2147483645                                                                                                               
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH                                                                                
_CACHE DEFAULT)                                                                                                                     
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_PROPERTIES"                                                                                             
   (	"PROP_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"SOURCE_ID" NUMBER NOT NULL ENABLE,                                                                                                
	"SOURCE_PK" VARCHAR2(32),                                                                                                          
	"ADDRESS1" VARCHAR2(60) NOT NULL ENABLE,                                                                                           
	"ADDRESS2" VARCHAR2(60),                                                                                                           
	"CITY" VARCHAR2(30) NOT NULL ENABLE,                                                                                               
	"STATE" VARCHAR2(2) NOT NULL ENABLE,                                                                                               
	"ZIPCODE" VARCHAR2(7) NOT NULL ENABLE,                                                                                             
	"ACREAGE" NUMBER,                                                                                                                  
	"SQ_FT" NUMBER(8,0),                                                                                                               
	"PROP_CLASS" VARCHAR2(1) DEFAULT 'B' NO                                                                                            
T NULL ENABLE,                                                                                                                      
	"GEO_LOCATION" "SDO_GEOMETRY",                                                                                                     
	"TOTAL_BEDROOMS" NUMBER,                                                                                                           
	"TOTAL_BATHROOMS" NUMBER,                                                                                                          
	"GEO_FOUND_YN" VARCHAR2(1) DEFAULT 'Y' NOT NULL ENABLE,                                                                            
                                                                                                                                    
	"PARCEL_ID" VARCHAR2(26),                                                                                                          
	"ALT_KEY" VARCHAR2(26),                                                                                                            
	"VALUE_GROUP" NUMBER(1,0),                                                                                                         
	"QUALITY_CODE" NUMBER(1,0),                                                                                                        
	"YEAR_BUILT" NUMBER(4,0),                                                                                                          
	"BUILDING_COUNT" NUMBER(4,0),                                                                                                      
	"RESIDENTIAL_UNITS" NUMBER(4,0),                                                                                                   
	"LEGAL_DESC" VARCHAR2(30),                                                                                                         
	"MARKET_AREA" VARCHAR2(3),                                                                                                         
	"NEIGHBORHOOD_CODE" VARCHAR2(10),                                                                                                  
	"CENSUS_BK" VARCHAR2(16),                                                                                                          
	"GEO_COORDINATES" "MDSYS"."SDO_GEOMETRY" ,                                                                                         
	 CONSTRAINT "PR_PROPERTIES_PK" PRIMARY KEY                                                                                         
 ("PROP_ID")                                                                                                                        
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 25                                                                                     
5 COMPUTE STATISTICS                                                                                                                
  STORAGE(INITIAL 29360128 NEXT 1048576 MINEXTENTS 1 MAXEX                                                                          
TENTS 2147483645                                                                                                                    
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
 1                                                                                                                                  
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACH                                                                           
E DEFAULT)                                                                                                                          
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "PR_PROPERTIES_FK1" FOREIGN KEY ("SOURCE_ID")                                                                          
                                                                                                                                    
	  REFERENCES "RNTMGR"."PR_SOURCES" ("SOURCE_ID") ENABLE,                                                                           
	 CONSTRAINT "PR_PROPERTIES_R2" FOREIGN                                                                                             
KEY ("PROP_CLASS")                                                                                                                  
	  REFERENCES "RNTMGR"."PR_PROP_CLASS" ("                                                                                           
PROP_CLASS") ENABLE                                                                                                                 
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
                                                                                                                                    
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 201326592 NEXT 1048576 MINEXTENTS 1 MAXE                                                                          
XTENTS 2147483645                                                                                                                   
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUP                                                                                          
S 1                                                                                                                                 
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CAC                                                                            
HE DEFAULT)                                                                                                                         
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_PROPERTY_LINKS"                                                                                         
   (	"PROP_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"URL" VARCHAR2(256) NOT NULL ENABLE,                                                                                               
	"TITLE" VARCHAR2(128),                                                                                                             
	 CONSTRAINT "PR_PROPERTY_LINKS_PK" PRIMARY KEY ("                                                                                  
PROP_ID", "URL")                                                                                                                    
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRAN                                                                                         
S 255 COMPUTE STATISTICS                                                                                                            
  STORAGE(INITIAL 17825792 NEXT 1048576 MINEXTENTS 1 M                                                                              
AXEXTENTS 2147483645                                                                                                                
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_                                                                               
CACHE DEFAULT)                                                                                                                      
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "PR_PROPERTY_LINKS_FK1" FOREIGN KEY ("PRO                                                                              
P_ID")                                                                                                                              
	  REFERENCES "RNTMGR"."PR_PROPERTIES" ("PROP_ID") EN                                                                               
ABLE                                                                                                                                
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRAN                                                                                          
S 255                                                                                                                               
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 19922944 NEXT 1048576 MINEXTENTS 1                                                                                
MAXEXTENTS 2147483645                                                                                                               
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH                                                                                
_CACHE DEFAULT)                                                                                                                     
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_PROPERTY_LISTINGS"                                                                                      
   (	"PROP_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"BUSINESS_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"LISTING_DATE" DATE NOT NULL ENABLE,                                                                                               
	"PRICE" NUMBER NOT NULL ENABLE,                                                                                                    
	"PUBLISH_YN" VARCHAR2(1) NOT NULL ENABLE,                                                                                          
	"SOLD_YN" VARCHAR2(1) NOT NULL ENABLE,                                                                                             
	"DESCRIPTION" VARCHAR2(4000),                                                                                                      
	"SOURCE" VARCHAR2(64),                                                                                                             
	"AGENT_NAME" VARCHAR2(64),                                                                                                         
	"AGENT_PHONE" VARCHAR2(16),                                                                                                        
	"AGENT_EMAIL" VARCHAR2(64),                                                                                                        
	"AGENT_WEBSITE" VARCHAR2(128),                                                                                                     
	 CONSTRAINT "PR_PROPERTY_LISTINGS_PK" PRIMARY KEY ("P                                                                              
ROP_ID", "BUSINESS_ID", "LISTING_DATE")                                                                                             
  USING INDEX PCTFREE 10 INITRANS 2 MAXT                                                                                            
RANS 255 COMPUTE STATISTICS                                                                                                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 M                                                                                 
AXEXTENTS 2147483645                                                                                                                
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_                                                                               
CACHE DEFAULT)                                                                                                                      
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "PR_PROPERTY_LISTINGS_R2" FOREIGN KEY ("B                                                                              
USINESS_ID")                                                                                                                        
	  REFERENCES "RNTMGR"."RNT_BUSINESS_UNITS" ("B                                                                                     
USINESS_ID") ENABLE,                                                                                                                
	 CONSTRAINT "PR_PROPERTY_LISTINGS_R1" FOREIGN KEY ("PROP_                                                                          
ID")                                                                                                                                
	  REFERENCES "RNTMGR"."PR_PROPERTIES" ("PROP_ID") ENAB                                                                             
LE                                                                                                                                  
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS                                                                                         
255                                                                                                                                 
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEX                                                                             
TENTS 2147483645                                                                                                                    
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
 1                                                                                                                                  
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACH                                                                           
E DEFAULT)                                                                                                                          
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_PROPERTY_OWNERS"                                                                                        
   (	"OWNER_ID" NUMBER NOT NULL ENABLE,                                                                                             
	"PROP_ID" NUMBER NOT NULL ENABLE,                                                                                                  
	"MAILING_ID" NUMBER,                                                                                                               
	 CONSTRAINT "PR_PROPERTY_OWNERS_PK" PRIMARY KEY ("OW                                                                               
NER_ID", "PROP_ID")                                                                                                                 
  USING INDEX PCTFREE 10 INITRANS 2 MAXT                                                                                            
RANS 255 COMPUTE STATISTICS                                                                                                         
  STORAGE(INITIAL 39845888 NEXT 1048576 MINEXTENTS                                                                                  
1 MAXEXTENTS 2147483645                                                                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLA                                                                                  
SH_CACHE DEFAULT)                                                                                                                   
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "PR_PROPERTY_OWNERS_FK3" FOREIGN KEY (                                                                                 
"MAILING_ID")                                                                                                                       
	  REFERENCES "RNTMGR"."PR_PROPERTIES" ("PROP_                                                                                      
ID") ENABLE,                                                                                                                        
	 CONSTRAINT "PR_PROPERTY_OWNERS_FK2" FOREIGN                                                                                       
KEY ("PROP_ID")                                                                                                                     
	  REFERENCES "RNTMGR"."PR_PROPERTIES" ("PRO                                                                                        
P_ID") ENABLE,                                                                                                                      
	 CONSTRAINT "PR_PROPERTY_OWNERS_FK1" FOREIG                                                                                        
N KEY ("OWNER_ID")                                                                                                                  
	  REFERENCES "RNTMGR"."PR_OWNERS" ("OWNE                                                                                           
R_ID") ENABLE                                                                                                                       
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 27262976 NEXT 1048576 MINE                                                                                        
XTENTS 1 MAXEXTENTS 2147483645                                                                                                      
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT C                                                                                         
ELL_FLASH_CACHE DEFAULT)                                                                                                            
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_PROPERTY_PHOTOS"                                                                                        
   (	"PROP_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"URL" VARCHAR2(256) NOT NULL ENABLE,                                                                                               
	"FILENAME" VARCHAR2(32),                                                                                                           
	 CONSTRAINT "PR_PROPERTY_PHOTOS_PK" PRIMARY KE                                                                                     
Y ("PROP_ID", "URL")                                                                                                                
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE ST                                                                         
ATISTICS                                                                                                                            
  STORAGE(INITIAL 117374976 NEXT 1048576 MINEXTENT                                                                                  
S 1 MAXEXTENTS 2147483645                                                                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_F                                                                                    
LASH_CACHE DEFAULT)                                                                                                                 
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "PR_PROPERTY_PHOTOS_R1" FOREIGN KEY                                                                                    
("PROP_ID")                                                                                                                         
	  REFERENCES "RNTMGR"."PR_PROPERTIES" ("PROP_ID                                                                                    
") ENABLE                                                                                                                           
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 125829120 NEXT 1048576 MINEXTE                                                                                    
NTS 1 MAXEXTENTS 2147483645                                                                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL                                                                                      
_FLASH_CACHE DEFAULT)                                                                                                               
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_PROPERTY_SALES"                                                                                         
   (	"PROP_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"NEW_OWNER_ID" NUMBER NOT NULL ENABLE,                                                                                             
	"SALE_DATE" DATE NOT NULL ENABLE,                                                                                                  
	"DEED_CODE" VARCHAR2(16),                                                                                                          
	"PRICE" NUMBER,                                                                                                                    
	"OLD_OWNER_ID" NUMBER,                                                                                                             
	"PLAT_BOOK" VARCHAR2(8),                                                                                                           
	"PLAT_PAGE" VARCHAR2(8),                                                                                                           
	 CONSTRAINT "PR_PROPERTY_SALES_PK" UNIQUE ("PROP_ID                                                                                
", "NEW_OWNER_ID", "SALE_DATE")                                                                                                     
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255                                                                                    
 COMPUTE STATISTICS                                                                                                                 
  STORAGE(INITIAL 134217728 NEXT 1048576 MINEXTENTS 1 MAXEX                                                                         
TENTS 2147483645                                                                                                                    
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
 1                                                                                                                                  
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACH                                                                           
E DEFAULT)                                                                                                                          
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "PR_PROPERTY_SALES_FK4" FOREIGN KEY ("DEED_CO                                                                          
DE")                                                                                                                                
	  REFERENCES "RNTMGR"."PR_DEED_CODES" ("DEED_CODE") EN                                                                             
ABLE,                                                                                                                               
	 CONSTRAINT "PR_PROPERTY_SALES_FK3" FOREIGN KEY ("PR                                                                               
OP_ID")                                                                                                                             
	  REFERENCES "RNTMGR"."PR_PROPERTIES" ("PROP_ID") E                                                                                
NABLE,                                                                                                                              
	 CONSTRAINT "PR_PROPERTY_SALES_FK2" FOREIGN KEY ("O                                                                                
LD_OWNER_ID")                                                                                                                       
	  REFERENCES "RNTMGR"."PR_OWNERS" ("OWNER_ID"                                                                                      
) ENABLE,                                                                                                                           
	 CONSTRAINT "PR_PROPERTY_SALES_FK1" FOREIGN KEY                                                                                    
("NEW_OWNER_ID")                                                                                                                    
	  REFERENCES "RNTMGR"."PR_OWNERS" ("OWNER_                                                                                         
ID") ENABLE                                                                                                                         
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 184549376 NEXT 1048576 MINEX                                                                                      
TENTS 1 MAXEXTENTS 2147483645                                                                                                       
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CE                                                                                        
LL_FLASH_CACHE DEFAULT)                                                                                                             
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_PROPERTY_USAGE"                                                                                         
   (	"UCODE" NUMBER NOT NULL ENABLE,                                                                                                
	"PROP_ID" NUMBER NOT NULL ENABLE,                                                                                                  
	 CONSTRAINT "PR_PROPERTY_USAGE_PK" PRIM                                                                                            
ARY KEY ("UCODE", "PROP_ID")                                                                                                        
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 CO                                                                                 
MPUTE STATISTICS                                                                                                                    
  STORAGE(INITIAL 29360128 NEXT 1048576 MI                                                                                          
NEXTENTS 1 MAXEXTENTS 2147483645                                                                                                    
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
 CELL_FLASH_CACHE DEFAULT)                                                                                                          
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "PR_PROPERTY_USAGE_FK2" FOREI                                                                                          
GN KEY ("PROP_ID")                                                                                                                  
	  REFERENCES "RNTMGR"."PR_PROPERTIES" ("                                                                                           
PROP_ID") ENABLE,                                                                                                                   
	 CONSTRAINT "PR_PROPERTY_USAGE_FK1" FORE                                                                                           
IGN KEY ("UCODE")                                                                                                                   
	  REFERENCES "RNTMGR"."PR_USAGE_CODES" ("                                                                                          
UCODE") ENABLE                                                                                                                      
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 23068672 NEXT 1048576 MIN                                                                                         
EXTENTS 1 MAXEXTENTS 2147483645                                                                                                     
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
CELL_FLASH_CACHE DEFAULT)                                                                                                           
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_PROP_CLASS"                                                                                             
   (	"PROP_CLASS" VARCHAR2(1) NOT NULL ENABLE,                                                                                      
	"DESCRIPTION" VARCHAR2(4000),                                                                                                      
	 CONSTRAINT "PR_PROP_CLASS_PK" PRIMARY KEY ("PROP_CLASS")                                                                          
                                                                                                                                    
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE ST                                                                         
ATISTICS                                                                                                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1                                                                                   
MAXEXTENTS 2147483645                                                                                                               
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH                                                                                
_CACHE DEFAULT)                                                                                                                     
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRAN                                                                                          
S 255                                                                                                                               
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAX                                                                               
EXTENTS 2147483645                                                                                                                  
  PCTINCREASE 0 FREELISTS 1 FREELIST GROU                                                                                           
PS 1                                                                                                                                
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CA                                                                             
CHE DEFAULT)                                                                                                                        
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_SALES_MV"                                                                                               
   (	"YEAR" VARCHAR2(4),                                                                                                            
	"MONTH_YEAR" VARCHAR2(7),                                                                                                          
	"DISPLAY_DATE" VARCHAR2(9),                                                                                                        
	"CITY" VARCHAR2(30) NOT NULL ENABLE,                                                                                               
	"DISPLAY_CITY" VARCHAR2(30),                                                                                                       
	"TOTAL_SALES" NUMBER,                                                                                                              
	"AVG_PRICE" NUMBER,                                                                                                                
	"SALES_COUNT" NUMBER                                                                                                               
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 2                                                                                       
55                                                                                                                                  
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 3145728 NEXT 1048576 MINEXTENTS 1 MAXE                                                                            
XTENTS 2147483645                                                                                                                   
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUP                                                                                          
S 1                                                                                                                                 
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CAC                                                                            
HE DEFAULT)                                                                                                                         
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_SALES_SUMMARY_MV"                                                                                       
   (	"YEAR" VARCHAR2(4),                                                                                                            
	"SALES_COUNT" NUMBER,                                                                                                              
	"TOTAL_SALES" NUMBER,                                                                                                              
	"AVG_PRICE" NUMBER                                                                                                                 
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 2                                                                                       
55                                                                                                                                  
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXT                                                                            
ENTS 2147483645                                                                                                                     
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
1                                                                                                                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
 DEFAULT)                                                                                                                           
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_SOURCES"                                                                                                
   (	"SOURCE_ID" NUMBER NOT NULL ENABLE,                                                                                            
                                                                                                                                    
	"SOURCE_NAME" VARCHAR2(64) NOT NULL ENABLE,                                                                                        
	"SOURCE_TYPE" VARCHAR2(16),                                                                                                        
	"BASE_URL" VARCHAR2(256),                                                                                                          
	"PHOTO_URL" VARCHAR2(4000),                                                                                                        
	"PROPERTY_URL" VARCHAR2(4000),                                                                                                     
	"PLATBOOK_URL" VARCHAR2(256),                                                                                                      
	"TAX_URL" VARCHAR2(4000),                                                                                                          
	"PK_COLUMN_NAME" VARCHAR2(30),                                                                                                     
	 CONSTRAINT "PR_SOURCES_PK" PRIMARY KEY ("SOURCE_ID")                                                                              
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS                                                                                        
 255 COMPUTE STATISTICS                                                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEX                                                                             
TENTS 2147483645                                                                                                                    
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
 1                                                                                                                                  
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACH                                                                           
E DEFAULT)                                                                                                                          
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
                                                                                                                                    
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTEN                                                                          
TS 2147483645                                                                                                                       
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAUL                                                                                            
T CELL_FLASH_CACHE DEFAULT)                                                                                                         
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_TAXES"                                                                                                  
   (	"PROP_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"TAX_YEAR" NUMBER(4,0) NOT NULL ENABLE,                                                                                            
	"TAX_VALUE" NUMBER NOT NULL ENABLE,                                                                                                
	"TAX_AMOUNT" NUMBER,                                                                                                               
	 CONSTRAINT "PR_TAXES_PK" PRIMARY KEY (                                                                                            
"PROP_ID", "TAX_YEAR")                                                                                                              
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE                                                                            
STATISTICS                                                                                                                          
  STORAGE(INITIAL 27262976 NEXT 1048576 MINEXTEN                                                                                    
TS 1 MAXEXTENTS 2147483645                                                                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_                                                                                     
FLASH_CACHE DEFAULT)                                                                                                                
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "PR_TAXES_FK1" FOREIGN KEY ("PROP_I                                                                                    
D")                                                                                                                                 
	  REFERENCES "RNTMGR"."PR_PROPERTIES" ("PROP_ID") ENABL                                                                            
E                                                                                                                                   
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 2                                                                                       
55                                                                                                                                  
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 25165824 NEXT 1048576 MINEXTENTS 1 MAX                                                                            
EXTENTS 2147483645                                                                                                                  
  PCTINCREASE 0 FREELISTS 1 FREELIST GROU                                                                                           
PS 1                                                                                                                                
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CA                                                                             
CHE DEFAULT)                                                                                                                        
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_UCODE_DATA"                                                                                             
   (	"CITY_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"UCODE" NUMBER NOT NULL ENABLE,                                                                                                    
	"PROPERTY_COUNT" NUMBER NOT NULL ENABLE,                                                                                           
	"TOTAL_SQFT" NUMBER NOT NULL ENABLE,                                                                                               
	 CONSTRAINT "PR_UCODE_DATA_PK" PRIMARY KE                                                                                          
Y ("CITY_ID", "UCODE")                                                                                                              
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE                                                                            
STATISTICS                                                                                                                          
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS                                                                                    
 1 MAXEXTENTS 2147483645                                                                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FL                                                                                   
ASH_CACHE DEFAULT)                                                                                                                  
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "PR_UCODE_DATA_R2" FOREIGN KEY ("UCOD                                                                                  
E")                                                                                                                                 
	  REFERENCES "RNTMGR"."PR_USAGE_CODES" ("UCODE") ENABLE                                                                            
,                                                                                                                                   
	 CONSTRAINT "PR_UCODE_DATA_R1" FOREIGN KEY ("CITY_ID")                                                                             
	  REFERENCES "RNTMGR"."RNT_CITIES" ("CIT                                                                                           
Y_ID") ENABLE                                                                                                                       
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXT                                                                                        
ENTS 1 MAXEXTENTS 2147483645                                                                                                        
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CEL                                                                                       
L_FLASH_CACHE DEFAULT)                                                                                                              
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_USAGE_CODES"                                                                                            
   (	"UCODE" NUMBER NOT NULL ENABLE,                                                                                                
	"DESCRIPTION" VARCHAR2(128) NOT NULL ENABLE,                                                                                       
	"PARENT_UCODE" NUMBER,                                                                                                             
	 CONSTRAINT "PR_USAGE_CODES_PK" PRIMARY KEY ("                                                                                     
UCODE")                                                                                                                             
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COM                                                                                
PUTE STATISTICS                                                                                                                     
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXT                                                                                         
ENTS 1 MAXEXTENTS 2147483645                                                                                                        
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CEL                                                                                       
L_FLASH_CACHE DEFAULT)                                                                                                              
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "PR_USAGE_CODES_FK1" FOREIGN KEY                                                                                       
("PARENT_UCODE")                                                                                                                    
	  REFERENCES "RNTMGR"."PR_USAGE_CODES" ("U                                                                                         
CODE") ENABLE                                                                                                                       
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTE                                                                                        
NTS 1 MAXEXTENTS 2147483645                                                                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL                                                                                      
_FLASH_CACHE DEFAULT)                                                                                                               
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_VALUES"                                                                                                 
   (	"CITY_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"UCODE" NUMBER NOT NULL ENABLE,                                                                                                    
	"PROP_CLASS" VARCHAR2(1) NOT NULL ENABLE,                                                                                          
	"YEAR" NUMBER(4,0) NOT NULL ENABLE,                                                                                                
	"MIN_PRICE" NUMBER,                                                                                                                
	"MAX_PRICE" NUMBER,                                                                                                                
	"MEDIAN_PRICE" NUMBER,                                                                                                             
	"RENT" NUMBER,                                                                                                                     
	"REPLACEMENT" NUMBER,                                                                                                              
	"MAINTENANCE" NUMBER,                                                                                                              
	"MGT_PERCENT" NUMBER,                                                                                                              
	"CAP_RATE" NUMBER,                                                                                                                 
	"VACANCY_PERCENT" NUMBER,                                                                                                          
	"UTILITIES" NUMBER,                                                                                                                
	 CONSTRAINT "PR_VALUES_PK" PRIMARY KEY ("CITY_ID", "UCOD                                                                           
E", "PROP_CLASS", "YEAR")                                                                                                           
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPU                                                                              
TE STATISTICS                                                                                                                       
  STORAGE(INITIAL 327680 NEXT 1048576 MINEXTE                                                                                       
NTS 1 MAXEXTENTS 2147483645                                                                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL                                                                                      
_FLASH_CACHE DEFAULT)                                                                                                               
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "PR_VALUES_R3" FOREIGN KEY ("CITY_                                                                                     
ID")                                                                                                                                
	  REFERENCES "RNTMGR"."RNT_CITIES" ("CITY_ID") ENABLE,                                                                             
                                                                                                                                    
	 CONSTRAINT "PR_VALUES_R2" FOREIGN KEY ("UCODE")                                                                                   
	  REFERENCES "RNTMGR"."PR_USAGE_CODES" ("UCODE"                                                                                    
) ENABLE,                                                                                                                           
	 CONSTRAINT "PR_VALUES_R1" FOREIGN KEY ("PROP_CL                                                                                   
ASS")                                                                                                                               
	  REFERENCES "RNTMGR"."PR_PROP_CLASS" ("PROP_CLASS")                                                                               
ENABLE                                                                                                                              
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTR                                                                                            
ANS 255                                                                                                                             
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 524288 NEXT 1048576 MINEXTENTS 1                                                                                  
MAXEXTENTS 2147483645                                                                                                               
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH                                                                                
_CACHE DEFAULT)                                                                                                                     
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_VOLUSIA_IDS"                                                                                            
   (	"FULL_PARCEL_ID" VARCHAR2(32) NOT NULL ENABLE,                                                                                 
	"PARCEL_ID" VARCHAR2(32) NOT NULL ENABLE,                                                                                          
	"ALT_KEY" VARCHAR2(32) NOT NULL ENABLE,                                                                                            
                                                                                                                                    
	"SHORT_PARCEL_ID" VARCHAR2(32)                                                                                                     
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 26214400 NEXT 1048576 MINE                                                                                        
XTENTS 1 MAXEXTENTS 2147483645                                                                                                      
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT C                                                                                         
ELL_FLASH_CACHE DEFAULT)                                                                                                            
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_ACCOUNTS"                                                                                              
   (	"ACCOUNT_ID" NUMBER NOT NULL ENABLE,                                                                                           
	"ACCOUNT_NUMBER" NUMBER NOT NULL ENABLE,                                                                                           
	"BUSINESS_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"NAME" VARCHAR2(64) NOT NULL ENABLE,                                                                                               
	"ACCOUNT_TYPE" VARCHAR2(32) NOT NULL ENABLE,                                                                                       
	"CURRENT_BALANCE_YN" VARCHAR2(1) NOT NULL ENAB                                                                                     
LE,                                                                                                                                 
	"USER_ASSIGN_ID" NUMBER,                                                                                                           
	"PEOPLE_BUSINESS_ID" NUMBER,                                                                                                       
	 CONSTRAINT "RNT_ACCOUNTS_PK" PRIMARY KEY ("ACCOUNT_ID")                                                                           
                                                                                                                                    
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE ST                                                                         
ATISTICS                                                                                                                            
  STORAGE(INITIAL 196608 NEXT 1048576 MINEXTENTS 1                                                                                  
 MAXEXTENTS 2147483645                                                                                                              
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLAS                                                                                 
H_CACHE DEFAULT)                                                                                                                    
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_ACCOUNTS_FK1" FOREIGN KEY ("ACCOUN                                                                                
T_TYPE")                                                                                                                            
	  REFERENCES "RNTMGR"."RNT_ACCOUNT_TYPES" ("ACCOUN                                                                                 
T_TYPE") ENABLE                                                                                                                     
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 393216 NEXT 1048576 MINE                                                                                          
XTENTS 1 MAXEXTENTS 2147483645                                                                                                      
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT C                                                                                         
ELL_FLASH_CACHE DEFAULT)                                                                                                            
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_ACCOUNTS_PAYABLE"                                                                                      
   (	"AP_ID" NUMBER NOT NULL ENABLE,                                                                                                
	"PAYMENT_DUE_DATE" DATE NOT NULL ENABLE,                                                                                           
	"AMOUNT" NUMBER NOT NULL ENABLE,                                                                                                   
	"PAYMENT_TYPE_ID" NUMBER NOT NULL ENABLE,                                                                                          
	"EXPENSE_ID" NUMBER,                                                                                                               
	"LOAN_ID" NUMBER,                                                                                                                  
	"SUPPLIER_ID" NUMBER,                                                                                                              
	"PAYMENT_PROPERTY_ID" NUMBER,                                                                                                      
	"BUSINESS_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"RECORD_TYPE" VARCHAR2(1 CHAR) NOT NULL ENABLE,                                                                                    
	"INVOICE_NUMBER" VARCHAR2(32),                                                                                                     
	 CONSTRAINT "RNT_ACCOUNTS_PAYABLE_PK" PRIMARY KE                                                                                   
Y ("AP_ID")                                                                                                                         
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255                                                                                    
 COMPUTE STATISTICS                                                                                                                 
  STORAGE(INITIAL 125829120 NEXT 1048576 MINEXTENTS 1 MAXEX                                                                         
TENTS 2147483645                                                                                                                    
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
 1                                                                                                                                  
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACH                                                                           
E DEFAULT)                                                                                                                          
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_ACCOUNTS_PAYABLE_FK6" FOREIGN KEY ("PAYM                                                                          
ENT_PROPERTY_ID")                                                                                                                   
	  REFERENCES "RNTMGR"."RNT_PROPERTIES" ("                                                                                          
PROPERTY_ID") ENABLE,                                                                                                               
	 CONSTRAINT "RNT_ACCOUNTS_PAYABLE_FK1" FOREIGN KEY ("EXP                                                                           
ENSE_ID")                                                                                                                           
	  REFERENCES "RNTMGR"."RNT_PROPERTY_EXPENSES" ("E                                                                                  
XPENSE_ID") ENABLE,                                                                                                                 
	 CONSTRAINT "RNT_ACCOUNTS_PAYABLE_FK4" FOREIGN KEY ("LOAN_                                                                         
ID")                                                                                                                                
	  REFERENCES "RNTMGR"."RNT_LOANS" ("LOAN_ID") ENABLE,                                                                              
                                                                                                                                    
	 CONSTRAINT "RNT_ACCOUNTS_PAYABLE_FK" FOREIGN KEY ("PAYMEN                                                                         
T_TYPE_ID")                                                                                                                         
	  REFERENCES "RNTMGR"."RNT_PAYMENT_TYPES" ("PAY                                                                                    
MENT_TYPE_ID") ENABLE,                                                                                                              
	 CONSTRAINT "RNT_ACCOUNTS_PAYABLE_FK2" FOREIGN KEY ("SU                                                                            
PPLIER_ID")                                                                                                                         
	  REFERENCES "RNTMGR"."RNT_SUPPLIERS_ALL" ("SUP                                                                                    
PLIER_ID") ENABLE                                                                                                                   
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 1179648 NEXT 1048576 M                                                                                            
INEXTENTS 1 MAXEXTENTS 2147483645                                                                                                   
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAUL                                                                                            
T CELL_FLASH_CACHE DEFAULT)                                                                                                         
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_ACCOUNTS_RECEIVABLE"                                                                                   
   (	"AR_ID" NUMBER NOT NULL ENABLE,                                                                                                
	"PAYMENT_DUE_DATE" DATE NOT NULL ENABLE,                                                                                           
	"AMOUNT" NUMBER NOT NULL ENABLE,                                                                                                   
	"PAYMENT_TYPE" NUMBER,                                                                                                             
	"TENANT_ID" NUMBER,                                                                                                                
	"AGREEMENT_ID" NUMBER,                                                                                                             
	"LOAN_ID" NUMBER,                                                                                                                  
	"BUSINESS_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"IS_GENERATED_YN" VARCHAR2(1) NOT NULL                                                                                             
ENABLE,                                                                                                                             
	"AGREEMENT_ACTION_ID" NUMBER,                                                                                                      
	"PAYMENT_PROPERTY_ID" NUMBER NOT NULL ENABLE,                                                                                      
	"SOURCE_PAYMENT_ID" NUMBER,                                                                                                        
	"RECORD_TYPE" VARCHAR2(1) NOT NULL ENABL                                                                                           
E,                                                                                                                                  
	 CONSTRAINT "RNT_ACCOUNTS_RECEIVABLE_PK" PRIMARY KEY ("                                                                            
AR_ID")                                                                                                                             
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COM                                                                                
PUTE STATISTICS                                                                                                                     
  STORAGE(INITIAL 196608 NEXT 1048576 MINEX                                                                                         
TENTS 1 MAXEXTENTS 2147483645                                                                                                       
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CE                                                                                        
LL_FLASH_CACHE DEFAULT)                                                                                                             
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_ACCOUNTS_RECEIVABLE_FK7" FO                                                                                       
REIGN KEY ("SOURCE_PAYMENT_ID")                                                                                                     
	  REFERENCES "RNTMGR"."RNT_ACCOUNTS_RECEIVABLE"                                                                                    
 ("AR_ID") ENABLE,                                                                                                                  
	 CONSTRAINT "RNT_ACCOUNTS_RECEIVABLE_FK                                                                                            
4" FOREIGN KEY ("PAYMENT_TYPE")                                                                                                     
	  REFERENCES "RNTMGR"."RNT_PAYMENT_TYPES" ("PAY                                                                                    
MENT_TYPE_ID") ENABLE,                                                                                                              
	 CONSTRAINT "RNT_ACCOUNTS_RECEIVABLE_FK3" FOREIGN KEY (                                                                            
"LOAN_ID")                                                                                                                          
	  REFERENCES "RNTMGR"."RNT_LOANS" ("LOAN_ID") EN                                                                                   
ABLE,                                                                                                                               
	 CONSTRAINT "RNT_ACCOUNTS_RECEIVABLE_FK" FOREIGN KEY                                                                               
 ("TENANT_ID")                                                                                                                      
	  REFERENCES "RNTMGR"."RNT_TENANT" ("TENANT_                                                                                       
ID") ENABLE,                                                                                                                        
	 CONSTRAINT "RNT_ACCOUNTS_RECEIVABLE_FK5" FOR                                                                                      
EIGN KEY ("AGREEMENT_ACTION_ID")                                                                                                    
	  REFERENCES "RNTMGR"."RNT_AGREEMENT_ACTIONS"                                                                                      
("ACTION_ID") ENABLE,                                                                                                               
	 CONSTRAINT "RNT_ACCOUNTS_RECEIVABLE_FK2" FOREIGN KEY ("                                                                           
PAYMENT_PROPERTY_ID")                                                                                                               
	  REFERENCES "RNTMGR"."RNT_PROPERTIES" ("PROPERTY_ID") EN                                                                          
ABLE                                                                                                                                
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRAN                                                                                          
S 255                                                                                                                               
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 458752 NEXT 1048576 MINEXTENTS 1 MA                                                                               
XEXTENTS 2147483645                                                                                                                 
  PCTINCREASE 0 FREELISTS 1 FREELIST GRO                                                                                            
UPS 1                                                                                                                               
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_C                                                                              
ACHE DEFAULT)                                                                                                                       
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_ACCOUNT_BALANCES"                                                                                      
   (	"ACCOUNT_ID" NUMBER NOT NULL ENABLE,                                                                                           
	"PERIOD_ID" NUMBER NOT NULL ENABLE,                                                                                                
	"OPENING_BALANCE" NUMBER NOT NULL ENABLE,                                                                                          
	 CONSTRAINT "RNT_ACCOUNT_BALANCES_PK" PRIMARY                                                                                      
 KEY ("ACCOUNT_ID", "PERIOD_ID")                                                                                                    
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 25                                                                                     
5 COMPUTE STATISTICS                                                                                                                
  STORAGE(INITIAL 196608 NEXT 1048576 MINEXTENTS 1 MAXEXTE                                                                          
NTS 2147483645                                                                                                                      
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
                                                                                                                                    
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
DEFAULT)                                                                                                                            
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_ACCOUNT_BALANCES_FK2"                                                                                             
FOREIGN KEY ("PERIOD_ID")                                                                                                           
	  REFERENCES "RNTMGR"."RNT_ACCOUNT_PERIODS" ("PERIOD_                                                                              
ID") ENABLE,                                                                                                                        
	 CONSTRAINT "RNT_ACCOUNT_BALANCES_FK1" FOREIG                                                                                      
N KEY ("ACCOUNT_ID")                                                                                                                
	  REFERENCES "RNTMGR"."RNT_ACCOUNTS" ("ACCOUNT_ID") ENABLE                                                                         
                                                                                                                                    
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 25                                                                                      
5                                                                                                                                   
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXT                                                                           
ENTS 2147483645                                                                                                                     
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
1                                                                                                                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
 DEFAULT)                                                                                                                           
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_ACCOUNT_PERIODS"                                                                                       
   (	"PERIOD_ID" NUMBER NOT NULL ENABLE,                                                                                            
	"BUSINESS_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"START_DATE" DATE NOT NULL ENABLE,                                                                                                 
	"CLOSED_YN" VARCHAR2(1) NOT NULL ENABLE,                                                                                           
	 CONSTRAINT "RNT_ACCOUNT_PERIODS_PK" PRIMARY KEY                                                                                   
("PERIOD_ID")                                                                                                                       
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 2                                                                                      
55 COMPUTE STATISTICS                                                                                                               
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTE                                                                           
NTS 2147483645                                                                                                                      
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
                                                                                                                                    
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
DEFAULT)                                                                                                                            
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_ACCOUNT_PERIODS_FK1" F                                                                                            
OREIGN KEY ("BUSINESS_ID")                                                                                                          
	  REFERENCES "RNTMGR"."RNT_BUSINESS_UNITS" ("BUSINES                                                                               
S_ID") ENABLE                                                                                                                       
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTE                                                                                        
NTS 1 MAXEXTENTS 2147483645                                                                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL                                                                                      
_FLASH_CACHE DEFAULT)                                                                                                               
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_ACCOUNT_TYPES"                                                                                         
   (	"ACCOUNT_TYPE" VARCHAR2(32) NOT NULL ENABLE,                                                                                   
	"DISPLAY_TITLE" VARCHAR2(32) NOT NULL ENAB                                                                                         
LE,                                                                                                                                 
	 CONSTRAINT "RNT_ACCOUNT_TYPES_PK" PRIMARY KEY ("ACCOU                                                                             
NT_TYPE")                                                                                                                           
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 C                                                                                  
OMPUTE STATISTICS                                                                                                                   
  STORAGE(INITIAL 65536 NEXT 1048576 MINE                                                                                           
XTENTS 1 MAXEXTENTS 2147483645                                                                                                      
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT C                                                                                         
ELL_FLASH_CACHE DEFAULT)                                                                                                            
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTE                                                                                        
NTS 1 MAXEXTENTS 2147483645                                                                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL                                                                                      
_FLASH_CACHE DEFAULT)                                                                                                               
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_AGREEMENT_ACTIONS"                                                                                     
   (	"ACTION_ID" NUMBER NOT NULL ENABLE,                                                                                            
	"AGREEMENT_ID" NUMBER NOT NULL ENABLE,                                                                                             
	"ACTION_DATE" DATE NOT NULL ENABLE,                                                                                                
	"ACTION_TYPE" VARCHAR2(30) NOT NULL ENABLE,                                                                                        
	"COMMENTS_VARCHAR" VARCHAR2(4000),                                                                                                 
	"RECOVERABLE_YN" VARCHAR2(1) NOT NULL ENABLE,                                                                                      
                                                                                                                                    
	"ACTION_COST" NUMBER NOT NULL ENABLE,                                                                                              
	"COMMENTS" CLOB,                                                                                                                   
	 CONSTRAINT "RNT_AGREEMENT_ACTIONS_PK" PRIMARY KEY ("ACTIO                                                                         
N_ID")                                                                                                                              
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMP                                                                               
UTE STATISTICS                                                                                                                      
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTE                                                                                        
NTS 1 MAXEXTENTS 2147483645                                                                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL                                                                                      
_FLASH_CACHE DEFAULT)                                                                                                               
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_AGREEMENT_ACTIONS_UK1" UNIQUE                                                                                     
 ("AGREEMENT_ID", "ACTION_DATE", "ACTION                                                                                            
_TYPE")                                                                                                                             
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COM                                                                                
PUTE STATISTICS                                                                                                                     
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXT                                                                                         
ENTS 1 MAXEXTENTS 2147483645                                                                                                        
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CEL                                                                                       
L_FLASH_CACHE DEFAULT)                                                                                                              
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 786432 NEXT 1048576 MINEXTEN                                                                                      
TS 1 MAXEXTENTS 2147483645                                                                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_                                                                                     
FLASH_CACHE DEFAULT)                                                                                                                
  TABLESPACE "USERS"                                                                                                                
 LOB ("COMMENTS") STORE AS BASICFILE (                                                                                              
  TABLESPACE "USERS" ENABLE STORAGE IN ROW CHUNK 8192 PCTV                                                                          
ERSION 10                                                                                                                           
  NOCACHE LOGGING                                                                                                                   
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 M                                                                                 
AXEXTENTS 2147483645                                                                                                                
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_                                                                               
CACHE DEFAULT)) ;                                                                                                                   
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_BUSINESS_UNITS"                                                                                        
   (	"BUSINESS_ID" NUMBER NOT NULL ENABLE,                                                                                          
	"BUSINESS_NAME" VARCHAR2(60) NOT NULL ENABLE,                                                                                      
	"PARENT_BUSINESS_ID" NUMBER NOT NULL ENA                                                                                           
BLE,                                                                                                                                
	 CONSTRAINT "RNT_BUSINESS_UNITS_PK" PRIMARY KEY ("BUS                                                                              
INESS_ID")                                                                                                                          
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255                                                                                    
COMPUTE STATISTICS                                                                                                                  
  STORAGE(INITIAL 65536 NEXT 1048576 MIN                                                                                            
EXTENTS 1 MAXEXTENTS 2147483645                                                                                                     
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
CELL_FLASH_CACHE DEFAULT)                                                                                                           
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXT                                                                                         
ENTS 1 MAXEXTENTS 2147483645                                                                                                        
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CEL                                                                                       
L_FLASH_CACHE DEFAULT)                                                                                                              
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_BU_SUPPLIERS"                                                                                          
   (	"BU_SUPPLIER_ID" NUMBER NOT NULL ENABLE,                                                                                       
	"BUSINESS_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"SUPPLIER_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"TAX_IDENTIFIER" VARCHAR2(20),                                                                                                     
	"NOTES" VARCHAR2(4000),                                                                                                            
	 CONSTRAINT "RNT_BU_SUPPLIERS_PK" PRIMARY KEY ("                                                                                   
BU_SUPPLIER_ID")                                                                                                                    
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRAN                                                                                         
S 255 COMPUTE STATISTICS                                                                                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXE                                                                              
XTENTS 2147483645                                                                                                                   
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUP                                                                                          
S 1                                                                                                                                 
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CAC                                                                            
HE DEFAULT)                                                                                                                         
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_BU_SUPPLIERS_U1" UNIQUE ("BUSINESS_ID",                                                                           
 "SUPPLIER_ID")                                                                                                                     
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS                                                                                        
 255 COMPUTE STATISTICS                                                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEX                                                                             
TENTS 2147483645                                                                                                                    
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
 1                                                                                                                                  
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACH                                                                           
E DEFAULT)                                                                                                                          
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_BU_SUPPLIERS_FK2" FOREIGN KEY ("SUPPLIER                                                                          
_ID")                                                                                                                               
	  REFERENCES "RNTMGR"."RNT_SUPPLIERS_ALL" ("SUPPLIER_                                                                              
ID") ENABLE,                                                                                                                        
	 CONSTRAINT "RNT_BU_SUPPLIERS_FK1" FOREIGN KE                                                                                      
Y ("BUSINESS_ID")                                                                                                                   
	  REFERENCES "RNTMGR"."RNT_BUSINESS_UNITS                                                                                          
" ("BUSINESS_ID") ENABLE                                                                                                            
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRAN                                                                                          
S 255                                                                                                                               
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAX                                                                               
EXTENTS 2147483645                                                                                                                  
  PCTINCREASE 0 FREELISTS 1 FREELIST GROU                                                                                           
PS 1                                                                                                                                
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CA                                                                             
CHE DEFAULT)                                                                                                                        
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_CITIES"                                                                                                
   (	"CITY_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"NAME" VARCHAR2(35) NOT NULL ENABLE,                                                                                               
	"COUNTY" VARCHAR2(25) NOT NULL ENABLE,                                                                                             
	"STATE" VARCHAR2(2) NOT NULL ENABLE,                                                                                               
	"DESCRIPTION" CLOB,                                                                                                                
	 CONSTRAINT "RNT_CITES_PK" PRIMARY KEY                                                                                             
("CITY_ID")                                                                                                                         
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255                                                                                    
 COMPUTE STATISTICS                                                                                                                 
  STORAGE(INITIAL 589824 NEXT 1048576 MINEXTENTS 1 MAXEXTEN                                                                         
TS 2147483645                                                                                                                       
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAUL                                                                                            
T CELL_FLASH_CACHE DEFAULT)                                                                                                         
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 2097152 NEXT 1048576 MI                                                                                           
NEXTENTS 1 MAXEXTENTS 2147483645                                                                                                    
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
 CELL_FLASH_CACHE DEFAULT)                                                                                                          
  TABLESPACE "USERS"                                                                                                                
 LOB ("DESCRIPTION") STORE AS BASICFILE (                                                                                           
  TABLESPACE "USERS" ENABLE STORAGE IN ROW CHUNK                                                                                    
8192 PCTVERSION 10                                                                                                                  
  NOCACHE LOGGING                                                                                                                   
  STORAGE(INITIAL 65536 NEXT 1048576 MINEX                                                                                          
TENTS 1 MAXEXTENTS 2147483645                                                                                                       
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CE                                                                                        
LL_FLASH_CACHE DEFAULT)) ;                                                                                                          
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_CITY_ZIPCODES"                                                                                         
   (	"CITY_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"ZIPCODE" NUMBER(5,0) NOT NULL ENABLE,                                                                                             
	 CONSTRAINT "RNT_CITY_ZIPCODES_PK" PRIMARY KEY ("CIT                                                                               
Y_ID", "ZIPCODE")                                                                                                                   
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRA                                                                                          
NS 255 COMPUTE STATISTICS                                                                                                           
  STORAGE(INITIAL 2097152 NEXT 1048576 MINEXTENTS 1 M                                                                               
AXEXTENTS 2147483645                                                                                                                
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_                                                                               
CACHE DEFAULT)                                                                                                                      
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS                                                                                         
 255                                                                                                                                
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 786432 NEXT 1048576 MINEXTENTS 1 MAX                                                                              
EXTENTS 2147483645                                                                                                                  
  PCTINCREASE 0 FREELISTS 1 FREELIST GROU                                                                                           
PS 1                                                                                                                                
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CA                                                                             
CHE DEFAULT)                                                                                                                        
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_DEFAULT_ACCOUNTS"                                                                                      
   (	"ACCOUNT_NUMBER" NUMBER NOT NULL ENABLE,                                                                                       
	"NAME" VARCHAR2(64) NOT NULL ENABLE,                                                                                               
	"ACCOUNT_TYPE" VARCHAR2(32) NOT NULL ENABLE,                                                                                       
                                                                                                                                    
	"CURRENT_BALANCE_YN" VARCHAR2(1) NOT NULL ENABLE,                                                                                  
	 CONSTRAINT "RNT_DEFAULT_ACCOUNTS_PK" PRIMARY                                                                                      
 KEY ("ACCOUNT_NUMBER")                                                                                                             
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE                                                                            
 STATISTICS                                                                                                                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS                                                                                     
 1 MAXEXTENTS 2147483645                                                                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FL                                                                                   
ASH_CACHE DEFAULT)                                                                                                                  
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_DEFAULT_ACCOUNTS_FK1" FOREIGN KE                                                                                  
Y ("ACCOUNT_TYPE")                                                                                                                  
	  REFERENCES "RNTMGR"."RNT_ACCOUNT_TYPES                                                                                           
" ("ACCOUNT_TYPE") ENABLE                                                                                                           
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRA                                                                                           
NS 255                                                                                                                              
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MA                                                                                
XEXTENTS 2147483645                                                                                                                 
  PCTINCREASE 0 FREELISTS 1 FREELIST GRO                                                                                            
UPS 1                                                                                                                               
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_C                                                                              
ACHE DEFAULT)                                                                                                                       
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_DEFAULT_PT_RULES"                                                                                      
   (	"PAYMENT_TYPE_ID" NUMBER NOT NULL ENABLE,                                                                                      
	"TRANSACTION_TYPE" VARCHAR2(32) NOT NULL E                                                                                         
NABLE,                                                                                                                              
	"DEBIT_ACCOUNT" NUMBER NOT NULL ENABLE,                                                                                            
	"CREDIT_ACCOUNT" NUMBER NOT NULL ENABLE,                                                                                           
	 CONSTRAINT "RNT_DEFAULT_PT_RULES_CK1" CHECK (                                                                                     
transaction_type in ('APS','APP', 'ARS',                                                                                            
 'ARP', 'DEP')) ENABLE,                                                                                                             
	 CONSTRAINT "RNT_DEFAULT_PT_RULES_PK" PRIMARY KEY ("PA                                                                             
YMENT_TYPE_ID", "TRANSACTION_TYPE")                                                                                                 
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS                                                                                        
 255 COMPUTE STATISTICS                                                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEX                                                                             
TENTS 2147483645                                                                                                                    
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
 1                                                                                                                                  
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACH                                                                           
E DEFAULT)                                                                                                                          
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_DEFAULT_PT_RULES_FK3" FOREIGN KEY ("CRED                                                                          
IT_ACCOUNT")                                                                                                                        
	  REFERENCES "RNTMGR"."RNT_DEFAULT_ACCOUNTS" (                                                                                     
"ACCOUNT_NUMBER") ENABLE,                                                                                                           
	 CONSTRAINT "RNT_DEFAULT_PT_RULES_FK2" FOREIGN KEY (                                                                               
"DEBIT_ACCOUNT")                                                                                                                    
	  REFERENCES "RNTMGR"."RNT_DEFAULT_ACCOUNT                                                                                         
S" ("ACCOUNT_NUMBER") ENABLE,                                                                                                       
	 CONSTRAINT "RNT_DEFAULT_PT_RULES_FK1" FOREIGN K                                                                                   
EY ("PAYMENT_TYPE_ID")                                                                                                              
	  REFERENCES "RNTMGR"."RNT_PAYMENT_TYPES" ("PAYMENT_TYPE                                                                           
_ID") ENABLE                                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTEN                                                                                       
TS 1 MAXEXTENTS 2147483645                                                                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_                                                                                     
FLASH_CACHE DEFAULT)                                                                                                                
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_DOC_TEMPLATES"                                                                                         
   (	"TEMPLATE_ID" NUMBER NOT NULL ENABLE,                                                                                          
	"NAME" VARCHAR2(32) NOT NULL ENABLE,                                                                                               
	"BUSINESS_ID" NUMBER,                                                                                                              
	"CONTENT" CLOB,                                                                                                                    
	 CONSTRAINT "RNT_DOC_TEMPLATES_PK" PRIMARY KEY (                                                                                   
"TEMPLATE_ID")                                                                                                                      
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS                                                                                        
255 COMPUTE STATISTICS                                                                                                              
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXT                                                                            
ENTS 2147483645                                                                                                                     
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
1                                                                                                                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
 DEFAULT)                                                                                                                           
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_DOC_TEMPLATES_R1" FOREIGN KEY ("BUSINESS_                                                                         
ID")                                                                                                                                
	  REFERENCES "RNTMGR"."RNT_BUSINESS_UNITS" ("BUSINESS_                                                                             
ID") ENABLE                                                                                                                         
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENT                                                                                      
S 1 MAXEXTENTS 2147483645                                                                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_F                                                                                    
LASH_CACHE DEFAULT)                                                                                                                 
  TABLESPACE "USERS"                                                                                                                
 LOB ("CONTENT") STORE AS BASICFILE (                                                                                               
  TABLESPACE "USERS" ENABLE STORAGE IN R                                                                                            
OW CHUNK 8192 PCTVERSION 10                                                                                                         
  NOCACHE LOGGING                                                                                                                   
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAX                                                                               
EXTENTS 2147483645                                                                                                                  
  PCTINCREASE 0 FREELISTS 1 FREELIST GROU                                                                                           
PS 1                                                                                                                                
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CA                                                                             
CHE DEFAULT)) ;                                                                                                                     
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_ERROR_DESCRIPTION"                                                                                     
   (	"ERROR_ID" NUMBER NOT NULL ENABLE,                                                                                             
	"ERROR_CODE" NUMBER NOT NULL ENABLE,                                                                                               
	"SHORT_DESCRIPTION" VARCHAR2(2000),                                                                                                
	"LONG_DESCRIPTION" VARCHAR2(4000),                                                                                                 
	"SHOW_LONG_DESCRIPTION_YN" VARCHAR2(1) NOT NULL ENABLE                                                                             
,                                                                                                                                   
	"CLASSIFIED_DESCRIPTION" VARCHAR2(50),                                                                                             
	"DISPLAY_SHORT_DESCRIPTION_YN" VARCHAR2(1) NOT NULL ENA                                                                            
BLE,                                                                                                                                
	 CONSTRAINT "RNT_ERROR_DESCRIPTION_PK" PRIMARY KEY ("                                                                              
ERROR_ID")                                                                                                                          
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255                                                                                    
COMPUTE STATISTICS                                                                                                                  
  STORAGE(INITIAL 65536 NEXT 1048576 MIN                                                                                            
EXTENTS 1 MAXEXTENTS 2147483645                                                                                                     
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
CELL_FLASH_CACHE DEFAULT)                                                                                                           
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXT                                                                                         
ENTS 1 MAXEXTENTS 2147483645                                                                                                        
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CEL                                                                                       
L_FLASH_CACHE DEFAULT)                                                                                                              
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_EXPENSE_ITEMS"                                                                                         
   (	"EXPENSE_ITEM_ID" NUMBER NOT NULL ENABLE,                                                                                      
	"EXPENSE_ID" NUMBER NOT NULL ENABLE,                                                                                               
	"SUPPLIER_ID" NUMBER,                                                                                                              
	"ITEM_NAME" VARCHAR2(60) NOT NULL ENABLE,                                                                                          
                                                                                                                                    
	"ITEM_COST" NUMBER NOT NULL ENABLE,                                                                                                
	"ESTIMATE" NUMBER,                                                                                                                 
	"ACTUAL" NUMBER,                                                                                                                   
	"ORDER_ROW" NUMBER,                                                                                                                
	"ITEM_UNIT" VARCHAR2(2) NOT NULL ENABLE,                                                                                           
	"ACCEPTED_YN" VARCHAR2(1) DEFAULT 'Y' NOT NULL ENABLE,                                                                             
                                                                                                                                    
	 CONSTRAINT "RNT_EXPENSE_ITEMS_PK" PRIMARY KEY ("EXPENSE_I                                                                         
TEM_ID")                                                                                                                            
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 CO                                                                                 
MPUTE STATISTICS                                                                                                                    
  STORAGE(INITIAL 65536 NEXT 1048576 MINEX                                                                                          
TENTS 1 MAXEXTENTS 2147483645                                                                                                       
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CE                                                                                        
LL_FLASH_CACHE DEFAULT)                                                                                                             
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_EXPENSE_ITEMS_F1" FOREIGN K                                                                                       
EY ("EXPENSE_ID")                                                                                                                   
	  REFERENCES "RNTMGR"."RNT_PROPERTY_EXPEN                                                                                          
SES" ("EXPENSE_ID") ENABLE,                                                                                                         
	 CONSTRAINT "RNT_EXPENSE_ITEMS_F2" FOREIGN KEY ("S                                                                                 
UPPLIER_ID")                                                                                                                        
	  REFERENCES "RNTMGR"."RNT_SUPPLIERS_ALL" ("SU                                                                                     
PPLIER_ID") ENABLE                                                                                                                  
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
                                                                                                                                    
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENT                                                                         
S 2147483645                                                                                                                        
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
 CELL_FLASH_CACHE DEFAULT)                                                                                                          
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_LEDGER_ENTRIES"                                                                                        
   (	"LEDGER_ID" NUMBER NOT NULL ENABLE,                                                                                            
	"ENTRY_DATE" DATE NOT NULL ENABLE,                                                                                                 
	"DESCRIPTION" VARCHAR2(4000) NOT NULL ENABLE,                                                                                      
	"DEBIT_ACCOUNT" NUMBER NOT NULL ENABLE,                                                                                            
	"CREDIT_ACCOUNT" NUMBER NOT NULL ENABLE,                                                                                           
	"PAYMENT_TYPE_ID" NUMBER NOT NULL ENABLE                                                                                           
,                                                                                                                                   
	"AR_ID" NUMBER,                                                                                                                    
	"AP_ID" NUMBER,                                                                                                                    
	"PAY_ALLOC_ID" NUMBER,                                                                                                             
	"PROPERTY_ID" NUMBER,                                                                                                              
	 CONSTRAINT "RNT_LEDGER_ENTRIES_PK" PRIMARY KEY ("L                                                                                
EDGER_ID")                                                                                                                          
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255                                                                                    
COMPUTE STATISTICS                                                                                                                  
  STORAGE(INITIAL 2097152 NEXT 1048576 M                                                                                            
INEXTENTS 1 MAXEXTENTS 2147483645                                                                                                   
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAUL                                                                                            
T CELL_FLASH_CACHE DEFAULT)                                                                                                         
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_LEDGER_ENTRIES_FK7" FOR                                                                                           
EIGN KEY ("PROPERTY_ID")                                                                                                            
	  REFERENCES "RNTMGR"."RNT_PROPERTIES" ("PROPERTY_ID")                                                                             
 ENABLE,                                                                                                                            
	 CONSTRAINT "RNT_LEDGER_ENTRIES_FK6" FOREIGN KEY                                                                                   
("PAYMENT_TYPE_ID")                                                                                                                 
	  REFERENCES "RNTMGR"."RNT_PAYMENT_TYPE                                                                                            
S" ("PAYMENT_TYPE_ID") ENABLE,                                                                                                      
	 CONSTRAINT "RNT_LEDGER_ENTRIES_FK5" FOREIGN KE                                                                                    
Y ("PAY_ALLOC_ID")                                                                                                                  
	  REFERENCES "RNTMGR"."RNT_PAYMENT_ALLOC                                                                                           
ATIONS" ("PAY_ALLOC_ID") ENABLE,                                                                                                    
	 CONSTRAINT "RNT_LEDGER_ENTRIES_FK4" FOREIGN                                                                                       
KEY ("AP_ID")                                                                                                                       
	  REFERENCES "RNTMGR"."RNT_ACCOUNTS_PAYABLE"                                                                                       
("AP_ID") ENABLE,                                                                                                                   
	 CONSTRAINT "RNT_LEDGER_ENTRIES_FK3" FOR                                                                                           
EIGN KEY ("AR_ID")                                                                                                                  
	  REFERENCES "RNTMGR"."RNT_ACCOUNTS_RECE                                                                                           
IVABLE" ("AR_ID") ENABLE,                                                                                                           
	 CONSTRAINT "RNT_LEDGER_ENTRIES_FK2" FOREIGN KEY ("C                                                                               
REDIT_ACCOUNT")                                                                                                                     
	  REFERENCES "RNTMGR"."RNT_ACCOUNTS" ("ACCO                                                                                        
UNT_ID") ENABLE,                                                                                                                    
	 CONSTRAINT "RNT_LEDGER_ENTRIES_FK1" FORE                                                                                          
IGN KEY ("DEBIT_ACCOUNT")                                                                                                           
	  REFERENCES "RNTMGR"."RNT_ACCOUNTS" ("ACCOUNT_ID") E                                                                              
NABLE                                                                                                                               
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRA                                                                                           
NS 255                                                                                                                              
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 7340032 NEXT 1048576 MINEXTENTS 1                                                                                 
MAXEXTENTS 2147483645                                                                                                               
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH                                                                                
_CACHE DEFAULT)                                                                                                                     
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_LOANS"                                                                                                 
   (	"LOAN_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"PROPERTY_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"POSITION" NUMBER NOT NULL ENABLE,                                                                                                 
	"LOAN_DATE" DATE NOT NULL ENABLE,                                                                                                  
	"LOAN_AMOUNT" NUMBER NOT NULL ENABLE,                                                                                              
	"TERM" NUMBER NOT NULL ENABLE,                                                                                                     
	"INTEREST_RATE" NUMBER NOT NULL ENABLE,                                                                                            
	"CREDIT_LINE_YN" VARCHAR2(1) NOT NULL ENABLE,                                                                                      
	"ARM_YN" VARCHAR2(1) NOT NULL ENABLE,                                                                                              
	"BALLOON_DATE" DATE,                                                                                                               
	"SETTLEMENT_DATE" DATE,                                                                                                            
	"CLOSING_COSTS" NUMBER,                                                                                                            
	"INTEREST_ONLY_YN" VARCHAR2(1) DEFAULT 'N' NOT NUL                                                                                 
L ENABLE,                                                                                                                           
	"PRINCIPAL_BALANCE" NUMBER NOT NULL ENABLE,                                                                                        
	"BALANCE_DATE" DATE NOT NULL ENABLE,                                                                                               
	 CONSTRAINT "RNT_LOANS_PK" PRIMARY KEY ("LO                                                                                        
AN_ID")                                                                                                                             
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COM                                                                                
PUTE STATISTICS                                                                                                                     
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXT                                                                                         
ENTS 1 MAXEXTENTS 2147483645                                                                                                        
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CEL                                                                                       
L_FLASH_CACHE DEFAULT)                                                                                                              
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_LOANS_UK2" UNIQUE ("PROPERTY                                                                                      
_ID", "POSITION")                                                                                                                   
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRA                                                                                          
NS 255 COMPUTE STATISTICS                                                                                                           
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAX                                                                               
EXTENTS 2147483645                                                                                                                  
  PCTINCREASE 0 FREELISTS 1 FREELIST GROU                                                                                           
PS 1                                                                                                                                
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CA                                                                             
CHE DEFAULT)                                                                                                                        
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_LOANS_FK" FOREIGN KEY ("PROPERTY_ID")                                                                             
	  REFERENCES "RNTMGR"."RNT_PROPERTIES"                                                                                             
("PROPERTY_ID") ENABLE                                                                                                              
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS                                                                                         
255                                                                                                                                 
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEX                                                                             
TENTS 2147483645                                                                                                                    
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
 1                                                                                                                                  
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACH                                                                           
E DEFAULT)                                                                                                                          
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_LOOKUP_TYPES"                                                                                          
   (	"LOOKUP_TYPE_ID" NUMBER NOT NULL ENABLE,                                                                                       
	"LOOKUP_TYPE_CODE" VARCHAR2(30) NOT NULL ENABLE                                                                                    
,                                                                                                                                   
	"LOOKUP_TYPE_DESCRIPTION" VARCHAR2(80) NOT NULL ENABLE,                                                                            
                                                                                                                                    
	 CONSTRAINT "RNT_LOOKUP_TYPES_PK" PRIMARY KEY ("LOOKUP_TYP                                                                         
E_ID")                                                                                                                              
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMP                                                                               
UTE STATISTICS                                                                                                                      
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTE                                                                                        
NTS 1 MAXEXTENTS 2147483645                                                                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL                                                                                      
_FLASH_CACHE DEFAULT)                                                                                                               
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS                                                                                     
 1 MAXEXTENTS 2147483645                                                                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FL                                                                                   
ASH_CACHE DEFAULT)                                                                                                                  
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_LOOKUP_VALUES"                                                                                         
   (	"LOOKUP_VALUE_ID" NUMBER NOT NULL ENABLE,                                                                                      
	"LOOKUP_CODE" VARCHAR2(80) NOT NULL ENABLE,                                                                                        
	"LOOKUP_VALUE" VARCHAR2(80),                                                                                                       
	"LOOKUP_TYPE_ID" NUMBER NOT NULL ENABLE,                                                                                           
	 CONSTRAINT "RNT_LOOKUP_VALUES_PK" PRIMARY KE                                                                                      
Y ("LOOKUP_VALUE_ID")                                                                                                               
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE S                                                                          
TATISTICS                                                                                                                           
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1                                                                                   
 MAXEXTENTS 2147483645                                                                                                              
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLAS                                                                                 
H_CACHE DEFAULT)                                                                                                                    
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_LOOKUP_VALUES_FK" FOREIGN KEY ("LO                                                                                
OKUP_TYPE_ID")                                                                                                                      
	  REFERENCES "RNTMGR"."RNT_LOOKUP_TYPES" ("L                                                                                       
OOKUP_TYPE_ID") ENABLE                                                                                                              
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS                                                                                         
255                                                                                                                                 
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEX                                                                             
TENTS 2147483645                                                                                                                    
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
 1                                                                                                                                  
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACH                                                                           
E DEFAULT)                                                                                                                          
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_MENUS"                                                                                                 
   (	"TAB_NAME" VARCHAR2(32) NOT NULL ENAB                                                                                          
LE,                                                                                                                                 
	"PARENT_TAB" VARCHAR2(32) NOT NULL ENABLE,                                                                                         
	"MENU_NAME" VARCHAR2(32) NOT NULL ENABLE,                                                                                          
	"MENU_TITLE" VARCHAR2(32) NOT NULL ENABLE,                                                                                         
	"DISPLAY_SEQ" NUMBER,                                                                                                              
	 CONSTRAINT "RNT_MENUS_PK" PRIMARY KEY ("TAB_NAME", "MEN                                                                           
U_NAME")                                                                                                                            
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 CO                                                                                 
MPUTE STATISTICS                                                                                                                    
  STORAGE(INITIAL 65536 NEXT 1048576 MINEX                                                                                          
TENTS 1 MAXEXTENTS 2147483645                                                                                                       
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CE                                                                                        
LL_FLASH_CACHE DEFAULT)                                                                                                             
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_MENUS_R1" FOREIGN KEY ("TAB                                                                                       
_NAME")                                                                                                                             
	  REFERENCES "RNTMGR"."RNT_MENU_TABS" ("TAB_NAME")                                                                                 
ENABLE                                                                                                                              
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTR                                                                                            
ANS 255                                                                                                                             
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 M                                                                                 
AXEXTENTS 2147483645                                                                                                                
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_                                                                               
CACHE DEFAULT)                                                                                                                      
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_MENU_LINKS"                                                                                            
   (	"TAB_NAME" VARCHAR2(32) NOT NULL ENABLE,                                                                                       
	"MENU_NAME" VARCHAR2(32) NOT NULL ENABLE,                                                                                          
	"LINK_TITLE" VARCHAR2(32) NOT NULL ENABLE,                                                                                         
	"LINK_URL" VARCHAR2(128),                                                                                                          
	"DISPLAY_SEQ" NUMBER,                                                                                                              
	 CONSTRAINT "RNT_MENU_LINKS_PK" PRIMARY KEY ("TA                                                                                   
B_NAME", "MENU_NAME", "LINK_TITLE")                                                                                                 
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS                                                                                        
 255 COMPUTE STATISTICS                                                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEX                                                                             
TENTS 2147483645                                                                                                                    
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
 1                                                                                                                                  
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACH                                                                           
E DEFAULT)                                                                                                                          
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_MENU_LINKS_R1" FOREIGN KEY ("TAB_NAME",                                                                           
"MENU_NAME")                                                                                                                        
	  REFERENCES "RNTMGR"."RNT_MENUS" ("TAB_NAME",                                                                                     
 "MENU_NAME") ENABLE                                                                                                                
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 25                                                                                      
5                                                                                                                                   
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTE                                                                           
NTS 2147483645                                                                                                                      
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
                                                                                                                                    
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
DEFAULT)                                                                                                                            
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_MENU_PAGES"                                                                                            
   (	"TAB_NAME" VARCHAR2(32) NOT NULL ENABLE,                                                                                       
	"MENU_NAME" VARCHAR2(32) NOT NULL ENABLE,                                                                                          
	"PAGE_NAME" VARCHAR2(32) NOT NULL ENABLE,                                                                                          
	"SUB_PAGE" VARCHAR2(32) NOT NULL ENABLE,                                                                                           
                                                                                                                                    
	"PAGE_TITLE" VARCHAR2(32) NOT NULL ENABLE,                                                                                         
	"DISPLAY_SEQ" NUMBER,                                                                                                              
	"HEADER_CONTENT" "SYS"."XMLTYPE" ,                                                                                                 
	"BODY_CONTENT" CLOB,                                                                                                               
	 CONSTRAINT "RNT_MENU_PAGES_PK" PRIMARY KEY ("TAB                                                                                  
_NAME", "MENU_NAME", "PAGE_NAME", "SUB_P                                                                                            
AGE")                                                                                                                               
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPU                                                                              
TE STATISTICS                                                                                                                       
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTEN                                                                                       
TS 1 MAXEXTENTS 2147483645                                                                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_                                                                                     
FLASH_CACHE DEFAULT)                                                                                                                
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_MENU_PAGES_R1" FOREIGN KEY ("T                                                                                    
AB_NAME", "MENU_NAME")                                                                                                              
	  REFERENCES "RNTMGR"."RNT_MENUS" ("TAB_NAME", "MENU_NAM                                                                           
E") ENABLE                                                                                                                          
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 196608 NEXT 1048576 MINEXTENT                                                                                     
S 1 MAXEXTENTS 2147483645                                                                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_F                                                                                    
LASH_CACHE DEFAULT)                                                                                                                 
  TABLESPACE "USERS"                                                                                                                
 XMLTYPE COLUMN "HEADER_CONTENT" STORE AS BASICFILE CLOB (                                                                          
                                                                                                                                    
  TABLESPACE "USERS" ENABLE STORAGE IN ROW CHUNK 8192 PCTVE                                                                         
RSION 10                                                                                                                            
  NOCACHE LOGGING                                                                                                                   
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MA                                                                                
XEXTENTS 2147483645                                                                                                                 
  PCTINCREASE 0 FREELISTS 1 FREELIST GRO                                                                                            
UPS 1                                                                                                                               
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_C                                                                              
ACHE DEFAULT))                                                                                                                      
 LOB ("BODY_CONTENT") STORE AS BASICFILE (                                                                                          
  TABLESPACE "USERS" ENABLE STORAGE IN RO                                                                                           
W CHUNK 8192 PCTVERSION 10                                                                                                          
  NOCACHE LOGGING                                                                                                                   
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXE                                                                              
XTENTS 2147483645                                                                                                                   
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUP                                                                                          
S 1                                                                                                                                 
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CAC                                                                            
HE DEFAULT)) ;                                                                                                                      
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_MENU_ROLES"                                                                                            
   (	"TAB_NAME" VARCHAR2(32) NOT NULL ENABLE,                                                                                       
	"ROLE_ID" NUMBER NOT NULL ENABLE,                                                                                                  
	 CONSTRAINT "RNT_MENU_ROLES_PK" PRIMARY KEY ("TAB_NAM                                                                              
E", "ROLE_ID")                                                                                                                      
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS                                                                                        
255 COMPUTE STATISTICS                                                                                                              
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXT                                                                            
ENTS 2147483645                                                                                                                     
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
1                                                                                                                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
 DEFAULT)                                                                                                                           
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_MENU_ROLES_R2" FOREIGN KEY ("ROLE_ID")                                                                            
	  REFERENCES "RNTMGR"."RNT_USER_ROLES" ("                                                                                          
ROLE_ID") ENABLE,                                                                                                                   
	 CONSTRAINT "RNT_MENU_ROLES_R1" FOREIGN                                                                                            
KEY ("TAB_NAME")                                                                                                                    
	  REFERENCES "RNTMGR"."RNT_MENU_TABS" ("TA                                                                                         
B_NAME") ENABLE                                                                                                                     
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEX                                                                                          
TENTS 1 MAXEXTENTS 2147483645                                                                                                       
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CE                                                                                        
LL_FLASH_CACHE DEFAULT)                                                                                                             
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_MENU_TABS"                                                                                             
   (	"TAB_NAME" VARCHAR2(32) NOT NULL ENABLE,                                                                                       
	"TAB_TITLE" VARCHAR2(32) NOT NULL ENABLE,                                                                                          
	"PARENT_TAB" VARCHAR2(32),                                                                                                         
	"DISPLAY_SEQ" NUMBER,                                                                                                              
	"TAB_HREF" VARCHAR2(128),                                                                                                          
	 CONSTRAINT "RNT_MENU_TABS_PK" PRIMARY KEY ("                                                                                      
TAB_NAME")                                                                                                                          
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255                                                                                    
COMPUTE STATISTICS                                                                                                                  
  STORAGE(INITIAL 65536 NEXT 1048576 MIN                                                                                            
EXTENTS 1 MAXEXTENTS 2147483645                                                                                                     
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
CELL_FLASH_CACHE DEFAULT)                                                                                                           
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_MENU_TABS_R1" FOREIGN KEY                                                                                         
 ("PARENT_TAB")                                                                                                                     
	  REFERENCES "RNTMGR"."RNT_MENU_TABS" ("TAB                                                                                        
_NAME") ENABLE                                                                                                                      
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXT                                                                                         
ENTS 1 MAXEXTENTS 2147483645                                                                                                        
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CEL                                                                                       
L_FLASH_CACHE DEFAULT)                                                                                                              
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_PAYMENTS"                                                                                              
   (	"PAYMENT_ID" NUMBER NOT NULL ENABLE,                                                                                           
	"PAYMENT_DATE" DATE NOT NULL ENABLE,                                                                                               
	"DESCRIPTION" VARCHAR2(256) NOT NULL ENABLE,                                                                                       
	"PAID_OR_RECEIVED" VARCHAR2(16) DEFAULT 'PAID' NO                                                                                  
T NULL ENABLE,                                                                                                                      
	"AMOUNT" NUMBER NOT NULL ENABLE,                                                                                                   
	"TENANT_ID" NUMBER,                                                                                                                
	"BUSINESS_ID" NUMBER NOT NULL ENABLE,                                                                                              
	 CONSTRAINT "RNT_PAYMENTS_PK" PRIMARY KEY ("PA                                                                                     
YMENT_ID")                                                                                                                          
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255                                                                                    
COMPUTE STATISTICS                                                                                                                  
  STORAGE(INITIAL 262144 NEXT 1048576 MI                                                                                            
NEXTENTS 1 MAXEXTENTS 2147483645                                                                                                    
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
 CELL_FLASH_CACHE DEFAULT)                                                                                                          
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_PAYMENTS_UK1" UNIQUE ("P                                                                                          
AYMENT_DATE", "DESCRIPTION")                                                                                                        
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 CO                                                                                 
MPUTE STATISTICS                                                                                                                    
  STORAGE(INITIAL 2097152 NEXT 1048576 MIN                                                                                          
EXTENTS 1 MAXEXTENTS 2147483645                                                                                                     
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
CELL_FLASH_CACHE DEFAULT)                                                                                                           
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_PAYMENTS_RNT_TENANT_FK" F                                                                                         
OREIGN KEY ("TENANT_ID")                                                                                                            
	  REFERENCES "RNTMGR"."RNT_TENANT" ("TENANT_ID") ENABL                                                                             
E                                                                                                                                   
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 2                                                                                       
55                                                                                                                                  
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXT                                                                            
ENTS 2147483645                                                                                                                     
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
1                                                                                                                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
 DEFAULT)                                                                                                                           
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_PAYMENT_ALLOCATIONS"                                                                                   
   (	"PAY_ALLOC_ID" NUMBER NOT NULL ENABLE,                                                                                         
	"PAYMENT_DATE" DATE NOT NULL ENABLE,                                                                                               
	"AMOUNT" NUMBER,                                                                                                                   
	"AR_ID" NUMBER,                                                                                                                    
	"AP_ID" NUMBER,                                                                                                                    
	"PAYMENT_ID" NUMBER,                                                                                                               
	 CONSTRAINT "RNT_PAYMENT_ALLOC_PK" PRIMARY KE                                                                                      
Y ("PAY_ALLOC_ID")                                                                                                                  
  USING INDEX PCTFREE 10 INITRANS 2 MAXTR                                                                                           
ANS 255 COMPUTE STATISTICS                                                                                                          
  STORAGE(INITIAL 720896 NEXT 1048576 MINEXTENTS 1 M                                                                                
AXEXTENTS 2147483645                                                                                                                
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_                                                                               
CACHE DEFAULT)                                                                                                                      
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_PAYMENT_ALLOCATIONS_FK" FOREIGN KEY                                                                               
("PAYMENT_ID")                                                                                                                      
	  REFERENCES "RNTMGR"."RNT_PAYMENTS" ("PAYME                                                                                       
NT_ID") ENABLE,                                                                                                                     
	 CONSTRAINT "RNT_PAYMENTS_RNT_ACCOUNTS_FK1                                                                                         
" FOREIGN KEY ("AP_ID")                                                                                                             
	  REFERENCES "RNTMGR"."RNT_ACCOUNTS_PAYABLE" ("AP_ID")                                                                             
ENABLE,                                                                                                                             
	 CONSTRAINT "RNT_PAYMENTS_RNT_ACCOUNTS_FK2" FOREIG                                                                                 
N KEY ("AR_ID")                                                                                                                     
	  REFERENCES "RNTMGR"."RNT_ACCOUNTS_RECEIVA                                                                                        
BLE" ("AR_ID") ENABLE                                                                                                               
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 2                                                                                       
55                                                                                                                                  
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 1048576 NEXT 1048576 MINEXTENTS 1 MAXE                                                                            
XTENTS 2147483645                                                                                                                   
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUP                                                                                          
S 1                                                                                                                                 
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CAC                                                                            
HE DEFAULT)                                                                                                                         
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_PAYMENT_TYPES"                                                                                         
   (	"PAYMENT_TYPE_ID" NUMBER NOT NULL ENABLE,                                                                                      
	"PAYMENT_TYPE_NAME" VARCHAR2(30) NOT NULL ENA                                                                                      
BLE,                                                                                                                                
	"DEPRECIATION_TERM" NUMBER,                                                                                                        
	"DESCRIPTION" VARCHAR2(4000),                                                                                                      
	"PAYABLE_YN" VARCHAR2(1) NOT NULL ENABLE,                                                                                          
	"RECEIVABLE_YN" VARCHAR2(1) NOT NULL ENABLE,                                                                                       
	"SERVICE_LIFE" NUMBER(3,0),                                                                                                        
	"NOI_YN" VARCHAR2(1) NOT NULL ENABLE,                                                                                              
	 CONSTRAINT "RNT_PAYMENT_TYPES_PK" PRIMARY KEY ("P                                                                                 
AYMENT_TYPE_ID")                                                                                                                    
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRAN                                                                                         
S 255 COMPUTE STATISTICS                                                                                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXE                                                                              
XTENTS 2147483645                                                                                                                   
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUP                                                                                          
S 1                                                                                                                                 
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CAC                                                                            
HE DEFAULT)                                                                                                                         
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_PAYMENT_TYPES_UK1" UNIQUE ("PAYMENT_TYP                                                                           
E_NAME")                                                                                                                            
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 CO                                                                                 
MPUTE STATISTICS                                                                                                                    
  STORAGE(INITIAL 65536 NEXT 1048576 MINEX                                                                                          
TENTS 1 MAXEXTENTS 2147483645                                                                                                       
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CE                                                                                        
LL_FLASH_CACHE DEFAULT)                                                                                                             
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTEN                                                                                       
TS 1 MAXEXTENTS 2147483645                                                                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_                                                                                     
FLASH_CACHE DEFAULT)                                                                                                                
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_PEOPLE"                                                                                                
   (	"PEOPLE_ID" NUMBER NOT NULL ENABLE,                                                                                            
                                                                                                                                    
	"FIRST_NAME" VARCHAR2(30) NOT NULL ENABLE,                                                                                         
	"LAST_NAME" VARCHAR2(30) NOT NULL ENABLE,                                                                                          
	"PHONE1" VARCHAR2(16),                                                                                                             
	"PHONE2" VARCHAR2(16),                                                                                                             
	"EMAIL_ADDRESS" VARCHAR2(100),                                                                                                     
	"SSN" VARCHAR2(11),                                                                                                                
	"DRIVERS_LICENSE" VARCHAR2(100),                                                                                                   
	"DATE_OF_BIRTH" DATE,                                                                                                              
	 CONSTRAINT "RNT_PEOPLE_PK" PRIMARY KEY ("PEO                                                                                      
PLE_ID")                                                                                                                            
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 CO                                                                                 
MPUTE STATISTICS                                                                                                                    
  STORAGE(INITIAL 65536 NEXT 1048576 MINEX                                                                                          
TENTS 1 MAXEXTENTS 2147483645                                                                                                       
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CE                                                                                        
LL_FLASH_CACHE DEFAULT)                                                                                                             
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTEN                                                                                       
TS 1 MAXEXTENTS 2147483645                                                                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_                                                                                     
FLASH_CACHE DEFAULT)                                                                                                                
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_PEOPLE_BU"                                                                                             
   (	"PEOPLE_BUSINESS_ID" NUMBER NOT NULL ENABLE,                                                                                   
	"PEOPLE_ID" NUMBER NOT NULL ENABLE,                                                                                                
	"BUSINESS_ID" NUMBER NOT NULL ENABLE,                                                                                              
	 CONSTRAINT "RNT_PEOPLE_BU_PK" PRIMARY KEY ("PEO                                                                                   
PLE_BUSINESS_ID")                                                                                                                   
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRA                                                                                          
NS 255 COMPUTE STATISTICS                                                                                                           
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAX                                                                               
EXTENTS 2147483645                                                                                                                  
  PCTINCREASE 0 FREELISTS 1 FREELIST GROU                                                                                           
PS 1                                                                                                                                
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CA                                                                             
CHE DEFAULT)                                                                                                                        
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_PEOPLE_BU_FK1" FOREIGN KEY ("BUSINESS_                                                                            
ID")                                                                                                                                
	  REFERENCES "RNTMGR"."RNT_BUSINESS_UNITS" ("BUSINESS_                                                                             
ID") ENABLE,                                                                                                                        
	 CONSTRAINT "RNT_PEOPLE_BU_FK2" FOREIGN KEY (                                                                                      
"PEOPLE_ID")                                                                                                                        
	  REFERENCES "RNTMGR"."RNT_PEOPLE" ("PEOPLE_ID                                                                                     
") ENABLE                                                                                                                           
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS                                                                                     
1 MAXEXTENTS 2147483645                                                                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLA                                                                                  
SH_CACHE DEFAULT)                                                                                                                   
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_PROPERTIES"                                                                                            
   (	"PROPERTY_ID" NUMBER NOT NULL ENABLE,                                                                                          
	"BUSINESS_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"UNITS" NUMBER DEFAULT 1 NOT NULL ENABLE,                                                                                          
	"ADDRESS1" VARCHAR2(60) NOT NULL ENABLE,                                                                                           
	"ADDRESS2" VARCHAR2(60),                                                                                                           
	"CITY" VARCHAR2(60) NOT NULL ENABLE,                                                                                               
	"STATE" VARCHAR2(2) NOT NULL ENABLE,                                                                                               
	"ZIPCODE" VARCHAR2(7) NOT NULL ENABLE,                                                                                             
	"DATE_PURCHASED" DATE,                                                                                                             
	"PURCHASE_PRICE" NUMBER,                                                                                                           
	"LAND_VALUE" NUMBER,                                                                                                               
	"DEPRECIATION_TERM" NUMBER DEFAULT 27.5 NOT                                                                                        
NULL ENABLE,                                                                                                                        
	"YEAR_BUILT" NUMBER,                                                                                                               
	"BUILDING_SIZE" NUMBER,                                                                                                            
	"LOT_SIZE" NUMBER,                                                                                                                 
	"DATE_SOLD" DATE,                                                                                                                  
	"SALE_AMOUNT" NUMBER,                                                                                                              
	"NOTE_YN" VARCHAR2(1),                                                                                                             
	"DESCRIPTION" VARCHAR2(4000),                                                                                                      
	"NAME" VARCHAR2(64),                                                                                                               
	"STATUS" VARCHAR2(16),                                                                                                             
	"PROP_ID" NUMBER,                                                                                                                  
	 CONSTRAINT "RNT_PROPERTIES_PK" PRIMARY KEY ("                                                                                     
PROPERTY_ID")                                                                                                                       
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 2                                                                                      
55 COMPUTE STATISTICS                                                                                                               
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTE                                                                           
NTS 2147483645                                                                                                                      
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
                                                                                                                                    
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
DEFAULT)                                                                                                                            
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_PROPERTIES_CK1" CHECK                                                                                             
(state in ('AK', 'AL', 'AR', 'AZ', 'CA',                                                                                            
 'CO', 'CT', 'DC', 'DE',                                                                                                            
'FL', 'GA', 'HI', 'IA', 'ID', 'IL', 'IN', 'KS', 'KY', '                                                                             
LA', 'MA', 'MD',                                                                                                                    
'ME', 'MI', 'MN', 'MO', 'MS', 'MT', 'NC', '                                                                                         
ND', 'NE', 'NH', 'NJ', 'NM',                                                                                                        
'NV', 'NY', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD                                                                                 
', 'TN', 'TX', 'UT',                                                                                                                
'VA', 'VT', 'WA', 'WI', 'WV', 'WY')) ENABLE,                                                                                        
	 CONSTRAINT "RNT_PROPERTIES_UK1" UNIQUE ("BUSINESS_I                                                                               
D", "ADDRESS1", "ZIPCODE")                                                                                                          
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMP                                                                               
UTE STATISTICS                                                                                                                      
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTE                                                                                        
NTS 1 MAXEXTENTS 2147483645                                                                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL                                                                                      
_FLASH_CACHE DEFAULT)                                                                                                               
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_PROPERTIES_FK" FOREIGN KEY ("                                                                                     
BUSINESS_ID")                                                                                                                       
	  REFERENCES "RNTMGR"."RNT_BUSINESS_UNITS" ("                                                                                      
BUSINESS_ID") ENABLE,                                                                                                               
	 CONSTRAINT "RNT_PROPERTIES_R1" FOREIGN KEY ("PROP_ID")                                                                            
	  REFERENCES "RNTMGR"."PR_PROPERTIES" (                                                                                            
"PROP_ID") ENABLE                                                                                                                   
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MIN                                                                                            
EXTENTS 1 MAXEXTENTS 2147483645                                                                                                     
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
CELL_FLASH_CACHE DEFAULT)                                                                                                           
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_PROPERTY_ESTIMATES"                                                                                    
   (	"PROPERTY_ID" NUMBER NOT NULL ENABLE,                                                                                          
	"BUSINESS_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"ESTIMATE_YEAR" DATE NOT NULL ENABLE,                                                                                              
	"ESTIMATE_TITLE" VARCHAR2(60) DEFAULT 'Pro-F                                                                                       
orma Statement',                                                                                                                    
	"MONTHLY_RENT" NUMBER NOT NULL ENABLE,                                                                                             
	"OTHER_INCOME" NUMBER DEFAULT 0,                                                                                                   
	"VACANCY_PCT" NUMBER(2,0) DEFAULT 5,                                                                                               
	"REPLACE_3YEARS" NUMBER DEFAULT 0,                                                                                                 
	"REPLACE_5YEARS" NUMBER DEFAULT 0,                                                                                                 
	"REPLACE_12YEARS" NUMBER DEFAULT 0,                                                                                                
	"MAINTENANCE" NUMBER DEFAULT 0,                                                                                                    
	"UTILITIES" NUMBER DEFAULT 0,                                                                                                      
	"PROPERTY_TAXES" NUMBER DEFAULT 0,                                                                                                 
	"INSURANCE" NUMBER DEFAULT 0,                                                                                                      
	"MGT_FEES" NUMBER DEFAULT 0,                                                                                                       
	"DOWN_PAYMENT" NUMBER DEFAULT 0,                                                                                                   
	"CLOSING_COSTS" NUMBER DEFAULT 0,                                                                                                  
	"PURCHASE_PRICE" NUMBER,                                                                                                           
	"CAP_RATE" NUMBER,                                                                                                                 
	"LOAN1_AMOUNT" NUMBER DEFAULT 0,                                                                                                   
	"LOAN1_TYPE" VARCHAR2(16) DEFAULT 'Amortizing',                                                                                    
	"LOAN1_TERM" NUMBER,                                                                                                               
	"LOAN1_RATE" NUMBER DEFAULT 8.0,                                                                                                   
	"LOAN2_AMOUNT" NUMBER DEFAULT 0,                                                                                                   
	"LOAN2_TYPE" VARCHAR2(16) DEFAULT 'Interest Only',                                                                                 
                                                                                                                                    
	"LOAN2_TERM" NUMBER,                                                                                                               
	"LOAN2_RATE" NUMBER DEFAULT 8.0,                                                                                                   
	"NOTES" VARCHAR2(4000),                                                                                                            
	"PROPERTY_ESTIMATES_ID" NUMBER NOT NULL ENABLE,                                                                                    
	 CONSTRAINT "RNT_PROPERTY_ESTIMATES_CHK2" CH                                                                                       
ECK (loan2_type  in ('Amortizing', 'Inte                                                                                            
rest Only')) ENABLE,                                                                                                                
	 CONSTRAINT "RNT_PROPERTY_ESTIMATES_CHK1" CHECK (loan1_ty                                                                          
pe  in ('Amortizing', 'Interest Only'))                                                                                             
ENABLE,                                                                                                                             
	 CONSTRAINT "RNT_PROPERTY_ESTIMATES_U1" UNIQUE ("P                                                                                 
ROPERTY_ID", "BUSINESS_ID", "ESTIMATE_YE                                                                                            
AR", "ESTIMATE_TITLE")                                                                                                              
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE                                                                            
STATISTICS                                                                                                                          
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS                                                                                     
1 MAXEXTENTS 2147483645                                                                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLA                                                                                  
SH_CACHE DEFAULT)                                                                                                                   
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_PROPERTY_ESTIMATES_PK" UNIQUE ("P                                                                                 
ROPERTY_ESTIMATES_ID")                                                                                                              
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE                                                                            
STATISTICS                                                                                                                          
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS                                                                                     
1 MAXEXTENTS 2147483645                                                                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLA                                                                                  
SH_CACHE DEFAULT)                                                                                                                   
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_PROPERTY_ESTIMATES_FK1" FOREIGN K                                                                                 
EY ("PROPERTY_ID")                                                                                                                  
	  REFERENCES "RNTMGR"."RNT_PROPERTIES" (                                                                                           
"PROPERTY_ID") ENABLE,                                                                                                              
	 CONSTRAINT "RNT_PROPERTY_ESTIMATES_FK2" FOREIGN KEY ("                                                                            
BUSINESS_ID")                                                                                                                       
	  REFERENCES "RNTMGR"."RNT_BUSINESS_UNITS" ("                                                                                      
BUSINESS_ID") ENABLE                                                                                                                
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 25                                                                                      
5                                                                                                                                   
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTE                                                                           
NTS 2147483645                                                                                                                      
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
                                                                                                                                    
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
DEFAULT)                                                                                                                            
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_PROPERTY_EXPENSES"                                                                                     
   (	"EXPENSE_ID" NUMBER NOT NULL ENABLE,                                                                                           
	"PROPERTY_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"EVENT_DATE" DATE NOT NULL ENABLE,                                                                                                 
	"DESCRIPTION" VARCHAR2(4000) NOT NULL ENABLE,                                                                                      
	"RECURRING_YN" VARCHAR2(1) DEFAULT 'N' NO                                                                                          
T NULL ENABLE,                                                                                                                      
	"RECURRING_PERIOD" VARCHAR2(20) DEFAULT 'N/                                                                                        
A',                                                                                                                                 
	"RECURRING_ENDDATE" DATE,                                                                                                          
	"UNIT_ID" NUMBER,                                                                                                                  
	"LOAN_ID" NUMBER,                                                                                                                  
	 CONSTRAINT "RNT_PROPERTY_EXPENSES_PK" PRIMARY                                                                                     
 KEY ("EXPENSE_ID")                                                                                                                 
  USING INDEX PCTFREE 10 INITRANS 2 MAXT                                                                                            
RANS 255 COMPUTE STATISTICS                                                                                                         
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1                                                                                  
MAXEXTENTS 2147483645                                                                                                               
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH                                                                                
_CACHE DEFAULT)                                                                                                                     
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_PROPERTY_HISTORY_UK1" UNIQUE ("PROP                                                                               
ERTY_ID", "EVENT_DATE", "UNIT_ID", "DESC                                                                                            
RIPTION")                                                                                                                           
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 165 C                                                                                  
OMPUTE STATISTICS                                                                                                                   
  STORAGE(INITIAL 327680 NEXT 1048576 MIN                                                                                           
EXTENTS 1 MAXEXTENTS 2147483645                                                                                                     
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
CELL_FLASH_CACHE DEFAULT)                                                                                                           
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_PROPERTY_HISTORY_FK" FORE                                                                                         
IGN KEY ("PROPERTY_ID")                                                                                                             
	  REFERENCES "RNTMGR"."RNT_PROPERTIES" ("PROPERTY_ID")                                                                             
ENABLE,                                                                                                                             
	 CONSTRAINT "RNT_PROPERTY_HISTORY_FK2" FOREIGN KEY                                                                                 
 ("UNIT_ID")                                                                                                                        
	  REFERENCES "RNTMGR"."RNT_PROPERTY_UNITS" ("U                                                                                     
NIT_ID") ENABLE,                                                                                                                    
	 CONSTRAINT "RNT_PROPERTY_EXPENSES_R3" FO                                                                                          
REIGN KEY ("LOAN_ID")                                                                                                               
	  REFERENCES "RNTMGR"."RNT_LOANS" ("LOAN_ID") ENABLE                                                                               
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEX                                                                                          
TENTS 1 MAXEXTENTS 2147483645                                                                                                       
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CE                                                                                        
LL_FLASH_CACHE DEFAULT)                                                                                                             
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_PROPERTY_LINKS"                                                                                        
   (	"PROPERTY_LINK_ID" NUMBER NOT NULL ENABLE,                                                                                     
	"PROPERTY_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"LINK_TITLE" VARCHAR2(200) NOT NULL ENABLE,                                                                                        
                                                                                                                                    
	"LINK_URL" VARCHAR2(1000) NOT NULL ENABLE,                                                                                         
	"CREATION_DATE" DATE,                                                                                                              
	 CONSTRAINT "RNT_PROPERTY_LINKS_PK" PRIMARY KEY                                                                                    
("PROPERTY_LINK_ID")                                                                                                                
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE ST                                                                         
ATISTICS                                                                                                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1                                                                                   
MAXEXTENTS 2147483645                                                                                                               
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH                                                                                
_CACHE DEFAULT)                                                                                                                     
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRAN                                                                                          
S 255                                                                                                                               
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAX                                                                               
EXTENTS 2147483645                                                                                                                  
  PCTINCREASE 0 FREELISTS 1 FREELIST GROU                                                                                           
PS 1                                                                                                                                
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CA                                                                             
CHE DEFAULT)                                                                                                                        
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_PROPERTY_PHOTOS"                                                                                       
   (	"PHOTO_ID" NUMBER NOT NULL ENABLE,                                                                                             
	"PHOTO_TITLE" VARCHAR2(300) NOT NULL ENABLE,                                                                                       
	"PHOTO_FILENAME" VARCHAR2(1024) NOT NULL EN                                                                                        
ABLE,                                                                                                                               
	"PROPERTY_ID" NUMBER NOT NULL ENABLE,                                                                                              
	 CONSTRAINT "RNT_PROPERTY_PHOTOS_PK" PRIMARY KEY ("P                                                                               
HOTO_ID")                                                                                                                           
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 C                                                                                  
OMPUTE STATISTICS                                                                                                                   
  STORAGE(INITIAL 65536 NEXT 1048576 MINE                                                                                           
XTENTS 1 MAXEXTENTS 2147483645                                                                                                      
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT C                                                                                         
ELL_FLASH_CACHE DEFAULT)                                                                                                            
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_PROPERTY_PHOTOS_FK1" FOREI                                                                                        
GN KEY ("PROPERTY_ID")                                                                                                              
	  REFERENCES "RNTMGR"."RNT_PROPERTIES" ("PROPERTY_ID") E                                                                           
NABLE                                                                                                                               
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRA                                                                                           
NS 255                                                                                                                              
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MA                                                                                
XEXTENTS 2147483645                                                                                                                 
  PCTINCREASE 0 FREELISTS 1 FREELIST GRO                                                                                            
UPS 1                                                                                                                               
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_C                                                                              
ACHE DEFAULT)                                                                                                                       
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_PROPERTY_UNITS"                                                                                        
   (	"UNIT_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"PROPERTY_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"UNIT_NAME" VARCHAR2(32) DEFAULT 'Unit 1' NOT NULL E                                                                               
NABLE,                                                                                                                              
	"UNIT_SIZE" NUMBER,                                                                                                                
	"BEDROOMS" NUMBER,                                                                                                                 
	"BATHROOMS" NUMBER,                                                                                                                
	"DESCRIPTION" VARCHAR2(4000),                                                                                                      
	 CONSTRAINT "RNT_PROPERTY_UNITS_PK" PRIMARY KEY ("UNIT                                                                             
_ID")                                                                                                                               
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPU                                                                              
TE STATISTICS                                                                                                                       
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTEN                                                                                       
TS 1 MAXEXTENTS 2147483645                                                                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_                                                                                     
FLASH_CACHE DEFAULT)                                                                                                                
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_PROPERTY_UNITS_UK1" UNIQUE ("P                                                                                    
ROPERTY_ID", "UNIT_NAME")                                                                                                           
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPU                                                                              
TE STATISTICS                                                                                                                       
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTEN                                                                                       
TS 1 MAXEXTENTS 2147483645                                                                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_                                                                                     
FLASH_CACHE DEFAULT)                                                                                                                
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_PROPERTY_UNITS_FK1" FOREIGN KE                                                                                    
Y ("PROPERTY_ID")                                                                                                                   
	  REFERENCES "RNTMGR"."RNT_PROPERTIES" ("                                                                                          
PROPERTY_ID") ENABLE                                                                                                                
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 25                                                                                      
5                                                                                                                                   
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTE                                                                           
NTS 2147483645                                                                                                                      
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
                                                                                                                                    
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
DEFAULT)                                                                                                                            
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_PROPERTY_VALUE"                                                                                        
   (	"VALUE_ID" NUMBER(8,0) NOT NULL ENABLE,                                                                                        
	"PROPERTY_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"VALUE_DATE" DATE NOT NULL ENABLE,                                                                                                 
	"VALUE_METHOD" VARCHAR2(30) NOT NULL ENABLE,                                                                                       
	"VALUE" NUMBER NOT NULL ENABLE,                                                                                                    
	"CAP_RATE" NUMBER,                                                                                                                 
	 CONSTRAINT "RNT_PROPERTY_VALUE_PK" PRIMARY KEY                                                                                    
 ("VALUE_ID")                                                                                                                       
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 2                                                                                      
55 COMPUTE STATISTICS                                                                                                               
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTE                                                                           
NTS 2147483645                                                                                                                      
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
                                                                                                                                    
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
DEFAULT)                                                                                                                            
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_PROPERTY_VALUE_UK1" UN                                                                                            
IQUE ("PROPERTY_ID", "VALUE_DATE", "VALU                                                                                            
E_METHOD")                                                                                                                          
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255                                                                                    
COMPUTE STATISTICS                                                                                                                  
  STORAGE(INITIAL 65536 NEXT 1048576 MIN                                                                                            
EXTENTS 1 MAXEXTENTS 2147483645                                                                                                     
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
CELL_FLASH_CACHE DEFAULT)                                                                                                           
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_PROPERTY_VALUE_FK" FOREIG                                                                                         
N KEY ("PROPERTY_ID")                                                                                                               
	  REFERENCES "RNTMGR"."RNT_PROPERTIES" ("PROPERTY_ID") EN                                                                          
ABLE                                                                                                                                
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRAN                                                                                          
S 255                                                                                                                               
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAX                                                                               
EXTENTS 2147483645                                                                                                                  
  PCTINCREASE 0 FREELISTS 1 FREELIST GROU                                                                                           
PS 1                                                                                                                                
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CA                                                                             
CHE DEFAULT)                                                                                                                        
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_PT_RULES"                                                                                              
   (	"BUSINESS_ID" NUMBER NOT NULL ENABLE,                                                                                          
	"PAYMENT_TYPE_ID" NUMBER NOT NULL ENABLE,                                                                                          
	"TRANSACTION_TYPE" VARCHAR2(32) NOT NULL ENABLE,                                                                                   
	"DEBIT_ACCOUNT" NUMBER NOT NULL ENABLE,                                                                                            
                                                                                                                                    
	"CREDIT_ACCOUNT" NUMBER NOT NULL ENABLE,                                                                                           
	 CONSTRAINT "RNT_PT_RULES_CK1" CHECK (transaction_type                                                                             
 in ('APS','APP', 'ARS', 'ARP', 'DEP'))                                                                                             
ENABLE,                                                                                                                             
	 CONSTRAINT "RNT_PT_RULES_PK" PRIMARY KEY ("BUSINE                                                                                 
SS_ID", "PAYMENT_TYPE_ID", "TRANSACTION_                                                                                            
TYPE")                                                                                                                              
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMP                                                                               
UTE STATISTICS                                                                                                                      
  STORAGE(INITIAL 524288 NEXT 1048576 MINEXT                                                                                        
ENTS 1 MAXEXTENTS 2147483645                                                                                                        
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CEL                                                                                       
L_FLASH_CACHE DEFAULT)                                                                                                              
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_PT_RULES_FK4" FOREIGN KEY ("                                                                                      
CREDIT_ACCOUNT")                                                                                                                    
	  REFERENCES "RNTMGR"."RNT_ACCOUNTS" ("ACC                                                                                         
OUNT_ID") ENABLE,                                                                                                                   
	 CONSTRAINT "RNT_PT_RULES_FK3" FOREIGN K                                                                                           
EY ("DEBIT_ACCOUNT")                                                                                                                
	  REFERENCES "RNTMGR"."RNT_ACCOUNTS" ("ACCOUNT_ID") ENABLE                                                                         
,                                                                                                                                   
	 CONSTRAINT "RNT_PT_RULES_FK2" FOREIGN KEY ("PAYMENT_TYP                                                                           
E_ID")                                                                                                                              
	  REFERENCES "RNTMGR"."RNT_PAYMENT_TYPES" ("PAYMENT_                                                                               
TYPE_ID") ENABLE,                                                                                                                   
	 CONSTRAINT "RNT_PT_RULES_FK1" FOREIGN K                                                                                           
EY ("BUSINESS_ID")                                                                                                                  
	  REFERENCES "RNTMGR"."RNT_BUSINESS_UNIT                                                                                           
S" ("BUSINESS_ID") ENABLE                                                                                                           
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRA                                                                                           
NS 255                                                                                                                              
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MA                                                                                
XEXTENTS 2147483645                                                                                                                 
  PCTINCREASE 0 FREELISTS 1 FREELIST GRO                                                                                            
UPS 1                                                                                                                               
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_C                                                                              
ACHE DEFAULT)                                                                                                                       
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_SECTION8_OFFICES"                                                                                      
   (	"SECTION8_ID" NUMBER NOT NULL ENABLE,                                                                                          
	"SECTION_NAME" VARCHAR2(30) NOT NULL ENABLE,                                                                                       
	 CONSTRAINT "RNT_SECTION8_OFFICES_PK" P                                                                                            
RIMARY KEY ("SECTION8_ID")                                                                                                          
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMP                                                                               
UTE STATISTICS                                                                                                                      
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTE                                                                                        
NTS 1 MAXEXTENTS 2147483645                                                                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL                                                                                      
_FLASH_CACHE DEFAULT)                                                                                                               
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS                                                                                     
 1 MAXEXTENTS 2147483645                                                                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FL                                                                                   
ASH_CACHE DEFAULT)                                                                                                                  
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_SECTION8_OFFICES_BU"                                                                                   
   (	"SECTION8_BUSINESS_ID" NUMBER NOT NULL ENAB                                                                                    
LE,                                                                                                                                 
	"SECTION8_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"BUSINESS_ID" NUMBER NOT NULL ENABLE,                                                                                              
	 CONSTRAINT "RNT_SECTION8_OFFICES_BU_PK" PRIMARY KEY (                                                                             
"SECTION8_BUSINESS_ID")                                                                                                             
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE                                                                            
 STATISTICS                                                                                                                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS                                                                                     
 1 MAXEXTENTS 2147483645                                                                                                            
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FL                                                                                   
ASH_CACHE DEFAULT)                                                                                                                  
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_SECTION8_OFFICES_BU_FK1" FOREIGN                                                                                  
 KEY ("BUSINESS_ID")                                                                                                                
	  REFERENCES "RNTMGR"."RNT_BUSINESS_UNITS" ("BUSINESS_ID")                                                                         
 ENABLE,                                                                                                                            
	 CONSTRAINT "RNT_SECTION8_OFFICES_BU_FK2" FOREIGN                                                                                  
 KEY ("SECTION8_ID")                                                                                                                
	  REFERENCES "RNTMGR"."RNT_SECTION8_OFFICES" ("SECTION8_ID                                                                         
") ENABLE                                                                                                                           
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS                                                                                     
1 MAXEXTENTS 2147483645                                                                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLA                                                                                  
SH_CACHE DEFAULT)                                                                                                                   
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_SUPPLIERS_ALL"                                                                                         
   (	"SUPPLIER_ID" NUMBER NOT NULL ENABLE,                                                                                          
	"NAME" VARCHAR2(60) NOT NULL ENABLE,                                                                                               
	"PHONE1" VARCHAR2(30) NOT NULL ENABLE,                                                                                             
	"PHONE2" VARCHAR2(30),                                                                                                             
	"ADDRESS1" VARCHAR2(60),                                                                                                           
	"ADDRESS2" VARCHAR2(60),                                                                                                           
	"CITY" VARCHAR2(30),                                                                                                               
	"STATE" VARCHAR2(2),                                                                                                               
	"ZIPCODE" NUMBER,                                                                                                                  
	"EMAIL_ADDRESS" VARCHAR2(100),                                                                                                     
	"COMMENTS" VARCHAR2(4000),                                                                                                         
	"SUPPLIER_TYPE_ID" NUMBER NOT NULL ENABLE,                                                                                         
                                                                                                                                    
	 CONSTRAINT "RNT_CONTRACTORS_ALL_PK" PRIMARY KEY ("SUPPLI                                                                          
ER_ID")                                                                                                                             
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COM                                                                                
PUTE STATISTICS                                                                                                                     
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXT                                                                                         
ENTS 1 MAXEXTENTS 2147483645                                                                                                        
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CEL                                                                                       
L_FLASH_CACHE DEFAULT)                                                                                                              
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_SUPPLIERS_ALL_U1" UNIQUE ("S                                                                                      
UPPLIER_TYPE_ID", "NAME", "CITY", "PHONE                                                                                            
1")                                                                                                                                 
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE                                                                            
 STATISTICS                                                                                                                         
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENT                                                                                     
S 1 MAXEXTENTS 2147483645                                                                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_F                                                                                    
LASH_CACHE DEFAULT)                                                                                                                 
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_SUPPLIERS_ALL_FK1" FOREIGN KEY                                                                                    
("SUPPLIER_TYPE_ID")                                                                                                                
	  REFERENCES "RNTMGR"."RNT_SUPPLIER_TYPES" ("SUPPLIER_TYPE                                                                         
_ID") ENABLE                                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTEN                                                                                       
TS 1 MAXEXTENTS 2147483645                                                                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_                                                                                     
FLASH_CACHE DEFAULT)                                                                                                                
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_SUPPLIERS_OLD"                                                                                         
   (	"SUPPLIER_ID" NUMBER NOT NULL ENABLE,                                                                                          
	"NAME" VARCHAR2(60) NOT NULL ENABLE,                                                                                               
	"PHONE1" VARCHAR2(30) NOT NULL ENABLE,                                                                                             
	"PHONE2" VARCHAR2(30),                                                                                                             
	"ADDRESS1" VARCHAR2(60),                                                                                                           
	"ADDRESS2" VARCHAR2(60),                                                                                                           
	"CITY" VARCHAR2(30),                                                                                                               
	"STATE" VARCHAR2(2),                                                                                                               
	"ZIPCODE" NUMBER,                                                                                                                  
	"SSN" VARCHAR2(11),                                                                                                                
	"EMAIL_ADDRESS" VARCHAR2(100),                                                                                                     
	"COMMENTS" VARCHAR2(4000),                                                                                                         
	"BUSINESS_ID" NUMBER NOT NULL ENABLE,                                                                                              
	 CONSTRAINT "RNT_CONTRACTORS_UK1" UNIQUE                                                                                           
 ("NAME", "BUSINESS_ID")                                                                                                            
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUT                                                                             
E STATISTICS                                                                                                                        
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENT                                                                                      
S 1 MAXEXTENTS 2147483645                                                                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_F                                                                                    
LASH_CACHE DEFAULT)                                                                                                                 
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_SUPPLIERS_FK" FOREIGN KEY ("BUS                                                                                   
INESS_ID")                                                                                                                          
	  REFERENCES "RNTMGR"."RNT_BUSINESS_UNITS" ("BUS                                                                                   
INESS_ID") ENABLE                                                                                                                   
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MIN                                                                                            
EXTENTS 1 MAXEXTENTS 2147483645                                                                                                     
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
CELL_FLASH_CACHE DEFAULT)                                                                                                           
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_SUPPLIER_TYPES"                                                                                        
   (	"SUPPLIER_TYPE_ID" NUMBER NOT NULL ENABLE,                                                                                     
	"SUPPLIER_TYPE_NAME" VARCHAR2(30) NOT NULL                                                                                         
ENABLE,                                                                                                                             
	 CONSTRAINT "RNT_SUPPLIER_TYPES_PK" PRIMARY KEY ("                                                                                 
SUPPLIER_TYPE_ID")                                                                                                                  
  USING INDEX PCTFREE 10 INITRANS 2 MAXTR                                                                                           
ANS 255 COMPUTE STATISTICS                                                                                                          
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MA                                                                                
XEXTENTS 2147483645                                                                                                                 
  PCTINCREASE 0 FREELISTS 1 FREELIST GRO                                                                                            
UPS 1                                                                                                                               
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_C                                                                              
ACHE DEFAULT)                                                                                                                       
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS                                                                                         
255                                                                                                                                 
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEX                                                                             
TENTS 2147483645                                                                                                                    
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
 1                                                                                                                                  
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACH                                                                           
E DEFAULT)                                                                                                                          
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_TENANCY_AGREEMENT"                                                                                     
   (	"AGREEMENT_ID" NUMBER NOT NULL ENABLE,                                                                                         
	"UNIT_ID" NUMBER NOT NULL ENABLE,                                                                                                  
	"AGREEMENT_DATE" DATE,                                                                                                             
	"TERM" NUMBER NOT NULL ENABLE,                                                                                                     
	"AMOUNT" NUMBER NOT NULL ENABLE,                                                                                                   
	"AMOUNT_PERIOD" VARCHAR2(30) NOT NULL ENABLE,                                                                                      
	"DATE_AVAILABLE" DATE NOT NULL ENABLE,                                                                                             
	"DEPOSIT" NUMBER,                                                                                                                  
	"LAST_MONTH" NUMBER,                                                                                                               
	"DISCOUNT_AMOUNT" NUMBER,                                                                                                          
	"DISCOUNT_TYPE" VARCHAR2(30),                                                                                                      
	"DISCOUNT_PERIOD" NUMBER,                                                                                                          
	"END_DATE" DATE,                                                                                                                   
	"AD_PUBLISH_YN" VARCHAR2(1) DEFAULT 'N' NOT NULL ENABLE,                                                                           
                                                                                                                                    
	"AD_TITLE" VARCHAR2(80),                                                                                                           
	"AD_CONTACT" VARCHAR2(80),                                                                                                         
	"AD_EMAIL" VARCHAR2(256),                                                                                                          
	"AD_PHONE" VARCHAR2(16),                                                                                                           
	 CONSTRAINT "RNT_TENANCY_AGREEMENT_PK" PRIMARY                                                                                     
 KEY ("AGREEMENT_ID")                                                                                                               
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE S                                                                          
TATISTICS                                                                                                                           
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1                                                                                   
 MAXEXTENTS 2147483645                                                                                                              
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLAS                                                                                 
H_CACHE DEFAULT)                                                                                                                    
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_TENANCY_AGREEMENT_CHK1" CHECK (ad_                                                                                
publish_yn in ('Y', 'N')) ENABLE,                                                                                                   
	 CONSTRAINT "RNT_TENANCY_AGREEMENT_FK" FOREI                                                                                       
GN KEY ("UNIT_ID")                                                                                                                  
	  REFERENCES "RNTMGR"."RNT_PROPERTY_UNIT                                                                                           
S" ("UNIT_ID") ENABLE                                                                                                               
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 2                                                                                       
55                                                                                                                                  
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXT                                                                            
ENTS 2147483645                                                                                                                     
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
1                                                                                                                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
 DEFAULT)                                                                                                                           
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_TENANT"                                                                                                
   (	"TENANT_ID" NUMBER NOT NULL ENABLE,                                                                                            
                                                                                                                                    
	"AGREEMENT_ID" NUMBER,                                                                                                             
	"STATUS" VARCHAR2(30) NOT NULL ENABLE,                                                                                             
	"DEPOSIT_BALANCE" NUMBER NOT NULL ENABLE,                                                                                          
	"LAST_MONTH_BALANCE" NUMBER NOT NULL ENABLE,                                                                                       
	"PEOPLE_ID" NUMBER NOT NULL ENABLE,                                                                                                
	"SECTION8_VOUCHER_AMOUNT" NUMBER,                                                                                                  
	"SECTION8_TENANT_PAYS" NUMBER,                                                                                                     
	"SECTION8_ID" NUMBER,                                                                                                              
	"TENANT_NOTE" VARCHAR2(4000),                                                                                                      
	 CONSTRAINT "RNT_TENANT_PK" PRIMARY KEY ("TENANT_ID")                                                                              
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS                                                                                        
 255 COMPUTE STATISTICS                                                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEX                                                                             
TENTS 2147483645                                                                                                                    
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
 1                                                                                                                                  
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACH                                                                           
E DEFAULT)                                                                                                                          
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_TENANT_FK3" FOREIGN KEY ("AGREEMENT_ID")                                                                          
                                                                                                                                    
	  REFERENCES "RNTMGR"."RNT_TENANCY_AGREEMENT" ("AGREEMENT_                                                                         
ID") ENABLE,                                                                                                                        
	 CONSTRAINT "RNT_TENANT_FK2" FOREIGN KEY ("SE                                                                                      
CTION8_ID")                                                                                                                         
	  REFERENCES "RNTMGR"."RNT_SECTION8_OFFICES" ("                                                                                    
SECTION8_ID") ENABLE,                                                                                                               
	 CONSTRAINT "RNT_TENANT_FK1" FOREIGN KEY ("PEOPLE_ID")                                                                             
	  REFERENCES "RNTMGR"."RNT_PEOPLE" ("PEO                                                                                           
PLE_ID") ENABLE                                                                                                                     
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEX                                                                                          
TENTS 1 MAXEXTENTS 2147483645                                                                                                       
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CE                                                                                        
LL_FLASH_CACHE DEFAULT)                                                                                                             
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_USERS"                                                                                                 
   (	"USER_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"USER_LOGIN" VARCHAR2(50) NOT NULL ENABLE                                                                                          
,                                                                                                                                   
	"USER_NAME" VARCHAR2(50) NOT NULL ENABLE,                                                                                          
	"USER_PASSWORD" VARCHAR2(64) NOT NULL ENABLE,                                                                                      
	"IS_ACTIVE_YN" VARCHAR2(1) NOT NULL ENABLE,                                                                                        
                                                                                                                                    
	"USER_LASTNAME" VARCHAR2(50),                                                                                                      
	"PRIMARY_PHONE" VARCHAR2(20),                                                                                                      
	"SECONDARY_PHONE" VARCHAR2(20),                                                                                                    
	"IS_SUBSCRIBED_YN" VARCHAR2(1) NOT NULL                                                                                            
ENABLE,                                                                                                                             
	"AGREEMENT_DATE" DATE,                                                                                                             
	 CONSTRAINT "RNT_USER_PK" PRIMARY KEY ("USER_                                                                                      
ID")                                                                                                                                
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUT                                                                             
E STATISTICS                                                                                                                        
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENT                                                                                      
S 1 MAXEXTENTS 2147483645                                                                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_F                                                                                    
LASH_CACHE DEFAULT)                                                                                                                 
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1                                                                                   
 MAXEXTENTS 2147483645                                                                                                              
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLAS                                                                                 
H_CACHE DEFAULT)                                                                                                                    
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_USER_ASSIGNMENTS"                                                                                      
   (	"USER_ASSIGN_ID" NUMBER NOT NULL ENABLE,                                                                                       
	"ROLE_ID" NUMBER NOT NULL ENABLE,                                                                                                  
	"USER_ID" NUMBER NOT NULL ENABLE,                                                                                                  
	"BUSINESS_ID" NUMBER NOT NULL ENABLE,                                                                                              
	 CONSTRAINT "RNT_USER_ASSIGNMENTS_PK" PRIMARY KEY (                                                                                
"USER_ASSIGN_ID")                                                                                                                   
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRA                                                                                          
NS 255 COMPUTE STATISTICS                                                                                                           
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAX                                                                               
EXTENTS 2147483645                                                                                                                  
  PCTINCREASE 0 FREELISTS 1 FREELIST GROU                                                                                           
PS 1                                                                                                                                
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CA                                                                             
CHE DEFAULT)                                                                                                                        
  TABLESPACE "USERS"  ENABLE,                                                                                                       
	 CONSTRAINT "RNT_USER_ASSIGNMENTS_FK3" FOREIGN KEY ("BU                                                                            
SINESS_ID")                                                                                                                         
	  REFERENCES "RNTMGR"."RNT_BUSINESS_UNITS" ("BU                                                                                    
SINESS_ID") ENABLE,                                                                                                                 
	 CONSTRAINT "RNT_USER_ASSIGNMENTS_FK2" FOREIGN KEY ("ROLE_                                                                         
ID")                                                                                                                                
	  REFERENCES "RNTMGR"."RNT_USER_ROLES" ("ROLE_ID") ENA                                                                             
BLE,                                                                                                                                
	 CONSTRAINT "RNT_USER_ASSIGNMENTS_FK1" FOREIGN KEY ("                                                                              
USER_ID")                                                                                                                           
	  REFERENCES "RNTMGR"."RNT_USERS" ("USER_ID") ENA                                                                                  
BLE                                                                                                                                 
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS                                                                                         
 255                                                                                                                                
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXE                                                                              
XTENTS 2147483645                                                                                                                   
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUP                                                                                          
S 1                                                                                                                                 
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CAC                                                                            
HE DEFAULT)                                                                                                                         
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_USER_REGISTRY"                                                                                         
   (	"USER_REGISTRY_ID" NUMBER NOT NULL ENABLE,                                                                                     
	"USER_LOGIN_EMAIL" VARCHAR2(50) NOT NULL ENA                                                                                       
BLE,                                                                                                                                
	"USER_PASSWORD" VARCHAR2(64) NOT NULL ENABLE,                                                                                      
	"USER_HASH_VALUE" VARCHAR2(64) NOT NULL ENABL                                                                                      
E,                                                                                                                                  
	"USER_NAME" VARCHAR2(50) NOT NULL ENABLE,                                                                                          
	"USER_LAST_NAME" VARCHAR2(50) NOT NULL ENABLE,                                                                                     
	"INVITE_USER_ID" NUMBER,                                                                                                           
	"LAST_UPDATE_DATE" DATE,                                                                                                           
	"TELEPHONE" VARCHAR2(30),                                                                                                          
	 CONSTRAINT "RNT_USER_REGISTRY_PK" PRIMA                                                                                           
RY KEY ("USER_REGISTRY_ID")                                                                                                         
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COM                                                                                
PUTE STATISTICS                                                                                                                     
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXT                                                                                         
ENTS 1 MAXEXTENTS 2147483645                                                                                                        
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CEL                                                                                       
L_FLASH_CACHE DEFAULT)                                                                                                              
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENT                                                                                      
S 1 MAXEXTENTS 2147483645                                                                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_F                                                                                    
LASH_CACHE DEFAULT)                                                                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_USER_ROLES"                                                                                            
   (	"ROLE_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"ROLE_CODE" VARCHAR2(20) NOT NULL ENABLE,                                                                                          
	"ROLE_NAME" VARCHAR2(30) NOT NULL ENABLE,                                                                                          
	 CONSTRAINT "RNT_USER_ROLES_PK" PRIMARY KEY ("RO                                                                                   
LE_ID")                                                                                                                             
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COM                                                                                
PUTE STATISTICS                                                                                                                     
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXT                                                                                         
ENTS 1 MAXEXTENTS 2147483645                                                                                                        
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CEL                                                                                       
L_FLASH_CACHE DEFAULT)                                                                                                              
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENT                                                                                      
S 1 MAXEXTENTS 2147483645                                                                                                           
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_F                                                                                    
LASH_CACHE DEFAULT)                                                                                                                 
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."RNT_ZIPCODES"                                                                                              
   (	"ZIPCODE" NUMBER(5,0) NOT NULL ENABLE,                                                                                         
	"PLACE_NAME" VARCHAR2(180),                                                                                                        
	"STATE_NAME" VARCHAR2(100),                                                                                                        
	"STATE_CODE" VARCHAR2(20),                                                                                                         
	"COUNTY" VARCHAR2(100),                                                                                                            
	"GEO_LOCATION" "SDO_GEOMETRY",                                                                                                     
	 CONSTRAINT "RNT_ZIPCODES_PK" PRIMARY KEY ("Z                                                                                      
IPCODE")                                                                                                                            
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 CO                                                                                 
MPUTE STATISTICS                                                                                                                    
  STORAGE(INITIAL 2097152 NEXT 1048576 MIN                                                                                          
EXTENTS 1 MAXEXTENTS 2147483645                                                                                                     
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
CELL_FLASH_CACHE DEFAULT)                                                                                                           
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 3145728 NEXT 1048576 MINE                                                                                         
XTENTS 1 MAXEXTENTS 2147483645                                                                                                      
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT C                                                                                         
ELL_FLASH_CACHE DEFAULT)                                                                                                            
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."SUNBIZ"                                                                                                    
   (	"COR_NUMBER" VARCHAR2(12),                                                                                                     
	"COR_NAME" VARCHAR2(192),                                                                                                          
	"COR_STATUS" VARCHAR2(1),                                                                                                          
	"COR_FILING_TYPE" VARCHAR2(15),                                                                                                    
	"COR_PRINC_ADD_1" VARCHAR2(42),                                                                                                    
	"COR_PRINC_ADD_2" VARCHAR2(42),                                                                                                    
	"COR_PRINC_CITY" VARCHAR2(28),                                                                                                     
	"COR_PRINC_STATE" VARCHAR2(2),                                                                                                     
	"BCOR_PRINC_ZIP" VARCHAR2(10),                                                                                                     
	"COR_PRINC_COUNTRY" VARCHAR2(2),                                                                                                   
	"COR_MAIL_ADD_1" VARCHAR2(42),                                                                                                     
	"COR_MAIL_ADD_2" VARCHAR2(42),                                                                                                     
	"COR_MAIL_CITY" VARCHAR2(28),                                                                                                      
	"COR_MAIL_STATE" VARCHAR2(2),                                                                                                      
	"COR_MAIL_ZIP" VARCHAR2(10),                                                                                                       
	"COR_MAIL_COUNTRY" VARCHAR2(2),                                                                                                    
	"COR_FILE_DATE" VARCHAR2(8),                                                                                                       
	"COR_FEI_NUMBER" VARCHAR2(14),                                                                                                     
	"MORE_THAN_SIX_OFF_FLAG" VARCHAR2(1),                                                                                              
	"LAST_TRX_DATE" VARCHAR2(8),                                                                                                       
	"STATE_COUNTRY" VARCHAR2(2),                                                                                                       
	"REPORT_YEAR_1" VARCHAR2(4),                                                                                                       
	"HOUSE_FLAG_1" VARCHAR2(1),                                                                                                        
	"REPORT_DATE_1" VARCHAR2(8),                                                                                                       
	"REPORT_YEAR_2" VARCHAR2(4),                                                                                                       
	"HOUSE_FLAG_2" VARCHAR2(1),                                                                                                        
	"REPORT_DATE_2" VARCHAR2(8),                                                                                                       
	"REPORT_YEAR_3" VARCHAR2(4),                                                                                                       
	"HOUSE_FLAG_3" VARCHAR2(1),                                                                                                        
	"REPORT_DATE_3" VARCHAR2(8),                                                                                                       
	"RA_NAME" VARCHAR2(42),                                                                                                            
	"RA_NAME_TYPE" VARCHAR2(1),                                                                                                        
	"RA_ADD_1" VARCHAR2(42),                                                                                                           
	"RA_CITY" VARCHAR2(28),                                                                                                            
	"RA_STATE" VARCHAR2(2),                                                                                                            
	"RA_ZIP5" VARCHAR2(5),                                                                                                             
	"RA_ZIP4" VARCHAR2(4),                                                                                                             
	"PRINC1_TITLE" VARCHAR2(4),                                                                                                        
	"PRINC1_NAME_TYPE" VARCHAR2(1),                                                                                                    
	"PRINC1_NAME" VARCHAR2(42),                                                                                                        
	"PRINC1_ADD_1" VARCHAR2(42),                                                                                                       
	"PRINC1_CITY" VARCHAR2(28),                                                                                                        
	"PRINC1_STATE" VARCHAR2(2),                                                                                                        
	"PRINC1_ZIP5" VARCHAR2(5),                                                                                                         
	"PRINC1_ZIP4" VARCHAR2(4),                                                                                                         
	"PRINC2_TITLE" VARCHAR2(4),                                                                                                        
	"PRINC2_NAME_TYPE" VARCHAR2(1),                                                                                                    
	"PRINC2_NAME" VARCHAR2(42),                                                                                                        
	"PRINC2_ADD_1" VARCHAR2(42),                                                                                                       
	"PRINC2_CITY" VARCHAR2(28),                                                                                                        
	"PRINC2_STATE" VARCHAR2(2),                                                                                                        
	"PRINC2_ZIP5" VARCHAR2(5),                                                                                                         
	"PRINC2_ZIP4" VARCHAR2(4),                                                                                                         
	"PRINC3_TITLE" VARCHAR2(4),                                                                                                        
	"PRINC3_NAME_TYPE" VARCHAR2(1),                                                                                                    
	"PRINC3_NAME" VARCHAR2(42),                                                                                                        
	"PRINC3_ADD_1" VARCHAR2(42),                                                                                                       
	"PRINC3_CITY" VARCHAR2(28),                                                                                                        
	"PRINC3_STATE" VARCHAR2(2),                                                                                                        
	"PRINC3_ZIP5" VARCHAR2(5),                                                                                                         
	"PRINC3_ZIP4" VARCHAR2(4),                                                                                                         
	"PRINC4_TITLE" VARCHAR2(4),                                                                                                        
	"PRINC4_NAME_TYPE" VARCHAR2(1),                                                                                                    
	"PRINC4_NAME" VARCHAR2(42),                                                                                                        
	"PRINC4_ADD_1" VARCHAR2(42),                                                                                                       
	"PRINC4_CITY" VARCHAR2(28),                                                                                                        
	"PRINC4_STATE" VARCHAR2(2),                                                                                                        
	"PRINC4_ZIP5" VARCHAR2(5),                                                                                                         
	"PRINC4_ZIP4" VARCHAR2(4),                                                                                                         
	"PRINC5_TITLE" VARCHAR2(4),                                                                                                        
	"PRINC5_NAME_TYPE" VARCHAR2(1),                                                                                                    
	"PRINC5_NAME" VARCHAR2(42),                                                                                                        
	"PRINC5_ADD_1" VARCHAR2(42),                                                                                                       
	"PRINC5_CITY" VARCHAR2(28),                                                                                                        
	"PRINC5_STATE" VARCHAR2(2),                                                                                                        
	"PRINC5_ZIP5" VARCHAR2(5),                                                                                                         
	"PRINC5_ZIP4" VARCHAR2(4),                                                                                                         
	"PRINC6_TITLE" VARCHAR2(4),                                                                                                        
	"PRINC6_NAME_TYPE" VARCHAR2(1),                                                                                                    
	"PRINC6_NAME" VARCHAR2(42),                                                                                                        
	"PRINC6_ADD_1" VARCHAR2(42),                                                                                                       
	"PRINC6_CITY" VARCHAR2(28),                                                                                                        
	"PRINC6_STATE" VARCHAR2(2),                                                                                                        
	"PRINC6_ZIP5" VARCHAR2(5),                                                                                                         
	"PRINC6_ZIP4" VARCHAR2(4)                                                                                                          
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 67108864 NEXT 1048576                                                                                             
MINEXTENTS 1 MAXEXTENTS 2147483645                                                                                                  
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
                                                                                                                                    
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
DEFAULT)                                                                                                                            
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."ZIPCODE_DATA"                                                                                              
   (	"PROPERTY_ID" NUMBER NOT NULL ENABLE,                                                                                          
	"ZIPCODE" NUMBER NOT NULL ENABLE                                                                                                   
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
                                                                                                                                    
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENT                                                                         
S 2147483645                                                                                                                        
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
 CELL_FLASH_CACHE DEFAULT)                                                                                                          
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."ZIP_COORDS"                                                                                                
   (	"ZIPCODE" VARCHAR2(20),                                                                                                        
	"PLACE_NAME" VARCHAR2(180),                                                                                                        
	"STATE_NAME" VARCHAR2(100),                                                                                                        
	"STATE_CODE" VARCHAR2(20),                                                                                                         
	"COUNTY" VARCHAR2(100),                                                                                                            
	"LATITUDE" NUMBER,                                                                                                                 
	"LONGITUDE" NUMBER                                                                                                                 
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRAN                                                                                          
S 255                                                                                                                               
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 1048576 NEXT 1048576 MINEXTENTS 1 M                                                                               
AXEXTENTS 2147483645                                                                                                                
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_                                                                               
CACHE DEFAULT)                                                                                                                      
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."DR$PR_OWNER_X1$I"                                                                                          
   (	"DR$TOKEN" VARCHAR2(64) NOT NULL ENABLE,                                                                                       
	"DR$TOKEN_TYPE" NUMBER(10,0) NOT NULL ENABLE,                                                                                      
	"DR$ROWID" ROWID NOT NULL ENABLE,                                                                                                  
	"DR$TOKEN_INFO" RAW(2000) NOT NULL ENABLE                                                                                          
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
                                                                                                                                    
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENT                                                                         
S 2147483645                                                                                                                        
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
 CELL_FLASH_CACHE DEFAULT)                                                                                                          
  TABLESPACE "USERS"                                                                                                                
  MONITORING ;                                                                                                                      
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."DR$PR_PROPERTIES_X1$I"                                                                                     
   (	"DR$TOKEN" VARCHAR2(64) NOT NULL ENABLE,                                                                                       
	"DR$TOKEN_TYPE" NUMBER(10,0) NOT NULL ENAB                                                                                         
LE,                                                                                                                                 
	"DR$ROWID" ROWID NOT NULL ENABLE,                                                                                                  
	"DR$TOKEN_INFO" RAW(2000) NOT NULL ENABLE,                                                                                         
	"CITY" VARCHAR2(30) NOT NULL ENABLE                                                                                                
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS                                                                                         
255                                                                                                                                 
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEX                                                                             
TENTS 2147483645                                                                                                                    
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
 1                                                                                                                                  
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACH                                                                           
E DEFAULT)                                                                                                                          
  TABLESPACE "USERS"                                                                                                                
  MONITORING ;                                                                                                                      
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."MDRT_12992$"                                                                                               
   (	"NODE_ID" NUMBER,                                                                                                              
	"NODE_LEVEL" NUMBER,                                                                                                               
	"INFO" BLOB                                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 2 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                      
                                                                                                                                    
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENT                                                                         
S 2147483645                                                                                                                        
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
 CELL_FLASH_CACHE DEFAULT)                                                                                                          
  TABLESPACE "USERS"                                                                                                                
 LOB ("INFO") STORE AS BASICFILE (                                                                                                  
  TABLESPACE "USERS" ENABLE STORAGE IN ROW CHUNK 8192 RE                                                                            
TENTION                                                                                                                             
  NOCACHE LOGGING                                                                                                                   
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MA                                                                                
XEXTENTS 2147483645                                                                                                                 
  PCTINCREASE 0 FREELISTS 1 FREELIST GRO                                                                                            
UPS 1                                                                                                                               
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_C                                                                              
ACHE DEFAULT))                                                                                                                      
  MONITORING ;                                                                                                                      
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."MDRT_1299E$"                                                                                               
   (	"NODE_ID" NUMBER,                                                                                                              
	"NODE_LEVEL" NUMBER,                                                                                                               
	"INFO" BLOB                                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 2 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                      
                                                                                                                                    
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENT                                                                         
S 2147483645                                                                                                                        
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
 CELL_FLASH_CACHE DEFAULT)                                                                                                          
  TABLESPACE "USERS"                                                                                                                
 LOB ("INFO") STORE AS BASICFILE (                                                                                                  
  TABLESPACE "USERS" ENABLE STORAGE IN ROW CHUNK 8192 RE                                                                            
TENTION                                                                                                                             
  NOCACHE LOGGING                                                                                                                   
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MA                                                                                
XEXTENTS 2147483645                                                                                                                 
  PCTINCREASE 0 FREELISTS 1 FREELIST GRO                                                                                            
UPS 1                                                                                                                               
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_C                                                                              
ACHE DEFAULT))                                                                                                                      
  MONITORING ;                                                                                                                      
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_NAL"                                                                                                    
   (	"CO_NO" VARCHAR2(2),                                                                                                           
	"PARCEL_ID" VARCHAR2(26),                                                                                                          
	"FILE_T" VARCHAR2(1),                                                                                                              
	"ASMNT_YR" VARCHAR2(4),                                                                                                            
	"BAS_STRT" VARCHAR2(2),                                                                                                            
	"ATV_STRT" NUMBER(1,0),                                                                                                            
	"GRP_NO" NUMBER(1,0),                                                                                                              
	"DOR_UC" VARCHAR2(3),                                                                                                              
	"PA_UC" VARCHAR2(2),                                                                                                               
	"SPASS_CD" VARCHAR2(1),                                                                                                            
	"JV" VARCHAR2(12),                                                                                                                 
	"JV_CHNG" VARCHAR2(12),                                                                                                            
	"JV_CHNG_CD" VARCHAR2(2),                                                                                                          
	"AV_SD" VARCHAR2(12),                                                                                                              
	"AV_NSD" VARCHAR2(12),                                                                                                             
	"TV_SD" VARCHAR2(12),                                                                                                              
	"TV_NSD" VARCHAR2(12),                                                                                                             
	"JV_HMSTD" VARCHAR2(12),                                                                                                           
	"AV_HMSTD" VARCHAR2(12),                                                                                                           
	"JV_NON_HMSTD_RESD" VARCHAR2(12),                                                                                                  
	"AV_NON_HMSTD_RESD" VARCHAR2(12),                                                                                                  
	"JV_RESD_NON_RESD" VARCHAR2(12),                                                                                                   
	"AV_RESD_NON_RESD" VARCHAR2(12),                                                                                                   
	"JV_CLASS_USE" VARCHAR2(12),                                                                                                       
	"AV_CLASS_USE" VARCHAR2(12),                                                                                                       
	"JV_H2O_RECHRGE" VARCHAR2(12),                                                                                                     
	"AV_H2O_RECHRGE" VARCHAR2(12),                                                                                                     
	"JV_CONSRV_LND" VARCHAR2(12),                                                                                                      
	"AV_CONSRV_LND" VARCHAR2(12),                                                                                                      
	"JV_HIST_COM_PROP" VARCHAR2(12),                                                                                                   
	"AV_HIST_COM_PROP" VARCHAR2(12),                                                                                                   
	"JV_HIST_SIGNF" VARCHAR2(12),                                                                                                      
	"AV_HIST_SIGNF" VARCHAR2(12),                                                                                                      
	"JV_WRKNG_WTRFNT" VARCHAR2(12),                                                                                                    
	"AV_WRKNG_WTRFNT" VARCHAR2(12),                                                                                                    
	"NCONST_VAL" VARCHAR2(12),                                                                                                         
	"DEL_VAL" VARCHAR2(12),                                                                                                            
	"PAR_SPLT" VARCHAR2(5),                                                                                                            
	"DISTR_CD" VARCHAR2(12),                                                                                                           
	"DISTR_YR" NUMBER(4,0),                                                                                                            
	"LND_VAL" VARCHAR2(12),                                                                                                            
	"LND_UNTS_CD" NUMBER(1,0),                                                                                                         
	"NO_LND_UNTS" VARCHAR2(12),                                                                                                        
	"LND_SQFOOT" VARCHAR2(12),                                                                                                         
	"DT_LAST_INSPT" NUMBER(4,0),                                                                                                       
	"IMP_QUAL" NUMBER(1,0),                                                                                                            
	"CONST_CLASS" NUMBER(1,0),                                                                                                         
	"EFF_YR_BLT" NUMBER(4,0),                                                                                                          
	"ACT_YR_BLT" NUMBER(4,0),                                                                                                          
	"TOT_LVG_AREA" VARCHAR2(12),                                                                                                       
	"NO_BULDNG" VARCHAR2(4),                                                                                                           
	"NO_RES_UNTS" VARCHAR2(4),                                                                                                         
	"SPEC_FEAT_VAL" VARCHAR2(12),                                                                                                      
	"MULTI_PAR_SAL1" VARCHAR2(1),                                                                                                      
	"QUAL_CD1" VARCHAR2(2),                                                                                                            
	"VI_CD1" VARCHAR2(1),                                                                                                              
	"SALE_PRC1" VARCHAR2(12),                                                                                                          
	"SALE_YR1" NUMBER(4,0),                                                                                                            
	"SALE_MO1" VARCHAR2(2),                                                                                                            
	"OR_BOOK1" VARCHAR2(6),                                                                                                            
	"OR_PAGE1" VARCHAR2(6),                                                                                                            
	"CLERK_NO1" VARCHAR2(20),                                                                                                          
	"SAL_CHNG_CD1" NUMBER(1,0),                                                                                                        
	"MULTI_PAR_SAL2" VARCHAR2(1),                                                                                                      
	"QUAL_CD2" VARCHAR2(2),                                                                                                            
	"VI_CD2" VARCHAR2(1),                                                                                                              
	"SALE_PRC2" VARCHAR2(12),                                                                                                          
	"SALE_YR2" VARCHAR2(4),                                                                                                            
	"SALE_MO2" VARCHAR2(2),                                                                                                            
	"OR_BOOK2" VARCHAR2(6),                                                                                                            
	"OR_PAGE2" VARCHAR2(6),                                                                                                            
	"CLERK_NO2" VARCHAR2(20),                                                                                                          
	"SAL_CHNG_CD2" NUMBER(1,0),                                                                                                        
	"OWN_NAME" VARCHAR2(30),                                                                                                           
	"OWN_ADDR1" VARCHAR2(40),                                                                                                          
	"OWN_ADDR2" VARCHAR2(40),                                                                                                          
	"OWN_CITY" VARCHAR2(40),                                                                                                           
	"OWN_STATE" VARCHAR2(25),                                                                                                          
	"OWN_ZIPCD" VARCHAR2(5),                                                                                                           
	"OWN_STATE_DOM" VARCHAR2(2),                                                                                                       
	"FIDU_NAME" VARCHAR2(30),                                                                                                          
	"FIDU_ADDR1" VARCHAR2(40),                                                                                                         
	"FIDU_ADDR2" VARCHAR2(40),                                                                                                         
	"FIDU_CITY" VARCHAR2(40),                                                                                                          
	"FIDU_STATE" VARCHAR2(25),                                                                                                         
	"FIDU_ZIPCD" VARCHAR2(5),                                                                                                          
	"FIDU_CD" NUMBER(1,0),                                                                                                             
	"S_LEGAL" VARCHAR2(30),                                                                                                            
	"APP_STAT" VARCHAR2(1),                                                                                                            
	"CO_APP_STAT" VARCHAR2(1),                                                                                                         
	"MKT_AR" VARCHAR2(3),                                                                                                              
	"NBRHD_CD" VARCHAR2(10),                                                                                                           
	"PUBLIC_LND" VARCHAR2(1),                                                                                                          
	"TAX_AUTH_CD" VARCHAR2(5),                                                                                                         
	"TWN" VARCHAR2(3),                                                                                                                 
	"RNG" VARCHAR2(3),                                                                                                                 
	"SEC" VARCHAR2(3),                                                                                                                 
	"CENSUS_BK" VARCHAR2(16),                                                                                                          
	"PHY_ADDR1" VARCHAR2(40),                                                                                                          
	"PHY_ADDR2" VARCHAR2(40),                                                                                                          
	"PHY_CITY" VARCHAR2(40),                                                                                                           
	"PHY_ZIPCD" VARCHAR2(5),                                                                                                           
	"ALT_KEY" VARCHAR2(26),                                                                                                            
	"ASS_TRNSFR_FG" VARCHAR2(1),                                                                                                       
	"PREV_HMSTD_OWN" VARCHAR2(2),                                                                                                      
	"ASS_DIF_TRNS" VARCHAR2(12),                                                                                                       
	"CONO_PRV_HM" VARCHAR2(2),                                                                                                         
	"PARCEL_ID_PRV_HMSTD" VARCHAR2(26),                                                                                                
	"YR_VAL_TRNSF" VARCHAR2(4),                                                                                                        
	"EXMPT_01" VARCHAR2(12),                                                                                                           
	"EXMPT_02" VARCHAR2(12),                                                                                                           
	"EXMPT_03" VARCHAR2(12),                                                                                                           
	"EXMPT_04" VARCHAR2(12),                                                                                                           
	"EXMPT_05" VARCHAR2(12),                                                                                                           
	"EXMPT_06" VARCHAR2(12),                                                                                                           
	"EXMPT_07" VARCHAR2(12),                                                                                                           
	"EXMPT_08" VARCHAR2(12),                                                                                                           
	"EXMPT_09" VARCHAR2(12),                                                                                                           
	"EXMPT_10" VARCHAR2(12),                                                                                                           
	"EXMPT_11" VARCHAR2(12),                                                                                                           
	"EXMPT_12" VARCHAR2(12),                                                                                                           
	"EXMPT_13" VARCHAR2(12),                                                                                                           
	"EXMPT_14" VARCHAR2(12),                                                                                                           
	"EXMPT_15" VARCHAR2(12),                                                                                                           
	"EXMPT_16" VARCHAR2(12),                                                                                                           
	"EXMPT_17" VARCHAR2(12),                                                                                                           
	"EXMPT_18" VARCHAR2(12),                                                                                                           
	"EXMPT_19" VARCHAR2(12),                                                                                                           
	"EXMPT_20" VARCHAR2(12),                                                                                                           
	"EXMPT_21" VARCHAR2(12),                                                                                                           
	"EXMPT_22" VARCHAR2(12),                                                                                                           
	"EXMPT_23" VARCHAR2(12),                                                                                                           
	"EXMPT_24" VARCHAR2(12),                                                                                                           
	"EXMPT_25" VARCHAR2(12),                                                                                                           
	"EXMPT_26" VARCHAR2(12),                                                                                                           
	"EXMPT_27" VARCHAR2(12),                                                                                                           
	"EXMPT_28" VARCHAR2(12),                                                                                                           
	"EXMPT_29" VARCHAR2(12),                                                                                                           
	"EXMPT_30" VARCHAR2(12),                                                                                                           
	"EXMPT_31" VARCHAR2(12),                                                                                                           
	"EXMPT_32" VARCHAR2(12),                                                                                                           
	"EXMPT_33" VARCHAR2(12),                                                                                                           
	"EXMPT_34" VARCHAR2(12),                                                                                                           
	"EXMPT_35" VARCHAR2(12),                                                                                                           
	"EXMPT_36" VARCHAR2(12),                                                                                                           
	"EXMPT_37" VARCHAR2(12),                                                                                                           
	"EXMPT_38" VARCHAR2(12),                                                                                                           
	"EXMPT_80" VARCHAR2(12),                                                                                                           
	"EXMPT_81" VARCHAR2(12),                                                                                                           
	"SEQ_NO" VARCHAR2(7),                                                                                                              
	"RS_ID" VARCHAR2(4),                                                                                                               
	"MP_ID" VARCHAR2(8),                                                                                                               
	"STATE_PAR_ID" VARCHAR2(18),                                                                                                       
	"SPC_CIR_CD" VARCHAR2(1),                                                                                                          
	"SPC_CIR_YR" VARCHAR2(4),                                                                                                          
	"SPC_CIR_TXT" VARCHAR2(50)                                                                                                         
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1                                                                                   
 MAXEXTENTS 2147483645                                                                                                              
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLAS                                                                                 
H_CACHE DEFAULT)                                                                                                                    
  TABLESPACE "PR_LOADER" ;                                                                                                          
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_SDF"                                                                                                    
   (	"CO_NO" VARCHAR2(2),                                                                                                           
	"PARCEL_ID" VARCHAR2(26),                                                                                                          
	"ASMNT_YR" NUMBER(4,0),                                                                                                            
	"ATV_STRT" NUMBER(1,0),                                                                                                            
	"GRP_NO" NUMBER(1,0),                                                                                                              
	"DOR_UC" VARCHAR2(5),                                                                                                              
	"NBRHD_CD" VARCHAR2(10),                                                                                                           
	"MKT_AR" VARCHAR2(5),                                                                                                              
	"CENSUS_BK" VARCHAR2(16),                                                                                                          
	"SALE_ID_CD" VARCHAR2(25),                                                                                                         
	"SAL_CHG_CD" VARCHAR2(1),                                                                                                          
	"VI_CD" VARCHAR2(1),                                                                                                               
	"OR_BOOK" VARCHAR2(6),                                                                                                             
	"OR_PAGE" VARCHAR2(6),                                                                                                             
	"CLERK_NO" VARCHAR2(20),                                                                                                           
	"QUAL_CD" VARCHAR2(2),                                                                                                             
	"SALE_YR" NUMBER(4,0),                                                                                                             
	"SALE_MO" NUMBER(2,0),                                                                                                             
	"SALE_PRC" NUMBER(12,0),                                                                                                           
	"MULTI_PAR_SAL" VARCHAR2(1),                                                                                                       
	"RS_ID" VARCHAR2(4),                                                                                                               
	"MP_ID" VARCHAR2(8),                                                                                                               
	"STATE_PARCEL_ID" VARCHAR2(18)                                                                                                     
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINE                                                                                           
XTENTS 1 MAXEXTENTS 2147483645                                                                                                      
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT C                                                                                         
ELL_FLASH_CACHE DEFAULT)                                                                                                            
  TABLESPACE "PR_LOADER" ;                                                                                                          
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_GEO"                                                                                                    
   (	"ID" NUMBER(38,0),                                                                                                             
	"PARCELNO" VARCHAR2(40),                                                                                                           
	"GEOM" "MDSYS"."SDO_GEOMETRY" ,                                                                                                    
	"GEOM_POINT" "MDSYS"."SDO_GEOMETRY" ,                                                                                              
	 PRIMARY KEY ("ID")                                                                                                                
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE S                                                                          
TATISTICS                                                                                                                           
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1                                                                                   
 MAXEXTENTS 2147483645                                                                                                              
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLAS                                                                                 
H_CACHE DEFAULT)                                                                                                                    
  TABLESPACE "PR_LOADER"  ENABLE                                                                                                    
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS                                                                                     
1 MAXEXTENTS 2147483645                                                                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLA                                                                                  
SH_CACHE DEFAULT)                                                                                                                   
  TABLESPACE "PR_LOADER" ;                                                                                                          
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_FMR"                                                                                                    
   (	"FIPS" VARCHAR2(16),                                                                                                           
	"RENT0" NUMBER,                                                                                                                    
	"RENT1" NUMBER,                                                                                                                    
	"RENT2" NUMBER,                                                                                                                    
	"RENT3" NUMBER,                                                                                                                    
	"RENT4" NUMBER,                                                                                                                    
	"COUNTY" NUMBER,                                                                                                                   
	"STATE" NUMBER,                                                                                                                    
	"COUSUB" VARCHAR2(16),                                                                                                             
	"POP2000" NUMBER,                                                                                                                  
	"COUNTYNAME" VARCHAR2(128),                                                                                                        
	"CBSASUB" VARCHAR2(128),                                                                                                           
	"AREANAME" VARCHAR2(128),                                                                                                          
	"COUNTY_TOWN_NAME" VARCHAR2(128),                                                                                                  
	"STATE_ALPHA" VARCHAR2(4)                                                                                                          
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 2                                                                                       
55                                                                                                                                  
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXT                                                                            
ENTS 2147483645                                                                                                                     
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
1                                                                                                                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE                                                                          
 DEFAULT)                                                                                                                           
  TABLESPACE "PR_LOADER" ;                                                                                                          
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_MILLAGE_RATES"                                                                                          
   (	"ID" NUMBER NOT NULL ENABLE,                                                                                                   
	"YEAR" NUMBER NOT NULL ENABLE,                                                                                                     
	"COUNTY" VARCHAR2(64),                                                                                                             
	"MILLAGE" NUMBER NOT NULL ENABLE,                                                                                                  
	"RENT_RATE" NUMBER,                                                                                                                
	 CONSTRAINT "PR_MILLAGE_RATES_PK" PRIMARY K                                                                                        
EY ("ID", "YEAR")                                                                                                                   
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRA                                                                                          
NS 255 COMPUTE STATISTICS                                                                                                           
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAX                                                                               
EXTENTS 2147483645                                                                                                                  
  PCTINCREASE 0 FREELISTS 1 FREELIST GROU                                                                                           
PS 1                                                                                                                                
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CA                                                                             
CHE DEFAULT)                                                                                                                        
  TABLESPACE "PR_LOADER"  ENABLE                                                                                                    
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRA                                                                                           
NS 255                                                                                                                              
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MA                                                                                
XEXTENTS 2147483645                                                                                                                 
  PCTINCREASE 0 FREELISTS 1 FREELIST GRO                                                                                            
UPS 1                                                                                                                               
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_C                                                                              
ACHE DEFAULT)                                                                                                                       
  TABLESPACE "PR_LOADER" ;                                                                                                          
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_VALUE_SUMMARY_MV"                                                                                       
   (	"ZIPCODE" VARCHAR2(5),                                                                                                         
	"UCODE" NUMBER,                                                                                                                    
	"SALE_YR" NUMBER(4,0),                                                                                                             
	"A_MAX" NUMBER,                                                                                                                    
	"A_MEDIAN" NUMBER,                                                                                                                 
	"A_MIN" NUMBER,                                                                                                                    
	"B_MEDIAN" NUMBER,                                                                                                                 
	"C_MAX" NUMBER,                                                                                                                    
	"C_MEDIAN" NUMBER,                                                                                                                 
	"C_MIN" NUMBER,                                                                                                                    
	"SALES_COUNT" NUMBER                                                                                                               
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINE                                                                                           
XTENTS 1 MAXEXTENTS 2147483645                                                                                                      
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT C                                                                                         
ELL_FLASH_CACHE DEFAULT)                                                                                                            
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_UCODE_SUMMARY_MV"                                                                                       
   (	"ZIPCODE" VARCHAR2(5),                                                                                                         
	"UCODE" NUMBER,                                                                                                                    
	"PROPERTY_COUNT" NUMBER,                                                                                                           
	"TOTAL_AREA" NUMBER                                                                                                                
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS                                                                                         
255                                                                                                                                 
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEX                                                                             
TENTS 2147483645                                                                                                                    
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS                                                                                         
 1                                                                                                                                  
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACH                                                                           
E DEFAULT)                                                                                                                          
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_CITY_SUMMARY_MV"                                                                                        
   (	"CITY_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"UCODE" NUMBER,                                                                                                                    
	"SALE_YR" NUMBER(4,0),                                                                                                             
	"A_MAX" NUMBER,                                                                                                                    
	"A_MEDIAN" NUMBER,                                                                                                                 
	"A_MIN" NUMBER,                                                                                                                    
	"B_MEDIAN" NUMBER,                                                                                                                 
	"C_MAX" NUMBER,                                                                                                                    
	"C_MEDIAN" NUMBER,                                                                                                                 
	"C_MIN" NUMBER,                                                                                                                    
	"SALES_COUNT" NUMBER                                                                                                               
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTR                                                                                            
ANS 255                                                                                                                             
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 M                                                                                 
AXEXTENTS 2147483645                                                                                                                
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_                                                                               
CACHE DEFAULT)                                                                                                                      
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_COUNTY_SUMMARY_MV"                                                                                      
   (	"COUNTY" VARCHAR2(25) NOT NULL ENABLE,                                                                                         
	"STATE" VARCHAR2(2) NOT NULL ENABLE,                                                                                               
	"UCODE" NUMBER,                                                                                                                    
	"SALE_YR" NUMBER(4,0),                                                                                                             
	"A_MAX" NUMBER,                                                                                                                    
	"A_MEDIAN" NUMBER,                                                                                                                 
	"A_MIN" NUMBER,                                                                                                                    
	"B_MEDIAN" NUMBER,                                                                                                                 
	"C_MAX" NUMBER,                                                                                                                    
	"C_MEDIAN" NUMBER,                                                                                                                 
	"C_MIN" NUMBER,                                                                                                                    
	"SALES_COUNT" NUMBER                                                                                                               
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTEN                                                                                       
TS 1 MAXEXTENTS 2147483645                                                                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_                                                                                     
FLASH_CACHE DEFAULT)                                                                                                                
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_PROPERTY_VALUES"                                                                                        
   (	"PROP_ID" NUMBER NOT NULL ENABLE,                                                                                              
	"PER_FOOT_RENT" NUMBER NOT NULL ENABLE,                                                                                            
	"SQ_FT" NUMBER NOT NULL ENABLE,                                                                                                    
	"VACANCY_PCT" NUMBER NOT NULL ENABLE,                                                                                              
	"MAINTENANCE" NUMBER NOT NULL ENABLE,                                                                                              
	"UTILITIES" NUMBER NOT NULL ENABLE,                                                                                                
	"PROPERTY_TAX" NUMBER NOT NULL ENABLE,                                                                                             
	"INSURANCE" NUMBER NOT NULL ENABLE,                                                                                                
	"MGT_FEES" NUMBER NOT NULL ENABLE,                                                                                                 
	"CAP_RATE" NUMBER NOT NULL ENABLE,                                                                                                 
	"MIN_VAL" NUMBER NOT NULL ENABLE,                                                                                                  
	"MAX_VAL" NUMBER NOT NULL ENABLE,                                                                                                  
	"MEDIAN_VAL" NUMBER NOT NULL ENABLE,                                                                                               
	 CONSTRAINT "PR_PROPERTY_VALUES_PK" PRIMARY KEY ("PROP                                                                             
_ID")                                                                                                                               
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPU                                                                              
TE STATISTICS                                                                                                                       
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTEN                                                                                       
TS 1 MAXEXTENTS 2147483645                                                                                                          
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_                                                                                     
FLASH_CACHE DEFAULT)                                                                                                                
  TABLESPACE "USERS"  ENABLE                                                                                                        
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS                                                                                     
1 MAXEXTENTS 2147483645                                                                                                             
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLA                                                                                  
SH_CACHE DEFAULT)                                                                                                                   
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
                                                                                                                                    
  CREATE TABLE "RNTMGR"."PR_ZIPCODE_SUMMARY_MV"                                                                                     
   (	"ZIPCODE" VARCHAR2(5),                                                                                                         
	"UCODE" NUMBER,                                                                                                                    
	"SALE_YR" NUMBER(4,0),                                                                                                             
	"A_MAX" NUMBER,                                                                                                                    
	"A_MEDIAN" NUMBER,                                                                                                                 
	"A_MIN" NUMBER,                                                                                                                    
	"B_MEDIAN" NUMBER,                                                                                                                 
	"C_MAX" NUMBER,                                                                                                                    
	"C_MEDIAN" NUMBER,                                                                                                                 
	"C_MIN" NUMBER,                                                                                                                    
	"SALES_COUNT" NUMBER                                                                                                               
   ) SEGMENT CREATION IMMEDIATE                                                                                                     
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                                                                     
                                                                                                                                    
 NOCOMPRESS LOGGING                                                                                                                 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENT                                                                         
S 2147483645                                                                                                                        
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                                                                       
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT                                                                                           
 CELL_FLASH_CACHE DEFAULT)                                                                                                          
  TABLESPACE "USERS" ;                                                                                                              
                                                                                                                                    
SQL> spool off
