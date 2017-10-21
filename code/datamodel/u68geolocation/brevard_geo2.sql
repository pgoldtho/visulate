declare
  cursor cur_geo is
  select  to_char(RENUM) renum, LONGITUDE, LATITUDE
  from brvd_geo;
begin
  for g_rec in cur_geo loop
    update pr_properties set
	geo_location = SDO_GEOMETRY(2001, 8307, 
       SDO_POINT_TYPE (g_rec.LONGITUDE, g_rec.LATITUDE ,NULL), NULL, NULL)
	where source_pk = g_rec.RENUM 
	and source_id = 3;
	commit;
  end loop;
end;
/  
	
