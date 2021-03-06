create or replace package PR_VALUES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2010        All rights reserved worldwide
    Name:      PR_VALUES_PKG
    Purpose:   API's for PR_VALUES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        15-FEB-11   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_CITY_ID IN PR_VALUES.CITY_ID%TYPE
                       , X_UCODE IN PR_VALUES.UCODE%TYPE
                       , X_PROP_CLASS IN PR_VALUES.PROP_CLASS%TYPE
                       , X_YEAR IN PR_VALUES.YEAR%TYPE)
            return PR_VALUES_V.CHECKSUM%TYPE;

  procedure update_row( X_CITY_ID IN PR_VALUES.CITY_ID%TYPE
                      , X_UCODE IN PR_VALUES.UCODE%TYPE
                      , X_PROP_CLASS IN PR_VALUES.PROP_CLASS%TYPE
                      , X_YEAR IN PR_VALUES.YEAR%TYPE
                      , X_MIN_PRICE IN PR_VALUES.MIN_PRICE%TYPE
                      , X_MAX_PRICE IN PR_VALUES.MAX_PRICE%TYPE
                      , X_MEDIAN_PRICE IN PR_VALUES.MEDIAN_PRICE%TYPE
                      , X_RENT IN PR_VALUES.RENT%TYPE
					  , X_VACANCY_PERCENT IN PR_VALUES.VACANCY_PERCENT%TYPE
                      , X_REPLACEMENT IN PR_VALUES.REPLACEMENT%TYPE
                      , X_MAINTENANCE IN PR_VALUES.MAINTENANCE%TYPE
                      , X_MGT_PERCENT IN PR_VALUES.MGT_PERCENT%TYPE
                      , X_CAP_RATE IN PR_VALUES.CAP_RATE%TYPE
                      , X_UTILITIES IN PR_VALUES.UTILITIES%TYPE
                      , X_CHECKSUM IN PR_VALUES_V.CHECKSUM%TYPE);

  procedure  insert_row( X_CITY_ID IN PR_VALUES.CITY_ID%TYPE
                     , X_UCODE IN PR_VALUES.UCODE%TYPE
                     , X_PROP_CLASS IN PR_VALUES.PROP_CLASS%TYPE
                     , X_YEAR IN PR_VALUES.YEAR%TYPE
                     , X_MIN_PRICE IN PR_VALUES.MIN_PRICE%TYPE
                     , X_MAX_PRICE IN PR_VALUES.MAX_PRICE%TYPE
                     , X_MEDIAN_PRICE IN PR_VALUES.MEDIAN_PRICE%TYPE
                     , X_RENT IN PR_VALUES.RENT%TYPE
		     , X_VACANCY_PERCENT IN PR_VALUES.VACANCY_PERCENT%TYPE
                     , X_REPLACEMENT IN PR_VALUES.REPLACEMENT%TYPE
                     , X_MAINTENANCE IN PR_VALUES.MAINTENANCE%TYPE
                     , X_MGT_PERCENT IN PR_VALUES.MGT_PERCENT%TYPE
                     , X_CAP_RATE IN PR_VALUES.CAP_RATE%TYPE
                     , X_UTILITIES IN PR_VALUES.UTILITIES%TYPE);

  procedure delete_row( X_CITY_ID IN PR_VALUES.CITY_ID%TYPE
                       , X_UCODE IN PR_VALUES.UCODE%TYPE
                       , X_PROP_CLASS IN PR_VALUES.PROP_CLASS%TYPE
                       , X_YEAR IN PR_VALUES.YEAR%TYPE);

end PR_VALUES_PKG;
/
create or replace package body PR_VALUES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2010        All rights reserved worldwide
    Name:      PR_VALUES_PKG
    Purpose:   API's for PR_VALUES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        15-FEB-11   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


procedure lock_row( X_CITY_ID IN PR_VALUES.CITY_ID%TYPE
                  , X_UCODE IN PR_VALUES.UCODE%TYPE
                  , X_PROP_CLASS IN PR_VALUES.PROP_CLASS%TYPE
                  , X_YEAR IN PR_VALUES.YEAR%TYPE) is
  cursor c is
  select * from PR_VALUES
  where  PROP_CLASS = X_PROP_CLASS
  and    UCODE      = X_UCODE
  and    CITY_ID    = X_CITY_ID
  and    YEAR       = X_YEAR
  for update nowait;

begin
    open c;
    close c;
exception
    when OTHERS then
      if SQLCODE = -54 then
        RAISE_APPLICATION_ERROR(-20001, 'Cannot changed record. Record is locked.');
      end if;
end lock_row;

-------------------------------------------------
--  Public Procedures and Functions
-------------------------------------------------
function get_checksum( X_CITY_ID IN PR_VALUES.CITY_ID%TYPE
                     , X_UCODE IN PR_VALUES.UCODE%TYPE
                     , X_PROP_CLASS IN PR_VALUES.PROP_CLASS%TYPE
                     , X_YEAR IN PR_VALUES.YEAR%TYPE)
            return PR_VALUES_V.CHECKSUM%TYPE is

    v_return_value               PR_VALUES_V.CHECKSUM%TYPE;
begin
    select CHECKSUM
    into v_return_value
    from PR_VALUES_V
    where PROP_CLASS = X_PROP_CLASS
    and UCODE = X_UCODE
    and CITY_ID = X_CITY_ID
    and YEAR = X_YEAR;
    return v_return_value;
end get_checksum;

procedure update_row( X_CITY_ID IN PR_VALUES.CITY_ID%TYPE
                    , X_UCODE IN PR_VALUES.UCODE%TYPE
                    , X_PROP_CLASS IN PR_VALUES.PROP_CLASS%TYPE
                    , X_YEAR IN PR_VALUES.YEAR%TYPE
                    , X_MIN_PRICE IN PR_VALUES.MIN_PRICE%TYPE
                    , X_MAX_PRICE IN PR_VALUES.MAX_PRICE%TYPE
                    , X_MEDIAN_PRICE IN PR_VALUES.MEDIAN_PRICE%TYPE
                    , X_RENT IN PR_VALUES.RENT%TYPE
                    , X_VACANCY_PERCENT IN PR_VALUES.VACANCY_PERCENT%TYPE
                    , X_REPLACEMENT IN PR_VALUES.REPLACEMENT%TYPE
                    , X_MAINTENANCE IN PR_VALUES.MAINTENANCE%TYPE
                    , X_MGT_PERCENT IN PR_VALUES.MGT_PERCENT%TYPE
                    , X_CAP_RATE IN PR_VALUES.CAP_RATE%TYPE
                    , X_UTILITIES IN PR_VALUES.UTILITIES%TYPE
                    , X_CHECKSUM IN PR_VALUES_V.CHECKSUM%TYPE)
is
  l_checksum          PR_VALUES_V.CHECKSUM%TYPE;
begin
     lock_row(X_CITY_ID, X_UCODE, X_PROP_CLASS, X_YEAR);

      -- validate checksum
      l_checksum := get_checksum(X_CITY_ID, X_UCODE, X_PROP_CLASS, X_YEAR);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

     update PR_VALUES
     set MIN_PRICE  = X_MIN_PRICE
     , MAX_PRICE    = X_MAX_PRICE
     , MEDIAN_PRICE = X_MEDIAN_PRICE
     , RENT         = X_RENT
	 , VACANCY_PERCENT = X_VACANCY_PERCENT 
     , REPLACEMENT  = X_REPLACEMENT
     , MAINTENANCE  = X_MAINTENANCE
     , MGT_PERCENT  = X_MGT_PERCENT
     , CAP_RATE     = X_CAP_RATE
     , UTILITIES    = X_UTILITIES
     where PROP_CLASS = X_PROP_CLASS
	 and   UCODE      = X_UCODE
     and   CITY_ID    = X_CITY_ID
     and   YEAR       = X_YEAR;

end update_row;

procedure  insert_row( X_CITY_ID IN PR_VALUES.CITY_ID%TYPE
                     , X_UCODE IN PR_VALUES.UCODE%TYPE
                     , X_PROP_CLASS IN PR_VALUES.PROP_CLASS%TYPE
                     , X_YEAR IN PR_VALUES.YEAR%TYPE
                     , X_MIN_PRICE IN PR_VALUES.MIN_PRICE%TYPE
                     , X_MAX_PRICE IN PR_VALUES.MAX_PRICE%TYPE
                     , X_MEDIAN_PRICE IN PR_VALUES.MEDIAN_PRICE%TYPE
                     , X_RENT IN PR_VALUES.RENT%TYPE
					 , X_VACANCY_PERCENT IN PR_VALUES.VACANCY_PERCENT%TYPE
                     , X_REPLACEMENT IN PR_VALUES.REPLACEMENT%TYPE
                     , X_MAINTENANCE IN PR_VALUES.MAINTENANCE%TYPE
                     , X_MGT_PERCENT IN PR_VALUES.MGT_PERCENT%TYPE
                     , X_CAP_RATE IN PR_VALUES.CAP_RATE%TYPE
                     , X_UTILITIES IN PR_VALUES.UTILITIES%TYPE)
is
  x          number;
begin

     insert into PR_VALUES
     ( PROP_CLASS
     , UCODE
     , CITY_ID
     , YEAR
     , MIN_PRICE
     , MAX_PRICE
     , MEDIAN_PRICE
     , RENT
	 , VACANCY_PERCENT
     , REPLACEMENT
     , MAINTENANCE
     , MGT_PERCENT
     , CAP_RATE
     , UTILITIES)
     values
     ( X_PROP_CLASS
     , X_UCODE
     , X_CITY_ID
     , X_YEAR
     , X_MIN_PRICE
     , X_MAX_PRICE
     , X_MEDIAN_PRICE
     , X_RENT
	 , X_VACANCY_PERCENT
     , X_REPLACEMENT
     , X_MAINTENANCE
     , X_MGT_PERCENT
     , X_CAP_RATE
     , X_UTILITIES);

end insert_row;

procedure delete_row( X_CITY_ID IN PR_VALUES.CITY_ID%TYPE
                    , X_UCODE IN PR_VALUES.UCODE%TYPE
                    , X_PROP_CLASS IN PR_VALUES.PROP_CLASS%TYPE
                    , X_YEAR IN PR_VALUES.YEAR%TYPE) is
begin
    delete from PR_VALUES
    where PROP_CLASS = X_PROP_CLASS
    and   UCODE      = X_UCODE
    and   CITY_ID    = X_CITY_ID
    and   YEAR       = X_YEAR;

end delete_row;

end PR_VALUES_PKG;
/

show errors package PR_VALUES_PKG
show errors package body PR_VALUES_PKG
