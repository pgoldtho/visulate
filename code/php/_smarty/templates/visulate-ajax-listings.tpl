{if ($commlist or $ziplist)}
<form id="ajaxForm" action="/rental/visulate_search.php" onsubmit="return false">
<input type="hidden" name="REPORT_CODE" value="AJAX" />
<input type="hidden" name="state" value="FL" />
{if ($county=="ANY" and $qtype != "LATEST")}
<input type="hidden" name="county" value="BREVARD" />
{elseif $qtype != "LATEST"}
<input type="hidden" name="county" value="{$county}" />
{/if}
<input type="hidden" name="city" value="{$city}" />

{if ($qtype=="COMMERCIAL" or $qtype=="LATEST" or $qtype=="HOMEPAGE")}
<table class="datatable" style="width: 100%">
<caption>{$pageDesc}</caption>
<tr>
<th>Search Type:</th>
<td>
<select class="ajaxSelect" name="qtype">
    <option value="HOMEPAGE" {if $qtype=="HOMEPAGE"}selected="selected"{/if}>Latest Commercial Listings</option>
    <option value="LATEST" {if $qtype=="LATEST"}selected="selected"{/if}>Latest County Listings</option>
    <option value="COMMERCIAL" {if $qtype=="COMMERCIAL"}selected="selected"{/if}>Commercial</option>
    <option value="RESIDENTIAL" >Residential</option>
    <option value="LAND" >Vacant Land</option>
</select>
</td>
{if ($qtype=="LATEST")}
<th>County:</th>
<td>
<select class="ajaxSelect" name="county">
{foreach name=outer item=loc from=$locations key=k}
<option value="{$loc.COUNTY}" {if $county== $loc.COUNTY}selected="selected"{/if}>
 {$loc.DISPLAY_LOCATION} ({$loc.LOCATION_COUNT|number_format:0:".":","})</option>
{/foreach}
</select>
</td>
{/if}

{if ($qtype=="COMMERCIAL")}

<th>County:</th>
<td>
<select class="ajaxSelect" name="county">
{foreach name=outer item=loc from=$locations key=k}
<option value="{$loc.COUNTY}" {if $county== $loc.COUNTY}selected="selected"{/if}>
 {$loc.DISPLAY_LOCATION} ({$loc.LOCATION_COUNT|number_format:0:".":","})</option>
{/foreach}
</select>
</td>

<th>Property Type:</th>
<td>
<select class="ajaxSelect" name="ZCODE">
  {foreach from=$commlist item=item}
    {if $item.ZCODE==$zcode}
        <option value="{$item.ZCODE}"selected="selected" >{$item.NAME}</option>
    {else}
        <option value="{$item.ZCODE}">{$item.NAME}</option>
    {/if}
   {/foreach}
</select>
</div>
</td>
<th>Price Class:</th>
<td>
 <select class="ajaxSelect" name="MAX" style="width: 50px;">
        <option value="A_MAX" {if $max=="A_MAX"}selected="selected"{/if}>A+</option>
    <option value="A_MEDIAN" {if $max=="A_MEDIAN"}selected="selected"{/if}>A</option>
    <option value="A_MIN" {if $max=="A_MIN"}selected="selected"{/if}>B+</option>
    <option value="B_MEDIAN" {if $max=="B_MEDIAN"}selected="selected"{/if}>B</option>
    <option value="C_MAX" {if $max=="C_MAX"}selected="selected"{/if}>C+</option>
    <option value="C_MEDIAN" {if $max=="C_MEDIAN"}selected="selected"{/if}>C</option>
</select>
</td>
{else}
<td>Added to Visulate on {$resultList[0].LISTING_DATE}</td>
<input type="hidden" name="ZCODE" value="{$commlist[0].ZCODE}" />
<input type="hidden" name="MAX" value="{$max}" />
{/if}
<tr>
</table>

{else}

<table class="datatable" style="width: 100%">
<caption>{$pageDesc}</caption>
<tr>
<th>Property Type:</th>
<td>
<select class="ajaxSelect" name="qtype">
    <option value="HOMEPAGE" >Latest Commercial Listings</option>
    <option value="LATEST" >Latest County Listings</option>
    <option value="COMMERCIAL" >Commercial</option>
    <option value="RESIDENTIAL" {if $qtype=="RESIDENTIAL"}selected="selected"{/if}>Residential</option>
    <option value="LAND" {if $qtype=="LAND"}selected="selected"{/if}>Vacant Land</option>
</select>
</td>

<th>County:</th>
<td>
<select class="ajaxSelect" name="county">
    {foreach name=outer item=loc from=$locations key=k}
      <option value="{$loc.COUNTY}" {if $county== $loc.COUNTY}selected="selected"{/if}>
      {$loc.DISPLAY_LOCATION} ({$loc.LOCATION_COUNT|number_format:0:".":","})</option>
    {/foreach}
</select>
</td>

<th>Zipcode:</th>
<td>
 <select class="ajaxSelect" name="ZCODE">
  {foreach from=$ziplist item=item}
    {if $item.ZCODE==$zcode}
        <option value="{$item.ZCODE}"selected="selected" >{$item.ZCODE} - {$item.PLACE_NAME}</option>
    {else}
        <option value="{$item.ZCODE}">{$item.ZCODE} - {$item.PLACE_NAME}</option>
    {/if}
   {/foreach}
</select>
</td>
<th>Price Class:</th>
<td>
 <select class="ajaxSelect" name="MAX">
    <option value="A_MAX" {if $max=="A_MAX"}selected="selected"{/if}>A+</option>
    <option value="A_MEDIAN" {if $max=="A_MEDIAN"}selected="selected"{/if}>A</option>
    <option value="A_MIN" {if $max=="A_MIN"}selected="selected"{/if}>B+</option>
    <option value="B_MEDIAN" {if $max=="B_MEDIAN"}selected="selected"{/if}>B</option>
    <option value="C_MAX" {if $max=="C_MAX"}selected="selected"{/if}>C+</option>
    <option value="C_MEDIAN" {if $max=="C_MEDIAN"}selected="selected"{/if}>C</option>
</select>
</td>
<tr>
</table>
{/if}
{if $resultList}
<!--h3 style="margin-top:0; padding-top:10px;">{$pageDesc}</h3-->
<div >
 {assign var="c" value=0}

 {foreach item=r from=$resultList name=rs}
 {if $c==0}
 <div class="row">
 {/if}
<div class="col-lg-3 col-md-6 col-sm-6">
<a style="border-style: none; padding: 0;" class="thumbnail text-center" href="{$url}&MAX={$max}&ZCODE={$zcode}&PROP_ID={$r.PROP_ID}">
{if ($r.PHOTO_URL)}
<img onmouseout="this.style.border='1px solid white';" onmouseover="this.style.border='1px solid #336699';"
src="/rental/php/resizeImg.php?w=400&h=300&src={$r.PHOTO_URL|escape:'url'}" style="width:400px; border: 1px solid white;" alt=""/>
{else}
<img src="/images/town.png" alt=""/>
{/if}
<span style="font-weight: 500;">{$r.ADDRESS1}, {$r.PRICE} </span></a></div>
{assign var="c" value=$c+1}

{if $c==4}
</div>
{assign var="c" value=0}
{/if}
 {/foreach}
  {if $c==0}<div class="row">{/if}

</div>
</div>

{else}
<p>No listings found</p>
{/if}

</form>



{literal}
<script type="text/javascript">
    function storageAvailable(type) {
        try {
             var storage = window[type],
                x = '__storage_test__';
                storage.setItem(x, x);
                storage.removeItem(x);
            return true;
            }
        catch(e) {
            return false;
            }
    }

   $j("select").simpleselect();
   $j('select.ajaxSelect').change(function(event){ 
        if (storageAvailable('localStorage')){
            localStorage.setItem('visulate_mls_query',  $j('#ajaxForm').serialize());
        }
        $j.ajax({
            url: '/rental/visulate_search.php',
            type: 'get',
            dataType:'html',   //expect return data as html from server
           data: $j('#ajaxForm').serialize(),
        success: function(response, textStatus, jqXHR){
              $j('#MLS-Listings').html(response);   //select the id and put the response in the html
            },
        error: function(jqXHR, textStatus, errorThrown){
              console.log('error(s):'+textStatus, errorThrown);
           }
        });
    });
</script>
{/literal}
{/if}



<div style="margin-top: 15px;">
<p >The data relating to real estate for sale on this web site comes from the Broker Reciprocity Programs of South East Florida,  Mid Florida MLS and Brevard County, Florida. Detailed information for each listing including the name of the listing broker is available by clicking on the property.</p>
<img src="/images/idx_brevard_small.gif" style="float:right;" alt=""/></div>
