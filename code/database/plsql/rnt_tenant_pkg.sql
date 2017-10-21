CREATE OR REPLACE PACKAGE        RNT_TENANT_PKG AS
/******************************************************************************
   NAME:       RNT_TENANT_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        29.04.2007             1. Created this package.
******************************************************************************/

function get_checksum(X_TENANT_ID RNT_TENANT.TENANT_ID%TYPE) return VARCHAR2;

procedure lock_row(X_TENANT_ID RNT_TENANT.TENANT_ID%TYPE);

procedure short_update_row(X_TENANT_ID RNT_TENANT.TENANT_ID%TYPE,
                     X_AGREEMENT_ID RNT_TENANT.AGREEMENT_ID%TYPE,
                     X_STATUS RNT_TENANT.STATUS%TYPE,
                     X_DEPOSIT_BALANCE RNT_TENANT.DEPOSIT_BALANCE%TYPE,
                     X_LAST_MONTH_BALANCE RNT_TENANT.LAST_MONTH_BALANCE%TYPE,
                     X_PEOPLE_ID RNT_TENANT.PEOPLE_ID%TYPE,
                     X_SECTION8_VOUCHER_AMOUNT RNT_TENANT.SECTION8_VOUCHER_AMOUNT%TYPE,
                     X_SECTION8_TENANT_PAYS RNT_TENANT.SECTION8_TENANT_PAYS%TYPE,
                     X_SECTION8_ID RNT_TENANT.SECTION8_ID%TYPE,
                     X_CHECKSUM VARCHAR2
                     );

procedure update_row(X_TENANT_ID RNT_TENANT.TENANT_ID%TYPE,
                     X_AGREEMENT_ID RNT_TENANT.AGREEMENT_ID%TYPE,
                     X_STATUS RNT_TENANT.STATUS%TYPE,
                     X_DEPOSIT_BALANCE RNT_TENANT.DEPOSIT_BALANCE%TYPE,
                     X_LAST_MONTH_BALANCE RNT_TENANT.LAST_MONTH_BALANCE%TYPE,
                     X_PEOPLE_ID RNT_TENANT.PEOPLE_ID%TYPE,
                     X_SECTION8_VOUCHER_AMOUNT RNT_TENANT.SECTION8_VOUCHER_AMOUNT%TYPE,
                     X_SECTION8_TENANT_PAYS RNT_TENANT.SECTION8_TENANT_PAYS%TYPE,
                     X_SECTION8_ID RNT_TENANT.SECTION8_ID%TYPE,
                     X_CHECKSUM VARCHAR2,
                     X_TENANT_NOTE RNT_TENANT.TENANT_NOTE%TYPE
                     );
                     
function insert_row(X_AGREEMENT_ID RNT_TENANT.AGREEMENT_ID%TYPE,
                    X_STATUS RNT_TENANT.STATUS%TYPE,
                    X_DEPOSIT_BALANCE RNT_TENANT.DEPOSIT_BALANCE%TYPE,
                    X_LAST_MONTH_BALANCE RNT_TENANT.LAST_MONTH_BALANCE%TYPE,
                    X_PEOPLE_ID RNT_TENANT.PEOPLE_ID%TYPE,
                    X_SECTION8_VOUCHER_AMOUNT RNT_TENANT.SECTION8_VOUCHER_AMOUNT%TYPE,
                    X_SECTION8_TENANT_PAYS RNT_TENANT.SECTION8_TENANT_PAYS%TYPE,
                    X_SECTION8_ID RNT_TENANT.SECTION8_ID%TYPE
                   ) return RNT_TENANT.TENANT_ID%TYPE;

procedure delete_row(X_TENANT_ID RNT_TENANT.TENANT_ID%TYPE);

END RNT_TENANT_PKG;
/


CREATE OR REPLACE PACKAGE BODY        RNT_TENANT_PKG AS
/******************************************************************************
   NAME:       RNT_TENANT_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        29.04.2007             1. Created this package body.
******************************************************************************/

function get_checksum(X_TENANT_ID RNT_TENANT.TENANT_ID%TYPE) return VARCHAR2
is
begin
for x in (select 
           TENANT_ID, AGREEMENT_ID, STATUS, 
           DEPOSIT_BALANCE, LAST_MONTH_BALANCE, PEOPLE_ID, 
           SECTION8_VOUCHER_AMOUNT, SECTION8_TENANT_PAYS, SECTION8_ID,
           TENANT_NOTE
         from RNT_TENANT
         where TENANT_ID = X_TENANT_ID         
         ) loop
         RNT_SYS_CHECKSUM_REC_PKG.INIT;
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.TENANT_ID);         
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.AGREEMENT_ID);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.STATUS); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.DEPOSIT_BALANCE);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.LAST_MONTH_BALANCE);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.PEOPLE_ID);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.SECTION8_VOUCHER_AMOUNT);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.SECTION8_TENANT_PAYS);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.SECTION8_ID);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.TENANT_NOTE);
         return RNT_SYS_CHECKSUM_REC_PKG.GET_CHECKSUM;
   end loop;
   raise NO_DATA_FOUND;  
end;

procedure lock_row(X_TENANT_ID RNT_TENANT.TENANT_ID%TYPE)
is
cursor c is
   select *
   from RNT_TENANT              
   for update of TENANT_ID nowait; 
begin
  open c;
  close c;
exception
  when OTHERS then
    if SQLCODE = -54 then
      RAISE_APPLICATION_ERROR(-20001, 'Cannot changed record. Record is locked.');
    end if; 
end;

function check_unique(X_TENANT_ID RNT_TENANT.TENANT_ID%TYPE, 
                      X_AGREEMENT_ID RNT_TENANT.AGREEMENT_ID%TYPE,
                      X_PEOPLE_ID RNT_TENANT.PEOPLE_ID%TYPE
                      ) return boolean
is
  x NUMBER;
begin
   select 1 
   into x
   from DUAL
   where exists (
                   select 1
                   from RNT_TENANT
                   where PEOPLE_ID = X_PEOPLE_ID
                     and AGREEMENT_ID = X_AGREEMENT_ID
                     and (TENANT_ID != X_TENANT_ID or X_TENANT_ID is null)
                 );
  return false;
exception
  when NO_DATA_FOUND then
     return true;                        
end;        

function check_unique_current(X_TENANT_ID RNT_TENANT.TENANT_ID%TYPE,
                              X_AGREEMENT_ID RNT_TENANT.AGREEMENT_ID%TYPE,
                              X_STATUS RNT_TENANT.STATUS%TYPE) return boolean
is
  x NUMBER;
begin
   if X_STATUS != 'CURRENT' then
     return TRUE; 
   end if;
   
   select 1 
   into x
   from DUAL
   where exists (
                   select 1
                   from RNT_TENANT
                   where AGREEMENT_ID = X_AGREEMENT_ID
                     and (TENANT_ID != X_TENANT_ID or X_TENANT_ID is null)
                     and STATUS = 'CURRENT'
                 );
  return false;
exception
  when NO_DATA_FOUND then
     return true;                        
end;                              
                              

procedure short_update_row(X_TENANT_ID RNT_TENANT.TENANT_ID%TYPE,
                     X_AGREEMENT_ID RNT_TENANT.AGREEMENT_ID%TYPE,
                     X_STATUS RNT_TENANT.STATUS%TYPE,
                     X_DEPOSIT_BALANCE RNT_TENANT.DEPOSIT_BALANCE%TYPE,
                     X_LAST_MONTH_BALANCE RNT_TENANT.LAST_MONTH_BALANCE%TYPE,
                     X_PEOPLE_ID RNT_TENANT.PEOPLE_ID%TYPE,
                     X_SECTION8_VOUCHER_AMOUNT RNT_TENANT.SECTION8_VOUCHER_AMOUNT%TYPE,
                     X_SECTION8_TENANT_PAYS RNT_TENANT.SECTION8_TENANT_PAYS%TYPE,
                     X_SECTION8_ID RNT_TENANT.SECTION8_ID%TYPE,
                     X_CHECKSUM VARCHAR2
                     )
is
l_checksum varchar2(32); 
begin
   
   lock_row(X_TENANT_ID);
   
   -- validate checksum   
   l_checksum := get_checksum(X_TENANT_ID);
   if X_CHECKSUM != l_checksum then
      RAISE_APPLICATION_ERROR(-20002, 'Record was changed another user.');
   end if;

   if not check_unique(X_TENANT_ID, X_AGREEMENT_ID, X_PEOPLE_ID) then
        RAISE_APPLICATION_ERROR(-20490, 'People for agreement must be unique');                      
   end if;   
   
   if not check_unique_current(X_TENANT_ID, X_AGREEMENT_ID, X_STATUS) then
        RAISE_APPLICATION_ERROR(-20491, 'Tenant with status "Current - Primary", must be one in agreement.');    
   end if; 
   
   update RNT_TENANT
   set 
        AGREEMENT_ID            = X_AGREEMENT_ID,
        STATUS                  = X_STATUS,
        DEPOSIT_BALANCE         = X_DEPOSIT_BALANCE,
        LAST_MONTH_BALANCE      = X_LAST_MONTH_BALANCE,
        PEOPLE_ID               = X_PEOPLE_ID,
        SECTION8_VOUCHER_AMOUNT = X_SECTION8_VOUCHER_AMOUNT,
        SECTION8_TENANT_PAYS    = X_SECTION8_TENANT_PAYS,
        SECTION8_ID             = X_SECTION8_ID
   where TENANT_ID = X_TENANT_ID;
end;  
       
function insert_row(X_AGREEMENT_ID RNT_TENANT.AGREEMENT_ID%TYPE,
                    X_STATUS RNT_TENANT.STATUS%TYPE,
                    X_DEPOSIT_BALANCE RNT_TENANT.DEPOSIT_BALANCE%TYPE,
                    X_LAST_MONTH_BALANCE RNT_TENANT.LAST_MONTH_BALANCE%TYPE,
                    X_PEOPLE_ID RNT_TENANT.PEOPLE_ID%TYPE,
                    X_SECTION8_VOUCHER_AMOUNT RNT_TENANT.SECTION8_VOUCHER_AMOUNT%TYPE,
                    X_SECTION8_TENANT_PAYS RNT_TENANT.SECTION8_TENANT_PAYS%TYPE,
                    X_SECTION8_ID RNT_TENANT.SECTION8_ID%TYPE
                   ) return RNT_TENANT.TENANT_ID%TYPE
is
x RNT_TENANT.TENANT_ID%TYPE;
begin

   if not check_unique(NULL, X_AGREEMENT_ID, X_PEOPLE_ID) then
        RAISE_APPLICATION_ERROR(-20490, 'People for agreement must be unique');                      
   end if;   

   if not check_unique_current(NULL, X_AGREEMENT_ID, X_STATUS) then
        RAISE_APPLICATION_ERROR(-20491, 'Tenant with status "Current - Primary", must be one in agreement.');                      
   end if;   
   
   insert into RNT_TENANT (
       TENANT_ID, AGREEMENT_ID, STATUS, 
       DEPOSIT_BALANCE, LAST_MONTH_BALANCE, PEOPLE_ID, 
       SECTION8_VOUCHER_AMOUNT, SECTION8_TENANT_PAYS, SECTION8_ID) 
   values (RNT_TENANT_SEQ.NEXTVAL, X_AGREEMENT_ID, X_STATUS, 
       X_DEPOSIT_BALANCE, X_LAST_MONTH_BALANCE, X_PEOPLE_ID, 
       X_SECTION8_VOUCHER_AMOUNT, X_SECTION8_TENANT_PAYS, X_SECTION8_ID
       )
   returning TENANT_ID into x;
   return x;  
end;                   

procedure update_row(X_TENANT_ID RNT_TENANT.TENANT_ID%TYPE,
                     X_AGREEMENT_ID RNT_TENANT.AGREEMENT_ID%TYPE,
                     X_STATUS RNT_TENANT.STATUS%TYPE,
                     X_DEPOSIT_BALANCE RNT_TENANT.DEPOSIT_BALANCE%TYPE,
                     X_LAST_MONTH_BALANCE RNT_TENANT.LAST_MONTH_BALANCE%TYPE,
                     X_PEOPLE_ID RNT_TENANT.PEOPLE_ID%TYPE,
                     X_SECTION8_VOUCHER_AMOUNT RNT_TENANT.SECTION8_VOUCHER_AMOUNT%TYPE,
                     X_SECTION8_TENANT_PAYS RNT_TENANT.SECTION8_TENANT_PAYS%TYPE,
                     X_SECTION8_ID RNT_TENANT.SECTION8_ID%TYPE,
                     X_CHECKSUM VARCHAR2,
                     X_TENANT_NOTE RNT_TENANT.TENANT_NOTE%TYPE
                     )
is
l_checksum varchar2(32); 
begin
   
   lock_row(X_TENANT_ID);
   
   -- validate checksum   
   l_checksum := get_checksum(X_TENANT_ID);
   if X_CHECKSUM != l_checksum then
      RAISE_APPLICATION_ERROR(-20002, 'Record was changed another user.');
   end if;

   if not check_unique(X_TENANT_ID, X_AGREEMENT_ID, X_PEOPLE_ID) then
        RAISE_APPLICATION_ERROR(-20490, 'People for agreement must be unique');                      
   end if;   

   if not check_unique_current(X_TENANT_ID, X_AGREEMENT_ID, X_STATUS) then
        RAISE_APPLICATION_ERROR(-20491, 'Tenant with status "Current - Primary", must be one in agreement.');    
   end if; 
   
   update RNT_TENANT
   set 
        AGREEMENT_ID            = X_AGREEMENT_ID,
        STATUS                  = X_STATUS,
        DEPOSIT_BALANCE         = X_DEPOSIT_BALANCE,
        LAST_MONTH_BALANCE      = X_LAST_MONTH_BALANCE,
        PEOPLE_ID               = X_PEOPLE_ID,
        SECTION8_VOUCHER_AMOUNT = X_SECTION8_VOUCHER_AMOUNT,
        SECTION8_TENANT_PAYS    = X_SECTION8_TENANT_PAYS,
        SECTION8_ID             = X_SECTION8_ID,
        TENANT_NOTE             = X_TENANT_NOTE
   where TENANT_ID = X_TENANT_ID;
end; 

procedure delete_row(X_TENANT_ID RNT_TENANT.TENANT_ID%TYPE)
is
begin
    delete from RNT_TENANT
    where TENANT_ID = X_TENANT_ID;
end;

END RNT_TENANT_PKG;
/


