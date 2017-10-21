create or replace view RNT_CITIES_V as
select CITY_ID
,      NAME
,      COUNTY
,      STATE
,      DESCRIPTION
,      rnt_sys_checksum_rec_pkg.get_checksum('CITY_ID='||CITY_ID
                                                       ||'NAME='||NAME
													   ||'COUNTY='||COUNTY
													   ||'STATE='||STATE
													   ||'DESCRIPTION='
													   ||dbms_lob.substr(DESCRIPTION, 3000, 1)
                                                       ||dbms_lob.getlength(DESCRIPTION)) as CHECKSUM
from RNT_CITIES;