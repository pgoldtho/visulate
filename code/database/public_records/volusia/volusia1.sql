set define '^'
declare
  cursor cur_property is
  select v.source_pk
  ,      v.owner_name
  ,      v.address1
  ,      v.address2
  ,      v.city
  ,      v.zipcode
  ,      v.mail_address1
  ,      v.mail_address2
  ,      v.mail_city
  ,      substr(v.mail_zipcode, 1, 5) mail_zipcode
  ,      v.total_bedrooms
  ,      v.total_bathrooms
  ,      prop_id
  from vol_properties v
  ,    pr_properties  p
  where v.source_pk = p.source_pk (+)
  and p.source_id (+) = 4
  and v.address1 is not null;


  v_source_id         PR_SOURCES.SOURCE_ID%TYPE;
  v_prop_id           PR_PROPERTIES.PROP_ID%TYPE;
  v_mail_id           PR_PROPERTIES.PROP_ID%TYPE;
  v_owner_id          PR_OWNERS.OWNER_ID%type;
  v_address2          pr_properties.address2%type;
  v_counter           pls_integer;
  v_city              pr_properties.city%type;

  
  function get_state(p_zipcode in varchar2) return varchar2 is
    v_return varchar2(2);
  begin
    dbms_output.put_line(p_zipcode);
    select distinct c.state
	into v_return
	from rnt_city_zipcodes z
	,    rnt_cities c
	where c.city_id = z.city_id
	and z.zipcode = p_zipcode;
	
	return v_return;
	
  exception
    when no_data_found then return 'XX';
	when others then return 'XX';
  end get_state;
  
  function get_city(p_zipcode in varchar2) return varchar2 is
    v_return varchar2(60);
  begin
    select distinct c.name
	into v_return
	from rnt_city_zipcodes z
	,    rnt_cities c
	where c.city_id = z.city_id
	and z.zipcode = p_zipcode;
	
	return v_return;
  end get_city;  
  
begin

  v_source_id := 4;
                                             
  for p_rec in cur_property loop  
       


-- dbms_output.put_line('prop_id='||v_mail_id);

   if p_rec.prop_id is not null then
      v_prop_id := p_rec.prop_id;
      update pr_properties 
      set total_bedrooms  = p_rec.total_bedrooms
	   ,  total_bathrooms = p_rec.total_bathrooms
       where prop_id = v_prop_id;
   else
     if p_rec.address1 != '0' then
 
       if p_rec.address2 is not null then
          v_address2 := p_rec.address2;
       else
          v_address2 := '';
       end if;
	   
	   if p_rec.city is not null then
	     v_city := p_rec.city;
	   else
	     v_city := get_city(p_rec.zipcode);
	   end if;
	 end if;
    begin
       v_prop_id := PR_RECORDS_PKG.insert_property
          ( X_SOURCE_ID => v_source_id
          , X_SOURCE_PK => p_rec.source_pk
          , X_ADDRESS1  => p_rec.address1
          , X_ADDRESS2  => v_address2
          , X_CITY      => v_city
          , X_STATE     => 'FL'
          , X_ZIPCODE   => p_rec.zipcode
          , X_ACREAGE   => null
          , X_SQ_FT     => null
		  , x_total_bedrooms  => p_rec.total_bedrooms
		  , x_total_bathrooms => p_rec.total_bathrooms);
	exception
	   when DUP_VAL_ON_INDEX then
          v_prop_id := PR_RECORDS_PKG.get_prop_id
          ( X_ADDRESS1  => p_rec.address1
          , X_ADDRESS2  => p_rec.address2
          , x_ZIPCODE   => p_rec.zipcode);

		  update pr_properties 
          set source_pk = p_rec.source_pk
	      ,   total_bedrooms  = p_rec.total_bedrooms
	      ,   total_bathrooms = p_rec.total_bathrooms
          where prop_id = v_prop_id;
      when others then raise;
     end;
 
    v_mail_id := null;
	if p_Rec.mail_address1 is not null then
     begin 
      v_mail_id := PR_RECORDS_PKG.insert_property
          ( X_SOURCE_ID => v_source_id
          , X_SOURCE_PK => null
          , X_ADDRESS1  => p_rec.mail_address1
          , X_ADDRESS2  => p_rec.mail_address2
          , X_CITY      => nvl(p_rec.mail_city, 'XXXXX')
          , X_STATE     => nvl(get_state(p_rec.mail_zipcode), 'XX')
          , X_ZIPCODE   => nvl(p_rec.mail_zipcode, 'XXXXX')
          , X_ACREAGE   => null
          , X_SQ_FT     => null);
	 exception
	   when DUP_VAL_ON_INDEX then
       v_mail_id := PR_RECORDS_PKG.get_prop_id
          ( X_ADDRESS1  => p_rec.mail_address1
          , X_ADDRESS2  => p_rec.mail_address2
          , x_ZIPCODE   => p_rec.mail_zipcode);
     end;
	end if;

     if v_mail_id is null then
       v_mail_id := v_prop_id;
	 end if;

	 
     if p_rec.owner_name is not null then
       v_owner_id := pr_records_pkg.get_owner_id(p_rec.owner_name, v_mail_id);

       if v_owner_id is null then
          v_owner_id := pr_records_pkg.insert_owner
                      ( x_owner_name => p_rec.owner_name
                      , x_owner_type => '');
       end if;

       select count(*)
       into v_counter
       from pr_property_owners
       where owner_id = v_owner_id
       and   prop_id = v_prop_id;

       if v_counter = 0 and v_prop_id is not null then
         pr_records_pkg.insert_property_owner
             ( x_owner_id   => v_owner_id
             , x_prop_id    => v_prop_id
             , x_mailing_id => v_mail_id);
--       else
--         dbms_output.put_line('found dup');
       end if;
     end if;
     commit;
    end if;
  end loop;
end;
/     