{include file="header.tpl"}
<ul  class="pagination" style="margin-top: 0px; margin-left: 5px; margin-bottom: 0px;">
<li><a id="valueA"  onclick="setCurrent('valueA'); showDiv('valueDiv');return false;" href="#"> Values</a></li>
<li><a id="paymentA" onclick="setCurrent('paymentA'); showDiv('paymentDiv');return false;" href="#">Payment History</a></li>
</ul>

<script language="JavaScript" src="{$PATH_FROM_ROOT}html/finance.js" type="text/javascript"></script>
<script language="JavaScript" src="{$PATH_FROM_ROOT}html/cap_calc.js" type="text/javascript"></script>

{literal}
<script type="text/javascript">
 isDomLoaded = false;
    function doCalcDetails(index)
    {
        var value = parseFloat($("VALUES["+index+"][VALUE]").getProperty('value'));
        var loan_amount = parseFloat($("VALUES[0][LOAN_AMOUNT]").getProperty('value'));
        var eqity = 0;
        var ltv   = 0;
        
        try
        {
            eqity = value - loan_amount;
            $("VALUES["+index+"][EQUITY]").setProperty('value', addCommas(eqity.toFixed(2)));
        }
        catch(e) {}
        
        try
        {
            ltv = loan_amount/value * 100;
            $("VALUES["+index+"][LTV]").setProperty('value', ltv.toFixed(2));
        }
        catch(e) {}
    }
    
            function hideDivs(){
            $('valueDiv').setStyles({display : 'none'});
            $('paymentDiv').setStyles({display : 'none'});
        }

        function unsetCurrent()
        {
            $('valueA').removeClass('current');
            $('paymentA').removeClass('current');
        }

        function setCurrent(aName){
            unsetCurrent();
             $(aName).addClass("current");
            $('CURRENT_LEVEL3').setProperty('value', aName);
            return false;
        }


        function showDiv(divName){
            hideDivs();
            $(divName).setStyles({display : 'block'});
            return false;
        }

        function getDivByMenuL3(menuName){
            if (menuName == "valueA")
               return "valueDiv";
            if (menuName == "paymentA")
               return "paymentDiv";
        }
      window.addEvent('domready', function(){
        showDiv(getDivByMenuL3($('CURRENT_LEVEL3').getProperty('value')));
        setCurrent($('CURRENT_LEVEL3').getProperty('value'));
        isDomLoaded = true;
        });
</script>
{/literal}

{$script}

<style>
   .sum 
   {ldelim}
       border-top:  2px #000000 solid;
       font-weight: bold;
   {rdelim}
   
   .text_item_readonly
   {ldelim}
       background-color: rgb(221, 221, 221);
       color:            rgb(128, 128, 128);
   {rdelim}
</style>

   <form {$form_data.attributes}>
<table class="layouttable" width="100%">
    <tr>
     <td><h1>{$header_title}</h1>
      {show_error info=$errorObj}

      <table class="datatable">
            <tr>
            <th>Loan Date<span class="error">*</span></th>
            <th width="40">Position <span class="error">*</span></th>
            <th>Amount <span class="error">*</span></th>
            <th>Term<span class="error">*</span></th>
            <th>Interest Rate <span class="error">*</span></th>
            <th>Credit Line <span class="error">*</span></th>
            <th>ARM <span class="error">*</span></th>
            <th>Interest Only <span class="error">*</span></th>
            <th>Closing costs</th>
            <th>Monthly Payment</th>
            <th>Balloon Date</th>
            <th>Settlement Date</th>
              {if ($isEdit == "true")}
             <th></th>
            {/if}
            </tr>
        {if @($form_data.LOANS)}
                {foreach from=$form_data.LOANS item=element}
                   <tr>
                     {foreach from=$element item=element1}
                        <td>
                          {$element1.html}
                          {calendar form="formFin" elements=$dates current=$element1.name}
                          {if @($element1.error)}
                             <br><span class="error">{$element1.error}</span>
                          {/if}
                       </td>
                     {/foreach}
                     </tr>
               {/foreach}
       {/if}
    </table>
      {if ($isEdit == "true")}
             <br>
           {$form_data.cancel.html} {$form_data.accept.html} {$form_data.new_loan.html}
         {$form_data.hidden}
      {/if}
     </td>
    </tr>
 </table>
 
 <div id="valueDiv" style="display:none">
 <div class="col-md-4">
 <h2>Account Balances</h2>
 <table  class="datatable">
 <tr><th>Account</th><th>Balance</th></tr>
 {foreach from=$account_bals item=a}
   {if $a.BALANCE != 0}
   <tr><td>{$a.ACCOUNT}</td><td>{$a.BALANCE|number_format:2:".":","}</td></tr>
   {/if}
 {/foreach}
 </table>
</div>
 <div class="col-md-8">
 <h2>Property Values</h2>
 <table class="datatable">
 <tr>
     <th>Date</th>
     <th>Method</th>
     <th>Value</th>
     <th>Equity</th>
     <th>LTV</th>
     {if ($isEdit == "true")}
         <th></th>
     {/if}
 </tr>
     {foreach from=$form_data.VALUES item=item}
         <tr>
             <td>
                 {$item.VALUE_DATE.html}
                 {calendar form="formFin" elements=$dates current=$item.VALUE_DATE.name}
             </td>
             <td>{$item.VALUE_METHOD.html}</td>
             <td>{$item.VALUE.html}
                 {$item.LOAN_AMOUNT.html}
             </td>
             <td>{$item.EQUITY.html}</td>
             <td>{$item.LTV.html} %</td>
             {if ($isEdit == "true")}
                 <td>{$item.VALUE_ID_LINK.html}</td>
             {/if}
         <tr>
     {/foreach}
 </table> 
 {if ($isEdit == "true")}
       {$form_data.cancel.html} {$form_data.accept_value.html} {$form_data.new_value.html}
 {/if} 
</form>
 
   
       
 {if ($isSold == "false")}
 
 <table class="layouttable" width="100%">
    <tr>
       <td valign="top">
            <br>
            <form name="calcValueForm" action="{$action}">
            <h1>Performance</h1>
             {$form_data.currYear.label} {$form_data.currYear.html}

               <table>
                 <tr>
                   <td>
                       {$form_data.SELECTED_DATE.label} {$form_data.SELECTED_DATE.html}
                       <table class="datatable">
                           <tr><th colspan="2">Income</th></tr>
                           {foreach from=$form_data.DETAILS.RECEIVABLE item=item}
                                  <tr><td>{$item.label}</td><td>{$item.html}</td></tr>
                           {/foreach}
                           <tr><td class="sum">{$form_data.CALC_AMOUNT_GROSS.label}</td><td class="sum">{$form_data.CALC_AMOUNT_GROSS.html}</td></tr>
                           <tr><th colspan="2">Expense</th></tr>
                           {foreach from=$form_data.DETAILS.PAYABLE item=item}
                                  <tr><td>{$item.label}</td><td>{$item.html}</td></tr>
                           {/foreach}
                           <tr><td class="sum">{$form_data.CALC_AMOUNT_EXPENSE.label}</td><td class="sum">{$form_data.CALC_AMOUNT_EXPENSE.html}</td></tr>
                           <tr><th>{$form_data.DEBT_SERVICE.label}</th><th>{$form_data.DEBT_SERVICE.html}</th></tr>
                           <tr><th>{$form_data.CALC_NOI.label}</th><th>{$form_data.CALC_NOI.html}</th></tr>
                        </table>
                    </td>
                   <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                   </td>
                   <td>
                       <table class="datatable1">
                           <tr><th>{$form_data.CALC_CAP_RATE.label}</th><td>{$form_data.CALC_CAP_RATE.html}</td></tr>
                           <tr><th>{$form_data.CALC_PURCHASE_PRICE.label}</th><td>{$form_data.CALC_PURCHASE_PRICE.html}</td></tr>
                           <tr><th>{$form_data.CALC_AMOUNT_LOAN.label}</th><td>{$form_data.CALC_AMOUNT_LOAN.html}</td></tr>
                           <tr><th>{$form_data.CALC_CLOSING_COSTS.label}</th><td>{$form_data.CALC_CLOSING_COSTS.html}</td></tr>
                           <tr><th>{$form_data.CALC_CASH_INVESTED.label}</th><td>{$form_data.CALC_CASH_INVESTED.html}</td></tr>
                           <tr><th>{$form_data.CALC_CASH_ON_CASH.label}</th><td>{$form_data.CALC_CASH_ON_CASH.html}</td></tr>                                                                                      </table>
                       </table>
                       <div class="error">{$form_data.CALC_WARN.label}</div>
                 </td>
               </tr>
             </table>
             {$hiden}
            </form>
       </td>
    </tr>
 </table>
 </div>
{/if}
</div>
<div id="paymentDiv" style="display:none">
<div class="col-md-12">
    {foreach from=$payments item=e key=k}
    <h2>Position {$k} Loan Payment History</h2>
    <table class="datatable">
    <tr>
    <th>Date</th><th>Description</th><th>Payment Type</th><th>Amount</th>
    </tr>
    {foreach from=$e item=e1 key=k1}
    <tr>
        <td>{$e1.PAYMENT_DATE}</td>
    {if $e1.DESCRIPTION == "Total"}
        <td>Total</td>
    {else}
        <td><a href="/rental/?currYear={$e1.EXPENSE_YEAR}&EXPENSE_ID={$e1.EXPENSE_ID}&prop_id={$e1.PROPERTY_ID}&m2=property_expense">{$e1.DESCRIPTION}</a></td>
    {/if}
        <td>{$e1.PAYMENT_TYPE}</td>
        <td>{$e1.AMOUNT|number_format:2:".":","}</td>
        </tr>
    
    
        {/foreach}
        </table>
    {/foreach}
</div>
</div>

{include file="footer.tpl"}
