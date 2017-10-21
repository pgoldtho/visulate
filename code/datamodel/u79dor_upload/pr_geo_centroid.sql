declare
  cursor cur_geo is
  select id
  ,      MDSYS.SDO_GEOM.SDO_CENTROID(GEOM,0.5) center
  from pr_geo
  order by id;
begin
  for g_rec in cur_geo loop
    update pr_geo
    set    geom_point = g_rec.center
    where id = g_rec.id;
    
    commit;
  end loop;
end;
/  
 
