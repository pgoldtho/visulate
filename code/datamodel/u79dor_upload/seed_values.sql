declare
 p_acap  number := 6.75;
 p_bcap  number := 8;
 p_ccap  number := 9.75;
 p_ins   number := 0.97;
 p_maint number := 0.52;
 p_vaca  number := 12.5;
 p_vacb  number := 22.5;
 p_vacc  number := 38;
 p_mgt1  number := 4;
 p_mgt2  number := 6;
 p_mgt3  number := 10;
 p_year  number := 2013;

 procedure set_ucode_summary is  
    cursor cur_summary is
    select c.city_id
    ,      u.ucode
    ,      sum(u.property_count) property_count
    ,      sum(u.total_area)     total_area
    from rnt_cities c
    ,    pr_ucode_summary_mv u
    ,    rnt_city_zipcodes cz
    where  c.city_id = cz.city_id
    and cz.zipcode = u.zipcode
    and u.ucode != 90990
    group by c.city_id, u.ucode
    order by c.city_id, u.ucode;
    
    v_count  pls_integer;
    v_ucode  pr_usage_codes.ucode%type;
  begin
    for s_rec in cur_summary loop
      
      select count(*) into v_count
      from pr_ucode_data
      where city_id = s_rec.city_id
      and ucode = s_rec.ucode;
      
      if v_count = 0 then
      /*
        dbms_output.put_line('City: '||s_rec.city_id
                           ||'Ucode: '||s_rec.ucode
                           ||'Count: '||s_rec.property_count
                           ||'Area: '||nvl(s_rec.total_area, 0));
                           */
        insert into pr_ucode_data
          (city_id, ucode, property_count, total_sqft)
        values
          (s_rec.city_id, s_rec.ucode, s_rec.property_count, nvl(s_rec.total_area, 0));
      else
        update pr_ucode_data
        set property_count = s_rec.property_count
        ,   total_sqft     = nvl(s_rec.total_area, 0)
        where
        city_id = s_rec.city_id
        and ucode = s_rec.ucode;
      
      end if;
    end loop;
  end set_ucode_summary;
  
  function parent_ucode(p_ucode in pr_usage_codes.ucode%type)
    return pr_usage_codes.ucode%type is
    v_return  pr_usage_codes.ucode%type;
  begin
    select parent_ucode
    into v_return
    from pr_usage_codes
    where ucode = p_ucode;
    
    return v_return;
  end parent_ucode;

  function get_rent( p_price   in number
                   , p_class   in varchar2
                   , p_millage in number) return number is
    v_noi     number;
    v_cap     number;
    v_pct     number;
    v_rent    number;
    v_tax     number;
    v_exp     number;
  begin
    if p_class = 'A' then
      v_cap := p_acap;
      v_pct := p_mgt1 + p_vaca;
    elsif p_class = 'C' then
      v_cap := p_ccap;
      v_pct := p_mgt2 + p_vacc;
    else
      v_cap := p_bcap;
      v_pct := p_mgt1 + p_vacb;
    end if;
    
    v_tax := p_price * p_millage/1000;
    v_noi := p_price * v_cap/100;
    v_exp := v_tax + p_maint + p_ins;
    v_rent := ((v_noi + v_exp) * 100)/(100 - v_pct);
    
    return v_rent;
  end get_rent;
  
  procedure set_value_estimates is   
  
    cursor cur_city_values is
    select m.city_id, ucode, sale_yr
    ,       a_max
    ,       a_median
    ,       a_min
    ,       b_median
    ,       c_max
    ,       c_median
    ,       c_min
    ,       sales_count
    from pr_city_summary_mv m
    ,    rnt_cities c
    where c.city_id = m.city_id
    and c.state = 'FL'
    and sales_count > 0
    order by m.city_id, ucode, sale_yr;
    


    cursor cur_county_values( p_city     in number
                            , p_ucode    in number
                            , p_sale_yr  in number) is
    select  a_max
    ,       a_median
    ,       a_min
    ,       b_median
    ,       c_max
    ,       c_median
    ,       c_min
    ,       sales_count
    from rnt_cities c
    ,    pr_county_summary_mv n
    where c.city_id = p_city
    and n.ucode  = p_ucode
    and n.sale_yr = p_sale_yr
    and n.state = c.state
    and n.county = c.county;

    type v_values_type is record
      ( min_price    number
      , max_price    number
      , median_price number
      , rent         number
      , replacement  number
      , maintenance  number
      , mgt_percent  number
      , cap_rate     number
      , vacancy_pct  number
      , utilities    number );
    type v_values_tab is table of v_values_type 
      index by varchar2(1);
      
    v_values        v_values_tab;
    v_parent_ucode  pr_usage_codes.ucode%type;
    v_ucode         pr_usage_codes.ucode%type;
    v_millage       number;
    v_rent_rate     number;
    v_counter       pls_integer;
  begin
    
    for v_rec in cur_city_values loop
      begin
      select millage, rent_rate
      into v_millage, v_rent_rate
      from pr_millage_rates r
      ,    rnt_cities c
      where c.county = upper(r.county)
      and c.city_id = v_rec.city_id
      and c.state = 'FL'
      and year = p_year;
      exception when no_data_found then
        dbms_output.put_line('city = '||v_rec.city_id);
        when others then raise;
     end;
    
      v_ucode := v_rec.ucode;
      v_parent_ucode := parent_ucode(v_ucode);
      
      if v_rec.sales_count < 16 then 
        for c_rec in cur_county_values(v_rec.city_id, v_rec.ucode, v_rec.sale_yr) loop
          v_values('A').min_price := c_rec.a_min;
          v_values('B').min_price := c_rec.c_max + 0.01;
          v_values('C').min_price := c_rec.c_min;

          v_values('A').median_price := c_rec.a_median;
          v_values('B').median_price := c_rec.b_median;
          v_values('C').median_price := c_rec.c_median;
       
          v_values('A').max_price := c_rec.a_max;
          v_values('B').max_price := c_rec.a_min - 0.01;
          v_values('C').max_price := c_rec.c_max;
        
        end loop;
      else
        v_values('A').min_price := v_rec.a_min;
        v_values('B').min_price := v_rec.c_max + 0.01;
        v_values('C').min_price := v_rec.c_min;

        v_values('A').median_price := v_rec.a_median;
        v_values('B').median_price := v_rec.b_median;
        v_values('C').median_price := v_rec.c_median;
       
        v_values('A').max_price := v_rec.a_max;
        v_values('B').max_price := v_rec.a_min - 0.01;
        v_values('C').max_price := v_rec.c_max;
        
      end if;
      if v_parent_ucode = 3 then -- land
        v_values('A').rent        := 0; 
        v_values('A').replacement := 0;
        v_values('A').maintenance := 0;
        v_values('A').mgt_percent := 0;
        v_values('A').cap_rate    := 0;
        v_values('A').vacancy_pct := 0;
        v_values('A').utilities   := 0;
        v_values('B').rent        := 0; 
        v_values('B').replacement := 0;
        v_values('B').maintenance := 0;
        v_values('B').mgt_percent := 0;
        v_values('B').cap_rate    := 0;
        v_values('B').vacancy_pct := 0;
        v_values('B').utilities   := 0;
        v_values('C').rent        := 0; 
        v_values('C').replacement := 0;
        v_values('C').maintenance := 0;
        v_values('C').mgt_percent := 0;
        v_values('C').cap_rate    := 0;
        v_values('C').vacancy_pct := 0;
        v_values('C').utilities   := 0;
      elsif v_parent_ucode in (91000, 1) then -- residential
        v_values('A').rent        := v_rent_rate; 
        v_values('A').replacement := p_ins;
        v_values('A').maintenance := p_maint;
        v_values('A').mgt_percent := p_mgt3;
        v_values('A').cap_rate    := p_acap;
        v_values('A').vacancy_pct := p_vaca;
        v_values('A').utilities   := 0;
        v_values('B').rent        := v_rent_rate; 
        v_values('B').replacement := p_ins;
        v_values('B').maintenance := p_maint;
        v_values('B').mgt_percent := p_mgt3;
        v_values('B').cap_rate    := p_bcap;
        v_values('B').vacancy_pct := p_vacb;
        v_values('B').utilities   := 0;
        v_values('C').rent        := v_rent_rate; 
        v_values('C').replacement := p_ins;
        v_values('C').maintenance := p_maint;
        v_values('C').mgt_percent := p_mgt3;
        v_values('C').cap_rate    := p_ccap;
        v_values('C').vacancy_pct := p_vacc;
        v_values('C').utilities   := 0;
      else -- commercial and industrial
        v_values('A').rent        := get_rent(v_rec.a_median, 'A',v_millage); 
        v_values('A').replacement := p_ins;
        v_values('A').maintenance := p_maint;
        v_values('A').mgt_percent := p_mgt1;
        v_values('A').cap_rate    := p_acap;
        v_values('A').vacancy_pct := p_vaca;
        v_values('A').utilities   := 0;
        v_values('B').rent        := get_rent(v_rec.b_median, 'B', v_millage); 
        v_values('B').replacement := p_ins;
        v_values('B').maintenance := p_maint;
        v_values('B').mgt_percent := p_mgt1;
        v_values('B').cap_rate    := p_bcap;
        v_values('B').vacancy_pct := p_vacb;
        v_values('B').utilities   := 0;
        v_values('C').rent        := get_rent(v_rec.c_median, 'C', v_millage); 
        v_values('C').replacement := p_ins;
        v_values('C').maintenance := p_maint;
        v_values('C').mgt_percent := p_mgt2;
        v_values('C').cap_rate    := p_ccap;
        v_values('C').vacancy_pct := p_vacc;
        v_values('C').utilities   := 0;      
      end if;
      
      select count(*)
      into v_counter
      from pr_values 
      where city_id =  v_rec.city_id
      and ucode = v_ucode
      and year =  v_rec.sale_yr; 
      
      if (v_counter = 0 and
          v_parent_ucode != 3 )then
        pr_values_pkg.insert_row( X_CITY_ID         => v_rec.city_id
                              , X_UCODE           => v_ucode
                              , X_PROP_CLASS      => 'A'
                              , X_YEAR            => v_rec.sale_yr
                              , X_MIN_PRICE       => v_values('A').min_price
                              , X_MAX_PRICE       => v_values('A').max_price
                              , X_MEDIAN_PRICE    => v_values('A').median_price
                              , X_RENT            => v_values('A').rent
                              , X_VACANCY_PERCENT => v_values('A').vacancy_pct
                              , X_REPLACEMENT     => v_values('A').replacement
                              , X_MAINTENANCE     => v_values('A').maintenance
                              , X_MGT_PERCENT     => v_values('A').mgt_percent
                              , X_CAP_RATE        => v_values('A').cap_rate
                              , X_UTILITIES       => v_values('A').utilities);
                              
        pr_values_pkg.insert_row( X_CITY_ID         => v_rec.city_id
                              , X_UCODE           => v_ucode
                              , X_PROP_CLASS      => 'B'
                              , X_YEAR            => v_rec.sale_yr
                              , X_MIN_PRICE       => v_values('B').min_price
                              , X_MAX_PRICE       => v_values('B').max_price
                              , X_MEDIAN_PRICE    => v_values('B').median_price
                              , X_RENT            => v_values('B').rent
                              , X_VACANCY_PERCENT => v_values('B').vacancy_pct
                              , X_REPLACEMENT     => v_values('B').replacement
                              , X_MAINTENANCE     => v_values('B').maintenance
                              , X_MGT_PERCENT     => v_values('B').mgt_percent
                              , X_CAP_RATE        => v_values('B').cap_rate
                              , X_UTILITIES       => v_values('B').utilities);

        pr_values_pkg.insert_row( X_CITY_ID         => v_rec.city_id
                              , X_UCODE           => v_ucode
                              , X_PROP_CLASS      => 'C'
                              , X_YEAR            => v_rec.sale_yr
                              , X_MIN_PRICE       => v_values('C').min_price
                              , X_MAX_PRICE       => v_values('C').max_price
                              , X_MEDIAN_PRICE    => v_values('C').median_price
                              , X_RENT            => v_values('C').rent
                              , X_VACANCY_PERCENT => v_values('C').vacancy_pct
                              , X_REPLACEMENT     => v_values('C').replacement
                              , X_MAINTENANCE     => v_values('C').maintenance
                              , X_MGT_PERCENT     => v_values('C').mgt_percent
                              , X_CAP_RATE        => v_values('C').cap_rate
                              , X_UTILITIES       => v_values('C').utilities);
      elsif v_counter > 0 then
        pr_values_pkg.update_row( X_CITY_ID         => v_rec.city_id
                              , X_UCODE           => v_ucode
                              , X_PROP_CLASS      => 'A'
                              , X_YEAR            => v_rec.sale_yr
                              , X_MIN_PRICE       => v_values('A').min_price
                              , X_MAX_PRICE       => v_values('A').max_price
                              , X_MEDIAN_PRICE    => v_values('A').median_price
                              , X_RENT            => v_values('A').rent
                              , X_VACANCY_PERCENT => v_values('A').vacancy_pct
                              , X_REPLACEMENT     => v_values('A').replacement
                              , X_MAINTENANCE     => v_values('A').maintenance
                              , X_MGT_PERCENT     => v_values('A').mgt_percent
                              , X_CAP_RATE        => v_values('A').cap_rate
                              , X_UTILITIES       => v_values('A').utilities
                              , X_CHECKSUM        => pr_values_pkg.get_checksum( v_rec.city_id, v_ucode, 'A', v_rec.sale_yr));
                              
        pr_values_pkg.update_row( X_CITY_ID         => v_rec.city_id
                              , X_UCODE           => v_ucode
                              , X_PROP_CLASS      => 'B'
                              , X_YEAR            => v_rec.sale_yr
                              , X_MIN_PRICE       => v_values('B').min_price
                              , X_MAX_PRICE       => v_values('B').max_price
                              , X_MEDIAN_PRICE    => v_values('B').median_price
                              , X_RENT            => v_values('B').rent
                              , X_VACANCY_PERCENT => v_values('B').vacancy_pct
                              , X_REPLACEMENT     => v_values('B').replacement
                              , X_MAINTENANCE     => v_values('B').maintenance
                              , X_MGT_PERCENT     => v_values('B').mgt_percent
                              , X_CAP_RATE        => v_values('B').cap_rate
                              , X_UTILITIES       => v_values('B').utilities
                              , X_CHECKSUM        => pr_values_pkg.get_checksum( v_rec.city_id, v_ucode, 'B', v_rec.sale_yr));

        pr_values_pkg.update_row( X_CITY_ID         => v_rec.city_id
                              , X_UCODE           => v_ucode
                              , X_PROP_CLASS      => 'C'
                              , X_YEAR            => v_rec.sale_yr
                              , X_MIN_PRICE       => v_values('C').min_price
                              , X_MAX_PRICE       => v_values('C').max_price
                              , X_MEDIAN_PRICE    => v_values('C').median_price
                              , X_RENT            => v_values('C').rent
                              , X_VACANCY_PERCENT => v_values('C').vacancy_pct
                              , X_REPLACEMENT     => v_values('C').replacement
                              , X_MAINTENANCE     => v_values('C').maintenance
                              , X_MGT_PERCENT     => v_values('C').mgt_percent
                              , X_CAP_RATE        => v_values('C').cap_rate
                              , X_UTILITIES       => v_values('C').utilities
                              , X_CHECKSUM        => pr_values_pkg.get_checksum( v_rec.city_id, v_ucode, 'C', v_rec.sale_yr));
      end if;
      commit;
    end loop;
  end set_value_estimates;


  procedure exec_seeding is
  begin
    set_ucode_summary;
    commit;
    set_value_estimates;
  end exec_seeding;
  
begin
  exec_seeding;
end;
/
