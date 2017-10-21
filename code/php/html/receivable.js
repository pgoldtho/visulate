
var undoArray = new Array();
var undoArray2 = new Array();

var oldUnnalocIndex = -1;
var oldUnnalocAmount = -1;
var oldUnnalocBalance = -1;


var oldAllocIndex1 = -1;
var oldAllocIndex2 = -1;
var oldAllocAmount = "0";

var old2AllocIndex1 = -1;
var old2AllocIndex2 = -1;
var old2AllocAmount = "0";

/*Paid button pressed*/
function Paid(index1, index2, obj, dateStr)
{
  if (obj.value == "Paid")
  {
	undoArray[index1] = new Array();  
	undoArray[index1][0] = getElementByName('RECEIVABLE['+index1+'][ALLOCATIONS]['+index2+'][AMOUNT]').value;
    undoArray[index1][1] = getElementByName('RECEIVABLE['+index1+'][ALLOCATIONS]['+index2+'][PAYMENT_DATE]').value;
    getElementByName('RECEIVABLE['+index1+'][ALLOCATIONS]['+index2+'][AMOUNT]').value = getElementByName('RECEIVABLE['+index1+'][ALLOCATIONS]['+index2+'][SUM_REMAINDER]').value; 
    getElementByName('RECEIVABLE['+index1+'][ALLOCATIONS]['+index2+'][PAYMENT_DATE]').value = dateStr;	
	obj.value = "Undo";
  }
  else
  {
	 // Undo button pressed 
     getElementByName('RECEIVABLE['+index1+'][ALLOCATIONS]['+index2+'][AMOUNT]').value = undoArray[index1][0]; 
     getElementByName('RECEIVABLE['+index1+'][ALLOCATIONS]['+index2+'][PAYMENT_DATE]').value = undoArray[index1][1]; 
     obj.value = "Paid";
  }
}

/*Paid button pressed for amount*/
function PaidSrc(index1, index2, obj, dateStr)
{
  if (obj.value == "Paid")
  {
	undoArray[index1] = new Array();  
	undoArray[index1][0] = getElementByName('RECEIVABLE['+index1+'][ALLOCATIONS]['+index2+'][AMOUNT]').value;
    undoArray[index1][1] = getElementByName('RECEIVABLE['+index1+'][ALLOCATIONS]['+index2+'][PAYMENT_DATE]').value;
    getElementByName('RECEIVABLE['+index1+'][ALLOCATIONS]['+index2+'][AMOUNT]').value = getElementByName('RECEIVABLE['+index1+'][AMOUNT]').value; 
    getElementByName('RECEIVABLE['+index1+'][ALLOCATIONS]['+index2+'][PAYMENT_DATE]').value = dateStr;	
	obj.value = "Undo";
  }
  else
  {
	 // Undo button pressed 
     getElementByName('RECEIVABLE['+index1+'][ALLOCATIONS]['+index2+'][AMOUNT]').value = undoArray[index1][0]; 
     getElementByName('RECEIVABLE['+index1+'][ALLOCATIONS]['+index2+'][PAYMENT_DATE]').value = undoArray[index1][1]; 
     obj.value = "Paid";
  }
}

/*Paid button pressed*/
function Paid2(index1, index2, obj, dateStr)
{
  if (obj.value == "Paid")
  {
	undoArray2[index1] = new Array();  
	undoArray2[index1][0] = getElementByName('PROP_PAYMENTS['+index1+'][ALLOCATIONS]['+index2+'][AMOUNT]').value;
    undoArray2[index1][1] = getElementByName('PROP_PAYMENTS['+index1+'][ALLOCATIONS]['+index2+'][PAYMENT_DATE]').value;
    getElementByName('PROP_PAYMENTS['+index1+'][ALLOCATIONS]['+index2+'][AMOUNT]').value = getElementByName('PROP_PAYMENTS['+index1+'][ALLOCATIONS]['+index2+'][REMAINDER_SUM]').value; 
    getElementByName('PROP_PAYMENTS['+index1+'][ALLOCATIONS]['+index2+'][PAYMENT_DATE]').value = dateStr;	
	obj.value = "Undo";
  }
  else
  {
	 // Undo button pressed 
     getElementByName('PROP_PAYMENTS['+index1+'][ALLOCATIONS]['+index2+'][AMOUNT]').value = undoArray2[index1][0]; 
     getElementByName('PROP_PAYMENTS['+index1+'][ALLOCATIONS]['+index2+'][PAYMENT_DATE]').value = undoArray2[index1][1]; 
     obj.value = "Paid";
  }
}

// submit allocation for payment
function submitAllocation(index1, index2)
{
	formPay.SAVE_ALLOC_INDEX1.value = index1;
	formPay.SAVE_ALLOC_INDEX2.value = index2;
	formPay.FORM_ACTION.value = "INSERT_PAYMENT_ALLOCATION";
}

// submit allocation for payment
function submitAllocation2(index1, index2)
{
	formPay.SAVE_ALLOC_INDEX1.value = index1;
	formPay.SAVE_ALLOC_INDEX2.value = index2;
	formPay.FORM_ACTION.value = "INSERT_PAYMENT_ALLOCATION_PROP";
}

// submit allocation for payment
function submitReceivable(index1)
{
	formPay.SAVE_ALLOC_INDEX1.value = index1;
	formPay.FORM_ACTION.value = "UPDATE_RECEIVABLE";
}

/*Submit for insert property payment*/
function submitAllocation3(index1)
{
	formPay.SAVE_ALLOC_INDEX1.value = index1;
	formPay.FORM_ACTION.value = "INSERT_PROP_PAYMENT";
}

function cancelAllocation3()
{
	formPay.FORM_ACTION.value = "CANCEL";
}

function round2(val)
{
	return Math.round(val*100)/100;
}

function setAllocationAmount()
{
   if (oldUnnalocIndex == -1 || (oldAllocIndex1 == -1 && old2AllocIndex1 == -1))
      return;
	  
   var amountSum = parseFloat(getElementByName('PAYMENTS['+oldUnnalocIndex+'][AMOUNT]').value.replace(",", ""));	  
   var alloc1Sum = 0;
   var alloc2Sum = 0;
   if (oldAllocIndex1 != -1)
    alloc1Sum = parseFloat(oldAllocAmount.replace(",", ""))
   if (old2AllocIndex1 != -1)
    alloc2Sum = parseFloat(old2AllocAmount.replace(",", ""))
	
   var  alloc = parseFloat(oldUnnalocAmount.replace(",", "")) + 
   		        parseFloat(alloc1Sum) + parseFloat(alloc2Sum);
   getElementByName('PAYMENTS['+oldUnnalocIndex+'][SUMMARY_ALLOCATED]').value = 
		   round2(alloc);

   getElementByName('PAYMENTS['+oldUnnalocIndex+'][BALANCE]').value = 
	       round2(amountSum - alloc);
}

function radioSelectUnalloc(idx)
{
	if (oldUnnalocIndex != -1)
	{
		// restore previous unnalocated values
		getElementByName('PAYMENTS['+oldUnnalocIndex+'][SUMMARY_ALLOCATED]').value = oldUnnalocAmount;
		
		var amountSum = parseFloat(getElementByName('PAYMENTS['+oldUnnalocIndex+'][AMOUNT]').value.replace(",", ""));	
		getElementByName('PAYMENTS['+oldUnnalocIndex+'][BALANCE]').value = round2(amountSum - parseFloat(oldUnnalocAmount.replace(",", "")), 2);	
//		getElementByName('PAYMENTS['+oldUnnalocIndex+'][AMOUNT]').disabled = false;
    }
	// remember new values
	oldUnnalocIndex = idx;
    oldUnnalocBalance = getElementByName('PAYMENTS['+idx+'][BALANCE]').value;
	oldUnnalocAmount = getElementByName('PAYMENTS['+idx+'][SUMMARY_ALLOCATED]').value;
  //  getElementByName('PAYMENTS['+oldUnnalocIndex+'][AMOUNT]').disabled = true;
	setAllocationAmount();
}

function radioSelectAlloc(idx1, idx2)
{
    oldAllocIndex1 = idx1;
    oldAllocIndex2 = idx2;	
    oldAllocAmount = getElementByName('RECEIVABLE['+idx1+'][ALLOCATIONS]['+(idx2)+'][AMOUNT]').value;
	setAllocationAmount();
} 

function radioSelectAlloc2(idx1, idx2)
{
    old2AllocIndex1 = idx1;
    old2AllocIndex2 = idx2;	
    old2AllocAmount = getElementByName('PROP_PAYMENTS['+idx1+'][ALLOCATIONS]['+(idx2)+'][AMOUNT]').value;
	setAllocationAmount();
} 

function onChangeUnalloc(index)
{
	var amountSum = parseFloat(getElementByName('PAYMENTS['+index+'][AMOUNT]').value.replace(",", ""));	
	var allocSum = parseFloat(getElementByName('PAYMENTS['+index+'][SUMMARY_ALLOCATED]').value.replace(",", ""));
    getElementByName('PAYMENTS['+index+'][BALANCE]').value = round2(amountSum - allocSum);	
	
    setAllocationAmount();
}