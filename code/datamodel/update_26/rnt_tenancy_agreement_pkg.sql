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
                     X_END_DATE RNT_TENANCY_AGREEMENT.END_DATE%TYPE,
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
                     X_DISCOUNT_PERIOD RNT_TENANCY_AGREEMENT.DISCOUNT_PERIOD%TYPE,
                     X_END_DATE RNT_TENANCY_AGREEMENT.END_DATE%TYPE
                     ) return RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE;

procedure delete_row(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE);

function get_business_id(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE) 
   return RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE;

function get_property_id(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE)
   return RNT_PROPERTIES.PROPERTY_ID%TYPE;
/*Agreeemnt validate programs:
1.  The agreement does not have a primary tenant
2.  The agreement has a primary tenant but the agreement start date is null.
3.  The agreement has a primary tenant but the agreement start date is in the
future.
4.  The agreement dates overlap with another agreement.
5.  The agreement end date is less than 60 days in the future
6.  The agreement end date is less than 30 days in the future
7.  The agreement has expired
8.  The agreement end date is earlier than the agreement start date.
9.  A value has been entered in one of the late fee fields but one of the other fields is null.
10. Section 8 office has been selected by tenant pays is null.
*/   
procedure validate_primary_tenants(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE);    
procedure validate_start_date_is_null(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE);
procedure validate_start_date_in_future(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE);
procedure validate_overlap_date(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE);
procedure validate_end_date_less30days(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE);
procedure validate_end_date_less60days(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE);
procedure validate_has_expired(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE);
procedure validate_end_date_less_start(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE); 
procedure validate_tenant_section8(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE);
procedure validate_late_fee(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE);
END RNT_TENANCY_AGREEMENT_PKG;
/


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
           DISCOUNT_AMOUNT, DISCOUNT_TYPE, DISCOUNT_PERIOD, END_DATE
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
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.END_DATE);         
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
                     X_END_DATE RNT_TENANCY_AGREEMENT.END_DATE%TYPE,
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
        RAISE_APPLICATION_ERROR(-20460, 'Date available for unit must be unique');                      
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
        DISCOUNT_PERIOD   = X_DISCOUNT_PERIOD,
        END_DATE          = X_END_DATE
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
                     X_DISCOUNT_PERIOD RNT_TENANCY_AGREEMENT.DISCOUNT_PERIOD%TYPE,
                     X_END_DATE RNT_TENANCY_AGREEMENT.END_DATE%TYPE
                     ) return RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE
is
  x RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE;
begin

    if not check_unique(NULL, X_UNIT_ID, X_DATE_AVAILABLE) then
        RAISE_APPLICATION_ERROR(-20460, 'Date available for unit must be unique');                      
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
       DISCOUNT_PERIOD,
       END_DATE) 
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
       X_DISCOUNT_PERIOD,
       X_END_DATE)
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
     RAISE_APPLICATION_ERROR(-20461, 'Cannot delete record. For agreement exists accounts receivable.');
  end if;
      
  delete from RNT_AGREEMENT_ACTIONS
  where AGREEMENT_ID = X_AGREEMENT_ID;
  
  delete from RNT_TENANCY_AGREEMENT
  where AGREEMENT_ID = X_AGREEMENT_ID;
end;

function get_business_id(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE) 
  return RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE
is
  x RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE;
begin
  select p.BUSINESS_ID
  into x
  from RNT_TENANCY_AGREEMENT a,
       RNT_PROPERTY_UNITS u,
       RNT_PROPERTIES p
  where u.UNIT_ID = a.UNIT_ID
    and p.PROPERTY_ID = u.PROPERTY_ID     
    and a.AGREEMENT_ID = X_AGREEMENT_ID;
  return x;  
end;  


function get_property_id(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE) 
  return RNT_PROPERTIES.PROPERTY_ID%TYPE
is
  x RNT_PROPERTIES.PROPERTY_ID%TYPE;
begin
  select u.PROPERTY_ID
  into x
  from RNT_TENANCY_AGREEMENT a,
       RNT_PROPERTY_UNITS u
  where u.UNIT_ID = a.UNIT_ID
    and a.AGREEMENT_ID = X_AGREEMENT_ID;
  return x;  
end;  

 
function is_exists_current_tenant(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE) return boolean
is
  x NUMBER;
begin
   select 1
   into x
   from DUAL
   where exists (select 1
                 from RNT_TENANT
                 where AGREEMENT_ID = X_AGREEMENT_ID
                   and STATUS = 'CURRENT');
   return TRUE;                   
exception
   when NO_DATA_FOUND then return FALSE;  
   when TOO_MANY_ROWS then return TRUE;
end;    

procedure validate_primary_tenants(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE)
is
  x NUMBER;
begin
  if not is_exists_current_tenant(X_AGREEMENT_ID) then 
     RAISE_APPLICATION_ERROR(-20462, 'The agreement does not have a primary tenant.');
   end if;    
end;    
 
procedure validate_start_date_is_null(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE)
is
  x_agr_date DATE;
begin
   if is_exists_current_tenant(X_AGREEMENT_ID) then
     select AGREEMENT_DATE
     into x_agr_date
     from RNT_TENANCY_AGREEMENT
     where AGREEMENT_ID = X_AGREEMENT_ID;
     if x_agr_date is null then
         RAISE_APPLICATION_ERROR(-20463, 'The agreement has a primary tenant but the agreement start date is null.');     
     end if;  
   end if;
end;     

procedure validate_start_date_in_future(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE)
is
  x_agr_date DATE;
begin
   if is_exists_current_tenant(X_AGREEMENT_ID) then
     select AGREEMENT_DATE
     into x_agr_date
     from RNT_TENANCY_AGREEMENT
     where AGREEMENT_ID = X_AGREEMENT_ID;
     if x_agr_date > SYSDATE then
         RAISE_APPLICATION_ERROR(-20464, ' The agreement has a primary tenant but the agreement start date is in the future.');     
     end if;  
   end if;
end;     

procedure validate_overlap_date(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE)
is
  x NUMBER;
begin
  select 1 
  into x
  from DUAL
  where exists (select 1
                from RNT_TENANCY_AGREEMENT ta,
                     RNT_TENANCY_AGREEMENT other
                where ta.AGREEMENT_ID = X_AGREEMENT_ID
                  and other.UNIT_ID = ta.UNIT_ID
                  and not (ta.AGREEMENT_DATE > other.END_DATE or ta.END_DATE < other.AGREEMENT_DATE)
                  and other.AGREEMENT_ID != ta.AGREEMENT_ID
                );
   RAISE_APPLICATION_ERROR(-20465, 'The agreement dates overlap with another agreement.');
exception   
  when NO_DATA_FOUND then NULL;  
end;

procedure validate_end_date_less30days(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE)
is
  x_end_date DATE;
begin
     select END_DATE
     into x_end_date
     from RNT_TENANCY_AGREEMENT
     where AGREEMENT_ID = X_AGREEMENT_ID;
     if x_end_date < trunc(SYSDATE) + 30 then
         RAISE_APPLICATION_ERROR(-20466, 'The agreement end date is less than 30 days in the future.');     
     end if;  
end;

procedure validate_end_date_less60days(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE)
is
  x_end_date DATE;
begin
     select END_DATE
     into x_end_date
     from RNT_TENANCY_AGREEMENT
     where AGREEMENT_ID = X_AGREEMENT_ID;
     if x_end_date < trunc(SYSDATE) + 60 then
         RAISE_APPLICATION_ERROR(-20467, 'The agreement end date is less than 60 days in the future.');     
     end if;  
end;

procedure validate_has_expired(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE)
is
  x_end_date DATE;
begin
     select END_DATE
     into x_end_date
     from RNT_TENANCY_AGREEMENT
     where AGREEMENT_ID = X_AGREEMENT_ID;
     if x_end_date < SYSDATE then
         RAISE_APPLICATION_ERROR(-20468, 'The agreement has expired.');     
     end if;  
end;
 
procedure validate_end_date_less_start(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE)
is
  x_start_date DATE;
  x_end_date DATE;
begin
     select AGREEMENT_DATE, END_DATE
     into x_start_date, x_end_date
     from RNT_TENANCY_AGREEMENT
     where AGREEMENT_ID = X_AGREEMENT_ID;
     if x_end_date < x_start_date then
         RAISE_APPLICATION_ERROR(-20469, 'The agreement end date is earlier than the agreement start date.');     
     end if;  
end;          


procedure validate_tenant_section8(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE)
is
  x NUMBER;
begin
  select 1 
  into x
  from DUAL
  where exists (
                select 1
                from RNT_TENANT
                where AGREEMENT_ID = X_AGREEMENT_ID
                  and SECTION8_ID is not null
                  and SECTION8_TENANT_PAYS is null
                );
   RAISE_APPLICATION_ERROR(-20470, 'Section 8 office has been selected by tenant pays is null.');
exception   
  when NO_DATA_FOUND then NULL;  
end;


procedure validate_late_fee(X_AGREEMENT_ID RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE)
is
  x_amount NUMBER;
  x_type VARCHAR2(30);
  x_period NUMBER;
begin
     select DISCOUNT_AMOUNT, DISCOUNT_TYPE, DISCOUNT_PERIOD
     into x_amount, x_type, x_period
     from RNT_TENANCY_AGREEMENT
     where AGREEMENT_ID = X_AGREEMENT_ID;
     if (x_amount is not null or x_type is not null or x_period is not null) and (x_amount is null or x_type is null or x_period is null) then
         RAISE_APPLICATION_ERROR(-20471, 'A value has been entered in one of the late fee fields but one of the other fields is null.');     
     end if;  
end;          
    
END RNT_TENANCY_AGREEMENT_PKG;
/


