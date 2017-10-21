{include file="top.tpl"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->

{literal}
<style>
.treeview-header {
    background:url(../../images/lm_bk.gif) repeat-y left top;
    margin-top:-12px;
    position:relative;
}
.treeview-footer {
    background:url(../../images/lm_bottom.gif) no-repeat left bottom!important;
    margin:0!important;
    padding-bottom:16px!important;
}
</style>

<script src="html/jqTreeview/lib/jquery.js" type="text/javascript"></script>
<script src="html/jqTreeview/lib/jquery.cookie.js" type="text/javascript"></script>
<script src="html/jqTreeview/jquery.treeview.js" type="text/javascript"></script>
<script type="text/javascript">
jQuery.noConflict();

jQuery(document).ready(function(){    
    jQuery("#browser").treeview({
        collapsed: false,
		unique: true,
		persist: "location"
    });
	jQuery("#browser").addClass("filetree");
	
	//jQuery("#browser").find("a").each(function(){this.href += "&type=data"});
	jQuery("#browser").find("a").click(function(){
	    this.href += "&type=data";	    
	});
});
</script>
{/literal}
          
<div id="left_part">
   <div id="nav">
      <h2 class="title">Cities</h2>
      <div class="treeview-header">{$cities_tree_html}</div>
      <div class="treeview-footer"></div>
   </div> <!-- end "nav" menu -->
</div> <!-- end left part -->


<!-- begin right part -->
<div id="right_part">  {*---right_part div is closed in footer.tpl---*}

{if $page_title} 
   {show_error info=$errorObj}
   <h3 style="color: #41464d;">{$page_title}</h3>   
   <div id="city_data_editor">
     <form {$form_data.attributes}>
        {$form_data.filter_ucode.html}
        {$form_data.filter_year.html}
        {$form_data.action_new.html}
        <br/><br/>
        <table class="datatable">
          <tr>
             <th>&nbsp;</th>
             <th>Class A</th>
             <th>Class B</th>
             <th>Class C</th>
          </tr>
          <tr>
             <th>Min Price</th>
             <td>{$form_data.PR_VALUES.A.MIN_PRICE.html}</td>
             <td>{$form_data.PR_VALUES.B.MIN_PRICE.html}</td>
             <td>{$form_data.PR_VALUES.C.MIN_PRICE.html}</td>
          </tr>
          <tr>
             <th>Median Price</th>
             <td>{$form_data.PR_VALUES.A.MEDIAN_PRICE.html}</td>
             <td>{$form_data.PR_VALUES.B.MEDIAN_PRICE.html}</td>
             <td>{$form_data.PR_VALUES.C.MEDIAN_PRICE.html}</td>
          </tr>
          <tr>
             <th>Max Price</th>
             <td>{$form_data.PR_VALUES.A.MAX_PRICE.html}</td>
             <td>{$form_data.PR_VALUES.B.MAX_PRICE.html}</td>
             <td>{$form_data.PR_VALUES.C.MAX_PRICE.html}</td>
          </tr>
          <tr>
             <th>Rent</th>
             <td>{$form_data.PR_VALUES.A.RENT.html}</td>
             <td>{$form_data.PR_VALUES.B.RENT.html}</td>
             <td>{$form_data.PR_VALUES.C.RENT.html}</td>
          </tr>
          <tr>
             <th>Vacancies and Bad Debt</th>
             <td>{$form_data.PR_VALUES.A.VACANCY_PERCENT.html}</td>
             <td>{$form_data.PR_VALUES.B.VACANCY_PERCENT.html}</td>
             <td>{$form_data.PR_VALUES.C.VACANCY_PERCENT.html}</td>
          </tr>
		  
          <tr>
             <th>Cap Rate</th>
             <td>{$form_data.PR_VALUES.A.CAP_RATE.html}</td>
             <td>{$form_data.PR_VALUES.B.CAP_RATE.html}</td>
             <td>{$form_data.PR_VALUES.C.CAP_RATE.html}</td>
          </tr>
          <tr>
             <th>Management Percentage</th>
             <td>{$form_data.PR_VALUES.A.MGT_PERCENT.html}</td>
             <td>{$form_data.PR_VALUES.B.MGT_PERCENT.html}</td>
             <td>{$form_data.PR_VALUES.C.MGT_PERCENT.html}</td>
          </tr>
          <tr>
             <th>Insurance</th>
             <td>{$form_data.PR_VALUES.A.REPLACEMENT.html}</td>
             <td>{$form_data.PR_VALUES.B.REPLACEMENT.html}</td>
             <td>{$form_data.PR_VALUES.C.REPLACEMENT.html}</td>
          </tr>
          <tr>
             <th>Maintentance</th>
             <td>{$form_data.PR_VALUES.A.MAINTENANCE.html}</td>
             <td>{$form_data.PR_VALUES.B.MAINTENANCE.html}</td>
             <td>{$form_data.PR_VALUES.C.MAINTENANCE.html}</td>
          </tr>
          <tr>
             <th>Utilities</th>
             <td>{$form_data.PR_VALUES.A.UTILITIES.html}</td>
             <td>{$form_data.PR_VALUES.B.UTILITIES.html}</td>
             <td>{$form_data.PR_VALUES.C.UTILITIES.html}</td>
          </tr>
        </table>
        
        {$form_data.hidden}
        {$form_data.action_save.html}
        {$form_data.action_cancel.html}
     </form>
  </div>  <!-- end dbcontent_editor -->
{else}  
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

{assign var="zoom_level" value="12"}
{if $location == "US"}
    {assign var="zoom_level" value="14"}
{/if}
map.drawZoomAndCenter("{$location}", "{$zoom_level}");
{foreach name=outer item=loc from=$cities_tree_data key=k}
    {if $loc.CITY_ID != "" }
        {if $location == "US"}
            {assign var="test" value="1"}
        {else}
            {instr var=test haystack=$loc.XPATH needle=$location}
        {/if}
            
        {if $test }
            var m{$k} = new YMarker("{$loc.XPATH}");
            m{$k}.addAutoExpand("{$loc.ITEM_TITLE}");
            map.addOverlay(m{$k});
        {/if}
    {/if}
{/foreach}
</script>

{/if}
   
{include file="footer.tpl"}