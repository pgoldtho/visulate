declare
/*
Sets the current owner in pr_property_owners and pr_property_sales
Removes duplicate sales records from pr_property_sales if 2 records 
have been recorded for most recent sale.
*/
  cursor cur_prop is 
   select v.mail_address1
   ,      v.mail_address2
   ,      v.mail_city
   ,      substr(v.mail_zipcode, 1, 5) mail_zipcode
   ,      v.owner_name    owner
   ,      prop_id
   from vol_properties v
   ,    pr_properties  p
   where v.source_pk = p.source_pk 
   and p.source_id  = 4
   and v.owner_name is not null;
 
  v_mail_id         number;
  v_owner_id        number;
  v_date            date;
  
  c1  pls_integer := 0;
  c2  pls_integer := 0;
begin
  for p_rec in cur_prop loop
    begin
      select prop_id into v_mail_id
	  from pr_properties
	  where address1 = p_rec.mail_address1
	  and nvl(address2, ' ') = nvl(p_rec.mail_address2, ' ')
	  and city = p_rec.mail_city
	  and zipcode = p_rec.mail_zipcode;
	exception
	  when no_data_found then
	    v_mail_id := p_rec.prop_id;
	  when others then raise;
	end;
	
	begin
	  select owner_id into v_owner_id
	  from pr_owners
	  where owner_name = p_rec.owner
	  and rownum < 2;
	exception
	  when no_data_found then
        v_owner_id := pr_records_pkg.insert_owner
                      ( x_owner_name => p_rec.owner
                      , x_owner_type => '');
	  when others then raise;
	end;
	
    select count(*) into c1
    from pr_property_owners
    where prop_id = p_rec.prop_id;

    if c1 = 0 then
         pr_records_pkg.insert_property_owner
             ( x_owner_id   => v_owner_id
             , x_prop_id    => p_rec.prop_id
             , x_mailing_id => v_mail_id);
    elsif c1 = 1 then
	  update pr_property_owners
	  set owner_id = v_owner_id
	  ,   mailing_id = v_mail_id
	  where prop_id = p_rec.prop_id;
	else 
	   delete from pr_property_owners
	   where prop_id = p_rec.prop_id;
	   
	   pr_records_pkg.insert_property_owner
             ( x_owner_id   => v_owner_id
             , x_prop_id    => p_rec.prop_id
             , x_mailing_id => v_mail_id);
    end if;
	
	begin
	  select max(sale_date) into v_date
	  from pr_property_sales
	  where prop_id = p_rec.prop_id;
	  
	  update pr_property_sales
	  set new_owner_id = v_owner_id
	  where prop_id = p_rec.prop_id
	  and sale_date = v_date;
	exception
	  when no_data_found then
	    null;
	  when DUP_VAL_ON_INDEX then
	    delete from pr_property_sales
		where prop_id = p_rec.prop_id
		and new_owner_id = 898931
		and sale_date = v_date;
	  when others then raise;
	end;
	commit;
  end loop;

end;
/