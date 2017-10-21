CREATE OR REPLACE PACKAGE        RNT_PEOPLE_PKG AS
/******************************************************************************
   NAME:       RNT_PEOPLE_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        26.04.2007             1. Created this package.
******************************************************************************/

procedure update_row(X_PEOPLE_ID     RNT_PEOPLE.PEOPLE_ID%TYPE,
                     X_FIRST_NAME    RNT_PEOPLE.FIRST_NAME%TYPE,
                     X_LAST_NAME     RNT_PEOPLE.LAST_NAME%TYPE,
                     X_PHONE1        RNT_PEOPLE.PHONE1%TYPE,
                     X_PHONE2        RNT_PEOPLE.PHONE2%TYPE,
                     X_DATE_OF_BIRTH RNT_PEOPLE.DATE_OF_BIRTH%TYPE,
                     X_EMAIL_ADDRESS RNT_PEOPLE.EMAIL_ADDRESS%TYPE,
                     X_SSN           RNT_PEOPLE.SSN%TYPE,
                     X_DRIVERS_LICENSE RNT_PEOPLE.DRIVERS_LICENSE%TYPE,
                     X_BUSINESS_ID   RNT_PEOPLE_BU.BUSINESS_ID%TYPE, 
                     X_PEOPLE_BUSINESS_ID RNT_PEOPLE_BU.PEOPLE_BUSINESS_ID%TYPE,
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
                     X_PEOPLE_BUSINESS_ID RNT_PEOPLE_BU.PEOPLE_BUSINESS_ID%TYPE,
                     X_BUSINESS_ID   RNT_PEOPLE_BU.BUSINESS_ID%TYPE
                    ) return RNT_PEOPLE.PEOPLE_ID%TYPE;
                    
procedure delete_row(X_PEOPLE_ID RNT_PEOPLE.PEOPLE_ID%TYPE,
                     X_BUSINESS_ID RNT_PEOPLE_BU.BUSINESS_ID%TYPE,
                     X_PEOPLE_BUSINESS_ID RNT_PEOPLE_BU.PEOPLE_BUSINESS_ID%TYPE );

function insert_people_business_unit(X_PEOPLE_ID IN RNT_PEOPLE_BU.PEOPLE_ID%TYPE,
                                     X_BUSINESS_ID IN RNT_PEOPLE_BU.BUSINESS_ID%TYPE) return RNT_PEOPLE_BU.PEOPLE_BUSINESS_ID%TYPE;

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
                      X_FIRST_NAME    RNT_PEOPLE.FIRST_NAME%TYPE
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
                 );
  return false;
exception
  when NO_DATA_FOUND then
     return true;                        
end;

function check_unique_bu(X_PEOPLE_ID RNT_PEOPLE.PEOPLE_ID%TYPE, 
                         X_BUSINESS_ID RNT_PEOPLE_BU.BUSINESS_ID%TYPE,  
                         X_PEOPLE_BUSINESS_ID RNT_PEOPLE_BU.PEOPLE_BUSINESS_ID%TYPE) return boolean
is                         
 x NUMBER;
begin
  select 1
  into x
  from DUAL
  where exists (select 1 
                from RNT_PEOPLE_BU
                where PEOPLE_ID = X_PEOPLE_ID
                  and BUSINESS_ID = X_BUSINESS_ID
                  and (PEOPLE_BUSINESS_ID != X_PEOPLE_BUSINESS_ID or X_PEOPLE_BUSINESS_ID is null)
               );
  return false;
exception  
  when NO_DATA_FOUND then
    return TRUE;                 
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
                     X_BUSINESS_ID   RNT_PEOPLE_BU.BUSINESS_ID%TYPE,
                     X_PEOPLE_BUSINESS_ID RNT_PEOPLE_BU.PEOPLE_BUSINESS_ID%TYPE,
                     X_CHECKSUM      VARCHAR2
                    )
is
 l_checksum varchar2(32); 
begin
   lock_row(X_PEOPLE_ID);
   
   -- validate checksum   
   select CHECKSUM
   into l_checksum
   from RNT_PEOPLE_LIST_V
   where PEOPLE_ID = X_PEOPLE_ID
     and BUSINESS_ID = X_BUSINESS_ID;
     
   if X_CHECKSUM != l_checksum then
      RAISE_APPLICATION_ERROR(-20002, 'Record was changed another user.');
   end if;

   if not check_unique(X_PEOPLE_ID, X_LAST_NAME, X_FIRST_NAME) then
        RAISE_APPLICATION_ERROR(-20281, 'Last and first name for people must be unique.');                      
   end if;
   
   if not check_unique_bu(X_PEOPLE_ID, X_BUSINESS_ID, X_PEOPLE_BUSINESS_ID) then
        RAISE_APPLICATION_ERROR(-20283, 'People must be unique in business unit.');                      
   end if; 
   
   update RNT_PEOPLE
   set FIRST_NAME      = X_FIRST_NAME,
       LAST_NAME       = X_LAST_NAME,
       PHONE1          = X_PHONE1,
       PHONE2          = X_PHONE2,
       DATE_OF_BIRTH   = X_DATE_OF_BIRTH,
       EMAIL_ADDRESS   = X_EMAIL_ADDRESS,
       SSN             = X_SSN,
       DRIVERS_LICENSE = X_DRIVERS_LICENSE
   where PEOPLE_ID     = X_PEOPLE_ID;
   
   if X_PEOPLE_BUSINESS_ID is null then
       insert into RNT_PEOPLE_BU(PEOPLE_BUSINESS_ID, PEOPLE_ID, BUSINESS_ID) 
       values (RNT_PEOPLE_BU_SEQ.NEXTVAL, X_PEOPLE_ID, X_BUSINESS_ID);
   else
       update RNT_PEOPLE_BU
       set BUSINESS_ID = X_BUSINESS_ID,
           PEOPLE_ID = X_PEOPLE_ID
       where PEOPLE_BUSINESS_ID = X_PEOPLE_BUSINESS_ID;     
   end if;
end;

function insert_row( X_FIRST_NAME    RNT_PEOPLE.FIRST_NAME%TYPE,
                     X_LAST_NAME     RNT_PEOPLE.LAST_NAME%TYPE,
                     X_PHONE1        RNT_PEOPLE.PHONE1%TYPE,
                     X_PHONE2        RNT_PEOPLE.PHONE2%TYPE,
                     X_DATE_OF_BIRTH RNT_PEOPLE.DATE_OF_BIRTH%TYPE,
                     X_EMAIL_ADDRESS RNT_PEOPLE.EMAIL_ADDRESS%TYPE,
                     X_SSN           RNT_PEOPLE.SSN%TYPE,
                     X_DRIVERS_LICENSE RNT_PEOPLE.DRIVERS_LICENSE%TYPE,
                     X_PEOPLE_BUSINESS_ID RNT_PEOPLE_BU.PEOPLE_BUSINESS_ID%TYPE,
                     X_BUSINESS_ID   RNT_PEOPLE_BU.BUSINESS_ID%TYPE
                    ) return RNT_PEOPLE.PEOPLE_ID%TYPE
is
  x RNT_PEOPLE.PEOPLE_ID%TYPE;
begin
   if not check_unique(NULL, X_LAST_NAME, X_FIRST_NAME) then
        RAISE_APPLICATION_ERROR(-20281, 'Last and first name for people must be unique.');                      
   end if;
   
   insert into RNT_PEOPLE (
               PEOPLE_ID, FIRST_NAME, LAST_NAME, 
               PHONE1, PHONE2, DATE_OF_BIRTH, EMAIL_ADDRESS, 
               SSN, DRIVERS_LICENSE) 
   values (RNT_PEOPLE_SEQ.NEXTVAL, X_FIRST_NAME, X_LAST_NAME, 
           X_PHONE1, X_PHONE2, X_DATE_OF_BIRTH, X_EMAIL_ADDRESS, 
           X_SSN, X_DRIVERS_LICENSE)
   returning PEOPLE_ID into x;
   
   insert into RNT_PEOPLE_BU(PEOPLE_BUSINESS_ID, PEOPLE_ID, BUSINESS_ID) 
   values (RNT_PEOPLE_BU_SEQ.NEXTVAL, x, X_BUSINESS_ID);
   
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

 
function exists_BU_for_people(X_PEOPLE_ID RNT_PEOPLE.PEOPLE_ID%TYPE) return boolean
is
 x NUMBER;
begin
  select 1
  into x
  from DUAL
  where exists (select 1
                from RNT_PEOPLE_BU
                where PEOPLE_ID = X_PEOPLE_ID
                );
  return true;
exception
  when NO_DATA_FOUND then
     return false;   
end;

procedure delete_row(X_PEOPLE_ID  RNT_PEOPLE.PEOPLE_ID%TYPE,
                     X_BUSINESS_ID  RNT_PEOPLE_BU.BUSINESS_ID%TYPE,
                     X_PEOPLE_BUSINESS_ID RNT_PEOPLE_BU.PEOPLE_BUSINESS_ID%TYPE
)
is
begin
  -- check for exists child records
  /*
  if is_exists_tenant(X_PEOPLE_ID) then
     RAISE_APPLICATION_ERROR(-20282, 'Cannot delete record. For people exists tenant. Instead set enaled flag to No');
  end if; 
 */ 
    -- delete from  business units
    delete from RNT_PEOPLE_BU
    where PEOPLE_BUSINESS_ID = X_PEOPLE_BUSINESS_ID;
    
    -- if not exists business for section8 when delete this
    if not exists_BU_for_people(X_PEOPLE_ID) and not is_exists_tenant(X_PEOPLE_ID) then
        delete from RNT_PEOPLE
  where PEOPLE_ID = X_PEOPLE_ID;
    end if;
    
  
end;

function is_exists_business_unit(X_PEOPLE_ID IN RNT_PEOPLE.PEOPLE_ID%TYPE
                               , X_BUSINESS_ID IN RNT_PEOPLE_BU.BUSINESS_ID%TYPE) return boolean
  is
    x NUMBER;
  begin
    select 1
    into x 
    from DUAL
    where exists (select 1 
                  from RNT_PEOPLE_BU
                  where PEOPLE_ID = X_PEOPLE_ID
                    and BUSINESS_ID = X_BUSINESS_ID);
    return true;
  exception 
    when NO_DATA_FOUND then
       return FALSE;                         
  end;                         
function insert_people_business_unit(X_PEOPLE_ID IN RNT_PEOPLE_BU.PEOPLE_ID%TYPE,
                                     X_BUSINESS_ID IN RNT_PEOPLE_BU.BUSINESS_ID%TYPE) return RNT_PEOPLE_BU.PEOPLE_BUSINESS_ID%TYPE
is
  x RNT_PEOPLE_BU.PEOPLE_BUSINESS_ID%TYPE;
begin
  if is_exists_business_unit(X_PEOPLE_ID, X_BUSINESS_ID) then
    RAISE_APPLICATION_ERROR(-20283,	'People must be unique in business unit.');
  end if; 
  
  insert into RNT_PEOPLE_BU (PEOPLE_BUSINESS_ID, PEOPLE_ID, BUSINESS_ID) 
         values (RNT_PEOPLE_BU_SEQ.NEXTVAL, X_PEOPLE_ID, X_BUSINESS_ID)
  returning PEOPLE_BUSINESS_ID into x;
  return x;
end;                                                              


END RNT_PEOPLE_PKG;
/

SHOW ERRORS;
