function changeStatusTenant(lst){
	if ((lst.value == "CURRENT" || lst.value == "CURRENT_SECONDARY") && formAgr.AGR_AGREEMENT_DATE.value == "")
	   alert("The Receivable list will not be generated \n because the agreement date is empty. \n Please enter an agreement date.");
   	
}