create or replace view RNT_AGREEMENT_ACTIONS_V as
select aa.ACTION_ID
,      aa.AGREEMENT_ID
,      aa.ACTION_DATE
,      aa.ACTION_TYPE
,      aa.COMMENTS
,      aa.RECOVERABLE_YN
,      aa.ACTION_COST
,      rnt_sys_checksum_rec_pkg.get_checksum('AGREEMENT_ID='||aa.AGREEMENT_ID
                                           ||'ACTION_DATE='||aa.ACTION_DATE
                                           ||'ACTION_TYPE='||aa.ACTION_TYPE
                                           ||'COMMENTS='||dbms_lob.substr(aa.COMMENTS, 3000, 1)
                                                        ||dbms_lob.getlength(aa.comments)
                                           ||'RECOVERABLE_YN='||aa.RECOVERABLE_YN
                                           ||'ACTION_COST='||aa.ACTION_COST) as   CHECKSUM
,      lv.LOOKUP_VALUE as ACTION_TYPE_NAME
from RNT_AGREEMENT_ACTIONS aa,
     RNT_LOOKUP_VALUES_V lv
where aa.ACTION_TYPE = lv.LOOKUP_CODE
  and lv.LOOKUP_TYPE_CODE = 'ACTION_TYPES';


create or replace view RNT_DOC_TEMPLATES_V as
select TEMPLATE_ID
,      NAME
,      BUSINESS_ID
,      CONTENT
,      rnt_sys_checksum_rec_pkg.get_checksum('TEMPLATE_ID='||TEMPLATE_ID
                                           ||'NAME='       ||NAME
                                           ||'BUSINESS_ID='||BUSINESS_ID
                                           ||'CONTENT='||dbms_lob.substr(CONTENT, 3000, 1)
                                                       ||dbms_lob.getlength(CONTENT)) as CHECKSUM
from RNT_DOC_TEMPLATES;