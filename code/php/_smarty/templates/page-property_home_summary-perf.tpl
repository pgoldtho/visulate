{include file="header2.tpl"}
  <h1>{$header_title}</h1>
    { if (!$isOnlyAlerts) }


               <h3>Property Summary</h3>
              <table class="datatable" style="font-size:12px">
                 <tr>
                    <th>Property Name</th>
                    <th>Total Income</th>
                    <th>Total Expense</th>
                    <th>Cash Flow</th>
                    <th>Uncollected Income</th>
                    <th>Unpaid Invoices</th>
                    <th>NOI</th>
                    <th>Cap Rate</th>
                 </tr>
                 {foreach from=$summaryTable item=item}
                        <tr>
                            <td>{$item.ADDRESS1}</td>
                            <td style="text-align:right">{$item.INCOME_AMOUNT}</td>
                            <td style="text-align:right">{$item.EXPENSE_AMOUNT}</td>
                            {assign var="color" value="#e0ffe0"}
                            {if ($item.IS_CASH_FLOW_GOOD=="no")}
                              {assign var="color" value="#ffe0e0"}
                            {/if}
                            <td style="text-align:right;background-color:{$color}">{$item.CASH_FLOW}</td>
                            <td style="text-align:right">{$item.UNCOLLECTED_INCOME}</td>
                            <td style="text-align:right">{$item.UNPAID_INVOICES}</td>
                            <td style="text-align:right">{$item.NOI_VALUE}</td>
                            <td style="text-align:right">{$item.CAP_RATE_VALUE}</td>
                         </tr>
                 {/foreach}
              </table>

               <h3>Income Valuation by Cap Rate - Last 12 Months</h3>
              <table class="datatable" style="font-size:12px">
                 <tr>
                    <th>Property Name</th>
                    <th>NOI</th>
                    <th>5%</th>
                    <th>6%</th>
                    <th>7%</th>
                    <th>8%</th>
                    <th>9%</th>
                    <th>10%</th>
                    <th>11%</th>
                    <th>12%</th>
                 </tr>
                 {foreach from=$valuesTable item=item}
                        <tr>
                            <td>{$item.ADDRESS1}</td>
                            <td style="text-align:right">{$item.NOI}</td>
                            {assign var="color" value="#e0ffe0"}
                            {if ($item.CAP_RATE_VALUE < 5)}
                              {assign var="color" value="#ffe0e0"}
                            {/if}
                            <td style="text-align:right;background-color:{$color}">{$item.5CAP}</td>
                            {assign var="color" value="#e0ffe0"}
                            {if ($item.CAP_RATE_VALUE < 6)}
                              {assign var="color" value="#ffe0e0"}
                            {/if}
                            <td style="text-align:right;background-color:{$color}">{$item.6CAP}</td>
                            {assign var="color" value="#e0ffe0"}
                            {if ($item.CAP_RATE_VALUE < 7)}
                              {assign var="color" value="#ffe0e0"}
                            {/if}
                            <td style="text-align:right;background-color:{$color}">{$item.7CAP}</td>
                            {assign var="color" value="#e0ffe0"}
                            {if ($item.CAP_RATE_VALUE < 8)}
                              {assign var="color" value="#ffe0e0"}
                            {/if}
                            <td style="text-align:right;background-color:{$color}">{$item.8CAP}</td>
                            {assign var="color" value="#e0ffe0"}
                            {if ($item.CAP_RATE_VALUE < 9)}
                              {assign var="color" value="#ffe0e0"}
                            {/if}
                            <td style="text-align:right;background-color:{$color}">{$item.9CAP}</td>
                            {assign var="color" value="#e0ffe0"}
                            {if ($item.CAP_RATE_VALUE < 10)}
                              {assign var="color" value="#ffe0e0"}
                            {/if}
                            <td style="text-align:right;background-color:{$color}">{$item.10CAP}</td>
                            {assign var="color" value="#e0ffe0"}
                            {if ($item.CAP_RATE_VALUE < 11)}
                              {assign var="color" value="#ffe0e0"}
                            {/if}
                            <td style="text-align:right;background-color:{$color}">{$item.11CAP}</td>
                            {assign var="color" value="#e0ffe0"}
                            {if ($item.CAP_RATE_VALUE < 12)}
                              {assign var="color" value="#ffe0e0"}
                            {/if}
                            <td style="text-align:right;background-color:{$color}">{$item.12CAP}</td>
                         </tr>
                 {/foreach}
              </table>

    
<h3>Net Operating Income (Last 12 Months)</h3>
<div class="col-md-8">
<img src="{$PATH_FROM_ROOT}php/graphs/prop_noi.php?BUSINESS_ID={$businessID}" width="390" height="300">
</div>
<div class="col-md-4">
        <br clear="left">
        {foreach from=$NOIList item=item}
           {$item}<br>
        {/foreach}
</div>
<div class="col-md-12">
<h3>Cap Rate (Last 12 Months)</h3>
</div>
<div class="col-md-8">
<img src="{$PATH_FROM_ROOT}php/graphs/prop_cap_rate.php?BUSINESS_ID={$businessID}" width="390" height="300">
</div>
<div class="col-md-4">
        <br clear="left">
        {foreach from=$CapRateList item=item}
           {$item}<br>
        {/foreach}
</div>
{/if}    
</div>
{include file="footer.tpl"}
