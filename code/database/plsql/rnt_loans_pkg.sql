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
					 X_INTEREST_ONLY_YN   RNT_LOANS.INTEREST_ONLY_YN%TYPE,
                     X_BALLOON_DATE       RNT_LOANS.BALLOON_DATE%TYPE,
                     X_CLOSING_COSTS      RNT_LOANS.CLOSING_COSTS%TYPE,
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
					 X_INTEREST_ONLY_YN   RNT_LOANS.INTEREST_ONLY_YN%TYPE,
                     X_BALLOON_DATE       RNT_LOANS.BALLOON_DATE%TYPE,
                     X_CLOSING_COSTS      RNT_LOANS.CLOSING_COSTS%TYPE,
                     X_SETTLEMENT_DATE    RNT_LOANS.SETTLEMENT_DATE%TYPE
                    ) return RNT_LOANS.LOAN_ID%TYPE;

procedure delete_row(X_LOAN_ID       RNT_LOANS.LOAN_ID%TYPE);                     


function get_mortgage_payment( p_amount  in number
                             , p_rate    in number
                             , p_term    in number   := null
                             , p_type    in varchar2 := 'I')
      return number;
END RNT_LOANS_PKG;
/


CREATE OR REPLACE PACKAGE BODY        RNT_LOANS_PKG AS
/******************************************************************************
   NAME:       RNT_LOANS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        08.04.2007             1. Created this package body.
   1.1        04.18.2009             2. Added mortgage payment calculator
******************************************************************************/

function get_checksum(X_LOAN_ID RNT_LOANS.LOAN_ID%TYPE) return VARCHAR2
is
begin
   for x in (select 
                LOAN_ID, PROPERTY_ID, POSITION, 
                LOAN_DATE, LOAN_AMOUNT, TERM, 
                INTEREST_RATE, CREDIT_LINE_YN, ARM_YN, INTEREST_ONLY_YN,
                BALLOON_DATE, CLOSING_COSTS, SETTLEMENT_DATE
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
		 RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.INTEREST_ONLY_YN);
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.BALLOON_DATE); 
         RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.CLOSING_COSTS);
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
					 X_INTEREST_ONLY_YN   RNT_LOANS.INTEREST_ONLY_YN%TYPE,
                     X_BALLOON_DATE       RNT_LOANS.BALLOON_DATE%TYPE,
                     X_CLOSING_COSTS       RNT_LOANS.CLOSING_COSTS%TYPE,
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
        RAISE_APPLICATION_ERROR(-20180, 'Position in property must be unique.');                      
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
	   INTEREST_ONLY_YN   = X_INTEREST_ONLY_YN,
       BALLOON_DATE       = X_BALLOON_DATE,
       CLOSING_COSTS = X_CLOSING_COSTS,
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
					 X_INTEREST_ONLY_YN   RNT_LOANS.INTEREST_ONLY_YN%TYPE,
                     X_BALLOON_DATE       RNT_LOANS.BALLOON_DATE%TYPE,
                     X_CLOSING_COSTS       RNT_LOANS.CLOSING_COSTS%TYPE,
                     X_SETTLEMENT_DATE    RNT_LOANS.SETTLEMENT_DATE%TYPE
                    ) return RNT_LOANS.LOAN_ID%TYPE
is
  x NUMBER;
begin
   if not check_unique(NULL, X_PROPERTY_ID, X_POSITION) then
        RAISE_APPLICATION_ERROR(-20180, 'Position in property must be unique.');                      
   end if;
   
   insert into RNT_LOANS (
       LOAN_ID, PROPERTY_ID, POSITION, 
       LOAN_DATE, LOAN_AMOUNT, TERM, 
       INTEREST_RATE, CREDIT_LINE_YN, ARM_YN, INTEREST_ONLY_YN,
       BALLOON_DATE, CLOSING_COSTS, SETTLEMENT_DATE, balance_date, principal_balance) 
    values (RNT_LOANS_SEQ.NEXTVAL, X_PROPERTY_ID, X_POSITION, 
         X_LOAN_DATE, X_LOAN_AMOUNT, X_TERM, 
         X_INTEREST_RATE, X_CREDIT_LINE_YN, X_ARM_YN, X_INTEREST_ONLY_YN,
         X_BALLOON_DATE, X_CLOSING_COSTS, X_SETTLEMENT_DATE, 
		 add_months(X_LOAN_DATE, 1), X_LOAN_AMOUNT)
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
     RAISE_APPLICATION_ERROR(-20181, 'Cannot delete loan with accounts receivable records.');
  end if; 
  if is_exists_acc_payable(X_LOAN_ID) then
     RAISE_APPLICATION_ERROR(-20182, 'Cannot delete loan with accounts payable records.');
  end if;
    
  delete from RNT_LOANS
  where LOAN_ID = X_LOAN_ID;
end;


function get_mortgage_payment( p_amount  in number
                             , p_rate    in number
                             , p_term    in number   := null
                             , p_type    in varchar2 := 'I')
      return number is
  v_return               number;
  v_payment_periods      number;
  v_payment_rate         number;
begin
  if nvl(p_amount, 0) = 0 then
     v_return := 0;
  elsif nvl(p_term, 30) = 0 then
     v_return := p_amount;
  elsif p_rate = 0 then
    v_return := p_amount/(nvl(p_term, 30) * 12);
  elsif upper(p_type) = 'A' then
     v_payment_periods := p_term * 12;
     v_payment_rate    :=  p_rate / 1200;
     v_return := p_amount * v_payment_rate / (1 - power((1 + v_payment_rate), (v_payment_periods * -1)));
  else
     v_return := p_amount * p_rate / 1200;
  end if;
  return round(v_return, 2);
end get_mortgage_payment;

END RNT_LOANS_PKG;
/
show errors package rnt_loans_pkg
show errors package body rnt_loans_pkg

