--
-- Create Schema Script 
--   Database Version   : 10.2.0.1.0 
--   TOAD Version       : 9.0.0.160 
--   DB Connect String  : XE 
--   Schema             : RNTMGR 
--   Script Created by  : RNTMGR 
--   Script Created at  : 24.04.2007 20:28:48 
--   Physical Location  :  
--   Notes              :  
--

-- Object Counts: 
--   Packages: 8        Lines of Code: 331 
--   Package Bodies: 8  Lines of Code: 1608 


--
-- RNT_SYS_CHECKSUM_REC_PKG  (Package) 
--
CREATE OR REPLACE PACKAGE        RNT_SYS_CHECKSUM_REC_PKG AS
/******************************************************************************
   NAME:       RNT_SYS_CHECKSUM_REC_PKG
   PURPOSE: Calculate checksum for record.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        28.03.2007             1. Created this package.
******************************************************************************/

/* Raise when length of internal value > 32760.
If it meaning then you can use next code:
  rnt_sys_checksum_rec_pkg.init;
  rnt_sys_checksum_rec_pkg.append(<very long string about 32000>);
  x1 := rnt_sys_checksum_rec_pkg.get_checksum();
  
  rnt_sys_checksum_rec_pkg.init;
  rnt_sys_checksum_rec_pkg.append(<another very long string about 32000>);
  x2 := rnt_sys_checksum_rec_pkg.get_checksum();
  
  rnt_sys_checksum_rec_pkg.init;
  rnt_sys_checksum_rec_pkg.append(x1);
  rnt_sys_checksum_rec_pkg.append(x2);
  
  dbms_output.put_line(rnt_sys_checksum_rec_pkg.get_checksum());
*/   
E_BOUNDARY_ERROR EXCEPTION;

PRAGMA EXCEPTION_INIT (E_BOUNDARY_ERROR, -20001);

-- inital package state
procedure init;

-- append field value to checksum
procedure append(p_char VARCHAR2);
procedure append(p_number NUMBER);
procedure append(p_date DATE);


-- return internal value. Length of return value 32 bytes. 
function get_internal_value return varchar2;

-- set internal value
procedure set_internal_value(val varchar2);

-- return checksum
function get_checksum return varchar2; 

END RNT_SYS_CHECKSUM_REC_PKG;
/

SHOW ERRORS;


--
-- RNT_USERS_PKG  (Package) 
--
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

function CHANGE_PASSWORD(X_USER_ID RNT_USERS.USER_ID%TYPE, X_NEW_PASSWORD RNT_USERS.USER_PASSWORD%TYPE) return varchar2;

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

END RNT_USERS_PKG;
/

SHOW ERRORS;


--
-- RNT_SYS_CHECKSUM_REC_PKG  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY        RNT_SYS_CHECKSUM_REC_PKG AS
/******************************************************************************
   NAME:       RNT_SYS_CHECKSUM_REC_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        28.03.2007             1. Created this package body.
******************************************************************************/

g_columns_value VARCHAR2(32760); 
g_boundary  CONSTANT VARCHAR2(20):= 'aguk@lan.aommz.com';

procedure init
is
begin
    g_columns_value := '';  
end;

procedure append(p_char varchar2)
is
begin
   -- append field separator, if first field value was adding
   if g_columns_value is not null then
      if  length(g_columns_value) + length(g_boundary) > 32760 then
         raise E_BOUNDARY_ERROR;
      end if;
      g_columns_value := g_columns_value||g_boundary;
   end if;
   
   if length(g_columns_value) + length(p_char) > 32760 then
      raise E_BOUNDARY_ERROR;
   end if;
      
   g_columns_value := g_columns_value||p_char;    
end;

procedure append(p_number NUMBER)
is
begin
  append(to_char(p_number));
end;

procedure append(p_date DATE)
is
begin
  append('RRRRMMDDHH24MISS');
end;


function get_checksum return varchar2
is
  x_field varchar2(32760) := '';
  x_key_string varchar2(16) := 'VISULATE-RENTAL_';
begin
  return RAWTOHEX(UTL_RAW.CAST_TO_RAW(dbms_obfuscation_toolkit.MD5(input_string => g_columns_value)));
end;

-- return internal value. 
function get_internal_value return varchar2
is
begin
  return g_columns_value;
end;

-- set internal value
procedure set_internal_value(val varchar2)
is
begin
  g_columns_value := val;
end;
 

END RNT_SYS_CHECKSUM_REC_PKG;
/

SHOW ERRORS;


--
-- RNT_USERS_PKG  (Package Body) 
--
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


--
-- RNT_USER_ASSIGNMENTS_PKG  (Package) 
--
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

SHOW ERRORS;


--
-- RNT_LOANS_PKG  (Package) 
--
CREATE OR REPLACE PACKAGE        RNT_LOANS_PKG AS
/******************************************************************************
   NAME:       RNT_LOANS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        08.04.2007             1. Created this package.
******************************************************************************/

function get_checksum(X_LOAN_ID RNT_LOANS.LOAN_ID%TYPE) return VARCHAR2;

procedure update_row(X_LOAN_ID            RNT_LOANS.LOAN_ID%TYPE,
                     X_PROPERTY_ID        RNT_LOANS.PROPERTY_ID%TYPE,
                     X_POSITION           RNT_LOANS.POSITION%TYPE,
                     X_LOAN_DATE          RNT_LOANS.LOAN_DATE%TYPE,
                     X_LOAN_AMOUNT        RNT_LOANS.LOAN_AMOUNT%TYPE,
                     X_TERM               RNT_LOANS.TERM%TYPE,
                     X_INTEREST_RATE      RNT_LOANS.INTEREST_RATE%TYPE,
                     X_CREDIT_LINE_YN     RNT_LOANS.CREDIT_LINE_YN%TYPE,
                     X_ARM_YN             RNT_LOANS.ARM_YN%TYPE,
                     X_BALLOON_DATE       RNT_LOANS.BALLOON_DATE%TYPE,
                     X_AMORTIZATION_START RNT_LOANS.AMORTIZATION_START%TYPE,
                     X_SETTLEMENT_DATE    RNT_LOANS.SETTLEMENT_DATE%TYPE,
                     X_CHECKSUM           VARCHAR2
                    ); 

function insert_row( X_PROPERTY_ID        RNT_LOANS.PROPERTY_ID%TYPE,
                     X_POSITION           RNT_LOANS.POSITION%TYPE,
                     X_LOAN_DATE          RNT_LOANS.LOAN_DATE%TYPE,
                     X_LOAN_AMOUNT        RNT_LOANS.LOAN_AMOUNT%TYPE,
                     X_TERM               RNT_LOANS.TERM%TYPE,
                     X_INTEREST_RATE      RNT_LOANS.INTEREST_RATE%TYPE,
                     X_CREDIT_LINE_YN     RNT_LOANS.CREDIT_LINE_YN%TYPE,
                     X_ARM_YN             RNT_LOANS.ARM_YN%TYPE,
                     X_BALLOON_DATE       RNT_LOANS.BALLOON_DATE%TYPE,
                     X_AMORTIZATION_START RNT_LOANS.AMORTIZATION_START%TYPE,
                     X_SETTLEMENT_DATE    RNT_LOANS.SETTLEMENT_DATE%TYPE
                    ) return RNT_LOANS.LOAN_ID%TYPE;

procedure delete_row(X_LOAN_ID       RNT_LOANS.LOAN_ID%TYPE);                     
END RNT_LOANS_PKG;
/

SHOW ERRORS;


--
-- RNT_PROPERTY_UNITS_PKG  (Package) 
--
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

SHOW ERRORS;


--
-- RNT_TENANCY_AGREEMENT_PKG  (Package) 
--
CREATE OR REPLACE PACKAGE        RNT_TENANCY_AGREEMENT_PKG AS
/******************************************************************************
   NAME:       RNT_TENANCY_AGREEMENT_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        06.04.2007             1. Created this package.
******************************************************************************/

function get_checksum(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE) return VARCHAR2;
procedure lock_row(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE);

procedure update_row(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE,
                     X_UNIT_ID RNT_TENANCY_AGREEMENT.UNIT_ID%TYPE,
                     X_AGREEMENT_DATE RNT_TENANCY_AGREEMENT.AGREEMENT_DATE%TYPE,
                     X_TERM RNT_TENANCY_AGREEMENT.TERM%TYPE,
                     X_AMOUNT RNT_TENANCY_AGREEMENT.AMOUNT%TYPE,
                     X_AMOUNT_PERIOD RNT_TENANCY_AGREEMENT.AMOUNT_PERIOD%TYPE,
                     X_DATE_AVAILABLE RNT_TENANCY_AGREEMENT.DATE_AVAILABLE%TYPE,
                     X_DEPOSIT RNT_TENANCY_AGREEMENT.DEPOSIT%TYPE,
                     X_LAST_MONTH RNT_TENANCY_AGREEMENT.LAST_MONTH%TYPE,
                     X_DISCOUNT_AMOUNT RNT_TENANCY_AGREEMENT.DISCOUNT_AMOUNT%TYPE,
                     X_DISCOUNT_TYPE RNT_TENANCY_AGREEMENT.DISCOUNT_TYPE%TYPE,
                     X_DISCOUNT_PERIOD RNT_TENANCY_AGREEMENT.DISCOUNT_PERIOD%TYPE,
                     X_CHECKSUM VARCHAR2
                     );

function insert_row(X_UNIT_ID RNT_TENANCY_AGREEMENT.UNIT_ID%TYPE,
                     X_AGREEMENT_DATE RNT_TENANCY_AGREEMENT.AGREEMENT_DATE%TYPE,
                     X_TERM RNT_TENANCY_AGREEMENT.TERM%TYPE,
                     X_AMOUNT RNT_TENANCY_AGREEMENT.AMOUNT%TYPE,
                     X_AMOUNT_PERIOD RNT_TENANCY_AGREEMENT.AMOUNT_PERIOD%TYPE,
                     X_DATE_AVAILABLE RNT_TENANCY_AGREEMENT.DATE_AVAILABLE%TYPE,
                     X_DEPOSIT RNT_TENANCY_AGREEMENT.DEPOSIT%TYPE,
                     X_LAST_MONTH RNT_TENANCY_AGREEMENT.LAST_MONTH%TYPE,
                     X_DISCOUNT_AMOUNT RNT_TENANCY_AGREEMENT.DISCOUNT_AMOUNT%TYPE,
                     X_DISCOUNT_TYPE RNT_TENANCY_AGREEMENT.DISCOUNT_TYPE%TYPE,
                     X_DISCOUNT_PERIOD RNT_TENANCY_AGREEMENT.DISCOUNT_PERIOD%TYPE
                     ) return RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE;

procedure delete_row(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE); 
END RNT_TENANCY_AGREEMENT_PKG;
/

SHOW ERRORS;


--
-- RNT_BUSINESS_UNITS_PKG  (Package) 
--
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


--
-- RNT_PROPERTY_UNITS_PKG  (Package Body) 
--
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
      RAISE_APPLICATION_ERROR(-20005, 'Unit name must be unique for property.');                 
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
      RAISE_APPLICATION_ERROR(-20005, 'Unit name must be unique for property.');                 
   end if;
   
   if not check_allowed_access(X_PROPERTY_ID) then
      RAISE_APPLICATION_ERROR(-20010, 'Security error. You cannot insert this unit.');       
   end if;
   
   insert into RNT_PROPERTY_UNITS (
            UNIT_ID, PROPERTY_ID, UNIT_NAME, 
            UNIT_SIZE, BEDROOMS, BATHROOMS) 
   values (RNT_PROPERTY_UNITS_SEQ.NEXTVAL, X_PROPERTY_ID, X_UNIT_NAME, 
          X_UNIT_SIZE, X_BEDROOMS, X_BATHROOMS)
   returning UNIT_ID into x;
   return x;
end;

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
 
   return is_exists_tenant(X_UNIT_ID) or
          is_exists_agreement(X_UNIT_ID) or
          is_exists_expenses(X_UNIT_ID);
end;

procedure delete_row(X_UNIT_ID RNT_PROPERTY_UNITS.UNIT_ID%TYPE)
is
begin
  -- check for exists child records
  if is_exists_tenant(X_UNIT_ID) then
    RAISE_APPLICATION_ERROR(-20004, 'Cannot delete record. For unit exists tenant record.');
  end if;
  if is_exists_agreement(X_UNIT_ID) then
    RAISE_APPLICATION_ERROR(-20004, 'Cannot delete record. For unit exists agreement record.');
  end if;
  if is_exists_expenses(X_UNIT_ID) then
    RAISE_APPLICATION_ERROR(-20004, 'Cannot delete record. For unit exists property expenses.');
  end if;

  
  delete from RNT_PROPERTY_UNITS
  where UNIT_ID = X_UNIT_ID;
end;                    

END RNT_PROPERTY_UNITS_PKG;
/

SHOW ERRORS;


--
-- RNT_TENANCY_AGREEMENT_PKG  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY        RNT_TENANCY_AGREEMENT_PKG AS
/******************************************************************************
   NAME:       RNT_TENANCY_AGREEMENT_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        06.04.2007             1. Created this package body.
******************************************************************************/
function get_checksum(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE) return VARCHAR2
is
begin
for x in (select 
           AGREEMENT_ID, UNIT_ID, AGREEMENT_DATE, 
           TERM, AMOUNT, AMOUNT_PERIOD, 
           DATE_AVAILABLE, DEPOSIT, LAST_MONTH, 
           DISCOUNT_AMOUNT, DISCOUNT_TYPE, DISCOUNT_PERIOD
         from RNT_TENANCY_AGREEMENT
         where AGREEMENT_ID = X_AGREEMENT_ID) loop
         RNT_SYS_CHECKSUM_REC_PKG.INIT;
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.AGREEMENT_ID);         
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.UNIT_ID);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.AGREEMENT_DATE); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.TERM);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.AMOUNT);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.AMOUNT_PERIOD);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.DATE_AVAILABLE);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.DEPOSIT);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.LAST_MONTH);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.DISCOUNT_AMOUNT);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.DISCOUNT_TYPE);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.DISCOUNT_PERIOD);
         return RNT_SYS_CHECKSUM_REC_PKG.GET_CHECKSUM;
   end loop;
   raise NO_DATA_FOUND;  
end;



function check_unique(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE, 
                      X_UNIT_ID RNT_TENANCY_AGREEMENT.UNIT_ID%TYPE,
                      X_DATE_AVAILABLE RNT_TENANCY_AGREEMENT.AGREEMENT_DATE%TYPE
                      ) return boolean
is
  x NUMBER;
begin
   select 1 
   into x
   from DUAL
   where exists (
                   select 1
                   from RNT_TENANCY_AGREEMENT
                   where UNIT_ID = X_UNIT_ID
                     and DATE_AVAILABLE = X_DATE_AVAILABLE
                     and (AGREEMENT_ID != X_AGREEMENT_ID or X_AGREEMENT_ID is null)
                 );
  return false;
exception
  when NO_DATA_FOUND then
     return true;                        
end;                       
                      

procedure lock_row(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE)
is
    cursor c is
              select 
               AGREEMENT_ID, UNIT_ID, AGREEMENT_DATE, 
               TERM, AMOUNT, AMOUNT_PERIOD, 
               DATE_AVAILABLE, DEPOSIT, LAST_MONTH, 
               DISCOUNT_AMOUNT, DISCOUNT_TYPE, DISCOUNT_PERIOD
             from RNT_TENANCY_AGREEMENT
             where AGREEMENT_ID = X_AGREEMENT_ID
             for update of AGREEMENT_ID nowait; 
begin
  open c;
  close c;
exception
  when OTHERS then
    if SQLCODE = -54 then
      RAISE_APPLICATION_ERROR(-20001, 'Cannot changed record. Record is locked.');
    end if; 
end;

procedure update_row(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE,
                     X_UNIT_ID RNT_TENANCY_AGREEMENT.UNIT_ID%TYPE,
                     X_AGREEMENT_DATE RNT_TENANCY_AGREEMENT.AGREEMENT_DATE%TYPE,
                     X_TERM RNT_TENANCY_AGREEMENT.TERM%TYPE,
                     X_AMOUNT RNT_TENANCY_AGREEMENT.AMOUNT%TYPE,
                     X_AMOUNT_PERIOD RNT_TENANCY_AGREEMENT.AMOUNT_PERIOD%TYPE,
                     X_DATE_AVAILABLE RNT_TENANCY_AGREEMENT.DATE_AVAILABLE%TYPE,
                     X_DEPOSIT RNT_TENANCY_AGREEMENT.DEPOSIT%TYPE,
                     X_LAST_MONTH RNT_TENANCY_AGREEMENT.LAST_MONTH%TYPE,
                     X_DISCOUNT_AMOUNT RNT_TENANCY_AGREEMENT.DISCOUNT_AMOUNT%TYPE,
                     X_DISCOUNT_TYPE RNT_TENANCY_AGREEMENT.DISCOUNT_TYPE%TYPE,
                     X_DISCOUNT_PERIOD RNT_TENANCY_AGREEMENT.DISCOUNT_PERIOD%TYPE,
                     X_CHECKSUM VARCHAR2
                     )
is
l_checksum varchar2(32); 
begin
   
   lock_row(X_AGREEMENT_ID);
   
   -- validate checksum   
   l_checksum := get_checksum(X_AGREEMENT_ID);
   if X_CHECKSUM != l_checksum then
      RAISE_APPLICATION_ERROR(-20002, 'Record was changed another user.');
      --E_ROW_CHANGED_ANOTHER_USER  
   end if;

   if not check_unique(X_AGREEMENT_ID, X_UNIT_ID, X_DATE_AVAILABLE) then
        RAISE_APPLICATION_ERROR(-20006, 'Date available for unit must be unique');                      
   end if;   
   
   update RNT_TENANCY_AGREEMENT
   set  AGREEMENT_ID      = X_AGREEMENT_ID,
        UNIT_ID           = X_UNIT_ID,
        AGREEMENT_DATE    = X_AGREEMENT_DATE,
        TERM              = X_TERM,
        AMOUNT            = X_AMOUNT,
        AMOUNT_PERIOD     = X_AMOUNT_PERIOD,
        DATE_AVAILABLE    = X_DATE_AVAILABLE,
        DEPOSIT           = X_DEPOSIT,
        LAST_MONTH        = X_LAST_MONTH,
        DISCOUNT_AMOUNT   = X_DISCOUNT_AMOUNT,
        DISCOUNT_TYPE     = X_DISCOUNT_TYPE,
        DISCOUNT_PERIOD   = X_DISCOUNT_PERIOD
   where AGREEMENT_ID     = X_AGREEMENT_ID;
end;                 

function insert_row(X_UNIT_ID RNT_TENANCY_AGREEMENT.UNIT_ID%TYPE,
                     X_AGREEMENT_DATE RNT_TENANCY_AGREEMENT.AGREEMENT_DATE%TYPE,
                     X_TERM RNT_TENANCY_AGREEMENT.TERM%TYPE,
                     X_AMOUNT RNT_TENANCY_AGREEMENT.AMOUNT%TYPE,
                     X_AMOUNT_PERIOD RNT_TENANCY_AGREEMENT.AMOUNT_PERIOD%TYPE,
                     X_DATE_AVAILABLE RNT_TENANCY_AGREEMENT.DATE_AVAILABLE%TYPE,
                     X_DEPOSIT RNT_TENANCY_AGREEMENT.DEPOSIT%TYPE,
                     X_LAST_MONTH RNT_TENANCY_AGREEMENT.LAST_MONTH%TYPE,
                     X_DISCOUNT_AMOUNT RNT_TENANCY_AGREEMENT.DISCOUNT_AMOUNT%TYPE,
                     X_DISCOUNT_TYPE RNT_TENANCY_AGREEMENT.DISCOUNT_TYPE%TYPE,
                     X_DISCOUNT_PERIOD RNT_TENANCY_AGREEMENT.DISCOUNT_PERIOD%TYPE
                     ) return RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE
is
  x RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE;
begin

    if not check_unique(NULL, X_UNIT_ID, X_DATE_AVAILABLE) then
        RAISE_APPLICATION_ERROR(-20006, 'Date available for unit must be unique');                      
    end if;
    
    insert into RNT_TENANCY_AGREEMENT (
       AGREEMENT_ID, 
       UNIT_ID, 
       AGREEMENT_DATE, 
       TERM, 
       AMOUNT, 
       AMOUNT_PERIOD, 
       DATE_AVAILABLE, 
       DEPOSIT, 
       LAST_MONTH, 
       DISCOUNT_AMOUNT, 
       DISCOUNT_TYPE, 
       DISCOUNT_PERIOD) 
    values (
       RNT_TENANCY_AGREEMENT_SEQ.NEXTVAL, 
       X_UNIT_ID, 
       X_AGREEMENT_DATE, 
       X_TERM, 
       X_AMOUNT, 
       X_AMOUNT_PERIOD, 
       X_DATE_AVAILABLE, 
       X_DEPOSIT, 
       X_LAST_MONTH, 
       X_DISCOUNT_AMOUNT, 
       X_DISCOUNT_TYPE, 
       X_DISCOUNT_PERIOD)
    returning AGREEMENT_ID into x;
    return x;    
end;             
  
function is_exists_acc_receivable(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE) return boolean
is
 x NUMBER;
begin
  select 1
  into x
  from DUAL
  where exists (select 1
                from RNT_ACCOUNTS_RECEIVABLE
                where AGREEMENT_ID = X_AGREEMENT_ID
                );
  return true;
exception
  when NO_DATA_FOUND then
     return false;   
end;

procedure delete_row(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE)
is
begin
  -- check for exists child records
  if is_exists_acc_receivable(X_AGREEMENT_ID) then
     RAISE_APPLICATION_ERROR(-20004, 'Cannot delete record. For agreement exists accounts receivable.');
  end if;
      
  delete from RNT_AGREEMENT_ACTIONS
  where AGREEMENT_ID = X_AGREEMENT_ID;
  
  delete from RNT_TENANCY_AGREEMENT
  where AGREEMENT_ID = X_AGREEMENT_ID;
end;
    
                     
END RNT_TENANCY_AGREEMENT_PKG;
/

SHOW ERRORS;


--
-- RNT_USER_ASSIGNMENTS_PKG  (Package Body) 
--
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

function insert_row(X_USER_ID RNT_USER_ASSIGNMENTS.USER_ID%TYPE,
                    X_ROLE_ID RNT_USER_ASSIGNMENTS.ROLE_ID%TYPE,
                    X_BUSINESS_ID RNT_USER_ASSIGNMENTS.BUSINESS_ID%TYPE)
                    return RNT_USER_ASSIGNMENTS.USER_ASSIGN_ID%TYPE 
is
  x RNT_USER_ASSIGNMENTS.USER_ASSIGN_ID%TYPE; 
begin
  if not check_unique(NULL, X_USER_ID, X_ROLE_ID, X_BUSINESS_ID) then
        RAISE_APPLICATION_ERROR(-20006, 'User assignment must be unique');                      
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


--
-- RNT_BUSINESS_UNITS_PKG  (Package Body) 
--
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

function INSERT_ROW(X_BUSINESS_NAME RNT_BUSINESS_UNITS.BUSINESS_NAME%TYPE,
                    X_PARENT_BUSINESS_ID RNT_BUSINESS_UNITS.PARENT_BUSINESS_ID%TYPE
                   ) return RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE
is
  x NUMBER;
begin
   
   if not check_allow_for_access(X_PARENT_BUSINESS_ID) then
       RAISE_APPLICATION_ERROR(-20006, 'You cannot create sub units for this business unit.');
   end if;

   if not check_unique(NULL, X_PARENT_BUSINESS_ID, X_BUSINESS_NAME) then
       RAISE_APPLICATION_ERROR(-20006, 'Name of business unit must be unique in parent business unit.');
   end if; 
    
   insert into RNT_BUSINESS_UNITS (
      BUSINESS_ID, BUSINESS_NAME, PARENT_BUSINESS_ID) 
   values (RNT_BUSINESS_UNITS_SEQ.NEXTVAL, X_BUSINESS_NAME, X_PARENT_BUSINESS_ID)
   returning BUSINESS_ID into x;  
   return x;
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
       RAISE_APPLICATION_ERROR(-20006, 'You cannot update this unit.');
   end if;

   if not check_unique(X_BUSINESS_ID, X_PARENT_BUSINESS_ID, X_BUSINESS_NAME) then
       RAISE_APPLICATION_ERROR(-20006, 'Name of business unit must be unique in parent business unit.');
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
      RAISE_APPLICATION_ERROR(-20011, 'Cannot delete record. Find properties for this record.');
   end if;   
   
   if (is_assign_user_exists(X_BUSINESS_ID)) then
      RAISE_APPLICATION_ERROR(-20011, 'Cannot delete record. Find assigned owners for this record.');
   end if;

   if (is_subunits_exists(X_BUSINESS_ID)) then
      RAISE_APPLICATION_ERROR(-20011, 'Cannot delete record. Find sub units for business unit.');
   end if;
 
   delete from RNT_BUSINESS_UNITS
   where BUSINESS_ID = X_BUSINESS_ID;
end;


END RNT_BUSINESS_UNITS_PKG;
/

SHOW ERRORS;


--
-- RNT_LOANS_PKG  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY        RNT_LOANS_PKG AS
/******************************************************************************
   NAME:       RNT_LOANS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        08.04.2007             1. Created this package body.
******************************************************************************/

function get_checksum(X_LOAN_ID RNT_LOANS.LOAN_ID%TYPE) return VARCHAR2
is
begin
   for x in (select 
                LOAN_ID, PROPERTY_ID, POSITION, 
                LOAN_DATE, LOAN_AMOUNT, TERM, 
                INTEREST_RATE, CREDIT_LINE_YN, ARM_YN, 
                BALLOON_DATE, AMORTIZATION_START, SETTLEMENT_DATE
            from RNT_LOANS
            where LOAN_ID = X_LOAN_ID) loop
         RNT_SYS_CHECKSUM_REC_PKG.INIT;
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.LOAN_ID);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.PROPERTY_ID);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.POSITION);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.LOAN_DATE);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.LOAN_AMOUNT);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.TERM); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.INTEREST_RATE); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.CREDIT_LINE_YN); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.ARM_YN); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.BALLOON_DATE); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.AMORTIZATION_START);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.SETTLEMENT_DATE); 
         return RNT_SYS_CHECKSUM_REC_PKG.GET_CHECKSUM;
   end loop;
   raise NO_DATA_FOUND;               
end;

procedure lock_row(X_LOAN_ID RNT_LOANS.LOAN_ID%TYPE)
is
  cursor c is
     select * 
     from RNT_LOANS   
     where LOAN_ID = X_LOAN_ID
     for update of LOAN_ID nowait; 
begin
  open c;
  close c;
exception
  when OTHERS then
    if SQLCODE = -54 then
      RAISE_APPLICATION_ERROR(-20001, 'Cannot changed record. Record is locked.');
    end if;       
end;

function check_unique(X_LOAN_ID       RNT_LOANS.LOAN_ID%TYPE,
                      X_PROPERTY_ID   RNT_LOANS.PROPERTY_ID%TYPE,
                      X_POSITION      RNT_LOANS.POSITION%TYPE
                      ) return boolean
is
  x NUMBER;
begin
   select 1 
   into x
   from DUAL
   where exists (
                   select 1
                   from RNT_LOANS
                   where (LOAN_ID != X_LOAN_ID or X_LOAN_ID is null) 
                     and PROPERTY_ID = X_PROPERTY_ID
                     and POSITION = X_POSITION             
                 );
  return false;
exception
  when NO_DATA_FOUND then
     return true;                        
end;                 

procedure update_row(X_LOAN_ID            RNT_LOANS.LOAN_ID%TYPE,
                     X_PROPERTY_ID        RNT_LOANS.PROPERTY_ID%TYPE,
                     X_POSITION           RNT_LOANS.POSITION%TYPE,
                     X_LOAN_DATE          RNT_LOANS.LOAN_DATE%TYPE,
                     X_LOAN_AMOUNT        RNT_LOANS.LOAN_AMOUNT%TYPE,
                     X_TERM               RNT_LOANS.TERM%TYPE,
                     X_INTEREST_RATE      RNT_LOANS.INTEREST_RATE%TYPE,
                     X_CREDIT_LINE_YN     RNT_LOANS.CREDIT_LINE_YN%TYPE,
                     X_ARM_YN             RNT_LOANS.ARM_YN%TYPE,
                     X_BALLOON_DATE       RNT_LOANS.BALLOON_DATE%TYPE,
                     X_AMORTIZATION_START RNT_LOANS.AMORTIZATION_START%TYPE,
                     X_SETTLEMENT_DATE    RNT_LOANS.SETTLEMENT_DATE%TYPE,
                     X_CHECKSUM           VARCHAR2
                    )
is
 l_checksum varchar2(32); 
begin
   lock_row(X_LOAN_ID);
   
   -- validate checksum   
   l_checksum := get_checksum(X_LOAN_ID);
   if X_CHECKSUM != l_checksum then
      RAISE_APPLICATION_ERROR(-20002, 'Record was changed another user.');
   end if;

   if not check_unique(X_LOAN_ID, X_PROPERTY_ID, X_POSITION) then
        RAISE_APPLICATION_ERROR(-20006, 'Position in property must be unique.');                      
   end if;   
   
   update RNT_LOANS
   set LOAN_ID            = X_LOAN_ID,
       PROPERTY_ID        = X_PROPERTY_ID,
       POSITION           = X_POSITION,
       LOAN_DATE          = X_LOAN_DATE,
       LOAN_AMOUNT        = X_LOAN_AMOUNT,
       TERM               = X_TERM,
       INTEREST_RATE      = X_INTEREST_RATE,
       CREDIT_LINE_YN     = X_CREDIT_LINE_YN,
       ARM_YN             = X_ARM_YN,
       BALLOON_DATE       = X_BALLOON_DATE,
       AMORTIZATION_START = X_AMORTIZATION_START,
       SETTLEMENT_DATE    = X_SETTLEMENT_DATE
   where LOAN_ID = X_LOAN_ID;
end;                                  

function insert_row( X_PROPERTY_ID        RNT_LOANS.PROPERTY_ID%TYPE,
                     X_POSITION           RNT_LOANS.POSITION%TYPE,
                     X_LOAN_DATE          RNT_LOANS.LOAN_DATE%TYPE,
                     X_LOAN_AMOUNT        RNT_LOANS.LOAN_AMOUNT%TYPE,
                     X_TERM               RNT_LOANS.TERM%TYPE,
                     X_INTEREST_RATE      RNT_LOANS.INTEREST_RATE%TYPE,
                     X_CREDIT_LINE_YN     RNT_LOANS.CREDIT_LINE_YN%TYPE,
                     X_ARM_YN             RNT_LOANS.ARM_YN%TYPE,
                     X_BALLOON_DATE       RNT_LOANS.BALLOON_DATE%TYPE,
                     X_AMORTIZATION_START RNT_LOANS.AMORTIZATION_START%TYPE,
                     X_SETTLEMENT_DATE    RNT_LOANS.SETTLEMENT_DATE%TYPE
                    ) return RNT_LOANS.LOAN_ID%TYPE
is
  x NUMBER;
begin
   if not check_unique(NULL, X_PROPERTY_ID, X_POSITION) then
        RAISE_APPLICATION_ERROR(-20006, 'Position in property must be unique.');                      
   end if;
   
   insert into RNT_LOANS (
       LOAN_ID, PROPERTY_ID, POSITION, 
       LOAN_DATE, LOAN_AMOUNT, TERM, 
       INTEREST_RATE, CREDIT_LINE_YN, ARM_YN, 
       BALLOON_DATE, AMORTIZATION_START, SETTLEMENT_DATE) 
    values (RNT_LOANS_SEQ.NEXTVAL, X_PROPERTY_ID, X_POSITION, 
         X_LOAN_DATE, X_LOAN_AMOUNT, X_TERM, 
         X_INTEREST_RATE, X_CREDIT_LINE_YN, X_ARM_YN, 
         X_BALLOON_DATE, X_AMORTIZATION_START, X_SETTLEMENT_DATE)
    returning LOAN_ID into x;
             
    return x;
end;                    

function is_exists_acc_receivable(X_LOAN_ID RNT_LOANS.LOAN_ID%TYPE) return boolean
is
 x NUMBER;
begin
  select 1
  into x
  from DUAL
  where exists (select 1
                from RNT_ACCOUNTS_RECEIVABLE
                where LOAN_ID = X_LOAN_ID
                );
  return true;
exception
  when NO_DATA_FOUND then
     return false;   
end;

function is_exists_acc_payable(X_LOAN_ID RNT_LOANS.LOAN_ID%TYPE) return boolean
is
 x NUMBER;
begin
  select 1
  into x
  from DUAL
  where exists (select 1
                from RNT_ACCOUNTS_PAYABLE
                where LOAN_ID = X_LOAN_ID
                );
  return true;
exception
  when NO_DATA_FOUND then
     return false;   
end;

procedure delete_row(X_LOAN_ID       RNT_LOANS.LOAN_ID%TYPE)
is
begin
  -- check for exists child records
  if is_exists_acc_receivable(X_LOAN_ID) then
     RAISE_APPLICATION_ERROR(-20004, 'Cannot delete record. For loan exists accounts receivable.');
  end if; 
  if is_exists_acc_payable(X_LOAN_ID) then
     RAISE_APPLICATION_ERROR(-20004, 'Cannot delete record. For loan exists accounts payable.');
  end if;
    
  delete from RNT_LOANS
  where LOAN_ID = X_LOAN_ID;
end;

END RNT_LOANS_PKG;
/

SHOW ERRORS;


--
-- RNT_PROPERTIES_PKG  (Package) 
--
CREATE OR REPLACE PACKAGE        RNT_PROPERTIES_PKG AS
/******************************************************************************
   NAME:       RNT_PROPERTIES_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        30.03.2007             1. Created this package.
******************************************************************************/
E_ROW_LOCKED EXCEPTION;
E_ROW_CHANGED_ANOTHER_USER EXCEPTION;

PRAGMA EXCEPTION_INIT (E_ROW_LOCKED, -20001);
PRAGMA EXCEPTION_INIT (E_ROW_CHANGED_ANOTHER_USER, -20002);

function get_ckecksum(p_property_id RNT_PROPERTIES.PROPERTY_ID%TYPE) return VARCHAR2;

procedure lock_row(X_PROPERTY_ID RNT_PROPERTIES.PROPERTY_ID%TYPE); 
   

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
                     X_CHECKSUM VARCHAR2); 

function insert_row( 
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
                     X_NOTE_YN           RNT_PROPERTIES.NOTE_YN%TYPE)
    return RNT_PROPERTIES.PROPERTY_ID%TYPE;

procedure delete_row(X_PROPERTY_ID       RNT_PROPERTIES.PROPERTY_ID%TYPE);
                          
END RNT_PROPERTIES_PKG;
/

SHOW ERRORS;


--
-- RNT_PROPERTIES_PKG  (Package Body) 
--
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
    RAISE_APPLICATION_ERROR(-20004, 'Cannot delete record. For property exists value(s) record.');
  end if;
  if is_exists_unit(X_PROPERTY_ID) then
    RAISE_APPLICATION_ERROR(-20004, 'Cannot delete record. For property exists units with child records.');
  end if;
  if is_exists_expenses(X_PROPERTY_ID) then
    RAISE_APPLICATION_ERROR(-20004, 'Cannot delete record. For property exists expenses expenses.');
  end if;
  
  delete from RNT_PROPERTY_UNITS
  where PROPERTY_ID = X_PROPERTY_ID;
  
  delete from RNT_PROPERTIES
  where PROPERTY_ID = X_PROPERTY_ID;
end;

END RNT_PROPERTIES_PKG;
/

SHOW ERRORS;


