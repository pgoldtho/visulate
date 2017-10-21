 declare
   cursor cur_sales is
   select new_owner_id, sale_date, price, count(*) p_count
   from pr_property_sales ps
   ,    pr_properties p
   where price > 100000
   and p.prop_id = ps.prop_id
   and p.source_id = 3
   group by new_owner_id, sale_date, price
   having count(*) > 1;
   
   cursor cur_prop( p_new_owner_id in number
                  , p_sale_date    in date
				  , p_price        in number) is
	select p.prop_id
	,      p.sq_ft
	from pr_property_sales ps
	,    pr_properties p
	where ps.new_owner_id = p_new_owner_id
    and  ps.sale_date = p_sale_date
    and  ps.price = p_price
	and p.prop_id = ps.prop_id
	and p.sq_ft != 0;
	
	v_overpriced boolean;
	
begin
  for s_rec in cur_sales loop
    v_overpriced := false;
    for p_rec in cur_prop(s_rec.new_owner_id, s_rec.sale_date, s_rec.price) loop
	  if round(s_rec.price/nvl(p_rec.sq_ft, 1)) > 220 then
	    v_overpriced := true;
--	    dbms_output.put_line(s_rec.sale_date||' $'||s_rec.price||' - '||round(s_rec.price/nvl(p_rec.sq_ft, 1)));
	  end if;
	end loop;
  
    if v_overpriced then
      execute immediate
      'update pr_property_sales
       set price = '||round(s_rec.price/s_rec.p_count)||'
	   where new_owner_id = :1
       and  sale_date = :3
       and  price = :4'
	   using s_rec.new_owner_id, s_rec.sale_date, s_rec.price;
    end if;	
  end loop;

end;
/  
   