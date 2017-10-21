declare
  cursor cur_cz is
  select city_id
  ,      zipcode
  from rnt_city_zipcodes;
begin
  for c_rec in cur_cz loop
   insert into pr_city_zipcodes (city_id, zipcode)
   values (c_rec.city_id, c_rec.zipcode);
   commit;
  end loop;
end;
/   