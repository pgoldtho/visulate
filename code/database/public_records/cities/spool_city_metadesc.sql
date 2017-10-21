set define ^
declare
  function get_nn( p_geo  in rnt_cities.geo_location%type
                 , p_pop  in number) return varchar2 is

    cursor cur_loc( p_geo  in rnt_cities.geo_location%type
                  , p_pop  in number) is
    select initcap(name) display_name, name
    , county, state, population, sdo_nn_distance(1) distance
    , region_id
    from rnt_cities c
    where population > p_pop
    and sdo_nn(c.geo_location, p_geo, 'sdo_num_res=50 unit=mile', 1) = 'TRUE'
    order by 5 desc;

    v_return   varchar2(4096);
    v_current  varchar2(256) := 'nowhere';
    v_count    pls_integer := 0;
  begin
    for n_rec in cur_loc(p_geo, p_pop) loop
      if v_current != n_rec.name then
        v_current := n_rec.name;
        v_count := v_count + 1;
        if v_count = 1 then
           v_return := 'is approximately '
                          ||round(n_rec.distance)||' miles from '
                          ||n_rec.display_name
                          ||' (population '
                          ||to_char(n_rec.population, 'fm9,999,999')||')';
        elsif v_count = 2 then
           v_return := v_return ||' and around '
                          ||round(n_rec.distance)||' miles from '
                          ||n_rec.display_name
                          ||' (population '
                          ||to_char(n_rec.population, 'fm9,999,999')||')';
        end if;
      end if;
    end loop;
    return v_return;
  end get_nn;
  
  procedure gen_text is
    cursor cur_city is
    select initcap(c.name) name
    ,      c.description
    ,      c.population
    ,      c.geo_location
    ,      initcap(c.county) county
    ,      decode (r.name,
           'East Central'  , 'East Central Florida',
           'North Central' , 'North Central Florida',
           'North Eastern' , 'North Eastern Florida',
           'North West'    , 'North West Florida',
           'South Central' , 'South Central Florida',
           'South East'    , 'South East Florida',
           'South West'    , 'South West Florida',
           'Tampa'         , 'the Tampa Bay region of Florida')  region
    ,      c.city_id
    ,      c.census_place
    from rnt_cities c
    ,    rnt_regions r
    where c.state = 'FL'
    and c.name != 'ANY'
    and c.region_id = r.region_id
    order by 5, 1;
    
    cursor cur_counties is
    select initcap(c.county) name
    ,      decode (r.name,
           'East Central'  , 'East Central Florida',
           'North Central' , 'North Central Florida',
           'North Eastern' , 'North Eastern Florida',
           'North West'    , 'North West Florida',
           'South Central' , 'South Central Florida',
           'South East'    , 'South East Florida',
           'South West'    , 'South West Florida',
           'Tampa'         , 'the Tampa Bay region of Florida')  region
    ,      c.city_id
    ,      c.census_place
    from rnt_cities c
    ,    rnt_regions r
    where c.state = 'FL'
    and c.name = 'ANY'
    and c.region_id = r.region_id
    order by 1;
    
    cursor cur_county_cities(p_county in varchar2) is
    select initcap(name) city
    ,      nvl(population, 1) population
    from rnt_cities
    where county = p_county
    and state = 'FL'
    and name != 'ANY'
    order by 2 desc;
    

    

    v_region   varchar(1024) := 'none';
    v_gen_text varchar2(32767);
    v_text     varchar2(32767);
    v_nn       varchar2(4096);
    v_count    pls_integer;
    v_city     varchar2(256);


  begin
    for c_rec in cur_city loop
      v_gen_text := '';
      if c_rec.region != v_region then
        pr_rets_pkg.put_line('-- '||c_rec.region);
        v_region := c_rec.region;
      end if;
      pr_rets_pkg.put_line('--------------------------------------------------------------- ');
      pr_rets_pkg.put_line('---- '||c_rec.name||', Florida '||c_rec.county||' County (Population: '||c_rec.population||')' );
      pr_rets_pkg.put_line('--------------------------------------------------------------- ');
      v_gen_text := c_rec.name||' is in '||c_rec.region||'.';
      if c_rec.population is not null then
        v_gen_text := v_gen_text ||'  It''s population as recorded in the 2010 Census was '
                      ||to_char(c_rec.population, 'fm9,999,999')||'.';
      end if;

      if (c_rec.population is null or c_rec.population < 50000) then
        v_nn := get_nn(c_rec.geo_location, nvl(c_rec.population, 1000));
        v_gen_text := v_gen_text ||'  '||c_rec.name||' '||v_nn||'.';
      end if;



      v_text := v_gen_text;

        dbms_output.put_line('update rnt_cities'||chr(10)
                         ||'set meta_description = '''||replace(v_text, '''', '''''')||''''||chr(10)
                         ||'where city_id = '||c_rec.city_id||';'||chr(10));


      
--      pr_rets_pkg.put_line('add_link('||c_rec.city_id||', '''', '''');');
      
    end loop;
    pr_rets_pkg.put_line('--------------------------------------------------------------- ');
    pr_rets_pkg.put_line('---- Counties' );
    pr_rets_pkg.put_line('--------------------------------------------------------------- ');
    
    for c_rec in cur_counties loop
       v_gen_text := '';
       v_gen_text := c_rec.name||' County is in '||c_rec.region||'.';
       v_count := 1;
       for t_rec in cur_county_cities(upper(c_rec.name)) loop
         if t_rec.population > 1 then
           v_city := t_rec.city||' (population '||to_char(t_rec.population, 'fm9,999,999')||')';
         else
           v_city := t_rec.city;
         end if;
       
         if v_count = 1 then
           v_gen_text := v_gen_text||'  The main cities in '
                         ||c_rec.name||' County are '
                         ||v_city;
         elsif v_count = 2 then
           v_gen_text := v_gen_text||', '||v_city;
         elsif v_count = 3 then
           v_gen_text := v_gen_text||' and '||v_city;         
         end if;
         v_count := v_count + 1;
       end loop;
       
       
       v_text := v_gen_text;

      dbms_output.put_line('update rnt_cities'||chr(10)
                         ||'set meta_description = '''||replace(v_text, '''', '''''')||''''||chr(10)
                         ||'where city_id = '||c_rec.city_id||';'||chr(10));
       
    end loop;

  end gen_text;
begin
  gen_text;
end;
/
