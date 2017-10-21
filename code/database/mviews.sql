drop materialized view pr_sales_summary_mv;
create materialized view pr_sales_summary_mv as
select upper(z.county) county
,      z.county display_county
,      to_char(sale_date, 'yyyy') year
,      count(*)                   sales_count
,      sum(price)                 total_sales
,      round(median(price))          avg_price
from pr_property_sales ps
,    pr_properties p
,    rnt_zipcodes z
where p.prop_id = ps.prop_id
and price > 100
and sale_date <= sysdate
and p.zipcode = z.zipcode
and to_char(sale_date, 'yyyy') > 1989
group by upper(z.county), z.county, to_char(sale_date, 'yyyy');

drop materialized view pr_sales_mv;
create materialized view pr_sales_mv as
select   upper(z.county) county
,        z.county display_county
,        to_char(sale_date, 'yyyy') year
,        to_char(sale_date, 'mm-yyyy') month_year
,        to_char(sale_date, 'Month')   display_date
,        city
,        initcap(city)                 display_city
,        sum(price)                    total_sales
,        round(median(price))          avg_price
,        count(*)                      sales_count
from pr_property_sales ps
,    pr_properties p
,    rnt_zipcodes z
where p.prop_id = ps.prop_id
and price > 100
and p.zipcode = z.zipcode
group by upper(z.county), z.county
,        to_char(sale_date, 'yyyy')
,        to_char(sale_date, 'mm-yyyy')
,        to_char(sale_date, 'Month')
,        city;

drop materialized view pr_commercial_summary_mv;
create materialized view pr_commercial_summary_mv as
select upper(z.county) county
,      z.county display_county
,      to_char(sale_date, 'yyyy') year
,      count(*)                   sales_count
,      sum(price)                 total_sales
,      round(median(price))          avg_price
from pr_property_sales ps
,    pr_properties p
,    pr_property_usage pu
,    pr_usage_codes uc
,    rnt_zipcodes z
where p.prop_id = ps.prop_id
and price > 100
and p.zipcode = z.zipcode
and sale_date <= sysdate
and to_char(sale_date, 'yyyy') > 1989
and pu.prop_id = p.prop_id
and uc.ucode = pu.ucode
and (uc.parent_ucode in (select ucode
                        from pr_usage_codes uc2
                        where uc2.parent_ucode = 2) or
    uc.parent_ucode in (92000, 93000, 94000, 95000, 96000))
group by upper(z.county), z.county
,        to_char(sale_date, 'yyyy');

drop materialized view pr_commercial_sales_mv;
create materialized view pr_commercial_sales_mv as
select upper(z.county) county
,      z.county display_county
,      uc.ucode
,      to_char(sale_date, 'yyyy') sales_year
,      uc.description
,      count(*)                   sales_count
,      sum(price)                 total_sales
,      round(median(price))       avg_price
from pr_property_sales ps
,    pr_properties p
,    pr_property_usage pu
,    pr_usage_codes uc
,    rnt_zipcodes z
where p.prop_id = ps.prop_id
and price > 100
and p.zipcode = z.zipcode
and pu.prop_id = p.prop_id
and uc.ucode = pu.ucode
and (uc.parent_ucode in (select ucode
                         from pr_usage_codes uc2
                         where uc2.parent_ucode = 2) or
    uc.parent_ucode in (92000, 93000, 94000, 95000, 96000))
group by upper(z.county), z.county
,     uc.ucode
,     to_char(sale_date, 'yyyy')
,     uc.description;

drop materialized view pr_land_summary_mv;
create materialized view pr_land_summary_mv as
select upper(z.county) county
,      z.county display_county
,      to_char(sale_date, 'yyyy') year
,      count(*)                   sales_count
,      sum(acreage)                 total_sales
,      round(median(price/acreage))          avg_price
from pr_property_sales ps
,    pr_properties p
,    pr_property_usage pu
,    pr_usage_codes uc
,    rnt_zipcodes z
where p.prop_id = ps.prop_id
and price > 100
and p.zipcode = z.zipcode
and acreage > 0
and sale_date <= sysdate
and to_char(sale_date, 'yyyy') > 1989
and pu.prop_id = p.prop_id
and uc.ucode = pu.ucode
and uc.parent_ucode = 3
group by upper(z.county), z.county
,     to_char(sale_date, 'yyyy');

drop materialized view pr_land_sales_mv;
create materialized view pr_land_sales_mv as
select upper(z.county) county
,      z.county display_county
,      uc.ucode
,      to_char(sale_date, 'yyyy') sales_year
,      uc.description
,      count(*)                     sales_count
,      sum(acreage)                 total_sales
,      round(median(price/acreage)) avg_price
from pr_property_sales ps
,    pr_properties p
,    pr_property_usage pu
,    pr_usage_codes uc
,    rnt_zipcodes z
where p.prop_id = ps.prop_id
and p.zipcode = z.zipcode
and price > 100
and acreage > 0
and pu.prop_id = p.prop_id
and uc.ucode = pu.ucode
and uc.parent_ucode = 3
group by upper(z.county), z.county
,     uc.ucode
,     to_char(sale_date, 'yyyy')
,     uc.description;

drop materialized view pr_county_summary_mv;
create materialized view pr_county_summary_mv as
select upper(z.county)             county
,      z.county                    display_county
,      uc2.ucode
,      uc2.description             ucode_name
,      to_char(sale_date, 'yyyy')  sales_year
,      count(*)                    sales_count
,      sum(price)                  total_sales
,      sum(sq_ft)                  total_ft_sales
,      round(median(price))        median_price
,      round(median(price/sq_ft))  median_price_ft
,      round(PERCENTILE_DISC(0.875) within group (order by price/sq_ft), 2) a_median_price_ft
,      round(PERCENTILE_DISC(0.125) within group (order by price/sq_ft), 2) c_median_price_ft
,      max(sale_date)              max_date
,      min(sale_date)              min_date
from pr_property_sales ps
,    pr_properties p
,    pr_property_usage pu
,    pr_usage_codes uc
,    rnt_zipcodes z
,    pr_usage_codes uc2
where p.prop_id = ps.prop_id
and price > 100
and p.zipcode = to_char(z.zipcode)
and sale_date <= sysdate
and pu.prop_id = p.prop_id
and uc.ucode = pu.ucode
and uc.parent_ucode = uc2.ucode
and sq_ft > 0
group by  upper(z.county) 
,      z.county           
,      uc2.ucode
,      uc2.description    
,      to_char(sale_date, 'yyyy');
