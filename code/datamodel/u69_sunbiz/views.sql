create or replace view PR_LOCATIONS_V as
select LOC_ID
,      ADDRESS1
,      ADDRESS2
,      CITY
,      STATE
,      ZIP5
,      ZIP4
,      COUNTRY
,      PROP_ID
,      rnt_sys_checksum_rec_pkg.get_checksum('LOC_ID='||LOC_ID||'ADDRESS1='||ADDRESS1||'ADDRESS2='
                                             ||ADDRESS2||'CITY='||CITY||'STATE='||STATE||'ZIP5='||ZIP5
											 ||'ZIP4='||ZIP4||'COUNTRY='||COUNTRY
											 ||'PROP_ID='||PROP_ID) as CHECKSUM
from PR_LOCATIONS;

create or replace view PR_PRINCIPALS_V as
select PN_ID
,      PN_TYPE
,      PN_NAME
,      rnt_sys_checksum_rec_pkg.get_checksum('PN_ID='||PN_ID||'PN_TYPE='||PN_TYPE
                                            ||'PN_NAME='||PN_NAME) as CHECKSUM
from PR_PRINCIPALS;

create or replace view PR_CORPORATIONS_V as
select CORP_NUMBER
,      NAME
,      STATUS
,      FILING_TYPE
,      FILING_DATE
,      FEI_NUMBER
,      rnt_sys_checksum_rec_pkg.get_checksum('CORP_NUMBER='||CORP_NUMBER||'NAME='||NAME
                                           ||'STATUS='||STATUS||'FILING_TYPE='||FILING_TYPE
										   ||'FILING_DATE='||FILING_DATE||'FEI_NUMBER='
										   ||FEI_NUMBER) as CHECKSUM
from PR_CORPORATIONS;

create or replace view PR_PRINCIPAL_LOCATIONS_V as
select LOC_ID
,      PN_ID
,      rnt_sys_checksum_rec_pkg.get_checksum('LOC_ID='||LOC_ID||'PN_ID='||PN_ID) as CHECKSUM
from PR_PRINCIPAL_LOCATIONS;

create or replace view PR_CORPORATE_LOCATIONS_V as
select LOC_ID
,      CORP_NUMBER
,      rnt_sys_checksum_rec_pkg.get_checksum('LOC_ID='||LOC_ID||'CORP_NUMBER='||CORP_NUMBER) as CHECKSUM
from PR_CORPORATE_LOCATIONS;

create or replace view PR_CORPORATE_POSITIONS_V as
select CORP_NUMBER
,      PN_ID
,      TITLE_CODE
,      rnt_sys_checksum_rec_pkg.get_checksum('CORP_NUMBER='||CORP_NUMBER||'PN_ID='||PN_ID
                                             ||'TITLE_CODE='||TITLE_CODE) as
 CHECKSUM
from PR_CORPORATE_POSITIONS
;