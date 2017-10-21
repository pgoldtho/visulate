load data
 infile FY2012_FMRS_50_County.csv
 truncate into table pr_fmr
 FIELDS TERMINATED BY ',' optionally enclosed by '"'
 TRAILING NULLCOLS
 ( FIPS           
 , Rent0          
 , Rent1          
 , Rent2          
 , Rent3          
 , Rent4              
 , county             
 , State              
 , CouSub             
 , pop2000            
 , countyname         
 , CBSASub            
 , Areaname           
 , county_town_name   
 , state_alpha  
 )