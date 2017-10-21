select score(1) search_score
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
,      to_char(inc.value_amount, '$999,999,999') hh_income
,      to_char(trunc(rent.value_amount/1000), '$99,999') rent_estimate
from pr_properties p
,    pr_property_usage u
,    pr_usage_codes uc
,    (select puma, percentile, value_amount
                from pr_pums_values
                where value_type = 'HH-INCOME') inc
,    (select puma, percentile, value_amount
                from pr_pums_values
                where value_type = 'RR-RENT') rent                
where contains(address1, pr_records_pkg.standard_suffix(upper('1849 james ave')), 1) >0
and u.prop_id = p.prop_id
and u.ucode = uc.ucode
and upper(city) = upper('Miami Beach')
            and inc.puma (+) = p.puma
            and inc.percentile (+) = p.puma_percentile
and rent.puma (+) = p.puma
            and rent.percentile (+) = p.rental_percentile            
order by score(1) desc, address1, address2;
