declare

  cursor cur_prop is 
  select prop_id
  ,      source_pk
  from pr_properties p
  where source_pk is not null
  and source_id = 3
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
	 if v_ucode = 499 then v_ucode := 433; end if;
	 if v_ucode = 6 then v_ucode := 3; end if;
	 if v_ucode = 8020 then v_ucode := 3; end if;
	 if v_ucode = 8030 then v_ucode := 3; end if;
	 if v_ucode = 8040 then v_ucode := 3; end if;
	 if v_ucode = 8050 then v_ucode := 3; end if;
	 if v_ucode = 8060 then v_ucode := 3; end if;
	 if v_ucode = 8070 then v_ucode := 3; end if;
	 if v_ucode = 8080 then v_ucode := 3; end if;
	 if v_ucode = 8090 then v_ucode := 3; end if;
   end loop;

   if v_ucode is not null then
 dbms_output.put_line(v_ucode||' '||p_rec.prop_id);
     pr_records_pkg.insert_property_usage(v_ucode, p_rec.prop_id);
     commit;
   end if;
 
  end loop;

end;
/
