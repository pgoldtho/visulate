declare
  cursor cur_prop is 
  select total_bedroom    
  ,      total_bath/100 total_bathrooms
  ,       prop_id
  from orange_properties op
  ,    pr_properties     p
  where p.source_pk = op.parcel_number
  and p.source_id = 5
  order by  parcel_number;
  
  v_prop_id  number;
  
begin
  for p_rec in cur_prop loop
  

	    update pr_properties
	    set TOTAL_BEDROOMS = p_rec.total_bedroom
        ,   TOTAL_BATHROOMS = p_rec.total_bathrooms
	    where prop_id = p_rec.prop_id;
     commit;
   
  end loop;
end;
/  