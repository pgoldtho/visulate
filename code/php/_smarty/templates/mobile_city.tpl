{include file="mobile-top.tpl"}



{if ($getCounty) }

{assign var="cur_region_id" value=999}
{foreach name=outer item=loc from=$locations key=k}
{if ($cur_region_id ne $loc.REGION_ID)}
{if $smarty.foreach.outer.first }
<div data-role="collapsibleset" data-theme="a" data-inset="true">
{else}
</ul></div>
{/if}
<div data-role="collapsible">
<h2>{if $getCounty}{$getCounty|lower|capitalize:true} County{else}{$loc.REGION_NAME} Region{/if}</h2>
<ul data-role="listview">
{assign var="cur_region_id" value=$loc.REGION_ID}
{assign var="cur_region_name" value=$loc.REGION_NAME}

{if ($getCity)}
<li data-icon="back"><a data-ajax="false"  href="/rental/visulate_search.php?REPORT_CODE=CITY&state={$loc.STATE}&county={$loc.COUNTY}&region_id={$loc.REGION_ID}">County</a></li>
{else}
<li data-icon="back"><a data-ajax="false"  href="/rental/visulate_search.php?REPORT_CODE=CITY&state={$loc.STATE}&region_id={$loc.REGION_ID}">Region</a></li>
{/if}

{/if}
<li><a data-ajax="false"  href="/rental/visulate_search.php?REPORT_CODE=CITY&state={$loc.STATE}&county={$loc.COUNTY}&city={$loc.CITY}&region_id={$loc.REGION_ID}">{$loc.DISPLAY_LOCATION}</a></li>
{if $smarty.foreach.outer.last }</ul></div></div>{/if}
{/foreach}
{elseif ($region_id)}

{assign var="cur_region_id" value=999}
{foreach name=outer item=loc from=$locations key=k}
{if ($cur_region_id ne $loc.REGION_ID)}
{if $smarty.foreach.outer.first }
<div data-role="collapsibleset" data-theme="a" data-inset="true">
{else}
</ul></div>
{/if}
<div data-role="collapsible">
<h2>{if $getCounty}{$getCounty|lower|capitalize:true} County{else}{$loc.REGION_NAME} Region{/if}</h2>
<ul data-role="listview">
{assign var="cur_region_id" value=$loc.REGION_ID}
{assign var="cur_region_name" value=$loc.REGION_NAME}
<li data-icon="back"><a data-ajax="false"  href="/rental/visulate_search.php?REPORT_CODE=CITY&state={$loc.STATE}">Florida</a></li>
{/if}
<li><a data-ajax="false"  href="/rental/visulate_search.php?REPORT_CODE=CITY&state={$loc.STATE}&county={$loc.COUNTY}&city={$loc.CITY}&region_id={$loc.REGION_ID}">{$loc.DISPLAY_LOCATION}</a></li>
{if $smarty.foreach.outer.last }</ul></div></div>{/if}
{/foreach}

{else}
<div data-role="collapsible">
<h2>Florida</h2>
<ul data-role="listview">
<li data-icon="home"><a  data-ajax="false" href="/rental/?m2=m_PROPERTY_DETAILS">Home Page</a></li>
<li><a data-ajax="false" href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=3">East Central</a></li>
<li><a data-ajax="false" href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=7">North Central</a></li>
<li><a data-ajax="false" href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=4">North Eastern</a></li>
<li><a data-ajax="false" href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=5">North West</a></li>
<li><a data-ajax="false" href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=8">South Central</a></li>
<li><a data-ajax="false" href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=1">South East</a></li>
<li><a data-ajax="false" href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=6">South West</a></li>
<li><a data-ajax="false" href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&region_id=2">Tampa Bay</a></li>
</ul>
</div>
{/if}

<div id="content" class="property-listing">
{if $cityDataValues}

{if ($cityDataValues.IMG_LIST)}


<!-- to change 
      <div id="city_images" class="nivoSlider" style="max-height: 237px; min-height: 237px;  width:100%">
  {foreach from=$cityDataValues.IMG_LIST key=k item=img name=ilist}
    {if ($img.ASPECT_RATIO=='16:10')}
         <img src="/rental/php/resizeImg.php?w=352&src=https://s3.amazonaws.com/visulate.cities/704x440/{$img.NAME}"
              title="{ $img.TITLE}" alt="{$img.ALT_TEXT}"/>{/if}
  {/foreach}

      </div>

<script type="text/javascript">
{literal}
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
{/literal}
  </script>
 to change -->



<!-- new -->
{literal}
<style>

       .large { 
         width: 100%;
        
       }

       .small { 
         width: 120px;
         float: left;
         display: inline;
       }

       .thumbs {
         width: 100%;
         height: 200px;
         white-space: nowrap;
       }

       .thumbList {
         width: 100%;
         white-space: nowrap;
         overflow-x: scroll;
         padding: 0;
         margin-top: 1px;
       }

       .imgItem {
         display: inline-block;
         margin: 0;
       }

       .selected {
         border: 1px black solid;
       }

       .photos {
         width: 98%;
         display: block;
         margin-left: auto;
         margin-right: auto;
       }

</style>
{/literal}



<div class="photos">
   {foreach from=$cityDataValues.IMG_LIST key=k item=img name=ilist}
     {if ($img.ASPECT_RATIO=='16:10')}
      {if $smarty.foreach.ilist.first}
         <img class="large"  src="/rental/php/resizeImg.php?w=352&src=https://s3.amazonaws.com/visulate.cities/704x440/{$img.NAME}">
         <ul class="thumbList">
      {/if}
      <li class="imgItem"><img class="small" src="/rental/php/resizeImg.php?w=352&src=https://s3.amazonaws.com/visulate.cities/704x440/{$img.NAME}"></li>
     {/if}
   {/foreach}
        </ul>
</div>
{literal}
      <script type="text/javascript">
      $(document).ready(function(){
        $('.small').click(function(){
          var smallsrc = $(this).attr('src').replace("w=120&h=90", "w=800&h=600");
          $('.large').attr('src', smallsrc);
        });
      });

      </script>

{/literal}
<!-- new -->



{/if}

<div class="column span-100">

{$cityDataValues.DESCRIPTION|replace:'<img src="https://s3.amazonaws.com':'<img src="/rental/php/resizeImg.php?w=352&src=https://s3.amazonaws.com'}

{/if}

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

{include file="adsense-mobile320x100.tpl"}

{include file="mobile-welcome.tpl"}

{include file="adsense-mobile320x100.tpl"}

<a data-ajax="false" class="ui-btn ui-icon-arrow-u ui-btn-icon-left ui-corner-all" href="#top">Return to Top</a>
</div>
{include file="mobile-footer-pub.tpl"}
