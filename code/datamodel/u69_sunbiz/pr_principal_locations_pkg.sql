create or replace package PR_PRINCIPAL_LOCATIONS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011       All rights reserved worldwide
    Name:      PR_PRINCIPAL_LOCATIONS_PKG
    Purpose:   API's for PR_PRINCIPAL_LOCATIONS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        13-JUN-11   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_LOC_ID IN PR_PRINCIPAL_LOCATIONS.LOC_ID%TYPE
                       , X_PN_ID IN PR_PRINCIPAL_LOCATIONS.PN_ID%TYPE)
            return PR_PRINCIPAL_LOCATIONS_V.CHECKSUM%TYPE;

  procedure insert_row( X_LOC_ID IN PR_PRINCIPAL_LOCATIONS.LOC_ID%TYPE
                       , X_PN_ID IN PR_PRINCIPAL_LOCATIONS.PN_ID%TYPE);

  procedure delete_row( X_LOC_ID IN PR_PRINCIPAL_LOCATIONS.LOC_ID%TYPE
                       , X_PN_ID IN PR_PRINCIPAL_LOCATIONS.PN_ID%TYPE);

end PR_PRINCIPAL_LOCATIONS_PKG;
/
create or replace package body PR_PRINCIPAL_LOCATIONS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011       All rights reserved worldwide
    Name:      PR_PRINCIPAL_LOCATIONS_PKG
    Purpose:   API's for PR_PRINCIPAL_LOCATIONS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        13-JUN-11   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_LOC_ID IN PR_PRINCIPAL_LOCATIONS.LOC_ID%TYPE
                       , X_PN_ID IN PR_PRINCIPAL_LOCATIONS.PN_ID%TYPE) is
     cursor c is
     select * from PR_PRINCIPAL_LOCATIONS
     where LOC_ID = X_LOC_ID
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
  function get_checksum( X_LOC_ID IN PR_PRINCIPAL_LOCATIONS.LOC_ID%TYPE
                       , X_PN_ID IN PR_PRINCIPAL_LOCATIONS.PN_ID%TYPE)
            return PR_PRINCIPAL_LOCATIONS_V.CHECKSUM%TYPE is

    v_return_value               PR_PRINCIPAL_LOCATIONS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from PR_PRINCIPAL_LOCATIONS_V
    where LOC_ID = X_LOC_ID
    and PN_ID = X_PN_ID;
    return v_return_value;
  end get_checksum;

  procedure insert_row( X_LOC_ID IN PR_PRINCIPAL_LOCATIONS.LOC_ID%TYPE
                       , X_PN_ID IN PR_PRINCIPAL_LOCATIONS.PN_ID%TYPE)  is
  begin

     insert into PR_PRINCIPAL_LOCATIONS
     ( LOC_ID
     , PN_ID)
     values
     ( X_LOC_ID
     , X_PN_ID);

     
  end insert_row;

  procedure delete_row( X_LOC_ID IN PR_PRINCIPAL_LOCATIONS.LOC_ID%TYPE
                       , X_PN_ID IN PR_PRINCIPAL_LOCATIONS.PN_ID%TYPE) is

  begin
    delete from PR_PRINCIPAL_LOCATIONS
    where LOC_ID = X_LOC_ID
    and PN_ID = X_PN_ID;

  end delete_row;

end PR_PRINCIPAL_LOCATIONS_PKG;
/

show errors package PR_PRINCIPAL_LOCATIONS_PKG
show errors package body PR_PRINCIPAL_LOCATIONS_PKG