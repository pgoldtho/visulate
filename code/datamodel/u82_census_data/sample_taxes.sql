declare
  cursor cur_millage is
  select id, county, millage
  from asc_millage_rates;

  cursor cur_duplicates(p_source in number) is
  select p.prop_id
  from pr_properties p
  ,    asc_tax_values t
  where t.prop_id = p.prop_id
  and source_id = p_source
  and rownum < 10;

  cursor cur_taxes(p_prop_id in number) is
  select tax_value
  from asc_tax_values
  where prop_id = p_prop_id;

  v_counter  pls_integer;
begin
  for m_rec in cur_millage loop
    dbms_output.put_line('** '||m_rec.county||' **');
    v_counter := 0;
    for d_rec in cur_duplicates(m_rec.id) loop
      v_counter := v_counter + 1;
      if v_counter < 6 then
        for t_rec in cur_taxes(d_rec.prop_id) loop
          dbms_output.put_line(d_rec.prop_id||' '||t_rec.tax_value
                     ||' => '||round(t_rec.tax_value * m_rec.millage/1000));
        end loop;
      end if;
    end loop;
  end loop;
end;
/
