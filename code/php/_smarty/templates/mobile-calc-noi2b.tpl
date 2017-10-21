<table data-role="table" data-mode="columntoggel"  class="datatable ui-responsive table-stroke">
<caption>Income Value</caption>
<tbody>
  <tr><th>Price Paid</th><td><input type="number" id="v12" name="cur_value" size="10"
         {if $defaults}value="{$defaults.$c.VALUE|number_format:0|replace:','}"{/if} /></td></tr>
  <tr><th>Down Payment</th><td><input type="number" id="v13" name="down_payment" size="10" 
  {if $defaults}value="{$defaults.$c.DOWN|number_format:0|replace:','}"{/if} /></td></tr>
  <tr><th>Closing Costs</th><td><input type="number" id="v14" name="c_costs" size="10" 
  {if $defaults}value="{$defaults.$c.COSTS|number_format:0|replace:','}"{/if} /></td></tr>
  <tr><th><input name="Button" onclick="compute_value(this.form)" type="button" value=" Calculate" /></th><td>&nbsp;</td></tr>
  <tr><th>Cash on Cash Return</th><td><input readonly="readonly" name="cash_on_cash" size="10" value=""  disabled="disabled" /></td></tr>
  <tr><th>Unleveraged Yield</th><td><input type="number" id="v15" name="cap_rate" size="10" 
                                     value="{if $defaults}{$defaults.$c.CAP_RATE}{/if}" /></td></tr>
</tbody>
</table>
</form>
</div>