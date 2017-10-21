{include file="mobile-top.tpl"}
 
<h1 id="page_header">{$pageTitle}</h1>
<p>Click on a map pin or select a value from the Properties menu on the left of the page</p>
<div id="map_container">
    <div id="map"></div>
</div>
<script type="text/javascript" src="http://api.maps.yahoo.com/ajaxymap?v=3.8&appid=0wwyIEvV34GiDYcHbs07wzZ948aMSvXfwh61VA06_qK0_E3dnl2bPleljQxoEz4-">
</script>
<script type="text/javascript">
	// Create a map object
	var map = new YMap(document.getElementById('map'));

	map.addTypeControl();
	map.addZoomLong();
	map.addPanControl();
	map.setMapType(YAHOO_MAP_REG);


	map.drawZoomAndCenter("{$loc.LOCATION_CONTEXT}", {$loc.ZOOM_LEVEL});
	{foreach name=outer item=loc from=$locations key=k} 
	   var m{$k} = new YMarker("{$loc.LOCATION}");
	   m{$k}.addAutoExpand('<a href="/rental/visulate_search.php?REPORT_CODE={$reportCode}&state={$loc.STATE}&county={$loc.COUNTY}&agreement={$loc.AGREEMENT_ID}">{$loc.DISPLAY_LOCATION} - {$loc.LOCATION_COUNT}</a>');
	   map.addOverlay(m{$k});
	{/foreach}  	

</script>


{include file="footer.tpl"}