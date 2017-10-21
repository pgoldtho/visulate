{include file="header2.tpl"}
{*include file="header_2_1.tpl"*}
<script language="javascript">
  function addBU(business_id, supplier_id){ldelim}
    var divName = 'div_'+business_id+'_'+supplier_id;
    var taxValue = $('tax_'+business_id+'_'+supplier_id).value;
    var url = '{$PATH_FROM_ROOT}php/addBU-supplier-search.php?'+Object.toQueryString({ldelim}business_id: business_id, supplier_id : supplier_id, taxValue : taxValue{rdelim});
    var myAjax = new Ajax(url, {ldelim}method: 'get', 
                                       update: divName
                               {rdelim} );
    myAjax.request();
  {rdelim}
</script>
{$script}
<h3>Find Vendors</h3>
<div class="col-md-4">
<form {$form_data.attributes}>
  
  <table align="center" border=1 class="datatable1">
         {foreach from=$form_data item=element}
          {if @($element.type == "text" || $element.type == "checkbox" || $element.type == "select" || $element.type == "lov")}
            <tr>    
              <th style="text-align:right">{$element.label}</th>
                  <td valign="middle">
                 {$element.html}
                 { if (@$element.required) } <span class="error">*</span> {/if}
              </td>
            </tr>
           {/if}
       {/foreach}    
    <tr>
       <td colspan="2" style="text-align:right">{$form_data.find.html} {$form_data.hidden} </td>
    </tr>
  </table>
</form>
</div>
<div class="col-md-6">
<div id="helpText" class="actionDiv">
<h3>Instructions</h3>
<p>Use the form on the left to enter details for the vendor or type of
vendor you need to find.  You can use the "%" character as a wildcard.  
Press the "Find" button to search for Vendors.  The results will be displayed
at the bottom of the page.</p>
<p>
Click the "Include" link in the results list to add a vendor to your business
unit.
</p>  
</div>
</div>

<div class="col-md-12">

{if ($warning neq "")}
  <b>{$warning}</b>
{/if}
<table width="600px">
{foreach from=$data item=item key=key}
      <form>
   <tr><td style="border-bottom:1px dotted #006600"><br><b style="font-size:120%">{$key+1}. {$item.NAME} / {$item.SUPPLIER_TYPE_NAME}</b></td></tr>
   <tr><td>  E-mail: {$item.EMAIL_ADDRESS}<br> </td></tr>
   <tr><td>  Phones: {$item.PHONE1}{if ($item.PHONE2)}, {$item.PHONE2}{/if}</td></tr>
   <tr><td>  Address: {$item.ADDRESS1}{if ($item.ADDRESS2)}, {$item.ADDRESS2}{/if}</td></tr>
   <tr><td>  City/State/Zip Code:  {$item.CITY} / {$item.STATE_NAME} / {$item.ZIPCODE}</td></tr>
   {section name=bus loop=$item.BUSINESS_UNITS}
          <tr>
              {if ($item.BUSINESS_UNITS[bus].IS_INCLUDED eq "Y")}
                    <td><span style="color:#aaaaaa">{$item.BUSINESS_UNITS[bus].BUSINESS_NAME}, Tax: {$item.BUSINESS_UNITS[bus].TAX_IDENTIFIER}<span></td>
              {else}
                  <td><div id="div_{$item.BUSINESS_UNITS[bus].BUSINESS_ID}_{$item.SUPPLIER_ID}">
                  {$item.BUSINESS_UNITS[bus].BUSINESS_NAME}, Tax: <input type="text" maxlength="20" size="17" id="tax_{$item.BUSINESS_UNITS[bus].BUSINESS_ID}_{$item.SUPPLIER_ID}" name="tax_{$item.BUSINESS_UNITS[bus].BUSINESS_ID}_{$item.SUPPLIER_ID}">
               <a href="javascript: void(0);" onclick="addBU({$item.BUSINESS_UNITS[bus].BUSINESS_ID}, {$item.SUPPLIER_ID})">Include</a></div></td>
              {/if}

          </tr>
     {/section}
   </form>    
    
{/foreach}
</table>
</div>
{include file="footer.tpl"}
