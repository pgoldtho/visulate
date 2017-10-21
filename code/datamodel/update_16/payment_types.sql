alter table RNT_PAYMENT_TYPES ADD PAYABLE_YN varchar2(1);

update RNT_PAYMENT_TYPES 
set PAYABLE_YN = 'N';   

alter table RNT_PAYMENT_TYPES MODIFY PAYABLE_YN varchar2(1) NOT NULL;

alter table RNT_PAYMENT_TYPES ADD RECEIVABLE_YN varchar2(1);

update RNT_PAYMENT_TYPES 
set RECEIVABLE_YN = 'N';   

alter table RNT_PAYMENT_TYPES MODIFY RECEIVABLE_YN varchar2(1) NOT NULL;

alter table RNT_PAYMENT_TYPES ADD SERVICE_LIFE number(3) NULL;
            
update RNT_PAYMENT_TYPES
set PAYABLE_YN = 'Y' 
where PAYMENT_TYPE_ID between 1 and 6;

update RNT_PAYMENT_TYPES
set RECEIVABLE_YN = 'Y' 
where PAYMENT_TYPE_ID in (11, 12);

commit;





