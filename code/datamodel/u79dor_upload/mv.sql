drop materialized view pr_value_summary_mv;
drop materialized view pr_ucode_summary_mv;
drop materialized view pr_county_summary_mv;


create materialized view pr_zipcode_summary_mv as
select n.phy_zipcd zipcode
    , (n.dor_uc + 90000) ucode
    , s.sale_yr 
    ,      round(max (s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) a_max
    ,      round(PERCENTILE_DISC(0.875) within group (order by s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) a_median
    ,      round(PERCENTILE_DISC(0.75) within group (order by s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) a_min
    ,      round(PERCENTILE_DISC(0.5) within group (order by s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) b_median
    ,      round(PERCENTILE_DISC(0.25) within group (order by s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) c_max
    ,      round(PERCENTILE_DISC(0.175) within group (order by s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) c_median
    ,      round(min (s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) c_min
    ,      count(*) sales_count
    from pr_nal n
    ,    pr_sdf s
    where s.parcel_id = n.parcel_id
    and s.sale_prc > 200
    group by n.phy_zipcd, (n.dor_uc + 90000), s.sale_yr;
    
create materialized view pr_city_summary_mv as
select c.city_id
    , (n.dor_uc + 90000) ucode
    , s.sale_yr 
    ,      round(max (s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) a_max
    ,      round(PERCENTILE_DISC(0.875) within group (order by s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) a_median
    ,      round(PERCENTILE_DISC(0.75) within group (order by s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) a_min
    ,      round(PERCENTILE_DISC(0.5) within group (order by s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) b_median
    ,      round(PERCENTILE_DISC(0.25) within group (order by s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) c_max
    ,      round(PERCENTILE_DISC(0.175) within group (order by s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) c_median
    ,      round(min (s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) c_min
    ,      count(*) sales_count
    from pr_nal n
    ,    pr_sdf s
    ,    rnt_city_zipcodes cz
    ,    rnt_cities c
    where s.parcel_id = n.parcel_id
    and s.sale_prc > 200
    and n.phy_zipcd = cz.zipcode
    and cz.city_id = c.city_id
    group by c.city_id, (n.dor_uc + 90000), s.sale_yr;
    
    
 create materialized view pr_county_summary_mv as
 select c.county, c.state
    , (n.dor_uc + 90000) ucode
    , s.sale_yr 
    ,      round(max (s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) a_max
    ,      round(PERCENTILE_DISC(0.875) within group (order by s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) a_median
    ,      round(PERCENTILE_DISC(0.75) within group (order by s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) a_min
    ,      round(PERCENTILE_DISC(0.5) within group (order by s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) b_median
    ,      round(PERCENTILE_DISC(0.25) within group (order by s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) c_max
    ,      round(PERCENTILE_DISC(0.175) within group (order by s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) c_median
    ,      round(min (s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) c_min
    ,      count(*) sales_count
    from pr_nal n
    ,    pr_sdf s
    ,    rnt_city_zipcodes cz
    ,    rnt_cities c
    where s.parcel_id = n.parcel_id
    and s.sale_prc > 200
    and n.phy_zipcd = cz.zipcode
    and cz.city_id = c.city_id
    group by c.county, c.state, (n.dor_uc + 90000), s.sale_yr;
       
    
create materialized view pr_ucode_summary_mv as
  select n.phy_zipcd   zipcode
  , (n.dor_uc + 90000) ucode
  ,      count(*)  property_count
  ,      sum(nvl(nvl(tot_lvg_area,(lnd_sqfoot/43560)),0)) total_area
  from pr_nal n
  group by n.phy_zipcd, (n.dor_uc + 90000);