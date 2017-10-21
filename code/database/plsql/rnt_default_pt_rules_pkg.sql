create or replace package RNT_DEFAULT_PT_RULES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_DEFAULT_PT_RULES_PKG
    Purpose:   API's for RNT_DEFAULT_PT_RULES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        26-MAR-09   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_PAYMENT_TYPE_ID IN RNT_DEFAULT_PT_RULES.PAYMENT_TYPE_ID%TYPE
                       , X_TRANSACTION_TYPE IN RNT_DEFAULT_PT_RULES.TRANSACTION_TYPE%TYPE)
            return RNT_DEFAULT_PT_RULES_V.CHECKSUM%TYPE;

  procedure update_row( X_PAYMENT_TYPE_ID IN RNT_DEFAULT_PT_RULES.PAYMENT_TYPE_ID%TYPE
                      , X_TRANSACTION_TYPE IN RNT_DEFAULT_PT_RULES.TRANSACTION_TYPE%TYPE
                      , X_DEBIT_ACCOUNT IN RNT_DEFAULT_PT_RULES.DEBIT_ACCOUNT%TYPE
                      , X_CREDIT_ACCOUNT IN RNT_DEFAULT_PT_RULES.CREDIT_ACCOUNT%TYPE
                      , X_CHECKSUM IN RNT_DEFAULT_PT_RULES_V.CHECKSUM%TYPE);

  procedure insert_row( X_PAYMENT_TYPE_ID IN RNT_DEFAULT_PT_RULES.PAYMENT_TYPE_ID%TYPE
                      , X_TRANSACTION_TYPE IN RNT_DEFAULT_PT_RULES.TRANSACTION_TYPE%TYPE
                      , X_DEBIT_ACCOUNT IN RNT_DEFAULT_PT_RULES.DEBIT_ACCOUNT%TYPE
                      , X_CREDIT_ACCOUNT IN RNT_DEFAULT_PT_RULES.CREDIT_ACCOUNT%TYPE);
           

  procedure delete_row( X_PAYMENT_TYPE_ID IN RNT_DEFAULT_PT_RULES.PAYMENT_TYPE_ID%TYPE
                       , X_TRANSACTION_TYPE IN RNT_DEFAULT_PT_RULES.TRANSACTION_TYPE%TYPE);

end RNT_DEFAULT_PT_RULES_PKG;
/

create or replace package body RNT_DEFAULT_PT_RULES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_DEFAULT_PT_RULES_PKG
    Purpose:   API's for RNT_DEFAULT_PT_RULES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        26-MAR-09   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_PAYMENT_TYPE_ID IN RNT_DEFAULT_PT_RULES.PAYMENT_TYPE_ID%TYPE
                    , X_TRANSACTION_TYPE IN RNT_DEFAULT_PT_RULES.TRANSACTION_TYPE%TYPE) is
     cursor c is
     select * from RNT_DEFAULT_PT_RULES
     where PAYMENT_TYPE_ID = X_PAYMENT_TYPE_ID
    and TRANSACTION_TYPE = X_TRANSACTION_TYPE
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
  function get_checksum( X_PAYMENT_TYPE_ID IN RNT_DEFAULT_PT_RULES.PAYMENT_TYPE_ID%TYPE
                       , X_TRANSACTION_TYPE IN RNT_DEFAULT_PT_RULES.TRANSACTION_TYPE%TYPE)
            return RNT_DEFAULT_PT_RULES_V.CHECKSUM%TYPE is 

    v_return_value               RNT_DEFAULT_PT_RULES_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_DEFAULT_PT_RULES_V
    where PAYMENT_TYPE_ID = X_PAYMENT_TYPE_ID
    and TRANSACTION_TYPE = X_TRANSACTION_TYPE;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_PAYMENT_TYPE_ID IN RNT_DEFAULT_PT_RULES.PAYMENT_TYPE_ID%TYPE
                      , X_TRANSACTION_TYPE IN RNT_DEFAULT_PT_RULES.TRANSACTION_TYPE%TYPE
                      , X_DEBIT_ACCOUNT IN RNT_DEFAULT_PT_RULES.DEBIT_ACCOUNT%TYPE
                      , X_CREDIT_ACCOUNT IN RNT_DEFAULT_PT_RULES.CREDIT_ACCOUNT%TYPE
                      , X_CHECKSUM IN RNT_DEFAULT_PT_RULES_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_DEFAULT_PT_RULES_V.CHECKSUM%TYPE;
  begin
     lock_row(X_PAYMENT_TYPE_ID, X_TRANSACTION_TYPE);

      -- validate checksum
      l_checksum := get_checksum(X_PAYMENT_TYPE_ID, X_TRANSACTION_TYPE);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;
     
     update RNT_DEFAULT_PT_RULES
     set TRANSACTION_TYPE = X_TRANSACTION_TYPE
     , DEBIT_ACCOUNT = X_DEBIT_ACCOUNT
     , CREDIT_ACCOUNT = X_CREDIT_ACCOUNT
     where PAYMENT_TYPE_ID = X_PAYMENT_TYPE_ID;

  end update_row;

  procedure insert_row( X_PAYMENT_TYPE_ID IN RNT_DEFAULT_PT_RULES.PAYMENT_TYPE_ID%TYPE
                      , X_TRANSACTION_TYPE IN RNT_DEFAULT_PT_RULES.TRANSACTION_TYPE%TYPE
                      , X_DEBIT_ACCOUNT IN RNT_DEFAULT_PT_RULES.DEBIT_ACCOUNT%TYPE
                      , X_CREDIT_ACCOUNT IN RNT_DEFAULT_PT_RULES.CREDIT_ACCOUNT%TYPE)
  is

  begin

     insert into RNT_DEFAULT_PT_RULES
     ( PAYMENT_TYPE_ID
     , TRANSACTION_TYPE
     , DEBIT_ACCOUNT
     , CREDIT_ACCOUNT)
     values
     ( X_PAYMENT_TYPE_ID
     , X_TRANSACTION_TYPE
     , X_DEBIT_ACCOUNT
     , X_CREDIT_ACCOUNT);

  end insert_row;

  procedure delete_row( X_PAYMENT_TYPE_ID IN RNT_DEFAULT_PT_RULES.PAYMENT_TYPE_ID%TYPE
                       , X_TRANSACTION_TYPE IN RNT_DEFAULT_PT_RULES.TRANSACTION_TYPE%TYPE) is

  begin
    delete from RNT_DEFAULT_PT_RULES
    where PAYMENT_TYPE_ID = X_PAYMENT_TYPE_ID
    and TRANSACTION_TYPE = X_TRANSACTION_TYPE;

  end delete_row;

end RNT_DEFAULT_PT_RULES_PKG;
/

show errors package RNT_DEFAULT_PT_RULES_PKG
show errors package body RNT_DEFAULT_PT_RULES_PKG
