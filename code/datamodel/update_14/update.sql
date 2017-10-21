--------------------------------------------------------------------------
-- Play this script in TESTRNTMGR@XE to make it look like RNTMGR@XE
--                                                                      --
-- Please review the script before using it to make sure it won't       --
-- cause any unacceptable data loss.                                    --
--                                                                      --
-- TESTRNTMGR@XE Schema Extracted by User TESTRNTMGR 
-- RNTMGR@XE Schema Extracted by User RNTMGR 
CREATE OR REPLACE FORCE VIEW RNT_PROPERTY_EXPENSES_V
(EXPENSE_ID, PROPERTY_ID, EVENT_DATE, DESCRIPTION, RECURRING_YN, 
 RECURRING_PERIOD, RECURRING_ENDDATE, UNIT_ID, CHECKSUM, UNIT_NAME)
AS 
select e.EXPENSE_ID
,      e.PROPERTY_ID
,      e.EVENT_DATE
,      e.DESCRIPTION
,      e.RECURRING_YN
,      e.RECURRING_PERIOD
,      e.RECURRING_ENDDATE
,      e.UNIT_ID
,      rnt_sys_checksum_rec_pkg.get_checksum(
             'PROPERTY_ID='||e.PROPERTY_ID||'EVENT_DATE='||e.EVENT_DATE||
             'DESCRIPTION='||e.DESCRIPTION||'RECURRING_YN='||e.RECURRING_YN||
             'RECURRING_PERIOD='||e.RECURRING_PERIOD||'RECURRING_ENDDATE='||e.RECURRING_ENDDATE||
             'UNIT_ID='||e.UNIT_ID) as CHECKSUM
,      u.UNIT_NAME              
from RNT_PROPERTY_EXPENSES e,
     RNT_PROPERTY_UNITS u
where e.UNIT_ID = u.UNIT_ID(+);

ALTER TABLE RNT_ACCOUNTS_PAYABLE
 ADD (RECORD_TYPE  VARCHAR2(1 CHAR));

ALTER TABLE RNT_ACCOUNTS_PAYABLE
 ADD (INVOICE_NUMBER  VARCHAR2(32 BYTE));


COMMENT ON COLUMN RNT_ACCOUNTS_PAYABLE.RECORD_TYPE IS 'G - generate, E - from expense list, O - other payment';

COMMENT ON COLUMN RNT_ACCOUNTS_PAYABLE.INVOICE_NUMBER IS 'Invoice number';
ALTER PACKAGE RNT_LOANS_PKG COMPILE BODY;

CREATE OR REPLACE FORCE VIEW RNT_ACCOUNTS_PAYABLE_ALL_V
(AP_ID, PAYMENT_DUE_DATE, AMOUNT, PAYMENT_TYPE_ID, EXPENSE_ID, 
 LOAN_ID, SUPPLIER_ID, PAYMENT_PROPERTY_ID, BUSINESS_ID, RECORD_TYPE, 
 INVOICE_NUMBER, CHECKSUM)
AS 
select 
   ap.AP_ID, ap.PAYMENT_DUE_DATE, ap.AMOUNT, 
   ap.PAYMENT_TYPE_ID, ap.EXPENSE_ID, ap.LOAN_ID, 
   ap.SUPPLIER_ID, ap.PAYMENT_PROPERTY_ID,
   ap.BUSINESS_ID,
   ap.RECORD_TYPE,
   ap.INVOICE_NUMBER,
   rnt_sys_checksum_rec_pkg.get_checksum('AP_ID='||ap.AP_ID||'PAYMENT_DUE_DATE='||ap.PAYMENT_DUE_DATE||
   'AMOUNT='||ap.AMOUNT||'PAYMENT_TYPE_ID='||ap.PAYMENT_TYPE_ID||'EXPENSE_ID='||ap.EXPENSE_ID||
   'LOAN_ID='||ap.LOAN_ID||'SUPLIER_ID='||ap.SUPPLIER_ID||'PAYMENT_PROPERTY_ID='||ap.PAYMENT_PROPERTY_ID||'BUSINESS_ID='||BUSINESS_ID||'RECORD_TYPE='||RECORD_TYPE||
   'INVOICE_NUMBER'||ap.INVOICE_NUMBER) as CHECKSUM
from RNT_ACCOUNTS_PAYABLE ap;

CREATE OR REPLACE FORCE VIEW RNT_ACCOUNTS_PAYABLE_V
(AP_ID, PAYMENT_DUE_DATE, AMOUNT, PAYMENT_TYPE_ID, EXPENSE_ID, 
 LOAN_ID, SUPPLIER_ID, PAYMENT_PROPERTY_ID, CHECKSUM, BUSINESS_ID, 
 RECORD_TYPE, INVOICE_NUMBER, SUPPLIER_NAME, PAYMENT_TYPE_NAME, PROPERTY_NAME)
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
,      ap.BUSINESS_ID
,      ap.RECORD_TYPE
,      ap.INVOICE_NUMBER
,      s.NAME as SUPPLIER_NAME
,      pt.PAYMENT_TYPE_NAME
,      p.ADDRESS1 as PROPERTY_NAME    
from RNT_ACCOUNTS_PAYABLE_ALL_V ap,
     RNT_SUPPLIERS s,
     RNT_PAYMENT_TYPES pt,
     RNT_PROPERTIES p
where ap.SUPPLIER_ID = s.SUPPLIER_ID
  and pt.PAYMENT_TYPE_ID = ap.PAYMENT_TYPE_ID
  and p.PROPERTY_ID = ap.PAYMENT_PROPERTY_ID;

CREATE OR REPLACE FORCE VIEW RNT_ACCNTS_PAYABLE_EXPENSES_V
(AP_ID, PAYMENT_DUE_DATE, AMOUNT, PAYMENT_TYPE_ID, EXPENSE_ID, 
 LOAN_ID, SUPPLIER_ID, PAYMENT_PROPERTY_ID, CHECKSUM, SUPPLIER_NAME, 
 PROPERTY_ID, PROPERTY_NAME, BUSINESS_ID, PAYMENT_TYPE_NAME, PAYMENT_DATE, 
 RECORD_TYPE, INVOICE_NUMBER)
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
,      ex.PROPERTY_ID
,      p.ADDRESS1 as PROPERTY_NAME
,      ap.BUSINESS_ID
,      pt.PAYMENT_TYPE_NAME
,      pa.PAYMENT_DATE
,      ap.RECORD_TYPE
,      ap.INVOICE_NUMBER
from RNT_ACCOUNTS_PAYABLE_ALL_V ap,
     RNT_SUPPLIERS s,
     RNT_PROPERTY_EXPENSES ex,
     RNT_PROPERTIES p,
     RNT_PAYMENT_TYPES pt,
     RNT_PAYMENT_ALLOCATIONS pa 
where s.SUPPLIER_ID = ap.SUPPLIER_ID
  and ap.EXPENSE_ID = ex.EXPENSE_ID 
  and p.PROPERTY_ID = ex.PROPERTY_ID
  and pt.PAYMENT_TYPE_ID = ap.PAYMENT_TYPE_ID
  and pa.AP_ID(+) = ap.AP_ID
  and ap.RECORD_TYPE = 'E';

CREATE OR REPLACE FORCE VIEW RNT_ACCOUNTS_PAYABLE_PROP_V
(AP_ID, PAYMENT_DUE_DATE, AMOUNT, PAYMENT_TYPE_ID, EXPENSE_ID, 
 LOAN_ID, SUPPLIER_ID, PAYMENT_PROPERTY_ID, CHECKSUM, PAYMENT_DATE, 
 BUSINESS_ID, INVOICE_NUMBER)
AS 
select 
   ap.AP_ID, 
   ap.PAYMENT_DUE_DATE, 
   ap.AMOUNT, 
   ap.PAYMENT_TYPE_ID, 
   ap.EXPENSE_ID, 
   ap.LOAN_ID, 
   ap.SUPPLIER_ID, 
   ap.PAYMENT_PROPERTY_ID, 
   ap.CHECKSUM,
   pa.PAYMENT_DATE,
   ap.BUSINESS_ID,
   ap.INVOICE_NUMBER
from RNT_ACCOUNTS_PAYABLE_ALL_V ap,
     RNT_PROPERTIES p,
     RNT_PAYMENT_ALLOCATIONS pa 
where ap.PAYMENT_PROPERTY_ID = p.PROPERTY_ID(+)
  and pa.AP_ID(+) = ap.AP_ID
  and ap.RECORD_TYPE = 'O';

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

CONST_GENERATE_TYPE CONSTANT VARCHAR2(1) := 'G';
CONST_OTHER_TYPE CONSTANT VARCHAR2(1) := 'O';
CONST_EXPENSE_TYPE CONSTANT VARCHAR2(1) := 'E';

function CONST_GENERATE_TYPE_VAL return varchar2;
function CONST_OTHER_TYPE_VAL  return varchar2;
function CONST_EXPENSE_TYPE_VAL  return varchar2;


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

SHOW ERRORS;

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
function PAYMENT_TYPE_SECTION8_RENT return NUMBER; --  CONSTANT NUMBER := 14;


 function get_checksum( X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE)
           return RNT_ACCOUNTS_RECEIVABLE_ALL_V.CHECKSUM%TYPE;

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
                     , X_CHECKSUM IN RNT_ACCOUNTS_RECEIVABLE_ALL_V.CHECKSUM%TYPE
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
                    , X_SOURCE_PAYMENT_ID IN RNT_ACCOUNTS_RECEIVABLE.SOURCE_PAYMENT_ID%TYPE := NULL
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
 procedure generate_payments_list ( x_business_unit  in rnt_business_units.business_id%type
                                  , x_effective_date in date := sysdate);

 procedure update_payment_from_allocation(
                                    X_AMOUNT IN RNT_PAYMENT_ALLOCATIONS.AMOUNT%TYPE,
                                    X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE,
                                    X_AR_ID IN RNT_PAYMENT_ALLOCATIONS.AR_ID%TYPE);

 function get_max_alloc_for_agr_action(X_ACTION_ID RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE) return NUMBER;

 procedure DELETE_AGR_ACTION_RECEIVABLE(X_ACTION_ID RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE);

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
                     );

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
             return RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE;

 procedure delete_row2(X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE);
end RNT_ACCOUNTS_RECEIVABLE_PKG;
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

function CONST_GENERATE_TYPE_VAL return varchar2 is begin return CONST_GENERATE_TYPE; end ;
function CONST_OTHER_TYPE_VAL  return varchar2 is begin return CONST_OTHER_TYPE; end ;
function CONST_EXPENSE_TYPE_VAL  return varchar2 is begin return CONST_EXPENSE_TYPE; end ;

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
                x.SUPPLIER_ID, x.PAYMENT_PROPERTY_ID, x.BUSINESS_ID, CONST_GENERATE_TYPE, x.INVOICE_NUMBER);
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
                    , X_AMOUNT           IN RNT_ACCOUNTS_RECEIVABLE.AMOUNT%TYPE
                    , X_PAYMENT_TYPE     IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_TYPE%TYPE
                    , X_TENANT_ID        IN RNT_ACCOUNTS_RECEIVABLE.TENANT_ID%TYPE
                    , X_AGREEMENT_ID     IN RNT_ACCOUNTS_RECEIVABLE.AGREEMENT_ID%TYPE
                    , X_LOAN_ID          IN RNT_ACCOUNTS_RECEIVABLE.LOAN_ID%TYPE
                    , X_BUSINESS_ID      IN RNT_ACCOUNTS_RECEIVABLE.BUSINESS_ID%TYPE
                    , X_IS_GENERATED_YN  IN RNT_ACCOUNTS_RECEIVABLE.IS_GENERATED_YN%TYPE
                    , X_AGREEMENT_ACTION_ID IN RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE
                    , X_PAYMENT_PROPERTY_ID IN RNT_PROPERTIES.PROPERTY_ID%TYPE
                    , X_SOURCE_PAYMENT_ID IN RNT_ACCOUNTS_RECEIVABLE.SOURCE_PAYMENT_ID%TYPE := NULL)
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
    , SOURCE_PAYMENT_ID
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
    , X_SOURCE_PAYMENT_ID
    )
    returning AR_ID into x;

    return x;
 end insert_row;

 procedure delete_row( X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE) is
 begin
   delete from RNT_ACCOUNTS_RECEIVABLE
   where AR_ID = X_AR_ID;
 end delete_row;

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
              AR_ID
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
              , SOURCE_PAYMENT_ID)
          values (RNT_ACCOUNTS_RECEIVABLE_SEQ.NEXTVAL
                  , x.NEXT_PAYMENT_DATE
                  , x_amount_section8
                  , PAYMENT_TYPE_SECTION8_RENT()
                  , x.TENANT_ID
                  , x.AGREEMENT_ID
                  , NULL
                  , x.BUSINESS_ID
                  , 'Y'
                  ,  NULL
                  , x.PROPERTY_ID
                  , x_ar_id);
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
 --
 -- Helper functions for generate_payments_list
 --
 function get_rent_amount( x_tenant_id in rnt_tenant.tenant_id%type
                         , x_agreement_id in rnt_tenant.agreement_id%type)
   return rnt_accounts_receivable.amount%type is

   v_current_tenants  number;
   v_agreement_amount rnt_accounts_receivable.amount%type;

 begin
   select count(*)
   into v_current_tenants
   from rnt_tenant
   where status = 'CURRENT'
   and agreement_id = x_agreement_id;

   select amount
   into v_agreement_amount
   from rnt_tenancy_agreement
   where agreement_id = x_agreement_id;

   return v_agreement_amount/v_current_tenants;
 end get_rent_amount;

  procedure process_late_fee( x_ar_id   in rnt_accounts_receivable.ar_id%type
                            , x_effective_date in date
                            , x_late_fee in rnt_tenancy_agreement.discount_amount%type
                            , x_period   in rnt_tenancy_agreement.discount_period%type ) is

    cursor cur_ar( x_ar_id in rnt_accounts_receivable.ar_id%type) is
    select ar.PAYMENT_DUE_DATE
    ,      ar.AMOUNT     amount_owed
    ,      ar.PAYMENT_TYPE
    ,      ar.BUSINESS_ID
    ,      ar.IS_GENERATED_YN
    ,      ar.PAYMENT_PROPERTY_ID
    ,      ar.SOURCE_PAYMENT_ID
    ,      ar.tenant_id
    ,      ar.agreement_id
    ,      pa.payment_date
    ,      pa.amount     amount_paid
    from rnt_accounts_receivable ar
    ,    rnt_payment_allocations pa
    where ar.ar_id = x_ar_id
    and   ar.ar_id = pa.ar_id (+);

    v_count        number(4);
    v_ar_id        rnt_accounts_receivable.ar_id%type;
  begin
    select count(*)
    into v_count
    from rnt_accounts_receivable
    where source_payment_id = x_ar_id
    and (payment_type = PAYMENT_TYPE_LATE_FEE() or
         payment_type = PAYMENT_TYPE_REMAINING_RENT ());

    if v_count = 0 then
       for c_rec in cur_ar(x_ar_id) loop
         if (nvl(c_rec.amount_paid, 0) < c_rec.amount_owed and
             (c_rec.payment_due_date + x_period) <= x_effective_date) then
                  v_ar_id := insert_row( x_payment_due_date    => c_rec.payment_due_date + x_period
                                       , x_amount              => x_late_fee
                                       , x_payment_type        => PAYMENT_TYPE_LATE_FEE()
                                       , x_tenant_id           => c_rec.tenant_id
                                       , x_agreement_id        => c_rec.agreement_id
                                       , x_loan_id             => null
                                       , x_business_id         => c_rec.business_id
                                       , x_is_generated_yn     => 'Y'
                                       , x_agreement_action_id => null
                                       , x_payment_property_id => c_rec.payment_property_id
                                       , x_source_payment_id   => x_ar_id);
         end if;
       end loop;
    end if;

  end process_late_fee;

 function  get_next_rentdate
                 ( x_ar_id  in rnt_accounts_receivable.ar_id%type
                 , x_period in rnt_tenancy_agreement.amount_period%type) return date is
   v_date      date;
   v_monthyear varchar2(8);
 begin
   select PAYMENT_DUE_DATE
   into v_date
   from rnt_accounts_receivable
   where ar_id = x_ar_id;

   if x_period = 'WEEK' then
      v_date := v_date + 7;
   elsif x_period = '2WEEKS' then
     v_date := v_date + 14;
   elsif x_period = 'BI-MONTH' then
      v_monthyear := to_char(v_date, 'MON-YYYY');
      if v_date < to_date('15-'||v_monthyear, 'dd-MON-YYYY') then
         v_date := to_date('15-'||v_monthyear, 'dd-MON-YYYY');
      else
         v_date := add_months(to_date('01-'||v_monthyear, 'dd-MON-YYYY'), 1);
      end if;
   else
     v_date := add_months(v_date, 1);
   end if;
   return v_date;

 end get_next_rentdate;




 procedure generate_payments_list ( x_business_unit  in rnt_business_units.business_id%type
                                  , x_effective_date in date := sysdate) is

   cursor cur_agreements( x_business_unit  in rnt_business_units.business_id%type
                        , x_effective_date in date) is
   select a.AGREEMENT_ID
   ,      a.UNIT_ID
   ,      a.AGREEMENT_DATE
   ,      a.TERM
   ,      a.AMOUNT
   ,      a.AMOUNT_PERIOD
   ,      a.DATE_AVAILABLE
   ,      a.DISCOUNT_AMOUNT
   ,      a.DISCOUNT_TYPE
   ,      a.DISCOUNT_PERIOD
   ,      a.END_DATE
   ,      p.property_id
   from rnt_tenancy_agreement a
   ,    rnt_property_units u
   ,    rnt_properties p
   where p.business_id = x_business_unit
   and p.property_id = u.property_id
   and u.unit_id = a.unit_id
   and add_months(nvl(a.end_date, to_date('12/31/2099', 'MM/DD/RRRR')), 1) > x_effective_date;

   cursor cur_tenants(x_agreement_id in rnt_tenancy_agreement.agreement_id%type) is
   SELECT TENANT_ID
   ,      STATUS
   ,      PEOPLE_ID
   ,      SECTION8_VOUCHER_AMOUNT
   ,      SECTION8_TENANT_PAYS
   ,      SECTION8_ID
   from rnt_tenant
   where agreement_id = x_agreement_id
   and status = 'CURRENT';

   v_ar_id            rnt_accounts_receivable.ar_id%type;
   v_rent             rnt_accounts_receivable.amount%type;
   v_rent_ins         rnt_accounts_receivable.amount%type;
   v_date             date;

 begin

  for a_rec in cur_agreements( x_business_unit  => x_business_unit
                             , x_effective_date => x_effective_date) loop
    for t_rec in cur_tenants(x_agreement_id => a_rec.agreement_id) loop

      v_rent := get_rent_amount( x_tenant_id    => t_rec.tenant_id
                               , x_agreement_id => a_rec.agreement_id);
      v_date := to_date('01-JAN-1980', 'dd-MON-yyyy');
      while v_date <= x_effective_date loop
        -- find last rent payment id
        select max(ar_id)
        into v_ar_id
        from rnt_accounts_receivable
        where tenant_id  = t_rec.tenant_id
        and agreement_id = a_rec.agreement_id
        and payment_type = PAYMENT_TYPE_RENT();

        if v_ar_id is not null then
          if a_rec.discount_type is not null then
             process_late_fee( x_ar_id          => v_ar_id
                             , x_effective_date => x_effective_date
                             , x_late_fee       => a_rec.discount_amount
                             , x_period         => a_rec.discount_period);
          end if;
          v_date := get_next_rentdate(v_ar_id, a_rec.amount_period);
        else
          v_date := a_rec.agreement_date;
        end if;
        if t_rec.section8_id is not null then
          v_rent_ins := nvl(t_rec.SECTION8_TENANT_PAYS, 0);
        else
          v_rent_ins := v_rent;
        end if;

        if v_date <= x_effective_date then
          v_ar_id := insert_row( x_payment_due_date    => v_date
                               , x_amount              => v_rent_ins
                               , x_payment_type        => PAYMENT_TYPE_RENT()
                               , x_tenant_id           => t_rec.tenant_id
                               , x_agreement_id        => a_rec.agreement_id
                               , x_loan_id             => null
                               , x_business_id         => x_business_unit
                               , x_is_generated_yn     => 'N'
                               , x_agreement_action_id => null
                               , x_payment_property_id => a_rec.property_id
                               , x_source_payment_id   => null);

          if t_rec.section8_id is not null then
            v_ar_id := insert_row( x_payment_due_date    => v_date
                                 , x_amount              => v_rent - v_rent_ins
                                 , x_payment_type        => PAYMENT_TYPE_SECTION8_RENT
                                 , x_tenant_id           => t_rec.tenant_id
                                 , x_agreement_id        => a_rec.agreement_id
                                 , x_loan_id             => null
                                 , x_business_id         => x_business_unit
                                 , x_is_generated_yn     => 'Y'
                                 , x_agreement_action_id => null
                                 , x_payment_property_id => a_rec.property_id
                                 , x_source_payment_id   => v_ar_id);
          end if;
        end if;
      end loop;
    end loop;
  end loop;
  commit;
 end  generate_payments_list;




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

ALTER PACKAGE RNT_AGREEMENT_ACTIONS_PKG COMPILE BODY;

 
ALTER TABLE RNT_ACCOUNTS_PAYABLE
 MODIFY (RECORD_TYPE  VARCHAR2(1 CHAR) NOT NULL);