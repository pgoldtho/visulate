select c.name
    ,      u2.description
    ,      s.tax_year
    ,      round(PERCENTILE_DISC(0.8) within group (order by s.tax_amount/nvl(p.sq_ft, p.acreage)) * 10, 2) a_median
    ,      round(PERCENTILE_DISC(0.5) within group (order by s.tax_amount/nvl(p.sq_ft, p.acreage)) * 10, 2) b_median
    ,      round(PERCENTILE_DISC(0.2) within group (order by s.tax_amount/nvl(p.sq_ft, p.acreage)) * 10, 2) c_median
    ,      count(*) prop_count
    from pr_properties p
    ,    pr_taxes s
    ,    pr_property_usage pu
    ,    pr_usage_codes u
    ,    rnt_city_zipcodes cz
    ,    rnt_cities c
    ,    pr_usage_codes u2
    where c.city_id = cz.city_id
    and to_char(cz.zipcode) = p.zipcode
    and c.state='FL'
    and pu.prop_id = p.prop_id
    and p.prop_id = s.prop_id
    and u.ucode = pu.ucode
    and u.parent_ucode = u2.ucode
    and p.sq_ft != 0
    and nvl(p.sq_ft, p.acreage) != 0
    and (s.tax_amount/nvl(p.sq_ft, p.acreage) < 25)
    group by c.name, u2.description, s.tax_year having count(*) > 20
    order by c.name, u2.description, s.tax_year;

