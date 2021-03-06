set define ^
create or replace package rnt_ledger_pkg as
/*******************************************************************************
   Copyright (c) Visulate 2009        All rights reserved worldwide
    Name:      RNT_LEDGER_PKG
    Purpose:   API's for the general ledger
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        30-JUN-09   Peter Goldthoprp Initial Version
*******************************************************************************/

  type debit_credit_t is record ( debit_account   rnt_accounts.account_id%type
                                , credit_account  rnt_accounts.account_id%type);

 procedure ins_default_rules
   ( p_ptype    in rnt_payment_types.payment_type_id%type
   , p_txn_type in rnt_default_pt_rules.transaction_type%type
   , p_debit    in rnt_default_pt_rules.debit_account%type
   , p_credit   in rnt_default_pt_rules.credit_account%type);

  --
  -- Create or update Payment Types
  --

  function getset_pt( p_payment_type_name  in rnt_payment_types.payment_type_name%type
                    , p_depreciation_term  in rnt_payment_types.depreciation_term%type
                    , p_description        in rnt_payment_types.description%type
                    , p_payable_yn         in rnt_payment_types.payable_yn%type
                    , p_receivable_yn      in rnt_payment_types.receivable_yn%type
                    , p_service_life       in rnt_payment_types.service_life%type
                    , p_noi_yn             in rnt_payment_types.noi_yn%type)
          return rnt_payment_types.payment_type_id%type;


  function get_payment_type_id(p_name in rnt_payment_types.payment_type_name%type) 
         return rnt_payment_types.payment_type_id%type;

  function get_account_id( p_account_number    in rnt_accounts.account_number%type
                         , p_business_id  in rnt_business_units.business_id%type)
         return rnt_accounts.account_id%type;

  procedure create_bu_accounts
              ( p_business_id   in rnt_business_units.business_id%type);

  function get_current_period
              ( p_business_id   in rnt_business_units.business_id%type)
    return rnt_account_periods.period_id%type;

  procedure post_ledger_entries
              ( p_business_id   in rnt_business_units.business_id%type
              , p_period_id     in rnt_account_periods.period_id%type
              , p_end_date      in date);

  function get_txn_amount (p_ledger_id in rnt_ledger_entries.ledger_id%type)
    return number;


  function get_pt_accounts( p_business_id      in rnt_business_units.business_id%type
                          , p_payment_type_id  in rnt_payment_types.payment_type_id%type
                          , p_transaction_type in rnt_pt_rules.transaction_type%type)
                   return debit_credit_t;

  function closed_period( p_business_id   in  rnt_business_units.business_id%type
                        , p_date          in date)
    return varchar2;

    procedure post_entry( p_entry_date     in date
	                    , p_amount         in number
						, p_debit_account  in number
						, p_credit_account in number
						, p_property_id    in number
						, p_business_id    in number
						, p_payment_type   in number
						, p_description    in varchar2);
	
  procedure update_loans( p_business_id   in  rnt_business_units.business_id%type
                        , p_date          in date);
						
  procedure generate_contra_entries( p_business_id   in  rnt_business_units.business_id%type
                                   , p_date          in date);

  function get_account_balance( p_account_id   in  rnt_accounts.account_id%type
                              , p_date          in date
							  , p_property_id  in rnt_properties.property_id%type := null) return number;



end rnt_ledger_pkg;
/


create or replace package body rnt_ledger_pkg as
/*******************************************************************************
   Copyright (c) Visulate 2009        All rights reserved worldwide
    Name:      RNT_LEDGER_PKG
    Purpose:   API's for the general ledger
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        30-JUN-09   Peter Goldthoprp Initial Version
*******************************************************************************/

 procedure ins_default_rules
   ( p_ptype    in rnt_payment_types.payment_type_id%type
   , p_txn_type in rnt_default_pt_rules.transaction_type%type
   , p_debit    in rnt_default_pt_rules.debit_account%type
   , p_credit   in rnt_default_pt_rules.credit_account%type) is

  cursor cur_business_unit is
  SELECT BUSINESS_ID
  ,      BUSINESS_NAME
  ,      PARENT_BUSINESS_ID
  FROM  RNT_BUSINESS_UNITS
  where parent_business_id not in (0, -1); 

 begin
   insert into rnt_default_pt_rules
     (payment_type_id, transaction_type, debit_account, credit_account)
   values
     (p_ptype, p_txn_type, p_debit, p_credit);

  for b_rec in cur_business_unit loop
    rnt_pt_rules_pkg.insert_row
           ( x_business_id      => b_rec.business_id
           , x_payment_type_id  => p_ptype
           , x_transaction_type => p_txn_type
           , x_debit_account    => rnt_ledger_pkg.get_account_id( p_debit, b_rec.business_id)
           , x_credit_account   => rnt_ledger_pkg.get_account_id( p_credit, b_rec.business_id));
  end loop;

 end ins_default_rules;


 function getset_pt( p_payment_type_name  in rnt_payment_types.payment_type_name%type
                   , p_depreciation_term  in rnt_payment_types.depreciation_term%type
                   , p_description        in rnt_payment_types.description%type
                   , p_payable_yn         in rnt_payment_types.payable_yn%type
                   , p_receivable_yn      in rnt_payment_types.receivable_yn%type
                   , p_service_life       in rnt_payment_types.service_life%type
                   , p_noi_yn             in rnt_payment_types.noi_yn%type)
          return rnt_payment_types.payment_type_id%type is

   cursor get_pt( p_name  in rnt_payment_types.payment_type_name%type) is
   SELECT PAYMENT_TYPE_ID
   FROM RNT_PAYMENT_TYPES
   where payment_type_name = p_name;

   p_id    rnt_payment_types.payment_type_id%type;

 begin

   P_id := null;
   for p_rec in get_pt(p_payment_type_name) loop
     p_id := p_rec.payment_type_id;
   end loop;

   if p_id is not null then
      update rnt_payment_types
      set depreciation_term = p_depreciation_term
      ,   description       = p_description
      ,   payable_yn        = p_payable_yn
      ,   receivable_yn     = p_receivable_yn
      ,   service_life      = p_service_life
      ,   noi_yn            = p_noi_yn
      where payment_type_id = p_id;
   else
      insert into RNT_PAYMENT_TYPES
      ( PAYMENT_TYPE_ID
      , PAYMENT_TYPE_NAME
      , DEPRECIATION_TERM
      , DESCRIPTION
      , PAYABLE_YN
      , RECEIVABLE_YN
      , SERVICE_LIFE
      , NOI_YN)
      values
     ( RNT_PAYMENT_TYPES_SEQ.nextval
     , p_payment_type_name
     , p_depreciation_term
     , p_description
     , p_payable_yn
     , p_receivable_yn
     , p_service_life
     , p_noi_yn)
     returning payment_type_id into p_id;
  end if;
  return p_id;
 end getset_pt;



  function get_payment_type_id(p_name in rnt_payment_types.payment_type_name%type) 
         return rnt_payment_types.payment_type_id%type  is


    v_return_value     rnt_payment_types.payment_type_id%type;

  begin
    select payment_type_id
    into v_return_value
    from rnt_payment_types
    where payment_type_name = p_name;
  
    return v_return_value;

  end get_payment_type_id;



  function get_account_id( p_account_number    in rnt_accounts.account_number%type
                         , p_business_id  in rnt_business_units.business_id%type)
         return rnt_accounts.account_id%type is 

    v_return        rnt_accounts.account_id%type;

  begin  
   select account_id
   into v_return
   from rnt_accounts
   where account_number = p_account_number
   and business_id = p_business_id;

   return v_return;

  end get_account_id;




  procedure create_bu_accounts
              ( p_business_id   in rnt_business_units.business_id%type) is

   v_business_id         rnt_business_units.business_id%type;
   v_account_id          rnt_accounts.account_id%type;
   v_period_id           rnt_account_periods.period_id%type;

   cursor cur_default_accounts is
   select account_number
   ,      name
   ,      account_type
   ,      current_balance_yn
   from rnt_default_accounts
   order by account_number;

   cursor cur_default_pt_rules is 
   select payment_type_id
   ,      transaction_type
   ,      debit_account
   ,      credit_account
   from rnt_default_pt_rules
   order by payment_type_id, transaction_type;

  begin
   -- Validate the input parameter
   select business_id
   into v_business_id
   from rnt_business_units
   where business_id = p_business_id
   and parent_business_id not in (-1, 0);

   
   v_period_id := rnt_account_periods_pkg.insert_row( x_business_id => p_business_id
                                                    , x_start_date  => to_date('01-JAN-2000', 'dd-MON-yyyy')
                                                    , x_closed_yn   => 'N');

   for a_rec in cur_default_accounts loop

     v_account_id := rnt_accounts_pkg.insert_row( x_account_number     => a_rec.account_number
                                                , x_business_id        => p_business_id
                                                , x_name               => a_rec.name
                                                , x_account_type       => a_rec.account_type
                                                , x_user_assign_id     => null
                                                , x_people_business_id => null
                                                , x_current_balance_yn => a_rec.current_balance_yn);

     rnt_account_balances_pkg.insert_row( x_account_id      => v_account_id
                                        , x_period_id       => v_period_id
                                        , x_opening_balance => 0.00);


   end loop;

   for r_rec in cur_default_pt_rules loop

     rnt_pt_rules_pkg.insert_row( x_business_id      => v_business_id
                                , x_payment_type_id  => r_rec.payment_type_id
                                , x_transaction_type => r_rec.transaction_type
                                , x_debit_account    => get_account_id( r_rec.debit_account, v_business_id)
                                , x_credit_account   => get_account_id( r_rec.credit_account, v_business_id));
   end loop;

  end create_bu_accounts;


  function get_current_period
              ( p_business_id   in rnt_business_units.business_id%type)
    return rnt_account_periods.period_id%type is

    cursor cur_period( p_business_id   in rnt_business_units.business_id%type) is
    select period_id
    from rnt_account_periods
    where closed_yn = 'N'
    order by start_date;

    v_return    rnt_account_periods.period_id%type;

  begin
    for p_rec in cur_period(p_business_id) loop
      v_return := p_rec.period_id;
    end loop;
    return v_return;
  end get_current_period;
 




  procedure post_ledger_entries
              ( p_business_id   in rnt_business_units.business_id%type
              , p_period_id     in rnt_account_periods.period_id%type
              , p_end_date      in date) is

    cursor cur_aps( p_business_id   in rnt_business_units.business_id%type
                  , p_start_date    in date
                  , p_end_date      in date) is
    select ap.ap_id
    ,      ap.payment_type_id
    ,      ap.payment_due_date
    ,       p.address1
    ,       e.description
    ,       s.name
    ,      pt.debit_account
    ,      pt.credit_account
    ,       p.property_id
    from rnt_accounts_payable ap
    ,    rnt_properties p
    ,    rnt_property_expenses e
    ,    rnt_suppliers_all s
    ,    rnt_pt_rules pt
    where ap.business_id = p_business_id
    and ap.payment_property_id = p.property_id (+)
    and ap.expense_id = e.expense_id(+)
    and ap.supplier_id = s.supplier_id (+)
    and ap.payment_due_date <= p_end_date
    and ap.payment_due_date >= p_start_date
    and pt.business_id = ap.business_id
    and pt.payment_type_id = ap.payment_type_id
    and pt.transaction_type = 'APS'
    order by ap.ap_id;

  cursor cur_app( p_business_id   in rnt_business_units.business_id%type
                , p_start_date    in date
                , p_end_date      in date) is
    select pa.pay_alloc_id
    ,      ap.payment_type_id
    ,      pa.payment_date
    ,       p.address1
    ,       e.description
    ,       s.name
    ,      pt.debit_account
    ,      pt.credit_account
    ,       p.property_id
    from rnt_accounts_payable    ap
    ,    rnt_properties          p
    ,    rnt_property_expenses   e
    ,    rnt_suppliers_all       s
    ,    rnt_pt_rules            pt
    ,    rnt_payment_allocations pa
    where ap.business_id       = p_business_id
    and ap.payment_property_id = p.property_id (+)
    and ap.expense_id          = e.expense_id(+)
    and ap.supplier_id         = s.supplier_id (+)
    and pa.payment_date       <= p_end_date
    and pa.payment_date       >= p_start_date
    and pa.ap_id               = ap.ap_id
    and pt.business_id         = ap.business_id
    and pt.payment_type_id     = ap.payment_type_id
    and pt.transaction_type    = 'APP'
    order by pa.pay_alloc_id;

    cursor cur_ars( p_business_id   in rnt_business_units.business_id%type
                  , p_start_date    in date
                  , p_end_date      in date) is
    select ar.ar_id
    ,      ar.payment_type
    ,      ar.payment_due_date
    ,       p.address1
    ,      pp.first_name
    ,      pp.last_name
    ,      aa.action_type
    ,      pt.debit_account
    ,      pt.credit_account
    ,       p.property_id
    from rnt_accounts_receivable ar
    ,    rnt_properties          p
    ,    rnt_tenant              t
    ,    rnt_people              pp
    ,    rnt_agreement_actions   aa
    ,    rnt_pt_rules            pt
    where ar.business_id       = p_business_id
    and ar.payment_property_id = p.property_id (+)
    and ar.tenant_id           = t.tenant_id(+)
    and t.people_id            = pp.people_id(+)
    and ar.agreement_action_id = aa.action_id (+)
    and ar.payment_due_date   <= p_end_date
    and ar.payment_due_date   >= p_start_date
    and pt.business_id         = ar.business_id
    and pt.payment_type_id     = ar.payment_type
    and pt.transaction_type    = 'ARS'
    order by ar.ar_id;

    cursor cur_arp( p_business_id   in rnt_business_units.business_id%type
                  , p_start_date    in date
                  , p_end_date      in date) is
    select pa.pay_alloc_id
    ,      ar.payment_type
    ,      ar.payment_due_date
    ,       p.address1
    ,      pp.first_name
    ,      pp.last_name
    ,      aa.action_type
    ,      pt.debit_account
    ,      pt.credit_account
    ,      pa.payment_date
    ,       p.property_id
    from rnt_accounts_receivable ar
    ,    rnt_properties          p
    ,    rnt_tenant              t
    ,    rnt_people              pp
    ,    rnt_agreement_actions   aa
    ,    rnt_pt_rules            pt
    ,    rnt_payment_allocations pa
    where ar.business_id       = p_business_id
    and ar.payment_property_id = p.property_id (+)
    and ar.tenant_id           = t.tenant_id(+)
    and t.people_id            = pp.people_id(+)
    and ar.agreement_action_id = aa.action_id (+)
    and pa.ar_id               = ar.ar_id
    and pa.payment_date       <= p_end_date
    and pa.payment_date       >= p_start_date
    and pt.business_id         = ar.business_id
    and pt.payment_type_id     = ar.payment_type
    and pt.transaction_type    = 'ARP'
    order by ar.ar_id;

    cursor cur_aps_ledger(p_ap_id in rnt_accounts_payable.ap_id%type) is
    select ledger_id
    from rnt_ledger_entries
    where ap_id = p_ap_id;

    cursor cur_ars_ledger(p_ar_id in rnt_accounts_receivable.ar_id%type) is
    select ledger_id
    from rnt_ledger_entries
    where ar_id = p_ar_id;


    cursor cur_app_ledger(p_pay_alloc_id in rnt_payment_allocations.pay_alloc_id%type) is
    select ledger_id
    from rnt_ledger_entries
    where pay_alloc_id = p_pay_alloc_id;


    v_ledger_id          RNT_LEDGER_ENTRIES.LEDGER_ID%TYPE;
    v_start_date         date;
    v_closed_yn          rnt_account_periods.closed_yn%type;
    v_ledger_entry_count pls_integer;

  begin

   select start_date, closed_yn
   into v_start_date, v_closed_yn
   from rnt_account_periods
   where period_id = p_period_id;

   if upper(v_closed_yn) != 'N' then
      RAISE_APPLICATION_ERROR(-20902, 'Cannot insert ledger rows for a closed accounting period');      
   end if;

   select count(*)
   into v_ledger_entry_count
   from rnt_accounts a
   ,    rnt_ledger_entries le
   where a.business_id = p_business_id
   and (a.account_id = le.debit_account OR
        a.account_id = le.credit_account)
   and le.entry_date <= p_end_date
   and le.entry_date >= v_start_date;

   if v_ledger_entry_count != 0 then
     RAISE_APPLICATION_ERROR(-20903, 'Bulk insert of ledger entries is only allowed when '
                                  || 'no entries have been posted for the selected accounting period.');      
   end if;
   
   for aps_rec in cur_aps(p_business_id, v_start_date, p_end_date) loop
         
     v_ledger_id := 0;
     for a_rec in cur_aps_ledger(aps_rec.AP_ID) loop
       v_ledger_id := a_rec.ledger_id;
     end loop;

     if v_ledger_id = 0 then
       v_ledger_id := 
       rnt_ledger_entries_pkg.insert_row( X_ENTRY_DATE      => aps_rec.PAYMENT_DUE_DATE
                                        , X_DESCRIPTION     => 'Scheduled payment for '||aps_rec.address1||' '
                                                             ||aps_rec.description ||' '||aps_rec.name
                                        , X_DEBIT_ACCOUNT   => aps_rec.DEBIT_ACCOUNT
                                        , X_CREDIT_ACCOUNT  => aps_rec.CREDIT_ACCOUNT
                                        , X_PAYMENT_TYPE_ID => aps_rec.PAYMENT_TYPE_ID
                                        , X_AR_ID           => null
                                        , X_AP_ID           => aps_rec.AP_ID
                                        , X_PAY_ALLOC_ID    => null
                                        , X_PROPERTY_ID     => aps_rec.property_id);
     end if;

    end loop;

   for app_rec in cur_app(p_business_id, v_start_date, p_end_date) loop

     v_ledger_id := 0;

     for a_rec in cur_app_ledger(app_rec.pay_alloc_id) loop
       v_ledger_id := a_rec.ledger_id;
     end loop;

     if v_ledger_id = 0 then
       v_ledger_id := 
       rnt_ledger_entries_pkg.insert_row( X_ENTRY_DATE      => app_rec.PAYMENT_DATE
                                        , X_DESCRIPTION     => 'Made payment for '||app_rec.address1    ||' '
                                                             ||app_rec.description ||' '||app_rec.name
                                        , X_DEBIT_ACCOUNT   => app_rec.DEBIT_ACCOUNT
                                        , X_CREDIT_ACCOUNT  => app_rec.CREDIT_ACCOUNT
                                        , X_PAYMENT_TYPE_ID => app_rec.PAYMENT_TYPE_ID
                                        , X_AR_ID           => null
                                        , X_AP_ID           => null
                                        , X_PAY_ALLOC_ID    => app_rec.pay_alloc_id
                                        , X_PROPERTY_ID     => app_rec.property_id);
     end if;

    end loop;

   for ars_rec in cur_ars(p_business_id, v_start_date, p_end_date) loop
         
     v_ledger_id := 0;
     for a_rec in cur_ars_ledger(ars_rec.AR_ID) loop
       v_ledger_id := a_rec.ledger_id;
     end loop;

     if v_ledger_id = 0 then
       v_ledger_id := 
       rnt_ledger_entries_pkg.insert_row( X_ENTRY_DATE      => ars_rec.PAYMENT_DUE_DATE
                                        , X_DESCRIPTION     => 'Scheduled receipt for '||ars_rec.address1||' '
                                                             ||ars_rec.first_name ||' '||ars_rec.last_name||' '||ars_rec.action_type
                                        , X_DEBIT_ACCOUNT   => ars_rec.DEBIT_ACCOUNT
                                        , X_CREDIT_ACCOUNT  => ars_rec.CREDIT_ACCOUNT
                                        , X_PAYMENT_TYPE_ID => ars_rec.PAYMENT_TYPE
                                        , X_AR_ID           => ars_rec.AR_ID
                                        , X_AP_ID           => null
                                        , X_PAY_ALLOC_ID    => null
                                        , X_PROPERTY_ID     => ars_rec.property_id);
     end if;

    end loop;

   for arp_rec in cur_arp(p_business_id, v_start_date, p_end_date) loop

     v_ledger_id := 0;
     for a_rec in cur_app_ledger(arp_rec.pay_alloc_id) loop
       v_ledger_id := a_rec.ledger_id;
     end loop;

     if v_ledger_id = 0 then
       v_ledger_id := 
       rnt_ledger_entries_pkg.insert_row( X_ENTRY_DATE      => arp_rec.PAYMENT_DATE
                                        , X_DESCRIPTION     => 'Receipt for '||arp_rec.address1    ||' '
                                                             ||arp_rec.first_name ||' '||arp_rec.last_name||' '||arp_rec.action_type
                                        , X_DEBIT_ACCOUNT   => arp_rec.DEBIT_ACCOUNT
                                        , X_CREDIT_ACCOUNT  => arp_rec.CREDIT_ACCOUNT
                                        , X_PAYMENT_TYPE_ID => arp_rec.PAYMENT_TYPE
                                        , X_AR_ID           => null
                                        , X_AP_ID           => null
                                        , X_PAY_ALLOC_ID    => arp_rec.pay_alloc_id
                                        , X_PROPERTY_ID     => arp_rec.property_id);
     end if;

    end loop;

  end post_ledger_entries;

  function get_txn_amount (p_ledger_id in rnt_ledger_entries.ledger_id%type)
    return number is

    l_ar_id           rnt_accounts_receivable.ar_id%type;
    l_ap_id           rnt_accounts_payable.ap_id%type;
    l_pay_alloc_id    rnt_payment_allocations.pay_alloc_id%type;
    l_return_value    number;

  begin

   select ar_id, ap_id, pay_alloc_id
   into l_ar_id, l_ap_id, l_pay_alloc_id
   from rnt_ledger_entries
   where ledger_id = p_ledger_id;

   if (l_ar_id is not null and 
       l_ap_id is null and
       l_pay_alloc_id is null) then
                              select nvl(amount, 0)
                              into l_return_value
                              from rnt_accounts_receivable
                              where ar_id = l_ar_id;
   elsif (l_ar_id is null and 
          l_ap_id is not null and
          l_pay_alloc_id is null) then
                              select nvl(amount, 0)
                              into l_return_value
                              from rnt_accounts_payable
                              where ap_id = l_ap_id;
   elsif (l_pay_alloc_id is not null) then
                              select nvl(amount, 0)
                              into l_return_value
                              from rnt_payment_allocations
                              where pay_alloc_id = l_pay_alloc_id;
   else
       RAISE_APPLICATION_ERROR(-20901, 'Unable to find amount for ledger entry');
   end if;

   return round(l_return_value, 2);

  end  get_txn_amount;


  function get_pt_accounts( p_business_id      in rnt_business_units.business_id%type
                          , p_payment_type_id  in  rnt_payment_types.payment_type_id%type
                          , p_transaction_type in rnt_pt_rules.transaction_type%type)
                   return debit_credit_t is

    v_return_value     debit_credit_t;
  begin
    select debit_account, credit_account
    into v_return_value.debit_account
    ,    v_return_value.credit_account
    from rnt_pt_rules
    where business_id    = p_business_id
    and payment_type_id  = p_payment_type_id
    and transaction_type = p_transaction_type;

    return v_return_value;
  end get_pt_accounts;
  
   function get_pt_accounts( p_business_id      in rnt_business_units.business_id%type
                          , p_payment_type      in rnt_payment_types.payment_type_name%type
                          , p_transaction_type  in rnt_pt_rules.transaction_type%type)
                   return debit_credit_t is
	  v_payment_type_id    rnt_payment_types.payment_type_id%type;
   begin
     select payment_type_id
	 into v_payment_type_id
	 from rnt_payment_types
	 where payment_type_name = p_payment_type;
	 
	 return get_pt_accounts(p_business_id, v_payment_type_id, p_transaction_type);
   end get_pt_accounts;


  function closed_period( p_business_id   in  rnt_business_units.business_id%type
                        , p_date          in date)
    return varchar2 is

    cursor cur_periods(p_business_id   in  rnt_business_units.business_id%type) is
    select start_date
    ,      upper(closed_yn) closed_yn
    from rnt_account_periods
    where business_id = p_business_id
    order by start_date;

    v_return     varchar2(1) := 'N';

  begin
    for c_rec in cur_periods(p_business_id) loop
      if c_rec.start_date <= p_date then
         v_return := c_rec.closed_yn;
      end if;
    end loop;
    return v_return;
  end closed_period;


  procedure record_depreciation( p_ap_id            in rnt_accounts_payable.ap_id%type
                               , p_effective_date   in date
                               , p_term             in number   := null
                               , p_description      in varchar2 := null) is

    v_depreciation      debit_credit_t; 
    v_dep_date          date;
    v_counter           pls_integer;
    v_amount            rnt_accounts_payable.amount%type;
    v_property_id       rnt_properties.property_id%type;
    v_business_id       rnt_business_units.business_id%type;
    v_term              rnt_payment_types.depreciation_term%type;
    v_payment_type_id   rnt_payment_types.payment_type_id%type;
    v_dep_amount        rnt_payments.amount%type;
    v_payment_id        rnt_payments.payment_id%type;
    v_alloc_id          rnt_payment_allocations.pay_alloc_id%type;
    v_ledger_id         rnt_ledger_entries.ledger_id%type;
    v_description       rnt_ledger_entries.description%type;
    v_property          rnt_properties.address1%type;  
    v_end_date          date;
    v_effective_date    date;

  begin
    select ap.amount
    ,      ap.payment_property_id
    ,      ap.business_id
    ,      pt.depreciation_term
    ,      pt.payment_type_id
    ,      ap.payment_due_date 
    ,       p.address1
    into   v_amount
    ,      v_property_id
    ,      v_business_id
    ,      v_term
    ,      v_payment_type_id
    ,      v_end_date
    ,      v_property
    from rnt_accounts_payable ap
    ,    rnt_payment_types pt
    ,    rnt_properties p
    where ap_id = p_ap_id
    and p.property_id = ap.payment_property_id
    and ap.payment_type_id = pt.payment_type_id;

    select max(entry_date)
    into v_dep_date
    from rnt_ledger_entries
    where ap_id = p_ap_id;

    if p_term is not null then
       v_term := p_term;
    end if;

    v_end_date := add_months(v_end_date, (v_term * 12));
    if p_effective_date < v_end_date then
       v_effective_date := p_effective_date;
    else
       v_effective_date := v_end_date;
    end if;


    v_description := v_property||': '||v_term||' year depreciation '
                               ||p_description||' (ends '
                               ||to_char(v_end_date, 'mm/dd/yyyy')||')';


      

    --
    -- Record depreciation every month
    --
    v_counter      := trunc(months_between(v_effective_date, v_dep_date));
    v_dep_amount   := round(v_amount/(v_term * 12), 2);
    v_depreciation := get_pt_accounts( p_business_id      => v_business_id
                                     , p_payment_type_id  => v_payment_type_id
                                     , p_transaction_type => 'DEP');

    for d in 1 .. v_counter loop
      v_dep_date   := add_months(v_dep_date , 1);

      if closed_period( p_business_id => v_business_id 
                      , p_date        => v_dep_date)   = 'Y' then
           RAISE_APPLICATION_ERROR(-20902, 'Cannot insert depreciation entry on '||v_dep_date
                                            ||' the accounting period is closed.');    
      end if; 

      v_payment_id := rnt_payments_pkg.insert_row
                        ( x_payment_date     => v_dep_date
                        , x_description      => 'Depreciation for Accounts Payable item '||p_ap_id
                        , x_paid_or_received => 'PAID'
                        , x_amount           => v_dep_amount
                        , x_tenant_id        => null
                        , x_business_id      => v_business_id);


      v_alloc_id := rnt_payment_allocations_pkg.insert_row
                        ( x_payment_date  => v_dep_date
                        , x_amount        => v_dep_amount
                        , x_ar_id         => null
                        , x_ap_id         => null
                        , x_payment_id    => v_payment_id);

      v_ledger_id := rnt_ledger_entries_pkg.insert_row
                        ( x_entry_date      => v_dep_date
                        , x_description     => v_description
                        , x_debit_account   => v_depreciation.debit_account
                        , x_credit_account  => v_depreciation.credit_account
                        , x_ar_id           => null
                        , x_ap_id           => p_ap_id
                        , x_pay_alloc_id    => v_alloc_id
                        , x_payment_type_id => v_payment_type_id
                        , x_property_id     => v_property_id);


    end loop;
  end record_depreciation;

    procedure post_entry( p_entry_date     in date
	                    , p_amount         in number
						, p_debit_account  in number
						, p_credit_account in number
						, p_property_id    in number
						, p_business_id    in number
						, p_payment_type   in number
						, p_description    in varchar2) is

      v_payment_id number;
	  v_alloc_id   number;
	  v_ledger_id  number;
	  
	begin
	--dbms_output.put_line(p_entry_date||' '||p_description||' '||p_amount);
	select count(*)
	into v_payment_id
	from rnt_payments
	where payment_date = p_entry_date
	and description = p_description
	and business_id = p_business_id;
	if v_payment_id = 0 then
      v_payment_id := rnt_payments_pkg.insert_row
                        ( x_payment_date     => p_entry_date
                        , x_description      => p_description
                        , x_paid_or_received => 'PAID'
                        , x_amount           => p_amount
                        , x_tenant_id        => null
                        , x_business_id      => p_business_id);

      v_alloc_id := rnt_payment_allocations_pkg.insert_row
                        ( x_payment_date  => p_entry_date
                        , x_amount        => p_amount
                        , x_ar_id         => null
                        , x_ap_id         => null
                        , x_payment_id    => v_payment_id);
						
      v_ledger_id := rnt_ledger_entries_pkg.insert_row
                           ( x_entry_date      => p_entry_date
                           , x_description     => p_description
                           , x_debit_account   => p_debit_account
                           , x_credit_account  => p_credit_account
                           , x_ar_id           => null
                           , x_ap_id           => null
                           , x_pay_alloc_id    => v_alloc_id
                           , x_payment_type_id => p_payment_type 
                           , x_property_id     => p_property_id);  
    end if;

  end post_entry;
  
  procedure update_loans( p_business_id   in  rnt_business_units.business_id%type
                        , p_date          in date) is
  
    cursor cur_loans( p_business_id   in  rnt_business_units.business_id%type
                    , p_date          in date) is
    select l.LOAN_ID
	,      l.PROPERTY_ID
	,      l.POSITION
	,      l.LOAN_DATE
	,      l.LOAN_AMOUNT
	,      l.TERM
	,      l.INTEREST_RATE
	,      l.CREDIT_LINE_YN
	,      l.ARM_YN
	,      l.INTEREST_ONLY_YN
	,      l.BALLOON_DATE
	,      l.CLOSING_COSTS
	,      l.SETTLEMENT_DATE
	,      l.balance_date
	,      l.principal_balance
	,      p.address1
	,      rnt_loans_pkg.get_mortgage_payment( l.loan_amount
                                             , l.interest_rate
                                             , l.term
                                             , replace(l.interest_only_yn, 'N', 'A')) payment
   from   RNT_LOANS l
   ,      rnt_properties p
   where p.property_id = l.property_id
   and p.business_id = p_business_id
   and l.principal_balance > 0
   and l.balance_date < p_date;
   
   cursor cur_payments( p_loan_id   in rnt_loans.loan_id%type
                      , p_from_date in date
					  , p_to_date   in date) is
   select pa.payment_date
   ,      l.position
   ,      pa.amount
   ,      pe.description
   ,      pe.expense_id
   ,      pe.property_id
   ,      pt.payment_type_name payment_type
   ,      pt.payment_type_id
   ,      to_char(pe.event_date, 'YYYY') expense_year
   ,      ap.payment_due_date
   from rnt_payment_allocations pa
   ,    rnt_accounts_payable ap
   ,    rnt_property_expenses pe
   ,    rnt_payment_types pt
   ,    rnt_loans l
   where pe.loan_id = p_loan_id
   and pe.expense_id = ap.expense_id
   and ap.ap_id = pa.ap_id
   and ap.payment_type_id = pt.payment_type_id
   and pt.payment_type_name like '%Mortgage%'
   and l.loan_id = pe.loan_id
   and pa.payment_date > p_from_date
   and pa.payment_date <= p_to_date
   order by pa.payment_date;
   
    v_from_date          date;
	v_to_date            date;
    v_amount             number(12,2);
	v_new_amount         number(12,2);
    v_interest           number(12,2);
    v_interest_accounts  debit_credit_t;
    v_principal_accounts debit_credit_t;
    v_pandi_accounts     debit_credit_t;
  begin
  
    v_interest_accounts  := get_pt_accounts( p_business_id     => p_business_id
                                          , p_payment_type     => 'Mortgage Interest'
                                          , p_transaction_type => 'APS');
										  
    v_principal_accounts := get_pt_accounts( p_business_id     => p_business_id
                                          , p_payment_type     => 'Mortgage Payment Principal'
                                          , p_transaction_type => 'APS');
										  
    v_pandi_accounts     := get_pt_accounts( p_business_id     => p_business_id
                                          , p_payment_type     => 'Mortgage Payment P&I'
                                          , p_transaction_type => 'APS');

    for l_rec in cur_loans(p_business_id, p_date) loop
      v_from_date := l_rec.balance_date;
	  v_amount := l_rec.principal_balance;
--  dbms_output.put_line(l_rec.address1||' ('||l_rec.loan_amount||') '||l_rec.payment);
	  v_to_date := add_months(v_from_date, 1);
	  while v_from_date <= p_date loop
        v_interest := v_amount * l_rec.interest_rate / 1200;
	    v_amount := v_amount + v_interest;
--	dbms_output.put_line(v_from_date||' interest = '||v_interest||' balance = '||v_amount);
		for p_rec in cur_payments( p_loan_id   => l_rec.loan_id
                                 , p_from_date => v_from_date
					             , p_to_date   => v_to_date) loop
		  v_amount := v_amount - p_rec.amount;
--    dbms_output.put_line(v_from_date||' interest = '||v_interest||' balance = '||v_amount||' payment='||p_rec.amount);
	      update rnt_loans
	      set balance_date = p_rec.payment_date
	      ,   principal_balance = v_amount
	      where loan_id = l_rec.loan_id;
		  
		  if p_rec.payment_type = 'Mortgage Payment P&I' then -- we need to distribute funds from escrow
		    if p_rec.amount <= v_interest then
			  post_entry( p_entry_date     => p_rec.payment_date
	                    , p_amount         => p_rec.amount
						, p_debit_account  => v_interest_accounts.debit_account
						, p_credit_account => v_pandi_accounts.debit_account
						, p_property_id    => p_rec.property_id
						, p_business_id    => p_business_id
						, p_payment_type   => p_rec.payment_type_id
						, p_description    => 'Interest from '||p_rec.amount||' Payment for loan id: '||l_rec.loan_id||'-'||p_rec.expense_id
						                      ||' ('||l_rec.address1||', '||p_rec.description||' due '||p_rec.payment_due_date);
			  v_interest := v_interest - p_rec.amount;
			else
			  post_entry( p_entry_date     => p_rec.payment_date
	                    , p_amount         => v_interest
						, p_debit_account  => v_interest_accounts.debit_account
						, p_credit_account => v_pandi_accounts.debit_account
						, p_property_id    => p_rec.property_id
						, p_business_id    => p_business_id
						, p_payment_type   => p_rec.payment_type_id
						, p_description    => 'Interest from '||p_rec.amount||' Payment for loan id: '||l_rec.loan_id||'-'||p_rec.expense_id
						                      ||' ('||l_rec.address1||', '||p_rec.description||') due '||p_rec.payment_due_date);

			  post_entry( p_entry_date     => p_rec.payment_date
	                    , p_amount         => p_rec.amount - v_interest
						, p_debit_account  => v_principal_accounts.debit_account
						, p_credit_account => v_pandi_accounts.debit_account
						, p_property_id    => p_rec.property_id
						, p_business_id    => p_business_id
						, p_payment_type   => p_rec.payment_type_id
						, p_description    => 'Principal from '||p_rec.amount||' Payment for loan id: '||l_rec.loan_id||'-'||p_rec.expense_id
						                      ||' ('||l_rec.address1||', '||p_rec.description||') due '||p_rec.payment_due_date);
              v_interest := 0;
			end if;
		  else -- the payment type is principal or interest only
		    v_interest := v_interest - p_rec.amount;
		  end if;

		end loop;  
	    if (v_amount < 0) or (v_from_date < l_rec.settlement_date) then
	      v_from_date := sysdate;
        else
		  v_from_date := v_to_date;
		  v_to_date := add_months(v_from_date, 1);
	    end if;
	end loop;
	update rnt_loans 
	set balance_date = p_date
    where loan_id = l_rec.loan_id;
  end loop;
  end update_loans;
  
  
  procedure generate_contra_entries( p_business_id   in  rnt_business_units.business_id%type
                                   , p_date          in date) is

    cursor cur_properties(p_business_id in rnt_business_units.business_id%type) is
      select property_id
      ,      address1
      ,      depreciation_term
      ,      date_purchased
      ,      purchase_price
      ,      land_value
      ,      purchase_price - land_value building_price
      from rnt_properties 
      where business_id = p_business_id
      and status = 'PURCHASED'
      and date_sold is null
      order by property_id;

    cursor cur_purchase(p_property_id in rnt_properties.property_id%type) is
      select ap_id, payment_due_date, amount
      from rnt_accounts_payable ap
      ,    rnt_payment_types pt
      where ap.payment_property_id = p_property_id
      and ap.payment_type_id = pt.payment_type_id
      and pt.payment_type_name = 'Building Purchase'
      order by ap_id;

    cursor cur_depreciation_items( p_business_id in rnt_business_units.business_id%type) is
      select ap_id
      ,      pe.description
      from rnt_accounts_payable ap
      ,    rnt_payment_types pt
      ,    rnt_property_expenses pe
      where pt.payment_type_id = ap.payment_type_id
      and pt.depreciation_term > 0
      and ap.expense_id (+)    = pe.expense_id
      and ap.business_id       = p_business_id
      order by ap_id;



    v_ap_id                        rnt_accounts_payable.ap_id%type;
    v_id                           number;
    v_ledger_id                    number;
    v_payment_type                 rnt_payment_types.payment_type_id%type;
    v_txn_accounts                 debit_credit_t;

  begin
    update_loans( p_business_id => p_business_id
                , p_date        => p_date);

  --
  -- Generate property depreciation entries.  
  -- 
    for p_rec in cur_properties(p_business_id) loop
      --
      -- Find the 'Building Purchase' rows in AP that correspond to the property.  Create the rows if
      -- they do not exist.
      --
        v_ap_id := null;
        for b_rec in cur_purchase(p_rec.property_id) loop
           v_ap_id := b_rec.ap_id;
        end loop;

        if v_ap_id is null then

           --
           -- Check the accounting period is open
           --
           if closed_period( p_business_id => p_business_id
                           , p_date        => p_rec.date_purchased) = 'Y'  then
              RAISE_APPLICATION_ERROR(-20902, 'Cannot insert ledger rows for purchase of property in '
                                            ||'a closed accounting period');      
           end if;

           --
           -- Record purchase of land associated with property
           --
           v_payment_type := get_payment_type_id('Land Purchase');
           v_ap_id := rnt_accounts_payable_pkg.insert_row
                            ( x_payment_due_date     => p_rec.date_purchased
                            , x_amount               => p_rec.land_value
                            , x_payment_type_id      => v_payment_type
                            , x_expense_id           => null
                            , x_loan_id              => null
                            , x_supplier_id          => null
                            , x_payment_property_id  => p_rec.property_id
                            , x_business_id          => p_business_id
                            , x_record_type          => rnt_accounts_payable_const_pkg.CONST_OTHER_TYPE
                            , x_invoice_number       => null);

          v_id := rnt_payment_allocations_pkg.insert_row
                           ( x_payment_date => p_rec.date_purchased
                           , x_amount       => p_rec.land_value
                           , x_ar_id        => null
                           , x_ap_id        => v_ap_id
                           , x_payment_id   => null);

          --
          -- Record ledger entries for land purchase
          --
          v_txn_accounts := get_pt_accounts( p_business_id      => p_business_id
                                           , p_payment_type_id  => v_payment_type
                                           , p_transaction_type => 'APS');

          v_ledger_id := rnt_ledger_entries_pkg.insert_row
                           ( x_entry_date      => p_rec.date_purchased
                           , x_description     => 'Scheduled payment for land purchase of '||p_rec.address1
                           , x_debit_account   => v_txn_accounts.debit_account
                           , x_credit_account  => v_txn_accounts.credit_account
                           , x_ar_id           => null
                           , x_ap_id           => v_ap_id
                           , x_pay_alloc_id    => null
                           , x_payment_type_id => v_payment_type 
                           , x_property_id     => p_rec.property_id);

          v_txn_accounts := get_pt_accounts( p_business_id      => p_business_id
                                           , p_payment_type_id  => v_payment_type
                                           , p_transaction_type => 'APP');

          v_ledger_id := rnt_ledger_entries_pkg.insert_row
                           ( x_entry_date      => p_rec.date_purchased
                           , x_description     => 'Payment for Land purchase of '||p_rec.address1
                           , x_debit_account   => v_txn_accounts.debit_account
                           , x_credit_account  => v_txn_accounts.credit_account
                           , x_ar_id           => null
                           , x_ap_id           => null
                           , x_pay_alloc_id    => v_id
                           , x_payment_type_id => v_payment_type 
                           , x_property_id     => p_rec.property_id);

          --
          -- Record purchase of building associated with property
          --
          v_payment_type := get_payment_type_id('Building Purchase');
                           
          v_ap_id := rnt_accounts_payable_pkg.insert_row
                            ( x_payment_due_date     => p_rec.date_purchased
                            , x_amount               => p_rec.building_price
                            , x_payment_type_id      => get_payment_type_id('Building Purchase')
                            , x_expense_id           => null
                            , x_loan_id              => null
                            , x_supplier_id          => null
                            , x_payment_property_id  => p_rec.property_id
                            , x_business_id          => p_business_id
                            , x_record_type          => rnt_accounts_payable_const_pkg.CONST_OTHER_TYPE
                            , x_invoice_number       => null);
     
          v_id := rnt_payment_allocations_pkg.insert_row
                           ( x_payment_date => p_rec.date_purchased
                           , x_amount       => p_rec.building_price
                           , x_ar_id        => null
                           , x_ap_id        => v_ap_id
                           , x_payment_id   => null);

          --
          -- Record ledger entries for building purchase
          --
          v_txn_accounts := get_pt_accounts( p_business_id      => p_business_id
                                           , p_payment_type_id  => v_payment_type
                                           , p_transaction_type => 'APS');

          v_ledger_id := rnt_ledger_entries_pkg.insert_row
                           ( x_entry_date      => p_rec.date_purchased
                           , x_description     => 'Scheduled payment for building purchase of '||p_rec.address1
                           , x_debit_account   => v_txn_accounts.debit_account
                           , x_credit_account  => v_txn_accounts.credit_account
                           , x_ar_id           => null
                           , x_ap_id           => v_ap_id
                           , x_pay_alloc_id    => null
                           , x_payment_type_id => v_payment_type 
                           , x_property_id     => p_rec.property_id);

          v_txn_accounts := get_pt_accounts( p_business_id      => p_business_id
                                         , p_payment_type_id  => v_payment_type
                                         , p_transaction_type => 'APP');

          v_ledger_id := rnt_ledger_entries_pkg.insert_row
                           ( x_entry_date      => p_rec.date_purchased
                           , x_description     => 'Payment for building purchase of '||p_rec.address1
                           , x_debit_account   => v_txn_accounts.debit_account
                           , x_credit_account  => v_txn_accounts.credit_account
                           , x_ar_id           => null
                           , x_ap_id           => null
                           , x_pay_alloc_id    => v_id
                           , x_payment_type_id => v_payment_type 
                           , x_property_id     => p_rec.property_id);

        end if;

        record_depreciation( p_ap_id          => v_ap_id
                           , p_effective_date => p_date
                           , p_term           => p_rec.depreciation_term);

    end loop;



  --
  -- Generate entries for payment types with a depreciation term > 0.  
  -- 
    for c_rec in cur_depreciation_items(p_business_id) loop

        record_depreciation( p_ap_id          => c_rec.ap_id
                           , p_effective_date => p_date
                           , p_term           => null
                           , p_description    => c_rec.description);
    end loop;


  end generate_contra_entries;



  function get_account_balance( p_account_id   in  rnt_accounts.account_id%type
                              , p_date         in date
							  , p_property_id  in rnt_properties.property_id%type := null) return number is

    v_account_type        rnt_accounts.account_type%type;
    v_debit_value         number;
    v_credit_value        number;

  begin

   select account_type
   into v_account_type
   from rnt_accounts
   where account_id = p_account_id;

   if p_property_id is null then
     select nvl(sum(amount), 0)
     into v_debit_value
     from rnt_ledger_transactions_v
     where account_id = p_account_id
     and entry_date < p_date
     and transaction_type = 'DEBIT';

     select nvl(sum(amount), 0)
     into v_credit_value
     from rnt_ledger_transactions_v
     where account_id = p_account_id
     and entry_date < p_date
     and transaction_type = 'CREDIT';
   else
     select nvl(sum(amount), 0)
     into v_debit_value
     from rnt_ledger_transactions_v
     where account_id = p_account_id
     and entry_date < p_date
     and transaction_type = 'DEBIT'
	 and property_id = p_property_id;

     select nvl(sum(amount), 0)
     into v_credit_value
     from rnt_ledger_transactions_v
     where account_id = p_account_id
     and entry_date < p_date
     and transaction_type = 'CREDIT'
	 and property_id = p_property_id;
   end if;

   if v_account_type in ('ASSET', 'COST', 'EXPENSE') then
     return v_debit_value - v_credit_value;
   else
     return v_credit_value - v_debit_value;
   end if;

  end get_account_balance;

end rnt_ledger_pkg;
/

show errors package rnt_ledger_pkg
show errors package body rnt_ledger_pkg
