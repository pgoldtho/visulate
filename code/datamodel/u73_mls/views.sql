create or replace view MLS_LISTINGS_V as
select MLS_ID
,      PROP_ID
,      SOURCE_ID
,      MLS_NUMBER
,      QUERY_TYPE
,      LISTING_TYPE
,      LISTING_STATUS
,      PRICE
,      IDX_YN
,      LISTING_BROKER
,      LISTING_DATE
,      SHORT_DESC
,      LINK_TEXT
,      DESCRIPTION
,      LAST_ACTIVE
,      rnt_sys_checksum_rec_pkg.get_checksum('MLS_ID='||MLS_ID
                                           ||'PROP_ID='||PROP_ID
										   ||'SOURCE_ID='||SOURCE_ID
										   ||'MLS_NUMBER='||MLS_NUMBER
										   ||'QUERY_TYPE='||QUERY_TYPE
										   ||'LISTING_TYPE='||LISTING_TYPE
										   ||'LISTING_STATUS='||LISTING_STATUS
										   ||'PRICE='||PRICE
										   ||'IDX_YN='||IDX_YN
										   ||'LISTING_BROKER='||LISTING_BROKER
										   ||'LISTING_DATE='||LISTING_DATE
										   ||'SHORT_DESC='||SHORT_DESC
										   ||'LINK_TEXT='||LINK_TEXT
										   ||'DESCRIPTION='||DESCRIPTION
										   ||'LAST_ACTIVE='||LAST_ACTIVE) 
										   as CHECKSUM
from MLS_LISTINGS;

create or replace view MLS_PHOTOS_V as
select MLS_ID
,      PHOTO_SEQ
,      PHOTO_URL
,      PHOTO_DESC
,      rnt_sys_checksum_rec_pkg.get_checksum('MLS_ID='||MLS_ID
                                           ||'PHOTO_SEQ='||PHOTO_SEQ
										   ||'PHOTO_URL='||PHOTO_URL
										   ||'PHOTO_DESC='||PHOTO_DESC) 
										   as CHECKSUM
from MLS_PHOTOS;

