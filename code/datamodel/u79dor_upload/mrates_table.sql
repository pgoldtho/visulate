create table pr_millage_rates
( id         number not null
, year       number not null
, county     varchar2(64)
, millage    number not null
, rent_rate  number 
, constraint pr_millage_rates_pk primary key (id, year))
tablespace pr_loader;