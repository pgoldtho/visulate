CREATE OR REPLACE PACKAGE        RNT_PROPERTY_UNITS_PKG AS
/******************************************************************************
   NAME:       RNT_PROPERTY_UNITS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        04.04.2007             1. Created this package.
******************************************************************************/

function get_checksum(p_unit_id RNT_PROPERTY_UNITS.UNIT_ID%TYPE) return VARCHAR2;

procedure lock_row(X_UNIT_ID RNT_PROPERTY_UNITS.UNIT_ID%TYPE);

procedure update_row(X_UNIT_ID RNT_PROPERTY_UNITS.UNIT_ID%TYPE, 
                     X_PROPERTY_ID RNT_PROPERTY_UNITS.PROPERTY_ID%TYPE, 
                     X_UNIT_NAME RNT_PROPERTY_UNITS.UNIT_NAME%TYPE, 
                     X_UNIT_SIZE RNT_PROPERTY_UNITS.UNIT_SIZE%TYPE, 
                     X_BEDROOMS RNT_PROPERTY_UNITS.BEDROOMS%TYPE, 
                     X_BATHROOMS RNT_PROPERTY_UNITS.BATHROOMS%TYPE,
                     X_CHECKSUM VARCHAR2);

function insert_row( X_PROPERTY_ID RNT_PROPERTY_UNITS.PROPERTY_ID%TYPE, 
                     X_UNIT_NAME RNT_PROPERTY_UNITS.UNIT_NAME%TYPE, 
                     X_UNIT_SIZE RNT_PROPERTY_UNITS.UNIT_SIZE%TYPE, 
                     X_BEDROOMS RNT_PROPERTY_UNITS.BEDROOMS%TYPE, 
                     X_BATHROOMS RNT_PROPERTY_UNITS.BATHROOMS%TYPE
                    ) return RNT_PROPERTY_UNITS.UNIT_ID%TYPE;

function is_exists_childs(X_UNIT_ID RNT_PROPERTY_UNITS.UNIT_ID%TYPE) return boolean;

procedure delete_row(X_UNIT_ID RNT_PROPERTY_UNITS.UNIT_ID%TYPE);
                     
END RNT_PROPERTY_UNITS_PKG;
/


CREATE OR REPLACE PACKAGE BODY        RNT_PROPERTY_UNITS_PKG AS
/******************************************************************************
   NAME:       RNT_PROPERTY_UNITS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        04.04.2007             1. Created this package body.
******************************************************************************/

function get_checksum(p_unit_id RNT_PROPERTY_UNITS.UNIT_ID%TYPE) return VARCHAR2
is
begin
   for x in (select
               UNIT_ID, PROPERTY_ID, 
               UNIT_NAME, UNIT_SIZE, BEDROOMS, 
               BATHROOMS
             from RNT_PROPERTY_UNITS      
             where UNIT_ID = p_unit_id) loop
         RNT_SYS_CHECKSUM_REC_PKG.INIT;
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.UNIT_ID);         
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.PROPERTY_ID);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.UNIT_NAME); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.UNIT_SIZE);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.BEDROOMS);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.BATHROOMS); 
         return RNT_SYS_CHECKSUM_REC_PKG.GET_CHECKSUM;
   end loop;
   raise NO_DATA_FOUND;  
end;

function check_unique(X_UNIT_ID RNT_PROPERTY_UNITS.UNIT_ID%TYPE,
                      X_PROPERTY_ID RNT_PROPERTY_UNITS.PROPERTY_ID%TYPE, 
                      X_UNIT_NAME RNT_PROPERTY_UNITS.UNIT_NAME%TYPE) return boolean
is
  x NUMBER;
begin
   select 1 
   into x
   from DUAL
   where exists (
                   select 1
                   from RNT_PROPERTY_UNITS
                   where PROPERTY_ID = X_PROPERTY_ID
                     and UNIT_NAME = X_UNIT_NAME
                     and (UNIT_ID != X_UNIT_ID or X_UNIT_ID is null)
                 );
  return false;
exception
  when NO_DATA_FOUND then
     return true;                        
end;                       
                      

procedure lock_row(X_UNIT_ID RNT_PROPERTY_UNITS.UNIT_ID%TYPE)
is
    cursor c is
          select
               UNIT_ID, PROPERTY_ID, 
               UNIT_NAME, UNIT_SIZE, BEDROOMS, 
               BATHROOMS
          from RNT_PROPERTY_UNITS      
          where UNIT_ID = X_UNIT_ID
          for update of UNIT_ID nowait; 
begin
  open c;
  close c;
exception
  when OTHERS then
    if SQLCODE = -54 then
      RAISE_APPLICATION_ERROR(-20001, 'Cannot changed record. Record is locked.');
    end if; 
end;

function check_allowed_access(X_PROPERTY_ID RNT_PROPERTIES.PROPERTY_ID%TYPE) return boolean
is
  x NUMBER;
begin
  select 1
  into x 
  from DUAL
  where exists(select 1 
               from RNT_BUSINESS_UNITS_V bu,
                    RNT_PROPERTIES p
               where p.PROPERTY_ID = X_PROPERTY_ID
                 and bu.BUSINESS_ID = p.BUSINESS_ID);
  return TRUE;                
exception
  when NO_DATA_FOUND then
    return FALSE; 
end;

procedure update_row(X_UNIT_ID RNT_PROPERTY_UNITS.UNIT_ID%TYPE, 
                     X_PROPERTY_ID RNT_PROPERTY_UNITS.PROPERTY_ID%TYPE, 
                     X_UNIT_NAME RNT_PROPERTY_UNITS.UNIT_NAME%TYPE, 
                     X_UNIT_SIZE RNT_PROPERTY_UNITS.UNIT_SIZE%TYPE, 
                     X_BEDROOMS RNT_PROPERTY_UNITS.BEDROOMS%TYPE, 
                     X_BATHROOMS RNT_PROPERTY_UNITS.BATHROOMS%TYPE,
                     X_CHECKSUM VARCHAR2)
is
 l_checksum varchar2(32); 
begin
   lock_row(X_UNIT_ID);
   
   -- validate checksum   
   l_checksum := get_checksum(X_UNIT_ID);
   if X_CHECKSUM != l_checksum then
      RAISE_APPLICATION_ERROR(-20002, 'Record was changed another user.');
   end if;
 
   if not check_allowed_access(X_PROPERTY_ID) then
      RAISE_APPLICATION_ERROR(-20010, 'Security error. You cannot update this unit.');       
   end if;
     
   if not check_unique(X_UNIT_ID, X_PROPERTY_ID, X_UNIT_NAME) then
      RAISE_APPLICATION_ERROR(-20370, 'Unit name must be unique for property.');                 
   end if;                       
      
   update RNT_PROPERTY_UNITS
   set PROPERTY_ID = X_PROPERTY_ID,
       UNIT_NAME   = X_UNIT_NAME,
       UNIT_SIZE   = X_UNIT_SIZE,
       BEDROOMS    = X_BEDROOMS,
       BATHROOMS   = X_BATHROOMS
   where UNIT_ID  = X_UNIT_ID;
end;                        

function insert_row( X_PROPERTY_ID RNT_PROPERTY_UNITS.PROPERTY_ID%TYPE, 
                     X_UNIT_NAME RNT_PROPERTY_UNITS.UNIT_NAME%TYPE, 
                     X_UNIT_SIZE RNT_PROPERTY_UNITS.UNIT_SIZE%TYPE, 
                     X_BEDROOMS RNT_PROPERTY_UNITS.BEDROOMS%TYPE, 
                     X_BATHROOMS RNT_PROPERTY_UNITS.BATHROOMS%TYPE
                    ) return RNT_PROPERTY_UNITS.UNIT_ID%TYPE
is
  x RNT_PROPERTY_UNITS.UNIT_ID%TYPE := 0;
begin
   if not check_unique(NULL, X_PROPERTY_ID, X_UNIT_NAME) then
      RAISE_APPLICATION_ERROR(-20371, 'Unit name must be unique for property.');                 
   end if;
   
   if not check_allowed_access(X_PROPERTY_ID) then
      RAISE_APPLICATION_ERROR(-20372, 'Security error. You cannot insert this unit.');       
   end if;
   
   insert into RNT_PROPERTY_UNITS (
            UNIT_ID, PROPERTY_ID, UNIT_NAME, 
            UNIT_SIZE, BEDROOMS, BATHROOMS) 
   values (RNT_PROPERTY_UNITS_SEQ.NEXTVAL, X_PROPERTY_ID, X_UNIT_NAME, 
          X_UNIT_SIZE, X_BEDROOMS, X_BATHROOMS)
   returning UNIT_ID into x;
   return x;
end;

/*
function is_exists_tenant(X_UNIT_ID RNT_PROPERTY_UNITS.UNIT_ID%TYPE) return boolean
is
 x NUMBER;
begin
  select 1
  into x
  from DUAL
  where exists (select 1
                from RNT_TENANT
                where UNIT_APPLIED_FOR = X_UNIT_ID
                );
  return true;
exception
  when NO_DATA_FOUND then
     return false;   
end;
*/

function is_exists_agreement(X_UNIT_ID RNT_PROPERTY_UNITS.UNIT_ID%TYPE) return boolean
is
 x NUMBER;
begin
  select 1
  into x
  from DUAL
  where exists (select 1
                from RNT_TENANCY_AGREEMENT
                where UNIT_ID = X_UNIT_ID
                );
  return true;
exception
  when NO_DATA_FOUND then
     return false;   
end;

function is_exists_expenses(X_UNIT_ID RNT_PROPERTY_UNITS.UNIT_ID%TYPE) return boolean
is
 x NUMBER;
begin
  select 1
  into x
  from DUAL
  where exists (select 1
                from RNT_PROPERTY_EXPENSES
                where UNIT_ID = X_UNIT_ID
                );
  return true;
exception
  when NO_DATA_FOUND then
     return false;   
end;

function is_exists_childs(X_UNIT_ID RNT_PROPERTY_UNITS.UNIT_ID%TYPE) return boolean
is
begin
 
   return --is_exists_tenant(X_UNIT_ID) or
          is_exists_agreement(X_UNIT_ID) or
          is_exists_expenses(X_UNIT_ID);
end;

procedure delete_row(X_UNIT_ID RNT_PROPERTY_UNITS.UNIT_ID%TYPE)
is
begin
  -- check for exists child records
/*  if is_exists_tenant(X_UNIT_ID) then
    RAISE_APPLICATION_ERROR(-20004, 'Cannot delete record. For unit exists tenant record.');
  end if;
  */
  if is_exists_agreement(X_UNIT_ID) then
    RAISE_APPLICATION_ERROR(-20373, 'Cannot delete record. For unit exists agreement record.');
  end if;
  if is_exists_expenses(X_UNIT_ID) then
    RAISE_APPLICATION_ERROR(-20374, 'Cannot delete record. For unit exists property expenses.');
  end if;

  
  delete from RNT_PROPERTY_UNITS
  where UNIT_ID = X_UNIT_ID;
end;                    

END RNT_PROPERTY_UNITS_PKG;
/


