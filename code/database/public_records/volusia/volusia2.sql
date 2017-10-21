declare

  cursor cur_prop is 
  select prop_id
  ,      source_pk
  from pr_properties p
  where source_pk is not null
  and source_id = 4;

  cursor cur_use(p_source_pk in pr_properties.source_pk%type) is
  select ucode
  from vol_properties
  where source_pk = p_source_pk;

  v_ucode     pr_property_usage.ucode%type;
  v_counter   pls_integer;

begin

  for p_rec in cur_prop loop
   for u_rec in cur_use(p_rec.source_pk) loop
     v_ucode := u_rec.ucode;
   end loop;
   
   select count(*) into v_counter
   from pr_property_usage pu
   where pu.prop_id = p_rec.prop_id;
   
   if v_counter = 0 then
     if v_ucode is not null then
       pr_records_pkg.insert_property_usage(v_ucode, p_rec.prop_id);
     end if;
   else
     if v_ucode is not null then
       update pr_property_usage
	   set ucode = v_ucode
	   where prop_id = p_rec.prop_id;
     end if;     
   end if;
   commit;
  end loop;

end;
/
