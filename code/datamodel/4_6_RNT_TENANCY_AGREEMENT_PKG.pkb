CREATE OR REPLACE PACKAGE BODY RNTMGR.RNT_TENANCY_AGREEMENT_PKG AS
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

