declare
  cursor cur_pums is
  select prop_id, puma, puma_percentile, rental_percentile
  from tmp_prop_pums
  order by prop_id;
begin
  for p_rec in cur_pums loop
    update pr_properties
    set puma              = p_rec.puma
    ,   puma_percentile   = p_rec.puma_percentile
    ,   rental_percentile = p_rec. rental_percentile
    where prop_id = p_rec.prop_id;
    commit;
  end loop;
end;
/
  
