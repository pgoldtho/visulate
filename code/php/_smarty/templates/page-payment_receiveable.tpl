{include file="header2.tpl"}
<script language="JavaScript" src="{$PATH_FROM_ROOT}html/receivable.js" type="text/javascript"></script>

<script>
    var gPtAccountsList = {$ptAccountsList};
</script>

{literal}
    <script language="JavaScript" type="text/javascript">
    <!--
        isDomLoaded = false;

        function hideDivs(){
            $('schedDiv').setStyles({display : 'none'});
            $('unschedDiv').setStyles({display : 'none'});
        }

        function unsetCurrent()
        {
            $('sched').removeClass('current');
            $('unsched').removeClass('current');
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
            if (menuName == "sched")
               return "schedDiv";
            if (menuName == "unsched")
               return "unschedDiv";
        }

    
        function PaidUnsched(index, obj, x_date)
        {
            var el = document.getElementsByName('OTHER_PAYMENTS['+index+'][PAYMENT_DATE]');
            var x = el[0];
            if (obj.value == "Paid")
            {
                x.value = x_date;
                obj.value = "Undo";
            }
            else
            {
                // Undo button pressed
                x.value = '';
                obj.value = "Paid";
            }
        }
    
    
        function setDefaultAccounts(index, obj) {
            var dbt  = document.getElementById('OTHER_PAYMENTS['+index+'][DEBIT_ACCOUNT]');
            var crdt = document.getElementById('OTHER_PAYMENTS['+index+'][CREDIT_ACCOUNT]');
            try {
                dbt.value  = gPtAccountsList[obj.value]["DEBIT_ACCOUNT"];
                crdt.value = gPtAccountsList[obj.value]["CREDIT_ACCOUNT"];
            } catch(e) {}
        }
    
    
      window.addEvent('domready', function(){
        showDiv(getDivByMenuL3($('CURRENT_LEVEL3').getProperty('value')));
        isDomLoaded = true;
    });
    //-->
    </script>
{/literal}

 <div class="col-md-8">
  <h1>{$header_title}</h1>
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
</div>
<div class="col-md-4">
  <table>
  <tr><th style="text-align:right">Amount Owed:</th><td style="text-align:right">{$summary.RECEIVABLE_AMOUNT}</td></tr>
    <tr><th style="text-align:right">Received:</th><td style="text-align:right">{$summary.ALLOCATED_AMOUNT}</td></tr>
    <tr><th style="border-top:1px #000000 solid; text-align:right">Balance Owed:</th><td style="border-top:1px #000000 solid; text-align:right">{$summary.BALANCE_AMOUNT}</td></tr>
  </table>
</div>  



<div class="col-md-12">  
{if ($businessID)}  

<form {$form_data.attributes}>   
    {show_error info=$errorObj}
  
<div id="schedDiv" style="display:none">
<h3>Scheduled Payments</h3>
      {if ($msgSuccess)}
         <span style="background-color:#339900;color:white;padding:2px 4px">{$msgSuccess}</span>
      {/if}
  
      {if ($isEdit eq "true")}
          {*<a href="?{$menuObj->getParam2()}&BUSINESS_ID={$businessID}&FORM_ACTION=updateLstDue&YEAR_MONTH_HIDDEN={$currYearMonth}" class="small" title="Update list of payment due">Update List</a> *}

          <span style="background-color:#dddddd;padding:6px 10px;border: 1px #aaaaaa dashed">
               <input type="submit" name="generateList" value="Update list">
              to
              {if (@$form_data.UPDATE_LIST_DATE.error)}
                  <span class="error">({$form_data.UPDATE_LIST_DATE.error})</span>
              {/if}
    
              {$form_data.UPDATE_LIST_DATE.html}
              {calendar elements=$dates current=$form_data.UPDATE_LIST_DATE.name}&nbsp;&nbsp;&nbsp;
              {$form_data.IS_GENERATE_LATE_FEE.label}{$form_data.IS_GENERATE_LATE_FEE.html}
          </span>
          <br><br> 
          
            <span style="background-color:#eedddd;padding:6px 10px;border: 1px #aaaaaa dashed">
               <input type="submit" name="deleteList" value="Delete generated rows" onclick="return confirm('Are you sure? Rows has been deleted.');">
              from
              {if (@$form_data.DELETE_LIST_DATE.error)}
                  <span class="error">({$form_data.DELETE_LIST_DATE.error})</span>
              {/if}
              {$form_data.DELETE_LIST_DATE.html}
              {calendar elements=$dates current=$form_data.DELETE_LIST_DATE.name} to end &nbsp;&nbsp;&nbsp;
          </span>
          <br><br>
      {/if}    
      
      {if ($form_data.RECEIVABLE|@count > 10)}
          <br/>
          {$form_data.save.html} {$form_data.cancel.html}
          <br/>
          <br/>
      {/if}
      
      <table class="datatable">
      <tr>
        <th>Date Due<span class="error">*</span></th>
        <th>Payment From<span class="error">*</span></th>
        <th>Amount Due<span class="error">*</span></th>
        <th>Date Paid</th>
        <th>Amount Paid</th>
        <th>ARP Debit</th>
        <th>ARS Credit</th>
        {if ($isEdit eq "true")}
           <th></th>
        {/if}
      </tr>
      {if @($form_data.RECEIVABLE)} 
        {foreach from=$form_data.RECEIVABLE item=item key=key}
        <tr>
            <td rowspan="{if ($item.ALLOCATIONS|count == 0)}1{else}{$item.ALLOCATIONS|@count}{/if}">{$item.PAYMENT_DUE_DATE.html}</td>
            <td rowspan="{if ($item.ALLOCATIONS|count == 0)}1{else}{$item.ALLOCATIONS|@count}{/if}">{$item.UNIT_NAME.html}<br>{$item.TENANT_NAME.html}</td>
            <td>
               {if @($item.AMOUNT.error)}
                 <span class="error">{$item.AMOUNT.error}</span>
               {/if}
               {$item.AMOUNT.html}
            </td>
                {assign var="is_allocation_present" value="false"} 
                {foreach from=$item.ALLOCATIONS item=item1 key=key1 name=alloc}
                     {assign var="is_allocation_present" value="true"} 
    
                     {if ($key1 > 0)}
                         <tr>
                               <td>{$item1.SUM_REMAINDER.html}</td>
                     {/if}
    
                     <td width="150px">
                         {if ($isEdit eq "true")}
                             {if @($item1.BUTTON)}
                                    {$item1.BUTTON.html}
                             {/if}
    
                         {/if}
    
                         {if @(@$item1.PAYMENT_DATE.error)}
                             <span class="error">{$item1.PAYMENT_DATE.error}</span>
                         {/if}
                         {$item1.PAYMENT_DATE.html}
                         {if ($isEdit eq "true")}
                             {calendar elements=$dates current=$item1.PAYMENT_DATE.name}
                         {/if}
                     </td>
                     <td>
                         {if @(@$item1.AMOUNT.error)}
                             <span class="error">{$item1.AMOUNT.error}</span>
                         {/if}
                            {$item1.AMOUNT.html}
                     </td>
    
                     <td>
                        {$item1.DEBIT_ACCOUNT.html}
                     </td>
    
                     {if $smarty.foreach.alloc.first}
                         <td rowspan="{if ($item.ALLOCATIONS|count == 0)}1{else}{$item.ALLOCATIONS|@count}{/if}">
                             {$item.CREDIT_ACCOUNT.html}
                         </td>
                     {/if}
    
                     {if ($isEdit eq "true")}
                         <td>{$item1.LINK_DELETE_ALLOC.html}</td>
                     {/if}
                     </tr>
                {/foreach}
                {if ($is_allocation_present == "false")} 
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    {if ($isEdit eq "true")}
                        <td></td>
                    {/if}
                    </tr>
               {/if}
       {/foreach}    
     {/if}
     </table>    
   {$form_data.save.html} {$form_data.cancel.html}  
   <br>
</div>


<div id="unschedDiv" style="display:none">
   <h3>Unscheduled Payments</h3>
  {if ($isEdit eq "true")}
      <a href="?{$menuObj->getParam2()}&BUSINESS_ID={$businessID}&FORM_ACTION=createOtherPayment&YEAR_MONTH_HIDDEN={$currYearMonth}&CURRENT_LEVEL3=unsched" class="small">New</a>
      <br>
  {/if}    
  
  {if ($form_data.OTHER_PAYMENTS|@count > 10)}
       <br/>
       {$form_data.save.html} {$form_data.cancel.html}
       <br/> <br/>
  {/if}
   <table class="datatable">
     <tr>
       <th>Date<span class="error">*</span></th>
       <th>Property/Payment Type<span class="error">*</span></th>
       <th>Amount<span class="error">*</span></th>
       <th>Date Paid</th>
       <th>Debit/Credit<span class="error">*</span></th>
       {if ($isEdit eq "true")}
            <th></th>
       {/if}
     </tr>
     {if @($form_data.OTHER_PAYMENTS)} 
        {foreach from=$form_data.OTHER_PAYMENTS item=item key=key}
           <tr>
            <td>
                      {if @(@$item.PAYMENT_DUE_DATE.error)}
                     <span class="error">{$item.PAYMENT_DUE_DATE.error}</span>
                    {/if}
                      {$item.PAYMENT_DUE_DATE.html}
                      {if ($isEdit eq "true")}
                         {calendar elements=$dates current=$item.PAYMENT_DUE_DATE.name}
                      {/if}
            </td>
            <td>{$item.PAYMENT_PROPERTY_ID.html}<br/>
                {$item.PAYMENT_TYPE.html}</td>
            <td>
                   {if @(@$item.AMOUNT.error)}
                     <span class="error">{$item.AMOUNT.error}</span>
                    {/if}
                {$item.AMOUNT.html}
            </td>
            <td>
                {if ($isEdit eq "true")}
                    {$item.BUTTON.html}
                {/if}
                {if @(@$item.PAYMENT_DATE.error)}
                     <span class="error">{$item.PAYMENT_DATE.error}</span>
                    {/if}
                {$item.PAYMENT_DATE.html}
                {if ($isEdit eq "true")}
                       {calendar elements=$dates current=$item.PAYMENT_DATE.name}
                {/if}
               </td>
               <td>
                   {$item.DEBIT_ACCOUNT.html}
                 <br/>
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
</div>  

</form>

{/if} 

</div>
{include file="footer.tpl"}
