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
  <table>
  <tr><th style="text-align:right">Amount Owed:</th><td style="text-align:right">{$summary.RECEIVABLE_AMOUNT}</td></tr>
	<tr><th style="text-align:right">Received:</th><td style="text-align:right">{$summary.ALLOCATED_AMOUNT}</td></tr>
	<tr><th style="border-top:1px #000000 solid; text-align:right">Balance Owed:</th><td style="border-top:1px #000000 solid; text-align:right">{$summary.BALANCE_AMOUNT}</td></tr>
  </table>

</div>
{include file="mobile-footer.tpl"}
