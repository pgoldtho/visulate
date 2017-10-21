create or replace package MLS_PHOTOS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011       All rights reserved worldwide
    Name:      MLS_PHOTOS_PKG
    Purpose:   API's for MLS_PHOTOS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        11-DEC-11   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_MLS_ID IN MLS_PHOTOS.MLS_ID%TYPE
                       , X_PHOTO_SEQ IN MLS_PHOTOS.PHOTO_SEQ%TYPE)
            return MLS_PHOTOS_V.CHECKSUM%TYPE;

  procedure update_row( X_MLS_ID     IN MLS_PHOTOS.MLS_ID%TYPE
                      , X_PHOTO_SEQ  IN MLS_PHOTOS.PHOTO_SEQ%TYPE
                      , X_PHOTO_URL  IN MLS_PHOTOS.PHOTO_URL%TYPE
                      , X_PHOTO_DESC IN MLS_PHOTOS.PHOTO_DESC%TYPE
                      , X_CHECKSUM   IN MLS_PHOTOS_V.CHECKSUM%TYPE);

  procedure insert_row( X_MLS_ID     IN MLS_PHOTOS.MLS_ID%TYPE
                      , X_PHOTO_SEQ  IN MLS_PHOTOS.PHOTO_SEQ%TYPE
                      , X_PHOTO_URL  IN MLS_PHOTOS.PHOTO_URL%TYPE
                      , X_PHOTO_DESC IN MLS_PHOTOS.PHOTO_DESC%TYPE);

  procedure delete_row( X_MLS_ID IN MLS_PHOTOS.MLS_ID%TYPE
                       , X_PHOTO_SEQ IN MLS_PHOTOS.PHOTO_SEQ%TYPE);

end MLS_PHOTOS_PKG;
/
create or replace package body MLS_PHOTOS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011       All rights reserved worldwide
    Name:      MLS_PHOTOS_PKG
    Purpose:   API's for MLS_PHOTOS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        11-DEC-11   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_MLS_ID IN MLS_PHOTOS.MLS_ID%TYPE
                    , X_PHOTO_SEQ IN MLS_PHOTOS.PHOTO_SEQ%TYPE) is
     cursor c is
     select * from MLS_PHOTOS
     where MLS_ID = X_MLS_ID
    and PHOTO_SEQ = X_PHOTO_SEQ
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
  function get_checksum( X_MLS_ID IN MLS_PHOTOS.MLS_ID%TYPE
                       , X_PHOTO_SEQ IN MLS_PHOTOS.PHOTO_SEQ%TYPE)
            return MLS_PHOTOS_V.CHECKSUM%TYPE is

    v_return_value               MLS_PHOTOS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from MLS_PHOTOS_V
    where MLS_ID = X_MLS_ID
    and PHOTO_SEQ = X_PHOTO_SEQ;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_MLS_ID     IN MLS_PHOTOS.MLS_ID%TYPE
                      , X_PHOTO_SEQ  IN MLS_PHOTOS.PHOTO_SEQ%TYPE
                      , X_PHOTO_URL  IN MLS_PHOTOS.PHOTO_URL%TYPE
                      , X_PHOTO_DESC IN MLS_PHOTOS.PHOTO_DESC%TYPE
                      , X_CHECKSUM   IN MLS_PHOTOS_V.CHECKSUM%TYPE)
  is
     l_checksum          MLS_PHOTOS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_MLS_ID, X_PHOTO_SEQ);

      -- validate checksum
      l_checksum := get_checksum(X_MLS_ID, X_PHOTO_SEQ);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

     update MLS_PHOTOS
     set PHOTO_URL = X_PHOTO_URL
     , PHOTO_DESC = X_PHOTO_DESC
     where MLS_ID = X_MLS_ID
	 and PHOTO_SEQ = X_PHOTO_SEQ;

  end update_row;

  procedure insert_row( X_MLS_ID     IN MLS_PHOTOS.MLS_ID%TYPE
                      , X_PHOTO_SEQ  IN MLS_PHOTOS.PHOTO_SEQ%TYPE
                      , X_PHOTO_URL  IN MLS_PHOTOS.PHOTO_URL%TYPE
                      , X_PHOTO_DESC IN MLS_PHOTOS.PHOTO_DESC%TYPE)
  is
     
  begin

     insert into MLS_PHOTOS
     ( MLS_ID
     , PHOTO_SEQ
     , PHOTO_URL
     , PHOTO_DESC)
     values
     ( X_MLS_ID
     , X_PHOTO_SEQ
     , X_PHOTO_URL
     , X_PHOTO_DESC);

  end insert_row;

  procedure delete_row( X_MLS_ID    IN MLS_PHOTOS.MLS_ID%TYPE
                      , X_PHOTO_SEQ IN MLS_PHOTOS.PHOTO_SEQ%TYPE) is

  begin
    delete from MLS_PHOTOS
    where MLS_ID = X_MLS_ID
    and PHOTO_SEQ = X_PHOTO_SEQ;

  end delete_row;

end MLS_PHOTOS_PKG;
/

show errors package MLS_PHOTOS_PKG
show errors package body MLS_PHOTOS_PKG