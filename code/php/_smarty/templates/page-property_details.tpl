{include file="header.tpl"}

{literal}
<style>
.overlay {
	display:none;
	position: absolute;
	top:0;
	left:0;
	width:100%;
	height:100%;
	overflow: visible;
	z-index:500;
	background-color: #eee;
	-moz-opacity: 0.3; /* Mozilla */
	opacity:.30;  /* CSS3 */
	filter: alpha(opacity=30); /* IE */
}
.window {
	display:none;
	position:absolute;
	float: left;
	width: 320px;
	background:  #a3a591;
    border: 1px solid #d6d6d6;
	border-left-color: #e4e4e4;
	border-top-color: #e4e4e4;
	font-size: 12px;
	font-weight: bold;
	padding: 0.5em;
	margin-top: 10px;
	margin-bottom: 2px;
	z-index: 1000;
}
</style>


<script language="JavaScript" type="text/javascript">
  <!--
  window.addEvent('domready', function()
	  {
     $each($$("p.help"), function (e, index)
		    {
	       e.setStyle('display', 'none');
	      });

    helptext("PROP_BUSINESS_ID_CODE");
    //
    helptext('PROP_BUSINESS_ID');
    helptext('PROP_UNITS');
    helptext('PROP_ADDRESS1');
    helptext('PROP_ADDRESS2');
    helptext('PROP_CITY');
    helptext('PROP_STATE');
    helptext('PROP_ZIPCODE');
    helptext('PROP_STATUS');
    helptext('PROP_DATE_PURCHASED');
    helptext('PROP_PURCHASE_PRICE');
    helptext('PROP_LAND_VALUE');
    helptext('PROP_DEPRECIATION_TERM');
    helptext('PROP_YEAR_BUILT');
    helptext('PROP_BUILDING_SIZE');
    helptext('PROP_LOT_SIZE');
    helptext('PROP_DATE_SOLD');
    helptext('PROP_SALE_AMOUNT');
    helptext('PROP_NOTE_YN');
    helptext('UNIT_UNIT_NAME');
    helptext('UNIT_UNIT_SIZE');
    helptext('UNIT_BEDROOMS');
    helptext('UNIT_BATHROOMS');
    helptext('UNIT_UNIT_ID_LINK');

    });
   -->
   
   window.onscroll = scroll;
   function scroll()
   {
       var cssObj = {top: window.pageYOffset, left: window.pageXOffset};
       $('overlayWindow').setStyles(cssObj);
   }

   function hide_utl_window()
   {
       $('utlWindow').setStyles({display : 'none'}); 
       $('overlayWindow').setStyles({display : 'none'}); 
   };

   function show_utl_window()
   {
       var cssObj = {top : 280, left : 315, display : 'block'};
       $('utlWindow').setStyles(cssObj); 
       
       $('overlayWindow').setStyles({display : 'block'}); 
   };
   
</script>
{/literal}
{$script}
<form {$form_data.attributes}>
<div class="col-md-6">
 <h1>{$header_title}</h1>
 <a name="top"></a>
 {show_error info=$errorObj}
   <table class="datatable1">
      {foreach from=$form_data item=element}
		  {if @($element.type == "text" || $element.type == "checkbox"
			                            || $element.type == "select"
										|| $element.type == "lov")}
             {if @(@$element.error)}
		        <tr>
			       <td colspan="2">
				     <span class="error">{$element.error}</span>
				   </td>
			    </tr>
		     {/if}

		     {if !($element.name == "FROM_BUSINESS_ID_CODE" || $element.name == "TO_BUSINESS_ID")}
                <tr>
		            <th>{$element.label}</th>
  	  	            <td class="{$element.name}" valign="middle">
				        {if ($element.name == "PROP_BUSINESS_ID_CODE") && $prop_has_details}
			                <a href="#" onclick="show_utl_window(); return false;">Move/Copy</a>
			                <br/>
			            {/if}
			         
			            {$element.html}
				        {calendar form="formProp" elements=$dates current=$element.name}
				        {if (@$element.required) } <span class="error">*</span> {/if}
			        </td>
			    </tr>
			 {/if}
		   {/if}
       {/foreach}
   </table>
</div>

<div class="col-md-6">
<h1>Rentable Units</h1>
{if @($form_data.UNITS)}
	<table class="datatable">
   	  <tr>
   	      <th>Unit</th>
	      {if ($num_units != 1)}
		      <th>Name<span class="error">*</span></th><th>Size</th>
		  {/if}
		  {assign var="required_type" value=""}
		  {if ($role == "ADVERTISE")}
		      {assign var="required_type" value="<span class=\"error\">*</span>"}
		  {/if}
		  <th>Beds {$required_type}</th>
		  <th>Bath {$required_type}</th>
		  {if ( ($isEdit == "true") && $num_units != 1)}
		      <th></th>
		  {/if}
	  </tr>
	  {assign var="i" value="1"}
      {foreach from=$form_data.UNITS item=element}
	     <tr>
	      <td>{$i++}</td>
    	  {foreach from=$element item=element1}
		     <td class="{$element1.name|regex_replace:"/UNITS\[\d+\]\[/":""|replace:']':''}" >
				  {$element1.html}
				  {if @($element1.error)}
						 <br><span class="error">{$element1.error}</span>
				  {/if}
	  	  	</td>
 	     {/foreach}
	     </tr>
	   {/foreach}
    </table>
{else}
   {if ($action != "INSERT_PROPERTY" && ($isEdit == "true"))}
   <i class="error">This property has no units. Click the "New unit" button to add Units for this
	                  property.</i>
   {/if}
{/if}

{if ($isEdit == "true")}
<div class="actionDiv">
{if ($role == "ADVERTISE")}
<h3>Actions (page 1 of 4)</h3>
		<p id="nextP">{$advertise_photo}</p>
   <div class="clear"><br/></div>
{else}
<h3>Actions</h3>
{/if}
 {$form_data.delete_prop.html} {$form_data.cancel.html} {$form_data.accept.html} {$form_data.new_property.html} {$form_data.new_unit.html}
</div>

<div id="helpText" class="actionDiv">
<h3>Instructions</h3>
<ol>
<li>Enter Property Details</li>
<li>Press Save</li>
<li>Enter Unit Details</li>
<li>Press Save</li>
</ol>
<p>Fields marked with * are required.</p>

<p id="PROP_BUSINESS_ID_CODE_help" class="help">Click on the list of values icon to select a business unit for the property.</p>

<p id="PROP_BUSINESS_ID_help" class="help">Click on the list of values icon to select a business unit for the property.</p>
<p id="PROP_UNITS_help" class="help">How many units does the property have?  Enter 1 for single family, 2 for duplex, 3 for triplex .. etc</p>
<p id="PROP_ADDRESS1_help" class="help">The first line of the address where the property is located.</p>
<p id="PROP_ADDRESS2_help" class="help">The second line of the address where the property is located.</p>
<p id="PROP_CITY_help" class="help">The city in which property is located.</p>
<p id="PROP_STATE_help" class="help">Click on the list of values icon to select the state where the property is located.</p>
<p id="PROP_STATUS_help" class="help">Click on the list of values icon to select the status the property.</p>
<p id="PROP_ZIPCODE_help" class="help">The zipcode for the property.  Visulate uses the zipcode to determine the county in property advertisements.  It also uses them to sort properties if you have more than one property in your business unit.</p>
<p id="PROP_DATE_PURCHASED_help" class="help">Enter the purchase date for the property in mm/dd/yyyy format.
Visulate uses the purchase date for investment analysis and tax reporting.
{if ($role == "ADVERTISE")}
  Don't worry if you can't find this information at the moment.  You can always update it later.
It won't be displayed in the advertisement.
{/if}
</p>
<p id="PROP_PURCHASE_PRICE_help" class="help">Enter the purchase price for the property.
Visulate uses the purchase purchase for investment analysis and tax reporting.
{if ($role == "ADVERTISE")}
  Don't worry if you can't find this information at the moment.  You can always update it later.
It won't be displayed in the advertisement.
{/if}
</p>
<p id="PROP_LAND_VALUE_help" class="help">Enter the land value at the time the property was purchased.
The IRS allows investors to depreciate the value of improvements (buildings) but not land.
The land value is subtracted from the purchase price to calculate the value of the improvements that
can be depreciated.  Visulate uses the land value for investment analysis and tax reporting.
{if ($role == "ADVERTISE")}
  Don't worry if you can't find this information at the moment.  You can always update it later.
It won't be displayed in the advertisement.
{/if}
</p>
<p id="PROP_DEPRECIATION_TERM_help" class="help">Enter 27.5 years for residential property and 39 years for commercial.</p>
<p id="PROP_YEAR_BUILT_help" class="help">What year was the building built?</p>
<p id="PROP_BUILDING_SIZE_help" class="help">The total size of the building in square feet.  This value is displayed in
advertisements for single family homes.  The unit size is displayed for multi-family listings.</p>
<p id="PROP_LOT_SIZE_help" class="help">The amount of land that the property sits on in acres (e.g. 1/4 acre = 0.25).</p>
<p id="PROP_DATE_SOLD_help" class="help">The date you sold this property if you no longer own it.</p>
<p id="PROP_SALE_AMOUNT_help" class="help">How much did you sell it for?</p>
<p id="PROP_NOTE_YN_help" class="help">Check this box if you are carrying a note as a result of the sale.</p>

<p id="UNIT_UNIT_NAME_help" class="help">Enter a unique name for the unit e.g. Unit 101, Unit 201 etc.</p>
<p id="UNIT_UNIT_SIZE_help" class="help">Enter the unit size in square feet.</p>
<p id="UNIT_BEDROOMS_help" class="help">How many bedrooms does the unit have?</p>
<p id="UNIT_BATHROOMS_help" class="help">How many bathrooms does the unit have?</p>
<p id="UNIT_UNIT_ID_LINK_help" class="help">Click on the x to delete this unit.</p>

</div>

	{$form_data.hidden}
{/if}

<br/>

{*
<input type="button" value="test: show" onclick="show_utl_window();">
*}

<div class="overlay" id="overlayWindow"></div>
<div class="window" id="utlWindow">
 {if ($role == "BUSINESS_OWNER")}
    Move or Copy Business Unit - {$header_title}
    <br/>
    <table>
    <tr>
        <td>From:</td><td>{$form_data.FROM_BUSINESS_ID_CODE.html}</td>
    </tr>
    <tr>
        <td>To:</td><td>{$form_data.TO_BUSINESS_ID.html}</td>
    </tr>
    <tr>
        <td>Transfer type:</td>
        <td valign="middle">
            <input name="transfer_type" type="radio" value="prop_move" checked/>
            Move the property and all its details
        </td>
    </tr> 
    <tr>    
        <td>&nbsp;</td>
        <td valign="baseline">
            <input name="transfer_type" type="radio" value="prop_copy" />
            Copy the property and estimates
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td>
            <input name="transfer_prop" type="submit" value="Save">
            <input name="cancel_transfer" type="button" value="Cancel" onclick="hide_utl_window();">
        </td>
    </tr>
    </table>
 {else}  
     <p>
        This property has estimates, income, expense or tenant  details associated with it.
        It can only be transferred to another business unit by someone with the ‘Business Owner’ role.
        Please select the Business Owner role (on login) or contact your Visulate representative.
     </p>
     <input name="cancel_transfer" type="button" value="Cancel" onclick="hide_utl_window();">
 {/if}
</div>

</div>
</form>


{include file="footer.tpl"}
