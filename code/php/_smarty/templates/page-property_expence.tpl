{include file="header.tpl"}
<ul class="pagination" style="margin-top: 0px; margin-left: 5px; margin-bottom: 0px;">
<li><a href="#" class="current" id="descA" onclick="setCurrent('descA');  showDiv('descDiv');return false;"> Description</a></li>
<li><a href="#" id="itemsA" onclick="setCurrent('itemsA');  showDiv('itemsDiv');return false;">Estimates</a></li>
<li><a href="#" id="invoiceA" onclick="setCurrent('invoiceA');  showDiv('invoiceDiv');return false;">Invoices</a></li>
</ul>
<script language="JavaScript" src="{$PATH_FROM_ROOT}html/expense.js" type="text/javascript"></script>
<script language="JavaScript" src="{$PATH_FROM_ROOT}html/cap_calc.js" type="text/javascript"></script>
{$script}
{literal}
    <script language="JavaScript" type="text/javascript">
    <!--
        isDomLoaded = false;

        function hideDivs(){
            $('descDiv').setStyles({display : 'none'});
            $('itemsDiv').setStyles({display : 'none'});
            $('invoiceDiv').setStyles({display : 'none'});
        }

        function unsetCurrent()
        {
            $('descA').removeClass('current');
            $('itemsA').removeClass('current');
            $('invoiceA').removeClass('current');
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
            if (menuName == "descA")
               return "descDiv";
            if (menuName == "itemsA")
               return "itemsDiv";
            if (menuName == "invoiceA")
               return "invoiceDiv";
        }

        function changeSupplierItem(radioItem){
            radioItem.form.FORM_ACTION.value = "SELECT_OTHER_SUPPLIER";
            radioItem.form.submit();
        }

        function changeItemsAcceptedFlag(checkboxItem, supplier_id) {
            var items = document.getElementsByName("ITEMS_SUPPLIER_ID");
            for(i in items)
            {
                items[i].checked = (items[i].value == supplier_id) ? true : false;
            }
            checkboxItem.form.FORM_ACTION.value = "CHANGE_ITEMS_ACCEPTED_FLAG";
            checkboxItem.form.submit();
        }

        function doCalc(index){
           if (!isDomLoaded)
              return;
           var itemCost = stripCommas2($("ITEMS["+index+"][ITEM_COST]").getProperty('value'));
           var actual = stripCommas2($("ITEMS["+index+"][ACTUAL]").getProperty('value'));
           var estimate = stripCommas2($("ITEMS["+index+"][ESTIMATE]").getProperty('value'));
           try {
                $("ITEMS["+index+"][ESTIMATE_COST]").setProperty('value', addCommas((itemCost*estimate).toFixed(2)));
           }
              catch(e){
           }

              try {
                $("ITEMS["+index+"][ACTUAL_COST]").setProperty('value', addCommas((itemCost*actual).toFixed(2)));
           }
              catch(e){
           }


        }

      window.addEvent('domready', function(){
        showDiv(getDivByMenuL3($('CURRENT_LEVEL3').getProperty('value')));
        isDomLoaded = true;
    });
    //-->
    </script>
{/literal}
<div class="col-md-12">
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
       <th>Recurring</th>
       <th>Estimate</th>
       <th>Actual</th>
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
        <td class="current" style="text-align:center">{$item.RECURRING_YN}</td>
        <td class="current" style="text-align:right">{show_number number=$item.ESTIMATE}</td>
        <td class="current" style="text-align:right">{show_number number=$item.ACTUAL}</td>
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
        <td style="text-align:center">{$item.RECURRING_YN}</td>
        <td style="text-align:right">{show_number number=$item.ESTIMATE}</td>
        <td style="text-align:right">{show_number number=$item.ACTUAL}</td>
        <td style="text-align:right">{show_number number=$item.INVOICED}</td>
      {/if}
      {assign var="total_expenses_estimate" value="`$total_expenses_estimate+$item.ESTIMATE`"}
      {assign var="total_expenses_actual"   value="`$total_expenses_actual+$item.ACTUAL`"}
      {assign var="total_expenses_invoiced" value="`$total_expenses_invoiced+$item.INVOICED`"}
     </tr>
  {/foreach}
     <tr>
         <td colspan="5" style="text-align:right">Total:</td>
         <td style="text-align:right">{show_number number=$total_expenses_estimate}</td>
         <td style="text-align:right">{show_number number=$total_expenses_actual}</td>
         <td style="text-align:right">{show_number number=$total_expenses_invoiced}</td>
     </tr>
  </table>

  </div>

  <div class="col-md-12">
  <form {$form_data.attributes}  onsubmit="return(checkForm())">
   {if $isEdit == "true"}
    {foreach from=$form_data item=item}
      {if ($item.type eq "submit")}
         {$item.html}
      {/if}
    {/foreach}<br><br>
    {/if}
  {$form_data.hidden}
   <div id="descDiv" style="display:none">
  {if ($currentExpenseID || $action == "INSERT")}
     <h2>Description</h2>
             <table class="datatable1">
               <tr><th>{$form_data.EVENT_DATE.label}<span class="error">*</span></th><td><span class="error">{$form_data.EVENT_DATE.error}</span>{$form_data.EVENT_DATE.html} {calendar elements=$dates current=$form_data.EVENT_DATE.name}</td> </tr>
               <tr><th>{$form_data.UNIT_ID.label}</th><td>{$form_data.UNIT_ID.html}</td> </tr>
               <tr><th>{$form_data.RECURRING_YN.label}</th><td>{$form_data.RECURRING_YN.html} {$form_data.RECURRING_PERIOD.html}</td> </tr>
               <tr><th>{$form_data.RECURRING_ENDDATE.label}</th><td><span class="error">{$form_data.RECURRING_ENDDATE.error}</span>{$form_data.RECURRING_ENDDATE.html} {calendar elements=$dates current=$form_data.RECURRING_ENDDATE.name}</td> </tr>
               <tr><th>{$form_data.LOAN_ID.label}</th><td>{$form_data.LOAN_ID.html}</td> </tr>
               <tr><th>{$form_data.DESCRIPTION.label}<span class="error">*</span></th><td><span class="error">{$form_data.DESCRIPTION.error}</span>{$form_data.DESCRIPTION.html}</td> </tr>
             </table>
   {else}
   <br>
   {/if}
  </div>
  <div id="invoiceDiv" style="display:none">
  {if ($currentExpenseID && $action != "INSERT")}
     <h2>Receipts &amp; Invoices</h2>
     <table class="datatable">
        <tr>
           <th>Date <span class="error">*</span></th>
           <th>Vendor
    
          {if ($isEdit == "trueXX")}
              [<a style="font-weight:100;color:blue" href="javascript:void(0)" onclick="window.open('{$PATH_FROM_ROOT}php/addTenantExpense.php?BUSINESS_ID={$currentBUID}&type=NEW_SUPPLIER', 'addTenantExpense', 'height=500,width=450,toolbar=no,menubar=no,location=no')">Add</a>]
             {/if}

             </th>
           <th>Invoice number</th>
           <th>Amount <span class="error">*</span></th>
           <th>Expense Type <span class="error">*</span></th>
           {if ($isEdit == "true")}
           <th></th>
           {/if}
         </tr>
         {foreach from=$form_data.ACCOUNTS item=element}
         <tr>
          {foreach from=$element item=item}
             <td>
                  {$item.html}{calendar elements=$dates current=$item.name}
                  {if @($item.error)}
                         <br><span class="error">{$item.error}</span>
                  {/if}
                </td>
          {/foreach}
         </tr>
       {/foreach}
     </table>
    {/if}
</div>
<div id="itemsDiv" style="display:none">
{if ($currentExpenseID && $action != "INSERT")}
     <h2>Items - Time &amp; Materials</h2>
     <table class="datatable">
           <tr>
                <th/>
                <th>Supplier</th>
                <th>Estimate</th>
                <th>Actual</th>
                <th>Invoiced</th>
                <th>Accepted</th>
          </tr>
         {foreach from=$itemsSupplierList item=item}
                    <tr>
                    {if ($item.SUPPLIER_ID eq  $currentItemSupplierID)}
                           <td style="background-color:#ffcc3e">&nbsp;
                        {else}
                           <td><input type="radio" name="ITEMS_SUPPLIER_ID" value="{$item.SUPPLIER_ID}" onclick="changeSupplierItem(this)">
                        {/if}
                    </td>
                    <td>{$item.SUPPLIER_NAME}</td>
                    <td style="text-align:right">{$item.ESTIMATE}</td>
                    <td style="text-align:right">{$item.ACTUAL}</td>
                    <td style="text-align:right">{$item.INVOICE}</td>
                    <td style="text-align:center">
                        {assign var="is_accepted" value=""}
                        {if $item.ACCEPTED_YN eq 'Y'}
                            {assign var="is_accepted" value="checked"}
                        {/if}
                        <input type="checkbox" name="ITEMS_ACCEPTED[{$item.SUPPLIER_ID}]" {$is_accepted} onclick="changeItemsAcceptedFlag(this, {$item.SUPPLIER_ID})">
                    </td>
               </tr>
         {/foreach}
     </table>

     <table class="datatable">
        <tr>
            <th>Sort<br/>Order</th>
            <th>Supplier</th>
            <th>Item <span class="error">*</span></th>
            <th>Item<br/>Cost</th>
            <th>Item<br/>Units</th>
            <th>Estimated<br/>Quantity</th>
            <th>Estimated<br/>Cost</th>
            <th>Actual<br/>Quantity</th>
            <th>Actual<br/>Cost</th>
            <th></th>
        </tr>
           {foreach from=$form_data.ITEMS item=element}
                   <tr>
                  {foreach from=$element item=item}
                     <td>
                      {$item.html}
                      {if @($item.error)}
                             <br><span class="error">{$item.error}</span>
                      {/if}
                        </td>
                 {/foreach}
                   </tr>
           {/foreach}
        </tr>
     </table>
{/if}
</div>
    <script language="javascript">
       setEnabledRecurring();
    </script>
     </form>
</div>
{include file="footer.tpl"}
