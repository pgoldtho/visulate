create or replace package PR_PROPERTY_USAGE_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2009        All rights reserved worldwide
    Name:      PR_PROPERTY_USAGE_PKG
    Purpose:   API's for PR_PROPERTY_USAGE table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        25-NOV-09   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_PROP_ID IN PR_PROPERTY_USAGE.PROP_ID%TYPE)
            return PR_PROPERTY_USAGE_V.CHECKSUM%TYPE;

  procedure update_row( X_PROP_ID  IN PR_PROPERTY_USAGE.PROP_ID%TYPE
                      , X_UCODE    IN PR_PROPERTY_USAGE.UCODE%TYPE
                      , X_CHECKSUM IN PR_PROPERTY_USAGE_V.CHECKSUM%TYPE);

  procedure insert_row( X_PROP_ID IN PR_PROPERTY_USAGE.PROP_ID%TYPE
                      , X_UCODE   IN PR_PROPERTY_USAGE.UCODE%TYPE);


  procedure delete_row( X_UCODE IN PR_PROPERTY_USAGE.UCODE%TYPE
                      , X_PROP_ID IN PR_PROPERTY_USAGE.PROP_ID%TYPE);

end PR_PROPERTY_USAGE_PKG;
/

create or replace package body PR_PROPERTY_USAGE_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2009        All rights reserved worldwide
    Name:      PR_PROPERTY_USAGE_PKG
    Purpose:   API's for PR_PROPERTY_USAGE table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        25-NOV-09   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row(X_PROP_ID IN PR_PROPERTY_USAGE.PROP_ID%TYPE) is
     cursor c is
     select * from PR_PROPERTY_USAGE
     where PROP_ID = X_PROP_ID
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
  function get_checksum( X_PROP_ID IN PR_PROPERTY_USAGE.PROP_ID%TYPE)
            return PR_PROPERTY_USAGE_V.CHECKSUM%TYPE is

    v_return_value               PR_PROPERTY_USAGE_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from PR_PROPERTY_USAGE_V
    where PROP_ID = X_PROP_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_PROP_ID  IN PR_PROPERTY_USAGE.PROP_ID%TYPE
                      , X_UCODE    IN PR_PROPERTY_USAGE.UCODE%TYPE
                      , X_CHECKSUM IN PR_PROPERTY_USAGE_V.CHECKSUM%TYPE)
  is
     l_checksum          PR_PROPERTY_USAGE_V.CHECKSUM%TYPE;
  begin
     lock_row(X_PROP_ID);

      -- validate checksum
      l_checksum := get_checksum(X_PROP_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

     update PR_PROPERTY_USAGE
     set PROP_ID = X_PROP_ID
     where UCODE = X_UCODE;

  end update_row;

  procedure insert_row( X_PROP_ID IN PR_PROPERTY_USAGE.PROP_ID%TYPE
                      , X_UCODE   IN PR_PROPERTY_USAGE.UCODE%TYPE)
  is
    
  begin

     insert into PR_PROPERTY_USAGE
     ( UCODE
     , PROP_ID)
     values
     ( X_UCODE
     , X_PROP_ID);
  end insert_row;

  procedure delete_row( X_UCODE IN PR_PROPERTY_USAGE.UCODE%TYPE
                       , X_PROP_ID IN PR_PROPERTY_USAGE.PROP_ID%TYPE) is

  begin
    delete from PR_PROPERTY_USAGE
    where UCODE = X_UCODE
    and PROP_ID = X_PROP_ID;

  end delete_row;

end PR_PROPERTY_USAGE_PKG;
/

show errors package PR_PROPERTY_USAGE_PKG
show errors package body PR_PROPERTY_USAGE_PKG