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
<tr><th>Owner</th><th>Address</th><th>Usage</th> </tr>
{foreach from=$data key=k item=item}
  <tr>
  <td><a href="?m2=business_reports&REPORT_CODE=OWNER_DETAILS&OWNER_ID={$k}"
	       target="visulate-report">{$item.OWNER_NAME}</a>
	    {if $item.M_ADDRESS1}
			{$item.M_ADDRESS1}, {$item.M_CITY}, {$item.M_STATE} {$item.M_ZIPCODE}</td>
			{/if}
  <td><a href="?m2=business_reports&REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$item.PROP_ID}"
	       target="visulate-report">  
	    {$item.ADDRESS1},</a></br>
	    {$item.CITY},</br>
	    {$item.STATE}{$item.ZIPCODE}</br>
	</td>
	<td>{$item.USAGE} </td>
  </tr>
{/foreach}
</table>

{if ($is_pdf_report)}
   {include file="reports/report-footer.tpl"}
{/if}
