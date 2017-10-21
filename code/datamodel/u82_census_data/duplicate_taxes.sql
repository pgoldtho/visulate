declare
  cursor cur_millage is
  select id, county, millage
  from asc_millage_rates;

  cursor cur_duplicates(p_source in number) is
  select p.prop_id, count(*) counter
  from pr_properties p
  ,    asc_tax_values t
  where t.prop_id = p.prop_id
  and source_id = p_source
  group by p.prop_id having count(*) > 1;

  cursor cur_taxes(p_prop_id in number) is
  select t.tax_value
  ,      nvl(p.sq_ft, 1) sq_ft
  ,      nvl(p.acreage, 1) acreage
  from asc_tax_values t
  ,    pr_properties p
  where p.prop_id = p_prop_id
  and p.prop_id = t.prop_id;

  v_counter  pls_integer;
begin
  for m_rec in cur_millage loop
    dbms_output.put_line('** '||m_rec.county||' **');
    v_counter := 0;
    for d_rec in cur_duplicates(m_rec.id) loop
      v_counter := v_counter + 1;
      if v_counter < 10 then
        for t_rec in cur_taxes(d_rec.prop_id) loop
          dbms_output.put_line(d_rec.prop_id||' '||t_rec.tax_value
                     ||' => '||round(t_rec.tax_value * m_rec.millage/1000)
                     ||' ('||round(t_rec.tax_value/t_rec.sq_ft)||' per ft, '
                     ||round(t_rec.tax_value/t_rec.acreage)||' per acre)');
        end loop;
      end if;
    end loop;
  end loop;
end;
/
