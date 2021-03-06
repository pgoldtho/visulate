declare
  cursor cur_vals is
select   to_char(sale_Date, 'yyyy') year
  ,      uc.ucode
  ,      c.name
  ,      c.city_id
  ,      count(*) sale_count
  ,      round(min(ps.price/p.sq_ft), 2) min_price
  ,      round(max(ps.price/p.sq_ft), 2) max_price
  ,      round(PERCENTILE_DISC(0.75) within group (order by ps.price/p.sq_ft), 2) class_a_min
  ,      round(PERCENTILE_DISC(0.875) within group (order by ps.price/p.sq_ft), 2) class_a_median
  ,      round(median(ps.price/p.sq_ft), 2) class_b_median
  ,      round(PERCENTILE_DISC(0.125) within group (order by ps.price/p.sq_ft), 2) class_c_median
  ,      round(PERCENTILE_DISC(0.25) within group (order by ps.price/p.sq_ft), 2) class_c_max
from pr_property_sales ps
,    pr_properties p
,    pr_property_usage pu
,    pr_usage_codes uc
,    rnt_zipcodes z
,    rnt_city_zipcodes cz
,    rnt_cities c
where ps.price > 200
and ps.prop_id = p.prop_id
and p.zipcode = z.zipcode
and z.zipcode = cz.zipcode
and cz.city_id = c.city_id
and p.prop_id = pu.prop_id
and p.source_id = 5
and p.sq_ft > 200
and pu.ucode = uc.ucode
and  to_char(sale_Date, 'yyyy') in
 ('2011')
and (uc.ucode = 1 or
     uc.parent_ucode in (1, 2))
group by to_char(sale_Date, 'yyyy') 
  ,      uc.ucode
  ,      c.name
  ,      c.city_id
having count(*) > 20
order by to_char(sale_Date, 'yyyy')
  ,      uc.ucode
  ,      c.name
  ,      c.city_id  ;

cursor cur_vals2 is  
  select   to_char(sale_Date, 'yyyy') year
  ,      uc.parent_ucode
  ,      c.name
  ,      c.city_id
  ,      count(*) sale_count
  ,      round(min(ps.price/p.sq_ft), 2) min_price
  ,      round(max(ps.price/p.sq_ft), 2) max_price
  ,      round(PERCENTILE_DISC(0.75) within group (order by ps.price/p.sq_ft), 2) class_a_min
  ,      round(PERCENTILE_DISC(0.875) within group (order by ps.price/p.sq_ft), 2) class_a_median
  ,      round(median(ps.price/p.sq_ft), 2) class_b_median
  ,      round(PERCENTILE_DISC(0.125) within group (order by ps.price/p.sq_ft), 2) class_c_median
  ,      round(PERCENTILE_DISC(0.25) within group (order by ps.price/p.sq_ft), 2) class_c_max
from pr_property_sales ps
,    pr_properties p
,    pr_property_usage pu
,    pr_usage_codes uc
,    rnt_zipcodes z
,    rnt_city_zipcodes cz
,    rnt_cities c
where ps.price > 200
and ps.prop_id = p.prop_id
and p.zipcode = z.zipcode
and z.zipcode = cz.zipcode
and cz.city_id = c.city_id
and p.prop_id = pu.prop_id
and p.source_id = 5
and p.sq_ft > 0
and pu.ucode = uc.ucode
and  to_char(sale_Date, 'yyyy') in
 ('2011')
and uc.parent_ucode in (11, 12, 13, 14, 15, 17, 18, 19, 23, 24)
group by to_char(sale_Date, 'yyyy') 
  ,      uc.parent_ucode
  ,      c.name
  ,      c.city_id
having count(*) > 20
order by to_char(sale_Date, 'yyyy')
  ,      uc.parent_ucode
  ,      c.name
  ,      c.city_id  ;
  
  
  
begin
/*
  for v_rec in cur_vals loop
     
     dbms_output.put_line('val '||v_rec.name||' - '||v_rec.ucode);
     PR_VALUES_PKG.INSERT_ROW
	                 ( X_CITY_ID      => v_rec.city_id
                     , X_UCODE        => v_rec.ucode
                     , X_PROP_CLASS   => 'A'
                     , X_YEAR         => v_rec.year
                     , X_MIN_PRICE    => v_rec.class_a_min
                     , X_MAX_PRICE    => v_rec.max_price
                     , X_MEDIAN_PRICE => v_rec.class_a_median
                     , X_RENT         => null
					 , X_VACANCY_PERCENT => null
                     , X_REPLACEMENT  => null
                     , X_MAINTENANCE  => null
                     , X_MGT_PERCENT  => null
                     , X_CAP_RATE     => null 
					 , X_UTILITIES    => null);
					 
     PR_VALUES_PKG.INSERT_ROW
	                 ( X_CITY_ID      => v_rec.city_id
                     , X_UCODE        => v_rec.ucode
                     , X_PROP_CLASS   => 'B'
                     , X_YEAR         => v_rec.year
                     , X_MIN_PRICE    => v_rec.class_c_max + 0.01
                     , X_MAX_PRICE    => v_rec.class_a_min - 0.01
                     , X_MEDIAN_PRICE => v_rec.class_b_median
                     , X_RENT         => null
					 , X_VACANCY_PERCENT => null
                     , X_REPLACEMENT  => null
                     , X_MAINTENANCE  => null
                     , X_MGT_PERCENT  => null
                     , X_CAP_RATE     => null 
                     , X_UTILITIES    => null);
					 
     PR_VALUES_PKG.INSERT_ROW
	                 ( X_CITY_ID      => v_rec.city_id
                     , X_UCODE        => v_rec.ucode
                     , X_PROP_CLASS   => 'C'
                     , X_YEAR         => v_rec.year
                     , X_MIN_PRICE    => v_rec.min_price
                     , X_MAX_PRICE    => v_rec.class_c_max
                     , X_MEDIAN_PRICE => v_rec.class_c_median
                     , X_RENT         => null
					 , X_VACANCY_PERCENT => null
                     , X_REPLACEMENT  => null
                     , X_MAINTENANCE  => null
                     , X_MGT_PERCENT  => null
                     , X_CAP_RATE     => null 
                     , X_UTILITIES    => null);
	commit;  				 
  end loop;	
  */
  for v_rec in cur_vals2 loop
     dbms_output.put_line('val2 '||v_rec.name ||' - '||v_rec.parent_ucode);
    begin
     PR_VALUES_PKG.INSERT_ROW
	                 ( X_CITY_ID      => v_rec.city_id
                     , X_UCODE        => v_rec.parent_ucode
                     , X_PROP_CLASS   => 'A'
                     , X_YEAR         => v_rec.year
                     , X_MIN_PRICE    => v_rec.class_a_min
                     , X_MAX_PRICE    => v_rec.max_price
                     , X_MEDIAN_PRICE => v_rec.class_a_median
                     , X_RENT         => null
					 , X_VACANCY_PERCENT => null
                     , X_REPLACEMENT  => null
                     , X_MAINTENANCE  => null
                     , X_MGT_PERCENT  => null
                     , X_CAP_RATE     => null 
                     , X_UTILITIES    => null);
					 
     PR_VALUES_PKG.INSERT_ROW
	                 ( X_CITY_ID      => v_rec.city_id
                     , X_UCODE        => v_rec.parent_ucode
                     , X_PROP_CLASS   => 'B'
                     , X_YEAR         => v_rec.year
                     , X_MIN_PRICE    => v_rec.class_c_max + 0.01
                     , X_MAX_PRICE    => v_rec.class_a_min - 0.01
                     , X_MEDIAN_PRICE => v_rec.class_b_median
                     , X_RENT         => null
					 , X_VACANCY_PERCENT => null
                     , X_REPLACEMENT  => null
                     , X_MAINTENANCE  => null
                     , X_MGT_PERCENT  => null
                     , X_CAP_RATE     => null 
                     , X_UTILITIES    => null);
					 
     PR_VALUES_PKG.INSERT_ROW
	                 ( X_CITY_ID      => v_rec.city_id
                     , X_UCODE        => v_rec.parent_ucode
                     , X_PROP_CLASS   => 'C'
                     , X_YEAR         => v_rec.year
                     , X_MIN_PRICE    => v_rec.min_price
                     , X_MAX_PRICE    => v_rec.class_c_max
                     , X_MEDIAN_PRICE => v_rec.class_c_median
                     , X_RENT         => null
					 , X_VACANCY_PERCENT => null
                     , X_REPLACEMENT  => null
                     , X_MAINTENANCE  => null
                     , X_MGT_PERCENT  => null
                     , X_CAP_RATE     => null 
                     , X_UTILITIES    => null);
	  commit;  				 
     exception when DUP_VAL_ON_INDEX then
	     dbms_output.put_line('skipped');
      when others then raise;
     end;
 
  end loop;	
end;
/					 