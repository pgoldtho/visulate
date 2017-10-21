declare 
  cursor get_sales is
  select ps.prop_id, ps.new_owner_id
  from pr_property_sales ps
  ,    pr_properties p
  ,    pr_owners o
  where o.owner_name = 'Not Recorded'
  and ps.new_owner_id = o.owner_id
  and ps.prop_id = p.prop_id
  and p.source_id != 4;
  
  v_count pls_integer := 0;

begin
  for s_rec in get_sales loop
    delete from pr_property_sales
	where prop_id = s_rec.prop_id
	and new_owner_id = s_rec.new_owner_id;
	
	v_count := v_count + 1;
  end loop;
  dbms_output.put_line(v_count || ' rows deleted');
end;
/  

