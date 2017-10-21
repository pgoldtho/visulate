declare
  cursor cur_prop is
  select po.owner_id
  ,      po.prop_id
  from pr_property_owners po
  ,    pr_properties p
  where p.prop_id = po.prop_id
  and p.source_id = 4
  order by prop_id;
  
  cursor cur_last_sale(p_prop_id in number) is
  select *
  from pr_property_sales
  where prop_id = p_prop_id
  and sale_date = (select max(sale_date)
                   from pr_property_sales
                   where prop_id = p_prop_id);
  
  
begin
 dbms_output.put_line('start');
  for p_rec in cur_prop loop
  dbms_output.put_line('prop '||p_rec.prop_id);
    update pr_property_sales 
	set new_owner_id = 898931
	where prop_id = p_rec.prop_id;
    for l_rec in cur_last_sale(p_rec.prop_id) loop
	   update pr_property_sales
	   set new_owner_id = p_rec.owner_id
	   where prop_id = p_rec.prop_id
	   and sale_date = l_rec.sale_date
	   and deed_code = l_rec.deed_code
	   and price = l_rec.price
	   and plat_book = l_rec.plat_book
	   and plat_page = l_rec.plat_page;
	end loop;
  end loop;
 end;
 /