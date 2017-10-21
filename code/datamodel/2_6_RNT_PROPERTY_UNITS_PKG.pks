CREATE OR REPLACE PACKAGE RNTMGR.RNT_PROPERTY_UNITS_PKG AS
/******************************************************************************
   NAME:       RNT_PROPERTY_UNITS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        04.04.2007             1. Created this package.
******************************************************************************/

function get_checksum(p_unit_id RNT_PROPERTY_UNITS.UNIT_ID%TYPE) return VARCHAR2;

procedure lock_row(X_UNIT_ID RNT_PROPERTY_UNITS.UNIT_ID%TYPE);

procedure update_row(X_UNIT_ID RNT_PROPERTY_UNITS.UNIT_ID%TYPE, 
                     X_PROPERTY_ID RNT_PROPERTY_UNITS.PROPERTY_ID%TYPE, 
                     X_UNIT_NAME RNT_PROPERTY_UNITS.UNIT_NAME%TYPE, 
                     X_UNIT_SIZE RNT_PROPERTY_UNITS.UNIT_SIZE%TYPE, 
                     X_BEDROOMS RNT_PROPERTY_UNITS.BEDROOMS%TYPE, 
                     X_BATHROOMS RNT_PROPERTY_UNITS.BATHROOMS%TYPE,
                     X_CHECKSUM VARCHAR2);

function insert_row( X_PROPERTY_ID RNT_PROPERTY_UNITS.PROPERTY_ID%TYPE, 
                     X_UNIT_NAME RNT_PROPERTY_UNITS.UNIT_NAME%TYPE, 
                     X_UNIT_SIZE RNT_PROPERTY_UNITS.UNIT_SIZE%TYPE, 
                     X_BEDROOMS RNT_PROPERTY_UNITS.BEDROOMS%TYPE, 
                     X_BATHROOMS RNT_PROPERTY_UNITS.BATHROOMS%TYPE
                    ) return RNT_PROPERTY_UNITS.UNIT_ID%TYPE;
END RNT_PROPERTY_UNITS_PKG; 
/

