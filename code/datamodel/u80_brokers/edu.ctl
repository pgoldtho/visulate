load data
 infile re_salesperson.csv
 truncate into table ldr_license_edu
 FIELDS TERMINATED BY ',' optionally enclosed by '"'
 TRAILING NULLCOLS
( lRank              
, Title              
, Lic                
, Name               
, Addr1              
, Addr2              
, City_state_zip     
, Lic_Expire_Date    date "mm/dd/yy"
, Course_Number      
, Course_Name        
, Course_Credit_Hours
, Course_End_Date    date "mm/dd/yy"
)