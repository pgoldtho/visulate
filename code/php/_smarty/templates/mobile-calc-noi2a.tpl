<p>Enter a Cap Rate (desired rate of return) then press the calculate button.</p>

<table  data-role="table" data-mode="columntoggel"  class="datatable ui-responsive table-stroke">
<caption>Income Value</caption>
<tbody>
  <tr><th>Cap Rate</th><td><input type="number" id="v15" name="cap_rate" size="10" value="8" /></td></tr>
  <tr><th><input name="Button" onclick="compute_value(this.form)"
  type="button" value=" Calculate Property Value" /></th>
      <td><input id="v12" name="cur_value" size="10"  value="" /></td></tr>
</tbody>
</table>
<input type="hidden" id="v13" name="down_payment" size="10" value="{$defaults.$c.DOWN|number_format:0}" />
<input type="hidden" id="v14" name="c_costs" size="10" value="{$defaults.$c.COSTS|number_format:0}" />
<input type="hidden" disabled="disabled" name="cash_on_cash" size="10" value="" />
</form>
<p>Income Value = NOI/Cap Rate</p>

</div>