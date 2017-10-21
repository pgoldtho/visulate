{if ($commlist or $ziplist)}
<form id="ajaxForm" action="/rental/visulate_search.php" onsubmit="return false">
<input type="hidden" name="REPORT_CODE" value="AJAX" />
<input type="hidden" name="state" value="FL" />
{if (($qtype=="HOMEPAGE" or $qtype=="COMMERCIAL") and $county=="ANY")}
<input type="hidden" name="county" value="BREVARD" />
{elseif (($qtype=="HOMEPAGE" or $qtype=="COMMERCIAL") and $county!="ANY")}
<!--input type="hidden" name="county" value="{$county}" /-->
{/if}
<input type="hidden" name="city" value="{$city}" />

<form>
<fieldset id="queryForm" data-role="controlgroup">
<label for="qtype">Search Type</label>
<select class="ajaxSelect" name="qtype">
        <option value="HOMEPAGE" {if $qtype=="HOMEPAGE"}selected="selected"{/if}>Latest Commercial Listings</option>
        <option value="LATEST" {if $qtype=="LATEST"}selected="selected"{/if}>Latest County Listings</option>
        <option value="COMMERCIAL" {if $qtype=="COMMERCIAL"}selected="selected"{/if}>Commercial</option>
        <option value="RESIDENTIAL" {if $qtype=="RESIDENTIAL"}selected="selected"{/if}>Homes for Sale</option>
        <option value="LAND" {if $qtype=="LAND"}selected="selected"{/if}>Vacant Land</option>
</select>

{if ($qtype!="HOMEPAGE")}
<label for="county">County</label>
<select class="ajaxSelect" name="county">
{foreach name=outer item=loc from=$locations key=k}
<option value="{$loc.COUNTY}" {if $county== $loc.COUNTY}selected="selected"{/if}>
 {$loc.DISPLAY_LOCATION} ({$loc.LOCATION_COUNT|number_format:0:".":","})</option>
{/foreach}
</select>
{/if}

{if ($qtype=="COMMERCIAL")}
<label for="ZCODE">Property Type:</label>
<select class="ajaxSelect" name="ZCODE">
  {foreach from=$commlist item=item}
    {if $item.ZCODE==$zcode}
        <option value="{$item.ZCODE}"selected="selected" >{$item.NAME}</option>
    {else}
        <option value="{$item.ZCODE}">{$item.NAME}</option>
    {/if}
   {/foreach}
</select>
{/if}

{if (($qtype=="RESIDENTIAL")||($qtype=="LAND"))}
<label for="ZCODE">Zipcode:</label>
 <select class="ajaxSelect" name="ZCODE">
  {foreach from=$ziplist item=item}
    {if $item.ZCODE==$zcode}
        <option value="{$item.ZCODE}"selected="selected" >{$item.ZCODE} - {$item.PLACE_NAME}</option>
    {else}
        <option value="{$item.ZCODE}">{$item.ZCODE} - {$item.PLACE_NAME}</option>
    {/if}
   {/foreach}
</select>
{/if}

{if ($qtype=="LATEST")||($qtype=="HOMEPAGE")}
<p>Added to Visulate on {$resultList[0].LISTING_DATE}</p>
<input type="hidden" name="ZCODE" value="{$commlist[0].ZCODE}" />
<input type="hidden" name="MAX" value="{$max}" />
{else}
<label for="MAX">Price Class:</label>
<select class="ajaxSelect" name="MAX" style="width: 50px;">
        <option value="A_MAX" {if $max=="A_MAX"}selected="selected"{/if}>A+</option>
        <option value="A_MEDIAN" {if $max=="A_MEDIAN"}selected="selected"{/if}>A</option>
        <option value="A_MIN" {if $max=="A_MIN"}selected="selected"{/if}>B+</option>
        <option value="B_MEDIAN" {if $max=="B_MEDIAN"}selected="selected"{/if}>B</option>
        <option value="C_MAX" {if $max=="C_MAX"}selected="selected"{/if}>C+</option>
        <option value="C_MEDIAN" {if $max=="C_MEDIAN"}selected="selected"{/if}>C</option>
</select>

{/if}
</fieldset>
</form>
<script>
      $('#queryForm').controlgroup();
</script>



{if $resultList}
<p>{$pageDesc}</p>

<ul data-role="listview" data-inset="true" id="mlsListings">
   {foreach name=rs item=r from=$resultList key=k}
   <li><a href="{$url}&MAX={$max}&ZCODE={$zcode}&PROP_ID={$r.PROP_ID}" >
   {if ($r.PHOTO_URL)}
    <img src="/rental/php/resizeImg.php?w=80&h=80&src={$r.PHOTO_URL|escape:'url'}" class="ui-li-thumb"/>
   {else}
    <img src="/rental/php/resizeImg.php?w=80&h=80&src=https://visulate.com/images/town.png" class="ui-li-thumb"/>
   {/if}
    
    <h2>{$r.PRICE}</h2>

    <p>{$r.ADDRESS1} 
    <span class="ui-li-count">{$k+1}/{$resultList|@count} </span>
   </p></a>
   </li>
   {/foreach}
</ul>
<img src="/images/idx_brevard_small.gif" />
<h2> Broker Reciprocity</h2>
<p>The data relating to real estate for sale on this web site comes from the Broker Reciprocity Programs of South East, Mid and Brevard County, Florida. Detailed information for each listing including the name of the listing broker is available by clicking on the property.</p>
       
<script>
      $('#mlsListings').listview();
</script>


{else}
<p>No listings found</p>
{/if}





{literal}
<script type="text/javascript">

$('select.ajaxSelect').change(function(event){
  $.ajax({
    url: '/rental/visulate_search.php',
    type: 'get',
    dataType:'html',   //expect return data as html from server
   data: $('#ajaxForm').serialize(),
   success: function(response, textStatus, jqXHR){
      $('#MLS-Listings').html(response);   //select the id and put the response in the html
    },
   error: function(jqXHR, textStatus, errorThrown){
      console.log('error(s):'+textStatus, errorThrown);
   }
 });  
 });
 </script>
{/literal}
{elseif ($qtype=="HOMEPAGE")}
<h3>MLS Listings</h3>
{if $resultList}
<table class="datatable">
 {assign var="c" value=0} 
 {foreach item=r from=$resultList name=rs}
 {if $c==0}
 <tr>
 {/if}
 <td><a href="{$url}&MAX={$max}&ZCODE={$zcode}&PROP_ID={$r.PROP_ID}">
<img onmouseout="this.style.border='1px solid white';" onmouseover="this.style.border='1px solid #336699';"
src="/rental/phpthumb/examples/remote_image_resize.php?size=213&img={$r.PHOTO_URL}" style="width: 213px; border: 1px solid white;"/>
<span>{$r.ADDRESS1},  {$r.PRICE}</span></a></td>
 {assign var="c" value=$c+1} 
 {if $c==3}
</tr>
{assign var="c" value=0} 
{/if}
 {/foreach}
 {if $c==0}
 <tr><td>&nbsp;</td><td>&nbsp;</td>
 {elseif $c==1}
 <td>&nbsp;</td>
 {/if}
  <td>
	<p style="width: 213px;">
		The data relating to real estate for sale on this web site comes from the Broker Reciprocity Programs of Mid Florida MLS and Brevard County, Florida. Detailed information for each listing including the name of the listing broker is available by clicking on the property.</p>
	<img src="/images/idx_brevard_small.gif" style="float:right;" /></td>
</tr>
</table>
{/if}


{/if}


