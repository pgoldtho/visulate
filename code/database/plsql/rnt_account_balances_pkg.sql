create or replace package RNT_ACCOUNT_BALANCES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_ACCOUNT_BALANCES_PKG
    Purpose:   API's for RNT_ACCOUNT_BALANCES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        13-JUN-09   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_ACCOUNT_ID IN RNT_ACCOUNT_BALANCES.ACCOUNT_ID%TYPE
                       , X_PERIOD_ID IN RNT_ACCOUNT_BALANCES.PERIOD_ID%TYPE)
            return RNT_ACCOUNT_BALANCES_V.CHECKSUM%TYPE;

  procedure update_row( X_ACCOUNT_ID IN RNT_ACCOUNT_BALANCES.ACCOUNT_ID%TYPE
                      , X_PERIOD_ID IN RNT_ACCOUNT_BALANCES.PERIOD_ID%TYPE
                      , X_OPENING_BALANCE IN RNT_ACCOUNT_BALANCES.OPENING_BALANCE%TYPE
                      , X_CHECKSUM IN RNT_ACCOUNT_BALANCES_V.CHECKSUM%TYPE);

  procedure insert_row( X_ACCOUNT_ID IN RNT_ACCOUNT_BALANCES.ACCOUNT_ID%TYPE
                      , X_PERIOD_ID IN RNT_ACCOUNT_BALANCES.PERIOD_ID%TYPE
                      , X_OPENING_BALANCE IN RNT_ACCOUNT_BALANCES.OPENING_BALANCE%TYPE);

  procedure delete_row( X_ACCOUNT_ID IN RNT_ACCOUNT_BALANCES.ACCOUNT_ID%TYPE
                       , X_PERIOD_ID IN RNT_ACCOUNT_BALANCES.PERIOD_ID%TYPE);

end RNT_ACCOUNT_BALANCES_PKG;
/
create or replace package body RNT_ACCOUNT_BALANCES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_ACCOUNT_BALANCES_PKG
    Purpose:   API's for RNT_ACCOUNT_BALANCES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        13-JUN-09   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_ACCOUNT_ID IN RNT_ACCOUNT_BALANCES.ACCOUNT_ID%TYPE
                       , X_PERIOD_ID IN RNT_ACCOUNT_BALANCES.PERIOD_ID%TYPE) is
     cursor c is
     select * from RNT_ACCOUNT_BALANCES
     where ACCOUNT_ID = X_ACCOUNT_ID
    and PERIOD_ID = X_PERIOD_ID
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
  function get_checksum( X_ACCOUNT_ID IN RNT_ACCOUNT_BALANCES.ACCOUNT_ID%TYPE
                       , X_PERIOD_ID IN RNT_ACCOUNT_BALANCES.PERIOD_ID%TYPE)
            return RNT_ACCOUNT_BALANCES_V.CHECKSUM%TYPE is

    v_return_value               RNT_ACCOUNT_BALANCES_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_ACCOUNT_BALANCES_V
    where ACCOUNT_ID = X_ACCOUNT_ID
    and PERIOD_ID = X_PERIOD_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_ACCOUNT_ID IN RNT_ACCOUNT_BALANCES.ACCOUNT_ID%TYPE
                      , X_PERIOD_ID IN RNT_ACCOUNT_BALANCES.PERIOD_ID%TYPE
                      , X_OPENING_BALANCE IN RNT_ACCOUNT_BALANCES.OPENING_BALANCE%TYPE
                      , X_CHECKSUM IN RNT_ACCOUNT_BALANCES_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_ACCOUNT_BALANCES_V.CHECKSUM%TYPE;
  begin
     lock_row(X_ACCOUNT_ID, X_PERIOD_ID);

      -- validate checksum
      l_checksum := get_checksum(X_ACCOUNT_ID, X_PERIOD_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

     update RNT_ACCOUNT_BALANCES
     set PERIOD_ID = X_PERIOD_ID
     , OPENING_BALANCE = X_OPENING_BALANCE
     where ACCOUNT_ID = X_ACCOUNT_ID;

  end update_row;

  procedure insert_row( X_ACCOUNT_ID IN RNT_ACCOUNT_BALANCES.ACCOUNT_ID%TYPE
                      , X_PERIOD_ID IN RNT_ACCOUNT_BALANCES.PERIOD_ID%TYPE
                      , X_OPENING_BALANCE IN RNT_ACCOUNT_BALANCES.OPENING_BALANCE%TYPE)
  is
     x          number;
  begin

     insert into RNT_ACCOUNT_BALANCES
     ( ACCOUNT_ID
     , PERIOD_ID
     , OPENING_BALANCE)
     values
     ( X_ACCOUNT_ID
     , X_PERIOD_ID
     , X_OPENING_BALANCE);

  end insert_row;

  procedure delete_row( X_ACCOUNT_ID IN RNT_ACCOUNT_BALANCES.ACCOUNT_ID%TYPE
                       , X_PERIOD_ID IN RNT_ACCOUNT_BALANCES.PERIOD_ID%TYPE) is

  begin
    delete from RNT_ACCOUNT_BALANCES
    where ACCOUNT_ID = X_ACCOUNT_ID
    and PERIOD_ID = X_PERIOD_ID;

  end delete_row;

end RNT_ACCOUNT_BALANCES_PKG;
/

show errors package RNT_ACCOUNT_BALANCES_PKG
show errors package body RNT_ACCOUNT_BALANCES_PKG
