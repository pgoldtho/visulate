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
<h2>Tenant Statement</h2>
<table>
  <tr><th colspan="2"><b>Parameters:</b></th></tr>
  <tr><td align="right">Business Unit:</td><td>{$PrmBusinessName}</td></tr>
  <tr><td align="right">Property:</td><td>{$PrmPropertyName}</td></tr>  
  <tr><td align="right">Agreeement:</td><td>{$PrmAgreementName}</td></tr>
</table>

{foreach from=$data item=item}
    <h4>{$item.PROPERTY.ADDRESS1}</h4>
	{foreach from=$item.AGREEMENTS item=a_item}
	    <h5>Agreement</h5> 
		Agreement Date : {$a_item.DATA.AGREEMENT_DATE}<br> 
		Unit : {$a_item.DATA.UNIT_NAME}<br>
		<b>Tenants:</b>
        <table class="datatable">
			   <tr>
				  <th>Tenant name</th>
				  <th>Unpaid Balance</th>
				  <th>Deposit balance</th>
				  <th>Last Month balance</th>
			   </tr>
			 {foreach from=$a_item.TENANTS item=t_item}
			  <tr>	   		   
				 <td>{$t_item.TENANT_NAME}</td>	
				 <td>{$t_item.ARREAR_AMOUNT}</td>	
				 <td>{$t_item.DEPOSIT_BALANCE}</td>				 
				 <td>{$t_item.LAST_MONTH_BALANCE}</td>				 			 
			 </tr>
		   {/foreach}
		</table>	
		<br>	
		<b>Running Total:</b>
   	     <table class="datatable">
			   <tr>
			      <th>Tenant Name</th> 
				  <th>Date Due</th>
				  <th>Amount Due</th>
				  <th>Date Paid</th>
				  <th>Amount Paid</th>
				  <th>Unpaid Balance</th>				  
			   </tr>
			 {foreach from=$a_item.RUNNINGTOTAL item=it}
			  <tr>	   		   
				 <td>{$it.TENANT_NAME}</td>	
				 <td>{$it.START_DATE}</td>	
				 <td>{$it.DUE_AMOUNT}</td>				 
				 <td>{$it.PAYMENT_DATE}</td>				 			 
				 <td>{$it.ALLOCATED_AMOUNT}</td>				 			 
				 <td>{$it.ARREARS}</td>				 			 				 				 
			 </tr>
		   {/foreach}
		</table>
	{/foreach}
{/foreach}
{if ($is_pdf_report)}
   {include file="reports/report-footer.tpl"}
{/if}
