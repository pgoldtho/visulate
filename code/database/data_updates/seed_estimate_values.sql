declare

  p_year  number(4) := 2011;
  
procedure seed_values is

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
and p.sq_ft > 200
and pu.ucode = uc.ucode
and  to_char(sale_Date, 'yyyy') = p_year
and (uc.ucode = 1 or
     uc.parent_ucode in (1, 2))
group by to_char(sale_Date, 'yyyy') 
  ,      uc.ucode
  ,      c.name
  ,      c.city_id
having count(*) > 8
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
and p.sq_ft > 0
and pu.ucode = uc.ucode
and  to_char(sale_Date, 'yyyy') = p_year
and uc.parent_ucode in (11, 12, 13, 14, 15, 17, 18, 19, 23, 24)
group by to_char(sale_Date, 'yyyy') 
  ,      uc.parent_ucode
  ,      c.name
  ,      c.city_id
having count(*) > 8
order by to_char(sale_Date, 'yyyy')
  ,      uc.parent_ucode
  ,      c.name
  ,      c.city_id  ;
  
  
  
begin
  for v_rec in cur_vals loop
    begin
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
	exception
	  when dup_val_on_index then null;
	  when others then raise;
	end;
  end loop;	
  for v_rec in cur_vals2 loop
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
	exception
	  when dup_val_on_index then null;
	  when others then raise;
	end;
	
  end loop;	
end seed_values;

procedure seed_factors is

begin
  update pr_values
  set rent = 19
  ,   cap_rate = 6.5
  where prop_class = 'A'
  and year = p_year;

  update pr_values
  set rent = 12
  ,   cap_rate = 8
  where prop_class = 'B'
  and year = p_year;

  update pr_values
  set rent = 7
  ,   cap_rate = 9.5
  where prop_class = 'C'
  and year = p_year;


  update pr_values
  set vacancy_percent = 8
  ,   mgt_percent = 10
  ,   rent = 10.4
  where prop_class = 'A'
  and ucode in (110, 121, 135, 414, 464, 465, 514)
  and year = p_year;

  update pr_values
  set vacancy_percent = 15
  ,   mgt_percent = 10
  ,   rent = 10.4
  where prop_class = 'B'
  and ucode in (110, 121, 135, 414, 464, 465, 514)
  and year = p_year;

  update pr_values
  set vacancy_percent = 25
  ,   mgt_percent = 10
  ,   rent = 10.4
  where prop_class = 'C'
  and ucode in (110, 121, 135, 414, 464, 465, 514)
  and year = p_year;


  update pr_values
  set vacancy_percent = 15
  ,   mgt_percent = 10
  where prop_class = 'A'
  and ucode < 100
  and year = p_year;

  update pr_values
  set vacancy_percent = 25
  ,   mgt_percent = 10
  where prop_class = 'B'
  and ucode < 100
  and year = p_year;

  update pr_values
  set vacancy_percent = 40
  ,   mgt_percent = 10
  where prop_class = 'C'
  and ucode < 100
  and year = p_year;

  update pr_values
  set maintenance = 0.52
  ,   replacement = 0.97
  where year = p_year;
  
  update pr_values
  set mgt_percent = 4
  where year = p_year
  and ucode in (12, 13, 14, 15)
  and prop_class = 'A';

  update pr_values
  set mgt_percent = 4
  where year = p_year
  and ucode in (12, 13, 14, 15)
  and prop_class = 'B';

  update pr_values
  set mgt_percent = 6
  where year = p_year
  and ucode in (12, 13, 14, 15)
  and prop_class = 'C';
  

end seed_factors;

begin
  seed_values;
  seed_factors;
end;  
/					 
