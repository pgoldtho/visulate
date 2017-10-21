--
-- Create Schema Script 
--   Database Version   : 10.2.0.1.0 
--   TOAD Version       : 9.0.0.160 
--   DB Connect String  : XE 
--   Schema             : RNTMGR 
--   Script Created by  : RNTMGR 
--   Script Created at  : 09.04.2007 23:01:23 
--   Physical Location  :  
--   Notes              :  
--

-- Object Counts: 
--   Packages: 5        Lines of Code: 225 
--   Package Bodies: 5  Lines of Code: 747 


--
-- RNT_SYS_CHECKSUM_REC_PKG  (Package) 
--
CREATE OR REPLACE PACKAGE RNT_SYS_CHECKSUM_REC_PKG AS
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
                     X_EFFECTIVE_DATE RNT_TENANCY_AGREEMENT.EFFECTIVE_DATE%TYPE,
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
                     X_EFFECTIVE_DATE RNT_TENANCY_AGREEMENT.EFFECTIVE_DATE%TYPE,
                     X_DEPOSIT RNT_TENANCY_AGREEMENT.DEPOSIT%TYPE,
                     X_LAST_MONTH RNT_TENANCY_AGREEMENT.LAST_MONTH%TYPE,
                     X_DISCOUNT_AMOUNT RNT_TENANCY_AGREEMENT.DISCOUNT_AMOUNT%TYPE,
                     X_DISCOUNT_TYPE RNT_TENANCY_AGREEMENT.DISCOUNT_TYPE%TYPE,
                     X_DISCOUNT_PERIOD RNT_TENANCY_AGREEMENT.DISCOUNT_PERIOD%TYPE
                     ) return RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE;

END RNT_TENANCY_AGREEMENT_PKG;
/

SHOW ERRORS;


--
-- RNT_SYS_CHECKSUM_REC_PKG  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY RNT_SYS_CHECKSUM_REC_PKG AS
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
           EFFECTIVE_DATE, DEPOSIT, LAST_MONTH, 
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
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.EFFECTIVE_DATE);
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
                      X_AGREEMENT_DATE RNT_TENANCY_AGREEMENT.AGREEMENT_DATE%TYPE
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
                     and AGREEMENT_DATE = X_AGREEMENT_DATE
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
               EFFECTIVE_DATE, DEPOSIT, LAST_MONTH, 
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
                     X_EFFECTIVE_DATE RNT_TENANCY_AGREEMENT.EFFECTIVE_DATE%TYPE,
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

   if not check_unique(X_AGREEMENT_ID, X_UNIT_ID, X_AGREEMENT_DATE) then
        RAISE_APPLICATION_ERROR(-20006, 'Address of property must be unique');                      
   end if;   
   
   update RNT_TENANCY_AGREEMENT
   set  AGREEMENT_ID      = X_AGREEMENT_ID,
        UNIT_ID           = X_UNIT_ID,
        AGREEMENT_DATE    = X_AGREEMENT_DATE,
        TERM              = X_TERM,
        AMOUNT            = X_AMOUNT,
        AMOUNT_PERIOD     = X_AMOUNT_PERIOD,
        EFFECTIVE_DATE    = X_EFFECTIVE_DATE,
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
                     X_EFFECTIVE_DATE RNT_TENANCY_AGREEMENT.EFFECTIVE_DATE%TYPE,
                     X_DEPOSIT RNT_TENANCY_AGREEMENT.DEPOSIT%TYPE,
                     X_LAST_MONTH RNT_TENANCY_AGREEMENT.LAST_MONTH%TYPE,
                     X_DISCOUNT_AMOUNT RNT_TENANCY_AGREEMENT.DISCOUNT_AMOUNT%TYPE,
                     X_DISCOUNT_TYPE RNT_TENANCY_AGREEMENT.DISCOUNT_TYPE%TYPE,
                     X_DISCOUNT_PERIOD RNT_TENANCY_AGREEMENT.DISCOUNT_PERIOD%TYPE
                     ) return RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE
is
  x RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE;
begin
    insert into RNT_TENANCY_AGREEMENT (
       AGREEMENT_ID, 
       UNIT_ID, 
       AGREEMENT_DATE, 
       TERM, 
       AMOUNT, 
       AMOUNT_PERIOD, 
       EFFECTIVE_DATE, 
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
       X_EFFECTIVE_DATE, 
       X_DEPOSIT, 
       X_LAST_MONTH, 
       X_DISCOUNT_AMOUNT, 
       X_DISCOUNT_TYPE, 
       X_DISCOUNT_PERIOD)
    returning AGREEMENT_ID into x;
    return x;    
end;                     
    
                     
END RNT_TENANCY_AGREEMENT_PKG;
/

SHOW ERRORS;


--
-- RNT_LOANS_PKG  (Package) 
--
CREATE OR REPLACE PACKAGE RNT_LOANS_PKG AS
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
END RNT_PROPERTIES_PKG;
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
END RNT_PROPERTY_UNITS_PKG;
/

SHOW ERRORS;


--
-- RNT_LOANS_PKG  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY RNT_LOANS_PKG AS
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

END RNT_LOANS_PKG;
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
begin

   if not check_unique(NULL,X_ADDRESS1, X_ADDRESS2, 
                      X_CITY, X_STATE, X_ZIPCODE) then
        RAISE_APPLICATION_ERROR(-20006, 'Address of property must be unique');                      
   end if;                       

  insert into RNT_PROPERTIES (
           PROPERTY_ID, BUSINESS_ID, UNITS, 
           ADDRESS1, ADDRESS2, 
           CITY, STATE, ZIPCODE, 
           DATE_PURCHASED, PURCHASE_PRICE, LAND_VALUE, 
           DEPRECIATION_TERM, YEAR_BUILT, BUILDING_SIZE, 
           LOT_SIZE, DATE_SOLD, SALE_AMOUNT, 
           NOTE_YN) 
  values (RNT_PROPERTIES_SEQ.NEXTVAL, X_BUSINESS_ID, X_UNITS, 
   X_ADDRESS1, X_ADDRESS2, 
   X_CITY, X_STATE, X_ZIPCODE, 
   X_DATE_PURCHASED, X_PURCHASE_PRICE, X_LAND_VALUE, 
   X_DEPRECIATION_TERM, X_YEAR_BUILT, X_BUILDING_SIZE, 
   X_LOT_SIZE, X_DATE_SOLD, X_SALE_AMOUNT, 
   X_NOTE_YN)
  returning PROPERTY_ID into x;
   
  return x;
end;

END RNT_PROPERTIES_PKG;
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
   
   if not check_unique(X_UNIT_ID, X_PROPERTY_ID, X_UNIT_NAME) then
      RAISE_APPLICATION_ERROR(-20005, 'Unit name must be unique for property.');                 
   end if;                       
      
   update RNT_PROPERTY_UNITS
   set PROPERTY_ID = X_PROPERTY_ID,
       UNIT_NAME   = X_UNIT_NAME,
       UNIT_SIZE   = X_UNIT_SIZE,
       BEDROOMS    = X_BEDROOMS,
       BATHROOMS   = X_BATHROOMS
   where  UNIT_ID  = X_UNIT_ID;
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
   
   insert into RNT_PROPERTY_UNITS (
            UNIT_ID, PROPERTY_ID, UNIT_NAME, 
            UNIT_SIZE, BEDROOMS, BATHROOMS) 
   values (RNT_PROPERTY_UNITS_SEQ.NEXTVAL, X_PROPERTY_ID, X_UNIT_NAME, 
          X_UNIT_SIZE, X_BEDROOMS, X_BATHROOMS)
   returning UNIT_ID into x;
   return x;
end;                    

END RNT_PROPERTY_UNITS_PKG;
/

SHOW ERRORS;


