load data
 infile census_bk_puma.csv
 truncate into table asc_bkpuma
 FIELDS TERMINATED BY ',' optionally enclosed by '"'
 TRAILING NULLCOLS
( county 
, tract  
, bg     
, state_code
, puma2k    
, state     
, cntyname  
, PUMA2kName
, pop10     
, afact )
