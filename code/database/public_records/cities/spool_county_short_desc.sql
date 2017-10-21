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
    
    cursor cur_counties is
    select '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county='||replace(c.county,' ', '%20')
            ||'&region_id='||c.region_id||'">'||initcap(c.county)||' County</a>' name
    ,      decode (r.name,
           'East Central'  , '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=3">East Central Florida</a>',
           'North Central' , '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=7">North Central Florida</a>',
           'North Eastern' , '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=4">North Eastern Florida</a>',
           'North West'    , '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5">North West Florida</a>',
           'South Central' , '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=8">South Central Florida</a>',
           'South East'    , '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=1">South East Florida</a>',
           'South West'    , '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=6">South West Florida</a>',
           'Tampa'         , 'the <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=2">Tampa Bay region of Florida</a>')  region
    ,      c.city_id
    ,      c.census_place
    ,      c.region_id
    ,      c.county
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
    v_city_url varchar2(1024);


  begin
    pr_rets_pkg.put_line('--------------------------------------------------------------- ');
    pr_rets_pkg.put_line('---- Counties' );
    pr_rets_pkg.put_line('--------------------------------------------------------------- ');
    
    for c_rec in cur_counties loop
       v_gen_text := '';
       v_gen_text := c_rec.name||' is in '||c_rec.region||'.';
       v_count := 1;
       for t_rec in cur_county_cities(upper(c_rec.county)) loop
         v_city_url := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county='
                      ||upper(replace(c_rec.county, ' ', '%20'))
                      ||'&city='||upper(replace(t_rec.city, ' ', '%20'))
                      ||'&region_id='||c_rec.region_id||'">'||t_rec.city||'</a>';
         if t_rec.population > 1 then
           v_city := v_city_url||' (population '||to_char(t_rec.population, 'fm9,999,999')||')';
         else
           v_city := v_city_url;
         end if;
       
         if v_count = 1 then
           v_gen_text := v_gen_text||'  The main cities in '
                         ||c_rec.name||' are '
                         ||v_city;
         elsif v_count = 2 then
           v_gen_text := v_gen_text||', '||v_city;
         elsif v_count = 3 then
           v_gen_text := v_gen_text||' and '||v_city;         
         end if;
         v_count := v_count + 1;
       end loop;
       
       
       v_text := v_gen_text;
 
      dbms_output.put_line('v_text('''||upper(c_rec.county)||''') := '''||v_text||''';');
       
    end loop;

  end gen_text;
begin
  gen_text;
end;
/
