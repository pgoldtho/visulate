declare
  cursor cur_sales is
  select prop_id
  ,      max(sale_date) sale_date
  from pr_property_sales ps
  where ps.sale_date > '01-JAN-2011'
  group by prop_id
  order by prop_id;
  
  v_owner_id    pr_owners.owner_id%type;
  v_counter     pls_integer;
  v_plat_page   pr_property_sales.plat_page%type;
 begin
   for p_rec in cur_sales loop
     select count(*)
	 into v_counter
	 from pr_property_owners
	 where prop_id = p_rec.prop_id;
	 
	 select max(plat_page)
	 into v_plat_page
	 from pr_property_sales
	 where prop_id = p_rec.prop_id
	 and sale_date = p_rec.sale_date;
	 
--	 dbms_output.put_line( p_rec.prop_id||' '||p_rec.sale_date||' '||v_plat_page);
	 select new_owner_id
	 into v_owner_id
	 from pr_property_sales
	 where prop_id = p_rec.prop_id
	 and sale_date = p_rec.sale_date
	 and nvl(plat_page, 1) = nvl(v_plat_page, 1)
	 and rownum < 2;
    begin
	  if v_counter = 0 then
	    insert into pr_property_owners (owner_id, prop_id)
	    values (v_owner_id, p_rec.prop_id);
	  else
	    update pr_property_owners
	    set owner_id = v_owner_id
	    where prop_id = p_rec.prop_id;
	  end if;
	exception
	  when DUP_VAL_ON_INDEX then null;
	  when others then raise;
	end;
   end loop;
 end;
 /
   