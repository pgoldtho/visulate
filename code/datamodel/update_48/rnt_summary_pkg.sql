CREATE OR REPLACE PACKAGE RNT_SUMMARY_PKG AS
/******************************************************************************
   NAME:       RNT_SUMMARY_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05.11.2007             1. Created this package.
******************************************************************************/

function get_summary1(X_BUSINESS_ID RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE) return T_SUMMARY_TABLE_1; 

function get_noi(X_BUSINESS_ID RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE) return T_SUMMARY_TABLE_2;

/*
 Alerts: 
  1.    Tenancy Agreement expiring in 90, 60 and 30 days.  (property_id, unit_id) link to tenancy agreement page
  2.    Vacant properties (property_id, unit_id) link to Agreement Page
  3.    Tenants more than one month in arrears. (prop_id, TENANT_ID - link to Tenants page)
  4.    Months with receivables balance owed > 5% of amount owed (BUSINESS_UNIT_ID, YEAR_MONTH - link for Receivable page)
  5.    Months with payables balance owed > 5% of amount owed (BUSINESS_UNIT_ID, YEAR_MONTH - link for Payable page).
Result table structure:
    DESCRIPTION, PROPERTY_ID, UNIT_ID, TENANT_ID, BUSINESS_ID, VALUE_DATE, TYPE
*/

function get_alerts(X_BUSINESS_ID RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE) return T_SUMMARY_ALERT_TABLE;

function flag_agr_expired_value return varchar2;
function flag_vacant_value return varchar2;
function flag_tenant_owed_value return varchar2;
function flag_unpaid_balance_value return varchar2;
function flag_uncollected_income_value return varchar2;
function flag_not_business_units_value return varchar2;
function flag_not_properties_value return varchar2;

/*Return summary table.*/
function get_summary3(X_BUSINESS_ID RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE) return T_SUMMARY_TABLE_3;

END RNT_SUMMARY_PKG;
/

CREATE OR REPLACE PACKAGE BODY RNT_SUMMARY_PKG AS
/******************************************************************************
   NAME:       RNT_SUMMARY_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05.11.2007             1. Created this package body.
******************************************************************************/
function flag_agr_expired_value return varchar2 is begin return 'EXP'; end;
function flag_vacant_value return varchar2 is begin return 'VCN'; end;
function flag_tenant_owed_value return varchar2 is begin return 'OWD'; end;
function flag_unpaid_balance_value return varchar2 is begin return 'UPB'; end;
function flag_uncollected_income_value return varchar2 is begin return 'UIV'; end;

function flag_not_business_units_value return varchar2 is begin return 'NBU'; end;
function flag_not_properties_value return varchar2 is begin return 'NPR'; end;

function get_summary1(X_BUSINESS_ID RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE) return T_SUMMARY_TABLE_1
is
   cursor c is
        select interval_months.MONTH_DATE,
               X_BUSINESS_ID as BUSINESS_ID,
               NVL(income.INCOME_AMOUNT, 0) as INCOME_AMOUNT,
               NVL(expense.EXPENSE_AMOUNT, 0) as EXPENSE_AMOUNT,
               NVL(income.INCOME_AMOUNT, 0) - NVL(expense.EXPENSE_AMOUNT, 0) as CASH_FLOW,
               NVL(owed.OWED_AMOUNT, 0) as OWED_AMOUNT,
               NVL(owed.OWED_AMOUNT, 0) - NVL(income.INCOME_AMOUNT, 0) as UNCOLLECTED_INCOME,
               NVL(invoiced.INVOICED_AMOUNT, 0) as INVOICED_AMOUNT,
               NVL(invoiced.INVOICED_AMOUNT, 0) - NVL(expense.EXPENSE_AMOUNT, 0) as UNPAID_INVOICES 
        from (
                select trunc(ADD_MONTHS(ADD_MONTHS(SYSDATE, -12), level-1), 'MM') as MONTH_DATE  
                from dual 
                connect by level < 12 + 1
              )
              interval_months,
              (
                select trunc(ar.payment_due_date, 'MM') MONTH_DATE, sum(pa.amount) INCOME_AMOUNT
                from rnt_accounts_receivable ar
                   , rnt_payment_allocations pa
                where ar.ar_id = pa.ar_id
                  and ar.BUSINESS_ID = X_BUSINESS_ID
                group by trunc(payment_due_date, 'MM')
              )  income,
              (
                select trunc(payment_due_date, 'MM') as MONTH_DATE, sum(pa.amount)  EXPENSE_AMOUNT
                from rnt_accounts_payable ap
                ,    rnt_payment_allocations pa
                where ap.ap_id = pa.ap_id
                  and ap.BUSINESS_ID = X_BUSINESS_ID
                group by trunc(payment_due_date, 'MM')
              ) expense,
              (select trunc(payment_due_date, 'MM') as MONTH_DATE, sum(ar.amount)  OWED_AMOUNT
               from rnt_accounts_receivable ar
               where ar.BUSINESS_ID = X_BUSINESS_ID 
               group by trunc(payment_due_date, 'MM')
              ) owed,
              (
                select trunc(payment_due_date, 'MM') as MONTH_DATE, sum(ap.amount)  INVOICED_AMOUNT
                from rnt_accounts_payable ap
                where BUSINESS_ID = X_BUSINESS_ID 
                group by trunc(payment_due_date, 'MM')
              ) invoiced
        where income.MONTH_DATE(+) = interval_months.MONTH_DATE
          and expense.MONTH_DATE(+) = interval_months.MONTH_DATE
          and owed.MONTH_DATE(+) = interval_months.MONTH_DATE
          and invoiced.MONTH_DATE(+) = interval_months.MONTH_DATE;
   rec T_SUMMARY_REC1;
   ret T_SUMMARY_TABLE_1 := T_SUMMARY_TABLE_1();          
begin
   for x in c loop
      rec := T_SUMMARY_REC1(MONTH_DATE          => x.MONTH_DATE, 
                            BUSINESS_ID         => x.BUSINESS_ID,
                            INCOME_AMOUNT       => x.INCOME_AMOUNT,
                            EXPENSE_AMOUNT      => x.EXPENSE_AMOUNT,
                            CASH_FLOW           => x.CASH_FLOW,
                            OWED_AMOUNT         => x.OWED_AMOUNT,
                            UNCOLLECTED_INCOME  => x.UNCOLLECTED_INCOME,
                            INVOICED_AMOUNT     => x.INVOICED_AMOUNT,
                            UNPAID_INVOICES     => x.UNPAID_INVOICES);
      ret.EXTEND();
      ret(ret.COUNT) := rec;
   end loop;  
   
   return ret;
end;

function get_noi(X_BUSINESS_ID RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE) return T_SUMMARY_TABLE_2
is
   cursor c is
        select p.PROPERTY_ID, 
               p.ADDRESS1,
               NVL(gross_income.gross_income_amount, 0) - NVL(property_costs.property_costs_amount, 0) as NOI_VALUE,
               -- CAP rate = noi / purchase_price * 100
               decode(NVL(p.PURCHASE_PRICE, 0), 
                      0, 0, 
                      (( NVL(gross_income.gross_income_amount, 0) - NVL(property_costs.property_costs_amount, 0) ) /
                        p.PURCHASE_PRICE)
                       )*100 as CAP_RATE_VALUE                
        from RNT_PROPERTIES p,
             ( select p.property_id, sum(pa.amount) gross_income_amount
                from rnt_accounts_receivable ar
                ,    rnt_payment_allocations pa
                ,    rnt_properties p
                ,    rnt_payment_types pt
                where ar.payment_due_date > add_months(sysdate, -12)
                and ar.payment_due_date <= SYSDATE       
                and ar.business_id = X_BUSINESS_ID
                and ar.ar_id = pa.ar_id
                and p.property_id = ar.payment_property_id
                and p.date_sold is null
                and pt.PAYMENT_TYPE_ID = ar.PAYMENT_TYPE
                and pt.NOI_YN = 'Y'
                group by p.property_id
             ) gross_income,
             (  select p.property_id, sum(ap.amount) property_costs_amount
                from rnt_accounts_payable ap
                ,    rnt_properties p
                ,    rnt_payment_types pt
                where ap.payment_due_date > add_months(sysdate, -12)
                and ap.payment_due_date <= SYSDATE
                and ap.business_id = X_BUSINESS_ID
                and p.property_id = ap.payment_property_id
                and pt.NOI_YN = 'Y'
                and pt.payment_type_id = ap.payment_type_id
                and p.date_sold is null
                group by p.property_id
             ) property_costs
        where p.BUSINESS_ID = X_BUSINESS_ID
          and p.DATE_SOLD is null
          and p.PROPERTY_ID = gross_income.PROPERTY_ID(+)
          and p.PROPERTY_ID = property_costs.PROPERTY_ID(+)
       ;
   rec T_SUMMARY_REC2;
   ret T_SUMMARY_TABLE_2 := T_SUMMARY_TABLE_2();          
begin
   for x in c loop
      rec := T_SUMMARY_REC2(PROPERTY_ID    => x.PROPERTY_ID, 
                            ADDRESS1       => x.ADDRESS1,
                            NOI_VALUE      => x.NOI_VALUE,
                            CAP_RATE_VALUE => x.CAP_RATE_VALUE);
      ret.EXTEND();
      ret(ret.COUNT) := rec;
   end loop;  
   
   return ret;
end;



function get_alerts(X_BUSINESS_ID RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE) return T_SUMMARY_ALERT_TABLE 
is
  cursor c_agr_expiried is
    select p.ADDRESS1, pu.UNIT_NAME, trunc(ta.END_DATE - SYSDATE) as DAY_LEFT,
           p.PROPERTY_ID, ta.UNIT_ID, p.BUSINESS_ID, ta.AGREEMENT_ID
    from RNT_TENANCY_AGREEMENT ta,
         RNT_PROPERTY_UNITS pu,
         RNT_PROPERTIES p
    where pu.UNIT_ID = ta.UNIT_ID
      and p.PROPERTY_ID = pu.PROPERTY_ID
      and ta.END_DATE < SYSDATE + 90
      and SYSDATE < ta.END_DATE
      and p.BUSINESS_ID = X_BUSINESS_ID
      and DATE_SOLD is null 
    order by p.ADDRESS1, pu.UNIT_NAME;
    
   cursor c_vacant is
        select p.ADDRESS1, 
               p.PROPERTY_ID, 
               p.BUSINESS_ID, 
               decode(ucount.CNT, 1, NULL, pu.UNIT_ID) as UNIT_ID, 
               decode(ucount.CNT, 1, NULL, pu.UNIT_NAME) as UNIT_NAME, 
               ucount.CNT
        from RNT_PROPERTIES p,
             RNT_PROPERTY_UNITS pu,
             (select PROPERTY_ID, count(*) as CNT from RNT_PROPERTY_UNITS group by PROPERTY_ID) ucount 
        where p.BUSINESS_ID = X_BUSINESS_ID
          and p.DATE_SOLD is null
          and p.PROPERTY_ID = pu.PROPERTY_ID
          and ucount.PROPERTY_ID = pu.PROPERTY_ID 
          and not exists (select 1
                          from  RNT_TENANCY_AGREEMENT ta,
                                RNT_TENANT t
                          where ta.UNIT_ID = pu.UNIT_ID
                            and t.AGREEMENT_ID = ta.AGREEMENT_ID
                            and t.STATUS in ('CURRENT', 'CURRENT_SECONDARY'))
        order by p.ADDRESS1, pu.UNIT_NAME;
        
    cursor c_tenant_owed is         
        select t.TENANT_ID, 
               p.LAST_NAME||' '||p.FIRST_NAME as TENANT_NAME,
               ar.PROPERTY_ID,
               abs(sum(ar.OWED_AMOUNT)) as OWED_AMOUNT
        from (
                select ar.TENANT_ID, trunc(ar.PAYMENT_DUE_DATE, 'MM') as PAYMENT_DUE_MONTH,
                       p.PROPERTY_ID, 
                       sum(NVL(pa.AMOUNT_ALLOC, 0) - NVL(ar.AMOUNT, 0)) as OWED_AMOUNT
                from rnt_accounts_receivable ar,
                    (select AR_ID,
                            sum(AMOUNT) as AMOUNT_ALLOC 
                     from rnt_payment_allocations pa
                     group by AR_ID) pa,
                     RNT_PROPERTIES p
                where ar.ar_id = pa.ar_id(+)
                  and ar.TENANT_ID is not null
                  and ar.PAYMENT_PROPERTY_ID = p.PROPERTY_ID
                  and p.DATE_SOLD is null
                  and p.BUSINESS_ID = X_BUSINESS_ID
                group by trunc(ar.PAYMENT_DUE_DATE, 'MM'), ar.TENANT_ID, p.PROPERTY_ID
                having sum(NVL(pa.AMOUNT_ALLOC, 0) - NVL(ar.AMOUNT, 0)) < 0
            ) ar,
           rnt_tenant t,
           rnt_people p
        where t.TENANT_ID = ar.TENANT_ID
          and p.PEOPLE_ID = t.PEOPLE_ID
        group by t.TENANT_ID, p.LAST_NAME||' '||p.FIRST_NAME, ar.PROPERTY_ID 
        having count(ar.PAYMENT_DUE_MONTH) > 1
        order by p.LAST_NAME||' '||p.FIRST_NAME;
   
   cursor c_uncollected_income is 
        select trunc(ar.PAYMENT_DUE_DATE, 'MM') as PAYMENT_DUE_MONTH,
               abs(sum(NVL(pa.AMOUNT_ALLOC, 0) - NVL(ar.AMOUNT, 0))) as UNCOLLECTED_INCOME
        from rnt_accounts_receivable ar,
            (select AR_ID,
                    sum(AMOUNT) as AMOUNT_ALLOC 
             from rnt_payment_allocations pa
             group by AR_ID) pa,
             RNT_PROPERTIES p
        where ar.ar_id = pa.ar_id(+)
          and ar.PAYMENT_PROPERTY_ID = p.PROPERTY_ID
          and p.DATE_SOLD is null
          and p.BUSINESS_ID = X_BUSINESS_ID
        group by trunc(ar.PAYMENT_DUE_DATE, 'MM')
        having sum(NVL(pa.AMOUNT_ALLOC, 0) - NVL(ar.AMOUNT, 0)) < sum(ar.AMOUNT)*-0.05 -- 5%
        order by trunc(ar.PAYMENT_DUE_DATE, 'MM');
   
   cursor c_unpaid_balance is
        select trunc(ap.PAYMENT_DUE_DATE, 'MM') as PAYMENT_DUE_MONTH,
               abs(sum(NVL(pa.AMOUNT_ALLOC, 0) - NVL(ap.AMOUNT, 0))) as UNPAID_BALANCE
        from rnt_accounts_payable ap,
            (select AP_ID,
                    sum(AMOUNT) as AMOUNT_ALLOC 
             from rnt_payment_allocations pa
             group by AP_ID) pa,
             RNT_PROPERTIES p
        where ap.AP_ID = pa.AP_ID(+)
          and ap.PAYMENT_PROPERTY_ID = p.PROPERTY_ID
          and p.DATE_SOLD is null
          and p.BUSINESS_ID = X_BUSINESS_ID
        group by trunc(ap.PAYMENT_DUE_DATE, 'MM')
        having sum(NVL(pa.AMOUNT_ALLOC, 0) - NVL(ap.AMOUNT, 0)) < sum(ap.AMOUNT)*-0.05 -- 5%
        order by trunc(ap.PAYMENT_DUE_DATE, 'MM');
            
   rec T_SUMMARY_ALERT_REC;
   ret T_SUMMARY_ALERT_TABLE := T_SUMMARY_ALERT_TABLE();
   procedure add_rec(X_PROPERTY_ID NUMBER,
                     X_UNIT_ID NUMBER, 
                     X_TENANT_ID NUMBER, 
                     X_BUSINESS_ID NUMBER,
                     X_RECORD_TYPE VARCHAR2,
                     X_DESCRIPTION VARCHAR2,
                     X_PAYMENT_DUE_MONTH VARCHAR2 := NULL,
                     X_AGREEMENT_ID NUMBER := NULL)
   is                     
   begin
      rec := T_SUMMARY_ALERT_REC(PROPERTY_ID => X_PROPERTY_ID,
                                 UNIT_ID     => X_UNIT_ID, 
                                 TENANT_ID   => X_TENANT_ID, 
                                 BUSINESS_ID => X_BUSINESS_ID,
                                 RECORD_TYPE => X_RECORD_TYPE,
                                 DESCRIPTION => X_DESCRIPTION,
                                 PAYMENT_DUE_MONTH => X_PAYMENT_DUE_MONTH,
                                 AGREEMENT_ID => X_AGREEMENT_ID);
    ret.EXTEND();
    ret(ret.COUNT) := rec;
   end;                  
begin
  -- Rental agreement for 105 Sky Lane Expires in 86 days
  for x in c_agr_expiried loop
     add_rec(X_PROPERTY_ID => x.PROPERTY_ID,
             X_UNIT_ID     => x.UNIT_ID, 
             X_TENANT_ID   => NULL, 
             X_BUSINESS_ID => x.BUSINESS_ID,
             X_RECORD_TYPE => flag_agr_expired_value,
             X_DESCRIPTION => 'Rental agreement for '||x.ADDRESS1||', '||x.UNIT_NAME||' expires in '||x.DAY_LEFT||' day(s).',
             X_AGREEMENT_ID => x.AGREEMENT_ID);
  end loop;

  -- 2997 Myers Dr is vacant  
  for x in c_vacant loop
     if x.UNIT_ID is null then
             add_rec(X_PROPERTY_ID => x.PROPERTY_ID,
                     X_UNIT_ID     => x.UNIT_ID, 
                     X_TENANT_ID   => NULL, 
                     X_BUSINESS_ID => x.BUSINESS_ID,
                     X_RECORD_TYPE => flag_vacant_value,
                     X_DESCRIPTION => x.ADDRESS1||' is vacant.');
     else
             add_rec(X_PROPERTY_ID => x.PROPERTY_ID,
                     X_UNIT_ID     => x.UNIT_ID, 
                     X_TENANT_ID   => NULL, 
                     X_BUSINESS_ID => x.BUSINESS_ID,
                     X_RECORD_TYPE => flag_vacant_value,
                     X_DESCRIPTION => x.ADDRESS1||' unit "'||x.UNIT_NAME||'" is vacant.');
     end if;
                             
  end loop;

  -- Leandra Johnson has an unpaid balance of $783  
  for x in c_tenant_owed loop
     add_rec(X_PROPERTY_ID => x.PROPERTY_ID,
             X_UNIT_ID     => NULL, 
             X_TENANT_ID   => x.TENANT_ID, 
             X_BUSINESS_ID => X_BUSINESS_ID,
             X_RECORD_TYPE => flag_tenant_owed_value,
             X_DESCRIPTION => x.TENANT_NAME||' has an unpaid balance of $'||ltrim(to_char(x.OWED_AMOUNT, '9,999,990.00'))||'.');
  end loop;
  
  -- Uncollected income for Oct 2007 = $598
  for x in c_uncollected_income loop
     add_rec(X_PROPERTY_ID => NULL,
             X_UNIT_ID     => NULL, 
             X_TENANT_ID   => NULL, 
             X_BUSINESS_ID => X_BUSINESS_ID,
             X_RECORD_TYPE => flag_uncollected_income_value,
             X_PAYMENT_DUE_MONTH => to_char(x.PAYMENT_DUE_MONTH, 'RRRRMM'),
             X_DESCRIPTION  => 'Uncollected income for '||to_char(x.PAYMENT_DUE_MONTH, 'Mon YYYY')||' $'||ltrim(to_char(x.UNCOLLECTED_INCOME, '9,999,990.00'))||'.');
  end loop;

  -- Unpaid balance for Oct 2007 = $598
  for x in c_unpaid_balance loop
     add_rec(X_PROPERTY_ID => NULL,
             X_UNIT_ID     => NULL, 
             X_TENANT_ID   => NULL, 
             X_BUSINESS_ID => X_BUSINESS_ID,
             X_RECORD_TYPE => flag_unpaid_balance_value,
             X_PAYMENT_DUE_MONTH => to_char(x.PAYMENT_DUE_MONTH, 'RRRRMM'),
             X_DESCRIPTION  => 'Unpaid balance for '||to_char(x.PAYMENT_DUE_MONTH, 'Mon YYYY')||' $'||ltrim(to_char(x.UNPAID_BALANCE, '9,999,990.00'))||'.');
  end loop;
   
  return ret;    
end;


function get_summary3(X_BUSINESS_ID RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE) return T_SUMMARY_TABLE_3
is
   cursor c is
select p.PROPERTY_ID,
       p.ADDRESS1, 
       X_BUSINESS_ID as BUSINESS_ID,
       NVL(income.INCOME_AMOUNT, 0) as INCOME_AMOUNT,
       NVL(expense.EXPENSE_AMOUNT, 0) as EXPENSE_AMOUNT,
       NVL(income.INCOME_AMOUNT, 0) - NVL(expense.EXPENSE_AMOUNT, 0) as CASH_FLOW,
       NVL(owed.OWED_AMOUNT, 0) as OWED_AMOUNT,
       NVL(owed.OWED_AMOUNT, 0) - NVL(income.INCOME_AMOUNT, 0) as UNCOLLECTED_INCOME,
       NVL(invoiced.INVOICED_AMOUNT, 0) as INVOICED_AMOUNT,
       NVL(invoiced.INVOICED_AMOUNT, 0) - NVL(expense.EXPENSE_AMOUNT, 0) as UNPAID_INVOICES,
       noi.NOI_VALUE,
       noi.CAP_RATE_VALUE 
        from (
                select ar.PAYMENT_PROPERTY_ID, sum(pa.amount) INCOME_AMOUNT
                from rnt_accounts_receivable ar
                   , rnt_payment_allocations pa
                where ar.ar_id = pa.ar_id
                  and ar.BUSINESS_ID = X_BUSINESS_ID
                group by PAYMENT_PROPERTY_ID
              )  income,
              (
                select ap.PAYMENT_PROPERTY_ID, sum(ap.amount) EXPENSE_AMOUNT
                from rnt_accounts_payable ap
                ,    rnt_payment_allocations pa
                where ap.ap_id = pa.ap_id
                  and ap.BUSINESS_ID = X_BUSINESS_ID
                group by ap.PAYMENT_PROPERTY_ID
              ) expense,
              (select ar.PAYMENT_PROPERTY_ID, sum(ar.amount) OWED_AMOUNT
               from rnt_accounts_receivable ar
               where ar.BUSINESS_ID = X_BUSINESS_ID 
               group by ar.PAYMENT_PROPERTY_ID
              ) owed,
              (
                select ap.PAYMENT_PROPERTY_ID, sum(ap.amount)  INVOICED_AMOUNT
                from rnt_accounts_payable ap
                where BUSINESS_ID = X_BUSINESS_ID 
                group by ap.PAYMENT_PROPERTY_ID
              ) invoiced,
              RNT_PROPERTIES p,
              table(RNT_SUMMARY_PKG.GET_NOI(X_BUSINESS_ID)) noi
        where p.PROPERTY_ID = income.PAYMENT_PROPERTY_ID(+)
          and p.PROPERTY_ID = expense.PAYMENT_PROPERTY_ID(+)
          and p.PROPERTY_ID = owed.PAYMENT_PROPERTY_ID(+)
          and p.PROPERTY_ID = invoiced.PAYMENT_PROPERTY_ID(+)
          and p.BUSINESS_ID = X_BUSINESS_ID
          and p.PROPERTY_ID = noi.PROPERTY_ID(+);
   rec T_SUMMARY_REC3;
   ret T_SUMMARY_TABLE_3 := T_SUMMARY_TABLE_3();          
begin
   for x in c loop
      rec := T_SUMMARY_REC3(PROPERTY_ID        => x.PROPERTY_ID,
                            ADDRESS1           => x.ADDRESS1, 
                            BUSINESS_ID        => x.BUSINESS_ID, 
                            INCOME_AMOUNT      => x.INCOME_AMOUNT,
                            EXPENSE_AMOUNT     => x.EXPENSE_AMOUNT,
                            CASH_FLOW          => x.CASH_FLOW,
                            OWED_AMOUNT        => x.OWED_AMOUNT,
                            UNCOLLECTED_INCOME => x.UNCOLLECTED_INCOME,
                            INVOICED_AMOUNT    => x.INVOICED_AMOUNT,
                            UNPAID_INVOICES    => x.UNPAID_INVOICES,
                            NOI_VALUE          => x.NOI_VALUE,
                            CAP_RATE_VALUE     => x.CAP_RATE_VALUE);
      ret.EXTEND();
      ret(ret.COUNT) := rec;
   end loop;  
   
   return ret;
end;

END RNT_SUMMARY_PKG;
/