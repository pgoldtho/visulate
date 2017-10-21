{include file="header2.tpl"}

<h3>{$businessName} - Payment Rules</h3>

<form {$form_data.attributes}>   

    {show_error info=$errorObj}
        
    <table class="datatable">
    <tr>
        <th>Payment Type</th>
        <th>Transaction Type</th>
        <th>Debit Account</th>
        <th>Credit Account</th>
    </tr>
      {foreach from=$form_data.RULES item=item}
          <tr>
              <td>{$item.PAYMENT_TYPE_NAME.html}</td>
              <td>{$item.TRANSACTION_TYPE_NAME.html}</td>
              <td>{$item.DEBIT_ACCOUNT.html}</td>
              <td>{$item.CREDIT_ACCOUNT.html}</td>
          <tr>
      {/foreach}
    </table> 
    
   {if ($isEdit == "true")}
       {$form_data.cancel.html} {$form_data.save.html}
   {/if}    
   
   <br>
   
   {$form_data.hidden}
   
</form>

{include file="footer.tpl"}
