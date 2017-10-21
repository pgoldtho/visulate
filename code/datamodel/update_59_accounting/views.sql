create or replace view RNT_ACCOUNT_TYPES_V as
select ACCOUNT_TYPE
,      DISPLAY_TITLE
,      rnt_sys_checksum_rec_pkg.get_checksum('ACCOUNT_TYPE='||ACCOUNT_TYPE 
                                           ||'DISPLAY_TITLE='||DISPLAY_TITLE) as CHECKSUM
from RNT_ACCOUNT_TYPES;

create or replace view RNT_ACCOUNTS_V as
select ACCOUNT_ID
,      ACCOUNT_NUMBER
,      BUSINESS_ID
,      NAME
,      ACCOUNT_TYPE
,      USER_ASSIGN_ID
,      PEOPLE_BUSINESS_ID
,      CURRENT_BALANCE_YN
,      rnt_sys_checksum_rec_pkg.get_checksum('ACCOUNT_ID='||ACCOUNT_ID
                                           ||'ACCOUNT_NUMBER='||ACCOUNT_NUMBER
                                           ||'BUSINESS_ID='||BUSINESS_ID
                                           ||'NAME='||NAME
                                           ||'ACCOUNT_TYPE='||ACCOUNT_TYPE
                                           ||'CURRENT_BALANCE_YN='||CURRENT_BALANCE_YN
                                           ||'USER_ASSIGN_ID='||USER_ASSIGN_ID
                                           ||'PEOPLE_BUSINESS_ID='||PEOPLE_BUSINESS_ID) as CHECKSUM
from RNT_ACCOUNTS;

create or replace view RNT_DEFAULT_ACCOUNTS_V as
select ACCOUNT_NUMBER
,      NAME
,      ACCOUNT_TYPE
,      CURRENT_BALANCE_YN
,      rnt_sys_checksum_rec_pkg.get_checksum('ACCOUNT_NUMBER='||ACCOUNT_NUMBER
                                           ||'NAME='||NAME
                                           ||'ACCOUNT_TYPE='||ACCOUNT_TYPE
                                           ||'CURRENT_BALANCE_YN='||CURRENT_BALANCE_YN) as CHECKSUM
from RNT_DEFAULT_ACCOUNTS;
      

create or replace view RNT_ACCOUNT_BALANCES_V as
select ACCOUNT_ID
,      PERIOD_ID
,      OPENING_BALANCE
,      rnt_sys_checksum_rec_pkg.get_checksum('ACCOUNT_ID='||ACCOUNT_ID
                                           ||'PERIOD_ID='||PERIOD_ID
                                           ||'OPENING_BALANCE='||OPENING_BALANCE) as CHECKSUM
from RNT_ACCOUNT_BALANCES;


create or replace view RNT_PT_RULES_V as
select BUSINESS_ID
,      PAYMENT_TYPE_ID
,      TRANSACTION_TYPE
,      DEBIT_ACCOUNT
,      CREDIT_ACCOUNT
,      rnt_sys_checksum_rec_pkg.get_checksum('BUSINESS_ID='||BUSINESS_ID
                                           ||'PAYMENT_TYPE_ID='||PAYMENT_TYPE_ID
                                           ||'TRANSACTION_TYPE='||TRANSACTION_TYPE
                                           ||'DEBIT_ACCOUNT='||DEBIT_ACCOUNT
                                           ||'CREDIT_ACCOUNT='||CREDIT_ACCOUNT) as CHECKSUM
from RNT_PT_RULES;

create or replace view RNT_DEFAULT_PT_RULES_V as
select PAYMENT_TYPE_ID
,      TRANSACTION_TYPE
,      DEBIT_ACCOUNT
,      CREDIT_ACCOUNT
,      rnt_sys_checksum_rec_pkg.get_checksum('PAYMENT_TYPE_ID='||PAYMENT_TYPE_ID
                                           ||'TRANSACTION_TYPE='||TRANSACTION_TYPE
                                           ||'DEBIT_ACCOUNT='||DEBIT_ACCOUNT
                                           ||'CREDIT_ACCOUNT='||CREDIT_ACCOUNT) as CHECKSUM
from RNT_DEFAULT_PT_RULES;

create or replace view RNT_LEDGER_ENTRIES_V as
select LEDGER_ID
,      ENTRY_DATE
,      DESCRIPTION
,      DEBIT_ACCOUNT
,      CREDIT_ACCOUNT
,      PAYMENT_TYPE_ID
,      AR_ID
,      AP_ID
,      PAY_ALLOC_ID
,      PROPERTY_ID
,      rnt_sys_checksum_rec_pkg.get_checksum('LEDGER_ID='||LEDGER_ID
                                           ||'ENTRY_DATE='||ENTRY_DATE
                                           ||'DESCRIPTION='||DESCRIPTION
                                           ||'DEBIT_ACCOUNT='||DEBIT_ACCOUNT
                                           ||'CREDIT_ACCOUNT='||CREDIT_ACCOUNT
                                           ||'PAYMENT_TYPE_ID='||PAYMENT_TYPE_ID
                                           ||'AR_ID='||AR_ID
                                           ||'AP_ID='||AP_ID
                                           ||'PAY_ALLOC_ID='||PAY_ALLOC_ID
                                           ||'PAYMENT_TYPE_ID='||PAYMENT_TYPE_ID
                                           ||'PROPERTY_ID='||PROPERTY_ID) as CHECKSUM
from RNT_LEDGER_ENTRIES;


create or replace view RNT_BUSINESS_UNITS_V as
select BUSINESS_ID
,      BUSINESS_NAME
,      PARENT_BUSINESS_ID
,      RNT_BUSINESS_UNITS_PKG.GET_CHECKSUM(BUSINESS_ID) as CHECKSUM
from RNT_BUSINESS_UNITS
start with (PARENT_BUSINESS_ID = 0
            and BUSINESS_ID in (select BUSINESS_ID
                                from RNT_USER_ASSIGNMENTS_V
                                where USER_ID = RNT_USERS_PKG.GET_USER()
                                  and ROLE_CODE = RNT_USERS_PKG.GET_ROLE()
                                )
           )
         or (BUSINESS_ID in (select BUSINESS_ID
                             from RNT_USER_ASSIGNMENTS_V
                             where USER_ID = RNT_USERS_PKG.GET_USER()
                             and ROLE_CODE = RNT_USERS_PKG.GET_ROLE()
                            )
             )
connect by prior BUSINESS_ID = PARENT_BUSINESS_ID;


create or replace view RNT_ACCOUNTS_PAYABLE_ALL_V as
select
   ap.AP_ID, ap.PAYMENT_DUE_DATE, ap.AMOUNT,
   ap.PAYMENT_TYPE_ID, ap.EXPENSE_ID, ap.LOAN_ID,
   ap.SUPPLIER_ID, ap.PAYMENT_PROPERTY_ID,
   ap.BUSINESS_ID,
   ap.RECORD_TYPE,
   ap.INVOICE_NUMBER,
   rnt_sys_checksum_rec_pkg.get_checksum('AP_ID='||ap.AP_ID
                                       ||'PAYMENT_DUE_DATE='||ap.PAYMENT_DUE_DATE
                                       ||'AMOUNT='||ap.AMOUNT
                                       ||'PAYMENT_TYPE_ID='||ap.PAYMENT_TYPE_ID
                                       ||'EXPENSE_ID='||ap.EXPENSE_ID
                                       ||'LOAN_ID='||ap.LOAN_ID
                                       ||'SUPLIER_ID='||ap.SUPPLIER_ID
                                       ||'PAYMENT_PROPERTY_ID='||ap.PAYMENT_PROPERTY_ID
                                       ||'BUSINESS_ID='||BUSINESS_ID
                                       ||'RECORD_TYPE='||RECORD_TYPE
                                       ||'INVOICE_NUMBER'||ap.INVOICE_NUMBER) as CHECKSUM
from RNT_ACCOUNTS_PAYABLE ap;


create or replace view RNT_ACCOUNTS_PAYABLE_V as
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
     RNT_SUPPLIERS_ALL s,
     RNT_PAYMENT_TYPES pt,
     RNT_PROPERTIES p
where ap.SUPPLIER_ID = s.SUPPLIER_ID
  and pt.PAYMENT_TYPE_ID = ap.PAYMENT_TYPE_ID
  and p.PROPERTY_ID = ap.PAYMENT_PROPERTY_ID
  and ap.RECORD_TYPE = RNT_ACCOUNTS_PAYABLE_CONST_PKG.CONST_EXPENSE_TYPE_VAL();

create or replace view RNT_ACCOUNTS_RECEIVABLE_ALL_V as
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
,      ar.SOURCE_PAYMENT_ID
,      ar.RECORD_TYPE
,      rnt_sys_checksum_rec_pkg.get_checksum('AR_ID='||ar.AR_ID
                                           ||'PAYMENT_DUE_DATE='||ar.PAYMENT_DUE_DATE
                                           ||'AMOUNT='||ar.AMOUNT
                                           ||'PAYMENT_TYPE='||ar.PAYMENT_TYPE
                                           ||'TENANT_ID='||ar.TENANT_ID
                                           ||'AGREEMENT_ID='||ar.AGREEMENT_ID
                                           ||'LOAN_ID='||ar.LOAN_ID
                                           ||'BUSINESS_ID='||ar.BUSINESS_ID
                                           ||'IS_GENERATED_YN='||ar.IS_GENERATED_YN
                                           ||'AGREEMENT_ACTION_ID='||ar.AGREEMENT_ACTION_ID
                                           ||'PAYMENT_PROPERTY_ID='||ar.PAYMENT_PROPERTY_ID
                                           ||'SOURCE_PAYMENT_ID='||ar.SOURCE_PAYMENT_ID
                                           ||'RECORD_TYPE='||RECORD_TYPE) as CHECKSUM
from RNT_ACCOUNTS_RECEIVABLE ar;

create or replace view RNT_ACCOUNTS_RECEIVABLE_V as
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
,      ar.CHECKSUM
,      u.PROPERTY_ID
,      pt.PAYMENT_TYPE_NAME as RECEIVABLE_TYPE_NAME
,      u.UNIT_NAME
,      prop.ADDRESS1
,      prop.ZIPCODE
,      prop.UNITS
,      ar.SOURCE_PAYMENT_ID
,      p.LAST_NAME||' '||p.FIRST_NAME as TENANT_NAME
from RNT_ACCOUNTS_RECEIVABLE_ALL_V ar,
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
  and p.PEOPLE_ID = t.PEOPLE_ID
  and ar.RECORD_TYPE = RNT_ACC_RECEIVABLE_CONST_PKG.CONST_GENERATE_TYPE_VAL;



create or replace view RNT_PAYMENT_ALLOCATIONS_V as
select PAY_ALLOC_ID
,      PAYMENT_DATE
,      AMOUNT
,      AR_ID
,      AP_ID
,      PAYMENT_ID
,      rnt_sys_checksum_rec_pkg.get_checksum('PAY_ALLOC_ID='||PAY_ALLOC_ID
                                           ||'PAYMENT_DATE='||PAYMENT_DATE
                                           ||'AMOUNT='||AMOUNT
                                           ||'AR_ID='||AR_ID
                                           ||'AP_ID='||AP_ID
                                           ||'PAYMENT_ID='||PAYMENT_ID) as CHECKSUM
from RNT_PAYMENT_ALLOCATIONS;



create or replace view RNT_ACCOUNT_PERIODS_V as
select PERIOD_ID
,      BUSINESS_ID
,      START_DATE
,      CLOSED_YN
,      rnt_sys_checksum_rec_pkg.get_checksum('PERIOD_ID='||PERIOD_ID||
                                             'BUSINESS_ID='||BUSINESS_ID||
                                             'START_DATE='||START_DATE||
                                             'CLOSED_YN='||CLOSED_YN) as CHECKSUM
from RNT_ACCOUNT_PERIODS;
                                                                                                     

create or replace view rnt_ledger_transactions_v as
select a.account_id
,      a.account_number
,      a.business_id
,      a.name                                     account_name
,      a.account_type
,      'DEBIT'                                    transaction_type
,      a.user_assign_id
,      l.ledger_id
,      l.entry_date
,      l.description
,      l.ar_id
,      l.ap_id
,      l.pay_alloc_id
,      l.payment_type_id
,      l.property_id
,      rnt_ledger_pkg.get_txn_amount(l.ledger_id) amount
from rnt_accounts a
,    rnt_ledger_entries l
where l.debit_account = a.account_id
UNION
select a.account_id
,      a.account_number
,      a.business_id
,      a.name                                    account_name
,      a.account_type
,      'CREDIT'                                  transaction_type
,      a.user_assign_id
,      l.ledger_id
,      l.entry_date
,      l.description
,      l.ar_id
,      l.ap_id
,      l.pay_alloc_id
,      l.payment_type_id
,      l.property_id
,      rnt_ledger_pkg.get_txn_amount(l.ledger_id) amount
from rnt_accounts a
,    rnt_ledger_entries l
where l.credit_account = a.account_id;


