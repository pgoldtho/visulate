set define ^
create or replace package mls_price_ranges_pkg as

  type tax_rec_type is record
  ( source_id           number
  , display_name        varchar2(256)
  , link_name           varchar2(32));

  function get_county_desc(p_cou in varchar2)  return varchar2;
  
  procedure get_rentals( X_COUNTY    in varchar2
                           , X_TAB_NAME  in varchar2
                           , X_MENU_NAME in varchar2
                           , X_PAGE_NAME in varchar2
                           , X_SUB_PAGE  in varchar2 );
                       
 procedure latest_listings( X_TAB_NAME  in varchar2
                              , X_MENU_NAME in varchar2
                              , X_PAGE_NAME in varchar2
                              , X_SUB_PAGE  in varchar2
                              , X_DATE      in date
                              , X_COUNTY    in varchar2);

  procedure set_range
    ( X_ZCODE         in mls_price_ranges.ZCODE%type
    , X_LISTING_TYPE  in mls_price_ranges.LISTING_TYPE%type
    , X_QUERY_TYPE    in mls_price_ranges.QUERY_TYPE%type
    , X_RANGE_DATE    in mls_price_ranges.RANGE_DATE%type
    , X_SOURCE_ID     in mls_price_ranges.SOURCE_ID%type
    , X_COUNTY        in mls_price_ranges.COUNTY%type
    , X_STATE         in mls_price_ranges.STATE%type
    , X_NAME          in mls_price_ranges.NAME%type
    , X_A_MAX         in mls_price_ranges.A_MAX%type
    , X_A_MEDIAN      in mls_price_ranges.A_MEDIAN%type
    , X_A_MIN         in mls_price_ranges.A_MIN%type
    , X_B_MEDIAN      in mls_price_ranges.B_MEDIAN%type
    , X_C_MAX         in mls_price_ranges.C_MAX%type
    , X_C_MEDIAN      in mls_price_ranges.C_MEDIAN%type
    , X_C_MIN         in mls_price_ranges.C_MIN%type
    , X_TOTAL         in mls_price_ranges.TOTAL%type);
    
  procedure set_price_ranges( p_county_name in varchar2
                            , p_source_id   in number);
                            
  procedure update_static_pages(p_mls in varchar2);
  procedure update_static_pages;
end mls_price_ranges_pkg;
/

create or replace package body mls_price_ranges_pkg as

  function get_county_desc(p_cou in varchar2)  return varchar2 is
    type text_list_type is table of varchar2(32767) index by varchar2(256);
    v_text    text_list_type;
    v_index   varchar2(128);
  begin
    v_index := upper(p_cou);
    v_index := replace(v_index, ' PROPERTY APPRAISER');
    v_index := replace(v_index, ' COUNTY');
    if (v_index = 'MIAMI DADE') then v_index := 'MIAMI-DADE'; end if;
  
v_text('ALACHUA') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ALACHUA&region_id=7">Alachua County</a>
is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=7">North Central Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ALACHUA&region_id=7">Alachua County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ALACHUA&city=GAINESVILLE&region_id=7">Gainesville</a> (population
124,354), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ALACHUA&city=ALACHUA&region_id=7">Alachua</a>
(population 9,059) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ALACHUA&city=HIGH%20SPRINGS&region_id=7">High Springs</a>
(population 5,350)';
v_text('BAKER') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAKER&region_id=4">Baker County</a> is in
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=4">North Eastern Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAKER&region_id=4">Baker County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAKER&city=MACCLENNY&region_id=4">Macclenny</a> (population
6,374), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAKER&city=GLEN%20SAINT%20MARY&region_id=4">Glen Saint
Mary</a> (population 437) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAKER&city=SANDERSON&region_id=4">Sanderson</a>';
v_text('BAY') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAY&region_id=5">Bay County</a> is in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5">North West Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAY&region_id=5">Bay County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAY&city=PANAMA%20CITY&region_id=5">Panama City</a> (population
36,484), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAY&city=LYNN%20HAVEN&region_id=5">Lynn Haven</a>
(population 18,493) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAY&city=PANAMA%20CITY%20BEACH&region_id=5">Panama City Beach</a>
(population 12,018)';
v_text('BRADFORD') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BRADFORD&region_id=7">Bradford
County</a> is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=7">North Central Florida</a>.  The main
cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BRADFORD&region_id=7">Bradford County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BRADFORD&city=STARKE&region_id=7">Starke</a> (population 5,449),
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BRADFORD&city=LAWTEY&region_id=7">Lawtey</a> (population 730)
and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BRADFORD&city=HAMPTON&region_id=7">Hampton</a> (population
500)';
v_text('BREVARD') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BREVARD&region_id=3">Brevard County</a>
is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=3">East Central Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BREVARD&region_id=3">Brevard County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BREVARD&city=PALM%20BAY&region_id=3">Palm Bay</a> (population
103,190), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BREVARD&city=MELBOURNE&region_id=3">Melbourne</a>
(population 76,068) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BREVARD&city=TITUSVILLE&region_id=3">Titusville</a> (population
43,761)';
v_text('BROWARD') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BROWARD&region_id=1">Broward County</a>
is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=1">South East Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BROWARD&region_id=1">Broward County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BROWARD&city=FORT%20LAUDERDALE&region_id=1">Fort Lauderdale</a>
(population 165,521), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BROWARD&city=PEMBROKE%20PINES&region_id=1">Pembroke Pines</a>
(population 154,750) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BROWARD&city=HOLLYWOOD&region_id=1">Hollywood</a> (population
140,768)';
v_text('CALHOUN') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CALHOUN&region_id=5">Calhoun County</a>
is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5">North West Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CALHOUN&region_id=5">Calhoun County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CALHOUN&city=BLOUNTSTOWN&region_id=5">Blountstown</a> (population
2,514), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CALHOUN&city=WEWAHITCHKA&region_id=5">Wewahitchka</a>
(population 1,981) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CALHOUN&city=ALTHA&region_id=5">Altha</a> (population 536)';
v_text('CHARLOTTE') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CHARLOTTE&region_id=6">Charlotte
County</a> is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=6">South West Florida</a>.  The main
cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CHARLOTTE&region_id=6">Charlotte County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CHARLOTTE&city=PORT%20CHARLOTTE&region_id=6">Port Charlotte</a>
(population 54,392), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CHARLOTTE&city=PUNTA%20GORDA&region_id=6">Punta Gorda</a>
(population 16,641) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CHARLOTTE&city=ENGLEWOOD&region_id=6">Englewood</a> (population
14,863)';
v_text('CITRUS') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CITRUS&region_id=2">Citrus County</a> is
in the <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=2">Tampa Bay region of Florida</a>.  The main cities
in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CITRUS&region_id=2">Citrus County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CITRUS&city=HOMOSASSA%20SPRINGS&region_id=2">Homosassa
Springs</a> (population 13,791), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CITRUS&city=HERNANDO&region_id=2">Hernando</a> (population 9,054)
and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CITRUS&city=BEVERLY%20HILLS&region_id=2">Beverly Hills</a>
(population 8,445)';
v_text('CLAY') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CLAY&region_id=4">Clay County</a> is in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=4">North Eastern Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CLAY&region_id=4">Clay County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CLAY&city=FLEMING%20ISLAND&region_id=4">Fleming Island</a>
(population 27,126), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CLAY&city=MIDDLEBURG&region_id=4">Middleburg</a> (population
13,008) and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CLAY&city=ORANGE%20PARK&region_id=4">Orange
Park</a> (population 8,412)';
v_text('COLLIER') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLLIER&region_id=6">Collier County</a>
is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=6">South West Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLLIER&region_id=6">Collier County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLLIER&city=IMMOKALEE&region_id=6">Immokalee</a> (population
24,154), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLLIER&city=NAPLES&region_id=6">Naples</a>
(population 19,537) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLLIER&city=MARCO%20ISLAND&region_id=6">Marco Island</a>
(population 16,413)';
v_text('COLUMBIA') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLUMBIA&region_id=7">Columbia
County</a> is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=7">North Central Florida</a>.  The main
cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLUMBIA&region_id=7">Columbia County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLUMBIA&city=LAKE%20CITY&region_id=7">Lake City</a> (population
12,046), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLUMBIA&city=FORT%20WHITE&region_id=7">Fort
White</a> (population 567) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLUMBIA&city=LULU&region_id=7">Lulu</a>';
v_text('DESOTO') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DESOTO&region_id=8">Desoto County</a> is
in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=8">South Central Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DESOTO&region_id=8">Desoto County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DESOTO&city=ARCADIA&region_id=8">Arcadia</a> (population 7,637),
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DESOTO&city=NOCATEE&region_id=8">Nocatee</a> (population
4,524) and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DESOTO&city=FORT%20OGDEN&region_id=8">Fort
Ogden</a>';
v_text('DIXIE') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DIXIE&region_id=7">Dixie County</a> is in
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=7">North Central Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DIXIE&region_id=7">Dixie County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DIXIE&city=CROSS%20CITY&region_id=7">Cross City</a> (population
1,728), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DIXIE&city=HORSESHOE%20BEACH&region_id=7">Horseshoe
Beach</a> (population 169) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DIXIE&city=OLD%20TOWN&region_id=7">Old Town</a>';
v_text('DUVAL') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DUVAL&region_id=4">Duval County</a> is in
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=4">North Eastern Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DUVAL&region_id=4">Duval County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DUVAL&city=JACKSONVILLE&region_id=4">Jacksonville</a> (population
821,784), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DUVAL&city=JACKSONVILLE%20BEACH&region_id=4">Jacksonville
Beach</a> (population 21,362) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DUVAL&city=ATLANTIC%20BEACH&region_id=4">Atlantic Beach</a>
(population 12,655)';
v_text('ESCAMBIA') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ESCAMBIA&region_id=5">Escambia
County</a> is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5">North West Florida</a>.  The main
cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ESCAMBIA&region_id=5">Escambia County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ESCAMBIA&city=PENSACOLA&region_id=5">Pensacola</a> (population
51,923), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ESCAMBIA&city=GONZALEZ&region_id=5">Gonzalez</a>
(population 13,273) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ESCAMBIA&city=CENTURY&region_id=5">Century</a> (population
1,698)';
v_text('FLAGLER') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FLAGLER&region_id=4">Flagler County</a>
is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=4">North Eastern Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FLAGLER&region_id=4">Flagler County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FLAGLER&city=PALM%20COAST&region_id=4">Palm Coast</a> (population
75,180), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FLAGLER&city=FLAGLER%20BEACH&region_id=4">Flagler
Beach</a> (population 4,484) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FLAGLER&city=BUNNELL&region_id=4">Bunnell</a> (population
2,676)';
v_text('FRANKLIN') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FRANKLIN&region_id=5">Franklin
County</a> is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5">North West Florida</a>.  The main
cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FRANKLIN&region_id=5">Franklin County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FRANKLIN&city=CARRABELLE&region_id=5">Carrabelle</a> (population
2,778), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FRANKLIN&city=EASTPOINT&region_id=5">Eastpoint</a>
(population 2,337) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FRANKLIN&city=APALACHICOLA&region_id=5">Apalachicola</a>
(population 2,231)';
v_text('GADSDEN') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GADSDEN&region_id=5">Gadsden County</a>
is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5">North West Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GADSDEN&region_id=5">Gadsden County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GADSDEN&city=QUINCY&region_id=5">Quincy</a> (population 7,972),
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GADSDEN&city=CHATTAHOOCHEE&region_id=5">Chattahoochee</a>
(population 3,652) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GADSDEN&city=HAVANA&region_id=5">Havana</a> (population 1,754)';
v_text('GILCHRIST') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GILCHRIST&region_id=7">Gilchrist
County</a> is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=7">North Central Florida</a>.  The main
cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GILCHRIST&region_id=7">Gilchrist County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GILCHRIST&city=TRENTON&region_id=7">Trenton</a> (population
1,999), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GILCHRIST&city=BELL&region_id=7">Bell</a> (population
456)';
v_text('GLADES') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GLADES&region_id=8">Glades County</a> is
in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=8">South Central Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GLADES&region_id=8">Glades County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GLADES&city=MOORE%20HAVEN&region_id=8">Moore Haven</a>
(population 1,680), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GLADES&city=PALMDALE&region_id=8">Palmdale</a>';
v_text('GULF') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GULF&region_id=5">Gulf County</a> is in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5">North West Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GULF&region_id=5">Gulf County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GULF&city=PORT%20SAINT%20JOE&region_id=5">Port Saint Joe</a>
(population 3,445), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GULF&city=WEWAHITCHKA&region_id=5">Wewahitchka</a> (population
1,981)';
v_text('HAMILTON') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HAMILTON&region_id=7">Hamilton
County</a> is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=7">North Central Florida</a>.  The main
cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HAMILTON&region_id=7">Hamilton County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HAMILTON&city=JASPER&region_id=7">Jasper</a> (population 4,546),
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HAMILTON&city=JENNINGS&region_id=7">Jennings</a> (population
878) and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HAMILTON&city=WHITE%20SPRINGS&region_id=7">White
Springs</a> (population 777)';
v_text('HARDEE') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HARDEE&region_id=8">Hardee County</a> is
in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=8">South Central Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HARDEE&region_id=8">Hardee County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HARDEE&city=WAUCHULA&region_id=8">Wauchula</a> (population
5,001), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HARDEE&city=BOWLING%20GREEN&region_id=8">Bowling
Green</a> (population 2,930) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HARDEE&city=ZOLFO%20SPRINGS&region_id=8">Zolfo Springs</a>
(population 1,827)';
v_text('HENDRY') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HENDRY&region_id=8">Hendry County</a> is
in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=8">South Central Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HENDRY&region_id=8">Hendry County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HENDRY&city=CLEWISTON&region_id=8">Clewiston</a> (population
7,155), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HENDRY&city=LABELLE&region_id=8">Labelle</a>
(population 4,640) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HENDRY&city=FELDA&region_id=8">Felda</a>';
v_text('HERNANDO') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HERNANDO&region_id=2">Hernando
County</a> is in the <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=2">Tampa Bay region of Florida</a>.
The main cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HERNANDO&region_id=2">Hernando County</a>
are <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HERNANDO&city=SPRING%20HILL&region_id=2">Spring Hill</a>
(population 98,621), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HERNANDO&city=BROOKSVILLE&region_id=2">Brooksville</a>
(population 7,719) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HERNANDO&city=NOBLETON&region_id=2">Nobleton</a> (population
282)';
v_text('HIGHLANDS') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HIGHLANDS&region_id=8">Highlands
County</a> is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=8">South Central Florida</a>.  The main
cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HIGHLANDS&region_id=8">Highlands County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HIGHLANDS&city=SEBRING&region_id=8">Sebring</a> (population
10,491), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HIGHLANDS&city=AVON%20PARK&region_id=8">Avon Park</a>
(population 8,836) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HIGHLANDS&city=LAKE%20PLACID&region_id=8">Lake Placid</a>
(population 2,223)';
v_text('HILLSBOROUGH') := '<a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HILLSBOROUGH&region_id=2">Hillsborough County</a> is in the <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=2">Tampa Bay region of Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HILLSBOROUGH&region_id=2">Hillsborough County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HILLSBOROUGH&city=TAMPA&region_id=2">Tampa</a> (population
335,709), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HILLSBOROUGH&city=BRANDON&region_id=2">Brandon</a>
(population 103,483) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HILLSBOROUGH&city=RIVERVIEW&region_id=2">Riverview</a>
(population 71,050)';
v_text('HOLMES') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HOLMES&region_id=5">Holmes County</a> is
in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5">North West Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HOLMES&region_id=5">Holmes County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HOLMES&city=BONIFAY&region_id=5">Bonifay</a> (population 2,793),
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HOLMES&city=WESTVILLE&region_id=5">Westville</a> (population
289) and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HOLMES&city=NOMA&region_id=5">Noma</a> (population
211)';
v_text('INDIAN RIVER') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=INDIAN%20RIVER&region_id=1">Indian
River County</a> is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=1">South East Florida</a>.  The main
cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=INDIAN%20RIVER&region_id=1">Indian River County</a>
are <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=INDIAN%20RIVER&city=SEBASTIAN&region_id=1">Sebastian</a>
(population 21,929), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=INDIAN%20RIVER&city=VERO%20BEACH&region_id=1">Vero Beach</a>
(population 15,220) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=INDIAN%20RIVER&city=FELLSMERE&region_id=1">Fellsmere</a>
(population 5,197)';
v_text('JACKSON') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JACKSON&region_id=5">Jackson County</a>
is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5">North West Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JACKSON&region_id=5">Jackson County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JACKSON&city=MARIANNA&region_id=5">Marianna</a> (population
6,102), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JACKSON&city=GRACEVILLE&region_id=5">Graceville</a>
(population 2,278) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JACKSON&city=MALONE&region_id=5">Malone</a> (population 2,088)';
v_text('JEFFERSON') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JEFFERSON&region_id=5">Jefferson
County</a> is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5">North West Florida</a>.  The main
cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JEFFERSON&region_id=5">Jefferson County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JEFFERSON&city=MONTICELLO&region_id=5">Monticello</a> (population
2,506), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JEFFERSON&city=WACISSA&region_id=5">Wacissa</a>
(population 386) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JEFFERSON&city=LLOYD&region_id=5">Lloyd</a> (population 215)';
v_text('LAFAYETTE') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAFAYETTE&region_id=7">Lafayette
County</a> is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=7">North Central Florida</a>.  The main
cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAFAYETTE&region_id=7">Lafayette County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAFAYETTE&city=MAYO&region_id=7">Mayo</a> (population 1,237), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAFAYETTE&city=DAY&region_id=7">Day</a> (population 116)';
v_text('LAKE') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAKE&region_id=3">Lake County</a> is in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=3">East Central Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAKE&region_id=3">Lake County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAKE&city=CLERMONT&region_id=3">Clermont</a> (population 28,742),
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAKE&city=LEESBURG&region_id=3">Leesburg</a> (population
20,117) and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAKE&city=EUSTIS&region_id=3">Eustis</a>
(population 18,558)';
v_text('LEE') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEE&region_id=6">Lee County</a> is in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=6">South West Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEE&region_id=6">Lee County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEE&city=CAPE%20CORAL&region_id=6">Cape Coral</a> (population
154,305), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEE&city=LEHIGH%20ACRES&region_id=6">Lehigh
Acres</a> (population 86,784) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEE&city=FORT%20MYERS&region_id=6">Fort Myers</a> (population
62,298)';
v_text('LEON') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEON&region_id=5">Leon County</a> is in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5">North West Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEON&region_id=5">Leon County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEON&city=TALLAHASSEE&region_id=5">Tallahassee</a> (population
181,376), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEON&city=WOODVILLE&region_id=5">Woodville</a>
(population 2,978)';
v_text('LEVY') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEVY&region_id=7">Levy County</a> is in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=7">North Central Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEVY&region_id=7">Levy County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEVY&city=WILLISTON&region_id=7">Williston</a> (population
2,768), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEVY&city=CHIEFLAND&region_id=7">Chiefland</a>
(population 2,245) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEVY&city=INGLIS&region_id=7">Inglis</a> (population 1,325)';
v_text('LIBERTY') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LIBERTY&region_id=5">Liberty County</a>
is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5">North West Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LIBERTY&region_id=5">Liberty County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LIBERTY&city=BRISTOL&region_id=5">Bristol</a> (population 996),
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LIBERTY&city=HOSFORD&region_id=5">Hosford</a> (population 650)
and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LIBERTY&city=SUMATRA&region_id=5">Sumatra</a> (population
148)';
v_text('MADISON') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MADISON&region_id=7">Madison County</a>
is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=7">North Central Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MADISON&region_id=7">Madison County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MADISON&city=MADISON&region_id=7">Madison</a> (population 2,843),
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MADISON&city=GREENVILLE&region_id=7">Greenville</a>
(population 843) and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MADISON&city=LEE&region_id=7">Lee</a>
(population 352)';
v_text('MANATEE') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MANATEE&region_id=2">Manatee County</a>
is in the <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=2">Tampa Bay region of Florida</a>.  The main
cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MANATEE&region_id=2">Manatee County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MANATEE&city=SARASOTA&region_id=2">Sarasota</a> (population
51,917), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MANATEE&city=BRADENTON&region_id=2">Bradenton</a>
(population 49,546) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MANATEE&city=PALMETTO&region_id=2">Palmetto</a> (population
12,606)';
v_text('MARION') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARION&region_id=7">Marion County</a> is
in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=7">North Central Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARION&region_id=7">Marion County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARION&city=OCALA&region_id=7">Ocala</a> (population 56,315), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARION&city=SILVER%20SPRINGS&region_id=7">Silver Springs</a>
(population 6,539) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARION&city=BELLEVIEW&region_id=7">Belleview</a> (population
4,492)';
v_text('MARTIN') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARTIN&region_id=1">Martin County</a> is
in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=1">South East Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARTIN&region_id=1">Martin County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARTIN&city=PALM%20CITY&region_id=1">Palm City</a> (population
23,120), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARTIN&city=STUART&region_id=1">Stuart</a>
(population 15,593) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARTIN&city=JENSEN%20BEACH&region_id=1">Jensen Beach</a>
(population 11,707)';
v_text('MIAMI-DADE') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MIAMI-DADE&region_id=1">Miami-Dade
County</a> is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=1">South East Florida</a>.  The main
cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MIAMI-DADE&region_id=1">Miami-Dade County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MIAMI-DADE&city=MIAMI&region_id=1">Miami</a> (population
399,457), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MIAMI-DADE&city=HIALEAH&region_id=1">Hialeah</a>
(population 224,669) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MIAMI-DADE&city=MIAMI%20BEACH&region_id=1">Miami Beach</a>
(population 87,779)';
v_text('MONROE') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MONROE&region_id=1">Monroe County</a> is
in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=1">South East Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MONROE&region_id=1">Monroe County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MONROE&city=KEY%20WEST&region_id=1">Key West</a> (population
24,649), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MONROE&city=KEY%20LARGO&region_id=1">Key Largo</a>
(population 10,433) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MONROE&city=MARATHON&region_id=1">Marathon</a> (population
8,297)';
v_text('NASSAU') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=NASSAU&region_id=4">Nassau County</a> is
in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=4">North Eastern Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=NASSAU&region_id=4">Nassau County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=NASSAU&city=YULEE&region_id=4">Yulee</a> (population 11,491), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=NASSAU&city=FERNANDINA%20BEACH&region_id=4">Fernandina Beach</a>
(population 11,487) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=NASSAU&city=HILLIARD&region_id=4">Hilliard</a> (population
3,086)';
v_text('OKALOOSA') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKALOOSA&region_id=5">Okaloosa
County</a> is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5">North West Florida</a>.  The main
cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKALOOSA&region_id=5">Okaloosa County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKALOOSA&city=CRESTVIEW&region_id=5">Crestview</a> (population
20,978), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKALOOSA&city=FORT%20WALTON%20BEACH&region_id=5">Fort
Walton Beach</a> (population 19,507) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKALOOSA&city=NICEVILLE&region_id=5">Niceville</a> (population
12,749)';
v_text('OKEECHOBEE') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKEECHOBEE&region_id=8">Okeechobee
County</a> is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=8">South Central Florida</a>.  The main
cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKEECHOBEE&region_id=8">Okeechobee County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKEECHOBEE&city=OKEECHOBEE&region_id=8">Okeechobee</a>
(population 5,621)';
v_text('ORANGE') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ORANGE&region_id=3">Orange County</a> is
in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=3">East Central Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ORANGE&region_id=3">Orange County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ORANGE&city=ORLANDO&region_id=3">Orlando</a> (population
238,300), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ORANGE&city=APOPKA&region_id=3">Apopka</a>
(population 41,542) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ORANGE&city=OCOEE&region_id=3">Ocoee</a> (population 35,579)';
v_text('OSCEOLA') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OSCEOLA&region_id=3">Osceola County</a>
is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=3">East Central Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OSCEOLA&region_id=3">Osceola County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OSCEOLA&city=KISSIMMEE&region_id=3">Kissimmee</a> (population
59,682), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OSCEOLA&city=SAINT%20CLOUD&region_id=3">Saint
Cloud</a> (population 35,183) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OSCEOLA&city=INTERCESSION%20CITY&region_id=3">Intercession
City</a>';
v_text('PALM BEACH') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PALM%20BEACH&region_id=1">Palm Beach
County</a> is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=1">South East Florida</a>.  The main
cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PALM%20BEACH&region_id=1">Palm Beach County</a> are
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PALM%20BEACH&city=WEST%20PALM%20BEACH&region_id=1">West Palm
Beach</a> (population 99,919), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PALM%20BEACH&city=BOCA%20RATON&region_id=1">Boca Raton</a>
(population 84,392) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PALM%20BEACH&city=BOYNTON%20BEACH&region_id=1">Boynton Beach</a>
(population 68,217)';
v_text('PASCO') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PASCO&region_id=2">Pasco County</a> is in
the <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=2">Tampa Bay region of Florida</a>.  The main cities in
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PASCO&region_id=2">Pasco County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PASCO&city=SPRING%20HILL&region_id=2">Spring Hill</a> (population
98,621), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PASCO&city=WESLEY%20CHAPEL&region_id=2">Wesley
Chapel</a> (population 44,092) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PASCO&city=LAND%20O%20LAKES&region_id=2">Land O Lakes</a>
(population 31,996)';
v_text('PINELLAS') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PINELLAS&region_id=2">Pinellas
County</a> is in the <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=2">Tampa Bay region of Florida</a>.
The main cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PINELLAS&region_id=2">Pinellas County</a>
are <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PINELLAS&city=SAINT%20PETERSBURG&region_id=2">Saint
Petersburg</a> (population 244,769), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PINELLAS&city=CLEARWATER%20BEACH&region_id=2">Clearwater
Beach</a> (population 107,685) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PINELLAS&city=LARGO&region_id=2">Largo</a> (population 77,648)';
v_text('POLK') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=POLK&region_id=2">Polk County</a> is in the
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=2">Tampa Bay region of Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=POLK&region_id=2">Polk County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=POLK&city=LAKELAND&region_id=2">Lakeland</a> (population 97,422),
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=POLK&city=KISSIMMEE&region_id=2">Kissimmee</a> (population
59,682) and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=POLK&city=WINTER%20HAVEN&region_id=2">Winter
Haven</a> (population 33,874)';
v_text('PUTNAM') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PUTNAM&region_id=4">Putnam County</a> is
in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=4">North Eastern Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PUTNAM&region_id=4">Putnam County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PUTNAM&city=PALATKA&region_id=4">Palatka</a> (population 10,558),
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PUTNAM&city=EAST%20PALATKA&region_id=4">East Palatka</a>
(population 1,654) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PUTNAM&city=CRESCENT%20CITY&region_id=4">Crescent City</a>
(population 1,577)';
v_text('SAINT JOHNS') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20JOHNS&region_id=4">Saint
Johns County</a> is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=4">North Eastern Florida</a>.  The
main cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20JOHNS&region_id=4">Saint Johns
County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20JOHNS&city=JACKSONVILLE&region_id=4">Jacksonville</a>
(population 821,784), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20JOHNS&city=SAINT%20AUGUSTINE&region_id=4">Saint
Augustine</a> (population 12,975) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20JOHNS&city=HASTINGS&region_id=4">Hastings</a> (population
580)';
v_text('SAINT LUCIE') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20LUCIE&region_id=1">Saint
Lucie County</a> is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=1">South East Florida</a>.  The main
cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20LUCIE&region_id=1">Saint Lucie County</a>
are <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20LUCIE&city=PORT%20SAINT%20LUCIE&region_id=1">Port
Saint Lucie</a> (population 164,603), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20LUCIE&city=FORT%20PIERCE&region_id=1">Fort Pierce</a>
(population 41,590)';
v_text('SANTA ROSA') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA%20ROSA&region_id=5">Santa Rosa
County</a> is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5">North West Florida</a>.  The main
cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA%20ROSA&region_id=5">Santa Rosa County</a> are
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA%20ROSA&city=NAVARRE&region_id=5">Navarre</a> (population
31,378), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA%20ROSA&city=MILTON&region_id=5">Milton</a>
(population 8,826) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA%20ROSA&city=GULF%20BREEZE&region_id=5">Gulf Breeze</a>
(population 5,763)';
v_text('SARASOTA') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SARASOTA&region_id=2">Sarasota
County</a> is in the <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=2">Tampa Bay region of Florida</a>.
The main cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SARASOTA&region_id=2">Sarasota County</a>
are <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SARASOTA&city=NORTH%20PORT&region_id=2">North Port</a>
(population 57,357), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SARASOTA&city=SARASOTA&region_id=2">Sarasota</a> (population
51,917) and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SARASOTA&city=VENICE&region_id=2">Venice</a>
(population 20,748)';
v_text('SEMINOLE') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SEMINOLE&region_id=3">Seminole
County</a> is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=3">East Central Florida</a>.  The main
cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SEMINOLE&region_id=3">Seminole County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SEMINOLE&city=SANFORD&region_id=3">Sanford</a> (population
53,570), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SEMINOLE&city=ALTAMONTE%20SPRINGS&region_id=3">Altamonte
Springs</a> (population 41,496) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SEMINOLE&city=OVIEDO&region_id=3">Oviedo</a> (population
33,342)';
v_text('SUMTER') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUMTER&region_id=3">Sumter County</a> is
in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=3">East Central Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUMTER&region_id=3">Sumter County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUMTER&city=THE%20VILLAGES&region_id=3">The Villages</a>
(population 51,442), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUMTER&city=WILDWOOD&region_id=3">Wildwood</a> (population 6,709)
and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUMTER&city=LAKE%20PANASOFFKEE&region_id=3">Lake
Panasoffkee</a> (population 3,551)';
v_text('SUWANNEE') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUWANNEE&region_id=7">Suwannee
County</a> is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=7">North Central Florida</a>.  The main
cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUWANNEE&region_id=7">Suwannee County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUWANNEE&city=LIVE%20OAK&region_id=7">Live Oak</a> (population
6,850), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUWANNEE&city=BRANFORD&region_id=7">Branford</a>
(population 712) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUWANNEE&city=WELLBORN&region_id=7">Wellborn</a>';
v_text('TAYLOR') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=TAYLOR&region_id=7">Taylor County</a> is
in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=7">North Central Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=TAYLOR&region_id=7">Taylor County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=TAYLOR&city=PERRY&region_id=7">Perry</a> (population 7,017), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=TAYLOR&city=STEINHATCHEE&region_id=7">Steinhatchee</a>
(population 1,047) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=TAYLOR&city=SHADY%20GROVE&region_id=7">Shady Grove</a>';
v_text('UNION') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=UNION&region_id=7">Union County</a> is in
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=7">North Central Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=UNION&region_id=7">Union County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=UNION&city=LAKE%20BUTLER&region_id=7">Lake Butler</a> (population
1,897), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=UNION&city=RAIFORD&region_id=7">Raiford</a>
(population 255) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=UNION&city=WORTHINGTON%20SPRINGS&region_id=7">Worthington
Springs</a> (population 181)';
v_text('VOLUSIA') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=VOLUSIA&region_id=3">Volusia County</a>
is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=3">East Central Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=VOLUSIA&region_id=3">Volusia County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=VOLUSIA&city=DELTONA&region_id=3">Deltona</a> (population
85,182), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=VOLUSIA&city=DAYTONA%20BEACH&region_id=3">Daytona
Beach</a> (population 61,005) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=VOLUSIA&city=PORT%20ORANGE&region_id=3">Port Orange</a>
(population 56,048)';
v_text('WAKULLA') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WAKULLA&region_id=5">Wakulla County</a>
is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5">North West Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WAKULLA&region_id=5">Wakulla County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WAKULLA&city=CRAWFORDVILLE&region_id=5">Crawfordville</a>
(population 3,702), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WAKULLA&city=PANACEA&region_id=5">Panacea</a> (population 816)
and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WAKULLA&city=SOPCHOPPY&region_id=5">Sopchoppy</a>
(population 457)';
v_text('WALTON') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WALTON&region_id=5">Walton County</a> is
in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5">North West Florida</a>.  The main cities in <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WALTON&region_id=5">Walton County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WALTON&city=MIRAMAR%20BEACH&region_id=5">Miramar Beach</a>
(population 6,146), <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WALTON&city=DEFUNIAK%20SPRINGS&region_id=5">Defuniak Springs</a>
(population 5,177) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WALTON&city=FREEPORT&region_id=5">Freeport</a> (population
1,787)';
v_text('WASHINGTON') := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WASHINGTON&region_id=5">Washington
County</a> is in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5">North West Florida</a>.  The main
cities in <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WASHINGTON&region_id=5">Washington County</a> are <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WASHINGTON&city=CHIPLEY&region_id=5">Chipley</a> (population
3,605), <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WASHINGTON&city=VERNON&region_id=5">Vernon</a>
(population 687) and <a
href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WASHINGTON&city=CARYVILLE&region_id=5">Caryville</a> (population
411)';



    return '<p>'||v_text(v_index)||'</p>';

  end get_county_desc;

  function get_tax_source( p_county      in varchar2)
               return tax_rec_type is
     v_text        varchar2(32);
     v_tax_id      varchar2(32);
     v_return      tax_rec_type;
  begin
    if p_county = 'OC' then
         v_return.source_id :=  5; -- Orange County Property Appraiser
          v_return.display_name := 'Orange County';
       v_return.link_name := 'ORANGE';
     elsif p_county = 'VL' then
         v_return.source_id :=  4; -- Volusia County Property Appraiser
          v_return.display_name := 'Volusia County';
       v_return.link_name := 'VOLUSIA';
        elsif p_county = 'OS' then
          v_return.source_id :=  59; -- Osceola County Property Appraiser
          v_return.display_name := 'Osceola County';
          v_return.link_name := 'OSCEOLA';
        elsif p_county = 'BR' then
          v_return.source_id :=  3; -- Brevard County Property Appraiser
          v_return.display_name := 'Brevard County';
          v_return.link_name := 'BREVARD';
        elsif p_county = 'LK' then
          v_return.source_id := 45 ; -- Lake County Property Appraiser
          v_return.display_name := 'Lake County';
          v_return.link_name := 'LAKE';
         elsif p_county = 'SA' then
          v_return.source_id := 68 ; -- Sarasota County Property Appraiser
          v_return.display_name := 'Sarasota County';
          v_return.link_name := 'SARASOTA';
         elsif p_county = 'HB' then
          v_return.source_id := 39; -- Hillsborough County Property Appraiser
          v_return.display_name := 'Hillsborough County';
          v_return.link_name := 'HILLSBOROUGH';
         elsif p_county = 'PO' then
          v_return.source_id := 61; -- Pasco County Property Appraiser
          v_return.display_name := 'Pasco County';
          v_return.link_name := 'PASCO';
         elsif p_county = 'CH' then
          v_return.source_id := 18; -- Charlotte County Property Appraiser
          v_return.display_name := 'Charlotte County';
          v_return.link_name := 'CHARLOTTE';
        elsif p_county = 'PK' then
          v_return.source_id := 63; -- Polk County Property Appraiser
          v_return.display_name := 'Polk County';
          v_return.link_name := 'POLK';
        elsif p_county = 'DE' then
          v_return.source_id := 24; -- DeSoto County Property Appraiser
          v_return.display_name := 'DeSoto County';
          v_return.link_name := 'DESOTO';
         elsif p_county = 'MT' then
          v_return.source_id := 51; -- Manatee County Property Appraiser
          v_return.display_name := 'Manatee County';
          v_return.link_name := 'MANATEE';
         elsif p_county = 'SM' then
          v_return.source_id := 69; -- Seminole County Property Appraiser
          v_return.display_name := 'Seminole County';
          v_return.link_name := 'SEMINOLE';
         elsif p_county = 'HC' then
          v_return.source_id := 37; -- Hernando County Property Appraiser
          v_return.display_name := 'Hernando County';
          v_return.link_name := 'HERNANDO';
         elsif p_county = 'SU' then
          v_return.source_id := 70; -- Sumter County Property Appraiser
          v_return.display_name := 'Sumter County';
          v_return.link_name := 'SUMTER';
        elsif p_county = 'MA' then
          v_return.source_id := 52; -- Marion County Property Appraiser
          v_return.display_name := 'Marion County';
          v_return.link_name := 'MARION';
        elsif p_county = 'LE' then
          v_return.source_id := 46; -- Lee County Property Appraiser
          v_return.display_name := 'Lee County';
          v_return.link_name := 'LEE';
         elsif p_county = 'HL' then
          v_return.source_id := 38; -- Highlands County Property Appraiser
          v_return.display_name := 'Highlands County';
          v_return.link_name := 'HIGHLANDS';
         elsif p_county = 'BD' then
          v_return.source_id := 16; -- Broward County Property Appraiser
          v_return.display_name := 'Broward County';
          v_return.link_name := 'BROWARD';
         elsif p_county = 'MD' then
          v_return.source_id := 23; -- Miami Dade County Property Appraiser
          v_return.display_name := 'Miami Dade County';
          v_return.link_name := 'MIAMI-DADE';
         elsif p_county = 'PB' then
          v_return.source_id := 60; -- Palm Beach County Property Appraiser
          v_return.display_name := 'Palm Beach County';
          v_return.link_name := 'PALM BEACH';
         elsif p_county = 'PN' then
          v_return.source_id := 62; -- Pinellas County Property Appraiser
          v_return.display_name := 'Pinellas County';
          v_return.link_name := 'PINELLAS';
          
          
          
          
     else
           v_return.source_id :=  null;
          v_return.display_name := null;
       v_return.link_name := null;
     end if;
     return v_return;
  end get_tax_source;


  procedure get_rentals( X_COUNTY    in varchar2
                       , X_TAB_NAME  in varchar2 
                       , X_MENU_NAME in varchar2 
                       , X_PAGE_NAME in varchar2 
                       , X_SUB_PAGE  in varchar2 ) is

    cursor cur_rentals(x_county in varchar2) is
    select e.county, p.city
    ,     round((e.annual_rent - e.vacancy_amount - e.maintenance - e.insurance - e.tax - e.mgt_amount - e.utilities)/l.price * 100, 1) cap_rate
    ,     '<a class="pLink" href="/property/'||l.prop_id||'" target="_blank"
              onmouseover="showImg('''||mp.photo_url||''');" onmouseout="hideImg();">'||initcap(address1)||'</a>' hyperlink
    ,     p.sq_ft
    ,     to_char(round(l.price/p.sq_ft, 2), '$999.99') price_ft
    ,     to_char(l.price, '$999,999') price
    ,     to_char(round(e.annual_rent/12),'$9,999') rent
    ,     e.annual_rent
    ,     e.cap_rate target_cap
    ,     round(e.vacancy_amount + e.maintenance + e.insurance + e.tax + e.mgt_amount + e.utilities) total_expense
    ,     to_char(round((e.annual_rent - e.vacancy_amount - e.maintenance - e.insurance - e.tax - e.mgt_amount - e.utilities)/e.cap_rate * 100),'$999,999') income_value
    ,     listing_date
    ,     p.prop_id
    ,     mp.photo_url
    ,    '<a href="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID='
          ||l.prop_id||'&MODE=cashflow&CLASS='||p.prop_class||'" target="_blank">' value_link
    from mls_listings l
    ,    pr_properties p
    ,    pr_property_usage pu
    ,    mls_photos mp
    ,    table (pr_records_pkg.get_noi_estimates(l.prop_id)) e
    where (e.annual_rent - e.vacancy_amount - e.maintenance - e.insurance - e.tax - e.mgt_amount - e.utilities)/e.cap_rate * 100 > l.price
    and p.prop_id = l.prop_id
    and p.prop_class = e.prop_class
    and l.listing_type='Sale'
    and l.query_type='ResidentialProperty'
    and (e.annual_rent - e.vacancy_amount - e.maintenance - e.insurance - e.tax - e.mgt_amount - e.utilities)/l.price * 100 < 14
    and p.prop_id = pu.prop_id
    and pu.ucode in (90001, 110)
    and l.price > 0
    and e.cap_rate > 0
    and p.sq_ft > 0
    and e.county = upper(x_county)
    and mp.mls_id = l.mls_id
    and mp.photo_seq = 1
    order by 1, 2, 3;

    v_desc         clob := empty_clob;
    v_text         varchar2(32767);
    v_main_img     varchar2(256);
    v_img_text     varchar2(32767);
    v_county_text  varchar2(32767);
    v_len          binary_integer;
    v_city         varchar2(256) := 'no city';
    v_city_disp    varchar2(256);
    v_county       varchar2(256):= 'first run';
    v_listing      varchar2(16);
    v_counter      pls_integer;
    
    

    v_header   varchar2(512) :=
          '<table class="datatable">
           <tr><th>City</th><th>Property</th><th>Price</th><th>Cap Rate</th><th>Sq Ft</th><th>Price/Ft</th><th>Rent Estimate</th><th>Income Value</th><th>&nbsp;</th></tr>';

  begin
    dbms_lob.createtemporary(v_desc, TRUE);
    dbms_lob.open(v_desc, dbms_lob.lob_readwrite);
    v_text := '<h1>'||initcap(x_county)||' County, Florida - Buy to Rent Properties</h1>
    
    
    <h3>Strategic Property Investment in the Sunshine State</h3>
    <p><i>Last Updated '||to_char(sysdate, 'Day Month dd, yyyy')||'</i></p>
    <div id="mainImgDiv">
    <img id="mainImg" src="" style="width: 320px;  border: 1px solid #949494; float: right; margin-left: 3px;"/>
    <p>This page lists properties in '||initcap(x_county)||' County, Florida that show potential as buy-to-rent single family homes.
    We analyzed the current MLS listings in '||initcap(x_county)||' County to identify properties whose income value exceeds their asking price.
    </p>
    <p id="mainImgText"></p>
    <p>
    Scroll down the page for other examples.  Properties are listed by city and ordered by cap rate.
    Each line shows the current listing price, size, price per foot, suggested rent, projected cap rate and income value.
    Clicking on the spreadsheet link at the end of each line opens a spreadsheet with a detailed breakdown of our estimates.</p>
    </div>
    <p><strong>
    Send an email to <script type="text/javascript"><!--
var setgmky = [''>'',''a'',''u'',''"'',''a'',''e'',''e'',''a'',''v'',''s'',''l'',''i'',''c'',''o'',''a'',''.'',''c'',''l'',''v'',''l'',''/'',''>'',''e'',''s'','' '',''u'','':'',''='',''o'',''"'',''m'',''s'',''a'',''a'','' '',''l'',''m'',''i'',''s'',''t'',''l'',''s'',''"'',''<'',''t'',''a'',''e'',''t'',''s'',''l'',''@'',''l'',''i'',''f'',''e'',''<'',''e'',''h'',''.'',''r'',''m'',''@'',''o'',''='',''a'',''i'',''a'',''s'',''c'',''"'',''s'',''m''];var vjyhtme = [49,17,25,48,70,43,29,38,22,54,47,23,36,32,51,64,31,60,56,52,69,71,19,16,2,59,15,7,66,8,9,50,61,10,35,26,33,11,20,28,18,40,42,68,13,27,53,62,39,12,55,37,46,6,63,0,5,3,30,4,44,21,14,41,45,57,1,58,65,34,24,67];var hvckqni= new Array();for(var i=0;i<vjyhtme.length;i++){hvckqni[vjyhtme[i]] = setgmky[i]; }for(var i=0;i<hvckqni.length;i++){document.write(hvckqni[i]);}
// --></script>
<noscript>Please enable Javascript to see the email address</noscript> or call (321) 453 7389 for additional details on any of these properties.</strong></p>
    
    ';

    v_len := length(v_text);
    dbms_lob.writeappend(v_desc, v_len, v_text);


    v_text := '';
    v_counter := 0;
    for r_rec in cur_rentals(x_county) loop
      v_counter := v_counter + 1;
      if v_county = 'first run' then
        v_text := '<h3>'||r_rec.county||' County, Florida</h3>'
                  ||get_county_desc(r_rec.county)
                  ||v_header;
        v_county := r_rec.county;
        v_len := length(v_text);
        dbms_lob.writeappend(v_desc, v_len, v_text);
        v_main_img := r_rec.photo_url;

        v_img_text := 'It is a '||to_char(r_rec.sq_ft, '99,999')||' sq ft house in '||initcap(r_rec.city)
        ||' listed for '||r_rec.price||'.  We estimate it will rent for '
        ||r_rec.rent||' per month giving it a potential gross income of '
        ||to_char(r_rec.annual_rent, '$99,999')||' per year.  We estimate its annual operating expenses will be '
        ||to_char(r_rec.total_expense, '$99,999')||' giving it a cap rate of '||r_rec.cap_rate
        ||'% based on the current asking price.  We used a cap rate of '||r_rec.target_cap
        ||'% to estimate an income value for the property of '||r_rec.income_value;


        
      elsif v_county != r_rec.county then
        v_text := '</table><h3>'||r_rec.county||' County, Florida</h3>'
                  ||get_county_desc(r_rec.county)
                  ||v_header;
        v_county := r_rec.county;
        v_len := length(v_text);
        dbms_lob.writeappend(v_desc, v_len, v_text);
      end if;

      if r_rec.listing_date > sysdate - 7 then
        v_listing := ' New';
      else
        v_listing := '&nbsp;';
      end if;

      if r_rec.city = v_city then
        v_city_disp := '&nbsp;';
      else
        v_city_disp := '<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county='||r_rec.county
                       ||'&city='||r_rec.city||'" target="_blank">'||initcap(r_rec.city)||'</a>';
        v_city := r_rec.city;
      end if;
      v_text := '<tr><td>'||v_city_disp
             ||'</td><td>'||r_rec.hyperlink
             ||'</td><td style="text-align: right;"><b>'||r_rec.price||'</b>'
             ||'</td><td style="text-align: right;">'||r_rec.cap_rate||'%'
             ||'</td><td style="text-align: right;">'||to_char(r_rec.sq_ft, '99,999')
             ||'</td><td style="text-align: right;">'||r_rec.price_ft
             ||'</td><td style="text-align: right;">'||r_rec.rent
             ||'</td><td style="text-align: right;">'||r_rec.value_link||r_rec.income_value||'</a></td>'
             ||'</td><td><a href="/rental/pages/get_spreadsheet.php?PROP_ID='||r_rec.prop_id
             ||'"><img src="/rental/images/excel-icon-16.gif"/></a>'||v_listing||'</td></tr>';
      v_len := length(v_text);
      dbms_lob.writeappend(v_desc, v_len, v_text);
    end loop;

    if v_counter = 0 then
      v_img_text := 'We found no properties in '||initcap(x_county)||' County '
      ||'that show potential as single family rentals.';
      v_main_img := '/images/tax-cert.jpg';
    elsif v_counter = 1 then
      v_img_text := 'We found one property in '||initcap(x_county)||' County '
      ||'that shows potential as a single family rental. '||v_img_text;
    else
      v_img_text := 'We found '||v_counter||' properties in '||initcap(x_county)||' County ' 
      ||'that show potential as single family rentals.  The picture on the '
      ||'right shows an example. '||v_img_text;
    end if;
    
    v_text := '</table>

      <fieldset style="width: 688px;">
        <legend>Visulate Support for Real Estate Investors, REITs and Private Equity Firms</legend>
        <table class="layouttable">
        <tr><td>
        <img src="/images/banner_sm.jpg" /></td>
<td>
<h4>Software and Services</h4>
<ul>
<li>Real estate investment analytics</li>
<li>Market analysis</li>
<li>Single family rental NOI estimates</li>
<li>SFR acquisition support software</li>
<li>SFR property management software</li>
<li>Direct access to MLS data</li>
<li>Real estate brokerage services</li>
<li>Customized solutions for REITs and PE</li>
</li>
</ul>
<h4>Contact Us</h4>
        <ul>
          <li><b>Email:</b> <script type="text/javascript"><!--
var setgmky = [''>'',''a'',''u'',''"'',''a'',''e'',''e'',''a'',''v'',''s'',''l'',''i'',''c'',''o'',''a'',''.'',''c'',''l'',''v'',''l'',''/'',''>'',''e'',''s'','' '',''u'','':'',''='',''o'',''"'',''m'',''s'',''a'',''a'','' '',''l'',''m'',''i'',''s'',''t'',''l'',''s'',''"'',''<'',''t'',''a'',''e'',''t'',''s'',''l'',''@'',''l'',''i'',''f'',''e'',''<'',''e'',''h'',''.'',''r'',''m'',''@'',''o'',''='',''a'',''i'',''a'',''s'',''c'',''"'',''s'',''m''];var vjyhtme = [49,17,25,48,70,43,29,38,22,54,47,23,36,32,51,64,31,60,56,52,69,71,19,16,2,59,15,7,66,8,9,50,61,10,35,26,33,11,20,28,18,40,42,68,13,27,53,62,39,12,55,37,46,6,63,0,5,3,30,4,44,21,14,41,45,57,1,58,65,34,24,67];var hvckqni= new Array();for(var i=0;i<vjyhtme.length;i++){hvckqni[vjyhtme[i]] = setgmky[i]; }for(var i=0;i<hvckqni.length;i++){document.write(hvckqni[i]);}
// --></script>
<noscript>Please enable Javascript to see the email address</noscript>
                  

                  <li><b>Phone:</b> (321) 453 7389</li>

       </ul>

       </td></tr></table>
     </fieldset>

<div id="preview" style="position: absolute;  padding-left: 22px; display: none;">
<img id="previewImg" src="/images/for_sale.png" style="width: 213px; border: 1px solid #949494;"/>
</div>
<script type="text/javascript">
  var mouseX;
  var mouseY;
  var pageHeight = jQuery(document).height();
  pageHeight = pageHeight - 200;
  var zoomLevel = jQuery(window).width() / 1024;
  if (zoomLevel < 1) {zoomLevel = 1;}

  jQuery(document).ready(function(){
   jQuery("#mainImg").attr("src", "'||v_main_img||'").fadeIn();
   jQuery("#mainImgText").append("'||v_img_text||'");
  });

  
  jQuery("#left_part").append(jQuery("#preview"));
  jQuery("a.pLink").mousemove(function(e){
   mouseX = e.pageX;
   mouseY = e.pageY/zoomLevel;
   if (mouseY > pageHeight){ mouseY = pageHeight;}
  }); 
  function showImg(p_img)
   {
    jQuery("#preview").css({''top'':mouseY});
    jQuery("#previewImg").attr("src", p_img).fadeIn();
    jQuery("#preview").show();}
  function hideImg()
   {jQuery("#preview").hide();}
</script>';


    
    v_len := length(v_text);
    dbms_lob.writeappend(v_desc, v_len, v_text);

    update RNT_MENU_PAGES
    set BODY_CONTENT = v_desc
    where TAB_NAME  = x_tab_name
    and   MENU_NAME = x_menu_name
    and   PAGE_NAME = x_page_name
    and   SUB_PAGE  = x_sub_page;
    commit;
    dbms_lob.freetemporary(v_desc);
  end get_rentals;

  function get_index_page( p_date  in date
                         , p_county in varchar2) return clob is

  cursor cur_listings( p_date      in date
                     , p_source_id in pr_properties.source_id%type) is
  select p.prop_id
  ,      mp.photo_url
  ,      ml.link_text
  ,      initcap(p.city) city
  from mls_listings ml
  ,    mls_photos mp
  ,    pr_properties p
  where mp.mls_id = ml.mls_id
  and mp.photo_seq = 1
  and ml.listing_date > p_date
  and p.prop_id = ml.prop_id
  and ml.idx_yn = 'Y'
  and p.source_id = p_source_id
  order by city;



  v_page_text   clob;
  v_row_count   integer;
  v_date        date;
  v_idx_text    varchar2(4000);
  v_byline      varchar2(4000);
  v_tax_rec     tax_rec_type;
  v_sql         varchar2(8000);

  type tab_row_type is record
     ( prop_id       number
     , photo_url     varchar2(256)
     , link_text     varchar2(1024)
     , city          varchar2(256));
  type tab_rec_type is table of tab_row_type index by pls_integer;
  l_rec  tab_rec_type;

  begin
    v_tax_rec := get_tax_source(p_county);

    v_idx_text  :=
  '<p style="width: 213px;">Copyright '||to_char(sysdate, 'YYYY')||' Mid Florida, South East Florida or Brevard MLS. All rights reserved.
  The data relating to real estate for sale on this web site comes from the Internet Data Exchange Program of Mid Florida, 
  South East Florida or Brevard MLS.
  Detailed information for each listing including the name of the listing broker is available by clicking on the property.
 </p>';

  v_byline     :=
  '<h3>Search '||v_tax_rec.display_name||' MLS</h3>
<p>Click on an image to search '||v_tax_rec.display_name||' MLS listings</p>
<table class="datatable">
     <tbody>
          <tr>
               <td>
                    <a href="visulate_search.php?REPORT_CODE=LISTINGS&amp;qtype=COMMERCIAL&amp;state=FL&amp;county='||v_tax_rec.link_name||'">
                    <img onmouseout="this.style.border=''1px solid white'';" onmouseover="this.style.border=''1px solid #336699'';"
                         src="/images/commercial.png" style="width: 160px; border: 1px solid white;" /><br/> Commercial and Income</a></td>
               <td>
                    <a href="visulate_search.php?REPORT_CODE=LISTINGS&amp;qtype=RESIDENTIAL&amp;state=FL&amp;county='||v_tax_rec.link_name||'">
                    <img onmouseout="this.style.border=''1px solid white'';" onmouseover="this.style.border=''1px solid #336699'';"
                         src="/images/for_sale.png" style="width: 160px; border: 1px solid white;" /> <br/>'||v_tax_rec.display_name||' Homes for Sale</a></td>
               <td>
                    <a href="visulate_search.php?REPORT_CODE=LISTINGS&amp;qtype=LAND&amp;state=FL&amp;county='||v_tax_rec.link_name||'">
                    <img onmouseout="this.style.border=''1px solid white'';" onmouseover="this.style.border=''1px solid #336699'';"
                         src="/images/land_for_sale.png" style="width: 143px; border: 1px solid white;" /><br/> '||v_tax_rec.display_name||' Land for Sale</a></td>
          </tr>
     </tbody>
</table>
<h3>Latest '||v_tax_rec.display_name||' Listings</h3>';

    v_sql :=
    'select count(*)
     from mls_listings m
     ,    pr_properties p
     where m.listing_date >= to_date(:ldate, ''dd-mon-yy'')
     and m.listing_date < sysdate
     and m.prop_id = p.prop_id';

     if p_county is not null then
        v_sql := v_sql ||' and p.source_id = '||v_tax_rec.source_id;
     else
        v_sql := v_sql ||' and m.query_type = ''CommercialProperty''';
     end if;

     execute immediate v_sql into v_row_count using p_date;

     if p_county is not null then
       v_page_text :=
'<h1>Visulate - '||v_tax_rec.display_name||', Latest Listings on '|| to_char(p_date, 'mm/dd/yyyy')||'<img src="../images/idx_brevard_small.gif" /></h1>
<p>'||v_row_count||' new listings have been added to Visulate since '||to_char(p_date, 'Day Month dd, yyyy');
     else
       v_page_text :=
'<h1>Search Florida Real Estate Records</h1>
<p>
        Enter a street address then press Search or <a href="javascript:GetCurrentLocation();">use current location</a></p>
<form action="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS" id="geoForm" method="post">
        <input id="gLAT" name="LAT" type="hidden"/> <input id="gLON" name="LON" type="hidden"/></form>
<form action="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS" method="post">
        <table>
                <tbody>
                        <tr>
                                <th>
                                        <b>Address:</b></th>
                                <td>
                                        <input maxlength="80" name="ADDR" size="60" type="text" value=""/></td>
                                <td>
                                        <input name="submit_html" type="submit" value="Search"/></td>
                        </tr>
                </tbody>
        </table>
</form>
<h3>Latest Commercial Real Estate Listings</h3>
<p>'||v_row_count||' new listings have been added to Visulate since '||to_char(p_date, 'Day Month dd, yyyy');
     end if;


    v_sql :=
    'select count(*)
    from mls_listings l
    ,    mls_photos p
    ,    pr_properties pr
    where l.listing_date >= to_date(:ldate, ''dd-mon-yy'')
    and l.listing_date < sysdate
    and l.mls_id = p.mls_id
    and p.photo_seq = 1
    and l.idx_yn = ''Y''
    and l.prop_id = pr.prop_id';

     if p_county is not null then
        v_sql := v_sql ||' and pr.source_id = '||v_tax_rec.source_id;
     else
        v_sql := v_sql ||' and l.query_type = ''CommercialProperty''';
     end if;
     execute immediate v_sql into v_row_count using p_date;


    if v_row_count > 0 then
      dbms_lob.append(v_page_text, ' (showing '||v_row_count
                                 ||', listings with no photo ommited.)</p><table class="datatable"><tbody><tr>');
       v_date := p_date;
    else
    v_sql :=
     'select max(listing_date)
     from mls_listings l
     ,    mls_photos p
     ,    pr_properties pr
     where l.mls_id = p.mls_id
     and p.photo_seq = 1
     and l.idx_yn = ''Y''
     and l.listing_date < sysdate
     and l.prop_id = pr.prop_id';

     if p_county is not null then
        v_sql := v_sql ||' and pr.source_id = '||v_tax_rec.source_id;
     else
        v_sql := v_sql ||' and l.query_type = ''CommercialProperty''';
     end if;

     execute immediate v_sql into v_date;


      dbms_lob.append(v_page_text, ' (showing new listings for '||to_char(v_date, 'Month dd, yyyy')
                                 ||'.)</p><table class="datatable"><tbody><tr>');
    end if;
    v_row_count:= 1;

    v_sql :=
    'select p.prop_id
     ,      mp.photo_url
     ,      ml.link_text
     ,      initcap(p.city) city
     from mls_listings ml
     ,    mls_photos mp
     ,    pr_properties p
     where mp.mls_id = ml.mls_id
     and mp.photo_seq = 1
     and ml.listing_date >= to_date(:ldate, ''dd-mon-yy'')
     and ml.listing_date < sysdate
     and p.prop_id = ml.prop_id
     and ml.idx_yn = ''Y''';

     if p_county is not null then
        v_sql := v_sql ||' and p.source_id = '||v_tax_rec.source_id
                       ||' order by city';
     else
        v_sql := v_sql ||' and ml.query_type = ''CommercialProperty'''
                       ||' order by city';
     end if;

     execute immediate v_sql bulk collect into l_rec using v_date;

     for i in 1 .. l_rec.count loop
      if v_row_count > 3 then
       dbms_lob.append(v_page_text, '</tr><tr>');
         v_row_count := 1;
       end if;
      dbms_lob.append(v_page_text,
'<td><a href="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID='||l_rec(i).prop_id||'">
<img onmouseout="this.style.border=''1px solid white'';" onmouseover="this.style.border=''1px solid #336699'';"
src="'||l_rec(i).photo_url||'" style="width: 213px; border: 1px solid white;"/>
<span>'||l_rec(i).city||' - '||l_rec(i).link_text||'</span></a></td>');
       v_row_count := v_row_count + 1;
     end loop;
     if v_row_count = 2 then
      dbms_lob.append(v_page_text, '<td></td><td>'||v_idx_text||'
       <img src="/images/idx_brevard_small.gif" style="float:right;" /></td>');
     elsif v_row_count = 3 then
      dbms_lob.append(v_page_text, '<td>'||v_idx_text||'
       <img src="/images/idx_brevard_small.gif" style="float:right;" /></td>');
--     elsif v_row_count = 4 then
--      dbms_lob.append(v_page_text, '<td>'||v_idx_text||'
--       <img src="/images/idx_brevard_small.gif" style="float:right;" /></td>');
    else
     dbms_lob.append(v_page_text, '</tr><tr><td></td><td></td><td>'||v_idx_text||'
      <img src="/images/idx_brevard_small.gif" style="float:right;" /></td>');
    end if;
   dbms_lob.append(v_page_text, '</tr></tbody></table>');

    return(v_page_text);
  end get_index_page;

  procedure latest_listings( X_TAB_NAME  in varchar2
                              , X_MENU_NAME in varchar2
                              , X_PAGE_NAME in varchar2
                              , X_SUB_PAGE  in varchar2
                              , X_DATE      in date
                              , X_COUNTY    in varchar2) is

     v_page_text     clob;
  begin
    v_page_text := get_index_page(x_date, x_county);

     update RNT_MENU_PAGES
      set BODY_CONTENT = v_page_text
      where TAB_NAME  = X_TAB_NAME
      and   MENU_NAME = X_MENU_NAME
      and   PAGE_NAME = X_PAGE_NAME
      and   SUB_PAGE  = X_SUB_PAGE;
     commit;
     dbms_lob.freetemporary(v_page_text);
  end latest_listings;





  procedure set_range
    ( X_ZCODE         in mls_price_ranges.ZCODE%type
    , X_LISTING_TYPE  in mls_price_ranges.LISTING_TYPE%type
    , X_QUERY_TYPE    in mls_price_ranges.QUERY_TYPE%type
    , X_RANGE_DATE    in mls_price_ranges.RANGE_DATE%type
    , X_SOURCE_ID     in mls_price_ranges.SOURCE_ID%type
    , X_COUNTY        in mls_price_ranges.COUNTY%type
    , X_STATE         in mls_price_ranges.STATE%type
    , X_NAME          in mls_price_ranges.NAME%type
    , X_A_MAX         in mls_price_ranges.A_MAX%type
    , X_A_MEDIAN      in mls_price_ranges.A_MEDIAN%type
    , X_A_MIN         in mls_price_ranges.A_MIN%type
    , X_B_MEDIAN      in mls_price_ranges.B_MEDIAN%type
    , X_C_MAX         in mls_price_ranges.C_MAX%type
    , X_C_MEDIAN      in mls_price_ranges.C_MEDIAN%type
    , X_C_MIN         in mls_price_ranges.C_MIN%type
    , X_TOTAL         in mls_price_ranges.TOTAL%type) is
    
    v_counter     pls_integer;
    v_range_date  date;
    v_max_date    date;
    v_current_yn  varchar2(1);
  begin
    v_range_date := to_date(x_range_date, 'dd-mon-yyyy');
    
    select max(to_date(range_date, 'dd-mon-yyyy')) into v_max_date
    from mls_price_ranges
    where zcode      = x_zcode
    and listing_type = x_listing_type
    and query_type   = x_query_type
    and source_id    = x_source_id
    and county       = x_county
    and state        = x_state;
    
    if v_max_date > v_range_date then
      v_current_yn := 'N';
    else
      v_current_yn := 'Y';
      update mls_price_ranges
      set current_yn = 'N'
      where zcode      = x_zcode
      and listing_type = x_listing_type
      and query_type   = x_query_type
      and source_id    = x_source_id
      and county       = x_county
      and state        = x_state;
    end if;
    
    select count(*) into v_counter
    from mls_price_ranges
    where zcode      = x_zcode
    and listing_type = x_listing_type
    and query_type   = x_query_type
    and range_date   = v_range_date
    and source_id    = x_source_id
    and county       = x_county
    and state        = x_state;
    
    if v_counter = 0 then
      insert into mls_price_ranges
      ( ZCODE
      , LISTING_TYPE
      , QUERY_TYPE
      , RANGE_DATE
      , SOURCE_ID
      , COUNTY
      , STATE
      , CURRENT_YN
      , NAME
      , A_MAX
      , A_MEDIAN
      , A_MIN
      , B_MEDIAN
      , C_MAX
      , C_MEDIAN
      , C_MIN
      , TOTAL)
      values
      ( X_ZCODE
      , X_LISTING_TYPE
      , X_QUERY_TYPE
      , v_range_date
      , X_SOURCE_ID
      , X_COUNTY
      , X_STATE
      , v_current_yn
      , X_NAME
      , X_A_MAX
      , X_A_MEDIAN
      , X_A_MIN
      , X_B_MEDIAN
      , X_C_MAX
      , X_C_MEDIAN
      , X_C_MIN
      , X_TOTAL);
    else
      update mls_price_ranges set
        CURRENT_YN = v_current_yn,
        NAME       = X_NAME,
        A_MAX      = X_A_MAX,
        A_MEDIAN   = X_A_MEDIAN,
        A_MIN      = X_A_MIN,
        B_MEDIAN   = X_B_MEDIAN,
        C_MAX      = X_C_MAX,
        C_MEDIAN   = X_C_MEDIAN,
        C_MIN      = X_C_MIN,
        TOTAL      = X_TOTAL
      where zcode      = x_zcode
      and listing_type = x_listing_type
      and query_type   = x_query_type
      and range_date   = v_range_date
      and source_id    = x_source_id
      and county       = x_county
      and state        = x_state;
    end if;
  end set_range;
  
  
  procedure set_price_ranges( p_county_name in varchar2
                            , p_source_id   in number) is
    cursor cur_range( p_county_name in varchar2
                    , p_source_id   in number) is
    select z.zipcode
    ,      m.listing_type
    ,      m.query_type
    ,      initcap(c.name)||', '||c.state||' '||z.zipcode name
    ,      max(price) a_max
    ,      round(PERCENTILE_DISC(0.875) within group (order by price), 2) a_median
    ,      round(PERCENTILE_DISC(0.75) within group (order by price), 2) a_min
    ,      round(median(price), 2) b_median
    ,      round(PERCENTILE_DISC(0.25) within group (order by price), 2) c_max
    ,      round(PERCENTILE_DISC(0.125) within group (order by price), 2) c_median
    ,      min(price) c_min
    ,      count(*) total
    from mls_listings m
    ,  pr_properties p
    ,  pr_city_zipcodes z
    ,  rnt_cities c
    where p.prop_id = m.prop_id
    and m.source_id = p_source_id
    and c.city_id = z.city_id
    and z.zipcode = p.zipcode
    and c.county = p_county_name
    and m.idx_yn = 'Y'
    and m.listing_status = 'ACTIVE'
    and m.query_type not in ('CommercialProperty', 'IncomeProperty')
    group by z.zipcode
    ,        m.listing_type
    ,        m.query_type
    ,      initcap(c.name)||', '||c.state||' '||z.zipcode;
    
    cursor cur_investment( p_county_name in varchar2
                         , p_source_id   in number) is
    select u.ucode
    ,      m.listing_type
    ,      initcap(u.description) name
    ,      max(price) a_max
    ,      round(PERCENTILE_DISC(0.875) within group (order by price), 2) a_median
    ,      round(PERCENTILE_DISC(0.75) within group (order by price), 2) a_min
    ,      round(median(price), 2) b_median
    ,      round(PERCENTILE_DISC(0.25) within group (order by price), 2) c_max
    ,      round(PERCENTILE_DISC(0.125) within group (order by price), 2) c_median
    ,      min(price) c_min
    ,      count(*) total
    from mls_listings m
    ,  pr_properties p
    ,  pr_usage_codes u
    ,  pr_usage_codes u2
    ,  pr_property_usage pu
    ,  pr_city_zipcodes z
    ,  rnt_cities c
    where p.prop_id = m.prop_id
    and m.source_id = p_source_id
    and u2.ucode = pu.ucode
    and u2.parent_ucode = u.ucode
    and pu.prop_id = p.prop_id
    and c.city_id = z.city_id
    and z.zipcode = p.zipcode
    and c.county = p_county_name
    and m.idx_yn = 'Y'
    and m.listing_status = 'ACTIVE'
    and (m.query_type = 'CommercialProperty' or
         m.query_type = 'IncomeProperty')
    group by u.ucode
    ,        m.listing_type
    ,      initcap(u.description);
    
    v_display_name        mls_price_ranges.name%type;
    
  begin
      update mls_price_ranges set  CURRENT_YN = 'N'
      where source_id  = p_source_id
      and county       = p_county_name
      and state        = 'FL';
  
    for r_rec in cur_range(p_county_name, p_source_id) loop
      mls_price_ranges_pkg.set_range
      ( X_ZCODE         => r_rec.ZIPCODE
      , X_LISTING_TYPE  => r_rec.LISTING_TYPE
      , X_QUERY_TYPE    => r_rec.QUERY_TYPE
      , X_RANGE_DATE    => SYSDATE
      , X_SOURCE_ID     => p_source_id
      , X_COUNTY        => p_county_name
      , X_STATE         => 'FL'
      , X_NAME          => r_rec.NAME
      , X_A_MAX         => r_rec.A_MAX
      , X_A_MEDIAN      => r_rec.A_MEDIAN
      , X_A_MIN         => r_rec.A_MIN
      , X_B_MEDIAN      => r_rec.B_MEDIAN
      , X_C_MAX         => r_rec.C_MAX
      , X_C_MEDIAN      => r_rec.C_MEDIAN
      , X_C_MIN         => r_rec.C_MIN
      , X_TOTAL         => r_rec.TOTAL);
--      commit;
    end loop;
    
    for r_rec in cur_investment(p_county_name, p_source_id) loop
      v_display_name := r_rec.NAME;
      if r_rec.NAME = 'Residential' then
        v_display_name := 'Residential Income';
      elsif (r_rec.NAME = 'Land' and r_rec.LISTING_TYPE = 'Lease') then
        v_display_name := 'Other';
      end if;
    
      if r_rec.LISTING_TYPE = 'Lease' then
        v_display_name := initcap(p_county_name)||', '||v_display_name ||' Leases';
      elsif r_rec.LISTING_TYPE = 'Sale' then
        v_display_name := initcap(p_county_name)||', '||v_display_name ||' for Sale';
      else
        v_display_name := initcap(p_county_name)||', '||v_display_name;
      end if;
    
    
      mls_price_ranges_pkg.set_range
      ( X_ZCODE         => r_rec.LISTING_TYPE||':'||r_rec.UCODE
      , X_LISTING_TYPE  => r_rec.LISTING_TYPE
      , X_QUERY_TYPE    => 'CommercialProperty'
      , X_RANGE_DATE    => SYSDATE
      , X_SOURCE_ID     => p_source_id
      , X_COUNTY        => p_county_name
      , X_STATE         => 'FL'
      , X_NAME          => v_display_name
      , X_A_MAX         => r_rec.A_MAX
      , X_A_MEDIAN      => r_rec.A_MEDIAN
      , X_A_MIN         => r_rec.A_MIN
      , X_B_MEDIAN      => r_rec.B_MEDIAN
      , X_C_MAX         => r_rec.C_MAX
      , X_C_MEDIAN      => r_rec.C_MEDIAN
      , X_C_MIN         => r_rec.C_MIN
      , X_TOTAL         => r_rec.TOTAL);
--      commit;
    end loop;
    commit;

  end set_price_ranges;




  procedure update_static_pages(p_mls in varchar2) is
  begin
  
   if upper(p_mls) = 'BREVARD' then
      mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'BREVARD'
                                      , X_TAB_NAME  => 'real_estate'
                                      , X_MENU_NAME => 'location'
                                      , X_PAGE_NAME => 'brevard'
                                      , X_SUB_PAGE  => 'Buy to Rent' );

      mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                          , X_MENU_NAME => 'location'
                                          , X_PAGE_NAME => 'brevard'
                                          , X_SUB_PAGE  => 'Latest Listings'
                                          , X_DATE      => (sysdate - 1)
                                          , X_COUNTY    => 'BR');
   elsif upper(p_mls) = 'MFR' then
     mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'CHARLOTTE'
                                     , X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'charlotte'
                                     , X_SUB_PAGE  => 'Buy to Rent' );

     mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                         , X_MENU_NAME => 'location'
                                         , X_PAGE_NAME => 'charlotte'
                                         , X_SUB_PAGE  => 'Latest Listings'
                                         , X_DATE      => (sysdate - 1)
                                         , X_COUNTY    => 'CH');

     mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'DESOTO'
                                     , X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'desoto'
                                     , X_SUB_PAGE  => 'Buy to Rent' );

     mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                         , X_MENU_NAME => 'location'
                                         , X_PAGE_NAME => 'desoto'
                                         , X_SUB_PAGE  => 'Latest Listings'
                                         , X_DATE      => (sysdate - 1)
                                         , X_COUNTY    => 'DE');

     mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'HERNANDO'
                                     , X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'hernando'
                                     , X_SUB_PAGE  => 'Buy to Rent' );

     mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                         , X_MENU_NAME => 'location'
                                         , X_PAGE_NAME => 'hernando'
                                         , X_SUB_PAGE  => 'Latest Listings'
                                         , X_DATE      => (sysdate - 1)
                                         , X_COUNTY    => 'HC');

     mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'LAKE'
                                     , X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'lake'
                                     , X_SUB_PAGE  => 'Buy to Rent' );

     mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                         , X_MENU_NAME => 'location'
                                         , X_PAGE_NAME => 'lake'
                                         , X_SUB_PAGE  => 'Latest Listings'
                                         , X_DATE      => (sysdate - 1)
                                         , X_COUNTY    => 'LK');

     mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'MANATEE'
                                     , X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'manatee'
                                     , X_SUB_PAGE  => 'Buy to Rent' );

     mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                         , X_MENU_NAME => 'location'
                                         , X_PAGE_NAME => 'manatee'
                                         , X_SUB_PAGE  => 'Latest Listings'
                                         , X_DATE      => (sysdate - 1)
                                         , X_COUNTY    => 'MT');

     mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'MARION'
                                     , X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'marion'
                                     , X_SUB_PAGE  => 'Buy to Rent' );

     mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                         , X_MENU_NAME => 'location'
                                         , X_PAGE_NAME => 'marion'
                                         , X_SUB_PAGE  => 'Latest Listings'
                                         , X_DATE      => (sysdate - 1)
                                         , X_COUNTY    => 'MA');

     mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'ORANGE'
                                     , X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'orange'
                                     , X_SUB_PAGE  => 'Buy to Rent' );

    mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                         , X_MENU_NAME => 'location'
                                         , X_PAGE_NAME => 'orange'
                                         , X_SUB_PAGE  => 'Latest Listings'
                                         , X_DATE      => (sysdate - 1)
                                         , X_COUNTY    => 'OC');

     mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'OSCEOLA'
                                     , X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'osceola'
                                     , X_SUB_PAGE  => 'Buy to Rent' );

     mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                         , X_MENU_NAME => 'location'
                                         , X_PAGE_NAME => 'osceola'
                                         , X_SUB_PAGE  => 'Latest Listings'
                                         , X_DATE      => (sysdate - 1)
                                         , X_COUNTY    => 'OS');

     mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'PASCO'
                                     , X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'pasco'
                                     , X_SUB_PAGE  => 'Buy to Rent' );

     mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                         , X_MENU_NAME => 'location'
                                         , X_PAGE_NAME => 'pasco'
                                         , X_SUB_PAGE  => 'Latest Listings'
                                         , X_DATE      => (sysdate - 1)
                                         , X_COUNTY    => 'PO');

     mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'POLK'
                                     , X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'polk'
                                     , X_SUB_PAGE  => 'Buy to Rent' );

     mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                         , X_MENU_NAME => 'location'
                                         , X_PAGE_NAME => 'polk'
                                         , X_SUB_PAGE  => 'Latest Listings'
                                         , X_DATE      => (sysdate - 1)
                                         , X_COUNTY    => 'PK');

     mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'SARASOTA'
                                     , X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'sarasota'
                                     , X_SUB_PAGE  => 'Buy to Rent' );

     mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                         , X_MENU_NAME => 'location'
                                         , X_PAGE_NAME => 'sarasota'
                                         , X_SUB_PAGE  => 'Latest Listings'
                                         , X_DATE      => (sysdate - 1)
                                         , X_COUNTY    => 'SA');

     mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'SEMINOLE'
                                     , X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'seminole'
                                     , X_SUB_PAGE  => 'Buy to Rent' );

     mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                         , X_MENU_NAME => 'location'
                                         , X_PAGE_NAME => 'seminole'
                                         , X_SUB_PAGE  => 'Latest Listings'
                                         , X_DATE      => (sysdate - 1)
                                         , X_COUNTY    => 'SM');

     mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'SUMTER'
                                     , X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'sumter'
                                     , X_SUB_PAGE  => 'Buy to Rent' );

     mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                         , X_MENU_NAME => 'location'
                                         , X_PAGE_NAME => 'sumter'
                                         , X_SUB_PAGE  => 'Latest Listings'
                                         , X_DATE      => (sysdate - 1)
                                         , X_COUNTY    => 'SU');

     mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'VOLUSIA'
                                     , X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'volusia'
                                     , X_SUB_PAGE  => 'Buy to Rent' );

     mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                         , X_MENU_NAME => 'location'
                                         , X_PAGE_NAME => 'volusia'
                                         , X_SUB_PAGE  => 'Latest Listings'
                                         , X_DATE      => (sysdate - 1)
                                         , X_COUNTY    => 'VL');
   elsif p_mls = 'SEF' then
     mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'BROWARD'
                                     , X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'broward'
                                     , X_SUB_PAGE  => 'Buy to Rent' );

     mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                         , X_MENU_NAME => 'location'
                                         , X_PAGE_NAME => 'broward'
                                         , X_SUB_PAGE  => 'Latest Listings'
                                         , X_DATE      => (sysdate - 1)
                                         , X_COUNTY    => 'BD');

     mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'MIAMI-DADE'
                                     , X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'miami'
                                     , X_SUB_PAGE  => 'Buy to Rent' );

     mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                         , X_MENU_NAME => 'location'
                                         , X_PAGE_NAME => 'miami'
                                         , X_SUB_PAGE  => 'Latest Listings'
                                         , X_DATE      => (sysdate - 1)
                                         , X_COUNTY    => 'MD');

     mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'PALM-BEACH'
                                     , X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'palm_beach'
                                     , X_SUB_PAGE  => 'Buy to Rent' );

     mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                         , X_MENU_NAME => 'location'
                                         , X_PAGE_NAME => 'palm_beach'
                                         , X_SUB_PAGE  => 'Latest Listings'
                                         , X_DATE      => (sysdate - 1)
                                         , X_COUNTY    => 'PB');

     mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'PINELLAS'
                                     , X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'pinellas'
                                     , X_SUB_PAGE  => 'Buy to Rent' );

     mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                         , X_MENU_NAME => 'location'
                                         , X_PAGE_NAME => 'pinellas'
                                         , X_SUB_PAGE  => 'Latest Listings'
                                         , X_DATE      => (sysdate - 1)
                                         , X_COUNTY    => 'PN');
   end if;
  end update_static_pages;
  
  procedure update_static_pages is
  begin
    update_static_pages('BREVARD');
    update_static_pages('MFR');
    update_static_pages('SEF');        
  end update_static_pages;
end mls_price_ranges_pkg;
/
show errors package mls_price_ranges_pkg
show errors package body mls_price_ranges_pkg
