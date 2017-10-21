create or replace package RNT_CITIES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2013       All rights reserved worldwide
    Name:      RNT_CITIES_PKG
    Purpose:   API's for RNT_CITIES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        21-SEP-13   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_CITY_ID IN RNT_CITIES.CITY_ID%TYPE)
            return RNT_CITIES_V.CHECKSUM%TYPE;

  procedure update_row( X_CITY_ID IN RNT_CITIES.CITY_ID%TYPE
                      , X_NAME IN RNT_CITIES.NAME%TYPE
                      , X_COUNTY IN RNT_CITIES.COUNTY%TYPE
                      , X_STATE IN RNT_CITIES.STATE%TYPE
                      , X_DESCRIPTION IN RNT_CITIES.DESCRIPTION%TYPE
                      , X_GEO_LOCATION IN RNT_CITIES.GEO_LOCATION%TYPE
                      , X_REPORT_DATA IN RNT_CITIES.REPORT_DATA%TYPE
                      , X_REGION_ID IN RNT_CITIES.REGION_ID%TYPE
                      , X_CHECKSUM IN RNT_CITIES_V.CHECKSUM%TYPE);

  function  insert_row( X_NAME IN RNT_CITIES.NAME%TYPE
                     , X_COUNTY IN RNT_CITIES.COUNTY%TYPE
                     , X_STATE IN RNT_CITIES.STATE%TYPE
                     , X_DESCRIPTION IN RNT_CITIES.DESCRIPTION%TYPE
                     , X_GEO_LOCATION IN RNT_CITIES.GEO_LOCATION%TYPE
                     , X_REPORT_DATA IN RNT_CITIES.REPORT_DATA%TYPE
                     , X_REGION_ID IN RNT_CITIES.REGION_ID%TYPE)
              return RNT_CITIES.CITY_ID%TYPE;

  procedure delete_row( X_CITY_ID IN RNT_CITIES.CITY_ID%TYPE);

end RNT_CITIES_PKG;
/
create or replace package body RNT_CITIES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2013       All rights reserved worldwide
    Name:      RNT_CITIES_PKG
    Purpose:   API's for RNT_CITIES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        21-SEP-13   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_CITY_ID IN RNT_CITIES.CITY_ID%TYPE) is
     cursor c is
     select * from RNT_CITIES
     where CITY_ID = X_CITY_ID
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
  function get_checksum( X_CITY_ID IN RNT_CITIES.CITY_ID%TYPE)
            return RNT_CITIES_V.CHECKSUM%TYPE is

    v_return_value               RNT_CITIES_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_CITIES_V
    where CITY_ID = X_CITY_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_CITY_ID IN RNT_CITIES.CITY_ID%TYPE
                      , X_NAME IN RNT_CITIES.NAME%TYPE
                      , X_COUNTY IN RNT_CITIES.COUNTY%TYPE
                      , X_STATE IN RNT_CITIES.STATE%TYPE
                      , X_DESCRIPTION IN RNT_CITIES.DESCRIPTION%TYPE
                      , X_GEO_LOCATION IN RNT_CITIES.GEO_LOCATION%TYPE
                      , X_REPORT_DATA IN RNT_CITIES.REPORT_DATA%TYPE
                      , X_REGION_ID IN RNT_CITIES.REGION_ID%TYPE
                      , X_CHECKSUM IN RNT_CITIES_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_CITIES_V.CHECKSUM%TYPE;
  begin
     lock_row(X_CITY_ID);

      -- validate checksum
      l_checksum := get_checksum(X_CITY_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

     update RNT_CITIES
     set NAME = X_NAME
     , COUNTY = X_COUNTY
     , STATE = X_STATE
     , DESCRIPTION = X_DESCRIPTION
     , GEO_LOCATION = X_GEO_LOCATION
     , REPORT_DATA = X_REPORT_DATA
     , REGION_ID = X_REGION_ID
     where CITY_ID = X_CITY_ID;

  end update_row;

  function  insert_row( X_NAME IN RNT_CITIES.NAME%TYPE
                     , X_COUNTY IN RNT_CITIES.COUNTY%TYPE
                     , X_STATE IN RNT_CITIES.STATE%TYPE
                     , X_DESCRIPTION IN RNT_CITIES.DESCRIPTION%TYPE
                     , X_GEO_LOCATION IN RNT_CITIES.GEO_LOCATION%TYPE
                     , X_REPORT_DATA IN RNT_CITIES.REPORT_DATA%TYPE
                     , X_REGION_ID IN RNT_CITIES.REGION_ID%TYPE)
              return RNT_CITIES.CITY_ID%TYPE
  is
     x          number;
  begin

     insert into RNT_CITIES
     ( CITY_ID
     , NAME
     , COUNTY
     , STATE
     , DESCRIPTION
     , GEO_LOCATION
     , REPORT_DATA
     , REGION_ID)
     values
     ( RNT_CITIES_SEQ.NEXTVAL
     , X_NAME
     , X_COUNTY
     , X_STATE
     , X_DESCRIPTION
     , X_GEO_LOCATION
     , X_REPORT_DATA
     , X_REGION_ID)
     returning CITY_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_CITY_ID IN RNT_CITIES.CITY_ID%TYPE) is

  begin
    delete from RNT_CITIES
    where CITY_ID = X_CITY_ID;

  end delete_row;

end RNT_CITIES_PKG;
/


show errors package RNT_CITIES_PKG
show errors package body RNT_CITIES_PKG
