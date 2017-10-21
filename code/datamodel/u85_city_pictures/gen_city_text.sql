set define ^
declare
  type cou_list_type is table of number;
  type text_list_type is table of varchar2(32767) index by varchar2(256);
  
  function get_static_text(p_city in varchar2)  return varchar2 is
    v_text    text_list_type;
    v_return  varchar2(32767);
  begin
    v_text('JACKSONVILLE') := '<h3>Jacksonville</h3>
<p>Jacksonville is Florida''s largest city by population and the largest city in the contingent United States by area. Jacksonville is located in the North of Florida, about 25 miles south of Georgia.  Jacksonville contains the largest deepwater port in the south (the second largest port on US East Coast).  Jacksonville is also home to numerous military facilities and has the 3rd largest naval presence in the county as a result of Naval Submarine Base Kings Bay being located nearby. The military is Jacksonville''s largest employer by far and has an estimated $6.1 billion economic impact annually. Top employers for Jacksonville are Naval Air Station Jacksonville, Duval County Public Schools, Naval Station Mayport, City of Jacksonville, and Baptist Health.</p>';
    v_text('MIAMI') := '<h3>Miami</h3>
<p>Miami is Florida''s second most populous city. Miami is also the second largest US city with a Spanish speaking majority, which accounts for its nickname of "the capital of Latin America." Industries with the largest influence in Miami include commerce, finance, and international business. Miami is home to the headquarters of many large businesses including Burger King, US Century Bank, Caribbean Cruise Lines, and World Fuel Services. The port of Miami is one of the nation''s busiest ports and contributes $18 billion to the city''s economy. The largest employers in Miami are Miami-Dade County Public Schools, Miami-Dade County, United States Government, Florida Government, University of Miami, and Baptist Health South Florida.</p>';
    v_text('TAMPA') := '<h3>Tampa</h3>
<p>Tampa is Florida''s third most populous city, behind Jacksonville and Miami. It is located on the west coast of Florida near The Gulf of Mexico in Hillsborough County. Service, retail, finance, insurance, shipping by air and sea, professional sports, tourism, real estate, and national defense play vital roles in Tampa''s economy. Tampa is home to numerous Fortune 1000 companies, including OSI Restaurant Partners, Wellcare Health Plans, TECO Energy, and Raymond James Financial. The University of South Florida is also located in Tampa.  Top employers in Tampa are Publix Supermarkets, Baycare Health Care Systems, Wal-mart, Verizon Communications Inc, TECO Energy Inc, and Ties Publishing Co.</p>';
    v_text('SAINT PETERSBURG') := '<h3>St. Petersburg</h3>
<p>St. Petersburg is the fourth most populous city in Florida and located in Pinellas County. St. Petersburg has, on average, 361 days of sunshine a year, making it an attractive destination for retirees. However, the city has gradually attracted younger residents as well. The core of St. Petersburg''s economy is fueled by tourism, contributing $2 billion in direct revenue annually. Other growth industries are financial services, manufacturing, medical technologies, information technology, and marine sciences. The largest employers for St. Petersburg are All Children''s Hospital, Raymond James, Bayfront Medical Center, Home Shopping Network, and Fidelity National Information services. St. Petersburg has the highest rate of violent crime in Florida.</p>';
    v_text('ORLANDO') := '<h3>Orlando</h3>
<p>Orlando is the fifth most populated city in Florida and is located in Orange County. Orlando is often nicknamed "the theme park capital of the world," as it is home to Walt Disney World, Universal Studios, Seaworld, and numerous other theme parks. As a result, Orlando is also known as the tourist capital of the world, attracting 51 million tourists a year. Orlando is a popular destination for conventions: the Orange County convention center is the second largest in the world. The Orlando metropolitan area has a $13.4 billion technology industry and employs 53,000 people. Orlando is also home to the Darden Restaurants headquarters, the largest operator of restaurants in the world by revenue. The University of Central Florida also resides in Orlando and is the second largest university in the United States. Orlando''s top employers are Walt Disney World, Orange County Public Schools, State of Florida Government, Adventist Health System, Florida Hospital, and Wal-Mart Stores.</p>';
    v_text('HIALEAH') := '<h3>Hialeah</h3>
<p>Hialeah is the sixth largest city in Florida in terms of population and is located in Miami Dade County. In terms of population, Hialeah is the densest American city not to feature a skyscraper. 95% of Hialeah''s population is Hispanic. The second largest Spanish television network, Telemundo, is headquartered in Hialeah. Top employers for Hialeah County are Hialeah Hospital, Palmetto General Hospital, Best Buy, Starbucks, and CVS Pharmacy.</p>';
    v_text('TALLAHASSEE') := '<h3>Tallahassee</h3>
<p>Tallahassee is the seventh most populous city in Florida and serves as the state''s capital. Tallahassee is located in Leon County. Much of Tallahassee''s economy revolves around the city''s numerous colleges and universities, including Florida State University and Florida A&M University. Trade and agriculture are also central to Tallahassee''s economy. Tallahassee is a regional center for scientific research. The largest and highest powered magnet research laboratory in the world, National High Magnetic Field Laboratory, is located in Tallahassee. Top employers for Tallahassee are State of Florida, Florida State University, Leon County Schools, Tallahassee Memorial Healthcare, and City of Tallahassee.</p>';
    v_text('FORT LAUDERDALE') := '<h3>Fort Lauderdale</h3>
<p>Fort Lauderdale is the eighth largest city in Florida is terms of population. Fort Lauderdale is located in Broward County and borders the Atlantic Ocean. Tourism is Fort Lauderdale''s largest industry, with a focus on water recreation. The city is home to over 42,000 resident yachts and 100 marinas and boatyards. Fort Lauderdale also has a large convention center, attracting 30% of the city''s visitors. Fort Lauderdale is a fast growing market for international trade. Many companies have established business operations in Fort Lauderdale with Latin American headquarters, including AT&T, AutoNation, CityCorp, Galaxy Latin America, Hewlett Packard, and others. Top employers for Fort Lauderdale are Tenet Healthcare, American Express, The Continental Group, Motorola, and Maxim Integrated Products.</p>';
    v_text('CAPE CORAL') := '<h3>Cape Coral</h3>
<p>Cape Coral is located in Lee County and borders the Gulf of Mexico. Cape Coral is the largest city between Miami and Tampa and has more miles of canals than any other city in the world.  The main industries in Cape Coral include local government services, health care, retail, and real estate/ construction. The top employers for Cape Coral are Lee County School District, Cape Coral City Hall, Publix Supermarkets, Cape Coral Hospital, and Wal-Mart.</p>';
    v_text('HOLLYWOOD') := '<h3>Hollywood</h3>
<p>Hollywood is located in Broward County, Florida. Top employers are Memorial Healthcare System, The Continental Group, City of Hollywood, Westin Diplomat Resort and Spa, Memorial Regional Hospital South, and BrandsMart USA. HEICO and Invicta Watch Group both have their headquarters in Hollywood.</p>';
    v_text('GAINESVILLE') := '<h3>Gainesville</h3>
<p>Gainesville is located in Alachua County in North Central Florida. Gaineville is the home to The University of Florida and much of the economy revolves around the University, with the highest percentage of residents in their 20s. Top employers are University of Florida, Shands HealthCare, Veterans Health Administration, School Board of Alachua County, and City of Gainesville.</p>';
    v_text('MIRAMAR') := '<h3>Miramar</h3>
<p>Miramar is located in Broward County. Spirit Airlines, JL Audio, Arise Virtual Solutions, and Chetu Inc are all headquartered in Miramar. The leading industries in Miramar are educational services, health care, and social assistance; retail trade; and professional, scientific, management, administrative and waste management services. Top employers are City of Miramar, Premier Beverage, Comcast of South Florida, Humana Medical Plans, and Royal Caribbean Cruises.</p>';
    v_text('CORAL SPRINGS') := '<h3>Coral Springs</h3>
<p>Coral Springs is located in Broward County. The largest industries for employment are management, professional, and retail; sales and office; service; construction; and production, transportation, and material moving. 98% of Coral Spring''s land is developed. ABB Asea Brown Boveri and Royal Plastics group have headquarters in Coral Springs. The top employers for Coral Springs are Broward County Schools, Publix Supermarkets, First Data, Alliance Entertainment, Wal-Mart, Coral Springs Medical Center, and City of Coral Springs.</p>';
    v_text('NAPLES') := '<h3>Naples</h3>
<p>Naples is located in Collier County in Southwest Florida. Collier County is bordered by Monroe, Miami Dade, Broward, Hendry, and Lee counties. Naples is also located along the Gulf of Mexico, which accounts for tourism being the city''s largest industry. Naples is home to many hotels and shopping opportunities catered to the city''s many tourists. Naples is particularly attractive to older people and those living up north who wish to relocate somewhere warm for the winter. As a result, Naples is more populated during the winter season. Many of Naple''s population are second home owners, making it an affluent area. Real estate is also a major industry, and home prices are comparatively higher here than in the rest of Florida. Naples''s top employers are District School Board of Collier County, NCH Healthcare System, Collier County, Collier County Sherriff, The Home Depot, and Ritz Carlton.</p>';
    v_text('MIMS') := '<h3>Mims</h3>
<p>Mims is a good place for those looking to buy a lot of land for a reasonable price, a lot of bang for your buck so to speak. With its wide open spaces and wooded trails, it is a particularly ideal place if you want to keep horses. Salt Lake Wildlife Management Area&nbsp;has many miles for riding, and the North Brevard Horseman&rsquo;s Club would be a great place to meet other people with a shared interest of equestrian activities.</p>
<p>
Mims is a semi-rural community in north Brevard County, with a population of approximately 7,000 people.&nbsp; It is 22.4 square miles, 5.3 of which are water.&nbsp; Themedian income in 2012 was $35,216, and 15% of the population lived under the poverty line. Compared to rest of country Mim&rsquo;s cost of livingis 9.8% less.</p>
<p>
A few sources of employment in Mims include The Kennedy Space Center, Parrish Medical Center, and Brevard Community College. Mims is the closest city in Brevard County to Orlando. It therefore would be a good place for those who want to work in Orlando, but have a lower cost of living.</p>
<p>
Mims is not for those who enjoy a busy or fast paced life style. It does not have many shopping or restaurant options. It has a Dollar Store, a Walgreens, and a gas station but not a lot else. However, if you do want to spend your free time doing something a little more exciting, it wouldn&rsquo;t take more than half an hour to get to somewhere with decent restaurants and stores. It is a quiet town with lots of space and room to grow.</p>';

    v_text('TITUSVILLE') := '<p>Titusville&nbsp; is the County Seat of Brevard County.&nbsp; Nicknamed Space City, USA,&nbsp; It is a principal city of the Palm Bay -Melbourne - Titusville Metropolitan Statistical Area</p>
<p>
        Titusville is a full service city covering 30.3 square miles and a population of approximately 45,000. Titusville is located on the west shore of the Indian River Lagoon, directly across from the John F. Kennedy Space Center. The Atlantic Ocean lies approximately 12 miles to the east and East Orlando 30 miles to the west.&nbsp; Incorporated in 1886, Titusville has seen most of its growth since 1962, with&nbsp; the creation of the Lunar Landing program at the Space Center. Titusville is the eastern anchor of Florida&rsquo;s high tech corridor. Industrial parks and &nbsp; prime commercial properties are near major highways such as I-95, SR 528/Beach line Expressway, and SR 50, all providing easy access to Orlando and other major cities.</p>
<p>Connecting the city to the rest of Florida and beyond is a modern, uncongested system of road and rail connections. Interstate 95, US 1,State Road 50 and the Florida East Coast Railway are all excellent methods for land transportation in the immediate area.</p>
<p>
        Commercial air transportation is provided by Orlando International Airport. General aviation facilities are available at Space Coast Regional Airport, located just five minutes from Kennedy Space Center and home to 1,200 acres of industrial property.</p>
<p>
        On the Atlantic Ocean sits Port Canaveral, a major deepwater port serving cargo, tanker and cruise markets. Port Canaveral has shown tremendous growth of late, registering 3.6 million short tons of cargo and 4.3 million total cruise passengers in FY 2007.
<p>
      The nostalgic historic Downtown&nbsp; area offers arts and crafts shops, clothing and consignment shops, flower and gift shops and a nearby riverside park, as well as several popular restaurants.</p>
<p>
        Nearby are other gift, hobby, museum and antique shops. Within one mile of downtown is the Titusville Municipal Marina with a ships store, a large seawall for viewing manatee and other marine life.</p>
<p>
        There 10 hotels/motels in Titusville mostly clustered around I95 or the Indian River.</p>
<p>
        House prices and rent in Titusville have been negatively impacted by the imminent closure of the shuttle program and the consequential loss of high salary jobs. As a real estate investor house prices are softer here than other areas in Brevard County. It is extremely important that the price paid enables the property to cash flow as a rental as selling prices are unlikely to rebound in the near future.</p>
<p>
        Links for the city of Titusville can be found at</p>
<p>
        <a href="http://www.titusville.com">http://www.titusville.com</a> </p>
<p>
        <a href="http://www.titusville.com/Files/titusville%20community%20data.pdf">http://<span>ww
w.titusville.com</span>/Files/<span>titusville</span>%<span><span>20community</span></span>%<span>20data.pdf</span></a></p>
<p>
        <a href="http://www.titusville.org/visitors/">http://www.titusville.org/visitors/</a></p>';

    v_text('COCOA') := '<h2>Cocoa</h2>
<p>
        Cocoa is located in Brevard Country, FL; north of Rockledge and west of Merritt Island. In 2002, Cocoa embarked on an intense annexation program, nearly doubling the city&rsquo;s size to 14 square miles. &nbsp;</p>

<p>
        Some of Cocoa&rsquo;s biggest employers are: Beyel Brothers Crane &amp; Rigging, Braden Kitchens, Brevard Community College, Brewer Paving &amp; Development, CEMEX, and Coastal Steel.</p>
<p>
        To get an idea, Beyel brothers Crane &amp; Rigging is a Cocoa based company that offers heavy hauling and crane rentals.&nbsp; Braden Kitchens is also based in Cocoa, and offers kitchen cabinets. CEMEX provides cement and Coastal steel is a steel erection and fabrication company.</p>
<p>
        The biggest industries are trade, transportation and utilities and construction.</p>
<p>
        The median house sales price in 2009 was $70,000. The medium gross rent: $723. The average household income is $49,502, and 83.7 percent of residents have a high school degree or higher.&nbsp;</p>
<p>
        Links</p>
<p>
        <a href="http://cocoafl.org">http://cocoafl.org</a></
p>
<p>
        <a href="http://www.cocoafl.org/DocumentView.aspx?DID=1248">http://www.cocoafl.org/DocumentView.aspx?DID=1248</a></p>';


   v_text('MELBOURNE') := '<p>
        The City of Melbourne is located on east central Florida&#39;s Space Coast.&nbsp; Melbourne is about an hour&#39;s drive south of the Kennedy Space center, and 1-1/2 hours due east of Disney World.  The City is in the southern portion of Brevard County. Interstate-95 runs through the county from north-to-south.&nbsp; Access roads from the west include the Beach line Expressway (formerly the Beeline) and US. 192, which runs through Melbourne to the beaches.</p>
<p>
        While most of Melbourne is located on the Florida mainland, a small portion is located on a barrier island. The Indian River Lagoon separates the mainland from the island. The island is a narrow strip of land that separates the Lagoon from the Atlantic Ocean.&nbsp; Spanning the Indian River Lagoon to connect the mainland to the barrier island are a pair of four-lane, high-rise bridges -- the Melbourne Causeway and the Eau Gallie Causeway.</p>
<p>
        The City is approximately 41 square miles in size, with about 75% of that land in use. The City of Melbourne population was 78,427 as of April 1, 2010, according to the University of Florida Bureau of Economic and Business Research. The population of Melbourne continues to grow at a modest rate. Melbourne is located at the center of a much larger urban area, the <a href="http://en.wikipedia.org/wiki/Palm_Bay_%E2%80%93_Melbourne_%E2%80%93_Titusville,_Florida_Metropolitan_Statistical_Area" title="Palm Bay ? Melbourne? Titusville, Florida Metropolitan Statistical Area">Palm Bay &ndash; Melbourne&ndash; Titusville, Florida Metropolitan Statistical Area</a>.</p>
<p>    Melbourne International Airport serves Florida&#39;s Space and Treasure Coasts with domestic and international passenger and air freight service.&nbsp;&nbsp; Melbourne International Airport is served by carriers including Delta Airlines and US Airways. The Airport also provides services including charter passenger flights, private aviation, and air freight flights. International services include U.S. Customs, I.N.S., and U.S.D.A.&nbsp;</p>
        <p>
                The city was named Melbourne in honor of its first postmaster, Cornthwaite John Hector, an Englishman who had spent much of his life in <a href="http://en.wikipedia.org/wiki/Melbourne" title="Melbourne">Melbourne</a>, Australia.<sup class="reference" id="cite_ref-The_History_of_Melbourne.2C_Florida_5-0"></sup></p>
        <p>
                Melbourne contains defense and technology companies with a high concentration of <a href="http://en.wikipedia.org/wiki/High_tech" title="High tech">high-tech</a> workers. The following corporations have operations in Melbourne:</p>
<ul>
  <li><a href="http://en.wikipedia.org/wiki/DRS_Technologies" title="DRS Technologies">DRS Technologies</a>,&nbsp;
  <sup class="reference" id="cite_ref-21"></sup></li>
  <li><a href="http://en.wikipedia.org/wiki/General_Electric" title="General Electric">General Electric</a>
     Transportation Systems and GE Energy Automation</li>
  <li><a href="http://en.wikipedia.org/wiki/Harris_Corporation" title="Harris Corporation">HarrisCorporation</a>
     (including corporate headquarters)</li>
  <li><a href="http://en.wikipedia.org/wiki/Northrop_Grumman" title="Northrop Grumman">Northrop Grumman</a>
     employed 1,640 workers in 2009 <sup class="reference" id="cite_ref-countbud_20-1"></sup></li>
  <li><a href="http://en.wikipedia.org/wiki/Rockwell_Collins" title="Rockwell Collins">Rockwell Collins</a>
     employed 1,430 in 2009<sup class="reference" id="cite_ref-countbud_20-2"></sup></li>
  <li><a href="http://en.wikipedia.org/wiki/Embraer" title="Embraer">Embraer</a>
      completed a 89,000&nbsp;square feet (8,300&nbsp;m<sup>2</sup>) hanger and administrative office at the Melbourne Airport in February 2011.<sup class="reference" id="cite_ref-22"></sup></li>
  <li><span style="color:#0000ff;">Live TV</span> has its headquarters in Melbourne.
   <sup class="reference" id="cite_ref-LocationsLiveTV_23-0"></sup></li>
</ul>
<span style="font-size:12px;">Melbourne has two downtown business districts, a result of the merger of Eau Gallie into Melbourne:</span>
<ul>
  <li>Downtown Eau Gallie Arts District</li>
  <li>Historic Downtown Melbourne. Among other retail outlets, this has 26 eating and drinking establishments within a four block extent.<sup class="reference" id="cite_ref-28"></sup></li>
</ul>
        <p>
                <sup class="reference"><span>Links</span></sup></p>
        <p>
                <a href="http://www.melbourneflorida.org/info/">http://<span>www.melbourneflorida.org</span>/info/</a></p>';


    v_text('CAPE CANAVERAL') := '<h2>Cape Canaveral</h2>
<p>
Cape Canaveral is located on Florida&#39;s Atlantic coast.&nbsp; It is north of Cocoa Beach and east of Merritt Island.&nbsp; It is part of a region known as the Space Coast, and is the site of the Cape Canaveral&nbsp;Air Force Station (CCAFS).&nbsp; CCAFS is an installation of the US Air Force Space Command which is headquartered at Patrick Air Force Base in Satellite Beach.&nbsp; It is the primary launch site for unmanned rockets in the Eastern United States.</p>
<p>
Port Canaveral is a deep water port located within Cape Canaveral. The port is a base for cruise and&nbsp;cargo shipping. Disney, Carnival, Royal Caribbean and Norwegian Cruise Lines operate cruise ships from Port Canaveral.&nbsp; Port Canaveral&nbsp;operates as&nbsp; foreign trade zone.&nbsp; &nbsp;This provides tax and tariff advantages to cargo operations from the port. A 2010 study conducted by Martin Associates estimated&nbsp;the port generated 13,093 jobs and $648.8 million in economic activity:</p>
<ul>
<li><a href="http://www.portcanaveral.com/general/news/canaveral_impact_report_51010.pdf">http://www.portcanaveral.com/general/news/canaveral_impact_report_51010.pdf</a></li>
</ul>
<p>
The Port Authority has approximately 1.9 million sq ft of commercial and industrial buildings.&nbsp; There is an additional 700,000 sq ft of industrial space outside the Port Authority.&nbsp; There are 3 hotels in Cape Canaveral providing&nbsp;a total of 380,000 sq ft&nbsp;of accommodation.&nbsp; &nbsp;Cape Canaveral has 422,951 sq ft of office space, 125,492 retail and 136,881 shopping.</p>
<p>
There is around 9 million sq ft of residential real estate in Cape Canaveral.&nbsp; 6 million of this is allocated to condominium units and another 1 million in townhouses.&nbsp; There are 800,000 sq ft of multi-family units.&nbsp; Single family homes make up a relatively small proportion of the residential market.&nbsp;</p>
<p>
Properties in Cape Canaveral are generally considered less desirable than similar properties in Cocoa Beach to the south. Much of the residential real estate in both cities dates from the 1960&#39;s.&nbsp; A lot of the cheaper condos are converted multi-family properties.&nbsp; Typically 1 bed/ 1 bath units with less than 400 sq ft of living space.&nbsp; Zoning restrictions for most of the city limit the minimum term of a rental agreement.&nbsp; These are designed to limit the areas in Cape Canaveral where condos can be used as vacation rentals.</p>';


   begin
     v_return :=  v_text(p_city);
   exception
     when no_data_found then
       v_return := null;
     when others then raise;
   end;
   return v_return;

  end get_static_text;


  function get_economic_value
    ( p_Manufacturers_shipments   in varchar2
    , p_wholesaler_sales          in varchar2
    , p_Retail_sales              in varchar2
    , p_Accommodation_food_sales  in varchar2) return number is

    v_city_economy_size  number := 0;
  begin
    if  regexp_like(p_Manufacturers_shipments , '\d') then
      v_city_economy_size := v_city_economy_size + p_Manufacturers_shipments;
    end if;
    if regexp_like(p_wholesaler_sales , '\d') then
      v_city_economy_size := v_city_economy_size + p_wholesaler_sales;
    end if;
    if regexp_like(p_Retail_sales , '\d') then
      v_city_economy_size := v_city_economy_size + p_Retail_sales;
    end if;
    if regexp_like(p_Accommodation_food_sales , '\d') then
      v_city_economy_size := v_city_economy_size + p_Accommodation_food_sales;
    end if;
    return v_city_economy_size;
  end get_economic_value;




  function get_census_text( p_city     in varchar2
                          , p_cou      in number) return varchar2 is
                    
    cursor cur_content(p_cou in number) is
    select PST0452 total_population
    ,      PST0402
    ,      PST1202 population_growth
    ,      POP0102 population_recent
    ,      AGE1352
    ,      AGE2952
    ,      AGE7752
    ,      SEX2552
    ,      RHI1252
    ,      RHI2252
    ,      RHI3252
    ,      RHI4252
    ,      RHI5252
    ,      RHI6252
    ,      RHI7252
    ,      RHI8252
    ,      POP7152
    ,      POP6452
    ,      POP8152
    ,      EDU6352 high_school
    ,      EDU6852 higher_ed
    ,      VET6052
    ,      LFE3052 travel_time
    ,      HSG0102 housing_units
    ,      HSG4452 owner_occupied
    ,      HSG0962 multi_units
    ,      HSG4952 median_unit_price
    ,      HSD4102
    ,      HSD3102
    ,      INC9102 per_captia_income
    ,      INC1102 median_household_income
    ,      PVY0202 poverty_pct
    ,      BZA0102 non_farm_estab
    ,      BZA1102 non_farm_employment
    ,      BZA1152 non_farm_employment_growth
    ,      NES0102 non_employ_establishments
    ,      SBO0012 total_firms
    ,      SBO3152
    ,      SBO1152
    ,      SBO2152
    ,      SBO5152
    ,      SBO4152
    ,      SBO0152
    ,      MAN4502 manufacturing_total
    ,      WTN2202 wholesale_total
    ,      RTN1302 retail_total
    ,      RTN1312
    ,      AFN1202 accommodation_food
    ,      (MAN4502 + WTN2202 + RTN1302 +  AFN1202)/1000 economy_size
    ,      BPS0302 building_permits
    ,      LND1102 land_area
    ,      POP0602 population_density
    ,      name
    from ldr_county_data d
    ,    ldr_counties c
    where c.STATECOU = p_cou
    and c.statecou = d.statecou;

    cursor cur_city_content(p_city in varchar2) is
    select City
    ,      Population_latest
    ,      Population_base
    ,      Population_growth
    ,      Population_recent
    ,      under5_pct
    ,      under18_pct
    ,      over65_pct
    ,      Female_pct
    ,      White_pct
    ,      Black_pct
    ,      American_Indian_pct
    ,      Asian_pct
    ,      Pacific_Islander_pct
    ,      multi_races_pct
    ,      Latino_pct
    ,      not_Hispanic_pct
    ,      same_house1year_pct
    ,      Foreign_pct
    ,      Language_non_English_pct
    ,      High_school_pct
    ,      graduate_pct
    ,      Veterans
    ,      time2work
    ,      Housing_units
    ,      Homeownership_rate
    ,      Housing_units_multi_pct
    ,      Median_value
    ,      Households
    ,      Persons_per_household
    ,      Per_capita_income
    ,      Median_household_income
    ,      poverty_pct
    ,      Business_city
    ,      Total_firms
    ,      Black_owned_pct
    ,      American_Indian_owned_pct
    ,      Asian_owned_pct
    ,      Pacific_Islander_owned_pct
    ,      Hispanic_owned_pct
    ,      Women_owned_pct
    ,      Manufacturers_shipments
    ,      wholesaler_sales
    ,      Retail_sales
    ,      Retail_sales_per_capita
    ,      Accommodation_food_sales
    ,      Geography_QuickFacts
    ,      Land_area
    ,      population_density
    ,      FIPS_Code
    ,      County
    from ldr_city_qfacts
    where upper(city) = p_city;

    v_text           varchar2(32767);
    v_table_text     varchar2(32767);
    v_table_header   varchar2(4000) :=
      '<table class="datatable">'
    ||'<tr><th>Region</th>'
    ||'<th>Population<br/>2010</th>'
    ||'<th>Economic Activity<br>2007 (Millions)</th>'
    ||'<th>Population Growth<br/>2010 to 2012</th>'
    ||'<th>Median Household<br/>Income 2011</th>'
    ||'<th>Housing <br/>Units</th>'
    ||'<th>Median Price<br/>2007 to 2011</th>'
    ||'</th></tr>';

    v_short_text   varchar2(4096);
    v_region_list  cou_list_type;

    
    v_pop   number := 0;
    v_econ  number := 0;
    v_grow  number := 0;
    v_inc   number := 0;
    v_unit  number := 0;
    v_price number := 0;
    v_count number := 0;
    
    v_usa_population_growth         number := 0;
    v_usa_population_density        number := 0;
    v_usa_poverty_pct               number := 0;
    
    v_fl_population_growth          number := 0;
    v_fl_population_density         number := 0;
    v_fl_owner_occupied             number := 0;    
    v_fl_median_household_income    number := 0;
    v_fl_poverty_pct                number := 0;    
    v_fl_economy_size               number := 0;
    
    v_county_name                   varchar2(256);
    v_county_economy_size           number := 0;
    v_city_rec                      ldr_city_qfacts%rowtype;
    v_city_economy_size             number := 0;
    v_city_economy_text             varchar2(32);
    
  begin
    for usa_rec in cur_content(0) loop
      v_table_text := v_table_header||'<tr><td>United States'
                           ||'</td><td style="text-align:right">'||to_char(usa_rec.total_population, '999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(usa_rec.economy_size, '$999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(usa_rec.population_growth, '90.9')||'%'
                           ||'</td><td style="text-align:right">'||to_char(usa_rec.median_household_income, '$999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(usa_rec.housing_units, '999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(usa_rec.median_unit_price, '$999,999,999')
                           ||'</td></tr>';
                           
      v_usa_population_growth  := usa_rec.population_growth;
      v_usa_population_density := usa_rec.population_density;
      v_usa_poverty_pct        := usa_rec.poverty_pct;
                           
    end loop;
    
    for fl_rec in cur_content(12000) loop
     v_table_text :=  v_table_text||'<tr><td><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL">Florida</a>'
                           ||'</td><td style="text-align:right">'||to_char(fl_rec.population_recent, '999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(fl_rec.economy_size, '$999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(fl_rec.population_growth, '90.9')||'%'
                           ||'</td><td style="text-align:right">'||to_char(fl_rec.median_household_income, '$999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(fl_rec.housing_units, '999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(fl_rec.median_unit_price, '$999,999,999')
                           ||'</td></tr>';
                           
      v_fl_population_growth       := fl_rec.population_growth;
      v_fl_population_density      := fl_rec.population_density;
      v_fl_owner_occupied          := fl_rec.owner_occupied ;    
      v_fl_median_household_income := fl_rec.median_household_income;
      v_fl_poverty_pct             := fl_rec.poverty_pct;    
      v_fl_economy_size            := fl_rec.economy_size;                         
      
    end loop;
    open cur_city_content(p_city);
    fetch cur_city_content into v_city_rec;
    close cur_city_content;

    if  regexp_like(v_city_rec.Manufacturers_shipments , '\d') then
      v_city_economy_size := v_city_economy_size + v_city_rec.Manufacturers_shipments;
    else
      v_city_rec.Manufacturers_shipments := 0;
    end if;
    if regexp_like(v_city_rec.wholesaler_sales , '\d') then
      v_city_economy_size := v_city_economy_size + v_city_rec.wholesaler_sales;
    else
      v_city_rec.wholesaler_sales := 0;
    end if;
    if regexp_like(v_city_rec.Retail_sales , '\d') then
      v_city_economy_size := v_city_economy_size + v_city_rec.Retail_sales;
    else
      v_city_rec.Retail_sales := 0;
    end if;
    if regexp_like(v_city_rec.Accommodation_food_sales , '\d') then
      v_city_economy_size := v_city_economy_size + v_city_rec.Accommodation_food_sales;
    else
      v_city_rec.Accommodation_food_sales := 0;
    end if;
    if v_city_economy_size > 0 then
        v_city_economy_text := to_char(v_city_economy_size/1000, '$999,999,999');
    else
        v_city_economy_text := 'N/A';
    end if;
    
    

    
    for county_rec in cur_content(p_cou) loop
     v_table_text :=  v_table_text||'<tr><td><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county='
                           ||upper(replace(county_rec.name, ' County'))||'">'||county_rec.name||'</a>'
                           ||'</td><td style="text-align:right">'||to_char(county_rec.population_recent, '999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(county_rec.economy_size, '$999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(county_rec.population_growth, '90.9')||'%'
                           ||'</td><td style="text-align:right">'||to_char(county_rec.median_household_income, '$999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(county_rec.housing_units, '999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(county_rec.median_unit_price, '$999,999,999')
                           ||'</td></tr>'
                           ||'<tr><td>'||v_city_rec.city
                           ||'</td><td style="text-align:right">'||to_char(v_city_rec.population_recent, '999,999,999')
                           ||'</td><td style="text-align:right">'||v_city_economy_text
                           ||'</td><td style="text-align:right">'||v_city_rec.population_growth
                           ||'</td><td style="text-align:right">'||v_city_rec.median_household_income
                           ||'</td><td style="text-align:right">'||to_char(v_city_rec.housing_units, '999,999,999')
                           ||'</td><td style="text-align:right">'||v_city_rec.median_value
                           
                           ||'</td></tr>'
                           ||'</table>';
                           
      v_county_name := county_rec.name;
      v_county_economy_size := county_rec.economy_size;                               
                           
      if county_rec.median_household_income > v_fl_median_household_income then
        v_short_text := 'higher than';
      elsif county_rec.median_household_income < v_fl_median_household_income then
        v_short_text := 'lower than';
      else
        v_short_text := 'equal to';                           
      end if;

      v_text :='<p>'||v_city_rec.city||' is located in '||
      county_rec.name||'.  It has a population of approximately '||to_char(v_city_rec.population_recent, '999,999,999')||' people. ';


      if v_city_rec.population_growth is not null then
        v_text := v_text
        ||'The population increased '||v_city_rec.population_growth||' from 2010 to 2012. '
        ||'This compared to a '||to_char(v_fl_population_growth, '90.9')||'% increase for the State of Florida, '
        ||to_char(county_rec.population_growth, '90.9')||'% for '||county_rec.name||' and a '
        ||to_char(v_usa_population_growth, '90.9')||'% increase for the country as a whole. ';
      end if;

      v_text := v_text
      ||v_city_rec.city||' occupies '||v_city_rec.land_area||' of the '||county_rec.land_area||' square miles in '
      ||county_rec.name||'.  It had a population density of '
      ||v_city_rec.population_density||' persons per square mile in 2010.  This compared to '
      ||county_rec.population_density||' for the county, '||v_fl_population_density
      ||' for Florida and '||v_usa_population_density||' for the country.</p>'
    
      ||'<p>'||to_char(v_city_rec.housing_units/county_rec.housing_units*100, '99.9')||'% ('
      ||to_char(v_city_rec.housing_units, '999,999,999')||') of the '
      ||to_char(county_rec.housing_units, '999,999,999')||' housing units in '||county_rec.name
      ||' are in '||v_city_rec.city

      
      ||' (a housing unit is defined by the US Census Bureau as a house, apartment, mobile home, group of rooms, or single room that is occupied as separate living quarters.) '

      ||v_city_rec.city||' has a '||v_city_rec.homeownership_rate
      ||' homeownership rate compared to '
      ||county_rec.name||'''s '||to_char(county_rec.owner_occupied, '90.9')
      ||'% homeownership rate and Florida''s rate of '
      ||to_char(v_fl_owner_occupied, '90.9')||'%.</p>'
      
      ||v_table_text
    
      ||'<p>'
      ||v_city_rec.city||'''s medium household income in 2011 was '
      ||v_city_rec.median_household_income||'. '
      ||county_rec.name||'''s medium household income was '
      ||to_char(county_rec.median_household_income, '$999,999,999')||', which is '||v_short_text
      ||' the medium income for Florida as a whole: '||to_char(v_fl_median_household_income, '$999,999,999')||'. '
      ||v_city_rec.poverty_pct||' of the population in '||v_city_rec.city
      ||' lives below the poverty line, compared to '||to_char(v_fl_poverty_pct, '90.9')||'% in Florida, '
      ||to_char(county_rec.poverty_pct, '90.9')||'% of the population in '||county_rec.name||' and '
      ||to_char(v_usa_poverty_pct, '90.9')||'% nationwide.  Additional Information:</p>'
      ||'<ul><li><a href="http://quickfacts.census.gov/qfd/states/12/'||p_cou||'lk.html" target=target="_blank">'
      ||county_rec.name||' Census Data</a></li></ul>';
    
      if v_city_economy_size > 0 then
            v_text := v_text

      ||'<h4>'||v_city_rec.city||' Economic Activity</h4>'
      ||'<p>The U.S. Bureau of the Census, Economic Census, 2007 calculated the total value manufacturing, '
      ||'merchant wholesaler, retail sales and food service sales in '||v_city_rec.city||'. '
      ||'The Census measured activity of large and medium-sized firms during calendar year 2007. '
      ||'It does not include every aspect of the economy but can be used as a measure of economic activity.</p> '
      
      ||'<p>At '||v_city_economy_text||' million, '
      ||v_city_rec.city||'''s economic activity represents '
      || to_char(((v_city_economy_size/1000)/(county_rec.economy_size)*100), '90.99')||'% of '
      ||county_rec.name||'''s '
      ||to_char(county_rec.economy_size, '$999,999,999') ||'MM in economic activity.  '
      ||county_rec.name||' represents '
      || to_char((county_rec.economy_size/v_fl_economy_size*100), '90.99')||'% of the Florida economy.</p>'  

      ||'<table class="datatable">'
      ||'<tr><th>Activity</th><th>Value (Millions)</th><th>Percentage</th></tr>'
      ||'<tr><th>Manufacturers shipments</th><td style="text-align:right">'
      ||to_char(v_city_rec.manufacturers_shipments/1000, '$999,999,999')||'</td>'
      ||'<td style="text-align:right">'
      ||to_char(v_city_rec.manufacturers_shipments/v_city_economy_size*100,'90.9')||'%</td></tr>'
      
      ||'<tr><th>Merchant wholesaler sales</th><td style="text-align:right">'
      ||to_char(v_city_rec.wholesaler_sales/1000, '$999,999,999')||'</td>'
      ||'<td style="text-align:right">'
      ||to_char(v_city_rec.wholesaler_sales/v_city_economy_size*100,'90.9')||'%</td></tr>'
      
      ||'<tr><th>Retail sales</th><td style="text-align:right">'
      ||to_char(v_city_rec.retail_sales/1000, '$999,999,999')||'</td>'
      ||'<td style="text-align:right">'
      ||to_char(v_city_rec.retail_sales/v_city_economy_size*100,'90.9')||'%</td></tr>'
      
      ||'<tr><th>Accommodation and food services sales</th><td style="text-align:right">'
      ||to_char(v_city_rec.accommodation_food_sales/1000, '$999,999,999')||'</td>'
      ||'<td style="text-align:right">'
      ||to_char(v_city_rec.accommodation_food_sales/v_city_economy_size*100,'90.9')||'%</td></tr>'

      ||'<tr><th>Total</th><td style="text-align:right">'
      ||v_city_economy_text||'</td>'
      ||'<td style="text-align:right">100%</td></tr>' 
      ||'</table>';

      end if;                     
    end loop;

---------------------------------------
    -- Start here ---
---------------------------------------

    v_table_text := replace(v_table_header, 'Region', 'City');
    for a_rec in
      (select *
       from ldr_city_qfacts
       where county = v_county_name
       order by city) loop
         if a_rec.city = v_city_rec.city then
            v_table_text := v_table_text
               ||'<tr><td class="current" >'||a_rec.city
               ||'</td><td  class="current" style="text-align:right">'||to_char(a_rec.population_recent, '999,999,999')
               ||'</td><td  class="current" style="text-align:right">'
               ||to_char(get_economic_value( a_rec.Manufacturers_shipments
                                           , a_rec.wholesaler_sales
                                           , a_rec.Retail_sales
                                           , a_rec.Accommodation_food_sales)/1000, '$999,999,999')
               ||'</td><td  class="current" style="text-align:right">'||a_rec.population_growth
               ||'</td><td  class="current" style="text-align:right">'||a_rec.median_household_income
               ||'</td><td  class="current" style="text-align:right">'||to_char(a_rec.housing_units, '999,999,999')
               ||'</td><td  class="current" style="text-align:right">'||a_rec.median_value
               ||'</td></tr>';
         else
            v_table_text := v_table_text
               ||'<tr><td><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county='
               ||upper(replace(v_county_name, ' County'))||'&city='||upper(a_rec.city)||'">'||a_rec.city||'</a>'
               ||'</td><td style="text-align:right">'||to_char(a_rec.population_recent, '999,999,999')
               ||'</td><td style="text-align:right">'
               ||to_char(get_economic_value( a_rec.Manufacturers_shipments
                                           , a_rec.wholesaler_sales
                                           , a_rec.Retail_sales
                                           , a_rec.Accommodation_food_sales)/1000, '$999,999,999')
               ||'</td><td style="text-align:right">'||a_rec.population_growth
               ||'</td><td style="text-align:right">'||a_rec.median_household_income
               ||'</td><td style="text-align:right">'||to_char(a_rec.housing_units, '999,999,999')
               ||'</td><td style="text-align:right">'||a_rec.median_value
               ||'</td></tr>';
         end if;
    end loop;
    v_text := v_text ||'<h4>'||v_county_name||' Regional Comparisons</h4>'
                     ||v_table_text||'</table>';
    
    if p_cou in (12061, 12111, 12085, 12099, 12011, 12086, 12087) then
        v_region_list := cou_list_type(12061, 12111, 12085, 12099, 12011, 12086, 12087);
        v_short_text := v_county_name||' is located in Southeast Florida. ';
    elsif p_cou in (12017, 12053, 12101, 12057, 12103, 12105, 12081, 12115) then
        v_region_list := cou_list_type(12017, 12053, 12101, 12057, 12103, 12105, 12081, 12115);
        v_short_text := v_county_name||' is located in the Tampa Bay Region. ';        
    elsif p_cou in (12009, 12097, 12095, 12117, 12069, 12127, 12119) then
        v_region_list := cou_list_type(12009, 12097, 12095, 12117, 12069, 12127, 12119);
        v_short_text := v_county_name||' is located in East Central Florida. ';        
    elsif p_cou in (12003, 12019, 12031, 12089, 12107, 12109, 12035) then
        v_region_list := cou_list_type(12003, 12019, 12031, 12089, 12107, 12109, 12035);
        v_short_text := v_county_name||' is located in Northeastern Florida. ';        
    elsif p_cou in (12033, 12113, 12091, 12131, 12059, 12063, 12133, 12005, 12013, 12077, 12045, 12037, 12039, 12073, 12065, 12129) then
        v_region_list := cou_list_type(12033, 12113, 12091, 12131, 12059, 12063, 12133, 12005, 12013, 12077, 12045, 12037, 12039, 12073, 12065, 12129);
        v_short_text := v_county_name||' is located in Northwest Florida. ';        
    elsif p_cou in (12015, 12071, 12021) then
        v_region_list := cou_list_type(12015, 12071, 12021);
        v_short_text := v_county_name||' is located in Southwest Florida. ';        
    elsif p_cou in (12079, 12047, 12123, 12121, 12125, 12007, 12067, 12029, 12075, 12041, 12001, 12083, 12023) then
        v_region_list := cou_list_type(12079, 12047, 12123, 12121, 12125, 12007, 12067, 12029, 12075, 12041, 12001, 12083, 12023);
        v_short_text := v_county_name||' is located in North Central Florida. ';        
    elsif p_cou in (12049, 12055, 12093, 12027, 12043, 12051) then
        v_region_list := cou_list_type(12049, 12055, 12093, 12027, 12043, 12051);
        v_short_text := v_county_name||' is located in South Central Florida. ';        
    else
        v_region_list := cou_list_type(p_cou);
        dbms_output.put_line(p_cou||' '||v_county_name);
    end if;
    
    v_table_text := v_table_header;

    for i in v_region_list.FIRST .. v_region_list.LAST loop
      for c_rec in cur_content(v_region_list(i)) loop
        v_pop   := v_pop + c_rec.total_population;
        v_econ  := v_econ + c_rec.economy_size;
        v_grow  := v_grow + c_rec.population_growth;
        v_inc   := v_inc + c_rec.median_household_income;
        v_unit  := v_unit + c_rec.housing_units;
        v_price := v_price + c_rec.median_unit_price;
        v_count := v_count + 1;
        
        if v_region_list(i) = p_cou then
          v_table_text := v_table_text ||'<tr><td class="current" >'||c_rec.name
                           ||'</td><td class="current" style="text-align:right">'||to_char(c_rec.population_recent, '999,999,999')
                           ||'</td><td class="current" style="text-align:right">'||to_char(c_rec.economy_size, '$999,999,999')
                           ||'</td><td class="current" style="text-align:right">'||to_char(c_rec.population_growth, '90.9')||'%'
                           ||'</td><td class="current" style="text-align:right">'||to_char(c_rec.median_household_income, '$999,999,999')
                           ||'</td><td class="current" style="text-align:right">'||to_char(c_rec.housing_units, '999,999,999')
                           ||'</td><td class="current" style="text-align:right">'||to_char(c_rec.median_unit_price, '$999,999,999')
                           ||'</td></tr>';      

          
          
        else
          v_table_text := v_table_text ||'<tr><td><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county='
                           ||upper(replace(c_rec.name, ' County'))||'">'||c_rec.name||'</a>'
                           ||'</td><td style="text-align:right">'||to_char(c_rec.population_recent, '999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(c_rec.economy_size, '$999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(c_rec.population_growth, '90.9')||'%'
                           ||'</td><td style="text-align:right">'||to_char(c_rec.median_household_income, '$999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(c_rec.housing_units, '999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(c_rec.median_unit_price, '$999,999,999')
                           ||'</td></tr>';      
                           
        end if;
                           

      end loop;
    end loop;
    if v_count > 0 then
         v_table_text := v_table_text
                           ||'<tr><td>Total'
                           ||'</td><td style="text-align:right">'||to_char(v_pop, '999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(v_econ, '$999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(v_grow/v_count, '90.9')||'%'
                           ||'</td><td style="text-align:right">'||to_char(v_inc/v_count, '$999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(v_unit, '999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(v_price/v_count, '$999,999,999')
                           ||'</td></tr>';    
    end if;
    
    v_short_text := v_short_text 
      ||'This region is responsible for '
      ||to_char((v_econ/v_fl_economy_size*100), '90.9')||'% of Florida''s economic activity. '
      ||v_county_name||' represents '
      ||to_char((v_county_economy_size/v_econ*100), '90.9')||'% of the region''s economy. ';
      
    v_table_text := v_table_text||'</table>';
    
    v_text := v_text 
    ||'<p>'||v_short_text||'</p>'
    ||v_table_text;
    
    return v_text;
 
  end get_census_text;

  function get_realestate_text( p_name   in varchar2
                              , p_county in varchar2
                              , p_mode   in varchar2) return varchar2 is
    cursor cur_ucode_data( p_name   in varchar2
                         , p_county in varchar2) is
    select u.description
    ,      round(sum(property_count)) property_count
    ,      round(sum(total_sqft)) total_volume
    from pr_ucode_data ud
    , rnt_cities c
    , pr_usage_codes u
    , pr_usage_codes uc
    where c.county=p_county
    and c.name=p_name
    and c.state='FL'
    and c.city_id = ud.city_id
    and ud.ucode = uc.ucode
    and u.ucode = uc.parent_ucode
    group by u.description;
    
    cursor cur_sales( p_name   in varchar2
                    , p_county in varchar2
                    , p_type   in varchar2
                    , p_year   in varchar2) is
    select  count(*)                    sales_count
     ,      sum(price)                  total_sales
     ,      sum(sq_ft)                  total_ft_sales
     ,      round(median(price))        median_price
     ,      round(median(price/sq_ft))  median_price_ft
     ,      round(PERCENTILE_DISC(0.875) within group (order by price/sq_ft), 2) a_median_price_ft
     ,      round(PERCENTILE_DISC(0.125) within group (order by price/sq_ft), 2) c_median_price_ft
     ,      to_char(max(sale_date), 'FMMonth ddth, yyyy')              max_date
     ,      to_char(min(sale_date), 'FMMonth ddth, yyyy')              min_date
     from pr_property_sales ps
     ,    pr_properties p
     ,    pr_property_usage pu
     ,    pr_usage_codes uc
     ,    rnt_zipcodes z
     ,    pr_usage_codes uc2
     ,    rnt_cities c
     ,    rnt_city_zipcodes cz
     where p.prop_id = ps.prop_id
     and price > 100
     and p.zipcode = to_char(z.zipcode)
     and sale_date <= sysdate
     and to_char(sale_date, 'yyyy') = p_year
     and pu.prop_id = p.prop_id
     and uc.ucode = pu.ucode
     and uc.parent_ucode = uc2.ucode
     and sq_ft > 0
     and c.city_id=cz.city_id
     and cz.zipcode=z.zipcode
     and uc2.description = p_type
     and c.county=p_county
     and c.name=p_name
     and c.state='FL';

    

    v_text            varchar2(32767);
    v_display_name    varchar2(256) := initcap(p_name);
    loop_index        varchar2(256);
    v_year            varchar2(4) := '2013';
    
    type usummary_type is record
      ( property_count  number
      , total_volume    number);
    type ucode_summary_type is table of usummary_type index by pr_usage_codes.description%type;
    v_ucode_summary   ucode_summary_type;
    v_type_name       varchar2(64);
    
  begin
    v_ucode_summary('Total').property_count := 0;
    v_ucode_summary('Total').total_volume := 0;
    v_ucode_summary('Residential Property').property_count := 0;
    v_ucode_summary('Commercial Property').property_count := 0;
    
    for u_rec in cur_ucode_data(p_name, p_county) loop
      v_ucode_summary(u_rec.description).property_count := u_rec.property_count;
      v_ucode_summary(u_rec.description).total_volume := u_rec.total_volume;
      if u_rec.description != 'Land' then
        v_ucode_summary('Total').property_count := v_ucode_summary('Total').property_count + u_rec.property_count;
        v_ucode_summary('Total').total_volume :=  v_ucode_summary('Total').total_volume + u_rec.total_volume;
      end if;  
    end loop;
  if v_ucode_summary('Total').property_count > 0 then
    if p_mode = 'table' then
      v_text := '<h3>'||v_display_name||' Real Estate</h3>'
      ||'<p>There are '||to_char(v_ucode_summary('Total').property_count, '999,999,999')||' properties in '
      ||v_display_name||'.  The following table shows a summary of them based on '||v_year||' sales data.</p>'
      ||'<table class="datatable">'
      ||'<tr><th>Usage Type</th><th>Property Count</th><th>%</th><th>Sales Count</th><th>Median Price</th><th>Median Price/Ft</th><th>Sales From</th><th>To</th>';
    end if;
      
    loop_index := v_ucode_summary.FIRST; 
    while loop_index is not null loop
      if loop_index not in ('Total', 'Land') then
        for s_rec in cur_sales(p_name, p_county, loop_index, v_year) loop
          v_type_name := replace(loop_index, ' Property');
          if p_mode = 'table' then
            v_text := v_text||'<tr>'
            ||'<td>'||loop_index||'</td>'
            ||'<td>'||to_char(v_ucode_summary(loop_index).property_count, '999,999,999')||'</td>'
            ||'<td>'||to_char( v_ucode_summary(loop_index).property_count/v_ucode_summary('Total').property_count *100, '90.99')||'</td>'
            ||'<td>'||to_char(s_rec.sales_count, '999,999,999')||'</td>'
            ||'<td>'||nvl(to_char(s_rec.median_price, '$999,999,999'),'n/a')||'</td>'
            ||'<td>'||nvl(to_char(s_rec.median_price_ft, '$9,999'),'n/a')||'</td>'
            ||'<td>'||nvl(s_rec.min_date,'n/a')||'</td>'
            ||'<td>'||nvl(s_rec.max_date,'n/a') ||'</td>'                                    
            ||'</tr>';
            
          else
        
            v_text := v_text  
            ||'<h4>'||v_type_name||' Real Estate in '||v_display_name ||', Florida</h4>'
            ||'<p>'||to_char(v_ucode_summary(loop_index).property_count, '999,999,999')|| '('
            ||to_char( v_ucode_summary(loop_index).property_count/v_ucode_summary('Total').property_count *100, '99.99')
            ||'%) of the properties in '||v_display_name||' are classified as '||v_type_name||'. ';
            if s_rec.sales_count > 0 then
              v_text := v_text            
              ||to_char(s_rec.sales_count, '999,999,999')||' of them sold between '
              ||s_rec.min_date||' and '||s_rec.max_date||'. The total value of these sales was '
              ||to_char(s_rec.total_sales, '$999,999,999,999')||'. The median sales price was '
              ||to_char(s_rec.median_price, '$999,999,999')||'. In '||v_year||' the median sales price for ';
            end if;            
            if  s_rec.sales_count = 0 then 
              null;
            elsif s_rec.sales_count < 18 then
               v_text := v_text 
              ||loop_index||' in '||v_display_name||' was '||to_char(s_rec.median_price_ft, '$9,999')||' per sq ft.';
            else
              v_text := v_text ||'A Class '
              ||loop_index||' in '||v_display_name||' was '||to_char(s_rec.a_median_price_ft, '$9,999')||' per sq ft, '
              ||'B Class properties sold for '||to_char(s_rec.median_price_ft, '$9,999')||'/ft and C Class '
              ||to_char(s_rec.c_median_price_ft, '$9,999')||'/ft.';
            end if;          
            v_text := v_text ||'</p>';
          end if;
        end loop;
      end if;
      
      loop_index := v_ucode_summary.NEXT(loop_index); 
    end loop;    
  end if;
  
  if p_mode='table' then
    v_text := v_text ||'</table>';
  end if;

    return v_text;
  end get_realestate_text;
  
  function get_google_ad return varchar2 is
    v_ad_text  varchar2(2048) := 
   '<script type="text/javascript"><!--
google_ad_client = "pub-9857825912142719";
/* 728x90, created 5/30/10 */
google_ad_slot = "7170948200";
google_ad_width = 728;
google_ad_height = 90;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>';
  begin
    return v_ad_text;
  end get_google_ad;
  
  
  function get_visulate_ad(p_location in varchar2) return varchar2 is
    v_ad_text  varchar2(2048) := 

 '     <fieldset>
	<legend>Welcome to Visulate</legend>
	
	<img src="/images/sue_sm.png" style="border: 1px solid #949494; float: left; margin-right: 5px; "/>
	
	<h3>'||p_location||' Real Estate</h3>
	<p>My name is Sue Goldthorp, owner and co-founder of Visulate.
	   Visulate is a real estate brokerage based in Merrit Island, Florida.
           We have assembled a database with details of every property in Florida.
           We can help you buy or sell real estate in '||p_location||', Florida</p>


<h4>Contact us if you want to buy or sell a property in '||p_location||':</h4>
        <ul>
          <li><b>Email:</b>
<script type="text/javascript"><!--
var setgmky = [''>'',''a'',''u'',''"'',''a'',''e'',''e'',''a'',''v'',''s'',''l'',''i'',''c'',''o'',''a'',''.'',''c'',''l'',''v'',''l'',''/'',''>'',''e'',''s'','' '',''u'','':'',''='',''o'',''"'',''m'',''s'',''a'',''a'','' '',''l'',''m'',''i'',''s'',''t'',''l'',''s'',''"'',''<'',''t'',''a'',''e'',''t'',''s'',''l'',''@'',''l'',''i'',''f'',''e'',''<'',''e'',''h'',''.'',''r'',''m'',''@'',''o'',''='',''a'',''i'',''a'',''s'',''c'',''"'',''s'',''m''];var vjyhtme = [49,17,25,48,70,43,29,38,22,54,47,23,36,32,51,64,31,60,56,52,69,71,19,16,2,59,15,7,66,8,9,50,61,10,35,26,33,11,20,28,18,40,42,68,13,27,53,62,39,12,55,37,46,6,63,0,5,3,30,4,44,21,14,41,45,57,1,58,65,34,24,67];var hvckqni= new Array();for(var i=0;i<vjyhtme.length;i++){hvckqni[vjyhtme[i]] = setgmky[i]; }for(var i=0;i<hvckqni.length;i++){document.write(hvckqni[i]);}
// --></script>
<noscript>Please enable Javascript to see the email address</noscript>          
</li>
<li><b>Phone:</b> <a href="tel:+1-321-453-7389">(321) 453 7389</a></li>
                
       </ul>
       <p>Visulate - Strategic Property Investment in the Sunshine State</p>  
       
     </fieldset>';
  begin
    return v_ad_text;
  end get_visulate_ad;
  
  
  procedure gen_county_text is
    cursor cur_county_list is
    select c.statecou
    ,      upper(replace(c.name, ' County')) ucounty
    ,      c.name
    ,      cq.city
    ,      upper(cq.city) ucity
    from ldr_counties c
    ,    ldr_city_qfacts cq
    where c.state = 'FL'
    and c.name = cq.county
    order by ucounty, ucity;
    
    v_desc      clob := empty_clob;
    v_cdesc     clob := empty_clob;
    v_text      varchar2(32767);
    v_len       binary_integer;
  begin
    for c_rec in cur_county_list loop
      v_cdesc := '<h3>'||c_rec.name||' Real Estate - '||c_rec.city||'</h3>'
                       ||get_static_text(c_rec.ucity);
    
    
      dbms_lob.createtemporary(v_desc, TRUE);
      dbms_lob.open(v_desc, dbms_lob.lob_readwrite);
      
      v_text := get_census_text(c_rec.ucity, c_rec.statecou);
      v_text := v_text||get_google_ad;
      v_len := length(v_text);
      if v_len > 0 then
        dbms_lob.writeappend(v_desc, v_len, v_text);
      end if;
      
      v_text := get_realestate_text(c_rec.ucity, c_rec.ucounty, 'table');
      v_len := length(v_text);
      if v_len > 0 then
        dbms_lob.writeappend(v_desc, v_len, v_text);
      end if;
      
      v_text := get_realestate_text(c_rec.ucity, c_rec.ucounty, 'text');
      v_text := v_text||get_google_ad;
      v_len := length(v_text);
      if v_len > 0 then
        dbms_lob.writeappend(v_desc, v_len, v_text);
      end if;

      
      update rnt_cities
      set description = v_cdesc
      ,   report_data = v_desc
      where name = c_rec.ucity
      and state = 'FL'
      and county = c_rec.ucounty;
      commit;
      
      dbms_lob.close(v_desc);
    end loop;

    for c_rec in
      (select name, county
       from rnt_cities
       where state='FL'
       and name != 'ANY'
       and not exists (select 1
                       from ldr_city_qfacts
                       where upper(city) = name)) loop

      v_cdesc := '<h3>'||initcap(c_rec.county)||' County Real Estate - '||initcap(c_rec.name)||'</h3>';

      dbms_lob.createtemporary(v_desc, TRUE);
      dbms_lob.open(v_desc, dbms_lob.lob_readwrite);

      v_text := get_realestate_text(c_rec.name, c_rec.county, 'table');
      v_len := length(v_text);
      if v_len > 0 then
        dbms_lob.writeappend(v_desc, v_len, v_text);
      end if;

      v_text := get_realestate_text(c_rec.name, c_rec.county, 'text');
      v_text := v_text||get_google_ad;
      v_len := length(v_text);
      
      if v_len > 0 then
        dbms_lob.writeappend(v_desc, v_len, v_text);
      end if;
      update rnt_cities
      set description = v_cdesc
      ,   report_data = v_desc
      where name = c_rec.name
      and state = 'FL'
      and county = c_rec.county;
      commit;

      dbms_lob.close(v_desc);
    end loop;
       
  end gen_county_text;


begin
  gen_county_text;
end;
/
