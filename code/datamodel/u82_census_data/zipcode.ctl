load data
 infile zipcode_puma.csv
 truncate into table asc_zipuma
 FIELDS TERMINATED BY ',' optionally enclosed by '"'
 TRAILING NULLCOLS
( zipcode       
, state_code    
, puma2k    
, state     
, zipname   
, puma2k_name
, longitude  
, latitude   
, total_hu   
, afact     )
