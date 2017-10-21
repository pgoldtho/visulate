CREATE OR REPLACE PACKAGE        RNT_USER_ASSIGNMENTS_PKG AS
/******************************************************************************
   NAME:       RNT_USER_ASSIGNMENTS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        22.04.2007             1. Created this package.
******************************************************************************/

function get_checksum(X_USER_ASSIGN_ID RNT_USER_ASSIGNMENTS.USER_ASSIGN_ID%TYPE) return varchar2; 

function insert_row(X_USER_ID RNT_USER_ASSIGNMENTS.USER_ID%TYPE,
                    X_ROLE_ID RNT_USER_ASSIGNMENTS.ROLE_ID%TYPE,
                    X_BUSINESS_ID RNT_USER_ASSIGNMENTS.BUSINESS_ID%TYPE)
                    return RNT_USER_ASSIGNMENTS.USER_ASSIGN_ID%TYPE;
                    
procedure delete_row(X_USER_ASSIGN_ID RNT_USER_ASSIGNMENTS.USER_ASSIGN_ID%TYPE);                    
                    
                     

END RNT_USER_ASSIGNMENTS_PKG;
/


CREATE OR REPLACE PACKAGE BODY        RNT_USER_ASSIGNMENTS_PKG AS
/******************************************************************************
   NAME:       RNT_USER_ASSIGNMENTS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        22.04.2007             1. Created this package body.
******************************************************************************/

function get_checksum(X_USER_ASSIGN_ID RNT_USER_ASSIGNMENTS.USER_ASSIGN_ID%TYPE) return varchar2
is
begin
  for x in (select USER_ASSIGN_ID, ROLE_ID, USER_ID, BUSINESS_ID
           from RNT_USER_ASSIGNMENTS
           where USER_ASSIGN_ID = X_USER_ASSIGN_ID) loop
         RNT_SYS_CHECKSUM_REC_PKG.INIT;
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.USER_ASSIGN_ID);         
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.ROLE_ID);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.USER_ID); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.BUSINESS_ID);
         return RNT_SYS_CHECKSUM_REC_PKG.GET_CHECKSUM;
   end loop;
   raise NO_DATA_FOUND;     
end;
/*
function check_unique(X_USER_ASSIGN_ID RNT_USER_ASSIGNMENTS.USER_ASSIGN_ID%TYPE,
                      X_USER_ID RNT_USER_ASSIGNMENTS.USER_ID%TYPE,
                      X_ROLE_ID RNT_USER_ASSIGNMENTS.ROLE_ID%TYPE,
                      X_BUSINESS_ID RNT_USER_ASSIGNMENTS.BUSINESS_ID%TYPE
                      ) return boolean
is
  x NUMBER;
begin
   select 1 
   into x
   from DUAL
   where exists (
                   select 1
                   from RNT_USER_ASSIGNMENTS
                   where USER_ID = X_USER_ID
                     and ROLE_ID = X_ROLE_ID
                     and BUSINESS_ID = X_BUSINESS_ID
                     and (USER_ASSIGN_ID != X_USER_ASSIGN_ID or X_USER_ASSIGN_ID is null)
                 );
  return false;
exception
  when NO_DATA_FOUND then
     return true;                        
end;
*/
function check_unique2(X_USER_ASSIGN_ID RNT_USER_ASSIGNMENTS.USER_ASSIGN_ID%TYPE,
                       X_USER_ID RNT_USER_ASSIGNMENTS.USER_ID%TYPE,
                       X_ROLE_ID RNT_USER_ASSIGNMENTS.ROLE_ID%TYPE,
                       X_BUSINESS_ID RNT_USER_ASSIGNMENTS.BUSINESS_ID%TYPE
                      ) return boolean
is
  x NUMBER;
begin
   select 1 
   into x
   from DUAL
   where exists (
                   select 1
                   from RNT_USER_ASSIGNMENTS
                   where USER_ID = X_USER_ID
                     and ROLE_ID = X_ROLE_ID
                     and BUSINESS_ID = X_BUSINESS_ID
                     and (USER_ASSIGN_ID != X_USER_ASSIGN_ID or X_USER_ASSIGN_ID is null)
                 );
  return false;
exception
  when NO_DATA_FOUND then
     return true;                        
end;

function insert_row(X_USER_ID RNT_USER_ASSIGNMENTS.USER_ID%TYPE,
                    X_ROLE_ID RNT_USER_ASSIGNMENTS.ROLE_ID%TYPE,
                    X_BUSINESS_ID RNT_USER_ASSIGNMENTS.BUSINESS_ID%TYPE)
                    return RNT_USER_ASSIGNMENTS.USER_ASSIGN_ID%TYPE 
is
  x RNT_USER_ASSIGNMENTS.USER_ASSIGN_ID%TYPE; 
begin
/*
  if not check_unique(NULL, X_USER_ID, X_ROLE_ID, X_BUSINESS_ID) then
        RAISE_APPLICATION_ERROR(-20006, 'User assignment must be unique');                      
   end if;   
*/   
   if not check_unique2(NULL, X_USER_ID, X_ROLE_ID, X_BUSINESS_ID) then
        RAISE_APPLICATION_ERROR(-20550, 'User must have unique role and business unit.');                      
   end if;
   insert into RNT_USER_ASSIGNMENTS (USER_ASSIGN_ID, USER_ID, ROLE_ID, BUSINESS_ID)
   values (RNT_USER_ASSIGNMENTS_SEQ.NEXTVAL, X_USER_ID, X_ROLE_ID, X_BUSINESS_ID)
   returning USER_ASSIGN_ID into x;
   
   return x;  
end;

procedure lock_row(X_USER_ASSIGN_ID RNT_USER_ASSIGNMENTS.USER_ASSIGN_ID%TYPE)
is
    cursor c is
             select *
             from RNT_USER_ASSIGNMENTS
             where USER_ASSIGN_ID = X_USER_ASSIGN_ID
             for update of USER_ASSIGN_ID nowait; 
begin
  open c;
  close c;
exception
  when OTHERS then
    if SQLCODE = -54 then
      RAISE_APPLICATION_ERROR(-20001, 'Cannot changed record. Record is locked.');
    end if; 
end;

procedure delete_row(X_USER_ASSIGN_ID RNT_USER_ASSIGNMENTS.USER_ASSIGN_ID%TYPE)
is
begin
  lock_row(X_USER_ASSIGN_ID);
   
  delete from RNT_USER_ASSIGNMENTS
  where USER_ASSIGN_ID = X_USER_ASSIGN_ID;
end;      

END RNT_USER_ASSIGNMENTS_PKG;
/


