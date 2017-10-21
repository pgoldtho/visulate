alter table rnt_properties drop constraint RNT_PROPERTIES_UK1;
drop index RNT_PROPERTIES_UK1;
alter table rnt_properties  
add constraint RNT_PROPERTIES_UK1
unique(BUSINESS_ID, ADDRESS1, ZIPCODE);

alter table rnt_properties modify date_purchased null;
alter table rnt_properties modify purchase_price  null;
alter table rnt_properties modify land_value null;

alter table rnt_properties
add ( name   varchar2(64)
    , status varchar2(16));

alter table rnt_expense_items modify supplier_id null;

alter table rnt_expense_items 
add (accepted_yn varchar2(1) default 'Y' not null );

comment on column rnt_expense_items.accepted_yn is
'Should this expense item be included in cost estimates?';