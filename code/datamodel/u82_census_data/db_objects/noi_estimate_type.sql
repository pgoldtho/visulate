drop type pr_noi_sets;
create or replace type pr_noi_type as object
( monthly_rent           number
, annual_rent            number
, vacancy_amount         number
, vacancy_percent        number
, insurance              number
, TAX                    number
, maintenance            number
, utilities              number
, cap_rate               number
, mgt_percent            number
, mgt_amount             number
, median_market_value    number
, low_market_value       number
, high_market_value      number
, sqft_rent              number
, prop_class             varchar2(1)
, min_price              number
, median_price           number
, max_price              number
, estimate_year          number
, noi                    number
, city                   varchar2(64)
, county                 varchar2(64)
, state                  varchar2(64)
, pclass                 varchar2(1)
, summary                varchar2(32767));
/

create or replace type pr_noi_sets as table of pr_noi_type;
/