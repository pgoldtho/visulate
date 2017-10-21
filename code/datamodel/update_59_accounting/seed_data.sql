declare

 procedure ins_ac_type
    ( p_type    in rnt_account_types.account_type%type
    , p_display in rnt_account_types.display_title%type) is
 begin
   insert into rnt_account_types
    ( account_type, display_title)
   values
    ( p_type, p_display);
 end ins_ac_type;

 procedure ins_default_ac
   ( p_number  in rnt_default_accounts.account_number%type
   , p_name    in rnt_default_accounts.name%type
   , p_type    in rnt_default_accounts.account_type%type
   , p_balance in rnt_default_accounts.current_balance_yn%type) is
 begin
   insert into rnt_default_accounts
     (account_number, name, account_type, current_balance_yn)
   values
     (p_number, p_name, p_type, p_balance);
 end ins_default_ac;


begin

 update rnt_payment_types 
 set receivable_yn = 'N' 
 where payment_type_id = 15;

 update rnt_payment_types 
 set payment_type_name = 'Carpet' 
 where payment_type_name = 'Carpet and Flooring';



 ins_ac_type('ASSET', 'Asset');
 ins_ac_type('LIABILITY', 'Liability');
 ins_ac_type('EQUITY', 'Owner''s Equity');
 ins_ac_type('REVENUE', 'Revenue');
 ins_ac_type('COST', 'Cost of Goods Sold');
 ins_ac_type('EXPENSE', 'Expense');


 ins_default_ac( p_number  => 1100
               , p_name    => 'Cash'
               , p_type    => 'ASSET'
               , p_balance => 'Y');

 ins_default_ac( p_number  => 1110
               , p_name    => 'Escrow - Tax and Insurance'
               , p_type    => 'ASSET'
               , p_balance => 'N');

 ins_default_ac( p_number  => 1150
               , p_name    => 'Escrow - Mortgage P&I'
               , p_type    => 'ASSET'
               , p_balance => 'N');

 ins_default_ac( p_number  => 1160
               , p_name    => 'Mortgage Principal Payment'
               , p_type    => 'ASSET'
               , p_balance => 'N');

 ins_default_ac( p_number  => 1200
               , p_name    => 'Accounts Receivable'
               , p_type    => 'ASSET'
               , p_balance => 'Y');

 ins_default_ac( p_number  => 1300
               , p_name    => 'Capital Improvements'
               , p_type    => 'ASSET'
               , p_balance => 'N');

 ins_default_ac( p_number  => 1400
               , p_name    => 'Reserve Fund'
               , p_type    => 'ASSET'
               , p_balance => 'N');

 ins_default_ac( p_number  => 1500
               , p_name    => 'Supplies'
               , p_type    => 'ASSET'
               , p_balance => 'Y');

 ins_default_ac( p_number  => 1700
               , p_name    => 'Land'
               , p_type    => 'ASSET'
               , p_balance => 'N');

 ins_default_ac( p_number  => 1750
               , p_name    => 'Buildings'
               , p_type    => 'ASSET'
               , p_balance => 'N');

 ins_default_ac( p_number  => 1780
               , p_name    => 'Accumulated Depreciation Buildings'
               , p_type    => 'ASSET'
               , p_balance => 'N');

 ins_default_ac( p_number  => 1800
               , p_name    => 'Equipment'
               , p_type    => 'ASSET'
               , p_balance => 'N');

 ins_default_ac( p_number  => 1880
               , p_name    => 'Accumulated Depreciation Equipment'
               , p_type    => 'ASSET'
               , p_balance => 'N');

ins_default_ac( p_number  => 1900
               , p_name    => 'Notes Receivable'
               , p_type    => 'ASSET'
               , p_balance => 'N');




 ins_default_ac( p_number  => 2100
               , p_name    => 'Notes Payable'
               , p_type    => 'LIABILITY'
               , p_balance => 'N');

 ins_default_ac( p_number  => 2200
               , p_name    => 'Accounts Payable'
               , p_type    => 'LIABILITY'
               , p_balance => 'Y');


 ins_default_ac( p_number  => 2300
               , p_name    => 'Tenant Deposits'
               , p_type    => 'LIABILITY'
               , p_balance => 'N');





 ins_default_ac( p_number  => 3000
               , p_name    => 'Business Owner, Capital'
               , p_type    => 'EQUITY'
               , p_balance => 'N');


 ins_default_ac( p_number  => 3500
               , p_name    => 'Business Owner, Drawing'
               , p_type    => 'EQUITY'
               , p_balance => 'N');






 ins_default_ac( p_number  => 4000
               , p_name    => 'Rental Income'
               , p_type    => 'REVENUE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 4010
               , p_name    => 'Late Fees'
               , p_type    => 'REVENUE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 4020
               , p_name    => 'Other Income'
               , p_type    => 'REVENUE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 4100
               , p_name    => 'Interest Revenue'
               , p_type    => 'REVENUE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 4300
               , p_name    => 'Mortgage Income'
               , p_type    => 'REVENUE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 4310
               , p_name    => 'Escrow - Mortgage Income P&I'
               , p_type    => 'REVENUE'
               , p_balance => 'N');


 ins_default_ac( p_number  => 5000
               , p_name    => 'Advertising Expense'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 5100
               , p_name    => 'Auto and Travel Expense'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 5200
               , p_name    => 'Cleaning/Janitorial'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 5300
               , p_name    => 'Commissions'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 5400
               , p_name    => 'Insurance'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 5500
               , p_name    => 'Interest Expense'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');


 ins_default_ac( p_number  => 5600
               , p_name    => 'Lawn Maintenance'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 5610
               , p_name    => 'Landscaping Expense'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 5700
               , p_name    => 'Management Fees'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 5800
               , p_name    => 'Pest Control'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 5900
               , p_name    => 'Professional Fees'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 6000
               , p_name    => 'Property Taxes'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 6010
               , p_name    => 'Other Taxes'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');


 ins_default_ac( p_number  => 6100
               , p_name    => 'Repairs & Maintenance'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 6200
               , p_name    => 'Weather Events'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 6210
               , p_name    => 'Snow Removeal'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 6220
               , p_name    => 'Storm & Hurricane Cleanup'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 6300
               , p_name    => 'Inventory Expense'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 6400
               , p_name    => 'Utilities'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 6410
               , p_name    => 'Utilities:Electric'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');


 ins_default_ac( p_number  => 6420
               , p_name    => 'Utilities:Gas'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 6430
               , p_name    => 'Utilities:Irrigation'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 6440
               , p_name    => 'Utilities:Telephone & Internet'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 6450
               , p_name    => 'Utilities:Water/Sewer/Trash'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 6500
               , p_name    => 'Office and General Business Expense'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');


 ins_default_ac( p_number  => 6610
               , p_name    => 'Mortgage Interest Expense'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 ins_default_ac( p_number  => 6700
               , p_name    => 'Bad Debt Expense'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');



 ins_default_ac( p_number  => 6910
               , p_name    => 'Depreciation Expense'
               , p_type    => 'EXPENSE'
               , p_balance => 'N');

 update rnt_properties
 set depreciation_term = 27.5
 where depreciation_term = 27;


end;
/
