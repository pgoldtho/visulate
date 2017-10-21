{if ($streetview)}
<img id="mainPicture" src="{$streetview}" style="border: 1px solid #949494;"
    alt="Google Street View of {$lat}, {$lon}"/>
{/if}
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
