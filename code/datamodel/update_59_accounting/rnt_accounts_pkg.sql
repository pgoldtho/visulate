create or replace package RNT_ACCOUNTS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_ACCOUNTS_PKG
    Purpose:   API's for RNT_ACCOUNTS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        26-MAR-09   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_ACCOUNT_ID IN RNT_ACCOUNTS.ACCOUNT_ID%TYPE)
            return RNT_ACCOUNTS_V.CHECKSUM%TYPE;

  procedure update_row( X_ACCOUNT_ID IN RNT_ACCOUNTS.ACCOUNT_ID%TYPE
                      , X_ACCOUNT_NUMBER IN RNT_ACCOUNTS.ACCOUNT_NUMBER%TYPE
                      , X_BUSINESS_ID IN RNT_ACCOUNTS.BUSINESS_ID%TYPE
                      , X_NAME IN RNT_ACCOUNTS.NAME%TYPE
                      , X_ACCOUNT_TYPE IN RNT_ACCOUNTS.ACCOUNT_TYPE%TYPE
                      , X_USER_ASSIGN_ID IN RNT_ACCOUNTS.USER_ASSIGN_ID%TYPE
                      , X_PEOPLE_BUSINESS_ID IN RNT_ACCOUNTS.PEOPLE_BUSINESS_ID%TYPE
                      , X_CURRENT_BALANCE_YN IN RNT_ACCOUNTS.CURRENT_BALANCE_YN%TYPE
                      , X_CHECKSUM IN RNT_ACCOUNTS_V.CHECKSUM%TYPE);

  function insert_row( X_ACCOUNT_NUMBER IN RNT_ACCOUNTS.ACCOUNT_NUMBER%TYPE
                     , X_BUSINESS_ID IN RNT_ACCOUNTS.BUSINESS_ID%TYPE
                     , X_NAME IN RNT_ACCOUNTS.NAME%TYPE
                     , X_ACCOUNT_TYPE IN RNT_ACCOUNTS.ACCOUNT_TYPE%TYPE
                     , X_USER_ASSIGN_ID IN RNT_ACCOUNTS.USER_ASSIGN_ID%TYPE
                     , X_PEOPLE_BUSINESS_ID IN RNT_ACCOUNTS.PEOPLE_BUSINESS_ID%TYPE
                     , X_CURRENT_BALANCE_YN IN RNT_ACCOUNTS.CURRENT_BALANCE_YN%TYPE)
              return RNT_ACCOUNTS.ACCOUNT_ID%TYPE;

  procedure delete_row( X_ACCOUNT_ID IN RNT_ACCOUNTS.ACCOUNT_ID%TYPE);


  procedure make_default_accounts(p_business_id in number);
  
end RNT_ACCOUNTS_PKG;
/
create or replace package body RNT_ACCOUNTS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_ACCOUNTS_PKG
    Purpose:   API's for RNT_ACCOUNTS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        26-MAR-09   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_ACCOUNT_ID IN RNT_ACCOUNTS.ACCOUNT_ID%TYPE) is
     cursor c is
     select * from RNT_ACCOUNTS
     where ACCOUNT_ID = X_ACCOUNT_ID
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
  function get_checksum( X_ACCOUNT_ID IN RNT_ACCOUNTS.ACCOUNT_ID%TYPE)
            return RNT_ACCOUNTS_V.CHECKSUM%TYPE is

    v_return_value               RNT_ACCOUNTS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_ACCOUNTS_V
    where ACCOUNT_ID = X_ACCOUNT_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_ACCOUNT_ID IN RNT_ACCOUNTS.ACCOUNT_ID%TYPE
                      , X_ACCOUNT_NUMBER IN RNT_ACCOUNTS.ACCOUNT_NUMBER%TYPE
                      , X_BUSINESS_ID IN RNT_ACCOUNTS.BUSINESS_ID%TYPE
                      , X_NAME IN RNT_ACCOUNTS.NAME%TYPE
                      , X_ACCOUNT_TYPE IN RNT_ACCOUNTS.ACCOUNT_TYPE%TYPE
                      , X_USER_ASSIGN_ID IN RNT_ACCOUNTS.USER_ASSIGN_ID%TYPE
                      , X_PEOPLE_BUSINESS_ID IN RNT_ACCOUNTS.PEOPLE_BUSINESS_ID%TYPE
                      , X_CURRENT_BALANCE_YN IN RNT_ACCOUNTS.CURRENT_BALANCE_YN%TYPE
                      , X_CHECKSUM IN RNT_ACCOUNTS_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_ACCOUNTS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_ACCOUNT_ID);

      -- validate checksum
      l_checksum := get_checksum(X_ACCOUNT_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

     update RNT_ACCOUNTS
     set ACCOUNT_NUMBER = X_ACCOUNT_NUMBER
     , BUSINESS_ID = X_BUSINESS_ID
     , NAME = X_NAME
     , ACCOUNT_TYPE = X_ACCOUNT_TYPE
     , USER_ASSIGN_ID = X_USER_ASSIGN_ID
     , PEOPLE_BUSINESS_ID = X_PEOPLE_BUSINESS_ID
     , CURRENT_BALANCE_YN = X_CURRENT_BALANCE_YN
     where ACCOUNT_ID = X_ACCOUNT_ID;

  end update_row;

  function insert_row( X_ACCOUNT_NUMBER IN RNT_ACCOUNTS.ACCOUNT_NUMBER%TYPE
                     , X_BUSINESS_ID IN RNT_ACCOUNTS.BUSINESS_ID%TYPE
                     , X_NAME IN RNT_ACCOUNTS.NAME%TYPE
                     , X_ACCOUNT_TYPE IN RNT_ACCOUNTS.ACCOUNT_TYPE%TYPE
                     , X_USER_ASSIGN_ID IN RNT_ACCOUNTS.USER_ASSIGN_ID%TYPE
                     , X_PEOPLE_BUSINESS_ID IN RNT_ACCOUNTS.PEOPLE_BUSINESS_ID%TYPE
                     , X_CURRENT_BALANCE_YN IN RNT_ACCOUNTS.CURRENT_BALANCE_YN%TYPE)
              return RNT_ACCOUNTS.ACCOUNT_ID%TYPE
  is
     x          number;
  begin

     insert into RNT_ACCOUNTS
     ( ACCOUNT_ID
     , ACCOUNT_NUMBER
     , BUSINESS_ID
     , NAME
     , ACCOUNT_TYPE
     , USER_ASSIGN_ID
     , PEOPLE_BUSINESS_ID
     , CURRENT_BALANCE_YN)
     values
     ( RNT_ACCOUNTS_SEQ.NEXTVAL
     , X_ACCOUNT_NUMBER
     , X_BUSINESS_ID
     , X_NAME
     , X_ACCOUNT_TYPE
     , X_USER_ASSIGN_ID
     , X_PEOPLE_BUSINESS_ID
     , X_CURRENT_BALANCE_YN)
     returning ACCOUNT_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_ACCOUNT_ID IN RNT_ACCOUNTS.ACCOUNT_ID%TYPE) is

  begin
    delete from RNT_ACCOUNTS
    where ACCOUNT_ID = X_ACCOUNT_ID;

  end delete_row;



procedure make_default_accounts(p_business_id in number)
is
begin
    insert into rnt_accounts
           (account_id,
            account_number,
            business_id,
            name,
            account_type,
            current_balance_yn,
            user_assign_id,
            people_business_id)
    select  rnt_accounts_seq.nextval as account_id, 
            account_number,
            p_business_id,
            name,
            account_type,
            current_balance_yn,
            to_number(null) as user_assign_id,
            to_number(null) as people_business_id
    from    rnt_default_accounts;
    --
    commit;
end make_default_accounts;


end RNT_ACCOUNTS_PKG;
/
