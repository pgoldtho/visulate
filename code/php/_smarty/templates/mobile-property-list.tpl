{if ($lat && $lon)}
   {assign var="pageDesc" value="Real estate and companies near Florida location $lat, $lon"}
{/if}

{include file="mobile-top.tpl" noindex="n"}
 <div id="content">
{if ($lat && $lon)}
<div itemscope itemtype="http://schema.org/Place">
<div itemprop="geo" itemscope itemtype="http://schema.org/GeoCoordinates">
<meta itemprop="latitude" content="{$lat}" />
<meta itemprop="longitude" content="{$lon}" />
</div>
</div>
<h4>Search Results for {$lat|string_format:"%.3f"}, {$lon|string_format:"%.3f"}</h4>
{if ($PrmAddr)}
<p>{$PrmAddr} is located at {$lat}, {$lon}</p>
{/if}

{/if}
 
 
{if ($streetview)}
<img id="mainPicture" src="{$streetview}" style="border: 1px solid #949494;" alt="Google Street View of {$lat}, {$lon}" />
{/if}
{if ($message)}
<p>{$message}</p>
{/if}

{if ($lat && $lon)}
  {assign var="map_title" value="Current Location"}
  {assign var="map_desc" value="Current Location"}
  {assign var="zoom" value="17"}
 <div id="map" style="width: 100%; height: 280px; border: 1px solid #949494;"></div>
  {include file="google-map.tpl"}
{/if}


  {if ($listings)}
   <h4>Properties</h4>
   <ul  data-role="listview" data-inset="true">
     {foreach name=outer item=loc from=$listings key=k}
       <li><a href="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$loc.PROP_ID}" target="_blank">{$loc.ADDRESS1|escape:'html'}
         - {$loc.DESCRIPTION}{if ($loc.SQ_FT > 0)} ({$loc.SQ_FT|number_format:0:".":","}sq ft){/if}</a>
       </li>
        {/foreach}
   </ul>
  {else}
<script type="text/javascript">
   var img = 'https://s3.amazonaws.com/visulate.cities/704x440/{$backgroundImg.NAME}';
   var imageLink = '<a style="color: white;" data-ajax="false"  href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county={$backgroundImg.COUNTY}&city={$backgroundImg.CITY}&region_id={$backgroundImg.REGION_ID}">{$backgroundImg.CITY|lower|ucwords}, Florida</a>';


   document.getElementById("tophead").style.color = "white";
   document.getElementById("page1").style.backgroundImage = "url(" + img + ")";
   $("#page1").append('<div id="title" style="display: inline;">'+
                      '<h1>Visulate</h1><p>Florida on Your Phone - '+imageLink+'</p></div>');
   $("#page1").append('<div id="late-list"><ul data-role="listview"><li><a data-ajax="false" href="/rental/?m2=m_LISTINGS" style="background-color: rgba(0, 0, 0, 0.3); color: white;");>Latest Commercial Listings</a></li></ul></div>');
   $("#page1").append(
      '<form id="geoForm" action="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS" method="post">' +
          '<input id="gLAT" name="LAT" type="hidden" />' +
          '<input id="gLON" name="LON" type="hidden" />' +
      '</form>' +

      '<form class="searchform" action="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS" method="post">' +
         '<div class="searchwrap">'+
           '<div class="searchbox"><input class="searchinput" aria-label="Florida Street Address"  name="ADDR" placeholder="Enter a Florida street address" type="text" value="{$PrmAddr}"/></div>'+
           '<a class="loclink" href="javascript:GetCurrentLocation();">Search current location</a>'+
         '</div>'+
      '</form>');

</script>
{literal}

<style>
/*remove text shadow*/
body.ui-mobile-viewport.ui-overlay-a { text-shadow:0 0 0 !important; }
div#page1.jqm-demo.jqm-home.ui-page.ui-page-theme-a.ui-page-active { text-shadow:0 0 0 !important; }
div.jqm-header.ui-header.ui-bar-inherit { text-shadow:0 0 0 !important; }
.ui-page-theme-a .ui-btn, html .ui-bar-a .ui-btn, html .ui-body-a .ui-btn, html body .ui-group-theme-a .ui-btn, html head + body .ui-btn.ui-btn-a, .ui-page-theme-a .ui-btn:visited, html .ui-bar-a .ui-btn:visited, html .ui-body-a .ui-btn:visited, html body .ui-group-theme-a .ui-btn:visited, html head + body .ui-btn.ui-btn-a:visited { text-shadow:0 0 0 !important; }
legend, .ui-input-text input, .ui-input-search input { text-shadow:0 0 0 !important; }



  .searchform {
    position: fixed;
    width: 100%;
  }  

  .searchwrap {
   width: 100%;
   height: 68px;
   background-color: rgba(33, 33, 33, 0.2);
  }

  .searchinput {
   display: inline;
  }
 
  .searchbox {
   width: 98%;
   color: white;
   padding: 5px 0 5px 0;
   margin: auto;
  }
 
  .ui-input-text {
    margin: 0;
    background-color: none;
  }

  .ui-input-text {
    background-color:  rgba(242, 242, 242, .8) !important;
    color: #666 !important;
  }

  .jqm-header {
    background-color: rgba(0, 0, 0, 0.3) !important;
  }

  .loctext {
    display: inline-block;
    margin: 8px 0 0 20px ;
  }

  .loclink {
    position: fixed;
    top: 88px;
    right: 5px;
    color: white !important;
    text-decoration: underline;
  }

  #late-list {
    position: fixed;
    width: 100%;
    bottom: 0;
  }

</style>
{/literal}
  {/if}

  {if ($companies)}
    <h4>Companies</h4>
    <ul  data-role="listview" data-inset="true">
     {foreach name=outer item=loc from=$companies key=k}
        <li><a href="/rental/visulate_search.php?CORP_ID={$loc.CORP_NUMBER}" target="_blank">{$loc.NAME|escape:'html'}</a></li>
     {/foreach}
    </ul> 
  {/if}

  {if ($mls_listings)}
<h4>Properties for Sale</h4>
<ul data-role="listview" data-inset="true" id="mlsListings">

   {foreach name=rs item=r from=$mls_listings key=k}
   <li><a data-ajax="false" href="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$r.PROP_ID}" >
    <img src="/rental/php/resizeImg.php?w=80&h=80&src={$r.PHOTO_URL|escape:'url'}" class="ui-li-thumb"/>
    <h2>{$r.PRICE}</h2>

    <p>{$r.ADDRESS1}
   </p></a>
   </li>
   {/foreach}
</ul>
<img src="/images/idx_brevard_small.gif" />
<h2> Broker Reciprocity</h2>
<p>The data relating to real estate for sale on this web site comes from the Broker Reciprocity Programs of South East, Mid and Brevard County, Florida. Detailed information for each listing including the name of the listing broker is available by clicking on the property.</p>
{/if}

{if ($data)}
<table class="datatable">
<tr><th>Owner</th><th>Address</th></tr>
{foreach from=$data key=k item=item}
  <tr>
  <td><a href="visulate_search.php?REPORT_CODE=OWNER_DETAILS&OWNER_ID={$k}">
	{if $publicUser} 
	Owner: {$k}
	{else}
	{$item.OWNER_NAME}
	{/if}</a></td>
  <td><a href="visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$item.PROP_ID}">  
	    {$item.ADDRESS1}</a></br>
	    {$item.CITY}</br>
	    {$item.STATE}{$item.ZIPCODE}</br>
	</td>
  </tr>
{/foreach}
</table>
{/if}

{if ($city.NAME)}
<h4>Neighborhood Information</h4>
<ul data-role="listview">
<li><a target="_blank"  href="/rental/visulate_search.php?REPORT_CODE=CITY&state={$city.STATE}&county={$city.COUNTY}&city={$city.NAME}&region_id={$city.REGION_ID}">{$city.DISPLAY_NAME}</a></li>
<li><a target="_blank"  href="/rental/visulate_search.php?REPORT_CODE=CITY&state={$city.STATE}&county={$city.COUNTY}&region_id={$city.REGION_ID}">{$city.COUNTY|lower|capitalize:true} County</a></li>
</ul>
{/if}

{if ($puma)}
{include file="pums-mobile.tpl"}
{/if}


</div>
{include file="mobile-footer-pub.tpl"}


