CREATE OR REPLACE PACKAGE BODY RNTMGR.RNT_USERS_PKG AS
/******************************************************************************
   NAME:       RNT_USERS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12.04.2007             1. Created this package body.
******************************************************************************/

-- current user
G_USER_ID NUMBER;
G_ROLE_CODE VARCHAR2(30);
--G_IS_ADMIN VARCHAR2(1);

function is_user_role(X_USER_ID RNT_USERS.USER_ID%TYPE, 
                      X_ROLE_CODE RNT_USER_ROLES.ROLE_CODE%TYPE) return boolean
is
  x NUMBER;
begin
  select 1
  into x
  from DUAL 
  where exists (
                  select 1
                  from  RNT_USER_ASSIGNMENTS_V
                  where USER_ID = X_USER_ID
                    and ROLE_CODE = X_ROLE_CODE 
               );
  return TRUE;
exception  
  when NO_DATA_FOUND then
    return FALSE;  
end;

function LOGIN(X_LOGIN RNT_USERS.USER_LOGIN%TYPE, 
               X_PASSWORD RNT_USERS.USER_PASSWORD%TYPE)
           return RNT_USERS.USER_ID%TYPE
is
  x RNT_USERS.USER_ID%TYPE;
begin
  x := -1;
  select USER_ID
  into x
  from RNT_USERS
  where USER_LOGIN = X_LOGIN
    and USER_PASSWORD = X_PASSWORD
    and IS_ACTIVE_YN = 'Y';
  return x;  
exception
  when NO_DATA_FOUND or TOO_MANY_ROWS then
     return -1;
  when OTHERS then
     return -1;     
end;

procedure set_user(X_USER_ID NUMBER)
is
  x NUMBER;
begin
  select USER_ID --, IS_ADMIN_YN
  into g_user_id --, g_is_admin
  from RNT_USERS
  where USER_ID = X_USER_ID;
end;

procedure set_role(X_ROLE_CODE VARCHAR2)
is
begin
  select ROLE_CODE
  into g_role_code
  from RNT_USER_ASSIGNMENTS_V
  where USER_ID = G_USER_ID
    and ROLE_CODE = X_ROLE_CODE
  group by ROLE_CODE ;  
end;

function GET_USER return NUMBER
is
begin
  return G_USER_ID;
end;

function GET_ROLE return VARCHAR2
is
begin
  return G_ROLE_CODE;
end;

function CHANGE_PASSWORD(X_USER_ID RNT_USERS.USER_ID%TYPE, X_NEW_PASSWORD RNT_USERS.USER_PASSWORD%TYPE) return VARCHAR2
is
begin
   update RNT_USERS
   set USER_PASSWORD = X_NEW_PASSWORD
   where USER_ID = X_USER_ID;
   if SQL%ROWCOUNT = 1 then
      return 'Y';
   end if;
   return 'N';   
end;

/*
function IS_ADMIN return VARCHAR2
is
begin
  return g_is_admin;
end;
*/
BEGIN
 G_USER_ID := -1;
 G_ROLE_CODE := '';
-- G_IS_ADMIN := 'N';
END RNT_USERS_PKG; 
/

