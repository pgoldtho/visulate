{include file="header2.tpl"}
  <h1>{$header_title}</h1>
<div class="col-md-6">
    { if (!$isOnlyAlerts) }
     <h3>Alerts</h3>
    <div style="width:300;height:300;overflow:auto;border:1px solid #808080">
    {$ExceptionMessage}
        {foreach from=$alertList item=item}
            {$item}<br>
        {/foreach}
        </div>
 <br clear="left">
      <h3>Uncollected Income and Unpaid Invoices</h3>
     <img src="{$PATH_FROM_ROOT}php/graphs/unc_inc_unp_inv.php?BUSINESS_ID={$businessID}" width="360" height="280">
        {/if }

</div>    
<div class="col-md-3">
                   <h3>Monthly Income Statement</h3>

<table class="datatable">
{foreach from=$income_statement key=k item=item}
 {if $k == 'Month Ending:'
  || $k == 'Quater Ending:'
    || $k == 'Year Ending:'
    || $k == 'Revenue:'
    || $k == 'Expenses:'
    || $k == 'Result:'}
  <tr><th>{$k}</th>
      <th>{$item[1]}</th>
      <th>{$item[2]}</th>
      <th>{$item[3]}</th></tr>
 {else}
  <tr><th>{$k}</th>
      <td>{show_number number=$item[1]}</td>
      <td>{show_number number=$item[2]}</td>
      <td>{show_number number=$item[3]}</td></tr>
 {/if}
{/foreach}
</table>



</div>

<div class="col-md-12">

{ if (!$isOnlyAlerts) }
        <br clear="left">
      <table class="datatable" style="font-size:12px">
                 <tr>
                     <th>&nbsp;</th>
                    {foreach from=$income_invoice.MONTH_NAMES item=item}
                        <th>{$item}</th>
                    {/foreach}
                 </tr>
                 <tr><th>Uncollected Income</th>
                     {foreach from=$income_invoice.UNCOLLECTED_INCOME item=item}
                           <td>{$item}</td>
                    {/foreach}
                 </tr>
                                  <tr><th>Unpaid Invoices</th>
                     {foreach from=$income_invoice.UNPAID_INVOICES item=item}
                           <td>{$item}</td>
                    {/foreach}
                 </tr>
    </table>
{*<!-- union Uncollected Income and Unpaid Invoices to one Graph above
        <h3>Uncollected Income</h3>
        <img src="{$PATH_FROM_ROOT}php/graphs/uncollected_income.php?BUSINESS_ID={$businessID}" width="390" height="300">
                <br clear="left">
        {foreach from=$uncollectedIncomeList item=item}
           {$item}
        {/foreach}


        <h3>Unpaid Invoices</h3>
        <img src="{$PATH_FROM_ROOT}php/graphs/unpaid_invoices.php?BUSINESS_ID={$businessID}" width="390" height="300">
        <br clear="left">
        {foreach from=$unpaidInvoicesList item=item}
           {$item}
        {/foreach}
 -->*}
{/if}    
</div>
{include file="footer.tpl"}
