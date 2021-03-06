
{if ($lat && $lon)}
   {assign var="pageDesc" value="Real estate, companies and market data for Florida location $lat, $lon"}
{/if}
{include file="homeTop.tpl" noindex="n"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->
      <div id="left_part">
      <div id="nav">
      

   <h3>Items</h3>
       <ul class="left_menu">
       {foreach from=$ReportList item=item name=l3menu}
         {if $smarty.foreach.l3menu.last }
            {assign var="l3class" value="li_left_last"}       
         {elseif $smarty.foreach.l3menu.first }
            {assign var="l3class" value="li_left_first"}
         {else}
            {assign var="l3class" value="li_left_normal"}
         {/if}
       {if ($item.code eq $reportCode)}
             <li class="{$l3class}"><a href="{$item.href}" class="active">{$item.title}</a></li>
		   {else}	 
             <li class="{$l3class}"><a href="{$item.href}">{$item.title}</a></li>
		   {/if} 
      {/foreach}
       </ul>

  {if ($listings)}

   <h3>Search Results</h3>
     <ul class="left_menu">
     {foreach name=menu item=loc from=$listings key=k}
         {if $smarty.foreach.menu.last }
            {assign var="l3class" value="li_left_last"}
         {elseif $smarty.foreach.menu.first }
            {assign var="l3class" value="li_left_first"}
         {else}
            {assign var="l3class" value="li_left_normal"}
         {/if}
         <li class="{$l3class}"><a href="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$loc.PROP_ID}" target="_blank">{$loc.ADDRESS1|escape:'html'}</a></li>

           
     {/foreach}

     </ul>
  {/if}

  {if ($companies)}
   <h3>Nearby Companies</h3>
     <ul class="left_menu">
     {foreach name=menu item=loc from=$companies key=k}
         {if $smarty.foreach.menu.last }
            {assign var="l3class" value="li_left_last"}
         {elseif $smarty.foreach.menu.first }
            {assign var="l3class" value="li_left_first"}
         {else}
            {assign var="l3class" value="li_left_normal"}
         {/if}
         <li class="{$l3class}"><a href="/rental/visulate_search.php?CORP_ID={$loc.CORP_NUMBER}" target="_blank" >{$loc.NAME|escape:'html'}</a></li>


     {/foreach}

     </ul>
  {/if}
<fieldset>
{literal}
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- search160x600 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:160px;height:600px"
     data-ad-client="ca-pub-9857825912142719"
     data-ad-slot="6079045716"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
{/literal}
</fieldset>
     </div> <!-- end nav -->
    </div> <!-- end left part -->
    <!-- begin right part -->
     <div id="right_part">  {*---right_part div is closed in footer.tpl---*} 
         
         {$data|@print_r}

 {$report_text}
 
{literal}
  <script type="text/javascript">
    function GetCurrentLocation() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(locateSuccess, locateFail);
        }
        else {
            alert('Geolocation is not supported in your current browser.');
        }
      }
    function locateSuccess(loc) {
      var lat = loc.coords.latitude;
      var lon = loc.coords.longitude;
      $j("#gLAT").val(lat);
      $j("#gLON").val(lon);
      $j('#geoForm').submit();
     }

    function locateFail(geoPositionError) {
        switch (geoPositionError.code) {
                case 0: // UNKNOWN_ERROR
                    alert('An unknown error occurred, sorry');
                    break;
                case 1: // PERMISSION_DENIED
                    alert('Permission to use Geolocation was denied');
                    break;
                case 2: // POSITION_UNAVAILABLE
                    alert('Couldn\'t find you...');
                    break;
                case 3: // TIMEOUT
                    alert('The Geolocation request took too long and timed out');
                    break;
                default:
            }
      }
   
  </script>
{/literal}
 
<h1 id="page_header">Search Florida Real Estate and Company Records</h1>

{if ($streetview)}
<img id="mainPicture" src="{$streetview}" style="border: 1px solid #949494;"
    alt="Google Street View of {$lat}, {$lon}"/>

{elseif (!($lat && $lon))}


<img src="https://s3.amazonaws.com/visulate.cities/704x440/palm_beach-8.jpg"  alt="Florida" style="border: 1px solid #949494;"/>
{/if}

<p>Use this form to perform a location based search
 or <a href="javascript:GetCurrentLocation();">use your current location</a></p>

<form id="geoForm" action="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS" method="post">
  <input id="gLAT" name="LAT" type="hidden" />
  <input id="gLON" name="LON" type="hidden" />
</form>

  <form id="searchForm"  
        action="rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS" method="post">
    <table  class="datatable" style="width: 100%">
    <caption>Enter Street Address then Press Search</caption>
     <tr><th><b>Address:</b></th>
         <td><input size="60" maxlength="80" name="ADDR" type="text" value="{$PrmAddr}"
                    placeholder="Example: 1116 Ocean Dr, Miami Beach" aria-label="Example: 1116 Ocean Dr, Miami Beach"/></td>
         <td><input name="submit_html" value="Search" type="submit" /></td>
     </tr>
    </table>
                    <input name="ADDRESS1" type="text"/><input name="CITY" type="text"/>                    
  </form>

{if ($PrmAddr)}
<p><span itemprop="name">{$PrmAddr}</span> is located at {$lat}, {$lon}</p>
{/if}

{literal}
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- search728x90 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:728px;height:90px"
     data-ad-client="ca-pub-9857825912142719"
     data-ad-slot="3125579310"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
{/literal}



<div >
{if ($lat && $lon)}
<div itemscope itemtype="http://schema.org/Place">
<h3>Search Results for Coordinates {$lat|string_format:"%.3f"}, {$lon|string_format:"%.3f"}</h3>

<div itemprop="geo" itemscope itemtype="http://schema.org/GeoCoordinates">
<meta itemprop="latitude" content="{$lat}" />
<meta itemprop="longitude" content="{$lon}" />
</div>
</div>
{/if}



{if ($message)}
<p>{$message}</p>
{/if}

{if ($lat && $lon)}
  {assign var="map_title" value="Current Location"}
  {assign var="map_desc" value="Current Location"}
  {assign var="zoom" value="18"}
<div id="map"></div>
  {include file="google-map.tpl"}
{/if}


{if ($PrmAddr)}
<ul><li><a href="http://www.broadbandmap.gov/internet-service-providers/{$PrmAddr}/lat={$lat}/long={$lon}/" target="_blank">
Check for internet service providers near {$PrmAddr}</a></li></ul>
{else}
<ul><li><a href="http://www.broadbandmap.gov/internet-service-providers/lat={$lat}/long={$lon}/" target="_blank">
Check for internet service providers near this location</a></li></ul>
{/if}



{if ($city.NAME)}
{$city.DESCRIPTION}
<p>Additional Information:</p>
<ul>
<li><a target="_blank"  href="/rental/visulate_search.php?REPORT_CODE=CITY&state={$city.STATE}&county={$city.COUNTY}&city={$city.NAME}&region_id={$city.REGION_ID}">
  {$city.DISPLAY_NAME} Real Estate Market Data</a></li>
</ul>
{if ($city.IMG_LIST)}
      <div id="county_images" class="nivoSlider">
  {foreach from=$city.IMG_LIST key=k item=cyimg name=cyilist}
         <img src="https://s3.amazonaws.com/visulate.cities/704x440/{$cyimg.NAME}"
              title="{$cyimg.TITLE}" alt="{$cyimg.ALT_TEXT}"/>
  {/foreach}

      </div>

<script type="text/javascript">
{literal}
   jQuery(window).load(function(){
    jQuery("#county_images").nivoSlider({
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
{/literal}
  </script>
{/if}

   {$city.COUNTY_DESCRIPTION}

<p>Additional Information:</p>
<ul>
<li><a target="_blank"  href="/rental/visulate_search.php?REPORT_CODE=CITY&state={$city.STATE}&county={$city.COUNTY}&region_id={$city.REGION_ID}">
  {$city.COUNTY|lower|capitalize:true} County Real Estate Market Data</a></li>
</ul>   
{/if}

{foreach name=menu item=loc from=$listings key=k}
{if  $smarty.foreach.menu.first }
<h4>Real Estate Search Results</h4>
<table class="datatable">
<tr><th>Address</th><th>Type</th><th>Sq Ft</th><th>Class</th><th>Rent</th><th>Percentile</th><th>&nbsp;</th></tr>
<ul>{/if}
<tr>
<td><a href="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$loc.PROP_ID}" target="_blank">{$loc.ADDRESS1|escape:'html'}</a></td>
<td>{$loc.DESCRIPTION}</td>
<td>{$loc.SQ_FT|number_format:0:".":","}</td>
<td>{$loc.PROP_CLASS}</td>
<td>{$loc.RENT_ESTIMATE} </td>
<td>{if ($loc.PUMA_PERCENTILE > 0)}{$loc.PUMA_PERCENTILE}{/if}</td>


<td>{if ($loc.SQ_FT > 0)}
  <a href="/rental/pages/get_spreadsheet.php?PROP_ID={$loc.PROP_ID}" target="_blank" rel="nofollow">
    <img height="16" width="16" src="/rental/images/excel-icon-16.gif" style="border: none;"></a></td>
   {/if}
</tr>
{if  $smarty.foreach.menu.last }</table>{/if}
{/foreach}

{literal}
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- search728x90 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:728px;height:90px"
     data-ad-client="ca-pub-9857825912142719"
     data-ad-slot="3125579310"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
{/literal}

{if ($mls_listings)}
{foreach item=mls name=menu from=$mls_listings key=k}
{if  $smarty.foreach.menu.first }
<h4>Nearest MLS Listings</h4>
<p>Nearest properties for sale within 3 miles of this location</p>
<img id="MLSImg" src="/rental/php/resizeImg.php?w=320&h=240&src={$mls.PHOTO_URL|escape:'url'}" style="width: 320px;  border: 1px solid #949494; float: right; margin-left: 3px;"/>
<table class="datatable">
<tr><th>Address</th><th>Miles</th><th>Sq Ft</th><th>Price</th><th>&nbsp;</th></tr>{/if}
<tr>
<td><a href="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$mls.PROP_ID}"
       onmouseover="document.getElementById('MLSImg').src='/rental/php/resizeImg.php?w=320&h=240&src={$mls.PHOTO_URL|escape:'url'}';"
       target="_blank">{$mls.ADDRESS1|escape:'html'}</a></td>
<td>{$mls.MILES}</td>
<td>{$mls.SQ_FT|number_format:0:".":","}</td>
<td>{$mls.PRICE}</td>
<td>{if ($mls.SQ_FT > 0)}
  <a href="/rental/pages/get_spreadsheet.php?PROP_ID={$mls.PROP_ID}" target="_blank" rel="nofollow">
    <img height="16" width="16" src="/rental/images/excel-icon-16.gif" style="border: none;"></a>
   {/if}
</td>
<tr>
{if  $smarty.foreach.menu.last }</table>{/if}
{/foreach}
{/if}

{if ($puma)}
{include file="pums-graph.tpl"}
{/if}



{if ($data)}

<table class="datatable">
<tr><th>Owner</th><th>Address</th></tr>
{foreach from=$data key=k item=item}
  <tr>
  <td><a href="rental/visulate_search.php?REPORT_CODE=OWNER_DETAILS&OWNER_ID={$k}" target="_blank">
	{if $publicUser} 
	Owner: {$k}
	{else}
	{$item.OWNER_NAME}
	{/if}</a></td>
  <td><a href="rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$item.PROP_ID}" target="_blank">  
	    {$item.ADDRESS1}</a></br>
	    {$item.CITY}</br>
	    {$item.STATE}{$item.ZIPCODE}</br>
	</td>
  </tr>
{/foreach}
</table>



<h4>Disclaimer Notices</h4>
<ul>
<li>The information on this site was assembled from Property Appraiser files and 
other sources of public record.  Property Appraiser files are used for the purpose 
of arriving at a valuation for assessment purposes.  Certain facts, terminology
or codes may be misinterpreted or misleading if used out of context or without 
knowledge of their meaning or intended use in the appraisal process.  Neither
Visulate LLC nor the County Property Appraisers assume responsibility for errors
or omissions contained herein or for misuse of the data by any individual.</li>
<li>
The Visulate site was produced from data and information compiled from recorded
documents and/or outside public and private sources.  Visulate LLC is not the 
custodian of public records and does not assume responsibility for errors or 
omissions in the data it displays or for its misuse by any individual.</li>
<li>
In the event of either error or omission, Visulate LLC, 
and any 3rd party data provider shall be held harmless from any damages arising 
from the use of records displayed on the site.</li>
<li>
All information displayed on this site is deemed reliable but not guaranteed.
It should be independently verified.</li>
</ul>
{else}
{if ($PrmAddr)}
<h4>Use Google to Search Visulate</h4>
<p>Use this form to search for companies and real estate records by name</p>
  <form id="googleForm"  onsubmit="return executeQuery();">
    <table >
     <tr>
         <td><input size="60" maxlength="80" id="searchBox" type="text" value="{$PrmAddr}" aria-label="Use Google to search Visulate"/></td>
         <td><input name="submit_html" value="Search" type="submit" /></td>
     </tr>
    </table>
  </form>

<script type="text/javascript"
        src="//www.google.com/cse/brand?form=googleForm&inputbox=searchBox">
</script>


{literal}
<script type="text/javascript">
  function executeQuery() {
    var input = document.getElementById('searchBox');
    var cx = '008961708794472305428:WMX-359750769';
    var element = google.search.cse.element.getElement('searchresults-only0');
    if (input.value == '') {
      element.clearAllResults();
    } else {
      element.execute(input.value);
      }
    return false;
  }

</script>
{/literal}
<gcse:searchresults-only></gcse:searchresults-only>
{elseif !($lat && $lon)}
<h4>Search Florida Public Records by Street Address</h4>
<p>
Visulate maintains records for over 8,000,000 properties and 1,700,000 companies in Florida.
Enter a street address in the search box then press search.
Visulate finds the coordinates of that address then
looks for nearby real estate and companies. It displays a map showing the location along with
properties and companies within 150 meters.
</p><p>
Real estate reports provide market and income valuation estimates. Visulate has estimates for
the rental income, expenses, NOI and cap rate for every property in Florida. It displays these
as a pro-forma income statement. A drill down link from the income statement allows the user to
edit these values to perform "what if" analysis and estimate cashflow.
</p><p>
Visulate's company records display information from public records for active corporations,
companies and non profits registered in the State of Florida. The records include their principal
location plus the names and positions of its officers. Company reports include links to the Florida
Department of Corporation's Sunbiz site and other sites with company related information.

</p>
<h4>Use Google to Search Visulate</h4>
<p>Use this form to search for companies and real estate records by name</p>
  <form id="googleForm"  onsubmit="return executeQuery();">
    <table >
     <tr>
         <td><input size="60" maxlength="80" id="searchBox" type="text" value="" aria-label="Use Google to search Visulate"/></td>
         <td><input name="submit_html" value="Search" type="submit" /></td>
     </tr>
    </table>
  </form>

<script type="text/javascript"
        src="//www.google.com/cse/brand?form=googleForm&inputbox=searchBox">
</script>

{literal}
<script>
  (function() {
    var cx = '008961708794472305428:WMX-359750769';
    var gcse = document.createElement('script'); gcse.type = 'text/javascript'; gcse.async = true;
    gcse.src = (document.location.protocol == 'https:' ? 'https:' : 'http:') +
        '//www.google.com/cse/cse.js?cx=' + cx;
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(gcse, s);
  })();
</script>


{/literal}
<gcse:searchresults-only></gcse:searchresults-only>
{/if}




{/if}


<h4>Quick Find ..</h4>

<table class="layouttable" id="nav-tab" width="600px">
        <tbody>
                <tr>
                        <td onmouseout="this.style.border='none';" onmouseover="this.style.border='1px solid #336699';" style="text-align: center; border: none;">
                                <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL"><img src="/images/ventilation.png" style="border: none;" /> Market Data</a></td>
                        <td onmouseout="this.style.border='none';" onmouseover="this.style.border='1px solid #336699';" style="text-align: center;">
                                <a href="/rental/?m2=real_estate"><img src="/images/cotteges.png"  style="border: none;"/>Buy-to-Rent</a></td>
                        <td onmouseout="this.style.border='none';" onmouseover="this.style.border='1px solid #336699';" style="text-align: center;">
                        <!--
                                <a href="/rental/?m2=find&amp;menu=sales&amp;page=LatestListings&amp;subpage=Sales%20Listings"><img src="/images/home.png" style="border: none;" /> Latest Listings</a></td>
                        <td onmouseout="this.style.border='none';" onmouseover="this.style.border='1px solid #336699';" style="text-align: center;">
                        -->
                                <a href="/rental/visulate_search.php?REPORT_CODE=LISTINGS&amp;qtype=RESIDENTIAL&amp;state=FL"><img src="/images/cotteges.png" style="border: none;" />Homes for Sale</a></td>
                        <td onmouseout="this.style.border='none';" onmouseover="this.style.border='1px solid #336699';" style="text-align: center;">
                                <a href="/rental/visulate_search.php?REPORT_CODE=LISTINGS&amp;qtype=COMMERCIAL&amp;state=FL"><img src="/images/town.png" style="border: none;" /> Commercial Real Estate</a></td>
                        <td onmouseout="this.style.border='none';" onmouseover="this.style.border='1px solid #336699';" style="text-align: center;">
                                <a href="/rental/visulate_search.php?REPORT_CODE=LISTINGS&amp;qtype=LAND&amp;state=FL"><img src="/images/water.png" style="border: none;" /> Vacant Land</a></td>
                </tr>
        </tbody>
</table>
</div>
{literal}
<script type="text/javascript">

  function executeQuery() {
    var input = document.getElementById('searchBox');
    var element = google.search.cse.element.getElement('searchresults-only0');
    if (input.value == '') {
      element.clearAllResults();
    } else {
      element.execute(input.value);
      }
    return false;
  }
</script>
{/literal}

{include file="google-analytics.tpl"}
{include file="footer.tpl"}
