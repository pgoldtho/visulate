create or replace view PR_PROP_CLASS_V as
select PROP_CLASS
,      DESCRIPTION
,      rnt_sys_checksum_rec_pkg.get_checksum('PROP_CLASS='||PROP_CLASS||'DESCRIPTION='||DESCRIPTION) as CHECKSUM
from PR_PROP_CLASS;

create or replace view PR_VALUES_V as
select CITY_ID
,      UCODE
,      PROP_CLASS
,      YEAR
,      MIN_PRICE
,      MAX_PRICE
,      MEDIAN_PRICE
,      RENT
,      VACANCY_PERCENT
,      REPLACEMENT
,      MAINTENANCE
,      MGT_PERCENT
,      CAP_RATE
,      UTILITIES
,      rnt_sys_checksum_rec_pkg.get_checksum('PROP_CLASS='||PROP_CLASS||'UCODE='||UCODE||'CITY_ID='||CITY_ID||'YEAR='
                                            ||YEAR||'MIN_PRICE='||MIN_PRICE||'MAX_PRICE='||MAX_PRICE||'MEDIAN_PRICE='
											||MEDIAN_PRICE||'RENT='||RENT||'REPLACEMENT='||REPLACEMENT||'MAINTENANCE='
											||MAINTENANCE||'MGT_PERCENT='||MGT_PERCENT||'CAP_RATE='
											||CAP_RATE||'UTILITIES='||UTILITIES||'VACANCY_PERCENT='||VACANCY_PERCENT) as CHECKSUM
from PR_VALUES;
