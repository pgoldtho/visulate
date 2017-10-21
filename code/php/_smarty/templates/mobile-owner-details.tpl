{include file="mobile-top.tpl"}
 <div class="content"> 
<h3>{$pageTitle}</h3>

{if ($data)}
{foreach name=outer from=$data item=report_element key=report_key}
 
  {if ($report_key == 'MAILING_ADDRESS')}
  <h4>Mailing Address</h4>
  {foreach from=$report_element key=k item=item}
  <p>  
    {if $publicUser}
    Owner: {$item.OWNER_ID}<br/>
    {else}
    {$item.OWNER_NAME}<br/>
    {/if}
    <a href="visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$k}">		
    {$item.ADDRESS1}</a><br/>
    {if ($item.ADDRESS2)}{$item.ADDRESS2}<br/>{/if}
    {$item.CITY}<br/>
    {$item.STATE_ZIP}<br/>
  </p>
  {/foreach}
  {elseif ($report_key == 'TRANSACTIONS')}
  <h4>Transaction History</h4>
  <table class="datatable">
  <tr><th>Date</th><th>Buy/Sell</th><th>Property</th><th>Price</th></tr>
  {foreach from=$report_element key=t item=t_item name=trans}
  <tr>
  <td>{$t_item.SALE_DATE}</td>
  <td>{$t_item.BUY_SELL}</td>
  <td><a href="visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$t_item.PROP_ID}">		
	  {$t_item.ADDRESS1}, {$t_item.CITY}</a>
	</td>
  
  <td>{show_number number=$t_item.PRICE}</td>
  </tr>
  {/foreach}
  </table>
  {elseif ($report_key == 'PROPERTIES')}
  <h4>Current Properties</h4>
  <table class="datatable">
  <tr><th>Property</th><th>Purchased</th><th>Purchase Price</th></tr>
  {foreach from=$report_element key=t item=p_item name=props}
  <tr>
  <td><a href="visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$t}">		
	{$p_item.ADDRESS1}, {$p_item.CITY}</a>
	</td>
  <td>{$p_item.SALE_DATE}</td>
  <td>{show_number number=$p_item.PRICE}</td>
  </tr>
  {/foreach}
  </table>
  {/if}

{/foreach}
{/if}

<script type="text/javascript"><!--
google_ad_client = "ca-pub-9857825912142719";
/* Mobile */
google_ad_slot = "2459853012";
google_ad_width = 320;
google_ad_height = 50;
//-->
</script>
<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>

<h4>Property Search</h4>
<p>Enter a street address then press Search<br/>
or <a href="javascript:GetCurrentLocation();">use current location</a></p>

<form id="geoForm" action="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS" method="post">
  <input id="gLAT" name="LAT" type="hidden" />
  <input id="gLON" name="LON" type="hidden" />
</form>

<form action="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS" method="post">
   <input maxlength="80" name="ADDR" size="30" type="text" value="{$PrmAddr}" />
   <input name="submit_html" type="submit" value="Search" /></td>
</form>
</div>
{include file="mobile-footer-pub.tpl"}
