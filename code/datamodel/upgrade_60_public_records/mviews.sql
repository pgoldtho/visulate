create materialized view pr_sales_summary_mv as
select to_char(sale_date, 'yyyy') year
,      count(*)                   sales_count
,      sum(price)                 total_sales
,      round(median(price))          avg_price
from pr_property_sales ps
,    pr_properties p
where deed_code = 'WD'
and p.prop_id = ps.prop_id
and price > 0
and sale_date <= sysdate
and to_char(sale_date, 'yyyy') > 1989
               group by to_char(sale_date, 'yyyy');


create materialized view pr_sales_mv as
select   to_char(sale_date, 'yyyy') year 
,        to_char(sale_date, 'mm-yyyy') month_year
,        to_char(sale_date, 'Month')   display_date
,        city
,        initcap(city)                 display_city
,        sum(price)                    total_sales
,        round(median(price))          avg_price
,        count(*)                      sales_count
from pr_property_sales ps
,    pr_properties p
where deed_code = 'WD'
and p.prop_id = ps.prop_id
and price > 0
group by to_char(sale_date, 'yyyy')
,        to_char(sale_date, 'mm-yyyy')
,        to_char(sale_date, 'Month')
,        city;


create materialized view pr_commercial_summary_mv as
select to_char(sale_date, 'yyyy') year
,      count(*)                   sales_count
,      sum(price)                 total_sales
,      round(median(price))          avg_price
from pr_property_sales ps
,    pr_properties p
,    pr_property_usage pu
,    pr_usage_codes uc
where deed_code = 'WD'
and p.prop_id = ps.prop_id
and price > 0
and sale_date <= sysdate
and to_char(sale_date, 'yyyy') > 1989
and pu.prop_id = p.prop_id
and uc.ucode = pu.ucode
and uc.parent_ucode in (select ucode
                        from pr_usage_codes uc2
                        where uc2.parent_ucode = 2)
group by to_char(sale_date, 'yyyy');


create materialized view pr_commercial_sales_mv as
select uc.ucode
,      to_char(sale_date, 'yyyy') sales_year
,      uc.description
,      count(*)                   sales_count
,      sum(price)                 total_sales
,      round(median(price))       avg_price
from pr_property_sales ps
,    pr_properties p
,    pr_property_usage pu
,    pr_usage_codes uc
where deed_code = 'WD'
and p.prop_id = ps.prop_id
and price > 0
and pu.prop_id = p.prop_id
and uc.ucode = pu.ucode
and uc.parent_ucode in (select ucode
                        from pr_usage_codes uc2
                        where uc2.parent_ucode = 2)
group by uc.ucode
,     to_char(sale_date, 'yyyy')
,     uc.description;


create materialized view pr_land_summary_mv as
select to_char(sale_date, 'yyyy') year
,      count(*)                   sales_count
,      sum(acreage)                 total_sales
,      round(median(price/acreage))          avg_price
from pr_property_sales ps
,    pr_properties p
,    pr_property_usage pu
,    pr_usage_codes uc
where deed_code = 'WD'
and p.prop_id = ps.prop_id
and price > 0
and acreage > 0
and sale_date <= sysdate
and to_char(sale_date, 'yyyy') > 1989
and pu.prop_id = p.prop_id
and uc.ucode = pu.ucode
and uc.parent_ucode = 3
group by to_char(sale_date, 'yyyy');


create materialized view pr_land_sales_mv as
select uc.ucode
,      to_char(sale_date, 'yyyy') sales_year
,      uc.description
,      count(*)                     sales_count
,      sum(acreage)                 total_sales
,      round(median(price/acreage)) avg_price
from pr_property_sales ps
,    pr_properties p
,    pr_property_usage pu
,    pr_usage_codes uc
where deed_code = 'WD'
and p.prop_id = ps.prop_id
and price > 0
and acreage > 0
and pu.prop_id = p.prop_id
and uc.ucode = pu.ucode
and uc.parent_ucode = 3
group by uc.ucode
,     to_char(sale_date, 'yyyy')
,     uc.description;