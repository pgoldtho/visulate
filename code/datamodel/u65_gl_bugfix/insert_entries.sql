declare

  cursor missing_schedule is
  select ar.business_id
  ,      ar.payment_type
  ,      ar.payment_due_date
  ,      ar.payment_property_id
  ,      p.address1
  ,      ar.ar_id
  from rnt_accounts_receivable ar
  ,    rnt_properties p
  where p.property_id = ar.payment_property_id
  and not exists (select 1 
                    from rnt_ledger_entries l
                    where l.ar_id = ar.ar_id)
  order by payment_due_date, business_id, payment_type;
  
  cursor missing_payment(p_ar_id in  rnt_accounts_receivable.ar_id%type) is
  select pa.pay_alloc_id
  ,      pa.payment_date
  from rnt_payment_allocations pa
  where pa.ar_id = p_ar_id
  and not exists (select 1 
                  from rnt_ledger_entries l
                  where l.pay_alloc_id = pa.pay_alloc_id)
  order by payment_date;

  v_account         rnt_ledger_pkg.debit_credit_t;
  v_ledger_id       rnt_ledger_entries.ledger_id%type;
  
  procedure prn_transaction
                     ( X_ENTRY_DATE      IN RNT_LEDGER_ENTRIES.ENTRY_DATE%TYPE
                     , X_DESCRIPTION     IN RNT_LEDGER_ENTRIES.DESCRIPTION%TYPE
                     , X_DEBIT_ACCOUNT   IN RNT_LEDGER_ENTRIES.DEBIT_ACCOUNT%TYPE
                     , X_CREDIT_ACCOUNT  IN RNT_LEDGER_ENTRIES.CREDIT_ACCOUNT%TYPE
                     , X_PAYMENT_TYPE_ID IN RNT_LEDGER_ENTRIES.PAYMENT_TYPE_ID%TYPE
                     , X_AR_ID           IN RNT_LEDGER_ENTRIES.AR_ID%TYPE
                     , X_AP_ID           IN RNT_LEDGER_ENTRIES.AP_ID%TYPE
                     , X_PAY_ALLOC_ID    IN RNT_LEDGER_ENTRIES.PAY_ALLOC_ID%TYPE
					 , X_PROPERTY_ID     IN RNT_LEDGER_ENTRIES.PROPERTY_ID%TYPE) is
    v_debit   varchar2(80);					 
    v_credit  varchar2(80);
	v_type    varchar2(80);
  begin
    select account_number||' - '||name
	into v_debit
	from rnt_accounts
	where account_id = X_DEBIT_ACCOUNT;
	
    select account_number||' - '||name
	into v_credit
	from rnt_accounts
	where account_id = X_CREDIT_ACCOUNT;	
	
	select payment_type_name
	into v_type
	from rnt_payment_types
	where payment_type_id = X_PAYMENT_TYPE_ID;
	
	dbms_output.put_line('Date: '||X_ENTRY_DATE);
	dbms_output.put_line('Desc: '||X_DESCRIPTION);
	dbms_output.put_line('Debit: '||V_DEBIT);
	dbms_output.put_line('Credit: '||V_CREDIT);
	dbms_output.put_line('Payment Type: '||v_type);
	dbms_output.put_line('AR: '||X_AR_ID);
	dbms_output.put_line('AP: '||X_AP_ID);
	dbms_output.put_line('Alloc: '||X_PAY_ALLOC_ID);
	dbms_output.put_line('Property: '||X_PROPERTY_ID);
	dbms_output.put_line('===================================');				   
	
  end prn_transaction;
  
begin
  for s_rec in missing_schedule loop
    v_account := rnt_ledger_pkg.get_pt_accounts
	               ( p_business_id      => s_rec.business_id
                   , p_payment_type_id  => s_rec.payment_type
                   , p_transaction_type => 'ARS');
	--dbms_output.put_line('================================================================');				   
    v_ledger_id := rnt_ledger_entries_pkg.insert_row
                   ( X_ENTRY_DATE        => s_rec.payment_due_date
                     , X_DESCRIPTION     => 'Scheduled payment for '||s_rec.address1
                     , X_DEBIT_ACCOUNT   => v_account.debit_account
                     , X_CREDIT_ACCOUNT  => v_account.credit_account
                     , X_PAYMENT_TYPE_ID => s_rec.payment_type
                     , X_AR_ID           => s_rec.ar_id
                     , X_AP_ID           => null
                     , X_PAY_ALLOC_ID    => null
					 , X_PROPERTY_ID     => s_rec.payment_property_id);

    for p_rec in missing_payment(s_rec.ar_id) loop				
	    v_account := rnt_ledger_pkg.get_pt_accounts
	               ( p_business_id      => s_rec.business_id
                   , p_payment_type_id  => s_rec.payment_type
                   , p_transaction_type => 'ARP');

	  v_ledger_id :=  rnt_ledger_entries_pkg.insert_row
                   ( X_ENTRY_DATE        => p_rec.payment_date
                     , X_DESCRIPTION     => 'Payment for '||s_rec.address1
                     , X_DEBIT_ACCOUNT   => v_account.debit_account
                     , X_CREDIT_ACCOUNT  => v_account.credit_account
                     , X_PAYMENT_TYPE_ID => s_rec.payment_type
                     , X_AR_ID           => s_rec.ar_id
                     , X_AP_ID           => null
                     , X_PAY_ALLOC_ID    => p_rec.pay_alloc_id
					 , X_PROPERTY_ID     => s_rec.payment_property_id);
    end loop;	
  end loop;
end;
/  