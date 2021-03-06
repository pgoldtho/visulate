set define ^
declare
  type cou_list_type is table of number;
  type text_list_type is table of varchar2(32767) index by varchar2(64);
  
  function get_static_text(p_name in varchar2)  return varchar2 is
    v_text    text_list_type;
  begin
   v_text('overview') := 
'<img src="https://s3.amazonaws.com/visulate.cities/704x440/florida-1.jpg"  alt="Florida" style="border: 1px solid #949494;"/>


<form id="geoForm" action="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS" method="post">
  <input id="gLAT" name="LAT" type="hidden" />
  <input id="gLON" name="LON" type="hidden" />
</form>


<div id="mobileSearch" style="display:none;">
<form id="searchForm" action="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS" method="post">

<h3>Search Florida Real Estate</h3>
<p>Enter a street address then press Search or</p>
<p><a href="javascript:GetCurrentLocation();">Use your current location</a></p>
     <table >
     <tr>
         <td><input size="36" maxlength="80" name="ADDR" type="text" value="" placeholder="Example: 1116 Ocean Dr, Miami Beach"/></td>
         <td><input name="submit_html" value="Search" type="submit" /></td>
         <td></td>
     </tr>
    </table>
</form>
</div>
<div id="pcSearch" style="display:none;">
<form id="searchForm" action="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS" method="post">

<h3>Search Florida Real Estate Records</h3>
<p>Visulate maintains records for every commercial and residential property in Florida.  Use this form to search them.<p>
    <table class="datatable" style="width: 100%">
    <caption>Enter Street Address then Press Search</caption>
     <tr><th><b>Address:</b></th>
         <td><input size="80" maxlength="80" name="ADDR" type="text" value="" placeholder="Example: 1116 Ocean Dr, Miami Beach, FL 33139"/></td>
         <td><input name="submit_html" value="Search" type="submit" /></td>
     </tr>
    </table>
</form>    
</div>
    

<script type="text/javascript">
if( /Android|webOS|iPhone|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
  jQuery("#mobileSearch").css("display","block");
}
else{
  $j("#pcSearch").css("display","block");
}

</script>

<h2>
Florida Economy and Real Estate Market</h2>
      <div id="city_images" class="nivoSlider">
         <img src="https://s3.amazonaws.com/visulate.cities/704x440/miami_beach-1.jpg"
              title="Miami Beach in South East Florida"/>
         <img src="https://s3.amazonaws.com/visulate.cities/704x440/cape_canaveral-22.jpg"
              title="SpaceX Launch from Cape Canaveral in East Central Florida"/>
         <img src="https://s3.amazonaws.com/visulate.cities/704x440/naples-1.jpg"
              title="Naples in South West Florida"/>
         <img src="https://s3.amazonaws.com/visulate.cities/704x440/tampa-2.jpg"
              title="Tampa at Night"/>
         <img src="https://s3.amazonaws.com/visulate.cities/704x440/apalachicola-5.jpg"
              title="Apalachicola in North West Florida"/>
         <img src="https://s3.amazonaws.com/visulate.cities/704x440/madison-8.jpg"
              title="Madison in North Central Florida"/>
         <img src="https://s3.amazonaws.com/visulate.cities/704x440/jacksonville-2.jpg"
              title="Jacksonville in North Eastern Florida"/>
         <img src="https://s3.amazonaws.com/visulate.cities/704x440/moore_haven-1.jpg"
              title="South Central Florida Cattle Country"/>
         <img src="https://s3.amazonaws.com/visulate.cities/704x440/orlando-2.jpg"
              title="Tourism is Florida''s largest industry"/>
         <img src="https://s3.amazonaws.com/visulate.cities/704x440/sebastian-3.jpg"
              title="A Day at the Beach in East Central Florida"/>
              
      </div>

<script type="text/javascript">

   jQuery(window).load(function(){
    jQuery("#city_images").nivoSlider({
        effect:"fade",
        slices:15,
        boxCols:8,
        boxRows:4,
        animSpeed:600,
        pauseTime:6000,
        startSlide:0,
        directionNav:false,
        directionNavHide:false,
        controlNav:false,
        controlNavThumbs:false,
        controlNavThumbsFromRel:false,
        keyboardNav:false,
        pauseOnHover:true,
        manualAdvance:false
    });
  });

  </script>
<h3>Florida</h3>
<p>
Florida is the fourth largest state in the country in terms of both population and GDP.&nbsp; If Florida was a country, it would be in the top twenty of the world.&nbsp; Florida&rsquo;s economy is larger than Saudi Arabia&rsquo;s or the combined economies of Argentina and Peru. Florida has a lot more to offer than most people are aware of and is a worthy spot for tourists, homeowners, and investors alike. With a record 89.3 million visitors in 2012, Florida is the most popular travel destination in the world. This makes tourism Florida&rsquo;s largest industry, contributing 57 billion dollars to the state&rsquo;s economy annually.</p>
<p>
The most popular cities for tourists are Orlando, Miami, Key West, and Daytona Beach. Florida&rsquo;s second largest industry is agriculture, contributing more than 100 billion dollars to the state&rsquo;s economy. Florida leads the southeast in farm income. Florida produces 75% of US oranges and contributes 40% of the world&rsquo;s orange juice supply. Florida is also the largest producer in the country for other citrus products, sweet corn, and green beans. Florida also largely produces tomatoes, strawberries, sugar cane, cattle, and numerous other crops. The top counties for agriculture production in the state are Palm Beach, Miami Dade, Hillsborough, and Hendry.</p>
<p>
Another major component of the economy is the space industry. The Kennedy Space Center is located in Brevard County and helps provide the 33,000 jobs and 4.1 billion dollars that the space industry provides the economy. Florida ranks 4<sup>th</sup> among states in aerospace employment. International trade is another large component of Florida&rsquo;s economy. 40% of all exports and imports to Latin and South America pass through Florida. Over the last ten years, the total value of Florida&rsquo;s merchandise trade has reached 162 billion dollars in value, a 135% increase. Florida ranks 6th in the U.S. in 2012 in exporting goods produced or with significant value added in the state.</p>
<p>
Real estate is another worthy asset of the Florida economy. Florida&rsquo;s real estate industry is driven by inward migration.&nbsp; It grows because people in other parts of the world want to live in Florida. &nbsp;Florida real estate was hit hard by the recession, but the economy is slowly turning around, and the real estate market will follow. &nbsp;As a result of retiring baby boomers, in 2013 more people moved to Florida than 2008, 2009, and 2010 combined. The population increased 2.7% in Florida from 2010 to 2012, compared to a 1.7% increase for the entire country. Inward migration is increasing demand for properties, and property prices are likely to reflect this.</p>
<p>
The Bergstrom Center for Real Estate Studies at The University of Florida provides a survey of real estate market conditions and provides the following analysis:&nbsp;<a href="http://warrington.ufl.edu/centers/cres/survey.asp">http://warrington.ufl.edu/centers/cres/survey.asp</a></p>';

  v_text('regions') := 
'<h2>
Florida Regions</h2>
<p>
Florida can be divided into 8 distinct regions: &nbsp;
<img src="/images/Regional-Navigation-Map.jpg" /></p>
<ul>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=1">Southeast Florida</a> contains Indian River, St. Lucie, Martin, Palm Beach, Broward, Dade, and Monroe counties. &nbsp;</li>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=2">The Tampa Bay region</a> is home to Citrus, Hernando, Pasco, Hillsborough, Pinellas, Polk, Manatee, and Sarasota counties. &nbsp;</li>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=3">East Central Florida</a> is home to Brevard, Osceola, Orange, Seminole, Lake, Volusia, and Sumter counties. &nbsp;</li>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=4">The Northeastern region</a> of Florida includes Baker, Clay, Duval, Nassau, Putnam, Saint Johns, and Flagler counties. &nbsp;</li>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5">The Northwest region</a> of Florida borders the Gulf of Mexico and runs from Pensacola to Tallahassee. It includes Escambia, Santa Rosa, Okaloosa, Walton, Holmes, Jackson, Washington, Bay, Calhoun, Liberty, Gulf, Franklin, Gadsden, Leon, Jefferson, and Wakulla Counties. &nbsp;</li>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=6">Southwest Florida</a> consists of Charlotte, Lee, and Collier counties.</li>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=7">North Central Florida</a> includes Madison, Hamilton, Taylor, Suwannee, Union, Bradford, Lafayette, Dixie, Levy, Gilchrist, Alachua, Marion and Columbia counties</li>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=8">South Central Florida</a> includes Hardee, Highlands, Okeechobee, DeSoto, Glades, and Hendry counties.</li>
</ul>
<p>
The following table shows the population, economic activity, population growth, mean household income, number of housing units, and median home value among the different regions. These numbers come from the United States Census Bureau.</p>
<p>Population describes all persons who are "usually resident" in a specified geographic area. Economic activity is a sum of the region''s manufacturer shipments, merchant wholesaler sales, retail sales, and accommodation and food sales. This number gives an idea of the size of the economy and a basis for comparison. The population growth value shows the difference between the 2012 population estimate and the 2010 population estimate. This number can be used to determine how many people are moving in or out of an area and therefore what the future demand for real estate may be. </p>
<p>Median household income includes the income of the householder and all other individuals over 15 years old in the household. This figure represents the average income of residents and gives insight to the amount of wealth in an area. The "housing units" includes houses, apartments, mobile homes, group of rooms, or single room that is occupied as separate living quarters. Median home value shows the average value of residential properties. This figure, again, provides insight to the wealth of the residents.</p>';
   v_text('region-table') := 
'<table class="datatable"><caption>Florida Economy Regional Comparisons</caption>
<tbody>
<tr><th scope="col">Region</th><th scope="col">Population<br />2012</th><th scope="col">Economic Activity<br />2007 (Millions)</th><th scope="col">Population Growth<br />2010 to 2012</th><th scope="col">Median Household<br />Income 2011</th><th scope="col">Housing<br />Units</th><th scope="col">Median Home Value<br />2007 to 2011</th></tr><tr>
<th scope="row">Southeast Florida</th>
<td style="text-align:right">
6,410,776</td>
<td style="text-align:right">
$237,494</td>
<td style="text-align:right">
2.6%</td>
<td style="text-align:right">
$49,643</td>
<td style="text-align:right">
2,814,252</td>
<td style="text-align:right">
$249,557</td>
</tr>
<tr>
<th scope="row">Tampa Bay Region</th>
<td style="text-align:right">
4,318,438</td>
<td style="text-align:right">
$142,617</td>
<td style="text-align:right">
1.5%</td>
<td style="text-align:right">
$45,359</td>
<td style="text-align:right">
2,122,664</td>
<td style="text-align:right">
$165,700</td>
</tr>
<tr>
<th scope="row">East Central Florida</th>
<td style="text-align:right">
3,369,551</td>
<td style="text-align:right">
$106,985</td>
<td style="text-align:right">
3.7%</td>
<td style="text-align:right">
$48,812</td>
<td style="text-align:right">
1,531,448</td>
<td style="text-align:right">
$186,400</td>
</tr>
<tr>
<th scope="row">Northeastern Florida</th>
<td style="text-align:right">
1,549,472</td>
<td style="text-align:right">
$54,582</td>
<td style="text-align:right">
1.9%</td>
<td style="text-align:right">
$51,852</td>
<td style="text-align:right">
688,499</td>
<td style="text-align:right">
$182,914</td>
</tr>
<tr>
<th scope="row">Northwest Florida</th>
<td style="text-align:right">1,400,233</td>
<td style="text-align:right">$28,814</td>
<td style="text-align:right">0.8%</td>
<td style="text-align:right">$42,825</td>
<td style="text-align:right">671,661</td>
<td style="text-align:right">$136,619</td>
</tr>

<tr>
<th scope="row">South West Florida</th>
<td style="text-align:right">
1,140,169</td>
<td style="text-align:right">
$24,606</td>
<td style="text-align:right">
3.1%</td>
<td style="text-align:right">
$50,477</td>
<td style="text-align:right">
671,152</td>
<td style="text-align:right">
$221,633</td>
</tr>
<tr>
<th scope="row">North Central Florida</th>
<td style="text-align:right">
878,554</td>
<td style="text-align:right">
$16,126</td>
<td style="text-align:right">
-0.4%</td>
<td style="text-align:right">
$39,575</td>
<td style="text-align:right">
407,372</td>
<td style="text-align:right">
$118,715</td>
</tr>
<tr>
<th scope="row">South Central Florida</th>
<td style="text-align:right">
250,375</td>
<td style="text-align:right">
$3,395</td>
<td style="text-align:right">
-1.0%</td>
<td style="text-align:right">
$37,316</td>
<td style="text-align:right">
119,917</td>
<td style="text-align:right">
$109,583</td>
</tr>
</tbody>
</table>';

  v_text('google-ad') := 
'<div style="margin-bottom: 6px;">
<script type="text/javascript"><!--
google_ad_client = "pub-9857825912142719";
/* 728x90, created 5/30/10 */
google_ad_slot = "7170948200";
google_ad_width = 728;
google_ad_height = 90;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
</div>';

  v_text('southeast') := 
'<img src="https://s3.amazonaws.com/visulate.cities/704x440/florida-south-east-1.jpg"  alt="Miami Beach, Florida" style="border: 1px solid #949494;"/>
<h2>Southeast Florida</h2>
<img src="/images/Regional-SouthEast.jpg" style="float: left;" />


<p>Southeast Florida contains <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=INDIAN%20RIVER&city=&region_id=1">Indian River</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20LUCIE&city=&region_id=1">St. Lucie</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARTIN&city=&region_id=1">Martin</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PALM%20BEACH&city=&region_id=1">Palm Beach</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BROWARD&city=&region_id=1">Broward</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MIAMI-DADE&city=&region_id=1">Miami-Dade</a>, and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MONROE&city=&region_id=1">Monroe</a> counties. This is one of the most densely populated and developed areas of the state and the Miami metropolitan area is the fourth largest urban area in the country.</p>
<p>Miami is the area''s biggest city. It is a popular tourist destination and provides easy access to international markets in Latin America.  Network Access Point, the AMPATH network, and many other internet related companies are all found in this region, making it one of the major telecom hubs in the world.</p>
<div style="clear:both;"></div>

<p><strong>Southeast Florida Links:</strong></p>
<ul>
<li><a href="http://www.enterpriseflorida.com/news/category/southeast-florida/" target="_blank">Southeast Florida Business News</a></li>
</ul>
<p>There are three Metropolitan Statistical Areas (MSAs) in Southeast Florida:</p>
<ul>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=1#sebastian">Sebastian-Vero Beach MSA</a></li>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=1#port-st-lucie">Port St. Lucie MSA</a></li>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=1#miami">Miami-Fort Lauderdale-Pompano Beach MSA</a></li>
</ul>

<a name="miami"></a>
<h3>Miami-Fort Lauderdale-Pompano Beach MSA</h3>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/miami-7.jpg"   title="Miami, Florida"  style="border: 1px solid #949494;"/>
<p>
The second-longest MSA in the US, Miami-Fort Lauderdale-Pompano Beach includes Miami-Dade, Broward, and coastal Palm Beach Counties. The MSA is the most populous in Florida and the eighth most-populous in the country. The urbanized areas are confined to a strip of land located between the Everglades and the Atlantic Ocean.</p>
<p>
Miami-Fort Lauderdale is the sixteenth-largest television market in the nation.</p>

<h4>Miami</h4>
<p>
The City of Miami has the distinction of being the only major U.S. city to have been founded by a woman. Julia Tuttle, a widow who moved from Cleveland after her husband''s death, convinced oil and railroad tycoon Henry Flagler to extend his railroad from Palm Beach. The railroad was completed in 1896, and Miami was founded the same year.</p>
<p>
Miami experienced decades of booming population, especially after World War II, when soldiers who were stationed and trained on Miami Beach got "sand in their shoes" and moved to get away from cold temperatures up north. </p>
<p>
The most important event in Miami''s history did not even happen in the U.S. Fidel Castro''s 1959 revolution in Cuba prompted large numbers of Cubans to flee the island for exile in Miami. This population paved the way for successive waves of immigrants from Latin America and the Caribbean. With a population that is over 60% Hispanic, Miami is sometimes referred to as the "Capital of Latin America".</p>
<p>
Miami is a growing city populated by over 400,000 people. A majority of those people speak Spanish as their first language. Over half of residents were born outside the U.S. Miami is the seat of Miami-Dade County, which is home for about 2.5 million people. Miami-Dade is the most-populous county in Florida and the seventh-most-populous in the U.S.</p>
<p>
Miami''s economy is primarily based on services, including tourism and healthcare, though many companies have chosen to locate in Miami or started there. Numerous companies are headquartered in Greater Miami, including Burger King, Carnival Cruise Lines, Telemundo, Univision, Perry Ellis International, Bacardi, and world-famous architectural firm Arquitectonica. Numerous U.S. and foreign concerns base their Latin American headquarters in Miami to take advantage of the well-educated Spanish-speaking population, including Sony, Microsoft, American Airlines, Wal-Mart, and Disney. In addition, some Latin American companies headquarter their U.S. divisions in the city, such as Odebrecht Construction, a Brazilian firm. The Brickell neighborhood contains the highest concentration of international banks in the nation.</p>
<p>
Miami is classified by the Globalization and World Cities Research Network as an Alpha- world-class city. Terremark (a subsidiary of Verizon) operates Network Access Point of the Americas, an important data center and Internet exchange point for routing traffic to and from Latin America, in downtown Miami. Another exchange point, the AMPATH network, is in Miami, but it is dedicated to research and education in Latin America and the Caribbean.</p>
<p>
PortMiami is the busiest in the world for cruise and passenger traffic, having handled four million cruise passengers in 2013. It is also an important port for cargo, with over half of that cargo coming in from Latin America and the Caribbean. Miami International Airport is the nation''s busiest airport for international cargo and one of the most trafficked for foreign visitors. Four general aviation airports elsewhere in the county handle private aircraft and pilot training.</p>
<p>
Miami is home to Florida International University; while the University of Miami, Barry University, St. Thomas University, Florida Memorial University, and campuses of Johnson & Wales University and Nova Southeastern University are located in the suburbs. Miami Dade College, with campuses across the county, is the second-largest institution of higher learning in the nation by enrollment.</p>

<p><b>Links:</b></p>
<ul>
<li><a href="http://www.miamigov.com/" target="_blank"> City of Miami</a></li>
<li><a href="http://www.miamidade.gov/" target="_blank"> Miami-Dade County</a></li>
<li><a href="http://www.miamichamber.com/" target="_blank"> Greater Miami Chamber of Commerce</a></li>
<li><a href="http://www.miamiandbeaches.com" target="_blank"> Greater Miami Convention and Visitors Bureau</a></li>
<li><a href="http://www.miamidade.gov/portmiami" target="_blank"> PortMiami</a></li>
<li><a href="http://www.miami-airport.com/" target="_blank"> Miami International Airport</a></li>
<li><a href="http://www.miami.edu/" target="_blank"> University of Miami</a></li>
<li><a href="http://www.fiu.edu/" target="_blank"> Florida International University</a></li>
<li><a href="http://www.mdc.edu/" target="_blank"> Miami Dade College</a></li>
<li><a href="http://www.barry.edu/" target="_blank"> Barry University</a></li>
<li><a href="http://www.stu.edu/" target="_blank"> St. Thomas University</a></li>
<li><a href="http://www.fmuniv.edu/" target="_blank"> Florida Memorial University</a></li>
<li><a href="http://www.jwu.edu/northmiami" target="_blank"> Johnson & Wales University - North Miami</a></li>
</ul>


<h4>Fort Lauderdale</h4>
<p>
Named for Major William Lauderdale, who ordered a fort built on the New River during the Second Seminole War in the 1830s, Fort Lauderdale was largely uninhabited until the 20th century. The arrival of the railroad in 1896 changed all that. During World War II, the disappearance of Flight 19 from Naval Air Station Fort Lauderdale revived the Bermuda Triangle myth. The city became a major Spring Break destination in the 1950s, which was only compounded by the celebration of the phenomenon in the film Where the Boys Are. The city aggressively pushed out Spring Breakers in the 1980s and created a cultural district downtown in the 2000s.</p>
<p>
Known as "Venice of America" for its numerous inland waterways, Fort Lauderdale is home for over 165,000 people, making it the eighth-largest city in Florida. Broward County, of which Fort Lauderdale is the seat, has over 1.5 million inhabitants, the second-most-populous county in the state.</p>
<p>
The largest segment of Fort Lauderdale''s economy is tourism. Almost a third of visitors attend a convention at the Broward County Convention Center. Many tourists come from the LGBT community because Fort Lauderdale and the adjacent City of Wilton Manors are gay-friendly with large numbers of LGBT people and businesses that cater to that population. </p>
<p>
The city is also a major center for cruise travel. Port Everglades serves the third-most cruise passengers annually of any port in the nation. The port is also an important hub for container cargo and petroleum. The city''s coastal location allows for other maritime recreation, including yachting. This had led to the presence of a large maritime manufacturing and repair industry.</p>
<p>
Fort Lauderdale-Hollywood International Airport is ranked number twenty-one nationwide for the number of passengers. The Florida Department of Transportation estimates the airport''s economic impact around $10.6 billion.</p>
<p>
Though the institution has campuses throughout the county, Broward College''s administrative offices are at the Willis Holcombe Center in downtown Fort Lauderdale. The city hosts City College and the Art Institute of Fort Lauderdale in addition to satellite campuses of Florida Atlantic University and Florida International University. Nova Southeastern University is located in the suburbs.</p>

<p><b>Links:</b></p>
<ul>
<li><a href="http://http://www.fortlauderdale.gov/" target="_blank"> City of Fort Lauderdale</a></li>
<li><a href="http://www.broward.org/" target="_blank"> Broward County</a></li>
<li><a href="http://www.ftlchamber.com/" target="_blank"> Greater Fort Lauderdale Chamber of Commerce</a></li>
<li><a href="http://www.broward.org/Airport/About/Pages/Default.aspx" target="_blank"> Broward County aviation department</a></li>
<li><a href="http://www.ftlauderdalecc.com/" target="_blank"> Greater Fort Lauderdale / Broward County Convention Center</a></li>
<li><a href="http://www.porteverglades.net/" target="_blank"> Port Everglades</a></li>
<li><a href="http://www.broward.edu/" target="_blank"> Broward College</a></li>
<li><a href="http://www.nova.edu" target="_blank"> Nova Southeastern University</a></li>
<li><a href="http://www.citycollege.edu/" target="_blank"> City College</a></li>
<li><a href="http://www.artinstitutes.edu/fort-lauderdale/" target="_blank">‎ Art Institute of Fort Lauderdale</a></li>
</ul>

<h4>Pompano Beach</h4>
<p>
The city of Pompano Beach was founded by two railroad workers who were conducting a survey for the Florida East Coast Railway expansion to Miami. Local legend has it that the name comes from a local fish that an early settler liked. The city is in northern Broward county and is home to about 100,000 people.</p>
<p>
Pompano''s economy is primarily driven by tourism, though manufacturing and healthcare are also strong. Pompano Beach''s manufacturing centers are primarily devoted to the construction industry. The largest employer in the city is Pompano Park, a horse racing track to which a casino, The Isle, was added.</p>
<p>
The headquarters of the South Florida Regional Transportation Authority, the organization that runs the Tri-Rail light commuter rail, is located in Pompano Beach.
The North Campus of Broward College is located in the adjacent city of Coconut Creek.</p>

<p><b>Links:</b></p>
<ul>
<li><a href="http://www.pompanobeachfl.gov/" target="_blank"> City of Pompano Beach</a></li>
<li><a href="http://www.pompanobeachchamber.com/" target="_blank"> Greater Pompano Beach Chamber of Commerce</a></li>
<li><a href="http://www.sfrta.fl.gov/" target="_blank"> South Florida Regional Transportation Authority</a></li>
<li><a href="http://www.broward.edu/locations/Pages/north-campus.aspx" target="_blank"> Broward College - North Campus</a></li>
</ul>

<h4>West Palm Beach</h4>
<p>
The City of West Palm Beach was incorporated in 1894. It was founded by Henry Flagler, who extended his railroad line to Lake Worth and built a pair of luxury hotels on Palm Beach. West Palm was created as the home for the hotel workers. It became the seat of Palm Beach County upon its creation in 1909. Like the rest of South Florida, West Palm experienced rapid population growth after World War II.</p>
<p>
Around 100,000 people call West Palm Beach home. West Palm Beach-Fort Pierce is the 38th-largest television market in the nation.</p>
<p>
Its primary economic driver is tourism, though the healthcare industry is very strong. The city also has a strong manufacturing base, especially with respect to the construction industry.
West Palm Beach hosts Palm Beach Atlantic University and a campus of Northwood University.</p>

<p><b>Links:</b></p>
<ul>
<li><a href="http://www.wpb.org" target="_blank"> City of West Palm Beach</a></li>
<li><a href="http://www.palmbeaches.org" target="_blank"> Chamber of Commerce of the Palm Beaches</a></li>
<li><a href="http://www.pba.edu" target="_blank"> Palm Beach Atlantic University</a></li>
<li><a href="http://www.northwood.edu/locations/florida.aspx" target="_blank"> Northwood University - Florida Campus</a></li>
</ul>

<h4>Boca Raton</h4>
<p>
Boca Raton is a city of over 80,000 in southern Palm Beach County. Boca is famous as the birthplace of the IBM personal computer. Since 1970, IBM owned and operated a research and manufacturing complex in the city, and it was the team that was based there that developed and assembled the first PCs IBM sold in the early 1980s. IBM moved their PC operations to North Carolina, but their former facility is now a research and business park.</p>
<p>
Tourism is important to Boca Raton''s economy, but white-collar jobs also make up a substantial piece of the pie. Office Depot''s corporate offices are in the city, as is the headquarters for GEO Group (formerly known as Wackenhut), among others. Boca''s reputation as a retirement destination means that healthcare is also an important economic motivator.</p>
<p>
Boca Raton is an affluent city with a median income well above the national median. The city has strict codes to enforce a clean look across the city. Signs are heavily restricted and billboards are not allowed, for instance.</p>
<p>
The main campus of Florida Atlantic University is located in Boca Raton. Lynn University is also in the city, as is a campus of Palm Beach State College.</p>

<p><b>Links:</b></p>
<ul>
<li><a href="http://www.ci.boca-raton.fl.us/" target="_blank"> City of Boca Raton</a></li>
<li><a href="http://www.bocaratonchamber.com" target="_blank"> Greater Boca Raton Chamber of Commerce</a></li>
<li><a href="http://www.fau.edu" target="_blank"> Florida Atlantic University</a></li>
<li><a href="http://www.lynn.edu" target="_blank"> Lynn University</a></li>
<li><a href="http://www.palmbeachstate.edu/locations/boca-raton/" target="_blank"> Palm Beach State College</a></li>
</ul>

<a name="sebastian"></a>
<h3>Sebastian-Vero Beach</h3>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/sebastian_inlet-6.jpg"   title="Sebastian Inlet"  style="border: 1px solid #949494;"/>
<p>
Sebastian-Vero Beach is contained within Indian River County, home to over 135,000 people and one of the wealthiest counties in the nation.<p>
<p>
This region makes up the northern portion of the Treasure Coast, so named because a Spanish treasure fleet wrecked off the coast in 1715. Occasionally, valuables lost in that destructive event wash up on the Florida shore.</p>

<h4>Sebastian</h4>
<p>
The City of Sebastian is home to about 22,000 people. Its economy is driven by tourism and healthcare. Velocity Aircraft is headquartered at the Sebastian Airport.</p>
<p>Nearby Pelican Island National Island Refuge was the first national wildlife refuge in the nation.  Sebastian is home to a campus of Indian River State College.</p>
<p><b>Links:</b></p>
<ul>
<li><a href="http://www.cityofsebastian.org/" target="_blank">City of Sebastian</a></li>
<li><a href="https://www.sebastianchamber.com/" target="_blank">Sebastian River Area Chamber of Commerce</a></li>
<li><a href="http://www.irsc.edu/" target="_blank">Indian River State College</a></li>
<li><a href="http://www.fws.gov/pelicanisland/" target="_blank">Pelican Island National Wildlife Refuge</a></li>
<li><a href="http://www.velocityaircraft.com/" target="_blank">Velocity Aircraft</a></li>
</ul>

<h4>Vero Beach</h4>
<p>
Vero Beach, the seat of Indian River County, has more than 15,000 residents. The city''s economy is primarily driven by services, including tourism and healthcare. Piper Aircraft, maker of general aviation aircraft including the Piper Cub, has their headquarters and manufacturing facility in Vero Beach. They are one of the largest private employers in the area.</p>
<p>Vero Beach is known for its golfing, fishing, and surfing. It is also home to a Disney resort.
The city is the location of the Mueller Campus of Indian River State College.</p>

<p><b>Links:</b></p>
<ul>
<li><a href="http://www.covb.org" target="_blank"> City of Vero Beach</a></li>
<li><a href="https://www.indianriverchamber.com/" target="_blank"> Indian River County Chamber of Commerce</a></li>
<li><a href="http://www.piper.com/" target="_blank"> Piper Aircraft</a></li>
<li><a href="http://www.irsc.edu/aboutirsc/campuslocations/muellercampus/muellercampus.aspx?id=452" target="_blank"> Indian River State College - Mueller (Vero Beach) Campus</a></li>
</ul>

<a name="port-st-lucie"></a>
<h3>Port St. Lucie MSA</h3>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/port_saint_lucie-1.jpg"   title="Port Saint Lucie Civic Center"  style="border: 1px solid #949494;"/>
<p>
The Port St. Lucie MSA covers St. Lucie and Martin Counties. The region has a population in excess of 400,000 people. This makes up the southern portion of the Treasure Coast, though it is sometimes referred to as the Research Coast because of the concentration of biological research firms.</p>

<h4>Port St. Lucie</h4>
<p>
Port St. Lucie was developed as a planned community in the 1960s. As late as the 1950s the area was sparsely inhabited. The residents of that first community refused to incorporate, though the developer included future building projects in the city.</p>
<p> The 2010 Census found that the City of Port St. Lucie is home for over 160,000, a number almost double that of the 2000 Census. Port St. Lucie is the ninth-largest city in Florida.</p>
<p>
The city''s economy is largely driven by the services, especially tourism and healthcare, however, the city is positioning itself as a player in life science research. The Torrey Pines Institute for Molecular Studies opened a LEED-certified research center in 2008 and the Mann Research Center is a 150-acre research park.</p>
<p>The city boasts three PGA tour golf courses that are available for use by the public. The New York Mets hold their spring training at Tradition Field.
The city hosts a campus of Indian River State College.</p>

<p><b>Links:</b></p>
<ul>
<li><a href="http://www.cityofpsl.com/" target="_blank">City of Port St. Lucie</a></li>
<li><a href="http://www.stluciechamber.org/" target="_blank">St. Lucie County Chamber of Commerce</a></li>
<li><a href="http://www.tpims.org/about-us/florida-location" target="_blank">Torrey Pines Institute for Molecular Studies - Florida Location</a></li>
<li><a href="http://mannresearchcenter.com/" target="_blank">Mann Research Center</a></li>
<li><a href="http://www.irsc.edu/aboutirsc/campuslocations/slwcampus/slwcampus.aspx?id=515" target="_blank">Indian River State College - Pruitt Campus</a></li>
</ul>

<h4>Fort Pierce</h4>
<p>
Formerly the principal city of the Port St. Lucie MSA, Fort Pierce has a population over 40,000. West Palm Beach-Fort Pierce is the 38th-largest television market in the nation.</p>
<p>
Established in 1901, Fort Pierce is the county seat of St. Lucie County. It is named for a Second Seminole War-era fort established by Lieutenant Colonel Benjamin K. Pierce. During World War II the navy established a base on the beach and trained the first Underwater Demolition Teams, or frogmen, the predecessors to the Navy SEALs. Today, Fort Pierce is home to the National Navy UDT-SEAL Museum.</p>
<p>
The city''s economy is primarily in the service sectors, including tourism, education, and healthcare.
Fort Pierce is located near the Indian River Lagoon, the estuary with the most biological diversity in the nation. Because of this, the city hosts the Smithsonian Marine Station and Harbor Branch Oceanographic Institution of Florida Atlantic University.
The city contains the main campus of Indian River State College.</p>

<p><b>Links:</b></p>
<ul>
<li><a href="http://www.cityoffortpierce.com/" target="_blank"> City of Fort Pierce</a></li>
<li><a href="http://www.sms.si.edu/" target="_blank"> Smithsonian Marine Station</a></li>
<li><a href="https://navysealmuseum.com/" target="_blank"> National UDT-Navy SEAL Museum</a></li>
<li><a href="http://www.irsc.edu" target="_blank"> Indian River State College</a></li>
</ul>

';

  v_text('southeast-data') := 
'<p><strong>Southeast Florida Quick Facts</strong></p>
<table class="datatable">
<caption>Southeast Florida Quick Facts</caption>
<tbody>
<tr>
<th scope="col">County</th>
<th scope="col">Population<br />2012</th>
<th scope="col">Economic Activity<br />2007 (Millions)</th>
<th scope="col">Population Growth<br />2010 to 2012</th>
<th scope="col">Median Household<br />Income 2011</th>
<th scope="col">Housing<br />Units</th>
<th scope="col">Median Home Value<br />2007 to 2011</th>
</tr>
<tr>
<th scope="row"><a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=INDIAN RIVER">Indian River County</a></th>
<td style="text-align:right">
140,567</td>
<td style="text-align:right">
$2,455</td>
<td style="text-align:right">
1.8%</td>
<td style="text-align:right">
$46,363</td>
<td style="text-align:right">
76,251</td>
<td style="text-align:right">
$179,300</td>
</tr>
<tr>
<th scope="row"><a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=ST. LUCIE">St. Lucie County</a></th>
<td style="text-align:right">
283,866</td>
<td style="text-align:right">
$5,576</td>
<td style="text-align:right">
2.2%</td>
<td style="text-align:right">
$44,947</td>
<td style="text-align:right">
137,581</td>
<td style="text-align:right">
$157,600</td>
</tr>
<tr>
<th scope="row"><a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=MARTIN">Martin County</a></th>
<td style="text-align:right">
148,817</td>
<td style="text-align:right">
$4,347</td>
<td style="text-align:right">
1.7%</td>
<td style="text-align:right">
$53,612</td>
<td style="text-align:right">
78,356</td>
<td style="text-align:right">
$238,200</td>
</tr>
<tr>
<th scope="row"><a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=PALM BEACH">Palm Beach County</a></th>
<td style="text-align:right">
1,356,545</td>
<td style="text-align:right">
$38,668</td>
<td style="text-align:right">
2.8%</td>
<td style="text-align:right">
$52,951</td>
<td style="text-align:right">
668,159</td>
<td style="text-align:right">
$236,600</td>
</tr>
<tr>
<th scope="row"><a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=BROWARD">Broward County</a></th>
<td style="text-align:right">
1,815,137</td>
<td style="text-align:right">
$73,668</td>
<td style="text-align:right">
3.8%</td>
<td style="text-align:right">
$51,782</td>
<td style="text-align:right">
810,795</td>
<td style="text-align:right">
$225,300</td>
</tr>
<tr>
<th scope="row"><a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=MIAMI-DADE">Miami-Dade County</a></th>
<td style="text-align:right">
2,591,035</td>
<td style="text-align:right">
$110,643</td>
<td style="text-align:right">
3.8%</td>
<td style="text-align:right">
$43,957</td>
<td style="text-align:right">
990,558</td>
<td style="text-align:right">
$246,800</td>
</tr>
<tr>
<th scope="row"><a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=MONROE">Monroe County</a></th>
<td style="text-align:right">
74,809</td>
<td style="text-align:right">
$2,136</td>
<td style="text-align:right">
2.4%</td>
<td style="text-align:right">
$53,889</td>
<td style="text-align:right">
52,552</td>
<td style="text-align:right">
$463,100</td>
</tr>
<tr>
<th scope="row">Total</th>
<td style="text-align:right">
6,410,776</td>
<td style="text-align:right">
$237,494</td>
<td style="text-align:right">
2.6%</td>
<td style="text-align:right">
$49,643</td>
<td style="text-align:right">
2,814,252</td>
<td style="text-align:right">
$249,557</td>
</tr>
</tbody>
</table>';

  v_text('tampa') := 
'<img src="https://s3.amazonaws.com/visulate.cities/704x440/florida-tampa-bay-1.jpg"  alt="Saint Petersburg, Florida" style="border: 1px solid #949494;"/>
<h2>Tampa Bay Region</h2>
<img src="/images/Regional-Tampbay.jpg" alt="Tampa Bay region" style="float: left;" />


<p>The Tampa Bay region is home to <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CITRUS&city=&region_id=2">Citrus</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HERNANDO&city=&region_id=2">Hernando</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PASCO&city=&region_id=2">Pasco</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HILLSBOROUGH&city=&region_id=2">Hillsborough</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PINELLAS&city=&region_id=2">Pinellas</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=POLK&city=&region_id=2">Polk</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MANATEE&city=&region_id=2">Manatee</a>, and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SARASOTA&city=&region_id=2">Sarasota</a> counties. This region is the 14th largest consumer market in the country, and one in four of Florida''s business and information services firms resides in Tampa Bay. The key industries of the region are applied medicine and human performance; business, financial & data services; high-tech electronics and instruments; and marine and environmental activities.</p>
<div style="clear:both;"></div>

<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.enterpriseflorida.com/news/category/tampa-bay/Tampa" target="_blank">Bay Region Business News</a></li>
<li><a href="http://www.tampabay.org/" target="_blank">Tampa Bay Partnership</a></li>
	</ul>
<p>Tampa Bay contains the following Metropolitan Statistical Areas (MSAs):</p>
<ul>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=2#tampa">Tampa-St. Petersburg-Clearwater MSA</a></li></li>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=2#lakeland">Lakeland-Winter Haven MSA</a></li>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=2#sarasota">North Port-Bradenton-Sarasota MSA</a></li>
</ul>


<a name="tampa"></a>
<h3>Tampa-St. Petersburg-Clearwater MSA</h3>

<img src="https://s3.amazonaws.com/visulate.cities/704x440/tampa-2.jpg" title="Tampa, Florida"  style="border: 1px solid #949494;"/>
<p>One of the most populous regions in the nation, Tampa Bay is well-known among political activists as a "swing" region on the western end of the so-called I-4 Corridor.</p>
<p>This region includes Hillsborough, Pinellas, Pasco, and Hernando Counties. It is home to over 2.5 million people and the fourteenth-largest television market in the country.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.tampahispanicchamber.com" target="_blank">Hispanic Chamber of Commerce of Tampa Bay</a></li>
</ul>
<h4>Tampa</h4>
<p>Despite its advantageous geography, the City of Tampa struggled initially due to Indian raids and yellow fever. Tampa boomed after phosphates were discovered nearby in the mid-1880s and Henry Plant extended his rail line down to the city. The relocation of some cigar factories by Vicente Martinez Ybor further fueled the city''s growth. Today, the Ybor City District boasts many historic structures and is itself a National Historic Landmark.</p>
<p>Tampa has a population in excess of 330,000. Its has a diverse economy and is home to a number of businesses, including Kforce, SYKES, and Bloomin'' Brands (operator of restaurant chains including Outback Steakhouse, Carrabba''s Italian Grill, and Bonefish Grill). Like many places in Florida, Tampa boasts a robust tourist economy, but many residents are also employed in white collar/administrative positions and health care.</p>
<p>Located just outside of the city is MacDill Air Force Base. MacDill hosts both the U.S. Central Command and Special Operations Command. It is also the location from which so-called "Hurricane Hunter" aircraft are based out of. The base directly employs over 14,000 and contributes an estimated $5 billion to the economy of the Tampa Bay area.</p>
<p>Tampa is served by the Port of Tampa Bay, which handles the most cargo of any port in the state. It specializes in bulk cargo, especially steel and phosphates. It is also a busy cruise ship port, seeing almost a million passengers annually.</p>
<p>All Property Management ranked Tampa as the second-best city in the U.S. for investing in rental properties in 2014.</p>
<p>The Globalization and World Cities Research Network ranks Tampa as a Gamma+ level world city.</p>
<p>Tampa hosts the University of South Florida, University of Tampa, and Hillsborough Community College.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.tampagov.net/" target="_blank">City of Tampa</a></li>
<li><a href="http://www.hillsboroughcounty.org" target="_blank">Hillsborough County</a></li>
<li><a href="http://www.tampachamber.com" target="_blank">Greater Tampa Chamber of Commerce</a></li>
<li><a href="http://www.tampaedc.com/" target="_blank">Tampa Hillsborough Economic Development Corporation</a></li>
<li><a href="http://www.tampasdowntown.com/" target="_blank">Tampa Downtown Partnership</a></li>
<li><a href="http://www.southtampachamber.org" target="_blank">South Tampa Chamber of Commerce</a></li>
<li><a href="http://www.northtampachamber.com" target="_blank">North Tampa Chamber of Commerce</a></li>
<li><a href="http://www.newtampachamber.org" target="_blank">New Tampa Chamber of Commerce</a></li>
<li><a href="http://www.westtampachamber.com" target="_blank">West Tampa Chamber of Commerce</a></li>
<li><a href="https://www.tampaport.com" target="_blank">Port of Tampa Bay</a></li>
<li><a href="http://www.tampaairport.com" target="_blank">Tampa International Airport</a></li>
<li><a href="http://www.usf.edu" target="_blank">University of South Florida</a></li>
<li><a href="http://www.ut.edu" target="_blank">University of Tampa</a></li>
<li><a href="http://www.hccfl.edu" target="_blank">Hillsborough Community College</a></li>
<li><a href="http://www.kforce.com" target="_blank">Kforce</a></li>
<li><a href="http://www.sykes.com" target=_blank">SYKES</a></li>
<li><a href="http://www.bloominbrands.com" target="_blank">Bloomin'' Brands</a></li>
</ul>
<h4>St. Petersburg</h4>
<p>The City of St. Petersburg is across Tampa Bay from the City of Tampa, on a peninsula that is bound by the bay and the Gulf of Mexico. The city holds the distinction of hosting the first commercial airline with regularly-scheduled flights, which went across the bay to Tampa twice a day beginning on January 1, 1914. The 1924 completion of the Gandy Bridge negated the need for the airline and cut the distance drivers had to travel by half.</p>
<p>St. Pete, home to just shy of a quarter-of-a-million people, is the largest city in Florida that is not its county''s seat. It hosts many businesses, including Raymond James Financial, Home Shopping Network (HSN), and Jabil Circuit. The city''s economy is strong in administrative and white collar jobs, as well as high-tech manufacturing, in addition to tourism and healthcare.</p>
<p>The city is home to the University of South Florida St. Petersburg, Eckerd College, St. Petersburg College, and a campus of Webster University.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.stpete.org" target="_blank">City of St. Petersburg</a></li>
<li><a href="http://www.pced.org" target="_blank">Pinellas County Economic Development</a></li>
<li><a href="http://www.usfsp.edu" target="_blank">University of South Florida St. Petersburg</a></li>
<li><a href="http://www.eckerd.edu" target="_blank">Eckerd College</a></li>
<li><a href="http://www.spcollege.edu" target="_blank">St. Petersburg College</a></li>
<li><a href="http://www.webster.edu/stpetersburg" target="_blank">Webster University - St. Petersburg</a></li>
<li><a href="http://www.raymondjames.com" target="_blank">Raymond James</a></li>
<li><a href="http://www.hsn.com" target="_blank">Home Shopping Network</a></li>
<li><a href="http://www.jabil.com" target="_blank">Jabil Circuit</a></li>
</ul>
<h4>Clearwater</h4>
<p>The seat of Pinellas County, Clearwater is home to over 100,000 people. Pinellas broke away from Hillsborough County in 1912, citing neglect from the county government and difficulty traveling to Tampa.</p>
<p>Like the other cities of the region, Clearwater''s economy is strongly supported by white collar and administrative positions, though tourism and healthcare are also important economic engines. Tech Data, a Fortune 500 company, is one of the businesses headquartered in Clearwater.</p>
<p>The city hosts a campus of St. Petersburg College and the Clearwater Christian College.</p>
<p><strong>Links</strong></p>
<ul>
<li><a href="http://www.myclearwater.com/gov" target="_blank">City of Clearwater</a></li>
<li><a href="http://www.pinellascounty.org/" target="_blank">Pinellas County</a></li>
<li><a href="http://www.tampabaybeaches.com" target="_blank">Tampa Bay Beaches Chamber of Commerce</a></li>
<li><a href="http://spcollege.edu/clw/" target="_blank">St. Petersburg College, Clearwater campus</a></li>
<li><a href="http://www.clearwater.edu" target="_blank">Clearwater Christian College</a></li>
<li><a href="http://www.techdata.com" target="_blank">Tech Data Worldwide</a></li>
</ul>

<a name="lakeland"></a>
<h3>Lakeland-Winter Haven MSA</h3>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/lakeland-1.jpg" title="Tampa, Florida"  style="border: 1px solid #949494;"/>
<p>Polk County lies at the center of the state of Florida. Indeed, a study by the University of Florida shows that Polk County has been the center-point of Florida''s population since 1960. The county is growing because of its location along the I-4 Corridor between Tampa and Orlando. Today, Polk County is home to over 600,000 people. Lakeland/Winter Haven is the 94th largest radio market in the U.S.</p>
<p>Warner University is located in the small city of Lake Wales and Webber International University is nearby in unincorporated Polk County.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.warner.edu" target="_blank">Warner University</a></li>
<li><a href="http://www.webber.edu" target="_blank">Webber International University</a></li>
</ul>
<h4>Lakeland</h4>
<p>In 1885, Lakeland incorporated as a city. It had grown due to the extension of the railroad in the area. It has expanded steadily and rapidly, becoming the spring training home of the Detroit Tigers in the 1930s and a flight instruction center during World War II.</p>
<p>The city of about 100,000 has long benefitted from its proximity to phosphate mines and citrus groves. Healthcare and tourism are also strong economic drivers. The headquarters of Publix Supermarkets is located in the city, and the Fortune 500 grocery chain is the city''s largest employer. Saddle Creek Logistics Services is also headquartered in Lakeland.</p>
<p>The city is home to Southeastern University, Florida Southern College, and campuses of Polk State College and Webster University.  It is also home to the newest member of the Florida State University System.  Florida Polytechnic University is strategically located in Lakeland, FL, on the I-4 high-tech corridor and focuses on STEM programs, specifically technology and engineering.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.lakelandgov.net" target="_blank">City of Lakeland</a></li>
<li><a href="http://www.lakelandchamber.com" target="_blank">Lakeland Area Chamber of Commerce</a></li>
<li><a href="http://www.downtownlakelandfl.com" target="_blank">Downtown Lakeland Partnership, Inc.</a></li>
<li><a href="http://www.seu.edu" target="_blank">Southeastern University of the Assemblies of God</a></li>
<li><a href="http://www.flsouthern.edu" target="blank">Florida Southern College</a></li>
<li><a href="https://floridapolytechnic.org/" target="blank">Florida Polytechnic University</a></li>
<li><a href="http://www.polk.edu/lakeland" target="_blank">Polk State College, Lakeland campus</a></li>
<li><a href="http://www.webster.edu/lakeland" target="_blank">Webster University - Lakeland</a></li>
<li><a href="http://www.publix.com" target="_blank">Publix Supermarkets</a></li>
<li><a href="http://www.sclogistics.com" target="_blank">Saddle Creek Logistics Services</a></li>
</ul>
<h4>Winter Haven</h4>
<p>Twenty-five years after Winter Haven incorporated as a city, in 1936, tourist attraction Cypress Gardens opened for business. It was the first theme park in the country and entertained guests with botanical gardens, beautiful women and exhibitions of water sports, especially waterskiing. The completion of the interstate highway system and opening of Walt Disney World in nearby Orlando caused the park to fall on hard times. The gardens were incorporated into Legoland Florida, which opened on the site in 2011.</p>
<p>The first Publix Supermarket opened in Winter Haven in 1930, though the grocery chain''s corporate headquarters are in nearby Lakeland. The economy of the city of over 30,000 is focused on tourism and healthcare.</p>
<p>The main campus of Polk State College is in Winter Haven.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.mywinterhaven.com" target="_blank">City of Winter Haven</a></li>
<li><a href="http://www.winterhavenchamber.com" target="blank">Greater Winter Haven Chamber of Commerce</a></li>
<li><a href="http://www.polk.edu" target="_blank">Polk State College</a></li>
</ul>

<a name="sarasota"></a>
<h3>North Port-Bradenton-Sarasota MSA</h3>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/sarasota-2.jpg" title="Sarasota, Florida"  style="border: 1px solid #949494;"/>
<p>Consisting of Manatee and Sarasota Counties, the Sarasota area is home to over 700,000 residents.</p>
<h4>North Port</h4>
<p>Originally a planned community, North Port Charlotte was incorporated in 1959. The name was shortened to "North Port" in 1974 by popular referendum. The city of over 50,000 is large, containing around seventy-five square miles of territory.</p>
<p>Primarily a bedroom community, North Port''s economy is driven by services including health care and education.</p>
<p>The city hosts the North Port Instructional Site of the University of South Florida Sarasota-Manatee.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.cityofnorthport.com">City of North Port</a></li>
<li><a href="http://www.usfsm.edu/north-port">University of South Florida Sarasota-Manatee</a></li>
</ul>
<h4>Bradenton</h4>
<p>Technically incorporated in 1943, Bradenton is the merger of two cities, Manatee and Bradentown, which were incorporated in 1888 and 1903, respectively. It is the seat of Manatee County and home to around 50,000 people. Bradenton is on the southern shores of Tampa Bay and the Sunshine Skyway bridge connects it to St. Petersburg.</p>
<p>Health care is the primary motivator of Bradenton''s economy, though tourism and other services are also strong. Additionally, the facilities for producing Tropicana juice are in Bradenton. The Bealls department store was founded and is still headquartered in Bradenton (though a chain of stores from Texas with the same name forces them to use the name "Burkes" in many markets).</p>
<p>Higher education opportunities within the city are available at the State College of Florida, Manatee-Sarasota.</p>
<p><strong>Links:</p></strong>
<ul>
<li><a href="http://www.cityofbradenton.com" target="_blank">City of Bradenton</a></li>
<li><a href="http://www.mymanatee.org" target="_blank">Manatee County</a></li>
<li><a href="http://www.manateechamber.com" target="_blank">Manatee Chamber of Commerce</a></li>
<li><a href="http://www.scf.edu" target="_blank">State College of Florida, Manatee-Sarasota</a></li>
</ul>
<h4>Sarasota</h4>
<p>The origins of the word "Sarasota" are a mystery. "Zara Zote" might refer to Sara, the daughter of Spanish explorer Hernando de Soto, or it might come from a Native American phrase that refers to an easily-spotted landfall. Regardless, the name "Sarasota" was settled on by 1839, after the United States took possession of Florida. Sarasota was incorporated as a town in 1902 and is the seat of Sarasota County.</p>
<p>Two of the Ringling brothers took their circus money and invested some of it in the town, which incorporated as a city the year after they arrived, 1913. The Ringlings brought their "Greatest Show on Earth" to Sarasota in the winter and created developments. Today their estates are historic structures, and their wealth created an institute of higher learning, a museum, and other institutions that give the city a cultural life in excess of what would normally be expected for a city of just over 50,000. Sarasota hosts theaters and operas, an orchestra with the Florida West Coast Symphony, gardens, festivals, and more.</p>
<p>The strongest segment of Sarasota''s economy is health care, though it is also strong in white collar and administrative careers, as well as tourism and other services. Boar''s Head Provision Company is one company that is headquartered in the city.</p>
<p>The University of South Florida Sarasota-Manatee is located in the city. New College of Florida occupies a campus that includes the former estate of Edith and Charles Ringling. Sarasota is also home to the Ringling College of Art and Design.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.sarasotagov.com" target="_blank">City of Sarasota</a></li>
<li><a href="http://www.usfsm.edu" target"_blank">University of South Florida Sarasota-Manatee</a></li>
<li><a href="http://www.ncf.edu" target="_blank">New College of Florida</a></li>
<li><a href="http://www.ringling.edu" target="_blank">Ringling College of Art and Design</a></li>
<li><a href="http://www.boarshead.com" target="_blank">Boar''s Head</a></li>
</ul>
';

  v_text('tampa-data') := 
'<p><strong>Tampa Bay Region Quick Facts</strong></p>
<table class="datatable">
<tbody>
<tr>
<th>
County</th>
<th>
Population<br />
2012</th>
<th>
Economic Activity<br />
2007 (Millions)</th>
<th>
Population Growth<br />
2010 to 2012</th>
<th>
Median Household<br />
Income 2011</th>
<th>
Housing<br />
Units</th>
<th>
Median Home Value<br />
2007 to 2011</th>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=CITRUS">Citrus County</a></td>
<td style="text-align:right">
139,360</td>
<td style="text-align:right">
$1,515</td>
<td style="text-align:right">
-1.3%</td>
<td style="text-align:right">
$38,189</td>
<td style="text-align:right">
78,423</td>
<td style="text-align:right">
$134,800</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=HERNANDO">Hernando County</a></td>
<td style="text-align:right">
173,422</td>
<td style="text-align:right">
$2,311</td>
<td style="text-align:right">
0.4%</td>
<td style="text-align:right">
$42,700</td>
<td style="text-align:right">
84,887</td>
<td style="text-align:right">
$145,000</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=PASCO">Pasco County</a></td>
<td style="text-align:right">
470,391</td>
<td style="text-align:right">
$6,731</td>
<td style="text-align:right">
1.2%</td>
<td style="text-align:right">
$44,103</td>
<td style="text-align:right">
231,008</td>
<td style="text-align:right">
$145,100</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=HILLSBOROUGH">Hillsborough County</a></td>
<td style="text-align:right">
1,277,746</td>
<td style="text-align:right">
$48,928</td>
<td style="text-align:right">
3.9%</td>
<td style="text-align:right">
$50,195</td>
<td style="text-align:right">
540,190</td>
<td style="text-align:right">
$185,900</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=PINELLAS">Pinellas County</a></td>
<td style="text-align:right">
921,319</td>
<td style="text-align:right">
$37,192</td>
<td style="text-align:right">
0.5%</td>
<td style="text-align:right">
$45,891</td>
<td style="text-align:right">
504,146</td>
<td style="text-align:right">
$172,900</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=POLK">Polk County</a></td>
<td style="text-align:right">
616,158</td>
<td style="text-align:right">
$27,540</td>
<td style="text-align:right">
2.3%</td>
<td style="text-align:right">
$44,398</td>
<td style="text-align:right">
281,004</td>
<td style="text-align:right">
$133,200</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=MANATEE">Manatee County</a></td>
<td style="text-align:right">
333,895</td>
<td style="text-align:right">
$9,029</td>
<td style="text-align:right">
3.4%</td>
<td style="text-align:right">
$48,181</td>
<td style="text-align:right">
173,660</td>
<td style="text-align:right">
$195,300</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=SARASOTA">Sarasota County</a></td>
<td style="text-align:right">
386,147</td>
<td style="text-align:right">
$9,371</td>
<td style="text-align:right">
1.8%</td>
<td style="text-align:right">
$49,212</td>
<td style="text-align:right">
229,346</td>
<td style="text-align:right">
$213,400</td>
</tr>
<tr>
<td>
Total</td>
<td style="text-align:right">
4,318,438</td>
<td style="text-align:right">
$142,617</td>
<td style="text-align:right">
1.5%</td>
<td style="text-align:right">
$45,359</td>
<td style="text-align:right">
2,122,664</td>
<td style="text-align:right">
$165,700</td>
</tr>
</tbody>
</table>';

  v_text('east-central') :=
'<img src="https://s3.amazonaws.com/visulate.cities/704x440/melbourne_beach-4.jpg"  alt="Melbourne Beach, Florida" style="border: 1px solid #949494;"/>

<h2>East Central Florida</h2>
<img src="http://visulate.com/images/Regional-EastCentral.jpg" alt="East Central Florida" style="float: left;"/>
<p>East Central Florida is home to <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BREVARD&city=&region_id=3">Brevard</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OSCEOLA&city=&region_id=3">Osceola</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ORANGE&city=&region_id=3">Orange</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SEMINOLE&city=&region_id=3">Seminole</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAKE&city=&region_id=3">Lake</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=VOLUSIA&city=&region_id=3">Volusia</a>, and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUMTER&city=&region_id=3">Sumter</a> counties. This region contains some of the state''s most popular tourist destinations including Walt Disney World, Universal Studios, Port Canaveral, and The Kennedy Space Center. This region accounts for a significant number of the state''s technological advancements and has some of the world''s biggest companies including Boeing, Rockwell Collins, Lockheed Martin, and the headquarters of Harris Corporation. The population is approximately 3.4 million people.</p>
<div style="clear:both;"></div>
<p><strong>East Central Florida Links:</strong></p>
<ul>
<li><a href="http://www.enterpriseflorida.com/news/category/east-central-florida/" target="_blank">East Central Florida Business News</a></li>
</ul>
<p>There are three Metropolitan Statistical Areas (MSAs) in East Central Florida:</p>
<ul>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=3#daytona">Deltona-Daytona Beach-Ormond Beach MSA</a></li>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=3#orlando">Orlando-Kissimmee-Sanford MSA</a></li>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=3#space-coast">Palm Bay-Melbourne-Titusville MSA</a></li>
</ul>

<div class="video-container">
<iframe width="704" height="440" src="//www.youtube.com/embed/eCbDBj8Jwvs" frameborder="0" allowfullscreen></iframe>
</div>

<a name="daytona"></a>
<h3>Deltona-Daytona Beach-Ormond Beach MSA</h3>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/daytona_beach-4.jpg" alt="Daytona Beach" style="border: 1px solid #949494;"/>
<p>The area is essentially the same as Volusia County, which contains sixteen incorporated municipalities. It is a popular place to retire, though the region has plenty of activity. It is also a tourist destination. The hard-packed sand of Volusia County''s beaches lent itself to auto races beginning in 1903, before paved roads were common, leading to the area''s reputation for cars and racing.</p>
<p>The primary industries are in the service sector, with tourism, healthcare, and education among the most prominent. The region also boasts many small manufacturing centers, which, when added together, make a significant contribution to the county''s economy.</p>
<p>Together with Orlando, the region is the nineteenth-largest television market in the nation.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.floridabusiness.org/" target="_blank">Volusia County Division of Economic Development</a></li>
</ul>


<h4>Deltona</h4>
<p>Developed in 1962 as a planned retirement community, Deltona is now the largest city in Volusia County, numbering 85,182 residents. Primarily a bedroom community, Deltona is no longer just for retirees. The population is now younger and diverse, with over a quarter of the population being of Hispanic or Latino/a descent. Despite being two counties away, Deltona is only a thirty minute drive from Orlando.</p>
<p>Deltona hosts a campus of Daytona State College.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://westvolusiaregionalchamber.org/city-spotlight/deland/" target="_blank">West Volusia Regional Chamber of Commerce page for Deltona</a></li>
<li><a href="http://www.deltonafl.gov/" target= "_blank">Official website for the City of Deltona</a></li>
<li><a href="http://www.daytonastate.edu/" target="_blank">Daytona State College</a></li>
</ul>

<h4>Daytona Beach</h4>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/daytona_beach-6.jpg" alt="Daytona Beach" style="border: 1px solid #949494;"/>
<p>Historically an auto-racing mecca due to its geography and climate, Daytona Beach is the location of one of the single most popular sporting events in the country, the NASCAR Daytona 500, which opens the stock car racing season. NASCAR''s main headquarters are in the city. Other auto racing and motorcycle events take place throughout the year. The city is also home to the LPGA and hosts several golf courses.</p>
<p>Daytona Beach, a city of 61,005 people, is additionally served by light manufacturing concerns, especially with respect to the automotive and healthcare industries.</p>
<p>The city is home to Bethune-Cookman University, Embry-Riddle Aeronautical University, Daytona State College, and a campus of the University of Central Florida.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.daytonachamber.com" target="_blank">Daytona Beach Chamber of Commerce</a></li>
<li><a href="http://www.cookman.edu/" target="_blank">Bethune-Cookman University</a></li>
<li><a href="http://www.daytonastate.edu/" target="_blank">Daytona State College</a></li>
<li><a href="http://daytonabeach.erau.edu/" target="_blank">Embry-Riddle Aeronautical University Daytona Beach Campus</a></li>
<li><a href="http://regionalcampuses.ucf.edu/campus/daytona-beach/" target="_blank">University of Central Florida Daytona Beach</a></li>
<li><a href="http://www.nascar.com/" target="_blank">NASCAR</a></li>
<li><a href="http://www.lpga.com/" target="_blank">LPGA</a></li>
</ul>

<h4>Ormond Beach</h4>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/ormond_beach-5.jpg" alt="Ormond Beach" style="border: 1px solid #949494;"/>
<p>Known as the "Birthplace of Speed", Ormond Beach was a popular spot for those who liked fast cars after the turn of the 20th century because the hard-packed beach was ideal for going fast. That same beach had led to the development of a tourist resort by Henry Flagler. It later attracted Flagler''s former business partner John D. Rockefeller, who had a winter home in Ormond.</p>
<p>Today, Ormond Beach is home to almost 40,000 people. The largest sectors of the economy lie with retail and healthcare, but trade and manufacturing are important, with science and technology a growing part of the economy.</p>
<p>The Ormond Beach Airport Business Park and Airpark are within a free trade zone.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.ormondbeach.org/" target="_blank">Official website for the City of Ormond Beach</a></li>
<li><a href="http://www.ormondchamber.com/" target="_blank">Ormond Beach Chamber of Commerce</a></li>
<li><a href="http://www.ormondbeach.org/index.aspx?NID=195" target="_blank">Airport Business Park</a></li>
</ul>

<a name="orlando"></a>
<h3>Orlando-Kissimmee-Sanford MSA</h3>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/orlando-2.jpg" alt="Highway exit sign for Disney World" style="border: 1px solid #949494;"/>
<p>This MSA includes Lake, Orange, Osceola, and Seminole Counties. The urban population of the MSA was 1,510,516 in 2010. There are fourteen cities in Lake County, thirteen in Orange, two in Osceola, and seven in Seminole.</p>
<p>After the Civil War in the 1860s, Greater Orlando was barely-inhabitable wetlands. It took a major drainage project financed by Philadelphia businessman Hamilton Disston in the 1880s to make the land available for settlement. During and after World War II, the U.S. Air Force established several bases and training facilities in the region.</p>
<p>The most important event in the history of Greater Orlando, however, was the construction of the Walt Disney World Resort. Announced in 1965 and opened to the public in 1971, Walt Disney wanted a location with abundant available land that the residents of the east coast could visit. Not only was there ample land in central Florida, but it was inexpensive and the inland location offered some protection from hurricanes. Disney bought up wetlands using dummy corporations so that others would not catch on to his plans. Disney''s 1965 press conference announcing the construction of a new theme park came as a shock to most. Today, the 42,000-acre resort attracts over 50 million people each year. A study conducted at the behest of Disney concluded that the resort and affiliated businesses generated over $18 billion, a number that would be around 2.5% of Florida''s GDP.</p>
<p>The most important economic driver is tourism, though Greater Orlando is also known for high-tech and life science research, military production and training, and processing food that is harvested in the important agricultural regions in rural areas. Minute Maid operates a large juice flavoring plant in Apopka, for example.</p>
<p>Greater Orlando is the third-largest metropolitan area in Florida, the fifth-largest in the southeastern United States, and the 26th largest in the United States. Together with the Deltona-Daytona Beach MSA, Orlando is the nineteenth largest television market in the country.</p>
<p>Greater Orlando is served by the University of Central Florida, whose Orlando campus is the second-largest college campus in the nation by enrollment. The university benefits from its proximity to Kennedy Space Center, where it maintains a campus, enrolling many students in engineering and other fields that support space exploration.</p>

<h4>Orlando</h4>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/orlando-11.jpg" alt="Orlando" style="border: 1px solid #949494;"/>
<p>Orlando incorporated as a city in 1885 due in part to the additional land made available for settlement by Disston''s drainage efforts. In the late 19th century, Orlando was a major hub of citrus production.</p>
<p>Orlando is a major tourist destination, though it is more than just the Walt Disney World Resort. Greater Orlando is home to many amusement parks, including Universal Orlando, whose Islands of Adventure park includes a wildly popular Harry Potter-themed area. Orlando is also one of the largest destinations for conventions in the country.</p>
<p>Aside from tourism, Orlando boasts the seventh-largest research park in the nation, Central Florida Research Park, located next to the University of Central Florida, and is home to a major high-tech industry that includes the Electronic Arts studio that produces the most popular video game in the U.S., Madden NFL football. The region is also an important player in the defense industry, with many manufacturing centers devoted to military production. Additionally, it is an important military training center, counting a number of flight simulators among its offerings.</p>
<p>Orlando''s population of about a quarter-of-a-million is diverse, with over a quarter of residents identifying as Hispanic or Latino/a.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.orlando.org" target="_blank">Orlando, Inc., the Orlando area chamber of commerce</a></li>
<li><a href="http://www.ucf.edu/" target="_blank">University of Central Florida</a></li>
<li><a href="http://www.cfrp.org/" target="_blank">Central Florida Research Park</a></li>
<li><a href="https://disneyworld.disney.go.com/" target="_blank">Walt Disney World Resort</a></li>
<li><a href="https://www.universalorlando.com/" target="_blank">Universal Orlando theme park</a></li>
<li><a href="http://www.ea.com/locations/orlando" target="_blank">Electronic Arts - Orlando</a></li>
</ul>


<h4>Kissimmee</h4>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/kissimmee-2.jpg" alt="Kissimmee, Florida" style="border: 1px solid #949494;"/>
<p>The headquarters of Hamilton Disston''s drainage company, Kissimmee boomed in the 1880s. The city was an important regional steamship port, owing that status to its location on Lake Tohopekaliga. The expansion of the railroads eliminated the need for Kissimmee''s steamship industry, forcing the city to rely on agriculture and cattle ranching until Walt Disney World opened in 1971.</p>
<p>Today, Kissimmee''s economy is focused on tourism, education, and construction. The city has around 60,000 residents, over half of which identify as Hispanic or Latino/a. Kissimmee''s proximity to Orlando and the Walt Disney World Resort make it a popular destination for tourists.</p>
<p>The city hosts Johnson University Florida (formerly Johnson Bible College) and a campus of Valencia College.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.kissimmee.org/" target="_blank">Official City of Kissimmee website</a></li>
<li><a href="http://www.johnsonu.edu/" target="_blank">Johnson University Florida</a></li>
<li><a href="http://www.valenciacollege.edu" target="_blank">Valencia College</a></li>
</ul>

<h4>Sanford</h4>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/sanford-6.jpg" alt="Sanford, Florida" style="border: 1px solid #949494;"/>
<p>A port city at the intersection of Lake Monroe and the St. Johns River, Sanford was incorporated in 1877. Envisioned as a transportation center, the city''s founder, Henry S. Sanford, nicknamed it "the Gate City of South Florida". It became a hub for shipping agricultural products, which earned the city another nickname, "Celery City". During World War II, the city grew because of the presence of a naval air station. In 2012, the name "Sanford"received national attention because of the shooting death of Miami teenager Trayvon Martin in the city.</p>
<p>Sanford, a city of over 50,000, still prospers due to its coastal location, but now recreational boating occurs at marinas alongside commercial craft. The Aerosim Flight Academy is located within Orlando Sanford International Airport, the former site of Naval Air Station Sanford. Sanford''s economy is primarily driven by the service sectors and construction.</p>
<p>The main campus of Seminole State College of Florida is located at Sanford.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.sanfordfl.gov/" target="_blank">Official website of the City of Sanford</a></li>
<li><a href="http://www.sanfordchamber.com/" target="_blank">The Greater Sanford Regional Chamber of Commerce</a></li>
<li><a href="http://www.seminolestate.edu/" target="_blank">Seminole State College of Florida</a></li>
</ul>

<a name="space-coast"></a>
<h3>Palm Bay-Melbourne-Titusville MSA</h3>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/cape_canaveral-22.jpg" alt="SpaceX Launch from Cape Canaveral" style="border: 1px solid #949494;">

<p>The MSA covers the same territory as Brevard County, a region referred to as the Space Coast because of the presence of the John F. Kennedy Space Center. The center is located at Cape Canaveral and is the location from which NASA and other spacecraft takeoff. According to the 2010 Census, Brevard County is home to over half-a-million people, making it the ninth most populous county in Florida. In 2010 Kiplinger.com rated the county one of the five best places in America to retire.</p>
<p>Brevard County''s economy is primarily based on tourism, though the federal government contributes a great deal because of Kennedy Space Center, which is the largest employer in the region. Other service industries such as healthcare and education are also important contributors to the economy.</p>
<p>Kennedy Space Center is located on Merritt Island, across the intracoastal waterway from Titusville. In the 1940s the US military established a missile testing facility there because the land was largely undeveloped and the agreeable climate allowed for year-round operations. When NASA searched for a long-term base from which to launch spacecraft, they chose Merritt Island for its access to the testing facility and to nearby communities. NASA purchased over 100,000 acres, of which significant portions are managed by the U.S. Fish and Wildlife Service as a wildlife refuge, most of which are accessible to visitors.</p>
<p>Port Canaveral is a major economic force. It essentially serves as Orlando''s port and is one of the busiest for cruise departures in the state. Disney Cruise Lines operates out of Port Canaveral, as does Carnival and Royal Caribbean. The port is within one of the largest foreign trade zones in the country.</p>
<p>Brevard County was hit particularly hard by the combined effect of the recession and the closing of the shuttle program. In 2012, Brevard had the highest foreclosure rate in the nation. In 2013, the metro area was rated by RealtyTrac as the best in the country for buying because of the low prices.</p>
<p>Eastern Florida State College has four campuses in Brevard County. In addition, the University of Central Florida maintains a satellite campus in Cocoa.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://greaterpalmbaychamber.com/" target="_blank">Greater Palm Bay Chamber of Commerce</a></li>
<li><a href="http://www.portcanaveral.org/" target="_blank">Port Canaveral</a></li>
<li><a href="http://www.easternflorida.edu/" target="_blank">Eastern Florida State College</a></li>
<li><a href="https://www.kennedyspacecenter.com/" target="_blank">Kennedy Space Center</a></li>
<li><a href="http://www.fws.gov/merrittisland/" target="_blank">Merritt Island National Wildlife Refuge</a></li>
<li><a href="http://regionalcampuses.ucf.edu/campus/cocoa/" target="_blank">University of Central Florida Cocoa</a></li>
</ul>

<h4>Palm Bay</h4>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/palm_bay-3.jpg" alt="Palm Bay, Florida" style="border: 1px solid #949494;"/>
<p>The city of Palm Bay is the largest in Brevard County and is home to over 100,000 people. In 2010, Forbes rated Palm Bay as the 11th-most innovative city in the U.S. The city''s largest employer is Harris Corporation, maker of telecommunications equipment, including materials for satellites. Healthcare and other services are also strong contributors to the economy.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.palmbayflorida.org/" target="_blank">City of Palm Bay</a></li>
<li><a href="http://www.harris.com/" target="_blank">Harris Corporation</a></li>
</ul>

<h4>Melbourne</h4>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/melbourne-8.jpg" alt="Melbourne, Florida" style="border: 1px solid #949494;"/>
<p>Melbourne is an Old Florida city, containing many 19th- and early 20th-century homes. It is located about halfway between Miami and Jacksonville.</p>
<p>76,068 people called Melbourne home in 2010. The city is served by Melbourne International Airport, which is contained within a foreign trade zone. It is also the location of the Florida Institute of Technology. Tourism and healthcare are the most important economic drivers in Melbourne.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.melbourneflorida.org/" target="_blank">City of Melbourne</a></li>
<li><a href="http://www.melbourneregionalchamber.com/" target="_blank">Melbourne Regional Chamber of East Central Florida</a></li>
<li><a href="http://www.mlbair.com/EconomicOpportunities.aspx/SiteSelection/ForeignTradeZone136.aspx" target="_blank">Melbourne International Airport Foreign Trade Zone #136</a></li>
<li><a href="http://www.fit.edu/" target="_blank">Florida Institute of Technology</a></li>
</ul>

<h4>Titusville</h4>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/titusville-3.jpg" alt="Titusville, Florida" style="border: 1px solid #949494;"/>
<p>Nicknamed "Space City USA" for its proximity to Kennedy Space Center, Titusville is known as the place to go to in order to see spacecraft launches. The city''s location just across the intracoastal waterway from KSC has given the city a highly-educated workforce and experience with government aerospace contractors.</p>
<p>Titusville is home for just under 50,000 people. The space center is the most important economic engine, both in direct employment and supporting industries including tourism.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.titusville.com/" target="_blank">The City of Titusville</a></li>
<li><a href="http://www.titusville.org/" target="_blank">Titusville Chamber of Commerce</a></li>
</ul>';

  v_text('east-central-data') :=
'<p>
<strong>East Central Florida Quick Facts</strong></p>
<table class="datatable">
<tbody>
<tr>
<th>
County</th>
<th>
Population<br />
2012</th>
<th>
Economic Activity<br />
2007 (Millions)</th>
<th>
Population Growth<br />
2010 to 2012</th>
<th>
Median Household<br />
Income 2011</th>
<th>
Housing<br />
Units</th>
<th>
Median Home Value<br />
2007 to 2011</th>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=BREVARD">Brevard County</a></td>
<td style="text-align:right">
547,307</td>
<td style="text-align:right">
$16,070</td>
<td style="text-align:right">
0.7%</td>
<td style="text-align:right">
$50,068</td>
<td style="text-align:right">
270,512</td>
<td style="text-align:right">
$171,200</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=OSCEOLA">Osceola County</a></td>
<td style="text-align:right">
287,416</td>
<td style="text-align:right">
$7,448</td>
<td style="text-align:right">
7.0%</td>
<td style="text-align:right">
$46,479</td>
<td style="text-align:right">
129,830</td>
<td style="text-align:right">
$170,200</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=ORANGE">Orange County</a></td>
<td style="text-align:right">
1,202,234</td>
<td style="text-align:right">
$53,843</td>
<td style="text-align:right">
4.9%</td>
<td style="text-align:right">
$49,731</td>
<td style="text-align:right">
492,209</td>
<td style="text-align:right">
$211,100</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=SEMINOLE">Seminole County</a></td>
<td style="text-align:right">
430,838</td>
<td style="text-align:right">
$12,124</td>
<td style="text-align:right">
1.9%</td>
<td style="text-align:right">
$58,908</td>
<td style="text-align:right">
182,625</td>
<td style="text-align:right">
$225,500</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=LAKE">Lake County</a></td>
<td style="text-align:right">
303,186</td>
<td style="text-align:right">
$5,430</td>
<td style="text-align:right">
2.1%</td>
<td style="text-align:right">
$47,509</td>
<td style="text-align:right">
145,303</td>
<td style="text-align:right">
$167,900</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=VOLUSIA">Volusia County</a></td>
<td style="text-align:right">
496,950</td>
<td style="text-align:right">
$10,951</td>
<td style="text-align:right">
0.5%</td>
<td style="text-align:right">
$44,169</td>
<td style="text-align:right">
254,981</td>
<td style="text-align:right">
$172,100</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=SUMTER">Sumter County</a></td>
<td style="text-align:right">
101,620</td>
<td style="text-align:right">
$1,120</td>
<td style="text-align:right">
8.8%</td>
<td style="text-align:right">
$44,817</td>
<td style="text-align:right">
55,988</td>
<td style="text-align:right">
$186,800</td>
</tr>
<tr>
<td>
Total</td>
<td style="text-align:right">
3,369,551</td>
<td style="text-align:right">
$106,985</td>
<td style="text-align:right">
3.7%</td>
<td style="text-align:right">
$48,812</td>
<td style="text-align:right">
1,531,448</td>
<td style="text-align:right">
$186,400</td>
</tr>
</tbody>
</table>';

  v_text('northeastern') := 
'<img src="https://s3.amazonaws.com/visulate.cities/704x440/florida-north-eastern-1.jpg"  alt="Florida" style="border: 1px solid #949494;"/>
<h2>Northeastern Florida</h2>
<img src="/images/Regional-NorthEast.jpg" style="float: left;"/>
<p>
The Northeastern region of Florida includes <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAKER&city=&region_id=4">Baker</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CLAY&city=&region_id=4">Clay</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DUVAL&city=&region_id=4">Duval</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=NASSAU&city=&region_id=4">Nassau</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=PUTNAM&city=&region_id=4">Putnam</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SAINT%20JOHNS&city=&region_id=4">Saint Johns</a>, and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FLAGLER&city=&region_id=4">Flagler</a> counties. The area houses three Fortune 500 companies (CSX Corp, Fidelity National Financial Inc., and Fidelity National Information Services Inc.) and 80 other corporate, regional, and divisional headquarters. The largest city in the state, Jacksonville, is in this area and accounts for the numerous large businesses. Forbes ranked Jacksonville among the 10 best cities for finding employment in 2013. Target industries are Advanced Manufacturing, Aviation and Aerospace, Finance and Insurance Services, Headquarters, Information Technology, Life Sciences, and Logistics and Distribution</p>
<div style="clear:both;"></div>

<p><strong>Northeastern Florida Links:</strong></p>
<ul>
<li><a href="http://www.enterpriseflorida.com/news/category/northeast-florida/" target="_blank">Northeastern Florida Business News</a></li>
</ul>
<p>There are two Metropolitan Statistical Areas (MSAs) in Norteastern Florida:</p>
<ul>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=4#palm-coast">Palm Coast MSA</a></li>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=4#jacksonville">Jacksonville MSA</a></li>
</ul>

<a name="jacksonville"></a>
<h3>Jacksonville MSA</h3>

<img src="https://s3.amazonaws.com/visulate.cities/704x440/jacksonville-2.jpg" alt="Jacksonville, Florida" style="border: 1px solid #949494;"/>
<p>The Jacksonville MSA (population 821,784 in 2010) includes Baker, Clay, Duval, Nassau, and St Johns Counties. There are 4 cities in Baker, 5 in Clay, 4 in Duval, 5 in Nassau and 6 in St Johns. The population for the whole MSA is 1.3 million. The city of Jacksonville is Florida''s largest by population and the largest city in the contingent United States by area.</p>
<p>Median household income levels in the Jacksonville MSA are slightly higher than average for Florida. It has a diversified economy that is less dependent on tourism than other areas of the state. Jacksonville has one of the lowest overall costs of living in Florida and in the US with a cost of living index of 94.9 compared to a national average of 100.</p>
<h4>Jacksonville</h4>
<p>Situated along the St. Johns River where it meets the Atlantic coast, Jacksonville''s natural advantages have long been known. In 1564, the French established Fort Caroline there. The Spanish conquered the settlement the following year. Under British rule in the 18th century more people moved to the region because a road allowed ranchers to move cattle between Florida and Georgia. After the United States took possession of Florida, American settlers named the area "Jacksonville" after Andrew Jackson, who was the first governor of the Florida territory. Jacksonville incorporated as a town in 1832.</p>
<p>In the latter part of the 19th century, Jacksonville became a popular winter resort for wealthy northerners. After the Great Fire of 1901, much of the city had to be rebuilt. In response to suburban sprawl and white flight, the governments of the City of Jacksonville and Duval County merged in 1968. A local newspaper claimed that this formed the world''s largest city by area.</p>
<p>Jacksonville''s population is in excess of 800,000. Since the 1980s, Jacksonville''s growth rate has been over 10% per decade. Unlike Florida generally, the city''s Hispanic population is less 10% of the total. The percentage of African-American residents is also atypical for the state, making up almost a third of Jacksonville''s population.</p>
<p>Jacksonville''s economy is diversified, strong in healthcare, administration, tourism, and manufacturing. It is also an important center for banking and insurance. The city is a major transportation hub, featuring rail links, a port of entry that is the third-busiest in the state, an international airport, and three general aviation airports. The Port of Jacksonville directly employs 23,000 people and estimates its economic impact at almost $19 billion. The economic impact of Jacksonville International Airport is estimated by the Florida Department of Transportation at over $2.1 billion.</p>
<p>Naval Air Station Jacksonville was built just before the United States entered World War II. Located in the Westside neighborhood, NAS Jax is the third-largest navy base in the country and the largest in the southeast. It directly employs over 22,000 people and the facility estimates its economic impact at $2.1 billion. Naval Station Mayport, located at the mouth of the St. Johns, employs about 14,000.</p>
<p>The city''s status as a transportation center and the low cost of living make it attractive as a headquarters location. The city is home to three Fortune 500 companies: CSX, Fidelity National Financial and Fidelity National Information Services. There are over 80 other business with national or divisional headquarters in the city, including Fortune 1000 logistics company Landstar System, Inc., Bi-Lo Holdings, which owns the BI-LO® and Winn-Dixie supermarket chains, the Florida East Coast Railway, manufacturing concern Saft America, retailer Stein Mart and web.com.</p>
<p>Jacksonville hosts several institutions of higher learning, including the University of North Florida and private Jacksonville University. Edward Waters College is the city''s oldest college and the oldest historically-black college in the state. Florida State College at Jacksonville operates four campuses in the city. Jones College is a private school with two campuses in Jacksonville. The University of Florida Health Science Center maintains a campus in the city, as does the Florida Coastal School of Law.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.coj.net/" target="_blank">City of Jacksonville</a></li>
<li><a href="http://www.myjaxchamber.com/" target="_blank">Jacksonville Chamber of Commerce</a></li>
<li><a href="http://jaxusa.org/images/uploads/resources/JAXUSA_Corporate_Headquarters.pdf" target="_blank">JAXUSA Partnership - Corporate Headquarters</a></li>
<li><a href="http://www.cnic.navy.mil/regions/cnrse/installations/nas_jacksonville.html" target="_blank">Naval Air Station Jacksonville</a></li>
<li><a href="http://www.cnic.navy.mil/regions/cnrse/installations/ns_mayport.html" target="_blank">Naval Station Mayport</a></li>
<li><a href="http://www.unf.edu" target="_blank">University of North Florida</a></li>
<li><a href="http://www.ju.edu" target="_blank">Jacksonville University</a></li>
<li><a href="http://www.fscj.edu/" target="_blank">Florida State College at Jacksonville</a></li>
<li><a href="http://www.ewc.edu" target="_blank">Edward Waters College</a></li>
<li><a href="http://www.jones.edu" target="_blank">Jones College</a></li>
<li><a href="http://www.fcsl.edu" target="_blank">Florida Coastal School of Law</a></li>
<li><a href="http://ufhealthjax.org" target=_blank">University of Florida Health Jacksonville</a></li>
<li><a href="http://www.csx.com" target="_blank">CSX Corporation</a></li>
<li><a href="http://www.fnf.com" target="_blank">Fidelity National Financial</a></li>
<li><a href="http://www.fisglobal.com" target="_blank">Fidelity National Information Services</a></li>
<li><a href="http://www.biloholdings.com" target="_blank">Bi-Lo Holdings</a></li>
<li><a href="http://www.fecrwy.com" target="_blank">Florida East Coast Railway</a></li>
<li><a href="http://www.saftbatteries.com" target="_blank">Saft</a></li>
<li><a href="http://www.steinmart.com" target="_blank">Stein Mart, Inc.</a></li>
<li><a href="http://www.web.com" target="_blank">web.com</a></li>
</ul>
<h4>St. Augustine</h4>
<p>The oldest continually-inhabited city established by a European in the United States, St. Augustine was founded in 1565 by Spaniard Pedro Menéndez de Avilés. Now a national monument managed by the National Parks Service, the Castillo de San Marcos was completed in 1695 and guarded Spanish shipping lanes for almost a century. St. Augustine
served as the capital of East Florida until the United States took possession, which moved it to Tallahassee in 1824.</p>
<p>In the 1880s, Henry Flagler, who built his fortune with Standard Oil, arrived in St. Augustine and began purchasing and organizing the railroads, founding the Florida East Coast Railway. In St. Augustine he built two luxury hotels for those railroad passengers to stay at and enjoy the city and its weather. In the 1960s, Dr. Martin Luther King, Jr. led peaceful protests in the city aimed at integrating schools. These efforts were key in raising awareness of the need for civil rights legislation and led to the passage of the 1964 Civil Rights Act. Modern St. Augustine is a center of tourism, hosting millions of visitors annually.</p>
<p>St. Augustine is the seat of St. Johns County, one of the original counties organized in Florida. The city is home to over 12,000 and the area is inhabited by more than 60,000.</p>
<p>Tourism and healthcare drive St. Augustine''s economy. St. Augustine is a popular destination because of its history, beaches, and abundance of nearby golf courses.</p>
<p>St. Augustine''s higher education facilities include Flagler College, which occupies one of the luxury hotels built by Henry Flagler, the Ponce de León. The newest campus of St. Johns River State College is located just outside of the city. Also in the city is the Florida School for the Deaf and Blind, which provides secondary and post-secondary educations.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.ci.st-augustine.fl.us/" target="_blank">City of St. Augustine, FL</a></li>
<li><a href="http://www.co.st-johns.fl.us/" target="_blank">St. Johns County</a></li>
<li><a href="http://www.stjohnscountychamber.com/" target="_blank">St. Johns County Chamber of Commerce</a></li>
<li><a href="http://www.flagler.edu" target="_blank">Flagler College</a></li>
<li><a href="http://www.sjrstate.edu/campussac.html" target="_blank">St. Johns State College - St. Augustine Campus</a></li>
<li><a href="http://www.fsdb.k12.fl.us/" target="_blank">Florida School for the Deaf and the Blind</a></li>
</ul>
<h4>Palatka</h4>
<p>The seat of Putnam County and principal city of the Palatka Micropolitan Area, Palatka is home to over 10,000. The city lies about sixty miles south of Jacksonville on the St. Johns River. A plurality of residents are African-American, and fewer than five percent identify as Hispanic.</p>
<p>Palatka has historically been an important port city, inland on the St Johns. Additionally, the city has a strong manufacturing base, including Georgia Pacific and Veritas Steel. Healthcare and tourism are also strong drivers of the city''s economy. Palatka has positioned itself as a center for eco-tourism, with proximity to many state parks, Ocala National Forest, and the Florida Trail.</p>
<p>The main campus of St. Johns River State College is located in the city.</p>
<p><strong>Links:</p></strong>
<ul>
<li><a href="http://www.putnam-fl.com/bocc/" target="_blank">Putnam County</a></li>
<li><a href="http://palatka-fl.gov/" target="_blank">Palatka, FL</a></li>
<li><a href="http://www.putnamcountychamber.com/mx/hm.asp?id=Chamber" target="_blank">Putnam County Chamber of Commerce</a></li>
<li><a href="http://www.gp.com/~/media/Corporate/GPCOM/Files/State-Fact-Sheets/florida.ashx" target="_blank">Georgia Pacific - Florida</a></li>
<li><a href="http://www.veritassteel.com/about/locations-and-facilities/">Veritas Steel locations</a></li>
<li><a href="http://www.sjrstate.edu/" target="_blank">St. Johns River State College</a></li>
<li><a href="http://www.fs.usda.gov/ocala" target="_blank">Ocala National Forest</a></li>
<li><a href="http://floridahikes.com/florida-trail" target="_blank">Florida Trail</a></li>
</ul>




<a name="palm-coast"></a>
<h3>Palm Coast MSA</h3>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/flagler_beach-1.jpg" alt="Flagler Beach" style="border: 1px solid #949494;"/>

<p>Flagler County, referred to by the U.S. Census as the Palm Coast MSA, contains almost 100,000 residents. There are five cities in the county. Flagler County was ranked the fastest-growing county in the nation by the US Census Bureau from 2000 to 2005, boasting a 53.3% increase, with a July 1, 2005 population estimate at 76,410. In 2012 it had reached an estimated 98,349.</p>
<p>Employment in Palm Coast is primarily in the service sectors, including tourism, education, and healthcare.</p>

<h4>Palm Coast</h4>
<p>Palm Coast is the principal urban center of the Palm Coast MSA and was home to 75,180 in 2010. Palm Coast is a young city and has more than doubled in population every decade since 1980. With the Atlantic Ocean, Intracoastal Waterway and 79 miles of canals, there is plenty of waterfront property in the area.</p>
<p>Palm Coast hosts a campus of Daytona State College.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.flaglerchamber.org/" target="_blank">Flagler County Chamber of Commerce</a></li>
<li><a href="http://www.flaglercountyedc.com/" target="_blank">Flagler County Department of Economic Opportunity</a></li>
<li><a href="http://www.daytonastate.edu/" target="_blank">Daytona State College</a></li>
</ul>


';

  v_text('northeastern-data') := 
'<p>
<strong>Quick Facts</strong></p>
<table class="datatable">
<tbody>
<tr>
<th>
County</th>
<th>
Population<br />
2012</th>
<th>
Economic Activity<br />
2007 (Millions)</th>
<th>
Population Growth<br />
2010 to 2012</th>
<th>
Median Household<br />
Income 2011</th>
<th>
Housing<br />
Units</th>
<th>
Median Home Value<br />
2007 to 2011</th>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=BAKER">Baker County</a></td>
<td style="text-align:right">
27,086</td>
<td style="text-align:right">
$200</td>
<td style="text-align:right">
-0.1%</td>
<td style="text-align:right">
$47,041</td>
<td style="text-align:right">
9,782</td>
<td style="text-align:right">
$142,600</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=CLAY">Clay County</a></td>
<td style="text-align:right">
194,345</td>
<td style="text-align:right">
$2,614</td>
<td style="text-align:right">
1.8%</td>
<td style="text-align:right">
$59,994</td>
<td style="text-align:right">
76,175</td>
<td style="text-align:right">
$178,900</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=DUVAL">Duval County</a></td>
<td style="text-align:right">
879,602</td>
<td style="text-align:right">
$43,464</td>
<td style="text-align:right">
1.8%</td>
<td style="text-align:right">
$49,964</td>
<td style="text-align:right">
389,434</td>
<td style="text-align:right">
$170,300</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=NASSAU">Nassau County</a></td>
<td style="text-align:right">
74,629</td>
<td style="text-align:right">
$1,614</td>
<td style="text-align:right">
1.8%</td>
<td style="text-align:right">
$58,933</td>
<td style="text-align:right">
35,286</td>
<td style="text-align:right">
$202,300</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=PUTNAM">Putnam County</a></td>
<td style="text-align:right">
73,263</td>
<td style="text-align:right">
$1,703</td>
<td style="text-align:right">
-1.5%</td>
<td style="text-align:right">
$34,174</td>
<td style="text-align:right">
37,406</td>
<td style="text-align:right">
$105,300</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=ST. JOHNS">St. Johns County</a></td>
<td style="text-align:right">
202,188</td>
<td style="text-align:right">
$3,952</td>
<td style="text-align:right">
6.4%</td>
<td style="text-align:right">
$64,153</td>
<td style="text-align:right">
91,348</td>
<td style="text-align:right">
$279,700</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=FLAGLER">Flagler County</a></td>
<td style="text-align:right">
98,359</td>
<td style="text-align:right">
$1,035</td>
<td style="text-align:right">
2.8%</td>
<td style="text-align:right">
$48,708</td>
<td style="text-align:right">
49,068</td>
<td style="text-align:right">
$201,300</td>
</tr>
<tr>
<td>
Total</td>
<td style="text-align:right">
1,549,472</td>
<td style="text-align:right">
$54,582</td>
<td style="text-align:right">
1.9%</td>
<td style="text-align:right">
$51,852</td>
<td style="text-align:right">
688,499</td>
<td style="text-align:right">
$182,914</td>
</tr>
</tbody>
</table>';

  v_text('northwest') := 
'<img src="https://s3.amazonaws.com/visulate.cities/704x440/florida-northwest-1.jpg"  alt="Florida" style="border: 1px solid #949494;"/>
<h2>Northwest Florida</h2>
<img src="/images/Regional-NorthWest.jpg" style="float: left;"/>
<p>
The northwest region of Florida borders the Gulf of Mexico and runs from Pensacola to Tallahassee. It includes <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ESCAMBIA&city=&region_id=5">Escambia</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA%20ROSA&city=&region_id=5">Santa Rosa</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKALOOSA&city=&region_id=5">Okaloosa</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WALTON&city=&region_id=5">Walton</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HOLMES&city=&region_id=5">Holmes</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JACKSON&city=&region_id=5">Jackson</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WASHINGTON&city=&region_id=5">Washington</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BAY&city=&region_id=5">Bay</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CALHOUN&city=&region_id=5">Calhoun</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LIBERTY&city=&region_id=5">Liberty</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GULF&city=&region_id=5">Gulf</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=FRANKLIN&city=&region_id=5">Franklin</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GADSDEN&city=&region_id=5">Gadsden</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEON&city=&region_id=5">Leon</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=JEFFERSON&city=&region_id=5">Jefferson</a>, and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=WAKULLA&city=&region_id=5">Wakulla</a> Counties. The target industries for the area are advanced manufacturing, aviation, aerospace, defense, health sciences, renewable energy, and transportation. The area has a population of 1.4 million and workforce greater than 700,000 people. The northwest region of Florida is attractive for all types of economic development projects, but particularly those that require access to deep water or barge facilities.</p>
<div style="clear:both;"></div>
<p><strong>Northwest Florida Links:</strong></p>
<ul>
<li><a href="http://www.enterpriseflorida.com/news/category/northwest-florida/" target="_blank">Northwest Florida Business News</a></li>
</ul>


<h3>North West Florida Metropolitan Statistical Areas</h3>
<p>A Metropolitan Statistical Areas (MSA) contains a core urban area wiht a population of 50,000 or more. Each metro area consists of one or more counties and includes the counties containing the core urban area, as well as any adjacent counties that have a high degree of social and economic integration (as measured by commuting to work) with the urban core.  There are 4 MSAs in the Northwest region:</p>
<ul>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5#pensacola">Pensacola-Ferry Pass-Brent MSA</a></li>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5#crestview">Crestview-Fort Walton-Destin MSA</a></li>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5#panama">Panama City MSA</a></li>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5#tallahassee">Tallahasse MSA</a></li>
</ul>

<a name="pensacola"></a>
<h3>Pensacola-Ferry Pass-Brent MSA</h3>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/pensacola-2.jpg"   title="Pensacola, Florida"  style="border: 1px solid #949494;"/>

<p>The core urban area in this MSA is Pensacola (51,923 in 2010).  It includes Escambia and Santa Rosa counties. There are two incorporated municipalities in Escambia County and 3 cities in Santa Rosa. Pensacola is surrounded by much smaller communities. The region has over 450,000 inhabitants.</p>
<p>Most employment is in the service sectors of education, healthcare and government. Indeed, governments rank as the top three employers by number of employees and healthcare providers make up four of the top ten.</p>
<p>This MSA is home to Naval Air Station Pensacola, recognized as the premier naval installation in the Department of the Navy, and NAS Whiting Field, one of two primary pilot training bases. The Department of Defense contributes an estimated $7.8 billion to the regional economy while directly employing over 25,000. The defense industry accounts for around 80,000 jobs.</p>
<p>Pensacola State College has campuses throughout the region, including Warrington near NAS Pensacola, Century at the northern end of Escambia County, and two in Pensacola including a downtown campus. PSC also has campuses in Santa Rosa County, including a Milton campus and the South Santa Rosa Center in Gulf Breeze.</p>
<ul>
<li><a href="http://myescambia.com/" target="_blank">Escambia County, Florida</a></li>
<li><a href="http://www.floridasgreatnorthwest.com/regional-overview/msa-information/pensacola-msa.aspx" target="_blank">
Pensacola-Ferry Pass-Brent MSA</a></li>
<li><a href="http://pensacolachamber.com/" target="_blank">Greater Pensacola Chamber</a></li>
</ul>
<h4>Pensacola</h4>
<p>The only city in Escambia County is also the county seat, Pensacola. The area was long inhabited by Native Americans, and the Spanish established a settlement in 1559, though it did not last. The failed settlement kept the Spanish away from the area until 1698, when the city of "Panzacola" was established. When the British took control in 1763, they split Florida into east and west and named Pensacola the capital of West Florida. Spain re-took West Florida in the early 1780s.</p>
<p>Pensacola was terrorized by American General Andrew Jackson throughout the 1810s. Settlers in Alabama and Mississippi wanted access to the Gulf of Mexico, so Jackson annexed territory from West Florida, which was added to those states. His occupation of Pensacola in 1819 spurred Spain to sell all of Florida to the United States in 1821.</p>
<p>Jackson used Pensacola as his capital while he was territorial governor; Tallahassee soon supplanted it for its more central location. Nonetheless, Pensacola remained an important port and tourist destination.</p>
<p>The healthcare industry is a strong driver of Pensacola''s economy. Facilities includes Baptist Hospital, the first hospital to operate emergency helicopters in the state; Sacred Heart, the first Catholic hospital in Florida and listed on the National Register of Historic Places; and West Florida Hospital, located just north of the city in Ferry Pass.</p>
<p>With 343 sunny days every year and a average annual temperature above 65 degrees Fahrenheit, Pensacola attracts many tourists looking for sun and fun. Some visit for the white sandy beaches and clear blue water, others for the historic buildings and arts & culture. The nearby state and national parks provide additional recreation opportunities. The tourism industry contributes over half-a-million dollars to the local economy.</p>
<p>The Pensacola area is home to several military bases with a focus on air and sea. Located southwest of the city proper, the land that Naval Air Station Pensacola occupies has a long history as a military base, dating back to the 1698 Spanish settlement. Established as a naval air station in 1914, the base was the only one of its kind when the United States entered World War I. NAS Pensacola is still the principal initial training facility for naval aviators serving in the Navy, Marine Corps, and Coast Guard. It is also the home base for the Blue Angels.</p>
<p>The Port of Pensacola features an Enterprise Zone, which includes state and local tax incentives, and a Foreign Trade Zone, which allows for the deferral of or exemption from the customs process, including duties. The 50-acre facility features eight deepwater-draft docking berths. Warehouses and a CSX rail link are also features of the port.</p>
<p>Pensacola International Airport is the westernmost airport that handles commercial jet traffic in the state. It airport is owned and operated by the city. The airport handles around 770,000 passengers. It claims an economic impact over $550 billion and supports almost 6,000 jobs. The airport is within the same Foreign Trade Zone as the port.</p>
<p>A 2012 Texas A&M study of 498 urban areas in the U.S. found that Pensacola had the shortest average highway commute time.</p>
<p>Companies headquartered in Pensacola include boatmaker Caribiana Sea Skiffs and All Pro Sound, which installs permanent sound and lighting systems across the country.</p>
<p>The University of West Florida is located in Ferry Pass and has an enrollment of over 12,000 students. The university benefits from its location in that many military personnel stationed in the area attend part-time. Pensacola State College, formerly Pensacola Junior College, offers four-year degrees in nursing and applied sciences. Troy University maintains a campus just west of the city.</p>
<p><b>Links:</b></p>
<ul>
<li><a href="http://www.cityofpensacola.com/" target="_blank"> City of Pensacola</a></li>
<li><a href="http://archive.pnj.com/section/NEWCOMERS/" target="_blank"> A Newcomer''s Guide to the Pensacola Bay Area</a></li>
<li><a href="http://www.portofpensacola.com" target="_blank"> Port of Pensacola</a></li>
<li><a href="http://www.flypensacola.com" target="_blank"> Pensacola International Airport</a></li>
<li><a href="http://www.uwf.edu" target="_blank"> University of West Florida</a></li>
<li><a href="http://www.pensacolastate.edu/" target="_blank"> Pensacola State College</a></li>
<li><a href="http://www.troy.edu/florida/pensacola.html" target="_blank"> Troy University - Pensacola</a></li>
<li><a href="http://www.blueangels.navy.mil/" target="_blank"> Blue Angels</a></li>
<li><a href="http://www.caribiana.com/" target="_blank"> Caribiana Sea Skiffs</a></li>
<li><a href="http://www.allprosound.com/" target="_blank"> All Pro Sound</a></li>
</ul>


<a name="crestview"></a>
<h3>Crestview-Fort Walton-Destin MSA</h3>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/fort_walton_beach-1.jpg"   title="Fort Walton Beach, Florida"  style="border: 1px solid #949494;"/>
<p>The core urban areas are Crestview, Fort Walton and Destin, which had a combined total population of 52,790 in 2010 and includes Okaloosa and Walton Counties. There are nine incorporated municipalities in Okaloosa and three in Walton. This is the third-fastest growing MSA in the nation.</p>
<p>This MSA is home to Eglin Air force base geographically the US Air Forces largest base. Hurlburt Field Airforce Installation is also part of this complex. Duke Field also known as Eglin AFB Auxiliary Field #3, is a military airport located three miles (5 km) south of the central business district of Crestview.</p>
<p>The defense industry has a significant presence in Okaloosa. Seven of the ten largest contractors in Florida are in the county. The industry contributes $6.6 billion to the local economy and employs 21,000 people, sustaining 350 companies.</p>
<p>Forbes ranked the area as the 94th best small place for business and careers, including a ranking of number 42 in the nation for education.</p>
<p>Northwest Florida Regional Airport is located at Eglin AFB, so it only allows commercial flights; no private airplanes are permitted. The airport shares runways with the military. Major carriers and their regional affiliates service the airport and its approximately 375,000 annual passengers. It is situated between Fort Walton Beach and Valparaiso. The Florida Department of Transportation estimates the airport''s economic impact at over $466 million and credit it with being responsible for over 5,000 jobs.</p>
<p>Northwest Florida State College operates five campuses in Okaloosa County and two in Walton. Its main campus is in Niceville. The school offers five bachelor''s degree programs, including nursing and education. It specializes in technical associate''s degrees.</p>

<p><b>Links:</b></p>
<ul>
<li><a href="http://www.floridasgreatnorthwest.com/regional-overview/msa-information/fort-walton-msa.aspx" target="_blank">
Crest view-Fort Walton-Destin MSA</a></li>

<li><a href="http://www.florida-edc.org/" target="_blank"> Economic Development Council of Okaloosa County</a></li>
<li><a href="http://www.eglin.af.mil/" target="_blank"> Eglin Air Force Base</a></li>
<li><a href="http://www.emeraldcoastfl.com/" target="_blank"> The Emerald Coast Convention and Visitors Bureau</a></li>
<li><a href="http://www.nwfsc.edu/" target="_blank"> Northwest Florida State College</a></li>
<li><a href="http://www.flyvps.com" target="_blank"> Northwest Florida Regional Airport</a></li>
</ul>

<h4>Crestview</h4>
<p>The city of Crestview is home to over 21,000 and is the seat of Okaloosa County. Its name comes from its location on the summit of a woodland range overlooking two rivers. The "Hub City" is at the confluence of Interstate 10 with U.S. Highway 90 and State Road 85, along with the CSX Railroad, and the Yellow and Shoal Rivers.</p>
<p>Three miles outside of downtown lies the Bob Sikes Airport, a general aviation facility. The airport can handle large military transport planes and serves the area''s general aviation needs. The Air Force and Navy use the facility for flight training. It has an 8,000-foot runway and a 64,000-sq. ft. hangar. The airport contributes more than $13 million to the local economy and employs more than 125 people.</p>
<p>The strongest driver of the economy is the healthcare sector, with tourism also an important contributor. North Florida Medical Centers operates twelve health centers in the region. The North Okaloosa Medical Center is also located within city limits.</p>
<p>Crestview is one of the fastest-growing cities in the state, with a growth rate over 40% since 1990.  Northwest Florida State College has a campus in the city named the Robert LF Sikes Center.</p>
<p><b>Links:</b></p>
<ul>
<li><a href="http://www.cityofcrestview.org/" target="_blank"> City of Crestview</a></li>
<li><a href="http://www.crestviewchamber.com/" target="_blank"> Crestview Area Chamber</a></li>
<li><a href="http://www.flycew.com/" target="_blank"> Bob Sikes Airport</a></li>
<li><a href="http://www.nfmc.org/" target="_blank"> North Florida Medical Centers, Inc.</a></li>
<li><a href="http://www.northokaloosa.com/north-okaloosa-medical-center/home.aspx" target="_blank"> North Okaloosa Medical Center</a></li>
</ul>
<h4>Fort Walton Beach</h4>
<p>In 1861, a unit of Confederate volunteers known as the Walton Guard made camp in what is today downtown Fort Walton Beach. Named for the county the area was then a part of, Camp Walton appeared on maps as a settlement in the 1910s. The name was changed to Fort Walton in 1932 and incorporated in 1941. The name was finally changed to its current form when the city annexed Tower Beach in 1953. The city has had a population around 20,000 since 1970.</p>
<p>The economy of the city is strong in administrative support and the services, including tourism. Fort Walton Beach caters to the family audience with its white sand beaches, museums, aquariums, and parks. Visitors can also take advantage of the multiple golf courses, including both public and championship-level ones, and the city''s proximity to the gulf for fishing, surfing, and other maritime recreation.</p>
<p>The single largest employer is Eglin Air Force Base, which is northeast of the city, followed by Hurlburt Field, located immediately to the west. Both are large U.S. Air Force bases. Hurlburt is home to the Air Force Special Operations Command.</p>
<p>Northwest Florida State College has a campus in the city and one on each of the two bases in the area. Troy University also has a campus in the city and one on each Air Force base to serve students in the military.</p>
<p><b>Links:</b></p>
<ul>
<li><a href="http://fwb.org/" target="_blank"> City of Fort Walton Beach</a></li>
<li><a href="http://www.hurlburt.af.mil/" target="_blank"> Hurlburt Field</a></li>
<li><a href="http://www.troy.edu/united-states/florida-landing-page.html" target="_blank">Troy University - Florida</a></li>
</ul>

<h4>Destin</h4>
<p>Once a small fishing village, Destin''s location on Florida''s Gulf Coast has made it a tourist destination. Located at the western end of a peninsula that was once a barrier island, the city borders Choctawhatchee Bay on the north with the gulf to the south and west, where East Pass connects the gulf and bay. The city of over 12,000 incorporated in 1984. In 2011, Good Morning America honored Destin by naming it one of the ten most beautiful places to live and Forbes called it one of the ten most recession-proof cities.</p>
<p>The city''s economy is strongest in administrative support and services, especially tourism. The city sees about 3.6 million visitors each year. Nicknamed the “world''s luckiest fishing village” for the abundance of edible sea life nearby, Destin is a premier destination for fishing. The city also boasts of golf courses, white sand beaches, and plentiful dining and shopping.</p>
<p>Coleman Kelly Field at the Destin Airport serves the community''s general aviation needs.</p>

<p><b>Links:</b></p>
<ul>
<li><a href="http://www.cityofdestin.com/" target="_blank"> City of Destin</a></li>
<li><a href="http://www.destinchamber.com/" target="_blank"> Destin Area Chamber of Commerce</a></li>
<li><a href="http://www.flydts.com/" target="_blank"> Destin Airport</a></li>
</ul>


<a name="panama"></a>
<h3>Panama City MSA</h3>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/panama_city-3.jpg"   title="Panama City, Florida"  style="border: 1px solid #949494;"/>
<p>The core urban areas are Panama City, Lynn Haven and Panama City Beach, with a total population of 66,995 in 2010 and includes Bay and Gulf counties. There are 6 cities in Bay and 1 in Gulf. The region has a total population of over 180,000.</p>
<p>This MSA is home to Tyndall Air force base headquarters to the Continental U.S. North American Aerospace Defense Command Region, which has the sole responsibility for ensuring the air sovereignty and air defense for the continental United States, U.S. Virgin Islands and Puerto Rico.</p>
<p>The Panama City region is a popular tourist destination. Skin Diver Magazine called the area the "Wreck Diving Capital of the Southeast".</p>

<ul>
<li><a href="http://www.floridasgreatnorthwest.com/regional-overview/msa-information/panama-city-msa.aspx" target="_blank">
Panama City MSA</a></li>
</ul>
<h4>Panama City</h4>
<p>With a population over 36,000, Panama City is the most populous city in the region. Originally called Harrison, the name of the Bay County seat was changed to take advantage of media attention surrounding the construction of the Panama Canal. Settlement began in the 1820s, and the city quickly earned a reputation as a tourist destination. During the American Civil War, the city was an important source of salt for Confederate troops, which led to Union troops destroying it in 1863. By the end of the nineteenth century, the city was again doing well. The main industries were salt harvesting, boat manufacturing, and fishing.</p>
<p>The city is located at the confluence of three bays (North, Saint Andrew, and East), with barrier islands separating them from the Gulf of Mexico.</p>
<p>Healthcare is a strong driver of the city''s economy, as are administrative support and tourism.  Bay Medical Center is recognized as a high-quality hospital by U.S. News and World Report. Gulf Coast Regional Medical Center is also located in the city.</p>
<p>Twelve miles east of the city lies Tyndall Air Force Base, home to around 3,000 people. The base was established at the start of World War II and was the site of actor Clark Gable''s training. Today, Tyndall is an active base, home to the 325th Fighter Wing with responsibility for training all F-22 pilots. The base is the largest employer in Bay County.</p>
<p>Northwest Florida Beaches International Airport is northwest of the city. Opened in 2010, it was the first major airport constructed in the U.S. since the 9/11 terrorist attacks. The airport is served by major air carriers and has a facility for general aviation.</p>
<p>Gulf Coast State College is located on the west end of the city. With an enrollment over 6,000, the college offers associate''s and bachelor''s degrees. Florida State University maintains a campus just to the north of GCSC with an enrollment around 1,500. Additionally, Troy University operates campuses in Panama City and on Tyndall AFB.</p>

<p><b>Links:</b></p>
<ul>
<li><a href="http://www.pcgov.org" target="_blank"> Panama City, Florida</a></li>
<li><a href="http://www.tyndall.af.mil/" target="_blank"> Tyndall Air Force Base</a></li>
<li><a href="http://www.iflybeaches.com/" target="_blank"> Northwest Florida Beaches International Airport</a></li>
<li><a href="http://www.gulfcoast.edu" target="_blank"> Gulf Coast State College</a></li>
<li><a href="http://www.troy.edu/florida/panama-citytyndall-afb.html" target="_blank"> Troy University - Panama City / Tyndall AFB</a></li>
<li><a href="http://www.pc.fsu.edu/" target="_blank"> Florida State University - Panama City</a></li>
</ul>
<h4>Panama City Beach</h4>
<p>A separate municipality from Panama City, Panama City Beach is located across the bay on the barrier island. Founded in 1936, the city''s population jumped from 67 in 1970 to 2,148 in 1980. In 2010, the census tallied over 12,000 residents in the rapidly-growing city.</p>
<p>The economy is driven by the services, including tourism. The city''s 27 miles of white sand beaches attract numerous tourists each year, including Spring Breakers from the Southeast and across the country. The community sees over 100,000 visitors during this season. There are many artificial reefs off the coast that make the waters popular with fishermen and divers.</p>

<p><b>Links:</b></p>
<ul>
<li><a href="http://www.pcbgov.com/" target="_blank"> City of Panama City Beach</a></li>
<li><a href="http://www.pcbeach.org/" target="_blank"> Panama City Beach Chamber of Commerce</a></li>
<li><a href="http://pcbeachspringbreak.com/" target="_blank"> The Official Website for Panama City Beach Spring Break</a></li>
<li><a href="http://www.springbreakhq.com/" target="_blank"> Spring Break HQ</a></li>
</ul>



<a name="tallahassee"></a>
<h3>Tallahassee MSA</h3>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/tallahassee-8.jpg"   title="Tallahassee, Florida"  style="border: 1px solid #949494;"/>
<p>The core urban area is Tallahasse, which has a population of 181,376 in 2010 and includes Gadsden, Wakulla, Leon and Jefferson Counties. The area has over 350,000 inhabitants and is one of the fastest-growing metropolitan regions in the country. There are six incorporated municipalities in Gadsden, two in Wakulla, one in Leon and one in Jefferson. This MSA is home to the State Capitol, Florida State University and Florida A&M University. It is a regional center for scientific research. Life and employment is dominated by the universities and the state government, with agriculture having a more prominent role in the outlying areas.</p>
<p>Gadsden is only county in the state with a majority African-American population. Though historically an important tobacco producer, the county is famous for the amount of shares its residents own in Coca-Cola. Banker Pat Munroe of Quincy encouraged residents to invest in the company when it went public in 1919. The city has a number of "Coke millionaires".</p>
<p>Jefferson County is mostly agricultural, producing such crops as watermelons, pecans, and pears. Indeed, the annual Watermelon Festival speaks to the importance of the crop to the region. Cattle ranching is also a significant portion of the industry in Jefferson, larger than in the other three counties.</p>

<ul>
<li><a href="http://www.floridasgreatnorthwest.com/regional-overview/msa-information/tallahassee-msa.aspx" target="_blank">
Tallahasse MSA</a></li>
<li><a href="http://www.gadsdengov.net/" target="_blank"> Gadsden County</a></li>
<li><a href="http://www.gadsdencc.com/" target="_blank"> Gadsden County Chamber of Commerce</a></li>
<li><a href="http://www.jeffersoncountyfl.gov/" target="_blank"> Jefferson County</a></li>
<li><a href="http://www.monticellojeffersonfl.com/" target="_blank"> Monticello-Jefferson County Chamber of Commerce</a></li>
<li><a href="http://www.mywakulla.com/" target="_blank"> Wakulla County</a></li>
<li><a href="http://www.visitwakulla.com/" target="_blank"> Visit Wakulla</a></li>
<li><a href="http://wakullacountychamber.com/" target="_blank"> Wakulla County Chamber of Commerce</a></li>
</ul>
<h4>Tallahassee</h4>
<p>The capital of the state and seat of Leon County, Tallahassee was founded in 1824 to be the state capital because it was roughly halfway between the two centers of population at the time, Pensacola and St. Augustine, which were on opposite sides of the panhandle. In the 1860s, Florida seceded from the Union and joined the Confederacy. Tallahassee was the only Confederate state capital east of the Mississippi River not to fall to the Union during the American Civil War. A new capitol building was opened in 1977 to better serve the needs of the rapidly growing state.</p>
<p>Much of the economy is driven by the state government and the presence of two major universities. When the legislature is in session from March to May, the city bustles with activity and the population swells with legislators, lobbyists, and their respective staffs. Retail and healthcare are also important economic drivers.</p>
<p>The city is home to both Florida State University and Florida A&M. FSU is the most historic institution of higher learning in the state, able to trace its history to the West Florida Seminary, which opened in 1856. In 1905, the state consolidated the university system, resulting in the university being reorganized at the Florida Female College. With the large number of soldiers returning home after World War II taking advantage of the GI Bill''s provision for a college education, the state recognized the need to expand. Florida chose to again make the school co-educational in 1947, calling it the Florida State University. </p>
<p>FSU attracts over $200 million in research funding. The school hosts the National High Magnetic Lab, the largest and most powerful magnet laboratory in the world, which attracts grants from the National Science Foundation as well as the private sector. The university is comprised of sixteen colleges, including a law school and a medical college.</p>
<p>Florida Agricultural and Mechanical University is the largest historically-black university in the nation by enrollment. Founded in 1887, FAMU students have a history of resisting the segregation and discrimination that characterized the post-Civil War South. The school offers sixty-two bachelor''s degrees and has eleven Ph.D programs to go along with its law school and college of pharmacy. FAMU attracts over $30 million in research funding, with agriculture and health sciences being the two largest grant categories for them</p>
<p>Located in the southwestern portion of the city, Tallahassee Regional Airport is primarily served by regional carriers, with regular flights to cities such as Miami, Orlando, Tampa, Atlanta, Charlotte and Dallas/Fort Worth. In addition, the airport serves general aviation and air taxis. About 400,000 passengers use TLH for commercial travel annually. The airport generates an estimated economic impact over $350 million each year and supports around 4,000 jobs.</p>
<p>In addition to the two major public universities, Tallahassee Community College serves the metropolitan area. </p>

<p><b>Links:</b></p>
<ul>
<li><a href="https://www.talgov.com/Main/Home.aspx" target="_blank"> City of Tallahassee</a></li>
<li><a href="http://www.leoncountyfl.gov" target="_blank"> Leon County</a></li>
<li><a href="http://talchamber.com/" target="_blank"> Greater Tallahassee Chamber of Commerce</a></li>
<li><a href="http://www.capitalcitychamber.com/" target="_blank"> Capital City Chamber of Commerce</a></li>
<li><a href="http://www.visittallahassee.com/" target="_blank"> Visit Tallahassee</a></li>
<li><a href="http://www.myflorida.com" target="_blank"> State of Florida</a></li>
<li><a href="http://www.fsu.edu" target="_blank"> Florida State University</a></li>
<li><a href="http://www.famu.edu" target="_blank"> Florida A&M University</a></li>
<li><a href="http://www.talgov.com/airport/airporthome.aspx" target="_blank"> Tallahassee Regional Airport</a></li>
<li><a href="http://www.tcc.fl.edu" target="_blank"> Tallahassee Community College</a></li>
</ul>
';

  v_text('northwest-data') := 
'<p>
<strong>Northwest Florida Quick Facts</strong></p>
<table class="datatable">
<tbody>
<tr>
<th>
County</th>
<th>
Population<br />
2012</th>
<th>
Economic Activity<br />
2007 (Millions)</th>
<th>
Population Growth<br />
2010 to 2012</th>
<th>
Median Household<br />
Income 2011</th>
<th>
Housing<br />
Units</th>
<th>
Median Home Value<br />
2007 to 2011</th>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=ESCAMBIA">Escambia County</a></td>
<td style="text-align:right">
302,715</td>
<td style="text-align:right">
$8,505</td>
<td style="text-align:right">
1.7%</td>
<td style="text-align:right">
$43,707</td>
<td style="text-align:right">
136,551</td>
<td style="text-align:right">
$145,000</td>
</tr>

<tr><td><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SANTA ROSA">Santa Rosa County</a></td>
<td style="text-align:right">     158,512</td>
<td style="text-align:right">       $1,467</td>
<td style="text-align:right">  4.7%</td>
<td style="text-align:right">      $55,913</td>
<td style="text-align:right">      65,728</td>
<td style="text-align:right">     $173,400</td></tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=OKALOOSA">Okaloosa County</a></td>
<td style="text-align:right">
190,083</td>
<td style="text-align:right">
$4,417</td>
<td style="text-align:right">
5.1%</td>
<td style="text-align:right">
$54,140</td>
<td style="text-align:right">
92,394</td>
<td style="text-align:right">
$196,800</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=WALTON">Walton County</a></td>
<td style="text-align:right">
57,582</td>
<td style="text-align:right">
$1,223</td>
<td style="text-align:right">
4.6%</td>
<td style="text-align:right">
$46,926</td>
<td style="text-align:right">
45,682</td>
<td style="text-align:right">
$174,000</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=HOLMES">Holmes County</a></td>
<td style="text-align:right">
19,804</td>
<td style="text-align:right">
$81</td>
<td style="text-align:right">
-0.6%</td>
<td style="text-align:right">
$33,510</td>
<td style="text-align:right">
8,649</td>
<td style="text-align:right">
$86,800</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=JACKSON">Jackson County</a></td>
<td style="text-align:right">
48,968</td>
<td style="text-align:right">
$836</td>
<td style="text-align:right">
-1.6%</td>
<td style="text-align:right">
$39,869</td>
<td style="text-align:right">
21,011</td>
<td style="text-align:right">
$97,200</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=WASHINGTON">Washington County</a></td>
<td style="text-align:right">
24,892</td>
<td style="text-align:right">
$195</td>
<td style="text-align:right">
0.0%</td>
<td style="text-align:right">
$37,036</td>
<td style="text-align:right">
10,864</td>
<td style="text-align:right">
$96,600</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=BAY">Bay County</a></td>
<td style="text-align:right">
171,903</td>
<td style="text-align:right">
$4,852</td>
<td style="text-align:right">
1.8%</td>
<td style="text-align:right">
$48,225</td>
<td style="text-align:right">
99,828</td>
<td style="text-align:right">
$168,400</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=CALHOUN">Calhoun County</a></td>
<td style="text-align:right">
14,723</td>
<td style="text-align:right">
$74</td>
<td style="text-align:right">
0.7%</td>
<td style="text-align:right">
$31,142</td>
<td style="text-align:right">
6,069</td>
<td style="text-align:right">
$80,200</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=LIBERTY">Liberty County</a></td>
<td style="text-align:right">
8,276</td>
<td style="text-align:right">
$28</td>
<td style="text-align:right">
-1.1%</td>
<td style="text-align:right">
$40,893</td>
<td style="text-align:right">
3,362</td>
<td style="text-align:right">
$80,600</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=GULF">Gulf County</a></td>
<td style="text-align:right">
15,718</td>
<td style="text-align:right">
$95</td>
<td style="text-align:right">
-0.9%</td>
<td style="text-align:right">
$41,291</td>
<td style="text-align:right">
9,148</td>
<td style="text-align:right">
$150,600</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=FRANKLIN">Franklin County</a></td>
<td style="text-align:right">
11,686</td>
<td style="text-align:right">
$130</td>
<td style="text-align:right">
1.2%</td>
<td style="text-align:right">
$37,017</td>
<td style="text-align:right">
8,665</td>
<td style="text-align:right">
$170,100</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=GADSDEN">Gadsden County</a></td>
<td style="text-align:right">
46,528</td>
<td style="text-align:right">
$1,106</td>
<td style="text-align:right">
-2.6%</td>
<td style="text-align:right">
$33,453</td>
<td style="text-align:right">
19,561</td>
<td style="text-align:right">
$109,000</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=LEON">Leon County</a></td>
<td style="text-align:right">
283,769</td>
<td style="text-align:right">
$5,470</td>
<td style="text-align:right">
3.0%</td>
<td style="text-align:right">
$45,827</td>
<td style="text-align:right">
124,701</td>
<td style="text-align:right">
$195,300</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=JEFFERSON">Jefferson County</a></td>
<td style="text-align:right">
14,256</td>
<td style="text-align:right">
$139</td>
<td style="text-align:right">
-3.4%</td>
<td style="text-align:right">
$42,096</td>
<td style="text-align:right">
6,727</td>
<td style="text-align:right">
$125,000</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=WAKULLA">Wakulla County</a></td>
<td style="text-align:right">
30,818</td>
<td style="text-align:right">
$195</td>
<td style="text-align:right">
0.1%</td>
<td style="text-align:right">
$54,151</td>
<td style="text-align:right">
12,721</td>
<td style="text-align:right">
$136,900</td>
</tr>
<tr>
<td>
Total</td>
<td style="text-align:right">1,400,233</td>
<td style="text-align:right">$28,814</td>
<td style="text-align:right">0.8%</td>
<td style="text-align:right">$42,825</td>
<td style="text-align:right">671,661</td>
<td style="text-align:right">$136,619</td>
</tr>
</tbody>
</table>';

v_text('southwest') := 
'<img src="https://s3.amazonaws.com/visulate.cities/704x440/florida-south-west-1.jpg"  alt="Naples, Florida" style="border: 1px solid #949494;"/>
<h3>Southwest Florida</h3>
<img src="http://visulate.com/images/Regional-SouthWest.jpg" alt="Southwest Florida region" style="float: left;"/>

<p>Southwest Florida consists of <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=CHARLOTTE&city=&region_id=6">Charlotte</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEE&city=&region_id=6">Lee</a>, and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLLIER&city=&region_id=6">Collier</a> counties. This region borders the Gulf Coast and is home to over 600 technology businesses, as well as many retail, tourism and healthcare industry businesses. The population is approximately 1.1 million people. Florida Gulf Coast University was founded in this region in 1991 and has drawn new businesses to the area.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.enterpriseflorida.com/news/category/southwest-florida/" target= "_blank">Southwest Florida Business News</a></li>
</ul>
<p>Southwest Florida contains the following three Metropolitan Statistical Areas (MSAs):</p>
<ul>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=6#punta-gorda">Punta Gorda MSA</a></li>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=6#cape-coral">Cape Coral-Fort Myers MSA</a></li>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=6#naples">Naples-Marco Island MSA</a></li>
</ul>





<a name="punta-gorda"></a>
<h3>Punta Gorda MSA</h3>

<img src="http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Punta_Gorda_FL_crths01.jpg/1200px-Punta_Gorda_FL_crths01.jpg" style="width: 704px; border: 1px solid #949494;" alt="Old Charlotte County Courthouse.  Punta Gorda, Florida" />
<p><i>Old Charlotte County Courthouse.  Punta Gorda, Florida. A <a href="http://commons.wikimedia.org/wiki/User:Ebyabe/Punta_Gorda">Wikimedia Commons</a> image</i></p>
<p>Charlotte County is home to over 150,000 people. Once named "Trabue" after the city''s founder, Punta Gorda is the only incorporated municipality in the county. The city of over 15,000 serves as the county seat.</p>
<p>Phosphate was discovered along the Peace River near Punta Gorda in 1885. The rock was shipped down the river to Punta Gorda to be packed and shipped until the completion of a railroad extension to Port Boca Grande in 1905.</p>
<p>The economy''s strength lies with tourism and healthcare. The Punta Gorda Airport is three miles southeast of the city.</p>
<p>Punta Gorda is home to the Charlotte campus of Florida SouthWestern (formerly Edison) State College.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.ci.punta-gorda.fl.us/" target="_blank">City of Punta Gorda</a></li>
<li><a href="http://www.puntagordachamber.com/" target="_blank">Punta Gorda Chamber of Commerce</a></li>
<li><a href="http://www.flypgd.com/about-punta-gorda-airport/" target="_blank">Punta Gorda Airport</a></li>
<li><a href="http://www.edison.edu/charlotte" target="_blank">Charlotte Campus of Florida SouthWestern State College</a></li>
</ul>





<a name="cape-coral"></a>
<h3>Cape Coral-Fort Myers MSA</h3>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/fort_myers-2.jpg" alt="Fort Myers, Florida" />
<p>Occupying the same region as Lee County, the Cape Coral-Fort Myers MSA is home to over 615,000. Fort Myers-Naples is the 64th largest television market in the nation. Fort Myers-Naples-Marco Island is the 62nd largest radio market.</p>
<p>The area is a popular tourist destination and spring training ground for major league franchises.</p>
<p>Lee County hosts Florida Gulf Coast University, which is located near Fort Myers. FGCU also has a satellite campus in Cape Coral.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.lee-county.com/Pages/default.aspx" target="_blank">Lee County</a></li>
<li><a href="http://www.leecountychamber.com/" target="_blank">Lee County Chamber of Commerce</a></li>
<li><a href="http://www.fgcu.edu" target="_blank">Florida Gulf Coast University</a></li>
</ul>
<h5>Cape Coral</h5>
<p>A city of over 150,000, Cape Coral is the most populous city in Southwest Florida. It holds the distinction of containing the most navigable inland waterways of any city in the world at over 400 miles. The city is located on a peninsula that juts out into the southern end of Charlotte Harbor with the Caloosahatchee River making up the city''s southern border.</p>
<p>Originally a planned community mostly inhabited by retirees, Cape Coral underwent a boom in the 1990s that diversified its population.</p>
<p>Cape Coral''s economy is largely based on tourism, healthcare, and construction. The city''s population has continued to boom through the early 2010s, growing by almost 10% from 2010-2013.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.capecoral.net" target="_blank">Cape Coral</a></li>
<li><a href="http://www.capecoralchamber.com/" target="_blank">Cape Coral Chamber of Commerce</a></li>
</ul>
<h5>Fort Myers</h5>
<p>The seat of Lee County and home for over 60,000, Fort Myers is the commercial center of Lee County. Built by the United States military as an outpost during the Seminole Wars, the fort was occupied by the North and was the site of the Battle of the Fort Myers, the southernmost battle of the Civil War. Thomas Edison built a home in the city in the 1880s, then convinced his friend Henry Ford to do the same. Both homes now welcome visitors.</p>
<p>The economy of Fort Myers is driven by healthcare, tourism, and manufacturing.</p>
<p>The city hosts Florida SouthWestern (formerly Edison) State College and a campus of private Hodges University.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.cityftmyers.com" target="_blank">City of Fort Myers</a></li>
<li><a href="https://www.fortmyers.org/" target="_blank">Greater Fort Myers Chamber of Commerce</a></li>
<li><a href="http://www.edison.edu" target="_blank">Florida SouthWestern (formerly Edison) State College</a></li>
<li><a href="http://www.hodges.edu" target="_blank">Hodges University</a></li>
</ul>





<a name="naples"></a>
<h3>Naples-Marco Island MSA</h3>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/naples-1.jpg" alt="Naples, Florida" />
<p>Concurrent with the Naples-Marco Island MSA, Collier County is home for over 300,000 people. The largest county in Florida by land area, most of Collier is not available for development due to the presence of Everglades National Park and the Big Cypress National Preserve. The coastal areas feature higher concentrations of population, while more inland communities tend towards agriculture.</p>
<p>The first commercial oil well in the state was dug at Sunniland in 1943.</p>
<p>Collier County is home to a satellite campus of Florida SouthWestern State College, a campus of Hodges University, and Ave Maria University.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.colliergov.net" target="_blank">Collier County</a></li>
<li><a href="http://www.edison.edu/collier" target="_blank">Florida SouthWestern State College Collier Campus</a></li>
<li><a href="http://www.hodges.edu" target="_blank">Hodges University</a></li>
<li><a href="http://www.avemaria.edu" target="_blank">Ave Maria University</a></li>
</ul>
<h5>Naples</h5>
<p>The sixth-wealthiest city in the nation per capita, Naples is home to about 20,000 residents, about half of which are over the age of 62.</p>
<p>Though the railroad was completed to the city in 1927 and the Tamiami Trail linked it by road to Miami and Tampa in 1928, the Great Depression kept the city from beginning to grow in earnest until after World War II.</p>
<p>The economy of Naples is strong, with over 10,000 businesses in the city. Its primary drivers are tourism, healthcare, and real estate. Naples is home to Beasley Broadcast Group, Newsbank, and ASG Software Solutions. Arthrex and INgage Networks are located in the adjacent neighborhood of North Naples.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.naplesgov.com" target="_blank">Naples, FL</a></li>
<li><a href="http://www.napleschamber.org/" target="_blank">Greater Naples Chamber of Commerce</a></li>
<li><a href="http://www.asg.com" target="_blank">ASG Software Solutions</a></li>
<li><a href="http://www.bbgi.com" target="_blank">Beasley Broadcast Group, Inc.</a></li>
<li><a href="http://www.newsbank.com/" target="_blank">Newsbank</a></li>
<li><a href="http://www.arthrex.com" target="_blank">Arthrex</a></li>
<li><a href="http://www.ingagenetworks.com/Index.aspx" target="_blank">INgage Networks</a></li>
</ul>
<h5>Marco Island</h5>
<p>In the late 1890s, an archaeological expedition led by Frank Hamilton Cushing journeyed to Southwest Florida. On Marco Island, sometimes referred to as Key Marco, the expedition found tools and pottery that provided evidence of how the Calusa Indians lived before the arrival of Columbus. Many of the recovered artifacts became property of the Smithsonian Institution, including the famed "Key Marco Cat".</p>
<p>Today, Marco Island is a popular tourist destination and home to over 16,000 people. Nearly half of the population is over the age of 65. It was developed in the 1960s and incorporated in its present form in 1997. It is the only developed island of the Ten Thousand Islands.</p>
<p>The economy of Marco Island is largely driven by tourism. Visitors are attracted by the warm weather, beaches, nature, and wildlife.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.cityofmarcoisland.com" target="_blank">Marco Island</a></li>
<li><a href="http://www.marcoislandchamber.org/" target="_blank">Marco Island Chamber of Commerce</a></li>
</ul>
';

v_text('southwest-data') := 
'<p>
<strong>Southwest Florida Quick Facts</strong></p>
<table class="datatable">
<tbody>
<tr>
<th>
County</th>
<th>
Population<br />
2012</th>
<th>
Economic Activity<br />
2007 (Millions)</th>
<th>
Population Growth<br />
2010 to 2012</th>
<th>
Median Household<br />
Income 2011</th>
<th>
Housing<br />
Units</th>
<th>
Median Home Value<br />
2007 to 2011</th>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=CHARLOTTE">Charlotte County</a></td>
<td style="text-align:right">
162,449</td>
<td style="text-align:right">
$2,288</td>
<td style="text-align:right">
1.5%</td>
<td style="text-align:right">
$45,112</td>
<td style="text-align:right">
100,612</td>
<td style="text-align:right">
$166,700</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=LEE">Lee County</a></td>
<td style="text-align:right">
645,293</td>
<td style="text-align:right">
$13,839</td>
<td style="text-align:right">
4.3%</td>
<td style="text-align:right">
$49,444</td>
<td style="text-align:right">
372,117</td>
<td style="text-align:right">
$181,000</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=COLLIER">Collier County</a></td>
<td style="text-align:right">
332,427</td>
<td style="text-align:right">
$8,479</td>
<td style="text-align:right">
3.4%</td>
<td style="text-align:right">
$56,876</td>
<td style="text-align:right">
198,423</td>
<td style="text-align:right">
$317,200</td>
</tr>
<tr>
<td>
Total</td>
<td style="text-align:right">
1,140,169</td>
<td style="text-align:right">
$24,606</td>
<td style="text-align:right">
3.1%</td>
<td style="text-align:right">
$50,477</td>
<td style="text-align:right">
671,152</td>
<td style="text-align:right">
$221,633</td>
</tr>
</tbody>
</table>';

  v_text('north-central') :=
'<img src="https://s3.amazonaws.com/visulate.cities/704x440/florida-north-central-1.jpg"  alt="Florida" style="border: 1px solid #949494;"/>
<h2>North Central Florida</h2>
<img src="/images/Regional-NorthCentral.jpg" style="float: left;"/>
<p>North Central Florida includes <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MADISON&city=&region_id=7">Madison</a>, <a "href=/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HAMILTON&city=&region_id=7">Hamilton</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=TAYLOR&city=&region_id=7">Taylor</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=SUWANNEE&city=&region_id=7">Suwannee</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=UNION&city=&region_id=7">Union</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=BRADFORD&city=&region_id=7">Bradford</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LAFAYETTE&city=&region_id=7">Lafayette</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DIXIE&city=&region_id=7">Dixie</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=LEVY&city=&region_id=7">Levy</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GILCHRIST&city=&region_id=7">Gilchrist</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=ALACHUA&city=&region_id=7">Alachua</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=MARION&city=&region_id=7">Marion</a> and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=COLUMBIA&city=&region_id=7">Columbia</a> counties. Alachua County has the lowest unemployment rate in the region, which can probably be accounted to The University of Florida located in Gainesville. Target industries are healthcare services and products, biofuels and renewable energy, aviation services and products, building component design and manufacturing, and logistics & distribution.</p>
<p>
The Florida Department of Corrections operates facilities in unincorporated areas in Marion County, including the Lowell Correctional Institution and the Lowell Annex.</p>
<div style="clear:both;"></div>


<p><strong>North Central Florida Links:</strong></p>
<ul>
<li><a href="http://www.enterpriseflorida.com/news/category/north-central-florida/" target="_blank">North Central Florida Business News</a></li>
</ul>
<h3>Metropolitan Statistical Areas</h3>
<p>A Metropolitan Statistical Areas (MSA) contains a core urban area of 50,000 or more population. Each metro area consists of one or more counties and includes the counties containing the core urban area, as well as any adjacent counties that have a high degree of social and economic integration (as measured by commuting to work) with the urban core. There are 2 Metropolitan Statistical Areas (MSAs) in the North Central region:</p>
<ul>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=7#gainesville">Gainesville MSA</a></li>
<li><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=7#ocala">Ocala MSA</a></li>
</ul>

<a name="gainesville"></a>
<h3>Gainesville MSA</h3>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/gainesville-5.jpg" />
<p>The core urban area is Gainesville (population 124,354 in 2010) and includes Gilchrist and Alachua Counties. There are 2 cities in Gilchrist and 8 in Alachua. The Gainesville MSA is home to the University of Florida and much of the economy relies on Florida''s top university.</p>

<p>Outside of the city, Alachua County is one of the most important agricultural areas in the state. It is a historical center of cattle ranching and ranks among the top five in the state for livestock production, whether it''s cattle, pigs, or goats. Alachua also produces plenty of tobacco, peanuts, and corn. There are over 35,000 jobs in Alachua County''s agriculture industry.</p>

<p>Established in 1925, Gilchrist County is the youngest in Florida. The rural county has a population just over 16,000, but has expanded at a rapid rate since the 1960s. Cattle ranching is also an important industry in Gilchrist, which has the 16th-most cattle of any county in the state. Both counties produce significant quantities of blueberries, peppers, cucumbers, potatoes, and squash.</p>

<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.alachuacounty.us" target="_blank">Alachua County</a></li>
<li><a href="http://www.alachuacountyfarmbureau.com/" target="_blank"> Alachua County Farm Bureau</a></li>
<li><a href="http://www.gilchrist.fl.us/" target="_blank">Gilchrist County</a></li>
<li><a href="http://gilchristcounty.com/" target="_blank">Gilchrist County Chamber of Commerce</a></li>
</ul>

<h4>Gainesville</h4>

<p>Fortunate to be situated along the Fernandina-Cedar Key railroad, Gainesville replaced Newnansville as the economic center of the region beginning in 1854. It became the county seat in the same year. Incorporated during Reconstruction in 1869, Gainesville had become an important center of commercial shipping by the 1880s, with many agricultural products moving through the city. Manufacturing built up in the late 19th century.</p>

<p>In 1906, the state of Florida selected Gainesville as the site for the consolidated state university for white males. Originally in a rural setting, gates had to be closed at night to prevent cattle from wandering around campus. Today, Gainesville is the proverbial college town, with over a quarter of the city''s population between 20-24.</p>

<p>The University of Florida is the flagship of the State University System of Florida. It is a member of the elite Association of American Universities, an invitation-only organization that is comprised of just over 60 of the top research universities in North America. It is consistently ranked as one of the best universities in the country by such organizations as U.S. News and World Report and Forbes, as well as best value by Kiplinger''s, Fiske Guide to Colleges, and Washington Monthly.</p>

<p>UF is one of the largest universities in the nation by enrollment with around 50,000 students. The 2,000-acre campus hosts 4,000 faculty in 16 colleges. The university attracts $400 million annually in research funding and offers over 100 undergraduate degree programs and more than 200 graduate degrees. The university''s main campus employs over 14,000, making it the largest single employer in the county.</p>

<p>Much of Gainesville''s economy comes from the University of Florida and supporting businesses. The city''s strengths lie in healthcare and tourism, though information technology is growing with businesses such as MindTree and SumTotal. Tech companies are actively incubated at Innovation Square, a public-private partnership that helps start-up companies with access to office space, venture capital, and administrative support.</p>

<p>The healthcare industry includes the University of Florida''s Health Science Center and Shands Hospital, recognized by U.S. News and World Report as a top hospital. Shands operates a specialty hospital dedicated to cancer and one for children. Shands is the second largest employer in Alachua County with over 12,000 working there.</p>

<p>Gainesville boasts of many cultural activities, most of which are connected to the university, including performing arts, museums, and film. The city includes or borders many lakes, making it a popular destination for kayaking, canoeing, fishing, and snorkeling. There are also numerous parks for landlubbers to bicycle, hike, and climb trees.</p>

<p>Gainesville Regional Airport, located at the eastern edge of the city, serves the region with regularly-scheduled commercial flights and its general aviation needs. The maintenance facility for Silver Airlines is located at GRA. The airport is responsible for over 2,000 jobs and the Florida Department of Transportation estimates its impact at over $230 million.</p>

<p>In addition to the University of Florida, Santa Fe College''s main campus is in northwest Gainesville. Many Santa Fe students transfer to UF. Additionally, City College operates a campus near the downtown area.</p>

<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.cityofgainesville.org/" target="_blank">City of Gainesville</a></li>
<li><a href="http://www.gainesvillechamber.com/" target=_blank">Gainesville Area Chamber of Commerce</a></li>
<li><a href="http://www.ufl.edu" target="_blank">University of Florida</a></li>
<li><a href="http://innovationsquare.ufl.edu" target="_blank>Innovation Square</a></li>
<li><a href="https://ufhealth.org/" target="_blank">UFHealth</a></li>
<li><a href="http://cancer.ufl.edu/" target="_blank">UFHealth Cancer Center</a></li>
<li><a href="http://www.sfcollege.edu/" target="_blank">Santa Fe College</a></li>
<li><a href="http://www.citycollege.edu/locations/gainesville.cfm" target="_blank">City College - Gainesville</a></li>
<li><a href="http://www.gra-gnv.com" target="_blank" target="_blank">Gainesville Regional Airport</a></li>
<li><a href="http://www.aau.edu" target="_blank">American Association of Universities</a></li>
<li><a href="http://www.mindtree.com" target="_blank">MindTree</a></li>
<li><a href="http://www.sumtotalsystems.com" target="_blank">SumTotal</a></li>
</ul>

<h4>Lake City</h4>

<p>The Lake City Micropolitan Statistical Area, Columbia County, is technically not a part of the Gainesville MSA. Instead, Lake City is within the boundaries of the Gainesville-Lake City Combined Statistical Area (CSA). The county has a population over 67,000, while Lake City is home to more than 12,000.</p>

<p>Originally called "Alligator" by the American settlers, who took the name from a neighboring Seminole village, Lake City was incorporated in 1859. Just two years later, Florida seceded from the United States and the Civil War began. The only major battle of that war fought in Florida, the Battle of Olustee, took place about fifteen miles east of the city in 1864. Southern troops defeated the Northerners, saving the capital, Tallahassee, from capture.</p>

<p>Healthcare and services are the strongest economic forces in this area. Three of the area''s ten largest employers are healthcare providers.</p>

<p>PCS Phosphate operates a plant that produces phosphate for industrial purposes. Though the plant is in White Springs, which is in Hamilton County, the facility to transship from truck to railcar is in Lake City. PCS Phosphate is the single largest private employer in Columbia County. Their White Springs facility produces over 4 million tonnes of phosphate products.</p>

<p>Also located in Lake City is TIMCO, an aviation maintenance, repair, and overhaul (MRO) provider. Their Lake City complex includes six hangars from which they perform airframe base maintenance.</p>

<p>The Lake City Gateway Airport is managed by the city. Though there are no commercial flights, the airport handles general aviation and air taxi traffic. It also stays busy with craft going to and from the TIMCO facility. The airport also houses the U.S. Forestry Service''s only fire support base in the southeast. The airport contributes an estimated $70 million to the local economy and employs around 1,500.</p>

<p>Florida Gateway College is located next to the airport. The school has a student population around 7,000. FGC began life as the Columbia Forestry School in the 1940s, though its forestry program was dropped in 2010 due to lack of interest.</p>

<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.lcfla.com/" target="_blank">Lake City, Florida</a></li>
<li><a href="http://www.columbiacountyfla.com/" target="_blank">Columbia County, Florida</a></li>
<li><a href="http://www.lakecitychamber.com/" target="_blank">Lake City / Columbia County Chamber</a></li>
<li><a href="http://www.lcfla.com/index.php/departments/gateway-airport-klcq" target="_blank">Lake City Gateway Airport</a></li>
<li><a href="http://www.potashcorp.com/about/facilities/phosphate/white_springs/" target="_blank">PCS Phosphate - White Springs</a></li>
<li><a href="http://www.timco.aero/content/locations-timco-lake-city-florida.html" target="_blank">TIMCO - Lake City, Florida</a></li>
<li><a href="http://www.fgc.edu" target="_blank">Florida Gateway College</a></li>
</ul>
</td></tr>
<tr><td>

<a name="ocala"></a>
<h3>Ocala MSA</h3>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/ocala-6.jpg" />
<p>The core urban area is Ocala and includes Marion County, which has five incorporated municipalities and a population in excess of 330,000. This area is referred to as the horse capital of the world, with nearly 50,000 horses during the peak of the season.</p>

<p>Agriculture plays a big part in this MSA; it is the 12th largest cattle producer in the state with around 47,000 head of cattle. Much of the cattle from this area is bred and sold as calves to ranches in the western part of the nation. The annual Ocala Bull Sale is the oldest one of its kind in the country. Marion County farms produce large quantities of peanuts and hay. With over 250,000 acres dedicated to forestry, timber is also an important agricultural output.</p>

<p>Ocala-area thoroughbreds can claim many firsts, including first Florida-bred horse to win the Florida Derby and first Florida-bred horse to win the Kentucky Derby. The horse industry accounts for over 40,000 jobs and more than $2.2 billion in contributions to the local economy. No county in the United States has more horses and ponies living within its boundaries than Marion.</p>

<p>Nearly a third of Marion County residents are 62 or older.</p>

<p>The southernmost county of North Central Florida is sometimes grouped with Central Florida.</p>

<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.marioncountyfl.org/" target="_blank">Marion County</a></li>
<li><a href="http://www.mrma.net/" target="_blank">Marion Regional Manufacturers Association</a></li>
<li><a href="http://www.marioncountyfarmbureau.org/" target="_blank">Marion County Farm Bureau</a></li>
</ul>

<h4>Ocala</h4>

<p>Home to over 50,000, the population of Ocala grew more than 20% from 2000 to 2010. It is the seat of Marion County. The city lies just west of the Silver River, which is part of the St. Johns River system. Silver Springs forms the headwaters of the river and puts out almost 550 million gallons of fresh, drinkable water every year.</p>

<p>Ocala was named for a Native American settlement that was recorded by the expedition of Spanish explorer Hernando de Soto in 1539. The region was settled by Americans beginning in the 1820s and Fort King was established in 1827 to keep the Seminoles and settlers separate. When Marion County was organized in 1844, the fort served as its first courthouse.</p>

<p>Ocala was incorporated in 1846. The city that grew around the military base was quickly selected as the county seat. Steamships carrying supplies and people to points south passed through Marion County, bringing visitors to the city. The completion of a railroad line in the 1870s enlarged the population, but it was the implementation of phosphate mining in the late 1880s and early 1890s that transformed the city into a financial and industrial center.</p>

<p>Today, the economy is strong in the healthcare, manufacturing, and tourism sectors. Ocala''s manufacturing industry is large for the state, especially with respect to plastics and furniture. Lockheed Martin operates a production facility that creates items for space applications, among other products.</p>

<p>Ocala''s proximity to natural beauty makes it a popular tourist destination for outdoor activities. The city is just west of Silver Springs State Park, which was the first tourist attraction in Florida because of its clear water and glass-bottom boat tours. The city is also close to the Ocala National Forest, which features 383,000 acres of natural splendor. There are several nearby golf courses. The city itself is the cultural heart of the region and contains art galleries and museums, as well as performing arts centers.</p>

<p>On the western edge of the city limits, Ocala operates the Ocala International Airport. The airport serves the region''s general aviation needs. Though there are no regularly scheduled commercial flights, the airport serves charters, air taxis, and air cargo.</p>

<p>About ten miles northwest of the city limits is the Lowell Correctional Institution, which was the first state facility to solely house female inmates. The Lowell complex includes the Lowell Annex, which is a more secure facility and houses the state''s female death row inmates.</p>

<p>Ocala is home to the College of Central Florida, not to be confused with the University of Central Florida.</p>

<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.ocalafl.org" target="_blank">City of Ocala</a></li>
<li><a href="http://ocalacep.com/" target="_blank">Ocala / Marion County Chamber and Economic Partnership</a></li>
<li><a href="http://www.ocalafl.org/airport/" target="_blank">Ocala International Airport</a></li>
<li><a href="http://www.lockheedmartin.com/us/mfc/siteinformation/ocala.html" target="_blank">Lockheed Martin - Ocala, FL</a></li>
<li><a href="http://www.cf.edu/" target="_blank">College of Central Florida</a></li>
<li><a href="http://silversprings.com/" target="_blank">Silver Springs State Park</a></li>
<li><a href="http://www.fs.usda.gov/ocala" target="_blank">Ocala National Forest</a></li>
<li><a href="http://www.dc.state.fl.us/facilities/region3/314.html" target="_blank">Lowell Correctional Institution</a></li>
</ul>';

v_text('north-central-data') :=
'<p>
<strong>North Central Florida Quick Facts</strong></p>
<table class="datatable">
<tbody>
<tr>
<th>
County</th>
<th>
Population<br />
2012</th>
<th>
Economic Activity<br />
2007 (Millions)</th>
<th>
Population Growth<br />
2010 to 2012</th>
<th>
Median Household<br />
Income 2011</th>
<th>
Housing<br />
Units</th>
<th>
Median Price<br />
2007 to 2011</th>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=MADISON">Madison County</a></td>
<td style="text-align:right">
18,907</td>
<td style="text-align:right">
$137</td>
<td style="text-align:right">
-1.7%</td>
<td style="text-align:right">
$36,557</td>
<td style="text-align:right">
8,499</td>
<td style="text-align:right">
$94,100</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=HAMILTON">Hamilton County</a></td>
<td style="text-align:right">
14,708</td>
<td style="text-align:right">
$111</td>
<td style="text-align:right">
-0.6%</td>
<td style="text-align:right">
$36,683</td>
<td style="text-align:right">
5,830</td>
<td style="text-align:right">
$75,600</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=TAYLOR">Taylor County</a></td>
<td style="text-align:right">
22,744</td>
<td style="text-align:right">
$823</td>
<td style="text-align:right">
0.8%</td>
<td style="text-align:right">
$38,005</td>
<td style="text-align:right">
11,085</td>
<td style="text-align:right">
$89,700</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=SUWANNEE">Suwannee County</a></td>
<td style="text-align:right">
43,656</td>
<td style="text-align:right">
$494</td>
<td style="text-align:right">
5.1%</td>
<td style="text-align:right">
$37,775</td>
<td style="text-align:right">
19,417</td>
<td style="text-align:right">
$108,900</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=UNION">Union County</a></td>
<td style="text-align:right">
15,212</td>
<td style="text-align:right">
$53</td>
<td style="text-align:right">
-2.1%</td>
<td style="text-align:right">
$45,645</td>
<td style="text-align:right">
4,566</td>
<td style="text-align:right">
$113,500</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=BRADFORD">Bradford County</a></td>
<td style="text-align:right">
27,049</td>
<td style="text-align:right">
$253</td>
<td style="text-align:right">
-5.2%</td>
<td style="text-align:right">
$41,397</td>
<td style="text-align:right">
11,083</td>
<td style="text-align:right">
$121,400</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=LAFAYETTE">Lafayette County</a></td>
<td style="text-align:right">
8,804</td>
<td style="text-align:right">
$69</td>
<td style="text-align:right">
-0.7%</td>
<td style="text-align:right">
$49,713</td>
<td style="text-align:right">
3,386</td>
<td style="text-align:right">
$153,500</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=DIXIE">Dixie County</a></td>
<td style="text-align:right">
16,126</td>
<td style="text-align:right">
$57</td>
<td style="text-align:right">
-1.8%</td>
<td style="text-align:right">
$34,243</td>
<td style="text-align:right">
9,471</td>
<td style="text-align:right">
$104,400</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=LEVY">Levy County</a></td>
<td style="text-align:right">
40,025</td>
<td style="text-align:right">
$572</td>
<td style="text-align:right">
-1.9%</td>
<td style="text-align:right">
$35,920</td>
<td style="text-align:right">
20,350</td>
<td style="text-align:right">
$108,400</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=GILCHRIST">Gilchrist County</a></td>
<td style="text-align:right">
16,815</td>
<td style="text-align:right">
$63</td>
<td style="text-align:right">
-0.7%</td>
<td style="text-align:right">
$38,467</td>
<td style="text-align:right">
7,367</td>
<td style="text-align:right">
$119,600</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=ALACHUA">Alachua County</a></td>
<td style="text-align:right">
251,417</td>
<td style="text-align:right">
$3,646</td>
<td style="text-align:right">
1.6%</td>
<td style="text-align:right">
$41,373</td>
<td style="text-align:right">
113,371</td>
<td style="text-align:right">
$185,100</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=MARION">Marion County</a></td>
<td style="text-align:right">
335,125</td>
<td style="text-align:right">
$8,053</td>
<td style="text-align:right">
1.2%</td>
<td style="text-align:right">
$40,103</td>
<td style="text-align:right">
164,037</td>
<td style="text-align:right">
$142,000</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=COLUMBIA">Columbia County</a></td>
<td style="text-align:right">
67,966</td>
<td style="text-align:right">
$1,796</td>
<td style="text-align:right">
0.6%</td>
<td style="text-align:right">
$38,589</td>
<td style="text-align:right">
28,910</td>
<td style="text-align:right">
$127,100</td>
</tr>
<tr>
<td>
Total</td>
<td style="text-align:right">
878,554</td>
<td style="text-align:right">
$16,126</td>
<td style="text-align:right">
-0.4%</td>
<td style="text-align:right">
$39,575</td>
<td style="text-align:right">
407,372</td>
<td style="text-align:right">
$118,715</td>
</tr>
</tbody>
</table>';

  v_text('south-central') :=
'<img src="https://s3.amazonaws.com/visulate.cities/704x440/florida-south-central-1.jpg"  alt="Florida" style="border: 1px solid #949494;"/>
<h2>South Central Florida</h2>
<img src="/images/Regional-SouthCentral.jpg" style="float: left;"/>
<p>
South Central Florida includes <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HARDEE&city=&region_id=8">Hardee</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HIGHLANDS&city=&region_id=8">Highlands</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=OKEECHOBEE&city=&region_id=8">Okeechobee</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=DESOTO&city=&region_id=8">DeSoto</a>, <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=GLADES&city=&region_id=8">Glades</a>, and <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HENDRY&city=&region_id=8">Hendry</a> counties. Its central location makes it convenient to many large metropolitan areas. There is a large Hispanic population in this region; 50% of Hendry County''s population is Hispanic. This region has a more rural, laidback lifestyle. Agriculture is a big industry in the area. Coca-Cola recently spent 2 billion dollars to support the planting of 25,000 acres of orange trees. Cattle ranching is a major industry here, especially in Highlands and Okeechobee Counties. Lake Okeechobee is partially within this region, divided between Okeechobee, Glades, and Hendry Counties. Lake Okeechobee is the nation''s second-largest freshwater lake.
</p>
<div style="clear:both;"></div>
<p><strong>South Central Florida Links:</strong></p>
<ul>
<li><a href="http://www.enterpriseflorida.com/news/category/south-central-florida/" target="_blank">South Central Florida Business News</a></li>
</ul>
<p>South Central Florida contains the Sebring Metropolitan Statistical Area (MSA):</p>

<h3>Sebring MSA</h3>
<img src="https://s3.amazonaws.com/visulate.cities/704x440/sebring-1.jpg" alt="Sebring, Florida"/>
<p>The Sebring metropolitan area occupies the same geographical area as
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county=HIGHLANDS&city=&region_id=8">Highlands County</a>. Around 100,000 people live in the county. The region''s economy is driven by the services, especially healthcare. About one third of residents are age 65 or older.</p>
<p>Highlands County is a major center of agricultural production in Florida. It has the second-largest population of cattle herds in the state. Only neighboring Okeechobee County has more. Highlands produces the third-most oranges of any county in the state.</p>
<p>South Florida State College maintains a campus in Avon Park, a city to the north of Sebring.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.hcbcc.net/" target="_blank">Highlands County Official Website</a></li>
<li><a href="http://www.highlandsedc.com/" target="_blank">Highlands Economic Development Commission</a></li>
<li><a href="http://www.southflorida.edu/campuses/highlands" target="_blank">South Florida State College</a></li>
</ul>
<h5>Sebring</h5>
<p>The principal city of the region and seat of Highlands County, Sebring is inhabited by over 10,000 people. The city include half a dozen lakes, the largest of which is Lake Jackson. Over 9,000 acres, Lake Jackson is largely shallow and clear. Its shores are composed of sandy beaches. Swimming and boating are popular activities.</p>
<p>A few miles southeast of the city lies Sebring General Airport. The facility provides a home to general aviation craft and also hosts the Sebring International Raceway. In operation since 1950, the raceway holds Twelve Hours of Sebring, an American Le Mans Series automobile race. The event is one of the most prestigious on the endurance racing circuit.</p>
<p>The economy of Sebring is strong in the white collar professional sector. Healthcare is also a strong economic driver.</p>
<p><strong>Links:</strong></p>
<ul>
<li><a href="http://www.mysebring.com/" target="_blank">City of Sebring</a></li>
<li><a href="http://www.sebring.org/" target="_blank">The Greater Sebring Chamber of Commerce</a></li>
<li><a href="http://www.sebring-airport.com/" target="_blank"> Sebring Regional Airport</a></li>
<li><a href="http://www.sebringraceway.com/" target="_blank">Sebring International Raceway</a></li>
</ul>';

  v_text('south-central-data') :=
'<p>
<strong>South Central Florida Quick Facts</strong></p>
<table class="datatable">
<tbody>
<tr>
<th>
County</th>
<th>
Population<br />
2012</th>
<th>
Economic Activity<br />
2007 (Millions)</th>
<th>
Population Growth<br />
2010 to 2012</th>
<th>
Median Household<br />
Income 2011</th>
<th>
Housing<br />
Units</th>
<th>
Median Price<br />
2007 to 2011</th>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=HARDEE">Hardee County</a></td>
<td style="text-align:right">
27,514</td>
<td style="text-align:right">
$418</td>
<td style="text-align:right">
-0.8%</td>
<td style="text-align:right">
$38,046</td>
<td style="text-align:right">
9,599</td>
<td style="text-align:right">
$104,100</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=HIGHLANDS">Highlands County</a></td>
<td style="text-align:right">
98,128</td>
<td style="text-align:right">
$1,496</td>
<td style="text-align:right">
-0.7%</td>
<td style="text-align:right">
$34,913</td>
<td style="text-align:right">
55,276</td>
<td style="text-align:right">
$115,600</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=OKEECHOBEE">Okeechobee County</a></td>
<td style="text-align:right">
39,467</td>
<td style="text-align:right">
$563</td>
<td style="text-align:right">
-1.3%</td>
<td style="text-align:right">
$36,929</td>
<td style="text-align:right">
18,656</td>
<td style="text-align:right">
$124,300</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=DESOTO">DeSoto County</a></td>
<td style="text-align:right">
34,712</td>
<td style="text-align:right">
$305</td>
<td style="text-align:right">
-0.4%</td>
<td style="text-align:right">
$36,407</td>
<td style="text-align:right">
14,617</td>
<td style="text-align:right">
$114,900</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=GLADES">Glades County</a></td>
<td style="text-align:right">
13,107</td>
<td style="text-align:right">
$18</td>
<td style="text-align:right">
1.7%</td>
<td style="text-align:right">
$39,611</td>
<td style="text-align:right">
7,082</td>
<td style="text-align:right">
$95,200</td>
</tr>
<tr>
<td>
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=HENDRY">Hendry County</a></td>
<td style="text-align:right">
37,447</td>
<td style="text-align:right">
$595</td>
<td style="text-align:right">
-4.3%</td>
<td style="text-align:right">
$37,989</td>
<td style="text-align:right">
14,687</td>
<td style="text-align:right">
$103,400</td>
</tr>
<tr>
<td>
Total</td>
<td style="text-align:right">
250,375</td>
<td style="text-align:right">
$3,395</td>
<td style="text-align:right">
-1.0%</td>
<td style="text-align:right">
$37,316</td>
<td style="text-align:right">
119,917</td>
<td style="text-align:right">
$109,583</td>
</tr>
</tbody>
</table>';

  v_text('visulate') := 
  
   '<fieldset>
<legend>Welcome to Visulate</legend>

<img src="/images/sue_sm.png" style="border: 1px solid #949494; float: left; margin-right: 5px; "/>

<h3>Florida Real Estate</h3>
<p>My name is Sue Goldthorp, owner and co-founder of Visulate.
   Visulate is a real estate brokerage based in Merrit Island, Florida.
           We have assembled a database with details of every property in Florida.
           We can help you buy or sell real estate anywhere in Florida.


<h4>Contact us if you want to buy or sell a property in Florida:</h4>
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

  return v_text(p_name);

end get_static_text;

  procedure set_region( p_region_id in number
                      , p_county    in varchar2) is
  begin
    update rnt_cities
    set region_id = p_region_id
    where county = p_county
    and state = 'FL';
  end set_region;

  procedure gen_fl_text is
    
    v_desc        clob := empty_clob;
    v_data        clob := empty_clob;
    v_text        varchar2(32767);
    v_len         binary_integer;
    v_region_id   rnt_regions.region_id%type;
  begin
    dbms_lob.createtemporary(v_desc, TRUE);
    dbms_lob.open(v_desc, dbms_lob.lob_readwrite); 
    
    dbms_lob.createtemporary(v_data, TRUE);
    dbms_lob.open(v_data, dbms_lob.lob_readwrite); 
    
    -------------------------------------------------------------------------
    v_text := get_static_text('overview');
    v_len := length(v_text);
    if v_len > 0 then
      dbms_lob.writeappend(v_desc, v_len, v_text);
    end if;
    
    v_text := get_static_text('regions');
    v_len := length(v_text);
    if v_len > 0 then
      dbms_lob.writeappend(v_data, v_len, v_text);
    end if;

    v_text := get_static_text('region-table');
    v_len := length(v_text);
    if v_len > 0 then
      dbms_lob.writeappend(v_data, v_len, v_text);
    end if;
    
    update rnt_cities
    set description = v_desc
    ,   report_data = v_data
    where name = 'ANY'
    and state = 'FL'
    and county = 'ANY';

    dbms_lob.close(v_desc);
    dbms_lob.close(v_data);    
    
    -----------------------------------------------------------------------

    v_desc := get_static_text('southeast');
    v_data := get_static_text('southeast-data');    

    v_region_id := rnt_regions_pkg.insert_row
                       ( x_name        => 'South East'
                       , x_description => v_desc
                       , x_report_data => v_data);
                       
    set_region(v_region_id, 'INDIAN RIVER');
    set_region(v_region_id, 'ST. LUCIE');
    set_region(v_region_id, 'SAINT LUCIE');
    set_region(v_region_id, 'MARTIN');
    set_region(v_region_id, 'PALM BEACH');
    set_region(v_region_id, 'BROWARD');
    set_region(v_region_id, 'MIAMI-DADE');
    set_region(v_region_id, 'MONROE');

    ----------------------------------------------------------------------
    v_desc := get_static_text('tampa');
    v_data := get_static_text('tampa-data');
    v_len := length(v_text);

    v_region_id := rnt_regions_pkg.insert_row
                       ( x_name        => 'Tampa'
                       , x_description => v_desc
                       , x_report_data => v_data);

    set_region(v_region_id, 'CITRUS');
    set_region(v_region_id, 'HERNANDO');
    set_region(v_region_id, 'PASCO');
    set_region(v_region_id, 'HILLSBOROUGH');
    set_region(v_region_id, 'PINELLAS');
    set_region(v_region_id, 'POLK');
    set_region(v_region_id, 'MANATEE');
    set_region(v_region_id, 'SARASOTA');

    ----------------------------------------------------------------------
    v_desc := get_static_text('east-central');
    v_data := get_static_text('east-central-data');
    
    v_region_id := rnt_regions_pkg.insert_row
                       ( x_name        => 'East Central'
                       , x_description => v_desc
                       , x_report_data => v_data);

    set_region(v_region_id, 'BREVARD');
    set_region(v_region_id, 'OSCEOLA');
    set_region(v_region_id, 'ORANGE');
    set_region(v_region_id, 'SEMINOLE');
    set_region(v_region_id, 'LAKE');
    set_region(v_region_id, 'VOLUSIA');
    set_region(v_region_id, 'SUMTER');
    ----------------------------------------------------------------------
    v_desc := get_static_text('northeastern');
    v_data := get_static_text('northeastern-data');

    v_region_id := rnt_regions_pkg.insert_row
                       ( x_name        => 'North Eastern'
                       , x_description => v_desc
                       , x_report_data => v_data);

    set_region(v_region_id, 'BAKER');
    set_region(v_region_id, 'CLAY');
    set_region(v_region_id, 'DUVAL');
    set_region(v_region_id, 'NASSAU');
    set_region(v_region_id, 'PUTNAM');
    set_region(v_region_id, 'ST. JOHNS');
    set_region(v_region_id, 'SAINT JOHNS');
    set_region(v_region_id, 'FLAGLER');
    ----------------------------------------------------------------------
    v_desc := get_static_text('northwest');
    v_data := get_static_text('northwest-data');

    v_region_id := rnt_regions_pkg.insert_row
                       ( x_name        => 'North West'
                       , x_description => v_desc
                       , x_report_data => v_data);

    set_region(v_region_id, 'ESCAMBIA');
    set_region(v_region_id, 'SANTA ROSA');
    set_region(v_region_id, 'OKALOOSA');
    set_region(v_region_id, 'WALTON');
    set_region(v_region_id, 'HOLMES');
    set_region(v_region_id, 'JACKSON');
    set_region(v_region_id, 'WASHINGTON');
    set_region(v_region_id, 'BAY');
    set_region(v_region_id, 'CALHOUN');
    set_region(v_region_id, 'LIBERTY');   
    set_region(v_region_id, 'GULF');
    set_region(v_region_id, 'FRANKLIN');
    set_region(v_region_id, 'GADSDEN');
    set_region(v_region_id, 'LEON');
    set_region(v_region_id, 'JEFFERSON');
    set_region(v_region_id, 'WAKULLA');
    ----------------------------------------------------------------------
    v_desc := get_static_text('southwest');
    v_data := get_static_text('southwest-data');

    v_region_id := rnt_regions_pkg.insert_row
                       ( x_name        => 'South West'
                       , x_description => v_desc
                       , x_report_data => v_data);

    set_region(v_region_id, 'CHARLOTTE');
    set_region(v_region_id, 'LEE');
    set_region(v_region_id, 'COLLIER');
    ----------------------------------------------------------------------
    v_desc := get_static_text('north-central');
    v_data := get_static_text('north-central-data');
    
    v_region_id := rnt_regions_pkg.insert_row
                       ( x_name        => 'North Central'
                       , x_description => v_desc
                       , x_report_data => v_data);

    set_region(v_region_id, 'MADISON');
    set_region(v_region_id, 'HAMILTON');
    set_region(v_region_id, 'TAYLOR');
    set_region(v_region_id, 'SUWANNEE');
    set_region(v_region_id, 'UNION');
    set_region(v_region_id, 'BRADFORD');
    set_region(v_region_id, 'LAFAYETTE');
    set_region(v_region_id, 'DIXIE');
    set_region(v_region_id, 'LEVY');
    set_region(v_region_id, 'GILCHRIST'); 
    set_region(v_region_id, 'ALACHUA');
    set_region(v_region_id, 'MARION');
    set_region(v_region_id, 'COLUMBIA');
    ----------------------------------------------------------------------
    v_desc := get_static_text('south-central');
    v_data := get_static_text('south-central-data');
    
    v_region_id := rnt_regions_pkg.insert_row
                       ( x_name        => 'South Central'
                       , x_description => v_desc
                       , x_report_data => v_data);

    set_region(v_region_id, 'HARDEE');
    set_region(v_region_id, 'HIGHLANDS');
    set_region(v_region_id, 'OKEECHOBEE');
    set_region(v_region_id, 'DESOTO');
    set_region(v_region_id, 'GLADES');
    set_region(v_region_id, 'HENDRY');
    ------------------------------------------------------------------------

  end gen_fl_text;
  
  procedure update_descriptions is
    v_text  varchar2(32767);
  begin
    v_text := get_static_text('overview');
    update rnt_cities
    set description = v_text
    where name = 'ANY'
    and state = 'FL'
    and county = 'ANY';

    v_text := get_static_text('regions')||get_static_text('region-table');
    update rnt_cities
    set report_data = v_text
    where name = 'ANY'
    and state = 'FL'
    and county = 'ANY';
  
    v_text := get_static_text('east-central');
    update rnt_regions
    set description = v_text
    where name='East Central';

    v_text := get_static_text('north-central');
    update rnt_regions
    set description = v_text
    where name='North Central';

    v_text := get_static_text('northeastern');
    update rnt_regions
    set description = v_text
    where name='North Eastern';


    v_text := get_static_text('northwest');
    update rnt_regions
    set description = v_text
    where name='North West';

    v_text := get_static_text('south-central');
    update rnt_regions
    set description = v_text
    where name='South Central';

    v_text := get_static_text('southeast');
    update rnt_regions
    set description = v_text
    where name='South East';

    v_text := get_static_text('southwest');
    update rnt_regions
    set description = v_text
    where name='South West';

    v_text := get_static_text('tampa');
    update rnt_regions
    set description = v_text
    where name='Tampa';

    
  
  end update_descriptions;
  
begin
--  gen_fl_text;
  update_descriptions;
end;
/  




