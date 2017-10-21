{include file="google-analytics.tpl"}
<div data-role="panel" class="jqm-navmenu-panel" data-position="left" id="menu" data-display="overlay" data-theme="a">
{include file="jqm-menu.tpl"}
</div>

<div data-role="panel" class="jqm-navmenu-panel" data-position="left" id="search" data-display="overlay" data-theme="a">
<h4>Search our Database:</h4>

<form id="geoForm" action="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS" method="post">
  <input id="gLAT" name="LAT" type="hidden" />
  <input id="gLON" name="LON" type="hidden" />
</form>

<form action="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS" method="post">
   <input  name="ADDR" placeholder="Enter a Florida street address" type="text" value="{$PrmAddr}" />

<p>or use your
<a  class="ui-btn ui-icon-location ui-btn-icon-left ui-corner-all" href="javascript:GetCurrentLocation();">Current Location</a></p>


</form>

<p>or search Visulate using Google</p>
{literal}
<script>
  (function() {
    var cx = '008961708794472305428:WMX-359750769';
    var gcse = document.createElement('script');
    gcse.type = 'text/javascript';
    gcse.async = true;
    gcse.src = (document.location.protocol == 'https:' ? 'https:' : 'http:') +
        '//www.google.com/cse/cse.js?cx=' + cx;
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(gcse, s);
  })();
</script>
{/literal}
<gcse:search></gcse:search>
</div>
</div> <!--page-->
</body>
</html>
