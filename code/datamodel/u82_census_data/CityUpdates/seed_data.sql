declare
  cursor cur_states is
  select distinct state
  from rnt_cities
  order by state;

  cursor cur_counties is
  select distinct state, county
  from rnt_cities
  where county != 'ANY'
  order by state, county;
  
  v_city_id  rnt_cities.city_id%type;
begin
  for s_rec in cur_states loop
    v_city_id := rnt_cities_pkg.insert_row
                     ( X_NAME         => 'ANY'
                     , X_COUNTY       => 'ANY'
                     , X_STATE        => s_rec.state
                     , X_DESCRIPTION  => null);
  end loop;
  
  for c_rec in cur_counties loop
    v_city_id := rnt_cities_pkg.insert_row
                     ( X_NAME         => 'ANY'
                     , X_COUNTY       => c_rec.county
                     , X_STATE        => c_rec.state
                     , X_DESCRIPTION  => null);
  end loop;
end;
/
  