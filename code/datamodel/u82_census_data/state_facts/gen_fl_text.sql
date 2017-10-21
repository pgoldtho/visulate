set define ^
declare
  type cou_list_type is table of number;
  type text_list_type is table of varchar2(32767) index by varchar2(64);
  
  function get_static_text(p_name in varchar2)  return varchar2 is
    v_text    text_list_type;
  begin
   v_text('overview') := 
'<h1>
	Florida Economy and Real Estate Market</h1>
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
	<img src="http://www.eflorida.com/images/Regional-Navigation-Map.jpg" /></p>
<ul>
	<li>
		<strong>Southeast Florida</strong> contains Indian River, St. Lucie, Martin, Palm Beach, Broward, Dade, and Monroe counties. &nbsp;</li>
	<li>
		<strong>The Tampa Bay region</strong> is home to Citrus, Hernando, Pasco, Hillsborough, Pinellas, Polk, Manatee, and Sarasota counties. &nbsp;</li>
	<li>
		<strong>East Central Florida </strong>is home to Brevard, Osceola, Orange, Seminole, Lake, Volusia, and Sumter counties. &nbsp;</li>
	<li>
		<strong>The Northeastern region </strong>of Florida includes Baker, Clay, Duval, Nassau, Putnam, Saint Johns, and Flagler counties. &nbsp;</li>
	<li>
		<strong>The Northwest region </strong>of Florida borders the Gulf of Mexico and runs from Pensacola to Tallahassee. It includes Escambia, Santa Rosa, Okaloosa, Walton, Holmes, Jackson, Washington, Bay, Calhoun, Liberty, Gulf, Franklin, Gadsden, Leon, Jefferson, and Wakulla Counties. &nbsp;</li>
	<li>
		<strong>Southwest Florida </strong>consists of Charlotte, Lee, and Collier counties.</li>
	<li>
		<strong>North Central Florida</strong> includes Madison, Hamilton, Taylor, Suwannee, Union, Bradford, Lafayette, Dixie, Levy, Gilchrist, Alachua, Marion and Columbia counties</li>
	<li>
		<strong>South Central Florida</strong> includes Hardee, Highlands, Okeechobee, DeSoto, Glades, and Hendry counties.</li>
</ul>
<p>	
The following table shows the population, economic activity, population growth, mean household income, number of housing units, and median home value among the different regions. These numbers come from the United States Census Bureau.</p>
<p>Population describes all persons who are "usually resident" in a specified geographic area. Economic activity is a sum of the region''s manufacturer shipments, merchant wholesaler sales, retail sales, and accommodation and food sales. This number gives an idea of the size of the economy and a basis for comparison. The population growth value shows the difference between the 2012 population estimate and the 2010 population estimate. This number can be used to determine how many people are moving in or out of an area and therefore what the future demand for real estate may be. </p>
<p>Median household income includes the income of the householder and all other individuals over 15 years old in the household. This figure represents the average income of residents and gives insight to the amount of wealth in an area. The "housing units" includes houses, apartments, mobile homes, group of rooms, or single room that is occupied as separate living quarters. Median home value shows the average value of residential properties. This figure, again, provides insight to the wealth of the residents.</p>';
   v_text('region-table') := 	
'<table class="datatable">
	<tbody>
		<tr>
			<th>
				Region</th>
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
				Southeast Florida</td>
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
			<td>
				Tampa Bay Region</td>
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
			<td>
				East Central Florida</td>
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
			<td>
				Northeastern Florida</td>
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
			<td>
				Northwest Florida</td>
			<td style="text-align:right">1,400,233</td>
			<td style="text-align:right">$28,814</td>
			<td style="text-align:right">0.8%</td>
			<td style="text-align:right">$42,825</td>
			<td style="text-align:right">671,661</td>
			<td style="text-align:right">$136,619</td>
		</tr>
		
		<tr>
			<td>
				South West Florida</td>
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
			<td>
				North Central Florida</td>
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
			<td>
				South Central Florida</td>
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
'<h3>
<strong>Southeast Florida</strong></h3>
<table class="layouttable">
<tr><td>	
<p>
Southeast Florida contains Indian River, St. Lucie, Martin, Palm Beach, Broward, Dade, and Monroe counties. This is one of the most densely populated and developed areas of the state and the Miami metropolitan area is the fourth largest urban area in the country. </p>
<p>
Miami is the area&rsquo;s biggest city and acts as popular tourist destination as well as provides easy access to international markets in Latin America. This region has one of the highest inventories of foreclosed homes, which could lead to a decline in house prices in the future. Network Access Point, the AMPATH network, and many other internet related companies are all found in this region, making it one of the major telecom hubs in the world.</p>
<p><strong>Enterprise Florida Links:</strong></p>
<ul>
<li><a href="http://www.eflorida.com/FloridasRegionsSubpage.aspx?id=280 target="_blank">Southeast Florida Business News</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=55&Display=all" target="_blank">Indian River County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=36&Display=all" target="_blank">St. Lucie County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=67&Display=all" target="_blank">Martin County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=31&Display=all" target="_blank">Palm Beach County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=6&Display=all" target="_blank">Broward County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=37&Display=all" target="_blank">Miami-Dade County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=25&Display=all" target="_blank">Monroe County</a></li>
</ul>

</td><td>
<img src="http://www.eflorida.com/images/Regional-SouthEast.jpg" />	
</td></tr>
</table>

	<strong>Southeast Florida Quick Facts</strong></p>
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
				<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=INDIAN RIVER">Indian River County</a></td>
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
			<td>
				<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=ST. LUCIE">St. Lucie County</a></td>
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
			<td>
				<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=MARTIN">Martin County</a></td>
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
			<td>
				<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=PALM BEACH">Palm Beach County</a></td>
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
			<td>
				<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=BROWARD">Broward County</a></td>
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
			<td>
				<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=MIAMI-DADE">Miami-Dade County</a></td>
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
			<td>
				<a href="/rental/visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county=MONROE">Monroe County</a></td>
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
			<td>
				Total</td>
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
'<h3>
	<strong>Tampa Bay Region</strong></h3>
	
<table class="layouttable">
<tr><td>
<p>
The Tampa Bay region is home to Citrus, Hernando, Pasco, Hillsborough, Pinellas, Polk, Manatee, and Sarasota counties. This region is the 14<sup>th</sup> largest consumer market in the country and one in four of Florida&#39;s business and information services firms resides in Tampa Bay. The key industries of the region are applied medicine and human performance; business, financial &amp; data services; high-tech electronics and instruments; and marine and environmental activities.</p>
<p><strong>Enterprise Florida Links:</strong></p>
<ul>
<li><a href="http://www.eflorida.com/FloridasRegionsSubpage.aspx?id=800" target="_blank">Tampa Bay Region Business News</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=14&Display=all" target="_blank">Sarasota County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=65&Display=all" target="_blank">Manatee County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=34&Display=all" target="_blank">Polk County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=54&Display=all" target="_blank">Hillsborough County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=33&Display=all" target="_blank">Pinellas County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=32&Display=all" target="_blank">Pasco County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=51&Display=all" target="_blank">Hernando County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=9&Display=all" target="_blank">Citrus County</a></li>
</ul>


</td><td>
<img src="http://www.eflorida.com/images/Regional-Tampbay.jpg" />	
</td></tr>
</table>
	
<p>
	<strong>Tampa Bay Region Quick Facts</strong></p>
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
'<h3>
	<strong>East Central Florida</strong></h3>
<table class="layouttable">
<tr><td>
<p>
East Central Florida is home to Brevard, Osceola, Orange, Seminole, Lake, Volusia, and Sumter counties. This region contains some of the state&rsquo;s most popular tourist destinations including Walt Disney World, Universal Studios, Port Canaveral, and The Kennedy Space Center. This region accounts for a significant number of the state&rsquo;s technological advancements and has some of the world&rsquo;s biggest companies including Boeing, Rockwell Collins, Lockheed Martin, and the headquarters of Harris Corporation. The population is approximately 3.4 million people.</p>
<p><strong>Enterprise Florida Links:</strong></p>
<ul>
<li><a href="http://www.eflorida.com/FloridasRegionsSubpage.aspx?id=258" target="_blank">East Central Florida Business News</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=5&Display=all"   target="_blank">Brevard County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=30&Display=all"  target="_blank">Osceola County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=29&Display=all"  target="_blank">Orange County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=59&Display=all"  target="_blank">Lake County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=16&Display=all"  target="_blank">Sumter County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=15&Display=all"  target="_blank">Seminole County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=20&Display=all"  target="_blank">Volusia County</a></li>
</ul>

</td><td>
<img src="http://www.eflorida.com/images/Regional-EastCentral.jpg " />	
</td></tr>
</table>	
	
<p>
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
'<h3>
<strong>Northeastern Florida&nbsp; </strong></h3>
<table class="layouttable">
<tr><td>
<p>
The Northeastern region of Florida includes Baker, Clay, Duval, Nassau, Putnam, Saint Johns, and Flagler counties. The area houses three Fortune 500 companies (CSX Corp, Fidelity National Financial Inc., and Fidelity National Information Services Inc.) and 80 other corporate, regional, and divisional headquarters. The largest city in the state, Jacksonville, is in this area and accounts for the numerous large businesses. Forbes ranked Jacksonville among the 10 best cities for finding employment in 2013. Target industries are Advanced Manufacturing, Aviation and Aerospace, Finance and Insurance Services, Headquarters, Information Technology, Life Sciences, and Logistics and Distribution</p>

<p><strong>Enterprise Florida Links:</strong></p>
<ul>
<li><a href="http://www.eflorida.com/FloridasRegionsSubpage.aspx?id=252" target="_blank">Northeastern Florida Business News</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=42&Display=all" target="_blank">Flagler County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=35&Display=all" target="_blank">Putnam County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=24&Display=all" target="_blank">St. Johns County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=11&Display=all" target="_blank">Clay County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=40&Display=all" target="_blank">Duval County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=26&Display=all" target="_blank">Nassau County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=2&Display=all" target="_blank">Baker County</a></li>
</ul>

</td><td>
<img src="http://www.eflorida.com/images/Regional-NorthEast.jpg" />	
</td></tr>
</table>	
	
<p>
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
'<h3>
<strong>Northwest Florida</strong></h3>
<table class="layouttable">
<tr><td>
<p>
The northwest region of Florida borders the Gulf of Mexico and runs from Pensacola to Tallahassee. It includes Escambia, Santa Rosa, Okaloosa, Walton, Holmes, Jackson, Washington, Bay, Calhoun, Liberty, Gulf, Franklin, Gadsden, Leon, Jefferson, and Wakulla Counties. The target industries for the area are advanced manufacturing, aviation, aerospace, defense, health sciences, renewable energy, and transportation. The area has a population of 1.4 million and workforce greater than 700,000 people. The northwest region of Florida is attractive for all types of economic development projects, but particularly those that require access to deep water or barge facilities.</p>

<p><strong>Enterprise Florida Links:</strong></p>
<ul>
<li><a href="http://www.eflorida.com/FloridasRegionsSubpage.aspx?id=242" target="_blank">Northwest Florida Business News</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=43&Display=all" target="_blank">Franklin County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=47&Display=all" target="_blank">Gulf County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=41&Display=all" target="_blank">Escambia County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=13&Display=all" target="_blank">Santa Rosa County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=27&Display=all" target="_blank">Okaloosa County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=22&Display=all" target="_blank">Walton County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=53&Display=all" target="_blank">Holmes County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=56&Display=all" target="_blank">Jackson County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=23&Display=all" target="_blank">Washington County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=7&Display=all" target="_blank">Calhoun County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=3&Display=all" target="_blank">Bay County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=44&Display=all" target="_blank">Gadsden County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=57&Display=all" target="_blank">Jefferson County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=21&Display=all" target="_blank">Wakulla County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=63&Display=all" target="_blank">Liberty County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=61&Display=all" target="_blank">Leon County</a></li>
</ul>
</td><td>
<img src="http://www.eflorida.com/images/Regional-NorthWest.jpg" />	
</td></tr>
</table>
<p>
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
'<h3>
	<strong>Southwest Florida</strong></h3>
<table class="layouttable">
<tr><td>
<p>
Southwest Florida consists of Charlotte, Lee, and Collier counties. This region borders the gulf coast and is home to over 600 technology businesses, as well as many retail, tourism and healthcare industry businesses. The population is approximately 1.1 million people. Florida Gulf Coast University was founded in this region in 1991 and has drawn new businesses to the area.</p>
<p><strong>Enterprise Florida Links:</strong></p>
<ul>
<li><a href="http://www.eflorida.com/FloridasRegionsSubpage.aspx?id=270" target="_blank"></a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=12&Display=all" target="_blank">Collier County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=60&Display=all" target="_blank">Lee County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=8&Display=all" target="_blank">Charlotte County</a></li>
</ul>

</td><td>
<img src="http://www.eflorida.com/images/Regional-SouthWest.jpg" />	
</td></tr>
</table>
<p>
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
'<h3>
	<strong>North Central Florida </strong></h3>
<table class="layouttable">
<tr><td>
<p>
North Central Florida includes Madison, Hamilton, Taylor, Suwannee, Union, Bradford, Lafayette, Dixie, Levy, Gilchrist, Alachua, Marion and Columbia counties. Alachua County has the lowest unemployment rate in the region, which can probably be accounted to The University of Florida located in Gainesville. Target industries are healthcare services and products, biofuels and renewable energy, aviation services and products, building component design and manufacturing, and logistics &amp;distribution.</p>

<p><strong>Enterprise Florida Links:</strong></p>
<ul>
<li><a href="http://www.eflorida.com/FloridasRegionsSubpage.aspx?id=246" target="_blank">North Central Florida Business News</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=66&Display=all" target="_blank">Marion County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=62&Display=all" target="_blank">Levy County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=39&Display=all" target="_blank">Dixie County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=18&Display=all" target="_blank">Taylor County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=58&Display=all" target="_blank">Lafayette County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=64&Display=all" target="_blank">Madison County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=48&Display=all" target="_blank">Hamilton County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=17&Display=all" target="_blank">Suwannee County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=10&Display=all" target="_blank">Columbia County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=45&Display=all" target="_blank">Gilchrist County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=1&Display=all" target="_blank">Alachua County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=4&Display=all" target="_blank">Bradford County</a></li>
</ul>

</td><td>
<img src="http://www.eflorida.com/images/Regional-NorthCentral.jpg" />	

</td></tr>
</table>
<p>
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
'<h3>
	<strong>South Central Florida </strong></h3>
<table class="layouttable">
<tr><td>
<p>
South Central Florida includes Hardee, Highlands, Okeechobee, DeSoto, Glades, and Hendry counties. Its central location makes it convenient for many large metropolitan areas. There is a large Hispanic population in this region; 50% of Hendry County&rsquo;s population is Hispanic. This region has a more rural, laidback lifestyle. Agriculture is a big industry in the area. Coca Cola recently spent 2 billion dollars to support the planting of 25,000 acres of orange trees. Lake Okeechobee is located in Okeechobee and is the nation&rsquo;s second largest fresh water lake.</p>

<p><strong>Enterprise Florida Links:</strong></p>
<ul>
<li><a href="http://www.eflorida.com/FloridasRegionsSubpage.aspx?id=274" target="_blank">South Central Florida Business News</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=50&Display=all" target="_blank">Hendry County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=46&Display=all" target="_blank">Glades County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=52&Display=all" target="_blank">Highlands County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=28&Display=all" target="_blank">Okeechobee County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=49&Display=all" target="_blank">Hardee County</a></li>
<li><a href="http://www.eflorida.com/profiles/CountyReport.asp?CountyID=38&Display=all" target="_blank">Desoto County</a></li>
</ul>

</td><td>
<img src="http://www.eflorida.com/images/Regional-SouthCentral.jpg" />	
</td></tr>
</table>
<p>
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

  procedure gen_fl_text is
    
    v_desc      clob := empty_clob;
    v_text      varchar2(32767);
    v_len       binary_integer;
  begin
    dbms_lob.createtemporary(v_desc, TRUE);
    dbms_lob.open(v_desc, dbms_lob.lob_readwrite); 
    
    v_text := get_static_text('overview');
    v_len := length(v_text);
    if v_len > 0 then
      dbms_lob.writeappend(v_desc, v_len, v_text);
    end if;
    
    v_text := get_static_text('visulate');
    v_len := length(v_text);
    if v_len > 0 then
      dbms_lob.writeappend(v_desc, v_len, v_text);
    end if;
    
    
    v_text := get_static_text('regions');
    v_len := length(v_text);
    if v_len > 0 then
      dbms_lob.writeappend(v_desc, v_len, v_text);
    end if;

    v_text := get_static_text('region-table');
    v_len := length(v_text);
    if v_len > 0 then
      dbms_lob.writeappend(v_desc, v_len, v_text);
    end if;

    v_text := get_static_text('google-ad');
    v_len := length(v_text);
    if v_len > 0 then
      dbms_lob.writeappend(v_desc, v_len, v_text);
    end if;

    v_text := get_static_text('southeast');
    v_len := length(v_text);
    if v_len > 0 then
      dbms_lob.writeappend(v_desc, v_len, v_text);
    end if;

    v_text := get_static_text('tampa');
    v_len := length(v_text);
    if v_len > 0 then
      dbms_lob.writeappend(v_desc, v_len, v_text);
    end if;

    v_text := get_static_text('east-central');
    v_len := length(v_text);
    if v_len > 0 then
      dbms_lob.writeappend(v_desc, v_len, v_text);
    end if;

    v_text := get_static_text('northeastern');
    v_len := length(v_text);
    if v_len > 0 then
      dbms_lob.writeappend(v_desc, v_len, v_text);
    end if;
    
    v_text := get_static_text('northwest');
    v_len := length(v_text);
    if v_len > 0 then
      dbms_lob.writeappend(v_desc, v_len, v_text);
    end if;
    
    v_text := get_static_text('southwest');
    v_len := length(v_text);
    if v_len > 0 then
      dbms_lob.writeappend(v_desc, v_len, v_text);
    end if;
    
    v_text := get_static_text('north-central');
    v_len := length(v_text);
    if v_len > 0 then
      dbms_lob.writeappend(v_desc, v_len, v_text);
    end if;
    
    v_text := get_static_text('google-ad');
    v_len := length(v_text);
    if v_len > 0 then
      dbms_lob.writeappend(v_desc, v_len, v_text);
    end if;
    
    v_text := get_static_text('south-central');
    v_len := length(v_text);
    if v_len > 0 then
      dbms_lob.writeappend(v_desc, v_len, v_text);
    end if;
      
    update rnt_cities
    set description = v_desc
    where name = 'ANY'
    and state = 'FL'
    and county = 'ANY';
    commit;
      
    dbms_lob.close(v_desc);
  end gen_fl_text;
  
begin
  gen_fl_text;
end;
/  




