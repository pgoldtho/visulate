declare 
  cursor cur_ucodes is
  select p.prop_id
  ,      b.total_bedrooms
  ,      b.total_bathrooms
  from pr_properties p
  ,     brd_beds b
  where b.source_pk = p.source_pk
  and p.source_id = 3;
begin
  for b_rec in cur_ucodes loop
    update pr_properties
    set total_bedrooms = b_rec.total_bedrooms
	,   total_bathrooms = b_rec.total_bathrooms
	where prop_id = b_rec.prop_id;
	
	commit;
  end loop;
end;
/