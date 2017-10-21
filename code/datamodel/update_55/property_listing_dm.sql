create table rnt_cities
( city_id         number       not null
, name            varchar2(35) not null
, county          varchar2(25) not null
, state           varchar2(2)  not null
, constraint rnt_cites_pk primary key (city_id));

create unique index rnt_cities_u1 on rnt_cities
( name
, county
, state);

create index rnt_cities_n1 on rnt_cities(county);
create index rnt_cities_n2 on rnt_cities(state);

create sequence rnt_cities_seq;

create table rnt_zipcodes
( zipcode         number(5) not null
, constraint      rnt_zipcodes_pk primary key (zipcode));


create table rnt_city_zipcodes
( city_id         number       not null
, zipcode         number(5)    not null
, constraint      rnt_city_zipcodes_pk primary key (city_id, zipcode));

create index rnt_city_zipcodes_n1 on rnt_city_zipcodes (zipcode);

alter table rnt_properties add
( description    varchar2(4000)); 

alter table rnt_property_units add
( description    varchar2(4000)); 

alter table rnt_tenancy_agreement add
( ad_publish_yn       varchar2(1)  default 'N' not null
, ad_title            varchar2(80)
, ad_contact          varchar2(80)
, ad_email            varchar2(256)
, ad_phone            varchar2(16)
, constraint rnt_tenancy_agreement_chk1 check (ad_publish_yn in ('Y', 'N')));

comment on table rnt_cities is 
'Records list of cities, states and counties for use in listing searches. Mapped to rnt_zipcodes via rnt_city_zipcodes'; 

comment on column rnt_cities.city_id is 'System generated UID';
comment on column rnt_cities.state is '2 character state code.';
comment on column rnt_cities.name is 'City name e.g. MERRIT ISLAND';
comment on column rnt_cities.county is 'County in which the city is located';

comment on table rnt_city_zipcodes is
'Intersection entity between rnt_cities and rnt_zipcodes.  Used to connect County and state to zipcodes during property search queries.';

comment on column rnt_city_zipcodes.city_id is 'Foreign key to rnt_cities';
comment on column rnt_city_zipcodes.city_id is 'Foreign key to rnt_zipcodes';

comment on table rnt_zipcodes is 
'Records US Zipcodes.  Can be joined to rnt_properties via the zipcode column.  The zipcodes table only records US Zipcodes.  The Zipcode column in rnt_properties allows Canadian postal codes to be recorded.  The foreign key is not enforced with a RI constraint.';


Comment on column rnt_properties.description is 
'Records the property description displayed in rental property listings';

Comment on column rnt_property_units.description is 
'Records the unit description displayed in rental property listings';

comment on column rnt_tenancy_agreement.ad_publish_yn is
'Should this agreement be displayed as an advertisement on the Visulate website?';

comment on column rnt_tenancy_agreement.ad_title is 'The display title for the agreement advert';
comment on column rnt_tenancy_agreement.ad_contact is 'The person to contact in response to the the ad';
comment on column rnt_tenancy_agreement.ad_email is 'Email address to be used in the ad';
comment on column rnt_tenancy_agreement.ad_phone is 'The telephone number to be displayed';



