select c.name, n.dor_uc, count(*), sum(nvl(n.tot_lvg_area,0))
from rnt_cities c
,         pr_nal n
where n.co_no = 59
and c.name = n.phy_city
group by c.name, n.dor_uc
order by c.name, n.dor_uc

select c.city_id, n.dor_uc, s.sale_yr
,      round(max (s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) a_max
,      round(PERCENTILE_DISC(0.875) within group (order by s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) a_median
,      round(PERCENTILE_DISC(0.75) within group (order by s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) a_min
,      round(PERCENTILE_DISC(0.5) within group (order by s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) b_median
,      round(PERCENTILE_DISC(0.25) within group (order by s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) c_max
,      round(PERCENTILE_DISC(0.175) within group (order by s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) c_median
,      round(min (s.sale_prc/nvl(n.tot_lvg_area,(lnd_sqfoot/43560))), 2) c_min
,      count(*) sales_count
from rnt_cities c
,         pr_nal n
,         pr_sdf s
where n.co_no = 59
and c.name = n.phy_city
and s.parcel_id = n.parcel_id
and s.sale_prc > 200
group by c.city_id, n.dor_uc, s.sale_yr
order by c.city_id, n.dor_uc, s.sale_yr

if 
ORA-13000: dimension number is out of range
ORA-06512: at "MDSYS.SDO_GEOM", line 125


SQL> select distinct a.geom.sdo_gtype from pr_geo A;

GEOM.SDO_GTYPE
--------------
	     3
	     7
	     
If sdo_gtype includes single digit values then	     

SQL> exec sdo_migrate.to_current('PR_GEO', 'GEOM')

GEOM.SDO_GTYPE
--------------
	  2007
	  2003


