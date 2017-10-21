{include file="homeTop.tpl"}
{include file="letterbox-img.tpl"}
{literal}
<script>
jQuery(document).ready(function() {
 
jQuery(window).scroll(function() {
var scrollPos = jQuery(window).scrollTop();
if (scrollPos > 267) {
  jQuery("#left_part").css({"position": "fixed", "top": "51px", "bottom": 0, "overflow": "scroll"});
}else{
  jQuery("#left_part").css({"position": "absolute", "top": "320px", "overflow": "visible"});
}
});
    
});
</script>
{/literal}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content" style="margin-top: 0">



<!-- begin right part -->
<div id="qright_part">  {*---right_part div is closed in footer.tpl---*}
    
<!--<h2>Florida Real Estate</h2>
<img src="https://s3.amazonaws.com/visulate.cities/700x140/search-{1|rand:11}.jpg"  alt="Florida" style="border: 1px solid #949494; width: 713px;"/>
-->
{$report_text}
<div id="MLS-Listings" style="padding: 0px 6px;"></div>
<script type="text/javascript">
{if ($current_county=='ANY')}{literal}
    var mls_query = localStorage.getItem('visulate_mls_query');
    if (mls_query) {
        jQuery("#MLS-Listings").load("/rental/visulate_search.php?" + mls_query);
    }
    else {
        jQuery("#MLS-Listings").load("/rental/visulate_search.php?REPORT_CODE=AJAX&qtype=HOMEPAGE");
    }{/literal}
 {elseif ($zcode)}
jQuery("#MLS-Listings").load("/rental/visulate_search.php?REPORT_CODE=AJAX&qtype={$qtype}&state=FL&county={$current_county}&ZCODE={$zcode}&MAX={$max}");
{elseif ($qtype == 'COMMERCIAL')}
jQuery("#MLS-Listings").load("/rental/visulate_search.php?REPORT_CODE=AJAX&qtype=COMMERCIAL&state=FL&county={$current_county}");
{elseif ($qtype == 'LAND')}
jQuery("#MLS-Listings").load("/rental/visulate_search.php?REPORT_CODE=AJAX&qtype=LAND&state=FL&county={$current_county}");
{else}
jQuery("#MLS-Listings").load("/rental/visulate_search.php?REPORT_CODE=AJAX&qtype=LATEST&state=FL&county={$current_county}");
{/if}
</script>

{if $resultList}
<h3>Search Results</h3>
<table class="datatable">
 {assign var="c" value=0}
 {foreach item=r from=$resultList name=rs}
 {if $c==0}
 <tr>
 {/if}
 <td><a href="{$url}&MAX={$max}&ZCODE={$zcode}&PROP_ID={$r.PROP_ID}">
<img onmouseout="this.style.border='1px solid white';" onmouseover="this.style.border='1px solid #336699';"
src="{$r.PHOTO_URL}" style="width: 160px; border: 1px solid white;"/>
<span>{$r.ADDRESS1},  {$r.PRICE}</span></a></td>
 {assign var="c" value=$c+1}
 {if $c==4}
</tr>
{assign var="c" value=0}
{/if}
 {/foreach}
 {if $c==0}
 <tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
 {elseif $c==1}
 <td>&nbsp;</td><td>&nbsp;</td>
 {elseif $c==2}
 <td>&nbsp;</td>
 {/if}
  <td>
  <p style="width: 160px;">
    The data relating to real estate for sale on this web site comes from the Broker Reciprocity Programs of South East, Mid Florida MLS and Brevard County, Florida. Detailed information for each listing including the name of the listing broker is available by clicking on the property.</p>
  <img src="/images/idx_brevard_small.gif" style="float:right;" /></td>
</tr>
</table>
{else}
{if (($qtype ne 'COMMERCIAL')||($county eq 'ANY'))}
{include file="visulate-welcome.tpl"}
{/if}{* $qtype != 'COMMERCIAL') *}

{/if}
{if $listingTable}
<h3>Price Range</h3>
<div class="btn-group" role="group">

<div  class="btn-group" role="group">
    <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
    {$qtype|lower|ucfirst}
    <span class="caret"></span>
  </button>
    
              <ul class="dropdown-menu">
                 {foreach from=$ReportList item=item name=l3menu}
       {if $smarty.foreach.l3menu.last }
          {assign var="l3class" value="li_left_last"}
       {elseif $smarty.foreach.l3menu.first }
          {assign var="l3class" value="li_left_first"}
       {else}
        {assign var="l3class" value="li_left_normal"}
       {/if}
                 {if ($item.code eq $reportCode)||($item.code eq $qtype)}
                    <li class="{$l3class}"><a href="{$item.href}" class="active">{$item.title}</a></li>
                 {else}
                    <li class="{$l3class}"><a href="{$item.href}">{$item.title}</a></li>
                 {/if}
                {/foreach}
              </ul>
</div>
  <div  class="btn-group" role="group">            
    <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu2" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
    {$current_county|lower|ucfirst}
    <span class="caret"></span>
  </button>
               <ul class="dropdown-menu">
                {foreach name=outer item=loc from=$locations key=k}
                         {if $smarty.foreach.outer.last }
                            {assign var="l3class" value="li_left_last"}
                         {elseif $smarty.foreach.outer.first }
                            {assign var="l3class" value="li_left_first"}
                         {else}
                            {assign var="l3class" value="li_left_normal"}
                         {/if}

                  <li class="{$l3class}"><a {if ($loc.COUNTY eq $current_county)} class="active" {/if}
                   href="/rental/visulate_search.php?REPORT_CODE={$reportCode}&qtype={$qtype}&state={$loc.STATE}&county={$loc.COUNTY}">{$loc.DISPLAY_LOCATION}:
                   ({$loc.LOCATION_COUNT|number_format:0:".":","})</a></li>

                {/foreach}
              </ul>
  </div>
</div>

<table class="datatable" style="width: 100%">
<tr><th>{if ($qtype eq 'COMMERCIAL')}Property Type{else}City, Zipcode{/if}</th><th colspan="6">Maximum Price </th><th>Properties</th></tr>
  {foreach item=l2 from=$listingTable key=k}
  <tr><th>{$l2.NAME}</th>
    <td style="text-align: right;">
    <a href="{$url}&ZCODE={$k}&MAX=A_MAX" {if ($zcode==$k) && ($max=='A_MAX')}{$selected}{/if}>
        {$l2.A_MAX|number_format:0:".":","}</td>
  <td style="text-align: right;">
    <a href="{$url}&ZCODE={$k}&MAX=A_MEDIAN" {if ($zcode==$k) && ($max=='A_MEDIAN')}{$selected}{/if}>
       {$l2.A_MEDIAN|number_format:0:".":","}</td>
  <td style="text-align: right;">
    <a href="{$url}&ZCODE={$k}&MAX=A_MIN" {if ($zcode==$k) && ($max=='A_MIN')}{$selected}{/if}>
       {$l2.A_MIN|number_format:0:".":","}</td>
  <td style="text-align: right;">
      <a href="{$url}&ZCODE={$k}&MAX=B_MEDIAN" {if ($zcode==$k) && ($max=='B_MEDIAN')}{$selected}{/if}>
     {$l2.B_MEDIAN|number_format:0:".":","}</td>
  <td style="text-align: right;">
      <a href="{$url}&ZCODE={$k}&MAX=C_MAX" {if ($zcode==$k) && ($max=='C_MAX')}{$selected}{/if}>
     {$l2.C_MAX|number_format:0:".":","}</td>
  <td style="text-align: right;">
      <a href="{$url}&ZCODE={$k}&MAX=C_MEDIAN" {if ($zcode==$k) && ($max=='C_MEDIAN')}{$selected}{/if}>
     {$l2.C_MEDIAN|number_format:0:".":","}</td>
  <td style="text-align: right;">{$l2.TOTAL|number_format:0:".":","}</td></tr>
  {/foreach}
</table>




{/if}
{include file="google-analytics.tpl"}

{include file="footer.tpl"}
