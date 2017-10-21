CREATE OR REPLACE PACKAGE RNT_ACC_RECEIVABLE_CONST_PKG  AS
/******************************************************************************
   NAME:       RNT_ACC_RECEIVABLE_CONST_PKG 
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11.10.2007             1. Created this package.
******************************************************************************/

CONST_GENERATE_TYPE CONSTANT VARCHAR2(1) := 'G';
CONST_OTHER_TYPE CONSTANT VARCHAR2(1) := 'O';

function CONST_GENERATE_TYPE_VAL  return varchar2;
function CONST_OTHER_TYPE_VAL  return varchar2;

END RNT_ACC_RECEIVABLE_CONST_PKG ;
/

SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY RNT_ACC_RECEIVABLE_CONST_PKG  AS
/******************************************************************************
   NAME:       RNT_ACC_RECEIVABLE_CONST_PKG 
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11.10.2007             1. Created this package body.
******************************************************************************/

function CONST_GENERATE_TYPE_VAL  return varchar2 as begin return CONST_GENERATE_TYPE; end;
function CONST_OTHER_TYPE_VAL  return varchar2 as begin return CONST_OTHER_TYPE; end;

END RNT_ACC_RECEIVABLE_CONST_PKG ;
/
