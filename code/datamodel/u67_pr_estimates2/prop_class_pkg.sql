create or replace package prop_class_pkg as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011        All rights reserved worldwide
    Name:      PROP_CLASS_PKG
    Purpose:   Property class management.
*******************************************************************************/
  function get_prop_class( p_prop_id  in number
                         , p_year     in number
						 , p_price    in number ) 
						 return varchar2;
 procedure process_sales;
end prop_class_pkg; 
/
						 
create or replace package body prop_class_pkg as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011        All rights reserved worldwide
    Name:      PROP_CLASS_PKG
    Purpose:   Property class management.
*******************************************************************************/
  function get_prop_class( p_prop_id  in number
                         , p_year     in number
						 , p_price    in number ) 
						 return varchar2 is
    
	v_ucode         pr_usage_codes.ucode%type;
	v_price_sqft    number;
	v_prop          pr_properties%rowtype;
	v_return        varchar2(1);
	v_class4year    varchar2(1);
	v_count         pls_integer;
	
	cursor cur_prop_val( p_zipcode in rnt_city_zipcodes.zipcode%type
	                   , p_ucode   in pr_usage_codes.ucode%type
					   , p_year    in number
					   , p_price   in number) is
	  select v.prop_class
	  from pr_values v
	  ,    rnt_cities c
	  ,    rnt_city_zipcodes cz	  
	  where cz.zipcode = p_zipcode
	  and cz.city_id = c.city_id
	  and c.city_id = v.city_id
	  and v.year = p_year
	  and p_price > v.min_price
	  and p_price < v.max_price
	  and (v.ucode = p_ucode OR
	       v.ucode in( select parent_ucode
		             from pr_usage_codes uc
					 where uc.ucode = p_ucode))
	  order by v.prop_class;
	       

  begin 
    select ucode 
    into v_ucode
    from pr_property_usage 
    where prop_id = p_prop_id;	
	
	select *
	into v_prop
	from pr_properties
	where prop_id = p_prop_id;
	
	if (v_prop.sq_ft is null or  v_prop.sq_ft = 0) then
	  v_return := 'L';
	else
	  v_price_sqft := p_price/v_prop.sq_ft;
	  v_return := 'B';
	  for r_rec in cur_prop_val(v_prop.zipcode, v_ucode, p_year, v_price_sqft) loop
	      v_return := r_rec.prop_class;
	  end loop;
	end if;
	return v_return;
  end get_prop_class;
  
  procedure process_sales is 
  
    cursor cur_sales is
	select prop_id
	,      to_char(sale_date, 'yyyy') year
	,      price
	, PROP_CLASS_PKG.GET_PROP_CLASS(PROP_ID,TO_CHAR(SALE_DATE,'YYYY'),PRICE) prop_class
	from pr_property_sales
	where sale_date > '01-JAN-1995'
	and price > 200
	order by PROP_CLASS_PKG.GET_PROP_CLASS(PROP_ID,TO_CHAR(SALE_DATE,'YYYY'),PRICE);
	
	v_prop_class    varchar2(1);
  begin
    for s_rec in cur_sales loop
--	  v_prop_class := get_prop_class(s_rec.prop_id, s_rec.year, s_rec.price);
	  update pr_properties 
	  set prop_class = s_rec.prop_class
	  where prop_id = s_rec.prop_id;
	  commit;
	end loop;
  end process_sales;
end prop_class_pkg; 
/  
show errors package prop_class_pkg
show errors package body prop_class_pkg
	
	  
	  