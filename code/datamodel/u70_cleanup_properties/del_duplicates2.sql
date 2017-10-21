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
  
  cursor cur_usage( p_address1 in varchar2
                  , p_address2 in varchar2
                  , p_zipcode in varchar2) is  
      select prop_id
	  from pr_properties p
      where exists (select 1 from pr_property_usage pu where p.prop_id = pu.prop_id)
	  and pr_records_pkg.standard_suffix(address1) = p_address1
      and nvl(address2, 'x') = nvl(p_address2, 'x')
      and zipcode = p_zipcode;

  v_primary_id    number;
  v_secondary_id  number;
  v_count         pls_integer := 0;
begin  
  for d_rec in cur_duplicates loop
    v_primary_id := null;
	v_secondary_id := null;
    for u_rec in cur_usage(d_rec.address1, d_rec.address2, d_rec.zipcode) loop
	  if v_primary_id is null then
	     v_primary_id := u_rec.prop_id;
	  else
	     v_secondary_id := u_rec.prop_id;
	  end if;
	end loop;   

--	dbms_output.put_line('------------'||v_primary_id||' -> '||v_secondary_id);
	
	if v_primary_id is not null and
	   v_secondary_id is not null then
	   
	   v_count := v_count + 1;
	   begin
	     update pr_property_owners 
	     set prop_id = v_primary_id
	     where prop_id = v_secondary_id;
	   exception
	     when DUP_VAL_ON_INDEX then
           delete from pr_property_owners
           where prop_id = v_secondary_id;
	   end;

	   update pr_property_owners 
	   set mailing_id = v_primary_id
	   where mailing_id = v_secondary_id;
    

	   update pr_property_links 
	   set prop_id = v_primary_id
	   where prop_id = v_secondary_id;
	   
	   update pr_property_photos 
	   set prop_id = v_primary_id
	   where prop_id = v_secondary_id;
	   
	   begin
	     update pr_buildings 
	     set prop_id = v_primary_id
	   where prop_id = v_secondary_id;
	    exception
	     when DUP_VAL_ON_INDEX then
		   delete from pr_building_usage
		   where building_id in 
		     (select building_id
			  from pr_buildings
		      where prop_id = v_secondary_id);
		  
		  delete from pr_building_features
		   where building_id in 
		     (select building_id
			  from pr_buildings
		      where prop_id = v_secondary_id);
		 
           delete from pr_buildings
           where prop_id = v_secondary_id;
	   end;
	   
       begin
   	     update pr_property_sales 
	     set prop_id = v_primary_id
	     where prop_id = v_secondary_id;
	   exception
	     when DUP_VAL_ON_INDEX then
           delete from pr_property_sales
           where prop_id = v_secondary_id;
	   end;

	   begin
	     update pr_taxes
	     set prop_id = v_primary_id
	     where prop_id = v_secondary_id;
   	   exception
	     when DUP_VAL_ON_INDEX then
           delete from pr_taxes
           where prop_id = v_secondary_id;
	   end;

	   
	   commit;

   	   delete from pr_property_usage 
	   where prop_id = v_secondary_id;

	   delete from pr_properties 
	   where prop_id = v_secondary_id;
	   
	   commit;
	end if;
	
  end loop;	
  dbms_output.put_line('Updated '||v_count||' rows');
end;
/