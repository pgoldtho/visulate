--------------------------------------------------------------------------
-- Play this script in TESTRNTMGR@XE to make it look like RNTMGR@XE
--                                                                      --
-- Please review the script before using it to make sure it won't       --
-- cause any unacceptable data loss.                                    --
--                                                                      --
-- TESTRNTMGR@XE Schema Extracted by User TESTRNTMGR 
-- RNTMGR@XE Schema Extracted by User RNTMGR 
ALTER TABLE RNT_ACCOUNTS_RECEIVABLE
 ADD (SOURCE_PAYMENT_ID  NUMBER);

ALTER TABLE RNT_ACCOUNTS_RECEIVABLE DROP COLUMN SOURCE_FOR_LATE_FEE;


COMMENT ON COLUMN RNT_ACCOUNTS_RECEIVABLE.SOURCE_PAYMENT_ID IS 'Source payment ID';
CREATE OR REPLACE PACKAGE BODY        RNT_TENANT_PKG AS
/******************************************************************************
   NAME:       RNT_TENANT_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        29.04.2007             1. Created this package body.
******************************************************************************/

function get_checksum(X_TENANT_ID RNT_TENANT.TENANT_ID%TYPE) return VARCHAR2
is
begin
for x in (select 
           TENANT_ID, AGREEMENT_ID, STATUS, 
           DEPOSIT_BALANCE, LAST_MONTH_BALANCE, PEOPLE_ID, 
           SECTION8_VOUCHER_AMOUNT, SECTION8_TENANT_PAYS, SECTION8_ID,
           TENANT_NOTE
         from RNT_TENANT
         where TENANT_ID = X_TENANT_ID         
         ) loop
         RNT_SYS_CHECKSUM_REC_PKG.INIT;
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.TENANT_ID);         
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.AGREEMENT_ID);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.STATUS); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.DEPOSIT_BALANCE);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.LAST_MONTH_BALANCE);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.PEOPLE_ID);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.SECTION8_VOUCHER_AMOUNT);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.SECTION8_TENANT_PAYS);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.SECTION8_ID);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.TENANT_NOTE);
         return RNT_SYS_CHECKSUM_REC_PKG.GET_CHECKSUM;
   end loop;
   raise NO_DATA_FOUND;  
end;

procedure lock_row(X_TENANT_ID RNT_TENANT.TENANT_ID%TYPE)
is
cursor c is
   select *
   from RNT_TENANT              
   for update of TENANT_ID nowait; 
begin
  open c;
  close c;
exception
  when OTHERS then
    if SQLCODE = -54 then
      RAISE_APPLICATION_ERROR(-20001, 'Cannot changed record. Record is locked.');
    end if; 
end;

function check_unique(X_TENANT_ID RNT_TENANT.TENANT_ID%TYPE, 
                      X_AGREEMENT_ID RNT_TENANT.AGREEMENT_ID%TYPE,
                      X_PEOPLE_ID RNT_TENANT.PEOPLE_ID%TYPE
                      ) return boolean
is
  x NUMBER;
begin
   select 1 
   into x
   from DUAL
   where exists (
                   select 1
                   from RNT_TENANT
                   where PEOPLE_ID = X_PEOPLE_ID
                     and AGREEMENT_ID = X_AGREEMENT_ID
                     and (TENANT_ID != X_TENANT_ID or X_TENANT_ID is null)
                 );
  return false;
exception
  when NO_DATA_FOUND then
     return true;                        
end;        

function check_unique_current(X_TENANT_ID RNT_TENANT.TENANT_ID%TYPE,
                              X_AGREEMENT_ID RNT_TENANT.AGREEMENT_ID%TYPE,
                              X_STATUS RNT_TENANT.STATUS%TYPE) return boolean
is
  x NUMBER;
begin
   if X_STATUS != 'CURRENT' then
     return TRUE; 
   end if;
   
   select 1 
   into x
   from DUAL
   where exists (
                   select 1
                   from RNT_TENANT
                   where AGREEMENT_ID = X_AGREEMENT_ID
                     and (TENANT_ID != X_TENANT_ID or X_TENANT_ID is null)
                     and STATUS = 'CURRENT'
                 );
  return false;
exception
  when NO_DATA_FOUND then
     return true;                        
end;                              
                              

procedure short_update_row(X_TENANT_ID RNT_TENANT.TENANT_ID%TYPE,
                     X_AGREEMENT_ID RNT_TENANT.AGREEMENT_ID%TYPE,
                     X_STATUS RNT_TENANT.STATUS%TYPE,
                     X_DEPOSIT_BALANCE RNT_TENANT.DEPOSIT_BALANCE%TYPE,
                     X_LAST_MONTH_BALANCE RNT_TENANT.LAST_MONTH_BALANCE%TYPE,
                     X_PEOPLE_ID RNT_TENANT.PEOPLE_ID%TYPE,
                     X_SECTION8_VOUCHER_AMOUNT RNT_TENANT.SECTION8_VOUCHER_AMOUNT%TYPE,
                     X_SECTION8_TENANT_PAYS RNT_TENANT.SECTION8_TENANT_PAYS%TYPE,
                     X_SECTION8_ID RNT_TENANT.SECTION8_ID%TYPE,
                     X_CHECKSUM VARCHAR2
                     )
is
l_checksum varchar2(32); 
begin
   
   lock_row(X_TENANT_ID);
   
   -- validate checksum   
   l_checksum := get_checksum(X_TENANT_ID);
   if X_CHECKSUM != l_checksum then
      RAISE_APPLICATION_ERROR(-20002, 'Record was changed another user.');
   end if;

   if not check_unique(X_TENANT_ID, X_AGREEMENT_ID, X_PEOPLE_ID) then
        RAISE_APPLICATION_ERROR(-20006, 'People for agreement must be unique');                      
   end if;   
   
   if not check_unique_current(X_TENANT_ID, X_AGREEMENT_ID, X_STATUS) then
        RAISE_APPLICATION_ERROR(-20007, 'Tenant with status "Current - Primary", must be one in agreement.');    
   end if; 
   
   update RNT_TENANT
   set 
        AGREEMENT_ID            = X_AGREEMENT_ID,
        STATUS                  = X_STATUS,
        DEPOSIT_BALANCE         = X_DEPOSIT_BALANCE,
        LAST_MONTH_BALANCE      = X_LAST_MONTH_BALANCE,
        PEOPLE_ID               = X_PEOPLE_ID,
        SECTION8_VOUCHER_AMOUNT = X_SECTION8_VOUCHER_AMOUNT,
        SECTION8_TENANT_PAYS    = X_SECTION8_TENANT_PAYS,
        SECTION8_ID             = X_SECTION8_ID
   where TENANT_ID = X_TENANT_ID;
end;  
       
function insert_row(X_AGREEMENT_ID RNT_TENANT.AGREEMENT_ID%TYPE,
                    X_STATUS RNT_TENANT.STATUS%TYPE,
                    X_DEPOSIT_BALANCE RNT_TENANT.DEPOSIT_BALANCE%TYPE,
                    X_LAST_MONTH_BALANCE RNT_TENANT.LAST_MONTH_BALANCE%TYPE,
                    X_PEOPLE_ID RNT_TENANT.PEOPLE_ID%TYPE,
                    X_SECTION8_VOUCHER_AMOUNT RNT_TENANT.SECTION8_VOUCHER_AMOUNT%TYPE,
                    X_SECTION8_TENANT_PAYS RNT_TENANT.SECTION8_TENANT_PAYS%TYPE,
                    X_SECTION8_ID RNT_TENANT.SECTION8_ID%TYPE
                   ) return RNT_TENANT.TENANT_ID%TYPE
is
x RNT_TENANT.TENANT_ID%TYPE;
begin

   if not check_unique(NULL, X_AGREEMENT_ID, X_PEOPLE_ID) then
        RAISE_APPLICATION_ERROR(-20006, 'People for agreement must be unique');                      
   end if;   

   if not check_unique_current(NULL, X_AGREEMENT_ID, X_STATUS) then
                RAISE_APPLICATION_ERROR(-20007, 'Tenant with status "Current - Primary", must be one in agreement.');                      
   end if;   
   
   insert into RNT_TENANT (
       TENANT_ID, AGREEMENT_ID, STATUS, 
       DEPOSIT_BALANCE, LAST_MONTH_BALANCE, PEOPLE_ID, 
       SECTION8_VOUCHER_AMOUNT, SECTION8_TENANT_PAYS, SECTION8_ID) 
   values (RNT_TENANT_SEQ.NEXTVAL, X_AGREEMENT_ID, X_STATUS, 
       X_DEPOSIT_BALANCE, X_LAST_MONTH_BALANCE, X_PEOPLE_ID, 
       X_SECTION8_VOUCHER_AMOUNT, X_SECTION8_TENANT_PAYS, X_SECTION8_ID
       )
   returning TENANT_ID into x;
   return x;  
end;                   

procedure update_row(X_TENANT_ID RNT_TENANT.TENANT_ID%TYPE,
                     X_AGREEMENT_ID RNT_TENANT.AGREEMENT_ID%TYPE,
                     X_STATUS RNT_TENANT.STATUS%TYPE,
                     X_DEPOSIT_BALANCE RNT_TENANT.DEPOSIT_BALANCE%TYPE,
                     X_LAST_MONTH_BALANCE RNT_TENANT.LAST_MONTH_BALANCE%TYPE,
                     X_PEOPLE_ID RNT_TENANT.PEOPLE_ID%TYPE,
                     X_SECTION8_VOUCHER_AMOUNT RNT_TENANT.SECTION8_VOUCHER_AMOUNT%TYPE,
                     X_SECTION8_TENANT_PAYS RNT_TENANT.SECTION8_TENANT_PAYS%TYPE,
                     X_SECTION8_ID RNT_TENANT.SECTION8_ID%TYPE,
                     X_CHECKSUM VARCHAR2,
                     X_TENANT_NOTE RNT_TENANT.TENANT_NOTE%TYPE
                     )
is
l_checksum varchar2(32); 
begin
   
   lock_row(X_TENANT_ID);
   
   -- validate checksum   
   l_checksum := get_checksum(X_TENANT_ID);
   if X_CHECKSUM != l_checksum then
      RAISE_APPLICATION_ERROR(-20002, 'Record was changed another user.');
   end if;

   if not check_unique(X_TENANT_ID, X_AGREEMENT_ID, X_PEOPLE_ID) then
        RAISE_APPLICATION_ERROR(-20006, 'People for agreement must be unique');                      
   end if;   

   if not check_unique_current(X_TENANT_ID, X_AGREEMENT_ID, X_STATUS) then
        RAISE_APPLICATION_ERROR(-20007, 'Tenant with status "Current - Primary", must be one in agreement.');    
   end if; 
   
   update RNT_TENANT
   set 
        AGREEMENT_ID            = X_AGREEMENT_ID,
        STATUS                  = X_STATUS,
        DEPOSIT_BALANCE         = X_DEPOSIT_BALANCE,
        LAST_MONTH_BALANCE      = X_LAST_MONTH_BALANCE,
        PEOPLE_ID               = X_PEOPLE_ID,
        SECTION8_VOUCHER_AMOUNT = X_SECTION8_VOUCHER_AMOUNT,
        SECTION8_TENANT_PAYS    = X_SECTION8_TENANT_PAYS,
        SECTION8_ID             = X_SECTION8_ID,
        TENANT_NOTE             = X_TENANT_NOTE
   where TENANT_ID = X_TENANT_ID;
end; 

procedure delete_row(X_TENANT_ID RNT_TENANT.TENANT_ID%TYPE)
is
begin
    delete from RNT_TENANT
    where TENANT_ID = X_TENANT_ID;
end;

END RNT_TENANT_PKG;
/

SHOW ERRORS;

CREATE OR REPLACE FORCE VIEW RNT_ACCOUNTS_RECEIVABLE_V
(AR_ID, PAYMENT_DUE_DATE, AMOUNT, PAYMENT_TYPE, TENANT_ID, 
 AGREEMENT_ID, LOAN_ID, BUSINESS_ID, IS_GENERATED_YN, AGREEMENT_ACTION_ID, 
 PAYMENT_PROPERTY_ID, CHECKSUM, PROPERTY_ID, RECEIVABLE_TYPE_NAME, UNIT_NAME, 
 ADDRESS1, ZIPCODE, UNITS, SOURCE_PAYMENT_ID, TENANT_NAME)
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
        'AGREEMENT_ACTION_ID='||ar.AGREEMENT_ACTION_ID||'PAYMENT_PROPERTY_ID='||ar.PAYMENT_PROPERTY_ID||
        'SOURCE_PAYMENT_ID'||ar.SOURCE_PAYMENT_ID) as CHECKSUM
,      u.PROPERTY_ID
,      pt.PAYMENT_TYPE_NAME as RECEIVABLE_TYPE_NAME
,      u.UNIT_NAME
,      prop.ADDRESS1
,      prop.ZIPCODE
,      prop.UNITS
,      ar.SOURCE_PAYMENT_ID
,      p.LAST_NAME||' '||p.FIRST_NAME as TENANT_NAME
from RNT_ACCOUNTS_RECEIVABLE ar,
     RNT_TENANT t,
     RNT_PEOPLE p,
     RNT_TENANCY_AGREEMENT a,
     RNT_PROPERTY_UNITS u,
     RNT_PAYMENT_TYPES pt,
     RNT_PROPERTIES prop
where a.AGREEMENT_ID = ar.AGREEMENT_ID
  and u.UNIT_ID = a.UNIT_ID
  and pt.PAYMENT_TYPE_ID = ar.PAYMENT_TYPE
  and prop.PROPERTY_ID = u.PROPERTY_ID
  and t.TENANT_ID = ar.TENANT_ID
  and p.PEOPLE_ID = t.PEOPLE_ID;

CREATE OR REPLACE FORCE VIEW RNT_ACCOUNTS_RECEIVABLE_PROP_V
(AR_ID, PAYMENT_DUE_DATE, AMOUNT, PAYMENT_TYPE, TENANT_ID, 
 AGREEMENT_ID, LOAN_ID, BUSINESS_ID, IS_GENERATED_YN, AGREEMENT_ACTION_ID, 
 PAYMENT_PROPERTY_ID, PROPERTY_NAME, CHECKSUM)
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
,      p.ADDRESS1 as PROPERTY_NAME
,      rnt_sys_checksum_rec_pkg.get_checksum('AR_ID='||ar.AR_ID||'PAYMENT_DUE_DATE='||ar.PAYMENT_DUE_DATE||'AMOUNT='||ar.AMOUNT||'PAYMENT_TYPE='||ar.PAYMENT_TYPE||'TENANT_ID='||ar.TENANT_ID||'AGREEMENT_ID='||ar.AGREEMENT_ID||'LOAN_ID='||ar.LOAN_ID||'BUSINESS_ID='||ar.BUSINESS_ID||'IS_GENERATED_YN='||ar.IS_GENERATED_YN||
        'AGREEMENT_ACTION_ID='||ar.AGREEMENT_ACTION_ID||'PAYMENT_PROPERTY_ID='||ar.PAYMENT_PROPERTY_ID) as CHECKSUM
 from RNT_ACCOUNTS_RECEIVABLE ar,
     RNT_PROPERTIES p
where ar.PAYMENT_PROPERTY_ID = p.PROPERTY_ID;

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
function PAYMENT_TYPE_RENT return NUMBER; -- CONSTANT NUMBER := 7;
function PAYMENT_TYPE_DISCOUNT_RENT return NUMBER; -- CONSTANT NUMBER := 8;
function PAYMENT_TYPE_RECOVERABLE return NUMBER; -- CONSTANT NUMBER := 9;
function PAYMENT_TYPE_LATE_FEE return NUMBER; --  CONSTANT NUMBER := 10;
function PAYMENT_TYPE_REMAINING_RENT return NUMBER; --  CONSTANT NUMBER := 13;
  

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
  /*
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
  */
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
             t.TENANT_ID
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
                                               
      insert into RNT_ACCOUNTS_RECEIVABLE (
           AR_ID, PAYMENT_DUE_DATE, AMOUNT, 
           PAYMENT_TYPE, TENANT_ID, AGREEMENT_ID, 
           LOAN_ID, BUSINESS_ID, IS_GENERATED_YN, 
           AGREEMENT_ACTION_ID, PAYMENT_PROPERTY_ID, SOURCE_PAYMENT_ID) 
       values (RNT_ACCOUNTS_RECEIVABLE_SEQ.NEXTVAL, x.NEXT_PAYMENT_DATE, x_amount,
            x_payment_type1, x.TENANT_ID, x.AGREEMENT_ID,
            NULL, x.BUSINESS_ID, 'Y',
            NULL, NULL, NULL)
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
                    NULL, NULL, x_ar_id);
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
end RNT_ACCOUNTS_RECEIVABLE_PKG;
/

SHOW ERRORS;

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

SHOW ERRORS;

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
     RNT_BUSINESS_UNITS_V bu,
     RNT_LOOKUP_VALUES_V v
where bu.PARENT_BUSINESS_ID = 0
  and s.BUSINESS_ID = bu.BUSINESS_ID
  and v.LOOKUP_TYPE_CODE = 'STATES'
  and v.LOOKUP_CODE = s.STATE;

ALTER TABLE RNT_ACCOUNTS_RECEIVABLE
 ADD CONSTRAINT RNT_ACCOUNTS_RECEIVABLE_FK7 
 FOREIGN KEY (SOURCE_PAYMENT_ID) 
 REFERENCES RNT_ACCOUNTS_RECEIVABLE (AR_ID);

 