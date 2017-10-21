create table brvd_parcel_lookups
( tax_id      varchar2(32)
, parcel_id   varchar2(32));

create unique index  brvd_parcel_lookups_pk on  brvd_parcel_lookups(tax_id);
