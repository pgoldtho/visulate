create or replace package RNT_ACCOUNT_PERIODS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_ACCOUNT_PERIODS_PKG
    Purpose:   API's for RNT_ACCOUNT_PERIODS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        13-JUN-09   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_PERIOD_ID IN RNT_ACCOUNT_PERIODS.PERIOD_ID%TYPE)
            return RNT_ACCOUNT_PERIODS_V.CHECKSUM%TYPE;

  procedure update_row( X_PERIOD_ID IN RNT_ACCOUNT_PERIODS.PERIOD_ID%TYPE
                      , X_BUSINESS_ID IN RNT_ACCOUNT_PERIODS.BUSINESS_ID%TYPE
                      , X_START_DATE IN RNT_ACCOUNT_PERIODS.START_DATE%TYPE
                      , X_CLOSED_YN IN RNT_ACCOUNT_PERIODS.CLOSED_YN%TYPE
                      , X_CHECKSUM IN RNT_ACCOUNT_PERIODS_V.CHECKSUM%TYPE);

  function insert_row( X_BUSINESS_ID IN RNT_ACCOUNT_PERIODS.BUSINESS_ID%TYPE
                     , X_START_DATE IN RNT_ACCOUNT_PERIODS.START_DATE%TYPE
                     , X_CLOSED_YN IN RNT_ACCOUNT_PERIODS.CLOSED_YN%TYPE)
              return RNT_ACCOUNT_PERIODS.PERIOD_ID%TYPE;

  procedure delete_row( X_PERIOD_ID IN RNT_ACCOUNT_PERIODS.PERIOD_ID%TYPE);

end RNT_ACCOUNT_PERIODS_PKG;
/
create or replace package body RNT_ACCOUNT_PERIODS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_ACCOUNT_PERIODS_PKG
    Purpose:   API's for RNT_ACCOUNT_PERIODS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        13-JUN-09   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_PERIOD_ID IN RNT_ACCOUNT_PERIODS.PERIOD_ID%TYPE) is
     cursor c is
     select * from RNT_ACCOUNT_PERIODS
     where PERIOD_ID = X_PERIOD_ID
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
  function get_checksum( X_PERIOD_ID IN RNT_ACCOUNT_PERIODS.PERIOD_ID%TYPE)
            return RNT_ACCOUNT_PERIODS_V.CHECKSUM%TYPE is

    v_return_value               RNT_ACCOUNT_PERIODS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_ACCOUNT_PERIODS_V
    where PERIOD_ID = X_PERIOD_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_PERIOD_ID IN RNT_ACCOUNT_PERIODS.PERIOD_ID%TYPE
                      , X_BUSINESS_ID IN RNT_ACCOUNT_PERIODS.BUSINESS_ID%TYPE
                      , X_START_DATE IN RNT_ACCOUNT_PERIODS.START_DATE%TYPE
                      , X_CLOSED_YN IN RNT_ACCOUNT_PERIODS.CLOSED_YN%TYPE
                      , X_CHECKSUM IN RNT_ACCOUNT_PERIODS_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_ACCOUNT_PERIODS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_PERIOD_ID);

      -- validate checksum
      l_checksum := get_checksum(X_PERIOD_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

     update RNT_ACCOUNT_PERIODS
     set BUSINESS_ID = X_BUSINESS_ID
     , START_DATE = X_START_DATE
     , CLOSED_YN = X_CLOSED_YN
     where PERIOD_ID = X_PERIOD_ID;

  end update_row;

  function insert_row( X_BUSINESS_ID IN RNT_ACCOUNT_PERIODS.BUSINESS_ID%TYPE
                     , X_START_DATE IN RNT_ACCOUNT_PERIODS.START_DATE%TYPE
                     , X_CLOSED_YN IN RNT_ACCOUNT_PERIODS.CLOSED_YN%TYPE)
              return RNT_ACCOUNT_PERIODS.PERIOD_ID%TYPE
  is
     x          number;
  begin

     insert into RNT_ACCOUNT_PERIODS
     ( PERIOD_ID
     , BUSINESS_ID
     , START_DATE
     , CLOSED_YN)
     values
     ( RNT_ACCOUNT_PERIODS_SEQ.NEXTVAL
     , X_BUSINESS_ID
     , X_START_DATE
     , X_CLOSED_YN)
     returning PERIOD_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_PERIOD_ID IN RNT_ACCOUNT_PERIODS.PERIOD_ID%TYPE) is

    v_business_id    rnt_account_periods.business_id%type;
    v_count          pls_integer;


  begin
    select business_id
    into v_business_id
    from rnt_account_periods
    where period_id = x_period_id;

    select count(*)
    into v_count
    from rnt_account_periods
    where business_id = v_business_id;

    if v_count = 1 then
       raise_application_error(-20905, 'Each business unit must have at least one accounting period;  This period cannot be deleted.');
    end if;


    delete from RNT_ACCOUNT_BALANCES
    where PERIOD_ID = X_PERIOD_ID;


    delete from RNT_ACCOUNT_PERIODS
    where PERIOD_ID = X_PERIOD_ID;

  end delete_row;

end RNT_ACCOUNT_PERIODS_PKG;
/

show errors package RNT_ACCOUNT_PERIODS_PKG
show errors package body RNT_ACCOUNT_PERIODS_PKG