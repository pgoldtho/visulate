CREATE OR REPLACE PACKAGE RNT_ACCOUNTS_PAYABLE_CONST_PKG AS
/******************************************************************************
   NAME:       RNT_ACCOUNTS_PAYABLE_CONST_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17.10.2007             1. Created this package.
******************************************************************************/

CONST_GENERATE_TYPE CONSTANT VARCHAR2(1) := 'G';
CONST_OTHER_TYPE CONSTANT VARCHAR2(1) := 'O';
CONST_EXPENSE_TYPE CONSTANT VARCHAR2(1) := 'E';

function CONST_GENERATE_TYPE_VAL return varchar2;
function CONST_OTHER_TYPE_VAL  return varchar2;
function CONST_EXPENSE_TYPE_VAL  return varchar2;

END RNT_ACCOUNTS_PAYABLE_CONST_PKG;
/

SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY RNT_ACCOUNTS_PAYABLE_CONST_PKG AS
/******************************************************************************
   NAME:       RNT_ACCOUNTS_PAYABLE_CONST_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17.10.2007             1. Created this package body.
******************************************************************************/

function CONST_GENERATE_TYPE_VAL return varchar2 is begin return CONST_GENERATE_TYPE; end ;
function CONST_OTHER_TYPE_VAL  return varchar2 is begin return CONST_OTHER_TYPE; end ;
function CONST_EXPENSE_TYPE_VAL  return varchar2 is begin return CONST_EXPENSE_TYPE; end ;

END RNT_ACCOUNTS_PAYABLE_CONST_PKG;
/

SHOW ERRORS;
