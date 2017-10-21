create table tmp_tax_values as
select pp.prop_id
          ,      p.jv  tax_value
          ,      round(p.jv * mr.millage/1000) tax_amount
          from pr_properties pp
          ,    pr_nal p
          ,    pr_millage_rates mr
          where (pp.source_pk = p.parcel_id or
                 pp.source_pk = p.alt_key)
          and pp.source_id = case when p.co_no = '15' then 3
                                  when p.co_no = '58' then 5
                                  when p.co_no = '74' then 4
                                  else to_number(p.co_no) end
          and mr.year = 2013
          and mr.id = pp.source_id;
          
create index tm_tax_values_pk on tmp_tax_values(prop_id);

declare
  cursor cur_duplicates is
  select prop_id
  ,      round(avg(tax_value)) tax_value
  ,      round(avg(tax_amount)) tax_amount
  ,      count(*) dcount
  from tmp_tax_values
  group by prop_id having count(*) > 1;
begin
  for d_rec in cur_duplicates loop
    delete from tmp_tax_values
    where prop_id = d_rec.prop_id;

    insert into tmp_tax_values
     (prop_id, tax_value, tax_amount)
    values
     (d_rec.prop_id, d_rec.tax_value, d_rec.tax_amount);
  end loop;
end;
/
