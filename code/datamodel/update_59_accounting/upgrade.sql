declare
  v_ap_id                        rnt_accounts_payable.ap_id%type;
  v_payment_type                 rnt_payment_types.payment_type_id%type;
  v_txn_accounts                 rnt_ledger_pkg.debit_credit_t;
  v_ledger_id                    number;

  cursor cur_business_unit is
  SELECT BUSINESS_ID
  ,      BUSINESS_NAME
  ,      PARENT_BUSINESS_ID
  FROM RNTMGR.RNT_BUSINESS_UNITS
  where parent_business_id not in (0, -1);

  cursor cur_loans(p_business in rnt_business_units.business_id%type) is
  SELECT L.LOAN_ID
  ,      L.PROPERTY_ID
  ,      L.POSITION
  ,      L.LOAN_DATE
  ,      L.LOAN_AMOUNT
  ,      L.TERM
  ,      L.INTEREST_RATE
  ,      L.CREDIT_LINE_YN
  ,      L.ARM_YN
  ,      L.BALLOON_DATE
  ,      L.SETTLEMENT_DATE
  ,      L.CLOSING_COSTS
  ,      P.ADDRESS1 
  FROM RNT_LOANS L
  ,    RNT_PROPERTIES P
  WHERE P.BUSINESS_ID = P_BUSINESS
  AND P.PROPERTY_ID = L.PROPERTY_ID
  and not exists (select 1
                  from rnt_accounts_payable ap
                  where ap.loan_id = l.loan_id);


begin

  for b_rec in cur_business_unit loop
   rnt_ledger_pkg.create_bu_accounts(b_rec.business_id);
      rnt_ledger_pkg.post_ledger_entries
            ( b_rec.business_id
            , rnt_ledger_pkg.get_current_period(b_rec.business_id)
            , sysdate);

     rnt_ledger_pkg.generate_contra_entries
            ( b_rec.business_id
            , sysdate);


   for l_rec in cur_loans(b_rec.business_id) loop
       v_payment_type := rnt_ledger_pkg.get_payment_type_id('Loan Origination');
           v_ap_id := rnt_accounts_payable_pkg.insert_row
                            ( x_payment_due_date     => l_rec.loan_date
                            , x_amount               => l_rec.loan_amount
                            , x_payment_type_id      => v_payment_type
                            , x_expense_id           => null
                            , x_loan_id              => l_rec.loan_id
                            , x_supplier_id          => null
                            , x_payment_property_id  => l_rec.property_id
                            , x_business_id          => b_rec.business_id
                            , x_record_type          => rnt_accounts_payable_const_pkg.CONST_GENERATE_TYPE
                            , x_invoice_number       => null);

          v_txn_accounts := rnt_ledger_pkg.get_pt_accounts( p_business_id      => b_rec.business_id
                                                          , p_payment_type_id  => v_payment_type
                                                          , p_transaction_type => 'APS');

          v_ledger_id := rnt_ledger_entries_pkg.insert_row
                           ( x_entry_date      => l_rec.loan_date
                           , x_description     => 'Loan Origination '||l_rec.address1
                                                  ||' loan position '||l_rec.position
                           , x_debit_account   => v_txn_accounts.debit_account
                           , x_credit_account  => v_txn_accounts.credit_account
                           , x_ar_id           => null
                           , x_ap_id           => v_ap_id
                           , x_pay_alloc_id    => null
                           , x_payment_type_id => v_payment_type 
                           , x_property_id     => l_rec.property_id);



   end loop;

  end loop;
end;
/