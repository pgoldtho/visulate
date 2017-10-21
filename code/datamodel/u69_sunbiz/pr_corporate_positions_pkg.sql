create or replace package PR_CORPORATE_POSITIONS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011       All rights reserved worldwide
    Name:      PR_CORPORATE_POSITIONS_PKG
    Purpose:   API's for PR_CORPORATE_POSITIONS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        14-JUN-11   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_CORP_NUMBER IN PR_CORPORATE_POSITIONS.CORP_NUMBER%TYPE
                       , X_PN_ID IN PR_CORPORATE_POSITIONS.PN_ID%TYPE)
            return PR_CORPORATE_POSITIONS_V.CHECKSUM%TYPE;

  procedure update_row( X_CORP_NUMBER IN PR_CORPORATE_POSITIONS.CORP_NUMBER%TYPE
                      , X_PN_ID IN PR_CORPORATE_POSITIONS.PN_ID%TYPE
                      , X_TITLE_CODE IN PR_CORPORATE_POSITIONS.TITLE_CODE%TYPE
                      , X_CHECKSUM IN PR_CORPORATE_POSITIONS_V.CHECKSUM%TYPE);

  procedure  insert_row( X_CORP_NUMBER IN PR_CORPORATE_POSITIONS.CORP_NUMBER%TYPE
                     , X_PN_ID IN PR_CORPORATE_POSITIONS.PN_ID%TYPE
                     , X_TITLE_CODE IN PR_CORPORATE_POSITIONS.TITLE_CODE%TYPE);

  procedure delete_row( X_CORP_NUMBER IN PR_CORPORATE_POSITIONS.CORP_NUMBER%TYPE
                       , X_PN_ID IN PR_CORPORATE_POSITIONS.PN_ID%TYPE);

end PR_CORPORATE_POSITIONS_PKG;
/
create or replace package body PR_CORPORATE_POSITIONS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011       All rights reserved worldwide
    Name:      PR_CORPORATE_POSITIONS_PKG
    Purpose:   API's for PR_CORPORATE_POSITIONS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        14-JUN-11   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_CORP_NUMBER IN PR_CORPORATE_POSITIONS.CORP_NUMBER%TYPE
                       , X_PN_ID IN PR_CORPORATE_POSITIONS.PN_ID%TYPE) is
     cursor c is
     select * from PR_CORPORATE_POSITIONS
     where CORP_NUMBER = X_CORP_NUMBER
    and PN_ID = X_PN_ID
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
  function get_checksum( X_CORP_NUMBER IN PR_CORPORATE_POSITIONS.CORP_NUMBER%TYPE
                       , X_PN_ID IN PR_CORPORATE_POSITIONS.PN_ID%TYPE)
            return PR_CORPORATE_POSITIONS_V.CHECKSUM%TYPE is

    v_return_value               PR_CORPORATE_POSITIONS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from PR_CORPORATE_POSITIONS_V
    where CORP_NUMBER = X_CORP_NUMBER
    and PN_ID = X_PN_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_CORP_NUMBER IN PR_CORPORATE_POSITIONS.CORP_NUMBER%TYPE
                      , X_PN_ID IN PR_CORPORATE_POSITIONS.PN_ID%TYPE
                      , X_TITLE_CODE IN PR_CORPORATE_POSITIONS.TITLE_CODE%TYPE
                      , X_CHECKSUM IN PR_CORPORATE_POSITIONS_V.CHECKSUM%TYPE)
  is
     l_checksum          PR_CORPORATE_POSITIONS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_CORP_NUMBER, X_PN_ID);

      -- validate checksum
      l_checksum := get_checksum(X_CORP_NUMBER, X_PN_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

     update PR_CORPORATE_POSITIONS
     set PN_ID = X_PN_ID
     , TITLE_CODE = X_TITLE_CODE
     where CORP_NUMBER = X_CORP_NUMBER;

  end update_row;

  procedure  insert_row( X_CORP_NUMBER IN PR_CORPORATE_POSITIONS.CORP_NUMBER%TYPE
                     , X_PN_ID IN PR_CORPORATE_POSITIONS.PN_ID%TYPE
                     , X_TITLE_CODE IN PR_CORPORATE_POSITIONS.TITLE_CODE%TYPE)
  is
     x          number;
  begin

     insert into PR_CORPORATE_POSITIONS
     ( CORP_NUMBER
     , PN_ID
     , TITLE_CODE)
     values
     ( X_CORP_NUMBER
     , X_PN_ID
     , X_TITLE_CODE);

  end insert_row;

  procedure delete_row( X_CORP_NUMBER IN PR_CORPORATE_POSITIONS.CORP_NUMBER%TYPE
                       , X_PN_ID IN PR_CORPORATE_POSITIONS.PN_ID%TYPE) is

  begin
    delete from PR_CORPORATE_POSITIONS
    where CORP_NUMBER = X_CORP_NUMBER
    and PN_ID = X_PN_ID;

  end delete_row;

end PR_CORPORATE_POSITIONS_PKG;
/

show errors package PR_CORPORATE_POSITIONS_PKG
show errors package body PR_CORPORATE_POSITIONS_PKG