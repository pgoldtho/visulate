create table mls_listings
  ( mls_id         number         not null
  , prop_id        number         not null
  , source_id      number         not null
  , mls_number     number         not null
  , query_type     varchar2(32)   not null
  , listing_type   varchar2(16)   not null
  , listing_status varchar2(16)   not null
  , price          number         not null
  , idx_yn         varchar2(1)    not null
  , listing_broker varchar2(64)   not null
  , listing_date   date           not null
  , short_desc     varchar2(128)  not null
  , link_text      varchar2(64)   not null
  , description    varchar2(4000) not null
  , last_active    date           not null
  , constraint mls_listings_pk primary key (mls_id)
  , constraint mls_listings_u1 unique  (source_id, mls_number)
  , constraint mls_listings_r1 foreign key (source_id)
                    references pr_sources (source_id)
  , constraint mls_listings_r2 foreign key (prop_id)
                    references pr_properties (prop_id));
					
create table mls_photos
  ( mls_id          number        not null
  , photo_seq       number        not null
  , photo_url       varchar2(256) not null
  , photo_desc      varchar2(256) 
  , constraint mls_photos_pk primary key (mls_id, photo_seq)
  , constraint mls_photos_r1 foreign key (mls_id)
                   references mls_listings(mls_id));

create index mls_listings_r1 on mls_listings(prop_id);



create sequence mls_listings_seq;

create table mls_rets_responses
 ( mls_number     number         not null
 , date_found     date           not null
 , query_type     varchar2(32)   not null
 , processed_yn   varchar2(1)    not null
 , response       xmltype);
 
 create table mls_brokers
 ( broker_uid     varchar2(64)  not null
 , source_id      number        not null
 , name           varchar2(128) not null
 , phone          varchar2(16)
 , url            varchar2(128)
 , constraint mls_brokers_pk primary key 
    (broker_uid, source_id)
 , constraint mls_brokers_r1 foreign key(source_id) 
   references pr_sources(source_id));
 
-- create index PR_PROPERTIES_FB2
-- on pr_properties (pr_records_pkg.sqft_class(sq_ft));

