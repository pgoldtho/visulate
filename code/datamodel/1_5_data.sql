SET DEFINE OFF;
Insert into RNT_BUSINESS_UNITS
   (BUSINESS_ID, NOTM, BUSINESS_NAME)
 Values
   (1, 0, 'Rental');
Insert into RNT_BUSINESS_UNITS
   (BUSINESS_ID, NOTM, BUSINESS_NAME)
 Values
   (2, 0, 'Vacation');
Insert into RNT_BUSINESS_UNITS
   (BUSINESS_ID, NOTM, BUSINESS_NAME)
 Values
   (3, 0, 'Resedential');
COMMIT;

SET DEFINE OFF;
Insert into RNTMGR.RNT_LOOKUP_TYPES
   (LOOKUP_TYPE_ID, LOOKUP_TYPE_CODE, LOOKUP_TYPE_DESCRIPTION)
 Values
   (4, 'TENANT_STATUS', 'Tenant status');
Insert into RNTMGR.RNT_LOOKUP_TYPES
   (LOOKUP_TYPE_ID, LOOKUP_TYPE_CODE, LOOKUP_TYPE_DESCRIPTION)
 Values
   (1, 'STATES', 'States of USA');
Insert into RNTMGR.RNT_LOOKUP_TYPES
   (LOOKUP_TYPE_ID, LOOKUP_TYPE_CODE, LOOKUP_TYPE_DESCRIPTION)
 Values
   (2, 'RENT_PERIOD', 'Rent period for agreements.');
Insert into RNTMGR.RNT_LOOKUP_TYPES
   (LOOKUP_TYPE_ID, LOOKUP_TYPE_CODE, LOOKUP_TYPE_DESCRIPTION)
 Values
   (3, 'FEE_TYPE', 'Fee type for agreements');
COMMIT;


SET DEFINE OFF;
Insert into RNTMGR.RNT_LOOKUP_VALUES
   (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
 Values
   (9, 'ACTIVE', 'Active', 4);
Insert into RNTMGR.RNT_LOOKUP_VALUES
   (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
 Values
   (10, 'FORMER', 'Former', 4);
Insert into RNTMGR.RNT_LOOKUP_VALUES
   (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
 Values
   (1, 'NC', 'North Carolina', 1);
Insert into RNTMGR.RNT_LOOKUP_VALUES
   (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
 Values
   (2, 'FL', 'Florida', 1);
Insert into RNTMGR.RNT_LOOKUP_VALUES
   (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
 Values
   (3, 'MONTH', 'Month', 2);
Insert into RNTMGR.RNT_LOOKUP_VALUES
   (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
 Values
   (4, 'BI-MONTH', 'Bi-Month', 2);
Insert into RNTMGR.RNT_LOOKUP_VALUES
   (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
 Values
   (5, '2WEEKS', '2-Weeks', 2);
Insert into RNTMGR.RNT_LOOKUP_VALUES
   (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
 Values
   (6, 'WEEK', 'Week', 2);
Insert into RNTMGR.RNT_LOOKUP_VALUES
   (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
 Values
   (7, 'DISCOUNT', 'Discount', 3);
Insert into RNTMGR.RNT_LOOKUP_VALUES
   (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
 Values
   (8, 'LATE_FEE', 'Late Fee', 3);
COMMIT;


SET DEFINE OFF;
Insert into RNTMGR.RNT_PROPERTIES
   (PROPERTY_ID, BUSINESS_ID, UNITS, NOTM, ADDRESS1, ADDRESS2, CITY, STATE, ZIPCODE, DATE_PURCHASED, PURCHASE_PRICE, LAND_VALUE, DEPRECIATION_TERM, YEAR_BUILT, BUILDING_SIZE, LOT_SIZE, DATE_SOLD, SALE_AMOUNT, NOTE_YN)
 Values
   (1, 3, 1, 0, '746 Bernard Street', '2line1', 'Cocoa', 'NC', 32922, TO_DATE('04/12/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 10000, 12, 276, 2004, 10, 1215, TO_DATE('12/12/2001 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 123, 'N');
Insert into RNTMGR.RNT_PROPERTIES
   (PROPERTY_ID, BUSINESS_ID, UNITS, NOTM, ADDRESS1, CITY, STATE, ZIPCODE, DATE_PURCHASED, PURCHASE_PRICE, LAND_VALUE, DEPRECIATION_TERM, YEAR_BUILT, BUILDING_SIZE, LOT_SIZE, SALE_AMOUNT, NOTE_YN)
 Values
   (2, 1, 1, 1, '1135 Pine Valley Lane', 'Odessa', 'FL', 121212, TO_DATE('10/10/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 123, 12, 35, 1960, 123, 1, 999, 'N');
Insert into RNTMGR.RNT_PROPERTIES
   (PROPERTY_ID, BUSINESS_ID, UNITS, NOTM, ADDRESS1, ADDRESS2, CITY, STATE, ZIPCODE, DATE_PURCHASED, PURCHASE_PRICE, LAND_VALUE, DEPRECIATION_TERM, YEAR_BUILT, BUILDING_SIZE, LOT_SIZE, DATE_SOLD, SALE_AMOUNT, NOTE_YN)
 Values
   (3, 3, 1, 1, '1135 Pine Valley Lane', '1231234123', 'Tex', 'NC', 2133, TO_DATE('01/01/2005 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 121.78, 120, 3112.99, 1700, 143.67, 12.98, TO_DATE('11/12/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 1234, 'N');
COMMIT;

SET DEFINE OFF;
Insert into RNTMGR.RNT_PROPERTY_UNITS
   (UNIT_ID, NOTM, PROPERTY_ID, UNIT_NAME, UNIT_SIZE, BEDROOMS, BATHROOMS)
 Values
   (2, 0, 2, 'Unit A', 100, 2, 3);
Insert into RNTMGR.RNT_PROPERTY_UNITS
   (UNIT_ID, NOTM, PROPERTY_ID, UNIT_NAME, UNIT_SIZE, BEDROOMS, BATHROOMS)
 Values
   (1, 0, 2, 'Unit B', 200, 5, 60);
Insert into RNTMGR.RNT_PROPERTY_UNITS
   (UNIT_ID, NOTM, PROPERTY_ID, UNIT_NAME, UNIT_SIZE, BEDROOMS, BATHROOMS)
 Values
   (3, 0, 1, 'Unit A', 10, 3, 7);
COMMIT;