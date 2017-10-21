{include file="header2.tpl"}

<h3>{$businessName} - Chart of Accounts</h3>

<form {$form_data.attributes}>   

    {show_error info=$errorObj}
        
    <table class="datatable">
    {if ($isEdit == "true")}
    <tr>
        <th colspan="2">Account Type:</th>
        <th colspan="3">
            {$form_data.ACCOUNT_TYPE_MAIN.html}
        </th>
        <th></th>
    </tr>
    {/if}
    <tr>
        <th>Account Number</th>
        <th>Name</th>
        <th>Current</th>
        <th>Owner Type</th>
        <th>Owner</th>
        {if ($isEdit == "true")}
            <th></th>
        {/if}
    </tr>
      {foreach from=$form_data.ACCOUNTS item=item}
          <tr>
              <td>{$item.ACCOUNT_NUMBER.html}</td>
              <td>{$item.NAME.html}</td>
              <td>{$item.CURRENT_BALANCE_YN.html}</td>
              <td>{$item.OWNER_TYPE.html}</td>
              <td>
                  {$item.OWNER_TYPE_BUSINESS.html}
                  {$item.USER_ASSIGN_ID.html}
                  {$item.PEOPLE_BUSINESS_ID.html}
              </td>
              {if ($isEdit == "true")}
                  <td>{$item.ACCOUNT_ID_LINK.html}</td>
              {/if}
          <tr>
      {/foreach}
    </table> 
    
   {if ($isEdit == "true")}
       {$form_data.cancel.html} {$form_data.save.html} {$form_data.new.html}
   {/if}    
   
   <br>
   
   {$form_data.hidden}
   
</form>

{include file="footer.tpl"}
