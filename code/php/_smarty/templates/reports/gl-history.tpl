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
<h2>{$PrmBusinessName} General Ledger History</h2>
<table>
  <tr><th colspan="2"><b>Parameters:</b></th></tr>
  <tr><td align="right">Business Unit:</td><td>{$PrmBusinessName}</td></tr>
  <tr><td align="right">Property:</td><td>{$PrmPropertyName}</td></tr>  
  <tr><td align="right">From:</td><td>{$PrmPeriodStart}</td></tr>
  <tr><td align="right">To:</td><td>{$PrmPeriodEnd}</td></tr>  
</table>

<h4>Details</h4>
<table class="datatable">
<tr><th>Date</th><th>Entry</th><th>Debit</th><th>Credit</th><th>Amount</th></tr>

{foreach from=$data key=k item=item}
  
  <tr>  
  <td>{$item.ENTRY_DATE}</td>
  <td>{$item.DESCRIPTION}</td>
  <td>{$item.DEBIT_ACCOUNT}</td>
  <td>{$item.CREDIT_ACCOUNT}</td>
  <td>{show_number number=$item.AMOUNT}</td>  
  </tr>
  
{/foreach}

</table>

{if ($is_pdf_report)}
   {include file="reports/report-footer.tpl"}
{/if}
