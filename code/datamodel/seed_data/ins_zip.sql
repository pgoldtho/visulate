declare

  cursor get_zip is
  select zip_code
  ,      city
  ,      state
  ,      county
  from zipcodes;


  v_zipcode       number(5);
  v_city          varchar2(35);
  v_state         varchar2(2);
  v_county        varchar2(25);
  v_city_id       number;
  v_count         number;


begin

 for z_rec in get_zip loop
  v_zipcode := z_rec.zip_code;
  v_city    := z_rec.city;
  v_state   := z_rec.state;
  v_county  := z_rec.county;

  select count(*)
  into v_count
  from rnt_cities
  where name = v_city
  and county = v_county
  and state  = v_state;

  if v_count = 0 then
    insert into rnt_cities (city_id, name, county, state)
    values (rnt_cities_seq.nextval, v_city, v_county, v_state)
    returning city_id into v_city_id;
  else
    select city_id
    into v_city_id
    from rnt_cities
    where name = v_city
    and county = v_county
    and state  = v_state;
  end if;

  select count(*)
  into v_count
  from rnt_zipcodes
  where zipcode = v_zipcode;

  if v_count = 0 then
    insert into rnt_zipcodes(zipcode)
    values (v_zipcode);
  end if;

  select count(*)
  into v_count
  from rnt_city_zipcodes
  where city_id = v_city_id
  and zipcode = v_zipcode;

  if v_count = 0 then
    insert into rnt_city_zipcodes (city_id, zipcode)
    values (v_city_id, v_zipcode);
  end if;
  commit;
 end loop;
end;
/
