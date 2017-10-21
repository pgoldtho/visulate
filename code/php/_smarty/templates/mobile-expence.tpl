	{include file="mobile-top.tpl"}
	<div class="content">
		{include file="mobile-prop-select.tpl"}	
  <h1>{$header_title}</h1>
  {show_error info=$errorObj}
  <table class="datatable">
   <tr>
	   <th>
	     <form>
	     <select name="currYear" onchange="submit()">
		   {foreach from=$yearList item=item}
		     <option value="{$item.YEAR}"
			   {if ($item.YEAR eq $currentYear)}
			      selected
			   {/if}
			 >{$item.YEAR}
		   {/foreach}
		 </select>
  	      {$for_choose_year_form}
		 </form>
	   </th>
	   <th>Date</th>
	   <th>Unit</th>
	   <th>Description</th>
	    <th>Invoiced</th>
   </tr>

  {assign var="total_expenses_estimate" value="0"}
  {assign var="total_expenses_actual"   value="0"}
  {assign var="total_expenses_invoiced" value="0"}

  {foreach from=$expenseList item=item}
     <tr>
	  {if ($item.EXPENSE_ID == $currentExpenseID)}
	    <td class="current"></td>
	    <td class="current">{$item.EVENT_DATE}</td>
	    <td class="current">{$item.UNIT_NAME}</td>
	    <td class="current">{$item.DESCRIPTION}</td>
	    <td class="current" style="text-align:right">{show_number number=$item.INVOICED}</td>
	  {else}
	    <td><form><input type="radio" onclick="submit()">
		    <input type="hidden" name="EXPENSE_ID" value="{$item.EXPENSE_ID}">
            {$for_choose_expense_form}
			</form>
		</td>
	    <td>{$item.EVENT_DATE}</td>
	    <td>{$item.UNIT_NAME}</td>
	    <td>{$item.DESCRIPTION}</td>
	    <td style="text-align:right">{show_number number=$item.INVOICED}</td>
	  {/if}
	  {assign var="total_expenses_invoiced" value="`$total_expenses_invoiced+$item.INVOICED`"}
	 </tr>
  {/foreach}
	 <tr>
	     <td colspan="4" style="text-align:right">Total:</td>
	     <td style="text-align:right">{show_number number=$total_expenses_invoiced}</td>
	 </tr>
  </table>
 
  <form {$form_data.attributes}  onsubmit="return(checkForm())">
   {if $isEdit == "true"}
    {foreach from=$form_data item=item}
	  {if (($item.type eq "submit") && ($item.name ne "new_item") && ($item.name ne "new_account")) }
	     {$item.html}
	  {/if}
	{/foreach}<br><br>
    {/if}
  {$form_data.hidden}

  {if ($currentExpenseID || $action == "INSERT")}
     <h2>Description</h2>
		     <table class="datatable1">
			   <tr><th>{$form_data.EVENT_DATE.label}<span class="error">*</span></th><td><span class="error">{$form_data.EVENT_DATE.error}</span>{$form_data.EVENT_DATE.html} {calendar elements=$dates current=$form_data.EVENT_DATE.name}</td> </tr>
			   <tr><th>{$form_data.UNIT_ID.label}</th><td>{$form_data.UNIT_ID.html}</td> </tr>
			   <tr><th>{$form_data.RECURRING_YN.label}</th><td>{$form_data.RECURRING_YN.html} {$form_data.RECURRING_PERIOD.html}</td> </tr>
			   <tr><th>{$form_data.RECURRING_ENDDATE.label}</th><td><span class="error">{$form_data.RECURRING_ENDDATE.error}</span>{$form_data.RECURRING_ENDDATE.html} {calendar elements=$dates current=$form_data.RECURRING_ENDDATE.name}</td> </tr>
			 </table>
{$form_data.DESCRIPTION.html}			 
			 
   {else}
   <br>
   {/if}

</div>
{include file="mobile-footer.tpl"}
