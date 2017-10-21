--------------------------------------------------------------------------
-- Play this script in TESTRNTMGR@XE to make it look like RNTMGR@XE
--                                                                      --
-- Please review the script before using it to make sure it won't       --
-- cause any unacceptable data loss.                                    --
--                                                                      --
-- TESTRNTMGR@XE Schema Extracted by User TESTRNTMGR 
-- RNTMGR@XE Schema Extracted by User RNTMGR 
ALTER TABLE RNT_ACCOUNTS_PAYABLE
MODIFY(PAYMENT_PROPERTY_ID  NOT NULL);


CREATE OR REPLACE package body        RNT_PROPERTY_EXPENSES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_PROPERTY_EXPENSES_PKG
    Purpose:   API's for RNT_PROPERTY_EXPENSES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        06-MAY-07   Auto Generated   Initial Version

********************************************************************************/

-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------
  function check_unique( X_EXPENSE_ID IN RNT_PROPERTY_EXPENSES.EXPENSE_ID%TYPE
                       , X_PROPERTY_ID IN RNT_PROPERTY_EXPENSES.PROPERTY_ID%TYPE
                       , X_EVENT_DATE IN RNT_PROPERTY_EXPENSES.EVENT_DATE%TYPE
                       , X_UNIT_ID IN RNT_PROPERTY_EXPENSES.UNIT_ID%TYPE
                       , X_DESCRIPTION IN RNT_PROPERTY_EXPENSES.DESCRIPTION%TYPE) return boolean is
   cursor c is
    select EXPENSE_ID
    from RNT_PROPERTY_EXPENSES
    where PROPERTY_ID = X_PROPERTY_ID
      and EVENT_DATE = X_EVENT_DATE
      and UNIT_ID = X_UNIT_ID
      and DESCRIPTION = X_DESCRIPTION;
  begin
     for c_rec in c loop
       if (X_EXPENSE_ID is null OR c_rec.EXPENSE_ID != X_EXPENSE_ID) then
         return false;
       end if;
     end loop;
     return true;
  end check_unique;

  procedure lock_row( X_EXPENSE_ID IN RNT_PROPERTY_EXPENSES.EXPENSE_ID%TYPE) is
     cursor c is
     select * from RNT_PROPERTY_EXPENSES
     where EXPENSE_ID = X_EXPENSE_ID
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
  function get_checksum( X_EXPENSE_ID IN RNT_PROPERTY_EXPENSES.EXPENSE_ID%TYPE)
            return RNT_PROPERTY_EXPENSES_V.CHECKSUM%TYPE is 

    v_return_value               RNT_PROPERTY_EXPENSES_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_PROPERTY_EXPENSES_V
    where EXPENSE_ID = X_EXPENSE_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_EXPENSE_ID IN RNT_PROPERTY_EXPENSES.EXPENSE_ID%TYPE
                      , X_PROPERTY_ID IN RNT_PROPERTY_EXPENSES.PROPERTY_ID%TYPE
                      , X_EVENT_DATE IN RNT_PROPERTY_EXPENSES.EVENT_DATE%TYPE
                      , X_DESCRIPTION IN RNT_PROPERTY_EXPENSES.DESCRIPTION%TYPE
                      , X_RECURRING_YN IN RNT_PROPERTY_EXPENSES.RECURRING_YN%TYPE
                      , X_RECURRING_PERIOD IN RNT_PROPERTY_EXPENSES.RECURRING_PERIOD%TYPE
                      , X_RECURRING_ENDDATE IN RNT_PROPERTY_EXPENSES.RECURRING_ENDDATE%TYPE
                      , X_UNIT_ID IN RNT_PROPERTY_EXPENSES.UNIT_ID%TYPE
                      , X_CHECKSUM IN RNT_PROPERTY_EXPENSES_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_PROPERTY_EXPENSES_V.CHECKSUM%TYPE;
  begin
     lock_row(X_EXPENSE_ID);

      -- validate checksum
      l_checksum := get_checksum(X_EXPENSE_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

     if not check_unique(X_EXPENSE_ID, X_PROPERTY_ID, X_EVENT_DATE, X_UNIT_ID, X_DESCRIPTION) then
         RAISE_APPLICATION_ERROR(-20006, 'Update values must be unique.');
     end if;

     update RNT_PROPERTY_EXPENSES
     set PROPERTY_ID = X_PROPERTY_ID
     , EVENT_DATE = X_EVENT_DATE
     , DESCRIPTION = X_DESCRIPTION
     , RECURRING_YN = X_RECURRING_YN
     , RECURRING_PERIOD = X_RECURRING_PERIOD
     , RECURRING_ENDDATE = X_RECURRING_ENDDATE
     , UNIT_ID = X_UNIT_ID
     where EXPENSE_ID = X_EXPENSE_ID;
     
     -- update propertyID for payment records
     update RNT_ACCOUNTS_PAYABLE
     set PAYMENT_PROPERTY_ID = X_PROPERTY_ID
     where EXPENSE_ID = X_EXPENSE_ID;  
  end update_row;

  function insert_row( X_PROPERTY_ID IN RNT_PROPERTY_EXPENSES.PROPERTY_ID%TYPE
                     , X_EVENT_DATE IN RNT_PROPERTY_EXPENSES.EVENT_DATE%TYPE
                     , X_DESCRIPTION IN RNT_PROPERTY_EXPENSES.DESCRIPTION%TYPE
                     , X_RECURRING_YN IN RNT_PROPERTY_EXPENSES.RECURRING_YN%TYPE
                     , X_RECURRING_PERIOD IN RNT_PROPERTY_EXPENSES.RECURRING_PERIOD%TYPE
                     , X_RECURRING_ENDDATE IN RNT_PROPERTY_EXPENSES.RECURRING_ENDDATE%TYPE
                     , X_UNIT_ID IN RNT_PROPERTY_EXPENSES.UNIT_ID%TYPE)
              return RNT_PROPERTY_EXPENSES.EXPENSE_ID%TYPE
  is
     x          number;
  begin
     if not check_unique(NULL, X_PROPERTY_ID, X_EVENT_DATE, X_UNIT_ID, X_DESCRIPTION) then
         RAISE_APPLICATION_ERROR(-20006, 'Insert values must be unique.');
     end if;

     insert into RNT_PROPERTY_EXPENSES
     ( EXPENSE_ID
     , PROPERTY_ID
     , EVENT_DATE
     , DESCRIPTION
     , RECURRING_YN
     , RECURRING_PERIOD
     , RECURRING_ENDDATE
     , UNIT_ID)
     values
     ( RNT_PROPERTY_EXPENSES_SEQ.NEXTVAL
     , X_PROPERTY_ID
     , X_EVENT_DATE
     , X_DESCRIPTION
     , X_RECURRING_YN
     , X_RECURRING_PERIOD
     , X_RECURRING_ENDDATE
     , X_UNIT_ID)
     returning EXPENSE_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_EXPENSE_ID IN RNT_PROPERTY_EXPENSES.EXPENSE_ID%TYPE) 
  is
  begin
    delete from RNT_PROPERTY_EXPENSES
    where EXPENSE_ID = X_EXPENSE_ID;
  end delete_row;

end RNT_PROPERTY_EXPENSES_PKG;
/

SHOW ERRORS;

CREATE OR REPLACE FORCE VIEW RNT_ACCOUNTS_PAYABLE_V
(AP_ID, PAYMENT_DUE_DATE, AMOUNT, PAYMENT_TYPE_ID, EXPENSE_ID, 
 LOAN_ID, SUPPLIER_ID, PAYMENT_PROPERTY_ID, CHECKSUM, SUPPLIER_NAME)
AS 
select ap.AP_ID
,      ap.PAYMENT_DUE_DATE
,      ap.AMOUNT
,      ap.PAYMENT_TYPE_ID
,      ap.EXPENSE_ID
,      ap.LOAN_ID
,      ap.SUPPLIER_ID
,      ap.PAYMENT_PROPERTY_ID
,      ap.CHECKSUM
,      s.NAME as SUPPLIER_NAME    
from RNT_ACCOUNTS_PAYABLE_ALL_V ap,
     RNT_SUPPLIERS s
where ap.SUPPLIER_ID = s.SUPPLIER_ID;

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
                      , X_PAYMENT_PROPERTY_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID%TYPE);

  function insert_row( X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_PAYABLE.PAYMENT_DUE_DATE%TYPE
                     , X_AMOUNT IN RNT_ACCOUNTS_PAYABLE.AMOUNT%TYPE
                     , X_PAYMENT_TYPE_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_TYPE_ID%TYPE
                     , X_EXPENSE_ID IN RNT_ACCOUNTS_PAYABLE.EXPENSE_ID%TYPE
                     , X_LOAN_ID IN RNT_ACCOUNTS_PAYABLE.LOAN_ID%TYPE
                     , X_SUPPLIER_ID IN RNT_ACCOUNTS_PAYABLE.SUPPLIER_ID%TYPE
                     , X_PAYMENT_PROPERTY_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID%TYPE)
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
                      );
                      
  procedure delete_row2( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE);
                      
  function get_date_by_recurring(x_daily varchar2, x_date DATE) return DATE;
  
  procedure generate_payment_list;                      
end RNT_ACCOUNTS_PAYABLE_PKG;
/

SHOW ERRORS;

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
            return RNT_ACCOUNTS_PAYABLE_V.CHECKSUM%TYPE is 

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
                      , X_PAYMENT_PROPERTY_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID%TYPE)
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
     where AP_ID = X_AP_ID;

  end update_row;

  function insert_row( X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_PAYABLE.PAYMENT_DUE_DATE%TYPE
                     , X_AMOUNT IN RNT_ACCOUNTS_PAYABLE.AMOUNT%TYPE
                     , X_PAYMENT_TYPE_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_TYPE_ID%TYPE
                     , X_EXPENSE_ID IN RNT_ACCOUNTS_PAYABLE.EXPENSE_ID%TYPE
                     , X_LOAN_ID IN RNT_ACCOUNTS_PAYABLE.LOAN_ID%TYPE
                     , X_SUPPLIER_ID IN RNT_ACCOUNTS_PAYABLE.SUPPLIER_ID%TYPE
                     , X_PAYMENT_PROPERTY_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID%TYPE)
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
     , PAYMENT_PROPERTY_ID)
     values
     ( RNT_ACCOUNTS_PAYABLE_SEQ.NEXTVAL
     , X_PAYMENT_DUE_DATE
     , X_AMOUNT
     , X_PAYMENT_TYPE_ID
     , X_EXPENSE_ID
     , X_LOAN_ID
     , X_SUPPLIER_ID
     ,X_PAYMENT_PROPERTY_ID)
     returning AP_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE) is

  begin
    lock_row(X_AP_ID);
    delete from RNT_ACCOUNTS_PAYABLE
    where AP_ID = X_AP_ID;
  end delete_row;
  
  procedure update_allocation(X_AP_ID IN RNT_PAYMENT_ALLOCATIONS.AP_ID%TYPE 
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
                     , X_PAYMENT_PROPERTY_ID => X_PAYMENT_PROPERTY_ID);  
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
       else RAISE_APPLICATION_ERROR(-23434, 'Unknown type of recurring period');  
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
               e.RECURRING_ENDDATE
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
               SUPPLIER_ID, PAYMENT_PROPERTY_ID) 
        values (RNT_ACCOUNTS_PAYABLE_SEQ.NEXTVAL, x.PAYMENT_NEXT_DATE, x.AMOUNT,
                x.PAYMENT_TYPE_ID, x.EXPENSE_ID, x.LOAN_ID, 
                x.SUPPLIER_ID, x.PAYMENT_PROPERTY_ID);
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

SHOW ERRORS;

CREATE OR REPLACE package body        RNT_ACCOUNTS_RECEIVABLE_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_ACCOUNTS_RECEIVABLE_PKG
    Purpose:   API's for RNT_ACCOUNTS_RECEIVABLE table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        14-MAY-07   Auto Generated   Initial Version

********************************************************************************/

function PAYMENT_TYPE_RENT return NUMBER as begin return 7; end;
function PAYMENT_TYPE_DISCOUNT_RENT return NUMBER as begin return 8; end;
function PAYMENT_TYPE_RECOVERABLE return NUMBER as begin return 9; end;
function PAYMENT_TYPE_LATE_FEE return NUMBER as begin return 10; end;
function PAYMENT_TYPE_REMAINING_RENT return NUMBER as begin return 13; end;
function PAYMENT_TYPE_SECTION8_RENT return NUMBER as begin return 14; end;

  procedure lock_row( X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE) is
     cursor c is
     select * from RNT_ACCOUNTS_RECEIVABLE
     where AR_ID = X_AR_ID
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
  function get_checksum( X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE)
            return RNT_ACCOUNTS_RECEIVABLE_ALL_V.CHECKSUM%TYPE is 

    v_return_value RNT_ACCOUNTS_RECEIVABLE_ALL_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_ACCOUNTS_RECEIVABLE_ALL_V
    where AR_ID = X_AR_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE
                      , X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_DUE_DATE%TYPE
                      , X_AMOUNT IN RNT_ACCOUNTS_RECEIVABLE.AMOUNT%TYPE
                      , X_PAYMENT_TYPE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_TYPE%TYPE
                      , X_TENANT_ID IN RNT_ACCOUNTS_RECEIVABLE.TENANT_ID%TYPE
                      , X_AGREEMENT_ID IN RNT_ACCOUNTS_RECEIVABLE.AGREEMENT_ID%TYPE
                      , X_LOAN_ID IN RNT_ACCOUNTS_RECEIVABLE.LOAN_ID%TYPE
                      , X_BUSINESS_ID IN RNT_ACCOUNTS_RECEIVABLE.BUSINESS_ID%TYPE
                      , X_IS_GENERATED_YN IN RNT_ACCOUNTS_RECEIVABLE.IS_GENERATED_YN%TYPE
                      , X_CHECKSUM IN RNT_ACCOUNTS_RECEIVABLE_V.CHECKSUM%TYPE
                      , X_AGREEMENT_ACTION_ID IN RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE
                      , X_PAYMENT_PROPERTY_ID IN RNT_PROPERTIES.PROPERTY_ID%TYPE)
  is
     l_checksum          RNT_ACCOUNTS_RECEIVABLE_ALL_V.CHECKSUM%TYPE;
  begin
     lock_row(X_AR_ID);

      -- validate checksum
      l_checksum := get_checksum(X_AR_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;
     
     update RNT_ACCOUNTS_RECEIVABLE
     set PAYMENT_DUE_DATE = X_PAYMENT_DUE_DATE
     , AMOUNT = X_AMOUNT
     , PAYMENT_TYPE = X_PAYMENT_TYPE
     , TENANT_ID = X_TENANT_ID
     , AGREEMENT_ID = X_AGREEMENT_ID
     , LOAN_ID = X_LOAN_ID
     , BUSINESS_ID = X_BUSINESS_ID
     , IS_GENERATED_YN = X_IS_GENERATED_YN
     , AGREEMENT_ACTION_ID = X_AGREEMENT_ACTION_ID
     , PAYMENT_PROPERTY_ID = X_PAYMENT_PROPERTY_ID 
     where AR_ID = X_AR_ID;

  end update_row;
  
  procedure update_row_amount( X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE
                             , X_AMOUNT IN RNT_ACCOUNTS_RECEIVABLE.AMOUNT%TYPE
                             , X_CHECKSUM IN RNT_ACCOUNTS_RECEIVABLE_ALL_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_ACCOUNTS_RECEIVABLE_ALL_V.CHECKSUM%TYPE;
  begin
     lock_row(X_AR_ID);

      -- validate checksum
      l_checksum := get_checksum(X_AR_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;
     
     update RNT_ACCOUNTS_RECEIVABLE
     set AMOUNT = X_AMOUNT
     where AR_ID = X_AR_ID;

  end update_row_amount;

  function insert_row( X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_DUE_DATE%TYPE
                     , X_AMOUNT IN RNT_ACCOUNTS_RECEIVABLE.AMOUNT%TYPE
                     , X_PAYMENT_TYPE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_TYPE%TYPE
                     , X_TENANT_ID IN RNT_ACCOUNTS_RECEIVABLE.TENANT_ID%TYPE
                     , X_AGREEMENT_ID IN RNT_ACCOUNTS_RECEIVABLE.AGREEMENT_ID%TYPE
                     , X_LOAN_ID IN RNT_ACCOUNTS_RECEIVABLE.LOAN_ID%TYPE
                     , X_BUSINESS_ID IN RNT_ACCOUNTS_RECEIVABLE.BUSINESS_ID%TYPE
                     , X_IS_GENERATED_YN IN RNT_ACCOUNTS_RECEIVABLE.IS_GENERATED_YN%TYPE
                     , X_AGREEMENT_ACTION_ID IN RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE
                     , X_PAYMENT_PROPERTY_ID IN RNT_PROPERTIES.PROPERTY_ID%TYPE   
                     )
              return RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE
  is
     x          number;
  begin

     insert into RNT_ACCOUNTS_RECEIVABLE
     ( AR_ID
     , PAYMENT_DUE_DATE
     , AMOUNT
     , PAYMENT_TYPE
     , TENANT_ID
     , AGREEMENT_ID
     , LOAN_ID
     , BUSINESS_ID
     , IS_GENERATED_YN
     , AGREEMENT_ACTION_ID
     , PAYMENT_PROPERTY_ID
     )
     values
     ( RNT_ACCOUNTS_RECEIVABLE_SEQ.NEXTVAL
     , X_PAYMENT_DUE_DATE
     , X_AMOUNT
     , X_PAYMENT_TYPE
     , X_TENANT_ID
     , X_AGREEMENT_ID
     , X_LOAN_ID
     , X_BUSINESS_ID
     , X_IS_GENERATED_YN
     , X_AGREEMENT_ACTION_ID
     , X_PAYMENT_PROPERTY_ID
     )
     returning AR_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE) is
  begin
    delete from RNT_ACCOUNTS_RECEIVABLE
    where AR_ID = X_AR_ID;
  end delete_row;
/*
  -- return type of payment for p_now_date
  function get_type_of_payment(   p_payment_due_date DATE  -- due payment date
                                , p_now_date DATE          -- current date
                                , p_discount_period NUMBER -- days for discount period
                                , p_discount_type varchar2 -- discount type LATE_FEE or DISCOUNT
                                ) return number
  is 
  begin
     -- p_current_type have values: 
     --   7  - Rent  
      --  8  - Discount Rent
      --  10 - Late Fee
     
     -- not discount or late fee 
     if p_discount_type is null then
       return PAYMENT_TYPE_RENT;
     end if;
     
     if p_discount_type = 'LATE_FEE' then
     
        if p_payment_due_date + p_discount_period < p_now_date then
          return PAYMENT_TYPE_LATE_FEE;
        else
          return PAYMENT_TYPE_RENT;
        end if;  
     end if;
     
     if p_discount_type = 'DISCOUNT' then
        if p_payment_due_date + p_discount_period  >= p_now_date then
          return PAYMENT_TYPE_DISCOUNT;
        else          
          return PAYMENT_TYPE_RENT;
        end if;  
     end if; 
     
     RAISE_APPLICATION_ERROR(-20000, 'Error in algoriphm for discount price');
  end;                                 

  function get_amount_for_payment(  p_payment_due_date DATE  -- due payment date
                                  , p_now_date DATE          -- current date
                                  , p_discount_period NUMBER -- days for discount period
                                  , p_amount NUMBER          -- amount for payment due date
                                  , p_discount_amount NUMBER -- discount amount
                                  , p_discount_type varchar2 -- discount type LATE_FEE or DISCOUNT
                                  , p_new_type out NUMBER   -- type for payment
                                  ) return number
  is
  begin
     p_new_type := get_type_of_payment(   
                                  p_payment_due_date => p_payment_due_date
                                , p_now_date => p_now_date
                                , p_discount_period => p_discount_period
                                , p_discount_type => p_discount_type); 
     -- not discount or late fee 
     if p_new_type = PAYMENT_TYPE_RENT then
        return p_amount;
     elsif p_new_type = PAYMENT_TYPE_LATE_FEE then   
        return p_amount + p_discount_amount;
     elsif p_new_type = PAYMENT_TYPE_DISCOUNT then     
        return p_amount - p_discount_amount;
     end if; 
     
     RAISE_APPLICATION_ERROR(-20000, 'Error in algoriphm for discount price');
  end;
*/
/*
  procedure update_payment_list
  is
  cursor c is 
          select a.DATE_AVAILABLE, a.TERM, a.AMOUNT,       
               a.AMOUNT_PERIOD, a.DISCOUNT_AMOUNT, a.DISCOUNT_TYPE,
               a.DISCOUNT_PERIOD, a.AGREEMENT_ID, 
               ra.AR_ID, 
               NVL(allocations.SUM_ALLOCATION, 0) as SUM_OF_ALLOCATION,
               ra.PAYMENT_TYPE,
               ra.AMOUNT as FOR_PAYMENT_AMOUNT,
               ra.TENANT_ID,  
               ra.PAYMENT_DUE_DATE,
               ra.SOURCE_FOR_LATE_FEE,
               late_fee.AR_ID as LATE_FEE_AR_ID,
               ra.BUSINESS_ID
        from RNT_TENANCY_AGREEMENT a,
             RNT_PROPERTY_UNITS u,
             RNT_TENANT t,
             RNT_ACCOUNTS_RECEIVABLE ra, 
             (select AR_ID, sum(AMOUNT) as SUM_ALLOCATION
              from RNT_PAYMENT_ALLOCATIONS
              group by AR_ID) allocations,
              RNT_ACCOUNTS_RECEIVABLE late_fee
        where a.UNIT_ID = u.UNIT_ID
          and t.AGREEMENT_ID = a.AGREEMENT_ID
          and ra.TENANT_ID = t.TENANT_ID
          and ra.AGREEMENT_ID = a.AGREEMENT_ID
          and allocations.AR_ID(+) = ra.AR_ID
          and ra.PAYMENT_TYPE in (PAYMENT_TYPE_RENT, PAYMENT_TYPE_DISCOUNT, PAYMENT_TYPE_LATE_FEE)
          and ra.AMOUNT - NVL(allocations.SUM_ALLOCATION, 0) != 0
          and ra.IS_GENERATED_YN = 'Y'
          and t.STATUS = 'CURRENT'
          and late_fee.SOURCE_FOR_LATE_FEE(+) = ra.AR_ID;
     x_new_type NUMBER;     
  begin
 
    for x in c loop
      
       x_new_type := get_type_of_payment(p_payment_due_date => x.PAYMENT_DUE_DATE -- due payment date
                                , p_now_date => trunc(SYSDATE)           -- current date
                                , p_discount_period => x.DISCOUNT_PERIOD -- days for discount period
                                , p_discount_type => x.DISCOUNT_TYPE);   -- discount type LATE_FEE or DISCOUNT
      -- dbms_output.put_line(x.PAYMENT_TYPE||' '||x_new_type);                                
      if x.LATE_FEE_AR_ID is not null and x_new_type = PAYMENT_TYPE_LATE_FEE then 
         null;
      else                            
        if x_new_type != x.PAYMENT_TYPE then
        
          if x.PAYMENT_TYPE = PAYMENT_TYPE_RENT then
             if x_new_type = PAYMENT_TYPE_DISCOUNT then
                   -- discount rent
                   update RNT_ACCOUNTS_RECEIVABLE
                   set AMOUNT = x.AMOUNT - x.DISCOUNT_AMOUNT,
                       PAYMENT_TYPE = PAYMENT_TYPE_DISCOUNT
                   where AR_ID = x.AR_ID;                                
             elsif x_new_type = PAYMENT_TYPE_LATE_FEE then
                   update RNT_ACCOUNTS_RECEIVABLE
                   set AMOUNT = x.AMOUNT + x.DISCOUNT_AMOUNT,
                       PAYMENT_TYPE = PAYMENT_TYPE_LATE_FEE
                   where AR_ID = x.AR_ID;
             else
                RAISE_APPLICATION_ERROR(-20000, 'Error in algoriphm for calculate rental 1');         
             end if;
          end if;
            
          if x.PAYMENT_TYPE = PAYMENT_TYPE_DISCOUNT then
            if x_new_type = PAYMENT_TYPE_RENT then
               -- rent
               update RNT_ACCOUNTS_RECEIVABLE
               set AMOUNT = x.AMOUNT,
                   PAYMENT_TYPE = PAYMENT_TYPE_RENT
               where AR_ID = x.AR_ID;
            elsif x_new_type = PAYMENT_TYPE_LATE_FEE then
               update RNT_ACCOUNTS_RECEIVABLE
               set AMOUNT = x.AMOUNT + x.DISCOUNT_AMOUNT,
                   PAYMENT_TYPE = PAYMENT_TYPE_LATE_FEE
               where AR_ID = x.AR_ID;
            else
               RAISE_APPLICATION_ERROR(-20000, 'Error in algoriphm for calculate rental 1');         
            end if;
          end if;   
            
           if x.PAYMENT_TYPE = PAYMENT_TYPE_LATE_FEE then
               if x_new_type in (PAYMENT_TYPE_RENT, PAYMENT_TYPE_DISCOUNT) then
                   -- rent
                   if x_new_type = PAYMENT_TYPE_RENT then
                       update RNT_ACCOUNTS_RECEIVABLE
                       set AMOUNT = x.AMOUNT,
                           PAYMENT_TYPE = PAYMENT_TYPE_RENT
                       where AR_ID = x.AR_ID;                                
                   elsif x_new_type = PAYMENT_TYPE_DISCOUNT then
                       update RNT_ACCOUNTS_RECEIVABLE
                       set AMOUNT = x.AMOUNT-x.DISCOUNT_AMOUNT,
                           PAYMENT_TYPE = PAYMENT_TYPE_DISCOUNT
                       where AR_ID = x.AR_ID;
                   end if;             
               else
                 RAISE_APPLICATION_ERROR(-20000, 'Error in algoriphm for calculate rental 1');         
               end if;
           end if;
        end if;
      end if;                                  
    end loop;
    commit;
  exception
   when OTHERS then
      rollback;
      raise;  
  end;          
*/

  function generate_payments return NUMBER
  is
     cursor c_new_payment
     is
        select a.DATE_AVAILABLE, 
             a.TERM,
             NVL(max_payment.MAX_PAYMENT_DATE, a.DATE_AVAILABLE) as MAX_PAYMENT_DATE,
             trunc(decode(a.AMOUNT_PERIOD,
                        'MONTH', ADD_MONTHS(NVL(max_payment.MAX_PAYMENT_DATE, a.DATE_AVAILABLE), 1),
                        'BI-MONTH', ADD_MONTHS(NVL(max_payment.MAX_PAYMENT_DATE, a.DATE_AVAILABLE), 2),
                        '2WEEKS', NVL(max_payment.MAX_PAYMENT_DATE, a.DATE_AVAILABLE)+14,
                        'WEEK', NVL(max_payment.MAX_PAYMENT_DATE, a.DATE_AVAILABLE)+7
             )) as NEXT_PAYMENT_DATE,
             a.AMOUNT,       
             a.AMOUNT_PERIOD,
             a.DISCOUNT_AMOUNT,
             a.DISCOUNT_TYPE,
             a.DISCOUNT_PERIOD,
             a.AGREEMENT_ID,
             p.BUSINESS_ID,
             t.TENANT_ID,
             t.SECTION8_TENANT_PAYS,
             t.SECTION8_VOUCHER_AMOUNT,
             u.PROPERTY_ID
     from RNT_TENANCY_AGREEMENT a,
          RNT_PROPERTY_UNITS u,
          RNT_TENANT t,
          (select TENANT_ID, max(PAYMENT_DUE_DATE) as MAX_PAYMENT_DATE 
           from RNT_ACCOUNTS_RECEIVABLE 
           where PAYMENT_TYPE in (RNT_ACCOUNTS_RECEIVABLE_PKG.PAYMENT_TYPE_RENT, RNT_ACCOUNTS_RECEIVABLE_PKG.PAYMENT_TYPE_DISCOUNT_RENT)
             and IS_GENERATED_YN = 'Y'
           group by TENANT_ID) max_payment,
          RNT_PROPERTIES p  
     where a.UNIT_ID = u.UNIT_ID
       and SYSDATE <= NVL(a.END_DATE, to_date('4000', 'RRRR'))
       and trunc(decode(a.AMOUNT_PERIOD,
           'MONTH', ADD_MONTHS(SYSDATE, -1),
           'BI-MONTH', ADD_MONTHS(SYSDATE, -2),
           '2WEEKS', SYSDATE-14,
           'WEEK', SYSDATE-7
           )) >= (select NVL(max(PAYMENT_DUE_DATE), a.DATE_AVAILABLE) 
                  from RNT_ACCOUNTS_RECEIVABLE aa 
                  where TENANT_ID = t.TENANT_ID
                    and IS_GENERATED_YN = 'Y'
                    and PAYMENT_TYPE in (RNT_ACCOUNTS_RECEIVABLE_PKG.PAYMENT_TYPE_RENT, RNT_ACCOUNTS_RECEIVABLE_PKG.PAYMENT_TYPE_DISCOUNT_RENT))
       and max_payment.TENANT_ID(+) = t.TENANT_ID
       and t.AGREEMENT_ID = a.AGREEMENT_ID
       and p.PROPERTY_ID = u.PROPERTY_ID
       and t.STATUS = 'CURRENT';
      
      x_ar_id NUMBER; 
                   
      x_payment_type1 NUMBER;
      x_payment_type2 NUMBER;
      x_amount NUMBER;
      x_amount2 NUMBER;
      x_cnt NUMBER;
      x_next_date2 DATE;
      x_amount_section8 NUMBER; 
  begin
    savepoint T_;
    x_cnt := 0;
    -- generate list from last payment 
    for x in c_new_payment loop
    
      x_amount := x.AMOUNT;
      x_payment_type1 := PAYMENT_TYPE_RENT();
      x_payment_type2 := 0;
      
      if x.DISCOUNT_TYPE = 'LATE_FEE' then
         x_amount:= x.AMOUNT;
         x_payment_type1 := PAYMENT_TYPE_RENT();
         x_payment_type2 := PAYMENT_TYPE_LATE_FEE();
         x_next_date2 := x.NEXT_PAYMENT_DATE + x.DISCOUNT_PERIOD;
         x_amount2 := x.DISCOUNT_AMOUNT;
      elsif x.DISCOUNT_TYPE = 'DISCOUNT' then
         x_payment_type1 := PAYMENT_TYPE_DISCOUNT_RENT();
         x_payment_type2 := PAYMENT_TYPE_REMAINING_RENT();
         x_next_date2 := x.NEXT_PAYMENT_DATE + x.DISCOUNT_PERIOD;
         x_amount := x.AMOUNT - x.DISCOUNT_AMOUNT;
         x_amount2 := x.DISCOUNT_AMOUNT;   
      end if;
      
      x_amount_section8 := null;
      if x.SECTION8_TENANT_PAYS is not null then
         --if NVL(x.SECTION8_VOUCHER_AMOUNT, 0) 
           x_amount_section8 := x_amount;
           x_amount := x.SECTION8_TENANT_PAYS;
           if x_amount_section8 - x.SECTION8_TENANT_PAYS < 0 then
             x_amount_section8 := NULL;
           else
             x_amount_section8 := x_amount_section8 - x.SECTION8_TENANT_PAYS;
           end if;  
      end if;  
      
      insert into RNT_ACCOUNTS_RECEIVABLE (
           AR_ID, PAYMENT_DUE_DATE, AMOUNT, 
           PAYMENT_TYPE, TENANT_ID, AGREEMENT_ID, 
           LOAN_ID, BUSINESS_ID, IS_GENERATED_YN, 
           AGREEMENT_ACTION_ID, PAYMENT_PROPERTY_ID, SOURCE_PAYMENT_ID) 
       values (RNT_ACCOUNTS_RECEIVABLE_SEQ.NEXTVAL, x.NEXT_PAYMENT_DATE, x_amount,
            x_payment_type1, x.TENANT_ID, x.AGREEMENT_ID,
            NULL, x.BUSINESS_ID, 'Y',
            NULL, x.PROPERTY_ID, NULL)
       returning AR_ID into x_ar_id;
      
      if x_payment_type2 != 0 then
            insert into RNT_ACCOUNTS_RECEIVABLE (
                   AR_ID, PAYMENT_DUE_DATE, AMOUNT, 
                   PAYMENT_TYPE, TENANT_ID, AGREEMENT_ID, 
                   LOAN_ID, BUSINESS_ID, IS_GENERATED_YN, 
                   AGREEMENT_ACTION_ID, PAYMENT_PROPERTY_ID, SOURCE_PAYMENT_ID) 
            values (RNT_ACCOUNTS_RECEIVABLE_SEQ.NEXTVAL, x_next_date2, x_amount2,
                    x_payment_type2, x.TENANT_ID, x.AGREEMENT_ID,
                    NULL, x.BUSINESS_ID, 'Y',
                    NULL, x.PROPERTY_ID, x_ar_id);
      end if;
      
      if x_amount_section8 is not null then
          insert into RNT_ACCOUNTS_RECEIVABLE (
               AR_ID, PAYMENT_DUE_DATE, AMOUNT, 
               PAYMENT_TYPE, TENANT_ID, AGREEMENT_ID, 
               LOAN_ID, BUSINESS_ID, IS_GENERATED_YN, 
               AGREEMENT_ACTION_ID, PAYMENT_PROPERTY_ID, SOURCE_PAYMENT_ID) 
           values (RNT_ACCOUNTS_RECEIVABLE_SEQ.NEXTVAL, x.NEXT_PAYMENT_DATE, x_amount_section8,
                 PAYMENT_TYPE_SECTION8_RENT(), x.TENANT_ID, x.AGREEMENT_ID,
                NULL, x.BUSINESS_ID, 'Y',
                NULL, x.PROPERTY_ID, x_ar_id);
      end if;
                                               
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
    for i in 1..10 loop
       x := generate_payments;
       exit when x = 0;
    end loop;
    --update_payment_list;
  end;
  
  /* 
     Function check then amount can be allocation for this payment
  */
  procedure update_payment_from_allocation(X_AMOUNT IN RNT_PAYMENT_ALLOCATIONS.AMOUNT%TYPE, 
                                           X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE, 
                                           X_AR_ID IN RNT_PAYMENT_ALLOCATIONS.AR_ID%TYPE)
  is

  cursor c_alloc is
    select NVL(sum(AMOUNT), 0) as ALLOCATED_AMOUNT 
    from RNT_PAYMENT_ALLOCATIONS
    where AR_ID = X_AR_ID;
      
  
  cursor c_payment is 
    select AMOUNT 
    from RNT_ACCOUNTS_RECEIVABLE
    where AR_ID = X_AR_ID;      
    
  x_allocated NUMBER;
  x_payment NUMBER;
  
  begin
    open c_alloc;
    fetch c_alloc into x_allocated;
    close c_alloc;
    
    open c_payment;
    fetch c_payment into x_payment;
    close c_payment;    
    
    if x_allocated + X_AMOUNT > x_payment then
       RAISE_APPLICATION_ERROR(-20567, 'New amount sum more then sum for payment in specified date ('||
                to_char(X_PAYMENT_DATE, 'MM/DD/RRRR')||'). Max allowed value for payment = '||
                (x_payment));       
    end if;
    
  end;                                     

  -- return max payed amount for agreement action
  function get_max_alloc_for_agr_action(X_ACTION_ID RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE) return NUMBER
  is
    x NUMBER;
  begin
    select max(SUM_AMOUNT)
    into x 
    from (
            select sum(pa.AMOUNT)as SUM_AMOUNT
            from RNT_ACCOUNTS_RECEIVABLE ar,
                 RNT_PAYMENT_ALLOCATIONS pa
            where ar.AGREEMENT_ACTION_ID = X_ACTION_ID
              and pa.AR_ID = ar.AR_ID
            group by TENANT_ID
          );
    return x;        
  end;
  
  procedure DELETE_AGR_ACTION_RECEIVABLE(X_ACTION_ID RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE)
  is
  begin
     -- delete allocations
     delete from RNT_ACCOUNTS_RECEIVABLE 
     where AGREEMENT_ACTION_ID = X_ACTION_ID;                 
  end;
  
  procedure update_alloc(X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE, 
                         X_AMOUNT IN RNT_PAYMENT_ALLOCATIONS.AMOUNT%TYPE,
                         X_AR_ID IN RNT_PAYMENT_ALLOCATIONS.AR_ID%TYPE)
  is
  begin
    if X_PAYMENT_DATE is null then
      delete from RNT_PAYMENT_ALLOCATIONS
      where AR_ID =X_AR_ID; 
    else
      update RNT_PAYMENT_ALLOCATIONS
      set PAYMENT_DATE = X_PAYMENT_DATE,
          AMOUNT = X_AMOUNT
      where AR_ID = X_AR_ID;
      if SQL%ROWCOUNT = 0 then
         insert into RNT_PAYMENT_ALLOCATIONS (
                   PAY_ALLOC_ID, PAYMENT_DATE, AMOUNT, 
                   AR_ID, AP_ID, PAYMENT_ID) 
          values (RNT_PAYMENT_ALLOCATIONS_SEQ.NEXTVAL, X_PAYMENT_DATE, X_AMOUNT,
                   X_AR_ID, NULL, NULL);
      end if;    
    end if;                      
  end;                         
------------------------------------------------------------------------------------
  function get_checksum2(X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE)  return RNT_ACCOUNTS_RECEIVABLE_PROP_V.CHECKSUM%TYPE is 

    v_return_value               RNT_ACCOUNTS_RECEIVABLE_PROP_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_ACCOUNTS_RECEIVABLE_PROP_V
    where AR_ID = X_AR_ID;
    return v_return_value;
  end get_checksum2;
  
  procedure update_row2(X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE
                      , X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_DUE_DATE%TYPE
                      , X_AMOUNT IN RNT_ACCOUNTS_RECEIVABLE.AMOUNT%TYPE
                      , X_PAYMENT_TYPE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_TYPE%TYPE
                      , X_TENANT_ID IN RNT_ACCOUNTS_RECEIVABLE.TENANT_ID%TYPE
                      , X_AGREEMENT_ID IN RNT_ACCOUNTS_RECEIVABLE.AGREEMENT_ID%TYPE
                      , X_LOAN_ID IN RNT_ACCOUNTS_RECEIVABLE.LOAN_ID%TYPE
                      , X_BUSINESS_ID IN RNT_ACCOUNTS_RECEIVABLE.BUSINESS_ID%TYPE
                      , X_IS_GENERATED_YN IN RNT_ACCOUNTS_RECEIVABLE.IS_GENERATED_YN%TYPE
                      , X_CHECKSUM IN RNT_ACCOUNTS_RECEIVABLE_V.CHECKSUM%TYPE
                      , X_AGREEMENT_ACTION_ID IN RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE
                      , X_PAYMENT_PROPERTY_ID IN RNT_PROPERTIES.PROPERTY_ID%TYPE
                      , X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE
                      )
  is
  begin
  
            update_row(X_AR_ID => X_AR_ID
                      , X_PAYMENT_DUE_DATE => X_PAYMENT_DUE_DATE 
                      , X_AMOUNT => X_AMOUNT
                      , X_PAYMENT_TYPE => X_PAYMENT_TYPE
                      , X_TENANT_ID => X_TENANT_ID
                      , X_AGREEMENT_ID => X_AGREEMENT_ID
                      , X_LOAN_ID => X_LOAN_ID
                      , X_BUSINESS_ID => X_BUSINESS_ID
                      , X_IS_GENERATED_YN => X_IS_GENERATED_YN
                      , X_CHECKSUM => X_CHECKSUM
                      , X_AGREEMENT_ACTION_ID => X_AGREEMENT_ACTION_ID
                      , X_PAYMENT_PROPERTY_ID => X_PAYMENT_PROPERTY_ID
                   );
            update_alloc(X_PAYMENT_DATE => X_PAYMENT_DATE 
                       , X_AMOUNT => X_AMOUNT 
                       , X_AR_ID => X_AR_ID);
  end;                    

  function insert_row2( X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_DUE_DATE%TYPE
                     , X_AMOUNT IN RNT_ACCOUNTS_RECEIVABLE.AMOUNT%TYPE
                     , X_PAYMENT_TYPE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_TYPE%TYPE
                     , X_TENANT_ID IN RNT_ACCOUNTS_RECEIVABLE.TENANT_ID%TYPE
                     , X_AGREEMENT_ID IN RNT_ACCOUNTS_RECEIVABLE.AGREEMENT_ID%TYPE
                     , X_LOAN_ID IN RNT_ACCOUNTS_RECEIVABLE.LOAN_ID%TYPE
                     , X_BUSINESS_ID IN RNT_ACCOUNTS_RECEIVABLE.BUSINESS_ID%TYPE
                     , X_IS_GENERATED_YN IN RNT_ACCOUNTS_RECEIVABLE.IS_GENERATED_YN%TYPE
                     , X_AGREEMENT_ACTION_ID IN RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE
                     , X_PAYMENT_PROPERTY_ID IN RNT_PROPERTIES.PROPERTY_ID%TYPE
                     , X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE                     
                   )
              return RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE
  is 
    x RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE;
  begin
         x:= insert_row(X_PAYMENT_DUE_DATE => X_PAYMENT_DUE_DATE 
                      , X_AMOUNT => X_AMOUNT
                      , X_PAYMENT_TYPE => X_PAYMENT_TYPE
                      , X_TENANT_ID => X_TENANT_ID
                      , X_AGREEMENT_ID => X_AGREEMENT_ID
                      , X_LOAN_ID => X_LOAN_ID
                      , X_BUSINESS_ID => X_BUSINESS_ID
                      , X_IS_GENERATED_YN => X_IS_GENERATED_YN
                      , X_AGREEMENT_ACTION_ID => X_AGREEMENT_ACTION_ID
                      , X_PAYMENT_PROPERTY_ID => X_PAYMENT_PROPERTY_ID
                      );
                      
         update_alloc(X_PAYMENT_DATE => X_PAYMENT_DATE 
                     , X_AMOUNT => X_AMOUNT
                     , X_AR_ID => x);
                      
        return x;
  end;
                 
 procedure delete_row2(X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE) is
  begin
      
    lock_row(X_AR_ID);
    delete from RNT_PAYMENT_ALLOCATIONS
    where AR_ID = X_AR_ID;
     
    delete from RNT_ACCOUNTS_RECEIVABLE
    where AR_ID = X_AR_ID;
    
  end delete_row2;
end RNT_ACCOUNTS_RECEIVABLE_PKG;
/

SHOW ERRORS;

ALTER PACKAGE RNT_PAYMENTS_PKG COMPILE BODY;

