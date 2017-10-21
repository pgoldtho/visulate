CREATE OR REPLACE package        RNT_AGREEMENT_ACTIONS_PKG as 
/*********************************************************************
  Copyright (c) Visulate 2007        All rights reserved worldwide
   Name:      RNT_AGREEMENT_ACTIONS_PKG
   Purpose:   API's for RNT_AGREEMENT_ACTIONS table

   Revision History
   Ver        Date        Author           Description
   --------   ---------   ---------------- ---------------------
   1.0        03-MAY-07   Auto Generated   Initial Version

*********************************************************************/
  procedure update_row(X_ACTION_ID IN RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE
  ,                   X_AGREEMENT_ID IN RNT_AGREEMENT_ACTIONS.AGREEMENT_ID%TYPE
  ,                   X_ACTION_DATE IN RNT_AGREEMENT_ACTIONS.ACTION_DATE%TYPE
  ,                   X_ACTION_TYPE IN RNT_AGREEMENT_ACTIONS.ACTION_TYPE%TYPE
  ,                   X_COMMENTS IN RNT_AGREEMENT_ACTIONS.COMMENTS%TYPE
  ,                   X_RECOVERABLE_YN IN RNT_AGREEMENT_ACTIONS.RECOVERABLE_YN%TYPE
  ,                   X_ACTION_COST IN RNT_AGREEMENT_ACTIONS.ACTION_COST%TYPE  
  ,                   X_CHECKSUM IN VARCHAR2  
  );

  function insert_row(X_AGREEMENT_ID IN RNT_AGREEMENT_ACTIONS.AGREEMENT_ID%TYPE
  ,                   X_ACTION_DATE IN RNT_AGREEMENT_ACTIONS.ACTION_DATE%TYPE
  ,                   X_ACTION_TYPE IN RNT_AGREEMENT_ACTIONS.ACTION_TYPE%TYPE
  ,                   X_ACTION_COST IN RNT_AGREEMENT_ACTIONS.ACTION_COST%TYPE  
  ,                   X_COMMENTS IN RNT_AGREEMENT_ACTIONS.COMMENTS%TYPE
  ,                   X_RECOVERABLE_YN IN RNT_AGREEMENT_ACTIONS.RECOVERABLE_YN%TYPE  
  ) return RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE;

  procedure delete_row(X_ACTION_ID IN RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE);

end RNT_AGREEMENT_ACTIONS_PKG;
/


CREATE OR REPLACE PACKAGE BODY        RNT_AGREEMENT_ACTIONS_PKG AS
/******************************************************************************
   NAME:       RNT_AGREEMENT_ACTIONS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03.05.2007             1. Created this package body.
******************************************************************************/

procedure lock_row(X_ACTION_ID IN RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE)
is
  cursor c is
     select * 
     from RNT_AGREEMENT_ACTIONS   
     where ACTION_ID = X_ACTION_ID
     for update of ACTION_ID nowait; 
begin
  open c;
  close c;
exception
  when OTHERS then
    if SQLCODE = -54 then
      RAISE_APPLICATION_ERROR(-20001, 'Cannot changed record. Record is locked.');
    end if;       
end;

function check_unique(X_ACTION_ID    RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE,       
                      X_AGREEMENT_ID RNT_AGREEMENT_ACTIONS.AGREEMENT_ID%TYPE,  
                      X_ACTION_DATE  RNT_AGREEMENT_ACTIONS.ACTION_DATE%TYPE,  
                      X_ACTION_TYPE  RNT_AGREEMENT_ACTIONS.ACTION_TYPE%TYPE
                      ) return boolean
is
  x NUMBER;
begin
   select 1 
   into x
   from DUAL
   where exists (
                   select 1
                   from RNT_AGREEMENT_ACTIONS
                   where (ACTION_ID != X_ACTION_ID or X_ACTION_ID is null) 
                     and AGREEMENT_ID = X_AGREEMENT_ID
                     and ACTION_DATE = X_ACTION_DATE
                     and ACTION_TYPE = X_ACTION_TYPE             
                 );
  return false;
exception
  when NO_DATA_FOUND then
     return true;                        
end;     


function get_checksum(X_ACTION_ID IN RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE)
return varchar2
is
  v varchar2(64);
begin
  select CHECKSUM
  into v 
  from RNT_AGREEMENT_ACTIONS_V 
  where ACTION_ID = X_ACTION_ID;
  return v;
end; 

procedure append_account_receivable(
                  X_AGREEMENT_ACTION_ID RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE
                , X_AGREEMENT_ID IN RNT_AGREEMENT_ACTIONS.AGREEMENT_ID%TYPE
                , X_ACTION_DATE IN RNT_AGREEMENT_ACTIONS.ACTION_DATE%TYPE
                , X_ACTION_COST IN RNT_AGREEMENT_ACTIONS.ACTION_COST%TYPE)
is
  x_ar_id RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE;
  x_business_id RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE;  
begin
  x_business_id := RNT_TENANCY_AGREEMENT_PKG.GET_BUSINESS_ID(X_AGREEMENT_ID);
  
  for x in (select TENANT_ID
            from RNT_TENANT 
            where AGREEMENT_ID = X_AGREEMENT_ID
              and STATUS = 'CURRENT') loop
      x_ar_id := RNT_ACCOUNTS_RECEIVABLE_PKG.INSERT_ROW( 
                       X_PAYMENT_DUE_DATE => X_ACTION_DATE
                     , X_AMOUNT => X_ACTION_COST
                     , X_PAYMENT_TYPE => RNT_ACCOUNTS_RECEIVABLE_PKG.PAYMENT_TYPE_RECOVERABLE 
                     , X_TENANT_ID => x.TENANT_ID
                     , X_AGREEMENT_ID => X_AGREEMENT_ID
                     , X_LOAN_ID => NULL
                     , X_BUSINESS_ID => x_business_id
                     , X_IS_GENERATED_YN => 'N'
                     , X_AGREEMENT_ACTION_ID => X_AGREEMENT_ACTION_ID
                     , X_RECORD_TYPE => RNT_ACC_RECEIVABLE_CONST_PKG.CONST_GENERATE_TYPE_VAL()
                     , X_PAYMENT_PROPERTY_ID => NULL
                   );
   end loop;                   
end;

procedure update_account_receivable(
                  X_AGREEMENT_ACTION_ID RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE
                , X_AGREEMENT_ID IN RNT_AGREEMENT_ACTIONS.AGREEMENT_ID%TYPE
                , X_ACTION_DATE IN RNT_AGREEMENT_ACTIONS.ACTION_DATE%TYPE
                , X_ACTION_COST IN RNT_AGREEMENT_ACTIONS.ACTION_COST%TYPE)
is
begin
      update RNT_ACCOUNTS_RECEIVABLE
      set AMOUNT = X_ACTION_COST,
          PAYMENT_DUE_DATE = X_ACTION_DATE
      where AGREEMENT_ID = X_AGREEMENT_ID
        and AGREEMENT_ACTION_ID = X_AGREEMENT_ACTION_ID
        and PAYMENT_TYPE = RNT_ACCOUNTS_RECEIVABLE_PKG.PAYMENT_TYPE_RECOVERABLE;                          
end;

  procedure update_row(X_ACTION_ID IN RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE
  ,                    X_AGREEMENT_ID IN RNT_AGREEMENT_ACTIONS.AGREEMENT_ID%TYPE
  ,                    X_ACTION_DATE IN RNT_AGREEMENT_ACTIONS.ACTION_DATE%TYPE
  ,                    X_ACTION_TYPE IN RNT_AGREEMENT_ACTIONS.ACTION_TYPE%TYPE
  ,                    X_COMMENTS IN RNT_AGREEMENT_ACTIONS.COMMENTS%TYPE
  ,                    X_RECOVERABLE_YN IN RNT_AGREEMENT_ACTIONS.RECOVERABLE_YN%TYPE
  ,                    X_ACTION_COST IN RNT_AGREEMENT_ACTIONS.ACTION_COST%TYPE  
  ,                    X_CHECKSUM IN VARCHAR2  
  )
is
 l_checksum varchar2(32); 
 cursor c_old is
    select ACTION_ID, AGREEMENT_ID, ACTION_DATE, 
           ACTION_TYPE, COMMENTS, RECOVERABLE_YN, 
           ACTION_COST
    from RNT_AGREEMENT_ACTIONS
    where ACTION_ID = X_ACTION_ID;
    
 x_old c_old%ROWTYPE;
 x_alloc_payment NUMBER;    
begin
   lock_row(X_ACTION_ID);
   
   -- validate checksum   
   l_checksum := get_checksum(X_ACTION_ID);
   if X_CHECKSUM != l_checksum then
      RAISE_APPLICATION_ERROR(-20002, 'Record was changed another user.');
   end if;
      
   if not check_unique(X_ACTION_ID, X_AGREEMENT_ID, X_ACTION_DATE, X_ACTION_TYPE) then
        RAISE_APPLICATION_ERROR(-20006, 'Action must be unique.');                      
   end if;   
   
   open c_old;
   fetch c_old into x_old;
   close c_old;
   
   if x_old.RECOVERABLE_YN = 'N' and X_RECOVERABLE_YN = 'Y' then
      append_account_receivable(X_ACTION_ID, X_AGREEMENT_ID, X_ACTION_DATE, X_ACTION_COST); 
   end if;
      
   if x_old.RECOVERABLE_YN = 'Y' and X_RECOVERABLE_YN = 'N' then
      -- check for payment
      x_alloc_payment := RNT_ACCOUNTS_RECEIVABLE_PKG.GET_MAX_ALLOC_FOR_AGR_ACTION(X_ACTION_ID);
      if NVL(x_alloc_payment, 0) > 0 then
        RAISE_APPLICATION_ERROR(-20045, 'Cannot update action record. Cause: find record about payment allocation.');
      end if;
      -- delete records 
      RNT_ACCOUNTS_RECEIVABLE_PKG.DELETE_AGR_ACTION_RECEIVABLE(X_ACTION_ID);
   end if;
      
   if x_old.RECOVERABLE_YN = 'Y' and X_RECOVERABLE_YN = 'Y' and NVL(X_ACTION_COST, 0) - NVL(x_old.ACTION_COST, 0) < 0 then
      -- new cost less then old cost - check amount
      x_alloc_payment := RNT_ACCOUNTS_RECEIVABLE_PKG.GET_MAX_ALLOC_FOR_AGR_ACTION(X_ACTION_ID);
      if X_ACTION_COST < NVL(x_alloc_payment, 0) then
        RAISE_APPLICATION_ERROR(-20045, 'Cannot update action record. Cause: find record about payment allocation. Action cost cannot be less '||NVL(x_alloc_payment, 0)||'.');
      end if; 
   end if;
   
   update_account_receivable(X_ACTION_ID, X_AGREEMENT_ID, X_ACTION_DATE, X_ACTION_COST);
   
   update RNT_AGREEMENT_ACTIONS
   set AGREEMENT_ID   = X_AGREEMENT_ID,
       ACTION_DATE    = X_ACTION_DATE,
       ACTION_TYPE    = X_ACTION_TYPE,
       COMMENTS       = X_COMMENTS,
       RECOVERABLE_YN = X_RECOVERABLE_YN,
       ACTION_COST    = X_ACTION_COST
   where ACTION_ID = X_ACTION_ID;
end;  

function insert_row(X_AGREEMENT_ID IN RNT_AGREEMENT_ACTIONS.AGREEMENT_ID%TYPE
  ,                   X_ACTION_DATE IN RNT_AGREEMENT_ACTIONS.ACTION_DATE%TYPE
  ,                   X_ACTION_TYPE IN RNT_AGREEMENT_ACTIONS.ACTION_TYPE%TYPE
  ,                   X_ACTION_COST IN RNT_AGREEMENT_ACTIONS.ACTION_COST%TYPE  
  ,                   X_COMMENTS IN RNT_AGREEMENT_ACTIONS.COMMENTS%TYPE
  ,                   X_RECOVERABLE_YN IN RNT_AGREEMENT_ACTIONS.RECOVERABLE_YN%TYPE  
  ) return RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE
is  
  x RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE;
begin

   if not check_unique(NULL, X_AGREEMENT_ID, X_ACTION_DATE, X_ACTION_TYPE) then
        RAISE_APPLICATION_ERROR(-20006, 'Action must be unique.');                      
   end if;

   insert into RNT_AGREEMENT_ACTIONS (
           ACTION_ID, AGREEMENT_ID, ACTION_DATE, 
           ACTION_TYPE, COMMENTS, RECOVERABLE_YN, 
           ACTION_COST) 
   values(RNT_AGREEMENT_ACTIONS_SEQ.NEXTVAL, X_AGREEMENT_ID, X_ACTION_DATE, 
          X_ACTION_TYPE, X_COMMENTS, X_RECOVERABLE_YN, 
          X_ACTION_COST)
   returning ACTION_ID into x;
   
   if X_RECOVERABLE_YN = 'Y' then
     append_account_receivable(x, X_AGREEMENT_ID, X_ACTION_DATE, X_ACTION_COST);
   end if;           
   return x;
end;
  

procedure delete_row(X_ACTION_ID IN RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE)
as
  x_alloc_payment NUMBER;
begin
  x_alloc_payment := RNT_ACCOUNTS_RECEIVABLE_PKG.GET_MAX_ALLOC_FOR_AGR_ACTION(X_ACTION_ID);
  if NVL(x_alloc_payment, 0) > 0 then
      RAISE_APPLICATION_ERROR(-20045, 'Cannot delete action record. Cause: find record of payment allocation.');
  end if;
   
  RNT_ACCOUNTS_RECEIVABLE_PKG.DELETE_AGR_ACTION_RECEIVABLE(X_ACTION_ID);
  
  delete from RNT_AGREEMENT_ACTIONS
  where ACTION_ID = X_ACTION_ID;
end;


END RNT_AGREEMENT_ACTIONS_PKG;
/


