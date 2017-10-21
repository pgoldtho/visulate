create or replace package RNT_LEAD_ACTIONS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2012       All rights reserved worldwide
    Name:      RNT_LEAD_ACTIONS_PKG
    Purpose:   API's for RNT_LEAD_ACTIONS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        24-JAN-13   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_ACTION_ID IN RNT_LEAD_ACTIONS.ACTION_ID%TYPE)
            return RNT_LEAD_ACTIONS_V.CHECKSUM%TYPE;

  procedure update_row( X_ACTION_ID IN RNT_LEAD_ACTIONS.ACTION_ID%TYPE
                      , X_LEAD_ID IN RNT_LEAD_ACTIONS.LEAD_ID%TYPE
                      , X_ACTION_DATE IN RNT_LEAD_ACTIONS.ACTION_DATE%TYPE
                      , X_ACTION_TYPE IN RNT_LEAD_ACTIONS.ACTION_TYPE%TYPE
                      , X_BROKER_ID IN RNT_LEAD_ACTIONS.BROKER_ID%TYPE
                      , X_DESCRIPTION IN RNT_LEAD_ACTIONS.DESCRIPTION%TYPE
                      , X_CHECKSUM IN RNT_LEAD_ACTIONS_V.CHECKSUM%TYPE);

  function  insert_row( X_LEAD_ID IN RNT_LEAD_ACTIONS.LEAD_ID%TYPE
                     , X_ACTION_DATE IN RNT_LEAD_ACTIONS.ACTION_DATE%TYPE
                     , X_ACTION_TYPE IN RNT_LEAD_ACTIONS.ACTION_TYPE%TYPE
                     , X_BROKER_ID IN RNT_LEAD_ACTIONS.BROKER_ID%TYPE
                     , X_DESCRIPTION IN RNT_LEAD_ACTIONS.DESCRIPTION%TYPE)
              return RNT_LEAD_ACTIONS.ACTION_ID%TYPE;

  procedure delete_row( X_ACTION_ID IN RNT_LEAD_ACTIONS.ACTION_ID%TYPE);

end RNT_LEAD_ACTIONS_PKG;
/

create or replace package body RNT_LEAD_ACTIONS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2012       All rights reserved worldwide
    Name:      RNT_LEAD_ACTIONS_PKG
    Purpose:   API's for RNT_LEAD_ACTIONS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        24-JAN-13   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_ACTION_ID IN RNT_LEAD_ACTIONS.ACTION_ID%TYPE) is
     cursor c is
     select * from RNT_LEAD_ACTIONS
     where ACTION_ID = X_ACTION_ID
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
  function get_checksum( X_ACTION_ID IN RNT_LEAD_ACTIONS.ACTION_ID%TYPE)
            return RNT_LEAD_ACTIONS_V.CHECKSUM%TYPE is

    v_return_value               RNT_LEAD_ACTIONS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_LEAD_ACTIONS_V
    where ACTION_ID = X_ACTION_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_ACTION_ID IN RNT_LEAD_ACTIONS.ACTION_ID%TYPE
                      , X_LEAD_ID IN RNT_LEAD_ACTIONS.LEAD_ID%TYPE
                      , X_ACTION_DATE IN RNT_LEAD_ACTIONS.ACTION_DATE%TYPE
                      , X_ACTION_TYPE IN RNT_LEAD_ACTIONS.ACTION_TYPE%TYPE
                      , X_BROKER_ID IN RNT_LEAD_ACTIONS.BROKER_ID%TYPE
                      , X_DESCRIPTION IN RNT_LEAD_ACTIONS.DESCRIPTION%TYPE
                      , X_CHECKSUM IN RNT_LEAD_ACTIONS_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_LEAD_ACTIONS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_ACTION_ID);

      -- validate checksum
      l_checksum := get_checksum(X_ACTION_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

     update RNT_LEAD_ACTIONS
     set LEAD_ID = X_LEAD_ID
     , ACTION_DATE = X_ACTION_DATE
     , ACTION_TYPE = X_ACTION_TYPE
     , BROKER_ID = X_BROKER_ID
     , DESCRIPTION = X_DESCRIPTION
     where ACTION_ID = X_ACTION_ID;

  end update_row;

  function  insert_row( X_LEAD_ID IN RNT_LEAD_ACTIONS.LEAD_ID%TYPE
                     , X_ACTION_DATE IN RNT_LEAD_ACTIONS.ACTION_DATE%TYPE
                     , X_ACTION_TYPE IN RNT_LEAD_ACTIONS.ACTION_TYPE%TYPE
                     , X_BROKER_ID IN RNT_LEAD_ACTIONS.BROKER_ID%TYPE
                     , X_DESCRIPTION IN RNT_LEAD_ACTIONS.DESCRIPTION%TYPE)
              return RNT_LEAD_ACTIONS.ACTION_ID%TYPE
  is
     x          number;
  begin

     insert into RNT_LEAD_ACTIONS
     ( ACTION_ID
     , LEAD_ID
     , ACTION_DATE
     , ACTION_TYPE
     , BROKER_ID
     , DESCRIPTION)
     values
     ( RNT_LEAD_ACTIONS_SEQ.NEXTVAL
     , X_LEAD_ID
     , X_ACTION_DATE
     , X_ACTION_TYPE
     , X_BROKER_ID
     , X_DESCRIPTION)
     returning ACTION_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_ACTION_ID IN RNT_LEAD_ACTIONS.ACTION_ID%TYPE) is
  begin
    delete from RNT_LEAD_ACTIONS
    where ACTION_ID = X_ACTION_ID;

  end delete_row;

end RNT_LEAD_ACTIONS_PKG;
/
