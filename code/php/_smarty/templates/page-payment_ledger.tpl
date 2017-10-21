{include file="header2.tpl"}

<h1>{$businessName} - General Ledger</h1>

<form {$form_data.attributes}>   

    {show_error info=$errorObj}


<table>
 <tr><td>Accounting Period:</td><td>{$form_data.ACCOUNT_PERIOD.html}</td></tr>
{if ($isEdit == "true")}
  <tr><td>{$form_data.PERIOD_START.label}</td>
	    <td> {$form_data.PERIOD_START.html}
			     {calendar elements=$dates current=$form_data.PERIOD_START.name}
           {$form_data.create.html} {$form_data.delete.html} 
  </td></tr>
    {if @($form_data.PERIOD_START.error)}
		  <tr>
			       <td colspan="2">
				     <span class="error">{$form_data.PERIOD_START.error}</span>
				   </td>
			    </tr>
		     {/if}	
{/if}   
</table>



<h3>{$title}</h3>
<table class="datatable">

{if $title == "Account Summary"}
<tr><th>Account</th><th>Debit</th><th>Credit</th><th>Debit Amount</th><th>Credit Amount</th></tr>
{foreach from=$data key=k item=item}
  {if $item.ACCOUNT}
  <tr>  
  <td>{if $item.ACCOUNT_ID}
	     <a href="?m2=payment_ledger&ACCOUNT_ID={$item.ACCOUNT_ID}&ACCOUNT_PERIOD={$acct_period}">
			 {$item.ACCOUNT}</a>
	     {else}
	     <b>{$item.ACCOUNT}</b>
	     {/if}
	</td>
  <td>{if	$item.DEBIT}{show_number number=$item.DEBIT}{/if}</td>
  <td>{if	$item.CREDIT}{show_number number=$item.CREDIT}{/if}</td>
  <td>{if	$item.DEBIT_AMOUNT}{show_number number=$item.DEBIT_AMOUNT}{/if}</td>
  <td>{if	$item.CREDIT_AMOUNT}{show_number number=$item.CREDIT_AMOUNT}{/if}</td>
  </tr>
  {/if}
{/foreach}
{else}
<tr><th colspan="2">Account</th><th colspan="3">{$form_data.ACCOUNT_ID.html}</th></tr>
<tr><th>Date</th><th>Description</th><th>Debit</th><th>Credit</th><th>Balance</th></tr>
{foreach from=$data key=k item=item}
  <tr>  
  <td>{$item.DATE}</td>
  <td>{$item.DESC}</td>
  <td>{if	$item.DEBIT}{show_number number=$item.DEBIT}{/if}</td>
  <td>{if	$item.CREDIT}{show_number number=$item.CREDIT}{/if}</td>
  <td>{if	$item.BALANCE}{show_number number=$item.BALANCE}{/if}</td>
  </tr>
{/foreach}
{/if}
</table>

    
 
   <br>
   
   {$form_data.hidden}
   
</form>

{include file="footer.tpl"}
