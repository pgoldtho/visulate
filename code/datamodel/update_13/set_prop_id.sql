update RNT_ACCOUNTS_PAYABLE app 
set PAYMENT_PROPERTY_ID = (select pe.PROPERTY_ID
                           from RNT_ACCOUNTS_PAYABLE ap,
                                RNT_PROPERTY_EXPENSES pe
                           where ap.EXPENSE_ID = pe.EXPENSE_ID
                             and app.AP_ID = ap.AP_ID)
where PAYMENT_PROPERTY_ID is null                                  
/

commit
/