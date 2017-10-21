CREATE OR REPLACE PACKAGE RNTMGR.RNT_USERS_PKG AS
/******************************************************************************
   NAME:       RNT_USERS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12.04.2007             1. Created this package.
   for password 'Admin' md5 = e3afed0047b08059d0fada10f400c1e5
******************************************************************************/

function LOGIN(X_LOGIN RNT_USERS.USER_LOGIN%TYPE, 
               X_PASSWORD RNT_USERS.USER_PASSWORD%TYPE)
               return RNT_USERS.USER_ID%TYPE;

procedure SET_USER(X_USER_ID NUMBER);

procedure SET_ROLE(X_ROLE_CODE VARCHAR2);

function GET_USER return NUMBER;

function GET_ROLE return VARCHAR2;

function CHANGE_PASSWORD(X_USER_ID RNT_USERS.USER_ID%TYPE, X_NEW_PASSWORD RNT_USERS.USER_PASSWORD%TYPE) return varchar2;

END RNT_USERS_PKG; 
/

