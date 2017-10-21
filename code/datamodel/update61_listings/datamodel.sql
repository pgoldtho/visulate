--
-- Add FK PROP_ID to rnt_properties.

alter table rnt_properties add
( prop_id               number);

alter table rnt_properties add
( constraint  rnt_properties_r1 
  foreign key (prop_id) references pr_properties(prop_id));


create index rnt_properties_i2 on rnt_properties(prop_id);

comment on column rnt_properties.prop_id is 'Foreign key to public records details for property';
comment on column rnt_properties.name is 
                         'Optional name for property used in order by clause to sort properties';
comment on column rnt_properties.status is 
  'Current status of property in the business unit e.g. candidate, purchased or rejected.';


--
-- Create new table pr_property_listings
--

create table pr_property_listings
( prop_id               number not null
, business_id           number not null
, listing_date          date   not null
, price                 number not null
, publish_yn            varchar2(1) not null
, sold_yn               varchar2(1) not null
, description           varchar2(4000)
, source                varchar2(64)
, agent_name            varchar2(64)
, agent_phone           varchar2(16)
, agent_email           varchar2(64)
, agent_website         varchar2(128)
, constraint pr_property_listings_pk
  primary key (prop_id, business_id, listing_date)
, constraint pr_property_listings_r1
  foreign key (prop_id) references pr_properties(prop_id)
, constraint pr_property_listings_r2
  foreign key (business_id) references rnt_business_units(business_id));

create index pr_property_listings_n1 
  on pr_property_listings(business_id);


comment on table pr_property_listings is
'Records details of properties that are currently available for sale';

comment on column pr_property_listings.prop_id  
  is 'Foreign key to pr_properties';
comment on column pr_property_listings.listing_date  
  is 'The data that the property became available for sale';
comment on column pr_property_listings.business_id  
  is 'Foreign key to rnt_business_units';
comment on column pr_property_listings.price  
  is 'Current advertized listing price';
comment on column pr_property_listings.publish_yn
  is 'Should this listing be displayed on the website?';
comment on column pr_property_listings.sold_yn
  is 'Has this property been sold or withdrawn from sale?';
comment on column pr_property_listings.description
  is 'Description of the property';
comment on column pr_property_listings.source
  is 'Where was it listed e.g. MLS, Loopnet etc';
comment on column pr_property_listings.agent_name
  is 'The name of the listing agent';
comment on column pr_property_listings.agent_phone
  is 'The listing agent''s telephone number';
comment on column pr_property_listings.agent_email
  is 'Email address for the listing agent';
comment on column pr_property_listings.agent_email
  is 'URL for the listing agent''s website. ';

create sequence PR_PROPERTIES_SEQ;