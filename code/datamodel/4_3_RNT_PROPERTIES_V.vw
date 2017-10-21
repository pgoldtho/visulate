CREATE OR REPLACE VIEW RNT_PROPERTIES_V
(PROPERTY_ID, BUSINESS_ID, BUSINESS_NAME, UNITS, ADDRESS1, 
 ADDRESS2, CITY, STATE, STATE_NAME, ZIPCODE, 
 DATE_PURCHASED, PURCHASE_PRICE, LAND_VALUE, DEPRECIATION_TERM, YEAR_BUILT, 
 BUILDING_SIZE, LOT_SIZE, DATE_SOLD, SALE_AMOUNT, NOTE_YN, 
 COUNT_UNITS, CHECKSUM)
AS 
select 
   p.PROPERTY_ID, 
   p.BUSINESS_ID,
   u.BUSINESS_NAME,
   p.UNITS,
   p.ADDRESS1, 
   p.ADDRESS2, 
   p.CITY, 
   p.STATE,
   v.LOOKUP_VALUE as STATE_NAME, 
   p.ZIPCODE, 
   p.DATE_PURCHASED, 
   p.PURCHASE_PRICE, 
   p.LAND_VALUE, 
   p.DEPRECIATION_TERM, 
   p.YEAR_BUILT, 
   p.BUILDING_SIZE, 
   p.LOT_SIZE, 
   p.DATE_SOLD, 
   p.SALE_AMOUNT, 
   p.NOTE_YN,
   (select count(*)  
    from RNT_PROPERTY_UNITS 
    where PROPERTY_ID = p.PROPERTY_ID
   ) as COUNT_UNITS,
   RNT_PROPERTIES_PKG.GET_CKECKSUM(p.PROPERTY_ID) as CHECKSUM 
from RNT_PROPERTIES p,
     RNT_BUSINESS_UNITS u,
     RNT_LOOKUP_VALUES_V v
where p.BUSINESS_ID = u.BUSINESS_ID
  and v.LOOKUP_TYPE_CODE = 'STATES'
  and v.LOOKUP_CODE = p.STATE
/


