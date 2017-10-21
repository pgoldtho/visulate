declare
  cursor cur_duplicates is 
  select  pr_records_pkg.standard_suffix(address1) address1
  ,       address2
  ,       zipcode
  from pr_properties p
  group by pr_records_pkg.standard_suffix(address1)
  ,       address2
  ,       zipcode
  having count(*) > 1;

  v_primary_id    number;
  v_secondary_id  number;
  v_count         pls_integer := 0;
begin  
  for d_rec in cur_duplicates loop
  
    begin 
      select prop_id
	  into v_primary_id
	  from pr_properties p
      where exists (select 1 from pr_property_usage pu where p.prop_id = pu.prop_id)
	  and pr_records_pkg.standard_suffix(address1) = d_rec.address1
      and nvl(address2, 'x') = nvl(d_rec.address2, 'x')
      and zipcode = d_rec.zipcode
	  and rownum < 2;
	exception 
	  when no_data_found then 
	    v_primary_id := '';
    end;

    begin 
      select prop_id
	  into v_secondary_id
	  from pr_properties p
      where not exists (select 1 from pr_property_usage pu where p.prop_id = pu.prop_id)
	  and pr_records_pkg.standard_suffix(address1) = d_rec.address1
      and nvl(address2, 'x') = nvl(d_rec.address2, 'x')
      and zipcode = d_rec.zipcode
	  and rownum < 2;
	exception 
	  when no_data_found then 
	    v_secondary_id := '';
    end;

--	dbms_output.put_line('------------'||v_primary_id||' -> '||v_secondary_id);
	
	if v_primary_id is not null and
	   v_secondary_id is not null then
	   
	   v_count := v_count + 1;
	   update pr_property_owners 
	   set prop_id = v_primary_id
	   where prop_id = v_secondary_id;

	   update pr_property_owners 
	   set mailing_id = v_primary_id
	   where mailing_id = v_secondary_id;
    

	update pr_property_links 
	   set prop_id = v_primary_id
	   where prop_id = v_secondary_id;

   	   update pr_property_sales 
	   set prop_id = v_primary_id
	   where prop_id = v_secondary_id;

	   update pr_taxes
	   set prop_id = v_primary_id
	   where prop_id = v_secondary_id;
	   
	   commit;

	   delete from pr_properties 
	   where prop_id = v_secondary_id;
	   
	   commit;
	end if;
	
  end loop;	
  dbms_output.put_line('Updated '||v_count||' rows');
end;
/