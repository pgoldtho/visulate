
var undoArray = new Array();

/*Paid button pressed*/
function Paid(index1, obj, dateStr)
{
  if (obj.value == "Paid" || obj.value == "Clear")
  {
	undoArray[index1] = getElementByName('PAYMENTS['+index1+'][PAYMENT_DATE]').value;
	if (obj.value == "Paid")
      getElementByName('PAYMENTS['+index1+'][PAYMENT_DATE]').value = dateStr;	
	else
	  getElementByName('PAYMENTS['+index1+'][PAYMENT_DATE]').value = "";	
	obj.value = "Undo";
  }
  else
  {
	 // Undo button pressed 
     getElementByName('PAYMENTS['+index1+'][PAYMENT_DATE]').value = undoArray[index1]; 
     obj.value = "Paid";
  }
}

