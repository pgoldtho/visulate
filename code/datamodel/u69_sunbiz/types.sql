create or replace type pr_corp_loc_type as object 
( corp_number   varchar2(12)
, corp_name     varchar2(192)
, loc_type      varchar2(4)
, loc_id        number
, prop_id       number
, address1      varchar2(42)
, address2      varchar2(42)
, city          varchar2(28)
, state          varchar2(2)
, zipcode       number(5)
, lat           number
, lon           number
);
/
create or replace type pr_corp_loc_set as table of pr_corp_loc_type; 
/
