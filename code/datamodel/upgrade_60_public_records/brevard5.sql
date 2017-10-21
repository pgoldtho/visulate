declare

  cursor cur_prop is 
  select prop_id
  ,      source_pk
  from pr_properties p
  where source_pk is not null
  and not exists (select 1 
                  from pr_property_usage pu
                  where pu.prop_id = p.prop_id);

  cursor cur_use(p_source_pk in pr_properties.source_pk%type) is
  select "UseCode" ucode
  from brd_properties
  where "TaxAcct" = p_source_pk;

  v_ucode   pr_property_usage.ucode%type;

begin

  for p_rec in cur_prop loop
   for u_rec in cur_use(p_rec.source_pk) loop
     v_ucode := u_rec.ucode;
   end loop;

   pr_records_pkg.insert_property_usage(v_ucode, p_rec.prop_id);
   commit;
 
  end loop;

end;
/
