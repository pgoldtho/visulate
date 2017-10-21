create table mls_price_ranges
( zcode         varchar2(64) not null
, listing_type  varchar2(16) not null
, query_type    varchar2(32) not null
, range_date    date         not null
, source_id     number       not null
, county        varchar2(25) not null
, state         varchar2(2)  not null
, current_yn    varchar2(1)  not null
, name          varchar2(64) not null
, a_max         number       not null
, a_median      number       not null
, a_min         number       not null
, b_median      number       not null
, c_max         number       not null
, c_median      number       not null
, c_min         number       not null
, total         number       not null
, constraint mls_price_ranges_pk primary key
  (zcode, listing_type, query_type, range_date, source_id, county, state)
, constraint mls_price_ranges_r1 foreign key (source_id)
  references pr_sources(source_id));