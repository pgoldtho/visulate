alter table mls_rets_responses add
( source_id         number);

create table mls_listings_archive
  ( mls_id         number         
  , prop_id        number         
  , source_id      number         
  , mls_number     number         
  , query_type     varchar2(32)   
  , listing_type   varchar2(16)   
  , listing_status varchar2(16)   
  , price          number         
  , idx_yn         varchar2(1)    
  , listing_broker varchar2(64)   
  , listing_date   date           
  , short_desc     varchar2(128)  
  , link_text      varchar2(64)   
  , description    varchar2(4000) 
  , last_active    date     
  , geo_location   sdo_geometry  
  );
					
create table mls_photos_archive
  ( mls_id          number        
  , photo_seq       number        
  , photo_url       varchar2(256) 
  , photo_desc      varchar2(256) 
  );
