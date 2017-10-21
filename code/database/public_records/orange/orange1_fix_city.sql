declare
  cursor cur_prop is 
  select  rtrim(situs_street_number)||' '||
          rtrim(situs_street_name)||' '||
		  rtrim(situs_street_type)||' '||
		  rtrim(situs_street_direction)  site_address1
  ,       nvl(situs_city, 'ORLANDO') site_city
  ,       nvl(situs_zip, '32801') site_zipcode
  ,       parcel_number          source_pk
  ,       prop_id
  from orange_properties op
  ,    pr_properties     p
  where p.source_pk = op.parcel_number
  and rtrim(op.situs_city) != rtrim(p.city)
  and p.source_id = 5
  order by  parcel_number;
  
  v_prop_id  number;
  
begin
  for p_rec in cur_prop loop
  
	  begin
	    update pr_properties
	    set address1 = p_rec.site_address1
		,   city    = p_rec.site_city
	    ,   zipcode = p_rec.site_zipcode
	    where prop_id = p_rec.prop_id;
	  exception when others then
	    select prop_id into v_prop_id
		from pr_properties
		where address1 = p_rec.site_address1
		and   city    = p_rec.site_city
	    and   zipcode = p_rec.site_zipcode;
	     dbms_output.put_line(p_rec.prop_id||' '||p_rec.source_pk||' '||v_prop_id);
	  end;
     commit;
   
  end loop;
end;
/  