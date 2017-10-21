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
,      geo_location
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