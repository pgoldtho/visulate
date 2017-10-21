{include file="header.tpl"}
<h1>{$header_title}</h1>
{show_error info=$errorObj}
{if ($isExists eq "true")}
<form {$form_data.attributes}>
<table>
 <tr>
  <td valign="top">  
	 <table class="datatable1">
		  {foreach from=$form_data item=element}
			  {if @($element.type == "text" || $element.type == "checkbox" || $element.type == "select" || $element.type == "link")}
				 {if @(@$element.error)}
					<tr>
					   <td colspan="2">
						 <span class="error">{$element.error}</span>
					   </td>
					</tr>
				 {/if}		  
				<tr>		  
				  <th>{$element.label}</th>
				  <td valign="middle">
					 {$element.html}{calendar form="formPeople" elements=$dates current=$element.name}
					 { if (@$element.required) } <span class="error">*</span> {/if}
				  </td>
				</tr>
			   {/if}	
		   {/foreach}    
	  </table>
  </td>	  
  <td valign="top">
      <table valign="top">
	    <tr>
		   <td valign="top">
		        <table class="datatable" style="font-size:12px">
                <caption>Payments Due</caption>
                <tbody>
				   <tr>
                     <th>Date</th><th>Item</th><th>Amount</th>
                   </tr>
                   {foreach from=$paymentDue item=item}  
				      <tr>
					    <td>{$item.PAYMENT_DUE_DATE}</td>
					    <td>{$item.RECEIVABLE_TYPE_NAME}</td>
						<td style="text-align:right">{$item.AMOUNT}</td>
					  </tr>
				   {/foreach}	  
				   <tr>
				     <td colspan="2"><b>Total</b></td>
					 <td><b>{$sum_due}</b></td>
				   </tr>	 
                 </tbody>
				</table>
		   </td>
		   <td valign="top">
                <table class="datatable" style="font-size:12px">
					<caption>Payments Made</caption>
					<tbody><tr>
					<th>Date</th><th>Amount</th>
					</tr>
					{foreach from=$paymentMade item=item}  
				      <tr>
					    <td>{$item.PAYMENT_DATE}</td>
						<td style="text-align:right">{$item.AMOUNT}</td>
					  </tr>
				   {/foreach}
				   <tr>
				     <td><b>Total</b></td>
					 <td><b>{$sum_made}</b></td>
				   </tr>	
				   </tbody>
			    </table>
		   </td>
		   <td valign="top">
		     <table class="datatable" style="font-size:12px">
		        <tbody>
				 <tr><th>Total Amount Due</th><td>{$sum_due}</td></tr>
                 <tr><th>Total Amount Paid</th><td>{$sum_made}</td></tr>
                 <tr><th>Balance</th><td>{$sum_balance}</td></tr>
                </tbody>
			  </table>	
		   </td>
		</tr>
	  </table>
	 {foreach from=$form_data item=element}
		 {if @($element.type == "submit")}
		 {$element.html}
	  {/if}
	 {/foreach} 
	 <br><br>
	 <table class="datatable">
	   <tr><th>{$form_data.TENANT_NOTE.label}</th></tr>
  	   <tr><td>{$form_data.TENANT_NOTE.html}</td></tr>
     </table>
    {$form_data.hidden}
  </td>
 </tr>
 </table> 
 </form>
{else}
  Not exists tenant records for property.
{/if}
{include file="footer.tpl"}