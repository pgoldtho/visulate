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
                          ||'<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county='
                          ||n_rec.county||'&city='||n_rec.name||'&region_id='||n_rec.region_id||'">'
                          ||n_rec.display_name||'</a>'
                          ||' (population '
                          ||to_char(n_rec.population, 'fm9,999,999')||')';
        elsif v_count = 2 then
           v_return := v_return ||' and around '
                          ||round(n_rec.distance)||' miles from '
                          ||'<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county='
                          ||n_rec.county||'&city='||n_rec.name||'&region_id='||n_rec.region_id||'">'
                          ||n_rec.display_name||'</a>'
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
    from rnt_cities c
    ,    rnt_regions r
    where c.state = 'FL'
    and c.name != 'ANY'
    and c.region_id = r.region_id
    order by 5, 1;

    v_region   varchar(1024) := 'none';
    v_gen_text varchar2(32767);
    v_text     varchar2(32767);
    v_nn       varchar2(4096);
    v_matrix   census2010matrix%rowtype;

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

      if c_rec.census_place is not null then
        select * into v_matrix
        from census2010matrix m
        where  m.logrecno = (select logrecno
                             from census2010profile
                             where place = c_rec.census_place);
        v_gen_text := v_gen_text ||'</p><p>';
        v_gen_text := v_gen_text ||'The median age for residents of '||c_rec.name||' is '||v_matrix.dpsf0020001||'.  Around ';

        
        v_gen_text := v_gen_text ||trunc(v_matrix.dpsf0140001/v_matrix.dpsf0130001*100, 1)||'%'
                    ||' of '||c_rec.name||' households include school aged children and ';
        v_gen_text := v_gen_text ||trunc(v_matrix.dpsf0150001/v_matrix.dpsf0130001*100, 1)||'%'
                    ||' of households include individuals aged 65 years or over.';

        v_gen_text := v_gen_text||'  Census records indicate '
               ||trunc(v_matrix.dpsf0080003/v_matrix.dpsf0080001*100, 1)||'% of the '
               ||c_rec.name||' population are White, '
               ||trunc(v_matrix.dpsf0080004/v_matrix.dpsf0080001*100, 1)||'% are Black or African American, '
               ||trunc(v_matrix.dpsf0080005/v_matrix.dpsf0080001*100, 1)||'% American Indian, '
               ||trunc(v_matrix.dpsf0080006/v_matrix.dpsf0080001*100, 1)||'% Asian and '
               ||trunc(v_matrix.dpsf0080020/v_matrix.dpsf0080001*100, 1)||'% are Two or more Races.';


        if v_matrix.dpsf0100002/v_matrix.dpsf0100001 > 0.2 then
          v_gen_text := v_gen_text||'  '||c_rec.name||' has a significant Hispanic population. '
               ||trunc(v_matrix.dpsf0100002/v_matrix.dpsf0100001*100, 1)||'% ('
               ||to_char(v_matrix.dpsf0100002,'fm9,999,999')||') of '
               ||c_rec.name||' residents are of Hispanic or Latino origin.'
               ||'  Of these '
               ||trunc(v_matrix.dpsf0100003/v_matrix.dpsf0100002*100, 2)||'% are of Mexican origin, '
               ||trunc(v_matrix.dpsf0100004/v_matrix.dpsf0100002*100, 2)||'% Puerto Rican, '
               ||trunc(v_matrix.dpsf0100005/v_matrix.dpsf0100002*100, 2)||'% Cuban and '
               ||trunc(v_matrix.dpsf0100006/v_matrix.dpsf0100002*100, 2)||'% are of other Hispanic or Latino origin.';
        end if;
        v_gen_text := v_gen_text ||'</p><p>';
        
        v_gen_text := v_gen_text ||'  There are '||to_char(v_matrix.dpsf0180001, 'fm9,999,999')
                       ||' housing units in '||c_rec.name||'.  '
                       ||to_char(v_matrix.dpsf0180003, 'fm9,999,999')||' ('
                       ||trunc(v_matrix.dpsf0180003/v_matrix.dpsf0180001*100,1)||'%)'
                       ||' of these were reported as vacant in the 2010 Census.';
        if (v_matrix.dpsf0180008/v_matrix.dpsf0180003) > 0.25 then
          v_gen_text := v_gen_text ||'  '||c_rec.name||' is a tourist destination, '
            ||trunc(v_matrix.dpsf0180008/v_matrix.dpsf0180003*100, 1)||'% ('
            ||to_char(v_matrix.dpsf0180008, 'fm9,999,999')
            ||') of it''s vacant housing units were classed as seasonal, recreational or for occasional use.';
        end if;

        v_gen_text := v_gen_text ||'  There are '
                   ||to_char((v_matrix.dpsf0210003 + v_matrix.dpsf0180004 +  v_matrix.dpsf0180005), 'fm9,999,999')
                   ||' residential rental units in '||c_rec.name
                   ||'.  '||to_char(v_matrix.dpsf0210003,'fm9,999,999')
                   ||' of them were occupied in 2010 providing a residential rental vacancy rate of '
                   ||v_matrix.dpsf0200001||'%.';
                   

        
      end if;


      v_text := c_rec.description||chr(10)||'<div id="censusData"><p>'||v_gen_text||'</p></div>';

      if c_rec.census_place is not null then
        dbms_output.put_line('update rnt_cities'||chr(10)
                         ||'set population = '||c_rec.population||chr(10)
                         ||',   pop_source = ''2010 Census'''||chr(10)
                         ||',   census_place = '''||c_rec.census_place||''''||chr(10)
                         ||',   description = '''||replace(v_text, '''', '''''')||''''||chr(10)
                         ||'where city_id = '||c_rec.city_id||';'||chr(10));
     else
        dbms_output.put_line('update rnt_cities'||chr(10)
                         ||'set description = '''||replace(v_text, '''', '''''')||''''||chr(10)
                         ||'where city_id = '||c_rec.city_id||';'||chr(10));
     end if;

      
--      pr_rets_pkg.put_line('add_link('||c_rec.city_id||', '''', '''');');
      
    end loop;

  end gen_text;
begin
  gen_text;
end;
/
