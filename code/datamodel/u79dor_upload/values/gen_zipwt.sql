select 'update rnt_zipcodes'||chr(10)||' set COUNTY_WT='||z.b_median/cn.b_median||chr(10)||' ,   CITY_WT='||z.b_median/c.b_median||chr(10)||' ,   ZIP_WT='||z.b_median/c.b_median||chr(10)||' where ZIPCODE='||cz.zipcode||';'
 from pr_zipcode_summary_mv z
  ,    pr_city_summary_mv c
  ,    rnt_city_zipcodes cz
  ,    pr_county_summary_mv cn
  ,    rnt_cities rc
  where c.ucode = 90001
  and   z.ucode = c.ucode
  and  cn.ucode = c.ucode
  and  to_number(z.zipcode) = cz.zipcode
  and c.city_id = cz.city_id
  and cz.city_id = rc.city_id
  and rc.county = cn.county
  and c.sale_yr = z.sale_yr
  and c.sale_yr = cn.sale_yr
  and c.sale_yr = 2011
  order by cz.zipcode;