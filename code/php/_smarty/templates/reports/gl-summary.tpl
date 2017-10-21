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
<h2>{$PrmBusinessName} General Ledger Summary</h2>
<table>
  <tr><th colspan="2"><b>Parameters:</b></th></tr>
  <tr><td align="right">Business Unit:</td><td>{$PrmBusinessName}</td></tr>
  <tr><td align="right">From:</td><td>{$PrmPeriodStart}</td></tr>  
  <tr><td align="right">To:</td><td>{$PrmPeriodEnd}</td></tr>  
</table>
<h4>Details</h4>
<table class="datatable">
<tr><th>Account</th><th>Debit</th><th>Credit</th><th>Debit Amount</th><th>Credit Amount</th></tr>

{foreach from=$data key=k item=item}
  {if $item.ACCOUNT}
  <tr>  
  <td>{$item.ACCOUNT}</td>
  <td>{if	$item.DEBIT}{show_number number=$item.DEBIT}{/if}</td>
  <td>{if	$item.CREDIT}{show_number number=$item.CREDIT}{/if}</td>
  <td>{if	$item.DEBIT_AMOUNT}{show_number number=$item.DEBIT_AMOUNT}{/if}</td>
  <td>{if	$item.CREDIT_AMOUNT}{show_number number=$item.CREDIT_AMOUNT}{/if}</td>
  </tr>
  {/if}
{/foreach}

</table>

{if ($is_pdf_report)}
   {include file="reports/report-footer.tpl"}
{/if}
