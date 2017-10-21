declare
  cursor cur_geo is
   select p.geo_location.sdo_point.x lat
   ,      p.geo_location.sdo_point.y lon
   ,      p.prop_id
   from pr_properties p;
begin
  for g_rec in cur_geo loop
    update pr_properties set
	geo_location = SDO_GEOMETRY(2001, 8307, 
       SDO_POINT_TYPE (g_rec.lon, g_rec.lat ,NULL), NULL, NULL)
	where prop_id = g_rec.prop_id;
	commit;
  end loop;
end;
/  