create or replace package RNT_DEFAULT_ACCOUNTS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_DEFAULT_ACCOUNTS_PKG
    Purpose:   API's for RNT_DEFAULT_ACCOUNTS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        26-MAR-09   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_ACCOUNT_NUMBER IN RNT_DEFAULT_ACCOUNTS.ACCOUNT_NUMBER%TYPE)
            return RNT_DEFAULT_ACCOUNTS_V.CHECKSUM%TYPE;

  procedure update_row( X_ACCOUNT_NUMBER IN RNT_DEFAULT_ACCOUNTS.ACCOUNT_NUMBER%TYPE
                      , X_NAME IN RNT_DEFAULT_ACCOUNTS.NAME%TYPE
                      , X_ACCOUNT_TYPE IN RNT_DEFAULT_ACCOUNTS.ACCOUNT_TYPE%TYPE
                      , X_CURRENT_BALANCE_YN IN RNT_DEFAULT_ACCOUNTS.CURRENT_BALANCE_YN%TYPE
                      , X_CHECKSUM IN RNT_DEFAULT_ACCOUNTS_V.CHECKSUM%TYPE
);

  function insert_row( X_NAME IN RNT_DEFAULT_ACCOUNTS.NAME%TYPE
                     , X_ACCOUNT_TYPE IN RNT_DEFAULT_ACCOUNTS.ACCOUNT_TYPE%TYPE
                     , X_CURRENT_BALANCE_YN IN RNT_DEFAULT_ACCOUNTS.CURRENT_BALANCE_YN%TYPE)
              return RNT_DEFAULT_ACCOUNTS.ACCOUNT_NUMBER%TYPE;

  procedure delete_row( X_ACCOUNT_NUMBER IN RNT_DEFAULT_ACCOUNTS.ACCOUNT_NUMBER%TYPE);

end RNT_DEFAULT_ACCOUNTS_PKG;
/                                                                                                                                                                                                                                                                                                          
create or replace package body RNT_DEFAULT_ACCOUNTS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_DEFAULT_ACCOUNTS_PKG
    Purpose:   API's for RNT_DEFAULT_ACCOUNTS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        26-MAR-09   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_ACCOUNT_NUMBER IN RNT_DEFAULT_ACCOUNTS.ACCOUNT_NUMBER%TYPE) is
     cursor c is
     select * from RNT_DEFAULT_ACCOUNTS
     where ACCOUNT_NUMBER = X_ACCOUNT_NUMBER
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
  function get_checksum( X_ACCOUNT_NUMBER IN RNT_DEFAULT_ACCOUNTS.ACCOUNT_NUMBER%TYPE)
            return RNT_DEFAULT_ACCOUNTS_V.CHECKSUM%TYPE is 

    v_return_value               RNT_DEFAULT_ACCOUNTS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_DEFAULT_ACCOUNTS_V
    where ACCOUNT_NUMBER = X_ACCOUNT_NUMBER;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_ACCOUNT_NUMBER IN RNT_DEFAULT_ACCOUNTS.ACCOUNT_NUMBER%TYPE
                      , X_NAME IN RNT_DEFAULT_ACCOUNTS.NAME%TYPE
                      , X_ACCOUNT_TYPE IN RNT_DEFAULT_ACCOUNTS.ACCOUNT_TYPE%TYPE
                      , X_CURRENT_BALANCE_YN IN RNT_DEFAULT_ACCOUNTS.CURRENT_BALANCE_YN%TYPE
                      , X_CHECKSUM IN RNT_DEFAULT_ACCOUNTS_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_DEFAULT_ACCOUNTS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_ACCOUNT_NUMBER);

      -- validate checksum
      l_checksum := get_checksum(X_ACCOUNT_NUMBER);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;
     
     update RNT_DEFAULT_ACCOUNTS
     set NAME = X_NAME
     , ACCOUNT_TYPE = X_ACCOUNT_TYPE
     , CURRENT_BALANCE_YN = X_CURRENT_BALANCE_YN
     where ACCOUNT_NUMBER = X_ACCOUNT_NUMBER;

  end update_row;

  function insert_row( X_NAME IN RNT_DEFAULT_ACCOUNTS.NAME%TYPE
                     , X_ACCOUNT_TYPE IN RNT_DEFAULT_ACCOUNTS.ACCOUNT_TYPE%TYPE
                     , X_CURRENT_BALANCE_YN IN RNT_DEFAULT_ACCOUNTS.CURRENT_BALANCE_YN%TYPE)
              return RNT_DEFAULT_ACCOUNTS.ACCOUNT_NUMBER%TYPE
  is
     x          number;
  begin

     insert into RNT_DEFAULT_ACCOUNTS
     ( ACCOUNT_NUMBER
     , NAME
     , ACCOUNT_TYPE
     , CURRENT_BALANCE_YN)
     values
     ( RNT_DEFAULT_ACCOUNTS_SEQ.NEXTVAL
     , X_NAME
     , X_ACCOUNT_TYPE
     , X_CURRENT_BALANCE_YN)
     returning ACCOUNT_NUMBER into x;

     return x;
  end insert_row;

  procedure delete_row( X_ACCOUNT_NUMBER IN RNT_DEFAULT_ACCOUNTS.ACCOUNT_NUMBER%TYPE) is

  begin
    delete from RNT_DEFAULT_ACCOUNTS
    where ACCOUNT_NUMBER = X_ACCOUNT_NUMBER;

  end delete_row;

end RNT_DEFAULT_ACCOUNTS_PKG;
/
                                                                                                     
show errors package RNT_DEFAULT_ACCOUNTS_PKG                                                         
show errors package body RNT_DEFAULT_ACCOUNTS_PKG                                                                                                                                                         