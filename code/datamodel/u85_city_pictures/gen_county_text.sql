set define ^
declare
  type cou_list_type is table of number;
  type text_list_type is table of varchar2(32767) index by pls_integer;
  
  function get_static_text(p_cou in number)  return varchar2 is
    v_text    text_list_type;
  begin
    -- Alachua County - 12001
    v_text(12001) := '<p>Alachua County is located in North Central Florida, along with Madison, Hamilton, Taylor, Suwannee, Union, Bradford, Lafayette, Dixie, Levy, Gilchrist, Marion, and Columbia counties. Alachua County is home to the University of Florida, and a lot of the county''s economy revolves around this. Top industries providing employment are government; education & health services; trade, transportation, & utilities; and leisure & hospitality.</p>
    <p>Major private sector employers for Alachua County are Shands Hospital, Publix, North Florida Regional Medical Center, Nationwide Insurance, and Wal-Mart Distribution Center. Top private sector employers are University of Florida, Veteran Affairs Medical Center, Alachua County School Board, City of Gainesville, Alachua County, and Santa Fe Community College. Cities in Alachua County are Alachua, Archer, Gainesville, Hawthorne, High Springs, Newberry, and Waldo.</p>';
    -- Baker County - 12003
    v_text(12003) := '<p>Baker County is part of the Northeast Florida region, along with Clay, Duval, Nassau, Putnam, St John''s, and Flagler counties. Baker County is a primarily rural area. Its largest industries by employment are trade, transportation & utility; public administration; and construction. Major private sector employers for Baker County include Wal-Mart Distribution Center, Ed Fraser Memorial Hospital & Healthcare, Ray''s Nursery, Macclenny Nursing & Rehab Center, and Earthworks of Northeast Florida, Inc. Top public sector employers are Northeast Florida State Hospital, Baker County School Board, Baker Correctional Institute, and Baker County Board of Commissioners. Towns and cities in Baker County include Glen St. Mary, Macclenny, and Sanderson.</p>';
    -- Bay County - 12005
    v_text(12005) := '<p>Bay County is part of the Northwest Florida region, along with Santa Rosa, Escambia, Walton, Holmes, Jackson, Washington, Okaloosa, Calhoun, Liberty, Gulf, Franklin, Gadsden, Leon, Jefferson, and Wakulla counties. The largest industries by employment for Bay County are educational, health and social services; retail trade, and arts, entertainment, recreation, accommodation and food services. Bay County''s white sand beaches and clear blue waters attract many visitors year round.</p>
    <p>Top private sector employers in Bay County are Bay Medical center, Wal-Mart, Eastern Ship Building, Gulf Coast Medical Center, and Smurfit- Stone Container Corporation. Major public sector employers are Tyndall Air Force Base, Naval Support, Bay District schools, Gulf Coast State College, City of Panama City, Bay County Board, and Bay County Sheriff. Cities and towns in Bay County include Callaway, Lynn Haven, Mexico Beach, Panama City (county seat), Panama City Beach, Parker, and Springfield.</p>';
    -- Bradford County - 12007
    v_text(12007) := '<p>Bradford County is located in North Central Florida, along with Madison, Hamilton, Taylor, Suwannee, Union, Marion, Lafayette, Dixie, Levy, Gilchrist, Alachua, and Columbia counties. The largest industries in Bradford County by employment are trade & transportation, education & health services, and leisure & hospitality. The top 5 growing industries are transportation & warehousing, waste management, wholesale trade, scientific & technical services, and construction.</p>
    <p>Major private sector employers are Du Pont Titanium Technologies, Wal-Mart Supercenter, Shands Starke, Bradford terrace LLC, and Davis Express Inc. The largest public sector employers include Bradford County School Board and Bradford County Government. Incorporated cities and towns are Brooker, Hampton, Lawtey, and Starke. Florida State Prison is located in Bradford County.</p>';
    -- Brevard County - 12009
    v_text(12009) := '<p>Brevard County in located in the East Central Florida region, along with Orange, Volusia, Sumter, Seminole, Lake, and Osceola counties. Top industries for Brevard County include technology, tourism, agriculture, and other service businesses. The Kennedy Space Center is located in Brevard County and provides many jobs for the area as well as acts as a popular tourist destination. Other tourist attractions in Brevard County include Port Canaveral, one of the busiest cruise ports in the world, and Cocoa Beach.</p>
    <p>In 2010 and 2011, the Brookings Institution reported that Brevard ranked in the bottom fifth of the nation''s top metro areas, based on unemployment, gross metropolitan product, housing prices and foreclosed properties.  In 2011, the county was rated the 6th worst in the nation for foreclosures. Top public sector employers for Brevard County are Brevard County School Board, Brevard County Board of County Commissioners, NASA, and US Department of Defense. Private sector employers include Harris Corporation, Health First, Inc, United Space Alliance, Wuesthoff Health System, and Northrop Grumman Corporation.</p>';
    -- Broward County - 12011
    v_text(12011) := '<p>Broward County is part of the southwest Florida region along with Indian River, St. Lucie, Martin, Palm Beach, Broward, and Monroe counties. Broward County identified these industries as focuses for its expansion efforts: advanced materials and High-Tech Manufacturing, aviation/aerospace, international trade, marine industries, and headquarters and management operations.</p>
    <p> Broward County has 29 recognized cities and towns, the largest being Fort Lauderdale, Pembroke Pines, and Hollywood.  95% of the properties in Broward County are residential, implying that it is a largely suburban area. Broward County is centrally located between major metropolitan areas in Miami-Dade and Palm Beach Counties. The unemployment rate in Broward County, at 5.7%, is lower than Miami-Dade (10.2%), Palm Beach (6.9%), and the state (7.2%).</p>
    <p> Major private sector employers are American Express, Nova Southeastern University, PRC, Kaplan Higher Education, and The Answer Group. Top public employers are Broward County School District, Broward County Government, North Broward Hospital District, Memorial Healthcare System, and the City of Fort Lauderdale.</p>';
    -- Calhoun County - 12013
    v_text(12013) := '<p>Calhoun County is part of the Northwest region of Florida, along with Escambia, Okaloosa, Walton, Holmes, Jackson, Washington, Bay, Santa Rosa, Liberty, Gulf, Franklin, Gadsden, Leon, Jefferson, and Wakulla counties. The largest industries in Calhoun County are manufacturing, distribution, and business. The major private sector employers in Calhoun County are Shelton''s Trucking Service, Parthenon, Blounstown Health & Rehab, Olglesby Plants International, and Calhoun Liberty Hospital. The largest public sector employer is the Calhoun School District. The cities in Calhoun County are Altha and Blountstown, with Blountstown acting as the county seat.</p>';
    -- Charlotte County - 12015
    v_text(12015) := '<p>Charlotte County is located in the southwest region of Florida, along with Lee and Collier County. The top industries providing employment are educational, health and social services; retail trade; arts, entertainment, recreation, accommodation and food services; and construction. Targeted industries for Charlotte County are manufacturing, communications & production of communications equipment, back office operations, marine and related industries, aircraft and avionics related industries, aquaculture and related support industries, and green technology industries.</p>
    <p> Major private sector employers in Charlotte County include Wal-Mart, Peace River Regional Medical Center, Charlotte Regional Medical Center, Publix Supermarkets, and Fawcett Memorial Hospital Inc. Top public sector employers are Charlotte County School Board, Board of County Commissioners, Charlotte County Sheriff''s Office, and Charlotte Correctional Institute. Cities and towns in Charlotte County include Port Charlotte, Grove City, Rotonda, Cleveland, Punta Gorda, South Punta Gorda Heights, and Pirate Harbor.</p>';
    -- Citrus County - 12017
    v_text(12017) := '<p>Citrus County is located in the Tampa Bay region of Florida, along with Sarasota, Manatee, Polk, Hillsborough, Pinellas, Pasco, and Hernando counties. Main industries in Citrus County include educational, health, and social services; retail trade; construction; and arts, entertainment, recreation, accommodation and food services. Citrus County is home to Crystal River and Homosassa Springs and is the only place in the United States where you can legally swim and interact with manatees.</p>
    <p> Citrus County''s top five major employers are Citrus County School Board, Citrus memorial Hospital, progress Energy, Seven Rivers Community Hospital, and Citrus County Sheriff''s Department. More than 80% of the businesses in Citrus County are small businesses.</p>';
    -- Clay County - 12019
    v_text(12019) := '<p>Clay County is part of the Northeast Florida region, along with Baker, Duval, Nassau, Putnam, St. Johns, and Flagler counties. The largest industries by employment are trade, transportation and utilities; education and health services; and leisure and hospitality.</p>
    <p> Major private sector employers are Orange Park Medical Center, HA Patient Account Services, AT&T, Clay Electric Cooperative, and Challenge Enterprises. Top public sector employers are School District of Clay County, Clay County Sheriff, Municipal Police Departments, and Florida Department of Military Affairs. Clay County contains the following cities and towns: Green Cove Springs, Keystone Heights, Orange Park, and Penney Farms.</p>';
    -- Collier County - 12021
    v_text(12021) := '<p>Collier County is part of the southwest region of Florida, along with Lee and Charlotte counties. Collier County is Florida''s largest county in area. The major employment industries in Collier County are trade, transportation, and utilities; leisure & hospitality; and education and health services. According to the U.S. Department of Housing and Urban Development (HUD), Collier County was one of the communities in the nation most impacted by the foreclosure crisis of 2008, but it is slowly picking back up again.</p>
<p>Major private sector employers for Collier County are Wal-Mart, Marriott, Fifth Third Bank, Naples Grande Resort, and Barron Collier Partnership. Top public sector employers include Collier County Public Schools, Collier County Government, and Collier County Sheriff''s Department. Cities and towns in Collier County include Everglades City, Marco Island, and Naples.</p>';
    -- Columbia County - 12023
    v_text(12023) := '<p>Columbia County is located in North Central Florida, along with Madison, Hamilton, Taylor, Suwannee, Union, Bradford, Lafayette, Dixie, Levy, Gilchrist, Alachua, and Marion counties. The largest industries providing employment for Columbia Count are educational, health, and public services; retail trade; and public administration. Cost of living in Columbia County is relatively low at 83.2 compared the US average of 100. Major private sector employers are VA Medical Center, Sitel, PCS Phosphate- White Springs, TIMCO, and Anderson Columbia Company. Top public sector employers include Columbia County School District and Columbia County. The incorporated cities in Columbia County are Fort White and Lake City.</p>';
    -- DeSoto County - 12027
    v_text(12027) := '<p>Desoto County is located in South Central Florida, along with Hendry, Glades, Highlands, Okeechobee, and Hardee counties. The largest industries providing employment are agriculture, forestry, fishing, hunting, and mining and education, health and social services Major private sector employers for Desoto County are Wal-Mart Distribution Center, Wal-Mart, Desoto Medical Hospital, Peace River Citrus, and Bethel Farms. Top public sector employers are Desoto School District, Desoto County, and Desoto County Sheriff''s Office. Desoto''s only city and county seat is Arcadia.</p>';
    -- Dixie County - 12029
    v_text(12029) := '<p>Dixie County is located in North Central Florida, along with Madison, Hamilton, Taylor, Suwannee, Union, Bradford, Lafayette, Marion, Levy, Gilchrist, Alachua, and Columbia counties. The main industries of Dixie County are building materials and seafood export.  Major private sector employers for Dixie County are Suwannee Lumber Company, Knight''s Products, Cross City Veneer, Anderson Columbia Construction, and Gulf Coast Supply & Manufacturing. The top public sector employers include Dixie County School System, County Government, and Sheriff''s Office. Cities in Dixie County are Cross City (county seat), Horseshoe Beach, Old Town, and Suwannee.</p>';
    -- Duval County - 12031
    v_text(12031) := '<p>Duval County is in the northeastern Florida region along with Baker, Clay, Nassau, Putnam, St. Johns, and Flagler counties. The current largest industries are trade, transportation, and utilities; professional and business services; and education and health services. Target industries for Duval County are advanced manufacturing, aviation and aerospace, finance and insurance services, headquarters, and information technology. Duval County is home to Jacksonville, one of Florida''s largest cities. Jacksonville houses the Naval Air Station Jacksonville, which brings many government jobs to the area. The University of North Florida is also located in Jacksonville. </p>
    <p>Major private sector employers for Duval County are Baptist Health, Blue Cross Blue Shield of Florida, Mayo Clinic, Citi, and CSX. The largest public sector employers are Naval Air Station Jacksonville, Duval County Public Schools, Mayport Naval Station, and the City of Jacksonville.</p> ';
    -- Escambia County - 12033
    v_text(12033) := '<p>Escambia County is part of the Northwest region of Florida, along with Santa Rosa, Okaloosa, Walton, Holmes, Jackson, Washington, Bay, Calhoun, Liberty, Gulf, Franklin, Gadsden, Leon, Jefferson, and Wakulla counties. Escambia County is the western most county in Florida, located in the tip of the panhandle.</p>
    <p> The most significant industries in Escambia County are military and defense, tourism, healthcare, education and construction. Pensacola, the county''s seat, contains many military bases including Pensacola Naval Air Station, Naval Training Center, Eglin Air Force Base, Corry Station Naval, Naval Technical Training Center, and Air Station Whiting Field. Pensacola is also home to the University of West Florida. Top private sector employers for Escambia County are Sacred Heart Health System, Baptist Health Care, Lakeview Center, Gulf Power Company, and Ascend Performance Materials. Major public sector employers include Escambia County Government, Federal Government, Florida State Government, and the University of West Florida.</p>';
    -- Flagler County - 12035
    v_text(12035) := '<p>Flagler County is part of the northeastern region of Florida, along with Baker, Clay, Duval, Nassau, Putnam, and St. Johns counties. The largest industries in Flagler County include construction, educational services, health care/social services, and retail. Target industries include agriculture, aviation/aerospace, green technology, health sciences, high technology, and marine research.</p>
    <p>Major private sector employers for Flagler County include Palm Coast Data, Florida Hospital Flagler, Publix Supermarkets, Hammock Beach Resort, Wal-Mart, and Sea Ray Boats. Top public sector employers are Flagler County School System, City of Palm Coast, Flagler County, and Flagler County Sheriff''s Department. Cities and towns in Flagler County include Bunnell (county seat), Flagler Beach, Palm Coast, Marineland, and Beverly Beach.</p>';
    -- Franklin County - 12037
    v_text(12037) := '<p>Franklin County is located in northwest Florida, along with Escambia, Santa Rosa, Okaloosa, Walton, Holmes, Jackson, Washington, Bay, Calhoun, Liberty, Gulf, Gadsden, Leon, Jefferson, and Wakulla counties. One of Franklin County''s largest industries is seafood, supplying for than 90% of Florida''s Oysters and 10% of the nations. Commercial timber and tourism are also large industries. Franklin County beaches have been ranked some of the most beautiful in the world.</p>
    <p>Top private sector employers for Franklin County are Weems Memorial Hospital, Leavins Seafood, and Greensteel Homes. Major public sector employers are Franklin County and Florida Department of Corrections. Cities, towns, and islands in Franklin County include Apalachicola (county seat), Carrabelle, Cape St. George Island, Dog Island, and St. Vincent.</p>';
    -- Gadsden County - 12039
    v_text(12039) := '<p>Gadsden County is located in northwest Florida, along with Escambia, Santa Rosa, Okaloosa, Walton, Holmes, Jackson, Washington, Bay, Calhoun, Liberty, Franklin, Gulf, Leon, Jefferson, and Wakulla counties. Gadsden County is Florida''s only predominately African American county. Top industries are education, health & social services; public administration; and retail trade.</p>
    <p>Gadsden County''s major private employers are Coastal Plywood Company, Talquin Electric Cooperative, T Formation, TeligentEMS, and Super-Valu. Top public employers include Florida State Hospital School, Department of Children, University of Florida, Gadsden County Supervisors Office, and Florida Department of Corrections- Quincy. Cities and towns in Gadsden County include Chattahoochee, Greensboro, Gretna, Havana, Midway, River Junction, and Quincy.</p>';
    -- Gilchrist County - 12041
    v_text(12041) := '<p>Gilchrist County is located in North Central Florida, along with Madison, Hamilton, Taylor, Suwannee, Union, Bradford, Lafayette, Dixie, Levy, Marion, Alachua, and Columbia counties. The leading industries in Gilchrist County are healthcare, water bottling, dairy, and wood products. Major private sector employers for Gilchrist County are Ayers Health & Rehabilitation, CCDA Waters, Tri-County Health Center, Alliance Dairy, and North Florida Holsteins. Top public sector employers include Gilchrist School District, Gilchrist County Government, and Gilchrist Sheriff''s Office.  Gilchrist County is very rural. There is only one traffic light in the entire county and no roads with more than 1 lane of traffic moving in one direction. Cities in Gilchrist County are Bell and Trenton (county seat).</p>';
    -- Glades County - 12043
    v_text(12043) := '<p>Glades County is located in South Central Florida, along with Hardee, Highlands, Okeechobee, DeSoto, and Hendry counties. The main industries providing employment are educational, health, and social services; agriculture, forestry, fishing, and hunting; public administration; and construction. Major private sector employers in Glades County are Moore Haven Correctional Facility, Lykes bros, Brighton Seminole Bingo, Glades Electric Co-op, and A Duda. The top public sector employer is Glades County School Board. Cost of living in Glades County is relatively low at 83.1, compared the US average of 100. Cities, towns, and regions in Glades County are Buckhead Ridge, Moore Haven (county seat), Lakeport, Palmdale, Brighton Seminole Indian Reservation, and Muse.</p>';
    -- Gulf County - 12045
    v_text(12045) := '<p>Gulf County is located in northwest Florida, along with Escambia, Santa Rosa, Okaloosa, Walton, Holmes, Jackson, Washington, Bay, Calhoun, Liberty, Franklin, Gadsden, Leon, Jefferson, and Wakulla counties. The largest industries are trade, transportation & utility; education & health services; and financial activities. Major private sector employers are GAC Contractors, Bay St. Joseph Care & Rehabilitation Center, Duren''s Piggly Wiggly, Fairpoint Communications, and Raffield Fisheries. The top public sector employers include Florida Department of Corrections, Gulf County School District, and County of Gulf. Cities and towns in Gulf County include Port St. Joe (county seat), Wewahitchka, and White City.</p>';
    -- Hamilton County - 12047
    v_text(12047) := '<p>Hamilton County is located in North Central Florida, along with Madison, Marion, Taylor, Suwannee, Union, Bradford, Lafayette, Dixie, Levy, Gilchrist, Alachua, and Columbia counties. Phosphate mining is a large industry in Hamilton County, employing nearly 1000 of the 14,000 residents. Other leading industries in Hamilton County are public administration, trade & transportations, and professional & business services. Major private sector employers for Hamilton County are PCS Phosphate White Springs, Suwannee Valley Nursing Center, Coggins Farms, Hamilton Jai Alai & Poker, and Taylor Industrial Construction Inc. Top public sector employers include Hamilton County School District, Hamilton County Government, and Hamilton County Sheriff''s Department.</p>';
    -- Hardee County - 12049
    v_text(12049) := '<p>Hardee County is located in South Central Florida, along with Hendry, Glades, Highlands, Okeechobee, and DeSoto counties. The major industries for the Hardee County are citrus, phosphate mining, vegetable farming, and cattle. The population increases during the harvesting season as a result of migratory workers. Major private sector employers are Florida Institute for Neurological Rehabilitation, Wal-Mart, Mosaic, C.F. Industries, and Peace River Electric Cooperative. Top public sector employers include Hardee School District, County Government, and Hardee County Sherriff''s Office. Incorporated cities are Bowling Green, Wauchula (county seat), and Zolfo Springs.</p>';
    -- Hendry County - 12051
    v_text(12051) := '<p>Hendry County is located in South Central Florida, along with Hardee, Highlands, Okeechobee, DeSoto, and Glades counties. The largest industries by employment are trade, transportation, & utilities; public administration; and natural resources and mining. 72.5% of the land in Hendry County is used for agriculture. The number one crop is citrus, followed by sugar cane and fresh vegetables. Major private sector employers include US Sugar Corp, Southern Gardens, A Duda & Sons, Hendry County Hospital Authority, and Alico, Inc. Top public sector employers include Hendry County School District, Hendry County, and Sheriff''s Office. Incorporated cities in Hendry County are Clewiston and LaBelle (county seat).</p>';
    -- Hernando County - 12053
    v_text(12053) := '<p>Hernando County is in the Tampa bay region of Florida, along with Citrus, Hillsborough, Pasco, Pinellas, Polk, Manatee, and Sarasota counties. The major industries in Hernando County are Distribution, Healthcare, Cement Production, Manufacturing, Mining, Tourism, Dairy/Cattle Production, Citrus Production, Forest Resources, and Construction.</p>
    <p>Hernando County is home to the largest (truck-to-truck) Wal-Mart Distribution Center in the U.S, making Wal-Mart the county''s largest employer. Other major employers in Hernando County include Oak Hill Hospital, Spring Hill & Brooksville Regional Hospitals, Sparton Electronics, and Florida Crushed Stone. Public Sector employers are Hernando County School Board, Hernando County Government, and Southwest Florida Water District. Cities and census designated places in Hernando County include Brooksville, Weeki Wachee, Bayport, Brookridge, Spring Hill, and Spring Lakes.</p>';
    -- Highlands County - 12055
    v_text(12055) := '<p>Highlands County is located in the south central Florida region, along with Hardee, Okeechobee, DeSoto, Glades, and Hendry counties. The largest industries providing employment are education & health services, natural resources & mining, trade & transportation, and government. Major private sector employers for Highlands County are Florida Hospital Heartland Division, Highlands Regional Medical Center, Cross Country Automotive Services, Wal-Mart Sebring, and Medical Data Systems. Top public sector employers are Highlands County School Board and Highlands County Board of Commissioners. Incorporated cities and towns include Avon Park, Lake Placid, and Sebring (county seat)</p>';
    -- Hillsborough County - 12057
    v_text(12057) := '<p>Hillsborough County is in the Tampa Bay region of Florida, along with Citrus, Hernando, Pasco, Pinellas, Polk, Manatee, and Sarasota counties. Tampa, one of Florida''s largest cities, is part of Hillsborough County. Busch Gardens, one of Florida''s main theme parks, is in Tampa and attracts many tourists.</p>
    <p> Hillsborough County has the 6th largest school district in the country employing approximately 25,000 people. Other major public employers are MacDill Airforce Base, Hillsborough County Government, University of South Florida, and Hillsborough Community College. The largest private sector employers are JPMorgan Chase, H.Lee Moffitt Cancer Center & Research Institute, Citi, Price water house Coopers, and Progressive Insurance. Target industries are applied medicine & human performance, high-tech electronics and instruments, business, financial & data services, and marine & environmental activities.</p>';
    -- Holmes County - 12059
    v_text(12059) := '<p>Holmes County is part of the Northwest Florida region, along with Santa Rosa, Escambia, Walton, Okaloosa, Jackson, Washington, Bay, Calhoun, Liberty, Gulf, Franklin, Gadsden, Leon, Jefferson, and Wakulla counties. The largest industries by employment are public administration; trade, transportation & utility; and construction.</p>
    <p>Major private sector employers for Holmes County are Bonifay Nursing & Rehab, Piggly Wiggly, LKQ, Bonifay IGA, Jerkin''s Inc. and Arban. Major public sector employers are Florida Department of Corrections, Holmes County School Board, and County of Holmes. Cities and towns in Holmes County include Bonifay (county seat), Esto, Noma, Ponce de Leon, and Westville.</p>';
    -- Indian River County - 12061
    v_text(12061) := '<p>Indian River County is part of the southwest region of Florida, along with St. Lucie, Miami-Dade, Palm Beach, Broward, Martin, and Monroe counties. As with most counties along the treasure coast, tourism is a major industry.  Agriculture also plays a large part in Indian River County''s economy. Resources produced here include citrus, beef, and honey. Because so much of the economy revolves around agriculture, unemployment is often high in summer months.</p>
    <p> Indian River County has targeted clean energy, information technology, aviation/aerospace, and financial/professional services as its industries for expansion. Cities in Indian River County are Vero Beach (county seat), Sebastian, Fellsmere, Indian River Shores, and Orchid. Major public sector employers are Indian River Medical Center, Publix Supermarkets, Piper Aircraft Inc, Sebastian River Medical Center, and John''s Island. Public sector employers are School District of Indian River County Indian River, Indian River County, City of Vero Beach, and City of Sebastian.</p>';
    -- Jackson County - 12063
    v_text(12063) := '<p>Jackson County is part of the Northwest Florida region, along with Santa Rosa, Escambia, Walton, Holmes, Okaloosa, Washington, Bay, Calhoun, Liberty, Gulf, Franklin, Gadsden, Leon, Jefferson, and Wakulla counties.  Top industries for Jackson County include government, trade & transportation, education and health services, and agriculture & natural resources.</p>
    <p>Jackson County is Florida''s top producer of soybeans and peanuts and contains a large distribution center. Major private sector employers for Jackson County are Family Dollar Distribution Center, Wal-Mart, Rex Lumber Company, Anderson Columbia, Inc, and Mowery Elevator Company, Inc. The largest public sector employers are Florida Department of Corrections–Sneads, Bureau of prisons, Florida Department of Corrections –Malone, Jackson County, and City of Marianna. Cities and towns in Jackson County include Alford, Bascom, Campbellton, Cottondale, Graceville, Grand Ridge, Greenwood, Jacob City, Malone, Marianna (county seat), and Sneads.</p>';
    -- Jefferson County - 12065
    v_text(12065) := '<p>Jefferson County is located in northwest Florida, along with Escambia, Santa Rosa, Okaloosa, Walton, Holmes, Jackson, Washington, Bay, Calhoun, Liberty, Franklin, Gadsden, Leon, Gulf, and Wakulla counties. Jefferson County is Florida''s only county that borders both Georgia and the Gulf of Mexico.  The largest industries by employment are trade, transportation, and utility; public administration; and construction.</p>
    <p>Major public sector employers are Brynwood Center, Simpson Nurseries, Crosslandings Health & Rehab Center, Jefferson County Kennel Club, and Farmers & Merchants Bank. Top public sector employers are Jefferson County School District, Florida Department of Corrections, and Jefferson County. Jefferson County''s county seat is Monticello.</p>';
    -- Lafayette County - 12067
    v_text(12067) := '<p>Lafayette County is located in North Central Florida, along with Madison, Hamilton, Taylor, Suwannee, Union, Bradford, Marion, Dixie, Levy, Gilchrist, Alachua, and Columbia counties. Most of Lafayette County''s 548 square miles in dedicated to timber and farmland. The leading industries in Lafayette County are corrections, agriculture, and healthcare. Major private sector employers are Mayo Correctional Institute, Lafayette Healthcare Nursing Home, Putnal''s Pinestraw, Bass Assassin Worms, and Townsend Pinestraw. Top public sector employers are Lafayette County School District, Lafayette County Government, and Lafayette County Sheriff''s Office.  Mayo is the county''s only incorporated city and also the county seat.</p>';
    -- Lake County - 12069
    v_text(12069) := '<p>Lake County is located in the east central Florida region, along with Brevard, Orange, Osceola, Volusia, Sumter, and Seminole counties. Top industries in Lake County are retail, healthcare, construction, and food services. Major private sector employers for Lake County are Leesburg Regional Medical Center, Wal-Mart, Villages of Lake Sumter Inc, Florida Hospital-Waterman, and Publix Supermarkets. Top public sector employers are Lake County Public Schools, Lake County Government, and Lake County Sherriff''s Department. Cities of Lake County include Astatula, Clermont, Eustis, Fruitland Park, Groveland, Lady Lake, Leesburg, Mascotte, Minneola, Montverde, Mount Dora, Taveres, and Umatilla. Lake County has approximately 1,400 named lakes.</p>';
    -- Lee County - 12071
    v_text(12071) := '<p>Lee County is located in the southwest Florida region, along with Collier and Charlotte counties. Top industries currently providing employment are trade, transportation, and utilities; leisure and hospitality; education and health services; and professional and business services. Historically, Lee County was best known for its agricultural industry and still heavily produces crops such as sweet corn, cucumbers, peppers and potatoes. Seafood is also largely produced in Lee County.</p>
    <p>Annually, over five million pounds of fish and two million pounds of shellfish are harvested in Lee County. However, today the most dominant industries are tourism, construction, and other service related industries. Florida Gulf Coast University, Florida''s newest public university, is also located in Lee County. Major private sector employers in Lee County are Publix Supermarkets, Wal-Mart, Chico''s FAS Inc, Bonita Bay Group, and WCI Group. Top public sector employers are Lee County School District, Lee County Administration, Lee County Sheriff''s Office, and City of Cape Coral. The communities in the Southwest Florida area include: Bonita Springs, Cape Coral, Fort Myers, Fort Myers Beach, Lehigh Acres, North Fort Myers, San Carlos Park, Sanibel/Captiva, and South Fort Myers. Incorporated communities are Cape Coral, Fort Myers, Fort Myers Beach, Bonita Springs, and Sanibel.</p>';
    -- Leon County - 12073
    v_text(12073) := '<p>Leon County is part of the northwest region of Florida, along with Escambia, Santa Rosa, Okaloosa, Walton, Holmes, Jackson, Washington, Bay, Calhoun, Liberty, Gulf, Franklin, Gadsden, Jefferson, and Wakulla Counties. Main industries for this area include advanced manufacturing, aviation, aerospace, defense, health sciences, renewable energy, and transportation. Florida''s capital, Tallahassee, is a part of Leon County, and also acts as the county seat.</p>
    <p>Two of Florida''s main Universities, Florida State University and Florida A&M University, are also a part of Leon County. As a result, Leon County has the highest average level of education among Florida''s 67 counties. Leon County''s regional economy remained stable throughout the recession as a result of a significant public sector presence. The unemployment rate has decreased and is below the state average at 8.1%. The housing market has not been as negatively affected in this county as in the rest of the state; the tax base loss is moderate and foreclosure rates equal the national average. The largest private sector employers are Tallahassee Memorial healthcare, Publix Supermarkets, Walmart, Capital Regional medical Center, and ACS. Top public employers are the State of Florida, Florida State University, Leon County Schools, City of Tallahassee, and Florida A&M University.</p>';
    -- Levy County - 12075
    v_text(12075) := '<p>Levy County is located in North Central Florida, along with Madison, Hamilton, Taylor, Suwannee, Union, Bradford, Lafayette, Dixie, Marion, Gilchrist, Alachua, and Columbia counties. Levy County is unique in that its area contains both hardwood forests and Gulf Coast beaches. Nature based tourism is a big industry in Levy County. Other leading industries include trade & transportation, agriculture, and construction. Major private sector employers are Wal-Mart, D.A.B. Contructors, Monterey Boats, Williston Health Care Center Inc, Central Florida Electric Co-Op, and Williston Holding Company. The top public sector employer is Levy County School Board. Cities in Levy County are Bronson, Cedar Key, Chiefland, Inglis, Morriston, Otter Creek, Williston, and Yankeetown.</p>';
    -- Liberty County - 12077
    v_text(12077) := '<p>Liberty County is located in northwest Florida, along with Escambia, Santa Rosa, Okaloosa, Walton, Holmes, Jackson, Washington, Bay, Calhoun, Gulf, Franklin, Gadsden, Leon, Jefferson, and Wakulla counties. Liberty County is Florida''s least populous county and The Apalachicola National Forest occupies half the county. Its main industries by employment are public administration; education, health, & social services; and construction. Liberty County is also known for its timber industry. The major private sector employers are Twin Oaks Juvenile Development, C.W. Roberts Contracting, Inc, Georgia Pacific, North Florida Lumber, Inc, and Apalachee Pole. Top public sector employers are Liberty County and Liberty County School District. Incorporated and unincorporated areas in Liberty County include Bristol (county seat), White Springs, Rock Bluff, Hosford, Orange, Wilma, and Telogia.</p>';
    -- Madison County - 12079
    v_text(12079) := '<p>Madison County is located in North Central Florida, along with Marion, Hamilton, Taylor, Suwannee, Union, Bradford, Lafayette, Dixie, Levy, Gilchrist, Alachua, and Columbia counties. The largest industries by employment in Madison County are education & health services; trade, transportation, & utilities; and public administration. Major private sector employers are Madison Correctional Facility, Nestle Waters North America, Johnson & Johnson, Lake Park of Madison Nursing Home, and Madison County Memorial Hospital. Top public sector employers are Madison County School District, Madison Correctional Facility, and Madison County Government. Madison County cities are Greenville, Lee, Madison (county seat), and Pinetta.</p>';
    -- Manatee County - 12081
    v_text(12081) := '<p>Manatee County is part of the Tampa Bay region of Florida, along with Sarasota, Polk, Hillsborough, Pinellas, Pasco, Hernando, and Citrus counties. Major industries include retail trade, agriculture, tourism, and retirement. Other important parts of the manatee county economy are manufacturing, agribusiness, and fishing. Port Manatee and the Sarasota Bradenton International Airport help connect Manatee County businesses to the world. The cost of living in Manatee County is slightly higher than the rest of the state.</p>
    <p>Manatee County''s largest private sector employers are Bealls Inc, Manatee Memorial Hospital, Tropicana products, Inc, and Publix. Major Public sector employers are Manatee County School District, Manatee County Government, and Manatee County Sheriffs Department. Bealls of Florida is headquartered in Manatee County. Incorporated cities and towns are Anna Maria, Bradenton (county seat), Bradenton beach, Holmes Beach, Longboat Key, and Palmetto.</p>';
    -- Marion County - 12083
    v_text(12083) := '<p>Marion County is located in North Central Florida, along with Madison, Hamilton, Taylor, Suwannee, Union, Bradford, Lafayette, Dixie, Levy, Gilchrist, Alachua, and Columbia counties. The largest industries providing employment in Marion County are agriculture, educational, health, and social services; retail trade; and manufacturing. Marion County is often considered the horse capital of the world. Marion County contains nearly 50,000 horses during peak season. It is also the 12th largest cattle producer in the state. Other crops produced here include peanuts, citrus, and hay.</p>
    <p>Major private sector employers are Munroe Regional Medical Center, Ocala Regional Medical Center & West Marion Community Hospital, AT&T, Lockheed Martin, and E-ONE Inc. top public sector employers include Marion County Public Schools, Florida State Government, Federal Government, Marion County BCC, and City of Ocala. Cities in Marion County are Anthony, belleview, Citra, Dunnellon, Eastlake Weir, Fort McCoy, McIntosh, Ocala, Ocklawaha, Reddick, Silver Springs, Summerfield, and Weirsdale.</p>';
    -- Martin County - 12085
    v_text(12085) := '<p>Martin County is part of the southwest region of Florida, along with Indian River, St. Lucie, Miami-Dade, Palm Beach, Broward, and Monroe counties. County targeted industries include aviation and aerospace, environmental/green technologies, marine industries, and head quarters.  Martin cities are Hobe Sound, Indiantown, Jensen Beach, Palm City, and Stuart. Top public sector employers are Martin County School District, Martin County, State Government, City of Stuart, and Indian River State College. Private employers are Martin Memorial Healthcare Systems, Publix Supermarkets, Old Cell Phone, TurboCombustor Technologies Inc, and Florida Power and Light.</p>';
    -- Miami-Dade County - 12086
    v_text(12086) := '<p>Miami Dade County is part of the southwest Florida region along with Indian River, St. Lucie, Martin, Palm Beach, Broward, and Monroe counties. Major industries for this county are tourism, international trade, international banking, and transportation. The county''s seat and largest city is Miami.  Miami''s close proximity to Latin America and the Caribbean makes it the center for international trade with those areas. The Port of Miami acts as one of the largest cruise spots in the world.</p>
    <p>Miami Dade County has 35 cities and incorporates many different geographical areas. The north, central, and east regions are heavily urbanized, with many large skyscrapers and a dense population. The southern region of Miami Dade County is sparsely populated and is the heart of Miami-Dade''s agricultural economy. The western region of the county includes the Everglades National Park and is inhabited only by a tribal village.</p>
    <p> Miami-Dade County is home to numerous large universities including the University of Miami, Florida International University, and Barry University. Top public employers are Miami-Dade County Public Schools, Miami-Dade County, the Federal Government, Florida State Government, and Jackson Health Systems. Major private employers include the University of Miami, Baptist Health South Florida, Publix Supermarkets, American Airlines, and Precision Response Corporation.</p>';
    -- Monroe County - 12087
    v_text(12087) := '<p>Monroe County is part of the southwest Florida region along with Indian River, St. Lucie, Miami-Dade, Martin, Palm Beach, and Broward. Monroe County is the southernmost county in Florida and the continental United States. Monroe County incorporates the Florida Keys, parts of the Everglades, and Big Cyprus National Preserve, with Key West as the county seat. Other cities are Marathon, Key Colony Beach, and Layton. 22% of the properties in Monroe County are government owned.</p>
    <p>The largest industry in Monroe County is tourism. In 2010, The Keys alone had 3.8 million visitors. Major private sector employers are Kmart, HMA, Baptist Mariner''s Hospital, HTA, and Hawks Cay Resort. Public employers are US Armed Forces, Monroe County Schools, Monroe County Government, and Florida Keys Community College.</p>';
    -- Nassau County - 12089
    v_text(12089) := '<p>Nassau County is in the northeastern region of Florida, along with Baker, Clay, Duval, Putnam, St. Johns, and Flagler counties. The largest industries in Nassau County are trade, transportation and utilities; leisure and hospitality; and education and health services. Nassau County has a diverse economy, with a lot of agriculture activity, mostly tree farms, in the west and a variety of activities near Amelia Island. Amelia Island acts as a popular tourist destination and contains two upscale hotels. High profile people such as Bill Clinton have vacationed here. Major private sector employers include Amelia Island Plantation, Ritz Carlton, Smurfit- Stone, Wal-Mart, and Baptist Medical Center- Nassau. Top private sector employers are Nassau County School board, Nassau County Government, Federal Aviation Administration, and City of Fernandina Beach.</p>';
    -- Okaloosa County - 12091
    v_text(12091) := '<p>Okaloosa County is part of the Northwest Florida region, along with Santa Rosa, Escambia, Walton, Holmes, Jackson, Washington, Bay, Calhoun, Liberty, Gulf, Franklin, Gadsden, Leon, Jefferson, and Wakulla counties. Top industries in Okaloosa County are government, profession & business services, trade & transportation, leisure and hospitality, and education & health services. Several air force and army facilities are located in Okaloosa County, including Eglin Air Force Base, Hurlburt Field, and Duke Field. By size, Eglin is the largest Air Force base in the country and is responsible for the development, acquisition, testing, and deployment of all air-delivered weapons. Okaloosa county''s white sand beaches also attract many tourists to the area. Top private sector employers are Fort Walton beach Medical Center, L-3 Communications/Crestview Aerospace, DRS Training & Control Systems, InDyne Inc, and ResortQuest. Major public sector employers are US Department of Defense-Eglin AFB, Okaloosa School District, and County of Okaloosa-Sheriff''s Department.</p>';    
    -- Okeechobee County - 12093
    v_text(12093) := '<p>Okeechobee County is located in South Central Florida, along with Hardee, Highlands, Glades, DeSoto, and Hendry counties. The leading industries in Okeechobee, Florida are educational, health and social services; Retail trade; and Arts, entertainment, recreation, accommodation and food services. Major private sector employers include Columbia Raulerson Hospital, Walpole Inc, Larson Dairy Inc, McArthur Farms Inc, and Okeechobee Healthcare. The top public sector employers are Okeechobee School District, Okeechobee Sheriff''s Office, and Okeechobee County. Okeechobee County''s only city is Okeechobee and this is also the county seat. The second largest freshwater lake in the US, Lake Okeechobee, is located in Okeechobee County.</p>';
    -- Orange County - 12095
    v_text(12095) := '<p>Orange County is part of the East Central Florida region along with Brevard, Osceola, Lake, Sumter, Seminole, and Volusia. Orlando is Orange County''s largest city and is home to many of the country''s most popular theme parks, making tourism the county''s main industry. Other main industries for Orange County are life sciences & health care resources; modeling, simulation & training resources; optics & photonics resources; and clean technology.</p>
    <p>Orange County is also home to the University of Central Florida, which is the second largest public university in the country at approximately 60,000 students. Orange County''s largest private sector employers are Walt Disney World, Adventist Health Systems, Universal Orlando, Orlando Health, and Busch Entertainment Corp. Top public sector employers are Orange County Public Schools, Greater Orlando Aviation Authority, Orange County Government, and The University of Central Florida.</p>';
    -- Osceola County - 12097
    v_text(12097) := '<p>Osceola County is located in East Central Florida, along with Brevard, Orange, Seminole, Lake, Volusia, and Sumter counties. Osceola County''s close proximity to Disney World makes tourism a major industry. Other industries in the area are arts, entertainment, recreation, accommodation and food services; retail trade; and educational, health, and social services.</p>
    <p>Major private sector employers are Walt Disney Company, Wal-Mart, Florida Hospital–Kissimmee & Celebration, Osceola Regional Medical Center, and Gaylord Palms Resort & Convention Center. Osceola County''s largest public sector employers are Osceola School District and Osceola County Government. The cost of living index in Osceola County in 2012 was 87.1, significantly less than the US average of 100. Osceola County has the following incorporated areas/cities: Buenaventura Lakes, Celebration, Poinciana, Campbell, Kissimmee, Saint Cloud, Poinciana Place, and Yeehaw Junction.</p>';
    -- Palm Beach County - 12099
    v_text(12099) := '<p>Palm Beach County is part of the southwest Florida region along with Indian River, St. Lucie, Martin, Miami-Dade, Broward, and Monroe counties. Palm Beach County has 38 cities, towns and villages in total. West Palm Beach is the county''s largest city and acts as the county seat.</p>
    <p>Palm Beach County considers agribusiness; aviation, aerospace, and engineering; equestrian; healthcare; green energy; and corporate headquarters to be among its main industries.</p>
    <p>Palm Beach County has many wealthy towns such as Palm Beach, Boca Raton, and Jupiter, as well as a large equestrian population making it one of Florida''s wealthiest counties. As a result, real estate prices are comparatively higher in Palm beach County than most other counties in Florida. Palm Beach County''s major private sector employers are Tenet Healthcare Corporation, Hospital Corporation of America, Florida Power& Light, The Breakers, and Office Depot. Top Public sector employers are Palm Beach County School Board, Palm Beach County, Florida Power and Light, Florida Atlantic University, and Boca Raton Community Hospital.</p>';
    -- Pasco County - 12101
    v_text(12101) := '<p>Pasco County is part of the Tampa Bay region of Florida, along with Citrus, Hernando, Hillsborough, Pinellas, Polk, Manatee, and Sarasota counties. Pasco County lists agri-business, logistics, defense, and medical/biomedical/life sciences as its targeted industries. Pasco County''s largest public sector employers are Pasco County School District, Pasco County Government, Pasco County Sheriff, State of Florida, and the Federal Government. Main private sector employers are Pall Aeropower Corporation; Zephyrhills Spring Water Co; VLOC, Subsidiary of II-VI, Inc; Zephy Egg LLC, and Preferred Materials, Inc. Pasco County cities include Aripeka, Bayonet Point, Crystal Springs, Dade City (County Seat), Elfers, Gulf Harbors, Holiday, Hudson, Lacoochee, New Port Richey, Odessa, Port Richey, San Antonio, Trinity, and Zephyrhills.</p>';
    -- Pinellas County - 12103
    v_text(12103) := '<p>Pinellas County is part of the Tampa Bay region of Florida, along with Citrus, Hernando, Pasco, Hillsborough, Polk, Manatee, and Sarasota counties.  Pinellas County''s largest industries are tourism, retail and whole sale trade, and finance, insurance and real estate. Around 5 million people visit Pinellas County annually. Pinellas County''s main tourist attraction is its beaches along the gulf coast. Pinellas County also attracts a lot of retires, with one in five of its residents over the age of sixty five. </p>
    <p>Major private sector employers include Home Shopping Network, Fidelity Information Svc, Nielson Media Research, Raymond James Financial, and Tech Data Corp. Public employers are Pinellas County School District, Pinellas County Government, City of St. Petersburg, and Pinellas County Sherriff''s Office.</p>';
    -- Polk County - 12105
    v_text(12105) := '<p>Polk County is part of the Tampa Bay region of Florida along with Citrus, Hernando, Pasco, Pinellas, Hillsborough, Manatee, and Sarasota counties. Polk County is between the two large metropolitan areas of Tampa and Orlando, which accounts for its rapid population growth rate. Despite the positive growth, unemployment rates are historically lower in Polk County than anywhere else in the state. </p>
    <p>Polk County''s economy revolves around the industries of phosphate mining, agriculture, and tourism. The building of LEGOLAND Florida in Winter Haven has increased tourism and boosted the economy. Of all Florida counties, Polk has the 2nd most farmland in the state. Major private sector employers are Publix Supermarkets, Wal-Mart, Lakeland Regional Medical Center, Winter haven Hospital, and GEICO. The largest public sector employers are Polk County School Board, Polk County Government, Florida State Government, and City of Lakeland.</p>';
    -- Putnam County - 12107
    v_text(12107) := '<p>Putnam County is part of the northeastern region of Florida, along with Baker, Clay, Duval, Nassau, St. John''s, and Flagler counties. Putnam County is an industrial rural community. The top industries by employment for Putnam County are government; trade, transportation & utilities; education & health services; and manufacturing.  Putnam County''s major private sector employers are Georgia Pacific, Putnam Community center, Wal-Mart, Precision Response Corporation, and Seminole Electric Corporation. Top public sector employers are Putnam County School District, St. Johns River Water Management District, and Putnam County.  Cities and towns in Putnam County include Crescent City, Interlachen, Palatka (county seat), Pomona Park, and Welaka.</p>';
    -- St. Johns County - 12109
    v_text(12109) := '<p>St. John''s County is part of the northeastern region of Florida, along with Baker, Clay, Duval, Nassau, Putnam, and Flagler counties. Top industries for St. John''s County are retail trade; professional, scientific & technical services; accommodation & food services; and healthcare & social assistance. St. John''s County is home to St. Augustine, recognized as the nation''s oldest city. St. Augustine is also the county seat. St. John''s County is also recognized as having Florida''s best public school system and lowest overall tax structure in northeast Florida. Top private sector employers for Duval County are Flagler Hospital, Northrop Grumman, PGA Tour Inc, Ponte Vedra Inn & Club, and Ring Power. The largest public sector employers are St. Johns County School District, St. Johns County, US Army National Guard, Florida School for the Deaf and Blind, and Community Hospice of NE Florida.</p>';
    -- St. Lucie County - 12111
    v_text(12111) := '<p>St. Lucie County is part of the southwest Florida region along with Indian River, Miami-Dade, Martin, Palm Beach, Broward, and Monroe counties. St. Lucie County lists manufacturing facilities, clean energy, professional and technical services, information industries, administrative and support services, and finance and insurance services among its target industries. Incorporated areas for St. Lucie County are Fort Pierce (county seat), Port St. Lucie, Lakewood Park, Indian River Estates, River Park, and White City. Cost of living in this area is 99.06, compared with Florida''s 100.</p>
    <p> Top private employers for St. Lucie County are Wal-Mart, Liberty Medical Supply, QVC, Publix Supermarkets, and Lawnwood regional Medical Center. Major public sector employers include St. Lucie School Board, Indian River Community College, City of Port St. Lucie, St. Lucie Board of County Commissioners, and FPL Group, Inc.</p> ';
    -- Santa Rosa County - 12113
    v_text(12113) := '<p>Santa Rosa County is part of the Northwest region of Florida, along with Escambia, Okaloosa, Walton, Holmes, Jackson, Washington, Bay, Calhoun, Liberty, Gulf, Franklin, Gadsden, Leon, Jefferson, and Wakulla counties. The largest industries by employment are trade, transportation & utilities; leisure & hospitality; education & health services; and professional & business services.</p>
    <p> Top private sector employers for Santa Rosa County are Wal-Mart, Baptist Health Care, Clearwire, Mediacom, and Santa Rosa Medical Center. Major public sector employers are Santa Rosa County School District, US Government, Florida State Government, and Santa Rosa County. Cities and towns in Santa Rosa County include Gulf Breeze, Jay, and Milton.</p>';
    -- Sarasota County - 12115
    v_text(12115) := '<p>Sarasota County is part of the Tampa Bay Region along with Manatee, Polk, Hillsborough, Pinellas, Pasco, Hernando, and Citrus counties.  Top industries are education and health services, leisure and hospitality, retail trade, and professional and business services. Targeted sectors are clean technology/green business, film/entertainment, life sciences, light manufacturing, and sports/ ecotourism.</p>
    <p>Sarasota County has 3 higher education facilities: New College of Florida, University of South Florida Sarasota- Manatee, and Ringling College of Art and Design. Public sector employers for Sarasota County include School Board of Sarasota County, Sarasota County Government, and Sarasota Memorial Hospital. Main private employers are PGT Industries, Sun Hydraulics Corporation, Tervis, FCCI Insurance, and protocol Communications. Sarasota County consists of the cities of Sarasota, Venice, and North Port, and the Town of Longboat Key.</p>';
    -- Seminole County - 12117
    v_text(12117) := '<p>Seminole County is located in the East Central Florida region, along with Brevard, Osceola, Orange, Lake, Volusia, and Sumter County. Seminole County''s major industries include agri-technology, aviation & aerospace, clean technology, and information technology. </p>
    <p>Top public sector employers in Seminole County are Seminole County Public Schools, Seminole State College of Florida, Seminole County Government, and Seminole County Sherriff Department. The largest private sector employers are Convergys, Florida Hospital, Chase Bankcard Services, Orlando Regional healthcare, and American Automobile Association. AAA (American Automobile Association) is headquartered in Seminole County. Cities in Seminole county include Altamonte Springs, Casselberry, Lake Mary, Longwood, Oviedo, Sanford, and Winter Springs.</p> ';
    -- Sumter County - 12119
    v_text(12119) := '<p>Sumter County is located in East Central Florida, along with Brevard, Osceola, Orange, Seminole, Lake, and Volusia counties. The largest industries in Sumter County by employment are leisure & hospitality, trade & transportation, education & health services, and public administration.</p>
    <p>Sumter County major private employers are The Villages, T&D Concrete, Villages Regional Medical Center, Wal-Mart, and Sumter Electric Cooperative. Major public employers include Coleman Federal Prison, Sumter District Schools, Sumter Correctional Institute, Sumter County Government, and Lake Sumter Community College. Cities in Sumter County include Bushnell, Center Hill, Coleman, Webster, and Wildwood.</p>';
    -- Suwannee County - 12121
    v_text(12121) := '<p>Suwannee County is located in North Central Florida, along with Madison, Hamilton, Taylor, Marion, Union, Bradford, Lafayette, Dixie, Levy, Gilchrist, Alachua, and Columbia counties. Poultry manufacturing and healthcare are Suwannee County''s largest industries. Major private sector industries are Pilgrim''s Pride, Advent Christian Village, Shands of Live Oak, Florida Sheriffs Youth Ranch, and Musgrove Construction. Top public sector employers include Suwannee County School District, Suwannee County, and Suwannee County Sheriff''s Department. Cities and towns in Suwannee County include Branfoord, Live Oak (county seat), Mcalpin, and O''Brien.</p>';
    -- Taylor County - 12123
    v_text(12123) := '<p>Taylor County is located in North Central Florida, along with Madison, Hamilton, Taylor, Suwannee, Union, Bradford, Lafayette, Dixie, Levy, Gilchrist, Alachua, Marion, and Columbia counties. The largest industries are healthcare, manufacturing, and the production of wood products. Taylor County has abundant amounts of rural land, giving a lot of opportunity for growth and new development.</p>
    <p> Major private sector employers for Taylor county are Buckeye Technologies, Doctors Memorial Hospital, Chemring Ordnance, United Welding Services Inc, and Gilman Building Products. Top public sector employers are Taylor County School Board and Taylor County Correctional Institute. Incorporated and unincorporated areas in Taylor County include Perry (county seat), Athena, Eridu, Iddo, Salem, Lakebird, and Pinland.</p>';
    -- Union County - 12125
    v_text(12125) := '<p>Union County is located in North Central Florida, along with Madison, Hamilton, Taylor, Suwannee, Bradford, Lafayette, Dixie, Levy, Gilchrist, Alachua, Marion, and Columbia counties. Union County is Florida''s smallest county in area. Union County''s largest industries by employment are trade, transportation, & utilities; manufacturing; and public administration. Major private sector employers are North Florida reception Center, Prichet Trucking, Suwannee Medical Personnel, Lake Butler Hospital/ Ramadan Hand Institute, and Ellington Construction. Top public sector employers are Union Correctional Institute, Union County School District, and Union County Government. Union County cities are Lake Butler (county seat), Raiford, and Worthington Springs.</p>';
    -- Volusia County - 12127
    v_text(12127) := '<p>Volusia County is located in the East Central Florida region, along with Brevard, Osceola, Orange, Seminole, Lake, and Sumter counties. Top industries for Volusia County are Education & Health Services, retail trade, leisure & hospitality, and professional & business services. Volusia County is home to Daytona Beach and the Daytona International Speedway, which hosts NASCAR''s most prestigious race: The Daytona 500. Daytona Beach also acts as a popular tourist destination.</p>
    <p> Top private sector employers include Florida Hospital, Halifax Health, Wal-Mart, Publix Supermarkets, and Embry-Riddle Aeronautical University. Public Sector employers include Volusia County School Board, County of Volusia, Florida State Government, Daytona State College, and US Government. Volusia County cities and towns include Daytona Beach, DeBary, DeLand, Deltona, Holly Hill, New Smyrna Beach, Orange City, Ormond Beach, and Port Orange.</p>';
    -- Wakulla County - 12129
    v_text(12129) := '<p>Wakulla County is located in northwest Florida, along with Escambia, Santa Rosa, Okaloosa, Walton, Holmes, Jackson, Washington, Bay, Calhoun, Liberty, Franklin, Gadsden, Leon, Jefferson, and Gulf counties.  There is not a lot of developed industry in Wakulla County. The largest industry is a commercial ball powder producing facility. Other industries include a fuel refinery, a tax exempted electrical power producing plant, a commercial billing agency, and a sea going barge terminal.</p>
    <p>The largest industries providing employment are public administration; education, health & social services; and construction. 89% of the land in Wakulla County is commercial forest land. Top private sector employers are St. Marks Power, CSG Systems Inc, and Eden Springs. The largest public sector employers include Wakulla County School Board, Florida Department of Corrections, and Florida Department of environment. Municipalities in Wakulla County include Sopchoppy, St. Marks and Crawfordville (county seat).</p>';
    -- Walton County - 12131
    v_text(12131) := '<p>Walton County is part of the Northwest Florida region, along with Santa Rosa, Escambia, Okaloosa, Holmes, Jackson, Washington, Bay, Calhoun, Liberty, Gulf, Franklin, Gadsden, Leon, Jefferson, and Wakulla counties. Largest industries by employment are leisure & hospitality; trade, transportation, & utility; and education & health services. Major private sector employers for Walton County are Sandestin Golf and Beach Resort, Sacred Heart on the Emerald Coast, ResortQuest, and Hilton Sandestin Beach Golf Resort & Spa. Top public sector employers include Walton County School Board and Walton County Government. Cities and towns in Walton County include DeFuniak Springs, Freeport, and Paxton.</p>';
    -- Washington County - 12133
    v_text(12133) := '<p>Washington County is part of the Northwest Florida region, along with Santa Rosa, Escambia, Walton, Holmes, Jackson, Okaloosa, Bay, Calhoun, Liberty, Gulf, Franklin, Gadsden, Leon, Jefferson, and Wakulla counties.  The top industries by employment for Washington County are public administration, trade & transportation, and construction.</p>
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
      '<table class="datatable">'
    ||'<tr><th>Region</th>'
    ||'<th>Population<br/>2012</th>'
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
                           ||'</td><td style="text-align:right">'||to_char(fl_rec.total_population, '999,999,999')
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
     v_table_text :=  v_table_text||'<tr><td>'||county_rec.name
                           ||'</td><td style="text-align:right">'||to_char(county_rec.total_population, '999,999,999')
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
      ||'<ul><li><a href="http://quickfacts.census.gov/qfd/states/12/'||p_cou||'lk.html" target=target="_blank">'
      ||county_rec.name||' Census Data</a></li></ul>'
    
      
      
      ||'<h4>'||county_rec.name||' Economic Activity</h4>'
      ||'<p>The U.S. Bureau of the Census, Economic  , 2007 calculated the total value manufacturing, '
      ||'merchant wholesaler, retail sales and food service sales in '||county_rec.name||'. '
      ||'The Census measured activity of large and medium-sized firms during calendar year 2007. '
      ||'It does not include every aspect of the economy but can be used as a measure of economic activity.</p> '
      
      ||'<p>At '||to_char(county_rec.economy_size, '$999,999,999') ||' million, '
      ||county_rec.name||'''s economic activity represents '
      || to_char((county_rec.economy_size/v_fl_economy_size*100), '90.99')||'% of the Florida economy.</p>'  

      ||'<table class="datatable">'
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
          v_table_text := v_table_text ||'<tr><td class="current" >'||c_rec.name
                           ||'</td><td class="current" style="text-align:right">'||to_char(c_rec.total_population, '999,999,999')
                           ||'</td><td class="current" style="text-align:right">'||to_char(c_rec.economy_size, '$999,999,999')
                           ||'</td><td class="current" style="text-align:right">'||to_char(c_rec.population_growth, '90.9')||'%'
                           ||'</td><td class="current" style="text-align:right">'||to_char(c_rec.median_household_income, '$999,999,999')
                           ||'</td><td class="current" style="text-align:right">'||to_char(c_rec.housing_units, '999,999,999')
                           ||'</td><td class="current" style="text-align:right">'||to_char(c_rec.median_unit_price, '$999,999,999')
                           ||'</td></tr>';      

          
          
        else
          v_table_text := v_table_text ||'<tr><td><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county='
                           ||upper(replace(c_rec.name, ' County'))||'">'||c_rec.name||'</a>'
                           ||'</td><td style="text-align:right">'||to_char(c_rec.total_population, '999,999,999')
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
      ||'<table class="datatable">'
      ||'<tr><th>Usage Type</th><th>Property Count</th><th>%</th><th>Sales Count</th><th>Median Price</th><th>Median Price/Ft</th><th>Sales From</th><th>To</th>';
    end if;
      
    loop_index := v_ucode_summary.FIRST; 
    while loop_index is not null loop
      if loop_index not in ('Total', 'Land') then
        for s_rec in cur_sales(v_display_name, loop_index, v_year) loop
          v_type_name := replace(loop_index, ' Property');
          if p_mode = 'table' then
            v_text := v_text||'<tr>'
            ||'<td>'||loop_index||'</td>'
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
      
      v_text := get_realestate_text(c_rec.county, 'table');
      v_len := length(v_text);
      if v_len > 0 then
        dbms_lob.writeappend(v_desc, v_len, v_text);
      end if;

      v_text := get_realestate_text(c_rec.county, 'text');
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
      and county = c_rec.county;
      commit;
      
      dbms_lob.close(v_desc);
    end loop;
  end gen_county_text;


begin
  gen_county_text;
end;
/