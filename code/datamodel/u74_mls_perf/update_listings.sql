declare
  cursor cur_geo_locations is
  select m.mls_id
  ,      p.geo_location
  from mls_listings m
  ,    pr_properties p
  where p.prop_id = m.prop_id;
begin
  for l_rec in cur_geo_locations loop
    update mls_listings
	set geo_location = l_rec.geo_location
	where mls_id = l_rec.mls_id;
	commit;
  end loop;
end;
/