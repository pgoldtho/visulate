CREATE OR REPLACE PACKAGE        RNT_PROPERTIES_PKG AS
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

procedure delete_row(X_PROPERTY_ID       RNT_PROPERTIES.PROPERTY_ID%TYPE);
                          
END RNT_PROPERTIES_PKG;
/


CREATE OR REPLACE PACKAGE BODY        RNT_PROPERTIES_PKG AS
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

function get_max_unit_number(X_PROPERTY_ID       RNT_PROPERTIES.PROPERTY_ID%TYPE) return NUMBER
is
  x_max NUMBER := 0;
  x_curr NUMBER;
begin
   for x in(select UNIT_NAME from RNT_PROPERTY_UNITS where PROPERTY_ID = X_PROPERTY_ID) loop
     begin
       x_curr := to_number(x.UNIT_NAME);
     exception 
       when OTHERS then
         x_curr := 0;  
     end;
     if x_max < x_curr then 
        x_max := x_curr; 
     end if;
   end loop;
   return x_max;
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
  xl_num_units NUMBER := X_UNITS;
  x_cnt NUMBER;
  x1 NUMBER;
  x_max_unit_number NUMBER; 
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
        RAISE_APPLICATION_ERROR(-20310, 'Address of property must be unique');                      
   end if;   
   
   if not RNT_BUSINESS_UNITS_PKG.CHECK_ALLOW_FOR_ACCESS(X_BUSINESS_ID) then
       RAISE_APPLICATION_ERROR(-20311, 'You cannot update this property because not allowed business unit reference.');
   end if;                    
   
   -- validate num rows
   select count(*)
   into x_cnt
   from RNT_PROPERTY_UNITS
   where PROPERTY_ID = X_PROPERTY_ID;
   
   if X_UNITS - x_cnt < 0 then
        RAISE_APPLICATION_ERROR(-20312, 'Value Units must be great then quantity of units in property.');   
   end if; 
   
   if x_cnt = 0 and X_UNITS = 1 then
     -- append single unit  
     x1 := RNT_PROPERTY_UNITS_PKG.INSERT_ROW(X_PROPERTY_ID => X_PROPERTY_ID, 
                                             X_UNIT_NAME => 'Single Unit', 
                                             X_UNIT_SIZE => X_BUILDING_SIZE, 
                                             X_BEDROOMS => NULL, 
                                             X_BATHROOMS => NULL);
 
/*   
   elsif x_cnt < X_UNITS then
      x_max_unit_number := get_max_unit_number(X_PROPERTY_ID);
      x_max_unit_number :=x_max_unit_number + 1;       
      for i in x_cnt+1..X_UNITS loop
           x1 := RNT_PROPERTY_UNITS_PKG.INSERT_ROW(X_PROPERTY_ID => X_PROPERTY_ID, 
                                                   X_UNIT_NAME => to_char(x_max_unit_number), 
                                                   X_UNIT_SIZE => NULL, 
                                                   X_BEDROOMS => NULL, 
                                                   X_BATHROOMS => NULL);
          x_max_unit_number :=x_max_unit_number + 1;                                                         
      end loop;
      */
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
 xl_num_units RNT_PROPERTIES.UNITS%TYPE;
 x1 RNT_PROPERTY_UNITS.UNIT_ID%TYPE;
begin

   if not check_unique(NULL,X_ADDRESS1, X_ADDRESS2, 
                      X_CITY, X_STATE, X_ZIPCODE) then
        RAISE_APPLICATION_ERROR(-20313, 'Address of property must be unique');                      
   end if;  

   if not RNT_BUSINESS_UNITS_PKG.CHECK_ALLOW_FOR_ACCESS(X_BUSINESS_ID) then
       RAISE_APPLICATION_ERROR(-20314, 'You cannot insert this property because not allowed business unit reference.');
   end if;                    
   
  xl_num_units := X_UNITS;
    
  -- num of units must be 1 or more 
  if xl_num_units = 0 then
      xl_num_units := 1;
  end if;
    
  insert into RNT_PROPERTIES (
           PROPERTY_ID, BUSINESS_ID, UNITS, 
           ADDRESS1, ADDRESS2, 
           CITY, STATE, ZIPCODE, 
           DATE_PURCHASED, PURCHASE_PRICE, LAND_VALUE, 
           DEPRECIATION_TERM, YEAR_BUILT, BUILDING_SIZE, 
           LOT_SIZE, DATE_SOLD, SALE_AMOUNT, 
           NOTE_YN) 
  values (RNT_PROPERTIES_SEQ.NEXTVAL, X_BUSINESS_ID,  xl_num_units, 
   X_ADDRESS1, X_ADDRESS2, 
   X_CITY, X_STATE, X_ZIPCODE, 
   X_DATE_PURCHASED, X_PURCHASE_PRICE, X_LAND_VALUE, 
   X_DEPRECIATION_TERM, X_YEAR_BUILT, X_BUILDING_SIZE, 
   X_LOT_SIZE, X_DATE_SOLD, X_SALE_AMOUNT, 
   X_NOTE_YN)
  returning PROPERTY_ID into x;
  
  if xl_num_units = 1 then
       -- append single unit  
       x1 := RNT_PROPERTY_UNITS_PKG.INSERT_ROW(X_PROPERTY_ID => x, 
                                               X_UNIT_NAME => 'Single Unit', 
                                               X_UNIT_SIZE => X_BUILDING_SIZE, 
                                               X_BEDROOMS => NULL, 
                                               X_BATHROOMS => NULL);
  else
     for i in 1..xl_num_units loop
         x1 := RNT_PROPERTY_UNITS_PKG.INSERT_ROW(X_PROPERTY_ID => x, 
                                                   X_UNIT_NAME => to_char(i), 
                                                   X_UNIT_SIZE => NULL, 
                                                   X_BEDROOMS => NULL, 
                                                   X_BATHROOMS => NULL);
     end loop;
                                               
  end if;
  
  return x;
end;

function is_exists_value(X_PROPERTY_ID RNT_PROPERTIES.PROPERTY_ID%TYPE) return boolean
is
 x NUMBER;
begin
  select 1
  into x
  from DUAL
  where exists (select 1
                from RNT_PROPERTY_VALUE
                where PROPERTY_ID = X_PROPERTY_ID
                );
  return true;
exception
  when NO_DATA_FOUND then
     return false;   
end;

function is_exists_unit(X_PROPERTY_ID RNT_PROPERTIES.PROPERTY_ID%TYPE) return boolean
is
 x NUMBER;
begin
  for x in (select UNIT_ID from RNT_PROPERTY_UNITS where PROPERTY_ID = X_PROPERTY_ID) loop
     if RNT_PROPERTY_UNITS_PKG.IS_EXISTS_CHILDS(x.UNIT_ID) then
        return true;
     end if;   
  end loop;
  return false;
end;

function is_exists_expenses(X_PROPERTY_ID RNT_PROPERTIES.PROPERTY_ID%TYPE) return boolean
is
 x NUMBER;
begin
  select 1
  into x
  from DUAL
  where exists (select 1
                from RNT_PROPERTY_EXPENSES
                where PROPERTY_ID = X_PROPERTY_ID
                );
  return true;
exception
  when NO_DATA_FOUND then
     return false;   
end;


procedure delete_row(X_PROPERTY_ID       RNT_PROPERTIES.PROPERTY_ID%TYPE)
is
begin
-- check for exists child records
  if is_exists_value(X_PROPERTY_ID) then
    RAISE_APPLICATION_ERROR(-20315, 'Cannot delete record. For property exists value(s) record.');
  end if;
  if is_exists_unit(X_PROPERTY_ID) then
    RAISE_APPLICATION_ERROR(-20316, 'Cannot delete record. For property exists units with child records.');
  end if;
  if is_exists_expenses(X_PROPERTY_ID) then
    RAISE_APPLICATION_ERROR(-20317, 'Cannot delete record. For property exists expenses expenses.');
  end if;
  
  delete from RNT_PROPERTY_UNITS
  where PROPERTY_ID = X_PROPERTY_ID;
  
  delete from RNT_PROPERTIES
  where PROPERTY_ID = X_PROPERTY_ID;
end;

END RNT_PROPERTIES_PKG;
/


