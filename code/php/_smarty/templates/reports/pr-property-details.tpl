{if ($is_pdf_report)}
   {include file="reports/report-header.tpl"}
{else}  
	<style>
	.total {ldelim}font-weight:bold;
			padding-bottom:30px;
			border-top:1px black solid;
		   {rdelim}
	</style>
{/if}

{foreach name=outer from=$data item=report_element key=report_key}
 
  {if ($report_key == 'PROPERTY_USAGE')}
    {foreach from=$report_element key=k item=item}
      <h3>Usage</h3>
      <p>{$item}</p>
    {/foreach}
  {elseif ($report_key == 'PROPERTY')}
  <h4>Address</h4>
  <div class="column span-40">
     <p>{$report_element.ADDRESS1}<br/>
		    {if ($report_element.ADDRESS2)}{$report_element.ADDRESS2}<br/>{/if}
		    {$report_element.CITY}<br/>
		    {$report_element.STATE}{$report_element.ZIPCODE}<br/>
		 </p>
	</div>
	<div class="column span-50">
	<table class="datatable">
	  <tr><th>Property Size (sq ft)</th><td>{show_number number=$report_element.SQ_FT}</td></tr>
	  <tr><th>Acreage</th><td>{show_number number=$report_element.ACREAGE}</td></tr>
	</table>
	</div>
	<div class="column span-100">
	<div id="map_container">
    <div id="map"></div>
</div>
<script type="text/javascript" src="http://api.maps.yahoo.com/ajaxymap?v=3.8&appid=0wwyIEvV34GiDYcHbs07wzZ948aMSvXfwh61VA06_qK0_E3dnl2bPleljQxoEz4-">
</script>
<script type="text/javascript">
	// Create a map object
	var map = new YMap(document.getElementById('map'));

	// Add map type control
	map.addTypeControl();
	
	// Add map type control
	map.addTypeControl();

	// Add map zoom (long) control
	map.addZoomLong();

	// Add the Pan Control
	map.addPanControl();

	// Set map type to either of: YAHOO_MAP_SAT, YAHOO_MAP_HYB, YAHOO_MAP_REG
	map.setMapType(YAHOO_MAP_REG);

	// Display the map centered on a geocoded location
	map.drawZoomAndCenter("{$report_element.ADDRESS1}, {$report_element.ZIPCODE}", 4);
	
	 var marker1 = new YMarker("{$report_element.ADDRESS1}, {$report_element.ZIPCODE}",'id1');
	 map.addOverlay(marker1);
		
</script>
	
	
	<h4>Links</h4>
	<ol>
	<li><a href="{$report_element.PROPERTY_URL}">{$report_element.SOURCE}</a></li>
	<li><a href="{$report_element.TAX_URL}">Tax Record</a></li>
	<li><a href="{$report_element.PHOTO_URL}">{$report_element.SOURCE} Photos (if any)</a></li>
	</ol>
	</div>
  {elseif ($report_key == 'BUILDINGS')}	
  <h4>Buildings</h4>
  <table class="datatable">
  <tr><th>Building</th><th>Year Built</th><th>Size</th><th>Usage</th><th>Features</th><tr>
    {foreach from=$report_element key=b item=b_item name=building}
    <tr><td>{$b_item.BUILDING_NAME}</td>
        <td>{$b_item.YEAR_BUILT}</td>
        <td>{show_number number=$b_item.SQ_FT}</td>
        <td>
        {foreach from=$b_item.USAGE key=bu item=bu_item name=bbu}
          {$bu_item}
        {/foreach}
				</td>
        <td>
        {foreach from=$b_item.FEATURES key=bf item=bf_item name=bbf}
          {$bf_item}, 
        {/foreach}

				</td></tr>
    {/foreach}
  </table>
	{elseif ($report_key == 'OWNER')}	
	<h4>Current Owner</h4>

    <p><a href="?m2=business_reports&REPORT_CODE=OWNER_DETAILS&OWNER_ID={$report_element.OWNER_ID}">
       {$report_element.OWNER}</a><br/>
       <a href="?m2=business_reports&REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$report_element.MAILING_ID}">
       {$report_element.ADDRESS1}</a><br>
       {if ($report_element.ADDRESS2)}{$report_element.ADDRESS2}<br/>{/if}
       {$report_element.CITY}<br/>
       {$report_element.STATE}{$report_element.ZIPCODE}<br/>
    </p>
  {elseif ($report_key == 'SALES_HISTORY')}	
  <h4>Sales History</h4>
  <table class="datatable">
  <tr><th>Date</th><th>Sold By</th><th>Sold To</th><th>Deed Type</th><th>Price</th></tr>
  {foreach from=$report_element key=t item=t_item name=trasactions}
  <tr><td>{$t_item.SALE_DATE}</td>
      <td><a href="?m2=business_reports&REPORT_CODE=OWNER_DETAILS&OWNER_ID={$t_item.OLD_OWNER_ID}">
          {$t_item.OLD_OWNER}</td>
      <td><a href="?m2=business_reports&REPORT_CODE=OWNER_DETAILS&OWNER_ID={$t_item.NEW_OWNER_ID}">
          {$t_item.NEW_OWNER}</td>
      <td>{$t_item.DEED_DESC}</td>    
      <td>{show_number number=$t_item.PRICE}</td></tr>
  {/foreach}
  </table>

  {/if}
{/foreach}



{if ($is_pdf_report)}
   {include file="reports/report-footer.tpl"}
{/if}
