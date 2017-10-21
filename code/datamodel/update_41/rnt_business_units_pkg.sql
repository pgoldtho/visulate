CREATE OR REPLACE PACKAGE        RNT_BUSINESS_UNITS_PKG AS
/******************************************************************************
   NAME:       RNT_BUSINESS_UNITS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        14.04.2007             1. Created this package.
******************************************************************************/

function get_checksum(X_BUSINESS_ID RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE) return varchar2;  

function INSERT_ROW(X_BUSINESS_NAME RNT_BUSINESS_UNITS.BUSINESS_NAME%TYPE,
                     X_PARENT_BUSINESS_ID RNT_BUSINESS_UNITS.PARENT_BUSINESS_ID%TYPE
                    ) return RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE;

function INSERT_ROW_AUTOMATIC(X_BUSINESS_NAME RNT_BUSINESS_UNITS.BUSINESS_NAME%TYPE,
                     X_PARENT_BUSINESS_ID RNT_BUSINESS_UNITS.PARENT_BUSINESS_ID%TYPE
                    ) return RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE;
                    
procedure update_row(X_BUSINESS_ID RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE,
                     X_BUSINESS_NAME RNT_BUSINESS_UNITS.BUSINESS_NAME%TYPE,
                     X_PARENT_BUSINESS_ID RNT_BUSINESS_UNITS.PARENT_BUSINESS_ID%TYPE,
                     X_CHECKSUM VARCHAR2
                     );
                                         
function check_allow_for_access(X_BUSINESS_ID RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE) return boolean;

procedure delete_row(X_BUSINESS_ID RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE);

END RNT_BUSINESS_UNITS_PKG;
/

SHOW ERRORS;


CREATE OR REPLACE PACKAGE BODY        RNT_BUSINESS_UNITS_PKG AS
/******************************************************************************
   NAME:       RNT_BUSINESS_UNITS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        14.04.2007             1. Created this package body.
******************************************************************************/

function get_checksum(X_BUSINESS_ID RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE) return varchar2
is
begin
   for x in (select 
             BUSINESS_ID, BUSINESS_NAME, PARENT_BUSINESS_ID
            from RNT_BUSINESS_UNITS
            where BUSINESS_ID = X_BUSINESS_ID) loop
         RNT_SYS_CHECKSUM_REC_PKG.INIT;
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.BUSINESS_ID);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.BUSINESS_NAME);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.PARENT_BUSINESS_ID);
         return RNT_SYS_CHECKSUM_REC_PKG.GET_CHECKSUM;
   end loop;
   raise NO_DATA_FOUND;               
end;


procedure lock_row(X_BUSINESS_ID RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE)
is
    cursor c is
             select *               
             from RNT_BUSINESS_UNITS
             where BUSINESS_ID = X_BUSINESS_ID
             for update of BUSINESS_ID nowait; 
begin
  open c;
  close c;
exception
  when OTHERS then
    if SQLCODE = -54 then
      RAISE_APPLICATION_ERROR(-20001, 'Cannot changed record. Record is locked.');
    end if; 
end;    

function check_allow_for_access(X_BUSINESS_ID RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE) return boolean
is
  x NUMBER;
begin
  if RNT_USERS_PKG.GET_ROLE() = 'ADMIN' then
    return TRUE;
  end if;
   
  select 1
  into x 
  from DUAL
  where exists(select 1 
               from RNT_BUSINESS_UNITS_V
               where BUSINESS_ID = X_BUSINESS_ID);
  return TRUE;                
exception
  when NO_DATA_FOUND then
    return FALSE; 
end;

function check_unique(X_BUSINESS_ID RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE,
                      X_PARENT_BUSINESS_ID RNT_BUSINESS_UNITS.PARENT_BUSINESS_ID%TYPE,
                      X_BUSINESS_NAME RNT_BUSINESS_UNITS.BUSINESS_NAME%TYPE
                      ) return boolean
is
  x NUMBER;
begin
   select 1 
   into x
   from DUAL
   where exists (
                   select 1
                   from RNT_BUSINESS_UNITS
                   where PARENT_BUSINESS_ID = X_PARENT_BUSINESS_ID
                     and BUSINESS_NAME = X_BUSINESS_NAME 
                     and (BUSINESS_ID != X_BUSINESS_ID or X_BUSINESS_ID is null)
                 );
  return false;
exception
  when NO_DATA_FOUND then
     return true;                        
end;       

function INSERT_ROW_PRIVATE(X_BUSINESS_NAME RNT_BUSINESS_UNITS.BUSINESS_NAME%TYPE,
                    X_PARENT_BUSINESS_ID RNT_BUSINESS_UNITS.PARENT_BUSINESS_ID%TYPE,
                    X_IS_CHECK boolean
                   ) return RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE
is
  x NUMBER;
begin
   if X_IS_CHECK then
       if not check_allow_for_access(X_PARENT_BUSINESS_ID) then
           RAISE_APPLICATION_ERROR(-20120, 'You cannot create sub units for this business unit. Access denied.');
       end if;
   end if;
   
   if not check_unique(NULL, X_PARENT_BUSINESS_ID, X_BUSINESS_NAME) then
       RAISE_APPLICATION_ERROR(-20121, 'Name of business unit must be unique in parent business unit.');
   end if; 
    
   insert into RNT_BUSINESS_UNITS (
      BUSINESS_ID, BUSINESS_NAME, PARENT_BUSINESS_ID) 
   values (RNT_BUSINESS_UNITS_SEQ.NEXTVAL, X_BUSINESS_NAME, X_PARENT_BUSINESS_ID)
   returning BUSINESS_ID into x;  
   return x;
end;

function INSERT_ROW(X_BUSINESS_NAME RNT_BUSINESS_UNITS.BUSINESS_NAME%TYPE,
                    X_PARENT_BUSINESS_ID RNT_BUSINESS_UNITS.PARENT_BUSINESS_ID%TYPE
                   ) return RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE
is
begin
  return INSERT_ROW_PRIVATE(X_BUSINESS_NAME => X_BUSINESS_NAME,
                    X_PARENT_BUSINESS_ID => X_PARENT_BUSINESS_ID,
                    X_IS_CHECK => true
                   ); 
end;                   

function INSERT_ROW_AUTOMATIC(X_BUSINESS_NAME RNT_BUSINESS_UNITS.BUSINESS_NAME%TYPE,
                     X_PARENT_BUSINESS_ID RNT_BUSINESS_UNITS.PARENT_BUSINESS_ID%TYPE
                    ) return RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE
is
begin
    return INSERT_ROW_PRIVATE(X_BUSINESS_NAME => X_BUSINESS_NAME,
                    X_PARENT_BUSINESS_ID => X_PARENT_BUSINESS_ID,
                    X_IS_CHECK => false
                   ); 
end;
                                        

procedure update_row(X_BUSINESS_ID RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE,
                     X_BUSINESS_NAME RNT_BUSINESS_UNITS.BUSINESS_NAME%TYPE,
                     X_PARENT_BUSINESS_ID RNT_BUSINESS_UNITS.PARENT_BUSINESS_ID%TYPE,
                     X_CHECKSUM VARCHAR2
                     )
is
   l_checksum varchar2(32); 
begin
   
   lock_row(X_BUSINESS_ID);
   
   -- validate checksum   
   l_checksum := get_checksum(X_BUSINESS_ID);
   if X_CHECKSUM != l_checksum then
      RAISE_APPLICATION_ERROR(-20002, 'Record was changed another user.');
   end if;


   if not check_allow_for_access(X_BUSINESS_ID) then
       RAISE_APPLICATION_ERROR(-20122, 'You cannot update this unit. Access denied.');
   end if;

   if not check_unique(X_BUSINESS_ID, X_PARENT_BUSINESS_ID, X_BUSINESS_NAME) then
       RAISE_APPLICATION_ERROR(-20121, 'Name of business unit must be unique in parent business unit.');
   end if; 
 
   update RNT_BUSINESS_UNITS  
   set BUSINESS_NAME      = X_BUSINESS_NAME,
       PARENT_BUSINESS_ID = X_PARENT_BUSINESS_ID
   where BUSINESS_ID      = X_BUSINESS_ID;       
end;

function is_properties_exists(X_BUSINESS_ID NUMBER)
return boolean
is  
  x NUMBER;
begin
  select 1
  into x
  from DUAL
  where exists (select 1
                from RNT_PROPERTIES
                where BUSINESS_ID = X_BUSINESS_ID
                );
  return true;
exception
  when NO_DATA_FOUND then
     return false;   
end;

function is_assign_user_exists(X_BUSINESS_ID NUMBER)
return boolean
is  
  x NUMBER;
begin
  select 1
  into x
  from DUAL
  where exists (select 1
                from RNT_USER_ASSIGNMENTS
                where BUSINESS_ID = X_BUSINESS_ID
                );
  return true;
exception
  when NO_DATA_FOUND then
     return false;   
end;
    
function is_subunits_exists(X_BUSINESS_ID NUMBER)
return boolean
is  
  x NUMBER;
begin
  select 1
  into x
  from DUAL
  where exists (select 1
                from RNT_BUSINESS_UNITS
                where PARENT_BUSINESS_ID = X_BUSINESS_ID
                );
  return true;
exception
  when NO_DATA_FOUND then
     return false;   
end;                 

procedure delete_row(X_BUSINESS_ID RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE)
is
begin
   if is_properties_exists(X_BUSINESS_ID) then
      RAISE_APPLICATION_ERROR(-20123, 'Cannot delete record. Find properties for this record.');
   end if;   
   
   if (is_assign_user_exists(X_BUSINESS_ID)) then
      RAISE_APPLICATION_ERROR(-20124, 'Cannot delete record. Find assigned owners for this record.');
   end if;

   if (is_subunits_exists(X_BUSINESS_ID)) then
      RAISE_APPLICATION_ERROR(-20125, 'Cannot delete record. Find sub units for business unit.');
   end if;
 
   delete from RNT_BUSINESS_UNITS
   where BUSINESS_ID = X_BUSINESS_ID;
end;


END RNT_BUSINESS_UNITS_PKG;
/

SHOW ERRORS;
