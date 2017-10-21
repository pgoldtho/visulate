declare

  cursor cur_north is
  select property_id
  from rnt_properties
  where business_id = 28
  and lower(city) in ('titusville', 'mims'); 

  cursor cur_central is
  select property_id
  from rnt_properties
  where business_id = 28
  and lower(city) in ('cocoa', 'rockledge', 'merritt island');

  cursor cur_melbourne is
  select property_id
  from rnt_properties
  where business_id = 28
  and lower(city) in ('melbourne', 'indian harbour beach');

  cursor cur_palm_south is
  select property_id
  from rnt_properties
  where business_id = 28
  and zipcode in (32909, 32908);


  v_business_id   RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE;

begin

  rnt_users_pkg.set_user(1);
  rnt_users_pkg.set_role('ADMIN');


  v_business_id := rnt_business_units_pkg.insert_row('Ring - North Brevard', 27);
  for c_rec in cur_north loop  
    rnt_properties_pkg.move(c_rec.property_id, 28, v_business_id);
  end loop;

  v_business_id := rnt_business_units_pkg.insert_row('Ring - Central Brevard', 27);
  for c_rec in cur_central loop  
    rnt_properties_pkg.move(c_rec.property_id, 28, v_business_id);
  end loop;

  v_business_id := rnt_business_units_pkg.insert_row('Ring - Melbourne', 27);
  for c_rec in cur_melbourne loop  
    rnt_properties_pkg.move(c_rec.property_id, 28, v_business_id);
  end loop;

  v_business_id := rnt_business_units_pkg.insert_row('Ring - Palm Bay South', 27);
  for c_rec in cur_palm_south loop  
    rnt_properties_pkg.move(c_rec.property_id, 28, v_business_id);
  end loop;

  update rnt_business_units
  set business_name = 'Ring - Palm Bay North'
  where business_id = 28;

  -- Update land value for Lake Washington
  update rnt_properties 
  set land_value = 600000
  where property_id = 1482;

  -- Move First Street to Sundore.
  rnt_properties_pkg.move(2021, 23, 43); 
 
end;
/