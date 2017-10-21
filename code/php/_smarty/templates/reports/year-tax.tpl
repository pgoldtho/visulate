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
<table width="100%" height="100%">
<tr>
    <td colspan="4" align="left">
        <h2>Income and Expenses Report</h2>
        <b>Business unit: {$PrmBusinessName}
        <br>For the period: {$PrmPeriodStart} - {$PrmPeriodEnd}
        </b>
    </td>
</tr>
<tr>
    <td align="center"> <h3>Property</h3> </td>
    <td align="center"> <h3>Income</h3>   </td>
    <td align="center"> <h3>Expenses</h3> </td>
    <td align="center"> <h3>Total</h3> </td>
</tr>
{foreach from=$data key=key item=property}
<tr>
    <td align="left" valign="top" width="20%" headers="25px">
        <b>{$key}</b>
    </td>
    <td {*rowspan="2"*} align="right" valign="top" width="25%">
	    {assign var="property_income" value="0"}
      	{foreach from=$property.INCOMES item=income name=x}
		    {if $smarty.foreach.x.last }
		        {assign var="item_class" value="total"}
		        {assign var="property_income" value=$income.AMOUNT}
		    {else}
		        {assign var="item_class" value="normal"}
		    {/if}
		    <span class="{$item_class}">
		        {$income.PAYMENT_TYPE} : {show_number number=$income.AMOUNT} <br>
		    </span>
		{/foreach}
	 	&nbsp;
    </td>
    <td {*rowspan="2"*} align="right" valign="top" width="35%">
		{assign var="property_expenses" value="0"}
      	{foreach from=$property.EXPENSES item=expense name=y}
		    {if $smarty.foreach.y.last }
		        {assign var="item_class" value="total"}
		        {assign var="property_expenses" value=$expense.AMOUNT}
		    {else}
		        {assign var="item_class" value="normal"}
		    {/if}
		     <span class="{$item_class}">
		        {$expense.PAYMENT_TYPE} : {show_number number=$expense.AMOUNT} <br>
		     </span>
		{/foreach}
	 	&nbsp;
    </td>
{*</tr>
<tr>
*}
    <td align="right" valign="top" width="20%">
        Income : {show_number number=$property_income} <br>
        Expenses : {show_number number=$property_expenses} <br>
        <span class="total">Cash Flow :
            {assign var="result_class" value="total"}
            {if $property_income<$property_expenses}
                {assign var="result_class" value="negative"}
            {/if}
            <span class="{$result_class}">
                {show_number number=`$property_income-$property_expenses`}
            </span>
        </span>
        &nbsp;
    </td>
</tr>
{/foreach}
</table>
{if ($is_pdf_report)}
   {include file="reports/report-footer.tpl"}
{/if}
