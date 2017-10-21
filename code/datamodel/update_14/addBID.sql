ALTER TABLE RNT_ACCOUNTS_PAYABLE ADD (BUSINESS_ID NUMBER NULL)
/

update RNT_ACCOUNTS_PAYABLE x
set BUSINESS_ID = (select p.BUSINESS_ID from RNT_ACCOUNTS_PAYABLE ap,
                                           RNT_PROPERTIES p
                                     where ap.PAYMENT_PROPERTY_ID = p.PROPERTY_ID
                                       and AP_ID = x.AP_ID)
/

ALTER TABLE RNT_ACCOUNTS_PAYABLE
MODIFY(PAYMENT_PROPERTY_ID  NULL)
/


ALTER TABLE RNT_ACCOUNTS_PAYABLE
MODIFY(BUSINESS_ID  NOT NULL)
/
                                       