{include file="header_units.tpl"}
<script language="JavaScript" src="{$PATH_FROM_ROOT}html/agreement.js" type="text/javascript"></script>
{literal}
<script language="JavaScript" type="text/javascript">
  <!--
  window.addEvent('domready', function() 
      {
     $each($$("p.help"), function (e, index)
            {
           e.setStyle('display', 'none');
          });
         

    helptext("AGR_DATE_AVAILABLE");
    helptext("AGR_UNIT_NAME");
    helptext("AGR_TERM");
    helptext("AGR_AMOUNT");
    helptext("AGR_AMOUNT_PERIOD");
    helptext("AGR_DISCOUNT_AMOUNT");
    helptext("AGR_DISCOUNT_PERIOD");
    helptext("AGR_DISCOUNT_TYPE");
    helptext("AGR_AGREEMENT_DATE");
    helptext("AGR_END_DATE");
    helptext("AGR_DEPOSIT");
    helptext("AGR_LAST_MONTH");
    });
   -->
</script>
{/literal}

{$script}
<div class="col-md-12">
   <form {$form_data.attributes}> 
     <h1>{$header_title}</h1>
      {show_error info=$errorObj}
</div>

{if ($is_exists) }    
<div class="col-md-4">    
   <table class="datatable1">
      {foreach from=$form_data item=element}
          {if @($element.type == "text" || $element.type == "checkbox" || $element.type == "select")}
             {if @(@$element.error)}
                <tr>
                   <td colspan="2">
                     <span class="error">{$element.error}</span>
                   </td>
                </tr>
             {/if}    {*---element.error---*}
            <tr>    
              <th>{$element.label}</th>
                  <td class="{$element.name}">
                 {$element.html}
                 {calendar elements=$dates current=$element.name}
                 { if (@$element.required) } <span class="error">*</span> {/if}
              </td></tr>
            </tr>
           {/if}    {*---element type---*}
    {/foreach}    
   </table>    
</div>
{/if} {*---is_exists---*}    


<div class="col-md-8 actionDiv">
{$form_data.hidden}

{if ($role == "ADVERTISE")}
<h3>Actions (page 3 of 4)</h3>  
  {if ($is_exists == "true") }
    <p>Select the property and unit that you want to advertise from the list on
    the left of this page.  <b>Make sure you press the Save button before
        clicking Next.</b></p>
        <p>{$advertise_prev}{$advertise_next}</p>
    <p>{$form_data.delete_agr.html}{$form_data.cancel.html}{$form_data.accept.html}</p>
    {else}
      <p>Select the property and unit that you want to advertise in from the list on
       the left of this page then press the "New Agreement" button.  If you don't
             see any properties listed on the left of the page you may need to create one.
             Click on the "My Properties" link in the menu bar to do this.</p>
             <p>{$advertise_prev}</p>
        <p style="float: right">{$form_data.new_agreement.html}</p>
  {/if}{*---is_exists---*}    

{else}
<h3>Actions and Instructions</h3>
  <p>First select and click on the property on the left of the screen, 
    click new agreement and enter the details requested -the late fee is
    automatically recorded into the payment/receivable screen, the grace period
    is the number of days before the late fee is applied. Press save, when all
    the information has been entered Then click on Add tenant. The tenant will
    already need to be in the system under the people screen, when you click on
    the arrow at Tenant name a choice of people will come up. Zero balances must
    also be recorded. If your tenant is receiving section 8 assistance you can
    record which office they are with and the amount that section 8 pays
    </p>
   {foreach from=$issues_list item=issue}
       {show_error info=$issue prefix="Warning:" class="warning"}
   {/foreach}
  <p>
  {if ($isEdit == "true") }
     {$form_data.delete_agr.html} 
         {$form_data.cancel.html}
         {$form_data.accept.html}
         {if ($role != "ADVERTISE")}
           {$form_data.new_agreement.html}
           {$form_data.add_tenant.html}
       {/if}{*---userRole---*}
  {/if}{*---isEdit---*}    
  {$form_data.prev_agreement.html} {$form_data.next_agreement.html}
    </p>
  {/if}{*---userRole == Advertise---*} 
</div>

<div id="helpText" class="col-md-8 actionDiv">
<h3>Instructions</h3>
<p>Mouse over the data entry fields to see help text</p>
<p id="AGR_DATE_AVAILABLE_help" class="help">Enter the date that the property or unit will become available for rent.</p>
<p id="AGR_UNIT_NAME_help" class="help">Use the menu on the left of this page to change the value in this field.</p>
<p id="AGR_TERM_help" class="help">The number of months the unit will be available (e.g. 12)</p>
<p id="AGR_AMOUNT_help" class="help">The rental amount.</p>
<p id="AGR_AMOUNT_PERIOD_help" class="help">The rental period (e.g. month, week .. etc)</p>
<p id="AGR_DISCOUNT_AMOUNT_help" class="help">An amount in dollars that the tenant will be charged if they are late in paying the rent.</p>
<p id="AGR_DISCOUNT_PERIOD_help" class="help">The number of days late that the tenant has to be to incure a late fee.  Visulate will generate accounts receivable records for late fees in based on this value.</p>
<p id="AGR_DISCOUNT_TYPE_help" class="help">Does the tenancy agreement describe the late fee as an early payment discount or an additional fee?</p>
<p id="AGR_AGREEMENT_DATE_help" class="help">What date was the tenancy agreement signed?  Visulate will generate accounts receivable records for rent due based on this date, the rent amount and rent period.</p>
<p id="AGR_END_DATE_help" class="help">The end date for the tenancy agreement.</p>
<p id="AGR_DEPOSIT_help" class="help">The deposit amount that the landlord will collect from the tenant before they move in.</p>
<p id="AGR_LAST_MONTH_help" class="help">The last month rent amount that the landlord will collect from the tenant before they move in.</p>
</div>


{if ($action != "INSERT_AGREEMENT")}
{if ($role != "ADVERTISE")}
<div class="col-md-12">
    <h1>Tenants and Applicants</h1>
        <table class="datatable">
           <tr>
              <th>Tenant name<span class="error">*</span></th>
              <th>Status<span class="error">*</span></th>
              <th>Deposit balance<span class="error">*</span></th>
              <th>Last Month balance<span class="error">*</span></th>
              <th>Section8 office</th>
    
              <th>Section8 tenant pays</th>
              <th>Details</th>
              <th></th>
           </tr>
          {foreach from=$form_data.TENANTS item=element}
            <tr>
          {foreach from=$element item=element1}
             <td>
                  {$element1.html}
                  {if @($element1.error)}
                         <br><span class="error">{$element1.error}</span>
                  {/if}{*---element.error---*}
                </td>
          {/foreach}
         </tr>
       {/foreach}
    
        </table>
{/if} {*---isAdvertise---*}
{/if}{*---action != INSERT_AGREEMENT ---*}    
</div>    
{include file="footer.tpl"}
