CREATE OR REPLACE PACKAGE RNTMGR.RNT_PROPERTIES_PKG AS
/******************************************************************************
   NAME:       RNT_PROPERTIES_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        30.03.2007             1. Created this package.
******************************************************************************/
E_ROW_LOCKED EXCEPTION;
E_ROW_CHANGED_ANOTHER_USER EXCEPTION;

PRAGMA EXCEPTION_INIT (E_ROW_LOCKED, -20001);
PRAGMA EXCEPTION_INIT (E_ROW_CHANGED_ANOTHER_USER, -20002);

function get_ckecksum(p_property_id RNT_PROPERTIES.PROPERTY_ID%TYPE) return VARCHAR2;

procedure lock_row(X_PROPERTY_ID RNT_PROPERTIES.PROPERTY_ID%TYPE); 
   

procedure update_row(X_PROPERTY_ID       RNT_PROPERTIES.PROPERTY_ID%TYPE, 
                     X_BUSINESS_ID       RNT_PROPERTIES.BUSINESS_ID%TYPE,
                     X_UNITS             RNT_PROPERTIES.UNITS%TYPE,                      
                     X_ADDRESS1          RNT_PROPERTIES.ADDRESS1%TYPE, 
                     X_ADDRESS2          RNT_PROPERTIES.ADDRESS2%TYPE, 
                     X_CITY              RNT_PROPERTIES.CITY%TYPE, 
                     X_STATE             RNT_PROPERTIES.STATE%TYPE, 
                     X_ZIPCODE           RNT_PROPERTIES.ZIPCODE%TYPE, 
                     X_DATE_PURCHASED    RNT_PROPERTIES.DATE_PURCHASED%TYPE, 
                     X_PURCHASE_PRICE    RNT_PROPERTIES.PURCHASE_PRICE%TYPE, 
                     X_LAND_VALUE        RNT_PROPERTIES.LAND_VALUE%TYPE, 
                     X_DEPRECIATION_TERM RNT_PROPERTIES.DEPRECIATION_TERM%TYPE, 
                     X_YEAR_BUILT        RNT_PROPERTIES.YEAR_BUILT%TYPE, 
                     X_BUILDING_SIZE     RNT_PROPERTIES.BUILDING_SIZE%TYPE, 
                     X_LOT_SIZE          RNT_PROPERTIES.LOT_SIZE%TYPE, 
                     X_DATE_SOLD         RNT_PROPERTIES.DATE_SOLD%TYPE, 
                     X_SALE_AMOUNT       RNT_PROPERTIES.SALE_AMOUNT%TYPE, 
                     X_NOTE_YN           RNT_PROPERTIES.NOTE_YN%TYPE,
                     X_CHECKSUM VARCHAR2); 

function insert_row( 
                     X_BUSINESS_ID       RNT_PROPERTIES.BUSINESS_ID%TYPE,
                     X_UNITS             RNT_PROPERTIES.UNITS%TYPE, 
                     X_ADDRESS1          RNT_PROPERTIES.ADDRESS1%TYPE, 
                     X_ADDRESS2          RNT_PROPERTIES.ADDRESS2%TYPE, 
                     X_CITY              RNT_PROPERTIES.CITY%TYPE, 
                     X_STATE             RNT_PROPERTIES.STATE%TYPE, 
                     X_ZIPCODE           RNT_PROPERTIES.ZIPCODE%TYPE, 
                     X_DATE_PURCHASED    RNT_PROPERTIES.DATE_PURCHASED%TYPE, 
                     X_PURCHASE_PRICE    RNT_PROPERTIES.PURCHASE_PRICE%TYPE, 
                     X_LAND_VALUE        RNT_PROPERTIES.LAND_VALUE%TYPE, 
                     X_DEPRECIATION_TERM RNT_PROPERTIES.DEPRECIATION_TERM%TYPE, 
                     X_YEAR_BUILT        RNT_PROPERTIES.YEAR_BUILT%TYPE, 
                     X_BUILDING_SIZE     RNT_PROPERTIES.BUILDING_SIZE%TYPE, 
                     X_LOT_SIZE          RNT_PROPERTIES.LOT_SIZE%TYPE, 
                     X_DATE_SOLD         RNT_PROPERTIES.DATE_SOLD%TYPE, 
                     X_SALE_AMOUNT       RNT_PROPERTIES.SALE_AMOUNT%TYPE, 
                     X_NOTE_YN           RNT_PROPERTIES.NOTE_YN%TYPE)
    return RNT_PROPERTIES.PROPERTY_ID%TYPE;                      
END RNT_PROPERTIES_PKG; 
/

