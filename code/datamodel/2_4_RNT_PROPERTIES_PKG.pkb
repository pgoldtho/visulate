CREATE OR REPLACE PACKAGE BODY RNTMGR.RNT_PROPERTIES_PKG AS
/******************************************************************************
   NAME:       RNT_PROPERTIES_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        30.03.2007             1. Created this package body.
******************************************************************************/

function get_ckecksum(p_property_id RNT_PROPERTIES.PROPERTY_ID%TYPE) return VARCHAR2
is
begin
   for x in (select 
                 PROPERTY_ID, BUSINESS_ID, 
                 ADDRESS1, ADDRESS2, CITY, UNITS,
                 STATE, ZIPCODE, 
                 DATE_PURCHASED, PURCHASE_PRICE, LAND_VALUE, 
                 DEPRECIATION_TERM, YEAR_BUILT, BUILDING_SIZE, 
                 LOT_SIZE, DATE_SOLD, SALE_AMOUNT, 
                 NOTE_YN
              from RNT_PROPERTIES
              where PROPERTY_ID = p_property_id) loop
         RNT_SYS_CHECKSUM_REC_PKG.INIT;
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.PROPERTY_ID);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.BUSINESS_ID);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.UNITS);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.ADDRESS1);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.ADDRESS2);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.CITY); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.STATE); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.ZIPCODE); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.DATE_PURCHASED); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.PURCHASE_PRICE); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.LAND_VALUE);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.DEPRECIATION_TERM); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.YEAR_BUILT);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.BUILDING_SIZE); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.LOT_SIZE);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.DATE_SOLD);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.SALE_AMOUNT); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.NOTE_YN);
         return RNT_SYS_CHECKSUM_REC_PKG.GET_CHECKSUM;
   end loop;
   raise NO_DATA_FOUND;               
end;

procedure lock_row(X_PROPERTY_ID RNT_PROPERTIES.PROPERTY_ID%TYPE)
is
  cursor c is
    select 
      PROPERTY_ID, BUSINESS_ID, UNITS, 
      ADDRESS1, ADDRESS2, 
      CITY, STATE, ZIPCODE, 
      DATE_PURCHASED, PURCHASE_PRICE, LAND_VALUE, 
      DEPRECIATION_TERM, YEAR_BUILT, BUILDING_SIZE, 
      LOT_SIZE, DATE_SOLD, SALE_AMOUNT, 
      NOTE_YN
   from RNT_PROPERTIES
   where PROPERTY_ID = X_PROPERTY_ID
   for update of PROPERTY_ID nowait; 
begin
  open c;
  close c;
exception
  when OTHERS then
    if SQLCODE = -54 then
      RAISE_APPLICATION_ERROR(-20001, 'Cannot changed record. Record is locked.');
    end if;       
end;

function check_unique(X_PROPERTY_ID       RNT_PROPERTIES.PROPERTY_ID%TYPE, 
                      X_ADDRESS1          RNT_PROPERTIES.ADDRESS1%TYPE, 
                      X_ADDRESS2          RNT_PROPERTIES.ADDRESS2%TYPE, 
                      X_CITY              RNT_PROPERTIES.CITY%TYPE, 
                      X_STATE             RNT_PROPERTIES.STATE%TYPE, 
                      X_ZIPCODE           RNT_PROPERTIES.ZIPCODE%TYPE) return boolean
is
  x NUMBER;
begin
   select 1 
   into x
   from DUAL
   where exists (
                   select 1
                   from RNT_PROPERTIES
                   where (PROPERTY_ID != X_PROPERTY_ID or X_PROPERTY_ID is null) 
                     and ADDRESS1 = X_ADDRESS1 
                     and ADDRESS2 = X_ADDRESS2 
                     and CITY = X_CITY 
                     and STATE = X_STATE 
                     and ZIPCODE = X_ZIPCODE            
                 );
  return false;
exception
  when NO_DATA_FOUND then
     return true;                        
end;                               

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
                     X_CHECKSUM          VARCHAR2) 
is
  l_checksum varchar2(32); 
begin
   lock_row(X_PROPERTY_ID);
   
   -- validate checksum   
   l_checksum := get_ckecksum(X_PROPERTY_ID);
   if X_CHECKSUM != l_checksum then
      RAISE_APPLICATION_ERROR(-20002, 'Record was changed another user.');
      --E_ROW_CHANGED_ANOTHER_USER  
   end if;

   if not check_unique(X_PROPERTY_ID,X_ADDRESS1, X_ADDRESS2, 
                      X_CITY, X_STATE, X_ZIPCODE) then
        RAISE_APPLICATION_ERROR(-20006, 'Address of property must be unique');                      
   end if;                       
   
   update RNT_PROPERTIES
   set PROPERTY_ID       = X_PROPERTY_ID,
       BUSINESS_ID       = X_BUSINESS_ID,
       UNITS             = X_UNITS,
       ADDRESS1          = X_ADDRESS1,
       ADDRESS2          = X_ADDRESS2,
       CITY              = X_CITY,
       STATE             = X_STATE,
       ZIPCODE           = X_ZIPCODE,
       DATE_PURCHASED    = X_DATE_PURCHASED,
       PURCHASE_PRICE    = X_PURCHASE_PRICE,
       LAND_VALUE        = X_LAND_VALUE,
       DEPRECIATION_TERM = X_DEPRECIATION_TERM,
       YEAR_BUILT        = X_YEAR_BUILT,
       BUILDING_SIZE     = X_BUILDING_SIZE,
       LOT_SIZE          = X_LOT_SIZE,
       DATE_SOLD         = X_DATE_SOLD,
       SALE_AMOUNT       = X_SALE_AMOUNT,
       NOTE_YN           = X_NOTE_YN
   where  PROPERTY_ID    = X_PROPERTY_ID;
end;

function insert_row( X_BUSINESS_ID       RNT_PROPERTIES.BUSINESS_ID%TYPE,
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
       return RNT_PROPERTIES.PROPERTY_ID%TYPE                     
is
 x RNT_PROPERTIES.PROPERTY_ID%TYPE;
begin

   if not check_unique(NULL,X_ADDRESS1, X_ADDRESS2, 
                      X_CITY, X_STATE, X_ZIPCODE) then
        RAISE_APPLICATION_ERROR(-20006, 'Address of property must be unique');                      
   end if;                       

  insert into RNT_PROPERTIES (
           PROPERTY_ID, BUSINESS_ID, UNITS, 
           ADDRESS1, ADDRESS2, 
           CITY, STATE, ZIPCODE, 
           DATE_PURCHASED, PURCHASE_PRICE, LAND_VALUE, 
           DEPRECIATION_TERM, YEAR_BUILT, BUILDING_SIZE, 
           LOT_SIZE, DATE_SOLD, SALE_AMOUNT, 
           NOTE_YN) 
  values (RNT_PROPERTIES_SEQ.NEXTVAL, X_BUSINESS_ID, X_UNITS, 
   X_ADDRESS1, X_ADDRESS2, 
   X_CITY, X_STATE, X_ZIPCODE, 
   X_DATE_PURCHASED, X_PURCHASE_PRICE, X_LAND_VALUE, 
   X_DEPRECIATION_TERM, X_YEAR_BUILT, X_BUILDING_SIZE, 
   X_LOT_SIZE, X_DATE_SOLD, X_SALE_AMOUNT, 
   X_NOTE_YN)
  returning PROPERTY_ID into x;
   
  return x;
end;

END RNT_PROPERTIES_PKG; 
/

