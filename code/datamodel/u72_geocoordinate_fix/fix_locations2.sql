declare
  cursor cur_geo is
   select loc_id
   from pr_locations p
   where p.geo_location.sdo_point.x is null;
begin
  for g_rec in cur_geo loop
    update pr_locations set
	geo_location = null
	where loc_id = g_rec.loc_id;
	commit;
  end loop;
end;
/  