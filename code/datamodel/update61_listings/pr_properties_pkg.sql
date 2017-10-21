create or replace package PR_PROPERTIES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2009        All rights reserved worldwide
    Name:      PR_PROPERTIES_PKG
    Purpose:   API's for PR_PROPERTIES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        25-NOV-09   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_PROP_ID IN PR_PROPERTIES.PROP_ID%TYPE)
            return PR_PROPERTIES_V.CHECKSUM%TYPE;

  procedure update_row( X_PROP_ID IN PR_PROPERTIES.PROP_ID%TYPE
                      , X_SOURCE_ID IN PR_PROPERTIES.SOURCE_ID%TYPE
                      , X_SOURCE_PK IN PR_PROPERTIES.SOURCE_PK%TYPE
                      , X_ADDRESS1 IN PR_PROPERTIES.ADDRESS1%TYPE
                      , X_ADDRESS2 IN PR_PROPERTIES.ADDRESS2%TYPE
                      , X_CITY IN PR_PROPERTIES.CITY%TYPE
                      , X_STATE IN PR_PROPERTIES.STATE%TYPE
                      , X_ZIPCODE IN PR_PROPERTIES.ZIPCODE%TYPE
                      , X_ACREAGE IN PR_PROPERTIES.ACREAGE%TYPE
                      , X_SQ_FT IN PR_PROPERTIES.SQ_FT%TYPE
                      , X_CHECKSUM IN PR_PROPERTIES_V.CHECKSUM%TYPE);

  function insert_row( X_SOURCE_ID IN PR_PROPERTIES.SOURCE_ID%TYPE
                     , X_SOURCE_PK IN PR_PROPERTIES.SOURCE_PK%TYPE
                     , X_ADDRESS1 IN PR_PROPERTIES.ADDRESS1%TYPE
                     , X_ADDRESS2 IN PR_PROPERTIES.ADDRESS2%TYPE
                     , X_CITY IN PR_PROPERTIES.CITY%TYPE
                     , X_STATE IN PR_PROPERTIES.STATE%TYPE
                     , X_ZIPCODE IN PR_PROPERTIES.ZIPCODE%TYPE
                     , X_ACREAGE IN PR_PROPERTIES.ACREAGE%TYPE
                     , X_SQ_FT IN PR_PROPERTIES.SQ_FT%TYPE)
              return PR_PROPERTIES.PROP_ID%TYPE;

  procedure delete_row( X_PROP_ID IN PR_PROPERTIES.PROP_ID%TYPE);

end PR_PROPERTIES_PKG;
/
create or replace package body PR_PROPERTIES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2009        All rights reserved worldwide
    Name:      PR_PROPERTIES_PKG
    Purpose:   API's for PR_PROPERTIES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        25-NOV-09   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_PROP_ID IN PR_PROPERTIES.PROP_ID%TYPE) is
     cursor c is
     select * from PR_PROPERTIES
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
  function get_checksum( X_PROP_ID IN PR_PROPERTIES.PROP_ID%TYPE)
            return PR_PROPERTIES_V.CHECKSUM%TYPE is

    v_return_value               PR_PROPERTIES_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from PR_PROPERTIES_V
    where PROP_ID = X_PROP_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_PROP_ID IN PR_PROPERTIES.PROP_ID%TYPE
                      , X_SOURCE_ID IN PR_PROPERTIES.SOURCE_ID%TYPE
                      , X_SOURCE_PK IN PR_PROPERTIES.SOURCE_PK%TYPE
                      , X_ADDRESS1 IN PR_PROPERTIES.ADDRESS1%TYPE
                      , X_ADDRESS2 IN PR_PROPERTIES.ADDRESS2%TYPE
                      , X_CITY IN PR_PROPERTIES.CITY%TYPE
                      , X_STATE IN PR_PROPERTIES.STATE%TYPE
                      , X_ZIPCODE IN PR_PROPERTIES.ZIPCODE%TYPE
                      , X_ACREAGE IN PR_PROPERTIES.ACREAGE%TYPE
                      , X_SQ_FT IN PR_PROPERTIES.SQ_FT%TYPE
                      , X_CHECKSUM IN PR_PROPERTIES_V.CHECKSUM%TYPE)
  is
     l_checksum          PR_PROPERTIES_V.CHECKSUM%TYPE;
  begin
     lock_row(X_PROP_ID);

      -- validate checksum
      l_checksum := get_checksum(X_PROP_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

     update PR_PROPERTIES
     set SOURCE_ID = X_SOURCE_ID
     , SOURCE_PK = X_SOURCE_PK
     , ADDRESS1 = X_ADDRESS1
     , ADDRESS2 = X_ADDRESS2
     , CITY = X_CITY
     , STATE = X_STATE
     , ZIPCODE = X_ZIPCODE
     , ACREAGE = X_ACREAGE
     , SQ_FT = X_SQ_FT
     where PROP_ID = X_PROP_ID;

  end update_row;

  function insert_row( X_SOURCE_ID IN PR_PROPERTIES.SOURCE_ID%TYPE
                     , X_SOURCE_PK IN PR_PROPERTIES.SOURCE_PK%TYPE
                     , X_ADDRESS1 IN PR_PROPERTIES.ADDRESS1%TYPE
                     , X_ADDRESS2 IN PR_PROPERTIES.ADDRESS2%TYPE
                     , X_CITY IN PR_PROPERTIES.CITY%TYPE
                     , X_STATE IN PR_PROPERTIES.STATE%TYPE
                     , X_ZIPCODE IN PR_PROPERTIES.ZIPCODE%TYPE
                     , X_ACREAGE IN PR_PROPERTIES.ACREAGE%TYPE
                     , X_SQ_FT IN PR_PROPERTIES.SQ_FT%TYPE)
              return PR_PROPERTIES.PROP_ID%TYPE
  is
     x          number;
  begin

     insert into PR_PROPERTIES
     ( PROP_ID
     , SOURCE_ID
     , SOURCE_PK
     , ADDRESS1
     , ADDRESS2
     , CITY
     , STATE
     , ZIPCODE
     , ACREAGE
     , SQ_FT)
     values
     ( PR_PROPERTIES_SEQ.NEXTVAL
     , X_SOURCE_ID
     , X_SOURCE_PK
     , X_ADDRESS1
     , X_ADDRESS2
     , X_CITY
     , X_STATE
     , X_ZIPCODE
     , X_ACREAGE
     , X_SQ_FT)
     returning PROP_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_PROP_ID IN PR_PROPERTIES.PROP_ID%TYPE) is

  begin
    delete from PR_PROPERTIES
    where PROP_ID = X_PROP_ID;

  end delete_row;

end PR_PROPERTIES_PKG;
/

show errors package PR_PROPERTIES_PKG
show errors package body PR_PROPERTIES_PKG