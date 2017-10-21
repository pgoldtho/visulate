create or replace view RNT_LEADS_V as
select LEAD_ID
,      PEOPLE_BUSINESS_ID
,      LEAD_DATE
,      LEAD_STATUS
,      LEAD_TYPE
,      REF_PROP_ID
,      FOLLOW_UP
,      UCODE
,      CITY
,      MIN_PRICE
,      MAX_PRICE
,      LTV_TARGET
,      LTV_QUALIFIED_YN
,      DESCRIPTION
,      rnt_sys_checksum_rec_pkg.get_checksum('LEAD_ID='||LEAD_ID||'PEOPLE_BUSINESS_ID='||PEOPLE_BUSINESS_ID
                                           ||'LEAD_DATE='||LEAD_DATE||'LEAD_STATUS='||LEAD_STATUS||'LEAD_TYPE='||LEAD_TYPE
                                           ||'REF_PROP_ID='||REF_PROP_ID||'FOLLOW_UP='||FOLLOW_UP||'UCODE='||UCODE
                                           ||'CITY='||CITY||'MIN_PRICE='||MIN_PRICE||'MAX_PRICE='||MAX_PRICE
                                           ||'LTV_TARGET='||LTV_TARGET||'LTV_QUALIFIED_YN='||LTV_QUALIFIED_YN
                                           ||'DESCRIPTION='||DESCRIPTION) as CHECKSUM
from RNT_LEADS;

create or replace view RNT_LEAD_ACTIONS_V as
select ACTION_ID
,      LEAD_ID
,      ACTION_DATE
,      ACTION_TYPE
,      BROKER_ID
,      DESCRIPTION
,      rnt_sys_checksum_rec_pkg.get_checksum('ACTION_ID='||ACTION_ID||'LEAD_ID='||LEAD_ID
                                           ||'ACTION_DATE='||ACTION_DATE||'ACTION_TYPE='||ACTION_TYPE
                                           ||'BROKER_ID='||BROKER_ID||'DESCRIPTION='||DESCRIPTION) as CHECKSUM
from RNT_LEAD_ACTIONS;


