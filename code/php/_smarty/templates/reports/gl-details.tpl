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
<h2>{$PrmBusinessName} General Ledger Details</h2>
<table>
  <tr><th colspan="2"><b>Parameters:</b></th></tr>
  <tr><td align="right">Business Unit:</td><td>{$PrmBusinessName}</td></tr>
  <tr><td align="right">From:</td><td>{$PrmPeriodStart}</td></tr>  
  <tr><td align="right">To:</td><td>{$PrmPeriodEnd}</td></tr>  
</table>
<h4>Details</h4>
<table class="datatable">
<tr><th>Account</th><th>Date</th><th>Description</th><th>Debit</th><th>Credit</th><th>Balance</th></tr>

{foreach from=$data key=k item=item}
  
  <tr>  
  <td>{$item.ACCOUNT}</td>
  <td>{$item.DATE}</td>
  <td>{$item.DESC}</td>
  <td>{if	$item.DEBIT}{show_number number=$item.DEBIT}{/if}</td>
  <td>{if	$item.CREDIT}{show_number number=$item.CREDIT}{/if}</td>
    <td>{if	$item.BALANCE}{show_number number=$item.BALANCE}{/if}</td>
  </tr>
  
{/foreach}

</table>

{if ($is_pdf_report)}
   {include file="reports/report-footer.tpl"}
{/if}
