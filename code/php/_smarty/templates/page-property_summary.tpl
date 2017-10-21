{include file="header.tpl"}

<table class="layouttable" width="100%" border=0>
	<tr>
	 <td><h1 style="font-size:25;">{$header_title} - Summary</h1>
	  {show_error info=$errorObj}

		<table cellpadding=0 cellspacing=0 border=0>
			<tr>
				<td>

	  {if (@$isData)}
			<table class="datatable">

	            		<tr>
			      			<th>Year</th>
	  	  	      			<td colspan=3>
								<select id="date_" onchange="document.location.href='{$link}&type={$type}&year='+this.value/*+'{if ($radio_id)}&radio_id={$radio_id}{/if}'*/;">
				{foreach from=$select_years item=element}
								<option value="{$element}"{if ($year==$element)} selected{/if}>{$element}</option>
	       		{/foreach}
								</select>
				  			</td>
						</tr>
	            		<tr>
			      			<th></th>
			      			<th>Amount Owed</th>
			      			<th>Amount Paid</th>
							<td></td>
						</tr>
	            		<tr>
			      			<td colspan=4>Income</td>
						</tr>

				{foreach from=$data_receivable item=element}
	            		<tr>
			      			<th>{$element.label}</th>
	  	  	      			<td>
				     			<input type="text" value="{$element.AMOUNT_OWED}" disabled="disabled">
				  			</td>
	  	  	      			<td>
				     			<input type="text" value="{$element.AMOUNT_RECEIVED}" disabled="disabled">
				  			</td>
	  	  	      			<td>
				     			<input type="radio" name="r1" {if (@$checked!=$element.id)}onclick="document.location.href='{$link}&type=RECEIVABLE{if ($year)}&year={$year}{/if}&radio_id={$element.id}';"{/if}{if (@$checked==$element.id)} checked{/if}>
				  			</td>
						</tr>
	       		{/foreach}

	            		<tr>
			      			<th>Total</th>
	  	  	      			<td>
				     			<input style="font-weight:bold;" type="text" value="{$Income_Total_Owed}" disabled="disabled">
				  			</td>
	  	  	      			<td>
				     			<input style="font-weight:bold;" type="text" value="{$Income_Total_Received}" disabled="disabled">
				  			</td>
							<td>
							</td>
						</tr>

	            		<tr>
			      			<td colspan=4>Expense</td>
						</tr>

				{foreach from=$data_payable item=element}
	            		<tr>
			      			<th>{$element.label}</th>
	  	  	      			<td>
				     			<input type="text" value="{$element.AMOUNT_OWED}" disabled="disabled">
				  			</td>
	  	  	      			<td>
				     			<input type="text" value="{$element.AMOUNT_RECEIVED}" disabled="disabled">
				  			</td>
	  	  	      			<td>
				     			<input type="radio" name="r1" {if (@$checked!=$element.id)}onclick="document.location.href='{$link}&type=PAYABLE{if ($year)}&year={$year}{/if}&radio_id={$element.id}';"{/if}{if (@$checked==$element.id)} checked{/if}>
				  			</td>
						</tr>
	       		{/foreach}

	            		<tr>
			      			<th>Total</th>
	  	  	      			<td>
				     			<input style="font-weight:bold;" type="text" value="{$Expense_Total_Owed}" disabled="disabled">
				  			</td>
	  	  	      			<td>
				     			<input style="font-weight:bold;" type="text" value="{$Expense_Total_Received}" disabled="disabled">
				  			</td>
							<td>
   					        </td>

						</tr>

			</table>
		{else}
		 <p class="error" style="font-size:20;"><b>No data!</b></p>
	  {/if}

		</td>
		<td width=5>
		</td>
		<td>
	  {if (@$radio_id)}
			<table class="datatable">
				<tr>
					<td colspan=3>{$radio_text}</td>
				</tr>
				<tr>
					<th>Date</th>
					<th>Amount Owed</th>
					<th>Amount Paid</th>
				</tr>

				{foreach from=$data_at_right item=element}
				<tr>
	  				<td>
		     			<a href="{$element.href}">{$element.date}</a>
					</td>
	  				<td>
		     			<input type="text" value="{$element.AMOUNT_OWED}" disabled="disabled">
					</td>
	  				<td>
		     			<input type="text" value="{$element.AMOUNT_RECEIVED}" disabled="disabled">
					</td>
				</tr>
	       		{/foreach}

			</table>
	  {/if}

		</td>
	</tr>
</table>
</td>
</tr>
</table>
{include file="footer.tpl"}
