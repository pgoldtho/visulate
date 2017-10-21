create or replace package RNT_ACCOUNTS_PAYABLE_PKG as
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
                       , X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE             := null  
                       , X_PAYMENT_PROPERTY_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID%TYPE
                       , X_BUSINESS_ID IN RNT_ACCOUNTS_PAYABLE.BUSINESS_ID%TYPE
                       , X_RECORD_TYPE IN RNT_ACCOUNTS_PAYABLE.RECORD_TYPE%TYPE
                       , X_INVOICE_NUMBER RNT_ACCOUNTS_PAYABLE.INVOICE_NUMBER%TYPE
                       , X_DEBIT_ACCOUNT IN RNT_LEDGER_ENTRIES.DEBIT_ACCOUNT%TYPE                := null
                       , X_CREDIT_ACCOUNT IN RNT_LEDGER_ENTRIES.CREDIT_ACCOUNT%TYPE              := null
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
                       --
                       , X_DEBIT_ACCOUNT IN RNT_LEDGER_ENTRIES.DEBIT_ACCOUNT%TYPE
                       , X_CREDIT_ACCOUNT IN RNT_LEDGER_ENTRIES.CREDIT_ACCOUNT%TYPE
                      );

  procedure delete_row2( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE);

  function get_date_by_recurring(x_daily varchar2, x_date DATE) return DATE;

  procedure generate_payment_list(X_BUSINESS_ID in RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE, X_NEED_DATE in DATE);
end RNT_ACCOUNTS_PAYABLE_PKG;
/
create or replace package body RNT_ACCOUNTS_PAYABLE_PKG as
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
     r RNT_ACCOUNTS_PAYABLE%ROWTYPE;
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

     -- select old values from tables
     select *
     into r
     from RNT_ACCOUNTS_PAYABLE
     where AP_ID = X_AP_ID;

     if r.RECORD_TYPE in (RNT_ACCOUNTS_PAYABLE_CONST_PKG.CONST_EXPENSE_TYPE_VAL()) then
        if r.EXPENSE_ID = X_EXPENSE_ID and (r.SUPPLIER_ID != X_SUPPLIER_ID or r.PAYMENT_TYPE_ID != X_PAYMENT_TYPE_ID) then
           -- need for update all records
           update RNT_ACCOUNTS_PAYABLE
           set SUPPLIER_ID = X_SUPPLIER_ID,
               PAYMENT_TYPE_ID = X_PAYMENT_TYPE_ID
           where EXPENSE_ID = r.EXPENSE_ID
             and SUPPLIER_ID = r.SUPPLIER_ID
             and PAYMENT_TYPE_ID = r.PAYMENT_TYPE_ID
             and RECORD_TYPE in (RNT_ACCOUNTS_PAYABLE_CONST_PKG.CONST_GENERATE_TYPE_VAL());
        end if;
     end if;


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

  function is_exists_allocations(X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE) return boolean
  is
    x NUMBER;
  begin
    select 1
    into x
    from DUAL
    where exists (select 1
                  from RNT_PAYMENT_ALLOCATIONS
                  where AP_ID = X_AP_ID);
    return TRUE;
  exception
    when NO_DATA_FOUND then
      return FALSE;
  end;

  procedure delete_row(X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE) is

  begin
    lock_row(X_AP_ID);
    -- check for payment if exists allocated payment then we cannot delete record
    if is_exists_allocations(X_AP_ID) then
       RAISE_APPLICATION_ERROR(-20031, 'Can''t delete payment record. Cause: found allocation of payment record.');
    end if;

    delete from RNT_ACCOUNTS_PAYABLE
    where AP_ID = X_AP_ID;
  end delete_row;

  procedure update_allocation(
                      X_AP_ID               IN RNT_PAYMENT_ALLOCATIONS.AP_ID%TYPE
                    , X_PAYMENT_DATE        IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE
                    , X_AMOUNT              IN RNT_PAYMENT_ALLOCATIONS.AMOUNT%TYPE
                    , X_PAYMENT_PROPERTY_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID%TYPE
                    , X_PAYMENT_TYPE_ID     IN RNT_ACCOUNTS_PAYABLE.PAYMENT_TYPE_ID%TYPE
                    , X_DEBIT_ACCOUNT       IN RNT_LEDGER_ENTRIES.DEBIT_ACCOUNT%TYPE
                    , X_CREDIT_ACCOUNT      IN RNT_LEDGER_ENTRIES.CREDIT_ACCOUNT%TYPE
                   )
  is
    v_pay_alloc_id   RNT_PAYMENT_ALLOCATIONS.PAY_ALLOC_ID%TYPE;
    v_ledger_id      RNT_LEDGER_ENTRIES.LEDGER_ID%TYPE;
    v_paytype      varchar2(80);
    v_property     varchar2(80);
  begin
      if X_PAYMENT_DATE is null then
          delete from RNT_LEDGER_ENTRIES
          where  pay_alloc_id = (select pay_alloc_id 
                                 from rnt_payment_allocations
                                 where  ap_id = X_AP_ID);
          --
          delete from RNT_PAYMENT_ALLOCATIONS
          where AP_ID = X_AP_ID;
      else
          update RNT_PAYMENT_ALLOCATIONS
          set    PAYMENT_DATE = X_PAYMENT_DATE,
                 AMOUNT       = X_AMOUNT
          where AP_ID = X_AP_ID;
          --
          if SQL%ROWCOUNT = 0 then
              insert into RNT_PAYMENT_ALLOCATIONS ( PAY_ALLOC_ID
                                                  , PAYMENT_DATE
                                                  , AMOUNT
                                                  , AR_ID
                                                  , AP_ID
                                                  , PAYMENT_ID)
              values ( RNT_PAYMENT_ALLOCATIONS_SEQ.NEXTVAL
                     , X_PAYMENT_DATE
                     , X_AMOUNT
                     , NULL
                     , X_AP_ID
                     , NULL)
              returning PAY_ALLOC_ID into v_pay_alloc_id;

             select count(*)
             into v_property
             from rnt_properties
             where property_id = x_payment_property_id;
            
             if v_property = '0' then
                v_property := 'Business Unit';
             else
                select address1
                into v_property
                from rnt_properties
                where property_id = x_payment_property_id;
             end if;

             select payment_type_name
             into v_paytype
             from rnt_payment_types
             where payment_type_id = x_payment_type_id;

              v_ledger_id := rnt_ledger_entries_pkg.insert_row(
                       X_ENTRY_DATE      => X_PAYMENT_DATE
                     , X_DESCRIPTION     => 'Payment for '||v_paytype||' '||v_property
                     , X_DEBIT_ACCOUNT   => X_DEBIT_ACCOUNT
                     , X_CREDIT_ACCOUNT  => X_CREDIT_ACCOUNT
                     , X_AR_ID           => to_number(null)
                     , X_AP_ID           => x_ap_id
                     , X_PAY_ALLOC_ID    => v_pay_alloc_id
                     , X_PAYMENT_TYPE_ID => X_PAYMENT_TYPE_ID
                     , X_PROPERTY_ID     => X_PAYMENT_PROPERTY_ID);
          else
            update rnt_ledger_entries
            set debit_account  = x_debit_account
            ,   credit_account = x_credit_account
            ,   entry_date     = x_payment_date
            where pay_alloc_id = (select pay_alloc_id 
                                  from rnt_payment_allocations
                                  where  ap_id = X_AP_ID);
          end if;
      end if;
  end update_allocation;

  function insert_row2( X_PAYMENT_DUE_DATE     IN RNT_ACCOUNTS_PAYABLE.PAYMENT_DUE_DATE%TYPE
                       , X_AMOUNT              IN RNT_ACCOUNTS_PAYABLE.AMOUNT%TYPE
                       , X_PAYMENT_TYPE_ID     IN RNT_ACCOUNTS_PAYABLE.PAYMENT_TYPE_ID%TYPE
                       , X_EXPENSE_ID          IN RNT_ACCOUNTS_PAYABLE.EXPENSE_ID%TYPE
                       , X_LOAN_ID             IN RNT_ACCOUNTS_PAYABLE.LOAN_ID%TYPE
                       , X_SUPPLIER_ID         IN RNT_ACCOUNTS_PAYABLE.SUPPLIER_ID%TYPE
                       , X_PAYMENT_DATE        IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE      := null
                       , X_PAYMENT_PROPERTY_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID%TYPE
                       , X_BUSINESS_ID         IN RNT_ACCOUNTS_PAYABLE.BUSINESS_ID%TYPE
                       , X_RECORD_TYPE         IN RNT_ACCOUNTS_PAYABLE.RECORD_TYPE%TYPE
                       , X_INVOICE_NUMBER      IN RNT_ACCOUNTS_PAYABLE.INVOICE_NUMBER%TYPE
                       , X_DEBIT_ACCOUNT       IN RNT_LEDGER_ENTRIES.DEBIT_ACCOUNT%TYPE          := null
                       , X_CREDIT_ACCOUNT      IN RNT_LEDGER_ENTRIES.CREDIT_ACCOUNT%TYPE         := null
                      )
              return RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE
  is
    x RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE;
    --
    v_pt_rule        RNT_LEDGER_PKG.DEBIT_CREDIT_T;
    v_ledger_id      RNT_LEDGER_ENTRIES.LEDGER_ID%TYPE;
    v_debit_account  RNT_LEDGER_ENTRIES.DEBIT_ACCOUNT%TYPE;
    v_credit_account  RNT_LEDGER_ENTRIES.CREDIT_ACCOUNT%TYPE;
    v_paytype        varchar2(80);
    v_property       varchar2(80);
  begin
      x := insert_row( X_PAYMENT_DUE_DATE    => X_PAYMENT_DUE_DATE
                     , X_AMOUNT              => X_AMOUNT
                     , X_PAYMENT_TYPE_ID     => X_PAYMENT_TYPE_ID
                     , X_EXPENSE_ID          => X_EXPENSE_ID
                     , X_LOAN_ID             => X_LOAN_ID
                     , X_SUPPLIER_ID         => X_SUPPLIER_ID
                     , X_PAYMENT_PROPERTY_ID => X_PAYMENT_PROPERTY_ID
                     , X_BUSINESS_ID         => X_BUSINESS_ID
                     , X_RECORD_TYPE         => X_RECORD_TYPE
                     , X_INVOICE_NUMBER      => X_INVOICE_NUMBER);
      --
      v_pt_rule := rnt_ledger_pkg.get_pt_accounts( X_BUSINESS_ID
                                                 , X_PAYMENT_TYPE_ID
                                                 , 'APS');

      if x_debit_account is null then
         v_debit_account := v_pt_rule.DEBIT_ACCOUNT;
      else
         v_debit_account := X_DEBIT_ACCOUNT;
      end if;

      select count(*)
      into v_property
      from rnt_properties
      where property_id = x_payment_property_id;

      if v_property = '0' then
         v_property := 'Business Unit';
      else
        select address1
        into v_property
        from rnt_properties
        where property_id = x_payment_property_id;
      end if;

      select payment_type_name
      into v_paytype
      from rnt_payment_types
      where payment_type_id = x_payment_type_id;

      v_ledger_id := rnt_ledger_entries_pkg.insert_row(
                       X_ENTRY_DATE      => X_PAYMENT_DUE_DATE
                     , X_DESCRIPTION     => 'Unscheduled payable '||v_paytype||' '||v_property
                     , X_DEBIT_ACCOUNT   => V_DEBIT_ACCOUNT
                     , X_CREDIT_ACCOUNT  => v_pt_rule.CREDIT_ACCOUNT
                     , X_AR_ID           => to_number(null)
                     , X_AP_ID           => x
                     , X_PAY_ALLOC_ID    => to_number(null)
                     , X_PAYMENT_TYPE_ID => X_PAYMENT_TYPE_ID
                     , X_PROPERTY_ID     => X_PAYMENT_PROPERTY_ID);                   


     -- 
     v_pt_rule := rnt_ledger_pkg.get_pt_accounts( X_BUSINESS_ID
                                                , X_PAYMENT_TYPE_ID
                                                , 'APP');
      if x_credit_account is null then
         v_credit_account := v_pt_rule.CREDIT_ACCOUNT;
      else
         v_credit_account := X_CREDIT_ACCOUNT;
      end if;


     update_allocation(X_AP_ID              => x
                    , X_PAYMENT_DATE        => X_PAYMENT_DATE
                    , X_AMOUNT              => X_AMOUNT
                    , X_PAYMENT_PROPERTY_ID => X_PAYMENT_PROPERTY_ID
                    , X_PAYMENT_TYPE_ID     => X_PAYMENT_TYPE_ID
                    , X_DEBIT_ACCOUNT       => v_pt_rule.DEBIT_ACCOUNT
                    , X_CREDIT_ACCOUNT      => V_CREDIT_ACCOUNT
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
                       , X_DEBIT_ACCOUNT  IN RNT_LEDGER_ENTRIES.DEBIT_ACCOUNT%TYPE
                       , X_CREDIT_ACCOUNT IN RNT_LEDGER_ENTRIES.CREDIT_ACCOUNT%TYPE
                       )
  is
    v_pt_rule        RNT_LEDGER_PKG.DEBIT_CREDIT_T;
  begin
      update_row( X_AP_ID               => X_AP_ID
                , X_PAYMENT_DUE_DATE    => X_PAYMENT_DUE_DATE
                , X_AMOUNT              => X_AMOUNT
                , X_PAYMENT_TYPE_ID     => X_PAYMENT_TYPE_ID
                , X_EXPENSE_ID          => X_EXPENSE_ID
                , X_LOAN_ID             => X_LOAN_ID
                , X_SUPPLIER_ID         => X_SUPPLIER_ID
                , X_CHECKSUM            => X_CHECKSUM
                , X_PAYMENT_PROPERTY_ID => X_PAYMENT_PROPERTY_ID
                , X_BUSINESS_ID         => X_BUSINESS_ID
                , X_RECORD_TYPE         => X_RECORD_TYPE
                , X_INVOICE_NUMBER      => X_INVOICE_NUMBER
                );

     v_pt_rule := rnt_ledger_pkg.get_pt_accounts( X_BUSINESS_ID
                                                , X_PAYMENT_TYPE_ID
                                                , 'APS');

     update rnt_ledger_entries
     set debit_account  = x_debit_account
     ,   credit_account = v_pt_rule.CREDIT_ACCOUNT
     where ap_id = x_ap_id
     and pay_alloc_id is null;

     v_pt_rule := rnt_ledger_pkg.get_pt_accounts(
                       X_BUSINESS_ID
                     , X_PAYMENT_TYPE_ID
                     , 'APP');

     update_allocation(X_AP_ID              => x_ap_id
                    , X_PAYMENT_DATE        => X_PAYMENT_DATE
                    , X_AMOUNT              => X_AMOUNT
                    , X_PAYMENT_PROPERTY_ID => X_PAYMENT_PROPERTY_ID
                    , X_PAYMENT_TYPE_ID     => X_PAYMENT_TYPE_ID
                    , X_DEBIT_ACCOUNT       => v_pt_rule.DEBIT_ACCOUNT
                    , X_CREDIT_ACCOUNT      => X_CREDIT_ACCOUNT
                    );


  end;

  procedure delete_row2( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE)
  is
    v_alloc_id   rnt_payment_allocations.pay_alloc_id%type;
  begin
    lock_row(X_AP_ID);
    --
    select pay_alloc_id
    into v_alloc_id
    from rnt_payment_allocations
    where ap_id = x_ap_id;

    delete from RNT_LEDGER_ENTRIES
    where  pay_alloc_id = v_alloc_id;

    delete from RNT_LEDGER_ENTRIES
    where  ap_id = X_AP_ID;
    --
    delete from RNT_PAYMENT_ALLOCATIONS
    where AP_ID = X_AP_ID;

    delete_row(X_AP_ID);
  end;

  function get_date_by_recurring(x_daily varchar2, x_date DATE) return DATE
  is
   v_date DATE := x_date;
   v_monthyear varchar2(8);
 begin
   if upper(x_daily) = 'D' then
      v_date := v_date + 1;
   elsif upper(x_daily) = 'W' then
     v_date := v_date + 7;
   elsif upper(x_daily) = 'BW' then
     v_date := v_date + 14;
   elsif upper(x_daily) = 'HM' then
      v_monthyear := to_char(v_date, 'MON-YYYY');
      if v_date < to_date('15-'||v_monthyear, 'dd-MON-YYYY') then
         v_date := to_date('15-'||v_monthyear, 'dd-MON-YYYY');
      else
         v_date := add_months(to_date('01-'||v_monthyear, 'dd-MON-YYYY'), 1);
      end if;
   elsif upper(x_daily) = 'M' then
     v_date := add_months(v_date, 1);
   elsif upper(x_daily) = 'BM' then
     v_date := add_months(v_date, 2);
   elsif upper(x_daily) = 'Q' then
     v_date := add_months(v_date, 3);
   elsif upper(x_daily) = 'TY' then
     v_date := add_months(v_date, 6);
   else
     RAISE_APPLICATION_ERROR(-20030, 'Unknown type of recurring period');
   end if;
   return v_date;

  end get_date_by_recurring;

  function generate_payments(X_BUSINESS_ID in RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE, X_NEED_DATE in DATE) return NUMBER
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
          and RNT_ACCOUNTS_PAYABLE_PKG.GET_DATE_BY_RECURRING(e.RECURRING_PERIOD, ap.PAYMENT_DUE_DATE) <= X_NEED_DATE
          and exists (select 1
                      from RNT_PROPERTIES p
                      where p.PROPERTY_ID = e.PROPERTY_ID
                        and BUSINESS_ID = X_BUSINESS_ID);
    x_cnt NUMBER := 0;
    --
    v_ap_id            rnt_accounts_payable.ap_id%type;
    v_pt_rule          rnt_ledger_pkg.debit_credit_t;
    v_ledger_id        rnt_ledger_entries.ledger_id%type;
    v_paytype      varchar2(80);
    v_property     varchar2(80);
  begin
    savepoint T_;
    for x in c loop
        insert into RNT_ACCOUNTS_PAYABLE (
               AP_ID, PAYMENT_DUE_DATE, AMOUNT,
               PAYMENT_TYPE_ID, EXPENSE_ID, LOAN_ID,
               SUPPLIER_ID, PAYMENT_PROPERTY_ID, BUSINESS_ID, RECORD_TYPE, INVOICE_NUMBER)
        values (RNT_ACCOUNTS_PAYABLE_SEQ.NEXTVAL, x.PAYMENT_NEXT_DATE, x.AMOUNT,
                x.PAYMENT_TYPE_ID, x.EXPENSE_ID, x.LOAN_ID,
                x.SUPPLIER_ID, x.PAYMENT_PROPERTY_ID, x.BUSINESS_ID, RNT_ACCOUNTS_PAYABLE_CONST_PKG.CONST_GENERATE_TYPE_VAL(), x.INVOICE_NUMBER)
        returning AP_ID into v_ap_id;
        --
        -- generate ledger entry
        --

        select address1
        into v_property
        from rnt_properties
        where property_id = x.payment_property_id;

        select payment_type_name
        into v_paytype
        from rnt_payment_types
        where payment_type_id = x.payment_type_id;

        v_pt_rule := rnt_ledger_pkg.get_pt_accounts(
                          X_BUSINESS_ID
                        , x.PAYMENT_TYPE_ID
                        , 'APS');
        v_ledger_id := rnt_ledger_entries_pkg.insert_row(
                               X_ENTRY_DATE      => x.PAYMENT_NEXT_DATE
                             , X_DESCRIPTION     => 'Scheduled payment '||v_paytype||' '||v_property
                             , X_DEBIT_ACCOUNT   => v_pt_rule.debit_account
                             , X_CREDIT_ACCOUNT  => v_pt_rule.credit_account
                             , X_AR_ID           => to_number(null)
                             , X_AP_ID           => v_ap_id
                             , X_PAY_ALLOC_ID    => to_number(null)
                             , X_PAYMENT_TYPE_ID => x.PAYMENT_TYPE_ID
                             , X_PROPERTY_ID     => x.PAYMENT_PROPERTY_ID);        
        --        
        x_cnt := x_cnt + 1;
     end loop;
    commit;
    return x_cnt;
  exception
    when OTHERS then
       rollback to T_;
       raise;
  end;

  procedure generate_payment_list(X_BUSINESS_ID in RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE, X_NEED_DATE in DATE)
  is
    x NUMBER;
  begin
    for i in 1..30 loop
       x := generate_payments(X_BUSINESS_ID, X_NEED_DATE);
       exit when x = 0;
    end loop;
    --update_payment_list;
  end;

end RNT_ACCOUNTS_PAYABLE_PKG;
/
