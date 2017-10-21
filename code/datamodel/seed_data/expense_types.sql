update rnt_payment_types set depreciation_term = 0;
update rnt_payment_types set service_life = 0;

update rnt_payment_types 
set payment_type_name = 'Property Tax' 
where payment_type_id = 2;


update rnt_payment_types 
set payment_type_name = 'Maintenance' 
where payment_type_id = 4;

update rnt_payment_types 
set payment_type_name = 'Repairs' 
,   service_life = 3
where payment_type_id = 5;

update rnt_payment_types 
set payment_type_name = 'Capital Improvements' 
,   service_life = 7
where payment_type_id = 6;

update rnt_payment_types 
set payment_type_name = 'Discounted Rent' 
where payment_type_id = 8;

update rnt_payment_types 
set payment_type_name = 'Other Income' 
where payment_type_id = 11;

update rnt_payment_types 
set payable_yn = 'Y'
where payment_type_id = 12;

insert into RNT_PAYMENT_TYPES
( PAYMENT_TYPE_ID
, PAYMENT_TYPE_NAME
, DEPRECIATION_TERM
, DESCRIPTION
, PAYABLE_YN
, RECEIVABLE_YN
, SERVICE_LIFE)
values
( RNT_PAYMENT_TYPES_SEQ.nextval
, 'Sales Tax'
, 0
, 'Sales tax collected for goods or services sold'
, 'Y'
, 'Y'
, 0);

