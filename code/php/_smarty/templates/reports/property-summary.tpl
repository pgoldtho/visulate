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
<h2>{$PrmBusinessName} Property Summary</h2>
<table>
  <tr><th colspan="2"><b>Parameters:</b></th></tr>
  <tr><td align="right">Business Unit:</td><td>{$PrmBusinessName}</td></tr>
  <tr><td align="right">Property:</td><td>{$PrmPropertyName}</td></tr>  

</table>
<h4>Details</h4>
<table class="datatable">
<tr><th>Address</th><th>Units</th><th>Size</th><th>Built</th><th>Description</th></tr>

{foreach from=$data key=k item=item}
  {if $item.ADDRESS1}
  <tr>  
  <td><b>{$item.ADDRESS1}</b>, {$item.ADDRESS2}<br/> {$item.CITY}<br/> {$item.STATE}{$item.ZIPCODE}</td>
  <td>{$item.COUNT_UNITS}</td>
  <td>{$item.BUILDING_SIZE} sq ft</td>
  <td>{$item.YEAR_BUILT}</td>
  <td>{$item.DESCRIPTION}</td>
  </tr>
  {/if}
{/foreach}

</table>

{if ($is_pdf_report)}
   {include file="reports/report-footer.tpl"}
{/if}
