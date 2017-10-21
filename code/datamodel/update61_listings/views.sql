create or replace view PR_PROPERTY_LISTINGS_V as
select PROP_ID
,      BUSINESS_ID
,      LISTING_DATE
,      PRICE
,      PUBLISH_YN
,      SOLD_YN
,      DESCRIPTION
,      SOURCE
,      AGENT_NAME
,      AGENT_PHONE
,      AGENT_EMAIL
,      AGENT_WEBSITE
,      rnt_sys_checksum_rec_pkg.get_checksum('PROP_ID='||PROP_ID
                                           ||'BUSINESS_ID='||BUSINESS_ID
                                           ||'LISTING_DATE='||LISTING_DATE
                                           ||'PRICE='||PRICE
                                           ||'PUBLISH_YN='||PUBLISH_YN
                                           ||'SOLD_YN='||SOLD_YN
                                           ||'DESCRIPTION='||DESCRIPTION
                                           ||'SOURCE='||SOURCE
                                           ||'AGENT_NAME='||AGENT_NAME
                                           ||'AGENT_PHONE='||AGENT_PHONE
                                           ||'AGENT_EMAIL='||AGENT_EMAIL
                                           ||'AGENT_WEBSITE='||AGENT_WEBSITE) as CHECKSUM
from PR_PROPERTY_LISTINGS;


create or replace view PR_PROPERTIES_V as
select PROP_ID
,      SOURCE_ID
,      SOURCE_PK
,      ADDRESS1
,      ADDRESS2
,      CITY
,      STATE
,      ZIPCODE
,      ACREAGE
,      SQ_FT
,      rnt_sys_checksum_rec_pkg.get_checksum('PROP_ID='||PROP_ID
                                           ||'SOURCE_ID='||SOURCE_ID
                                           ||'SOURCE_PK='||SOURCE_PK
                                           ||'ADDRESS1='||ADDRESS1
                                           ||'ADDRESS2='||ADDRESS2
                                           ||'CITY='||CITY
                                           ||'STATE='||STATE
                                           ||'ZIPCODE='||ZIPCODE
                                           ||'ACREAGE='||ACREAGE
                                           ||'SQ_FT='||SQ_FT) as CHECKSUM
from PR_PROPERTIES;


create or replace view PR_PROPERTY_USAGE_V as
select UCODE
,      PROP_ID
,      rnt_sys_checksum_rec_pkg.get_checksum('UCODE='||UCODE||'PROP_ID='||PROP_ID) as CHECKSUM
from PR_PROPERTY_USAGE;