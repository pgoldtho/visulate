create or replace package PR_PROP_CLASS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011        All rights reserved worldwide
    Name:      PR_PROP_CLASS_PKG
    Purpose:   API's for PR_PROP_CLASS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        14-FEB-11   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_PROP_CLASS IN PR_PROP_CLASS.PROP_CLASS%TYPE)
            return PR_PROP_CLASS_V.CHECKSUM%TYPE;

  procedure update_row( X_PROP_CLASS IN PR_PROP_CLASS.PROP_CLASS%TYPE
                      , X_DESCRIPTION IN PR_PROP_CLASS.DESCRIPTION%TYPE
                      , X_CHECKSUM IN PR_PROP_CLASS_V.CHECKSUM%TYPE);

  procedure  insert_row( X_PROP_CLASS IN PR_PROP_CLASS.PROP_CLASS%TYPE
                     , X_DESCRIPTION IN PR_PROP_CLASS.DESCRIPTION%TYPE);

  procedure delete_row( X_PROP_CLASS IN PR_PROP_CLASS.PROP_CLASS%TYPE);

end PR_PROP_CLASS_PKG;
/
create or replace package body PR_PROP_CLASS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011        All rights reserved worldwide
    Name:      PR_PROP_CLASS_PKG
    Purpose:   API's for PR_PROP_CLASS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        14-FEB-11   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_PROP_CLASS IN PR_PROP_CLASS.PROP_CLASS%TYPE) is
     cursor c is
     select * from PR_PROP_CLASS
     where PROP_CLASS = X_PROP_CLASS
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
  function get_checksum( X_PROP_CLASS IN PR_PROP_CLASS.PROP_CLASS%TYPE)
            return PR_PROP_CLASS_V.CHECKSUM%TYPE is

    v_return_value               PR_PROP_CLASS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from PR_PROP_CLASS_V
    where PROP_CLASS = X_PROP_CLASS;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_PROP_CLASS IN PR_PROP_CLASS.PROP_CLASS%TYPE
                      , X_DESCRIPTION IN PR_PROP_CLASS.DESCRIPTION%TYPE
                      , X_CHECKSUM IN PR_PROP_CLASS_V.CHECKSUM%TYPE)
  is
     l_checksum          PR_PROP_CLASS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_PROP_CLASS);

      -- validate checksum
      l_checksum := get_checksum(X_PROP_CLASS);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

     update PR_PROP_CLASS
     set DESCRIPTION = X_DESCRIPTION
     where PROP_CLASS = X_PROP_CLASS;

  end update_row;

  procedure  insert_row( X_PROP_CLASS IN PR_PROP_CLASS.PROP_CLASS%TYPE
                     , X_DESCRIPTION IN PR_PROP_CLASS.DESCRIPTION%TYPE)
  is
     x          number;
  begin

     insert into PR_PROP_CLASS
     ( PROP_CLASS
     , DESCRIPTION)
     values
     ( X_PROP_CLASS
     , X_DESCRIPTION);

  end insert_row;

  procedure delete_row( X_PROP_CLASS IN PR_PROP_CLASS.PROP_CLASS%TYPE) is

  begin
    delete from PR_PROP_CLASS
    where PROP_CLASS = X_PROP_CLASS;

  end delete_row;

end PR_PROP_CLASS_PKG;
/

show errors package PR_PROP_CLASS_PKG
show errors package body PR_PROP_CLASS_PKG
