create or replace package RNT_PROPERTY_EXPENSES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011       All rights reserved worldwide
    Name:      RNT_PROPERTY_EXPENSES_PKG
    Purpose:   API's for RNT_PROPERTY_EXPENSES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        03-OCT-11   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_EXPENSE_ID IN RNT_PROPERTY_EXPENSES.EXPENSE_ID%TYPE)
            return RNT_PROPERTY_EXPENSES_V.CHECKSUM%TYPE;

  procedure update_row( X_EXPENSE_ID IN RNT_PROPERTY_EXPENSES.EXPENSE_ID%TYPE
                      , X_PROPERTY_ID IN RNT_PROPERTY_EXPENSES.PROPERTY_ID%TYPE
                      , X_EVENT_DATE IN RNT_PROPERTY_EXPENSES.EVENT_DATE%TYPE
                      , X_DESCRIPTION IN RNT_PROPERTY_EXPENSES.DESCRIPTION%TYPE
                      , X_RECURRING_YN IN RNT_PROPERTY_EXPENSES.RECURRING_YN%TYPE
                      , X_RECURRING_PERIOD IN RNT_PROPERTY_EXPENSES.RECURRING_PERIOD%TYPE
                      , X_RECURRING_ENDDATE IN RNT_PROPERTY_EXPENSES.RECURRING_ENDDATE%TYPE
                      , X_UNIT_ID IN RNT_PROPERTY_EXPENSES.UNIT_ID%TYPE
                      , X_LOAN_ID IN RNT_PROPERTY_EXPENSES.LOAN_ID%TYPE
                      , X_CHECKSUM IN RNT_PROPERTY_EXPENSES_V.CHECKSUM%TYPE);

  function  insert_row( X_PROPERTY_ID IN RNT_PROPERTY_EXPENSES.PROPERTY_ID%TYPE
                     , X_EVENT_DATE IN RNT_PROPERTY_EXPENSES.EVENT_DATE%TYPE
                     , X_DESCRIPTION IN RNT_PROPERTY_EXPENSES.DESCRIPTION%TYPE
                     , X_RECURRING_YN IN RNT_PROPERTY_EXPENSES.RECURRING_YN%TYPE
                     , X_RECURRING_PERIOD IN RNT_PROPERTY_EXPENSES.RECURRING_PERIOD%TYPE
                     , X_RECURRING_ENDDATE IN RNT_PROPERTY_EXPENSES.RECURRING_ENDDATE%TYPE
                     , X_UNIT_ID IN RNT_PROPERTY_EXPENSES.UNIT_ID%TYPE
                     , X_LOAN_ID IN RNT_PROPERTY_EXPENSES.LOAN_ID%TYPE)
              return RNT_PROPERTY_EXPENSES.EXPENSE_ID%TYPE;

  procedure delete_row( X_EXPENSE_ID IN RNT_PROPERTY_EXPENSES.EXPENSE_ID%TYPE);

end RNT_PROPERTY_EXPENSES_PKG;
/
create or replace package body RNT_PROPERTY_EXPENSES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011       All rights reserved worldwide
    Name:      RNT_PROPERTY_EXPENSES_PKG
    Purpose:   API's for RNT_PROPERTY_EXPENSES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        03-OCT-11   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------
  function check_unique( X_EXPENSE_ID IN RNT_PROPERTY_EXPENSES.EXPENSE_ID%TYPE
                       , X_PROPERTY_ID IN RNT_PROPERTY_EXPENSES.PROPERTY_ID%TYPE
                       , X_EVENT_DATE IN RNT_PROPERTY_EXPENSES.EVENT_DATE%TYPE
                       , X_UNIT_ID IN RNT_PROPERTY_EXPENSES.UNIT_ID%TYPE
                       , X_DESCRIPTION IN RNT_PROPERTY_EXPENSES.DESCRIPTION%TYPE) return boolean is
        cursor c is
        select EXPENSE_ID
        from RNT_PROPERTY_EXPENSES
        where PROPERTY_ID = X_PROPERTY_ID
    and EVENT_DATE = X_EVENT_DATE
    and UNIT_ID = X_UNIT_ID
    and DESCRIPTION = X_DESCRIPTION;

      begin
         for c_rec in c loop
           if (X_EXPENSE_ID is null OR c_rec.EXPENSE_ID != X_EXPENSE_ID) then
             return false;
           end if;
         end loop;
         return true;
      end check_unique;

  procedure lock_row( X_EXPENSE_ID IN RNT_PROPERTY_EXPENSES.EXPENSE_ID%TYPE) is
     cursor c is
     select * from RNT_PROPERTY_EXPENSES
     where EXPENSE_ID = X_EXPENSE_ID
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
  function get_checksum( X_EXPENSE_ID IN RNT_PROPERTY_EXPENSES.EXPENSE_ID%TYPE)
            return RNT_PROPERTY_EXPENSES_V.CHECKSUM%TYPE is

    v_return_value               RNT_PROPERTY_EXPENSES_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_PROPERTY_EXPENSES_V
    where EXPENSE_ID = X_EXPENSE_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_EXPENSE_ID IN RNT_PROPERTY_EXPENSES.EXPENSE_ID%TYPE
                      , X_PROPERTY_ID IN RNT_PROPERTY_EXPENSES.PROPERTY_ID%TYPE
                      , X_EVENT_DATE IN RNT_PROPERTY_EXPENSES.EVENT_DATE%TYPE
                      , X_DESCRIPTION IN RNT_PROPERTY_EXPENSES.DESCRIPTION%TYPE
                      , X_RECURRING_YN IN RNT_PROPERTY_EXPENSES.RECURRING_YN%TYPE
                      , X_RECURRING_PERIOD IN RNT_PROPERTY_EXPENSES.RECURRING_PERIOD%TYPE
                      , X_RECURRING_ENDDATE IN RNT_PROPERTY_EXPENSES.RECURRING_ENDDATE%TYPE
                      , X_UNIT_ID IN RNT_PROPERTY_EXPENSES.UNIT_ID%TYPE
                      , X_LOAN_ID IN RNT_PROPERTY_EXPENSES.LOAN_ID%TYPE
                      , X_CHECKSUM IN RNT_PROPERTY_EXPENSES_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_PROPERTY_EXPENSES_V.CHECKSUM%TYPE;
  begin
     lock_row(X_EXPENSE_ID);

      -- validate checksum
      l_checksum := get_checksum(X_EXPENSE_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

         if not check_unique(X_EXPENSE_ID, X_PROPERTY_ID, X_EVENT_DATE, X_UNIT_ID, X_DESCRIPTION) then
             RAISE_APPLICATION_ERROR(-20006, 'Update values must be unique.');
         end if;
     update RNT_PROPERTY_EXPENSES
     set PROPERTY_ID = X_PROPERTY_ID
     , EVENT_DATE = X_EVENT_DATE
     , DESCRIPTION = X_DESCRIPTION
     , RECURRING_YN = X_RECURRING_YN
     , RECURRING_PERIOD = X_RECURRING_PERIOD
     , RECURRING_ENDDATE = X_RECURRING_ENDDATE
     , UNIT_ID = X_UNIT_ID
     , LOAN_ID = X_LOAN_ID
     where EXPENSE_ID = X_EXPENSE_ID;

  end update_row;

  function  insert_row( X_PROPERTY_ID IN RNT_PROPERTY_EXPENSES.PROPERTY_ID%TYPE
                     , X_EVENT_DATE IN RNT_PROPERTY_EXPENSES.EVENT_DATE%TYPE
                     , X_DESCRIPTION IN RNT_PROPERTY_EXPENSES.DESCRIPTION%TYPE
                     , X_RECURRING_YN IN RNT_PROPERTY_EXPENSES.RECURRING_YN%TYPE
                     , X_RECURRING_PERIOD IN RNT_PROPERTY_EXPENSES.RECURRING_PERIOD%TYPE
                     , X_RECURRING_ENDDATE IN RNT_PROPERTY_EXPENSES.RECURRING_ENDDATE%TYPE
                     , X_UNIT_ID IN RNT_PROPERTY_EXPENSES.UNIT_ID%TYPE
                     , X_LOAN_ID IN RNT_PROPERTY_EXPENSES.LOAN_ID%TYPE)
              return RNT_PROPERTY_EXPENSES.EXPENSE_ID%TYPE
  is
     x          number;
  begin
if not check_unique(NULL, X_PROPERTY_ID, X_EVENT_DATE, X_UNIT_ID, X_DESCRIPTION) then
         RAISE_APPLICATION_ERROR(-20006, 'Insert values must be unique.');
     end if;

     insert into RNT_PROPERTY_EXPENSES
     ( EXPENSE_ID
     , PROPERTY_ID
     , EVENT_DATE
     , DESCRIPTION
     , RECURRING_YN
     , RECURRING_PERIOD
     , RECURRING_ENDDATE
     , UNIT_ID
     , LOAN_ID)
     values
     ( RNT_PROPERTY_EXPENSES_SEQ.NEXTVAL
     , X_PROPERTY_ID
     , X_EVENT_DATE
     , X_DESCRIPTION
     , X_RECURRING_YN
     , X_RECURRING_PERIOD
     , X_RECURRING_ENDDATE
     , X_UNIT_ID
     , X_LOAN_ID)
     returning EXPENSE_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_EXPENSE_ID IN RNT_PROPERTY_EXPENSES.EXPENSE_ID%TYPE) is

  begin
    delete from RNT_PROPERTY_EXPENSES
    where EXPENSE_ID = X_EXPENSE_ID;

  end delete_row;

end RNT_PROPERTY_EXPENSES_PKG;
/

show errors package RNT_PROPERTY_EXPENSES_PKG
show errors package body RNT_PROPERTY_EXPENSES_PKG