 	{include file="mobile-top.tpl"}
	<div class="content">
		{include file="mobile-bu-select.tpl"}	

  <h1>{$header_title}</h1>
  <table>
    <tr>
	  <td width="100">
		  {if @($form_data.PREV_YEAR_LINK)}
			 {$form_data.PREV_YEAR_LINK.html}
		  {/if}
	  </td>	  
	  <td width="100">
       {$form_data.YEAR_MONTH.html}
	  </td> 
	  <td width="100">
		  {if @($form_data.NEXT_YEAR_LINK)}
			 {$form_data.NEXT_YEAR_LINK.html}
		  {/if}
      </td>
	</tr>
  </table>	 
  
  <table cellpadding="0" cellspacing="0">
    <tr><td style="text-align:right">Amount Owed:</td><td style="text-align:right">{$summary.PAYABLE_AMOUNT}</td></tr>
	<tr><td style="text-align:right">Paid:</td><td style="text-align:right">{$summary.ALLOCATED_AMOUNT}</td></tr>
	<tr><td style="border-top:1px #000000 solid;text-align:right">Balance Owed:</td><td style="border-top:1px #000000 solid;text-align:right">{$summary.BALANCE_AMOUNT}</td></tr>
  </table>


</div>
{include file="mobile-footer.tpl"}
