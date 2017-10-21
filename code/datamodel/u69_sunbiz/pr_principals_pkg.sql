create or replace package PR_PRINCIPALS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011       All rights reserved worldwide
    Name:      PR_PRINCIPALS_PKG
    Purpose:   API's for PR_PRINCIPALS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        13-JUN-11   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_PN_ID IN PR_PRINCIPALS.PN_ID%TYPE)
            return PR_PRINCIPALS_V.CHECKSUM%TYPE;

  procedure update_row( X_PN_ID IN PR_PRINCIPALS.PN_ID%TYPE
                      , X_PN_TYPE IN PR_PRINCIPALS.PN_TYPE%TYPE
                      , X_PN_NAME IN PR_PRINCIPALS.PN_NAME%TYPE
                      , X_CHECKSUM IN PR_PRINCIPALS_V.CHECKSUM%TYPE);

  function  insert_row( X_PN_TYPE IN PR_PRINCIPALS.PN_TYPE%TYPE
                     , X_PN_NAME IN PR_PRINCIPALS.PN_NAME%TYPE)
              return PR_PRINCIPALS.PN_ID%TYPE;
			  
  function  get_pnid( X_PN_TYPE IN PR_PRINCIPALS.PN_TYPE%TYPE
                    , X_PN_NAME IN PR_PRINCIPALS.PN_NAME%TYPE)
              return PR_PRINCIPALS.PN_ID%TYPE;			  

  procedure delete_row( X_PN_ID IN PR_PRINCIPALS.PN_ID%TYPE);

end PR_PRINCIPALS_PKG;
/
create or replace package body PR_PRINCIPALS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011       All rights reserved worldwide
    Name:      PR_PRINCIPALS_PKG
    Purpose:   API's for PR_PRINCIPALS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        13-JUN-11   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------
  function check_unique( X_PN_ID IN PR_PRINCIPALS.PN_ID%TYPE
                       , X_PN_TYPE IN PR_PRINCIPALS.PN_TYPE%TYPE
                       , X_PN_NAME IN PR_PRINCIPALS.PN_NAME%TYPE) return boolean is
        cursor c is
        select PN_ID
        from PR_PRINCIPALS
        where PN_TYPE = X_PN_TYPE
    and PN_NAME = X_PN_NAME;

      begin
         for c_rec in c loop
           if (X_PN_ID is null OR c_rec.PN_ID != X_PN_ID) then
             return false;
           end if;
         end loop;
         return true;
      end check_unique;

  procedure lock_row( X_PN_ID IN PR_PRINCIPALS.PN_ID%TYPE) is
     cursor c is
     select * from PR_PRINCIPALS
     where PN_ID = X_PN_ID
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
  function get_checksum( X_PN_ID IN PR_PRINCIPALS.PN_ID%TYPE)
            return PR_PRINCIPALS_V.CHECKSUM%TYPE is

    v_return_value               PR_PRINCIPALS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from PR_PRINCIPALS_V
    where PN_ID = X_PN_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_PN_ID IN PR_PRINCIPALS.PN_ID%TYPE
                      , X_PN_TYPE IN PR_PRINCIPALS.PN_TYPE%TYPE
                      , X_PN_NAME IN PR_PRINCIPALS.PN_NAME%TYPE
                      , X_CHECKSUM IN PR_PRINCIPALS_V.CHECKSUM%TYPE)
  is
     l_checksum          PR_PRINCIPALS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_PN_ID);

      -- validate checksum
      l_checksum := get_checksum(X_PN_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

         if not check_unique(X_PN_ID, X_PN_TYPE, X_PN_NAME) then
             RAISE_APPLICATION_ERROR(-20006, 'Update values must be unique.');
         end if;
     update PR_PRINCIPALS
     set PN_TYPE = X_PN_TYPE
     , PN_NAME = X_PN_NAME
     where PN_ID = X_PN_ID;

  end update_row;

  function  insert_row( X_PN_TYPE IN PR_PRINCIPALS.PN_TYPE%TYPE
                     , X_PN_NAME IN PR_PRINCIPALS.PN_NAME%TYPE)
              return PR_PRINCIPALS.PN_ID%TYPE
  is
     x          number;
  begin
if not check_unique(NULL, X_PN_TYPE, X_PN_NAME) then
         RAISE_APPLICATION_ERROR(-20006, 'Insert values must be unique.');
     end if;

     insert into PR_PRINCIPALS
     ( PN_ID
     , PN_TYPE
     , PN_NAME)
     values
     ( PR_PRINCIPALS_SEQ.NEXTVAL
     , X_PN_TYPE
     , X_PN_NAME)
     returning PN_ID into x;

     return x;
  end insert_row;
  
  function  get_pnid( X_PN_TYPE IN PR_PRINCIPALS.PN_TYPE%TYPE
                    , X_PN_NAME IN PR_PRINCIPALS.PN_NAME%TYPE)
              return PR_PRINCIPALS.PN_ID%TYPE is
    v_return   PR_PRINCIPALS.PN_ID%TYPE;
  begin
    select pn_id
	into v_return
	from pr_principals
	where pn_type = x_pn_type
	and pn_name = x_pn_name;
	
	return v_return;
  exception
    when no_data_found then return null;
	when others then raise;
  end get_pnid;
			  
			  
  procedure delete_row( X_PN_ID IN PR_PRINCIPALS.PN_ID%TYPE) is

  begin
    delete from PR_PRINCIPALS
    where PN_ID = X_PN_ID;

  end delete_row;

end PR_PRINCIPALS_PKG;
/

show errors package PR_PRINCIPALS_PKG
show errors package body PR_PRINCIPALS_PKG