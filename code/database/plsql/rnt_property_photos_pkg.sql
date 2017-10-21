CREATE OR REPLACE package RNT_PROPERTY_PHOTOS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_PROPERTY_PHOTOS_PKG
    Purpose:   API's for RNT_PROPERTY_PHOTOS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        04-JUL-08   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_PHOTO_ID IN RNT_PROPERTY_PHOTOS.PHOTO_ID%TYPE)
            return RNT_PROPERTY_PHOTOS_V.CHECKSUM%TYPE;

  procedure update_row( X_PHOTO_ID IN RNT_PROPERTY_PHOTOS.PHOTO_ID%TYPE
                      , X_PHOTO_TITLE IN RNT_PROPERTY_PHOTOS.PHOTO_TITLE%TYPE
                      , X_PHOTO_FILENAME IN RNT_PROPERTY_PHOTOS.PHOTO_FILENAME%TYPE
                      , X_PROPERTY_ID IN RNT_PROPERTY_PHOTOS.PROPERTY_ID%TYPE
                      , X_CHECKSUM IN RNT_PROPERTY_PHOTOS_V.CHECKSUM%TYPE);

  function insert_row( X_PHOTO_TITLE IN RNT_PROPERTY_PHOTOS.PHOTO_TITLE%TYPE
                     , X_PHOTO_FILENAME IN RNT_PROPERTY_PHOTOS.PHOTO_FILENAME%TYPE
                     , X_PROPERTY_ID IN RNT_PROPERTY_PHOTOS.PROPERTY_ID%TYPE)
              return RNT_PROPERTY_PHOTOS.PHOTO_ID%TYPE;

  procedure delete_row( X_PHOTO_ID IN RNT_PROPERTY_PHOTOS.PHOTO_ID%TYPE);

end RNT_PROPERTY_PHOTOS_PKG; 
/

CREATE OR REPLACE package body RNT_PROPERTY_PHOTOS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_PROPERTY_PHOTOS_PKG
    Purpose:   API's for RNT_PROPERTY_PHOTOS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        04-JUL-08   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_PHOTO_ID IN RNT_PROPERTY_PHOTOS.PHOTO_ID%TYPE) is
     cursor c is
     select * from RNT_PROPERTY_PHOTOS
     where PHOTO_ID = X_PHOTO_ID
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
  function get_checksum( X_PHOTO_ID IN RNT_PROPERTY_PHOTOS.PHOTO_ID%TYPE)
            return RNT_PROPERTY_PHOTOS_V.CHECKSUM%TYPE is 

    v_return_value               RNT_PROPERTY_PHOTOS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_PROPERTY_PHOTOS_V
    where PHOTO_ID = X_PHOTO_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_PHOTO_ID IN RNT_PROPERTY_PHOTOS.PHOTO_ID%TYPE
                      , X_PHOTO_TITLE IN RNT_PROPERTY_PHOTOS.PHOTO_TITLE%TYPE
                      , X_PHOTO_FILENAME IN RNT_PROPERTY_PHOTOS.PHOTO_FILENAME%TYPE
                      , X_PROPERTY_ID IN RNT_PROPERTY_PHOTOS.PROPERTY_ID%TYPE
                      , X_CHECKSUM IN RNT_PROPERTY_PHOTOS_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_PROPERTY_PHOTOS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_PHOTO_ID);

      -- validate checksum
      l_checksum := get_checksum(X_PHOTO_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;
     
     update RNT_PROPERTY_PHOTOS
     set PHOTO_TITLE = X_PHOTO_TITLE
     , PHOTO_FILENAME = X_PHOTO_FILENAME
     , PROPERTY_ID = X_PROPERTY_ID
     where PHOTO_ID = X_PHOTO_ID;

  end update_row;

  function insert_row( X_PHOTO_TITLE IN RNT_PROPERTY_PHOTOS.PHOTO_TITLE%TYPE
                     , X_PHOTO_FILENAME IN RNT_PROPERTY_PHOTOS.PHOTO_FILENAME%TYPE
                     , X_PROPERTY_ID IN RNT_PROPERTY_PHOTOS.PROPERTY_ID%TYPE)
              return RNT_PROPERTY_PHOTOS.PHOTO_ID%TYPE
  is
     x          number;
  begin

     insert into RNT_PROPERTY_PHOTOS
     ( PHOTO_ID
     , PHOTO_TITLE
     , PHOTO_FILENAME
     , PROPERTY_ID)
     values
     ( RNT_PROPERTY_PHOTOS_SEQ.NEXTVAL
     , X_PHOTO_TITLE
     , X_PHOTO_FILENAME
     , X_PROPERTY_ID)
     returning PHOTO_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_PHOTO_ID IN RNT_PROPERTY_PHOTOS.PHOTO_ID%TYPE) is

  begin
    delete from RNT_PROPERTY_PHOTOS
    where PHOTO_ID = X_PHOTO_ID;

  end delete_row;

end RNT_PROPERTY_PHOTOS_PKG; 
/

