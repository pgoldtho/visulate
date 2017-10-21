{include file="header2.tpl"}
  <h3>Repair Estimates</h3>

  <table class="datatable" style="font-size:12px">
  <tr>
      <th width="20%">
          <b>Address</b>
      </th>
      <th width="10%" style="text-align:center">
          <b>Sq ft</b>
      </th>
      <th width="10%" style="text-align:center">
          <b>Asking Price</b>
      </th>
      <th width="10%" style="text-align:center">
          <b>Offer Price</b>
      </th>
      <th width="10%" style="text-align:center">
          <b>Cost Estimates</b>
      </th>
      <th width="10%" style="text-align:center">
          <b>Cost Basis</b>
      </th>
      <th width="10%" style="text-align:center">
          <b>Price/Sq ft</b>
      </th>
      <th width="10%" style="text-align:center">
          <b>ARV</b>
      </th>
      <th width="10%" style="text-align:center">
          <b>Projected Profit/Loss</b>
      </th>
  </tr>
  {foreach from=$repairEstimates item=item}
      <tr>
          <td>
              <a href="?m2=property_details&prop_id={$item.PROPERTY_ID}">
                  <b>{$item.ADDRESS}</b>
              </a>
          </td>
          <td style="text-align:right">{show_number number=$item.SQFT}</td>
          <td style="text-align:right">
              <a href="?m2=property_finance&prop_id={$item.PROPERTY_ID}">
                  {show_number number=$item.ASKING_PRICE}
              </a>
          </td>
          <td style="text-align:right">
              <a href="?m2=property_finance&prop_id={$item.PROPERTY_ID}">
                  {show_number number=$item.OFFER_PRICE}
              </a>
          </td>
          <td style="text-align:right">
              <a href="?m2=property_expense&prop_id={$item.PROPERTY_ID}&CURRENT_LEVEL3=itemsA">
                  {show_number number=$item.COST_ESTIMATES}</td>
              </a>
          <td style="text-align:right">{show_number number=$item.COST_BASIS}</td>
          <td style="text-align:right">{show_number number=$item.PRICE_SQFT}</td>
          <td style="text-align:right">
              <a href="?m2=property_finance&prop_id={$item.PROPERTY_ID}">
                  {show_number number=$item.ARV}
              </a>
          </td>
          <td style="text-align:right">{show_number number=$item.PROFIT_LOSS}</td>
      </tr>
  {/foreach}
  </table>

<h3>Cash Flow Estimates</h3>

  {foreach from=$cashFlowEstimates key=key item=item}
      <table class="datatable" style="font-size:12px">
         {if $smarty.foreach.$item.first}
             <tr align="center">
                 <th width="20%">
                     <strong>{$key}</strong>
                 </th>
                 <th width="10%" style="text-align:center">
                     <strong>Price</strong>
                 </th>
                 <th width="10%" style="text-align:center">
                     <strong>Monthly Rent</strong>
                 </th>
                 <th width="10%" style="text-align:center">
                     <strong>Annual Rent</strong>
                 </th>
                 <th width="10%" style="text-align:center">
                     <strong>Operating Expenses</strong>
                 </th>
                 <th width="10%" style="text-align:center">
                     <strong>NOI</strong>
                 </th>
                 <th width="10%" style="text-align:center">
                     <strong>Cap Rate</strong>
                 </th>
                 <th width="10%" style="text-align:center">
                     <strong>Cash Invested</strong>
                 </th>
                 <th width="10%" style="text-align:center">
                     <strong>Cash on Cash</strong>
                 </th>
             </tr>
         {/if}
         {foreach from=$item item=estimate}
             <tr>
                 <td width="20%">
                     {assign var="prop_estimates_id" value=""}
                     {if ($estimate.PROPERTY_ESTIMATES_ID) }
                         {assign var="prop_estimates_id" value="&PROPERTY_ESTIMATES_ID="|cat:$estimate.PROPERTY_ESTIMATES_ID}
                     {/if}
                     <a href="?m2=property_estimates&prop_id={$estimate.PROPERTY_ID}{$prop_estimates_id}">
                         {$estimate.TITLE}
                     </a>
                 </td>
                 <td style="text-align:right">{show_number number=$estimate.PRICE}</td>
                 <td style="text-align:right">{show_number number=$estimate.MONTHLY_RENT}</td>
                 <td style="text-align:right">{show_number number=$estimate.ANNUAL_RENT}</td>
                 <td style="text-align:right">{show_number number=$estimate.EXPENSE_AMOUNT}</td>
                 <td style="text-align:right">{show_number number=$estimate.NOI}</td>
                 <td style="text-align:right">{show_number number=$estimate.CAP_RATE} %</td>
                 <td style="text-align:right">{show_number number=$estimate.CASH_INVESTED}</td>
                 <td style="text-align:right">{show_number number=$estimate.CASH_ON_CASH}</td>
             </tr>
          {/foreach}
      </table>
      <br/>
  {/foreach}
{include file="footer.tpl"}
