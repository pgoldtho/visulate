create or replace package PR_LOCATIONS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011       All rights reserved worldwide
    Name:      PR_LOCATIONS_PKG
    Purpose:   API's for PR_LOCATIONS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        14-JUN-11   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_LOC_ID IN PR_LOCATIONS.LOC_ID%TYPE)
            return PR_LOCATIONS_V.CHECKSUM%TYPE;

  procedure update_row( X_LOC_ID IN PR_LOCATIONS.LOC_ID%TYPE
                      , X_ADDRESS1 IN PR_LOCATIONS.ADDRESS1%TYPE
                      , X_ADDRESS2 IN PR_LOCATIONS.ADDRESS2%TYPE
                      , X_CITY IN PR_LOCATIONS.CITY%TYPE
                      , X_STATE IN PR_LOCATIONS.STATE%TYPE
                      , X_ZIPCODE IN PR_LOCATIONS.ZIPCODE%TYPE
                      , X_ZIP4 IN PR_LOCATIONS.ZIP4%TYPE
                      , X_COUNTRY IN PR_LOCATIONS.COUNTRY%TYPE
                      , X_PROP_ID IN PR_LOCATIONS.PROP_ID%TYPE
                      , x_geo_location in PR_LOCATIONS.GEO_LOCATION%TYPE := null
                      , x_geo_found_yn in PR_LOCATIONS.GEO_FOUND_YN%TYPE := 'N'
                      , X_CHECKSUM IN PR_LOCATIONS_V.CHECKSUM%TYPE);

  function  insert_row( X_ADDRESS1 IN PR_LOCATIONS.ADDRESS1%TYPE
                     , X_ADDRESS2 IN PR_LOCATIONS.ADDRESS2%TYPE
                     , X_CITY IN PR_LOCATIONS.CITY%TYPE
                     , X_STATE IN PR_LOCATIONS.STATE%TYPE
                     , X_ZIPCODE IN PR_LOCATIONS.ZIPCODE%TYPE
                     , X_ZIP4 IN PR_LOCATIONS.ZIP4%TYPE
                     , X_COUNTRY IN PR_LOCATIONS.COUNTRY%TYPE
                     , X_PROP_ID IN PR_LOCATIONS.PROP_ID%TYPE
                     , x_geo_location in PR_LOCATIONS.GEO_LOCATION%TYPE := null
                     , x_geo_found_yn in PR_LOCATIONS.GEO_FOUND_YN%TYPE := 'N')
              return PR_LOCATIONS.LOC_ID%TYPE;
			  
  function  get_locid( X_ADDRESS1 IN PR_LOCATIONS.ADDRESS1%TYPE
                     , X_ADDRESS2 IN PR_LOCATIONS.ADDRESS2%TYPE
                     , X_ZIPCODE IN PR_LOCATIONS.ZIPCODE%TYPE)
              return PR_LOCATIONS.LOC_ID%TYPE;  
			  
  procedure insert_corp_location
                     ( X_ADDRESS1    IN PR_LOCATIONS.ADDRESS1%TYPE
                     , X_ADDRESS2    IN PR_LOCATIONS.ADDRESS2%TYPE
                     , X_CITY        IN PR_LOCATIONS.CITY%TYPE
                     , X_STATE       IN PR_LOCATIONS.STATE%TYPE
                     , X_ZIPCODE     IN   varchar2
                     , X_ZIP4        IN   varchar2
                     , X_COUNTRY     IN PR_LOCATIONS.COUNTRY%TYPE
		     , X_CORP_NUMBER IN PR_CORPORATIONS.CORP_NUMBER%TYPE
		     , X_LOC_TYPE    IN PR_CORPORATE_LOCATIONS.LOC_TYPE%TYPE
		     , x_geo_location in PR_LOCATIONS.GEO_LOCATION%TYPE := null
                     , x_geo_found_yn in PR_LOCATIONS.GEO_FOUND_YN%TYPE := 'N');
					 
  procedure update_corp_location
                     ( X_ADDRESS1    IN PR_LOCATIONS.ADDRESS1%TYPE
                     , X_ADDRESS2    IN PR_LOCATIONS.ADDRESS2%TYPE
                     , X_CITY        IN PR_LOCATIONS.CITY%TYPE
                     , X_STATE       IN PR_LOCATIONS.STATE%TYPE
                     , X_ZIPCODE     IN   varchar2
                     , X_ZIP4        IN   varchar2
                     , x_prop_id     in pr_properties.prop_id%type
                     , X_COUNTRY     IN PR_LOCATIONS.COUNTRY%TYPE
                     , X_CORP_NUMBER IN PR_CORPORATIONS.CORP_NUMBER%TYPE
                     , X_LOC_TYPE    IN PR_CORPORATE_LOCATIONS.LOC_TYPE%TYPE
                     , x_geo_location in PR_LOCATIONS.GEO_LOCATION%TYPE := null
                     , x_geo_found_yn in PR_LOCATIONS.GEO_FOUND_YN%TYPE := 'N');
					 
  procedure insert_principal_location
                     ( X_ADDRESS1 IN PR_LOCATIONS.ADDRESS1%TYPE
                     , X_ADDRESS2 IN PR_LOCATIONS.ADDRESS2%TYPE
                     , X_CITY IN PR_LOCATIONS.CITY%TYPE
                     , X_STATE IN PR_LOCATIONS.STATE%TYPE
                     , X_ZIPCODE IN   varchar2
                     , X_ZIP4 IN   varchar2
                     , X_COUNTRY IN PR_LOCATIONS.COUNTRY%TYPE
		     , X_PN_TYPE IN PR_PRINCIPALS.PN_TYPE%TYPE
                     , X_PN_NAME IN PR_PRINCIPALS.PN_NAME%TYPE
		     , X_CORP_NUMBER IN PR_CORPORATIONS.CORP_NUMBER%TYPE
		     , X_TITLE_CODE IN PR_CORPORATE_POSITIONS.TITLE_CODE%TYPE
		     , x_geo_location in PR_LOCATIONS.GEO_LOCATION%TYPE := null
                     , x_geo_found_yn in PR_LOCATIONS.GEO_FOUND_YN%TYPE := 'N');
					 
  procedure delete_row( X_LOC_ID IN PR_LOCATIONS.LOC_ID%TYPE);

end PR_LOCATIONS_PKG;
/
create or replace package body PR_LOCATIONS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011       All rights reserved worldwide
    Name:      PR_LOCATIONS_PKG
    Purpose:   API's for PR_LOCATIONS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        14-JUN-11   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------
  function check_unique( X_LOC_ID IN PR_LOCATIONS.LOC_ID%TYPE
                       , X_ADDRESS1 IN PR_LOCATIONS.ADDRESS1%TYPE
                       , X_ADDRESS2 IN PR_LOCATIONS.ADDRESS2%TYPE
                       , X_ZIPCODE IN PR_LOCATIONS.ZIPCODE%TYPE) return boolean is
        cursor c is
        select LOC_ID
        from PR_LOCATIONS
        where ADDRESS1 = X_ADDRESS1
    and ADDRESS2 = X_ADDRESS2
    and ZIPCODE = X_ZIPCODE;

      begin
         for c_rec in c loop
           if (X_LOC_ID is null OR c_rec.LOC_ID != X_LOC_ID) then
             return false;
           end if;
         end loop;
         return true;
      end check_unique;
	  
  function isnumeric ( p_string in varchar2) 
    return boolean as
	x  integer;
  begin
    x := p_string;
	return true;
  exception
    when others then return false;
  end;	  

  procedure lock_row( X_LOC_ID IN PR_LOCATIONS.LOC_ID%TYPE) is
     cursor c is
     select * from PR_LOCATIONS
     where LOC_ID = X_LOC_ID
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
  function get_checksum( X_LOC_ID IN PR_LOCATIONS.LOC_ID%TYPE)
            return PR_LOCATIONS_V.CHECKSUM%TYPE is

    v_return_value               PR_LOCATIONS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from PR_LOCATIONS_V
    where LOC_ID = X_LOC_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_LOC_ID IN PR_LOCATIONS.LOC_ID%TYPE
                      , X_ADDRESS1 IN PR_LOCATIONS.ADDRESS1%TYPE
                      , X_ADDRESS2 IN PR_LOCATIONS.ADDRESS2%TYPE
                      , X_CITY IN PR_LOCATIONS.CITY%TYPE
                      , X_STATE IN PR_LOCATIONS.STATE%TYPE
                      , X_ZIPCODE IN PR_LOCATIONS.ZIPCODE%TYPE
                      , X_ZIP4 IN PR_LOCATIONS.ZIP4%TYPE
                      , X_COUNTRY IN PR_LOCATIONS.COUNTRY%TYPE
                      , X_PROP_ID IN PR_LOCATIONS.PROP_ID%TYPE
                      , x_geo_location in PR_LOCATIONS.GEO_LOCATION%TYPE := null
                      , x_geo_found_yn in PR_LOCATIONS.GEO_FOUND_YN%TYPE := 'N'
                      , X_CHECKSUM IN PR_LOCATIONS_V.CHECKSUM%TYPE)
  is
     l_checksum          PR_LOCATIONS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_LOC_ID);

      -- validate checksum
      l_checksum := get_checksum(X_LOC_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

         if not check_unique(X_LOC_ID, X_ADDRESS1, X_ADDRESS2, X_ZIPCODE) then
             RAISE_APPLICATION_ERROR(-20006, 'Update values must be unique.');
         end if;
     update PR_LOCATIONS
     set ADDRESS1 = X_ADDRESS1
     , ADDRESS2 = X_ADDRESS2
     , CITY = X_CITY
     , STATE = X_STATE
     , ZIPCODE = X_ZIPCODE
     , ZIP4 = X_ZIP4
     , COUNTRY = X_COUNTRY
     , PROP_ID = X_PROP_ID
     , geo_location = x_geo_location
     , geo_found_yn = x_geo_found_yn
     where LOC_ID = X_LOC_ID;

  end update_row;

  function  insert_row( X_ADDRESS1 IN PR_LOCATIONS.ADDRESS1%TYPE
                     , X_ADDRESS2 IN PR_LOCATIONS.ADDRESS2%TYPE
                     , X_CITY IN PR_LOCATIONS.CITY%TYPE
                     , X_STATE IN PR_LOCATIONS.STATE%TYPE
                     , X_ZIPCODE IN PR_LOCATIONS.ZIPCODE%TYPE
                     , X_ZIP4 IN PR_LOCATIONS.ZIP4%TYPE
                     , X_COUNTRY IN PR_LOCATIONS.COUNTRY%TYPE
                     , X_PROP_ID IN PR_LOCATIONS.PROP_ID%TYPE
                     , x_geo_location in PR_LOCATIONS.GEO_LOCATION%TYPE := null
                     , x_geo_found_yn in PR_LOCATIONS.GEO_FOUND_YN%TYPE := 'N')
              return PR_LOCATIONS.LOC_ID%TYPE
  is
     x          number;
  begin
if not check_unique(NULL, X_ADDRESS1, X_ADDRESS2, X_ZIPCODE) then
         RAISE_APPLICATION_ERROR(-20006, 'Insert values must be unique.');
     end if;

     insert into PR_LOCATIONS
     ( LOC_ID
     , ADDRESS1
     , ADDRESS2
     , CITY
     , STATE
     , ZIPCODE
     , ZIP4
     , COUNTRY
     , PROP_ID
     , geo_location
     , geo_found_yn)
     values
     ( PR_LOCATIONS_SEQ.NEXTVAL
     , X_ADDRESS1
     , X_ADDRESS2
     , X_CITY
     , X_STATE
     , X_ZIPCODE
     , X_ZIP4
     , X_COUNTRY
     , X_PROP_ID
     , x_geo_location
     , x_geo_found_yn)
     returning LOC_ID into x;

     return x;
  end insert_row;
  
  function  get_locid( X_ADDRESS1 IN PR_LOCATIONS.ADDRESS1%TYPE
                       , X_ADDRESS2 IN PR_LOCATIONS.ADDRESS2%TYPE
                       , X_ZIPCODE IN PR_LOCATIONS.ZIPCODE%TYPE)
              return PR_LOCATIONS.LOC_ID%TYPE is
	  v_return   PR_LOCATIONS.LOC_ID%TYPE;
    begin
	  if x_address2 is not null then
        select loc_id
	    into v_return
	    from pr_locations
	    where address1 = x_address1
	    and address2 = x_address2
	    and ZIPCODE = x_ZIPCODE
	    and rownum = 1;
	  else
        select loc_id
	    into v_return
	    from pr_locations
	    where address1 = x_address1
	    and ZIPCODE = x_ZIPCODE
	    and address2 is null
	    and rownum = 1;	  
	  end if;
	
	return v_return;
  exception
    when no_data_found then return null;
	when others then raise;
  end get_locid;			  

procedure insert_corp_location
                     ( X_ADDRESS1 IN PR_LOCATIONS.ADDRESS1%TYPE
                     , X_ADDRESS2 IN PR_LOCATIONS.ADDRESS2%TYPE
                     , X_CITY IN PR_LOCATIONS.CITY%TYPE
                     , X_STATE IN PR_LOCATIONS.STATE%TYPE
                     , X_ZIPCODE IN   varchar2
                     , X_ZIP4 IN   varchar2
                     , X_COUNTRY IN PR_LOCATIONS.COUNTRY%TYPE
		     , X_CORP_NUMBER IN PR_CORPORATIONS.CORP_NUMBER%TYPE
		     , X_LOC_TYPE IN PR_CORPORATE_LOCATIONS.LOC_TYPE%TYPE
		     , x_geo_location in PR_LOCATIONS.GEO_LOCATION%TYPE := null
                     , x_geo_found_yn in PR_LOCATIONS.GEO_FOUND_YN%TYPE := 'N') is
	 v_locid          PR_LOCATIONS.LOC_ID%TYPE;
	 v_count          pls_integer;
	 invalid_address  exception;
  begin
--  dbms_output.put_line(X_CORP_NUMBER||' '||X_ADDRESS1||', '||X_ADDRESS2||', '||X_ZIPCODE);
    if X_ADDRESS1 is null 
	   or x_ZIPCODE is  null 
	   or length(x_ZIPCODE) != 5
	   or isnumeric(x_ZIPCODE) != TRUE  
	   or isnumeric(x_zip4) != TRUE  then
	   raise invalid_address;
	end if;
    v_locid := get_locid( X_ADDRESS1, X_ADDRESS2, X_ZIPCODE);
    
    if v_locid is null then
	  v_locid := pr_locations_pkg.insert_row
	                 ( X_ADDRESS1     => X_ADDRESS1
                         , X_ADDRESS2     => X_ADDRESS2
                         , X_CITY         => X_CITY
                         , X_STATE        => X_STATE
                         , X_ZIPCODE      => X_ZIPCODE
                         , X_ZIP4         => X_ZIP4
                         , X_COUNTRY      => X_COUNTRY
			 , X_PROP_ID      => null
			 , x_geo_location => x_geo_location
			 , x_geo_found_yn => x_geo_found_yn);
	end if;
	
	select count(*)
	into v_count 
	from pr_corporate_locations
	where LOC_ID = v_locid
        and CORP_NUMBER = X_CORP_NUMBER
        and LOC_TYPE = X_LOC_TYPE;
	
	if v_count = 0 then
	  pr_corporate_locations_pkg.insert_row
	    ( X_LOC_ID => v_locid
            , X_CORP_NUMBER => X_CORP_NUMBER
	    , X_LOC_TYPE => X_LOC_TYPE );
	end if;
	
  exception when invalid_address then
	dbms_output.put_line('Invalid Address: '||X_CORP_NUMBER||' '||X_ADDRESS1||', '||X_ADDRESS2||', '||X_ZIPCODE);
      null;
	when DUP_VAL_ON_INDEX then null;
    when others then
    dbms_output.put_line(sqlerrm);
	dbms_output.put_line(X_CORP_NUMBER||' '||X_ADDRESS1||', '||X_ADDRESS2||', '||X_ZIPCODE);
	raise;	
  end insert_corp_location;
  
  procedure update_corp_location
                     ( X_ADDRESS1    IN PR_LOCATIONS.ADDRESS1%TYPE
                     , X_ADDRESS2    IN PR_LOCATIONS.ADDRESS2%TYPE
                     , X_CITY        IN PR_LOCATIONS.CITY%TYPE
                     , X_STATE       IN PR_LOCATIONS.STATE%TYPE
                     , X_ZIPCODE     IN   varchar2
                     , X_ZIP4        IN   varchar2
                     , x_prop_id     in pr_properties.prop_id%type
                     , X_COUNTRY     IN PR_LOCATIONS.COUNTRY%TYPE
                     , X_CORP_NUMBER IN PR_CORPORATIONS.CORP_NUMBER%TYPE
                     , X_LOC_TYPE    IN PR_CORPORATE_LOCATIONS.LOC_TYPE%TYPE
                     , x_geo_location in PR_LOCATIONS.GEO_LOCATION%TYPE := null
                     , x_geo_found_yn in PR_LOCATIONS.GEO_FOUND_YN%TYPE := 'N') is
                     
    v_loc_id         pr_locations.loc_id%type;
    v_count          pls_integer;
  begin
  /*
    select loc_id
    into v_loc_id
    from pr_corporate_locations
    where corp_number = X_CORP_NUMBER
    and loc_type = X_LOC_TYPE
    and rownum = 1;
    
    
      update pr_locations
      set ADDRESS1 = upper(X_ADDRESS1)
      ,   ADDRESS2 = upper(X_ADDRESS2)
      ,   CITY     = upper(X_CITY)
      ,   STATE    = upper(X_STATE)
      ,   ZIPCODE  = X_ZIPCODE
      ,   ZIP4     = X_ZIP4
      ,   COUNTRY  = upper(X_COUNTRY)
      ,   prop_id  = x_prop_id
      ,   GEO_LOCATION = x_geo_location 
      ,   GEO_FOUND_YN = x_geo_found_yn 
      where LOC_ID = v_loc_id;
    else
    */
      delete from pr_corporate_locations
      where corp_number = X_CORP_NUMBER
      and loc_type = X_LOC_TYPE;
      
      pr_locations_pkg.insert_corp_location
                     ( X_ADDRESS1     => upper(X_ADDRESS1)
                     , X_ADDRESS2     => upper(X_ADDRESS2)
                     , X_CITY         => upper(X_CITY)
                     , X_STATE        => upper(X_STATE)
                     , X_ZIPCODE      => X_ZIPCODE
                     , X_ZIP4         => X_ZIP4
                     , X_COUNTRY      => upper(X_COUNTRY)
                     , X_CORP_NUMBER  => X_CORP_NUMBER
                     , X_LOC_TYPE     =>  X_LOC_TYPE
                     , x_geo_location => x_geo_location
                     , x_geo_found_yn => x_geo_found_yn
                     );
/*                     
      select loc_id
      into v_loc_id
      from pr_corporate_locations
      where corp_number = X_CORP_NUMBER
      and loc_type = X_LOC_TYPE;
  */    
      update pr_locations
      set STATE    = upper(X_STATE)
      ,   prop_id  = x_prop_id
      ,   GEO_LOCATION = x_geo_location 
      ,   GEO_FOUND_YN = x_geo_found_yn 
      where address1 =  upper(X_ADDRESS1)
      and nvl(address2, ' ') = nvl(upper(X_ADDRESS2), ' ')
      and zipcode = X_ZIPCODE;
    
    /*
      update pr_locations
      set ADDRESS1 = upper(X_ADDRESS1)
      ,   ADDRESS2 = upper(X_ADDRESS2)
      ,   CITY     = upper(X_CITY)
      ,   STATE    = upper(X_STATE)
      ,   ZIPCODE  = X_ZIPCODE
      ,   ZIP4     = X_ZIP4
      ,   COUNTRY  = upper(X_COUNTRY)
      ,   prop_id  = x_prop_id
      ,   GEO_LOCATION = x_geo_location 
      ,   GEO_FOUND_YN = x_geo_found_yn 
      where LOC_ID = v_loc_id;
*/                     
    --end if;
  end update_corp_location;
                     
                     
  procedure insert_principal_location
                     ( X_ADDRESS1     IN PR_LOCATIONS.ADDRESS1%TYPE
                     , X_ADDRESS2     IN PR_LOCATIONS.ADDRESS2%TYPE
                     , X_CITY         IN PR_LOCATIONS.CITY%TYPE
                     , X_STATE        IN PR_LOCATIONS.STATE%TYPE
                     , X_ZIPCODE      IN   varchar2
                     , X_ZIP4         IN   varchar2
                     , X_COUNTRY      IN PR_LOCATIONS.COUNTRY%TYPE
		     , X_PN_TYPE      IN PR_PRINCIPALS.PN_TYPE%TYPE
                     , X_PN_NAME      IN PR_PRINCIPALS.PN_NAME%TYPE
		     , X_CORP_NUMBER  IN PR_CORPORATIONS.CORP_NUMBER%TYPE
		     , X_TITLE_CODE   IN PR_CORPORATE_POSITIONS.TITLE_CODE%TYPE
		     , x_geo_location in PR_LOCATIONS.GEO_LOCATION%TYPE := null
                     , x_geo_found_yn in PR_LOCATIONS.GEO_FOUND_YN%TYPE := 'N') is
                     
	v_locid          PR_LOCATIONS.LOC_ID%TYPE;
	v_pnid           PR_PRINCIPALS.PN_ID%TYPE;
	v_count          pls_integer;
	invalid_address  exception;
  begin
  -- dbms_output.put_line(X_CORP_NUMBER||'(p) '||X_ADDRESS1||', '||X_ADDRESS2||', '||X_ZIPCODE);
    if X_ADDRESS1 is null 
      or x_ZIPCODE is  null
      or length(x_ZIPCODE) != 5
      or isnumeric(x_ZIPCODE) != TRUE
      or isnumeric(x_zip4) != TRUE
      or X_PN_NAME is null then  raise invalid_address;
    end if;
    v_locid := get_locid( X_ADDRESS1
	                , X_ADDRESS2
			, X_ZIPCODE);
    if v_locid is null then
       v_locid := pr_locations_pkg.insert_row
                         ( X_ADDRESS1     => X_ADDRESS1
                         , X_ADDRESS2     => X_ADDRESS2
                         , X_CITY         => X_CITY
                         , X_STATE        => X_STATE
                         , X_ZIPCODE      => X_ZIPCODE
                         , X_ZIP4         => X_ZIP4
                         , X_COUNTRY      => X_COUNTRY
  		         , X_PROP_ID      => null
  		         , x_geo_location => x_geo_location
  		         , x_geo_found_yn => x_geo_found_yn);
	end if;


	v_pnid := PR_PRINCIPALS_PKG.get_pnid( X_PN_TYPE => X_PN_TYPE
                                            , X_PN_NAME => X_PN_NAME);

	if (v_pnid is null) then
	   v_pnid := PR_PRINCIPALS_PKG.INSERT_ROW( X_PN_TYPE => X_PN_TYPE
                                  , X_PN_NAME => X_PN_NAME);
	end if;
	
	select count(*) 
	into v_count
	from pr_principal_locations
	where LOC_ID = v_locid 
    and  PN_ID  = v_pnid;
	
	if v_count = 0 then
	  pr_principal_locations_pkg.insert_row
	    ( X_LOC_ID => v_locid 
		, X_PN_ID  => v_pnid);
	end if;

	select count(*) 
	into v_count
	from pr_corporate_positions
	where  CORP_NUMBER = X_CORP_NUMBER
	and PN_ID = v_pnid;
	
	if v_count = 0 then
	  pr_corporate_positions_pkg.insert_row
		     ( X_CORP_NUMBER => X_CORP_NUMBER
                     , X_PN_ID => v_pnid
                     , X_TITLE_CODE => X_TITLE_CODE);
	end if;
					 
	
  exception when invalid_address then
    null;
	-- dbms_output.put_line('Invalid Address: '||X_CORP_NUMBER||' '||X_ADDRESS1||', '||X_ADDRESS2||', '||X_ZIPCODE);
	when DUP_VAL_ON_INDEX then null;
    when others then
    dbms_output.put_line(sqlerrm||chr(10)|| ' '||X_CORP_NUMBER||' '||X_ADDRESS1||', '||X_ADDRESS2||', '||X_ZIPCODE);
	raise;
  end insert_principal_location;

  
  procedure delete_row( X_LOC_ID IN PR_LOCATIONS.LOC_ID%TYPE) is

  begin
    delete from PR_LOCATIONS
    where LOC_ID = X_LOC_ID;

  end delete_row;

end PR_LOCATIONS_PKG;
/

show errors package PR_LOCATIONS_PKG
show errors package body PR_LOCATIONS_PKG
