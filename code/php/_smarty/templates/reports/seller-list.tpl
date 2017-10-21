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

<div class="column span-40">
<table class="datatable">
<tr><th>Buyers</th><th>Purchased</th></tr>
{foreach from=$bdata key=k item=item}
  <tr>  
  <td><a href="?m2=business_reports&REPORT_CODE=OWNER_DETAILS&OWNER_ID={$k}">{$item.OWNER_NAME}</a></td>
  <td>{$item.PROPERTY_COUNT}</td>
  </tr>
{/foreach}
</table>
</div>
<div class="column span-40">
<table class="datatable">
<tr><th>Sellers</th><th>Sold</th></tr>
{foreach from=$sdata key=k item=item}
  <tr>  
  <td><a href="?m2=business_reports&REPORT_CODE=OWNER_DETAILS&OWNER_ID={$k}">{$item.OWNER_NAME}</a></td>
  <td>{$item.PROPERTY_COUNT}</td>
  </tr>
{/foreach}
</table>
</div>

{if ($is_pdf_report)}
   {include file="reports/report-footer.tpl"}
{/if}
