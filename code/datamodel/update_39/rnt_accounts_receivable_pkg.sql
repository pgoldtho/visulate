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

function PAYMENT_TYPE_UTILITES return NUMBER; --  CONSTANT NUMBER := 1;
function PAYMENT_TYPE_TAX return NUMBER; --  CONSTANT NUMBER := 2;
function PAYMENT_TYPE_INSURANCE return NUMBER; --  CONSTANT NUMBER := 3;
function PAYMENT_TYPE_3_YEAR_AMORTIZ return NUMBER; --  CONSTANT NUMBER := 4;
function PAYMENT_TYPE_5_YEAR_AMORTIZ return NUMBER; --  CONSTANT NUMBER := 5
function PAYMENT_TYPE_10_YEAR_AMORTIZ return NUMBER; --  CONSTANT NUMBER := 6
function PAYMENT_TYPE_RENT return NUMBER; -- CONSTANT NUMBER := 7;
function PAYMENT_TYPE_DISCOUNT_RENT return NUMBER; -- CONSTANT NUMBER := 8;
function PAYMENT_TYPE_RECOVERABLE return NUMBER; -- CONSTANT NUMBER := 9;
function PAYMENT_TYPE_LATE_FEE return NUMBER; --  CONSTANT NUMBER := 10;
function PAYMENT_TYPE_OTHER_INCOMING return NUMBER; --  CONSTANT NUMBER := 11;
function PAYMENT_TYPE_MORTGAGE_PAYMENT return NUMBER; --  CONSTANT NUMBER := 12;
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
                    , X_RECORD_TYPE IN RNT_ACCOUNTS_RECEIVABLE.RECORD_TYPE%TYPE                    
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
-- procedure generate_payment_list;
 /*@return next date for period with start date x_date*/
 function get_next_period_date(x_date in DATE,
                               x_period in rnt_tenancy_agreement.amount_period%type) return date;

 procedure generate_payments_list ( x_business_unit  in rnt_business_units.business_id%type
                                  , x_effective_date in date := sysdate
                                  , x_generate_late  in boolean := TRUE);
                                  
 procedure delete_payments_list_from(x_business_unit  in rnt_business_units.business_id%type
                                   , x_date_from in date);                                  

 procedure setup_payments_list ( x_business_unit  in rnt_business_units.business_id%type
                               , x_start_date     in date
                               , x_end_date       in date);


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
                    , X_RECORD_TYPE IN RNT_ACCOUNTS_RECEIVABLE.RECORD_TYPE%TYPE                    
                  )
             return RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE;

 procedure delete_row2(X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE);
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

function PAYMENT_TYPE_UTILITES return NUMBER as begin return 1; end;
function PAYMENT_TYPE_TAX return NUMBER as begin return 2; end;
function PAYMENT_TYPE_INSURANCE return NUMBER as begin return 3; end;
function PAYMENT_TYPE_3_YEAR_AMORTIZ return NUMBER as begin return 4; end;
function PAYMENT_TYPE_5_YEAR_AMORTIZ return NUMBER as begin return 5; end;
function PAYMENT_TYPE_10_YEAR_AMORTIZ return NUMBER as begin return 6; end;
function PAYMENT_TYPE_RENT return NUMBER as begin return 7; end;
function PAYMENT_TYPE_DISCOUNT_RENT return NUMBER as begin return 8; end;
function PAYMENT_TYPE_RECOVERABLE return NUMBER as begin return 9; end;
function PAYMENT_TYPE_LATE_FEE return NUMBER as begin return 10; end;
function PAYMENT_TYPE_OTHER_INCOMING return NUMBER as begin return 11; end;
function PAYMENT_TYPE_MORTGAGE_PAYMENT return NUMBER as begin return 12; end;
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
                    , X_RECORD_TYPE IN RNT_ACCOUNTS_RECEIVABLE.RECORD_TYPE%TYPE
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
    , RECORD_TYPE
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
    , X_RECORD_TYPE
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
 function generate_payments return NUMBER
 is
    cursor c_new_payment
    is
       select 
            a.DATE_AVAILABLE,
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
          AGREEMENT_ACTION_ID, PAYMENT_PROPERTY_ID, SOURCE_PAYMENT_ID, RECORD_TYPE)
      values (RNT_ACCOUNTS_RECEIVABLE_SEQ.NEXTVAL, x.NEXT_PAYMENT_DATE, x_amount,
           x_payment_type1, x.TENANT_ID, x.AGREEMENT_ID,
           NULL, x.BUSINESS_ID, 'Y',
           NULL, x.PROPERTY_ID, NULL, RNT_ACC_RECEIVABLE_CONST_PKG.CONST_GENERATE_TYPE_VAL())
      returning AR_ID into x_ar_id;

     if x_payment_type2 != 0 then
           insert into RNT_ACCOUNTS_RECEIVABLE (
                  AR_ID, PAYMENT_DUE_DATE, AMOUNT,
                  PAYMENT_TYPE, TENANT_ID, AGREEMENT_ID,
                  LOAN_ID, BUSINESS_ID, IS_GENERATED_YN,
                  AGREEMENT_ACTION_ID, PAYMENT_PROPERTY_ID, SOURCE_PAYMENT_ID, RECORD_TYPE)
           values (RNT_ACCOUNTS_RECEIVABLE_SEQ.NEXTVAL, x_next_date2, x_amount2,
                   x_payment_type2, x.TENANT_ID, x.AGREEMENT_ID,
                   NULL, x.BUSINESS_ID, 'Y',
                   NULL, x.PROPERTY_ID, x_ar_id, RNT_ACC_RECEIVABLE_CONST_PKG.CONST_GENERATE_TYPE_VAL);
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
              , SOURCE_PAYMENT_ID
              , RECORD_TYPE)
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
                  , x_ar_id
                  , RNT_ACC_RECEIVABLE_CONST_PKG.CONST_GENERATE_TYPE_VAL());
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
*/

/*                                    
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
 */
 
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
                                       , x_source_payment_id   => x_ar_id
                                       , x_record_type         => RNT_ACC_RECEIVABLE_CONST_PKG.CONST_GENERATE_TYPE_VAL()
                                       );
         end if;
       end loop;
    end if;

  end process_late_fee;

 function get_next_period_date(x_date in DATE,
                               x_period in rnt_tenancy_agreement.amount_period%type) return date
 is
   v_date DATE := x_date;
   v_monthyear varchar2(8);
 begin
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
 end;                        
                                                  

 function  get_next_rentdate
                 ( x_ar_id  in rnt_accounts_receivable.ar_id%type
                 , x_period in rnt_tenancy_agreement.amount_period%type) return date is
   v_date      date;
 begin
   select PAYMENT_DUE_DATE
   into v_date
   from rnt_accounts_receivable
   where ar_id = x_ar_id;

   return get_next_period_date(v_date, x_period); 
 end get_next_rentdate;




 procedure generate_payments_list ( x_business_unit  in rnt_business_units.business_id%type
                                  , x_effective_date in date := sysdate
                                  , x_generate_late  in boolean := TRUE) is

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
   ,      p.address1
   from rnt_tenancy_agreement a
   ,    rnt_property_units u
   ,    rnt_properties p
   where p.business_id = x_business_unit
   and p.property_id = u.property_id
   and u.unit_id = a.unit_id
   and nvl(a.end_date, to_date('12/31/2099', 'MM/DD/RRRR')) > x_effective_date
   order by a.agreement_date;

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

--dbms_output.put_line(a_rec.address1 ||' - '||a_rec.agreement_date);
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
            if x_generate_late then
               process_late_fee( x_ar_id          => v_ar_id
                               , x_effective_date => x_effective_date
                               , x_late_fee       => a_rec.discount_amount
                               , x_period         => a_rec.discount_period);
            end if;
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

--dbms_output.put_line(v_ar_id ||' - '||v_date);

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
                               , x_source_payment_id   => null
                               , x_record_type         => RNT_ACC_RECEIVABLE_CONST_PKG.CONST_GENERATE_TYPE_VAL());

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
                                 , x_source_payment_id   => v_ar_id
                                 , x_record_type         => RNT_ACC_RECEIVABLE_CONST_PKG.CONST_GENERATE_TYPE_VAL());
          end if;
        end if;
      end loop;
    end loop;
  end loop;
  commit;
 end  generate_payments_list;

 procedure delete_payments_list_from(x_business_unit  in rnt_business_units.business_id%type, x_date_from in date)
 is
   x NUMBER;
 begin
   begin
    select 1 
    into x
    from DUAL
    where exists(select 1
                 from (
                            select AR_ID
                            from RNT_ACCOUNTS_RECEIVABLE ar
                            where BUSINESS_ID = x_business_unit
                              and PAYMENT_DUE_DATE >= x_date_from
                              and RECORD_TYPE = RNT_ACC_RECEIVABLE_CONST_PKG.CONST_GENERATE_TYPE_VAL
                              and (SOURCE_PAYMENT_ID is null 
                                   or 
                                   exists (select 1
                                           from RNT_ACCOUNTS_RECEIVABLE
                                           where PAYMENT_DUE_DATE >= x_date_from 
                                             and AR_ID = ar.SOURCE_PAYMENT_ID)
                                  )
                     ) acc
                  where exists (select 1
                                from RNT_PAYMENT_ALLOCATIONS
                                where acc.AR_ID = AR_ID)
               );
       RAISE_APPLICATION_ERROR(-20061, 'Can not delete record found payment allocated record(s) in current month or in next month(s).');        
    exception
      when NO_DATA_FOUND then NULL;               
    end;
    
    delete from RNT_ACCOUNTS_RECEIVABLE ar
    where BUSINESS_ID = x_business_unit
      and PAYMENT_DUE_DATE >= x_date_from
      and RECORD_TYPE = RNT_ACC_RECEIVABLE_CONST_PKG.CONST_GENERATE_TYPE_VAL
      and (SOURCE_PAYMENT_ID is null 
           or 
            exists (select 1
                    from RNT_ACCOUNTS_RECEIVABLE
                    where PAYMENT_DUE_DATE >= x_date_from 
                      and AR_ID = ar.SOURCE_PAYMENT_ID
                      and RECORD_TYPE = RNT_ACC_RECEIVABLE_CONST_PKG.CONST_GENERATE_TYPE_VAL
                   )
         );
 end;


 procedure setup_payments_list ( x_business_unit  in rnt_business_units.business_id%type
                               , x_start_date     in date
                               , x_end_date       in date) is
   v_date       date;

 begin
    v_date := x_start_date;  
    while v_date <= x_end_date loop
      rnt_accounts_receivable_pkg.generate_payments_list( x_business_unit  => x_business_unit
                                                        , x_effective_date => v_date
                                                        , x_generate_late  => FALSE);
      v_date := add_months(v_date, 1);
    end loop;

 end setup_payments_list;


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
      RAISE_APPLICATION_ERROR(-20060, 'New amount sum more then sum for payment in specified date ('||
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
                    , X_RECORD_TYPE IN RNT_ACCOUNTS_RECEIVABLE.RECORD_TYPE%TYPE
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
                     , X_RECORD_TYPE => X_RECORD_TYPE
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

