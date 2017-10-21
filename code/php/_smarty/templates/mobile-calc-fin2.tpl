<div data-role="collapsible">
<h4>Second Loan</h4>
<form name="temps2">
  <table data-role="table" data-mode="columntoggel"  class="datatable ui-responsive table-stroke">
  <caption>Second Loan</caption>
    <tbody>
  <tr><th>2nd Loan Amount</th><td><input id="v20" name="LA" onchange="dosum2()" size="6" type="number"   value="0" /></td></tr>
  <tr><th>Type</th><td><select id="v21" name="loantype" onchange="dosum2()">
                       <option value="Amortizing">Amortizing</option>
                       <option selected="selected" value="Interest Only">Interest Only</option></select></td></tr>
  <tr><th>Term</th><td><input id="v22"  name="YR" onchange="dosum2()" size="6" type="number"   value="" /></td></tr>
  <tr><th>Interest Rate</th><td><input id="v23" name="IR" onchange="dosum2()" size="6" type="number"   value="8.0" /></td></tr>
  <tr><th>Monthly Prin + Int</th><td><input name="PI" size="10" type="number"   /></td></tr>
    </tbody>
  </table>
</form>
</div>
