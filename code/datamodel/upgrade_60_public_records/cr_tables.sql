create table pr_sources
( source_id          number        not null
, source_name        varchar2(64)  not null
, source_type        varchar2(16)
, base_url           varchar2(256)
, photo_url          varchar2(256)
, property_url       varchar2(256)
, platbook_url       varchar2(256)
, tax_url            varchar2(256)
, pk_column_name     varchar2(30)
, constraint pr_sources_pk primary key (source_id));

create unique index pr_sources_u1 on pr_sources(source_name);
create index pr_properties_n1 on pr_properties(source_pk);

comment on table pr_sources is 'External system that was used to source the data';
comment on column pr_sources.source_id      is 'System generated key';
comment on column pr_sources.source_name    is 'The name of the external system';
comment on column pr_sources.base_url       is 'URL for the home page of the system.  used to generate links';
comment on column pr_sources.pk_column_name is 'The name of the primary key column in the property table of the external system.';

create table pr_properties
( prop_id            number        not null
, source_id          number        not null
, source_pk          varchar2(32)  
, address1           varchar2(60)  not null
, address2           varchar2(60) 
, city               varchar2(60)  not null
, state              varchar2(2)   not null
, zipcode            varchar2(7)   not null
, acreage            number(4)
, sq_ft              number(8)
, constraint pr_properties_pk primary key (prop_id)
, constraint pr_properties_fk1 foreign key (source_id) references pr_sources(source_id)
);


create unique index pr_properties_u1 on pr_properties(address1, address2, zipcode);


comment on table pr_properties is 'Properties identified from public records';

comment on column pr_properties.prop_id   is 'System generated unique key';
comment on column pr_properties.source_id is 'External system that was used to source the data';
comment on column pr_properties.source_pk is 'Primary key reference for the property in the external system';
comment on column pr_properties.address1  is 'Property Address';
comment on column pr_properties.address2  is 'Property Address';
comment on column pr_properties.city      is 'Property Address';
comment on column pr_properties.state     is 'Property Address';
comment on column pr_properties.zipcode   is 'Property Address';
comment on column pr_properties.acreage   is 'Lot size';
comment on column pr_properties.sq_ft     is 'Total building size';


create table pr_property_links
( prop_id          number        not null
, url              varchar2(256) not null
, title            varchar2(32)
, constraint pr_property_links_pk primary key (prop_id, url)
, constraint pr_property_links_fk1 foreign key (prop_id) references pr_properties(prop_id));


create table pr_deed_codes
( deed_code     varchar2(16)  not null
, description   varchar2(64)  not null
, definition    varchar2(4000)
, constraint pr_deed_codes_pk primary key (deed_code));

create table pr_owners
( owner_id       number        not null
, owner_name     varchar2(64)  not null
, owner_type     varchar2(8)
, constraint pr_owners_pk primary key (owner_id));

create index pr_owners_n1 on pr_owners(owner_name);


create table pr_property_owners
( owner_id      number not null
, prop_id       number not null
, mailing_id    number
, constraint pr_property_owners_pk primary key (owner_id, prop_id)
, constraint pr_property_owners_fk1 foreign key (owner_id) references pr_owners(owner_id)
, constraint pr_property_owners_fk2 foreign key (prop_id) references pr_properties(prop_id)
, constraint pr_property_owners_fk3 foreign key (mailing_id) references pr_properties(prop_id));


create index pr_property_owners_n1 on pr_property_owners(prop_id);
create index pr_property_owners_n2 on pr_property_owners(mailing_id);


create table pr_property_sales
( prop_id          number        not null
, new_owner_id     number        not null
, sale_date        date          not null
, deed_code        varchar2(16)
, price            number
, old_owner_id     number
, plat_book        varchar2(8)
, plat_page        varchar2(8)
, constraint pr_property_sales_pk primary key (prop_id, new_owner_id)
, constraint pr_property_sales_fk1 foreign key (new_owner_id) references pr_owners (owner_id)
, constraint pr_property_sales_fk2 foreign key (old_owner_id) references pr_owners (owner_id)
, constraint pr_property_sales_fk3 foreign key (prop_id) references pr_properties (prop_id)
, constraint pr_property_sales_fk4 foreign key (deed_code) references pr_deed_codes (deed_code));

create index pr_property_sales_n1 on pr_property_sales (new_owner_id);
create index pr_property_sales_n2 on pr_property_sales (old_owner_id);
create index pr_property_sales_n3 on pr_property_sales (deed_code);


create table pr_taxes
( prop_id       number        not null
, tax_year      number(4)     not null
, tax_value     number        not null
, tax_amount    number        not null
, constraint pr_taxes_pk primary key (prop_id, tax_year)
, constraint pr_taxes_fk1 foreign key (prop_id) references pr_properties (prop_id));


create table pr_usage_codes
( ucode         number         not null
, description   varchar2(128)  not null
, parent_ucode  number       
, constraint pr_usage_codes_pk primary key (ucode)
, constraint pr_usage_codes_fk1 foreign key (parent_ucode) references pr_usage_codes(ucode));

create index pr_property_codes_u1 on pr_usage_codes (parent_ucode);

create table pr_property_usage
( ucode        number  not null
, prop_id      number  not null
, constraint pr_property_usage_pk primary key (ucode, prop_id)
, constraint pr_property_usage_fk1 foreign key (ucode) references pr_usage_codes (ucode)
, constraint pr_property_usage_fk2 foreign key (prop_id) references pr_properties (prop_id));

create index pr_property_usage_n1 on pr_property_usage (prop_id);

create table pr_buildings
( building_id       number       not null
, prop_id           number       not null
, building_name     varchar2(64) not null
, year_built        number(4)
, sq_ft             number(8)
, constraint pr_buildings_pk primary key (building_id)
, constraint pr_buildings_fk1 foreign key (prop_id) references pr_properties (prop_id));

create unique index pr_buildings_u1 on pr_buildings(prop_id, building_name);



create table pr_building_usage
( ucode            number  not null
, building_id      number  not null
, constraint pr_building_usage_pk primary key (ucode, building_id)
, constraint pr_building_usage_fk1 foreign key (ucode) references pr_usage_codes (ucode)
, constraint pr_building_usage_fk2 foreign key (building_id) references pr_buildings (building_id));

create index pr_building_usage_n1 on pr_building_usage (building_id);



create table pr_feature_codes
( fcode         number         not null
, description   varchar2(128)  not null
, parent_fcode  number       
, constraint pr_feature_codes_pk primary key (fcode)
, constraint pr_feature_codes_fk1 foreign key (parent_fcode) references pr_feature_codes(fcode));

create index pr_feature_codes_n1 on pr_feature_codes (parent_fcode);



create table pr_building_features
( fcode            number  not null
, building_id      number  not null
, constraint pr_building_features_pk primary key (fcode, building_id)
, constraint pr_building_features_fk1 foreign key (fcode) references pr_feature_codes (fcode)
, constraint pr_building_features_fk2 foreign key (building_id) references pr_buildings (building_id));

create index pr_building_features_n1 on pr_building_features (building_id);


create sequence  PR_SOURCES_SEQ;
create sequence  PR_PROPERTIES_SEQ;
create sequence  PR_OWNERS_SEQ;
create sequence  PR_BUILDINGS_SEQ;