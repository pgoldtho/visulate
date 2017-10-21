alter table pr_properties add
( PARCEL_ID          VARCHAR2(26)
, alt_key            varchar2(26)
, value_group        number(1)
, quality_code       number(1)
, year_built         number(4)
, building_count     number(4)
, residential_units  number(4)
, legal_desc         varchar2(30)
, market_area        varchar2(3)
, neighborhood_code  varchar2(10)
, census_bk          varchar2(16)
, geo_coordinates    MDSYS.SDO_GEOMETRY);

alter table pr_taxes modify tax_amount null;

create table pr_property_values
 
 , val_rent           number 
 , val_sqft           number 
 , val_vacancy_pct    number 
 , val_lease_type     varchar2(8) 
 , val_maintenance    number 
 , val_utilities      number 
 , val_property_tax   number 
 , val_insurance      number 
 , val_mgt_fees       number 
 , val_cap_rate       number 
 , val_min_val        number 
 , val_max_val        number 
 , val_median_val     number 