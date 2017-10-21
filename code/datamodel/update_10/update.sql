--------------------------------------------------------------------------
-- Play this script in TESTRNTMGR@XE to make it look like RNTMGR@XE
--                                                                      --
-- Please review the script before using it to make sure it won't       --
-- cause any unacceptable data loss.                                    --
--                                                                      --
-- TESTRNTMGR@XE Schema Extracted by User TESTRNTMGR 
-- RNTMGR@XE Schema Extracted by User RNTMGR 
DROP INDEX RNT_USER_ASSIGNMENTS_U2;

CREATE SEQUENCE RNT_ERROR_DESCRIPTION_SEQ
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;

CREATE TABLE RNT_ERROR_DESCRIPTION
(
  ERROR_ID                  NUMBER              NOT NULL,
  ERROR_CODE                NUMBER              NOT NULL,
  SHORT_DESCRIPTION         VARCHAR2(2000 BYTE),
  LONG_DESCRIPTION          VARCHAR2(4000 BYTE),
  SHOW_LONG_DESCRIPTION_YN  VARCHAR2(1 BYTE)    NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE RNT_ERROR_DESCRIPTION IS 'Description database error.';

COMMENT ON COLUMN RNT_ERROR_DESCRIPTION.ERROR_ID IS 'Error ID';

COMMENT ON COLUMN RNT_ERROR_DESCRIPTION.ERROR_CODE IS 'Error number.';

COMMENT ON COLUMN RNT_ERROR_DESCRIPTION.SHORT_DESCRIPTION IS 'Short description of error.';

COMMENT ON COLUMN RNT_ERROR_DESCRIPTION.LONG_DESCRIPTION IS 'Long description of error.';

COMMENT ON COLUMN RNT_ERROR_DESCRIPTION.SHOW_LONG_DESCRIPTION_YN IS 'Flag for show long description.';

CREATE UNIQUE INDEX RNT_ERROR_DESCRIPTION_U1 ON RNT_ERROR_DESCRIPTION
(ERROR_CODE)
LOGGING
NOPARALLEL;

CREATE INDEX RNT_ERROR_DESCRIPTION_PK ON RNT_ERROR_DESCRIPTION
(ERROR_ID)
LOGGING
NOPARALLEL;

DROP INDEX RNT_PEOPLE_U1;
CREATE UNIQUE INDEX RNT_PEOPLE_U1 ON RNT_PEOPLE
(BUSINESS_ID, FIRST_NAME, LAST_NAME)
LOGGING
NOPARALLEL;

CREATE UNIQUE INDEX RNT_USER_ASSIGNMENTS_U1 ON RNT_USER_ASSIGNMENTS
(ROLE_ID, USER_ID, BUSINESS_ID)
LOGGING
NOPARALLEL;

CREATE OR REPLACE PACKAGE RNT_ERROR_DESCRIPTION_PKG AS
/******************************************************************************
   NAME:       RNT_ERROR_DESCRIPTION_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        29.07.2007             1. Created this package.
******************************************************************************/

function get_short_description(x_error_code RNT_ERROR_DESCRIPTION.ERROR_CODE%TYPE) return RNT_ERROR_DESCRIPTION.SHORT_DESCRIPTION%TYPE;

function get_long_description(x_error_code RNT_ERROR_DESCRIPTION.ERROR_CODE%TYPE) return RNT_ERROR_DESCRIPTION.LONG_DESCRIPTION%TYPE;

function is_show_long(x_error_code RNT_ERROR_DESCRIPTION.ERROR_CODE%TYPE) return RNT_ERROR_DESCRIPTION.SHOW_LONG_DESCRIPTION_YN%TYPE;
  
END RNT_ERROR_DESCRIPTION_PKG;
/

SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY RNT_ERROR_DESCRIPTION_PKG AS
/******************************************************************************
   NAME:       RNT_ERROR_DESCRIPTION_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        29.07.2007             1. Created this package body.
******************************************************************************/

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


END RNT_ERROR_DESCRIPTION_PKG;
/

SHOW ERRORS;

ALTER TABLE RNT_ACCOUNTS_PAYABLE
MODIFY(EXPENSE_ID  NULL);


ALTER TABLE RNT_ACCOUNTS_PAYABLE
 ADD (PAYMENT_PROPERTY_ID  NUMBER);


COMMENT ON COLUMN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID IS 'Property ID';
CREATE OR REPLACE PACKAGE        RNT_PEOPLE_PKG AS
/******************************************************************************
   NAME:       RNT_PEOPLE_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        26.04.2007             1. Created this package.
******************************************************************************/

function get_checksum(X_PEOPLE_ID NUMBER) return varchar2;

procedure update_row(X_PEOPLE_ID     RNT_PEOPLE.PEOPLE_ID%TYPE,
                     X_FIRST_NAME    RNT_PEOPLE.FIRST_NAME%TYPE,
                     X_LAST_NAME     RNT_PEOPLE.LAST_NAME%TYPE,
                     X_PHONE1        RNT_PEOPLE.PHONE1%TYPE,
                     X_PHONE2        RNT_PEOPLE.PHONE2%TYPE,
                     X_DATE_OF_BIRTH RNT_PEOPLE.DATE_OF_BIRTH%TYPE,
                     X_EMAIL_ADDRESS RNT_PEOPLE.EMAIL_ADDRESS%TYPE,
                     X_SSN           RNT_PEOPLE.SSN%TYPE,
                     X_DRIVERS_LICENSE RNT_PEOPLE.DRIVERS_LICENSE%TYPE,
                     X_IS_ENABLED_YN RNT_PEOPLE.IS_ENABLED_YN%TYPE,
                     X_BUSINESS_ID   RNT_PEOPLE.BUSINESS_ID%TYPE, 
                     X_CHECKSUM      VARCHAR2
                    );
                    
function insert_row( X_FIRST_NAME    RNT_PEOPLE.FIRST_NAME%TYPE,
                     X_LAST_NAME     RNT_PEOPLE.LAST_NAME%TYPE,
                     X_PHONE1        RNT_PEOPLE.PHONE1%TYPE,
                     X_PHONE2        RNT_PEOPLE.PHONE2%TYPE,
                     X_DATE_OF_BIRTH RNT_PEOPLE.DATE_OF_BIRTH%TYPE,
                     X_EMAIL_ADDRESS RNT_PEOPLE.EMAIL_ADDRESS%TYPE,
                     X_SSN           RNT_PEOPLE.SSN%TYPE,
                     X_DRIVERS_LICENSE RNT_PEOPLE.DRIVERS_LICENSE%TYPE,
                     X_IS_ENABLED_YN RNT_PEOPLE.IS_ENABLED_YN%TYPE,
                     X_BUSINESS_ID   RNT_PEOPLE.BUSINESS_ID%TYPE
                    ) return RNT_PEOPLE.PEOPLE_ID%TYPE;
                    
procedure delete_row(X_PEOPLE_ID       RNT_PEOPLE.PEOPLE_ID%TYPE);

END RNT_PEOPLE_PKG;
/

SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY        RNT_PEOPLE_PKG AS
/******************************************************************************
   NAME:       RNT_PEOPLE_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        26.04.2007             1. Created this package body.
******************************************************************************/

function get_checksum(X_PEOPLE_ID NUMBER) return varchar2
is
begin
    for x in (select  
                   PEOPLE_ID, FIRST_NAME, LAST_NAME, 
                   PHONE1, PHONE2, DATE_OF_BIRTH, EMAIL_ADDRESS, 
                   SSN, DRIVERS_LICENSE, BUSINESS_ID, IS_ENABLED_YN
                from RNT_PEOPLE
                where PEOPLE_ID = X_PEOPLE_ID) loop
         RNT_SYS_CHECKSUM_REC_PKG.INIT;
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.PEOPLE_ID);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.FIRST_NAME);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.LAST_NAME);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.PHONE1);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.PHONE2);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.DATE_OF_BIRTH);         
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.EMAIL_ADDRESS);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.SSN);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.DRIVERS_LICENSE);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.BUSINESS_ID);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.IS_ENABLED_YN);
         return RNT_SYS_CHECKSUM_REC_PKG.GET_CHECKSUM;
   end loop;
   RAISE_APPLICATION_ERROR(-20100, 'Not found record in RNT_PEOPLE');   
end;

procedure lock_row(X_PEOPLE_ID RNT_PEOPLE.PEOPLE_ID%TYPE)
is
  cursor c is
     select * 
     from RNT_PEOPLE   
     where PEOPLE_ID = X_PEOPLE_ID
     for update of PEOPLE_ID nowait; 
begin
  open c;
  close c;
exception
  when OTHERS then
    if SQLCODE = -54 then
      RAISE_APPLICATION_ERROR(-20001, 'Cannot changed record. Record is locked.');
    end if;       
end;

function check_unique(X_PEOPLE_ID     RNT_PEOPLE.PEOPLE_ID%TYPE,
                      X_LAST_NAME     RNT_PEOPLE.LAST_NAME%TYPE,
                      X_FIRST_NAME    RNT_PEOPLE.FIRST_NAME%TYPE,
                      X_BUSINESS_ID   RNT_PEOPLE.BUSINESS_ID%TYPE
                      ) return boolean
is
  x NUMBER;
begin
   select 1 
   into x
   from DUAL
   where exists (
                   select 1
                   from RNT_PEOPLE
                   where (PEOPLE_ID != X_PEOPLE_ID or X_PEOPLE_ID is null) 
                     and LAST_NAME = X_LAST_NAME
                     and FIRST_NAME = X_FIRST_NAME
                     and BUSINESS_ID = X_BUSINESS_ID             
                 );
  return false;
exception
  when NO_DATA_FOUND then
     return true;                        
end;                 

procedure update_row(X_PEOPLE_ID     RNT_PEOPLE.PEOPLE_ID%TYPE,
                     X_FIRST_NAME    RNT_PEOPLE.FIRST_NAME%TYPE,
                     X_LAST_NAME     RNT_PEOPLE.LAST_NAME%TYPE,
                     X_PHONE1        RNT_PEOPLE.PHONE1%TYPE,
                     X_PHONE2        RNT_PEOPLE.PHONE2%TYPE,
                     X_DATE_OF_BIRTH RNT_PEOPLE.DATE_OF_BIRTH%TYPE,
                     X_EMAIL_ADDRESS RNT_PEOPLE.EMAIL_ADDRESS%TYPE,
                     X_SSN           RNT_PEOPLE.SSN%TYPE,
                     X_DRIVERS_LICENSE RNT_PEOPLE.DRIVERS_LICENSE%TYPE,
                     X_IS_ENABLED_YN RNT_PEOPLE.IS_ENABLED_YN%TYPE,
                     X_BUSINESS_ID   RNT_PEOPLE.BUSINESS_ID%TYPE,
                     X_CHECKSUM      VARCHAR2
                    )
is
 l_checksum varchar2(32); 
begin
   lock_row(X_PEOPLE_ID);
   
   -- validate checksum   
   l_checksum := get_checksum(X_PEOPLE_ID);
   if X_CHECKSUM != l_checksum then
      RAISE_APPLICATION_ERROR(-20002, 'Record was changed another user.');
   end if;

   if not check_unique(X_PEOPLE_ID, X_LAST_NAME, X_FIRST_NAME, X_BUSINESS_ID) then
        RAISE_APPLICATION_ERROR(-20006, 'Last and first name for people must be unique.');                      
   end if;   
   
   update RNT_PEOPLE
   set FIRST_NAME      = X_FIRST_NAME,
       LAST_NAME       = X_LAST_NAME,
       PHONE1          = X_PHONE1,
       PHONE2          = X_PHONE2,
       DATE_OF_BIRTH   = X_DATE_OF_BIRTH,
       EMAIL_ADDRESS   = X_EMAIL_ADDRESS,
       SSN             = X_SSN,
       DRIVERS_LICENSE = X_DRIVERS_LICENSE,
       IS_ENABLED_YN   = X_IS_ENABLED_YN
   where PEOPLE_ID     = X_PEOPLE_ID;
end;

function insert_row( X_FIRST_NAME    RNT_PEOPLE.FIRST_NAME%TYPE,
                     X_LAST_NAME     RNT_PEOPLE.LAST_NAME%TYPE,
                     X_PHONE1        RNT_PEOPLE.PHONE1%TYPE,
                     X_PHONE2        RNT_PEOPLE.PHONE2%TYPE,
                     X_DATE_OF_BIRTH RNT_PEOPLE.DATE_OF_BIRTH%TYPE,
                     X_EMAIL_ADDRESS RNT_PEOPLE.EMAIL_ADDRESS%TYPE,
                     X_SSN           RNT_PEOPLE.SSN%TYPE,
                     X_DRIVERS_LICENSE RNT_PEOPLE.DRIVERS_LICENSE%TYPE,
                     X_IS_ENABLED_YN RNT_PEOPLE.IS_ENABLED_YN%TYPE,
                     X_BUSINESS_ID   RNT_PEOPLE.BUSINESS_ID%TYPE
                    ) return RNT_PEOPLE.PEOPLE_ID%TYPE
is
  x RNT_PEOPLE.PEOPLE_ID%TYPE;
 -- X_BUSINESS_ID   RNT_PEOPLE.BUSINESS_ID%TYPE; 
begin
   if not check_unique(NULL, X_LAST_NAME, X_FIRST_NAME, X_BUSINESS_ID) then
        RAISE_APPLICATION_ERROR(-20006, 'Last and first name for people must be unique.');                      
   end if;
      
--   X_BUSINESS_ID := RNT_USERS_PKG.GET_CURRENT_BUSINESS_UNIT();
   
   insert into RNT_PEOPLE (
               PEOPLE_ID, FIRST_NAME, LAST_NAME, 
               PHONE1, PHONE2, DATE_OF_BIRTH, EMAIL_ADDRESS, 
               SSN, DRIVERS_LICENSE, BUSINESS_ID, 
               IS_ENABLED_YN) 
   values (RNT_PEOPLE_SEQ.NEXTVAL, X_FIRST_NAME, X_LAST_NAME, 
           X_PHONE1, X_PHONE2, X_DATE_OF_BIRTH, X_EMAIL_ADDRESS, 
           X_SSN, X_DRIVERS_LICENSE, X_BUSINESS_ID, 
           X_IS_ENABLED_YN)
   returning PEOPLE_ID into x;
   return x;
end;                                                      


function is_exists_tenant(X_PEOPLE_ID RNT_PEOPLE.PEOPLE_ID%TYPE) return boolean
is
 x NUMBER;
begin
  select 1
  into x
  from DUAL
  where exists (select 1
                from RNT_TENANT
                where PEOPLE_ID = X_PEOPLE_ID
                );
  return true;
exception
  when NO_DATA_FOUND then
     return false;   
end;

procedure delete_row(X_PEOPLE_ID       RNT_PEOPLE.PEOPLE_ID%TYPE)
is
begin
  -- check for exists child records
  if is_exists_tenant(X_PEOPLE_ID) then
     RAISE_APPLICATION_ERROR(-20004, 'Cannot delete record. For people exists tenant. Instead set enaled flag to No');
  end if; 
    
  delete from RNT_PEOPLE
  where PEOPLE_ID = X_PEOPLE_ID;
end;


END RNT_PEOPLE_PKG;
/

SHOW ERRORS;

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
        RAISE_APPLICATION_ERROR(-20006, 'User must have unique role and business unit.');                      
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

SHOW ERRORS;

CREATE OR REPLACE FORCE VIEW RNT_ACCOUNTS_PAYABLE_V
(AP_ID, PAYMENT_DUE_DATE, AMOUNT, PAYMENT_TYPE_ID, EXPENSE_ID, 
 LOAN_ID, SUPPLIER_ID, PAYMENT_PROPERTY_ID, CHECKSUM, SUPPLIER_NAME)
AS 
select ap.AP_ID
,      ap.PAYMENT_DUE_DATE
,      ap.AMOUNT
,      ap.PAYMENT_TYPE_ID
,      ap.EXPENSE_ID
,      ap.LOAN_ID
,      ap.SUPPLIER_ID
,      ap.PAYMENT_PROPERTY_ID
,      rnt_sys_checksum_rec_pkg.get_checksum('AP_ID='||ap.AP_ID||'PAYMENT_DUE_DATE='||ap.PAYMENT_DUE_DATE||'AMOUNT='||ap.AMOUNT||'PAYMENT_TYPE_ID='||ap.PAYMENT_TYPE_ID||'EXPENSE_ID='||ap.EXPENSE_ID||'LOAN_ID='||ap.LOAN_ID||'SUPPLIER_ID='||ap.SUPPLIER_ID||'PAYMENT_PROPERTY_ID='||PAYMENT_PROPERTY_ID) as CHECKSUM
,      s.NAME as SUPPLIER_NAME    
from RNT_ACCOUNTS_PAYABLE ap,
     RNT_SUPPLIERS s
where ap.SUPPLIER_ID = s.SUPPLIER_ID;

CREATE OR REPLACE FORCE VIEW RNT_ACCOUNTS_PAYABLE_ALL_V
(AP_ID, PAYMENT_DUE_DATE, AMOUNT, PAYMENT_TYPE_ID, EXPENSE_ID, 
 LOAN_ID, SUPPLIER_ID, PAYMENT_PROPERTY_ID, CHECKSUM)
AS 
select 
   ap.AP_ID, ap.PAYMENT_DUE_DATE, ap.AMOUNT, 
   ap.PAYMENT_TYPE_ID, ap.EXPENSE_ID, ap.LOAN_ID, 
   ap.SUPPLIER_ID, ap.PAYMENT_PROPERTY_ID,
   rnt_sys_checksum_rec_pkg.get_checksum('AP_ID='||ap.AP_ID||'PAYMENT_DUE_DATE='||ap.PAYMENT_DUE_DATE||
   'AMOUNT='||ap.AMOUNT||'PAYMENT_TYPE_ID='||ap.PAYMENT_TYPE_ID||'EXPENSE_ID='||ap.EXPENSE_ID||
   'LOAN_ID='||ap.LOAN_ID||'SUPLIER_ID='||ap.SUPPLIER_ID||'PAYMENT_PROPERTY_ID='||ap.PAYMENT_PROPERTY_ID) as CHECKSUM
from RNT_ACCOUNTS_PAYABLE ap;

CREATE OR REPLACE FORCE VIEW RNT_ACCOUNTS_RECEIVABLE_ALL_V
(AR_ID, PAYMENT_DUE_DATE, AMOUNT, PAYMENT_TYPE, TENANT_ID, 
 AGREEMENT_ID, LOAN_ID, BUSINESS_ID, IS_GENERATED_YN, AGREEMENT_ACTION_ID, 
 PAYMENT_PROPERTY_ID, SOURCE_PAYMENT_ID, CHECKSUM)
AS 
select ar.AR_ID
,      ar.PAYMENT_DUE_DATE
,      ar.AMOUNT
,      ar.PAYMENT_TYPE
,      ar.TENANT_ID
,      ar.AGREEMENT_ID
,      ar.LOAN_ID
,      ar.BUSINESS_ID
,      ar.IS_GENERATED_YN
,      ar.AGREEMENT_ACTION_ID
,      ar.PAYMENT_PROPERTY_ID
,      ar.SOURCE_PAYMENT_ID
,      rnt_sys_checksum_rec_pkg.get_checksum('AR_ID='||ar.AR_ID||'PAYMENT_DUE_DATE='||ar.PAYMENT_DUE_DATE||'AMOUNT='||ar.AMOUNT||'PAYMENT_TYPE='||ar.PAYMENT_TYPE||'TENANT_ID='||ar.TENANT_ID||'AGREEMENT_ID='||ar.AGREEMENT_ID||'LOAN_ID='||ar.LOAN_ID||'BUSINESS_ID='||ar.BUSINESS_ID||'IS_GENERATED_YN='||ar.IS_GENERATED_YN||
        'AGREEMENT_ACTION_ID='||ar.AGREEMENT_ACTION_ID||'PAYMENT_PROPERTY_ID='||ar.PAYMENT_PROPERTY_ID||
        'SOURCE_PAYMENT_ID'||ar.SOURCE_PAYMENT_ID) as CHECKSUM
from RNT_ACCOUNTS_RECEIVABLE ar;

CREATE OR REPLACE package        RNT_ACCOUNTS_PAYABLE_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_ACCOUNTS_PAYABLE_PKG
    Purpose:   API's for RNT_ACCOUNTS_PAYABLE table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        06-MAY-07   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE)
            return RNT_ACCOUNTS_PAYABLE_V.CHECKSUM%TYPE;

  procedure update_row( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE
                      , X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_PAYABLE.PAYMENT_DUE_DATE%TYPE
                      , X_AMOUNT IN RNT_ACCOUNTS_PAYABLE.AMOUNT%TYPE
                      , X_PAYMENT_TYPE_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_TYPE_ID%TYPE
                      , X_EXPENSE_ID IN RNT_ACCOUNTS_PAYABLE.EXPENSE_ID%TYPE
                      , X_LOAN_ID IN RNT_ACCOUNTS_PAYABLE.LOAN_ID%TYPE
                      , X_SUPPLIER_ID IN RNT_ACCOUNTS_PAYABLE.SUPPLIER_ID%TYPE
                      , X_CHECKSUM IN RNT_ACCOUNTS_PAYABLE_V.CHECKSUM%TYPE
                      , X_PAYMENT_PROPERTY_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID%TYPE);

  function insert_row( X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_PAYABLE.PAYMENT_DUE_DATE%TYPE
                     , X_AMOUNT IN RNT_ACCOUNTS_PAYABLE.AMOUNT%TYPE
                     , X_PAYMENT_TYPE_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_TYPE_ID%TYPE
                     , X_EXPENSE_ID IN RNT_ACCOUNTS_PAYABLE.EXPENSE_ID%TYPE
                     , X_LOAN_ID IN RNT_ACCOUNTS_PAYABLE.LOAN_ID%TYPE
                     , X_SUPPLIER_ID IN RNT_ACCOUNTS_PAYABLE.SUPPLIER_ID%TYPE
                     , X_PAYMENT_PROPERTY_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID%TYPE)
              return RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE;

  procedure delete_row( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE);

  procedure update_row2( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE
                       , X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_PAYABLE.PAYMENT_DUE_DATE%TYPE
                       , X_AMOUNT IN RNT_ACCOUNTS_PAYABLE.AMOUNT%TYPE
                       , X_PAYMENT_TYPE_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_TYPE_ID%TYPE
                       , X_EXPENSE_ID IN RNT_ACCOUNTS_PAYABLE.EXPENSE_ID%TYPE
                       , X_LOAN_ID IN RNT_ACCOUNTS_PAYABLE.LOAN_ID%TYPE
                       , X_SUPPLIER_ID IN RNT_ACCOUNTS_PAYABLE.SUPPLIER_ID%TYPE
                       , X_CHECKSUM IN RNT_ACCOUNTS_PAYABLE_V.CHECKSUM%TYPE
                       , X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE
                       , X_PAYMENT_PROPERTY_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID%TYPE
                       );
end RNT_ACCOUNTS_PAYABLE_PKG;
/

SHOW ERRORS;

CREATE OR REPLACE PACKAGE        RNT_USERS_PKG AS
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

function CHANGE_PASSWORD(X_USER_ID RNT_USERS.USER_ID%TYPE, 
                         X_NEW_PASSWORD RNT_USERS.USER_PASSWORD%TYPE,
                         X_OLD_PASSWORD RNT_USERS.USER_PASSWORD%TYPE) return VARCHAR2;

procedure SET_PASSWORD(X_USER_ID RNT_USERS.USER_ID%TYPE, 
                       X_NEW_PASSWORD RNT_USERS.USER_PASSWORD%TYPE);
                       
procedure CHANGE_ACTIVE_FLAG(X_USER_ID RNT_USERS.USER_ID%TYPE);

function get_checksum(X_USER_ID RNT_USERS.USER_ID%TYPE) return varchar2;

procedure UPDATE_ROW(X_USER_ID RNT_USERS.USER_ID%TYPE,
                     X_USER_LOGIN RNT_USERS.USER_LOGIN%TYPE,
                     X_USER_NAME RNT_USERS.USER_NAME%TYPE,
                     X_IS_ACTIVE_YN RNT_USERS.IS_ACTIVE_YN%TYPE,
                     X_CHECKSUM VARCHAR2
                     );

function INSERT_ROW(X_USER_LOGIN RNT_USERS.USER_LOGIN%TYPE,
                    X_USER_NAME RNT_USERS.USER_NAME%TYPE,
                    X_USER_PASSWORD RNT_USERS.USER_PASSWORD%TYPE, 
                    X_IS_ACTIVE_YN RNT_USERS.IS_ACTIVE_YN%TYPE                   
                   ) return RNT_USERS.USER_ID%TYPE; 

function GET_CURRENT_BUSINESS_UNIT return RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE;

END RNT_USERS_PKG;
/

SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY        RNT_USERS_PKG AS
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
  where UPPER(USER_LOGIN) = UPPER(X_LOGIN)
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

function CHANGE_PASSWORD(X_USER_ID RNT_USERS.USER_ID%TYPE, 
                         X_NEW_PASSWORD RNT_USERS.USER_PASSWORD%TYPE,
                         X_OLD_PASSWORD RNT_USERS.USER_PASSWORD%TYPE) return VARCHAR2
is
  x NUMBER;
begin
  begin
   select 1
   into x 
   from RNT_USERS
   where USER_ID = X_USER_ID
     and USER_PASSWORD = X_OLD_PASSWORD;
  exception
    when NO_DATA_FOUND then
       RAISE_APPLICATION_ERROR(-20340, 'Cannot change password. Old password is a not valid.');   
  end; 
  
  update RNT_USERS
  set USER_PASSWORD = X_NEW_PASSWORD
  where USER_ID = X_USER_ID;
  if SQL%ROWCOUNT = 1 then
     return 'Y';
  end if;
  return 'N';   
end;

procedure SET_PASSWORD(X_USER_ID RNT_USERS.USER_ID%TYPE, 
                       X_NEW_PASSWORD RNT_USERS.USER_PASSWORD%TYPE) 
is
begin
  update RNT_USERS
  set USER_PASSWORD = X_NEW_PASSWORD
  where USER_ID = X_USER_ID;
  if SQL%ROWCOUNT = 1 then
     NULL;
  else
     RAISE_APPLICATION_ERROR(-20004, 'Password not changed');     
  end if;
end;                         


procedure change_active_flag(X_USER_ID RNT_USERS.USER_ID%TYPE)
is
  x VARCHAR2(1);
begin
  select IS_ACTIVE_YN
  into x
  from RNT_USERS
  where USER_ID = X_USER_ID;
  
  if x = 'N' then
     x := 'Y';
  else
     x := 'N';
  end if;
  
  update RNT_USERS
  set IS_ACTIVE_YN = x
  where USER_ID = X_USER_ID;    

end;

function get_checksum(X_USER_ID RNT_USERS.USER_ID%TYPE) return varchar2
is
begin
  for x in (select USER_ID, USER_LOGIN, USER_NAME, USER_PASSWORD, IS_ACTIVE_YN
            from RNT_USERS 
            where USER_ID = X_USER_ID) 
 loop
     RNT_SYS_CHECKSUM_REC_PKG.INIT;
     RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.USER_ID);         
     RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.USER_LOGIN);
     RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.USER_NAME); 
     RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.IS_ACTIVE_YN);
     return RNT_SYS_CHECKSUM_REC_PKG.GET_CHECKSUM;
 end loop;           
end;

function check_unique(X_USER_ID RNT_USERS.USER_ID%TYPE,
                      X_USER_LOGIN RNT_USERS.USER_LOGIN%TYPE
                      ) return boolean
is
  x NUMBER;
begin
   select 1 
   into x
   from DUAL
   where exists (
                   select 1
                   from RNT_USERS
                   where UPPER(USER_LOGIN) = UPPER(X_USER_LOGIN)
                     and (USER_ID != X_USER_ID or X_USER_ID is null)
                 );
  return false;
exception
  when NO_DATA_FOUND then
     return true;                        
end;                       
                      

procedure lock_row(X_USER_ID RNT_USERS.USER_ID%TYPE)
is
    cursor c is
             select USER_ID, USER_LOGIN, USER_NAME, 
                    USER_PASSWORD, IS_ACTIVE_YN
             from RNT_USERS
             where USER_ID = X_USER_ID
             for update of USER_ID nowait; 
begin
  open c;
  close c;
exception
  when OTHERS then
    if SQLCODE = -54 then
      RAISE_APPLICATION_ERROR(-20001, 'Cannot changed record. Record is locked.');
    end if; 
end;


procedure UPDATE_ROW(X_USER_ID RNT_USERS.USER_ID%TYPE,
                     X_USER_LOGIN RNT_USERS.USER_LOGIN%TYPE,
                     X_USER_NAME RNT_USERS.USER_NAME%TYPE,
                     X_IS_ACTIVE_YN RNT_USERS.IS_ACTIVE_YN%TYPE,
                     X_CHECKSUM VARCHAR2
                     )
is
l_checksum varchar2(32); 
begin
   
   lock_row(X_USER_ID);
   
   -- validate checksum   
   l_checksum := get_checksum(X_USER_ID);
   if X_CHECKSUM != l_checksum then
      RAISE_APPLICATION_ERROR(-20002, 'Record was changed another user.');
   end if;

   if not check_unique(X_USER_ID, X_USER_LOGIN) then
        RAISE_APPLICATION_ERROR(-20006, 'User login must be unique');                      
   end if;   
   
   update RNT_USERS
   set USER_LOGIN    = X_USER_LOGIN,
       USER_NAME     = X_USER_NAME,
       IS_ACTIVE_YN  = X_IS_ACTIVE_YN
   where USER_ID     = X_USER_ID;
end;
       
function INSERT_ROW(X_USER_LOGIN RNT_USERS.USER_LOGIN%TYPE,
                    X_USER_NAME RNT_USERS.USER_NAME%TYPE,
                    X_USER_PASSWORD RNT_USERS.USER_PASSWORD%TYPE, 
                    X_IS_ACTIVE_YN RNT_USERS.IS_ACTIVE_YN%TYPE                   
                   ) return RNT_USERS.USER_ID%TYPE
is
   x RNT_USERS.USER_ID%TYPE;
begin
   if not check_unique(NULL, X_USER_LOGIN) then
        RAISE_APPLICATION_ERROR(-20006, 'User login must be unique');                      
   end if;   
   insert into RNT_USERS (USER_ID, USER_LOGIN, USER_NAME, 
                          USER_PASSWORD, IS_ACTIVE_YN) 
   values (RNT_USERS_SEQ.NEXTVAL, X_USER_LOGIN, X_USER_NAME, 
           X_USER_PASSWORD, X_IS_ACTIVE_YN)
   returning USER_ID into x;
   return x;
end;
 
function GET_CURRENT_BUSINESS_UNIT return RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE
is
  x RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE;
begin
  select BUSINESS_ID
  into x
  from RNT_BUSINESS_UNITS
  where PARENT_BUSINESS_ID = 0;
  
  return x;
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

SHOW ERRORS;

CREATE OR REPLACE package body        RNT_ACCOUNTS_PAYABLE_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_ACCOUNTS_PAYABLE_PKG
    Purpose:   API's for RNT_ACCOUNTS_PAYABLE table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        06-MAY-07   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE) is
     cursor c is
     select * from RNT_ACCOUNTS_PAYABLE
     where AP_ID = X_AP_ID
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
  function get_checksum( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE)
            return RNT_ACCOUNTS_PAYABLE_V.CHECKSUM%TYPE is 

    v_return_value               RNT_ACCOUNTS_PAYABLE_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_ACCOUNTS_PAYABLE_V
    where AP_ID = X_AP_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE
                      , X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_PAYABLE.PAYMENT_DUE_DATE%TYPE
                      , X_AMOUNT IN RNT_ACCOUNTS_PAYABLE.AMOUNT%TYPE
                      , X_PAYMENT_TYPE_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_TYPE_ID%TYPE
                      , X_EXPENSE_ID IN RNT_ACCOUNTS_PAYABLE.EXPENSE_ID%TYPE
                      , X_LOAN_ID IN RNT_ACCOUNTS_PAYABLE.LOAN_ID%TYPE
                      , X_SUPPLIER_ID IN RNT_ACCOUNTS_PAYABLE.SUPPLIER_ID%TYPE
                      , X_CHECKSUM IN RNT_ACCOUNTS_PAYABLE_V.CHECKSUM%TYPE
                      , X_PAYMENT_PROPERTY_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID%TYPE)
  is
     l_checksum          RNT_ACCOUNTS_PAYABLE_V.CHECKSUM%TYPE;
  begin
     lock_row(X_AP_ID);

      -- validate checksum
      l_checksum := get_checksum(X_AP_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;
     
     update RNT_ACCOUNTS_PAYABLE
     set PAYMENT_DUE_DATE = X_PAYMENT_DUE_DATE
     , AMOUNT = X_AMOUNT
     , PAYMENT_TYPE_ID = X_PAYMENT_TYPE_ID
     , EXPENSE_ID = X_EXPENSE_ID
     , LOAN_ID = X_LOAN_ID
     , SUPPLIER_ID = X_SUPPLIER_ID
     , PAYMENT_PROPERTY_ID = X_PAYMENT_PROPERTY_ID
     where AP_ID = X_AP_ID;

  end update_row;

  function insert_row( X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_PAYABLE.PAYMENT_DUE_DATE%TYPE
                     , X_AMOUNT IN RNT_ACCOUNTS_PAYABLE.AMOUNT%TYPE
                     , X_PAYMENT_TYPE_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_TYPE_ID%TYPE
                     , X_EXPENSE_ID IN RNT_ACCOUNTS_PAYABLE.EXPENSE_ID%TYPE
                     , X_LOAN_ID IN RNT_ACCOUNTS_PAYABLE.LOAN_ID%TYPE
                     , X_SUPPLIER_ID IN RNT_ACCOUNTS_PAYABLE.SUPPLIER_ID%TYPE
                     , X_PAYMENT_PROPERTY_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID%TYPE)
              return RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE
  is
     x          number;
  begin

     insert into RNT_ACCOUNTS_PAYABLE
     ( AP_ID
     , PAYMENT_DUE_DATE
     , AMOUNT
     , PAYMENT_TYPE_ID
     , EXPENSE_ID
     , LOAN_ID
     , SUPPLIER_ID
     , PAYMENT_PROPERTY_ID)
     values
     ( RNT_ACCOUNTS_PAYABLE_SEQ.NEXTVAL
     , X_PAYMENT_DUE_DATE
     , X_AMOUNT
     , X_PAYMENT_TYPE_ID
     , X_EXPENSE_ID
     , X_LOAN_ID
     , X_SUPPLIER_ID
     ,X_PAYMENT_PROPERTY_ID)
     returning AP_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE) is

  begin
    delete from RNT_ACCOUNTS_PAYABLE
    where AP_ID = X_AP_ID;
  end delete_row;
  
  procedure update_allocation(X_AP_ID IN RNT_PAYMENT_ALLOCATIONS.AP_ID%TYPE 
                    , X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE
                    , X_AMOUNT IN RNT_PAYMENT_ALLOCATIONS.AMOUNT%TYPE
                   )
  is
  begin
  if X_PAYMENT_DATE is null then
      delete from RNT_PAYMENT_ALLOCATIONS
      where AP_ID =X_AP_ID; 
    else
      update RNT_PAYMENT_ALLOCATIONS
      set PAYMENT_DATE = X_PAYMENT_DATE,
          AMOUNT = X_AMOUNT
      where AP_ID = X_AP_ID;
      if SQL%ROWCOUNT = 0 then
         insert into RNT_PAYMENT_ALLOCATIONS (
                   PAY_ALLOC_ID, PAYMENT_DATE, AMOUNT, 
                   AR_ID, AP_ID, PAYMENT_ID) 
          values (RNT_PAYMENT_ALLOCATIONS_SEQ.NEXTVAL, X_PAYMENT_DATE, X_AMOUNT,
                  NULL, X_AP_ID, NULL);
      end if;    
    end if;   
  end;                   

  procedure update_row2( X_AP_ID IN RNT_ACCOUNTS_PAYABLE.AP_ID%TYPE
                       , X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_PAYABLE.PAYMENT_DUE_DATE%TYPE
                       , X_AMOUNT IN RNT_ACCOUNTS_PAYABLE.AMOUNT%TYPE
                       , X_PAYMENT_TYPE_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_TYPE_ID%TYPE
                       , X_EXPENSE_ID IN RNT_ACCOUNTS_PAYABLE.EXPENSE_ID%TYPE
                       , X_LOAN_ID IN RNT_ACCOUNTS_PAYABLE.LOAN_ID%TYPE
                       , X_SUPPLIER_ID IN RNT_ACCOUNTS_PAYABLE.SUPPLIER_ID%TYPE
                       , X_CHECKSUM IN RNT_ACCOUNTS_PAYABLE_V.CHECKSUM%TYPE
                       , X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE
                       , X_PAYMENT_PROPERTY_ID IN RNT_ACCOUNTS_PAYABLE.PAYMENT_PROPERTY_ID%TYPE
                       )
  is
  begin
    update_row( X_AP_ID => X_AP_ID 
              , X_PAYMENT_DUE_DATE => X_PAYMENT_DUE_DATE
              , X_AMOUNT => X_AMOUNT
              , X_PAYMENT_TYPE_ID => X_PAYMENT_TYPE_ID
              , X_EXPENSE_ID => X_EXPENSE_ID
              , X_LOAN_ID => X_LOAN_ID
              , X_SUPPLIER_ID => X_SUPPLIER_ID
              , X_CHECKSUM => X_CHECKSUM
              , X_PAYMENT_PROPERTY_ID => X_PAYMENT_PROPERTY_ID
              );
    update_allocation(X_AP_ID => X_AP_ID
                    , X_PAYMENT_DATE => X_PAYMENT_DATE
                    , X_AMOUNT => X_AMOUNT
                      );               
  end;                       
end RNT_ACCOUNTS_PAYABLE_PKG;
/

SHOW ERRORS;

CREATE OR REPLACE FORCE VIEW RNT_ACCOUNTS_RECEIVABLE_V
(AR_ID, PAYMENT_DUE_DATE, AMOUNT, PAYMENT_TYPE, TENANT_ID, 
 AGREEMENT_ID, LOAN_ID, BUSINESS_ID, IS_GENERATED_YN, AGREEMENT_ACTION_ID, 
 PAYMENT_PROPERTY_ID, CHECKSUM, PROPERTY_ID, RECEIVABLE_TYPE_NAME, UNIT_NAME, 
 ADDRESS1, ZIPCODE, UNITS, SOURCE_PAYMENT_ID, TENANT_NAME)
AS 
select ar.AR_ID
,      ar.PAYMENT_DUE_DATE
,      ar.AMOUNT
,      ar.PAYMENT_TYPE
,      ar.TENANT_ID
,      ar.AGREEMENT_ID
,      ar.LOAN_ID
,      ar.BUSINESS_ID
,      ar.IS_GENERATED_YN
,      ar.AGREEMENT_ACTION_ID
,      ar.PAYMENT_PROPERTY_ID
,      ar.CHECKSUM
,      u.PROPERTY_ID
,      pt.PAYMENT_TYPE_NAME as RECEIVABLE_TYPE_NAME
,      u.UNIT_NAME
,      prop.ADDRESS1
,      prop.ZIPCODE
,      prop.UNITS
,      ar.SOURCE_PAYMENT_ID
,      p.LAST_NAME||' '||p.FIRST_NAME as TENANT_NAME
from RNT_ACCOUNTS_RECEIVABLE_ALL_V ar,
     RNT_TENANT t,
     RNT_PEOPLE p,
     RNT_TENANCY_AGREEMENT a,
     RNT_PROPERTY_UNITS u,
     RNT_PAYMENT_TYPES pt,
     RNT_PROPERTIES prop
where a.AGREEMENT_ID = ar.AGREEMENT_ID
  and u.UNIT_ID = a.UNIT_ID
  and pt.PAYMENT_TYPE_ID = ar.PAYMENT_TYPE
  and prop.PROPERTY_ID = u.PROPERTY_ID
  and t.TENANT_ID = ar.TENANT_ID
  and p.PEOPLE_ID = t.PEOPLE_ID;

CREATE OR REPLACE FORCE VIEW RNT_ACCOUNTS_RECEIVABLE_PROP_V
(AR_ID, PAYMENT_DUE_DATE, AMOUNT, PAYMENT_TYPE, TENANT_ID, 
 AGREEMENT_ID, LOAN_ID, BUSINESS_ID, IS_GENERATED_YN, AGREEMENT_ACTION_ID, 
 PAYMENT_PROPERTY_ID, PROPERTY_NAME, CHECKSUM, PAYMENT_DATE)
AS 
select ar.AR_ID
,      ar.PAYMENT_DUE_DATE
,      ar.AMOUNT
,      ar.PAYMENT_TYPE
,      ar.TENANT_ID
,      ar.AGREEMENT_ID
,      ar.LOAN_ID
,      ar.BUSINESS_ID
,      ar.IS_GENERATED_YN
,      ar.AGREEMENT_ACTION_ID
,      ar.PAYMENT_PROPERTY_ID
,      p.ADDRESS1 as PROPERTY_NAME
,      ar.CHECKSUM
,      pa.PAYMENT_DATE
 from RNT_ACCOUNTS_RECEIVABLE_ALL_V ar,
      RNT_PROPERTIES p,
      RNT_PAYMENT_ALLOCATIONS pa 
where ar.PAYMENT_PROPERTY_ID = p.PROPERTY_ID
  and pa.AR_ID(+) = ar.AR_ID;

CREATE OR REPLACE FORCE VIEW RNT_ACCNTS_PAYABLE_EXPENSES_V
(AP_ID, PAYMENT_DUE_DATE, AMOUNT, PAYMENT_TYPE_ID, EXPENSE_ID, 
 LOAN_ID, SUPPLIER_ID, PAYMENT_PROPERTY_ID, CHECKSUM, SUPPLIER_NAME, 
 PROPERTY_ID, PROPERTY_NAME, BUSINESS_ID, PAYMENT_TYPE_NAME, PAYMENT_DATE)
AS 
select ap.AP_ID
,      ap.PAYMENT_DUE_DATE
,      ap.AMOUNT
,      ap.PAYMENT_TYPE_ID
,      ap.EXPENSE_ID
,      ap.LOAN_ID
,      ap.SUPPLIER_ID
,      ap.PAYMENT_PROPERTY_ID
,      ap.CHECKSUM
,      s.NAME as SUPPLIER_NAME
,      ex.PROPERTY_ID
,      p.ADDRESS1 as PROPERTY_NAME
,      p.BUSINESS_ID
,      pt.PAYMENT_TYPE_NAME
,      pa.PAYMENT_DATE
from RNT_ACCOUNTS_PAYABLE_ALL_V ap,
     RNT_SUPPLIERS s,
     RNT_PROPERTY_EXPENSES ex,
     RNT_PROPERTIES p,
     RNT_PAYMENT_TYPES pt,
     RNT_PAYMENT_ALLOCATIONS pa 
where s.SUPPLIER_ID = ap.SUPPLIER_ID
  and ap.EXPENSE_ID = ex.EXPENSE_ID 
  and p.PROPERTY_ID = ex.PROPERTY_ID
  and pt.PAYMENT_TYPE_ID = ap.PAYMENT_TYPE_ID
  and pa.AP_ID(+) = ap.AP_ID;

CREATE OR REPLACE FORCE VIEW RNT_ACCOUNTS_PAYABLE_PROP_V
(AP_ID, PAYMENT_DUE_DATE, AMOUNT, PAYMENT_TYPE_ID, EXPENSE_ID, 
 LOAN_ID, SUPPLIER_ID, PAYMENT_PROPERTY_ID, CHECKSUM, PAYMENT_DATE, 
 BUSINESS_ID)
AS 
select 
   ap.AP_ID, 
   ap.PAYMENT_DUE_DATE, 
   ap.AMOUNT, 
   ap.PAYMENT_TYPE_ID, 
   ap.EXPENSE_ID, 
   ap.LOAN_ID, 
   ap.SUPPLIER_ID, 
   ap.PAYMENT_PROPERTY_ID, 
   ap.CHECKSUM,
   pa.PAYMENT_DATE,
   p.BUSINESS_ID
from RNT_ACCOUNTS_PAYABLE_ALL_V ap,
     RNT_PROPERTIES p,
     RNT_PAYMENT_ALLOCATIONS pa 
where ap.PAYMENT_PROPERTY_ID = p.PROPERTY_ID
  and pa.AP_ID(+) = ap.AP_ID;

CREATE OR REPLACE package        RNT_ACCOUNTS_RECEIVABLE_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_ACCOUNTS_RECEIVABLE_PKG
    Purpose:   API's for RNT_ACCOUNTS_RECEIVABLE table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        14-MAY-07   Auto Generated   Initial Version
*******************************************************************************/
function PAYMENT_TYPE_RENT return NUMBER; -- CONSTANT NUMBER := 7;
function PAYMENT_TYPE_DISCOUNT_RENT return NUMBER; -- CONSTANT NUMBER := 8;
function PAYMENT_TYPE_RECOVERABLE return NUMBER; -- CONSTANT NUMBER := 9;
function PAYMENT_TYPE_LATE_FEE return NUMBER; --  CONSTANT NUMBER := 10;
function PAYMENT_TYPE_REMAINING_RENT return NUMBER; --  CONSTANT NUMBER := 13;
function PAYMENT_TYPE_SECTION8_RENT return NUMBER; --  CONSTANT NUMBER := 14;
  

  function get_checksum( X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE)
            return RNT_ACCOUNTS_RECEIVABLE_V.CHECKSUM%TYPE;

  procedure update_row( X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE
                      , X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_DUE_DATE%TYPE
                      , X_AMOUNT IN RNT_ACCOUNTS_RECEIVABLE.AMOUNT%TYPE
                      , X_PAYMENT_TYPE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_TYPE%TYPE
                      , X_TENANT_ID IN RNT_ACCOUNTS_RECEIVABLE.TENANT_ID%TYPE
                      , X_AGREEMENT_ID IN RNT_ACCOUNTS_RECEIVABLE.AGREEMENT_ID%TYPE
                      , X_LOAN_ID IN RNT_ACCOUNTS_RECEIVABLE.LOAN_ID%TYPE
                      , X_BUSINESS_ID IN RNT_ACCOUNTS_RECEIVABLE.BUSINESS_ID%TYPE
                      , X_IS_GENERATED_YN IN RNT_ACCOUNTS_RECEIVABLE.IS_GENERATED_YN%TYPE
                      , X_CHECKSUM IN RNT_ACCOUNTS_RECEIVABLE_V.CHECKSUM%TYPE
                      , X_AGREEMENT_ACTION_ID IN RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE
                      , X_PAYMENT_PROPERTY_ID IN RNT_PROPERTIES.PROPERTY_ID%TYPE
                      );

 procedure update_row_amount(  X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE
                      , X_AMOUNT IN RNT_ACCOUNTS_RECEIVABLE.AMOUNT%TYPE
                      , X_CHECKSUM IN RNT_ACCOUNTS_RECEIVABLE_V.CHECKSUM%TYPE
                      );
                      
  function insert_row( X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_DUE_DATE%TYPE
                     , X_AMOUNT IN RNT_ACCOUNTS_RECEIVABLE.AMOUNT%TYPE
                     , X_PAYMENT_TYPE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_TYPE%TYPE
                     , X_TENANT_ID IN RNT_ACCOUNTS_RECEIVABLE.TENANT_ID%TYPE
                     , X_AGREEMENT_ID IN RNT_ACCOUNTS_RECEIVABLE.AGREEMENT_ID%TYPE
                     , X_LOAN_ID IN RNT_ACCOUNTS_RECEIVABLE.LOAN_ID%TYPE
                     , X_BUSINESS_ID IN RNT_ACCOUNTS_RECEIVABLE.BUSINESS_ID%TYPE
                     , X_IS_GENERATED_YN IN RNT_ACCOUNTS_RECEIVABLE.IS_GENERATED_YN%TYPE
                     , X_AGREEMENT_ACTION_ID IN RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE
                     , X_PAYMENT_PROPERTY_ID IN RNT_PROPERTIES.PROPERTY_ID%TYPE
                   )
              return RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE;

  procedure delete_row( X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE);
  /*
  -- return type of payment for p_now_date
  function get_type_of_payment(   p_payment_due_date DATE  -- due payment date
                                , p_now_date DATE          -- current date
                                , p_discount_period NUMBER -- days for discount period
                                , p_discount_type varchar2 -- discount type LATE_FEE or DISCOUNT
                                ) return number;
  
  function get_amount_for_payment(  p_payment_due_date DATE  -- due payment date
                                  , p_now_date DATE          -- current date
                                  , p_discount_period NUMBER -- days for discount period
                                  , p_amount NUMBER          -- amount for payment due date
                                  , p_discount_amount NUMBER -- discount amount
                                  , p_discount_type varchar2 -- discount type LATE_FEE or DISCOUNT
                                  , p_new_type out NUMBER   -- type for payment 
                                  ) return number;
                                  
  procedure update_payment_list;
  */
  procedure generate_payment_list;
  
  procedure update_payment_from_allocation(
                                     X_AMOUNT IN RNT_PAYMENT_ALLOCATIONS.AMOUNT%TYPE, 
                                     X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE, 
                                     X_AR_ID IN RNT_PAYMENT_ALLOCATIONS.AR_ID%TYPE);
  
  function get_max_alloc_for_agr_action(X_ACTION_ID RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE) return NUMBER;
                                       
  procedure DELETE_AGR_ACTION_RECEIVABLE(X_ACTION_ID RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE);
  
  procedure update_row2(X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE
                      , X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_DUE_DATE%TYPE
                      , X_AMOUNT IN RNT_ACCOUNTS_RECEIVABLE.AMOUNT%TYPE
                      , X_PAYMENT_TYPE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_TYPE%TYPE
                      , X_TENANT_ID IN RNT_ACCOUNTS_RECEIVABLE.TENANT_ID%TYPE
                      , X_AGREEMENT_ID IN RNT_ACCOUNTS_RECEIVABLE.AGREEMENT_ID%TYPE
                      , X_LOAN_ID IN RNT_ACCOUNTS_RECEIVABLE.LOAN_ID%TYPE
                      , X_BUSINESS_ID IN RNT_ACCOUNTS_RECEIVABLE.BUSINESS_ID%TYPE
                      , X_IS_GENERATED_YN IN RNT_ACCOUNTS_RECEIVABLE.IS_GENERATED_YN%TYPE
                      , X_CHECKSUM IN RNT_ACCOUNTS_RECEIVABLE_V.CHECKSUM%TYPE
                      , X_AGREEMENT_ACTION_ID IN RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE
                      , X_PAYMENT_PROPERTY_ID IN RNT_PROPERTIES.PROPERTY_ID%TYPE
                      , X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE
                      );

  function insert_row2( X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_DUE_DATE%TYPE
                     , X_AMOUNT IN RNT_ACCOUNTS_RECEIVABLE.AMOUNT%TYPE
                     , X_PAYMENT_TYPE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_TYPE%TYPE
                     , X_TENANT_ID IN RNT_ACCOUNTS_RECEIVABLE.TENANT_ID%TYPE
                     , X_AGREEMENT_ID IN RNT_ACCOUNTS_RECEIVABLE.AGREEMENT_ID%TYPE
                     , X_LOAN_ID IN RNT_ACCOUNTS_RECEIVABLE.LOAN_ID%TYPE
                     , X_BUSINESS_ID IN RNT_ACCOUNTS_RECEIVABLE.BUSINESS_ID%TYPE
                     , X_IS_GENERATED_YN IN RNT_ACCOUNTS_RECEIVABLE.IS_GENERATED_YN%TYPE
                     , X_AGREEMENT_ACTION_ID IN RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE
                     , X_PAYMENT_PROPERTY_ID IN RNT_PROPERTIES.PROPERTY_ID%TYPE
                     , X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE                     
                   )
              return RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE;
              
  procedure delete_row2(X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE);               
end RNT_ACCOUNTS_RECEIVABLE_PKG;
/

SHOW ERRORS;

CREATE OR REPLACE package body        RNT_ACCOUNTS_RECEIVABLE_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_ACCOUNTS_RECEIVABLE_PKG
    Purpose:   API's for RNT_ACCOUNTS_RECEIVABLE table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        14-MAY-07   Auto Generated   Initial Version

********************************************************************************/

function PAYMENT_TYPE_RENT return NUMBER as begin return 7; end;
function PAYMENT_TYPE_DISCOUNT_RENT return NUMBER as begin return 8; end;
function PAYMENT_TYPE_RECOVERABLE return NUMBER as begin return 9; end;
function PAYMENT_TYPE_LATE_FEE return NUMBER as begin return 10; end;
function PAYMENT_TYPE_REMAINING_RENT return NUMBER as begin return 13; end;
function PAYMENT_TYPE_SECTION8_RENT return NUMBER as begin return 14; end;

  procedure lock_row( X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE) is
     cursor c is
     select * from RNT_ACCOUNTS_RECEIVABLE
     where AR_ID = X_AR_ID
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
  function get_checksum( X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE)
            return RNT_ACCOUNTS_RECEIVABLE_V.CHECKSUM%TYPE is 

    v_return_value               RNT_ACCOUNTS_RECEIVABLE_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_ACCOUNTS_RECEIVABLE_ALL_V
    where AR_ID = X_AR_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE
                      , X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_DUE_DATE%TYPE
                      , X_AMOUNT IN RNT_ACCOUNTS_RECEIVABLE.AMOUNT%TYPE
                      , X_PAYMENT_TYPE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_TYPE%TYPE
                      , X_TENANT_ID IN RNT_ACCOUNTS_RECEIVABLE.TENANT_ID%TYPE
                      , X_AGREEMENT_ID IN RNT_ACCOUNTS_RECEIVABLE.AGREEMENT_ID%TYPE
                      , X_LOAN_ID IN RNT_ACCOUNTS_RECEIVABLE.LOAN_ID%TYPE
                      , X_BUSINESS_ID IN RNT_ACCOUNTS_RECEIVABLE.BUSINESS_ID%TYPE
                      , X_IS_GENERATED_YN IN RNT_ACCOUNTS_RECEIVABLE.IS_GENERATED_YN%TYPE
                      , X_CHECKSUM IN RNT_ACCOUNTS_RECEIVABLE_V.CHECKSUM%TYPE
                      , X_AGREEMENT_ACTION_ID IN RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE
                      , X_PAYMENT_PROPERTY_ID IN RNT_PROPERTIES.PROPERTY_ID%TYPE)
  is
     l_checksum          RNT_ACCOUNTS_RECEIVABLE_V.CHECKSUM%TYPE;
  begin
     lock_row(X_AR_ID);

      -- validate checksum
      l_checksum := get_checksum(X_AR_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;
     
     update RNT_ACCOUNTS_RECEIVABLE
     set PAYMENT_DUE_DATE = X_PAYMENT_DUE_DATE
     , AMOUNT = X_AMOUNT
     , PAYMENT_TYPE = X_PAYMENT_TYPE
     , TENANT_ID = X_TENANT_ID
     , AGREEMENT_ID = X_AGREEMENT_ID
     , LOAN_ID = X_LOAN_ID
     , BUSINESS_ID = X_BUSINESS_ID
     , IS_GENERATED_YN = X_IS_GENERATED_YN
     , AGREEMENT_ACTION_ID = X_AGREEMENT_ACTION_ID
     , PAYMENT_PROPERTY_ID = X_PAYMENT_PROPERTY_ID 
     where AR_ID = X_AR_ID;

  end update_row;
  
  procedure update_row_amount( X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE
                      , X_AMOUNT IN RNT_ACCOUNTS_RECEIVABLE.AMOUNT%TYPE
                      , X_CHECKSUM IN RNT_ACCOUNTS_RECEIVABLE_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_ACCOUNTS_RECEIVABLE_V.CHECKSUM%TYPE;
  begin
     lock_row(X_AR_ID);

      -- validate checksum
      l_checksum := get_checksum(X_AR_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;
     
     update RNT_ACCOUNTS_RECEIVABLE
     set AMOUNT = X_AMOUNT
     where AR_ID = X_AR_ID;

  end update_row_amount;

  function insert_row( X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_DUE_DATE%TYPE
                     , X_AMOUNT IN RNT_ACCOUNTS_RECEIVABLE.AMOUNT%TYPE
                     , X_PAYMENT_TYPE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_TYPE%TYPE
                     , X_TENANT_ID IN RNT_ACCOUNTS_RECEIVABLE.TENANT_ID%TYPE
                     , X_AGREEMENT_ID IN RNT_ACCOUNTS_RECEIVABLE.AGREEMENT_ID%TYPE
                     , X_LOAN_ID IN RNT_ACCOUNTS_RECEIVABLE.LOAN_ID%TYPE
                     , X_BUSINESS_ID IN RNT_ACCOUNTS_RECEIVABLE.BUSINESS_ID%TYPE
                     , X_IS_GENERATED_YN IN RNT_ACCOUNTS_RECEIVABLE.IS_GENERATED_YN%TYPE
                     , X_AGREEMENT_ACTION_ID IN RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE
                     , X_PAYMENT_PROPERTY_ID IN RNT_PROPERTIES.PROPERTY_ID%TYPE   
                     )
              return RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE
  is
     x          number;
  begin

     insert into RNT_ACCOUNTS_RECEIVABLE
     ( AR_ID
     , PAYMENT_DUE_DATE
     , AMOUNT
     , PAYMENT_TYPE
     , TENANT_ID
     , AGREEMENT_ID
     , LOAN_ID
     , BUSINESS_ID
     , IS_GENERATED_YN
     , AGREEMENT_ACTION_ID
     , PAYMENT_PROPERTY_ID
     )
     values
     ( RNT_ACCOUNTS_RECEIVABLE_SEQ.NEXTVAL
     , X_PAYMENT_DUE_DATE
     , X_AMOUNT
     , X_PAYMENT_TYPE
     , X_TENANT_ID
     , X_AGREEMENT_ID
     , X_LOAN_ID
     , X_BUSINESS_ID
     , X_IS_GENERATED_YN
     , X_AGREEMENT_ACTION_ID
     , X_PAYMENT_PROPERTY_ID
     )
     returning AR_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE) is
  begin
    delete from RNT_ACCOUNTS_RECEIVABLE
    where AR_ID = X_AR_ID;
  end delete_row;
/*
  -- return type of payment for p_now_date
  function get_type_of_payment(   p_payment_due_date DATE  -- due payment date
                                , p_now_date DATE          -- current date
                                , p_discount_period NUMBER -- days for discount period
                                , p_discount_type varchar2 -- discount type LATE_FEE or DISCOUNT
                                ) return number
  is 
  begin
     -- p_current_type have values: 
     --   7  - Rent  
      --  8  - Discount Rent
      --  10 - Late Fee
     
     -- not discount or late fee 
     if p_discount_type is null then
       return PAYMENT_TYPE_RENT;
     end if;
     
     if p_discount_type = 'LATE_FEE' then
     
        if p_payment_due_date + p_discount_period < p_now_date then
          return PAYMENT_TYPE_LATE_FEE;
        else
          return PAYMENT_TYPE_RENT;
        end if;  
     end if;
     
     if p_discount_type = 'DISCOUNT' then
        if p_payment_due_date + p_discount_period  >= p_now_date then
          return PAYMENT_TYPE_DISCOUNT;
        else          
          return PAYMENT_TYPE_RENT;
        end if;  
     end if; 
     
     RAISE_APPLICATION_ERROR(-20000, 'Error in algoriphm for discount price');
  end;                                 

  function get_amount_for_payment(  p_payment_due_date DATE  -- due payment date
                                  , p_now_date DATE          -- current date
                                  , p_discount_period NUMBER -- days for discount period
                                  , p_amount NUMBER          -- amount for payment due date
                                  , p_discount_amount NUMBER -- discount amount
                                  , p_discount_type varchar2 -- discount type LATE_FEE or DISCOUNT
                                  , p_new_type out NUMBER   -- type for payment
                                  ) return number
  is
  begin
     p_new_type := get_type_of_payment(   
                                  p_payment_due_date => p_payment_due_date
                                , p_now_date => p_now_date
                                , p_discount_period => p_discount_period
                                , p_discount_type => p_discount_type); 
     -- not discount or late fee 
     if p_new_type = PAYMENT_TYPE_RENT then
        return p_amount;
     elsif p_new_type = PAYMENT_TYPE_LATE_FEE then   
        return p_amount + p_discount_amount;
     elsif p_new_type = PAYMENT_TYPE_DISCOUNT then     
        return p_amount - p_discount_amount;
     end if; 
     
     RAISE_APPLICATION_ERROR(-20000, 'Error in algoriphm for discount price');
  end;
*/
/*
  procedure update_payment_list
  is
  cursor c is 
          select a.DATE_AVAILABLE, a.TERM, a.AMOUNT,       
               a.AMOUNT_PERIOD, a.DISCOUNT_AMOUNT, a.DISCOUNT_TYPE,
               a.DISCOUNT_PERIOD, a.AGREEMENT_ID, 
               ra.AR_ID, 
               NVL(allocations.SUM_ALLOCATION, 0) as SUM_OF_ALLOCATION,
               ra.PAYMENT_TYPE,
               ra.AMOUNT as FOR_PAYMENT_AMOUNT,
               ra.TENANT_ID,  
               ra.PAYMENT_DUE_DATE,
               ra.SOURCE_FOR_LATE_FEE,
               late_fee.AR_ID as LATE_FEE_AR_ID,
               ra.BUSINESS_ID
        from RNT_TENANCY_AGREEMENT a,
             RNT_PROPERTY_UNITS u,
             RNT_TENANT t,
             RNT_ACCOUNTS_RECEIVABLE ra, 
             (select AR_ID, sum(AMOUNT) as SUM_ALLOCATION
              from RNT_PAYMENT_ALLOCATIONS
              group by AR_ID) allocations,
              RNT_ACCOUNTS_RECEIVABLE late_fee
        where a.UNIT_ID = u.UNIT_ID
          and t.AGREEMENT_ID = a.AGREEMENT_ID
          and ra.TENANT_ID = t.TENANT_ID
          and ra.AGREEMENT_ID = a.AGREEMENT_ID
          and allocations.AR_ID(+) = ra.AR_ID
          and ra.PAYMENT_TYPE in (PAYMENT_TYPE_RENT, PAYMENT_TYPE_DISCOUNT, PAYMENT_TYPE_LATE_FEE)
          and ra.AMOUNT - NVL(allocations.SUM_ALLOCATION, 0) != 0
          and ra.IS_GENERATED_YN = 'Y'
          and t.STATUS = 'CURRENT'
          and late_fee.SOURCE_FOR_LATE_FEE(+) = ra.AR_ID;
     x_new_type NUMBER;     
  begin
 
    for x in c loop
      
       x_new_type := get_type_of_payment(p_payment_due_date => x.PAYMENT_DUE_DATE -- due payment date
                                , p_now_date => trunc(SYSDATE)           -- current date
                                , p_discount_period => x.DISCOUNT_PERIOD -- days for discount period
                                , p_discount_type => x.DISCOUNT_TYPE);   -- discount type LATE_FEE or DISCOUNT
      -- dbms_output.put_line(x.PAYMENT_TYPE||' '||x_new_type);                                
      if x.LATE_FEE_AR_ID is not null and x_new_type = PAYMENT_TYPE_LATE_FEE then 
         null;
      else                            
        if x_new_type != x.PAYMENT_TYPE then
        
          if x.PAYMENT_TYPE = PAYMENT_TYPE_RENT then
             if x_new_type = PAYMENT_TYPE_DISCOUNT then
                   -- discount rent
                   update RNT_ACCOUNTS_RECEIVABLE
                   set AMOUNT = x.AMOUNT - x.DISCOUNT_AMOUNT,
                       PAYMENT_TYPE = PAYMENT_TYPE_DISCOUNT
                   where AR_ID = x.AR_ID;                                
             elsif x_new_type = PAYMENT_TYPE_LATE_FEE then
                   update RNT_ACCOUNTS_RECEIVABLE
                   set AMOUNT = x.AMOUNT + x.DISCOUNT_AMOUNT,
                       PAYMENT_TYPE = PAYMENT_TYPE_LATE_FEE
                   where AR_ID = x.AR_ID;
             else
                RAISE_APPLICATION_ERROR(-20000, 'Error in algoriphm for calculate rental 1');         
             end if;
          end if;
            
          if x.PAYMENT_TYPE = PAYMENT_TYPE_DISCOUNT then
            if x_new_type = PAYMENT_TYPE_RENT then
               -- rent
               update RNT_ACCOUNTS_RECEIVABLE
               set AMOUNT = x.AMOUNT,
                   PAYMENT_TYPE = PAYMENT_TYPE_RENT
               where AR_ID = x.AR_ID;
            elsif x_new_type = PAYMENT_TYPE_LATE_FEE then
               update RNT_ACCOUNTS_RECEIVABLE
               set AMOUNT = x.AMOUNT + x.DISCOUNT_AMOUNT,
                   PAYMENT_TYPE = PAYMENT_TYPE_LATE_FEE
               where AR_ID = x.AR_ID;
            else
               RAISE_APPLICATION_ERROR(-20000, 'Error in algoriphm for calculate rental 1');         
            end if;
          end if;   
            
           if x.PAYMENT_TYPE = PAYMENT_TYPE_LATE_FEE then
               if x_new_type in (PAYMENT_TYPE_RENT, PAYMENT_TYPE_DISCOUNT) then
                   -- rent
                   if x_new_type = PAYMENT_TYPE_RENT then
                       update RNT_ACCOUNTS_RECEIVABLE
                       set AMOUNT = x.AMOUNT,
                           PAYMENT_TYPE = PAYMENT_TYPE_RENT
                       where AR_ID = x.AR_ID;                                
                   elsif x_new_type = PAYMENT_TYPE_DISCOUNT then
                       update RNT_ACCOUNTS_RECEIVABLE
                       set AMOUNT = x.AMOUNT-x.DISCOUNT_AMOUNT,
                           PAYMENT_TYPE = PAYMENT_TYPE_DISCOUNT
                       where AR_ID = x.AR_ID;
                   end if;             
               else
                 RAISE_APPLICATION_ERROR(-20000, 'Error in algoriphm for calculate rental 1');         
               end if;
           end if;
        end if;
      end if;                                  
    end loop;
    commit;
  exception
   when OTHERS then
      rollback;
      raise;  
  end;          
*/

  function generate_payments return NUMBER
  is
     cursor c_new_payment
     is
        select a.DATE_AVAILABLE, 
             a.TERM,
             NVL(max_payment.MAX_PAYMENT_DATE, a.DATE_AVAILABLE) as MAX_PAYMENT_DATE,
             trunc(decode(a.AMOUNT_PERIOD,
                        'MONTH', ADD_MONTHS(NVL(max_payment.MAX_PAYMENT_DATE, a.DATE_AVAILABLE), 1),
                        'BI-MONTH', ADD_MONTHS(NVL(max_payment.MAX_PAYMENT_DATE, a.DATE_AVAILABLE), 2),
                        '2WEEKS', NVL(max_payment.MAX_PAYMENT_DATE, a.DATE_AVAILABLE)+14,
                        'WEEK', NVL(max_payment.MAX_PAYMENT_DATE, a.DATE_AVAILABLE)+7
             )) as NEXT_PAYMENT_DATE,
             a.AMOUNT,       
             a.AMOUNT_PERIOD,
             a.DISCOUNT_AMOUNT,
             a.DISCOUNT_TYPE,
             a.DISCOUNT_PERIOD,
             a.AGREEMENT_ID,
             p.BUSINESS_ID,
             t.TENANT_ID,
             t.SECTION8_TENANT_PAYS,
             t.SECTION8_VOUCHER_AMOUNT
     from RNT_TENANCY_AGREEMENT a,
          RNT_PROPERTY_UNITS u,
          RNT_TENANT t,
          (select TENANT_ID, max(PAYMENT_DUE_DATE) as MAX_PAYMENT_DATE 
           from RNT_ACCOUNTS_RECEIVABLE 
           where PAYMENT_TYPE in (RNT_ACCOUNTS_RECEIVABLE_PKG.PAYMENT_TYPE_RENT, RNT_ACCOUNTS_RECEIVABLE_PKG.PAYMENT_TYPE_DISCOUNT_RENT)
             and IS_GENERATED_YN = 'Y'
           group by TENANT_ID) max_payment,
          RNT_PROPERTIES p  
     where a.UNIT_ID = u.UNIT_ID
       and SYSDATE <= NVL(a.END_DATE, to_date('4000', 'RRRR'))
       and trunc(decode(a.AMOUNT_PERIOD,
           'MONTH', ADD_MONTHS(SYSDATE, -1),
           'BI-MONTH', ADD_MONTHS(SYSDATE, -2),
           '2WEEKS', SYSDATE-14,
           'WEEK', SYSDATE-7
           )) >= (select NVL(max(PAYMENT_DUE_DATE), a.DATE_AVAILABLE) 
                  from RNT_ACCOUNTS_RECEIVABLE aa 
                  where TENANT_ID = t.TENANT_ID
                    and IS_GENERATED_YN = 'Y'
                    and PAYMENT_TYPE in (RNT_ACCOUNTS_RECEIVABLE_PKG.PAYMENT_TYPE_RENT, RNT_ACCOUNTS_RECEIVABLE_PKG.PAYMENT_TYPE_DISCOUNT_RENT))
       and max_payment.TENANT_ID(+) = t.TENANT_ID
       and t.AGREEMENT_ID = a.AGREEMENT_ID
       and p.PROPERTY_ID = u.PROPERTY_ID
       and t.STATUS = 'CURRENT';
      
      x_ar_id NUMBER; 
                   
      x_payment_type1 NUMBER;
      x_payment_type2 NUMBER;
      x_amount NUMBER;
      x_amount2 NUMBER;
      x_cnt NUMBER;
      x_next_date2 DATE;
      x_amount_section8 NUMBER; 
  begin
    savepoint T_;
    x_cnt := 0;
    -- generate list from last payment 
    for x in c_new_payment loop
    
      x_amount := x.AMOUNT;
      x_payment_type1 := PAYMENT_TYPE_RENT();
      x_payment_type2 := 0;
      
      if x.DISCOUNT_TYPE = 'LATE_FEE' then
         x_amount:= x.AMOUNT;
         x_payment_type1 := PAYMENT_TYPE_RENT();
         x_payment_type2 := PAYMENT_TYPE_LATE_FEE();
         x_next_date2 := x.NEXT_PAYMENT_DATE + x.DISCOUNT_PERIOD;
         x_amount2 := x.DISCOUNT_AMOUNT;
      elsif x.DISCOUNT_TYPE = 'DISCOUNT' then
         x_payment_type1 := PAYMENT_TYPE_DISCOUNT_RENT();
         x_payment_type2 := PAYMENT_TYPE_REMAINING_RENT();
         x_next_date2 := x.NEXT_PAYMENT_DATE + x.DISCOUNT_PERIOD;
         x_amount := x.AMOUNT - x.DISCOUNT_AMOUNT;
         x_amount2 := x.DISCOUNT_AMOUNT;   
      end if;
      
      x_amount_section8 := null;
      if x.SECTION8_TENANT_PAYS is not null then
         --if NVL(x.SECTION8_VOUCHER_AMOUNT, 0) 
           x_amount_section8 := x_amount;
           x_amount := x.SECTION8_TENANT_PAYS;
           if x_amount_section8 - x.SECTION8_TENANT_PAYS < 0 then
             x_amount_section8 := NULL;
           else
             x_amount_section8 := x_amount_section8 - x.SECTION8_TENANT_PAYS;
           end if;  
      end if;  
      
      insert into RNT_ACCOUNTS_RECEIVABLE (
           AR_ID, PAYMENT_DUE_DATE, AMOUNT, 
           PAYMENT_TYPE, TENANT_ID, AGREEMENT_ID, 
           LOAN_ID, BUSINESS_ID, IS_GENERATED_YN, 
           AGREEMENT_ACTION_ID, PAYMENT_PROPERTY_ID, SOURCE_PAYMENT_ID) 
       values (RNT_ACCOUNTS_RECEIVABLE_SEQ.NEXTVAL, x.NEXT_PAYMENT_DATE, x_amount,
            x_payment_type1, x.TENANT_ID, x.AGREEMENT_ID,
            NULL, x.BUSINESS_ID, 'Y',
            NULL, NULL, NULL)
       returning AR_ID into x_ar_id;
      
      if x_payment_type2 != 0 then
            insert into RNT_ACCOUNTS_RECEIVABLE (
                   AR_ID, PAYMENT_DUE_DATE, AMOUNT, 
                   PAYMENT_TYPE, TENANT_ID, AGREEMENT_ID, 
                   LOAN_ID, BUSINESS_ID, IS_GENERATED_YN, 
                   AGREEMENT_ACTION_ID, PAYMENT_PROPERTY_ID, SOURCE_PAYMENT_ID) 
            values (RNT_ACCOUNTS_RECEIVABLE_SEQ.NEXTVAL, x_next_date2, x_amount2,
                    x_payment_type2, x.TENANT_ID, x.AGREEMENT_ID,
                    NULL, x.BUSINESS_ID, 'Y',
                    NULL, NULL, x_ar_id);
      end if;
      
      if x_amount_section8 is not null then
          insert into RNT_ACCOUNTS_RECEIVABLE (
               AR_ID, PAYMENT_DUE_DATE, AMOUNT, 
               PAYMENT_TYPE, TENANT_ID, AGREEMENT_ID, 
               LOAN_ID, BUSINESS_ID, IS_GENERATED_YN, 
               AGREEMENT_ACTION_ID, PAYMENT_PROPERTY_ID, SOURCE_PAYMENT_ID) 
           values (RNT_ACCOUNTS_RECEIVABLE_SEQ.NEXTVAL, x.NEXT_PAYMENT_DATE, x_amount_section8,
                 PAYMENT_TYPE_SECTION8_RENT(), x.TENANT_ID, x.AGREEMENT_ID,
                NULL, x.BUSINESS_ID, 'Y',
                NULL, NULL, x_ar_id);
      end if;
                                               
      x_cnt := x_cnt + 1;  
    end loop;
    
    commit;
    return x_cnt;    
  exception
    when OTHERS then
       rollback to T_; 
       raise; 
  end;

  procedure generate_payment_list 
  is
    x NUMBER;
  begin
    for i in 1..10 loop
       x := generate_payments;
       exit when x = 0;
    end loop;
    --update_payment_list;
  end;
  
  /* 
     Function check then amount can be allocation for this payment
  */
  procedure update_payment_from_allocation(X_AMOUNT IN RNT_PAYMENT_ALLOCATIONS.AMOUNT%TYPE, 
                                           X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE, 
                                           X_AR_ID IN RNT_PAYMENT_ALLOCATIONS.AR_ID%TYPE)
  is

  cursor c_alloc is
    select NVL(sum(AMOUNT), 0) as ALLOCATED_AMOUNT 
    from RNT_PAYMENT_ALLOCATIONS
    where AR_ID = X_AR_ID;
      
  
  cursor c_payment is 
    select AMOUNT 
    from RNT_ACCOUNTS_RECEIVABLE
    where AR_ID = X_AR_ID;      
    
  x_allocated NUMBER;
  x_payment NUMBER;
  
  begin
    open c_alloc;
    fetch c_alloc into x_allocated;
    close c_alloc;
    
    open c_payment;
    fetch c_payment into x_payment;
    close c_payment;    
    
    if x_allocated + X_AMOUNT > x_payment then
       RAISE_APPLICATION_ERROR(-20567, 'New amount sum more then sum for payment in specified date ('||
                to_char(X_PAYMENT_DATE, 'MM/DD/RRRR')||'). Max allowed value for payment = '||
                (x_payment));       
    end if;
    
  end;                                     

  -- return max payed amount for agreement action
  function get_max_alloc_for_agr_action(X_ACTION_ID RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE) return NUMBER
  is
    x NUMBER;
  begin
    select max(SUM_AMOUNT)
    into x 
    from (
            select sum(pa.AMOUNT)as SUM_AMOUNT
            from RNT_ACCOUNTS_RECEIVABLE ar,
                 RNT_PAYMENT_ALLOCATIONS pa
            where ar.AGREEMENT_ACTION_ID = X_ACTION_ID
              and pa.AR_ID = ar.AR_ID
            group by TENANT_ID
          );
    return x;        
  end;
  
  procedure DELETE_AGR_ACTION_RECEIVABLE(X_ACTION_ID RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE)
  is
  begin
     -- delete allocations
     delete from RNT_ACCOUNTS_RECEIVABLE 
     where AGREEMENT_ACTION_ID = X_ACTION_ID;                 
  end;
  
  procedure update_alloc(X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE, 
                         X_AMOUNT IN RNT_PAYMENT_ALLOCATIONS.AMOUNT%TYPE,
                         X_AR_ID IN RNT_PAYMENT_ALLOCATIONS.AR_ID%TYPE)
  is
  begin
    if X_PAYMENT_DATE is null then
      delete from RNT_PAYMENT_ALLOCATIONS
      where AR_ID =X_AR_ID; 
    else
      update RNT_PAYMENT_ALLOCATIONS
      set PAYMENT_DATE = X_PAYMENT_DATE,
          AMOUNT = X_AMOUNT
      where AR_ID = X_AR_ID;
      if SQL%ROWCOUNT = 0 then
         insert into RNT_PAYMENT_ALLOCATIONS (
                   PAY_ALLOC_ID, PAYMENT_DATE, AMOUNT, 
                   AR_ID, AP_ID, PAYMENT_ID) 
          values (RNT_PAYMENT_ALLOCATIONS_SEQ.NEXTVAL, X_PAYMENT_DATE, X_AMOUNT,
                   X_AR_ID, NULL, NULL);
      end if;    
    end if;                      
  end;                         
------------------------------------------------------------------------------------
  function get_checksum2(X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE)  return RNT_ACCOUNTS_RECEIVABLE_PROP_V.CHECKSUM%TYPE is 

    v_return_value               RNT_ACCOUNTS_RECEIVABLE_PROP_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_ACCOUNTS_RECEIVABLE_PROP_V
    where AR_ID = X_AR_ID;
    return v_return_value;
  end get_checksum2;
  
  procedure update_row2(X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE
                      , X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_DUE_DATE%TYPE
                      , X_AMOUNT IN RNT_ACCOUNTS_RECEIVABLE.AMOUNT%TYPE
                      , X_PAYMENT_TYPE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_TYPE%TYPE
                      , X_TENANT_ID IN RNT_ACCOUNTS_RECEIVABLE.TENANT_ID%TYPE
                      , X_AGREEMENT_ID IN RNT_ACCOUNTS_RECEIVABLE.AGREEMENT_ID%TYPE
                      , X_LOAN_ID IN RNT_ACCOUNTS_RECEIVABLE.LOAN_ID%TYPE
                      , X_BUSINESS_ID IN RNT_ACCOUNTS_RECEIVABLE.BUSINESS_ID%TYPE
                      , X_IS_GENERATED_YN IN RNT_ACCOUNTS_RECEIVABLE.IS_GENERATED_YN%TYPE
                      , X_CHECKSUM IN RNT_ACCOUNTS_RECEIVABLE_V.CHECKSUM%TYPE
                      , X_AGREEMENT_ACTION_ID IN RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE
                      , X_PAYMENT_PROPERTY_ID IN RNT_PROPERTIES.PROPERTY_ID%TYPE
                      , X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE
                      )
  is
  begin
  
            update_row(X_AR_ID => X_AR_ID
                      , X_PAYMENT_DUE_DATE => X_PAYMENT_DUE_DATE 
                      , X_AMOUNT => X_AMOUNT
                      , X_PAYMENT_TYPE => X_PAYMENT_TYPE
                      , X_TENANT_ID => X_TENANT_ID
                      , X_AGREEMENT_ID => X_AGREEMENT_ID
                      , X_LOAN_ID => X_LOAN_ID
                      , X_BUSINESS_ID => X_BUSINESS_ID
                      , X_IS_GENERATED_YN => X_IS_GENERATED_YN
                      , X_CHECKSUM => X_CHECKSUM
                      , X_AGREEMENT_ACTION_ID => X_AGREEMENT_ACTION_ID
                      , X_PAYMENT_PROPERTY_ID => X_PAYMENT_PROPERTY_ID
                   );
            update_alloc(X_PAYMENT_DATE => X_PAYMENT_DATE 
                       , X_AMOUNT => X_AMOUNT 
                       , X_AR_ID => X_AR_ID);
  end;                    

  function insert_row2( X_PAYMENT_DUE_DATE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_DUE_DATE%TYPE
                     , X_AMOUNT IN RNT_ACCOUNTS_RECEIVABLE.AMOUNT%TYPE
                     , X_PAYMENT_TYPE IN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_TYPE%TYPE
                     , X_TENANT_ID IN RNT_ACCOUNTS_RECEIVABLE.TENANT_ID%TYPE
                     , X_AGREEMENT_ID IN RNT_ACCOUNTS_RECEIVABLE.AGREEMENT_ID%TYPE
                     , X_LOAN_ID IN RNT_ACCOUNTS_RECEIVABLE.LOAN_ID%TYPE
                     , X_BUSINESS_ID IN RNT_ACCOUNTS_RECEIVABLE.BUSINESS_ID%TYPE
                     , X_IS_GENERATED_YN IN RNT_ACCOUNTS_RECEIVABLE.IS_GENERATED_YN%TYPE
                     , X_AGREEMENT_ACTION_ID IN RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE
                     , X_PAYMENT_PROPERTY_ID IN RNT_PROPERTIES.PROPERTY_ID%TYPE
                     , X_PAYMENT_DATE IN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE%TYPE                     
                   )
              return RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE
  is 
    x RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE;
  begin
         x:= insert_row(X_PAYMENT_DUE_DATE => X_PAYMENT_DUE_DATE 
                      , X_AMOUNT => X_AMOUNT
                      , X_PAYMENT_TYPE => X_PAYMENT_TYPE
                      , X_TENANT_ID => X_TENANT_ID
                      , X_AGREEMENT_ID => X_AGREEMENT_ID
                      , X_LOAN_ID => X_LOAN_ID
                      , X_BUSINESS_ID => X_BUSINESS_ID
                      , X_IS_GENERATED_YN => X_IS_GENERATED_YN
                      , X_AGREEMENT_ACTION_ID => X_AGREEMENT_ACTION_ID
                      , X_PAYMENT_PROPERTY_ID => X_PAYMENT_PROPERTY_ID
                      );
                      
         update_alloc(X_PAYMENT_DATE => X_PAYMENT_DATE 
                     , X_AMOUNT => X_AMOUNT
                     , X_AR_ID => x);
                      
        return x;
  end;
                 
 procedure delete_row2(X_AR_ID IN RNT_ACCOUNTS_RECEIVABLE.AR_ID%TYPE) is
  begin
    delete from RNT_PAYMENT_ALLOCATIONS
    where AR_ID = X_AR_ID;
     
    delete from RNT_ACCOUNTS_RECEIVABLE
    where AR_ID = X_AR_ID;
    
  end delete_row2;
end RNT_ACCOUNTS_RECEIVABLE_PKG;
/

SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY        RNT_PROPERTIES_PKG AS
/******************************************************************************
   NAME:       RNT_PROPERTIES_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        30.03.2007             1. Created this package body.
******************************************************************************/

function get_ckecksum(p_property_id RNT_PROPERTIES.PROPERTY_ID%TYPE) return VARCHAR2
is
begin
   for x in (select 
                 PROPERTY_ID, BUSINESS_ID, 
                 ADDRESS1, ADDRESS2, CITY, UNITS,
                 STATE, ZIPCODE, 
                 DATE_PURCHASED, PURCHASE_PRICE, LAND_VALUE, 
                 DEPRECIATION_TERM, YEAR_BUILT, BUILDING_SIZE, 
                 LOT_SIZE, DATE_SOLD, SALE_AMOUNT, 
                 NOTE_YN
              from RNT_PROPERTIES
              where PROPERTY_ID = p_property_id) loop
         RNT_SYS_CHECKSUM_REC_PKG.INIT;
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.PROPERTY_ID);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.BUSINESS_ID);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.UNITS);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.ADDRESS1);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.ADDRESS2);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.CITY); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.STATE); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.ZIPCODE); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.DATE_PURCHASED); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.PURCHASE_PRICE); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.LAND_VALUE);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.DEPRECIATION_TERM); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.YEAR_BUILT);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.BUILDING_SIZE); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.LOT_SIZE);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.DATE_SOLD);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.SALE_AMOUNT); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.NOTE_YN);
         return RNT_SYS_CHECKSUM_REC_PKG.GET_CHECKSUM;
   end loop;
   raise NO_DATA_FOUND;               
end;

procedure lock_row(X_PROPERTY_ID RNT_PROPERTIES.PROPERTY_ID%TYPE)
is
  cursor c is
    select 
      PROPERTY_ID, BUSINESS_ID, UNITS, 
      ADDRESS1, ADDRESS2, 
      CITY, STATE, ZIPCODE, 
      DATE_PURCHASED, PURCHASE_PRICE, LAND_VALUE, 
      DEPRECIATION_TERM, YEAR_BUILT, BUILDING_SIZE, 
      LOT_SIZE, DATE_SOLD, SALE_AMOUNT, 
      NOTE_YN
   from RNT_PROPERTIES
   where PROPERTY_ID = X_PROPERTY_ID
   for update of PROPERTY_ID nowait; 
begin
  open c;
  close c;
exception
  when OTHERS then
    if SQLCODE = -54 then
      RAISE_APPLICATION_ERROR(-20001, 'Cannot changed record. Record is locked.');
    end if;       
end;

function check_unique(X_PROPERTY_ID       RNT_PROPERTIES.PROPERTY_ID%TYPE, 
                      X_ADDRESS1          RNT_PROPERTIES.ADDRESS1%TYPE, 
                      X_ADDRESS2          RNT_PROPERTIES.ADDRESS2%TYPE, 
                      X_CITY              RNT_PROPERTIES.CITY%TYPE, 
                      X_STATE             RNT_PROPERTIES.STATE%TYPE, 
                      X_ZIPCODE           RNT_PROPERTIES.ZIPCODE%TYPE) return boolean
is
  x NUMBER;
begin
   select 1 
   into x
   from DUAL
   where exists (
                   select 1
                   from RNT_PROPERTIES
                   where (PROPERTY_ID != X_PROPERTY_ID or X_PROPERTY_ID is null) 
                     and ADDRESS1 = X_ADDRESS1 
                     and ADDRESS2 = X_ADDRESS2 
                     and CITY = X_CITY 
                     and STATE = X_STATE 
                     and ZIPCODE = X_ZIPCODE            
                 );
  return false;
exception
  when NO_DATA_FOUND then
     return true;                        
end;                               

procedure update_row(X_PROPERTY_ID       RNT_PROPERTIES.PROPERTY_ID%TYPE, 
                     X_BUSINESS_ID       RNT_PROPERTIES.BUSINESS_ID%TYPE, 
                     X_UNITS             RNT_PROPERTIES.UNITS%TYPE,
                     X_ADDRESS1          RNT_PROPERTIES.ADDRESS1%TYPE, 
                     X_ADDRESS2          RNT_PROPERTIES.ADDRESS2%TYPE, 
                     X_CITY              RNT_PROPERTIES.CITY%TYPE, 
                     X_STATE             RNT_PROPERTIES.STATE%TYPE, 
                     X_ZIPCODE           RNT_PROPERTIES.ZIPCODE%TYPE, 
                     X_DATE_PURCHASED    RNT_PROPERTIES.DATE_PURCHASED%TYPE, 
                     X_PURCHASE_PRICE    RNT_PROPERTIES.PURCHASE_PRICE%TYPE, 
                     X_LAND_VALUE        RNT_PROPERTIES.LAND_VALUE%TYPE, 
                     X_DEPRECIATION_TERM RNT_PROPERTIES.DEPRECIATION_TERM%TYPE, 
                     X_YEAR_BUILT        RNT_PROPERTIES.YEAR_BUILT%TYPE, 
                     X_BUILDING_SIZE     RNT_PROPERTIES.BUILDING_SIZE%TYPE, 
                     X_LOT_SIZE          RNT_PROPERTIES.LOT_SIZE%TYPE, 
                     X_DATE_SOLD         RNT_PROPERTIES.DATE_SOLD%TYPE, 
                     X_SALE_AMOUNT       RNT_PROPERTIES.SALE_AMOUNT%TYPE, 
                     X_NOTE_YN           RNT_PROPERTIES.NOTE_YN%TYPE,
                     X_CHECKSUM          VARCHAR2) 
is
  l_checksum varchar2(32);
  xl_num_units NUMBER := X_UNITS;
  x_cnt NUMBER;
  x1 NUMBER; 
begin
   lock_row(X_PROPERTY_ID);
   
   -- validate checksum   
   l_checksum := get_ckecksum(X_PROPERTY_ID);
   if X_CHECKSUM != l_checksum then
      RAISE_APPLICATION_ERROR(-20002, 'Record was changed another user.');
      --E_ROW_CHANGED_ANOTHER_USER  
   end if;

   if not check_unique(X_PROPERTY_ID,X_ADDRESS1, X_ADDRESS2, 
                      X_CITY, X_STATE, X_ZIPCODE) then
        RAISE_APPLICATION_ERROR(-20006, 'Address of property must be unique');                      
   end if;   
   
   if not RNT_BUSINESS_UNITS_PKG.CHECK_ALLOW_FOR_ACCESS(X_BUSINESS_ID) then
       RAISE_APPLICATION_ERROR(-20006, 'You cannot update this property becouse not allowed business unit reference.');
   end if;                    
   
   -- validate num rows
   select count(*)
   into x_cnt
   from RNT_PROPERTY_UNITS
   where PROPERTY_ID = X_PROPERTY_ID;
   
   if X_UNITS - x_cnt < 0 then
        RAISE_APPLICATION_ERROR(-20006, 'Value Units must be great then quantity of units in property.');   
   end if; 
   
   if x_cnt = 0 and X_UNITS = 1 then
     -- append single unit  
     x1 := RNT_PROPERTY_UNITS_PKG.INSERT_ROW(X_PROPERTY_ID => X_PROPERTY_ID, 
                                             X_UNIT_NAME => 'Single Unit', 
                                             X_UNIT_SIZE => X_BUILDING_SIZE, 
                                             X_BEDROOMS => NULL, 
                                             X_BATHROOMS => NULL);      
   end if;
      
   update RNT_PROPERTIES
   set PROPERTY_ID       = X_PROPERTY_ID,
       BUSINESS_ID       = X_BUSINESS_ID,
       UNITS             = X_UNITS,
       ADDRESS1          = X_ADDRESS1,
       ADDRESS2          = X_ADDRESS2,
       CITY              = X_CITY,
       STATE             = X_STATE,
       ZIPCODE           = X_ZIPCODE,
       DATE_PURCHASED    = X_DATE_PURCHASED,
       PURCHASE_PRICE    = X_PURCHASE_PRICE,
       LAND_VALUE        = X_LAND_VALUE,
       DEPRECIATION_TERM = X_DEPRECIATION_TERM,
       YEAR_BUILT        = X_YEAR_BUILT,
       BUILDING_SIZE     = X_BUILDING_SIZE,
       LOT_SIZE          = X_LOT_SIZE,
       DATE_SOLD         = X_DATE_SOLD,
       SALE_AMOUNT       = X_SALE_AMOUNT,
       NOTE_YN           = X_NOTE_YN
   where  PROPERTY_ID    = X_PROPERTY_ID;
end;

function insert_row( X_BUSINESS_ID       RNT_PROPERTIES.BUSINESS_ID%TYPE,
                     X_UNITS             RNT_PROPERTIES.UNITS%TYPE, 
                     X_ADDRESS1          RNT_PROPERTIES.ADDRESS1%TYPE, 
                     X_ADDRESS2          RNT_PROPERTIES.ADDRESS2%TYPE, 
                     X_CITY              RNT_PROPERTIES.CITY%TYPE, 
                     X_STATE             RNT_PROPERTIES.STATE%TYPE, 
                     X_ZIPCODE           RNT_PROPERTIES.ZIPCODE%TYPE, 
                     X_DATE_PURCHASED    RNT_PROPERTIES.DATE_PURCHASED%TYPE, 
                     X_PURCHASE_PRICE    RNT_PROPERTIES.PURCHASE_PRICE%TYPE, 
                     X_LAND_VALUE        RNT_PROPERTIES.LAND_VALUE%TYPE, 
                     X_DEPRECIATION_TERM RNT_PROPERTIES.DEPRECIATION_TERM%TYPE, 
                     X_YEAR_BUILT        RNT_PROPERTIES.YEAR_BUILT%TYPE, 
                     X_BUILDING_SIZE     RNT_PROPERTIES.BUILDING_SIZE%TYPE, 
                     X_LOT_SIZE          RNT_PROPERTIES.LOT_SIZE%TYPE, 
                     X_DATE_SOLD         RNT_PROPERTIES.DATE_SOLD%TYPE, 
                     X_SALE_AMOUNT       RNT_PROPERTIES.SALE_AMOUNT%TYPE, 
                     X_NOTE_YN           RNT_PROPERTIES.NOTE_YN%TYPE)
       return RNT_PROPERTIES.PROPERTY_ID%TYPE                     
is
 x RNT_PROPERTIES.PROPERTY_ID%TYPE;
 xl_num_units RNT_PROPERTIES.UNITS%TYPE;
 x1 RNT_PROPERTY_UNITS.UNIT_ID%TYPE;
begin

   if not check_unique(NULL,X_ADDRESS1, X_ADDRESS2, 
                      X_CITY, X_STATE, X_ZIPCODE) then
        RAISE_APPLICATION_ERROR(-20006, 'Address of property must be unique');                      
   end if;  

   if not RNT_BUSINESS_UNITS_PKG.CHECK_ALLOW_FOR_ACCESS(X_BUSINESS_ID) then
       RAISE_APPLICATION_ERROR(-20006, 'You cannot insert this property becouse not allowed business unit reference.');
   end if;                    
   
  xl_num_units := X_UNITS;
    
  -- num of units must be 1 or more 
  if xl_num_units = 0 then
      xl_num_units := 1;
  end if;
    
  insert into RNT_PROPERTIES (
           PROPERTY_ID, BUSINESS_ID, UNITS, 
           ADDRESS1, ADDRESS2, 
           CITY, STATE, ZIPCODE, 
           DATE_PURCHASED, PURCHASE_PRICE, LAND_VALUE, 
           DEPRECIATION_TERM, YEAR_BUILT, BUILDING_SIZE, 
           LOT_SIZE, DATE_SOLD, SALE_AMOUNT, 
           NOTE_YN) 
  values (RNT_PROPERTIES_SEQ.NEXTVAL, X_BUSINESS_ID,  xl_num_units, 
   X_ADDRESS1, X_ADDRESS2, 
   X_CITY, X_STATE, X_ZIPCODE, 
   X_DATE_PURCHASED, X_PURCHASE_PRICE, X_LAND_VALUE, 
   X_DEPRECIATION_TERM, X_YEAR_BUILT, X_BUILDING_SIZE, 
   X_LOT_SIZE, X_DATE_SOLD, X_SALE_AMOUNT, 
   X_NOTE_YN)
  returning PROPERTY_ID into x;
  
  if xl_num_units = 1 then
       -- append single unit  
       x1 := RNT_PROPERTY_UNITS_PKG.INSERT_ROW(X_PROPERTY_ID => x, 
                                               X_UNIT_NAME => 'Single Unit', 
                                               X_UNIT_SIZE => X_BUILDING_SIZE, 
                                               X_BEDROOMS => NULL, 
                                               X_BATHROOMS => NULL);
  end if;
  
  return x;
end;

function is_exists_value(X_PROPERTY_ID RNT_PROPERTIES.PROPERTY_ID%TYPE) return boolean
is
 x NUMBER;
begin
  select 1
  into x
  from DUAL
  where exists (select 1
                from RNT_PROPERTY_VALUE
                where PROPERTY_ID = X_PROPERTY_ID
                );
  return true;
exception
  when NO_DATA_FOUND then
     return false;   
end;

function is_exists_unit(X_PROPERTY_ID RNT_PROPERTIES.PROPERTY_ID%TYPE) return boolean
is
 x NUMBER;
begin
  for x in (select UNIT_ID from RNT_PROPERTY_UNITS where PROPERTY_ID = X_PROPERTY_ID) loop
     if RNT_PROPERTY_UNITS_PKG.IS_EXISTS_CHILDS(x.UNIT_ID) then
        return true;
     end if;   
  end loop;
  return false;
end;

function is_exists_expenses(X_PROPERTY_ID RNT_PROPERTIES.PROPERTY_ID%TYPE) return boolean
is
 x NUMBER;
begin
  select 1
  into x
  from DUAL
  where exists (select 1
                from RNT_PROPERTY_EXPENSES
                where PROPERTY_ID = X_PROPERTY_ID
                );
  return true;
exception
  when NO_DATA_FOUND then
     return false;   
end;


procedure delete_row(X_PROPERTY_ID       RNT_PROPERTIES.PROPERTY_ID%TYPE)
is
begin
-- check for exists child records
  if is_exists_value(X_PROPERTY_ID) then
    RAISE_APPLICATION_ERROR(-20200, 'Cannot delete record. For property exists value(s) record.');
  end if;
  if is_exists_unit(X_PROPERTY_ID) then
    RAISE_APPLICATION_ERROR(-20201, 'Cannot delete record. For property exists units with child records.');
  end if;
  if is_exists_expenses(X_PROPERTY_ID) then
    RAISE_APPLICATION_ERROR(-20202, 'Cannot delete record. For property exists expenses expenses.');
  end if;
  
  delete from RNT_PROPERTY_UNITS
  where PROPERTY_ID = X_PROPERTY_ID;
  
  delete from RNT_PROPERTIES
  where PROPERTY_ID = X_PROPERTY_ID;
end;

END RNT_PROPERTIES_PKG;
/

SHOW ERRORS;

CREATE OR REPLACE package body        RNT_PAYMENTS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_PAYMENTS_PKG
    Purpose:   API's for RNT_PAYMENTS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        10-MAY-07   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------
  function check_unique( X_PAYMENT_ID IN RNT_PAYMENTS.PAYMENT_ID%TYPE
                       , X_PAYMENT_DATE IN RNT_PAYMENTS.PAYMENT_DATE%TYPE
                       , X_DESCRIPTION IN RNT_PAYMENTS.DESCRIPTION%TYPE) return boolean is
        cursor c is
        select PAYMENT_ID
        from RNT_PAYMENTS
        where PAYMENT_DATE = X_PAYMENT_DATE
    and DESCRIPTION = X_DESCRIPTION;

      begin
         for c_rec in c loop
           if (X_PAYMENT_ID is null OR c_rec.PAYMENT_ID != X_PAYMENT_ID) then
             return false;
           end if;
         end loop;
         return true;
      end check_unique;

  procedure lock_row( X_PAYMENT_ID IN RNT_PAYMENTS.PAYMENT_ID%TYPE) is
     cursor c is
     select * from RNT_PAYMENTS
     where PAYMENT_ID = X_PAYMENT_ID
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
  function get_checksum( X_PAYMENT_ID IN RNT_PAYMENTS.PAYMENT_ID%TYPE)
            return RNT_PAYMENTS_V.CHECKSUM%TYPE is 

    v_return_value               RNT_PAYMENTS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_PAYMENTS_V
    where PAYMENT_ID = X_PAYMENT_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_PAYMENT_ID IN RNT_PAYMENTS.PAYMENT_ID%TYPE
                      , X_PAYMENT_DATE IN RNT_PAYMENTS.PAYMENT_DATE%TYPE
                      , X_DESCRIPTION IN RNT_PAYMENTS.DESCRIPTION%TYPE
                      , X_PAID_OR_RECEIVED IN RNT_PAYMENTS.PAID_OR_RECEIVED%TYPE
                      , X_AMOUNT IN RNT_PAYMENTS.AMOUNT%TYPE
                      , X_TENANT_ID IN RNT_PAYMENTS.TENANT_ID%TYPE
                      , X_BUSINESS_ID IN RNT_PAYMENTS.BUSINESS_ID%TYPE
                      , X_CHECKSUM IN RNT_PAYMENTS_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_PAYMENTS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_PAYMENT_ID);

      -- validate checksum
      l_checksum := get_checksum(X_PAYMENT_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;
     
         if not check_unique(X_PAYMENT_ID, X_PAYMENT_DATE, X_DESCRIPTION) then
             RAISE_APPLICATION_ERROR(-20006, 'Update values must be unique.');
         end if;
     update RNT_PAYMENTS
     set PAYMENT_DATE = X_PAYMENT_DATE
     , DESCRIPTION = X_DESCRIPTION
     , PAID_OR_RECEIVED = X_PAID_OR_RECEIVED
     , AMOUNT = X_AMOUNT
     , TENANT_ID = X_TENANT_ID
     , BUSINESS_ID = X_BUSINESS_ID
     where PAYMENT_ID = X_PAYMENT_ID;

  end update_row;

  function insert_row( X_PAYMENT_DATE IN RNT_PAYMENTS.PAYMENT_DATE%TYPE
                     , X_DESCRIPTION IN RNT_PAYMENTS.DESCRIPTION%TYPE
                     , X_PAID_OR_RECEIVED IN RNT_PAYMENTS.PAID_OR_RECEIVED%TYPE
                     , X_AMOUNT IN RNT_PAYMENTS.AMOUNT%TYPE
                     , X_TENANT_ID IN RNT_PAYMENTS.TENANT_ID%TYPE
                     , X_BUSINESS_ID IN RNT_PAYMENTS.BUSINESS_ID%TYPE)
              return RNT_PAYMENTS.PAYMENT_ID%TYPE
  is
     x          number;
  begin
if not check_unique(NULL, X_PAYMENT_DATE, X_DESCRIPTION) then
         RAISE_APPLICATION_ERROR(-20006, 'Insert values must be unique.');
     end if;
  
     insert into RNT_PAYMENTS
     ( PAYMENT_ID
     , PAYMENT_DATE
     , DESCRIPTION
     , PAID_OR_RECEIVED
     , AMOUNT
     , TENANT_ID
     , BUSINESS_ID)
     values
     ( RNT_PAYMENTS_SEQ.NEXTVAL
     , X_PAYMENT_DATE
     , X_DESCRIPTION
     , X_PAID_OR_RECEIVED
     , X_AMOUNT
     , X_TENANT_ID
     , X_BUSINESS_ID)
     returning PAYMENT_ID into x;

     return x;
  end insert_row;
/*
function is_exists_allocation(X_PAYMENT_ID RNT_PAYMENTS.PAYMENT_ID%TYPE) return boolean
is
 x NUMBER;
begin
  select 1
  into x
  from DUAL
  where exists (select 1
                from RNT_PAYMENTS
                where PAYMENT_ID = X_PAYMENT_ID
                );
  return true;
exception
  when NO_DATA_FOUND then
     return false;   
end;
*/

  procedure delete_row( X_PAYMENT_ID IN RNT_PAYMENTS.PAYMENT_ID%TYPE) is

  begin
    /*
     if is_exists_allocation(X_PAYMENT_ID) then
      RAISE_APPLICATION_ERROR(-20004, 'Cannot delete record. Found payment allocation for record.');
    end if;
    */
    update RNT_PAYMENT_ALLOCATIONS
    set PAYMENT_ID = NULL
    where PAYMENT_ID = X_PAYMENT_ID; 
    
    delete from RNT_PAYMENTS
    where PAYMENT_ID = X_PAYMENT_ID;

  end delete_row;

  procedure set_allocation(X_PAYMENT_ID IN RNT_PAYMENTS.PAYMENT_ID%TYPE, 
                           X_PAY_ALLOC_ID IN RNT_PAYMENT_ALLOCATIONS.PAY_ALLOC_ID%TYPE)
  is
  begin
     update RNT_PAYMENT_ALLOCATIONS
     set PAYMENT_ID = X_PAYMENT_ID
     where PAY_ALLOC_ID = X_PAY_ALLOC_ID; 
  end;
  
  procedure generate_payment_list(X_BUSINESS_ID RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE)
  is
  cursor c is
        select a.DATE_AVAILABLE, 
               a.TERM,
               NVL(max_payment.MAX_PAYMENT_DATE, a.DATE_AVAILABLE) as MAX_PAYMENT_DATE,
               a.AMOUNT_PERIOD,
               a.DISCOUNT_AMOUNT,
               a.DISCOUNT_TYPE,
               a.DISCOUNT_PERIOD 
        from RNT_TENANCY_AGREEMENT_V a,
             RNT_PROPERTY_UNITS_V u,
             RNT_TENANT t,
             (select TENANT_ID, max(PAYMENT_DUE_DATE) as MAX_PAYMENT_DATE 
              from RNT_ACCOUNTS_RECEIVABLE 
              group by TENANT_ID) max_payment
        where a.UNIT_ID = u.UNIT_ID
          and a.AGREEMENT_ID = t.AGREEMENT_ID 
          and SYSDATE < a.END_DATE
          and decode(AMOUNT_PERIOD,
               'MONTH', ADD_MONTHS(SYSDATE, -1),
               'BI-MONTH', ADD_MONTHS(SYSDATE, -2),
               '2WEEKS', SYSDATE-14,
               'WEEK', SYSDATE-7
               ) > (select NVL(max(PAYMENT_DUE_DATE), a.DATE_AVAILABLE) 
                         from RNT_ACCOUNTS_RECEIVABLE 
                         where TENANT_ID = t.TENANT_ID)
         and max_payment.TENANT_ID(+) = t.TENANT_ID
         and u.BUSINESS_ID = X_BUSINESS_ID;   
  begin
    null;
  end;
                            
end RNT_PAYMENTS_PKG;
/

SHOW ERRORS;

CREATE OR REPLACE FORCE VIEW RNT_SUPPLIERS_V
(SUPPLIER_ID, NAME, PHONE1, PHONE2, ADDRESS1, 
 ADDRESS2, CITY, STATE, ZIPCODE, SSN, 
 EMAIL_ADDRESS, COMMENTS, BUSINESS_ID, CHECKSUM)
AS 
select s.SUPPLIER_ID
,      s.NAME
,      s.PHONE1
,      s.PHONE2
,      s.ADDRESS1
,      s.ADDRESS2
,      s.CITY
,      s.STATE
,      s.ZIPCODE
,      s.SSN
,      s.EMAIL_ADDRESS
,      s.COMMENTS
,      s.BUSINESS_ID
,      rnt_sys_checksum_rec_pkg.get_checksum('SUPPLIER_ID='||s.SUPPLIER_ID||'NAME='||s.NAME||'PHONE1='||s.PHONE1||'PHONE2='||s.PHONE2||'ADDRESS1='||s.ADDRESS1||'ADDRESS2='||s.ADDRESS2||'CITY='||s.CITY||'STATE='||s.STATE||'ZIPCODE='||s.ZIPCODE||'SSN='||s.SSN||'EMAIL_ADDRESS='||s.EMAIL_ADDRESS||'COMMENTS='||s.COMMENTS||'BUSINESS_ID='||s.BUSINESS_ID) as CHECKSUM
from RNT_SUPPLIERS s,
     RNT_BUSINESS_UNITS_V bu
where s.BUSINESS_ID = bu.BUSINESS_ID;

ALTER TABLE RNT_ACCOUNTS_PAYABLE
 ADD CONSTRAINT RNT_ACCOUNTS_PAYABLE_FK6 
 FOREIGN KEY (PAYMENT_PROPERTY_ID) 
 REFERENCES RNT_PROPERTIES (PROPERTY_ID);

 