create or replace package RNT_CITY_MEDIA_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2012       All rights reserved worldwide
    Name:      RNT_CITY_MEDIA_PKG
    Purpose:   API's for RNT_CITY_MEDIA table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        21-SEP-13   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_MEDIA_ID IN RNT_CITY_MEDIA.MEDIA_ID%TYPE)
            return RNT_CITY_MEDIA_V.CHECKSUM%TYPE;

  procedure update_row( X_MEDIA_ID IN RNT_CITY_MEDIA.MEDIA_ID%TYPE
                      , X_NAME IN RNT_CITY_MEDIA.NAME%TYPE
                      , X_MEDIA_TYPE IN RNT_CITY_MEDIA.MEDIA_TYPE%TYPE
                      , X_CITY_ID IN RNT_CITY_MEDIA.CITY_ID%TYPE
                      , X_REGION_ID IN RNT_CITY_MEDIA.REGION_ID%TYPE
                      , X_TITLE IN RNT_CITY_MEDIA.TITLE%TYPE
                      , X_ASPECT_RATIO IN RNT_CITY_MEDIA.ASPECT_RATIO%TYPE
                      , X_COUNTY_YN IN RNT_CITY_MEDIA.COUNTY_YN%TYPE
                      , X_CHECKSUM IN RNT_CITY_MEDIA_V.CHECKSUM%TYPE);

  function  insert_row( X_NAME IN RNT_CITY_MEDIA.NAME%TYPE
                     , X_MEDIA_TYPE IN RNT_CITY_MEDIA.MEDIA_TYPE%TYPE
                     , X_CITY_ID IN RNT_CITY_MEDIA.CITY_ID%TYPE
                     , X_REGION_ID IN RNT_CITY_MEDIA.REGION_ID%TYPE
                     , X_TITLE IN RNT_CITY_MEDIA.TITLE%TYPE
                     , X_ASPECT_RATIO IN RNT_CITY_MEDIA.ASPECT_RATIO%TYPE
                     , X_COUNTY_YN IN RNT_CITY_MEDIA.COUNTY_YN%TYPE)
              return RNT_CITY_MEDIA.MEDIA_ID%TYPE;

  procedure delete_row( X_MEDIA_ID IN RNT_CITY_MEDIA.MEDIA_ID%TYPE);

end RNT_CITY_MEDIA_PKG;
/
create or replace package body RNT_CITY_MEDIA_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2012       All rights reserved worldwide
    Name:      RNT_CITY_MEDIA_PKG
    Purpose:   API's for RNT_CITY_MEDIA table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        21-SEP-13   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------
  function check_unique( X_MEDIA_ID IN RNT_CITY_MEDIA.MEDIA_ID%TYPE
                       , X_NAME IN RNT_CITY_MEDIA.NAME%TYPE) return boolean is
        cursor c is
        select MEDIA_ID
        from RNT_CITY_MEDIA
        where NAME = X_NAME;

      begin
         for c_rec in c loop
           if (X_MEDIA_ID is null OR c_rec.MEDIA_ID != X_MEDIA_ID) then
             return false;
           end if;
         end loop;
         return true;
      end check_unique;

  procedure lock_row( X_MEDIA_ID IN RNT_CITY_MEDIA.MEDIA_ID%TYPE) is
     cursor c is
     select * from RNT_CITY_MEDIA
     where MEDIA_ID = X_MEDIA_ID
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
  function get_checksum( X_MEDIA_ID IN RNT_CITY_MEDIA.MEDIA_ID%TYPE)
            return RNT_CITY_MEDIA_V.CHECKSUM%TYPE is

    v_return_value               RNT_CITY_MEDIA_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_CITY_MEDIA_V
    where MEDIA_ID = X_MEDIA_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_MEDIA_ID IN RNT_CITY_MEDIA.MEDIA_ID%TYPE
                      , X_NAME IN RNT_CITY_MEDIA.NAME%TYPE
                      , X_MEDIA_TYPE IN RNT_CITY_MEDIA.MEDIA_TYPE%TYPE
                      , X_CITY_ID IN RNT_CITY_MEDIA.CITY_ID%TYPE
                      , X_REGION_ID IN RNT_CITY_MEDIA.REGION_ID%TYPE
                      , X_TITLE IN RNT_CITY_MEDIA.TITLE%TYPE
                      , X_ASPECT_RATIO IN RNT_CITY_MEDIA.ASPECT_RATIO%TYPE
                      , X_COUNTY_YN IN RNT_CITY_MEDIA.COUNTY_YN%TYPE
                      , X_CHECKSUM IN RNT_CITY_MEDIA_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_CITY_MEDIA_V.CHECKSUM%TYPE;
  begin
     lock_row(X_MEDIA_ID);

      -- validate checksum
      l_checksum := get_checksum(X_MEDIA_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

         if not check_unique(X_MEDIA_ID, X_NAME) then
             RAISE_APPLICATION_ERROR(-20006, 'Update values must be unique.');
         end if;
     update RNT_CITY_MEDIA
     set NAME = X_NAME
     , MEDIA_TYPE = X_MEDIA_TYPE
     , CITY_ID = X_CITY_ID
     , REGION_ID = X_REGION_ID
     , TITLE = X_TITLE
     , ASPECT_RATIO = X_ASPECT_RATIO
     , COUNTY_YN = X_COUNTY_YN
     where MEDIA_ID = X_MEDIA_ID;

  end update_row;

  function  insert_row( X_NAME IN RNT_CITY_MEDIA.NAME%TYPE
                     , X_MEDIA_TYPE IN RNT_CITY_MEDIA.MEDIA_TYPE%TYPE
                     , X_CITY_ID IN RNT_CITY_MEDIA.CITY_ID%TYPE
                     , X_REGION_ID IN RNT_CITY_MEDIA.REGION_ID%TYPE
                     , X_TITLE IN RNT_CITY_MEDIA.TITLE%TYPE
                     , X_ASPECT_RATIO IN RNT_CITY_MEDIA.ASPECT_RATIO%TYPE
                     , X_COUNTY_YN IN RNT_CITY_MEDIA.COUNTY_YN%TYPE)
              return RNT_CITY_MEDIA.MEDIA_ID%TYPE
  is
     x          number;
  begin
if not check_unique(NULL, X_NAME) then
         RAISE_APPLICATION_ERROR(-20006, 'Insert values must be unique.');
     end if;

     insert into RNT_CITY_MEDIA
     ( MEDIA_ID
     , NAME
     , MEDIA_TYPE
     , CITY_ID
     , REGION_ID
     , TITLE
     , ASPECT_RATIO
     , COUNTY_YN)
     values
     ( RNT_CITY_MEDIA_SEQ.NEXTVAL
     , X_NAME
     , X_MEDIA_TYPE
     , X_CITY_ID
     , X_REGION_ID
     , X_TITLE
     , X_ASPECT_RATIO
     , X_COUNTY_YN)
     returning MEDIA_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_MEDIA_ID IN RNT_CITY_MEDIA.MEDIA_ID%TYPE) is

  begin
    delete from RNT_CITY_MEDIA
    where MEDIA_ID = X_MEDIA_ID;

  end delete_row;

end RNT_CITY_MEDIA_PKG;
/
