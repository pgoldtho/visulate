{include file="header.tpl"}
<script language="JavaScript" src="{$PATH_FROM_ROOT}html/cap_calc.js" type="text/javascript"></script>
<script language="javascript">
  function doComplete(data){ldelim}
    var myObj = Json.evaluate(data);
  for(x in myObj){ldelim}
    $(x).value =  myObj[x];
  {rdelim}
  compute_value(document.calc);
  dosum();
  dosum2();
  {rdelim}
  
  function failureAjax(){ldelim}
    alert('Can not perform request for estimate parameters.');
  {rdelim}
  
 {if ($isEdit == "true")}
  window.addEvent('domready', function(){ldelim}
        $('GET_DATA_FOR_YEAR').addEvent('click', function(e) {ldelim}

       {if ($action != "INSERT")}
          if (!confirm('This will overwrite the current data. Do you want to continue?'))
           return false;
           {/if}
  
       if (this.value == ""){ldelim}
          alert('Please set Estimate Year');
          return false;
       {rdelim}
       var url = "{$PATH_FORM_ROOT}/php/estimate_params.php";
       var myAjax = new Ajax(url, {ldelim}
                                      method: 'get',
                      onComplete : doComplete,
                      data:{ldelim}propertyID: this.form.PROPERTY_ID.value,
                                   year: this.form.ESTIMATE_YEAR.value
                         {rdelim}
                         {rdelim});
  
             myAjax.onFailure = failureAjax;
             myAjax.request();
    {rdelim});
  {rdelim});  
{/if}
  
</script>
<h1>{$header_title}</h1>
{show_error info=$errorObj}
<h1>
    Property Estimates
    <sup>
        <a href="?{$menuObj->getParam2()}&{$menu3Obj->request_property_id}={$menu3Obj->current_property_id}&PROPERTY_ESTIMATES_ID={$currentEstimatePropID}&IS_SPREADSHEET_DOWNLOAD=1" target="_blank">
            <img heigth="16" width="16" src="{$PATH_FROM_ROOT}images/excel-icon-16.gif">
        </a>
    </sup>
</h1>
{if ($downloadSpreadsheetFileError)}
<span class="error">{$downloadSpreadsheetFileError}</span>
{/if}

<div class="col-md-4">
<h3>Saved</h3>
<table class="datatable">
  <tr>
     <th>Year</th>
   <th>Title</th>
  </tr>
  {foreach from=$estimateList item=item}
     <tr>
     {if ($item.PROPERTY_ESTIMATES_ID == $currentEstimatePropID && $action != 'INSERT')}
        <td><b>{$item.ESTIMATE_YEAR}</b></td>
      <td><b>{$item.ESTIMATE_TITLE}</b></td>
     {else}
        <td><a href="{$item.href}">{$item.ESTIMATE_YEAR}</a></td>
      <td><a href="{$item.href}">{$item.ESTIMATE_TITLE}</a></td>
     {/if}
   </tr>
  {/foreach}
  {if ($action == 'INSERT')}
      <tr>
       <td style="2" colspan="2"><b>---New---</b></td>
   </tr>
  {/if}
</table>
</div>
<div class="col-md-6">
{if ($action == 'INSERT')}
   <h3>New</h3>
{else}
   <h3>Selected</h3>
{/if}
<form {$form_data.attributes}>
 
        <table class="datatable1">
            <tbody>
              <tr>
                <th>{$form_data.ESTIMATE_YEAR.label}<span class="error">*</span></th>
                <td>{$form_data.ESTIMATE_YEAR.html} <span class="error">{$form_data.ESTIMATE_YEAR.error}</span> 
            {if ($isEdit == "true")}
             {$form_data.GET_DATA_FOR_YEAR.html}</td>
        {/if}
              </tr>
              <tr>
                <th>{$form_data.ESTIMATE_TITLE.label}</th>
                <td>{$form_data.ESTIMATE_TITLE.html}<span class="error">{$form_data.ESTIMATE_TITLE.error}</span></td>
              </tr>
            </tbody>
          </table>
{if ($isEdit == "true")}
         {$form_data.new.html}
        {$form_data.delete.html}
        {$form_data.cancel.html}
        {$form_data.saveas.html}
        {$form_data.accept.html}
{/if}  
</div>          
<div class="col-md-12" >      
<h3>NOI and CAP Rate</h3>
<div class="col-md-2" >
      <table class="datatable1">
            <tbody>
              <tr>
                <th>{$form_data.MONTHLY_RENT.label}<span class="error">*</span></th>
                <td>{$form_data.MONTHLY_RENT.html} <span class="error">{$form_data.MONTHLY_RENT.error}</span>{*<input name="prop_rent" value="1,800" size="10">*}</td>
              </tr>
              <tr>
                <th>Annual Rent</th>
                <td><input name="prop_gross" disabled="disabled" value="" size="10"></td>
              </tr>
              <tr>
                <th>{$form_data.OTHER_INCOME.label}</th>
                <td>{$form_data.OTHER_INCOME.html}<span class="error">{$form_data.OTHER_INCOME.error}</span></td>
              </tr>
              <tr>
                <th>Total Gross </th>
                <td><input name="prop_total_gross" disabled="disabled" value="" size="10"></td>
              </tr>
            </tbody>
          </table>
</div>          
<div class="col-md-4" >
        <table class="datatable1">
            <tbody>
              <tr>
                <th>{$form_data.VACANCY_PCT.label}
                  {$form_data.VACANCY_PCT.html}<span class="error">{$form_data.VACANCY_PCT.error}</span>
                  % </th>
                <td><input name="prop_vc_act" disabled="disabled" value="" size="10"></td>
              </tr>
              <tr>
                <th>{$form_data.REPLACE_3YEARS.label}</th>
                <td>{$form_data.REPLACE_3YEARS.html}<span class="error">{$form_data.REPLACE_3YEARS.error}</span></td>
              </tr>
              <tr>
                <th>{$form_data.REPLACE_5YEARS.label}</th>
                <td>{$form_data.REPLACE_5YEARS.html}<span class="error">{$form_data.REPLACE_5YEARS.error}</span></td>
              </tr>
              <tr>
                <th>{$form_data.REPLACE_12YEARS.label}</th>
                <td>{$form_data.REPLACE_12YEARS.html}<span class="error">{$form_data.REPLACE_12YEARS.error}</span></td>
              </tr>
              <tr>
                <th>Reserve Fund</th>
                <td><input name="prop_impr" disabled="disabled" value="" size="10"></td>
              </tr>
              <tr>
                <th>{$form_data.MAINTENANCE.label}</th>
                <td>{$form_data.MAINTENANCE.html}<span class="error">{$form_data.MAINTENANCE.error}</span></td>
              </tr>
              <tr>
                <th>{$form_data.UTILITIES.label}</th>
                <td>{$form_data.UTILITIES.html}<span class="error">{$form_data.UTILITIES.error}</span></td>
              </tr>
              <tr>
                <th>{$form_data.PROPERTY_TAXES.label}</th>
        <td>{$form_data.PROPERTY_TAXES.html}<span class="error">{$form_data.PROPERTY_TAXES.error}</span></td>
              </tr>
              <tr>
                <th>{$form_data.INSURANCE.label}</th>
                <td>{$form_data.INSURANCE.html}<span class="error">{$form_data.INSURANCE.error}</span></td>
              </tr>
              <tr>
                <th>{$form_data.MGT_FEES.label}</th>
                <td>{$form_data.MGT_FEES.html}<span class="error">{$form_data.MGT_FEES.error}</span></td>
              </tr>
              <tr>
                <th>Net Operating Income</th>
                <td><input type="text" name="prop_noi" disabled="disabled" value="" size="10"></td>
              </tr>
            </tbody>
          </table>
</div>          
<div class="col-md-4" >                    
        <table class="datatable1">
            <tbody>
              <tr>
                <th>{$form_data.PURCHASE_PRICE.label}</th>
                <td>{$form_data.PURCHASE_PRICE.html}<span class="error">{$form_data.PURCHASE_PRICE.error}</span></td>
              </tr>
              <tr>
                <th>{$form_data.DOWN_PAYMENT.label}</th>
                <td>{$form_data.DOWN_PAYMENT.html}<span class="error">{$form_data.DOWN_PAYMENT.error}</span></td>
              </tr>
              <tr>
                <th>{$form_data.CLOSING_COSTS.label}</th>
                <td>{$form_data.CLOSING_COSTS.html}<span class="error">{$form_data.CLOSING_COSTS.error}</span></td>
              </tr>
        {if ($isEdit == "true")}
              <tr>
                <th><input name="prop_Button" value=" Calculate" onclick="compute_value(this.form)" type="button"></th>
                <td></td>
              </tr>
        {/if}
              <tr>
                <th>Cash on Cash Return</th>
                <td><input name="prop_cash_on_cash" disabled="disabled" value="" size="10"></td>
              </tr>
              <tr>
                <th>{$form_data.CAP_RATE.label}</th>
                <td>{$form_data.CAP_RATE.html}<span class="error">{$form_data.CAP_RATE.error}</span></td>
              </tr>
            </tbody>
          </table>
</div></div>          
<div class="col-md-8" >                    
          
  <h3>Finance</h3>
  <table class="layouttable">
    <tbody>
      <tr>
        <td><table class="datatable1">
            <tbody>
              <tr>
                <th>{$form_data.LOAN1_AMOUNT.label}</th>
                <td>{$form_data.LOAN1_AMOUNT.html}<span class="error">{$form_data.LOAN1_AMOUNT.error}</span></td>
              </tr>
              <tr>
                <th>{$form_data.LOAN1_TYPE.label}</th>
                <td>{$form_data.LOAN1_TYPE.html}<span class="error">{$form_data.LOAN1_TYPE.error}</span></td>
              </tr>
              <tr>
                <th>{$form_data.LOAN1_TERM.label}</th>
                <td>{$form_data.LOAN1_TERM.html}<span class="error">{$form_data.LOAN1_TERM.error}</span></td>
              </tr>
              <tr>
                <th>{$form_data.LOAN1_RATE.label}</th>
                <td>{$form_data.LOAN1_RATE.html}<span class="error">{$form_data.LOAN1_RATE.error}</span></td>
              </tr>
              <tr>
                <th>Property Tax (Annual)</th>
                <td><input name="temps_AT" onchange="dosum()" size="6" value="1000" type="text"></td>
              </tr>
              <tr>
                <th>Insurance(Annual)</th>
                <td><input name="temps_AI" onchange="dosum()" size="6" value="300" type="text"></td>
              </tr>
              <tr>
                <th>Monthly Prin + Int</th>
                <td><input disabled="disabled" name="temps_PI" size="10" type="text">
                </td>
              </tr>
              <tr>
                <th>Monthly Tax </th>
                <td><input disabled="disabled" name="temps_MT" size="10" type="text">
                </td>
              </tr>
              <tr>
                <th>Monthly Ins </th>
                <td><input disabled="disabled" name="temps_MI" size="10" type="text">
                </td>
              </tr>
              <tr>
                <th>Monthly Total </th>
                <td><input name="temps_MP" size="10" type="text">
                </td>
              </tr>
            </tbody>
          </table></td>
        <td><table class="datatable1">
            <tbody>
              <tr>
                <th>{$form_data.LOAN2_AMOUNT.label}</th>
                <td>{$form_data.LOAN2_AMOUNT.html}<span class="error">{$form_data.LOAN2_AMOUNT.error}</span></td>
              </tr>
              <tr>
                <th>{$form_data.LOAN2_TYPE.label}</th>
                <td>{$form_data.LOAN2_TYPE.html}<span class="error">{$form_data.LOAN2_TYPE.error}</span></td>
              </tr>
              <tr>
                <th>{$form_data.LOAN2_TERM.label}</th>
                <td>{$form_data.LOAN2_TERM.html}<span class="error">{$form_data.LOAN2_TERM.error}</span></td>
              </tr>
              <tr>
                <th>{$form_data.LOAN2_RATE.label}</th>
                <td>{$form_data.LOAN2_RATE.html}<span class="error">{$form_data.LOAN2_RATE.error}</span></td>
              </tr>
              <tr>
                <th>Monthly Prin + Int</th>
                <td><input name="temps2_PI" size="10" type="text">
                </td>
              </tr>
            </tbody>
          </table></td>
      </tr>
    </tbody>
  </table>
</div>          
<div class="col-md-4" >            
  
  <h3>Cash Flow</h3>
  <table class="datatable1">
    <tbody>
      <tr>
        <th></th>
        <th>Annual</th>
        <th>Monthly</th>
      </tr>
      <tr>
        <th>Net Operating Income</th>
        <td><input name="cf_a_noi" size="6" disabled="disabled" value="" type="text"></td>
        <td><input name="cf_m_noi" size="6" disabled="disabled" value="" type="text"></td>
      </tr>
      <tr>
        <th>1st Loan</th>
        <td><input name="cf_a_loan1" size="6" disabled="disabled" value="" type="text"></td>
        <td><input name="cf_m_loan1" size="6" disabled="disabled" value="" type="text"></td>
      </tr>
      <tr>
        <th>2nd Loan</th>
        <td><input name="cf_a_loan2" size="6" disabled="disabled" value="" type="text"></td>
        <td><input name="cf_m_loan2" size="6" disabled="disabled" value="" type="text"></td>
      </tr>
      <tr><th>DSCR</th><td><input disabled="disabled" name="dscr" size="6" type="text" value="" /></td>
      <td id="dscr_status">&nbsp;</td></tr>
      <tr>
        <th>Cash Flow</th>
        <td><input name="cf_a_cf" size="6" value="" type="text"></td>
        <td><input name="cf_m_cf" size="6" value="" type="text"></td>
      </tr>
    </tbody>
  </table>
</div>
<div class="col-md-10" >            
  <table class="datatable1">
    <tbody>
      <tr>
        <th>{$form_data.NOTES.label}</th>
      </tr>
      <tr>
        <td>{$form_data.NOTES.html}<span class="error">{$form_data.NOTES.error}</span></td>
      </tr>
    </tbody>
  </table>
  <table width="540px">
      <tr>
       {$form_data.hidden}
       <td style="text-align:right">
          {$form_data.new.html}
        {$form_data.delete.html}
        {$form_data.cancel.html}
      {$form_data.saveas.html}
        {$form_data.accept.html}
     </td>
    </tr>
  </table>
</div>  
</form>

<script language="javascript">
   compute_value(document.calc);
   dosum();
   dosum2();
</script>
{include file="footer.tpl"} 