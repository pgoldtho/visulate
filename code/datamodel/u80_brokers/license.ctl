load data
 infile REALESTATE2501LICENSE_1.csv
 infile REALESTATE2501LICENSE_2.csv
 infile REALESTATE2501LICENSE_3.csv
 infile REALESTATE2501LICENSE_4.csv
 infile REALESTATE2501LICENSE_5.csv
 infile RealEstateCorpLicense.csv
 truncate into table ldr_license
 FIELDS TERMINATED BY ',' optionally enclosed by '"'
 TRAILING NULLCOLS
( Board                  
, Licensee_Name          
, DBA_Name               
, nRank                  
, Address1               
, Address2               
, Address3               
, City                   
, State                  
, Zip                    
, County                 
, License_Number         
, Primary_Status         
, Secondary_Status       
, License_Date           
, Effective_Date         
, Expiration_Date        
, Alternate_License_Number 
, Sole_Proprietor          
, Employer                 
, Employer_License_Number  )
