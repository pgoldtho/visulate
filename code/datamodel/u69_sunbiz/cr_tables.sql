create sequence pr_locations_seq;
create sequence pr_principals_seq;


create table pr_corporations
( corp_number        varchar2(12)  not null
, name               varchar2(192) not null
, status             varchar2(1)   not null
, filing_type        varchar2(15)
, filing_date        date
, fei_number         varchar2(14)
, constraint pr_corporations_pk primary key (corp_number));
create index pr_corporations_n1 on pr_corporations (name);


create table pr_locations
( loc_id             number       not null
, address1           varchar2(42) not null
, address2           varchar2(42)
, city               varchar2(28)
, state              varchar2(2)
, zip5               number(5)    
, zip4               number(4)
, country            varchar2(2)
, prop_id            number
, geo_location       SDO_GEOMETRY
, constraint pr_locations_pk primary key (loc_id)
, constraint pr_locations_u1 unique (address1, address2, zip5)
, constraint pr_locations_f1 foreign key (prop_id) 
  references pr_properties (prop_id));
  
  create index pr_locations_f1 on pr_locations(prop_id);

create table pr_principals
( pn_id             number       not null
, pn_type           varchar2(1)  not null
, pn_name           varchar2(42) not null
, constraint pr_principals_pk primary key (pn_id)
, constraint pr_principals_u1 unique (pn_type, pn_name));

create table pr_principal_locations
( loc_id          number not null
, pn_id           number not null
, constraint pr_principal_locations_pk primary key (loc_id, pn_id));

create index pr_principal_locations_f1 on pr_principal_locations(pn_id);


create table pr_corporate_locations
( loc_id           number       not null
, corp_number      varchar2(12) not null
, loc_type         varchar2(4)  not null
, constraint pr_corporate_locations_pk primary key (loc_id, corp_number, loc_type));

create index pr_corporate_locations_f1 on pr_corporate_locations(corp_number);

create table pr_corporate_positions
( corp_number      varchar2(12) not null
, pn_id            number       not null
, title_code       varchar2(4)
, constraint pr_corporate_positions_pk primary key (corp_number, pn_id));
create index pr_corporate_positions_f1 on pr_corporate_positions(pn_id);

