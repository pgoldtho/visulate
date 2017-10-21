declare

  cursor cur_prop is 
  select prop_id
  ,      source_pk
  from pr_properties p
  where source_pk is not null
  and source_id = 4
  and sq_ft is null;
  
  cursor cur_use(p_source_pk in pr_properties.source_pk%type) is
  select sum(sqft) sqft
  from vol_sqft
  where alt_key = p_source_pk;

  v_sq_ft   pr_properties.sq_ft%type;

begin

  for p_rec in cur_prop loop
   for u_rec in cur_use(p_rec.source_pk) loop
     v_sq_ft := u_rec.sqft;
   end loop;

   if v_sq_ft is not null then
     update pr_properties 
	 set sq_ft = v_sq_ft
	 where source_pk = p_rec.source_pk;
     commit;
   end if;
 
  end loop;

end;
/
