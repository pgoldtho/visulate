{if $smarty.request.CLASS}
  {assign var="c" value=$smarty.request.CLASS|escape:'htmlall'}
{else}
  {assign var="c" value="B"}
{/if}
<script src="/include/cap_calc.js" type="text/javascript" > </script>

<script src="/rental/html/jquery.remember-state/jquery.remember-state.js" type="text/javascript" ></script>
<script>{literal}
    $(function() {
      $("#prop").rememberState({ objName: "worksheet_{/literal}{$data.PROPERTY.PROP_ID}{literal}" }).submit(function() {
        localStorage.setObject("worksheet_{/literal}{$data.PROPERTY.PROP_ID}{literal}", $(this).serializeArray());
        return false;
      });
    });
{/literal}</script>



<h3>{$c} Class Property Net Operating Income and Cap Rate <br/> {$save2BUmsg}</h3>

<h4>Income Estimate</h4>
<form id="prop" name="prop">
<table class="datatable">
<tbody>
  <tr><th>Monthly Rent</th><td><input id="v01" name="rent" size="10" value="{$defaults.$c.MONTHLY_RENT|number_format:0}" /></td></tr>
  <tr><th>Annual Rent</th><td><input disabled="disabled" name="gross" size="10" value="{$defaults.$c.ANNUAL_RENT|number_format:0}" /></td></tr>
  <tr><th>Other Income</th><td><input id="v02" name="other" size="10" value="" /></td></tr>
  <tr><th>Total Gross</th><td><input disabled="disabled" name="total_gross" size="10" value="{$defaults.$c.ANNUAL_RENT|number_format:0}" /></td></tr>
</tbody>
</table>
<script type="text/javascript"><!--
google_ad_client = "ca-pub-9857825912142719";
/* Mobile */
google_ad_slot = "2459853012";
google_ad_width = 320;
google_ad_height = 50;
//-->
</script>
<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>


<h4>Expense Estimate</h4>
<table class="datatable">
<tbody>
<tr><th>Vacancy and Bad Debt<input id="v03" name="vc_pct" size="2" value="{$defaults.$c.VACANCY_PERCENT}" /> %</th>                <td>
<input disabled="disabled" name="vc_act" size="10" value="{$defaults.$c.VACANCY_AMOUNT|number_format:0}" /></td></tr>
  <tr><th>3 Year Replacements</th><td><input id="v04" name="impr3" size="10" value="" /></td></tr>
  <tr><th>5 Year Replacements</th><td><input id="v05" name="impr5" size="10" value="" /></td></tr>
  <tr><th>12 Year Replacements</th><td><input id="v06" name="impr12" size="10" value="" /></td></tr>
  <tr><th>Reserve Fund</th><td><input disabled="disabled" name="impr" size="10" value="" /></td></tr>
  <tr><th>Maintenance</th><td><input id="v07" name="maint" size="10" value="{$defaults.$c.MAINTENANCE|number_format:0}" /></td></tr>
  <tr><th>Utilities</th><td><input id="v08" name="util" size="10" value="{$defaults.$c.UTILITIES|number_format:0}" /></td>
  </tr><tr><th>Property Taxes</th><td><input id="v09" name="tax" size="10" value="{$defaults.$c.TAX|number_format:0}" /></td></tr>
  <tr><th>Insurance</th><td><input id="v10" name="ins" size="10" value="{$defaults.$c.INSURANCE|number_format:0}" /></td></tr>
  <tr><th>Management Fees</th><td><input id="v11" name="mgt" size="10" value="{$defaults.$c.MGT_AMOUNT|number_format:0}" /></td></tr>
  <tr><th>Net Operating Income</th><td><input disabled="disabled" name="noi" size="10" value="{$defaults.$c.NOI|number_format:0}" /></td></tr>
</tbody>
</table>

<h4>Estimated Value</h4>
<table class="datatable">
<tbody>
  <tr><th>Property Value</th><td><input id="v12" name="cur_value" size="10" value="{$defaults.$c.VALUE|number_format:0}" /></td></tr>
  <tr><th>Down Payment</th><td><input id="v13" name="down_payment" size="10" value="{$defaults.$c.DOWN|number_format:0}" /></td></tr>
  <tr><th>Closing Costs</th><td><input id="v14" name="c_costs" size="10" value="{$defaults.$c.COSTS|number_format:0}" /></td></tr>
  <tr><th><input name="Button" onclick="compute_value(this.form)" type="button" value=" Calculate" /></th></tr>
  <tr><th>Cash on Cash Return</th><td><input disabled="disabled" name="cash_on_cash" size="10" value="" /></td></tr>
  <tr><th>Unleveraged Yield</th><td><input id="v15" name="cap_rate" size="10" value="{$defaults.$c.CAP_RATE}" /></td></tr>
</tbody>
</table>
</form>

<h3>Finance</h3>
<form name="temps">
<table class="datatable">
<tbody>
  <tr><th>1st Loan Amount</th><td><input id="v16" name="LA" onchange="dosum()" size="6" type="TEXT" value="{$defaults.$c.LOAN|number_format:0}" /></td></tr>
  <tr><th>Type</th><td><select id="v17" name="loantype" onchange="dosum()">
                       <option selected="selected" value="Amortizing">Amortizing</option>
                       <option value="Interest Only">Interest Only</option></select></td></tr>
        <tr><th>Term</th><td><input id="v18" name="YR" onchange="dosum()" size="6" type="TEXT" value="30" /></td></tr>
  <tr><th>Interest Rate</th><td><input id="v19" name="IR" onchange="dosum()" size="6" type="TEXT" value="8.0" /></td></tr>
  <tr><th>Property Tax (Annual)</th><td><input name="AT" onchange="dosum()" size="6" type="TEXT" value="{$defaults.$c.TAX|number_format:0}" /></td></tr>
  <tr><th>Insurance(Annual)</th><td><input name="AI" onchange="dosum()" size="6" type="TEXT" value="{$defaults.$c.INSURANCE|number_format:0}" /></td></tr>
  <tr><th>Monthly Prin + Int</th><td><input disabled="disabled" name="PI" size="10" type="TEXT" /></td></tr>
  <tr><th>Monthly Tax</th><td><input disabled="disabled" name="MT" size="10" type="TEXT" /></td></tr>
  <tr><th>Monthly Ins</th><td><input disabled="disabled" name="MI" size="10" type="TEXT" /></td></tr>
  <tr><th>Monthly Total</th><td><input name="MP" size="10" type="TEXT" /></td></tr>
</tbody>
</table>
</form>


<form name="temps2">
  <table class="datatable">
    <tbody>
  <tr><th>2nd Loan Amount</th><td><input id="v20" name="LA" onchange="dosum2()" size="6" type="TEXT" value="0" /></td></tr>
  <tr><th>Type</th><td><select id="v21" name="loantype" onchange="dosum2()">
                       <option value="Amortizing">Amortizing</option>
                       <option selected="selected" value="Interest Only">Interest Only</option></select></td></tr>
  <tr><th>Term</th><td><input id="v22" disabled="disabled" name="YR" onchange="dosum2()" size="6" type="TEXT" value="" /></td></tr>
  <tr><th>Interest Rate</th><td><input id="v23" name="IR" onchange="dosum2()" size="6" type="TEXT" value="8.0" /></td></tr>
  <tr><th>Monthly Prin + Int</th><td><input name="PI" size="10" type="TEXT" /></td></tr>
    </tbody>
  </table>
</form>

{literal}
<script type="text/javascript"><!--
google_ad_client = "ca-pub-9857825912142719";
/* Mobile */
google_ad_slot = "2459853012";
google_ad_width = 320;
google_ad_height = 50;
//-->
</script>
<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>
{/literal}

<h3>Cash Flow</h3>
<table class="layouttable">
<form name="cf">
  <table class="datatable">
    <tbody>
  <tr><th>&nbsp;</th><th>Annual</th><th>Monthly</th></tr>
  <tr><th>Net Operating Income</th><td><input disabled="disabled" name="a_noi" size="6" type="text" value="" /></td>
    <td><input disabled="disabled" name="m_noi" size="6" type="text" value="" /></td></tr>
  <tr><th>1st Loan</th><td><input disabled="disabled" name="a_loan1" size="6" type="text" value="" /></td>
    <td><input disabled="disabled" name="m_loan1" size="6" type="text" value="" /></td></tr>
  <tr><th>2nd Loan</th><td><input disabled="disabled" name="a_loan2" size="6" type="text" value="" /></td>
    <td><input disabled="disabled" name="m_loan2" size="6" type="text" value="" /></td></tr>
  <tr><th>DSCR</th><td><input disabled="disabled" name="dscr" size="6" type="text" value="" /></td>
    <td id="dscr_status">&nbsp;</td></tr>

  <tr><th>Cash Flow</th><td><input name="a_cf" size="6" type="text" value="" /></td>
    <td><input name="m_cf" size="6" type="text" value="" /></td></tr>
    </tbody>
  </table>
</form>

{if $isEditor}

{literal}
  <script type="text/javascript">
    function submit2BU()
     {
      jQuery("#monthly_rent").val(jQuery('#v01').val());
      jQuery("#other_income").val(jQuery('#v02').val());
      jQuery("#vacancy_pct").val(jQuery('#v03').val());
      jQuery("#replace_3years").val(jQuery('#v04').val());
      jQuery("#replace_5years").val(jQuery('#v05').val());
      jQuery("#replace_12years").val(jQuery('#v06').val());
      jQuery("#maintenance").val(jQuery('#v07').val());
      jQuery("#utilities").val(jQuery('#v08').val());
      jQuery("#property_taxes").val(jQuery('#v09').val());
      jQuery("#insurance").val(jQuery('#v10').val());
      jQuery("#mgt_fees").val(jQuery('#v11').val());
      jQuery("#purchase_price").val(jQuery('#v12').val());
      jQuery("#down_payment").val(jQuery('#v13').val());
      jQuery("#closing_costs").val(jQuery('#v14').val());
      jQuery("#cap_rate").val(jQuery('#v15').val());
      jQuery("#loan1_amount").val(jQuery('#v16').val());
      jQuery("#loan1_type").val(jQuery('#v17').val());
      jQuery("#loan1_term").val(jQuery('#v18').val());
      jQuery("#loan1_rate").val(jQuery('#v19').val());
      jQuery("#loan2_amount").val(jQuery('#v20').val());
      jQuery("#loan2_type").val(jQuery('#v21').val());
      jQuery("#loan2_term").val(jQuery('#v22').val());
      jQuery("#loan2_rate").val(jQuery('#v23').val());

      jQuery('#save2BU').submit();
     }
  </script>
{/literal}
<form id="save2BU" action="/rental/visulate_search.php" method="post">
  <input id="prod_id"         name="PROP_ID"         type="hidden"  value="{$data.PROPERTY.PROP_ID}"/>
  <input id="report_code"     name="REPORT_CODE"     type="hidden"  value="SAVE2BU"/>
  <input id="mode"            name="MODE"            type="hidden"  value="cashflow"/>
  <input id="monthly_rent"    name="MONTHLY_RENT"    type="hidden" value=""/>
  <input id="other_income"    name="OTHER_INCOME"    type="hidden" value=""/>
  <input id="vacancy_pct"     name="VACANCY_PCT"     type="hidden" value=""/>
  <input id="replace_3years"  name="REPLACE_3YEARS"  type="hidden" value=""/>
  <input id="replace_5years"  name="REPLACE_5YEARS"  type="hidden" value=""/>
  <input id="replace_12years" name="REPLACE_12YEARS" type="hidden" value=""/>
  <input id="maintenance"     name="MAINTENANCE"     type="hidden" value=""/>
  <input id="utilities"       name="UTILITIES"       type="hidden" value=""/>
  <input id="property_taxes"  name="PROPERTY_TAXES"  type="hidden" value=""/>
  <input id="insurance"       name="INSURANCE"       type="hidden" value=""/>
  <input id="mgt_fees"        name="MGT_FEES"        type="hidden" value=""/>
  <input id="down_payment"    name="DOWN_PAYMENT"    type="hidden" value=""/>
  <input id="closing_costs"   name="CLOSING_COSTS"   type="hidden" value=""/>
  <input id="purchase_price"  name="PURCHASE_PRICE"  type="hidden" value=""/>
  <input id="cap_rate"        name="CAP_RATE"        type="hidden" value=""/>
  <input id="loan1_amount"    name="LOAN1_AMOUNT"    type="hidden" value=""/>
  <input id="loan1_type"      name="LOAN1_TYPE"      type="hidden" value=""/>
  <input id="loan1_term"      name="LOAN1_TERM"      type="hidden" value=""/>
  <input id="loan1_rate"      name="LOAN1_RATE"      type="hidden" value=""/>
  <input id="loan2_amount"    name="LOAN2_AMOUNT"    type="hidden" value=""/>
  <input id="loan2_type"      name="LOAN2_TYPE"      type="hidden" value=""/>
  <input id="loan2_term"      name="LOAN2_TERM"      type="hidden" value=""/>
  <input id="loan2_rate"      name="LOAN2_RATE"      type="hidden" value=""/>

  <table class="datatable">
    <tbody>
    <tr><th>&nbsp;</th><th>Save Estimate</th></tr>
    <tr><th>Business Unit</th><td><select name="BUSINESS_ID">
            {foreach from=$buList item=b key=k }
                             <option value="{$b.BUSINESS_ID}" {if $k==0} selected="selected"{/if}>{$b.BUSINESS_NAME}</option>
            {/foreach}
                             </select></td></tr>
    <tr><th>Title</th><td><input type="text" name="ESTIMATE_TITLE" size="30" value="Cashflow Estimate"/></td></tr>
    <tr><th>Action</th><td><input type="button" onclick="submit2BU();" value="Save"/> </td></tr>

    </tbody>
  </table>
</form>

{/if}
{literal}
<script type="text/javascript"><!--
google_ad_client = "ca-pub-9857825912142719";
/* Mobile */
google_ad_slot = "2459853012";
google_ad_width = 320;
google_ad_height = 50;
//-->
</script>
<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>
{/literal}

<p>
  <a href="http://visulate.com" style="display: none;">home</a></p>
