{include file="header_units.tpl"}
<div class="col-md-12">
<h1>{$header_title}</h1>
             {show_error info=$errorObj}
               <form action="index.php" method="POST" id="postVals" name="postVals">
                     {$hidden_fields}
                     {if ($isEdit eq "true")}
                       {$form_data.TEMPLATE.html}
                       <input type="submit" name="s_new_action" value="New action">
                     {/if}
                     {if ($prev_agreement) }
                        <input type="submit" name="s_prev_agreement" value="Prev agreement">
                     {else}
                           <input type="submit" name="s_prev_agreement" value="Prev agreement" disabled="disabled">
                     {/if}
    
                     {if ($next_agreement)}
                        <input type="submit" name="s_next_agreement" value="Next agreement">
                     {else}
                           <input type="submit" name="s_next_agreement" value="Next agreement" disabled="disabled">
                     {/if}
                   </form>

              <table class="datatable" width="100%">
                       <tr>
                          {if ($isEdit eq "true")}
                          <th></th>
                          {/if}
                          <th>Date <span class="error">*</span></th>
                          <th>Action <span class="error">*</span></th>
                          <th>Cost <span class="error">*</span></th>
                          <th>Recoverable</th>
                          {if ($isEdit eq "true")}
                          <th></th>
                          {/if}
                       </tr>
              {foreach from=$actionList item=element}
                {if ($element.ACTION_ID == $currentActionID) }
                  <form {$form_data.attributes}>
                   <tr>
                      <td style="background-color:#eeeeee"></td>
                          {foreach from=$form_data item=element}
                            {if @($element.type == "text"
                               || $element.type == "checkbox"
                                 || $element.type == "select")&& ($element.name != "TEMPLATE")}
                              <td style="background-color:#eeeeee">
                                {if @(@$element.error)}
                                   <span class="error">{$element.error}</span>
                                {/if}
                                {$element.html}
                                {calendar elements=$dates current=$element.name}
                                </td>
                             {/if}
                           {/foreach}
                      <td style="background-color:#eeeeee"></td>
                    </tr>
                    <tr>
                       <td colspan="6" style="text-align:center;background-color:#eeeeee">
              
              {$ckEditor->editor('COMMENTS', $comments, $cke_config)}
              
              

                       </td>
                    </tr>
                    <tr>
                       <td colspan="6" style="background-color:#eeeeee">
                           {foreach from=$form_data item=element}
                             {if @($element.type == "submit")}
                                {$element.html}
                             {/if}
                           {/foreach}
                       </td>
                    </tr>
                    {$form_data.hidden}
                   </form>
                {else}
                      <tr>
                           {if ($isEdit eq "true")}
                            <td>{$element.EDIT_LINK}</td>
                        {/if}
                        <td>{$element.ACTION_DATE}</td>
                        <td>{$element.ACTION_TYPE_NAME}</td>
                        <td>{$element.ACTION_COST}</td>
                        <td style="text-align:center">
                            {if ($element.RECOVERABLE_YN eq 'Y') }
                               [ X ]
                            {else}
                               [ &nbsp; ]
                            {/if}
                        </td>
                           {if ($isEdit eq "true")}
                             <td>{$element.DELETE_LINK}</td>    
                        {/if}
                      </tr>
                  {/if}
              {/foreach}
              </table>

{if ($is_exists eq "true")}
<div class="col-md-4">
              <h2>Agreement Terms</h2>
                  <table class="datatable1">
                 {foreach from=$agrData item=element}
                    <tr>
                        <th>{$element.name}</th>
                        <td>{$element.value}</td>
                    </tr>
                 {/foreach}
                 </table>
</div>
<div class="col-md-8">    
<h2>Balance Summary</h2>
    

           <table class="datatable">
               <tr>
                  <th>Tenant name</th>
                  <th>Unpaid Balance</th>
                  <th>Deposit balance</th>
                  <th>Last Month balance</th>
               </tr>
             {foreach from=$tenantList item=element}
              <tr>
                 <td>{$element.TENANT_NAME}</td>
                 <td>{$element.ARREAR_AMOUNT}</td>
                 <td>{$element.DEPOSIT_BALANCE}</td>
                 <td>{$element.LAST_MONTH_BALANCE}</td>
             </tr>
           {/foreach}
        </table>
         <h2>Payment History</h2>
            <table class="datatable">
               <tr>
                  <th>Tenant Name</th>
                  <th>Date Due</th>
                  <th>Amount Due</th>
                  <th>Date Paid</th>
                  <th>Amount Paid</th>
                  <th>Unpaid Balance</th>
               </tr>
             {foreach from=$TenantRunningTotal item=it}
              <tr>
                 <td>{$it.TENANT_NAME}</td>
                 <td>{$it.START_DATE}</td>
                 <td>{$it.DUE_AMOUNT}</td>
                 <td>{$it.PAYMENT_DATE}</td>
                 <td>{$it.ALLOCATED_AMOUNT}</td>
                 <td>{$it.ARREARS}</td>
             </tr>
           {/foreach}
        </table>
</div>    
    
    
    
 {else}
   <h1>{$header_title}</h1>
   No agreements exists for property.    
 {/if}
</div>
{include file="footer.tpl"}
