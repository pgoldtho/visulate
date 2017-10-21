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

{include file="mobile-calc-noi1.tpl"}
{include file="mobile-calc-noi2b.tpl"}
{include file="mobile-calc-fin1.tpl"}
{include file="mobile-calc-fin2.tpl"}
{include file="mobile-calc-cashflow.tpl"}
{include file="adsense-mobile320x100.tpl"}


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

<p>
  <a href="http://visulate.com" style="display: none;">home</a></p>
