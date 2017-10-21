declare
  cursor cur_geo is
  select loc_id
  ,      latitude   lat
  ,      longitude  lon
  from pr_locations_geo
  where latitude != 0;
begin
  for g_rec in cur_geo loop
    update pr_properties set
	geo_location = SDO_GEOMETRY(2001, 8307, 
       SDO_POINT_TYPE (g_rec.lon, g_rec.lat ,NULL), NULL, NULL)
	where prop_id = g_rec.loc_id;
	commit;
  end loop;
end;
/    