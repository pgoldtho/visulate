{include file="homeTop.tpl"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->
      <div id="left_part" style="top: 50px;">
       <div id="nav" class="nolast">


     {if $getCounty}
      <h3 class="lefthead">County Sales History</h3>
       <ul class="left_menu">
           <li class="li_left_first"><a {if $allSales} class="active"{/if}
              href="rental/visulate_search.php?REPORT_CODE=SALES&county={$getCounty}&region_id={$region_id}">
            {$getCounty|lower|capitalize:true} County Sales</a></li>
           <li><a {if $commercialSummary} class="active"{/if}
              href="rental/visulate_search.php?REPORT_CODE=COMMERCIAL&county={$getCounty}&region_id={$region_id}">
            Commercial Sales</a></li>
           <li><a {if $landSales} class="active"{/if}
              href="rental/visulate_search.php?REPORT_CODE=LAND&county={$getCounty}&region_id={$region_id}">
            Land Sales</a></li>
        </ul>
     {/if}

     {assign var="cur_region_id" value="9999"}

  {foreach from=$locations item=loc name=outer key=k}
     {if ($cur_region_id ne $loc.REGION_ID)}
          {if ($cur_region_id != "9999")}

          <li class="{$l3class}"><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id={$cur_region_id}">{$cur_region_name} Florida Region</a></li>

        </ul>
          {/if}
    <h3 class="lefthead">{if $getCounty}{$getCounty|lower|capitalize:true}
      Cities{else}{$loc.REGION_NAME} Region{/if}</h3>
       <ul class="left_menu">
          {assign var="cur_region_id" value=$loc.REGION_ID}
          {assign var="cur_region_name" value=$loc.REGION_NAME}
            {assign var="l3class" value="li_left_first"}
         {else}
            {assign var="l3class" value="li_left_normal"}


    {/if}

          {if ($smarty.get.city) && ($smarty.get.city == $loc.CITY)}

            <li class="{$l3class}"><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state={$loc.STATE}&county={$loc.COUNTY}&city={$loc.CITY}&region_id={$loc.REGION_ID}">
              {$loc.DISPLAY_LOCATION}</a></li>
          {else}

            <li class="{$l3class}"><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state={$loc.STATE}&county={$loc.COUNTY}&city={$loc.CITY}&region_id={$loc.REGION_ID}">
              {$loc.DISPLAY_LOCATION}</a></li>

          {/if}
  {/foreach}


          {if $getCounty}

            <li class="{$l3class}"><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id={$region_id}">Select a Different County</a></li>
          {elseif ($skey != 0)}

            <li class="{$l3class}"><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL">All Florida Counties</a></li>
          {/if}
       </ul>
{if ($region_id)}
<fieldset>
{literal}
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- MD160x600 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:160px;height:600px"
     data-ad-client="ca-pub-9857825912142719"
     data-ad-slot="6114888512"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
{/literal}
</fieldset>
{/if}
      </div> <!-- end nav -->
    </div> <!-- end left part -->

    <!-- begin right part -->
     <div id="right_part">  {*---right_part div is closed in footer.tpl---*}
{include file="visulate-submenu.tpl"}
<h1 id="page_header">{$pageTitle}</h1>




{if ($commercialSummary|$allSales|$landSales|$salesData)}



{if $commercialSummary}
<h3>{$getCounty|lower|capitalize:true} Commercial Sales</h3>
<table class="datatable">
<caption>{$getCounty|lower|capitalize:true} Commercial Sales</caption>
<tr><th scope="col">Year</th><th scope="col">Sales Count</th><th scope="col">Total Sales</th><th scope="col">Median Price</th></tr>
{foreach from=$commercialSummary key=k item=item}
  <tr>
  <th scope="row"><a href="rental/visulate_search.php?REPORT_CODE=COMMERCIAL&YEAR={$k}&county={$getCounty}">{$k}</a></th>

  <td style="text-align: right">{$item.SALES_COUNT|number_format:0:".":","}</td>
  <td style="text-align: right">${$item.TOTAL_SALES|number_format:0:".":","}</td>
  <td style="text-align: right">${$item.AVG_PRICE|number_format:0:".":","}</td>
  </tr>
{/foreach}
</table>
{/if}

{if $allSales}
<h3>{$getCounty|lower|capitalize:true} County Sales History</h3>
<table class="datatable">
<caption>{$getCounty|lower|capitalize:true} County Sales History</caption>
<tr><th scope="col">Year</th><th scope="col">Sales Count</th><th scope="col">Total Sales</th><th scope="col">Median Price</th></tr>
{foreach from=$allSales key=k item=item}
  <tr>
  <th scope="row"><a href="rental/visulate_search.php?REPORT_CODE=SALES&YEAR={$k}&county={$getCounty}">{$k}</a></td>
   <td style="text-align: right">{$item.SALES_COUNT|number_format:0:".":","}</td>
  <td style="text-align: right">${$item.TOTAL_SALES|number_format:0:".":","}</td>
  <td style="text-align: right">${$item.AVG_PRICE|number_format:0:".":","}</td>
  </tr>
{/foreach}
</table>
{/if}

{if $landSales}
<h3>{$getCounty|lower|capitalize:true} Land Sales</h3>
<table class="datatable">
<caption>{$getCounty|lower|capitalize:true} Land Sales</caption>
<tr><th scope="col">Year</th><th scope="col">Sales Count</th><th scope="col">Total Sales (Acres)</th><th scope="col">Median Price/Acre</th></tr>
{foreach from=$landSales key=k item=item}
  <tr>
  <th scope="row"><a href="rental/visulate_search.php?REPORT_CODE=LAND&YEAR={$k}&county={$getCounty}">{$k}</a></th>
  <td style="text-align: right">{$item.SALES_COUNT|number_format:0:".":","}</td>
  <td style="text-align: right">{$item.TOTAL_SALES|number_format:2:".":","}</td>
  <td style="text-align: right">${$item.AVG_PRICE|number_format:0:".":","}</td>
  </tr>
{/foreach}
</table>
{/if}

{if $salesData}
   <h3>{$smarty.get.year} Property Sales </h3>
        <table class="datatable">
        <caption>{$smarty.get.year} Property Sales</caption>
        <tr><th scope="col">Address</th><th scope="col">Date</th><th scope="col">Price</th><th scope="col">Sq Ft</th><th scope="col">Price/Sq Ft</th></tr>
        {foreach item=d from=$salesData key=k}
        <tr><th scope="row"><a href="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$d.PROP_ID}">
        {$d.ADDRESS1}</a></th>
            <td>{$d.SALE_DATE}</td>
                <td>{$d.PRICE|number_format:0:".":","}</td>
                <td>{$d.SQ_FT|number_format:0:".":","}</td>
                <td>{$d.SQFT_PRICE}</td></tr>
        {/foreach}
        </table>
{/if}


{literal}
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- MD336x280 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:336px;height:280px"
     data-ad-client="ca-pub-9857825912142719"
     data-ad-slot="1758740915"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
{/literal}



{if $pageText}
<p>{$pageText}</p>
{/if}




{/if}



{if $cityDataValues}
{if ($cityDataValues.IMG_LIST)}
      <div id="city_images" class="nivoSlider">
  {foreach from=$cityDataValues.IMG_LIST key=k item=img name=ilist}
    {if ($img.ASPECT_RATIO=='16:10')}
         <img src="https://s3.amazonaws.com/visulate.cities/704x440/{$img.NAME}"
              title="{ $img.TITLE}" alt="{$img.ALT_TEXT}" pagespeed_no_transform />{/if}
  {/foreach}

      </div>

<script type="text/javascript">
{literal}
   jQuery(function(){
    jQuery("#city_images").nivoSlider({
        effect:"fade",
        slices:15,
        boxCols:8,
        boxRows:4,
        animSpeed:600,
        pauseTime:6000,
        startSlide:0,
        directionNav:true,
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

<div class="col-md-12">
{$cityDataValues.DESCRIPTION}
{if $ziplist}
<div id="MLS-Listings"></div>
<script type="text/javascript">
  jQuery("#MLS-Listings").load("/rental/visulate_search.php?REPORT_CODE=AJAX&qtype=RESIDENTIAL&state=FL&county={$getCounty}&city={$getCity|replace:' ':'+'}&ZCODE={$ziplist[0].ZCODE}&MAX=A_MIN");
</script>
{else if $commlist}
<div id="MLS-Listings"></div>
<script type="text/javascript">
  jQuery("#MLS-Listings").load("/rental/visulate_search.php?REPORT_CODE=AJAX&qtype=LATEST&state=FL&county={$getCounty}");
</script>
{/if}

{include file="visulate-welcome.tpl"}

{if (($cityDataValues.LAT && $cityDataValues.LON) &! ($cityDataValues.CITY_LIST))}
  {assign var="lat" value=$cityDataValues.LAT}
  {assign var="lon" value=$cityDataValues.LON}
  {assign var="zoom" value="10"}
  {assign var="map_title" value=$displayLocation}
  {assign var="map_desc" value=$displayLocation}
<div id="map"></div>
  {include file="google-map.tpl"}
{/if}



{if ($cityDataValues.CITY_LIST)}
<h3>{$cityDataValues.DISPLAY_NAME} Florida Cities</h3>
  {if ($cityDataValues.REGION_IMG_LIST)}
      <div id="region_images" class="nivoSlider">
  {foreach from=$cityDataValues.REGION_IMG_LIST key=k item=img name=ilist}
         <img src="https://s3.amazonaws.com/visulate.cities/704x440/{$img.NAME}"
              title="{$img.TITLE}" alt="{$img.ALT_TEXT}"/>
  {/foreach}
      </div>

<script type="text/javascript">
{literal}
   jQuery(window).load(function(){
    jQuery("#region_images").nivoSlider({
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
  {/if} {*---end $cityDataValues.REGION_IMG_LIST ---*}



<p>
  {foreach from=$cityDataValues.CITY_LIST key=k item=city name=clist}
  {if $smarty.foreach.clist.first}
  There are {$smarty.foreach.clist.total} cities in {$cityDataValues.DISPLAY_NAME} Florida.  These are listed below.  Click on a link for details.
</p><p>{/if}
  <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county={$city.COUNTY}&city={$city.NAME}&region_id={$region_id}">{$city.DISPLAY_NAME}</a>,
  {/foreach}
</p>

<div style="margin-bottom: 6px;">
{literal}
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- MD728x90 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:728px;height:90px"
     data-ad-client="ca-pub-9857825912142719"
     data-ad-slot="9282007715"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
{/literal}
</div>


{if ($cityDataValues.CITY_LIST)}

  {assign var="lat" value=$cityDataValues.CITY_LIST[0].LAT}
  {assign var="lon" value=$cityDataValues.CITY_LIST[0].LON}
  {assign var="zoom" value="8"}
  {assign var="map_title" value=""}
  {assign var="map_desc" value=""}
<div id="map"></div>
  {include file="google-map.tpl"}
{/if}



{/if}


{$cityDataValues.REPORT_DATA}
</div>
{/if}  {*---end $cityDataValues ---*}





    {if $cityData}

    <table class="layouttable"><tr><td>
        <h3>{if $smarty.get.city}
        {$smarty.get.city|lower|capitalize:true},
        <a href="/rental/visulate_search.php?REPORT_CODE=CITY&state={$smarty.get.state}&county={$smarty.get.county}">
{$smarty.get.county|lower|capitalize:true} County</a>
        {else}
        {$smarty.get.county|lower|capitalize:true}
        {/if}
         Market Data</h3>
      <table class="datatable">
      <caption>
{if $smarty.get.city}{$smarty.get.city|lower|capitalize:true}{else}{$smarty.get.county|lower|capitalize:true}{/if} Real Estate</caption>
      <tr><th scope="col">Property Usage</th><th scope="col">Property Count</th><th scope="col">Total Sq Ft</th></tr>
      {assign var='max_length' value=0}
      {foreach name=outer item=d from=$cityData key=k}
      <tr><th scope="row">
      {$d.PROP_USAGE}
      </th>
      <td style="text-align: right">{$d.PROP_COUNT|number_format:0:".":","}</td>
      <td style="text-align: right">{$d.TOTAL_SQFT|number_format:0:".":","}</td></tr>
      {/foreach}
      </table></td><td>
        <div id="chart1" style="height:400px; width:400px; "> </div>
       <div id="chart2" style="height:400px; width:400px; "> </div>
       </td></tr></table>
     <script type="text/javascript">

         line1 = {$pcountPlot};
        plot1 = $j.jqplot('chart1', [line1],{literal} {
                       title: 'Property Breakdown by Property Count',
                       seriesDefaults:{renderer:$j.jqplot.PieRenderer,
                       rendererOptions:{
                         dataLabels:'label',
                         showDataLabels:true,
                       }},
                       legend:{show:false}}{/literal});

        line2 = {$sqftPlot};
        plot2 = $j.jqplot('chart2', [line2],{literal} {
                       title: 'Property Breakdown by Total SqFt',
                       seriesDefaults:{renderer:$j.jqplot.PieRenderer,
                       rendererOptions:{
                         dataLabels:'label',
                         showDataLabels:true,
                       }},
                       legend:{show:false}}{/literal});

    </script>
    {/if}



    {if $cityValues}

    <h3>{$smarty.get.city|lower|capitalize:true} Median Property Values per Sq Ft</h3>
    {assign var='c_desc' value='Z'}

        <table class="datatable">
        <caption>{$smarty.get.city|lower|capitalize:true} Median Property Values per Sq Ft by Property Class</caption>
        <tr><th>Property Class</th><th>&nbsp;</th><th colspan="2" scope="col">Class A</th><th colspan="2" scope="col">Class B</th><th colspan="2" scope="col">Class C</th></tr>
                <tr><th scope="col">Usage</th><th scope="col">Year</th>
                    <th scope="col">Sale</th><th scope="col">Lease</th>
                    <th scope="col">Sale</th><th scope="col">Lease</th>
                    <th scope="col">Sale</th><th scope="col">Lease</th>
                    </tr>


    {foreach name=outer item=d from=$cityValues key=k}
      {if $c_desc != $d.DESCRIPTION}
        {if $c_desc != 'Z'}</tr>{/if}

        <tr><th scope="row">{$d.DESCRIPTION}</th>
        {assign var='c_desc' value=$d.DESCRIPTION}
        {assign var='c_ucode' value=$d.UCODE}
        {assign var='c_year' value='1900'}

      {/if}

      {if $c_year != $d.YEAR}
        {if $c_year != '1900'}</tr>{/if}
        <td>{$d.YEAR}</td>
        {assign var='c_year' value=$d.YEAR}
       {/if}
       <td>${$d.MEDIAN_PRICE}</td><td>${$d.RENT}</td>

      {/foreach}
      </tr>




    {/if}
   </table>


{include file="google-analytics.tpl"}
{include file="footer.tpl"}
