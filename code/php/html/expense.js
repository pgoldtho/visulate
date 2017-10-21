function setEnabledRecurring()
{
   var arr = document.getElementsByName("RECURRING_PERIOD"); 
   if (arr.length == 0 || arr == null)
	  return;
   
   if (document.formExpense.RECURRING_YN == null || document.formExpense.RECURRING_YN.length == null)
	  return;	  
	  
   document.formExpense.RECURRING_PERIOD.disabled = !document.formExpense.RECURRING_YN[1].checked;
   if (document.formExpense.RECURRING_PERIOD.disabled && document.formExpense.RECURRING_PERIOD.value != "")
       document.formExpense.RECURRING_PERIOD.value = "";
}



function checkForm()
{
	var arr = document.getElementsByName("RECURRING_PERIOD"); 
    if (arr.length == 0 || arr == null)
	  return;
	
	if (document.formExpense.RECURRING_YN == null || document.formExpense.RECURRING_YN.length == null)
	  return;
	  
	// 1 - its checkbox, 0 - hidden 
	if (document.formExpense.RECURRING_YN[1].checked) 
	{
	    if 	(document.formExpense.RECURRING_PERIOD.value == "")
		{
		   alert("Set recurring period");
		   return false;
		}
    }  
	else
	{
	    if 	(document.formExpense.RECURRING_PERIOD.value != "")
		{
		   alert("Recurring period not used. Please check reccuring flag or set recurring period to empty.");
		   return false;
		}
    }
	
	return true;
}