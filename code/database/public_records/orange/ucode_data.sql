delete from pr_property_usage 
where ucode = 10
and prop_id = 759521;

delete from pr_property_usage 
where ucode = 4
and prop_id = 759526;

begin
  prop_class_pkg.process_sales;
end;
/


insert into pr_ucode_data
  ( city_id
  , ucode
  , property_count
  , total_sqft)
  select c.city_id
  ,      uc.ucode
  ,      count(*) property_count  
  ,      sum(p.sq_ft) property_sqft
  from pr_properties p
  ,    pr_property_usage pu
  ,    pr_usage_codes uc
  ,    rnt_zipcodes z
  ,    rnt_city_zipcodes cz
  ,    rnt_cities c
where p.zipcode = z.zipcode
and z.zipcode = cz.zipcode
and cz.city_id = c.city_id
and p.prop_id = pu.prop_id
and p.sq_ft > 0
and pu.ucode = uc.ucode
and p.source_id = 5
group by c.city_id
  ,      uc.ucode
order by c.city_id
  ,      uc.ucode;