{config_load file="default.conf"}
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
<head>
  <title>{#pageTitle#}</title>
  <base href="{$PATH_FROM_ROOT}">  
  <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" >
  <link rel="stylesheet" type="text/css" href="{$PATH_FROM_ROOT}css/default.css" >
  <link rel="stylesheet" type="text/css" href="{$PATH_FROM_ROOT}html/calendar/styles/calendar.css">
  <script language="JavaScript" src="{$PATH_FROM_ROOT}html/util.js" type="text/javascript"></script>
  <script language="JavaScript" src="{$PATH_FROM_ROOT}html/calendar/javascript/simplecalendar.js" type="text/javascript"></script>
</head>
<body>
  <h1>Quick entry for suppliers <span style="font-size:14px">(<a href="{$fromExistsLinkHref}">
  {if ($type == "NEW_SUPPLIER")}
    from exists
  {else}	
    new supplier
  {/if}
  </a>)</span> 
  </h1>
      
     {show_error info=$errorObj}
	 <table width="100%">
	 <tr>
	 <td align="center">
  {if ($success == "true")}
      <p class="okMsg">Supplier record inserted.</p>
	  <script language="javascript">
	     // --- update supplier list with new values
		 function addOption(obj, val, text)
		 {ldelim}
			 var oOption = opener.document.createElement("OPTION");
             oOption.text = text;
             oOption.value = val;
             obj.options.add(oOption);
		 {rdelim}
		 if ((expenseForm = opener.document.forms["formExpense"]) != null)
		    if ({$currentBUID} == expenseForm.elements["BUSINESS_ID"].value)
				 {ldelim}
				    var i = 0;
					do {ldelim}
  					   var list_obj = expenseForm.elements["ACCOUNTS["+i+"][SUPPLIER_ID]"];
					   if (list_obj != null)
					   {ldelim}
					     var val = list_obj.value;
					     while(list_obj.options.length != 0)
						    list_obj.remove(0);
                         {foreach from=$listSupplier item=item}
						    addOption(list_obj, {$item.SUPPLIER_ID}, "{$item.NAME}");
						 {/foreach}
						 list_obj.value = val; 
					   {rdelim}	
					   else
						  break; 
					   i++;
					{rdelim} while (true);
				 {rdelim}
	  </script>
   	  <form {$form_data.attributes}>	  
	     <input type="button" value="Close" onClick="window.close()">
		 <input type="hidden" name="BUSINESS_ID" value="{$currentBUID}">
         <input type="submit" name="new" value="Create Supplier">		 
  	     <input type="submit" name="add" value="Add Supplier">		 
      </form>
  {else}
	 <form {$form_data.attributes}>
			<table class="datatable">
			{foreach from=$form_data item=element}
				{if @($element.type == "text" || $element.type == "textarea" || $element.type == "select")}
					{if @(@$element.error)}
						<tr>
							<td colspan="2">
								<span class="error">{$element.error}</span>
						</td>
						</tr>
					{/if}		  
					<tr>		  
						<th>{$element.label}</th>
						<td valign="middle">
							{$element.html}
							{ if (@$element.required) } <span class="error">*</span> {/if}
						</td>
					</tr>
				{/if}	
			{/foreach}    
					<tr>
						<td colspan="2" align="right" style="text-align:right">
						{foreach from=$form_data item=element}
							{if @($element.type == 'submit')}
								{$element.html}
							{/if}
						{/foreach} 
						</td>
					</tr>
				</table>
			{$form_data.hidden}
		</form>  
     {/if}  {* ----- {if ($success)}*} 		
  </td>
  </tr>
 </form> 	

</body>
</html>