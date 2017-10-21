create or replace package RNT_ACCOUNT_TYPES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_ACCOUNT_TYPES_PKG
    Purpose:   API's for RNT_ACCOUNT_TYPES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        16-AUG-09   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_ACCOUNT_TYPE IN RNT_ACCOUNT_TYPES.ACCOUNT_TYPE%TYPE)
            return RNT_ACCOUNT_TYPES_V.CHECKSUM%TYPE;

  procedure update_row( X_ACCOUNT_TYPE IN RNT_ACCOUNT_TYPES.ACCOUNT_TYPE%TYPE
                      , X_DISPLAY_TITLE IN RNT_ACCOUNT_TYPES.DISPLAY_TITLE%TYPE
                      , X_CHECKSUM IN RNT_ACCOUNT_TYPES_V.CHECKSUM%TYPE);

  procedure insert_row( X_ACCOUNT_TYPE IN RNT_ACCOUNT_TYPES.ACCOUNT_TYPE%TYPE
                     , X_DISPLAY_TITLE IN RNT_ACCOUNT_TYPES.DISPLAY_TITLE%TYPE);

  procedure delete_row( X_ACCOUNT_TYPE IN RNT_ACCOUNT_TYPES.ACCOUNT_TYPE%TYPE);

end RNT_ACCOUNT_TYPES_PKG;
/
create or replace package body RNT_ACCOUNT_TYPES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_ACCOUNT_TYPES_PKG
    Purpose:   API's for RNT_ACCOUNT_TYPES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        16-AUG-09   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_ACCOUNT_TYPE IN RNT_ACCOUNT_TYPES.ACCOUNT_TYPE%TYPE) is
     cursor c is
     select * from RNT_ACCOUNT_TYPES
     where ACCOUNT_TYPE = X_ACCOUNT_TYPE
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
  function get_checksum( X_ACCOUNT_TYPE IN RNT_ACCOUNT_TYPES.ACCOUNT_TYPE%TYPE)
            return RNT_ACCOUNT_TYPES_V.CHECKSUM%TYPE is

    v_return_value               RNT_ACCOUNT_TYPES_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_ACCOUNT_TYPES_V
    where ACCOUNT_TYPE = X_ACCOUNT_TYPE;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_ACCOUNT_TYPE IN RNT_ACCOUNT_TYPES.ACCOUNT_TYPE%TYPE
                      , X_DISPLAY_TITLE IN RNT_ACCOUNT_TYPES.DISPLAY_TITLE%TYPE
                      , X_CHECKSUM IN RNT_ACCOUNT_TYPES_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_ACCOUNT_TYPES_V.CHECKSUM%TYPE;
  begin
     lock_row(X_ACCOUNT_TYPE);

      -- validate checksum
      l_checksum := get_checksum(X_ACCOUNT_TYPE);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

     update RNT_ACCOUNT_TYPES
     set DISPLAY_TITLE = X_DISPLAY_TITLE
     where ACCOUNT_TYPE = X_ACCOUNT_TYPE;

  end update_row;

  procedure insert_row( X_ACCOUNT_TYPE IN RNT_ACCOUNT_TYPES.ACCOUNT_TYPE%TYPE
                     , X_DISPLAY_TITLE IN RNT_ACCOUNT_TYPES.DISPLAY_TITLE%TYPE)
  is
    
  begin

     insert into RNT_ACCOUNT_TYPES
     ( ACCOUNT_TYPE
     , DISPLAY_TITLE)
     values
     ( X_ACCOUNT_TYPE
     , X_DISPLAY_TITLE);

  end insert_row;

  procedure delete_row( X_ACCOUNT_TYPE IN RNT_ACCOUNT_TYPES.ACCOUNT_TYPE%TYPE) is

  begin
    delete from RNT_ACCOUNT_TYPES
    where ACCOUNT_TYPE = X_ACCOUNT_TYPE;

  end delete_row;

end RNT_ACCOUNT_TYPES_PKG;
/

show errors package RNT_ACCOUNT_TYPES_PKG
show errors package body RNT_ACCOUNT_TYPES_PKG