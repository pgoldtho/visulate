create or replace package RNT_REGIONS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2013       All rights reserved worldwide
    Name:      RNT_REGIONS_PKG
    Purpose:   API's for RNT_REGIONS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        21-SEP-13   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_REGION_ID IN RNT_REGIONS.REGION_ID%TYPE)
            return RNT_REGIONS_V.CHECKSUM%TYPE;

  procedure update_row( X_REGION_ID IN RNT_REGIONS.REGION_ID%TYPE
                      , X_NAME IN RNT_REGIONS.NAME%TYPE
                      , X_DESCRIPTION IN RNT_REGIONS.DESCRIPTION%TYPE
                      , X_REPORT_DATA IN RNT_REGIONS.REPORT_DATA%TYPE
                      , X_CHECKSUM IN RNT_REGIONS_V.CHECKSUM%TYPE);

  function  insert_row( X_NAME IN RNT_REGIONS.NAME%TYPE
                     , X_DESCRIPTION IN RNT_REGIONS.DESCRIPTION%TYPE
                     , X_REPORT_DATA IN RNT_REGIONS.REPORT_DATA%TYPE)
              return RNT_REGIONS.REGION_ID%TYPE;

  procedure delete_row( X_REGION_ID IN RNT_REGIONS.REGION_ID%TYPE);

end RNT_REGIONS_PKG;
/
create or replace package body RNT_REGIONS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2013       All rights reserved worldwide
    Name:      RNT_REGIONS_PKG
    Purpose:   API's for RNT_REGIONS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        21-SEP-13   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------
  function check_unique( X_REGION_ID IN RNT_REGIONS.REGION_ID%TYPE
                       , X_NAME IN RNT_REGIONS.NAME%TYPE) return boolean is
        cursor c is
        select REGION_ID
        from RNT_REGIONS
        where NAME = X_NAME;

      begin
         for c_rec in c loop
           if (X_REGION_ID is null OR c_rec.REGION_ID != X_REGION_ID) then
             return false;
           end if;
         end loop;
         return true;
      end check_unique;

  procedure lock_row( X_REGION_ID IN RNT_REGIONS.REGION_ID%TYPE) is
     cursor c is
     select * from RNT_REGIONS
     where REGION_ID = X_REGION_ID
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
  function get_checksum( X_REGION_ID IN RNT_REGIONS.REGION_ID%TYPE)
            return RNT_REGIONS_V.CHECKSUM%TYPE is

    v_return_value               RNT_REGIONS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_REGIONS_V
    where REGION_ID = X_REGION_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_REGION_ID IN RNT_REGIONS.REGION_ID%TYPE
                      , X_NAME IN RNT_REGIONS.NAME%TYPE
                      , X_DESCRIPTION IN RNT_REGIONS.DESCRIPTION%TYPE
                      , X_REPORT_DATA IN RNT_REGIONS.REPORT_DATA%TYPE
                      , X_CHECKSUM IN RNT_REGIONS_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_REGIONS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_REGION_ID);

      -- validate checksum
      l_checksum := get_checksum(X_REGION_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

         if not check_unique(X_REGION_ID, X_NAME) then
             RAISE_APPLICATION_ERROR(-20006, 'Update values must be unique.');
         end if;
     update RNT_REGIONS
     set NAME = X_NAME
     , DESCRIPTION = X_DESCRIPTION
     , REPORT_DATA = X_REPORT_DATA
     where REGION_ID = X_REGION_ID;

  end update_row;

  function  insert_row( X_NAME IN RNT_REGIONS.NAME%TYPE
                     , X_DESCRIPTION IN RNT_REGIONS.DESCRIPTION%TYPE
                     , X_REPORT_DATA IN RNT_REGIONS.REPORT_DATA%TYPE)
              return RNT_REGIONS.REGION_ID%TYPE
  is
     x          number;
  begin
if not check_unique(NULL, X_NAME) then
         RAISE_APPLICATION_ERROR(-20006, 'Insert values must be unique.');
     end if;

     insert into RNT_REGIONS
     ( REGION_ID
     , NAME
     , DESCRIPTION
     , REPORT_DATA)
     values
     ( RNT_REGIONS_SEQ.NEXTVAL
     , X_NAME
     , X_DESCRIPTION
     , X_REPORT_DATA)
     returning REGION_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_REGION_ID IN RNT_REGIONS.REGION_ID%TYPE) is

  begin
    delete from RNT_REGIONS
    where REGION_ID = X_REGION_ID;

  end delete_row;

end RNT_REGIONS_PKG;
/


show errors package RNT_REGIONS_PKG
show errors package body RNT_REGIONS_PKG