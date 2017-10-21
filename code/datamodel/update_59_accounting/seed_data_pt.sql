set define '^'
declare

  v_pt   rnt_payment_types.payment_type_id%type;

 procedure ins_default_rules
   ( p_ptype    in rnt_payment_types.payment_type_id%type
   , p_txn_type in rnt_default_pt_rules.transaction_type%type
   , p_debit    in rnt_default_pt_rules.debit_account%type
   , p_credit   in rnt_default_pt_rules.credit_account%type) is
 begin
   insert into rnt_default_pt_rules
     (payment_type_id, transaction_type, debit_account, credit_account)
   values
     (p_ptype, p_txn_type, p_debit, p_credit);
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
   FROM RNTMGR.RNT_PAYMENT_TYPES
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



begin
  v_pt := getset_pt('Advertising', 0, 'Schedule E expense type', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 5000 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  v_pt := getset_pt('Auto and Travel', 0, 'Schedule E expense type', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 5100 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  v_pt := getset_pt('Building Purchase', 0, 'All Improvements', 'Y', 'N', 27.5, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1750 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'DEP'
                   , p_debit    => 6910 
                   , p_credit   => 1780 );

  v_pt := getset_pt('Capital Improvements', 0, 'All Improvements', 'Y', 'N', 7, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1300 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'DEP'
                   , p_debit    => 6910 
                   , p_credit   => 1780 );

  v_pt := getset_pt('Capital Improvements - 3 Year', 3, 'Improvements depreciated over 3 years', 'Y', 'N', 3, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1300 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'DEP'
                   , p_debit    => 6910 
                   , p_credit   => 1780 );

  v_pt := getset_pt('Capital Improvements - 5 Year', 5, 'Improvements depreciated over 5 years', 'Y', 'N', 5, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1300 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'DEP'
                   , p_debit    => 6910 
                   , p_credit   => 1780 );

  v_pt := getset_pt('Capital Improvements - 7 Year', 7, 'Improvements depreciated over 7 years', 'Y', 'N', 7, 'Y');
  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1300 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'DEP'
                   , p_debit    => 6910 
                   , p_credit   => 1780 );

  v_pt := getset_pt('Capital Improvements - 10 Year', 10, 'Improvements depreciated over 10 years', 'Y', 'N', 10, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1300 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'DEP'
                   , p_debit    => 6910 
                   , p_credit   => 1780 );

  v_pt := getset_pt('Capital Improvements - 12 Year', 12, 'Improvements depreciated over 12 years', 'Y', 'N', 12, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1300 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'DEP'
                   , p_debit    => 6910 
                   , p_credit   => 1780 );

  v_pt := getset_pt('Capital Improvements - 15 Year', 15, 'Improvements depreciated over 15 years', 'Y', 'N', 15, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1300 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'DEP'
                   , p_debit    => 6910 
                   , p_credit   => 1780 );

  v_pt := getset_pt('Capital Improvements - 20 Year', 20, 'Improvements depreciated over 20 years', 'Y', 'N', 20, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1300 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'DEP'
                   , p_debit    => 6910 
                   , p_credit   => 1780 );

  v_pt := getset_pt('Capital Improvements - 25 Year', 25, 'Improvements depreciated over 25 years', 'Y', 'N', 25, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1300 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'DEP'
                   , p_debit    => 6910 
                   , p_credit   => 1780 );

  v_pt := getset_pt('Carpet', 5, 'Schedule E expense type', 'Y', 'N', 5, 'Y');

  update rnt_payment_types
  set payment_type_name = 'Carpet Install/Replacement'
  where payment_type_id = v_pt;

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1300 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'DEP'
                   , p_debit    => 6910 
                   , p_credit   => 1780 );

  v_pt := getset_pt('Cleaning and maintenance', 0, '', 'Y', 'N', 0, 'Y');

  update rnt_payment_types
  set payment_type_name = 'Cleaning/Janitorial Expense'
  where payment_type_id = v_pt;

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 5200 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  v_pt := getset_pt('Commissions', 0, 'Schedule E expense type', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 5300 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  v_pt := getset_pt('Equipment Purchase', 0, 'Schedule E expense type', 'Y', 'N', 5, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1800 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'DEP'
                   , p_debit    => 6910 
                   , p_credit   => 1880 );

  v_pt := getset_pt('Equipment - 3 Year', 3, 'Equipment depreciated over 3 years', 'Y', 'N', 3, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1800 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'DEP'
                   , p_debit    => 6910 
                   , p_credit   => 1880 );

  v_pt := getset_pt('Equipment - 5 Year', 5, 'Equipment depreciated over 5 years', 'Y', 'N', 5, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1800 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'DEP'
                   , p_debit    => 6910 
                   , p_credit   => 1880 );

  v_pt := getset_pt('Equipment - 7 Year', 7, 'Equipment depreciated over 7 years', 'Y', 'N', 7, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1800 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'DEP'
                   , p_debit    => 6910 
                   , p_credit   => 1880 );

  v_pt := getset_pt('Equipment - 10 Year', 10, 'Equipment depreciated over 10 years', 'Y', 'N', 10, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1800 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'DEP'
                   , p_debit    => 6910 
                   , p_credit   => 1880 );

  v_pt := getset_pt('Equipment - 12 Year', 12, 'Equipment depreciated over 12 years', 'Y', 'N', 12, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1800 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'DEP'
                   , p_debit    => 6910 
                   , p_credit   => 1880 );

  v_pt := getset_pt('Discounted Rent', 0, '', 'N', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARS'
                   , p_debit    => 1200 
                   , p_credit   => 4000 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARP'
                   , p_debit    => 1100 
                   , p_credit   => 1200 );

  v_pt := getset_pt('Household Appliances', 0, 'Schedule E expense type', 'Y', 'N', 5, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1800 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'DEP'
                   , p_debit    => 6910 
                   , p_credit   => 1880 );

  v_pt := getset_pt('Insurance', 0, '', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 5400 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  v_pt := getset_pt('Interest Expense', 0, '', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 5500 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  v_pt := getset_pt('Interest Income', 0, '', 'N', 'Y', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARS'
                   , p_debit    => 1200 
                   , p_credit   => 4100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARP'
                   , p_debit    => 1100 
                   , p_credit   => 1200 );

  v_pt := getset_pt('Inventory Purchase', 0, '', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 6300 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );


  v_pt := getset_pt('Land Purchase', 0, '', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1700 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  v_pt := getset_pt('Landscaping', 0, '', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 5610 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  v_pt := getset_pt('Late Fee', 0, '', 'N', 'Y', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARS'
                   , p_debit    => 1200 
                   , p_credit   => 4010 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARP'
                   , p_debit    => 1100 
                   , p_credit   => 1200 );

  v_pt := getset_pt('Lawn Service', 0, 'Schedule E expense type', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 5600 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  v_pt := getset_pt('Legal and other fees', 0, 'Schedule E expense type', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 5900 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

 v_pt := getset_pt('Loan Origination', 0, '', 'Y', 'Y', 0, 'N');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1100 
                   , p_credit   => 2100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2100 
                   , p_credit   => 1100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARS'
                   , p_debit    => 1900 
                   , p_credit   => 4300 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARP'
                   , p_debit    => 1100 
                   , p_credit   => 1900 );


  v_pt := getset_pt('Management fees', 0, 'Schedule E expense type', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 5700 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  v_pt := getset_pt('Mortgage Interest', 0, 'Schedule E expense type', 'Y', 'Y', 0, 'N');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 6610 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );


  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARS'
                   , p_debit    => 1200 
                   , p_credit   => 4100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARP'
                   , p_debit    => 1100 
                   , p_credit   => 1200 );


  v_pt := getset_pt('Mortgage Payment Principal', 0, 'Schedule E expense type', 'Y', 'Y', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1160 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );


  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARS'
                   , p_debit    => 1900 
                   , p_credit   => 4300 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARP'
                   , p_debit    => 1100 
                   , p_credit   => 1900 );

  v_pt := getset_pt('Mortgage Payment P&I', 0, '', 'Y', 'Y', 0, 'N');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1150 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );


  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARS'
                   , p_debit    => 1900 
                   , p_credit   => 4310 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARP'
                   , p_debit    => 1100 
                   , p_credit   => 1900 );


  v_pt := getset_pt('Other Income', 0, '', 'N', 'Y', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARS'
                   , p_debit    => 1200 
                   , p_credit   => 4020 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARP'
                   , p_debit    => 1100 
                   , p_credit   => 1200 );

  v_pt := getset_pt('Other Interest', 0, 'Schedule E expense type', 'Y', 'Y', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 5500 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );


  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARS'
                   , p_debit    => 1200 
                   , p_credit   => 4100 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARP'
                   , p_debit    => 1100 
                   , p_credit   => 1200 );

  v_pt := getset_pt('Pest Control', 0, 'Schedule E expense type', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 5800 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );
  

  v_pt := getset_pt('Phone Service', 0, 'Schedule E expense type', 'Y', 'N', 0, 'Y');

  update rnt_payment_types
  set payment_type_name = 'Utilities:Telephone & Internet'
  where payment_type_id = v_pt;

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 6440 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  v_pt := getset_pt('Property Tax', 0, '123123', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 6000
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  v_pt := getset_pt('Recoverable', 0, '', 'N', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARS'
                   , p_debit    => 1200 
                   , p_credit   => 4020 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARP'
                   , p_debit    => 1100 
                   , p_credit   => 1200 );


  v_pt := getset_pt('Remaining Rent', 0, '', 'N', 'N', 0, 'Y');


  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARS'
                   , p_debit    => 1200 
                   , p_credit   => 4000 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARP'
                   , p_debit    => 1100 
                   , p_credit   => 1200 );

  v_pt := getset_pt('Rent', 0, '', 'N', 'Y', 0, 'Y');

  update rnt_payment_types
  set payment_type_name = 'Rental Income'
  where payment_type_id = v_pt;

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARS'
                   , p_debit    => 1200 
                   , p_credit   => 4000 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARP'
                   , p_debit    => 1100 
                   , p_credit   => 1200 );

  v_pt := getset_pt('Repairs', 0, '', 'Y', 'N', 3, 'Y');

  update rnt_payment_types
  set payment_type_name = 'Repairs & Maintenance'
  where payment_type_id = v_pt;

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 6100 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  v_pt := getset_pt('Sales Tax', 0, 'Sales tax collected for goods or services sold', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 6010 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  v_pt := getset_pt('Section 8 Rent', 0, '', 'N', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARS'
                   , p_debit    => 1200 
                   , p_credit   => 4000 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'ARP'
                   , p_debit    => 1100 
                   , p_credit   => 1200 );



  v_pt := getset_pt('Supplies', 0, 'Schedule E expense type', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 1500 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  v_pt := getset_pt('Tangible Tax', 0, 'Schedule E expense type', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 6010 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  v_pt := getset_pt('Utilities', 0, '1111', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 6400 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  v_pt := getset_pt('Utilities:Electricity', 0, '1111', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 6410 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  v_pt := getset_pt('Utilities:Gas', 0, '1111', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 6420 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  v_pt := getset_pt('Utilities:Irrigation', 0, '1111', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 6430 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

  v_pt := getset_pt('Utilities:W/S/T', 0, 'Water/Sewer/Trash', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 6450 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );


  v_pt := getset_pt('Weather Event', 0, '1111', 'Y', 'N', 0, 'Y');

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APS'
                   , p_debit    => 6200 
                   , p_credit   => 2200 );

  ins_default_rules( p_ptype    => v_pt
                   , p_txn_type => 'APP'
                   , p_debit    => 2200 
                   , p_credit   => 1100 );

end;
/


