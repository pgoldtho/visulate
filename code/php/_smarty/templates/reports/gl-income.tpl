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
<h2>{$PrmBusinessName} Income Statement</h2>
<table>
  <tr><th colspan="2"><b>Parameters:</b></th></tr>
  <tr><td align="right">Business Unit:</td><td>{$PrmBusinessName}</td></tr>
  <tr><td align="right">Property:</td><td>{$PrmPropertyName}</td></tr>  
  <tr><td align="right">Effective Date:</td><td>{$PrmEffectiveDate}</td></tr>  
  <tr><td align="right">Accounting Basis:</td><td>{$PrmReportType}</td></tr>  
</table>

{foreach from=$data key=rk item=r_item}
<h4>{$rk} Statement</h4>
<table class="datatable">
{foreach from=$r_item key=k item=item}
 {if $k == 'Month Ending:'
  || $k == 'Quater Ending:'
	|| $k == 'Year Ending:'
	|| $k == 'Revenue:'
	|| $k == 'Expenses:'
	|| $k == 'Result:'}
  <tr><th>{$k}</th>
      <th>{$item[1]}</th>
      <th>{$item[2]}</th>
      <th>{$item[3]}</th></tr>
 {else}
  <tr><th>{$k}</th>
      <td>{show_number number=$item[1]}</td>
      <td>{show_number number=$item[2]}</td>
      <td>{show_number number=$item[3]}</td></tr>
 {/if}
{/foreach}
</table>
{/foreach}

{if ($is_pdf_report)}
   {include file="reports/report-footer.tpl"}
{/if}
