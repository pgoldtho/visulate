set define ^
CREATE OR REPLACE PACKAGE RNT_PROPERTIES_PKG AS
/******************************************************************************
   NAME:       RNT_PROPERTIES_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        30.03.2007                Created this package.
   1.1                                  Added copy/move business unit functionality
   1.2        Nov 25, 2009              Added public record functionality
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
                     X_NAME              RNT_PROPERTIES.NAME%TYPE,
                     X_ADDRESS1          RNT_PROPERTIES.ADDRESS1%TYPE,
                     X_ADDRESS2          RNT_PROPERTIES.ADDRESS2%TYPE,
                     X_CITY              RNT_PROPERTIES.CITY%TYPE,
                     X_STATE             RNT_PROPERTIES.STATE%TYPE,
                     X_ZIPCODE           RNT_PROPERTIES.ZIPCODE%TYPE,
                     X_STATUS            RNT_PROPERTIES.STATUS%TYPE,
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
                     X_NAME              RNT_PROPERTIES.NAME%TYPE,
                     X_ADDRESS1          RNT_PROPERTIES.ADDRESS1%TYPE,
                     X_ADDRESS2          RNT_PROPERTIES.ADDRESS2%TYPE,
                     X_CITY              RNT_PROPERTIES.CITY%TYPE,
                     X_STATE             RNT_PROPERTIES.STATE%TYPE,
                     X_ZIPCODE           RNT_PROPERTIES.ZIPCODE%TYPE,
                     X_STATUS            RNT_PROPERTIES.STATUS%TYPE,
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
                     X_PROP_ID           RNT_PROPERTIES.PROP_ID%TYPE := null)
    return RNT_PROPERTIES.PROPERTY_ID%TYPE;

procedure delete_row(X_PROPERTY_ID       RNT_PROPERTIES.PROPERTY_ID%TYPE);

-- copy property to another business unit
procedure copy(p_property_id in number,
               p_buID_from   in number,
               p_buID_to     in number);

-- copy property to another business unit
procedure move(p_property_id in number,
               p_buID_from   in number,
               p_buID_to     in number);

function copy_public_record( p_prop_id     in pr_properties.prop_id%type
                           , p_business_id in rnt_business_units.business_id%type)
         return rnt_properties.property_id%type;

function estimate2BU(
      x_prop_id           IN   pr_properties.prop_id%TYPE,
      x_business_id       IN   rnt_property_estimates.business_id%TYPE,
      x_estimate_title    IN   rnt_property_estimates.estimate_title%TYPE,
      x_monthly_rent      IN   rnt_property_estimates.monthly_rent%TYPE,
      x_other_income      IN   rnt_property_estimates.other_income%TYPE,
      x_vacancy_pct       IN   rnt_property_estimates.vacancy_pct%TYPE,
      x_replace_3years    IN   rnt_property_estimates.replace_3years%TYPE,
      x_replace_5years    IN   rnt_property_estimates.replace_5years%TYPE,
      x_replace_12years   IN   rnt_property_estimates.replace_12years%TYPE,
      x_maintenance       IN   rnt_property_estimates.maintenance%TYPE,
      x_utilities         IN   rnt_property_estimates.utilities%TYPE,
      x_property_taxes    IN   rnt_property_estimates.property_taxes%TYPE,
      x_insurance         IN   rnt_property_estimates.insurance%TYPE,
      x_mgt_fees          IN   rnt_property_estimates.mgt_fees%TYPE,
      x_down_payment      IN   rnt_property_estimates.down_payment%TYPE,
      x_closing_costs     IN   rnt_property_estimates.closing_costs%TYPE,
      x_purchase_price    IN   rnt_property_estimates.purchase_price%TYPE,
      x_cap_rate          IN   rnt_property_estimates.cap_rate%TYPE,
      x_loan1_amount      IN   rnt_property_estimates.loan1_amount%TYPE,
      x_loan1_type        IN   rnt_property_estimates.loan1_type%TYPE,
      x_loan1_term        IN   rnt_property_estimates.loan1_term%TYPE,
      x_loan1_rate        IN   rnt_property_estimates.loan1_rate%TYPE,
      x_loan2_amount      IN   rnt_property_estimates.loan2_amount%TYPE,
      x_loan2_type        IN   rnt_property_estimates.loan2_type%TYPE,
      x_loan2_term        IN   rnt_property_estimates.loan2_term%TYPE,
      x_loan2_rate        IN   rnt_property_estimates.loan2_rate%TYPE
   ) return number;

END RNT_PROPERTIES_PKG;
/
CREATE OR REPLACE PACKAGE BODY RNT_PROPERTIES_PKG AS
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
                 NOTE_YN, DESCRIPTION, NAME, STATUS
              from RNT_PROPERTIES
              where PROPERTY_ID = p_property_id) loop
         RNT_SYS_CHECKSUM_REC_PKG.INIT;
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.PROPERTY_ID);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.BUSINESS_ID);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.UNITS);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.NAME);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.ADDRESS1);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.ADDRESS2);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.CITY);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.STATE);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.ZIPCODE);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.STATUS);
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
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.DESCRIPTION);
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
                      X_ZIPCODE           RNT_PROPERTIES.ZIPCODE%TYPE,
                      X_BUSINESS_ID       RNT_PROPERTIES.BUSINESS_ID%TYPE) return boolean
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
                     and BUSINESS_ID = x_BUSINESS_ID
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
                     X_NAME              RNT_PROPERTIES.NAME%TYPE,
                     X_ADDRESS1          RNT_PROPERTIES.ADDRESS1%TYPE,
                     X_ADDRESS2          RNT_PROPERTIES.ADDRESS2%TYPE,
                     X_CITY              RNT_PROPERTIES.CITY%TYPE,
                     X_STATE             RNT_PROPERTIES.STATE%TYPE,
                     X_ZIPCODE           RNT_PROPERTIES.ZIPCODE%TYPE,
                     X_STATUS            RNT_PROPERTIES.STATUS%TYPE,
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
                      X_CITY, X_STATE, X_ZIPCODE, X_BUSINESS_ID) then
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
       NAME              = X_NAME,
       ADDRESS1          = X_ADDRESS1,
       ADDRESS2          = X_ADDRESS2,
       CITY              = X_CITY,
       STATE             = X_STATE,
       ZIPCODE           = X_ZIPCODE,
       STATUS            = X_STATUS,
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
                     X_NAME              RNT_PROPERTIES.NAME%TYPE,
                     X_ADDRESS1          RNT_PROPERTIES.ADDRESS1%TYPE,
                     X_ADDRESS2          RNT_PROPERTIES.ADDRESS2%TYPE,
                     X_CITY              RNT_PROPERTIES.CITY%TYPE,
                     X_STATE             RNT_PROPERTIES.STATE%TYPE,
                     X_ZIPCODE           RNT_PROPERTIES.ZIPCODE%TYPE,
                     X_STATUS            RNT_PROPERTIES.STATUS%TYPE,
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
                     X_PROP_ID           RNT_PROPERTIES.PROP_ID%TYPE := null)
       return RNT_PROPERTIES.PROPERTY_ID%TYPE
is
 x RNT_PROPERTIES.PROPERTY_ID%TYPE;
 xl_num_units RNT_PROPERTIES.UNITS%TYPE;
 x1 RNT_PROPERTY_UNITS.UNIT_ID%TYPE;
begin

   if not check_unique(NULL,X_ADDRESS1, X_ADDRESS2,
                      X_CITY, X_STATE, X_ZIPCODE, X_BUSINESS_ID) then
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
           NAME, ADDRESS1, ADDRESS2,
           CITY, STATE, ZIPCODE, STATUS,
           DATE_PURCHASED, PURCHASE_PRICE, LAND_VALUE,
           DEPRECIATION_TERM, YEAR_BUILT, BUILDING_SIZE,
           LOT_SIZE, DATE_SOLD, SALE_AMOUNT,
           NOTE_YN, PROP_ID)
  values (RNT_PROPERTIES_SEQ.NEXTVAL, X_BUSINESS_ID,  xl_num_units,
   X_NAME, X_ADDRESS1, X_ADDRESS2,
   X_CITY, X_STATE, X_ZIPCODE, X_STATUS,
   X_DATE_PURCHASED, X_PURCHASE_PRICE, X_LAND_VALUE,
   X_DEPRECIATION_TERM, X_YEAR_BUILT, X_BUILDING_SIZE,
   X_LOT_SIZE, X_DATE_SOLD, X_SALE_AMOUNT,
   X_NOTE_YN, X_PROP_ID)
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


procedure copy(p_property_id in number,
               p_buID_from   in number,
               p_buID_to     in number)
is
  v_new_property_id    number;
begin
    --
    select RNT_PROPERTIES_SEQ.NEXTVAL 
    into   v_new_property_id 
    from   dual;
         
    -- copy property
    insert into RNT_PROPERTIES(
           PROPERTY_ID,
           BUSINESS_ID,
           UNITS, NAME, ADDRESS1, ADDRESS2,
           CITY, STATE, ZIPCODE, STATUS,
           DATE_PURCHASED, PURCHASE_PRICE, LAND_VALUE,
           DEPRECIATION_TERM, YEAR_BUILT, BUILDING_SIZE,
           LOT_SIZE, DATE_SOLD, SALE_AMOUNT, NOTE_YN, PROP_ID)
    select v_new_property_id as PROPERTY_ID,
           p_buID_to as BUSINESS_ID,
           UNITS, NAME, ADDRESS1, ADDRESS2,
           CITY, STATE, ZIPCODE, STATUS,
           DATE_PURCHASED, PURCHASE_PRICE, LAND_VALUE,
           DEPRECIATION_TERM, YEAR_BUILT, BUILDING_SIZE,
           LOT_SIZE, DATE_SOLD, SALE_AMOUNT, NOTE_YN, PROP_ID
    from   rnt_properties
    where  business_id = p_buID_from
    and    property_id = p_property_id
    and    p_buID_from != p_buID_to;  -- check! 
    
    if SQL%ROWCOUNT = 1 then
        -- copy units
        insert into RNT_PROPERTY_UNITS(
               UNIT_ID,
               PROPERTY_ID, UNIT_NAME,
               UNIT_SIZE, BEDROOMS, BATHROOMS)
        select RNT_PROPERTY_UNITS_SEQ.NEXTVAL as UNIT_ID,
               v_new_property_id as PROPERTY_ID,  UNIT_NAME,
               UNIT_SIZE, BEDROOMS, BATHROOMS
        from   RNT_PROPERTY_UNITS    
        where  property_id = p_property_id;
             
        -- copy estimates
        insert into rnt_property_estimates(
               PROPERTY_ESTIMATES_ID,
               PROPERTY_ID,
               BUSINESS_ID,
               ESTIMATE_YEAR, ESTIMATE_TITLE, MONTHLY_RENT, OTHER_INCOME,
               VACANCY_PCT, REPLACE_3YEARS, REPLACE_5YEARS, REPLACE_12YEARS,
               MAINTENANCE, UTILITIES, PROPERTY_TAXES, INSURANCE,
               MGT_FEES, DOWN_PAYMENT, CLOSING_COSTS, PURCHASE_PRICE,
               CAP_RATE, LOAN1_AMOUNT, LOAN1_TYPE, LOAN1_TERM,
               LOAN1_RATE, LOAN2_AMOUNT, LOAN2_TYPE, LOAN2_TERM,
               LOAN2_RATE, NOTES)
        select RNT_PROPERTY_ESTIMATES_SEQ.NEXTVAL as PROPERTY_ESTIMATES_ID,
               v_new_property_id,
               p_buID_to,
               ESTIMATE_YEAR, ESTIMATE_TITLE, MONTHLY_RENT, OTHER_INCOME,
               VACANCY_PCT, REPLACE_3YEARS, REPLACE_5YEARS, REPLACE_12YEARS,
               MAINTENANCE, UTILITIES, PROPERTY_TAXES, INSURANCE,
               MGT_FEES, DOWN_PAYMENT, CLOSING_COSTS, PURCHASE_PRICE,
               CAP_RATE, LOAN1_AMOUNT, LOAN1_TYPE, LOAN1_TERM,
               LOAN1_RATE, LOAN2_AMOUNT, LOAN2_TYPE, LOAN2_TERM,
               LOAN2_RATE, NOTES 
        from   rnt_property_estimates
        where  business_id = p_buID_from
        and    property_id = p_property_id;
             
        -- copy links 
        insert into RNT_PROPERTY_LINKS(
               PROPERTY_LINK_ID,
               PROPERTY_ID,
               LINK_TITLE, LINK_URL, CREATION_DATE)
        select RNT_PROPERTY_LINKS_SEQ.NEXTVAL as PROPERTY_LINK_ID,
               v_new_property_id as PROPERTY_ID,
               LINK_TITLE, LINK_URL, SYSDATE
        from   rnt_property_links
        where  property_id = p_property_id;
    else
        RAISE_APPLICATION_ERROR(
            -20413,
            'Copy property error! Input params:'||
            ' p_property_id = '||p_property_id||
            ' p_buID_from ='||p_buID_from||
            ' p_buID_to ='||p_buID_to
        );
    end if;
end copy;


procedure move(p_property_id in number,
               p_buID_from   in number,
               p_buID_to     in number)
is
begin
    -- 1. Update rnt_properties.business_id
    update rnt_properties
    set    business_id = p_buID_to
    where  business_id = p_buID_from
    and    property_id = p_property_id
    and    p_buID_from != p_buID_to;  -- check!
    
    if SQL%ROWCOUNT = 1 then
        -- 2. Update rnt_accounts_payable.business_id for each row 
        -- associated with the property
        update rnt_accounts_payable
        set    business_id = p_buID_to
        where  business_id         = p_buID_from
        and    payment_property_id = p_property_id;
        
        -- 3. Update rnt_accounts_receivable.business_id for each row 
        -- associated with the property
        update rnt_accounts_receivable
        set    business_id = p_buID_to
        where  business_id         = p_buID_from
        and    payment_property_id = p_property_id;
        
        -- 4. Insert rows in rnt_people_bu for each tenant for the property.
        insert into RNT_PEOPLE_BU(
               PEOPLE_BUSINESS_ID,
               PEOPLE_ID,
               BUSINESS_ID) 
        select RNT_PEOPLE_BU_SEQ.NEXTVAL as PEOPLE_BUSINESS_ID,
               r.people_id,
               r.business_id 
        from   (select people_id,
                       p_buID_to as business_id
                from   (select distinct t.people_id 
                        from   rnt_properties        p,
                               rnt_property_units    pu,
                               rnt_tenancy_agreement ta,
                               rnt_tenant t
                        where  pu.property_id    = p.property_id
                        and    ta.unit_id     (+)= pu.unit_id
                        and    t.agreement_id    = ta.agreement_id
                        --and    p.business_id     = p_buID_from
                        and    p.property_id     = p_property_id
                       ) x
                 minus
                 select people_id,
                        business_id
                 from   RNT_PEOPLE_BU      
               ) r;

        -- 5. Insert rows in rnt_bu_suppliers for each supplier 
        -- with expense items or accounts payable rows for the property.
        insert into RNT_BU_SUPPLIERS
               (BU_SUPPLIER_ID,
                BUSINESS_ID,
                SUPPLIER_ID,
                TAX_IDENTIFIER, NOTES)
        select  RNT_BU_SUPPLIERS_SEQ.NEXTVAL as BU_SUPPLIER_ID,
                r.business_id, r.supplier_id,
                to_char(null) as tax_identifier, to_char(null) as notes
        from    (select p_buID_to as business_id,
                        x.supplier_id as supplier_id
                 from   (select ei.supplier_id
                         from   RNT_PROPERTY_EXPENSES  pe,
                                RNT_EXPENSE_ITEMS  ei
                         where  ei.expense_id  = pe.expense_id
                         and    pe.property_id = p_property_id
                         union
                         select ap.supplier_id 
                         from   RNT_ACCOUNTS_PAYABLE   ap,
                                RNT_PROPERTY_EXPENSES  pe
                         where  ap.expense_id  = pe.expense_id
                         --and    ap.business_id = p_buID_from
                         and    pe.property_id = p_property_id
                        ) x
                 minus
                 select business_id, supplier_id
                 from   RNT_BU_SUPPLIERS
                ) r;

        -- 6. Insert rows in rnt_section8_offices_bu 
        -- for any section 8 tenancy agreements.
        insert into RNT_SECTION8_OFFICES_BU
               (SECTION8_BUSINESS_ID,
                SECTION8_ID,
                BUSINESS_ID) 
        select RNT_SECTION8_OFFICES_BU_SEQ.NEXTVAL, 
               r.section8_id, 
               r.business_id 
        from   (select x.section8_id as section8_id,
                       p_buID_to as business_id
                from   (select distinct t.section8_id
                        from   rnt_properties        p,
                               rnt_property_units    pu,
                               rnt_tenancy_agreement ta,
                               rnt_tenant t
                        where  pu.property_id    = p.property_id
                        and    ta.unit_id     (+)= pu.unit_id
                        and    t.agreement_id    = ta.agreement_id
                        --and    p.business_id     = p_buID_from
                        and    p.property_id     = p_property_id
                       ) x
                where  x.section8_id is not null
                minus
                select section8_id, business_id
                from   RNT_SECTION8_OFFICES_BU
               ) r;
    else
        RAISE_APPLICATION_ERROR(
            -20413,
            'Move property error! Input params:'||
            ' p_property_id = '||p_property_id||
            ' p_buID_from ='||p_buID_from||
            ' p_buID_to ='||p_buID_to
        );
    end if;
end move;

function copy_public_record( p_prop_id     in pr_properties.prop_id%type
                           , p_business_id in rnt_business_units.business_id%type)
         return rnt_properties.property_id%type is

  v_prop_rec        pr_properties%rowtype;
  v_building_count  pls_integer;
  v_property_id     rnt_properties.property_id%type;
  v_ucode           pr_usage_codes.ucode%type;
  v_depreciation    number;
  v_link_id         rnt_property_links.property_link_id%type;

begin

  select * 
  into v_prop_rec
  from pr_properties
  where prop_id = p_prop_id;

  select count(*) 
  into v_building_count
  from pr_buildings
  where prop_id = p_prop_id;

  if v_building_count < 1 then
    v_building_count := 1;
  end if;

  select min(parent_ucode)
  into v_ucode
  from pr_property_usage pu
  ,    pr_usage_codes uc
  where pu.ucode = uc.ucode
  and pu.prop_id = p_prop_id;

  if v_ucode in (2, 11, 12, 13, 14, 15, 16, 17, 18, 19, 23, 24,
                 92000, 93000,94000, 95000, 96000, 97000 ) then
     v_depreciation := 39;
  else 
     v_depreciation := 27.5;
  end if;

  v_property_id := insert_row( X_BUSINESS_ID       => P_BUSINESS_ID
                             , X_UNITS             => v_building_count
                             , X_ADDRESS1          => initcap(v_prop_rec.ADDRESS1)
                             , X_ADDRESS2          => initcap(v_prop_rec.ADDRESS2)
                             , X_CITY              => initcap(v_prop_rec.CITY)
                             , X_STATE             => v_prop_rec.STATE
                             , X_ZIPCODE           => v_prop_rec.ZIPCODE
                             , X_STATUS            => 'CANDIDATE'
                             , X_DEPRECIATION_TERM => v_depreciation
                             , X_BUILDING_SIZE     => v_prop_rec.sq_ft
                             , X_LOT_SIZE          => v_prop_rec.acreage
                             , X_PROP_ID           => p_prop_id
                             , X_NAME              => null
                             , X_DATE_PURCHASED    => null
                             , X_PURCHASE_PRICE    => null
                             , X_LAND_VALUE        => null
                             , X_YEAR_BUILT        => null
                             , X_DATE_SOLD         => null
                             , X_SALE_AMOUNT       => null
                             , X_NOTE_YN           => null);

  v_link_id := rnt_property_links_pkg.insert_row
                    ( x_property_id  => v_property_id
                    , x_link_title   => 'Visulate'
                    , x_link_url     => 'http://visulate.com/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID='||p_prop_id);

  return v_property_id;

end copy_public_record;

function estimate2BU(
      x_prop_id           IN   pr_properties.prop_id%TYPE,
      x_business_id       IN   rnt_property_estimates.business_id%TYPE,
      x_estimate_title    IN   rnt_property_estimates.estimate_title%TYPE,
      x_monthly_rent      IN   rnt_property_estimates.monthly_rent%TYPE,
      x_other_income      IN   rnt_property_estimates.other_income%TYPE,
      x_vacancy_pct       IN   rnt_property_estimates.vacancy_pct%TYPE,
      x_replace_3years    IN   rnt_property_estimates.replace_3years%TYPE,
      x_replace_5years    IN   rnt_property_estimates.replace_5years%TYPE,
      x_replace_12years   IN   rnt_property_estimates.replace_12years%TYPE,
      x_maintenance       IN   rnt_property_estimates.maintenance%TYPE,
      x_utilities         IN   rnt_property_estimates.utilities%TYPE,
      x_property_taxes    IN   rnt_property_estimates.property_taxes%TYPE,
      x_insurance         IN   rnt_property_estimates.insurance%TYPE,
      x_mgt_fees          IN   rnt_property_estimates.mgt_fees%TYPE,
      x_down_payment      IN   rnt_property_estimates.down_payment%TYPE,
      x_closing_costs     IN   rnt_property_estimates.closing_costs%TYPE,
      x_purchase_price    IN   rnt_property_estimates.purchase_price%TYPE,
      x_cap_rate          IN   rnt_property_estimates.cap_rate%TYPE,
      x_loan1_amount      IN   rnt_property_estimates.loan1_amount%TYPE,
      x_loan1_type        IN   rnt_property_estimates.loan1_type%TYPE,
      x_loan1_term        IN   rnt_property_estimates.loan1_term%TYPE,
      x_loan1_rate        IN   rnt_property_estimates.loan1_rate%TYPE,
      x_loan2_amount      IN   rnt_property_estimates.loan2_amount%TYPE,
      x_loan2_type        IN   rnt_property_estimates.loan2_type%TYPE,
      x_loan2_term        IN   rnt_property_estimates.loan2_term%TYPE,
      x_loan2_rate        IN   rnt_property_estimates.loan2_rate%TYPE
   ) return number is
  v_return_msg               number := 0;
  v_count                    pls_integer;
  v_property_id              rnt_properties.property_id%type;
  v_property_estimates_id    rnt_property_estimates.property_estimates_id%type;
  v_year                     date;
  v_userid                   number;
  v_username                 rnt_users.user_name%type;
begin
  select count(*)
  into v_count
  from rnt_properties
  where business_id = x_business_id
  and prop_id = x_prop_id;
  
  v_userid := rnt_users_pkg.get_user;
  select user_login
  into v_username
  from rnt_users
  where user_id = v_userid;

  
  v_year := round(sysdate, 'YYYY');

  if v_count > 0 then
    select property_id
    into v_property_id
    from rnt_properties
    where business_id = x_business_id
    and prop_id = x_prop_id;

    update rnt_properties
    set status = 'CANDIDATE'
    where property_id = v_property_id
    and (status = 'REJECTED' or status='SOLD');
  else
    v_property_id := copy_public_record(x_prop_id, x_business_id);
    v_return_msg := 1;
  end if;
  --v_year := sysdate;



  begin
    select property_estimates_id
    into v_property_estimates_id
    from rnt_property_estimates
    where property_id = v_property_id
    and business_id = x_business_id
    and estimate_year = v_year
    and estimate_title = x_estimate_title;
  exception
    when no_data_found then null;
    when others then raise;
  end;

  if v_property_estimates_id is not null then
    rnt_property_estimates_pkg.update_row (
      x_property_estimates_id   =>  v_property_estimates_id,
      x_property_id             =>  v_property_id,
      x_business_id             =>  x_business_id,
      x_estimate_year           =>  v_year,
      x_estimate_title          =>  x_estimate_title,
      x_monthly_rent            =>  x_monthly_rent,
      x_other_income            =>  x_other_income,
      x_vacancy_pct             =>  x_vacancy_pct,
      x_replace_3years          =>  x_replace_3years,
      x_replace_5years          =>  x_replace_5years,
      x_replace_12years         =>  x_replace_12years,
      x_maintenance             =>  x_maintenance,
      x_utilities               =>  x_utilities,
      x_property_taxes          =>  x_property_taxes,
      x_insurance               =>  x_insurance,
      x_mgt_fees                =>  x_mgt_fees,
      x_down_payment            =>  x_down_payment,
      x_closing_costs           =>  x_closing_costs,
      x_purchase_price          =>  x_purchase_price,
      x_cap_rate                =>  x_cap_rate,
      x_loan1_amount            =>  x_loan1_amount,
      x_loan1_type              =>  x_loan1_type,
      x_loan1_term              =>  x_loan1_term,
      x_loan1_rate              =>  x_loan1_rate,
      x_loan2_amount            =>  x_loan2_amount,
      x_loan2_type              =>  x_loan2_type,
      x_loan2_term              =>  x_loan2_term,
      x_loan2_rate              =>  x_loan2_rate,
      x_notes                   =>  sysdate||' Updated from cashflow estimate page by '||v_username,
      x_checksum                =>  rnt_property_estimates_pkg.get_checksum(v_property_estimates_id));
      v_return_msg := 2;
  else
    v_property_estimates_id := rnt_property_estimates_pkg.insert_row (
      x_property_id             =>  v_property_id,
      x_business_id             =>  x_business_id,
      x_estimate_year           =>  v_year,
      x_estimate_title          =>  x_estimate_title,
      x_monthly_rent            =>  x_monthly_rent,
      x_other_income            =>  x_other_income,
      x_vacancy_pct             =>  x_vacancy_pct,
      x_replace_3years          =>  x_replace_3years,
      x_replace_5years          =>  x_replace_5years,
      x_replace_12years         =>  x_replace_12years,
      x_maintenance             =>  x_maintenance,
      x_utilities               =>  x_utilities,
      x_property_taxes          =>  x_property_taxes,
      x_insurance               =>  x_insurance,
      x_mgt_fees                =>  x_mgt_fees,
      x_down_payment            =>  x_down_payment,
      x_closing_costs           =>  x_closing_costs,
      x_purchase_price          =>  x_purchase_price,
      x_cap_rate                =>  x_cap_rate,
      x_loan1_amount            =>  x_loan1_amount,
      x_loan1_type              =>  x_loan1_type,
      x_loan1_term              =>  x_loan1_term,
      x_loan1_rate              =>  x_loan1_rate,
      x_loan2_amount            =>  x_loan2_amount,
      x_loan2_type              =>  x_loan2_type,
      x_loan2_term              =>  x_loan2_term,
      x_loan2_rate              =>  x_loan2_rate,
      x_notes                   =>  sysdate||' Added from cashflow estimate page by '||v_username);

      v_return_msg := v_return_msg + 10;
  end if;
 
  return v_return_msg;
end estimate2BU;   


END RNT_PROPERTIES_PKG;
/
show errors package RNT_PROPERTIES_PKG
show errors package body RNT_PROPERTIES_PKG