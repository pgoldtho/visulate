set define ^
declare
  type cou_list_type is table of number;
  type text_list_type is table of varchar2(32767) index by pls_integer;
  
  function get_static_text(p_cou in number)  return varchar2 is
    v_text    text_list_type;
  begin
    -- Alachua County - 12001
    v_text(12001) := '<p>Alachua County is located in North Central Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MADISON&city=&region_id=7">Madison</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HAMILTON&city=&region_id=7">Hamilton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=TAYLOR&city=&region_id=7">Taylor</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUWANNEE&city=&region_id=7">Suwannee</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=UNION&city=&region_id=7">Union</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BRADFORD&city=&region_id=7">Bradford</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAFAYETTE&city=&region_id=7">Lafayette</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DIXIE&city=&region_id=7">Dixie</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEVY&city=&region_id=7">Levy</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GILCHRIST&city=&region_id=7">Gilchrist</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARION&city=&region_id=7">Marion</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLUMBIA&city=&region_id=7">Columbia</a>
 counties. Alachua County is home to the University of Florida, and a lot of the county''s economy revolves around this. Top industries providing employment are government; education & health services; trade, transportation, & utilities; and leisure & hospitality. Cities in Alachua County are Alachua, Archer, Gainesville, Hawthorne, High Springs, Newberry, and Waldo. The population of the county is around 250,000.</p>
<p>Major private sector employers for Alachua County are Shands Hospital, Publix, North Florida Regional Medical Center, Nationwide Insurance, and Wal-Mart Distribution Center. Top public sector employers are University of Florida, Veteran Affairs Medical Center, Alachua County School Board, City of Gainesville, Alachua County, and Santa Fe Community College.</p>
<p>Alachua has historically been an important center of agricultural production. Many animal herds are raised in the county; Alachua ranks in the top for number of cattle, pigs, and goats. It is also known for its tobacco, peanuts, corn, blueberries, peppers, cucumbers, potatoes, and squash. More than 35,000 people are employed in the county’s agriculture industry.</p>
<p>Gainesville is home to the University of Florida, the flagship of the State University System of Florida. UF is highly-regarded on university rankings such as the annual report put out by <i>U.S. News and World Report</i>. The university has an enrollment over 50,000, making it one of the largest in the nation. Over $400 million in research grants are annually awarded to UF. The 2,000-acre campus employs more than 14,000 people, making it the largest employer in the county.</p>
<p>The county’s second-largest employer is Shands Hospital, with over 12,000 employees. Shands operates a facility dedicated to children and another for cancer patients. Shands is recognized as a top hospital by <i>U.S. News and World Report</i>.</p>';
    -- Baker County - 12003
    v_text(12003) := '<p>Baker County is part of the Northeast Florida region, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CLAY&city=&region_id=4">Clay</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DUVAL&city=&region_id=4">Duval</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=NASSAU&city=&region_id=4">Nassau</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PUTNAM&city=&region_id=4">Putnam</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20JOHNS&city=&region_id=4">St John''s</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FLAGLER&city=&region_id=4">Flagler</a>
 counties. Towns and cities in Baker County include Glen St. Mary, Macclenny, and the unincorporated community of Sanderson. The county is home to over 25,000 people.</p>
<p>Baker County is a primarily rural area. Its largest industries by employment are trade, transportation & utility; public administration; and construction. Major private sector employers for Baker County include Wal-Mart Distribution Center, Ed Fraser Memorial Hospital & Healthcare, Ray''s Nursery, Macclenny Nursing & Rehab Center, and Earthworks of Northeast Florida, Inc. Top public sector employers are Northeast Florida State Hospital, Baker County School Board, Baker Correctional Institute, and Baker County Board of Commissioners.</p>
<p>A lightly-inhabited county, Baker has thousands of acres available for outdoor recreation, including the John M. Bethea State Forest. Partially within Baker County, Osceola National Forest is a destination for hunters as well as a historical center for logging and turpentine. Baker County has a trail within the forest connecting historic sites related to the Seminole Indians.</p>
<p>The major tourist attraction in Baker County is the Olustee Battlefield. Olustee was the site of the only major American Civil War battle in the state of Florida. The site include a walking trail and a visitor center. Every February, reenactors visit the site, and tens of thousands visit to see them.</p>
<p>Despite being a rural county, there is little commercial agricultural production. Baker County ranks number 51 among Florida counties for number of cattle and calves. The eastern portions of the county are growing as bedroom communities for Jacksonville, especially the county seat of Macclenny with its location on I-10 and US 90.</p>';
    -- Bay County - 12005
    v_text(12005) := '<p>Bay County is part of the Northwest Florida region, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA%20ROSA&city=&region_id=5">Santa Rosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ESCAMBIA&city=&region_id=5">Escambia</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WALTON&city=&region_id=5">Walton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HOLMES&city=&region_id=5">Holmes</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JACKSON&city=&region_id=5">Jackson</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WASHINGTON&city=&region_id=5">Washington</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKALOOSA&city=&region_id=5">Okaloosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CALHOUN&city=&region_id=5">Calhoun</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LIBERTY&city=&region_id=5">Liberty</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GULF&city=&region_id=5">Gulf</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FRANKLIN&city=&region_id=5">Franklin</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GADSDEN&city=&region_id=5">Gadsden</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEON&city=&region_id=5">Leon</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JEFFERSON&city=&region_id=5">Jefferson</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WAKULLA&city=&region_id=5">Wakulla</a>
     counties. The largest industries by employment for Bay County are educational, health and social services; retail trade, and arts, entertainment, recreation, accommodation and food services. Bay County''s white sand beaches and clear blue waters attract many visitors year round.</p>
    <p>Top private sector employers in Bay County are Bay Medical center, Wal-Mart, Eastern Ship Building, Gulf Coast Medical Center, and Smurfit- Stone Container Corporation. Major public sector employers are Tyndall Air Force Base, Naval Support, Bay District schools, Gulf Coast State College, City of Panama City, Bay County Board, and Bay County Sheriff. Cities and towns in Bay County include Callaway, Lynn Haven, Mexico Beach, Panama City (county seat), Panama City Beach, Parker, and Springfield.</p>';
    -- Bradford County - 12007
    v_text(12007) := '<p>Bradford County is located in North Central Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ALACHUA&city=&region_id=7">Alachua</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MADISON&city=&region_id=7">Madison</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HAMILTON&city=&region_id=7">Hamilton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=TAYLOR&city=&region_id=7">Taylor</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUWANNEE&city=&region_id=7">Suwannee</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=UNION&city=&region_id=7">Union</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAFAYETTE&city=&region_id=7">Lafayette</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DIXIE&city=&region_id=7">Dixie</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEVY&city=&region_id=7">Levy</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GILCHRIST&city=&region_id=7">Gilchrist</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARION&city=&region_id=7">Marion</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLUMBIA&city=&region_id=7">Columbia</a>
 counties. The largest industries in Bradford County by employment are trade & transportation, education & health services, and leisure & hospitality. The top 5 growing industries are transportation & warehousing, waste management, wholesale trade, scientific & technical services, and construction.</p>
    <p>Major private sector employers are Du Pont Titanium Technologies, Wal-Mart Supercenter, Shands Starke, Bradford terrace LLC, and Davis Express Inc. The largest public sector employers include Bradford County School Board and Bradford County Government. Incorporated cities and towns are Brooker, Hampton, Lawtey, and Starke. Florida State Prison is located in Bradford County.</p>';
    -- Brevard County - 12009
    v_text(12009) := '<p>Brevard County is located in the East Central Florida region, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ORANGE&city=&region_id=3">Orange</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=VOLUSIA&city=&region_id=3">Volusia</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUMTER&city=&region_id=3">Sumter</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SEMINOLE&city=&region_id=3">Seminole</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAKE&city=&region_id=3">Lake</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OSCEOLA&city=&region_id=3">Osceola</a>
 counties. There are many incorporated municipalities in Brevard. Cities include Cape Canaveral, Cocoa, Cocoa Beach, Indian Harbour Beach, Melbourne, Palm Bay, Rockledge, Satellite Beach, Titusville, and West Melbourne. The towns in Brevard are Grant-Valkaria, Indiatlantic, Malabar, Melbourne Beach, Melbourne Village, and Palm Shores. Brevard’s population is well over half a million.</p>
<p>Top industries for Brevard County include technology, tourism, agriculture, and other service businesses. Top public sector employers for Brevard County are the Brevard County School Board, Brevard County Board of County Commissioners, NASA, and US Department of Defense. Private sector employers include Harris Corporation, Health First, Inc., United Space Alliance, Wuesthoff Health System, and Northrop Grumman Corporation.</p>
<p>Kennedy Space Center is located on Merritt Island in Brevard County and provides many jobs for the area, as well as acting as a popular tourist destination. It is from this activity that Brevard takes its nickname, the Space Coast. Nicknamed "Space City USA", the city of Titusville is across the water from KSC. The city’s population is highly-educated. The city is a popular destination for visitors wishing to see spacecraft launches.</p>
<p>Other tourist attractions in Brevard County include Port Canaveral, one of the busiest cruise ports in the world, the Merritt Island National Wildlife Refuge, and Cocoa Beach. Port Canaveral is serviced by Disney Cruise Lines, Carnival, and Royal Caribbean. Not just a tourist destination, the port is within a foreign trade zone.</p>
<p>In 2010 and 2011, the Brookings Institution reported that Brevard ranked in the bottom fifth of the nation''s top metro areas, based on unemployment, gross metropolitan product, housing prices and foreclosed properties. In 2011, the county was rated the 6th worst in the nation for foreclosures. RealtyTrac rated Brevard as the best county in the United States for buyers in 2013 because of the low prices.</p>';
    -- Broward County - 12011
    v_text(12011) := '<p>Broward County is part of the southeast Florida region along with <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MIAMI-DADE&city=&region_id=1">Miami-Dade</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=INDIAN%20RIVER&city=&region_id=1"><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=INDIAN%20RIVER&city=&region_id=1">Indian River</a></a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20LUCIE&city=&region_id=1">St. Lucie</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARTIN&city=&region_id=1">Martin</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PALM%20BEACH&city=&region_id=1">Palm Beach</a>, and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MONROE&city=&region_id=1">Monroe</a> counties. Broward County has 29 recognized cities and towns, the largest being Fort Lauderdale, Pembroke Pines, and Hollywood. 95% of the properties in Broward County are residential, implying that it is a largely suburban area. Broward County is centrally located between major metropolitan areas in Miami-Dade and Palm Beach Counties. The county’s population is over 1.5 million, making it the second most populous in Florida.</p>
<p>Broward County identified these industries as focuses for its expansion efforts: advanced materials and High-Tech Manufacturing, aviation/aerospace, international trade, marine industries, and headquarters and management operations. Major private sector employers are American Express, Nova Southeastern University, AutoNation, Kaplan Higher Education, and The Answer Group. Top public employers are Broward County School District, Broward County Government, North Broward Hospital District, Memorial Healthcare System, and the City of Fort Lauderdale.</p>
<p>Port Everglades and Fort Lauderdale-Hollywood International Airport are major contributors to the region’s economy. Port Everglades is the third most trafficked port for cruise passengers in the nation. It is also a major destination for container cargo and imported petroleum. FLL is the 21st-busiest airport in the United States and the Florida Department of Transportation estimates its economic impact at $10.6 billion.</p>
<p>The county seat and largest city, with a population over 165,000, is Fort Lauderdale. The eighth-largest city in the state is a travel destination, especially for LGBT tourists. Fort Lauderdale and the adjacent Wilton Manors are among the most friendly cities to LGBT people and are among the cities with the highest proportions of same-sex couples.</p>
<p>Nova Southeastern University is a major private school located in the suburb of Davie. Broward College has campuses throughout the county. City College and the Art Institute of Fort Lauderdale are located in the city, as are satellite campuses of Florida Atlantic University and Florida International University.</p>';
    -- Calhoun County - 12013
    v_text(12013) := '<p>Calhoun County is part of the Northwest region of Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAY&city=&region_id=5">Bay</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA%20ROSA&city=&region_id=5">Santa Rosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ESCAMBIA&city=&region_id=5">Escambia</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WALTON&city=&region_id=5">Walton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HOLMES&city=&region_id=5">Holmes</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JACKSON&city=&region_id=5">Jackson</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WASHINGTON&city=&region_id=5">Washington</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKALOOSA&city=&region_id=5">Okaloosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LIBERTY&city=&region_id=5">Liberty</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GULF&city=&region_id=5">Gulf</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FRANKLIN&city=&region_id=5">Franklin</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GADSDEN&city=&region_id=5">Gadsden</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEON&city=&region_id=5">Leon</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JEFFERSON&city=&region_id=5">Jefferson</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WAKULLA&city=&region_id=5">Wakulla</a>
     counties. The largest industries in Calhoun County are manufacturing, distribution, and business. The major private sector employers in Calhoun County are Shelton''s Trucking Service, Parthenon, Blounstown Health & Rehab, Olglesby Plants International, and Calhoun Liberty Hospital. The largest public sector employer is the Calhoun School District. The cities in Calhoun County are Altha and Blountstown, with Blountstown acting as the county seat.</p>';
    -- Charlotte County - 12015
    v_text(12015) := '<p>Charlotte County is located in the southwest region of Florida, along with <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEE&city=&region_id=6">Lee</a> and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLLIER&city=&region_id=6">Collier</a> County. The only incorporated municipality in Charlotte County is Punta Gorda. Other neighborhoods include Port Charlotte, Grove City, Rotonda, Cleveland, South Punta Gorda Heights, and Pirate Harbor. The county has a population in excess of 150,000.</p>
<p>The top industries providing employment are educational, health and social services; retail trade; arts, entertainment, recreation, accommodation and food services; and construction. Targeted industries for Charlotte County are manufacturing, communications & production of communications equipment, back office operations, marine and related industries, aircraft and avionics related industries, aquaculture and related support industries, and green technology industries. Major private sector employers in Charlotte County include Wal-Mart, Peace River Regional Medical Center, Charlotte Regional Medical Center, Publix Supermarkets, and Fawcett Memorial Hospital Inc. Top public sector employers are Charlotte County School Board, Board of County Commissioners, Charlotte County Sheriff''s Office, and Charlotte Correctional Institute.</p>
<p>The county seat of Punta Gorda is home to over 15,000. Phosphate mining is an important part of the region’s economy. It used to be that phosphate was shipped down the Peace River to the city, but the railroad extension to Port Boca Grande headed off the need for that transit. Today, Punta Gorda’s economy is reliant on healthcare and tourism.</p>';
    -- Citrus County - 12017
    v_text(12017) := '<p>Citrus County is located in the Tampa Bay region of Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MANATEE&city=&region_id=2">Manatee</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=POLK&city=&region_id=2">Polk</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HILLSBOROUGH&city=&region_id=2">Hillsborough</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PINELLAS&city=&region_id=2">Pinellas</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PASCO&city=&region_id=2">Pasco</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HERNANDO&city=&region_id=2">Hernando</a>, and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SARASOTA&city=&region_id=2">Sarasota</a>
   counties. Main industries in Citrus County include educational, health, and social services; retail trade; construction; and arts, entertainment, recreation, accommodation and food services. Citrus County is home to Crystal River and Homosassa Springs and is the only place in the United States where you can legally swim and interact with manatees.</p>
    <p> Citrus County''s top five major employers are Citrus County School Board, Citrus memorial Hospital, progress Energy, Seven Rivers Community Hospital, and Citrus County Sheriff''s Department. More than 80% of the businesses in Citrus County are small businesses.</p>';
    -- Clay County - 12019
    v_text(12019) := '<p>Clay County is part of the Northeast Florida region, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAKER&city=&region_id=4">Baker</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DUVAL&city=&region_id=4">Duval</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=NASSAU&city=&region_id=4">Nassau</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PUTNAM&city=&region_id=4">Putnam</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20JOHNS&city=&region_id=4">St John''s</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FLAGLER&city=&region_id=4">Flagler</a>
 counties.  Clay County contains the following cities and towns: Green Cove Springs, Keystone Heights, Orange Park, and Penney Farms. The county is home to over 190,000 people.</p>
<p>The largest industries by employment are trade, transportation and utilities; education and health services; and leisure and hospitality. Major private sector employers are Orange Park Medical Center, HA Patient Account Services, AT&T, Clay Electric Cooperative, and Challenge Enterprises. Top public sector employers are School District of Clay County, Clay County Sheriff Office, Municipal Police Departments, and Florida Department of Military Affairs.</p>
<p>Clay County has many outdoor recreational options, including Jennings State Forest and Belmore State Forest, which feature hiking, canoeing, horseback riding, and bicycling. Abundant wildlife gives ample opportunities for viewing, hunting, and fishing. The Bayard Conservation Area, on the west bank of the St. Johns River, provide similar opportunities. The north-central portion of the county, adjacent to the Westside neighborhood of Jacksonville, is the Branan Field Mitigation Park Wildlife and Environmental Area, a wildlife conservation zone specifically focused on gopher tortoises. At Branan, visitors can hike and view wildlife.</p>
<p>Clay County hosts Camp Blanding Joint Training Center, the primary training facility for Florida National Guard formations. This, combined with the presence of multiple major military bases in Jacksonville just to the north, means that Clay County is a popular location for defense contractors, including Aero-Hose Corporation and Wyle Laboratory. The county also hosts advanced manufacturing firms, including VAC-CON, Alternate Energy Technologies, and Harris Lighting.</p>
<p>A campus of St. Johns River State College is located in Orange Park, which is in northeastern Clay County. The town also hosts a campus of Evergreen University. Orange Park is a suburb of Jacksonville, located just over five miles away from Naval Air Station Jacksonville. A satellite campus of Embry-Riddle Aeronautical University is located across the lake in Fleming Island.</p>';
    -- Collier County - 12021
    v_text(12021) := '<p>Collier County is part of the southwest region of Florida, along with <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEE&city=&region_id=6">Lee</a> and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CHARLOTTE&city=&region_id=6">Charlotte</a> counties. Collier County is Florida''s largest county in area, though much of that territory is within Everglades National Park and Big Cypress National Preserve. Cities and towns in Collier County include Everglades City, Marco Island, and Naples. Collier County has a population over 300,000.</p>
<p>The major employment industries in Collier County are trade, transportation, and utilities; leisure & hospitality; and education and health services. Major private sector employers for Collier County are Wal-Mart, Marriott, Fifth Third Bank, Naples Grande Resort, and Barron Collier Partnership. Top public sector employers include Collier County Public Schools, Collier County Government, and Collier County Sheriff''s Department.</p>
<p>Collier County is the site of the first oil well dug in the state of Florida. According to the U.S. Department of Housing and Urban Development (HUD), Collier County was one of the communities in the nation most impacted by the foreclosure crisis of 2008, but it is slowly picking back up again. The coastal areas in the western portion of the county are the centers of population, while interior areas are more devoted to agriculture.</p>
<p>One of the ten wealthiest cities in the U.S. per capita, the county seat of Naples is home for around 20,000. The city’s population is heavy on retirees, with half of residents over the age of 62. Nonetheless, the city has a strong economy and is the headquarters for about 10,000 businesses, including ASG Software Solutions, Beasley Broadcast Group, and Newsbank.</p>
<p>Marco Island is located off the mainland coast. Nearly half of the 16,000 residents are over 65. The developed island is a tourist destination.</p>';
    -- Columbia County - 12023
    v_text(12023) := '<p>Columbia County is located in North Central Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ALACHUA&city=&region_id=7">Alachua</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MADISON&city=&region_id=7">Madison</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HAMILTON&city=&region_id=7">Hamilton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=TAYLOR&city=&region_id=7">Taylor</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUWANNEE&city=&region_id=7">Suwannee</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=UNION&city=&region_id=7">Union</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BRADFORD&city=&region_id=7">Bradford</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAFAYETTE&city=&region_id=7">Lafayette</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DIXIE&city=&region_id=7">Dixie</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEVY&city=&region_id=7">Levy</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GILCHRIST&city=&region_id=7">Gilchrist</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARION&city=&region_id=7">Marion</a> counties.  The incorporated cities in Columbia County are Fort White and Lake City. Columbia County’s population is over 67,000.</p>
<p>The largest industries providing employment for Columbia County are educational, health, and public services; retail trade; and public administration. Cost of living in Columbia County is relatively low at 83.2 compared the US average of 100. Major private sector employers are VA Medical Center, Sitel, PCS Phosphate- White Springs, TIMCO, and Anderson Columbia Company. Top public sector employers include Columbia County School District and Columbia County.</p>
<p>The largest employer in Columbia County is PCS Phosphate, whose production facility is actually in neighboring Hamilton County. What is in Lake City is the railroad shipment facility to ship out the 4 million tonnes of phosphate that White Springs produces annually. In addition to the rail facilities, Lake City’s location at the intersection of I-10 and I-75 gives it easy access to the rest of the state and cities such as Jacksonville, Tampa, and Atlanta. Indeed, Lake City considers itself the gateway to Florida.</p>
<p>Lake City is also home to the Lake City Gateway Airport and TIMCO maintenance, repair, and overhaul (MRO) facility. Gateway is a general aviation airport that is home to the only U.S. Forestry Service fire support base in the Southeast U.S. The TIMCO facility includes six hangars specializing in airframe base maintenance.</p>
<p>Located next to the airport is Florida Gateway College. Originally Columbia Forestry School, the forest management program ceased in 2010 from lack of interest. Today, the student population is around 7,000.</p>';
    -- DeSoto County - 12027
    v_text(12027) := '<p>Desoto County is located in South Central Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HENDRY&city=&region_id=8">Hendry</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GLADES&city=&region_id=8">Glades</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HIGHLANDS&city=&region_id=8">Highlands</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKEECHOBEE&city=&region_id=8">Okeechobee</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HARDEE&city=&region_id=8">Hardee</a>
 counties.  Desoto''s only city and county seat is
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DESOTO&city=ARCADIA&region_id=8"> Arcadia</a>. The U.S. Census Bureau refers to DeSoto County as the Arcadia Micropolitan Statistical Area. Over 34,000 people live here.</p>
<p>The largest industries providing employment are agriculture, forestry, fishing, hunting, and mining and education, health and social services. Major private sector employers for DeSoto County are Wal-Mart Distribution Center, Wal-Mart, DeSoto Medical Hospital, Peace River Citrus, and Bethel Farms. Top public sector employers are DeSoto School District, DeSoto County, and DeSoto County Sheriff''s Office.</p>
<p>Largely rural, the economy of DeSoto County is primarily driven by agriculture. There are only five counties in the state with more cattle and calves. Cattle in the region is generally raised until they are 400-600 pounds, then sold to ranches in the western part of the nation to finish growing. There are about two head of cattle in DeSoto County for every human.</p>
<p>Citrus production is also a major component of the DeSoto County economy. Shipping over 17 million boxes annually, DeSoto is the fourth-largest citrus producer among Florida counties. 98% of those boxes are oranges. Over 60,000 acres of land are devoted to commercial citrus trees.</p>
<p>Arcadia is home to over 7,500 people. The city’s location on the Peace River makes it a prime spot for canoeing and camping. Technically outside of the city in the neighborhood of Southeast Arcadia lies Arcadia Municipal Airport, a two-runway general aviation facility. The DeSoto Campus of South Florida State College is in Arcadia.</p>';
    -- Dixie County - 12029
    v_text(12029) := '<p>Dixie County is located in North Central Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ALACHUA&city=&region_id=7">Alachua</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MADISON&city=&region_id=7">Madison</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HAMILTON&city=&region_id=7">Hamilton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=TAYLOR&city=&region_id=7">Taylor</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUWANNEE&city=&region_id=7">Suwannee</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=UNION&city=&region_id=7">Union</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BRADFORD&city=&region_id=7">Bradford</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAFAYETTE&city=&region_id=7">Lafayette</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEVY&city=&region_id=7">Levy</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GILCHRIST&city=&region_id=7">Gilchrist</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARION&city=&region_id=7">Marion</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLUMBIA&city=&region_id=7">Columbia</a>
 counties. The main industries of Dixie County are building materials and seafood export.  Major private sector employers for Dixie County are Suwannee Lumber Company, Knight''s Products, Cross City Veneer, Anderson Columbia Construction, and Gulf Coast Supply & Manufacturing. The top public sector employers include Dixie County School System, County Government, and Sheriff''s Office. Cities in Dixie County are Cross City (county seat), Horseshoe Beach, Old Town, and Suwannee.</p>';
    -- Duval County - 12031
    v_text(12031) := '<p>Duval County is in the northeastern Florida region along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAKER&city=&region_id=4">Baker</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CLAY&city=&region_id=4">Clay</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=NASSAU&city=&region_id=4">Nassau</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PUTNAM&city=&region_id=4">Putnam</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20JOHNS&city=&region_id=4">St John''s</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FLAGLER&city=&region_id=4">Flagler</a>
 counties. The current largest industries are trade, transportation, and utilities; professional and business services; and education and health services. Target industries for Duval County are advanced manufacturing, aviation and aerospace, finance and insurance services, headquarters, and information technology. Duval County is home to Jacksonville, one of Florida''s largest cities. Jacksonville houses Naval Air Station Jacksonville, which brings many government jobs to the area. The University of North Florida is also located in Jacksonville.</p>
    <p>Major private sector employers for Duval County are Baptist Health, Blue Cross Blue Shield of Florida, Mayo Clinic, Citi, and CSX. The largest public sector employers are Naval Air Station Jacksonville, Duval County Public Schools, Mayport Naval Station, and the City of Jacksonville.</p>
    <p>Duval is a popular locale for business and corporate headquarters because it has a number of transportation links. Automobile highways include I-10, I-95, the I-295 Bypass, and numerous others. Not only does Jacksonville have major railroads, but CSX Railroad is headquartered in the city. The Port of Jacksonville is the third-busiest in the state, and Jacksonville International Airport is number seven among Florida airports. The city also has smaller airports to serve general aviation needs, including Jacksonville Executive at Craig Airport, Herlong Recreational Airport, and Cecil Airport. The county has a median income above the state median and an average lower cost of living, too.</p>
<p>Duval County’s historic location where the St. John’s River meets the Atlantic Ocean makes for prime waterfront. Tourists and residents can take advantage of the beaches and fishing as well as other maritime recreation, including kayaking, paddleboarding, and surfing. The area also offers arts & culture options in the form of museums, art galleries, the symphony, and theater. Jacksonville is also a world-class golf destination with dozens of courses.</p> ';
    -- Escambia County - 12033
    v_text(12033) := '<p>Escambia County is part of the Northwest region of Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAY&city=&region_id=5">Bay</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA%20ROSA&city=&region_id=5">Santa Rosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WALTON&city=&region_id=5">Walton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HOLMES&city=&region_id=5">Holmes</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JACKSON&city=&region_id=5">Jackson</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WASHINGTON&city=&region_id=5">Washington</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKALOOSA&city=&region_id=5">Okaloosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CALHOUN&city=&region_id=5">Calhoun</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LIBERTY&city=&region_id=5">Liberty</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GULF&city=&region_id=5">Gulf</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FRANKLIN&city=&region_id=5">Franklin</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GADSDEN&city=&region_id=5">Gadsden</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEON&city=&region_id=5">Leon</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JEFFERSON&city=&region_id=5">Jefferson</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WAKULLA&city=&region_id=5">Wakulla</a>
 counties. Escambia County is the westernmost county in Florida, located in the tip of the panhandle. It has a population over 450,000.</p>

<p>The most significant industries in Escambia County are military and defense, tourism, healthcare, education and construction. Pensacola, the county''s seat and home to over 50,000, contains many military bases including Pensacola Naval Air Station, Naval Training Center, Eglin Air Force Base, Corry Station Naval, Naval Technical Training Center, and Air Station Whiting Field. Top private sector employers for Escambia County are Sacred Heart Health System, Baptist Health Care, Lakeview Center, Gulf Power Company, and Ascend Performance Materials. Major public sector employers include Escambia County Government, Federal Government, Florida State Government, and the University of West Florida.</p>

<p>A suburb of Pensacola, Ferry Pass, is home to the University of West Florida. In addition, Pensacola State College has campuses throughout the county. Troy University also has a campus just west of the city.</p>

<p>The military contributes significantly to the county’s economy. The Department of Defense spends an estimated $7.8 billion in Escambia. The defense industry is responsible for about 80,000 careers.</p>

<p>Escambia contains a major airport and seaport. The airport has an economic impact in excess of $550 billion and supports over 6,000 jobs. The Port of Escambia is a 50-acre facility with eight deepwater docking facilities and railroad access on site. Both fall within a foreign trade zone.</p>';
    -- Flagler County - 12035
    v_text(12035) := '<p>Flagler County is part of the northeastern region of Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAKER&city=&region_id=4">Baker</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CLAY&city=&region_id=4">Clay</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DUVAL&city=&region_id=4">Duval</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=NASSAU&city=&region_id=4">Nassau</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PUTNAM&city=&region_id=4">Putnam</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20JOHNS&city=&region_id=4">St John''s</a>
 counties. The largest industries in Flagler County include construction, educational services, health care/social services, and retail. Target industries include agriculture, aviation/aerospace, green technology, health sciences, high technology, and marine research.</p>
<p>Major private sector employers for Flagler County include Palm Coast Data, Florida Hospital Flagler, Publix Supermarkets, Hammock Beach Resort, Wal-Mart, and Sea Ray Boats. Top public sector employers are Flagler County School System, City of Palm Coast, Flagler County, and Flagler County Sheriff''s Department. Cities and towns in Flagler County include Bunnell (county seat), Flagler Beach, Palm Coast, Marineland, and Beverly Beach.</p>
<p>Inhabited by around 100,000 people, Flagler County was the fastest-growing county in the US from 2000 to 2005.</p>
<p>The center of population is Palm Coast, a city that was incorporated in 1999 and is home to over 75,000. Since 1980, the population has grown by at least 100% each decade. The growing city boasts miles upon miles of waterfront property, including canals, the Intercoastal Waterway, and Atlantic Ocean.</p>';
    -- Franklin County - 12037
    v_text(12037) := '<p>Franklin County is located in northwest Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAY&city=&region_id=5">Bay</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA%20ROSA&city=&region_id=5">Santa Rosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ESCAMBIA&city=&region_id=5">Escambia</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WALTON&city=&region_id=5">Walton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HOLMES&city=&region_id=5">Holmes</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JACKSON&city=&region_id=5">Jackson</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WASHINGTON&city=&region_id=5">Washington</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKALOOSA&city=&region_id=5">Okaloosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CALHOUN&city=&region_id=5">Calhoun</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LIBERTY&city=&region_id=5">Liberty</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GULF&city=&region_id=5">Gulf</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GADSDEN&city=&region_id=5">Gadsden</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEON&city=&region_id=5">Leon</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JEFFERSON&city=&region_id=5">Jefferson</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WAKULLA&city=&region_id=5">Wakulla</a>
 counties. One of Franklin County''s largest industries is seafood, supplying for than 90% of Florida''s Oysters and 10% of the nations. Commercial timber and tourism are also large industries. Franklin County beaches have been ranked some of the most beautiful in the world.</p>
    <p>Top private sector employers for Franklin County are Weems Memorial Hospital, Leavins Seafood, and Greensteel Homes. Major public sector employers are Franklin County and Florida Department of Corrections. Cities, towns, and islands in Franklin County include Apalachicola (county seat), Carrabelle, Cape St. George Island, Dog Island, and St. Vincent.</p>';
    -- Gadsden County - 12039
    v_text(12039) := '<p>Gadsden County is located in northwest Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAY&city=&region_id=5">Bay</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA%20ROSA&city=&region_id=5">Santa Rosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ESCAMBIA&city=&region_id=5">Escambia</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WALTON&city=&region_id=5">Walton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HOLMES&city=&region_id=5">Holmes</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JACKSON&city=&region_id=5">Jackson</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WASHINGTON&city=&region_id=5">Washington</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKALOOSA&city=&region_id=5">Okaloosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CALHOUN&city=&region_id=5">Calhoun</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LIBERTY&city=&region_id=5">Liberty</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GULF&city=&region_id=5">Gulf</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FRANKLIN&city=&region_id=5">Franklin</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEON&city=&region_id=5">Leon</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JEFFERSON&city=&region_id=5">Jefferson</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WAKULLA&city=&region_id=5">Wakulla</a>
 counties. Gadsden County is Florida''s only predominantly African-American county. It has a population over 45,000. Top industries are education, health & social services; public administration; and retail trade.</p>
<p>Gadsden County''s major private employers are Coastal Plywood Company, Talquin Electric Cooperative, T Formation, TeligentEMS, and Super-Valu. Top public employers include Florida State Hospital School, Department of Children, University of Florida, Gadsden County Supervisors Office, and Florida Department of Corrections- Quincy. Cities and towns in Gadsden County include Chattahoochee, Greensboro, Gretna, Havana, Midway, River Junction, and Quincy.</p>
<p>Gadsden’s claim to fame is its "Coke millionaires". Quincy banker Pat Monroe invested in the company when it offered shares to the public for the first time in 1919. He encouraged others to do the same. It is not known just how many Gadsden County residents own shares in Coca-Cola, but a local rumor suggested that the company sent a representative to collect shareholder votes.</p>';
    -- Gilchrist County - 12041
    v_text(12041) := '<p>Gilchrist County is located in North Central Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ALACHUA&city=&region_id=7">Alachua</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MADISON&city=&region_id=7">Madison</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HAMILTON&city=&region_id=7">Hamilton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=TAYLOR&city=&region_id=7">Taylor</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUWANNEE&city=&region_id=7">Suwannee</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=UNION&city=&region_id=7">Union</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BRADFORD&city=&region_id=7">Bradford</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAFAYETTE&city=&region_id=7">Lafayette</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DIXIE&city=&region_id=7">Dixie</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEVY&city=&region_id=7">Levy</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARION&city=&region_id=7">Marion</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLUMBIA&city=&region_id=7">Columbia</a>
 counties. Cities in Gilchrist County are Bell and Trenton (county seat).</p>
<p>The leading industries in Gilchrist County are healthcare, water bottling, dairy, and wood products. Major private sector employers for Gilchrist County are Ayers Health & Rehabilitation, CCDA Waters, Tri-County Health Center, Alliance Dairy, and North Florida Holsteins. Top public sector employers include Gilchrist School District, Gilchrist County Government, and Gilchrist Sheriff''s Office.</p>
<p>The newest county in Florida, having been created in 1925, Gilchrist County is very rural. Owing to rapid population growth since the 1960s, the population is a bit over 16,000. There is only one traffic light in the entire county and no roads with more than one lane of traffic moving in one direction.</p>
<p>The rural county is a significant agricultural producer. It ranks number sixteen for number of cattle in Florida. Gilchrist also produces significant quantities of blueberries, peppers, cucumbers, potatoes, and squash.</p>';
    -- Glades County - 12043
    v_text(12043) := '<p>Glades County is located in South Central Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DESOTO&city=&region_id=8">Desoto</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HENDRY&city=&region_id=8">Hendry</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HIGHLANDS&city=&region_id=8">Highlands</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKEECHOBEE&city=&region_id=8">Okeechobee</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HARDEE&city=&region_id=8">Hardee</a>
 counties.  The only incorporated municipality in Glades County is the city of
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GLADES&city=MOORE%20HAVEN&region_id=8">
 Moore Haven</a>, the county seat. Other communities include Buckhead Ridge, Lakeport, Palmdale, and Muse. The Brighton Seminole Indian Reservation is in Glades as well. The county is located just to the west of Lake Okeechobee. The population is in excess of 12,000.</p>
<p>The main industries providing employment are educational, health, and social services; agriculture, forestry, fishing, and hunting; public administration; and construction. Major private sector employers in Glades County are Moore Haven Correctional Facility, Lykes Bros, Inc., Brighton Seminole Bingo, Glades Electric Co-op, and A Duda. The top public sector employer is Glades County School Board. Cost of living in Glades County is relatively low at 83.1, compared to the US average of 100.</p>
<p>A rural county, agriculture is important to the economy of Glades. More than 1.2 million commercial fruit trees in the county produce over 2.5 million boxes of citrus annually, the vast majority of which are oranges. Glades ranks number nine among Florida counties for number of cattle and calves. Aside from ranching, much of the county’s land is given over to pine tree farming.</p>
<p>Moore Haven, a city of over 1,500, is located on the southwestern shore of Lake Okeechobee, where it intersects with the Caloosahatchee Canal. The city hosts a head of the Lake Okeechobee Scenic Trail, which allows hikers and mountain bikers to view the lake and its wildlife around the 110-mile path. The city is home to the annual Chalo Nitka festival, one of the oldest festivals in the state, which is essentially a large county fair that showcases local culture and the culture of Seminole Indians.</p>';
    -- Gulf County - 12045
    v_text(12045) := '<p>Gulf County is located in northwest Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAY&city=&region_id=5">Bay</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA%20ROSA&city=&region_id=5">Santa Rosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ESCAMBIA&city=&region_id=5">Escambia</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WALTON&city=&region_id=5">Walton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HOLMES&city=&region_id=5">Holmes</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JACKSON&city=&region_id=5">Jackson</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WASHINGTON&city=&region_id=5">Washington</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKALOOSA&city=&region_id=5">Okaloosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CALHOUN&city=&region_id=5">Calhoun</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LIBERTY&city=&region_id=5">Liberty</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FRANKLIN&city=&region_id=5">Franklin</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GADSDEN&city=&region_id=5">Gadsden</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEON&city=&region_id=5">Leon</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JEFFERSON&city=&region_id=5">Jefferson</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WAKULLA&city=&region_id=5">Wakulla</a>
 counties. The largest industries are trade, transportation & utility; education & health services; and financial activities. Major private sector employers are GAC Contractors, Bay St. Joseph Care & Rehabilitation Center, Duren''s Piggly Wiggly, Fairpoint Communications, and Raffield Fisheries. The top public sector employers include Florida Department of Corrections, Gulf County School District, and County of Gulf. Cities and towns in Gulf County include Port St. Joe (county seat), Wewahitchka, and White City.</p>';
    -- Hamilton County - 12047
    v_text(12047) := '<p>Hamilton County is located in North Central Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ALACHUA&city=&region_id=7">Alachua</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MADISON&city=&region_id=7">Madison</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=TAYLOR&city=&region_id=7">Taylor</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUWANNEE&city=&region_id=7">Suwannee</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=UNION&city=&region_id=7">Union</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BRADFORD&city=&region_id=7">Bradford</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAFAYETTE&city=&region_id=7">Lafayette</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DIXIE&city=&region_id=7">Dixie</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEVY&city=&region_id=7">Levy</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GILCHRIST&city=&region_id=7">Gilchrist</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARION&city=&region_id=7">Marion</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLUMBIA&city=&region_id=7">Columbia</a>
 counties. Municipalities include Jasper, the county seat, Jennings, and White Springs. Hamilton County has over 14,000 inhabitants.</p>
<p>Leading industries in Hamilton County are public administration, trade & transportations, and professional & business services. Major private sector employers for Hamilton County are PCS Phosphate White Springs, Suwannee Valley Nursing Center, Coggins Farms, Hamilton Jai Alai & Poker, and Taylor Industrial Construction Inc. Top public sector employers include Hamilton County School District, Hamilton County Government, and Hamilton County Sheriff''s Department.</p>
<p>Phosphate mining is a large industry in Hamilton County, employing nearly 1,000 of the 14,000 residents. The PCS Phosphate facility in White Springs produces phosphate for industrial purposes. The plant churns out over 4 million tonnes every year.</p>';
    -- Hardee County - 12049
    v_text(12049) := '<p>Hardee County is located in South Central Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DESOTO&city=&region_id=8">Desoto</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HENDRY&city=&region_id=8">Hendry</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GLADES&city=&region_id=8">Glades</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HIGHLANDS&city=&region_id=8">Highlands</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKEECHOBEE&city=&region_id=8">Okeechobee</a>  counties.  Incorporated cities are
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HARDEE&city=BOWLING%20GREEN&region_id=8">
Bowling Green</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HARDEE&city=WAUCHULA&region_id=8">
Wauchula</a> (the county seat), and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HARDEE&city=ZOLFO%20SPRINGS&region_id=8">
Zolfo Springs</a>. The county''s population is over 25,000.</p>
<p>The major industries for Hardee County are citrus, phosphate mining, vegetable farming, and cattle. The population increases during the harvesting season as a result of migratory workers. Major private sector employers are Florida Institute for Neurological Rehabilitation, Wal-Mart, Mosaic, C.F. Industries, and Peace River Electric Cooperative. Top public sector employers include Hardee School District, County Government, and Hardee County Sheriff''s Office.</p>
<p>A rural county, Hardee’s economy is largely driven by agriculture. It is the fifth most productive county in Florida for citrus. Virtually all of the over 12 million boxes of citrus are oranges. 47,000 acres are devoted to commercial citrus production. Hardee County is also number five for the number of cattle and calves. Much of the cattle in the region is sold to ranches in the western portion of the nation before they are mature so that they can grow larger than they would be able to at Florida ranches.</p>
<p>Wauchula is situated along the Peace River, giving it access to maritime recreation, from paddleboarding to canoeing to fishing. The healthcare industry is a large segment of the county''s economy; Florida Hospital Wauchula is located in the city. Commercial farms in the area grow blueberries, cucumbers, eggplant, squash, peppers, tomatoes, and watermelons.</p>
<p>Hardee County includes three public golf courses. Throughout the county are recreational lakes, including four at Hardee Lakes County Park. In addition to fishing at the lake, the park includes trails for hiking, horseback riding, and cycling.</p>';
    -- Hendry County - 12051
    v_text(12051) := '<p>Hendry County is located in South Central Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DESOTO&city=&region_id=8">Desoto</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GLADES&city=&region_id=8">Glades</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HIGHLANDS&city=&region_id=8">Highlands</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKEECHOBEE&city=&region_id=8">Okeechobee</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HARDEE&city=&region_id=8">Hardee</a>
 counties.  Incorporated cities in Hendry County are 
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HENDRY&city=CLEWISTON&region_id=8">
Clewiston</a> and 
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HENDRY&city=LABELLE&region_id=8">
LaBelle</a> (the county seat). Hendry County is known to the U.S. Census Bureau as the Clewiston Micropolitan Statistical Area. The county''s population is in excess of 35,000.</p>
<p>The largest industries by employment are trade, transportation, & utilities; public administration; and natural resources and mining. Major private sector employers include US Sugar Corp, Southern Gardens, A Duda & Sons, Hendry County Hospital Authority, and Alico, Inc. Top public sector employers include Hendry County School District, Hendry County, and Hendry County Sheriff''s Office.</p>
<p>72.5% of the land in Hendry County is used for agriculture. Hendry County’s location on the southwest shore of Lake Okeechobee gives it access to the rich soil that was left after the partial drainage of the Everglades. The number one crop is citrus, with over 9 million trees in the county, followed by sugar cane and fresh vegetables. Watermelons are also grown in significant quantities in Henry County.</p>
<p>Located in the northeastern corner of the county, Clewiston is on the southwestern shore of Lake Okeechobee. The city known as “America’s Sweetest Town” is home to over 6,000. The U.S. Sugar Corporation mill is located on the southern end of the city. It processes 700,000 tons of sugar cane each year.</p>
<p>Clewiston is also known as the Gateway to Lake Okeechobee. The 730 square-mile lake is full of opportunities for maritime recreation, including fishing. Largemouth bass is a popular target for fishers, and many bass tournaments are held in Clewiston. Fishermen and -women also fish the crappie. Fishing contributes millions of dollars to the local economy every year. The lake is also a prime spot for yachting and birding. Hikers can use the Herbert Hoover Dike that rings the water to view the lake and its wildlife.</p>';
    -- Hernando County - 12053
    v_text(12053) := '<p>Hernando County is in the Tampa bay region of Florida, along with <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MANATEE&city=&region_id=2">Manatee</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=POLK&city=&region_id=2">Polk</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HILLSBOROUGH&city=&region_id=2">Hillsborough</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PINELLAS&city=&region_id=2">Pinellas</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PASCO&city=&region_id=2">Pasco</a>,   <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CITRUS&city=&region_id=2">Citrus</a> and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SARASOTA&city=&region_id=2">Sarasota</a> counties. The major industries in Hernando County are Distribution, Healthcare, Cement Production, Manufacturing, Mining, Tourism, Dairy/Cattle Production, Citrus Production, Forest Resources, and Construction.</p>
    <p>Hernando County is home to the largest (truck-to-truck) Wal-Mart Distribution Center in the U.S, making Wal-Mart the county''s largest employer. Other major employers in Hernando County include Oak Hill Hospital, Spring Hill & Brooksville Regional Hospitals, Sparton Electronics, and Florida Crushed Stone. Public Sector employers are Hernando County School Board, Hernando County Government, and Southwest Florida Water District. Cities and census designated places in Hernando County include Brooksville, Weeki Wachee, Bayport, Brookridge, Spring Hill, and Spring Lakes.</p>';
    -- Highlands County - 12055
    v_text(12055) := '<p>Highlands County is located in the south central Florida region, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DESOTO&city=&region_id=8">Desoto</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HENDRY&city=&region_id=8">Hendry</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GLADES&city=&region_id=8">Glades</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKEECHOBEE&city=&region_id=8">Okeechobee</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HARDEE&city=&region_id=8">Hardee</a>
 counties. The largest industries providing employment are education & health services, natural resources & mining, trade & transportation, and government. Major private sector employers for Highlands County are Florida Hospital Heartland Division, Highlands Regional Medical Center, Cross Country Automotive Services, Wal-Mart Sebring, and Medical Data Systems. Top public sector employers are Highlands County School Board and Highlands County Board of Commissioners. Incorporated cities and towns include Avon Park, Lake Placid, and Sebring (county seat)</p>';
    -- Hillsborough County - 12057
    v_text(12057) := '<p>Hillsborough County is in the Tampa Bay region of Florida, along with <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CITRUS&city=&region_id=2">Citrus</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HERNANDO&city=&region_id=2">Hernando</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PASCO&city=&region_id=2">Pasco</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PINELLAS&city=&region_id=2">Pinellas</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=POLK&city=&region_id=2">Polk</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MANATEE&city=&region_id=2">Manatee</a>, and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SARASOTA&city=&region_id=2">Sarasota</a> counties. Tampa, one of Florida''s largest cities, is part of Hillsborough County. Over 1.2 million people live in Hillsborough County.</p>
<p>Hillsborough County has the 6th largest school district in the country, employing approximately 25,000 people. Other major public employers are MacDill Air Force Base, Hillsborough County Government, University of South Florida, and Hillsborough Community College. The largest private sector employers are JP Morgan Chase, H. Lee Moffitt Cancer Center & Research Institute, Citi, Pricewaterhouse Coopers, and Progressive Insurance. Target industries are applied medicine & human performance, high-tech electronics and instruments, business, financial & data services, and marine & environmental activities.</p>
<p>Busch Gardens, one of Florida''s main theme parks, is in Tampa and attracts many tourists. Tourists also visit historic Tampa neighborhood of Ybor City, once a cigar factory district, now a National Historic Landmark. Many tourists also flow through the Port of Tampa, which handles about a million cruise passengers each year. Not just for tourists, the port is busiest in the state for cargo, with large quantities of phosphates and steel flowing through it.    </p>
<p>Located just outside of Tampa is MacDill Air Force Base, the headquarters for U.S. Central Command and the Special Operations Command. When hurricanes threaten the Atlantic coast, “hurricane hunter” planes takeoff from MacDill to fly into the storm and take measurements. MacDill employs more than 14,000 and has an estimated impact of $5 billion.</p>
<p>Tampa is ranked by the Globalization and World Cities Research Network as a Gamma+ class city. In 2014 it was ranked as the number two city in the nation for investing in rental properties by All Property Management.</p>';
    -- Holmes County - 12059
    v_text(12059) := '<p>Holmes County is part of the Northwest Florida region, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAY&city=&region_id=5">Bay</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA%20ROSA&city=&region_id=5">Santa Rosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ESCAMBIA&city=&region_id=5">Escambia</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WALTON&city=&region_id=5">Walton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JACKSON&city=&region_id=5">Jackson</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WASHINGTON&city=&region_id=5">Washington</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKALOOSA&city=&region_id=5">Okaloosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CALHOUN&city=&region_id=5">Calhoun</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LIBERTY&city=&region_id=5">Liberty</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GULF&city=&region_id=5">Gulf</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FRANKLIN&city=&region_id=5">Franklin</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GADSDEN&city=&region_id=5">Gadsden</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEON&city=&region_id=5">Leon</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JEFFERSON&city=&region_id=5">Jefferson</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WAKULLA&city=&region_id=5">Wakulla</a>
 counties. The largest industries by employment are public administration; trade, transportation & utility; and construction.</p>
    <p>Major private sector employers for Holmes County are Bonifay Nursing & Rehab, Piggly Wiggly, LKQ, Bonifay IGA, Jerkin''s Inc. and Arban. Major public sector employers are Florida Department of Corrections, Holmes County School Board, and County of Holmes. Cities and towns in Holmes County include Bonifay (county seat), Esto, Noma, Ponce de Leon, and Westville.</p>';
    -- Indian River County - 12061
    v_text(12061) := '<p>Indian River County is part of the southeast region of Florida, along with <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20LUCIE&city=&region_id=1">St. Lucie</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MIAMI-DADE&city=&region_id=1">Miami-Dade</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PALM%20BEACH&city=&region_id=1">Palm Beach</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BROWARD&city=&region_id=1">Broward</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARTIN&city=&region_id=1">Martin</a>, and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MONROE&city=&region_id=1">Monroe</a> counties. Cities in Indian River County are Vero Beach (county seat), Sebastian, Fellsmere, Indian River Shores, and Orchid. The county’s population is over 135,000 people. Indian River is one of the wealthiest counties in the state and in the nation.</p>
<p>Indian River County has targeted clean energy, information technology, aviation/aerospace, and financial/professional services as its industries for expansion. Major private sector employers are Indian River Medical Center, Publix Supermarkets, Piper Aircraft Inc., Sebastian River Medical Center, and John''s Island. Public sector employers are School District of Indian River County, Indian River County, City of Vero Beach, and City of Sebastian.</p>
<p>As with most counties along the treasure coast, tourism is a major industry.  Agriculture also plays a large part in Indian River County''s economy. Resources produced here include citrus, beef, and honey. Because so much of the economy revolves around agriculture, unemployment is often high in summer months.</p>
<p>The most populous city is Sebastian, home to 22,000. Sebastian Airport is headquarters for Velocity Aircraft. The city is also home to an Indian River State College campus.</p>
<p>Over 15,000 people live in Vero Beach, the seat of Indian River County. One of the largest employers in the county is Piper Aircraft, which maintains their general aviation production facility and headquarters in the city. Vero Beach is a tourist destination, known for golfing, fishing, and surfing. It also hosts a Disney resort.</p>';
    -- Jackson County - 12063
    v_text(12063) := '<p>Jackson County is part of the Northwest Florida region, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAY&city=&region_id=5">Bay</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA%20ROSA&city=&region_id=5">Santa Rosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ESCAMBIA&city=&region_id=5">Escambia</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WALTON&city=&region_id=5">Walton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HOLMES&city=&region_id=5">Holmes</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WASHINGTON&city=&region_id=5">Washington</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKALOOSA&city=&region_id=5">Okaloosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CALHOUN&city=&region_id=5">Calhoun</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LIBERTY&city=&region_id=5">Liberty</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GULF&city=&region_id=5">Gulf</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FRANKLIN&city=&region_id=5">Franklin</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GADSDEN&city=&region_id=5">Gadsden</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEON&city=&region_id=5">Leon</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JEFFERSON&city=&region_id=5">Jefferson</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WAKULLA&city=&region_id=5">Wakulla</a>
 counties.  Top industries for Jackson County include government, trade & transportation, education and health services, and agriculture & natural resources.</p>
    <p>Jackson County is Florida''s top producer of soybeans and peanuts and contains a large distribution center. Major private sector employers for Jackson County are Family Dollar Distribution Center, Wal-Mart, Rex Lumber Company, Anderson Columbia, Inc, and Mowery Elevator Company, Inc. The largest public sector employers are Florida Department of Corrections–Sneads, Bureau of prisons, Florida Department of Corrections –Malone, Jackson County, and City of Marianna. Cities and towns in Jackson County include Alford, Bascom, Campbellton, Cottondale, Graceville, Grand Ridge, Greenwood, Jacob City, Malone, Marianna (county seat), and Sneads.</p>';
    -- Jefferson County - 12065
    v_text(12065) := '
<p>Jefferson County is located in northwest Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAY&city=&region_id=5">Bay</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA%20ROSA&city=&region_id=5">Santa Rosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ESCAMBIA&city=&region_id=5">Escambia</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WALTON&city=&region_id=5">Walton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HOLMES&city=&region_id=5">Holmes</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JACKSON&city=&region_id=5">Jackson</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WASHINGTON&city=&region_id=5">Washington</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKALOOSA&city=&region_id=5">Okaloosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CALHOUN&city=&region_id=5">Calhoun</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LIBERTY&city=&region_id=5">Liberty</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GULF&city=&region_id=5">Gulf</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FRANKLIN&city=&region_id=5">Franklin</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GADSDEN&city=&region_id=5">Gadsden</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEON&city=&region_id=5">Leon</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WAKULLA&city=&region_id=5">Wakulla</a>
 counties. Jefferson County is Florida''s easternmost county that borders both Georgia and the Gulf of Mexico. Over 14,000 people live in Jefferson County.</p>
<p>The largest industries by employment are trade, transportation, and utility; public administration; and construction. Major private sector employers are Brynwood Center, Simpson Nurseries, Crosslandings Health & Rehab Center, Jefferson County Kennel Club, and Farmers & Merchants Bank. Top public sector employers are Jefferson County School District, Florida Department of Corrections, and Jefferson County. Jefferson County''s seat is Monticello.</p>
<p>Jefferson is largely an agricultural region. Cattle ranching is an important part of the economy here. Watermelons, pears, and pecans are staple crops for the county. Every year, the Watermelon Festival celebrates the harvest.</p>';
    -- Lafayette County - 12067
    v_text(12067) := '<p>Lafayette County is located in North Central Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ALACHUA&city=&region_id=7">Alachua</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MADISON&city=&region_id=7">Madison</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HAMILTON&city=&region_id=7">Hamilton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=TAYLOR&city=&region_id=7">Taylor</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUWANNEE&city=&region_id=7">Suwannee</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=UNION&city=&region_id=7">Union</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BRADFORD&city=&region_id=7">Bradford</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DIXIE&city=&region_id=7">Dixie</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEVY&city=&region_id=7">Levy</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GILCHRIST&city=&region_id=7">Gilchrist</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARION&city=&region_id=7">Marion</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLUMBIA&city=&region_id=7">Columbia</a>
 counties. Most of Lafayette County''s 548 square miles in dedicated to timber and farmland. The leading industries in Lafayette County are corrections, agriculture, and healthcare. Major private sector employers are Mayo Correctional Institute, Lafayette Healthcare Nursing Home, Putnal''s Pinestraw, Bass Assassin Worms, and Townsend Pinestraw. Top public sector employers are Lafayette County School District, Lafayette County Government, and Lafayette County Sheriff''s Office.  Mayo is the county''s only incorporated city and also the county seat.</p>';
    -- Lake County - 12069
    v_text(12069) := '<p>Lake County is located in the east central Florida region, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BREVARD&city=&region_id=3">Brevard</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ORANGE&city=&region_id=3">Orange</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=VOLUSIA&city=&region_id=3">Volusia</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUMTER&city=&region_id=3">Sumter</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SEMINOLE&city=&region_id=3">Seminole</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OSCEOLA&city=&region_id=3">Osceola</a>
 counties. Cities of Lake County include Astatula, Clermont, Eustis, Fruitland Park, Groveland, Lady Lake, Leesburg, Mascotte, Minneola, Montverde, Mount Dora, Tavares, and Umatilla. Lake County has approximately 1,400 named lakes. It is home to around 300,000 people. About one in four residents are over the age of 65.</p>
<p>Top industries in Lake County are retail, healthcare, construction, and food services. Major private sector employers for Lake County are Leesburg Regional Medical Center, Wal-Mart, Villages of Lake Sumter Inc., Florida Hospital-Waterman, and Publix Supermarkets. Top public sector employers are Lake County Public Schools, Lake County Government, and Lake County Sheriff''s Department.</p>
<p>The county seat is Tavares, a city with a population over 12,000. A third of the people who live in Tavares are over age 65. The city’s economic strength lies in services, especially healthcare and retail.</p>
<p>Leesburg is a city of over 20,000. Nestled among the Harris Chain of Lakes, maritime recreational opportunities abound, including boating and fishing.The area hosts many full-service retirement communities. The Leesburg Regional Airport features two runways for general aviaion craft.</p>';
    -- Lee County - 12071
    v_text(12071) := '<p>Lee County is located in the southwest Florida region, along with <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLLIER&city=&region_id=6">Collier</a> and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CHARLOTTE&city=&region_id=6">Charlotte</a> counties. The communities in Lee County include Bonita Springs, Cape Coral, Fort Myers, Fort Myers Beach, Lehigh Acres, North Fort Myers, San Carlos Park, Sanibel/Captiva, and South Fort Myers. Incorporated communities are Cape Coral, Fort Myers, Fort Myers Beach, Bonita Springs, and Sanibel. The population of Lee County is in excess of 600,000.</p>
<p>Top industries currently providing employment are trade, transportation, and utilities; leisure and hospitality; education and health services; and professional and business services. Major private sector employers in Lee County are Publix Supermarkets, Wal-Mart, Chico''s FAS Inc., Bonita Bay Group, and WCI Group. Top public sector employers are Lee County School District, Lee County Administration, Lee County Sheriff''s Office, and the City of Cape Coral.</p>
<p>Historically, Lee County was best known for its agricultural industry and still heavily produces crops such as sweet corn, cucumbers, peppers and potatoes. Seafood is also produced in large quantities in Lee County. Annually, over five million pounds of fish and two million pounds of shellfish are harvested in Lee County. Today, however, the most dominant industries are tourism, construction, and other service related industries.</p>
<p>The most populous city in southwest Florida is Cape Coral, home to over 150,000. The U.S. Census Bureau estimated that the city grew by 10% from 2010-2013. The city lies on a peninsula surrounded by Charlotte Harbor, with the Caloosahatchee River on the city’s southern border. There are over 400 miles of inland navigable waterways within city limits, the most of any city in the world.</p>
<p>Located across the Caloosahatchee, the county seat of Fort Myers has a population over 60,000 people. The economic heart of Lee County, the city’s strength is in the services, including the healthcare and tourism industries. Just south of the city is Florida Gulf Coast University, Florida''s newest public university. Additionally, Florida SouthWestern State College, formerly Edison State College, is located within city limits.</p>';
    -- Leon County - 12073
    v_text(12073) := '<p>Leon County is part of the northwest region of Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAY&city=&region_id=5">Bay</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA%20ROSA&city=&region_id=5">Santa Rosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ESCAMBIA&city=&region_id=5">Escambia</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WALTON&city=&region_id=5">Walton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HOLMES&city=&region_id=5">Holmes</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JACKSON&city=&region_id=5">Jackson</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WASHINGTON&city=&region_id=5">Washington</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKALOOSA&city=&region_id=5">Okaloosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CALHOUN&city=&region_id=5">Calhoun</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LIBERTY&city=&region_id=5">Liberty</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GULF&city=&region_id=5">Gulf</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FRANKLIN&city=&region_id=5">Franklin</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GADSDEN&city=&region_id=5">Gadsden</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JEFFERSON&city=&region_id=5">Jefferson</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WAKULLA&city=&region_id=5">Wakulla</a>
 counties. Main industries for this area include advanced manufacturing, aviation, aerospace, defense, health sciences, renewable energy, and transportation. Florida''s capital, Tallahassee, is a part of Leon County, and also acts as the county seat. The county has over 275,000 inhabitants.</p>
<p>Two of Florida''s main Universities, Florida State University and Florida A&M University, are also a part of Leon County. As a result, Leon County has the highest average level of education among Florida''s 67 counties. Leon County''s regional economy remained stable throughout the recession as a result of a significant public sector presence. The unemployment rate has decreased and is below the state average at 8.1%. The housing market has not been as negatively affected in this county as in the rest of the state; the tax base loss is moderate and foreclosure rates equal the national average. The largest private sector employers are Tallahassee Memorial healthcare, Publix Supermarkets, Walmart, Capital Regional Medical Center, and ACS. Top public employers are the State of Florida, Florida State University, Leon County Schools, City of Tallahassee, and Florida A&M University.</p>
<p>Much of the economy is driven by the state government, especially the two universities. Both are major research universities; Florida State attracts over $200 million annually, while FAMU brings in at least $30 million each year. FSU operates the National High Magnetic Lab, the world’s most powerful and largest magnetic laboratory. In addition to offering numerous degree programs at all levels, both universities also run law and medical schools. FSU and FAMU are located in Tallahassee.</p>
<p>Tallahassee Regional Airport handles commercial and general aviation. Around 400,000 people make use of its facilities each year. The airport is responsible for an economic impact around $350 million annually and sustains about 4,000 careers.</p>';
    -- Levy County - 12075
    v_text(12075) := '<p>Levy County is located in North Central Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ALACHUA&city=&region_id=7">Alachua</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MADISON&city=&region_id=7">Madison</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HAMILTON&city=&region_id=7">Hamilton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=TAYLOR&city=&region_id=7">Taylor</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUWANNEE&city=&region_id=7">Suwannee</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=UNION&city=&region_id=7">Union</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BRADFORD&city=&region_id=7">Bradford</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAFAYETTE&city=&region_id=7">Lafayette</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DIXIE&city=&region_id=7">Dixie</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GILCHRIST&city=&region_id=7">Gilchrist</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARION&city=&region_id=7">Marion</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLUMBIA&city=&region_id=7">Columbia</a>
 counties. Levy County is unique in that its area contains both hardwood forests and Gulf Coast beaches. Nature based tourism is a big industry in Levy County. Other leading industries include trade & transportation, agriculture, and construction. Major private sector employers are Wal-Mart, D.A.B. Contructors, Monterey Boats, Williston Health Care Center Inc, Central Florida Electric Co-Op, and Williston Holding Company. The top public sector employer is Levy County School Board. Cities in Levy County are Bronson, Cedar Key, Chiefland, Inglis, Morriston, Otter Creek, Williston, and Yankeetown.</p>';
    -- Liberty County - 12077
    v_text(12077) := '<p>Liberty County is located in northwest Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAY&city=&region_id=5">Bay</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA%20ROSA&city=&region_id=5">Santa Rosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ESCAMBIA&city=&region_id=5">Escambia</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WALTON&city=&region_id=5">Walton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HOLMES&city=&region_id=5">Holmes</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JACKSON&city=&region_id=5">Jackson</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WASHINGTON&city=&region_id=5">Washington</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKALOOSA&city=&region_id=5">Okaloosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CALHOUN&city=&region_id=5">Calhoun</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GULF&city=&region_id=5">Gulf</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FRANKLIN&city=&region_id=5">Franklin</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GADSDEN&city=&region_id=5">Gadsden</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEON&city=&region_id=5">Leon</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JEFFERSON&city=&region_id=5">Jefferson</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WAKULLA&city=&region_id=5">Wakulla</a>
 counties. Liberty County is Florida''s least populous county and The Apalachicola National Forest occupies half the county. Its main industries by employment are public administration; education, health, & social services; and construction. Liberty County is also known for its timber industry. The major private sector employers are Twin Oaks Juvenile Development, C.W. Roberts Contracting, Inc, Georgia Pacific, North Florida Lumber, Inc, and Apalachee Pole. Top public sector employers are Liberty County and Liberty County School District. Incorporated and unincorporated areas in Liberty County include Bristol (county seat), White Springs, Rock Bluff, Hosford, Orange, Wilma, and Telogia.</p>';
    -- Madison County - 12079
    v_text(12079) := '<p>Madison County is located in North Central Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ALACHUA&city=&region_id=7">Alachua</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HAMILTON&city=&region_id=7">Hamilton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=TAYLOR&city=&region_id=7">Taylor</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUWANNEE&city=&region_id=7">Suwannee</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=UNION&city=&region_id=7">Union</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BRADFORD&city=&region_id=7">Bradford</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAFAYETTE&city=&region_id=7">Lafayette</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DIXIE&city=&region_id=7">Dixie</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEVY&city=&region_id=7">Levy</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GILCHRIST&city=&region_id=7">Gilchrist</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARION&city=&region_id=7">Marion</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLUMBIA&city=&region_id=7">Columbia</a>
 counties. The largest industries by employment in Madison County are education & health services; trade, transportation, & utilities; and public administration. Major private sector employers are Madison Correctional Facility, Nestle Waters North America, Johnson & Johnson, Lake Park of Madison Nursing Home, and Madison County Memorial Hospital. Top public sector employers are Madison County School District, Madison Correctional Facility, and Madison County Government. Madison County cities are Greenville, Lee, Madison (county seat), and Pinetta.</p>';
    -- Manatee County - 12081
    v_text(12081) := '<p>Manatee County is part of the Tampa Bay region of Florida, along with <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SARASOTA&city=&region_id=2">Sarasota</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=POLK&city=&region_id=2">Polk</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HILLSBOROUGH&city=&region_id=2">Hillsborough</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PINELLAS&city=&region_id=2">Pinellas</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PASCO&city=&region_id=2">Pasco</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HERNANDO&city=&region_id=2">Hernando</a>, and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CITRUS&city=&region_id=2">Citrus</a> counties. Incorporated cities and towns in Manatee County include the county seat of Bradenton, Anna Maria, Bradenton Beach, Holmes Beach, Palmetto, and Longboat Key. The county’s population is over 300,000.</p>
<p>Major industries include retail trade, agriculture, tourism, and retirement. Other important parts of the Manatee County economy are manufacturing, agribusiness, and fishing. The cost of living in Manatee County is slightly higher than the rest of the state.</p>
<p>Manatee County''s largest private sector employers are Bealls Inc., Manatee Memorial Hospital, Tropicana Products, Inc., and Publix. Major public sector employers are Manatee County School District, Manatee County Government, and Manatee County Sheriff’s Department. Bealls of Florida is headquartered in Manatee County.</p>
<p>The county seat is Bradenton, an old-Florida town that dates to the 1880s. As such, tourism is a strong economic driver, with tourists enjoying the warm weather and maritime recreation such as fishing. Bradenton also hosts a Tropicana juice production facility.</p>';
    -- Marion County - 12083
    v_text(12083) := '<p>Marion County is located in North Central Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ALACHUA&city=&region_id=7">Alachua</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MADISON&city=&region_id=7">Madison</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HAMILTON&city=&region_id=7">Hamilton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=TAYLOR&city=&region_id=7">Taylor</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUWANNEE&city=&region_id=7">Suwannee</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=UNION&city=&region_id=7">Union</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BRADFORD&city=&region_id=7">Bradford</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAFAYETTE&city=&region_id=7">Lafayette</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DIXIE&city=&region_id=7">Dixie</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEVY&city=&region_id=7">Levy</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GILCHRIST&city=&region_id=7">Gilchrist</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLUMBIA&city=&region_id=7">Columbia</a>
 counties. Incorporated municipalities include Belleview, Dunnellon, Ocala, McIntosh, and Reddick. The population of Marion County is over 330,000.</p>
<p>The largest industries providing employment in Marion County are agriculture, educational, health, and social services; retail trade; and manufacturing. Major private sector employers are Munroe Regional Medical Center, Ocala Regional Medical Center & West Marion Community Hospital, AT&T, Lockheed Martin, and E-ONE Inc. top public sector employers include Marion County Public Schools, Florida State Government, Federal Government, Marion County BCC, and City of Ocala.</p>
<p>Marion County is the only region in the United States that can legitimately claim the title of the horse capital of the world. Marion County contains nearly 50,000 horses during peak season, more than any other county in the nation. Thoroughbred racehorses from Marion were the first Florida-bred horses to win the Kentucky Derby and Florida Derby. The industry drives approximately $2.2 billion into the local economy and supports 40,000 jobs.</p>
<p>An important agricultural area, Marion County has a long history of ranching. It is the 12th largest cattle producer in the state and the Ocala Bull Sale is the oldest in the nation. More than 250,000 acres are devoted to logging. Other crops produced here include peanuts, citrus, and hay.</p>
<p>Ten miles northwest of Ocala lies the Lowell Correctional Institution. The facility was the first to house female inmates exclusively. The Lowell Annex is part of the complex and houses the state''s female inmates on death row.</p>';
    -- Martin County - 12085
    v_text(12085) := '<p>Martin County is part of the southeast region of Florida, along with
    <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=INDIAN%20RIVER&city=&region_id=1">Indian River</a>,
    <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20LUCIE&city=&region_id=1">St. Lucie</a>,
    <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MIAMI-DADE&city=&region_id=1">Miami-Dade</a>,
    <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PALM%20BEACH&city=&region_id=1">Palm Beach</a>,
    <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BROWARD&city=&region_id=1">Broward</a>, and
    <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MONROE&city=&region_id=1">Monroe</a> counties.
Martin cities and towns are Stuart, Jupiter Island, Ocean Breeze, and Sewall''s Point. Other communities of note include Hobe Sound, Indiantown, Jensen Beach, and Palm City. More than 140,000 people live in Martin County.</p>
<p>County targeted industries include aviation and aerospace, environmental/green technologies, marine industries, and headquarters. Top public sector employers are Martin County School District, Martin County, Florida State Government, City of Stuart, and Indian River State College. Private employers are Martin Memorial Healthcare Systems, Publix Supermarkets, Old Cell Phone, TurboCombustor Technologies Inc, and Florida Power and Light.</p>
<p>The county seat of Stuart is home to over 15,000. Known as the Sailfish Capital of the World, Stuart is a popular boating and fishing destination. Indeed, Ralph Evinrude, owner of Evinrude Outboard Motors, retired to nearby Jensen Beach.</p>
<p>Jupiter Island is a town located in the southeastern section of the county on the barrier island of the same name. Located off the coast of Hobe Sound, Jupiter Island is amongst the five wealthiest places per capita in the country. The town has been home to celebrities such as Tiger Woods, Celine Dion, and Alan Jackson.</p>';
    -- Miami-Dade County - 12086
    v_text(12086) := '<p>Miami-Dade County is part of the southeast Florida region along with <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=INDIAN%20RIVER&city=&region_id=1">Indian River</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20LUCIE&city=&region_id=1">St. Lucie</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARTIN&city=&region_id=1">Martin</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PALM%20BEACH&city=&region_id=1">Palm Beach</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BROWARD&city=&region_id=1">Broward</a>, and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MONROE&city=&region_id=1">Monroe</a> counties. Miami Dade County has 35 cities and incorporates many different geographical areas. The north, central, and east regions are heavily urbanized, with many large skyscrapers and a dense population. The southern region of Miami-Dade County is sparsely populated and is the heart of Miami-Dade''s agricultural economy. The western region of the county includes the Everglades National Park and is inhabited only by a tribal village. The county is home to around 2.5 million people, making it the most populous in Florida and number seven in the country.</p>
<p>Major industries for this county are tourism, international trade, international banking, and transportation. Top public employers are Miami-Dade County Public Schools, Miami-Dade County, the Federal Government, Florida State Government, and Jackson Health Systems. Major private employers include the University of Miami, Baptist Health South Florida, Publix Supermarkets, American Airlines, and Precision Response Corporation.</p>
<p>The county''s seat and largest city is Miami. Miami''s close proximity to Latin America and the Caribbean makes it the center for international trade with those areas. The city’s population is 70% Hispanic. The concentration of Latin American businesses and international banks in the city has given it the nickname “Capital of Latin America”. PortMiami acts as one of the largest cruise spots in the world. Miami International Airport is one of the busiest ports of entry for foreign travelers and handles the most international air cargo of any airport in the country.</p>
<p>Miami-Dade is also a major tourist destination, especially in the city of Miami Beach. The historic 1920s Art Deco hotels on Ocean Drive are well-known landmarks, many of which have historic designations. Visitors enjoy the warm weather, sandy beaches, and nightlife of South Beach. It is also a major convention destination. The annual Art Basel Miami and its satellite fairs bring the foremost art collectors to South Beach and the Miami neighborhood of Wynwood.</p>
<p>Miami-Dade County is home to numerous large universities including the private University of Miami, public Florida International University, and Catholic Barry University. The county is also home to historically-black Florida Memorial University and Miami Dade College, the second-largest public university in the nation by enrollment. The Miami-Dade County Public School System is the fifth-largest in the nation.</p>';
    -- Monroe County - 12087
    v_text(12087) := '<p>Monroe County is part of the southeast Florida region along with
    <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MIAMI-DADE&city=&region_id=1">Miami-Dade</a>,
    <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=INDIAN%20RIVER&city=&region_id=1">Indian River</a>,
    <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20LUCIE&city=&region_id=1">St. Lucie</a>,
    <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARTIN&city=&region_id=1">Martin</a>,
    <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PALM%20BEACH&city=&region_id=1">Palm Beach</a>, and
    <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BROWARD&city=&region_id=1">Broward</a>.
 Key West is the county seat. Other incorporated municipalities are Marathon, Key Colony Beach, Layton, and Islamorada. The county''s population is over 70,000.</p>
<p>Monroe County is the southernmost county in Florida and the continental United States. 99% of the population of Monroe County lives in the Florida Keys, which are wholly contained within Monroe County. Mainland Monroe County is covered by wetlands. Portions of Everglades National Park and Big Cypress National Preserve form the entirety of the section of Monroe County that lies on the peninsula. 22% of the properties in Monroe County are government owned.</p>
<p>The largest industry in Monroe County is tourism. In 2010, The Keys alone had 3.8 million visitors. Major private sector employers are Kmart, HMA, Baptist Mariner''s Hospital, HTA, and Hawks Cay Resort. Public employers are US Armed Forces, Monroe County Schools, Monroe County Government, and Florida Keys Community College.</p>
<p>Visitors go to the Keys for the year-round warm weather, sandy beaches, and stunning vistas of both the Atlantic Ocean and Gulf of Mexico. The islands of the Keys offer a variety of maritime recreation opportunities, including boating, fishing, and windsurfing. The Keys are sometimes referred to as the Conch Republic after the islands seceded from the United States in 1982 and immediately surrendered to protest a blockade at the mainlands to search for drugs.</p>
<p>Once the largest city in Florida, Key West is still the southernmost in the lower 48. The cultural and economic heart of Monroe County is at the southern terminus of US 1. The southern islands have long been a naval base, dating back to its establishment in 1823 to combat piracy. Today, Naval Air Station Key West is used as a forward base to combat the narcotics trade in the Caribbean and as a flight training center.</p>';
    -- Nassau County - 12089
    v_text(12089) := '<p>Nassau County is in the northeastern region of Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAKER&city=&region_id=4">Baker</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CLAY&city=&region_id=4">Clay</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DUVAL&city=&region_id=4">Duval</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PUTNAM&city=&region_id=4">Putnam</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20JOHNS&city=&region_id=4">St John''s</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FLAGLER&city=&region_id=4">Flagler</a>
 counties. It is situated in the northeastern corner of Florida, along the border with Georgia and just north of Jacksonville. Incorporated municipalities include Fernandina Beach, Callahan, and Hilliard. The county’s population is over 70,000.</p>
<p>The largest industries in Nassau County are trade, transportation and utilities; leisure and hospitality; and education and health services. Major private sector employers include Amelia Island Plantation, Ritz Carlton, Smurfit-Stone, Wal-Mart, and Baptist Medical Center - Nassau. Top private sector employers are Nassau County School Board, Nassau County Government, Federal Aviation Administration, and City of Fernandina Beach.</p>
<p>Nassau County has a diverse economy, with a lot of agriculture activity, mostly tree farms, in the west and a variety of activities near Amelia Island. With over 7,000 head of cattle, Nassau County has the 43rd-highest population of cattle and calves in the state. The Nassau Wildlife Management Area and Four Creeks State Forest in the central portion of the county provide outdoor recreational opportunities.</p>
<p>Amelia Island is a popular tourist destination and contains two upscale hotels. High profile people such as President Bill Clinton have vacationed at the exclusive White Oak Plantation. The largest city in Nassau and the county seat, Fernandina Beach, is located on Amelia Island. Not just a tourist destination, a Rayonier pulp mill in the city processes the timber that is collected in the western portions of the county.</p>';
    -- Okaloosa County - 12091
    v_text(12091) := '<p>Okaloosa County is part of the Northwest Florida region, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAY&city=&region_id=5">Bay</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA%20ROSA&city=&region_id=5">Santa Rosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ESCAMBIA&city=&region_id=5">Escambia</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WALTON&city=&region_id=5">Walton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HOLMES&city=&region_id=5">Holmes</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JACKSON&city=&region_id=5">Jackson</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WASHINGTON&city=&region_id=5">Washington</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CALHOUN&city=&region_id=5">Calhoun</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LIBERTY&city=&region_id=5">Liberty</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GULF&city=&region_id=5">Gulf</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FRANKLIN&city=&region_id=5">Franklin</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GADSDEN&city=&region_id=5">Gadsden</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEON&city=&region_id=5">Leon</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JEFFERSON&city=&region_id=5">Jefferson</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WAKULLA&city=&region_id=5">Wakulla</a>
 counties. Okaloosa has a population over 180,000. The county is part of one of the fastest growing regions in the nation. The county is located in the panhandle, with the southern portion bordering the Gulf of Mexico and the northern portion on the Georgia border.</p>

<p>Top industries in Okaloosa County are government, professional & business services, trade & transportation, leisure and hospitality, and education & health services. Several air force and army facilities are located in Okaloosa County, including Eglin Air Force Base, Hurlburt Field, and Duke Field. By size, Eglin is the largest Air Force base in the country and is responsible for the development, acquisition, testing, and deployment of all air-delivered weapons. Okaloosa county''s white sand beaches also attract many tourists to the area. Top private sector employers are Fort Walton Beach Medical Center, L-3 Communications/Crestview Aerospace, DRS Training & Control Systems, InDyne Inc, and ResortQuest. Major public sector employers are US Department of Defense-Eglin AFB, Okaloosa School District, and County of Okaloosa-Sheriff''s Department.</p>

<p>Defense is major business in Okaloosa. Of the ten largest defense contractors in the state, six have a presence in Okaloosa. 350 such companies provide 21,000 jobs and contribute over $6.5 billion to the economy.</p>

<p>Okaloosa is a major transportation hub. Indeed, its county seat, Crestview, is nicknamed the "Hub City". With two rivers, a CSX railroad line, and access to multiple highways including Interstate-10, the city is at the center of the region.</p>

<p>Northwest Florida State College has five campuses throughout the county, with its main campus in Niceville. Troy University also has campuses in the county, including one on Eglin AFB.</p>';    
    -- Okeechobee County - 12093
    v_text(12093) := '<p>Okeechobee County is located in South Central Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DESOTO&city=&region_id=8">Desoto</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HENDRY&city=&region_id=8">Hendry</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GLADES&city=&region_id=8">Glades</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HIGHLANDS&city=&region_id=8">Highlands</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HARDEE&city=&region_id=8">Hardee</a>
 counties. Okeechobee County''s only city is 
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKEECHOBEE&city=OKEECHOBEE&region_id=8">
Okeechobee</a> and this is also the county seat. The second largest freshwater lake in the U.S., Lake Okeechobee, is partially located within Okeechobee County. The U.S. Census Bureau identifies the county as the Okeechobee Micropolitan Statistical Area. The county population is over 39,000.</p>
<p>The leading industries in Okeechobee, Florida are educational, health and social services; retail trade; and arts, entertainment, recreation, accommodation and food services. Major private sector employers include Columbia Raulerson Hospital, Walpole Inc., Larson Dairy Inc., McArthur Farms Inc., and Okeechobee Healthcare. The top public sector employers are Okeechobee School District, Okeechobee Sheriff''s Office, and Okeechobee County.</p>
<p>Primarily rural and agricultural, Okeechobee County has the most cattle and calves of any county in Florida. The 1930s Okeechobee Livestock Market is the largest market of its kind in the state by volume, with around 150,000 transactions annually. In addition to raising calves, dairy production is also an important segment of the cattle industry, contributing over $100 million annually. Okeechobee is also a citrus producing county, with an annual production of over 1.5 million boxes, the majority of which are oranges.</p>
<p>The county seat of Okeechobee is home to over 5,000. Just northwest of the city is Okeechobee County Airport, a general aviation facility with a 5,000-foot runway that contributes around $10 million to the local economy. The city’s location near Lake Okeechobee allows for easy access to fishing and the trail that runs its circumference. Okeechobee is known as the "Speckled Perch Capital of World" and hosts the annual Speckled Perch Festival.</p>';
    -- Orange County - 12095
    v_text(12095) := '<p>Orange County is part of the East Central Florida region along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BREVARD&city=&region_id=3">Brevard</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=VOLUSIA&city=&region_id=3">Volusia</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUMTER&city=&region_id=3">Sumter</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SEMINOLE&city=&region_id=3">Seminole</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAKE&city=&region_id=3">Lake</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OSCEOLA&city=&region_id=3">Osceola</a>
 Counties. With a population over 1.1 million, Orange is the fifth most populous county in Florida. Incorporated municipalities include Apopka, Bay Lake, Belle Isle, Edgewood, Lake Buena Vista, Maitland, Ocoee, Orlando, Winter Garden, Winter Park, Eatonville, Oakland, and Windermere.</p>
<p>Orlando is Orange County''s largest city and is home to many of the country''s most popular theme parks, making tourism the county''s primary industry. Other main industries for Orange County are life sciences & health care resources; modeling, simulation & training resources; optics & photonics resources; and clean technology. Orange County''s largest private sector employers are Walt Disney World, Adventist Health Systems, Universal Orlando, Orlando Health, and Busch Entertainment Corp. Top public sector employers are Orange County Public Schools, Greater Orlando Aviation Authority, Orange County Government, and The University of Central Florida.</p>
<p>For many in the United States and across the world, Orlando is synonymous with the Walt Disney World Resort. Indeed, Disney produced a study indicating that the resort and businesses associated with it were responsible for an $18 billion economic impact, 2.5% of the GDP of the state of Florida. The Greater Orlando area also hosts the Universal Orlando theme parks, each of which features a Harry Potter-themed section. In addition, numerous tourist attractions exist, mostly catering to a family audience, such as miniature golf courses, arcades, and amusement parks.</p>
<p>Greater Orlando has a business side, too. Orange County is also home to the University of Central Florida, which is the second largest public university in the country at approximately 60,000 students. UCF has a partnership with the Central Florida Research Park, the seventh-largest research park in the country, located next close to the university. Orlando is an important city for the military, including pilot training with its varied flight simulators and production facilities. Madden NFL Football, the most popular video game franchise in the country, is created in Orlando by Electronic Arts.</p>
<p>As its name implies, rural Orange County is a center of citrus production. Much of the land is given over to orange groves. Apopka hosts a Minute Maid juice flavoring plant.</p>';
    -- Osceola County - 12097
    v_text(12097) := '<p>Osceola County is located in East Central Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BREVARD&city=&region_id=3">Brevard</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ORANGE&city=&region_id=3">Orange</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=VOLUSIA&city=&region_id=3">Volusia</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUMTER&city=&region_id=3">Sumter</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SEMINOLE&city=&region_id=3">Seminole</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAKE&city=&region_id=3">Lake</a>
 counties. Osceola County has the following incorporated areas/cities: Buenaventura Lakes, Celebration, Poinciana, Campbell, Kissimmee, Saint Cloud, Poinciana Place, and Yeehaw Junction. The county has a population well in excess of a quarter of a million.</p>
<p>Osceola County''s close proximity to Disney World makes tourism a major industry. Other industries in the area are arts, entertainment, recreation, accommodation and food services; retail trade; and educational, health, and social services. Major private sector employers are Walt Disney Company, Wal-Mart, Florida Hospital Kissimmee & Celebration, Osceola Regional Medical Center, and Gaylord Palms Resort & Convention Center. Osceola County''s largest public sector employers are Osceola School District and Osceola County Government.</p>
<p>The cost of living index in Osceola County in 2012 was 87.1, significantly less than the US average of 100.</p>
<p>Historically a transportation hub and center of agriculture and cattle ranching, modern Kissimmee’s economy is focused on tourism. The city’s proximity to the Walt Disney World Resort makes it a perfect spot for tourists to stay when visiting the theme park.</p>
<p>Kissimmee’s population is 25% Hispanic.</p>';
    -- Palm Beach County - 12099
    v_text(12099) := '<p>Palm Beach County is part of the southeast Florida region along with <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=INDIAN%20RIVER&city=&region_id=1">Indian River</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20LUCIE&city=&region_id=1">St. Lucie</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARTIN&city=&region_id=1">Martin</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MIAMI-DADE&city=&region_id=1">Miami-Dade</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BROWARD&city=&region_id=1">Broward</a>, and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MONROE&city=&region_id=1">Monroe</a> counties. Palm Beach County has 38 cities, towns and villages in total. West Palm Beach is the county''s largest city and acts as the county seat. Palm Beach has a population over 1.3 million.</p>
<p>Palm Beach County has many wealthy towns such as Palm Beach, Boca Raton, and Jupiter, as well as a large equestrian population making it one of Florida''s wealthiest counties. As a result, real estate prices are comparatively higher in Palm Beach County than most other counties in Florida.</p>
<p>Palm Beach County''s major private sector employers are Tenet Healthcare Corporation, Hospital Corporation of America, Florida Power & Light, The Breakers, and Office Depot. Top public sector employers are Palm Beach County School Board, Palm Beach County, Florida Atlantic University, and Boca Raton Community Hospital. Palm Beach County considers agribusiness; aviation, aerospace, and engineering; equestrian; healthcare; green energy; and corporate headquarters to be among its main industries.</p>
<p>Boca Raton is in southern Palm Beach County and is known as the birthplace of the IBM personal computer. It still hosts a large research park focused on technological innovation. The city hosts the headquarters for Office Depot and GEO Group. Florida Atlantic University and Lynn University are both located in Boca Raton.</p>';
    -- Pasco County - 12101
    v_text(12101) := '<p>Pasco County is part of the Tampa Bay region of Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MANATEE&city=&region_id=2">Manatee</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=POLK&city=&region_id=2">Polk</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HILLSBOROUGH&city=&region_id=2">Hillsborough</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PINELLAS&city=&region_id=2">Pinellas</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HERNANDO&city=&region_id=2">Hernando</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CITRUS&city=&region_id=2">Citrus</a> and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SARASOTA&city=&region_id=2">Sarasota</a>
 counties. Pasco County lists agri-business, logistics, defense, and medical/biomedical/life sciences as its targeted industries. Pasco County''s largest public sector employers are Pasco County School District, Pasco County Government, Pasco County Sheriff, State of Florida, and the Federal Government. Main private sector employers are Pall Aeropower Corporation; Zephyrhills Spring Water Co; VLOC, Subsidiary of II-VI, Inc; Zephy Egg LLC, and Preferred Materials, Inc. Pasco County cities include Aripeka, Bayonet Point, Crystal Springs, Dade City (County Seat), Elfers, Gulf Harbors, Holiday, Hudson, Lacoochee, New Port Richey, Odessa, Port Richey, San Antonio, Trinity, and Zephyrhills.</p>';
    -- Pinellas County - 12103
    v_text(12103) := '<p>Pinellas County is part of the Tampa Bay region of Florida, along with <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CITRUS&city=&region_id=2">Citrus</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HERNANDO&city=&region_id=2">Hernando</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PASCO&city=&region_id=2">Pasco</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HILLSBOROUGH&city=&region_id=2">Hillsborough</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=POLK&city=&region_id=2">Polk</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MANATEE&city=&region_id=2">Manatee</a>, and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SARASOTA&city=&region_id=2">Sarasota</a> counties. The county lies on a peninsula across Tampa Bay from Hillsborough County and the city of Tampa. Pinellas counts over 900,000 people in its population. There are 24 incorporated municipalities in Pinellas County.</p>
<p>Pinellas County''s largest industries are tourism, retail and wholesale trade, and finance, insurance and real estate. Major private sector employers include Home Shopping Network, Fidelity Information Services, Nielson Media Research, Raymond James Financial, and Tech Data Corp. Public employers are Pinellas County School District, Pinellas County Government, City of St. Petersburg, and Pinellas County Sheriff''s Office.</p>
<p>Around 5 million people visit Pinellas County annually. Pinellas County''s main tourist attraction is its beaches along the gulf coast. Pinellas County also attracts a lot of retirees, with one in five of its residents over the age of sixty five.</p>
<p>Unlike many counties, the largest city is not the county seat. Home to around a quarter of a million people, St. Petersburg is the fifth-largest city in Florida and headquarters for Home Shopping Network, Jabil Circuit, and Raymond James Financial. The county seat is Clearwater, which has a population around 100,000. Clearwater is home to Fortune 500 company Tech Data.</p>
<p>The city of Tarpon Springs was largely settled by Greeks and is currently the city most heavily populated by people of Greek ancestry in the U.S. Tarpon Springs is a major center of sponging. Though economic activity revolves around a variety of aquaculture harvesting, including fishing and shrimping, sponge diving and its legacy are what the city is known for.</p>';
    -- Polk County - 12105
    v_text(12105) := '<p>Polk County is part of the Tampa Bay region of Florida along with <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CITRUS&city=&region_id=2">Citrus</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HERNANDO&city=&region_id=2">Hernando</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PASCO&city=&region_id=2">Pasco</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PINELLAS&city=&region_id=2">Pinellas</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HILLSBOROUGH&city=&region_id=2">Hillsborough</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MANATEE&city=&region_id=2">Manatee</a>, and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SARASOTA&city=&region_id=2">Sarasota</a> counties. It is located inland, to the east of Hillsborough County and Tampa. The county is the geographic center of Florida’s population. Polk County is between the two large metropolitan areas of Tampa and Orlando, which accounts for its rapid population growth rate. Despite the positive growth, unemployment rates are historically lower in Polk County than anywhere else in the state. It has a population in excess of 600,000 and 17 incorporated municipalities.</p>
<p>Polk County''s economy revolves around the industries of phosphate mining, agriculture, and tourism. Major private sector employers are Publix Supermarkets, Wal-Mart, Lakeland Regional Medical Center, Winter Haven Hospital, and GEICO. The largest public sector employers are Polk County School Board, Polk County Government, Florida State Government, and City of Lakeland. Though the economy depends less on tourism than in other parts of the state, the building of LEGOLAND Florida in Winter Haven has increased tourism and boosted the economy.</p>
<p>Of all Florida counties, Polk has the 2nd most farmland in the state. Like other areas in the central part of the state, Polk has numerous citrus groves.</p>
<p>A mining and railroad town, Lakeland has steadily grown since its 1885 incorporation. Home to around 100,000 people, Lakeland is the headquarters for Saddle Creek Logistics and Fortune 500 supermarket chain Publix. Lakeland also hosts Florida Polytechnic University, Southeastern University, Florida Southern College, and campuses of Polk State College and Webster University.</p>';
    -- Putnam County - 12107
    v_text(12107) := '<p>Putnam County is part of the northeastern region of Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAKER&city=&region_id=4">Baker</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CLAY&city=&region_id=4">Clay</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DUVAL&city=&region_id=4">Duval</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=NASSAU&city=&region_id=4">Nassau</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20JOHNS&city=&region_id=4">St John''s</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FLAGLER&city=&region_id=4">Flagler</a>
 counties. Putnam County is an industrial rural community. The top industries by employment for Putnam County are government; trade, transportation & utilities; education & health services; and manufacturing. Putnam County''s major private sector employers are Georgia Pacific, Putnam Community Center, Wal-Mart, Precision Response Corporation, and Seminole Electric Corporation. Top public sector employers are Putnam County School District, St. Johns River Water Management District, and Putnam County.  Cities and towns in Putnam County include Crescent City, Interlachen, Palatka (county seat), Pomona Park, and Welaka.</p>
<p>Palatka is the principal center of the Palatka Micropolitan Statistical Area, which encompasses Putnam County. The city of over 10,000 lies on the St. Johns River. In addition to being a port, Palatka is home to manufacturing centers operated by Georgia Pacific and Veritas Steel.</p>
<p>The county has a number of natural areas for recreation, including the northeastern section of Ocala National Forest, Etoniah Creek State Forest, Rice Creek Conservation Area, Horseshoe Point Conservation Area, the Marjorie Harris Carr Cross Florida Greenway, and Dunns Creek. The county includes over 175 miles of state-certified canoe paths. Palatka can also lay claim to a Ravine Gardens State Park, created in the 1930s. Palatka and the town of Interlachen both have arts & culture activities, including museums and galleries, wildlife observatories, and historic sites.</p>
<p>Forestry is the most important part of the agricultural industry in Putnam County. Timber consumes more land than any other agricultural product. Farms in the county produce crops including potatoes, cabbage, and poultry. Like other places in Florida, cattle ranching and citrus harvesting are also important agricultural activities.</p>';
    -- St. Johns County - 12109
    v_text(12109) := '<p>St. Johns County is in the northeastern Florida region along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAKER&city=&region_id=4">Baker</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CLAY&city=&region_id=4">Clay</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DUVAL&city=&region_id=4">Duval</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=NASSAU&city=&region_id=4">Nassau</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PUTNAM&city=&region_id=4">Putnam</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FLAGLER&city=&region_id=4">Flagler</a>
 counties. It is one of the original counties that was organized when Florida became part of the United States. It is home to about 60,000.</p>

<p>The county seat is St. Augustine, the oldest city in the United States that was founded by Europeans and is still inhabited. It was established by the Spanish in 1565, who also built a fort, the Castillo de San Marcos, which became operational in 1695. The city was the capital of colonial Florida until the United States established the territorial government at Tallahassee in 1824. The arrival of Henry Morrison Flagler in the 1880s, accompanied by the construction of two luxury resort hotels, signaled the establishment of St. Augustine’s tourist economy.</p>

<p>The county is a major tourist destination. Visitors patronize the many beaches and golf courses throughout the county. In addition, the historical and cultural activities draw many visitors.</p>

<p>The region also includes higher education facilities, including Flagler College and St. Johns River College. The Florida School for the Deaf and Blind, which has a secondary school and a college, is in St. Augustine.</p> ';
    -- St. Lucie County - 12111
    v_text(12111) := '<p>St. Lucie County is part of the southeast Florida region along with <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BROWARD&city=&region_id=1">Broward</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=INDIAN%20RIVER&city=&region_id=1">Indian River</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MIAMI-DADE&city=&region_id=1">Miami-Dade</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARTIN&city=&region_id=1">Martin</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MONROE&city=&region_id=1">Monroe</a>, and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PALM%20BEACH&city=&region_id=1">Palm Beach</a> counties. Incorporated areas for St. Lucie County are Fort Pierce (county seat), Port St. Lucie, and St. Lucie Village. Other notable communities include Lakewood Park, Indian River Estates, River Park, and White City. The county’s population is over 275,000.</p>
<p>St. Lucie County lists manufacturing facilities, clean energy, professional and technical services, information industries, administrative and support services, and finance and insurance services among its target industries. The large number of biological research firms in the county sometimes leads to it being called the Research Coast. Cost of living in this area is 99.06, compared with Florida''s 100.</p>
<p>Though the region was thinly populated as late as the 1950s, a series of planned communities in the 1960s created Port St. Lucie and resulted in a population explosion, doubling from the 2000 to 2010 Census. Over 160,000 people call Port St. Lucie home, making it the ninth-largest city in the state. In 2008, the Torrey Pines Institute for Molecular Studies opened a LEED-certified research center. Additionally, Mann Research Center is a 150-acre research park. Known for its golf, the city hosts three PGA tour courses that are open to the public.</p>
<p>The seat of St. Lucie County is Fort Pierce. The city''s location near the Indian River Lagoon makes it a prime spot for researchers who are interested in the most biologically diverse estuary in the nation. Both the Smithsonian Marine Station and Florida Atlantic University Harbor Branch Oceanographic Institution.</p> ';
    -- Santa Rosa County - 12113
    v_text(12113) := '<p>Santa Rosa County is part of the Northwest region of Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAY&city=&region_id=5">Bay</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ESCAMBIA&city=&region_id=5">Escambia</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WALTON&city=&region_id=5">Walton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HOLMES&city=&region_id=5">Holmes</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JACKSON&city=&region_id=5">Jackson</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WASHINGTON&city=&region_id=5">Washington</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKALOOSA&city=&region_id=5">Okaloosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CALHOUN&city=&region_id=5">Calhoun</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LIBERTY&city=&region_id=5">Liberty</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GULF&city=&region_id=5">Gulf</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FRANKLIN&city=&region_id=5">Franklin</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GADSDEN&city=&region_id=5">Gadsden</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEON&city=&region_id=5">Leon</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JEFFERSON&city=&region_id=5">Jefferson</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WAKULLA&city=&region_id=5">Wakulla</a>
 counties. The largest industries by employment are trade, transportation & utilities; leisure & hospitality; education & health services; and professional & business services.</p>
    <p> Top private sector employers for Santa Rosa County are Wal-Mart, Baptist Health Care, Clearwire, Mediacom, and Santa Rosa Medical Center. Major public sector employers are Santa Rosa County School District, US Government, Florida State Government, and Santa Rosa County. Cities and towns in Santa Rosa County include Gulf Breeze, Jay, and Milton.</p>';
    -- Sarasota County - 12115
    v_text(12115) := '<p>Sarasota County is part of the Tampa Bay Region along with<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MANATEE&city=&region_id=2">Manatee</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=POLK&city=&region_id=2">Polk</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HILLSBOROUGH&city=&region_id=2">Hillsborough</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PINELLAS&city=&region_id=2">Pinellas</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PASCO&city=&region_id=2">Pasco</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HERNANDO&city=&region_id=2">Hernando</a>, and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CITRUS&city=&region_id=2">Citrus</a> counties. Sarasota County consists of the cities of Sarasota, Venice, and North Port, and the Town of Longboat Key. The county is home to over 375,000 people.</p>
<p>Top industries are education and health services, leisure and hospitality, retail trade, and professional and business services. Targeted sectors are clean technology/green business, film/entertainment, life sciences, light manufacturing, and sports/ ecotourism.</p>
<p>Sarasota County has three higher education facilities: New College of Florida, University of South Florida Sarasota-Manatee, and Ringling College of Art and Design. Public sector employers for Sarasota County include the School Board of Sarasota County, Sarasota County Government, and Sarasota Memorial Hospital. Main private employers are PGT Industries, Sun Hydraulics Corporation, Tervis, FCCI Insurance, and Protocol Communications.</p>
<p>At the south end of the county is North Port, a master-planned community that was incorporated in 1959. The 75-square-mile city is home to more than 50,000 people and growing. The city is primarily a bedroom community.</p>
<p>Home to just over 50,000, Sarasota is the county seat. Once the winter home of the famed Ringling Brothers Circus, two of the Ringling brothers invested in Sarasota, establishing a cultural scene stronger than what would be expected of a city its size. The economy is diversified, strong in healthcare and administrative services. Boar’s Head Provision Company is headquartered in the city.</p>';
    -- Seminole County - 12117
    v_text(12117) := '<p>Seminole County is located in the East Central Florida region, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BREVARD&city=&region_id=3">Brevard</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ORANGE&city=&region_id=3">Orange</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=VOLUSIA&city=&region_id=3">Volusia</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUMTER&city=&region_id=3">Sumter</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAKE&city=&region_id=3">Lake</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OSCEOLA&city=&region_id=3">Osceola</a>
 County. Cities in Seminole County include Altamonte Springs, Casselberry, Lake Mary, Longwood, Oviedo, Sanford, and Winter Springs. Seminole County’s population is over 420,000 despite being one of the geographically smallest counties in Florida.</p>
<p>Seminole County''s major industries include agri-technology, aviation & aerospace, clean technology, and information technology. Top public sector employers in Seminole County are Seminole County Public Schools, Seminole State College of Florida, Seminole County Government, and Seminole County Sheriff Department. The largest private sector employers are Convergys, Florida Hospital, Chase Bankcard Services, Orlando Regional Healthcare, and American Automobile Association.</p>
<p>Known as the Historic Waterfront Gateway City because of its location at the confluence of Lake Monroe and the St. Johns River, Sanford is the seat of Seminole County. Historically a transportation hub for the production of nearby agriculture, Sanford was once known as "Celery City". Home to over 50,000, the city''s economy is driven by the service industries and construction. The city''s waterfront marinas are still home to commercial craft, but they also host plenty of recreational boats.</p>
<p>AAA (American Automobile Association) is headquartered in the unincorporated Seminole County community of Heathrow.</p>';
    -- Sumter County - 12119
    v_text(12119) := '<p>Sumter County is located in East Central Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BREVARD&city=&region_id=3">Brevard</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ORANGE&city=&region_id=3">Orange</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=VOLUSIA&city=&region_id=3">Volusia</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SEMINOLE&city=&region_id=3">Seminole</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAKE&city=&region_id=3">Lake</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OSCEOLA&city=&region_id=3">Osceola</a>
 counties.  Cities in Sumter County include Bushnell, Center Hill, Coleman, Webster, and Wildwood. The county is home to over 90,000.</p>
<p>The largest industries in Sumter County by employment are leisure & hospitality, trade & transportation, education & health services, and public administration. Sumter County major private employers are The Villages, T&D Concrete, Villages Regional Medical Center, Wal-Mart, and Sumter Electric Cooperative. Major public employers include Coleman Federal Prison, Sumter District Schools, Sumter Correctional Institute, Sumter County Government, and Lake Sumter Community College.</p>
<p>Known as "Hog County" for its large pig population, Sumter is historically a largely rural county. Sumter is number eighteen among Florida counties for number of cattle and calves. In the southern end of the county, near Webster, cucumbers, eggplants and peppers are grown for commercial sale. Near the unincorporated community of Oxford in the north, tomatoes and watermelons are the more popular crops.</p>
<p>The county is known to the Census Bureau as The Villages Micropolitan Statistical Area, named after the most populous census-designated place in Sumter County. The Villages is a large, planned retirement community that spans Sumter, Lake, and Marion Counties. The community in northeast Sumter County is home to over 50,000. In addition to the retirees, The Villages also contains subdivisions for workers and their families that includes a charter school. Over 95% of residents are white caucasians.</p>';
    -- Suwannee County - 12121
    v_text(12121) := '<p>Suwannee County is located in North Central Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ALACHUA&city=&region_id=7">Alachua</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MADISON&city=&region_id=7">Madison</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HAMILTON&city=&region_id=7">Hamilton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=TAYLOR&city=&region_id=7">Taylor</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=UNION&city=&region_id=7">Union</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BRADFORD&city=&region_id=7">Bradford</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAFAYETTE&city=&region_id=7">Lafayette</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DIXIE&city=&region_id=7">Dixie</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEVY&city=&region_id=7">Levy</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GILCHRIST&city=&region_id=7">Gilchrist</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARION&city=&region_id=7">Marion</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLUMBIA&city=&region_id=7">Columbia</a>
 counties. Poultry manufacturing and healthcare are Suwannee County''s largest industries. Major private sector industries are Pilgrim''s Pride, Advent Christian Village, Shands of Live Oak, Florida Sheriffs Youth Ranch, and Musgrove Construction. Top public sector employers include Suwannee County School District, Suwannee County, and Suwannee County Sheriff''s Department. Cities and towns in Suwannee County include Branfoord, Live Oak (county seat), Mcalpin, and O''Brien.</p>';
    -- Taylor County - 12123
    v_text(12123) := '<p>Taylor County is located in North Central Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ALACHUA&city=&region_id=7">Alachua</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MADISON&city=&region_id=7">Madison</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HAMILTON&city=&region_id=7">Hamilton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUWANNEE&city=&region_id=7">Suwannee</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=UNION&city=&region_id=7">Union</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BRADFORD&city=&region_id=7">Bradford</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAFAYETTE&city=&region_id=7">Lafayette</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DIXIE&city=&region_id=7">Dixie</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEVY&city=&region_id=7">Levy</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GILCHRIST&city=&region_id=7">Gilchrist</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARION&city=&region_id=7">Marion</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLUMBIA&city=&region_id=7">Columbia</a>
 counties. The largest industries are healthcare, manufacturing, and the production of wood products. Taylor County has abundant amounts of rural land, giving a lot of opportunity for growth and new development.</p>
    <p> Major private sector employers for Taylor county are Buckeye Technologies, Doctors Memorial Hospital, Chemring Ordnance, United Welding Services Inc, and Gilman Building Products. Top public sector employers are Taylor County School Board and Taylor County Correctional Institute. Incorporated and unincorporated areas in Taylor County include Perry (county seat), Athena, Eridu, Iddo, Salem, Lakebird, and Pinland.</p>';
    -- Union County - 12125
    v_text(12125) := '<p>Union County is located in North Central Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ALACHUA&city=&region_id=7">Alachua</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MADISON&city=&region_id=7">Madison</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HAMILTON&city=&region_id=7">Hamilton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=TAYLOR&city=&region_id=7">Taylor</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUWANNEE&city=&region_id=7">Suwannee</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BRADFORD&city=&region_id=7">Bradford</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAFAYETTE&city=&region_id=7">Lafayette</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DIXIE&city=&region_id=7">Dixie</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEVY&city=&region_id=7">Levy</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GILCHRIST&city=&region_id=7">Gilchrist</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARION&city=&region_id=7">Marion</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLUMBIA&city=&region_id=7">Columbia</a>
 counties. Union County is Florida''s smallest county in area. Union County''s largest industries by employment are trade, transportation, & utilities; manufacturing; and public administration. Major private sector employers are North Florida reception Center, Prichet Trucking, Suwannee Medical Personnel, Lake Butler Hospital/ Ramadan Hand Institute, and Ellington Construction. Top public sector employers are Union Correctional Institute, Union County School District, and Union County Government. Union County cities are Lake Butler (county seat), Raiford, and Worthington Springs.</p>';
    -- Volusia County - 12127
    v_text(12127) := '<p>Volusia County is located in the East Central Florida region, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BREVARD&city=&region_id=3">Brevard</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ORANGE&city=&region_id=3">Orange</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUMTER&city=&region_id=3">Sumter</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SEMINOLE&city=&region_id=3">Seminole</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAKE&city=&region_id=3">Lake</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OSCEOLA&city=&region_id=3">Osceola</a>
 counties. Volusia County cities and towns include Daytona Beach, DeBary, DeLand, Deltona, Holly Hill, New Smyrna Beach, Orange City, Ormond Beach, and Port Orange.</p>
<p>Top industries for Volusia County are education & health services, retail trade, leisure & hospitality, and professional & business services. Top private sector employers include Florida Hospital, Halifax Health, Wal-Mart, Publix Supermarkets, and Embry-Riddle Aeronautical University. Public sector employers include Volusia County School Board, County of Volusia, Florida state government, Daytona State College, and US government.</p>
<p>Volusia County is home to Daytona Beach and the Daytona International Speedway, which hosts NASCAR''s most prestigious race, the Daytona 500. Daytona Beach is also a popular tourist destination owing to its beaches and the races at its speedway. Daytona is home to the headquarters for NASCAR and the LPGA. Daytona features several golf courses.</p>
<p>The largest city in Volusia County in Deltona, which is a bedroom community for Orlando. Though it was originally a planned community for retirees, the city is now a quarter Hispanic and much younger.</p>';
    -- Wakulla County - 12129
    v_text(12129) := '<p>Wakulla County is located in northwest Florida, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAY&city=&region_id=5">Bay</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA%20ROSA&city=&region_id=5">Santa Rosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ESCAMBIA&city=&region_id=5">Escambia</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WALTON&city=&region_id=5">Walton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HOLMES&city=&region_id=5">Holmes</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JACKSON&city=&region_id=5">Jackson</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WASHINGTON&city=&region_id=5">Washington</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKALOOSA&city=&region_id=5">Okaloosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CALHOUN&city=&region_id=5">Calhoun</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LIBERTY&city=&region_id=5">Liberty</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GULF&city=&region_id=5">Gulf</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FRANKLIN&city=&region_id=5">Franklin</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GADSDEN&city=&region_id=5">Gadsden</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEON&city=&region_id=5">Leon</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JEFFERSON&city=&region_id=5">Jefferson</a>  counties.  There is not a lot of developed industry in Wakulla County. The largest industry is a commercial ball powder producing facility. Other industries include a fuel refinery, a tax exempted electrical power producing plant, a commercial billing agency, and a sea going barge terminal.</p>
    <p>The largest industries providing employment are public administration; education, health & social services; and construction. 89% of the land in Wakulla County is commercial forest land. Top private sector employers are St. Marks Power, CSG Systems Inc, and Eden Springs. The largest public sector employers include Wakulla County School Board, Florida Department of Corrections, and Florida Department of environment. Municipalities in Wakulla County include Sopchoppy, St. Marks and Crawfordville (county seat).</p>';
    -- Walton County - 12131
    v_text(12131) := '<p>Walton County is part of the Northwest Florida region, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAY&city=&region_id=5">Bay</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA%20ROSA&city=&region_id=5">Santa Rosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ESCAMBIA&city=&region_id=5">Escambia</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HOLMES&city=&region_id=5">Holmes</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JACKSON&city=&region_id=5">Jackson</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WASHINGTON&city=&region_id=5">Washington</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKALOOSA&city=&region_id=5">Okaloosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CALHOUN&city=&region_id=5">Calhoun</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LIBERTY&city=&region_id=5">Liberty</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GULF&city=&region_id=5">Gulf</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FRANKLIN&city=&region_id=5">Franklin</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GADSDEN&city=&region_id=5">Gadsden</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEON&city=&region_id=5">Leon</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JEFFERSON&city=&region_id=5">Jefferson</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WAKULLA&city=&region_id=5">Wakulla</a>
 counties. Largest industries by employment are leisure & hospitality; trade, transportation, & utility; and education & health services. Major private sector employers for Walton County are Sandestin Golf and Beach Resort, Sacred Heart on the Emerald Coast, ResortQuest, and Hilton Sandestin Beach Golf Resort & Spa. Top public sector employers include Walton County School Board and Walton County Government. Cities and towns in Walton County include DeFuniak Springs, Freeport, and Paxton.</p>';
    -- Washington County - 12133
    v_text(12133) := '<p>Washington County is part of the Northwest Florida region, along with
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAY&city=&region_id=5">Bay</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA%20ROSA&city=&region_id=5">Santa Rosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ESCAMBIA&city=&region_id=5">Escambia</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WALTON&city=&region_id=5">Walton</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HOLMES&city=&region_id=5">Holmes</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JACKSON&city=&region_id=5">Jackson</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKALOOSA&city=&region_id=5">Okaloosa</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CALHOUN&city=&region_id=5">Calhoun</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LIBERTY&city=&region_id=5">Liberty</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GULF&city=&region_id=5">Gulf</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FRANKLIN&city=&region_id=5">Franklin</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GADSDEN&city=&region_id=5">Gadsden</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEON&city=&region_id=5">Leon</a>,
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JEFFERSON&city=&region_id=5">Jefferson</a>,
and
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WAKULLA&city=&region_id=5">Wakulla</a>
 counties.  The top industries by employment for Washington County are public administration, trade & transportation, and construction.</p>
    <p> Major private sector employers for Washington County include WestPoint Home, Inc, Wal-Mart, NW Florida Community Hospital, Trawick Construction, and ARC of Wash-Holmes Cos. Top public sector employers are Florida Department of Corrections, Florida Department of Transportation, Washington County School District, and County of Washington. Cities and towns in Washington City include Caryville, Chipley, Ebro, Vernon, Wausau.</p> ';
    
    return v_text(p_cou);

  end get_static_text;

  function get_census_text( p_cou        in number) return varchar2 is
                     
    cursor cur_content(p_cou in number) is
    select PST0452 total_population
    ,      PST0402
    ,      PST1202 population_growth
    ,      POP0102
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
    
    v_text           varchar2(32767);
    v_table_text     varchar2(32767);
    v_table_header   varchar2(4000) :=
      '<table class="datatable"><caption>Regional Economic Indicators</caption>'
    ||'<tr><th scope="col">Region</th>'
    ||'<th scope="col">Population<br/>2012</th>'
    ||'<th scope="col">Economic Activity<br>2007 (Millions)</th>'
    ||'<th scope="col">Population Growth<br/>2010 to 2012</th>'
    ||'<th scope="col">Median Household<br/>Income 2011</th>'
    ||'<th scope="col">Housing <br/>Units</th>'
    ||'<th scope="col">Median Price<br/>2007 to 2011</th>'
    ||'</tr>';

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
    
  begin
    for usa_rec in cur_content(0) loop
      v_table_text := v_table_header||'<tr><th scope="row">United States'
                           ||'</th><td style="text-align:right">'||to_char(usa_rec.total_population, '999,999,999')
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
     v_table_text :=  v_table_text||'<tr><th scope="row"><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL">Florida</a>'
                           ||'</th><td style="text-align:right">'||to_char(fl_rec.total_population, '999,999,999')
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
    
    for county_rec in cur_content(p_cou) loop
     v_table_text :=  v_table_text||'<tr><th  scope="row">'||county_rec.name
                           ||'</th><td style="text-align:right">'||to_char(county_rec.total_population, '999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(county_rec.economy_size, '$999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(county_rec.population_growth, '90.9')||'%'
                           ||'</td><td style="text-align:right">'||to_char(county_rec.median_household_income, '$999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(county_rec.housing_units, '999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(county_rec.median_unit_price, '$999,999,999')
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
    
      v_text := '<p>'||county_rec.name||' has a population of approximately '||to_char(county_rec.total_population, '999,999,999')||' people. ' 
      ||'The population increased '||to_char(county_rec.population_growth, '90.9')||'% from 2010 to 2012. '
      ||'This compared to a '||to_char(v_fl_population_growth, '90.9')||'% increase for the State of Florida and a '
      ||to_char(v_usa_population_growth, '90.9')||'% increase for the country as a whole. '
      ||county_rec.name||' is '||county_rec.land_area||' square miles and had a population density of '
      ||county_rec.population_density||' Persons per square mile in 2010.  This compared to '||v_fl_population_density
      ||' for Florida and '||v_usa_population_density||' for the country.</p>'
    
      ||'<p>There are '||to_char(county_rec.housing_units, '999,999,999')||' housing units in '||county_rec.name
      ||' (a housing unit is defined by the US Census Bureau as a house, apartment, mobile home, group of rooms, or single room that is occupied as separate living quarters.) '
      ||county_rec.name||' has a '||to_char(county_rec.owner_occupied, '90.9')||'% homeownership rate compared to Florida''s rate of '
      ||to_char(v_fl_owner_occupied, '90.9')||'%. '||county_rec.name||'''s medium household income in 2011 was '
      ||to_char(county_rec.median_household_income, '$999,999,999')||', which is '||v_short_text
      ||' the medium income for Florida as a whole: '||to_char(v_fl_median_household_income, '$999,999,999')||'.</p>'
      
      ||v_table_text
    
      ||'<p>'||to_char(county_rec.poverty_pct, '90.9')||'% of the population in '||county_rec.name
      ||' lives below the poverty line, compared to '||to_char(v_fl_poverty_pct, '90.9')||'% in Florida and '
      ||to_char(v_usa_poverty_pct, '90.9')||'% nationwide.  Additional Information:</p>'
      ||'<ul><li><a href="http://quickfacts.census.gov/qfd/states/12/'||p_cou||'lk.html" target="_blank">'
      ||county_rec.name||' Census Data</a></li><li><a href="http://www.bebr.ufl.edu/data/county/'
      ||replace(county_rec.name, ' County')||'" target="_blank">University of Florida Bureau of Economic and Business Research - '||county_rec.name||'</a></li></ul>'
    
      
      
      ||'<h4>'||county_rec.name||' Economic Activity</h4>'
      ||'<p>The U.S. Bureau of the Census, Economic  , 2007 calculated the total value manufacturing, '
      ||'merchant wholesaler, retail sales and food service sales in '||county_rec.name||'. '
      ||'The Census measured activity of large and medium-sized firms during calendar year 2007. '
      ||'It does not include every aspect of the economy but can be used as a measure of economic activity.</p> '
      
      ||'<p>At '||to_char(county_rec.economy_size, '$999,999,999') ||' million, '
      ||county_rec.name||'''s economic activity represents '
      || to_char((county_rec.economy_size/v_fl_economy_size*100), '90.99')||'% of the Florida economy.</p>'  

      ||'<table class="datatable"><caption>Economic Activity</caption>'
      ||'<tr><th>Activity</th><th>Value (Millions)</th><th>Percentage</th></tr>'       
      ||'<tr><th>Manufacturers shipments</th><td style="text-align:right">'
      ||to_char(county_rec.manufacturing_total/1000, '$999,999,999')||'</td>'
      ||'<td style="text-align:right">'||to_char((county_rec.manufacturing_total/1000)/county_rec.economy_size*100,'90.9')||'%</td></tr>' 
      ||'<tr><th>Merchant wholesaler sales</th><td style="text-align:right">'
      ||to_char(county_rec.wholesale_total/1000, '$999,999,999')||'</td>' 
      ||'<td style="text-align:right">'||to_char((county_rec.wholesale_total/1000)/county_rec.economy_size*100,'90.9')||'%</td></tr>' 
      ||'<tr><th>Retail sales</th><td style="text-align:right">'
      ||to_char(county_rec.retail_total/1000, '$999,999,999')||'</td>' 
      ||'<td style="text-align:right">'||to_char((county_rec.retail_total/1000)/county_rec.economy_size*100,'90.9')||'%</td></tr>' 
      ||'<tr><th>Accommodation and food services sales</th><td style="text-align:right">'
      ||to_char(county_rec.accommodation_food/1000, '$999,999,999')||'</td>' 
      ||'<td style="text-align:right">'||to_char((county_rec.accommodation_food/1000)/county_rec.economy_size*100,'90.9')||'%</td></tr>' 
      ||'<tr><th>Total</th><td style="text-align:right">'
      ||to_char(county_rec.economy_size, '$999,999,999')||'</td>' 
      ||'<td style="text-align:right">100%</td></tr>' 
      ||'</table>';

                           
    end loop;
    
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
          v_table_text := v_table_text ||'<tr><th class="current"  scope="row">'||c_rec.name
                           ||'</th><td class="current" style="text-align:right">'||to_char(c_rec.total_population, '999,999,999')
                           ||'</td><td class="current" style="text-align:right">'||to_char(c_rec.economy_size, '$999,999,999')
                           ||'</td><td class="current" style="text-align:right">'||to_char(c_rec.population_growth, '90.9')||'%'
                           ||'</td><td class="current" style="text-align:right">'||to_char(c_rec.median_household_income, '$999,999,999')
                           ||'</td><td class="current" style="text-align:right">'||to_char(c_rec.housing_units, '999,999,999')
                           ||'</td><td class="current" style="text-align:right">'||to_char(c_rec.median_unit_price, '$999,999,999')
                           ||'</td></tr>';      

          
          
        else
          v_table_text := v_table_text ||'<tr><th scope="row"><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county='
                           ||upper(replace(c_rec.name, ' County'))||'">'||c_rec.name||'</a>'
                           ||'</th><td style="text-align:right">'||to_char(c_rec.total_population, '999,999,999')
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
                           ||'<tr><th scope="row">Total'
                           ||'</th><td style="text-align:right">'||to_char(v_pop, '999,999,999')
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
    
    v_text := v_text ||'<h4>'||v_county_name||' Regional Comparisons</h4>'
    ||'<p>'||v_short_text||'</p>'
    ||v_table_text;
    
    return v_text;
 
  end get_census_text;
  
  function get_realestate_text( p_name in varchar2
                              , p_mode in varchar2) return varchar2 is
    cursor cur_ucode_data(p_name in varchar2) is
    select u.description
    ,      round(sum(property_count)) property_count
    ,      round(sum(total_sqft)) total_volume
    from pr_ucode_data ud
    , rnt_cities c
    , pr_usage_codes u
    , pr_usage_codes uc
    where c.county=p_name
    and c.state='FL'
    and c.city_id = ud.city_id
    and ud.ucode = uc.ucode
    and u.ucode = uc.parent_ucode
    group by u.description;
    
    cursor cur_sales( p_county in varchar2
                    , p_type   in varchar2
                    , p_year   in varchar2) is
    select sales_count, total_sales, total_ft_sales, median_price
    , median_price_ft, a_median_price_ft, c_median_price_ft
    ,      to_char(max_date, 'FMMonth ddth, yyyy')  max_date
    ,      to_char(min_date, 'FMMonth ddth, yyyy')  min_date
    from pr_county_summary_mv 
    where display_county = p_county
    and  ucode_name = p_type
    and sales_year = p_year;
    

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
    
    for u_rec in cur_ucode_data(p_name) loop
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
      ||v_display_name||' County.  The following table shows a summary of them based on '||v_year||' sales data.</p>'
      ||'<table class="datatable"><caption>'||v_display_name||' County Real Estate Sales Summary</caption>'
      ||'<tr><th scope="col">Usage Type</th><th scope="col">Property Count</th><th scope="col">%</th><th scope="col">Sales Count</th><th scope="col">Median Price</th><th scope="col">Median Price/Ft</th><th scope="col">Sales From</th><th scope="col">To</th>';
    end if;
      
    loop_index := v_ucode_summary.FIRST; 
    while loop_index is not null loop
      if loop_index not in ('Total', 'Land') then
        for s_rec in cur_sales(v_display_name, loop_index, v_year) loop
          v_type_name := replace(loop_index, ' Property');
          if p_mode = 'table' then
            v_text := v_text||'<tr>'
            ||'<th scope="row">'||loop_index||'</th>'
            ||'<td>'||to_char(v_ucode_summary(loop_index).property_count, '999,999,999')||'</td>'
            ||'<td>'||to_char( v_ucode_summary(loop_index).property_count/v_ucode_summary('Total').property_count *100, '90.99')||'</td>'
            ||'<td>'||to_char(s_rec.sales_count, '999,999,999')||'</td>'
            ||'<td>'||to_char(s_rec.median_price, '$999,999,999')||'</td>'
            ||'<td>'||to_char(s_rec.median_price_ft, '$9,999')||'</td>'
            ||'<td>'||s_rec.min_date||'</td>'
            ||'<td>'||s_rec.max_date ||'</td>'                                    
            ||'</tr>';
            
          else
        
            v_text := v_text  
            ||'<h4>'||v_type_name||' Real Estate in '||v_display_name ||' County, Florida</h4>'
            ||'<p>'||to_char(v_ucode_summary(loop_index).property_count, '999,999,999')|| '('
            ||to_char( v_ucode_summary(loop_index).property_count/v_ucode_summary('Total').property_count *100, '99.99')
            ||'%) of the properties in '||v_display_name||' County are classified as '||v_type_name||'. ';
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
              ||loop_index||' in '||v_display_name||' County was '||to_char(s_rec.median_price_ft, '$9,999')||' per sq ft.';
            else
              v_text := v_text ||'A Class '
              ||loop_index||' in '||v_display_name||' County was '||to_char(s_rec.a_median_price_ft, '$9,999')||' per sq ft, '
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
  else  
    v_text := v_text
       ||'<h4>Additional Details:</h4><ul>'
       ||'<li><a href="/rental/visulate_search.php?REPORT_CODE=SALES&county='||p_name||'">'||v_display_name||' Property Sales History</a></li>'
       ||'<li><a href="/rental/visulate_search.php?REPORT_CODE=COMMERCIAL&county='||p_name||'">'||v_display_name||' Commercial Sales History</a></li>'
       ||'<li><a href="/rental/visulate_search.php?REPORT_CODE=LAND&county='||p_name||'">'||v_display_name||' Land Sales History</a></li>'
       ||'</ul>';
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
    select statecou
    ,      upper(replace(name, ' County')) county
    ,      name
    from ldr_counties
    where state = 'FL'
    order by county;
    
    v_desc      clob := empty_clob;
    v_cdesc     clob := empty_clob;
    v_text      varchar2(32767);
    v_len       binary_integer;

    v_county    varchar2(256);
  begin
    for c_rec in cur_county_list loop
      v_cdesc := '<h3>'||c_rec.name||'</h3>'
                      ||get_static_text(c_rec.statecou);
    
      dbms_lob.createtemporary(v_desc, TRUE);
      dbms_lob.open(v_desc, dbms_lob.lob_readwrite);
      
      v_text := get_census_text(c_rec.statecou);
      v_text := v_text||get_google_ad;
      v_len := length(v_text);
      if v_len > 0 then
        dbms_lob.writeappend(v_desc, v_len, v_text);
      end if;

      v_county := c_rec.county;
      if v_county = 'ST. LUCIE' then v_county := 'SAINT LUCIE'; end if;
      if v_county = 'ST. JOHNS' then v_county := 'SAINT JOHNS'; end if;

      v_text := get_realestate_text(v_county, 'table');
      v_len := length(v_text);
      if v_len > 0 then
        dbms_lob.writeappend(v_desc, v_len, v_text);
      end if;

      v_text := get_realestate_text(v_county, 'text');
      v_text := v_text||get_google_ad;
      v_len := length(v_text);
      if v_len > 0 then
        dbms_lob.writeappend(v_desc, v_len, v_text);
      end if;

      
      update rnt_cities
      set description = v_cdesc
      ,   report_data = v_desc
      where name = 'ANY'
      and state = 'FL'
      and county = v_county;
      commit;
      
      dbms_lob.close(v_desc);
    end loop;
  end gen_county_text;


begin
  gen_county_text;
end;
/
