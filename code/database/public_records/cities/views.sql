create or replace view RNT_CITY_MEDIA_V as
select MEDIA_ID
,      NAME
,      MEDIA_TYPE
,      CITY_ID
,      REGION_ID
,      TITLE
,      ASPECT_RATIO
,      COUNTY_YN
,      rnt_sys_checksum_rec_pkg.get_checksum
                                 ('MEDIA_ID='||MEDIA_ID
                                ||'NAME='||NAME
                                ||'MEDIA_TYPE='||MEDIA_TYPE
                                ||'CITY_ID='||CITY_ID
                                ||'REGION_ID='||REGION_ID
                                ||'TITLE='||TITLE
                                ||'ASPECT_RATIO='||ASPECT_RATIO
                                ||'COUNTY_YN='||COUNTY_YN) as CHECKSUM
from RNT_CITY_MEDIA;

create or replace view RNT_REGIONS_V as
select REGION_ID
,      NAME
,      DESCRIPTION
,      REPORT_DATA
,      meta_description
,      rnt_sys_checksum_rec_pkg.get_checksum
                                 ('REGION_ID='||REGION_ID
                                ||'NAME='||NAME
                                ||'DESCRIPTION='||dbms_lob.substr(DESCRIPTION, 1500, 1)
                                ||dbms_lob.getlength(DESCRIPTION)
                                ||'REPORT_DATA='||dbms_lob.substr(REPORT_DATA, 1500, 1)
                                ||dbms_lob.getlength(REPORT_DATA)) as CHECKSUM
from RNT_REGIONS;

create or replace view RNT_CITIES_V as
select c.CITY_ID
,      c.NAME
,      c.COUNTY
,      c.STATE
,      c.DESCRIPTION
,      c.GEO_LOCATION
,      c.REPORT_DATA
,      c.REGION_ID
,      c.POPULATION
,      r.name region_name
,      c.meta_description
,      c.rss_news        
,      c.rss_source      
,      c.rss_name        
,      rnt_sys_checksum_rec_pkg.get_checksum
                                 ('CITY_ID='||c.CITY_ID
                                ||'NAME='||c.NAME
                                ||'COUNTY='||c.COUNTY
                                ||'STATE='||c.STATE
                                ||'DESCRIPTION='||dbms_lob.substr(c.DESCRIPTION, 1500, 1)
                                ||dbms_lob.getlength(c.DESCRIPTION)
                                ||'REPORT_DATA='||dbms_lob.substr(c.REPORT_DATA, 1500, 1)
                                ||dbms_lob.getlength(c.REPORT_DATA)
                                ||'LAT='||c.geo_location.sdo_point.y
                                ||'LON='||c.geo_location.sdo_point.x 
                                ||'REGION_ID='||c.REGION_ID) as CHECKSUM
from RNT_CITIES c
,    RNT_REGIONS r
where r.region_id(+) = c.region_id;

