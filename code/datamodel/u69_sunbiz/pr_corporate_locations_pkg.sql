create or replace package PR_CORPORATE_LOCATIONS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011       All rights reserved worldwide
    Name:      PR_CORPORATE_LOCATIONS_PKG
    Purpose:   API's for PR_CORPORATE_LOCATIONS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        13-JUN-11   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_LOC_ID IN PR_CORPORATE_LOCATIONS.LOC_ID%TYPE
                       , X_CORP_NUMBER IN PR_CORPORATE_LOCATIONS.CORP_NUMBER%TYPE)
            return PR_CORPORATE_LOCATIONS_V.CHECKSUM%TYPE;

  procedure insert_row( X_LOC_ID IN PR_CORPORATE_LOCATIONS.LOC_ID%TYPE
                       , X_CORP_NUMBER IN PR_CORPORATE_LOCATIONS.CORP_NUMBER%TYPE
					   , X_LOC_TYPE IN PR_CORPORATE_LOCATIONS.LOC_TYPE%TYPE);

  procedure delete_row( X_LOC_ID IN PR_CORPORATE_LOCATIONS.LOC_ID%TYPE
                       , X_CORP_NUMBER IN PR_CORPORATE_LOCATIONS.CORP_NUMBER%TYPE
					   , X_LOC_TYPE IN PR_CORPORATE_LOCATIONS.LOC_TYPE%TYPE);

end PR_CORPORATE_LOCATIONS_PKG;
/
create or replace package body PR_CORPORATE_LOCATIONS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011       All rights reserved worldwide
    Name:      PR_CORPORATE_LOCATIONS_PKG
    Purpose:   API's for PR_CORPORATE_LOCATIONS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        13-JUN-11   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_LOC_ID IN PR_CORPORATE_LOCATIONS.LOC_ID%TYPE
                       , X_CORP_NUMBER IN PR_CORPORATE_LOCATIONS.CORP_NUMBER%TYPE) is
     cursor c is
     select * from PR_CORPORATE_LOCATIONS
     where LOC_ID = X_LOC_ID
    and CORP_NUMBER = X_CORP_NUMBER
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
  function get_checksum( X_LOC_ID IN PR_CORPORATE_LOCATIONS.LOC_ID%TYPE
                       , X_CORP_NUMBER IN PR_CORPORATE_LOCATIONS.CORP_NUMBER%TYPE)
            return PR_CORPORATE_LOCATIONS_V.CHECKSUM%TYPE is

    v_return_value               PR_CORPORATE_LOCATIONS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from PR_CORPORATE_LOCATIONS_V
    where LOC_ID = X_LOC_ID
    and CORP_NUMBER = X_CORP_NUMBER;
    return v_return_value;
  end get_checksum;


  procedure insert_row( X_LOC_ID IN PR_CORPORATE_LOCATIONS.LOC_ID%TYPE
                      , X_CORP_NUMBER IN PR_CORPORATE_LOCATIONS.CORP_NUMBER%TYPE
					  , X_LOC_TYPE IN PR_CORPORATE_LOCATIONS.LOC_TYPE%TYPE)  is
     
  begin

     insert into PR_CORPORATE_LOCATIONS
     ( LOC_ID
     , CORP_NUMBER
	 , loc_type)
     values
     ( X_LOC_ID
     , X_CORP_NUMBER
	 , x_loc_type);

     
  end insert_row;

  procedure delete_row( X_LOC_ID IN PR_CORPORATE_LOCATIONS.LOC_ID%TYPE
                       , X_CORP_NUMBER IN PR_CORPORATE_LOCATIONS.CORP_NUMBER%TYPE
					   , X_LOC_TYPE IN PR_CORPORATE_LOCATIONS.LOC_TYPE%TYPE) is

  begin
    delete from PR_CORPORATE_LOCATIONS
    where LOC_ID = X_LOC_ID
    and CORP_NUMBER = X_CORP_NUMBER
	and loc_type = x_loc_type;

  end delete_row;

end PR_CORPORATE_LOCATIONS_PKG;
/

show errors package PR_CORPORATE_LOCATIONS_PKG
show errors package body PR_CORPORATE_LOCATIONS_PKG