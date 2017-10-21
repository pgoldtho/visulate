CREATE OR REPLACE package RNT_SECTION8_OFFICES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_SECTION8_OFFICES_PKG
    Purpose:   API's for RNT_SECTION8_OFFICES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        03-OCT-07   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_SECTION8_ID IN RNT_SECTION8_OFFICES.SECTION8_ID%TYPE)
            return RNT_SECTION8_OFFICES_V.CHECKSUM%TYPE;

  procedure update_row( X_SECTION8_ID IN RNT_SECTION8_OFFICES.SECTION8_ID%TYPE
                      , X_SECTION_NAME IN RNT_SECTION8_OFFICES.SECTION_NAME%TYPE
                      , X_BUSINESS_ID IN RNT_SECTION8_OFFICES.BUSINESS_ID%TYPE
                      , X_CHECKSUM IN RNT_SECTION8_OFFICES_V.CHECKSUM%TYPE);

  function insert_row( X_SECTION_NAME IN RNT_SECTION8_OFFICES.SECTION_NAME%TYPE
                     , X_BUSINESS_ID IN RNT_SECTION8_OFFICES.BUSINESS_ID%TYPE)
              return RNT_SECTION8_OFFICES.SECTION8_ID%TYPE;

  procedure delete_row( X_SECTION8_ID IN RNT_SECTION8_OFFICES.SECTION8_ID%TYPE);

end RNT_SECTION8_OFFICES_PKG;
/


CREATE OR REPLACE package body        RNT_SECTION8_OFFICES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_SECTION8_OFFICES_PKG
    Purpose:   API's for RNT_SECTION8_OFFICES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        03-OCT-07   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_SECTION8_ID IN RNT_SECTION8_OFFICES.SECTION8_ID%TYPE) is
     cursor c is
     select * from RNT_SECTION8_OFFICES
     where SECTION8_ID = X_SECTION8_ID
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
  function get_checksum( X_SECTION8_ID IN RNT_SECTION8_OFFICES.SECTION8_ID%TYPE)
            return RNT_SECTION8_OFFICES_V.CHECKSUM%TYPE is 

    v_return_value               RNT_SECTION8_OFFICES_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_SECTION8_OFFICES_V
    where SECTION8_ID = X_SECTION8_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_SECTION8_ID IN RNT_SECTION8_OFFICES.SECTION8_ID%TYPE
                      , X_SECTION_NAME IN RNT_SECTION8_OFFICES.SECTION_NAME%TYPE
                      , X_BUSINESS_ID IN RNT_SECTION8_OFFICES.BUSINESS_ID%TYPE
                      , X_CHECKSUM IN RNT_SECTION8_OFFICES_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_SECTION8_OFFICES_V.CHECKSUM%TYPE;
  begin
     lock_row(X_SECTION8_ID);

      -- validate checksum
      l_checksum := get_checksum(X_SECTION8_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;
     
     update RNT_SECTION8_OFFICES
     set SECTION_NAME = X_SECTION_NAME
     , BUSINESS_ID = X_BUSINESS_ID
     where SECTION8_ID = X_SECTION8_ID;

  end update_row;

  function insert_row( X_SECTION_NAME IN RNT_SECTION8_OFFICES.SECTION_NAME%TYPE
                     , X_BUSINESS_ID IN RNT_SECTION8_OFFICES.BUSINESS_ID%TYPE)
              return RNT_SECTION8_OFFICES.SECTION8_ID%TYPE
  is
     x          number;
  begin

     insert into RNT_SECTION8_OFFICES
     ( SECTION8_ID
     , SECTION_NAME
     , BUSINESS_ID)
     values
     ( RNT_SECTION8_OFFICES_SEQ.NEXTVAL
     , X_SECTION_NAME
     , X_BUSINESS_ID)
     returning SECTION8_ID into x;

     return x;
  end insert_row;

function is_exists_tenant(X_SECTION8_ID RNT_SECTION8_OFFICES.SECTION8_ID%TYPE) return boolean
is
 x NUMBER;
begin
  select 1
  into x
  from DUAL
  where exists (select 1
                from RNT_TENANT
                where SECTION8_ID = X_SECTION8_ID
                );
  return true;
exception
  when NO_DATA_FOUND then
     return false;   
end;

  procedure delete_row(X_SECTION8_ID IN RNT_SECTION8_OFFICES.SECTION8_ID%TYPE) is
  begin
    -- check for exists child records
    if is_exists_tenant(X_SECTION8_ID) then
       RAISE_APPLICATION_ERROR(-20400, 'Cannot delete record. For Section8 exists tenant.');
    end if; 
  
    delete from RNT_SECTION8_OFFICES
    where SECTION8_ID = X_SECTION8_ID;

  end delete_row;

end RNT_SECTION8_OFFICES_PKG;
/


