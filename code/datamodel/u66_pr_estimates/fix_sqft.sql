declare
  cursor cur_prop is
   select prop_id
   from pr_properties p
   where p.sq_ft < (select sum(sq_ft)
                    from pr_buildings b
                    where b.prop_id = p.prop_id);
					
    v_sq_ft     number;
begin
  for p_rec in cur_prop loop
    select sum(sq_ft)
	into v_sq_ft
    from pr_buildings b
    where b.prop_id = p_rec.prop_id;
	
	update pr_properties
	set sq_ft = v_sq_ft
	where prop_id = p_rec.prop_id;
  end loop;  
end;
/  