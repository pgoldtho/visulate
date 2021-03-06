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

  {if ($report_key == 'CORP')}
     <h3>{$report_element.NAME}</h3>
     <ol>
     {if ($report_element.NUMBER)}
     <li>Corp ID: <a href="visulate_search.php?CORP_ID={$report_element.NUMBER}">{$report_element.NUMBER}</a></li>
     {/if}
     <li><a href="http://www.google.com/search?q={$report_element.NAME}">Search Google</a></li>
     </ol>
     
  {/if}
  {if ($report_key == 'MAILING_ADDRESS')}
  <h4>Mailing Address</h4>
  {foreach from=$report_element key=k item=item}
  <p>  
    {$item.OWNER_NAME}<br/>
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
  <tr><th>Date</th><th>Buy/Sell</th><th>Property</th><th>Deed Type</th><th>Price</th></tr>
  {foreach from=$report_element key=t item=t_item name=trans}
  <tr>
  <td>{$t_item.SALE_DATE}</td>
  <td>{$t_item.BUY_SELL}</td>
  <td><a href="visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$t_item.PROP_ID}">		
	  {$t_item.ADDRESS1}, {$t_item.CITY}</a>
	</td>
  <td>{$t_item.DEED_DESC}</td>
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



{if ($is_pdf_report)}
   {include file="reports/report-footer.tpl"}
{/if}
