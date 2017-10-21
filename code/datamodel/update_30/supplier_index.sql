alter table rnt_suppliers
drop constraint RNT_CONTRACTORS_UK1;

drop index  RNT_CONTRACTORS_UK1;

alter table rnt_suppliers
add constraint RNT_CONTRACTORS_UK1
unique (NAME, BUSINESS_ID);