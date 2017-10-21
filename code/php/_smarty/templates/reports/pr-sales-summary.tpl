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
<tr><th>Transaction Type</th><th>Transaction Count</th></tr>
{foreach from=$data key=k item=item}
  <tr>
  <td><a href="?m2=business_reports&REPORT_CODE=RECENT_SALES&DEED_CODE={$k}&ZIPCODE={$PrmZipcode}&CITY={$PrmCity}">{$item.DESCRIPTION}</a></td>
  <td>{$item.DEED_COUNT}</td>
  </tr>
{/foreach}
</table>

{if ($is_pdf_report)}
   {include file="reports/report-footer.tpl"}
{/if}
