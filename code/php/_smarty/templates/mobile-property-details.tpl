    {if ($data)}
{assign var="hidden" value=$data.PROPERTY.HIDDEN}
{assign var="propid" value=$data.PROP_ID}
{assign var="address1" value=$data.PROPERTY.ADDRESS1}
{assign var="displayLocation" value=$data.PROPERTY.CITY}
{/if}
{if ($skey==1)}
{include file="mobile-top.tpl" noindex="y"}
<div data-role="navbar" data-iconpos="left"><ul>
<li><a data-ajax="false" href="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$propid}" data-icon="star">Property</a></li>
<li><a href="#" class="ui-btn-active" data-icon="grid">Estimates</a></li>
</ul></div>
{else}
{include file="mobile-top.tpl"}
<div data-role="navbar" data-iconpos="left" ><ul>
<li><a href="#" class="ui-btn-active" data-icon="star">Property</a></li>
<li><a data-ajax="false"  href="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$propid}&MODE=cashflow" data-icon="grid">Estimates</a></li>
</ul></div>
{/if}


<div id="content" class="content">
<h1>{$data.PROPERTY.ADDRESS1}, {$data.PROPERTY.CITY}</h1>

{if (($skey==1) && not isset($listingReport))}
  {include file="mobile-property-details-cashflow.tpl"}
{else}
  {if ($photos)}
    {foreach item=photo from=$photos key=k}
      {assign var=main_picture value=`$photo.URL`}
    {/foreach}
  {/if}
  {include file="mobile-property-details-main.tpl"}
{/if}
  
</div>
{include file="mobile-footer-pub.tpl"}






