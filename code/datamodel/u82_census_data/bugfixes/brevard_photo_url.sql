declare
  cursor cur_photo is
  select pp.prop_id
  ,      url
  ,      replace(url, 'brevardpropertyappraiser.com', 'bcpao.us') new_url
  from pr_properties p
  ,    pr_property_photos pp
  where p.prop_id = pp.prop_id
  and p.source_id = 3;
begin
  for t_rec in cur_photo loop
    update pr_property_photos
    set url = t_rec.new_url
    where prop_id = t_rec.prop_id
    and url = t_rec.url;
    commit;    
  end loop;
end;
/
  