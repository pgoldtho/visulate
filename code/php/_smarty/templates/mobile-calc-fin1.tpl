<div data-role="collapsible">
<h4>Mortgage Payments</h4>
<form id="fin" name="temps">
<table data-role="table" data-mode="columntoggel"  class="datatable ui-responsive table-stroke">
<caption>Property Finance</caption>
<tbody>
  <tr><th>Loan Amount</th><td><input id="v16" name="LA" onchange="dosum()" size="6" type="number"  {if $defaults}value="{$defaults.$c.LOAN|number_format:0|replace:','}"{else}value=""{/if} /></td></tr>

<tr><th>Type</th>
<td><select id="v17" name="loantype" onchange="dosum()">
<option selected="selected" value="Amortizing">Amortizing</option>
<option value="Interest Only">Interest Only</option></select>
</td></tr>
<tr><th>Term</th>
<td><input id="v18" name="YR" onchange="dosum()" size="6" type="number" value="30" />
</td></tr>
<tr><th>Interest Rate</th>
<td><input id="v19" name="IR" onchange="dosum()" size="6" type="number"  value="6.5" />
</td></tr>
<tr><th>Property Tax (Annual)</th>
<td><input id="AT" name="AT" onchange="dosum()" size="6" type="number"  
{if $defaults}value="{$defaults.$c.TAX|number_format:0|replace:','}"{else}value=""{/if} />
</td></tr>
<tr><th>Insurance(Annual)</th>
<td><input id="AI" name="AI" onchange="dosum()" size="6" type="number" 
{if $defaults}value="{$defaults.$c.INSURANCE|number_format:0|replace:','}"{else}value=""{/if} />
</td></tr>
<tr><th>Monthly Prin + Int</th>
<td>   <input readonly="readonly" name="PI" size="10" type="number"  disabled="disabled"  />
</td></tr>
<tr><th>Monthly Tax</th>
<td>          <input readonly="readonly" name="MT" size="10" type="number"  disabled="disabled"  />
</td></tr>
<tr><th>Monthly Ins</th>
<td>          <input readonly="readonly" name="MI" size="10" type="number"   disabled="disabled" />
</td></tr>
<tr><th>Monthly Total</th>
<td><input name="MP" size="10" type="number"   />
</td></tr>
</tbody>
</table>
</form>

</div>
