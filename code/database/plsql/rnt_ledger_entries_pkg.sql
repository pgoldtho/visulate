create or replace package RNT_LEDGER_ENTRIES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_LEDGER_ENTRIES_PKG
    Purpose:   API's for RNT_LEDGER_ENTRIES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        26-MAR-09   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_LEDGER_ID IN RNT_LEDGER_ENTRIES.LEDGER_ID%TYPE)
            return RNT_LEDGER_ENTRIES_V.CHECKSUM%TYPE;

  procedure update_row( X_LEDGER_ID       IN RNT_LEDGER_ENTRIES.LEDGER_ID%TYPE
                      , X_ENTRY_DATE      IN RNT_LEDGER_ENTRIES.ENTRY_DATE%TYPE
                      , X_DESCRIPTION     IN RNT_LEDGER_ENTRIES.DESCRIPTION%TYPE
                      , X_DEBIT_ACCOUNT   IN RNT_LEDGER_ENTRIES.DEBIT_ACCOUNT%TYPE
                      , X_CREDIT_ACCOUNT  IN RNT_LEDGER_ENTRIES.CREDIT_ACCOUNT%TYPE
                      , X_PAYMENT_TYPE_ID IN RNT_LEDGER_ENTRIES.PAYMENT_TYPE_ID%TYPE
                      , X_AR_ID           IN RNT_LEDGER_ENTRIES.AR_ID%TYPE
                      , X_AP_ID           IN RNT_LEDGER_ENTRIES.AP_ID%TYPE
                      , X_PAY_ALLOC_ID    IN RNT_LEDGER_ENTRIES.PAY_ALLOC_ID%TYPE
                      , X_CHECKSUM        IN RNT_LEDGER_ENTRIES_V.CHECKSUM%TYPE);

  function insert_row( X_ENTRY_DATE      IN RNT_LEDGER_ENTRIES.ENTRY_DATE%TYPE
                     , X_DESCRIPTION     IN RNT_LEDGER_ENTRIES.DESCRIPTION%TYPE
                     , X_DEBIT_ACCOUNT   IN RNT_LEDGER_ENTRIES.DEBIT_ACCOUNT%TYPE
                     , X_CREDIT_ACCOUNT  IN RNT_LEDGER_ENTRIES.CREDIT_ACCOUNT%TYPE
                     , X_PAYMENT_TYPE_ID IN RNT_LEDGER_ENTRIES.PAYMENT_TYPE_ID%TYPE
                     , X_AR_ID           IN RNT_LEDGER_ENTRIES.AR_ID%TYPE
                     , X_AP_ID           IN RNT_LEDGER_ENTRIES.AP_ID%TYPE
                     , X_PAY_ALLOC_ID    IN RNT_LEDGER_ENTRIES.PAY_ALLOC_ID%TYPE)
              return RNT_LEDGER_ENTRIES.LEDGER_ID%TYPE;

  procedure delete_row( X_LEDGER_ID IN RNT_LEDGER_ENTRIES.LEDGER_ID%TYPE);

end RNT_LEDGER_ENTRIES_PKG;
/    

create or replace package body RNT_LEDGER_ENTRIES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_LEDGER_ENTRIES_PKG
    Purpose:   API's for RNT_LEDGER_ENTRIES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        26-MAR-09   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_LEDGER_ID IN RNT_LEDGER_ENTRIES.LEDGER_ID%TYPE) is
     cursor c is
     select * from RNT_LEDGER_ENTRIES
     where LEDGER_ID = X_LEDGER_ID
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
  function get_checksum( X_LEDGER_ID IN RNT_LEDGER_ENTRIES.LEDGER_ID%TYPE)
            return RNT_LEDGER_ENTRIES_V.CHECKSUM%TYPE is 

    v_return_value               RNT_LEDGER_ENTRIES_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_LEDGER_ENTRIES_V
    where LEDGER_ID = X_LEDGER_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_LEDGER_ID       IN RNT_LEDGER_ENTRIES.LEDGER_ID%TYPE
                      , X_ENTRY_DATE      IN RNT_LEDGER_ENTRIES.ENTRY_DATE%TYPE
                      , X_DESCRIPTION     IN RNT_LEDGER_ENTRIES.DESCRIPTION%TYPE
                      , X_DEBIT_ACCOUNT   IN RNT_LEDGER_ENTRIES.DEBIT_ACCOUNT%TYPE
                      , X_CREDIT_ACCOUNT  IN RNT_LEDGER_ENTRIES.CREDIT_ACCOUNT%TYPE
                      , X_PAYMENT_TYPE_ID IN RNT_LEDGER_ENTRIES.PAYMENT_TYPE_ID%TYPE
                      , X_AR_ID           IN RNT_LEDGER_ENTRIES.AR_ID%TYPE
                      , X_AP_ID           IN RNT_LEDGER_ENTRIES.AP_ID%TYPE
                      , X_PAY_ALLOC_ID    IN RNT_LEDGER_ENTRIES.PAY_ALLOC_ID%TYPE
                      , X_CHECKSUM        IN RNT_LEDGER_ENTRIES_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_LEDGER_ENTRIES_V.CHECKSUM%TYPE;
  begin
     lock_row(X_LEDGER_ID);

      -- validate checksum
      l_checksum := get_checksum(X_LEDGER_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;
     
     update RNT_LEDGER_ENTRIES
     set ENTRY_DATE    = X_ENTRY_DATE
     , DESCRIPTION     = X_DESCRIPTION
     , DEBIT_ACCOUNT   = X_DEBIT_ACCOUNT
     , CREDIT_ACCOUNT  = X_CREDIT_ACCOUNT
     , PAYMENT_TYPE_ID = X_PAYMENT_TYPE_ID
     , AR_ID           = X_AR_ID
     , AP_ID           = X_AP_ID
     , PAY_ALLOC_ID    = X_PAY_ALLOC_ID
     where LEDGER_ID = X_LEDGER_ID;

  end update_row;

  function insert_row( X_ENTRY_DATE      IN RNT_LEDGER_ENTRIES.ENTRY_DATE%TYPE
                     , X_DESCRIPTION     IN RNT_LEDGER_ENTRIES.DESCRIPTION%TYPE
                     , X_DEBIT_ACCOUNT   IN RNT_LEDGER_ENTRIES.DEBIT_ACCOUNT%TYPE
                     , X_CREDIT_ACCOUNT  IN RNT_LEDGER_ENTRIES.CREDIT_ACCOUNT%TYPE
                     , X_PAYMENT_TYPE_ID IN RNT_LEDGER_ENTRIES.PAYMENT_TYPE_ID%TYPE
                     , X_AR_ID           IN RNT_LEDGER_ENTRIES.AR_ID%TYPE
                     , X_AP_ID           IN RNT_LEDGER_ENTRIES.AP_ID%TYPE
                     , X_PAY_ALLOC_ID    IN RNT_LEDGER_ENTRIES.PAY_ALLOC_ID%TYPE)
              return RNT_LEDGER_ENTRIES.LEDGER_ID%TYPE
  is
     x          number;
  begin

     insert into RNT_LEDGER_ENTRIES
     ( LEDGER_ID
     , ENTRY_DATE
     , DESCRIPTION
     , DEBIT_ACCOUNT
     , CREDIT_ACCOUNT
     , PAYMENT_TYPE_ID
     , AR_ID
     , AP_ID
     , PAY_ALLOC_ID)
     values
     ( RNT_LEDGER_ENTRIES_SEQ.NEXTVAL
     , X_ENTRY_DATE
     , X_DESCRIPTION
     , X_DEBIT_ACCOUNT
     , X_CREDIT_ACCOUNT
     , X_PAYMENT_TYPE_ID
     , X_AR_ID
     , X_AP_ID
     , X_PAY_ALLOC_ID)
     returning LEDGER_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_LEDGER_ID IN RNT_LEDGER_ENTRIES.LEDGER_ID%TYPE) is

  begin
    delete from RNT_LEDGER_ENTRIES
    where LEDGER_ID = X_LEDGER_ID;

  end delete_row;

end RNT_LEDGER_ENTRIES_PKG;
/
                                                                                                                                                                                        
show errors package RNT_LEDGER_ENTRIES_PKG
show errors package body RNT_LEDGER_ENTRIES_PKG                                                      