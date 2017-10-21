declare
  cursor cur_geo is
  select  prop_id, LONGITUDE, LATITUDE
  from PR_PROPERTIES_GEO;
begin
  for g_rec in cur_geo loop
    update pr_properties p set
	geo_location = SDO_GEOMETRY(2001, 8307, 
       SDO_POINT_TYPE (g_rec.LATITUDE, g_rec.LONGITUDE ,NULL), NULL, NULL)
	where p.prop_id = g_rec.prop_id
	and p.geo_location is null;
	commit;
  end loop;
end;
/  
	
