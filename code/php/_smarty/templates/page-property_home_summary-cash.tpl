{include file="header2.tpl"}
  <h1>{$header_title}</h1>
<div class="col-md-8">
    { if (!$isOnlyAlerts) }
        <h3>Cash Flow Last 12 Months</h3>
        <img src="{$PATH_FROM_ROOT}php/graphs/cash_flow.php?BUSINESS_ID={$businessID}" width="390" height="300">
    {/if}


</div>    
<div class="col-md-4">
                   <h3>Cash Flow Summary</h3>

                   <table class="datatable" style="font-size:12px">
                     <caption align="top" id="tableCaption">Cash Flow Current Month</caption>
                     <tbody>
                        <tr><th></th><th>Income</th><th>Expense</th><th>Cash Flow</th></tr>
                        <tr><th>Owed</th><td style="text-align:right">{$CashFlowSum.LAST_MONTH.OWED.t1}</td><td style="text-align:right">{$CashFlowSum.LAST_MONTH.OWED.t2}</td><td style="text-align:right">{$CashFlowSum.LAST_MONTH.OWED.t3}</td></tr>
                        <tr><th>Paid</th><td style="text-align:right">{$CashFlowSum.LAST_MONTH.RECEIVED_PAID.t1}</td><td style="text-align:right">{$CashFlowSum.LAST_MONTH.RECEIVED_PAID.t2}</td><td style="text-align:right">{$CashFlowSum.LAST_MONTH.RECEIVED_PAID.t3}</td></tr>
                        <tr><th>Unpaid</th><td style="text-align:right">{$CashFlowSum.LAST_MONTH.TOTAL.t1}</td><td style="text-align:right">{$CashFlowSum.LAST_MONTH.TOTAL.t2}</td><td style="text-align:right">{$CashFlowSum.LAST_MONTH.TOTAL.t3}</td></tr>
                      </tbody>
                    </table>


                   <table class="datatable" style="font-size:12px">
                     <caption align="top" id="tableCaption">Cash Flow Prior 12 Months</caption>
                     <tbody>
                        <tr><th></th><th>Income</th><th>Expense</th><th>Cash Flow</th></tr>
                        <tr><th>Owed</th><td style="text-align:right">{$CashFlowSum.LAST12MONTH.OWED.t1}</td><td style="text-align:right">{$CashFlowSum.LAST12MONTH.OWED.t2}</td><td style="text-align:right">{$CashFlowSum.LAST12MONTH.OWED.t3}</td></tr>
                        <tr><th>Paid</th><td style="text-align:right">{$CashFlowSum.LAST12MONTH.RECEIVED_PAID.t1}</td><td style="text-align:right">{$CashFlowSum.LAST12MONTH.RECEIVED_PAID.t2}</td><td style="text-align:right">{$CashFlowSum.LAST12MONTH.RECEIVED_PAID.t3}</td></tr>
                        <tr><th>Unpaid</th><td style="text-align:right">{$CashFlowSum.LAST12MONTH.TOTAL.t1}</td><td style="text-align:right">{$CashFlowSum.LAST12MONTH.TOTAL.t2}</td><td style="text-align:right">{$CashFlowSum.LAST12MONTH.TOTAL.t3}</td></tr>
                      </tbody>
                    </table>

                   <table class="datatable" style="font-size:12px">
                     <caption align="top" id="tableCaption">Cash Flow Current Year</caption>
                     <tbody>
                        <tr><th></th><th>Income</th><th>Expense</th><th>Cash Flow</th></tr>
                        <tr><th>Owed</th><td style="text-align:right">{$CashFlowSum.YEAR_TO_DATE.OWED.t1}</td><td style="text-align:right">{$CashFlowSum.YEAR_TO_DATE.OWED.t2}</td><td style="text-align:right">{$CashFlowSum.YEAR_TO_DATE.OWED.t3}</td></tr>
                        <tr><th>Paid</th><td style="text-align:right">{$CashFlowSum.YEAR_TO_DATE.RECEIVED_PAID.t1}</td><td style="text-align:right">{$CashFlowSum.YEAR_TO_DATE.RECEIVED_PAID.t2}</td><td style="text-align:right">{$CashFlowSum.YEAR_TO_DATE.RECEIVED_PAID.t3}</td></tr>
                        <tr><th>Unpaid</th><td style="text-align:right">{$CashFlowSum.YEAR_TO_DATE.TOTAL.t1}</td><td style="text-align:right">{$CashFlowSum.YEAR_TO_DATE.TOTAL.t2}</td><td style="text-align:right">{$CashFlowSum.YEAR_TO_DATE.TOTAL.t3}</td></tr>
                      </tbody>
                    </table>

</div>

<div class="col-md-12">

{ if (!$isOnlyAlerts) }
   <h3>Cash Flow Details</h3>
    
                   <table class="datatable" style="font-size:12px">
                     <caption align="top" id="tableCaption">Cash Flow Prior 12 Months</caption>
                     <tbody>
                        {foreach from=$cashFlowList item=item1 key=key1}
                           <tr>
                             {section name=item2 loop=$item1}
                                {if ($key1 eq "MONTHS") || ($smarty.section.item2.index == 0)}
                                  <th>{$item1[item2]}</th>
                                {else}
                                  <td style="text-align:right">{$item1[item2]}</td>
                                {/if}
                             {/section}
                           </tr>
                        {/foreach}
                      </tbody>
                    </table>


                     <table class="datatable" style="font-size:12px">
                     <caption align="top" id="tableCaption">Cash Flow Current Year</caption>
                     <tbody>
                        {foreach from=$currentYearCashFlow item=item1 key=key1}
                           <tr>
                             {section name=item2 loop=$item1}
                                {if ($key1 eq "MONTH_NAME") || ($smarty.section.item2.index == 0)}
                                  <th style="text-align:center">{$item1[item2]}</th>
                                {else}
                                  <td style="text-align:right">{$item1[item2]}</td>
                                {/if}
                             {/section}
                           </tr>
                        {/foreach}
                      </tbody>
                    </table>

{/if}    
</div>
{include file="footer.tpl"}
