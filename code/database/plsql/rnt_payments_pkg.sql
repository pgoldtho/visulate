CREATE OR REPLACE package        RNT_PAYMENTS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_PAYMENTS_PKG
    Purpose:   API's for RNT_PAYMENTS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        10-MAY-07   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_PAYMENT_ID IN RNT_PAYMENTS.PAYMENT_ID%TYPE)
            return RNT_PAYMENTS_V.CHECKSUM%TYPE;

  procedure update_row( X_PAYMENT_ID IN RNT_PAYMENTS.PAYMENT_ID%TYPE
                      , X_PAYMENT_DATE IN RNT_PAYMENTS.PAYMENT_DATE%TYPE
                      , X_DESCRIPTION IN RNT_PAYMENTS.DESCRIPTION%TYPE
                      , X_PAID_OR_RECEIVED IN RNT_PAYMENTS.PAID_OR_RECEIVED%TYPE
                      , X_AMOUNT IN RNT_PAYMENTS.AMOUNT%TYPE
                      , X_TENANT_ID IN RNT_PAYMENTS.TENANT_ID%TYPE
                      , X_BUSINESS_ID IN RNT_PAYMENTS.BUSINESS_ID%TYPE
                      , X_CHECKSUM IN RNT_PAYMENTS_V.CHECKSUM%TYPE);

  function insert_row( X_PAYMENT_DATE IN RNT_PAYMENTS.PAYMENT_DATE%TYPE
                     , X_DESCRIPTION IN RNT_PAYMENTS.DESCRIPTION%TYPE
                     , X_PAID_OR_RECEIVED IN RNT_PAYMENTS.PAID_OR_RECEIVED%TYPE
                     , X_AMOUNT IN RNT_PAYMENTS.AMOUNT%TYPE
                     , X_TENANT_ID IN RNT_PAYMENTS.TENANT_ID%TYPE
                     , X_BUSINESS_ID IN RNT_PAYMENTS.BUSINESS_ID%TYPE)
              return RNT_PAYMENTS.PAYMENT_ID%TYPE;

  procedure delete_row( X_PAYMENT_ID IN RNT_PAYMENTS.PAYMENT_ID%TYPE);
  
  procedure set_allocation(X_PAYMENT_ID IN RNT_PAYMENTS.PAYMENT_ID%TYPE, 
                           X_PAY_ALLOC_ID IN RNT_PAYMENT_ALLOCATIONS.PAY_ALLOC_ID%TYPE);
                           
  procedure generate_payment_list(X_BUSINESS_ID RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE);
                           
end RNT_PAYMENTS_PKG;
/


CREATE OR REPLACE package body        RNT_PAYMENTS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_PAYMENTS_PKG
    Purpose:   API's for RNT_PAYMENTS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        10-MAY-07   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------
  function check_unique( X_PAYMENT_ID IN RNT_PAYMENTS.PAYMENT_ID%TYPE
                       , X_PAYMENT_DATE IN RNT_PAYMENTS.PAYMENT_DATE%TYPE
                       , X_DESCRIPTION IN RNT_PAYMENTS.DESCRIPTION%TYPE) return boolean is
        cursor c is
        select PAYMENT_ID
        from RNT_PAYMENTS
        where PAYMENT_DATE = X_PAYMENT_DATE
    and DESCRIPTION = X_DESCRIPTION;

      begin
         for c_rec in c loop
           if (X_PAYMENT_ID is null OR c_rec.PAYMENT_ID != X_PAYMENT_ID) then
             return false;
           end if;
         end loop;
         return true;
      end check_unique;

  procedure lock_row( X_PAYMENT_ID IN RNT_PAYMENTS.PAYMENT_ID%TYPE) is
     cursor c is
     select * from RNT_PAYMENTS
     where PAYMENT_ID = X_PAYMENT_ID
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
  function get_checksum( X_PAYMENT_ID IN RNT_PAYMENTS.PAYMENT_ID%TYPE)
            return RNT_PAYMENTS_V.CHECKSUM%TYPE is 

    v_return_value               RNT_PAYMENTS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_PAYMENTS_V
    where PAYMENT_ID = X_PAYMENT_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_PAYMENT_ID IN RNT_PAYMENTS.PAYMENT_ID%TYPE
                      , X_PAYMENT_DATE IN RNT_PAYMENTS.PAYMENT_DATE%TYPE
                      , X_DESCRIPTION IN RNT_PAYMENTS.DESCRIPTION%TYPE
                      , X_PAID_OR_RECEIVED IN RNT_PAYMENTS.PAID_OR_RECEIVED%TYPE
                      , X_AMOUNT IN RNT_PAYMENTS.AMOUNT%TYPE
                      , X_TENANT_ID IN RNT_PAYMENTS.TENANT_ID%TYPE
                      , X_BUSINESS_ID IN RNT_PAYMENTS.BUSINESS_ID%TYPE
                      , X_CHECKSUM IN RNT_PAYMENTS_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_PAYMENTS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_PAYMENT_ID);

      -- validate checksum
      l_checksum := get_checksum(X_PAYMENT_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;
     
         if not check_unique(X_PAYMENT_ID, X_PAYMENT_DATE, X_DESCRIPTION) then
             RAISE_APPLICATION_ERROR(-20220, 'Update values must be unique.');
         end if;
     update RNT_PAYMENTS
     set PAYMENT_DATE = X_PAYMENT_DATE
     , DESCRIPTION = X_DESCRIPTION
     , PAID_OR_RECEIVED = X_PAID_OR_RECEIVED
     , AMOUNT = X_AMOUNT
     , TENANT_ID = X_TENANT_ID
     , BUSINESS_ID = X_BUSINESS_ID
     where PAYMENT_ID = X_PAYMENT_ID;

  end update_row;

  function insert_row( X_PAYMENT_DATE IN RNT_PAYMENTS.PAYMENT_DATE%TYPE
                     , X_DESCRIPTION IN RNT_PAYMENTS.DESCRIPTION%TYPE
                     , X_PAID_OR_RECEIVED IN RNT_PAYMENTS.PAID_OR_RECEIVED%TYPE
                     , X_AMOUNT IN RNT_PAYMENTS.AMOUNT%TYPE
                     , X_TENANT_ID IN RNT_PAYMENTS.TENANT_ID%TYPE
                     , X_BUSINESS_ID IN RNT_PAYMENTS.BUSINESS_ID%TYPE)
              return RNT_PAYMENTS.PAYMENT_ID%TYPE
  is
     x          number;
  begin
if not check_unique(NULL, X_PAYMENT_DATE, X_DESCRIPTION) then
         RAISE_APPLICATION_ERROR(-20221, 'Insert values must be unique.');
     end if;
  
     insert into RNT_PAYMENTS
     ( PAYMENT_ID
     , PAYMENT_DATE
     , DESCRIPTION
     , PAID_OR_RECEIVED
     , AMOUNT
     , TENANT_ID
     , BUSINESS_ID)
     values
     ( RNT_PAYMENTS_SEQ.NEXTVAL
     , X_PAYMENT_DATE
     , X_DESCRIPTION
     , X_PAID_OR_RECEIVED
     , X_AMOUNT
     , X_TENANT_ID
     , X_BUSINESS_ID)
     returning PAYMENT_ID into x;

     return x;
  end insert_row;
/*
function is_exists_allocation(X_PAYMENT_ID RNT_PAYMENTS.PAYMENT_ID%TYPE) return boolean
is
 x NUMBER;
begin
  select 1
  into x
  from DUAL
  where exists (select 1
                from RNT_PAYMENTS
                where PAYMENT_ID = X_PAYMENT_ID
                );
  return true;
exception
  when NO_DATA_FOUND then
     return false;   
end;
*/

  procedure delete_row( X_PAYMENT_ID IN RNT_PAYMENTS.PAYMENT_ID%TYPE) is

  begin
    /*
     if is_exists_allocation(X_PAYMENT_ID) then
      RAISE_APPLICATION_ERROR(-20004, 'Cannot delete record. Found payment allocation for record.');
    end if;
    */
    update RNT_PAYMENT_ALLOCATIONS
    set PAYMENT_ID = NULL
    where PAYMENT_ID = X_PAYMENT_ID; 
    
    delete from RNT_PAYMENTS
    where PAYMENT_ID = X_PAYMENT_ID;

  end delete_row;

  procedure set_allocation(X_PAYMENT_ID IN RNT_PAYMENTS.PAYMENT_ID%TYPE, 
                           X_PAY_ALLOC_ID IN RNT_PAYMENT_ALLOCATIONS.PAY_ALLOC_ID%TYPE)
  is
  begin
     update RNT_PAYMENT_ALLOCATIONS
     set PAYMENT_ID = X_PAYMENT_ID
     where PAY_ALLOC_ID = X_PAY_ALLOC_ID; 
  end;
  
  procedure generate_payment_list(X_BUSINESS_ID RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE)
  is
  cursor c is
        select a.DATE_AVAILABLE, 
               a.TERM,
               NVL(max_payment.MAX_PAYMENT_DATE, a.DATE_AVAILABLE) as MAX_PAYMENT_DATE,
               a.AMOUNT_PERIOD,
               a.DISCOUNT_AMOUNT,
               a.DISCOUNT_TYPE,
               a.DISCOUNT_PERIOD 
        from RNT_TENANCY_AGREEMENT_V a,
             RNT_PROPERTY_UNITS_V u,
             RNT_TENANT t,
             (select TENANT_ID, max(PAYMENT_DUE_DATE) as MAX_PAYMENT_DATE 
              from RNT_ACCOUNTS_RECEIVABLE 
              group by TENANT_ID) max_payment
        where a.UNIT_ID = u.UNIT_ID
          and a.AGREEMENT_ID = t.AGREEMENT_ID 
          and SYSDATE < a.END_DATE
          and decode(AMOUNT_PERIOD,
               'MONTH', ADD_MONTHS(SYSDATE, -1),
               'BI-MONTH', ADD_MONTHS(SYSDATE, -2),
               '2WEEKS', SYSDATE-14,
               'WEEK', SYSDATE-7
               ) > (select NVL(max(PAYMENT_DUE_DATE), a.DATE_AVAILABLE) 
                         from RNT_ACCOUNTS_RECEIVABLE 
                         where TENANT_ID = t.TENANT_ID)
         and max_payment.TENANT_ID(+) = t.TENANT_ID
         and u.BUSINESS_ID = X_BUSINESS_ID;   
  begin
    null;
  end;
                            
end RNT_PAYMENTS_PKG;
/


