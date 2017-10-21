create or replace view rnt_properties_v as
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
   p.description,
   p.name,
   p.status,
   p.prop_id,
   (select count(*)
    from RNT_PROPERTY_UNITS
    where PROPERTY_ID = p.PROPERTY_ID
   ) as COUNT_UNITS,
   RNT_PROPERTIES_PKG.GET_CKECKSUM(p.PROPERTY_ID) as CHECKSUM
from RNT_PROPERTIES p,
     RNT_BUSINESS_UNITS_V u,
     RNT_LOOKUP_VALUES_V v
where p.BUSINESS_ID = u.BUSINESS_ID
  and v.LOOKUP_TYPE_CODE = 'STATES'
  and v.LOOKUP_CODE = p.STATE;
