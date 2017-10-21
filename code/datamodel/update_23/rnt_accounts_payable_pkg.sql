CREATE OR REPLACE package        RNT_ACCOUNTS_PAYABLE_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_ACCOUNTS_PAYABLE_PKG
    Purpose:   API's for RNT_ACCOUNTS_PAYABLE table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        06-MAY-07   Auto Generated   Initial Version
*******************************************************************************/

  function get_checksum( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE)
            return RNT_ACCOUNTS_PAYABLE_V.CHECKSUM%TYPE;
            
  procedure VERIFY_CHECKSUM(X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE, 
                            X_CHECKSUM IN RNT_ACCOUNTS_PAYABLE_V.CHECKSUM%TYPE);            

  procedure update_row( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE
                      , X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_PAYABLE.PAYMENT_DUE_DATE%TYPE
                      , X_AMOUNT IN RNT_ACCOUNTS_PAYABLE.AMOUNT%TYPE
                      , X_PAYMENT_TYPE_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_TYPE_ID%TYPE
                      , X_EXPENSE_ID IN RNT_ACCOUNTS_PAYABLE.EXPENSE_ID%TYPE
                      , X_LOAN_ID IN RNT_ACCOUNTS_PAYABLE.LOAN_ID%TYPE
                      , X_SUPPLIER_ID IN RNT_ACCOUNTS_PAYABLE.SUPPLIER_ID%TYPE
                      , X_CHECKSUM IN RNT_ACCOUNTS_PAYABLE_V.CHECKSUM%TYPE
                      , X_PAYMENT_PROPERTY_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID%TYPE
                      , X_BUSINESS_ID IN RNT_ACCOUNTS_PAYABLE.BUSINESS_ID%TYPE
                      , X_RECORD_TYPE IN RNT_ACCOUNTS_PAYABLE.RECORD_TYPE%TYPE
                      , X_INVOICE_NUMBER RNT_ACCOUNTS_PAYABLE.INVOICE_NUMBER%TYPE
                      );

  function insert_row( X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_PAYABLE.PAYMENT_DUE_DATE%TYPE
                     , X_AMOUNT IN RNT_ACCOUNTS_PAYABLE.AMOUNT%TYPE
                     , X_PAYMENT_TYPE_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_TYPE_ID%TYPE
                     , X_EXPENSE_ID IN RNT_ACCOUNTS_PAYABLE.EXPENSE_ID%TYPE
                     , X_LOAN_ID IN RNT_ACCOUNTS_PAYABLE.LOAN_ID%TYPE
                     , X_SUPPLIER_ID IN RNT_ACCOUNTS_PAYABLE.SUPPLIER_ID%TYPE
                     , X_PAYMENT_PROPERTY_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID%TYPE
                     , X_BUSINESS_ID IN RNT_ACCOUNTS_PAYABLE.BUSINESS_ID%TYPE
                     , X_RECORD_TYPE IN RNT_ACCOUNTS_PAYABLE.RECORD_TYPE%TYPE
                     , X_INVOICE_NUMBER RNT_ACCOUNTS_PAYABLE.INVOICE_NUMBER%TYPE)
              return RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE;

  procedure delete_row( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE);

  function insert_row2( X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_PAYABLE.PAYMENT_DUE_DATE%TYPE
                       , X_AMOUNT IN RNT_ACCOUNTS_PAYABLE.AMOUNT%TYPE
                       , X_PAYMENT_TYPE_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_TYPE_ID%TYPE
                       , X_EXPENSE_ID IN RNT_ACCOUNTS_PAYABLE.EXPENSE_ID%TYPE
                       , X_LOAN_ID IN RNT_ACCOUNTS_PAYABLE.LOAN_ID%TYPE
                       , X_SUPPLIER_ID IN RNT_ACCOUNTS_PAYABLE.SUPPLIER_ID%TYPE
                       , X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE
                       , X_PAYMENT_PROPERTY_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID%TYPE
                       , X_BUSINESS_ID IN RNT_ACCOUNTS_PAYABLE.BUSINESS_ID%TYPE
                       , X_RECORD_TYPE IN RNT_ACCOUNTS_PAYABLE.RECORD_TYPE%TYPE
                       , X_INVOICE_NUMBER RNT_ACCOUNTS_PAYABLE.INVOICE_NUMBER%TYPE
                      )
              return RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE;                      

  procedure update_row2( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE
                       , X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_PAYABLE.PAYMENT_DUE_DATE%TYPE
                       , X_AMOUNT IN RNT_ACCOUNTS_PAYABLE.AMOUNT%TYPE
                       , X_PAYMENT_TYPE_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_TYPE_ID%TYPE
                       , X_EXPENSE_ID IN RNT_ACCOUNTS_PAYABLE.EXPENSE_ID%TYPE
                       , X_LOAN_ID IN RNT_ACCOUNTS_PAYABLE.LOAN_ID%TYPE
                       , X_SUPPLIER_ID IN RNT_ACCOUNTS_PAYABLE.SUPPLIER_ID%TYPE
                       , X_CHECKSUM IN RNT_ACCOUNTS_PAYABLE_V.CHECKSUM%TYPE
                       , X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE
                       , X_PAYMENT_PROPERTY_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID%TYPE
                       , X_BUSINESS_ID IN RNT_ACCOUNTS_PAYABLE.BUSINESS_ID%TYPE
                       , X_RECORD_TYPE IN RNT_ACCOUNTS_PAYABLE.RECORD_TYPE%TYPE
                       , X_INVOICE_NUMBER RNT_ACCOUNTS_PAYABLE.INVOICE_NUMBER%TYPE                       
                      );
                      
  procedure delete_row2( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE);
                      
  function get_date_by_recurring(x_daily varchar2, x_date DATE) return DATE;
  
  procedure generate_payment_list;                      
end RNT_ACCOUNTS_PAYABLE_PKG;
/


CREATE OR REPLACE package body        RNT_ACCOUNTS_PAYABLE_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_ACCOUNTS_PAYABLE_PKG
    Purpose:   API's for RNT_ACCOUNTS_PAYABLE table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        06-MAY-07   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------

  procedure lock_row( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE) is
     cursor c is
     select * from RNT_ACCOUNTS_PAYABLE
     where AP_ID = X_AP_ID
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
  function get_checksum( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE)
            return RNT_ACCOUNTS_PAYABLE_V.CHECKSUM%TYPE 
  is 
    v_return_value               RNT_ACCOUNTS_PAYABLE_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_ACCOUNTS_PAYABLE_ALL_V
    where AP_ID = X_AP_ID;
    return v_return_value;
  end get_checksum;

  procedure VERIFY_CHECKSUM(X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE, 
                            X_CHECKSUM IN RNT_ACCOUNTS_PAYABLE_V.CHECKSUM%TYPE)
  is
  begin
    if get_checksum(X_AP_ID) != X_CHECKSUM then
        RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
    end if;
  end;                                        

  procedure update_row( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE
                      , X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_PAYABLE.PAYMENT_DUE_DATE%TYPE
                      , X_AMOUNT IN RNT_ACCOUNTS_PAYABLE.AMOUNT%TYPE
                      , X_PAYMENT_TYPE_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_TYPE_ID%TYPE
                      , X_EXPENSE_ID IN RNT_ACCOUNTS_PAYABLE.EXPENSE_ID%TYPE
                      , X_LOAN_ID IN RNT_ACCOUNTS_PAYABLE.LOAN_ID%TYPE
                      , X_SUPPLIER_ID IN RNT_ACCOUNTS_PAYABLE.SUPPLIER_ID%TYPE
                      , X_CHECKSUM IN RNT_ACCOUNTS_PAYABLE_V.CHECKSUM%TYPE
                      , X_PAYMENT_PROPERTY_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID%TYPE
                      , X_BUSINESS_ID IN RNT_ACCOUNTS_PAYABLE.BUSINESS_ID%TYPE
                      , X_RECORD_TYPE IN RNT_ACCOUNTS_PAYABLE.RECORD_TYPE%TYPE
                      , X_INVOICE_NUMBER RNT_ACCOUNTS_PAYABLE.INVOICE_NUMBER%TYPE)
  is
     l_checksum          RNT_ACCOUNTS_PAYABLE_V.CHECKSUM%TYPE;
  begin
     lock_row(X_AP_ID);
      -- dont validate checksum - its validate in verify_checksum
      -- validate checksum
      /*
      l_checksum := get_checksum(X_AP_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;
      */
     
     update RNT_ACCOUNTS_PAYABLE
     set PAYMENT_DUE_DATE = X_PAYMENT_DUE_DATE
     , AMOUNT = X_AMOUNT
     , PAYMENT_TYPE_ID = X_PAYMENT_TYPE_ID
     , EXPENSE_ID = X_EXPENSE_ID
     , LOAN_ID = X_LOAN_ID
     , SUPPLIER_ID = X_SUPPLIER_ID
     , PAYMENT_PROPERTY_ID = X_PAYMENT_PROPERTY_ID
     , BUSINESS_ID = X_BUSINESS_ID
     , RECORD_TYPE = X_RECORD_TYPE
     , INVOICE_NUMBER = X_INVOICE_NUMBER 
     where AP_ID = X_AP_ID;

  end update_row;

  function insert_row( X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_PAYABLE.PAYMENT_DUE_DATE%TYPE
                     , X_AMOUNT IN RNT_ACCOUNTS_PAYABLE.AMOUNT%TYPE
                     , X_PAYMENT_TYPE_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_TYPE_ID%TYPE
                     , X_EXPENSE_ID IN RNT_ACCOUNTS_PAYABLE.EXPENSE_ID%TYPE
                     , X_LOAN_ID IN RNT_ACCOUNTS_PAYABLE.LOAN_ID%TYPE
                     , X_SUPPLIER_ID IN RNT_ACCOUNTS_PAYABLE.SUPPLIER_ID%TYPE
                     , X_PAYMENT_PROPERTY_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID%TYPE
                     , X_BUSINESS_ID IN RNT_ACCOUNTS_PAYABLE.BUSINESS_ID%TYPE
                     , X_RECORD_TYPE IN RNT_ACCOUNTS_PAYABLE.RECORD_TYPE%TYPE
                     , X_INVOICE_NUMBER RNT_ACCOUNTS_PAYABLE.INVOICE_NUMBER%TYPE
                     )
              return RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE
  is
     x          number;
  begin

     insert into RNT_ACCOUNTS_PAYABLE
     ( AP_ID
     , PAYMENT_DUE_DATE
     , AMOUNT
     , PAYMENT_TYPE_ID
     , EXPENSE_ID
     , LOAN_ID
     , SUPPLIER_ID
     , PAYMENT_PROPERTY_ID
     , BUSINESS_ID
     , RECORD_TYPE
     , INVOICE_NUMBER)
     values
     ( RNT_ACCOUNTS_PAYABLE_SEQ.NEXTVAL
     , X_PAYMENT_DUE_DATE
     , X_AMOUNT
     , X_PAYMENT_TYPE_ID
     , X_EXPENSE_ID
     , X_LOAN_ID
     , X_SUPPLIER_ID
     , X_PAYMENT_PROPERTY_ID
     , X_BUSINESS_ID
     , X_RECORD_TYPE
     , X_INVOICE_NUMBER)
     returning AP_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE) is

  begin
    lock_row(X_AP_ID);
    delete from RNT_ACCOUNTS_PAYABLE
    where AP_ID = X_AP_ID;
  end delete_row;
  
  procedure update_allocation(
                      X_AP_ID IN RNT_PAYMENT_ALLOCATIONS.AP_ID%TYPE 
                    , X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE
                    , X_AMOUNT IN RNT_PAYMENT_ALLOCATIONS.AMOUNT%TYPE
                   )
  is
  begin
  if X_PAYMENT_DATE is null then
      delete from RNT_PAYMENT_ALLOCATIONS
      where AP_ID =X_AP_ID; 
    else
      update RNT_PAYMENT_ALLOCATIONS
      set PAYMENT_DATE = X_PAYMENT_DATE,
          AMOUNT = X_AMOUNT
      where AP_ID = X_AP_ID;
      if SQL%ROWCOUNT = 0 then
         insert into RNT_PAYMENT_ALLOCATIONS (
                   PAY_ALLOC_ID, PAYMENT_DATE, AMOUNT, 
                   AR_ID, AP_ID, PAYMENT_ID) 
          values (RNT_PAYMENT_ALLOCATIONS_SEQ.NEXTVAL, X_PAYMENT_DATE, X_AMOUNT,
                  NULL, X_AP_ID, NULL);
      end if;    
    end if;   
  end;                   

  function insert_row2( X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_PAYABLE.PAYMENT_DUE_DATE%TYPE
                       , X_AMOUNT IN RNT_ACCOUNTS_PAYABLE.AMOUNT%TYPE
                       , X_PAYMENT_TYPE_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_TYPE_ID%TYPE
                       , X_EXPENSE_ID IN RNT_ACCOUNTS_PAYABLE.EXPENSE_ID%TYPE
                       , X_LOAN_ID IN RNT_ACCOUNTS_PAYABLE.LOAN_ID%TYPE
                       , X_SUPPLIER_ID IN RNT_ACCOUNTS_PAYABLE.SUPPLIER_ID%TYPE
                       , X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE
                       , X_PAYMENT_PROPERTY_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID%TYPE
                       , X_BUSINESS_ID IN RNT_ACCOUNTS_PAYABLE.BUSINESS_ID%TYPE
                       , X_RECORD_TYPE IN RNT_ACCOUNTS_PAYABLE.RECORD_TYPE%TYPE
                       , X_INVOICE_NUMBER RNT_ACCOUNTS_PAYABLE.INVOICE_NUMBER%TYPE
                      )
              return RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE
  is
  x RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE;
  begin
    x := insert_row(   X_PAYMENT_DUE_DATE => X_PAYMENT_DUE_DATE 
                     , X_AMOUNT => X_AMOUNT 
                     , X_PAYMENT_TYPE_ID => X_PAYMENT_TYPE_ID
                     , X_EXPENSE_ID => X_EXPENSE_ID
                     , X_LOAN_ID => X_LOAN_ID
                     , X_SUPPLIER_ID => X_SUPPLIER_ID
                     , X_PAYMENT_PROPERTY_ID => X_PAYMENT_PROPERTY_ID
                     , X_BUSINESS_ID => X_BUSINESS_ID
                     , X_RECORD_TYPE => X_RECORD_TYPE
                     , X_INVOICE_NUMBER => X_INVOICE_NUMBER);  
    update_allocation(X_AP_ID => x
                    , X_PAYMENT_DATE => X_PAYMENT_DATE
                    , X_AMOUNT => X_AMOUNT
                    );
    return x;                  
  end;                                    

  procedure update_row2( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE
                       , X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_PAYABLE.PAYMENT_DUE_DATE%TYPE
                       , X_AMOUNT IN RNT_ACCOUNTS_PAYABLE.AMOUNT%TYPE
                       , X_PAYMENT_TYPE_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_TYPE_ID%TYPE
                       , X_EXPENSE_ID IN RNT_ACCOUNTS_PAYABLE.EXPENSE_ID%TYPE
                       , X_LOAN_ID IN RNT_ACCOUNTS_PAYABLE.LOAN_ID%TYPE
                       , X_SUPPLIER_ID IN RNT_ACCOUNTS_PAYABLE.SUPPLIER_ID%TYPE
                       , X_CHECKSUM IN RNT_ACCOUNTS_PAYABLE_V.CHECKSUM%TYPE
                       , X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE
                       , X_PAYMENT_PROPERTY_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID%TYPE
                       , X_BUSINESS_ID IN RNT_ACCOUNTS_PAYABLE.BUSINESS_ID%TYPE
                       , X_RECORD_TYPE IN RNT_ACCOUNTS_PAYABLE.RECORD_TYPE%TYPE
                       , X_INVOICE_NUMBER RNT_ACCOUNTS_PAYABLE.INVOICE_NUMBER%TYPE 
                       )
  is
  begin
    update_row( X_AP_ID => X_AP_ID 
              , X_PAYMENT_DUE_DATE => X_PAYMENT_DUE_DATE
              , X_AMOUNT => X_AMOUNT
              , X_PAYMENT_TYPE_ID => X_PAYMENT_TYPE_ID
              , X_EXPENSE_ID => X_EXPENSE_ID
              , X_LOAN_ID => X_LOAN_ID
              , X_SUPPLIER_ID => X_SUPPLIER_ID
              , X_CHECKSUM => X_CHECKSUM
              , X_PAYMENT_PROPERTY_ID => X_PAYMENT_PROPERTY_ID
              , X_BUSINESS_ID => X_BUSINESS_ID
              , X_RECORD_TYPE => X_RECORD_TYPE
              , X_INVOICE_NUMBER => X_INVOICE_NUMBER
              );
    update_allocation(X_AP_ID => X_AP_ID
                    , X_PAYMENT_DATE => X_PAYMENT_DATE
                    , X_AMOUNT => X_AMOUNT
                      );               
  end;
  
  procedure delete_row2( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE)
  is
  begin
    lock_row(X_AP_ID);
    
    delete from RNT_PAYMENT_ALLOCATIONS
    where AP_ID = X_AP_ID;
     
    delete_row(X_AP_ID);
  end;
  
  function get_date_by_recurring(x_daily varchar2, x_date DATE) return DATE
  is
  begin
     case x_daily  
       when 'D' then return x_date + 1;
       when 'W' then return x_date + 7;
       when 'BW' then return x_date + 14;
       when 'HM' then return ADD_MONTHS(x_date, 0.5);
       when 'M' then return ADD_MONTHS(x_date, 1);
       when 'BM' then return ADD_MONTHS(x_date, 2); 
       when 'Q' then return ADD_MONTHS(x_date, 3);
       when 'TY' then return ADD_MONTHS(x_date, 6);
       else RAISE_APPLICATION_ERROR(-20023, 'Unknown type of recurring period');  
     end case;
      
  end;     
  
  function generate_payments return NUMBER
  is
     cursor c is
        select ap.PAYMENT_DUE_DATE, ap.SUPPLIER_ID, e.EXPENSE_ID,
               RNT_ACCOUNTS_PAYABLE_PKG.GET_DATE_BY_RECURRING(e.RECURRING_PERIOD, ap.PAYMENT_DUE_DATE) as PAYMENT_NEXT_DATE,
               ap.AP_ID as SOURCE_AP_ID,
               e.RECURRING_PERIOD,
               ap.AMOUNT, 
               ap.PAYMENT_TYPE_ID, 
               ap.LOAN_ID, 
               ap.PAYMENT_PROPERTY_ID,
               ap.INVOICE_NUMBER,
               e.RECURRING_ENDDATE,
               ap.BUSINESS_ID
        from RNT_PROPERTY_EXPENSES e,
             RNT_ACCOUNTS_PAYABLE ap
        where e.RECURRING_YN = 'Y'
          and ap.EXPENSE_ID = e.EXPENSE_ID
          and ap.PAYMENT_DUE_DATE = (select max(PAYMENT_DUE_DATE) 
                                     from RNT_ACCOUNTS_PAYABLE 
                                     where EXPENSE_ID = e.EXPENSE_ID
                                       and SUPPLIER_ID = ap.SUPPLIER_ID
                                       and PAYMENT_TYPE_ID = ap.PAYMENT_TYPE_ID)
          and RNT_ACCOUNTS_PAYABLE_PKG.GET_DATE_BY_RECURRING(e.RECURRING_PERIOD, ap.PAYMENT_DUE_DATE) <= 
                                NVL(e.RECURRING_ENDDATE, to_date('4000', 'RRRR'))
          and RNT_ACCOUNTS_PAYABLE_PKG.GET_DATE_BY_RECURRING(e.RECURRING_PERIOD, ap.PAYMENT_DUE_DATE) <= SYSDATE+30;
    x_cnt NUMBER := 0;                                
  begin
    savepoint T_;  
    for x in c loop
       insert into RNT_ACCOUNTS_PAYABLE (
               AP_ID, PAYMENT_DUE_DATE, AMOUNT, 
               PAYMENT_TYPE_ID, EXPENSE_ID, LOAN_ID, 
               SUPPLIER_ID, PAYMENT_PROPERTY_ID, BUSINESS_ID, RECORD_TYPE, INVOICE_NUMBER) 
        values (RNT_ACCOUNTS_PAYABLE_SEQ.NEXTVAL, x.PAYMENT_NEXT_DATE, x.AMOUNT,
                x.PAYMENT_TYPE_ID, x.EXPENSE_ID, x.LOAN_ID, 
                x.SUPPLIER_ID, x.PAYMENT_PROPERTY_ID, x.BUSINESS_ID, RNT_ACCOUNTS_PAYABLE_CONST_PKG.CONST_GENERATE_TYPE_VAL(), x.INVOICE_NUMBER);
        x_cnt := x_cnt + 1;                  
     end loop;
    commit;
    return x_cnt;    
  exception
    when OTHERS then
       rollback to T_; 
       raise; 
  end;
  
  procedure generate_payment_list 
  is
    x NUMBER;
  begin
    for i in 1..30 loop
       x := generate_payments;
       exit when x = 0;
    end loop;
    --update_payment_list;
  end;
                      
end RNT_ACCOUNTS_PAYABLE_PKG;
/


