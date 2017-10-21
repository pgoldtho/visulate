select property_details_rec(score(1) 
, p.PROP_ID
, p.SOURCE_ID
, p.SOURCE_PK
, p.ADDRESS1
, p.ADDRESS2
, p.CITY
, p.STATE
, p.ZIPCODE
, p.ACREAGE
, p.SQ_FT
, p.PROP_CLASS
, p.GEO_LOCATION
, p.TOTAL_BEDROOMS
, p.TOTAL_BATHROOMS
, p.GEO_FOUND_YN
, p.PARCEL_ID
, p.ALT_KEY
, p.VALUE_GROUP
, p.QUALITY_CODE
, p.YEAR_BUILT
, p.BUILDING_COUNT
, p.RESIDENTIAL_UNITS
, p.LEGAL_DESC
, p.MARKET_AREA
, p.NEIGHBORHOOD_CODE
, p.CENSUS_BK
, p.GEO_COORDINATES
, p.PUMA
, p.PUMA_PERCENTILE
, p.RENTAL_PERCENTILE
, p.HIDDEN
, u.UCODE
, uc.DESCRIPTION
, uc.PARENT_UCODE)
from pr_properties p
,    pr_property_usage u
,    pr_usage_codes uc
where contains(address1, pr_records_pkg.standard_suffix(upper('790 pine pl')), 1) >0
and u.prop_id = p.prop_id
and u.ucode = uc.ucode
and upper(city) = upper('merritt island')