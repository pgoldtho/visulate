select c.name city
,      z.zipcode
,      p.prop_class pclass
,      round(v.rent * z.county_wt, 2)                                   eRent
,      pr_records_pkg.sqft_class(p.sq_ft)                                        sqft
,      pr_records_pkg.year_class(p.year_built)                         yr_class
,      to_char (m.price, '$99,999')                                  Asking 
,      p.prop_id
from pr_properties p
,    pr_property_usage pu
,    rnt_city_zipcodes cz
,    rnt_cities c
,    pr_values v
,    pr_usage_codes uc
,    pr_taxes t
,    MLS_LISTINGS m
,    rnt_zipcodes z
where p.prop_id = m.prop_id
and p.prop_id = pu.prop_id
and (v.ucode = uc.ucode or
     v.ucode = uc.parent_ucode)
and z.zipcode = cz.zipcode
and to_number(p.zipcode) = z.zipcode
and uc.ucode = pu.ucode
and pu.ucode = 90001
and cz.city_id = c.city_id
and v.city_id = c.city_id
and t.prop_id = p.prop_id
and p.prop_class = v.prop_class
and p.sq_ft > 0
and m.listing_type = 'Rent'
and v.year = (select max(year)
           from pr_values v2
           where v2.prop_class = v.prop_class
           and v2.ucode = v.ucode
           and v2.city_id = v.city_id)
order by 1, 2, 3;