{if ($is_pdf_report)}
   {include file="reports/report-header.tpl"}
{else}
	<style>
	     .normal {ldelim}
             font-size:11px;
			 padding:0px;
	   	 {rdelim}

		 .total {ldelim}
		     font-size:11px;
		     font-weight:bold;
		 	 padding-bottom:5px;
			 border-top:1px black solid;
		 {rdelim}

	     .negative {ldelim}
	         font-size:11px;
	         font-weight:bold;
	         border-top:1px black solid;
	         padding-bottom:5px;
	         color: red;
		 {rdelim}
	</style>
{/if}
<br>
<table class="datatable">
<tr><th>Business Unit:</th><td> {$PrmBusinessName}</td></tr>
<tr><th>Expense Type:</th><td> {$PrmPaymentType}</td></tr>
<tr><th>Basis:</th><td> {$PrmBasis}</td></tr>
<tr><th>Period:</th><td>{$PrmPeriodStart} - {$PrmPeriodEnd}</td></tr>
</table>

{foreach from=$data key=key item=property}
<h3>{$key} - {$PrmPaymentType}</h3>
  <table class="datatable" width="100%">
  <tr><th>Due Date</th><th>Vendor</th><th>Description</th><th>Amount</th></tr>
  {foreach from=$property.EXPENSES item=expense name=y}
    <tr>
    <td>{$expense.PAYMENT_DUE_DATE}</td>
    <td>{$expense.NAME}</td>
    <td>{$expense.DESCRIPTION}</td>
    <td>{show_number number=$expense.AMOUNT}</td>
    </tr>
  {/foreach}   
	<tr><td colspan="3"><b>Total</b></td><td><b>{show_number number=$property.TOTAL_AMOUNT}</b></td></tr>
  </table>
{/foreach}        

{if ($is_pdf_report)}
   {include file="reports/report-footer.tpl"}
{/if}
