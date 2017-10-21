update RNT_ACCOUNTS_RECEIVABLE ar_
 set PAYMENT_PROPERTY_ID = (select u.PROPERTY_ID
                            from RNT_TENANCY_AGREEMENT a,
                                 RNT_PROPERTY_UNITS u,
                                 RNT_ACCOUNTS_RECEIVABLE ar 
                            where ar.AGREEMENT_ID = a.AGREEMENT_ID
                              and a.UNIT_ID = u.UNIT_ID
                              and ar.AR_ID = ar_.AR_ID)
 where ar_.PAYMENT_PROPERTY_ID is null
/