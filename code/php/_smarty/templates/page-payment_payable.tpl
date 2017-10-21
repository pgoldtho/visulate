{include file="header2.tpl"}
<script language="JavaScript" src="{$PATH_FROM_ROOT}html/payable.js" type="text/javascript"></script>
 
<script type="text/javascript">
    var gPtAccountsList = {$ptAccountsList};
</script>


{$script}

 
{literal}
	<script language="JavaScript" type="text/javascript">
	<!--
        isDomLoaded = false;

		function hideDivs(){
			$('schedDiv').setStyles({display : 'none'});
			$('unschedDiv').setStyles({display : 'none'});
		}

		function unsetCurrent()
		{
			$('sched').removeClass('current');
			$('unsched').removeClass('current');
		}

		function setCurrent(aName){
		    unsetCurrent();
 		    $(aName).addClass("current");
			$('CURRENT_LEVEL3').setProperty('value', aName);
			return false;
		}


		function showDiv(divName){
			hideDivs();
			$(divName).setStyles({display : 'block'});
			return false;
		}

        function getDivByMenuL3(menuName){
		    if (menuName == "sched")
		       return "schedDiv";
			if (menuName == "unsched")
			   return "unschedDiv";
		}
	
		    
    function setDefaultAccounts(index, obj) {
        var dbt  = document.getElementById('OTHER_PAYMENTS['+index+'][DEBIT_ACCOUNT]'); 
        var crdt = document.getElementById('OTHER_PAYMENTS['+index+'][CREDIT_ACCOUNT]');
        try {
            dbt.value  = gPtAccountsList[obj.value]["DEBIT_ACCOUNT"];
            crdt.value = gPtAccountsList[obj.value]["CREDIT_ACCOUNT"];
        } catch(e) {}
	}


  	window.addEvent('domready', function(){
	    showDiv(getDivByMenuL3($('CURRENT_LEVEL3').getProperty('value')));
		isDomLoaded = true;
    });
	//-->
	</script>
{/literal}
 
  <h1>{$header_title}</h1>
  <table>
    <tr>
	  <td width="100">
		  {if @($form_data.PREV_YEAR_LINK)}
			 {$form_data.PREV_YEAR_LINK.html}
		  {/if}
	  </td>	  
	  <td width="100">
       {$form_data.YEAR_MONTH.html}
	  </td> 
	  <td width="100">
		  {if @($form_data.NEXT_YEAR_LINK)}
			 {$form_data.NEXT_YEAR_LINK.html}
		  {/if}
      </td>
	</tr>
  </table>	 
  
  <table cellpadding="0" cellspacing="0">
  <tr><td style="width:500px">&nbsp;</td><td align="right"
  <table cellpadding="0" cellspacing="0">
    <tr><td style="text-align:right">Amount Owed:</td><td style="text-align:right">{$summary.PAYABLE_AMOUNT}</td></tr>
	<tr><td style="text-align:right">Paid:</td><td style="text-align:right">{$summary.ALLOCATED_AMOUNT}</td></tr>
	<tr><td style="border-top:1px #000000 solid;text-align:right">Balance Owed:</td><td style="border-top:1px #000000 solid;text-align:right">{$summary.BALANCE_AMOUNT}</td></tr>
  </table>
  </td></tr></table>
 {if ($msgSuccess)}
     <span style="background-color:#339900;color:white;padding:2px 4px">{$msgSuccess}</span>
  {/if}
   
 <form {$form_data.attributes}>   
  {show_error info=$errorObj}
{if ($businessID)}  

<div id="schedDiv" style="display:none">
  <h3>Scheduled Payments</h3>
  {if ($isEdit eq "true")}
      {* <a href="?{$menuObj->getParam2()}&BUSINESS_ID={$businessID}&FORM_ACTION=updateLstDue&YEAR_MONTH_HIDDEN={$currYearMonth}" class="small" title="Update list of payment due">Update List</a>*}
	  <span style="background-color:#dddddd;padding:6px 10px;border: 1px #aaaaaa dashed">
 	  <input type="submit" name="generateList" value="Update list">
	  to 
	  {if (@$form_data.UPDATE_LIST_DATE.error)}
	        <span class="error">({$form_data.UPDATE_LIST_DATE.error})</span>
	  {/if}
	  {$form_data.UPDATE_LIST_DATE.html}
	  {calendar elements=$dates current=$form_data.UPDATE_LIST_DATE.name}
	  </span>
       <br><br> 
   {/if}	
   
   {if $role == "MANAGER" || $role == "MANAGER_OWNER"}
      {if ($form_data.PAYMENTS|@count > 10)}
        <br/>
        {$form_data.save.html} {$form_data.cancel.html}
        <br/>
        <br/>
      {/if}  
   {/if}
        
   <table class="datatable">
     <tr>
	   <th>Date Due<span class="error">*</span></th>
	   <th>Payment For<span class="error">*</span></th>
	   <th>Amount<span class="error">*</span></th>
	   <th>Date Paid</th>
	   <th>Debit/Credit</th>
	   {if $role == "MANAGER" || $role == "MANAGER_OWNER"}
	   <th></th>
	   {/if}
     </tr>
     {if @($form_data.PAYMENTS)} 
	    {foreach from=$form_data.PAYMENTS item=item key=key}
	       <tr>
		    <td>
	          {$item.VPAYMENT_DUE_DATE.html}
			</td>
			<td>
			  {$item.FOR.html}<br>
			  {$item.PAYMENT_TYPE_NAME.value}
			</td>
			<td>
   			    {if @(@$item.AMOUNT.error)}
					 <span class="error">{$item.AMOUNT.error}</span>
					{/if}						 
			    {$item.AMOUNT.html}
			</td>
		    <td>{if @(@$item.PAYMENT_DATE.error)}
					 <span class="error">{$item.PAYMENT_DATE.error}</span>
				{/if}						 
				
				{if $role == "MANAGER" || $role == "MANAGER_OWNER"}
			        {$item.BUTTON.html}
			    {/if}

			    {$item.PAYMENT_DATE.html}
				{if ($isEdit eq "true")}
					   {calendar elements=$dates current=$item.PAYMENT_DATE.name}
				{/if}   
  	         </td>
  	         <td>
  	             {$item.DEBIT_ACCOUNT.html}
				 <br/>
				 {$item.CREDIT_ACCOUNT.html}
  	         </td>
  	 	     {if $role == "MANAGER" || $role == "MANAGER_OWNER"}
			 <td>
			    {if (@$item.DELETE_LINK_AP_ID)}
				     {$item.DELETE_LINK_AP_ID.html}
				{/if}
			 </td>
			 {/if}
    	 </tr>		
       {/foreach}						   
	{/if}
   </table>	    
   <a name="bottomOther"></a>
	<br>
     {if $role == "MANAGER" || $role == "MANAGER_OWNER"}
	     {$form_data.save.html} {$form_data.cancel.html}  
     {/if}	 
</div>
     
<div id="unschedDiv" style="display:none">     
   <h3>Unscheduled Payments</h3>
  {if ($isEdit eq "true")}
	  <a href="?{$menuObj->getParam2()}&BUSINESS_ID={$businessID}&FORM_ACTION=createOtherPayment&YEAR_MONTH_HIDDEN={$currYearMonth}&CURRENT_LEVEL3=unsched" class="small">New</a>
	  <br>
  {/if}	  

  {if $role == "MANAGER" || $role == "MANAGER_OWNER"}
     {if ($form_data.OTHER_PAYMENTS|@count > 10)}
       <br/>
       {$form_data.save.html} {$form_data.cancel.html}
       <br/>
       <br/>
     {/if}
  {/if}
  
   <table class="datatable">
     <tr>
	   <th>Date<span class="error">*</span></th>
	   <th>Property/Payment Type<span class="error">*</span></th>
	   <th>Supplier<span class="error">*</span></th>
	   <th>Amount<span class="error">*</span></th>
	   <th>Date Paid</th>
	   <th>Debit/Credit</th>
	   {if ($isEdit eq "true")}
  	      <th></th>
	   {/if}	  
     </tr>
     {if @($form_data.OTHER_PAYMENTS)} 
	    {foreach from=$form_data.OTHER_PAYMENTS item=item key=key}
	       <tr>
		    <td>
          			{if @(@$item.PAYMENT_DUE_DATE.error)}
					 <span class="error">{$item.PAYMENT_DUE_DATE.error}</span>
					{/if}
			          {$item.PAYMENT_DUE_DATE.html}
					  {if ($isEdit eq "true")}
					     {calendar elements=$dates current=$item.PAYMENT_DUE_DATE.name}
					  {/if}	 
			</td>
		    <td>{$item.PAYMENT_PROPERTY_ID.html}<br/>
		        {$item.PAYMENT_TYPE_ID.html}
		    </td>
			<td>{$item.SUPPLIER_ID.html}</td>
			<td>
   			    {if @(@$item.AMOUNT.error)}
					 <span class="error">{$item.AMOUNT.error}</span>
					{/if}						 
			    {$item.AMOUNT.html}
			</td>
		    <td>{if @(@$item.PAYMENT_DATE.error)}
					 <span class="error">{$item.PAYMENT_DATE.error}</span>
					{/if}						 
			    {$item.PAYMENT_DATE.html}
				{if ($isEdit eq "true")}
					   {calendar elements=$dates current=$item.PAYMENT_DATE.name}
				{/if}   
  	         </td>
  	         <td>
  	             {$item.DEBIT_ACCOUNT.html}
				 <br/>
				 {$item.CREDIT_ACCOUNT.html}
  	         </td>
			{if ($isEdit eq "true")}
   		        <td>{$item.LINK_DELETE.html}</td>
            {/if}
    	 </tr>		
       {/foreach}						   
	{/if}
   </table>	    
   <a name="bottomOther"></a>
    {$form_data.hidden}
	<br>
    {if $role == "MANAGER" || $role == "MANAGER_OWNER"}
    	{$form_data.save.html} {$form_data.cancel.html}  
    {/if}		
</div>

</form>
   
{/if}   
{include file="footer.tpl"}
