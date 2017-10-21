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
   RAISE_APPLICATION_ERROR(-20280, 'Not found record in RNT_PEOPLE');   
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
        RAISE_APPLICATION_ERROR(-20281, 'Last and first name for people must be unique.');                      
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
        RAISE_APPLICATION_ERROR(-20281, 'Last and first name for people must be unique.');                      
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
     RAISE_APPLICATION_ERROR(-20282, 'Cannot delete record. For people exists tenant. Instead set enaled flag to No');
  end if; 
    
  delete from RNT_PEOPLE
  where PEOPLE_ID = X_PEOPLE_ID;
end;


END RNT_PEOPLE_PKG;
/


