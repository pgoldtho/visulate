load data
 infile tax_values_2012.csv
 truncate into table asc_tax_values
 FIELDS TERMINATED BY ',' optionally enclosed by '"'
 TRAILING NULLCOLS
(prop_id, tax_value )
