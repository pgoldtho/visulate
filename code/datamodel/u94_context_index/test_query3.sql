select score(1)
,      p.prop_id
,      p.address1
,      p.address2
,      p.city
,      u.ucode
,      uc.description
,      p.sq_ft
,      p.acreage
,      p.PROP_CLASS
,      p.GEO_LOCATION
,      p.TOTAL_BEDROOMS
,      p.TOTAL_BATHROOMS
,      p.GEO_FOUND_YN   
,      p.PARCEL_ID      
,      p.ALT_KEY        
,      p.VALUE_GROUP
,      p.QUALITY_CODE   
,      p.YEAR_BUILT     
,      p.BUILDING_COUNT
,      p.RESIDENTIAL_UNITS 
,      p.LEGAL_DESC        
,      p.MARKET_AREA       
,      p.NEIGHBORHOOD_CODE 
,      p.CENSUS_BK         
,      p.PUMA          
,      p.PUMA_PERCENTILE
,      p.RENTAL_PERCENTILE
,      p.HIDDEN
from pr_properties p
,    pr_property_usage u
,    pr_usage_codes uc
where contains(address1, pr_records_pkg.standard_suffix(upper('215 Lincoln Rd')), 1) >0
and u.prop_id = p.prop_id
and u.ucode = uc.ucode
and upper(city) = upper('Miami Beach')
order by score(1) desc, address1, address2;
