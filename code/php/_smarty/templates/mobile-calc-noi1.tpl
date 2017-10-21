<div data-role="collapsible">
<h4>Income </h4>

<form id="prop" name="prop">
<table data-role="table" data-mode="columntoggel" class="datatable ui-responsive table-stroke">
<caption>Estimated Income</caption>
<tbody>
  <tr><th>Monthly Rent</th><td><input type="number" id="v01" name="rent" size="10" 
                                      value="{if $defaults}{$defaults.$c.MONTHLY_RENT|number_format:0|replace:','}{/if}" /></td></tr>
  <tr><th>Annual Rent</th><td><input type="number" readonly="readonly" name="gross" size="10"  disabled="disabled"
                                     value="{$defaults.$c.ANNUAL_RENT|number_format:0|replace:','}" /></td></tr>
  <tr><th>Other Income</th><td><input type="number" id="v02" name="other" size="10" value=""  /></td></tr>
  <tr><th>Total Gross</th><td><input readonly="readonly" name="total_gross" size="10" disabled="disabled"
                                     value="{$defaults.$c.ANNUAL_RENT|number_format:0}" /></td></tr>
</tbody>
</table>

<table data-role="table" data-mode="columntoggel" class="datatable ui-responsive table-stroke" >
<caption>Expense Estimates</caption>
<tbody>
<tr><th>Vacancy and Bad Debt Percentage</th><td><input type="number" id="v03" name="vc_pct" size="2"
                                   value="{if $defaults}{$defaults.$c.VACANCY_PERCENT}{else}15{/if}" /></td></tr>
<tr><th>Vacancy and Bad Debt Amount</th><td>
                            <input type="number" readonly="readonly" name="vc_act" size="10"  disabled="disabled"
                                   value="{$defaults.$c.VACANCY_AMOUNT|number_format:0|replace:','}" /></td></tr>
  <tr><th>3 Year Replacements</th><td><input type="number" id="v04" name="impr3" size="10"  
  value="" /></td></tr>
  <tr><th>5 Year Replacements</th><td><input type="number" id="v05" name="impr5" size="10" 
  value="" /></td></tr>
  <tr><th>12 Year Replacements</th><td><input type="number" id="v06" name="impr12" size="10"  
  value="" /></td></tr>
  <tr><th>Reserve Fund</th><td><input type="number" readonly="readonly" name="impr" size="10"   value=""  disabled="disabled" /></td></tr>
  <tr><th>Maintenance</th><td><input type="number" id="v07" name="maint" size="10" 
  {if $defaults}value="{$defaults.$c.MAINTENANCE|number_format:0|replace:','}"{/if} /></td></tr>
  <tr><th>Utilities</th><td><input type="number" id="v08" name="util" size="10" 
  {if $defaults}value="{$defaults.$c.UTILITIES|number_format:0|replace:','}"{/if} /></td></tr>
  <tr><th>Property Taxes</th><td><input type="number" id="v09" name="tax" size="10"
  {if $defaults}value="{$defaults.$c.TAX|number_format:0|replace:','}"{/if} /></td></tr>
    <tr><th>Insurance</th><td><input type="number" id="v10" name="ins" size="10" 
  {if $defaults}value="{$defaults.$c.INSURANCE|number_format:0|replace:','}"{/if} /></td></tr>
  
  <tr><th>Management Fees</th><td><input type="number" id="v11" name="mgt" size="10" 
  {if $defaults}value="{$defaults.$c.MGT_AMOUNT|number_format:0|replace:','}"{/if} /></td></tr>
  
  <tr><th>Net Operating Income (NOI)</th><td><input readonly="readonly"  disabled="disabled" name="noi" size="10" 
  value="{$defaults.$c.NOI|number_format:0}" /></td></tr>
</tbody>
</table>

