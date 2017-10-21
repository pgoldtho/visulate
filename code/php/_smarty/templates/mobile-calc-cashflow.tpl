<div data-role="collapsible">
<h4>Cashflow</h4>
<form name="cf">
  <table  data-role="table" data-mode="columntoggel"  class="datatable ui-responsive table-stroke">
  <caption>Cash Flow</caption>
    <tbody>
  <tr><th><input name="Button" onclick="compute_value(document.forms['prop'])" type="button" value=" Calculate" /></th><th>Annual</th><th>Monthly</th></tr>
  <tr><th>Net Operating Income</th><td><input readonly="readonly" name="a_noi" size="8" type="text" value=""  disabled="disabled"/></td>
    <td><input readonly="readonly" name="m_noi" size="8" type="text" value=""  disabled="disabled"/></td></tr>
  <tr><th>1st Loan</th><td><input readonly="readonly" name="a_loan1" size="8" type="text" value=""  disabled="disabled"/></td>
    <td><input readonly="readonly" name="m_loan1" size="8" type="text" value=""  disabled="disabled" /></td></tr>
  <tr><th>2nd Loan</th><td><input readonly="readonly" name="a_loan2" size="8" type="text" value=""  disabled="disabled"/></td>
    <td><input readonly="readonly" name="m_loan2" size="8" type="text" value=""  disabled="disabled"/></td></tr>
  <tr><th>DSCR</th><td><input readonly="readonly" name="dscr" size="6" type="text" value=""  disabled="disabled" /></td>
    <td id="dscr_status">&nbsp;</td></tr>

  <tr><th>Cash Flow</th><td><input readonly="readonly" name="a_cf" size="8" type="text" value=""  disabled="disabled" /></td>
    <td><input readonly="readonly" name="m_cf" size="8" type="text" value=""  disabled="disabled" /></td></tr>
    </tbody>
  </table>
</form>
</div>
