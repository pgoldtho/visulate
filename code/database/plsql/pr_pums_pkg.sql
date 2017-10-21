create or replace package pr_pums_pkg as
  p_year   number := 2016;

  procedure seed_pums_data;
  procedure set_vacancy_rate;
  procedure set_property_pumas;
  procedure set_insurance_rate;
  procedure update_tax_values;
  procedure get_rent_values;
  procedure set_rental_percentage;
  procedure get_income_values;


  procedure set_pums_values
    ( p_puma           in pr_pums_values.puma%type
    , p_value_type     in pr_pums_values.value_type%type
    , p_percentile     in pr_pums_values.percentile%type
    , p_value_amount   in pr_pums_values.value_amount%type);
    
  procedure set_puma_percentile;

  function get_percentile
    ( p_puma           in pr_pums_values.puma%type
    , p_value_type     in pr_pums_values.value_type%type
    , p_value_amount   in pr_pums_values.value_amount%type)
    return pr_pums_values.percentile%type;

  function get_value
    ( p_puma           in pr_pums_values.puma%type
    , p_value_type     in pr_pums_values.value_type%type
    , p_percentile     in pr_pums_values.value_amount%type)
    return pr_pums_values.value_amount%type;
    
  procedure set_ucode_summary;
  procedure set_value_estimates;
    
end pr_pums_pkg;
/

create or replace package body pr_pums_pkg as

  procedure seed_pums_data is
    cursor cur_puma is
    select puma
    ,      median(grpip) rent_income_ratio
    from asc_pums_extract
    where grpip is not null
    group by puma
    order by puma;

    v_counter pls_integer;

  begin
    for p_rec in cur_puma loop
      select count(*) into v_counter
      from pr_pums_data
      where puma = p_rec.puma;
      
      if v_counter = 0 then
        insert into pr_pums_data (puma, rent_income_ratio)
        values (p_rec.puma, p_rec.rent_income_ratio);
      else
        update pr_pums_data
        set rent_income_ratio =  p_rec.rent_income_ratio
        where puma = p_rec.puma;
      end if;
      
    end loop;
  end seed_pums_data;

  procedure set_vacancy_rate is
    cursor cur_pumas is
    select puma
    from pr_pums_data
    group by puma
    order by puma;

    v_rentals     pls_integer;
    v_vacancies   pls_integer;
    v_vac_rate    number;
    
  begin
    for p_rec in cur_pumas loop
      select count(*)
      into v_rentals
      from asc_pums_extract
      where ten=3
      and puma=p_rec.puma;

      select count(*)
      into v_vacancies
      from asc_pums_extract
      where vacs=1
      and puma=p_rec.puma;

      v_vac_rate := round(v_vacancies/(v_vacancies + v_rentals)*100);
      update pr_pums_data
      set vacancy_rate = v_vac_rate
      where puma = p_rec.puma;
      commit;
    end loop;
  end set_vacancy_rate;

  procedure set_property_pumas is
    cursor cur_properties is
    select p.prop_id
    ,      regexp_substr(substr(census_bk, 1, 5), '[0-9]+') county
    ,      regexp_substr(substr(census_bk,6,4), '[0-9]+')   tract
    ,      to_number(zipcode) zipcode
    from pr_properties p
    ,    pr_property_usage pu
    where p.state='FL'
    and p.prop_id = pu.prop_id
    and puma is null;

    cursor cur_map_tract( p_county in number
                        , p_tract  in number) is
    select puma2k puma
    ,      afact
    from  asc_bkpuma
    where county = p_county
    and round(tract) = p_tract
    order by afact desc;

    cursor cur_map_zipcode( p_zipcode in number) is
    select puma2k puma
    ,      afact
    from  asc_zipuma
    where zipcode = p_zipcode
    order by afact desc;

    v_counter  pls_integer;
  begin
    for p_rec in cur_properties loop
      v_counter := 0;
      
      for t_rec in cur_map_tract(p_rec.county, p_rec.tract) loop
        v_counter := v_counter + 1;
        if v_counter = 1 then -- we know afact value is greatest due to order by
          update pr_properties
          set puma = t_rec.puma
          where prop_id = p_rec.prop_id;
        end if;
      end loop;
      
      if v_counter = 0 then -- map by tract failed
        for z_rec in cur_map_zipcode(p_rec.zipcode) loop
          v_counter := v_counter + 1;
          if v_counter = 1 then -- we know afact value is greatest due to order by
            update pr_properties
            set puma = z_rec.puma
            where prop_id = p_rec.prop_id;
          end if;
        end loop;
      end if;
      commit;
    end loop;
  end set_property_pumas;

  procedure set_insurance_rate is
    cursor cur_pumas is
    select puma
    from pr_pums_data
    order by puma;

    v_ins_rate     number;
    v_median_ins   number;
    v_median_sqft  number;

  begin
    for p_rec in cur_pumas loop
      select median(round(insp*adjhsg/1000000))
      into v_median_ins
      from asc_pums_extract h
      where  insp is not null
      and h.puma = p_rec.puma;

      select median(sq_ft)
      into v_median_sqft
      from pr_properties p
      ,    pr_property_usage pu
      where p.puma = p_rec.puma
      and pu.ucode in (110, 113, 121, 135, 212, 213, 214, 414, 90001, 90002, 90004)
      and p.prop_id = pu.prop_id;

      v_ins_rate := v_median_ins/v_median_sqft;
      update pr_pums_data
      set insurance = v_ins_rate
      where puma = p_rec.puma;
      commit;
    end loop;
  end set_insurance_rate;

  procedure update_tax_values is
    cursor cur_taxval is
    select distinct prop_id, tax_value, round(tax_amount) tax_amount
    from asc_tax_values
    where prop_id is not null
    and tax_value is not null
    order by prop_id;

    v_prop_id   number := 0;
    v_tax_val   number := 0;
  begin
  
    for t_rec in cur_taxval loop
      if t_rec.prop_id != v_prop_id then
        insert into pr_taxes
           (prop_id, tax_year, tax_value, tax_amount, current_yn)
        values
           ( t_rec.prop_id
           , p_year
           , t_rec.tax_value
           , t_rec.tax_amount
           , 'Y');
       v_tax_val := t_rec.tax_value;
       v_prop_id := t_rec.prop_id;
      else
        if t_rec.tax_value != v_tax_val then
          update pr_taxes
          set tax_value = t_rec.tax_value
          ,   tax_amount =  t_rec.tax_amount
          where prop_id = v_prop_id
          and tax_year = p_year;
          v_tax_val := t_rec.tax_value;
        end if;
      end if;
    end loop;

  update pr_taxes
  set current_yn = 'N'
  where tax_year != p_year;
  
  end update_tax_values;

  procedure set_pums_values
    ( p_puma           in pr_pums_values.puma%type
    , p_value_type     in pr_pums_values.value_type%type
    , p_percentile     in pr_pums_values.percentile%type
    , p_value_amount   in pr_pums_values.value_amount%type) is

    v_count  pls_integer;
  begin
    select count(*)
    into v_count
    from pr_pums_values
    where puma = p_puma
    and value_type = p_value_type
    and percentile = p_percentile;

    if v_count > 0 then
      update pr_pums_values
      set value_amount = p_value_amount
      where puma = p_puma
      and value_type = p_value_type
      and percentile = p_percentile;
    else
      insert into pr_pums_values
           (puma, value_type, percentile, value_amount)
        values
           (p_puma, p_value_type, p_percentile, p_value_amount);
    end if;
  end set_pums_values;
   
  procedure set_puma_percentile is
    cursor cur_pumas is
    select puma
    from pr_pums_data
    order by puma;

    --
    -- Find percentile values for single family, half duplex,
    -- condo, townhouse, and mobile home
    --
    cursor cur_percentile(p_puma in pr_pums_data.puma%type) is
    select p.prop_id
    ,      tax_value
    ,      round (PERCENT_RANK () over (order by tax_value) *100) pct_val
    from pr_properties p
    ,         pr_taxes t
    ,         pr_property_usage pu
    where puma=p_puma
    and t.prop_id = p.prop_id
    and p.prop_id = pu.prop_id
    and pu.ucode in (110, 113, 121, 135, 212, 213, 214, 414, 90001, 90002, 90004)
    and t.current_yn = 'Y'
    order by tax_value;

    v_current_pct  number;
    v_max_tax      number;

  begin
    for p_rec in cur_pumas loop
      v_current_pct  := 0;
      v_max_tax      := 0;
      for v_rec in cur_percentile(p_rec.puma) loop
        if v_rec.pct_val != v_current_pct then
           set_pums_values(p_rec.puma, 'TAX-VALUE', v_current_pct, v_max_tax);
           v_current_pct := v_rec.pct_val;
        end if;
        v_max_tax := v_rec.tax_value;

        update pr_properties
        set puma_percentile = v_rec.pct_val
        where prop_id = v_rec.prop_id;
        commit;
      end loop;
    end loop;
  end set_puma_percentile;



  procedure get_rent_values is
    cursor cur_pumas is
    select puma
    from pr_pums_data
    order by puma;

    --
    -- Find percentile values for non owner occupied
    -- single family, half duplex, condo, townhouse, and mobile homes
    --
    cursor cur_percentile(p_puma in pr_pums_data.puma%type) is
    select p.prop_id
    ,      tax_value
    ,      round (PERCENT_RANK () over (order by tax_value) *100) pct_val
    from pr_properties p
    ,    pr_taxes t
    ,    pr_property_usage pu
    ,    pr_property_owners o
    ,    pr_properties op
    where p.puma=p_puma
    and t.prop_id = p.prop_id
    and p.prop_id = pu.prop_id
    and pu.ucode in (110, 113, 121, 135, 212, 213, 214, 414, 90001, 90002, 90004)
    and o.prop_id = p.prop_id
    and o.mailing_id != o.prop_id
    and t.current_yn = 'Y'
    and o.prop_id = p.prop_id
    and o.mailing_id != o.prop_id
    and o.mailing_id = op.prop_id
    and utl_match.jaro_winkler_similarity(p.address1, op.address1) < 85
    order by tax_value;

    v_current_pct  number;
    v_max_tax      number;

  begin
    for p_rec in cur_pumas loop
      v_current_pct  := 0;
      v_max_tax      := 0;
      for v_rec in cur_percentile(p_rec.puma) loop
        if v_rec.pct_val != v_current_pct then
           set_pums_values(p_rec.puma, 'RENT-VALUE', v_current_pct, v_max_tax);
           v_current_pct := v_rec.pct_val;
        end if;
        v_max_tax := v_rec.tax_value;
        commit;
      end loop;
    end loop;
  end get_rent_values;


  procedure get_income_values is
    cursor cur_pumas is
    select puma
    from pr_pums_data
    order by puma;

    cursor cur_percentile(p_puma in pr_pums_data.puma%type) is
    select trunc(fincp*adjinc/1000000) income
    ,      round (PERCENT_RANK () over (order by trunc(fincp*adjinc/1000000)) *100) pct_val
    from asc_pums_extract
    where fincp is not null
    and puma = p_puma
    order by 1;

    cursor cur_percentile2( p_puma in pr_pums_data.puma%type
                          , p_min  in number) is
    select trunc(fincp*adjinc/1000000*grpip) income
    ,      round (PERCENT_RANK () over (order by trunc(fincp*adjinc/1000000*grpip)) *100) pct_val
    from asc_pums_extract
    where fincp is not null
    and fincp > 0
    and grntp is not null
    and fincp*adjinc/1000000 > p_min
    and puma = p_puma
    order by 1;

    cursor cur_percentile3( p_puma in pr_pums_data.puma%type) is
    select trunc(grntp*adjinc/1000) income
    ,      round (PERCENT_RANK () over (order by trunc(grntp*adjinc/1000)) *100) pct_val
    from asc_pums_extract
    where grntp is not null
    and puma = p_puma
    order by 1;

    
    v_current_pct  number;
    v_max          number;
    v_min          number;

  begin
    for p_rec in cur_pumas loop
    
      v_current_pct  := 0;
      v_max          := 0;
      for v_rec in cur_percentile(p_rec.puma) loop
        if v_rec.pct_val != v_current_pct then
           set_pums_values(p_rec.puma, 'HH-INCOME', v_current_pct, v_max);
           v_current_pct := v_rec.pct_val;
        end if;
        v_max := v_rec.income;
        commit;
      end loop;

      select value_amount
      into v_min
      from pr_pums_values
      where percentile = 6
      and value_type = 'HH-INCOME'
      and puma = p_rec.puma;
      
      v_current_pct  := 0;
      v_max          := 0;
      for v_rec in cur_percentile2(p_rec.puma, v_min) loop
        if v_rec.pct_val != v_current_pct then
           set_pums_values(p_rec.puma, 'RR-INCOME', v_current_pct, v_max);
           v_current_pct := v_rec.pct_val;
        end if;
        v_max := v_rec.income;
        commit;
      end loop;

      v_current_pct  := 0;
      v_max          := 0;
      for v_rec in cur_percentile3(p_rec.puma) loop
        if v_rec.pct_val != v_current_pct then
           set_pums_values(p_rec.puma, 'RR-RENT', v_current_pct, v_max);
           v_current_pct := v_rec.pct_val;
        end if;
        v_max := v_rec.income;
        commit;
      end loop;

      
    end loop;
  end get_income_values;


  function get_percentile
    ( p_puma           in pr_pums_values.puma%type
    , p_value_type     in pr_pums_values.value_type%type
    , p_value_amount   in pr_pums_values.value_amount%type)
    return pr_pums_values.percentile%type is
    v_return  pr_pums_values.percentile%type;
  begin
  
    select min(percentile) into v_return
    from pr_pums_values
    where puma=p_puma
    and value_type=p_value_type
    and value_amount > p_value_amount;

    if v_return is null then
      select max(percentile) into v_return
      from  pr_pums_values
      where puma=p_puma
      and value_type=p_value_type;
    end if;

    return v_return;
  end get_percentile;


  function get_value
    ( p_puma           in pr_pums_values.puma%type
    , p_value_type     in pr_pums_values.value_type%type
    , p_percentile     in pr_pums_values.value_amount%type)
    return pr_pums_values.value_amount%type is
    v_return pr_pums_values.value_amount%type;
  begin
    select value_amount
    into v_return
    from pr_pums_values
    where puma = p_puma
    and value_type = p_value_type
    and percentile = p_percentile;

    return v_return;
  end get_value;

  procedure set_rental_percentage is
    cursor cur_values is
    select puma
    ,      percentile
    ,      value_amount
    from pr_pums_values
    where value_type = 'TAX-VALUE'
    order by puma, percentile;

    v_rent_percentile    pr_pums_values.percentile%type;
  begin
    for v_rec in cur_values loop
      v_rent_percentile := get_percentile(v_rec.puma, 'RENT-VALUE', v_rec.value_amount);
      
      update pr_properties
      set rental_percentile = v_rent_percentile
      where puma = v_rec.puma
      and puma_percentile = v_rec.percentile;

      commit;
    end loop;
  
  end set_rental_percentage;

  procedure set_ucode_summary is
    cursor cur_summary is
    select c.city_id
    ,      u.ucode
    ,      count(*)              property_count
    ,      sum(nvl(p.sq_ft, 0))  total_area
    from rnt_cities c
    ,    pr_properties p
    ,    rnt_city_zipcodes cz
    ,    pr_property_usage u
    where  c.city_id = cz.city_id
    and to_char(cz.zipcode) = p.zipcode
    and c.state = 'FL'
    and u.prop_id = p.prop_id
    group by c.city_id, u.ucode
    order by c.city_id, u.ucode;

    v_count     pls_integer;
    v_ucode     pr_usage_codes.ucode%type;
    v_current   rnt_cities.city_id%type;
  begin
    v_current := 99999999999999;
    for s_rec in cur_summary loop
      if v_current != s_rec.city_id then
        v_current := s_rec.city_id;
        delete from pr_ucode_data
        where city_id = s_rec.city_id;
      end if;

      select count(*) into v_count
      from pr_ucode_data
      where city_id = s_rec.city_id
      and ucode = s_rec.ucode;

      if v_count = 0 then
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


  procedure set_value_estimates is
    p_acap  number := 6;
    p_bcap  number := 7;
    p_ccap  number := 9;
    p_ins   number := 0.97;
    p_maint number := 0.52;
    p_vaca  number := 12.5;
    p_vacb  number := 15;
    p_vacc  number := 22.5;
    p_mgt1  number := 4;
    p_mgt2  number := 6;
    p_mgt3  number := 10;

    p_retail_vac     number := 7.2;
    p_office_vac     number := 18.2;
    p_industrial_vac number := 8.3;

  cursor cur_cities is
    select c.city_id, m.year sale_yr, ud.ucode, uc.description
    , uc.parent_ucode, m.rent_rate, c.name, c.county
    from pr_ucode_data ud
    ,    pr_usage_codes uc
    ,    rnt_cities c
    ,    pr_millage_rates m
    where ud.ucode = uc.ucode
    and c.city_id = ud.city_id
    and c.county = upper(m.county)
    and c.state = 'FL'
    order by 1, 2, 3;


  type lrate_type is record
      ( a_median         number
      , b_median         number
      , c_median         number
      , prop_count       number);
  type lrate_tab_type is table of lrate_type index by varchar2(256);
  lrate           lrate_tab_type;
  default_lrate   lrate_tab_type;

  cursor cur_lease_rates is
    select c.city_id
    ,      u2.ucode
    ,      s.tax_year
    ,      round(PERCENTILE_DISC(0.8) within group (order by s.tax_amount/nvl(p.sq_ft, p.acreage)) * 10, 2) a_median
    ,      round(PERCENTILE_DISC(0.5) within group (order by s.tax_amount/nvl(p.sq_ft, p.acreage)) * 10, 2) b_median
    ,      round(PERCENTILE_DISC(0.2) within group (order by s.tax_amount/nvl(p.sq_ft, p.acreage)) * 10, 2) c_median
    ,      count(*) prop_count
    from pr_properties p
    ,    pr_taxes s
    ,    pr_property_usage pu
    ,    pr_usage_codes u
    ,    rnt_city_zipcodes cz
    ,    rnt_cities c
    ,    pr_usage_codes u2
    where c.city_id = cz.city_id
    and to_char(cz.zipcode) = p.zipcode
    and c.state='FL'
    and pu.prop_id = p.prop_id
    and p.prop_id = s.prop_id
    and u.ucode = pu.ucode
    and u.parent_ucode = u2.ucode
    and p.sq_ft != 0
    and nvl(p.sq_ft, p.acreage) != 0
    and (s.tax_amount/nvl(p.sq_ft, p.acreage) < 25)
    group by c.city_id, u2.ucode, s.tax_year having count(*) > 20
    order by c.city_id, u2.ucode, s.tax_year;

  cursor cur_default_lease_rates is
    select u2.ucode
    ,      s.tax_year
    ,      round(PERCENTILE_DISC(0.8) within group (order by s.tax_amount/nvl(p.sq_ft, p.acreage)) * 10, 2) a_median
    ,      round(PERCENTILE_DISC(0.5) within group (order by s.tax_amount/nvl(p.sq_ft, p.acreage)) * 10, 2) b_median
    ,      round(PERCENTILE_DISC(0.2) within group (order by s.tax_amount/nvl(p.sq_ft, p.acreage)) * 10, 2) c_median
    ,      count(*) prop_count
    from pr_properties p
    ,    pr_taxes s
    ,    pr_property_usage pu
    ,    pr_usage_codes u
    ,    rnt_city_zipcodes cz
    ,    rnt_cities c
    ,    pr_usage_codes u2
    where c.city_id = cz.city_id
    and to_char(cz.zipcode) = p.zipcode
    and c.state='FL'
    and pu.prop_id = p.prop_id
    and p.prop_id = s.prop_id
    and u.ucode = pu.ucode
    and u.parent_ucode = u2.ucode
    and p.sq_ft != 0
    and nvl(p.sq_ft, p.acreage) != 0
    and (s.tax_amount/nvl(p.sq_ft, p.acreage) < 25)
    group by u2.ucode, s.tax_year having count(*) > 20
    order by u2.ucode, s.tax_year;


    type city_values_type is record
      ( a_max            number
      , a_median         number
      , a_min            number
      , b_median         number
      , c_max            number
      , c_median         number
      , c_min            number
      , sales_count      number);
    type city_values_tab_type is table of city_values_type index by varchar2(256);
    city_value           city_values_tab_type;
    county_value         city_values_tab_type;


    cursor cur_city_values is
    select c.city_id
    ,      pu.ucode
    ,      to_char(s.sale_date, 'YYYY') sale_yr
    ,      round(max (s.price/nvl(p.sq_ft, p.acreage)), 2) a_max
    ,      round(PERCENTILE_DISC(0.875) within group (order by s.price/nvl(p.sq_ft, p.acreage)), 2) a_median
    ,      round(PERCENTILE_DISC(0.75) within group (order by s.price/nvl(p.sq_ft, p.acreage)), 2) a_min
    ,      round(PERCENTILE_DISC(0.5) within group (order by s.price/nvl(p.sq_ft, p.acreage)), 2) b_median
    ,      round(PERCENTILE_DISC(0.25) within group (order by s.price/nvl(p.sq_ft, p.acreage)), 2) c_max
    ,      round(PERCENTILE_DISC(0.175) within group (order by s.price/nvl(p.sq_ft, p.acreage)), 2) c_median
    ,      round(min (s.price/nvl(p.sq_ft, p.acreage)), 2) c_min
    ,      count(*) sales_count
    from pr_properties p
    ,    pr_property_sales s
    ,    pr_property_usage pu
    ,    rnt_city_zipcodes cz
    ,    rnt_cities c
    where c.city_id = cz.city_id
    and to_char(cz.zipcode) = p.zipcode
    and c.state='FL'
    and pu.prop_id = p.prop_id
    and p.prop_id = s.prop_id
    and s.price > 200
    and nvl(p.sq_ft, p.acreage) > 0
    and s.price/nvl(p.sq_ft, p.acreage) < 1000
    and s.price/nvl(p.sq_ft, p.acreage) > 10
    group by c.city_id, pu.ucode, to_char(s.sale_date, 'YYYY')
    order by c.city_id, pu.ucode, to_char(s.sale_date, 'YYYY');

    cursor cur_county_values is
      select c.county, c.state
          ,      uc.parent_ucode ucode
          ,      to_char(s.sale_date, 'YYYY') sale_yr
          ,      round(max (s.price/nvl(p.sq_ft, p.acreage)), 2) a_max
          ,      round(PERCENTILE_DISC(0.875) within group (order by s.price/nvl(p.sq_ft, p.acreage)), 2) a_median
          ,      round(PERCENTILE_DISC(0.75) within group (order by s.price/nvl(p.sq_ft, p.acreage)), 2) a_min
          ,      round(PERCENTILE_DISC(0.5) within group (order by s.price/nvl(p.sq_ft, p.acreage)), 2) b_median
          ,      round(PERCENTILE_DISC(0.25) within group (order by s.price/nvl(p.sq_ft, p.acreage)), 2) c_max
          ,      round(PERCENTILE_DISC(0.175) within group (order by s.price/nvl(p.sq_ft, p.acreage)), 2) c_median
          ,      round(min (s.price/nvl(p.sq_ft, p.acreage)), 2) c_min
          ,      count(*) sales_count
          from pr_properties p
          ,    pr_property_sales s
          ,    pr_property_usage pu
          ,    rnt_city_zipcodes cz
          ,    rnt_cities c
          ,    pr_usage_codes uc
          where c.city_id = cz.city_id
          and to_char(cz.zipcode) = p.zipcode
          and c.state='FL'
          and pu.prop_id = p.prop_id
          and p.prop_id = s.prop_id
          and s.price > 200
          and nvl(p.sq_ft, p.acreage) > 0
          and s.price/nvl(p.sq_ft, p.acreage) < 1000
          and s.price/nvl(p.sq_ft, p.acreage) > 10
          and uc.ucode = pu.ucode
          group by c.county, c.state, uc.parent_ucode, to_char(s.sale_date, 'YYYY')
     order by c.county, uc.parent_ucode, sale_yr;


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
    v_row           varchar2(256);
    v_row2          varchar2(256);
    v_row3          varchar2(256);
  begin
    for v_rec in cur_default_lease_rates loop
      default_lrate(v_rec.ucode||':'||v_rec.tax_year).a_median := v_rec.a_median;
      default_lrate(v_rec.ucode||':'||v_rec.tax_year).b_median := v_rec.b_median;
      default_lrate(v_rec.ucode||':'||v_rec.tax_year).c_median := v_rec.c_median;
    end loop;

    for v_rec in cur_lease_rates loop
      lrate(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.tax_year).a_median := v_rec.a_median;
      lrate(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.tax_year).b_median := v_rec.b_median;
      lrate(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.tax_year).c_median := v_rec.c_median;
    end loop;

    for v_rec in cur_city_values loop
      city_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).a_max := v_rec.a_max;
      city_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).a_median := v_rec.a_median;
      city_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).a_min := v_rec.a_min;
      city_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).b_median := v_rec.b_median;
      city_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).c_max := v_rec.c_max;
      city_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).c_median := v_rec.c_median;
      city_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).c_min := v_rec.c_min;
      city_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).sales_count := v_rec.sales_count;
    end loop;

    for v_rec in cur_county_values loop
      county_value(v_rec.county||':'||v_rec.ucode||':'||v_rec.sale_yr).a_max := v_rec.a_max;
      county_value(v_rec.county||':'||v_rec.ucode||':'||v_rec.sale_yr).a_median := v_rec.a_median;
      county_value(v_rec.county||':'||v_rec.ucode||':'||v_rec.sale_yr).a_min := v_rec.a_min;
      county_value(v_rec.county||':'||v_rec.ucode||':'||v_rec.sale_yr).b_median := v_rec.b_median;
      county_value(v_rec.county||':'||v_rec.ucode||':'||v_rec.sale_yr).c_max := v_rec.c_max;
      county_value(v_rec.county||':'||v_rec.ucode||':'||v_rec.sale_yr).c_median := v_rec.c_median;
      county_value(v_rec.county||':'||v_rec.ucode||':'||v_rec.sale_yr).c_min := v_rec.c_min;
      county_value(v_rec.county||':'||v_rec.ucode||':'||v_rec.sale_yr).sales_count := v_rec.sales_count;
    end loop;


    for v_rec in cur_cities loop

      v_ucode := v_rec.ucode;
      v_parent_ucode := v_rec.parent_ucode;
      v_row := v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr;
      v_row2 := v_rec.city_id||':'||v_rec.parent_ucode||':'||v_rec.sale_yr;
      v_row3 := v_rec.county||':'||v_rec.parent_ucode||':'||v_rec.sale_yr;

      if city_value.exists(v_row) then
        if city_value(v_row).sales_count > 15 then
          v_values('A').min_price := city_value(v_row).a_min;
          v_values('B').min_price := city_value(v_row).c_max + 0.01;
          v_values('C').min_price := city_value(v_row).c_min;

          v_values('A').median_price := city_value(v_row).a_median;
          v_values('B').median_price := city_value(v_row).b_median;
          v_values('C').median_price := city_value(v_row).c_median;

          v_values('A').max_price := city_value(v_row).a_max;
          v_values('B').max_price := city_value(v_row).a_min - 0.01;
          v_values('C').max_price := city_value(v_row).c_max;
        else
          if county_value.exists(v_row3) then
            v_values('A').min_price := county_value(v_row3).a_min;
            v_values('B').min_price := county_value(v_row3).c_max + 0.01;
            v_values('C').min_price := county_value(v_row3).c_min;

            v_values('A').median_price := county_value(v_row3).a_median;
            v_values('B').median_price := county_value(v_row3).b_median;
            v_values('C').median_price := county_value(v_row3).c_median;

            v_values('A').max_price := county_value(v_row3).a_max;
            v_values('B').max_price := county_value(v_row3).a_min - 0.01;
            v_values('C').max_price := county_value(v_row3).c_max;
          else
            dbms_output.put_line(v_row2||' Not found');
          end if;
        end if;
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
      elsif v_parent_ucode in (91000, 1, 4, 17) then -- residential
        v_rent_rate :=  default_lrate(v_parent_ucode||':'||v_rec.sale_yr).b_median;
      
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

        v_values('A').replacement := p_ins;
        v_values('A').maintenance := p_maint;
        v_values('A').mgt_percent := p_mgt1;
        v_values('A').cap_rate    := p_acap;
        v_values('A').vacancy_pct := p_vaca;
        v_values('A').utilities   := 0;

        v_values('B').replacement := p_ins;
        v_values('B').maintenance := p_maint;
        v_values('B').mgt_percent := p_mgt1;
        v_values('B').cap_rate    := p_bcap;
        v_values('B').vacancy_pct := p_vacb;
        v_values('B').utilities   := 0;

        v_values('C').replacement := p_ins;
        v_values('C').maintenance := p_maint;
        v_values('C').mgt_percent := p_mgt2;
        v_values('C').cap_rate    := p_ccap;
        v_values('C').vacancy_pct := p_vacc;
        v_values('C').utilities   := 0;
      begin
        v_values('A').rent        := lrate(v_row2).a_median;
        v_values('B').rent        := lrate(v_row2).b_median;
        v_values('C').rent        := lrate(v_row2).c_median;        
      exception
        when others then dbms_output.put_line(v_row3);
        if v_parent_ucode is not null then
          if v_parent_ucode = 2 then v_parent_ucode := 12; end if;
          v_values('A').rent := default_lrate(v_parent_ucode||':'||v_rec.sale_yr).a_median;
          v_values('B').rent := default_lrate(v_parent_ucode||':'||v_rec.sale_yr).b_median;
          v_values('C').rent := default_lrate(v_parent_ucode||':'||v_rec.sale_yr).c_median;
        else
          v_values('A').rent := 18;
          v_values('B').rent :=  8;
          v_values('C').rent :=  6;
        end if;
        
      end;
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
    
    update pr_values set current_yn = 'N';
    merge into pr_values v using
      (select city_id, ucode, prop_class, max(year) cyear
       from pr_values
       group by city_id, ucode, prop_class) s
    on (s.city_id = v.city_id and
        s.ucode = v.ucode and
        s.prop_class = v.prop_class and
        s.cyear = v.year)
    when matched then update
    set v.current_yn = 'Y';
    
  end set_value_estimates;


end pr_pums_pkg;
/
show errors package pr_pums_pkg
show errors package body pr_pums_pkg
