create or replace package RNT_PT_RULES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_PT_RULES_PKG
    Purpose:   API's for RNT_PT_RULES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        26-MAR-09   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_BUSINESS_ID IN RNT_PT_RULES.BUSINESS_ID%TYPE
                       , X_PAYMENT_TYPE_ID IN RNT_PT_RULES.PAYMENT_TYPE_ID%TYPE
                       , X_TRANSACTION_TYPE IN RNT_PT_RULES.TRANSACTION_TYPE%TYPE)
            return RNT_PT_RULES_V.CHECKSUM%TYPE;

  procedure update_row( X_BUSINESS_ID IN RNT_PT_RULES.BUSINESS_ID%TYPE
                      , X_PAYMENT_TYPE_ID IN RNT_PT_RULES.PAYMENT_TYPE_ID%TYPE
                      , X_TRANSACTION_TYPE IN RNT_PT_RULES.TRANSACTION_TYPE%TYPE
                      , X_DEBIT_ACCOUNT IN RNT_PT_RULES.DEBIT_ACCOUNT%TYPE
                      , X_CREDIT_ACCOUNT IN RNT_PT_RULES.CREDIT_ACCOUNT%TYPE
                      , X_CHECKSUM IN RNT_PT_RULES_V.CHECKSUM%TYPE);

  procedure insert_row( X_BUSINESS_ID IN RNT_PT_RULES.BUSINESS_ID%TYPE
                      , X_PAYMENT_TYPE_ID IN RNT_PT_RULES.PAYMENT_TYPE_ID%TYPE
                      , X_TRANSACTION_TYPE IN RNT_PT_RULES.TRANSACTION_TYPE%TYPE
                      , X_DEBIT_ACCOUNT IN RNT_PT_RULES.DEBIT_ACCOUNT%TYPE
                      , X_CREDIT_ACCOUNT IN RNT_PT_RULES.CREDIT_ACCOUNT%TYPE);

  procedure delete_row( X_BUSINESS_ID IN RNT_PT_RULES.BUSINESS_ID%TYPE
                       , X_PAYMENT_TYPE_ID IN RNT_PT_RULES.PAYMENT_TYPE_ID%TYPE
                       , X_TRANSACTION_TYPE IN RNT_PT_RULES.TRANSACTION_TYPE%TYPE);


  procedure make_default_rules(p_business_id in number);
  
end RNT_PT_RULES_PKG;
/                                                                                                                                                                                                         
create or replace package body RNT_PT_RULES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_PT_RULES_PKG
    Purpose:   API's for RNT_PT_RULES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        26-MAR-09   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_BUSINESS_ID IN RNT_PT_RULES.BUSINESS_ID%TYPE
                    , X_PAYMENT_TYPE_ID IN RNT_PT_RULES.PAYMENT_TYPE_ID%TYPE
                    , X_TRANSACTION_TYPE IN RNT_PT_RULES.TRANSACTION_TYPE%TYPE) is
     cursor c is
     select * from RNT_PT_RULES
     where BUSINESS_ID = X_BUSINESS_ID
    and PAYMENT_TYPE_ID = X_PAYMENT_TYPE_ID
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
  function get_checksum( X_BUSINESS_ID IN RNT_PT_RULES.BUSINESS_ID%TYPE
                       , X_PAYMENT_TYPE_ID IN RNT_PT_RULES.PAYMENT_TYPE_ID%TYPE
                       , X_TRANSACTION_TYPE IN RNT_PT_RULES.TRANSACTION_TYPE%TYPE)
            return RNT_PT_RULES_V.CHECKSUM%TYPE is

    v_return_value               RNT_PT_RULES_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_PT_RULES_V
    where BUSINESS_ID = X_BUSINESS_ID
    and PAYMENT_TYPE_ID = X_PAYMENT_TYPE_ID
    and TRANSACTION_TYPE = X_TRANSACTION_TYPE;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_BUSINESS_ID IN RNT_PT_RULES.BUSINESS_ID%TYPE
                      , X_PAYMENT_TYPE_ID IN RNT_PT_RULES.PAYMENT_TYPE_ID%TYPE
                      , X_TRANSACTION_TYPE IN RNT_PT_RULES.TRANSACTION_TYPE%TYPE
                      , X_DEBIT_ACCOUNT IN RNT_PT_RULES.DEBIT_ACCOUNT%TYPE
                      , X_CREDIT_ACCOUNT IN RNT_PT_RULES.CREDIT_ACCOUNT%TYPE
                      , X_CHECKSUM IN RNT_PT_RULES_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_PT_RULES_V.CHECKSUM%TYPE;
  begin
     lock_row(X_BUSINESS_ID, X_PAYMENT_TYPE_ID, X_TRANSACTION_TYPE);

      -- validate checksum
      l_checksum := get_checksum(X_BUSINESS_ID, X_PAYMENT_TYPE_ID, X_TRANSACTION_TYPE);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

     update RNT_PT_RULES
     set PAYMENT_TYPE_ID = X_PAYMENT_TYPE_ID
     , TRANSACTION_TYPE = X_TRANSACTION_TYPE
     , DEBIT_ACCOUNT = X_DEBIT_ACCOUNT
     , CREDIT_ACCOUNT = X_CREDIT_ACCOUNT
     where BUSINESS_ID = X_BUSINESS_ID
     and   PAYMENT_TYPE_ID = X_PAYMENT_TYPE_ID
     and   TRANSACTION_TYPE = X_TRANSACTION_TYPE;

  end update_row;

  procedure insert_row( X_BUSINESS_ID IN RNT_PT_RULES.BUSINESS_ID%TYPE
                      , X_PAYMENT_TYPE_ID IN RNT_PT_RULES.PAYMENT_TYPE_ID%TYPE
                      , X_TRANSACTION_TYPE IN RNT_PT_RULES.TRANSACTION_TYPE%TYPE
                      , X_DEBIT_ACCOUNT IN RNT_PT_RULES.DEBIT_ACCOUNT%TYPE
                      , X_CREDIT_ACCOUNT IN RNT_PT_RULES.CREDIT_ACCOUNT%TYPE)
  is
     x          number;
  begin

     insert into RNT_PT_RULES
     ( BUSINESS_ID
     , PAYMENT_TYPE_ID
     , TRANSACTION_TYPE
     , DEBIT_ACCOUNT
     , CREDIT_ACCOUNT)
     values
     ( X_BUSINESS_ID 
     , X_PAYMENT_TYPE_ID
     , X_TRANSACTION_TYPE
     , X_DEBIT_ACCOUNT
     , X_CREDIT_ACCOUNT);

  end insert_row;

  procedure delete_row( X_BUSINESS_ID IN RNT_PT_RULES.BUSINESS_ID%TYPE
                       , X_PAYMENT_TYPE_ID IN RNT_PT_RULES.PAYMENT_TYPE_ID%TYPE
                       , X_TRANSACTION_TYPE IN RNT_PT_RULES.TRANSACTION_TYPE%TYPE) is

  begin
    delete from RNT_PT_RULES
    where BUSINESS_ID = X_BUSINESS_ID
    and PAYMENT_TYPE_ID = X_PAYMENT_TYPE_ID
    and TRANSACTION_TYPE = X_TRANSACTION_TYPE;

  end delete_row;


procedure make_default_rules(p_business_id in number)
is
begin
    insert into rnt_pt_rules
           (business_id,
            payment_type_id,
            transaction_type,
            debit_account,
            credit_account)
    select p_business_id as business_id,
           dptr.payment_type_id,
           dptr.transaction_type,
           da.account_id as debit_account,
           ca.account_id as credit_account
    from   rnt_default_pt_rules dptr,
           rnt_accounts da,
           rnt_accounts ca
    where  dptr.credit_account = ca.account_number
    and    dptr.debit_account  = da.account_number;
    --
    commit;
end;

end RNT_PT_RULES_PKG;
/
    
show errors package RNT_PT_RULES_PKG                                                            
show errors package body RNT_PT_RULES_PKG                                                       
