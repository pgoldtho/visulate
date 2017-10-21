--------------------------------------------------------------------------
-- Play this script in TESTRNTMGR@XE to make it look like RNTMGR@XE
--                                                                      --
-- Please review the script before using it to make sure it won't       --
-- cause any unacceptable data loss.                                    --
--                                                                      --
-- TESTRNTMGR@XE Schema Extracted by User TESTRNTMGR 
-- RNTMGR@XE Schema Extracted by User RNTMGR 
ALTER TABLE RNT_SUPPLIERS
 ADD (BUSINESS_ID  NUMBER                           NOT NULL);


COMMENT ON COLUMN RNT_SUPPLIERS.BUSINESS_ID IS 'FK to business unit';
CREATE OR REPLACE PACKAGE        RNT_TENANCY_AGREEMENT_PKG AS
/******************************************************************************
   NAME:       RNT_TENANCY_AGREEMENT_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        06.04.2007             1. Created this package.
******************************************************************************/

function get_checksum(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE) return VARCHAR2;
procedure lock_row(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE);

procedure update_row(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE,
                     X_UNIT_ID RNT_TENANCY_AGREEMENT.UNIT_ID%TYPE,
                     X_AGREEMENT_DATE RNT_TENANCY_AGREEMENT.AGREEMENT_DATE%TYPE,
                     X_TERM RNT_TENANCY_AGREEMENT.TERM%TYPE,
                     X_AMOUNT RNT_TENANCY_AGREEMENT.AMOUNT%TYPE,
                     X_AMOUNT_PERIOD RNT_TENANCY_AGREEMENT.AMOUNT_PERIOD%TYPE,
                     X_DATE_AVAILABLE RNT_TENANCY_AGREEMENT.DATE_AVAILABLE%TYPE,
                     X_DEPOSIT RNT_TENANCY_AGREEMENT.DEPOSIT%TYPE,
                     X_LAST_MONTH RNT_TENANCY_AGREEMENT.LAST_MONTH%TYPE,
                     X_DISCOUNT_AMOUNT RNT_TENANCY_AGREEMENT.DISCOUNT_AMOUNT%TYPE,
                     X_DISCOUNT_TYPE RNT_TENANCY_AGREEMENT.DISCOUNT_TYPE%TYPE,
                     X_DISCOUNT_PERIOD RNT_TENANCY_AGREEMENT.DISCOUNT_PERIOD%TYPE,
                     X_END_DATE RNT_TENANCY_AGREEMENT.END_DATE%TYPE,
                     X_CHECKSUM VARCHAR2
                     );

function insert_row(X_UNIT_ID RNT_TENANCY_AGREEMENT.UNIT_ID%TYPE,
                     X_AGREEMENT_DATE RNT_TENANCY_AGREEMENT.AGREEMENT_DATE%TYPE,
                     X_TERM RNT_TENANCY_AGREEMENT.TERM%TYPE,
                     X_AMOUNT RNT_TENANCY_AGREEMENT.AMOUNT%TYPE,
                     X_AMOUNT_PERIOD RNT_TENANCY_AGREEMENT.AMOUNT_PERIOD%TYPE,
                     X_DATE_AVAILABLE RNT_TENANCY_AGREEMENT.DATE_AVAILABLE%TYPE,
                     X_DEPOSIT RNT_TENANCY_AGREEMENT.DEPOSIT%TYPE,
                     X_LAST_MONTH RNT_TENANCY_AGREEMENT.LAST_MONTH%TYPE,
                     X_DISCOUNT_AMOUNT RNT_TENANCY_AGREEMENT.DISCOUNT_AMOUNT%TYPE,
                     X_DISCOUNT_TYPE RNT_TENANCY_AGREEMENT.DISCOUNT_TYPE%TYPE,
                     X_DISCOUNT_PERIOD RNT_TENANCY_AGREEMENT.DISCOUNT_PERIOD%TYPE,
                     X_END_DATE RNT_TENANCY_AGREEMENT.END_DATE%TYPE
                     ) return RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE;

procedure delete_row(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE);

function get_business_id(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE) 
   return RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE;
 
END RNT_TENANCY_AGREEMENT_PKG;
/

SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY        RNT_TENANCY_AGREEMENT_PKG AS
/******************************************************************************
   NAME:       RNT_TENANCY_AGREEMENT_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        06.04.2007             1. Created this package body.
******************************************************************************/
function get_checksum(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE) return VARCHAR2
is
begin
for x in (select 
           AGREEMENT_ID, UNIT_ID, AGREEMENT_DATE, 
           TERM, AMOUNT, AMOUNT_PERIOD, 
           DATE_AVAILABLE, DEPOSIT, LAST_MONTH, 
           DISCOUNT_AMOUNT, DISCOUNT_TYPE, DISCOUNT_PERIOD, END_DATE
         from RNT_TENANCY_AGREEMENT
         where AGREEMENT_ID = X_AGREEMENT_ID) loop
         RNT_SYS_CHECKSUM_REC_PKG.INIT;
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.AGREEMENT_ID);         
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.UNIT_ID);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.AGREEMENT_DATE); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.TERM);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.AMOUNT);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.AMOUNT_PERIOD);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.DATE_AVAILABLE);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.DEPOSIT);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.LAST_MONTH);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.DISCOUNT_AMOUNT);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.DISCOUNT_TYPE);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.DISCOUNT_PERIOD);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.END_DATE);         
         return RNT_SYS_CHECKSUM_REC_PKG.GET_CHECKSUM;
   end loop;
   raise NO_DATA_FOUND;  
end;



function check_unique(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE, 
                      X_UNIT_ID RNT_TENANCY_AGREEMENT.UNIT_ID%TYPE,
                      X_DATE_AVAILABLE RNT_TENANCY_AGREEMENT.AGREEMENT_DATE%TYPE
                      ) return boolean
is
  x NUMBER;
begin
   select 1 
   into x
   from DUAL
   where exists (
                   select 1
                   from RNT_TENANCY_AGREEMENT
                   where UNIT_ID = X_UNIT_ID
                     and DATE_AVAILABLE = X_DATE_AVAILABLE
                     and (AGREEMENT_ID != X_AGREEMENT_ID or X_AGREEMENT_ID is null)
                 );
  return false;
exception
  when NO_DATA_FOUND then
     return true;                        
end;                       
                      

procedure lock_row(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE)
is
    cursor c is
              select 
               AGREEMENT_ID, UNIT_ID, AGREEMENT_DATE, 
               TERM, AMOUNT, AMOUNT_PERIOD, 
               DATE_AVAILABLE, DEPOSIT, LAST_MONTH, 
               DISCOUNT_AMOUNT, DISCOUNT_TYPE, DISCOUNT_PERIOD
             from RNT_TENANCY_AGREEMENT
             where AGREEMENT_ID = X_AGREEMENT_ID
             for update of AGREEMENT_ID nowait; 
begin
  open c;
  close c;
exception
  when OTHERS then
    if SQLCODE = -54 then
      RAISE_APPLICATION_ERROR(-20001, 'Cannot changed record. Record is locked.');
    end if; 
end;

procedure update_row(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE,
                     X_UNIT_ID RNT_TENANCY_AGREEMENT.UNIT_ID%TYPE,
                     X_AGREEMENT_DATE RNT_TENANCY_AGREEMENT.AGREEMENT_DATE%TYPE,
                     X_TERM RNT_TENANCY_AGREEMENT.TERM%TYPE,
                     X_AMOUNT RNT_TENANCY_AGREEMENT.AMOUNT%TYPE,
                     X_AMOUNT_PERIOD RNT_TENANCY_AGREEMENT.AMOUNT_PERIOD%TYPE,
                     X_DATE_AVAILABLE RNT_TENANCY_AGREEMENT.DATE_AVAILABLE%TYPE,
                     X_DEPOSIT RNT_TENANCY_AGREEMENT.DEPOSIT%TYPE,
                     X_LAST_MONTH RNT_TENANCY_AGREEMENT.LAST_MONTH%TYPE,
                     X_DISCOUNT_AMOUNT RNT_TENANCY_AGREEMENT.DISCOUNT_AMOUNT%TYPE,
                     X_DISCOUNT_TYPE RNT_TENANCY_AGREEMENT.DISCOUNT_TYPE%TYPE,
                     X_DISCOUNT_PERIOD RNT_TENANCY_AGREEMENT.DISCOUNT_PERIOD%TYPE,
                     X_END_DATE RNT_TENANCY_AGREEMENT.END_DATE%TYPE,
                     X_CHECKSUM VARCHAR2
                     )
is
l_checksum varchar2(32); 
begin
   
   lock_row(X_AGREEMENT_ID);
   
   -- validate checksum   
   l_checksum := get_checksum(X_AGREEMENT_ID);
   if X_CHECKSUM != l_checksum then
      RAISE_APPLICATION_ERROR(-20002, 'Record was changed another user.');
      --E_ROW_CHANGED_ANOTHER_USER  
   end if;

   if not check_unique(X_AGREEMENT_ID, X_UNIT_ID, X_DATE_AVAILABLE) then
        RAISE_APPLICATION_ERROR(-20006, 'Date available for unit must be unique');                      
   end if;   
   
   update RNT_TENANCY_AGREEMENT
   set  AGREEMENT_ID      = X_AGREEMENT_ID,
        UNIT_ID           = X_UNIT_ID,
        AGREEMENT_DATE    = X_AGREEMENT_DATE,
        TERM              = X_TERM,
        AMOUNT            = X_AMOUNT,
        AMOUNT_PERIOD     = X_AMOUNT_PERIOD,
        DATE_AVAILABLE    = X_DATE_AVAILABLE,
        DEPOSIT           = X_DEPOSIT,
        LAST_MONTH        = X_LAST_MONTH,
        DISCOUNT_AMOUNT   = X_DISCOUNT_AMOUNT,
        DISCOUNT_TYPE     = X_DISCOUNT_TYPE,
        DISCOUNT_PERIOD   = X_DISCOUNT_PERIOD,
        END_DATE          = X_END_DATE
   where AGREEMENT_ID     = X_AGREEMENT_ID;
end;                 

function insert_row(X_UNIT_ID RNT_TENANCY_AGREEMENT.UNIT_ID%TYPE,
                     X_AGREEMENT_DATE RNT_TENANCY_AGREEMENT.AGREEMENT_DATE%TYPE,
                     X_TERM RNT_TENANCY_AGREEMENT.TERM%TYPE,
                     X_AMOUNT RNT_TENANCY_AGREEMENT.AMOUNT%TYPE,
                     X_AMOUNT_PERIOD RNT_TENANCY_AGREEMENT.AMOUNT_PERIOD%TYPE,
                     X_DATE_AVAILABLE RNT_TENANCY_AGREEMENT.DATE_AVAILABLE%TYPE,
                     X_DEPOSIT RNT_TENANCY_AGREEMENT.DEPOSIT%TYPE,
                     X_LAST_MONTH RNT_TENANCY_AGREEMENT.LAST_MONTH%TYPE,
                     X_DISCOUNT_AMOUNT RNT_TENANCY_AGREEMENT.DISCOUNT_AMOUNT%TYPE,
                     X_DISCOUNT_TYPE RNT_TENANCY_AGREEMENT.DISCOUNT_TYPE%TYPE,
                     X_DISCOUNT_PERIOD RNT_TENANCY_AGREEMENT.DISCOUNT_PERIOD%TYPE,
                     X_END_DATE RNT_TENANCY_AGREEMENT.END_DATE%TYPE
                     ) return RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE
is
  x RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE;
begin

    if not check_unique(NULL, X_UNIT_ID, X_DATE_AVAILABLE) then
        RAISE_APPLICATION_ERROR(-20006, 'Date available for unit must be unique');                      
    end if;
    
    insert into RNT_TENANCY_AGREEMENT (
       AGREEMENT_ID, 
       UNIT_ID, 
       AGREEMENT_DATE, 
       TERM, 
       AMOUNT, 
       AMOUNT_PERIOD, 
       DATE_AVAILABLE, 
       DEPOSIT, 
       LAST_MONTH, 
       DISCOUNT_AMOUNT, 
       DISCOUNT_TYPE, 
       DISCOUNT_PERIOD,
       END_DATE) 
    values (
       RNT_TENANCY_AGREEMENT_SEQ.NEXTVAL, 
       X_UNIT_ID, 
       X_AGREEMENT_DATE, 
       X_TERM, 
       X_AMOUNT, 
       X_AMOUNT_PERIOD, 
       X_DATE_AVAILABLE, 
       X_DEPOSIT, 
       X_LAST_MONTH, 
       X_DISCOUNT_AMOUNT, 
       X_DISCOUNT_TYPE, 
       X_DISCOUNT_PERIOD,
       X_END_DATE)
    returning AGREEMENT_ID into x;
    return x;    
end;             
  
function is_exists_acc_receivable(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE) return boolean
is
 x NUMBER;
begin
  select 1
  into x
  from DUAL
  where exists (select 1
                from RNT_ACCOUNTS_RECEIVABLE
                where AGREEMENT_ID = X_AGREEMENT_ID
                );
  return true;
exception
  when NO_DATA_FOUND then
     return false;   
end;

procedure delete_row(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE)
is
begin
  -- check for exists child records
  if is_exists_acc_receivable(X_AGREEMENT_ID) then
     RAISE_APPLICATION_ERROR(-20004, 'Cannot delete record. For agreement exists accounts receivable.');
  end if;
      
  delete from RNT_AGREEMENT_ACTIONS
  where AGREEMENT_ID = X_AGREEMENT_ID;
  
  delete from RNT_TENANCY_AGREEMENT
  where AGREEMENT_ID = X_AGREEMENT_ID;
end;

function get_business_id(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE) 
  return RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE
is
  x RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE;
begin
  select p.BUSINESS_ID
  into x
  from RNT_TENANCY_AGREEMENT a,
       RNT_PROPERTY_UNITS u,
       RNT_PROPERTIES p
  where u.UNIT_ID = a.UNIT_ID
    and p.PROPERTY_ID = u.PROPERTY_ID     
    and a.AGREEMENT_ID = X_AGREEMENT_ID;
  return x;  
end;  
 
    
                     
END RNT_TENANCY_AGREEMENT_PKG;
/

SHOW ERRORS;

-- Difference: Status (no action taken since target is valid).
CREATE OR REPLACE FORCE VIEW RNT_ACCOUNTS_RECEIVABLE_V
(AR_ID, PAYMENT_DUE_DATE, AMOUNT, PAYMENT_TYPE, TENANT_ID, 
 AGREEMENT_ID, LOAN_ID, BUSINESS_ID, IS_GENERATED_YN, AGREEMENT_ACTION_ID, 
 PAYMENT_PROPERTY_ID, CHECKSUM, PROPERTY_ID, RECEIVABLE_TYPE_NAME, UNIT_NAME, 
 ADDRESS1, ZIPCODE, UNITS)
AS 
select ar.AR_ID
,      ar.PAYMENT_DUE_DATE
,      ar.AMOUNT
,      ar.PAYMENT_TYPE
,      ar.TENANT_ID
,      ar.AGREEMENT_ID
,      ar.LOAN_ID
,      ar.BUSINESS_ID
,      ar.IS_GENERATED_YN
,      ar.AGREEMENT_ACTION_ID
,      ar.PAYMENT_PROPERTY_ID
,      rnt_sys_checksum_rec_pkg.get_checksum('AR_ID='||ar.AR_ID||'PAYMENT_DUE_DATE='||ar.PAYMENT_DUE_DATE||'AMOUNT='||ar.AMOUNT||'PAYMENT_TYPE='||ar.PAYMENT_TYPE||'TENANT_ID='||ar.TENANT_ID||'AGREEMENT_ID='||ar.AGREEMENT_ID||'LOAN_ID='||ar.LOAN_ID||'BUSINESS_ID='||ar.BUSINESS_ID||'IS_GENERATED_YN='||ar.IS_GENERATED_YN||
        'AGREEMENT_ACTION_ID='||ar.AGREEMENT_ACTION_ID||'PAYMENT_PROPERTY_ID='||ar.PAYMENT_PROPERTY_ID) as CHECKSUM
,      u.PROPERTY_ID
,      pt.PAYMENT_TYPE_NAME as RECEIVABLE_TYPE_NAME
,      u.UNIT_NAME
,      prop.ADDRESS1
,      prop.ZIPCODE
,      prop.UNITS
from RNT_ACCOUNTS_RECEIVABLE ar,
     RNT_TENANCY_AGREEMENT a,
     RNT_PROPERTY_UNITS u,
     RNT_PAYMENT_TYPES pt,
     RNT_PROPERTIES prop
where a.AGREEMENT_ID = ar.AGREEMENT_ID
  and u.UNIT_ID = a.UNIT_ID
  and pt.PAYMENT_TYPE_ID = ar.PAYMENT_TYPE
  and prop.PROPERTY_ID = u.PROPERTY_ID;

-- No action taken.  This is a column of a view.  
-- Changes should be made in underlying objects of the view, not the view itself.

CREATE OR REPLACE FORCE VIEW RNT_USER_ASSIGNMENTS_V
(USER_ID, USER_LOGIN, USER_NAME, IS_ACTIVE_YN, ROLE_CODE, 
 ROLE_NAME, ROLE_ID, USER_ASSIGN_ID, BUSINESS_ID, BUSINESS_NAME, 
 PARENT_BUSINESS_ID, CHECKSUM)
AS 
select u.USER_ID, u.USER_LOGIN, u.USER_NAME, u.IS_ACTIVE_YN,
       r.ROLE_CODE, r.ROLE_NAME, r.ROLE_ID,
       a.USER_ASSIGN_ID, b.BUSINESS_ID, b.BUSINESS_NAME,
       b.PARENT_BUSINESS_ID,
       RNT_USER_ASSIGNMENTS_PKG.GET_CHECKSUM(a.USER_ASSIGN_ID) as CHECKSUM
from RNT_USERS u,
     RNT_USER_ROLES r,
     RNT_USER_ASSIGNMENTS a,
     RNT_BUSINESS_UNITS b
where a.ROLE_ID = r.ROLE_ID
  and a.USER_ID= u.USER_ID
  and a.BUSINESS_ID = b.BUSINESS_ID;

ALTER PACKAGE RNT_ACCOUNTS_PAYABLE_PKG COMPILE;

CREATE OR REPLACE package        RNT_ACCOUNTS_RECEIVABLE_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_ACCOUNTS_RECEIVABLE_PKG
    Purpose:   API's for RNT_ACCOUNTS_RECEIVABLE table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        14-MAY-07   Auto Generated   Initial Version
*******************************************************************************/
  PAYMENT_TYPE_RENT CONSTANT NUMBER := 7;
  PAYMENT_TYPE_DISCOUNT CONSTANT NUMBER := 8;
  PAYMENT_TYPE_RECOVERABLE CONSTANT NUMBER := 9;
  PAYMENT_TYPE_LATE_FEE CONSTANT NUMBER := 10;
  


  function get_checksum( X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE)
            return RNT_ACCOUNTS_RECEIVABLE_V.CHECKSUM%TYPE;

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
                      , X_PAYMENT_PROPERTY_ID IN RNT_PROPERTIES.PROPERTY_ID%TYPE
                      );

 procedure update_row_amount(  X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE
                      , X_AMOUNT IN RNT_ACCOUNTS_RECEIVABLE.AMOUNT%TYPE
                      , X_CHECKSUM IN RNT_ACCOUNTS_RECEIVABLE_V.CHECKSUM%TYPE
                      );
                      
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
              return RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE;

  procedure delete_row( X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE);
  
  -- return type of payment for p_now_date
  function get_type_of_payment(   p_payment_due_date DATE  -- due payment date
                                , p_now_date DATE          -- current date
                                , p_discount_period NUMBER -- days for discount period
                                , p_discount_type varchar2 -- discount type LATE_FEE or DISCOUNT
                                ) return number;
  
  function get_amount_for_payment(  p_payment_due_date DATE  -- due payment date
                                  , p_now_date DATE          -- current date
                                  , p_discount_period NUMBER -- days for discount period
                                  , p_amount NUMBER          -- amount for payment due date
                                  , p_discount_amount NUMBER -- discount amount
                                  , p_discount_type varchar2 -- discount type LATE_FEE or DISCOUNT
                                  , p_new_type out NUMBER   -- type for payment 
                                  ) return number;
                                  
  procedure update_payment_list;
  procedure generate_payment_list;
  
  procedure update_payment_from_allocation(
                                     X_AMOUNT IN RNT_PAYMENT_ALLOCATIONS.AMOUNT%TYPE, 
                                     X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE, 
                                     X_AR_ID IN RNT_PAYMENT_ALLOCATIONS.AR_ID%TYPE);
  
  function get_max_alloc_for_agr_action(X_ACTION_ID RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE) return NUMBER;
                                       
  procedure DELETE_AGR_ACTION_RECEIVABLE(X_ACTION_ID RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE);
end RNT_ACCOUNTS_RECEIVABLE_PKG;
/

SHOW ERRORS;

ALTER PACKAGE RNT_USERS_PKG COMPILE BODY;

ALTER PACKAGE RNT_ACCOUNTS_PAYABLE_PKG COMPILE BODY;

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
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


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
            return RNT_ACCOUNTS_RECEIVABLE_V.CHECKSUM%TYPE is 

    v_return_value               RNT_ACCOUNTS_RECEIVABLE_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_ACCOUNTS_RECEIVABLE_V
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
     l_checksum          RNT_ACCOUNTS_RECEIVABLE_V.CHECKSUM%TYPE;
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
                      , X_CHECKSUM IN RNT_ACCOUNTS_RECEIVABLE_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_ACCOUNTS_RECEIVABLE_V.CHECKSUM%TYPE;
  begin
     lock_row(X_AR_ID);

      -- validate checksum
      l_checksum := get_checksum(X_AR_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;
     
     update RNT_ACCOUNTS_RECEIVABLE
     set 
      AMOUNT = X_AMOUNT
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
     , X_PAYMENT_PROPERTY_ID)
     returning AR_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE) is
  begin
    delete from RNT_ACCOUNTS_RECEIVABLE
    where AR_ID = X_AR_ID;
  end delete_row;

  -- return type of payment for p_now_date
  function get_type_of_payment(   p_payment_due_date DATE  -- due payment date
                                , p_now_date DATE          -- current date
                                , p_discount_period NUMBER -- days for discount period
                                , p_discount_type varchar2 -- discount type LATE_FEE or DISCOUNT
                                ) return number
  is 
  begin
     /* p_current_type have values: 
        7  - Rent  
        8  - Discount Rent
        10 - Late Fee
     */
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
    /* p_current_type have values: 
        7  - Rent  
        8  - Discount Rent
        10 - Late Fee
    */
 
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
                   /*             
                   insert into RNT_ACCOUNTS_RECEIVABLE (
                           AR_ID, PAYMENT_DUE_DATE, AMOUNT, 
                           PAYMENT_TYPE, TENANT_ID, AGREEMENT_ID, 
                           LOAN_ID, BUSINESS_ID, IS_GENERATED_YN, 
                           SOURCE_FOR_LATE_FEE) 
                   values ( RNT_ACCOUNTS_RECEIVABLE_SEQ.NEXTVAL, x.PAYMENT_DUE_DATE+x.DISCOUNT_PERIOD, x.DISCOUNT_AMOUNT, 
                            10, x.TENANT_ID, x.AGREEMENT_ID,
                            NULL, x.BUSINESS_ID, 'Y',
                            x.AR_ID);
                   */              
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
              /*                                   
               if x_new_type = 10 then
                   -- late fee
                   insert into RNT_ACCOUNTS_RECEIVABLE (
                           AR_ID, PAYMENT_DUE_DATE, AMOUNT, 
                           PAYMENT_TYPE, TENANT_ID, AGREEMENT_ID, 
                           LOAN_ID, BUSINESS_ID, IS_GENERATED_YN, 
                           SOURCE_FOR_LATE_FEE) 
                   values ( RNT_ACCOUNTS_RECEIVABLE_SEQ.NEXTVAL, x.PAYMENT_DUE_DATE+x.DISCOUNT_PERIOD, x.AMOUNT + x.DISCOUNT_AMOUNT, 
                            10, x.TENANT_ID, x.AGREEMENT_ID,
                            NULL, x.BUSINESS_ID, 'Y',
                            x.AR_ID);
               end if;
               */             
            else
               RAISE_APPLICATION_ERROR(-20000, 'Error in algoriphm for calculate rental 1');         
            end if;
          end if;   
            
           if x.PAYMENT_TYPE = PAYMENT_TYPE_LATE_FEE then
               if x_new_type in (PAYMENT_TYPE_RENT, PAYMENT_TYPE_DISCOUNT) then
                   -- rent
                   /*
                   delete from RNT_ACCOUNTS_RECEIVABLE
                   where SOURCE_FOR_LATE_FEE = x.AR_ID;
                   */                                
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
             )) as NEXT_PAYMENT,
             a.AMOUNT,       
             a.AMOUNT_PERIOD,
             a.DISCOUNT_AMOUNT,
             a.DISCOUNT_TYPE,
             a.DISCOUNT_PERIOD,
             t.TENANT_ID,
             a.AGREEMENT_ID,
             p.BUSINESS_ID
     from RNT_TENANCY_AGREEMENT a,
          RNT_PROPERTY_UNITS u,
          RNT_TENANT t,
          (select TENANT_ID, max(PAYMENT_DUE_DATE) as MAX_PAYMENT_DATE 
           from RNT_ACCOUNTS_RECEIVABLE 
           where PAYMENT_TYPE in (PAYMENT_TYPE_RENT, PAYMENT_TYPE_DISCOUNT, PAYMENT_TYPE_LATE_FEE)
             and IS_GENERATED_YN = 'Y'
           group by TENANT_ID) max_payment,
          RNT_PROPERTIES p  
     where a.UNIT_ID = u.UNIT_ID
       and a.AGREEMENT_ID = t.AGREEMENT_ID 
       and SYSDATE <= NVL(a.END_DATE, to_date('4000', 'RRRR'))
       and trunc(decode(a.AMOUNT_PERIOD,
           'MONTH', ADD_MONTHS(SYSDATE, -1),
           'BI-MONTH', ADD_MONTHS(SYSDATE, -2),
           '2WEEKS', SYSDATE-14,
           'WEEK', SYSDATE-7
           )) >= (select NVL(max(PAYMENT_DUE_DATE), a.DATE_AVAILABLE) 
                  from RNT_ACCOUNTS_RECEIVABLE 
                  where TENANT_ID = t.TENANT_ID
                    and IS_GENERATED_YN = 'Y'
                    and PAYMENT_TYPE in (PAYMENT_TYPE_RENT, PAYMENT_TYPE_DISCOUNT, PAYMENT_TYPE_LATE_FEE))
       and max_payment.TENANT_ID(+) = t.TENANT_ID
       and p.PROPERTY_ID = u.PROPERTY_ID;
       
      x_need_type NUMBER;
      x_amount NUMBER;
      x_cnt NUMBER; 
  begin
    savepoint T_;
    x_cnt := 0;
    -- generate list from last payment 
    for x in c_new_payment loop
      x_amount := get_amount_for_payment(  
                                    p_payment_due_date =>x.NEXT_PAYMENT  -- due payment date
                                  , p_now_date =>trunc(SYSDATE)          -- current date
                                  , p_discount_period => x.DISCOUNT_PERIOD-- days for discount period
                                  , p_amount => x.AMOUNT        -- amount for payment due date
                                  , p_discount_amount => x.DISCOUNT_AMOUNT  -- discount amount
                                  , p_discount_type => x.DISCOUNT_TYPE -- discount type LATE_FEE or DISCOUNT
                                  , p_new_type => x_need_type
                                  );      
      insert into RNT_ACCOUNTS_RECEIVABLE (
               AR_ID, PAYMENT_DUE_DATE, AMOUNT, 
               PAYMENT_TYPE, TENANT_ID, AGREEMENT_ID, 
               LOAN_ID, BUSINESS_ID, IS_GENERATED_YN) 
      values (RNT_ACCOUNTS_RECEIVABLE_SEQ.NEXTVAL, x.NEXT_PAYMENT, x_amount,
        x_need_type, x.TENANT_ID, x.AGREEMENT_ID,
        NULL, x.BUSINESS_ID, 'Y');
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
    update_payment_list;
  end;
  
  /* 
     Function check then amount can be allocation for this payment
  */
  procedure update_payment_from_allocation(X_AMOUNT IN RNT_PAYMENT_ALLOCATIONS.AMOUNT%TYPE, 
                                           X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE, 
                                           X_AR_ID IN RNT_PAYMENT_ALLOCATIONS.AR_ID%TYPE)
  is
  cursor c_payment_1 is
     select ra.PAYMENT_TYPE
     from RNT_ACCOUNTS_RECEIVABLE ra
     where ra.AR_ID = X_AR_ID;
  cursor c_payment is
       select ra.PAYMENT_DUE_DATE,
              ta.AMOUNT,
              ra.PAYMENT_TYPE,
              ta.DISCOUNT_PERIOD,
              ta.DISCOUNT_TYPE, 
              ta.DISCOUNT_AMOUNT,
              ta.AMOUNT as AGR_AMOUNT
     from RNT_ACCOUNTS_RECEIVABLE ra,
          RNT_TENANCY_AGREEMENT ta 
     where ra.AR_ID = X_AR_ID
       and ta.AGREEMENT_ID = ra.AGREEMENT_ID;

  x_payment c_payment%ROWTYPE;
       
  cursor c_alloc is
    select NVL(sum(AMOUNT), 0) as SUM_AMOUNT,
           max(PAYMENT_DATE) as MAX_DATE
    from RNT_PAYMENT_ALLOCATIONS
    where AR_ID = X_AR_ID;
    
  x_alloc c_alloc%ROWTYPE;
  x_new_amount NUMBER;
  x_new_type NUMBER;
  
  x_date DATE;
  x_now_amount NUMBER;
  x_payment_type NUMBER;
  begin
  
    open c_payment_1;
    fetch c_payment_1 into x_payment_type;
    if c_payment_1%NOTFOUND then
      RAISE_APPLICATION_ERROR(-21000, 'Cannot found accont receivable AR_ID='||X_AR_ID);
    end if;
    close c_payment_1;
   /* 
    -- not rent, discount etc. 
    if (x_payment_type not in (7,8,10)) then
      return;
    end if;
     
    open c_payment;
    fetch c_payment into x_payment;
    if c_payment%NOTFOUND then
      RAISE_APPLICATION_ERROR(-21000, 'Cannot found accont receivable AR_ID='||X_AR_ID);
    end if;
    close c_payment;
    
    -- procedure calling for all account receiveable.  
    if x_payment.PAYMENT_TYPE not in (7, 8, 10) then
      return;
    end if;
    
    open c_alloc;
    fetch c_alloc into x_alloc;
    close c_alloc;
    
    -- calculate max date
    if x_alloc.MAX_DATE is null and X_PAYMENT_DATE is null then
       x_date := x_payment.PAYMENT_DUE_DATE;      
    elsif x_alloc.MAX_DATE is null or x_alloc.MAX_DATE < X_PAYMENT_DATE then
       x_date := X_PAYMENT_DATE;
    else      
       x_date := x_alloc.MAX_DATE;
    end if;     
    
    -- get payment type as if we payment in max allocation date
    x_new_amount := get_amount_for_payment(
                                    p_payment_due_date => x_payment.PAYMENT_DUE_DATE  -- due payment date
                                  , p_now_date => x_date          -- current date
                                  , p_discount_period => x_payment.DISCOUNT_PERIOD -- days for discount period
                                  , p_amount => x_payment.AMOUNT          -- amount for payment due date
                                  , p_discount_amount => x_payment.DISCOUNT_AMOUNT -- discount amount
                                  , p_discount_type => x_payment.DISCOUNT_TYPE -- discount type LATE_FEE or DISCOUNT
                                  , p_new_type => x_new_type   -- type for payment
                                );
    --
    x_now_amount := x_alloc.SUM_AMOUNT + X_AMOUNT;  
    
    if x_now_amount > x_new_amount then
       RAISE_APPLICATION_ERROR(-20567, 'New amount sum more then sum for payment in specified date ('||
                to_char(X_PAYMENT_DATE, 'MM/DD/RRRR')||'). Max allowed value for payment = '||
                (x_new_amount - x_alloc.SUM_AMOUNT));       
    end if;
    
    
       -- change type if need
   if x_payment.PAYMENT_TYPE != x_new_type then
       update RNT_ACCOUNTS_RECEIVABLE
       set AMOUNT = x_new_amount,
           PAYMENT_TYPE = x_new_type
       where AR_ID = X_AR_ID; 
   end if;
   */  
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
     /*
     delete from RNT_PAYMENT_ALLOCATIONS pa
     where exists (select 1
                   from RNT_ACCOUNTS_RECEIVABLE 
                   where AR_ID = pa.AR_ID
                     and AGREEMENT_ACTION_ID = X_ACTION_ID);
       */              
     delete from RNT_ACCOUNTS_RECEIVABLE 
     where AGREEMENT_ACTION_ID = X_ACTION_ID;                 
  end;
end RNT_ACCOUNTS_RECEIVABLE_PKG;
/

SHOW ERRORS;

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

SHOW ERRORS;

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

SHOW ERRORS;

CREATE OR REPLACE package RNT_SUPPLIERS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_SUPPLIERS_PKG
    Purpose:   API's for RNT_SUPPLIERS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        26-JUN-07   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_SUPPLIER_ID IN RNT_SUPPLIERS.SUPPLIER_ID%TYPE)
            return RNT_SUPPLIERS_V.CHECKSUM%TYPE;

  procedure update_row( X_SUPPLIER_ID IN RNT_SUPPLIERS.SUPPLIER_ID%TYPE
                      , X_NAME IN RNT_SUPPLIERS.NAME%TYPE
                      , X_PHONE1 IN RNT_SUPPLIERS.PHONE1%TYPE
                      , X_PHONE2 IN RNT_SUPPLIERS.PHONE2%TYPE
                      , X_ADDRESS1 IN RNT_SUPPLIERS.ADDRESS1%TYPE
                      , X_ADDRESS2 IN RNT_SUPPLIERS.ADDRESS2%TYPE
                      , X_CITY IN RNT_SUPPLIERS.CITY%TYPE
                      , X_STATE IN RNT_SUPPLIERS.STATE%TYPE
                      , X_ZIPCODE IN RNT_SUPPLIERS.ZIPCODE%TYPE
                      , X_SSN IN RNT_SUPPLIERS.SSN%TYPE
                      , X_EMAIL_ADDRESS IN RNT_SUPPLIERS.EMAIL_ADDRESS%TYPE
                      , X_COMMENTS IN RNT_SUPPLIERS.COMMENTS%TYPE
                      , X_BUSINESS_ID IN RNT_SUPPLIERS.BUSINESS_ID%TYPE
                      , X_CHECKSUM IN RNT_SUPPLIERS_V.CHECKSUM%TYPE);

  function insert_row( X_NAME IN RNT_SUPPLIERS.NAME%TYPE
                     , X_PHONE1 IN RNT_SUPPLIERS.PHONE1%TYPE
                     , X_PHONE2 IN RNT_SUPPLIERS.PHONE2%TYPE
                     , X_ADDRESS1 IN RNT_SUPPLIERS.ADDRESS1%TYPE
                     , X_ADDRESS2 IN RNT_SUPPLIERS.ADDRESS2%TYPE
                     , X_CITY IN RNT_SUPPLIERS.CITY%TYPE
                     , X_STATE IN RNT_SUPPLIERS.STATE%TYPE
                     , X_ZIPCODE IN RNT_SUPPLIERS.ZIPCODE%TYPE
                     , X_SSN IN RNT_SUPPLIERS.SSN%TYPE
                     , X_EMAIL_ADDRESS IN RNT_SUPPLIERS.EMAIL_ADDRESS%TYPE
                     , X_COMMENTS IN RNT_SUPPLIERS.COMMENTS%TYPE
                     , X_BUSINESS_ID IN RNT_SUPPLIERS.BUSINESS_ID%TYPE)
              return RNT_SUPPLIERS.SUPPLIER_ID%TYPE;

  procedure delete_row( X_SUPPLIER_ID IN RNT_SUPPLIERS.SUPPLIER_ID%TYPE);

end RNT_SUPPLIERS_PKG;
/

SHOW ERRORS;

ALTER PACKAGE RNT_PROPERTY_UNITS_PKG COMPILE BODY;

ALTER PACKAGE RNT_PAYMENTS_PKG COMPILE BODY;

CREATE OR REPLACE package body RNT_SUPPLIERS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_SUPPLIERS_PKG
    Purpose:   API's for RNT_SUPPLIERS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        26-JUN-07   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------
  function check_unique( X_SUPPLIER_ID IN RNT_SUPPLIERS.SUPPLIER_ID%TYPE
                       , X_NAME IN RNT_SUPPLIERS.NAME%TYPE) return boolean is
        cursor c is
        select SUPPLIER_ID
        from RNT_SUPPLIERS
        where NAME = X_NAME;

      begin
         for c_rec in c loop
           if (X_SUPPLIER_ID is null OR c_rec.SUPPLIER_ID != X_SUPPLIER_ID) then
             return false;
           end if;
         end loop;
         return true;
      end check_unique;

  procedure lock_row( X_SUPPLIER_ID IN RNT_SUPPLIERS.SUPPLIER_ID%TYPE) is
     cursor c is
     select * from RNT_SUPPLIERS
     where SUPPLIER_ID = X_SUPPLIER_ID
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
  function get_checksum( X_SUPPLIER_ID IN RNT_SUPPLIERS.SUPPLIER_ID%TYPE)
            return RNT_SUPPLIERS_V.CHECKSUM%TYPE is 

    v_return_value               RNT_SUPPLIERS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_SUPPLIERS_V
    where SUPPLIER_ID = X_SUPPLIER_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_SUPPLIER_ID IN RNT_SUPPLIERS.SUPPLIER_ID%TYPE
                      , X_NAME IN RNT_SUPPLIERS.NAME%TYPE
                      , X_PHONE1 IN RNT_SUPPLIERS.PHONE1%TYPE
                      , X_PHONE2 IN RNT_SUPPLIERS.PHONE2%TYPE
                      , X_ADDRESS1 IN RNT_SUPPLIERS.ADDRESS1%TYPE
                      , X_ADDRESS2 IN RNT_SUPPLIERS.ADDRESS2%TYPE
                      , X_CITY IN RNT_SUPPLIERS.CITY%TYPE
                      , X_STATE IN RNT_SUPPLIERS.STATE%TYPE
                      , X_ZIPCODE IN RNT_SUPPLIERS.ZIPCODE%TYPE
                      , X_SSN IN RNT_SUPPLIERS.SSN%TYPE
                      , X_EMAIL_ADDRESS IN RNT_SUPPLIERS.EMAIL_ADDRESS%TYPE
                      , X_COMMENTS IN RNT_SUPPLIERS.COMMENTS%TYPE
                      , X_BUSINESS_ID IN RNT_SUPPLIERS.BUSINESS_ID%TYPE
                      , X_CHECKSUM IN RNT_SUPPLIERS_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_SUPPLIERS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_SUPPLIER_ID);

      -- validate checksum
      l_checksum := get_checksum(X_SUPPLIER_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;
     
         if not check_unique(X_SUPPLIER_ID, X_NAME) then
             RAISE_APPLICATION_ERROR(-20006, 'Update values must be unique.');
         end if;
     update RNT_SUPPLIERS
     set NAME = X_NAME
     , PHONE1 = X_PHONE1
     , PHONE2 = X_PHONE2
     , ADDRESS1 = X_ADDRESS1
     , ADDRESS2 = X_ADDRESS2
     , CITY = X_CITY
     , STATE = X_STATE
     , ZIPCODE = X_ZIPCODE
     , SSN = X_SSN
     , EMAIL_ADDRESS = X_EMAIL_ADDRESS
     , COMMENTS = X_COMMENTS
     , BUSINESS_ID = X_BUSINESS_ID
     where SUPPLIER_ID = X_SUPPLIER_ID;

  end update_row;

  function insert_row( X_NAME IN RNT_SUPPLIERS.NAME%TYPE
                     , X_PHONE1 IN RNT_SUPPLIERS.PHONE1%TYPE
                     , X_PHONE2 IN RNT_SUPPLIERS.PHONE2%TYPE
                     , X_ADDRESS1 IN RNT_SUPPLIERS.ADDRESS1%TYPE
                     , X_ADDRESS2 IN RNT_SUPPLIERS.ADDRESS2%TYPE
                     , X_CITY IN RNT_SUPPLIERS.CITY%TYPE
                     , X_STATE IN RNT_SUPPLIERS.STATE%TYPE
                     , X_ZIPCODE IN RNT_SUPPLIERS.ZIPCODE%TYPE
                     , X_SSN IN RNT_SUPPLIERS.SSN%TYPE
                     , X_EMAIL_ADDRESS IN RNT_SUPPLIERS.EMAIL_ADDRESS%TYPE
                     , X_COMMENTS IN RNT_SUPPLIERS.COMMENTS%TYPE
                     , X_BUSINESS_ID IN RNT_SUPPLIERS.BUSINESS_ID%TYPE)
              return RNT_SUPPLIERS.SUPPLIER_ID%TYPE
  is
     x          number;
  begin
if not check_unique(NULL, X_NAME) then
         RAISE_APPLICATION_ERROR(-20006, 'Insert values must be unique.');
     end if;
  
     insert into RNT_SUPPLIERS
     ( SUPPLIER_ID
     , NAME
     , PHONE1
     , PHONE2
     , ADDRESS1
     , ADDRESS2
     , CITY
     , STATE
     , ZIPCODE
     , SSN
     , EMAIL_ADDRESS
     , COMMENTS
     , BUSINESS_ID)
     values
     ( RNT_SUPPLIERS_SEQ.NEXTVAL
     , X_NAME
     , X_PHONE1
     , X_PHONE2
     , X_ADDRESS1
     , X_ADDRESS2
     , X_CITY
     , X_STATE
     , X_ZIPCODE
     , X_SSN
     , X_EMAIL_ADDRESS
     , X_COMMENTS
     , X_BUSINESS_ID)
     returning SUPPLIER_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_SUPPLIER_ID IN RNT_SUPPLIERS.SUPPLIER_ID%TYPE) is

  begin
    delete from RNT_SUPPLIERS
    where SUPPLIER_ID = X_SUPPLIER_ID;

  end delete_row;

end RNT_SUPPLIERS_PKG;
/

SHOW ERRORS;

ALTER PACKAGE RNT_BUSINESS_UNITS_PKG COMPILE BODY;

CREATE OR REPLACE FORCE VIEW RNT_PEOPLE_LIST_V
(PEOPLE_ID, FIRST_NAME, LAST_NAME, PHONE1, PHONE2, 
 DATE_OF_BIRTH, EMAIL_ADDRESS, SSN, DRIVERS_LICENSE, BUSINESS_ID, 
 IS_ENABLED_YN, CHECKSUM)
AS 
select p.PEOPLE_ID, p.FIRST_NAME, p.LAST_NAME, 
       p.PHONE1, p.PHONE2, p.DATE_OF_BIRTH, p.EMAIL_ADDRESS, 
       p.SSN, p.DRIVERS_LICENSE, p.BUSINESS_ID, 
       p.IS_ENABLED_YN,
       RNT_PEOPLE_PKG.GET_CHECKSUM(p.PEOPLE_ID) as CHECKSUM
from RNT_PEOPLE p,
     RNT_BUSINESS_UNITS_V bu
where bu.PARENT_BUSINESS_ID = 0
  and p.BUSINESS_ID = bu.BUSINESS_ID;

ALTER VIEW RNT_TENANT_V1 COMPILE;

CREATE OR REPLACE FORCE VIEW RNT_SUPPLIERS_V
(SUPPLIER_ID, NAME, PHONE1, PHONE2, ADDRESS1, 
 ADDRESS2, CITY, STATE, ZIPCODE, SSN, 
 EMAIL_ADDRESS, COMMENTS, BUSINESS_ID, CHECKSUM)
AS 
select s.SUPPLIER_ID
,      s.NAME
,      s.PHONE1
,      s.PHONE2
,      s.ADDRESS1
,      s.ADDRESS2
,      s.CITY
,      s.STATE
,      s.ZIPCODE
,      s.SSN
,      s.EMAIL_ADDRESS
,      s.COMMENTS
,      s.BUSINESS_ID
,      rnt_sys_checksum_rec_pkg.get_checksum('SUPPLIER_ID='||s.SUPPLIER_ID||'NAME='||s.NAME||'PHONE1='||s.PHONE1||'PHONE2='||s.PHONE2||'ADDRESS1='||s.ADDRESS1||'ADDRESS2='||s.ADDRESS2||'CITY='||s.CITY||'STATE='||s.STATE||'ZIPCODE='||s.ZIPCODE||'SSN='||s.SSN||'EMAIL_ADDRESS='||s.EMAIL_ADDRESS||'COMMENTS='||s.COMMENTS||'BUSINESS_ID='||s.BUSINESS_ID) as CHECKSUM
from RNT_SUPPLIERS s,
     RNT_BUSINESS_UNITS_V bu
where bu.PARENT_BUSINESS_ID = 0
  and s.BUSINESS_ID = bu.BUSINESS_ID;

ALTER VIEW RNT_BUSINESS_UNITS_V COMPILE;

ALTER VIEW RNT_PROPERTIES_V COMPILE;

ALTER VIEW RNT_PROPERTY_UNITS_V COMPILE;

ALTER VIEW RNT_TENANCY_AGREEMENT_V COMPILE;

ALTER TABLE RNT_SUPPLIERS
 ADD CONSTRAINT RNT_SUPPLIERS_FK 
 FOREIGN KEY (BUSINESS_ID) 
 REFERENCES RNT_BUSINESS_UNITS (BUSINESS_ID);

 