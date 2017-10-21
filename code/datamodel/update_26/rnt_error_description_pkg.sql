
CREATE OR REPLACE package        RNT_ERROR_DESCRIPTION_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_ERROR_DESCRIPTION_PKG
    Purpose:   API's for RNT_ERROR_DESCRIPTION table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        29-OCT-07   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_ERROR_ID IN RNT_ERROR_DESCRIPTION.ERROR_ID%TYPE)
            return RNT_ERROR_DESCRIPTION_V.CHECKSUM%TYPE;

  procedure update_row( X_ERROR_ID IN RNT_ERROR_DESCRIPTION.ERROR_ID%TYPE
                      , X_ERROR_CODE IN RNT_ERROR_DESCRIPTION.ERROR_CODE%TYPE
                      , X_SHORT_DESCRIPTION IN RNT_ERROR_DESCRIPTION.SHORT_DESCRIPTION%TYPE
                      , X_LONG_DESCRIPTION IN RNT_ERROR_DESCRIPTION.LONG_DESCRIPTION%TYPE
                      , X_SHOW_LONG_DESCRIPTION_YN IN RNT_ERROR_DESCRIPTION.SHOW_LONG_DESCRIPTION_YN%TYPE
                      , X_CLASSIFIED_DESCRIPTION IN RNT_ERROR_DESCRIPTION.CLASSIFIED_DESCRIPTION%TYPE
                      , X_CHECKSUM IN RNT_ERROR_DESCRIPTION_V.CHECKSUM%TYPE);

  function insert_row( X_ERROR_CODE IN RNT_ERROR_DESCRIPTION.ERROR_CODE%TYPE
                     , X_SHORT_DESCRIPTION IN RNT_ERROR_DESCRIPTION.SHORT_DESCRIPTION%TYPE
                     , X_LONG_DESCRIPTION IN RNT_ERROR_DESCRIPTION.LONG_DESCRIPTION%TYPE
                     , X_SHOW_LONG_DESCRIPTION_YN IN RNT_ERROR_DESCRIPTION.SHOW_LONG_DESCRIPTION_YN%TYPE
                     , X_CLASSIFIED_DESCRIPTION IN RNT_ERROR_DESCRIPTION.CLASSIFIED_DESCRIPTION%TYPE)
              return RNT_ERROR_DESCRIPTION.ERROR_ID%TYPE;

  procedure delete_row( X_ERROR_ID IN RNT_ERROR_DESCRIPTION.ERROR_ID%TYPE);

  function get_short_description(x_error_code RNT_ERROR_DESCRIPTION.ERROR_CODE%TYPE) return RNT_ERROR_DESCRIPTION.SHORT_DESCRIPTION%TYPE;

  function get_long_description(x_error_code RNT_ERROR_DESCRIPTION.ERROR_CODE%TYPE) return RNT_ERROR_DESCRIPTION.LONG_DESCRIPTION%TYPE;

  function is_show_long(x_error_code RNT_ERROR_DESCRIPTION.ERROR_CODE%TYPE) return RNT_ERROR_DESCRIPTION.SHOW_LONG_DESCRIPTION_YN%TYPE;
 
end RNT_ERROR_DESCRIPTION_PKG;
/


CREATE OR REPLACE package body        RNT_ERROR_DESCRIPTION_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_ERROR_DESCRIPTION_PKG
    Purpose:   API's for RNT_ERROR_DESCRIPTION table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        29-OCT-07   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_ERROR_ID IN RNT_ERROR_DESCRIPTION.ERROR_ID%TYPE) is
     cursor c is
     select * from RNT_ERROR_DESCRIPTION
     where ERROR_ID = X_ERROR_ID
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
  function get_checksum( X_ERROR_ID IN RNT_ERROR_DESCRIPTION.ERROR_ID%TYPE)
            return RNT_ERROR_DESCRIPTION_V.CHECKSUM%TYPE is 

    v_return_value               RNT_ERROR_DESCRIPTION_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_ERROR_DESCRIPTION_V
    where ERROR_ID = X_ERROR_ID;
    return v_return_value;
  end get_checksum;
  
  function check_unique(X_ERROR_ID IN RNT_ERROR_DESCRIPTION.ERROR_ID%TYPE
                      , X_ERROR_CODE IN RNT_ERROR_DESCRIPTION.ERROR_CODE%TYPE) return boolean
    is
      x NUMBER;
    begin
       select 1 
       into x
       from DUAL
       where exists (
                       select 1
                       from RNT_ERROR_DESCRIPTION
                       where (ERROR_ID != X_ERROR_ID or X_ERROR_ID is null) 
                         and ERROR_CODE = X_ERROR_CODE            
                     );
      return false;
    exception
      when NO_DATA_FOUND then
         return true;                        
    end;

  procedure update_row( X_ERROR_ID IN RNT_ERROR_DESCRIPTION.ERROR_ID%TYPE
                      , X_ERROR_CODE IN RNT_ERROR_DESCRIPTION.ERROR_CODE%TYPE
                      , X_SHORT_DESCRIPTION IN RNT_ERROR_DESCRIPTION.SHORT_DESCRIPTION%TYPE
                      , X_LONG_DESCRIPTION IN RNT_ERROR_DESCRIPTION.LONG_DESCRIPTION%TYPE
                      , X_SHOW_LONG_DESCRIPTION_YN IN RNT_ERROR_DESCRIPTION.SHOW_LONG_DESCRIPTION_YN%TYPE
                      , X_CLASSIFIED_DESCRIPTION IN RNT_ERROR_DESCRIPTION.CLASSIFIED_DESCRIPTION%TYPE
                      , X_CHECKSUM IN RNT_ERROR_DESCRIPTION_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_ERROR_DESCRIPTION_V.CHECKSUM%TYPE;
  begin
     lock_row(X_ERROR_ID);

      -- validate checksum
      l_checksum := get_checksum(X_ERROR_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

     if not check_unique(X_ERROR_ID, X_ERROR_CODE) then
        RAISE_APPLICATION_ERROR(-20150, 'Error code must be unique');                      
     end if;  
        
     update RNT_ERROR_DESCRIPTION
     set ERROR_CODE = X_ERROR_CODE
     , SHORT_DESCRIPTION = X_SHORT_DESCRIPTION
     , LONG_DESCRIPTION = X_LONG_DESCRIPTION
     , SHOW_LONG_DESCRIPTION_YN = X_SHOW_LONG_DESCRIPTION_YN
     , CLASSIFIED_DESCRIPTION = X_CLASSIFIED_DESCRIPTION
     where ERROR_ID = X_ERROR_ID;

  end update_row;

  function insert_row( X_ERROR_CODE IN RNT_ERROR_DESCRIPTION.ERROR_CODE%TYPE
                     , X_SHORT_DESCRIPTION IN RNT_ERROR_DESCRIPTION.SHORT_DESCRIPTION%TYPE
                     , X_LONG_DESCRIPTION IN RNT_ERROR_DESCRIPTION.LONG_DESCRIPTION%TYPE
                     , X_SHOW_LONG_DESCRIPTION_YN IN RNT_ERROR_DESCRIPTION.SHOW_LONG_DESCRIPTION_YN%TYPE
                     , X_CLASSIFIED_DESCRIPTION IN RNT_ERROR_DESCRIPTION.CLASSIFIED_DESCRIPTION%TYPE)
              return RNT_ERROR_DESCRIPTION.ERROR_ID%TYPE
  is
     x          number;
  begin
     if not check_unique(NULL, X_ERROR_CODE) then
        RAISE_APPLICATION_ERROR(-20150, 'Error code must be unique');                      
     end if;  

     insert into RNT_ERROR_DESCRIPTION
     ( ERROR_ID
     , ERROR_CODE
     , SHORT_DESCRIPTION
     , LONG_DESCRIPTION
     , SHOW_LONG_DESCRIPTION_YN
     , CLASSIFIED_DESCRIPTION)
     values
     ( RNT_ERROR_DESCRIPTION_SEQ.NEXTVAL
     , X_ERROR_CODE
     , X_SHORT_DESCRIPTION
     , X_LONG_DESCRIPTION
     , X_SHOW_LONG_DESCRIPTION_YN
     , X_CLASSIFIED_DESCRIPTION)
     returning ERROR_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_ERROR_ID IN RNT_ERROR_DESCRIPTION.ERROR_ID%TYPE) is

  begin
    delete from RNT_ERROR_DESCRIPTION
    where ERROR_ID = X_ERROR_ID;

  end delete_row;

function get_short_description(x_error_code RNT_ERROR_DESCRIPTION.ERROR_CODE%TYPE) return RNT_ERROR_DESCRIPTION.SHORT_DESCRIPTION%TYPE
is
 x RNT_ERROR_DESCRIPTION.SHORT_DESCRIPTION%TYPE;
begin
 select SHORT_DESCRIPTION
 into x
 from RNT_ERROR_DESCRIPTION
 where ERROR_CODE = x_error_code;
 return x;
exception
  when NO_DATA_FOUND then return NULL;
end;

function get_long_description(x_error_code RNT_ERROR_DESCRIPTION.ERROR_CODE%TYPE) return RNT_ERROR_DESCRIPTION.LONG_DESCRIPTION%TYPE
is
  x RNT_ERROR_DESCRIPTION.LONG_DESCRIPTION%TYPE;
begin
 select LONG_DESCRIPTION
 into x
 from RNT_ERROR_DESCRIPTION
 where ERROR_CODE = x_error_code;
 return x;
exception
  when NO_DATA_FOUND then return NULL;
end;

function is_show_long(x_error_code RNT_ERROR_DESCRIPTION.ERROR_CODE%TYPE) return RNT_ERROR_DESCRIPTION.SHOW_LONG_DESCRIPTION_YN%TYPE
is
  x RNT_ERROR_DESCRIPTION.SHOW_LONG_DESCRIPTION_YN%TYPE;
begin
 select SHOW_LONG_DESCRIPTION_YN
 into x
 from RNT_ERROR_DESCRIPTION
 where ERROR_CODE = x_error_code;

 return x;

exception
  when NO_DATA_FOUND then
      return 'N';
end;

 
end RNT_ERROR_DESCRIPTION_PKG;
/


