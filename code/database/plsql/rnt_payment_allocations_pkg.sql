CREATE OR REPLACE package        RNT_PAYMENT_ALLOCATIONS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_PAYMENT_ALLOCATIONS_PKG
    Purpose:   API's for RNT_PAYMENT_ALLOCATIONS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        14-MAY-07   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_PAY_ALLOC_ID IN RNT_PAYMENT_ALLOCATIONS.PAY_ALLOC_ID%TYPE)
            return RNT_PAYMENT_ALLOCATIONS_V.CHECKSUM%TYPE;

  procedure update_row( X_PAY_ALLOC_ID IN RNT_PAYMENT_ALLOCATIONS.PAY_ALLOC_ID%TYPE
                      , X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE
                      , X_AMOUNT IN RNT_PAYMENT_ALLOCATIONS.AMOUNT%TYPE
                      , X_AR_ID IN RNT_PAYMENT_ALLOCATIONS.AR_ID%TYPE
                      , X_AP_ID IN RNT_PAYMENT_ALLOCATIONS.AP_ID%TYPE
                      , X_PAYMENT_ID IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_ID%TYPE
                      , X_CHECKSUM IN RNT_PAYMENT_ALLOCATIONS_V.CHECKSUM%TYPE);

  function insert_row( X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE
                     , X_AMOUNT IN RNT_PAYMENT_ALLOCATIONS.AMOUNT%TYPE
                     , X_AR_ID IN RNT_PAYMENT_ALLOCATIONS.AR_ID%TYPE
                     , X_AP_ID IN RNT_PAYMENT_ALLOCATIONS.AP_ID%TYPE
                     , X_PAYMENT_ID IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_ID%TYPE)
              return RNT_PAYMENT_ALLOCATIONS.PAY_ALLOC_ID%TYPE;
 /*             
  function insert_receivable_row( X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE
                     , X_AMOUNT IN RNT_PAYMENT_ALLOCATIONS.AMOUNT%TYPE
                     , X_AR_ID IN RNT_PAYMENT_ALLOCATIONS.AR_ID%TYPE
                     , X_AP_ID IN RNT_PAYMENT_ALLOCATIONS.AP_ID%TYPE
                     , X_PAYMENT_ID IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_ID%TYPE)
              return RNT_PAYMENT_ALLOCATIONS.PAY_ALLOC_ID%TYPE;
   */           
  procedure delete_row( X_PAY_ALLOC_ID IN RNT_PAYMENT_ALLOCATIONS.PAY_ALLOC_ID%TYPE);
  
  --procedure delete_receivable_row( X_PAY_ALLOC_ID IN RNT_PAYMENT_ALLOCATIONS.PAY_ALLOC_ID%TYPE);
end RNT_PAYMENT_ALLOCATIONS_PKG;
/


CREATE OR REPLACE package body        RNT_PAYMENT_ALLOCATIONS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_PAYMENT_ALLOCATIONS_PKG
    Purpose:   API's for RNT_PAYMENT_ALLOCATIONS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        14-MAY-07   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_PAY_ALLOC_ID IN RNT_PAYMENT_ALLOCATIONS.PAY_ALLOC_ID%TYPE) is
     cursor c is
     select * from RNT_PAYMENT_ALLOCATIONS
     where PAY_ALLOC_ID = X_PAY_ALLOC_ID
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
  function get_checksum( X_PAY_ALLOC_ID IN RNT_PAYMENT_ALLOCATIONS.PAY_ALLOC_ID%TYPE)
            return RNT_PAYMENT_ALLOCATIONS_V.CHECKSUM%TYPE is 

    v_return_value               RNT_PAYMENT_ALLOCATIONS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_PAYMENT_ALLOCATIONS_V
    where PAY_ALLOC_ID = X_PAY_ALLOC_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_PAY_ALLOC_ID IN RNT_PAYMENT_ALLOCATIONS.PAY_ALLOC_ID%TYPE
                      , X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE
                      , X_AMOUNT IN RNT_PAYMENT_ALLOCATIONS.AMOUNT%TYPE
                      , X_AR_ID IN RNT_PAYMENT_ALLOCATIONS.AR_ID%TYPE
                      , X_AP_ID IN RNT_PAYMENT_ALLOCATIONS.AP_ID%TYPE
                      , X_PAYMENT_ID IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_ID%TYPE
                      , X_CHECKSUM IN RNT_PAYMENT_ALLOCATIONS_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_PAYMENT_ALLOCATIONS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_PAY_ALLOC_ID);

      -- validate checksum
      l_checksum := get_checksum(X_PAY_ALLOC_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;
     
     update RNT_PAYMENT_ALLOCATIONS
     set PAYMENT_DATE = X_PAYMENT_DATE
     , AMOUNT = X_AMOUNT
     , AR_ID = X_AR_ID
     , AP_ID = X_AP_ID
     , PAYMENT_ID = X_PAYMENT_ID
     where PAY_ALLOC_ID = X_PAY_ALLOC_ID;

  end update_row;

  function insert_row( X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE
                     , X_AMOUNT IN RNT_PAYMENT_ALLOCATIONS.AMOUNT%TYPE
                     , X_AR_ID IN RNT_PAYMENT_ALLOCATIONS.AR_ID%TYPE
                     , X_AP_ID IN RNT_PAYMENT_ALLOCATIONS.AP_ID%TYPE
                     , X_PAYMENT_ID IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_ID%TYPE)
              return RNT_PAYMENT_ALLOCATIONS.PAY_ALLOC_ID%TYPE
  is
     x          number;
  begin
     if (X_AR_ID is not null) then
         RNT_ACCOUNTS_RECEIVABLE_PKG.UPDATE_PAYMENT_FROM_ALLOCATION(
                                     X_AMOUNT => X_AMOUNT, 
                                     X_PAYMENT_DATE => X_PAYMENT_DATE, 
                                     X_AR_ID => X_AR_ID);
     end if;
     
     insert into RNT_PAYMENT_ALLOCATIONS
     ( PAY_ALLOC_ID
     , PAYMENT_DATE
     , AMOUNT
     , AR_ID
     , AP_ID
     , PAYMENT_ID)
     values
     ( RNT_PAYMENT_ALLOCATIONS_SEQ.NEXTVAL
     , X_PAYMENT_DATE
     , X_AMOUNT
     , X_AR_ID
     , X_AP_ID
     , X_PAYMENT_ID)
     returning PAY_ALLOC_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_PAY_ALLOC_ID IN RNT_PAYMENT_ALLOCATIONS.PAY_ALLOC_ID%TYPE) is
  x_ar_id NUMBER;
  begin
    select AR_ID
    into x_ar_id 
    from RNT_PAYMENT_ALLOCATIONS
    where PAY_ALLOC_ID = X_PAY_ALLOC_ID;
    
    delete from RNT_PAYMENT_ALLOCATIONS
    where PAY_ALLOC_ID = X_PAY_ALLOC_ID;
    
    if x_ar_id is not null then
        RNT_ACCOUNTS_RECEIVABLE_PKG.UPDATE_PAYMENT_FROM_ALLOCATION(
                                     X_AMOUNT => 0, 
                                     X_PAYMENT_DATE => NULL, 
                                     X_AR_ID => X_AR_ID);    
    end if;
  end delete_row;

 function insert_receivable_row( X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE
                     , X_AMOUNT IN RNT_PAYMENT_ALLOCATIONS.AMOUNT%TYPE
                     , X_AR_ID IN RNT_PAYMENT_ALLOCATIONS.AR_ID%TYPE
                     , X_AP_ID IN RNT_PAYMENT_ALLOCATIONS.AP_ID%TYPE
                     , X_PAYMENT_ID IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_ID%TYPE)
              return RNT_PAYMENT_ALLOCATIONS.PAY_ALLOC_ID%TYPE
  is
     x          number;
  begin
     if (X_AR_ID is not null) then
         RNT_ACCOUNTS_RECEIVABLE_PKG.UPDATE_PAYMENT_FROM_ALLOCATION(
                                     X_AMOUNT => X_AMOUNT, 
                                     X_PAYMENT_DATE => X_PAYMENT_DATE, 
                                     X_AR_ID => X_AR_ID);
     end if;
 
     return insert_row(X_PAYMENT_DATE => X_PAYMENT_DATE
                     , X_AMOUNT => X_AMOUNT
                     , X_AR_ID => X_AR_ID
                     , X_AP_ID => X_AP_ID
                     , X_PAYMENT_ID => X_PAYMENT_ID);
  end insert_receivable_row;

  procedure delete_receivable_row( X_PAY_ALLOC_ID IN RNT_PAYMENT_ALLOCATIONS.PAY_ALLOC_ID%TYPE) is
  x_ar_id NUMBER;
  begin
    select AR_ID
    into x_ar_id 
    from RNT_PAYMENT_ALLOCATIONS
    where PAY_ALLOC_ID = X_PAY_ALLOC_ID;
    
    delete from RNT_PAYMENT_ALLOCATIONS
    where PAY_ALLOC_ID = X_PAY_ALLOC_ID;
    
    if x_ar_id is not null then
        RNT_ACCOUNTS_RECEIVABLE_PKG.UPDATE_PAYMENT_FROM_ALLOCATION(
                                     X_AMOUNT => 0, 
                                     X_PAYMENT_DATE => NULL, 
                                     X_AR_ID => X_AR_ID);    
    end if;
  end delete_receivable_row;
   
end RNT_PAYMENT_ALLOCATIONS_PKG;
/


