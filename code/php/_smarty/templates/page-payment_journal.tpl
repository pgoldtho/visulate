{include file="header2.tpl"}

<form {$form_data.attributes}>   
 <div class="col-md-8">
  <h1>{$header_title}</h1>

</div>
<div class="col-md-4">
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
  <input type="submit" name="generateList" value="Update list"> to
              {if (@$form_data.UPDATE_LIST_DATE.error)}
                  <span class="error">({$form_data.UPDATE_LIST_DATE.error})</span>
              {/if}
    
              {$form_data.UPDATE_LIST_DATE.html}
              {calendar elements=$dates current=$form_data.UPDATE_LIST_DATE.name}
</div>  



<div class="col-md-12">  
{if ($businessID)}  

<form {$form_data.attributes}>   
    {show_error info=$errorObj}

<div class="col-md-8">
   <h3>Journal Entries</h3>
   
  {if ($isEdit eq "true")}
        {if ($form_data.OTHER_PAYMENTS|@count > 10)}
          <br/>
          {$form_data.save.html} {$form_data.cancel.html}          
        {/if}
       
      <a href="?{$menuObj->getParam2()}&BUSINESS_ID={$businessID}&FORM_ACTION=createOtherPayment&YEAR_MONTH_HIDDEN={$currYearMonth}&CURRENT_LEVEL3=unsched" class="small">New</a>
      <br/><br/>
  {/if}    
</div>  
<div class="col-md-12">
   <table class="datatable">
     <tr>
       <th>Date<span class="error">*</span></th>
       <th>Memo/Property<span class="error">*</span></th>
       <th>Amount<span class="error">*</span></th>
       <th>Debit/Credit<span class="error">*</span></th>
       {if ($isEdit eq "true")}
            <th></th>
       {/if}
     </tr>
     {if @($form_data.OTHER_PAYMENTS)} 
        {foreach from=$form_data.OTHER_PAYMENTS item=item key=key}
           <tr>
             <td>
                 {if @(@$item.PAYMENT_DATE.error)}
                       <span class="error">{$item.PAYMENT_DATE.error}</span>
                 {/if}
    
                 {$item.PAYMENT_DATE.html}

                 {if ($isEdit eq "true")}
                      {calendar elements=$dates current=$item.PAYMENT_DATE.name}
                 {/if}
             </td>
             <td>
                 {$item.DESCRIPTION.html}<br/>
                 {$item.PROPERTY_ID.html}
                 {*$item.ADDRESS1.html*}
             </td>
               <td>
                   {$item.AMOUNT.html}
               </td>
             <td>
                 {$item.DEBIT_ACCOUNT.html}<br/>
                 {$item.CREDIT_ACCOUNT.html}
             </td>
             {if ($isEdit eq "true")}
                   <td>{$item.LINK_DELETE.html}</td>
            {/if}
         </tr>
       {/foreach}    
    {/if}
   </table>    
   <a name="bottomOther"></a>
    {$form_data.hidden}
    <br>
    {$form_data.save.html} {$form_data.cancel.html}


</form>

{/if} 
</div>
</div>
{include file="footer.tpl"}
