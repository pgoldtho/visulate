-- 1. Update view RNT_PROPERTIES_V
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


-- 2. Update view RNT_PROPERTY_UNITS_V
create or replace view rnt_property_units_v as
select u.UNIT_ID,
       u.PROPERTY_ID,
       u.UNIT_NAME, u.UNIT_SIZE, u.BEDROOMS,
       u.BATHROOMS,
       u.description,
       RNT_PROPERTY_UNITS_PKG.GET_CHECKSUM(u.UNIT_ID) as CHECKSUM,
       p.BUSINESS_ID
from RNT_PROPERTY_UNITS u,
     RNT_PROPERTIES_V p
where p.PROPERTY_ID = u.PROPERTY_ID;


-- 3. Update view RNT_TENANCY_AGREEMENT_V
create or replace view rnt_tenancy_agreement_v as
select
   a.AGREEMENT_ID,
   a.UNIT_ID,
   a.AGREEMENT_DATE,
   a.TERM,
   a.AMOUNT,
   a.AMOUNT_PERIOD,
   a.DATE_AVAILABLE,
   a.DEPOSIT,
   a.LAST_MONTH,
   a.DISCOUNT_AMOUNT,
   a.DISCOUNT_TYPE,
   a.DISCOUNT_PERIOD,
   a.END_DATE,
   a.ad_publish_yn,
   a.ad_title,
   a.ad_contact,
   a.ad_email,
   a.ad_phone,
   u.PROPERTY_ID,
   u.UNIT_NAME,
   lv.LOOKUP_VALUE as AMOUNTH_PERIOD_NAME,
   dt.LOOKUP_VALUE as DISCOUNT_TYPE_NAME,
   RNT_TENANCY_AGREEMENT_PKG.GET_CHECKSUM(a.AGREEMENT_ID) as CHECKSUM
from RNT_TENANCY_AGREEMENT a,
     RNT_PROPERTY_UNITS_V u,
     RNT_LOOKUP_VALUES_V lv,
     (select LOOKUP_CODE, LOOKUP_VALUE from RNT_LOOKUP_VALUES_V where LOOKUP_TYPE_CODE = 'FEE_TYPE') dt
where u.UNIT_ID = a.UNIT_ID
  and lv.LOOKUP_TYPE_CODE = 'RENT_PERIOD'
  and lv.LOOKUP_CODE = a.AMOUNT_PERIOD
  and dt.LOOKUP_CODE(+) = a.DISCOUNT_TYPE;
