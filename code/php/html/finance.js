
function changeSettlementDate(form)
{
   var i = 0;
   var isWarning = false;   
   while (true)
   {
      
	  var input = getElementByName2("LOANS["+ i +"][LOAN_SETTLEMENT_DATE]");
	  i++;
	  
	  if (input == null)
	     break;
	  
	  if (input.value != "")
	  {
	      // try to date
		  try
		  {
	         var ms = Date.parse(input.value);
             var today = new Date();		
			 // add 20 day for today	 
			 today.setDate(today.getDate() + 20);
			 if (ms > today)
			 {
			    isWarning = true;
				break;
			 }
		  }
		  catch(e)
		  {

		  }
	  } // --- 	 if (input.value != "")
   } // ---  while (true)
   
   if (isWarning)
   {
      
      return window.confirm("One of the Settlement Date in future. Continue?");
   }   
   
   return true;
}