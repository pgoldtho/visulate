declare

  function get_nearest( p_prop_id in number
                      , p_target  in number) return number is

    cursor cur_taxes(p_prop_id in number) is
    select t.tax_value
    ,      nvl(p.sq_ft, 1) sq_ft
    ,      nvl(p.acreage, 1) acreage
    from asc_tax_values t
    ,    pr_properties p
    where p.prop_id = p_prop_id
    and p.prop_id = t.prop_id;

    v_return       number := 0;
    v_dev1         number := 999999999999;
    v_dev2         number;
    v_price_per_ft number;
    
  begin
    for t_rec in cur_taxes(p_prop_id) loop
    /*
      dbms_output.put_line(p_prop_id||' '||t_rec.tax_value
                     ||' ('||round(t_rec.tax_value/t_rec.sq_ft)||' per ft, '
                     ||round(t_rec.tax_value/t_rec.acreage)||' per acre)');
    */
      if t_rec.sq_ft > 1 then
        v_price_per_ft := t_rec.tax_value/t_rec.sq_ft;
        v_dev2 := abs(p_target - v_price_per_ft);
        if (v_dev2 < v_dev1 and v_price_per_ft > 15) then
          v_dev1 := v_dev2;
          v_return := t_rec.tax_value;
        end if;
      else
--        dbms_output.put_line(to_char(t_rec.acreage, '999.99')|| ' acres');
        if t_rec.acreage < 2 then
          v_dev2 := abs(5000 - (t_rec.tax_value/t_rec.acreage));
        else
          v_dev2 := abs(1200 - (t_rec.tax_value/t_rec.acreage));
        end if;
        if v_dev2 < v_dev1 then
          v_dev1 := v_dev2;
          v_return := t_rec.tax_value;
        end if;
      end if;
    end loop;
    return v_return;
  end get_nearest;


  procedure rm_duplicates( p_county in varchar2
                         , p_target in number) is

    cursor cur_millage(p_county in varchar2) is
    select id, county, millage
    from asc_millage_rates
    where county = p_county;

    cursor cur_duplicates(p_source in number) is
    select p.prop_id, count(*) counter
    from pr_properties p
    ,    asc_tax_values t
    where t.prop_id = p.prop_id
    and source_id = p_source
    group by p.prop_id having count(*) > 1;

    v_counter  pls_integer;
    v_keep     number;
  begin
    for m_rec in cur_millage(p_county) loop
      dbms_output.put_line('** '||m_rec.county||' **');
      v_counter := 0;
      for d_rec in cur_duplicates(m_rec.id) loop
        v_counter := v_counter + 1;
--        if v_counter < 50 then
          v_keep := get_nearest(d_rec.prop_id, p_target);
          dbms_output.put_line(d_rec.prop_id||' Selected '||v_keep);
          if v_keep = 0 then
            select tax_value
            into v_keep
            from asc_tax_values
            where prop_id = d_rec.prop_id
            and rownum =1;
          end if;
          
          if v_keep != 0 then 
            delete from asc_tax_values
            where prop_id = d_rec.prop_id
            and tax_value != v_keep;
            commit;
          end if;          
--        end if;
      end loop;
    end loop;
  end rm_duplicates;

begin
  rm_duplicates('Levy', 31);
  rm_duplicates('Manatee', 55);
  rm_duplicates('Nassau', 55);
  rm_duplicates('Okaloosa', 67);
  rm_duplicates('Saint Johns', 60);
end;
/
