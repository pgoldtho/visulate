declare
  cursor cur_geo is
   select p.geo_location.sdo_point.x lat
   ,      p.geo_location.sdo_point.y lon
   ,      p.loc_id
   from pr_locations p
   where p.geo_location.sdo_point.x is not null;
begin
  for g_rec in cur_geo loop
    update pr_locations set
	geo_location = SDO_GEOMETRY(2001, 8307, 
       SDO_POINT_TYPE (g_rec.lon, g_rec.lat ,NULL), NULL, NULL)
	where loc_id = g_rec.loc_id;
	commit;
  end loop;
end;
/  