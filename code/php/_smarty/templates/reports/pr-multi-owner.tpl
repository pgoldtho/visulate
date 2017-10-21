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


<table class="datatable">
<tr><th>Owner</th><th>Property Type</th><th>Property Count</th></tr>
{foreach from=$data key=k item=item}
  <tr>
  <td><a href="?m2=business_reports&REPORT_CODE=OWNER_DETAILS&OWNER_ID={$k}" target="_blank">{$item.OWNER_NAME}</a></td>
  <td>{$item.DESCRIPTION}</td>
  <td>{$item.PROPERTY_COUNT}</td>
  </tr>
{/foreach}
</table>

{if ($is_pdf_report)}
   {include file="reports/report-footer.tpl"}
{/if}
