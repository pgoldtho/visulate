<?
 require_once dirname(__FILE__)."/../classes/database/rnt_properties.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_acc_payable.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_expenses.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_expense_items.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";
 
 $mobile_device = Context::getMobileDevice();
 if ($mobile_device)
  {
    $template_name = "mobile-expence.tpl";
    $desc_width = 40;
  }
 else
  {
   $template_name = "page-property_expence.tpl";
   $desc_width = 60;
  }

 if (!defined("PROPERTY_EXPENSE"))
 {
    define("PROPERTY_EXPENSE", "1");
    define("UPDATE_ACTION", "UPDATE");
    define("DELETE_ACTION", "DELETE");
    define("INSERT_ACTION", "INSERT");
    define("CANCEL_ACTION", "CANCEL");
    define("INSERT_ACTION_ACCOUNT", "INSERT_ACCOUNT");
    define("DELETE_ACTION_ACCOUNT", "DELETE_ACCOUNT");
    define("INSERT_ACTION_ITEM", "INSERT_ITEM");
    define("DELETE_ACTION_ITEM", "DELETE_ITEM");
 }

 $dbProp     = new RNTProperties($smarty->connection);
 $dbExpenses = new RNTExpenses($smarty->connection);
 $dbAccounts = new RNTAccountPayable($smarty->connection);
 $dbItems    = new RNTExpenseItems($smarty->connection);

 $form = new HTML_QuickForm('formExpense', 'POST');
 $IsPost = $form->isSubmitted();
 $action = UPDATE_ACTION;
 $dates_elements = array();

 $currentPropertyID = $menu3->current_property_id;
 $currentBUID = $dbProp->getBusinessUnit($currentPropertyID);
 $currentExpenseID = @$_REQUEST["EXPENSE_ID"];
 $href = $GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&".$menu3->getParams()."&EXPENSE_ID=". $currentExpenseID;
 $currentYear = @$_REQUEST["currYear"];
 $yearList = $dbExpenses->getYearList();

 $currentL3 = @$_REQUEST['CURRENT_LEVEL3'];

 if (!$currentL3){
 	// TODO  set menu 3 depend from submit button
 	$currentL3 = "descA";
 }

 if (!$yearList)
    // no found year in list
    $yearList = array(array("YEAR"=>date("Y")));
 if (!$currentYear)
   $currentYear = $yearList[0]["YEAR"];

 $IsSave = @$_REQUEST["accept"] || @$_REQUEST['new_item'];

 if (@$_REQUEST["next"] || @$_REQUEST["prev"])
 {
   $id = @$_REQUEST["NEXT_DIRECTION_ID"];
   if (@$_REQUEST["prev"])
      $id = @$_REQUEST["PREV_DIRECTION_ID"];
   header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&".$menu3->getParams()."&EXPENSE_ID=".$id);
   exit;
 }

 if (@$_REQUEST["new"])
 {
    header("Location: ".$href."&FORM_ACTION=INSERT&currYear=".$currentYear);
    exit;
 }

 if (@$_REQUEST["new_account"]){
    header("Location: ".$href."&FORM_ACTION=INSERT_ACCOUNT&currYear=".$currentYear."&CURRENT_LEVEL3=invoiceA");
    exit;
 }
/*
 if (@$_REQUEST["new_item"]){
    header("Location: ".$href."&FORM_ACTION=INSERT_ITEM&currYear=".$currentYear."&CURRENT_LEVEL3=itemsA&ITEMS_SUPPLIER_ID=".@$_REQUEST['ITEMS_SUPPLIER_ID']);
    exit;
 }
 */

 if (@$_POST['FORM_ACTION'] == "SELECT_OTHER_SUPPLIER"){
 	header("Location: ".$href."&currYear=".$currentYear."&CURRENT_LEVEL3=itemsA&ITEMS_SUPPLIER_ID=".@$_REQUEST['ITEMS_SUPPLIER_ID']);
    exit;
 }


 if (@$_POST['FORM_ACTION'] == "CHANGE_ITEMS_ACCEPTED_FLAG"){
    $tmp = $_REQUEST["ITEMS_ACCEPTED"];
    $key = $_REQUEST['ITEMS_SUPPLIER_ID'];
    $items_accepted = $tmp[$key];
    $items_accepted = is_null($items_accepted) ? "N" : "Y";

    //update ACCEPTED_YN values of expense items for supplier
    $IsError = 0;
    try
    {
        $dbItems->UpdateItemsAcceptedFlag(
            $_REQUEST["EXPENSE_ID"],
            $_REQUEST['ITEMS_SUPPLIER_ID'],
            $items_accepted
        );

        $smarty->connection->commit();
    }
    catch(SQLException $e)
    {
          $IsError = 1;
          $smarty->connection->rollback();
          $de =  new DatabaseError($smarty->connection);
          $smarty->assign("errorObj", $de->getErrorFromException($e));
    }

    if(!$IsError)
    {
 	    header("Location: ".$href.
 	           "&currYear=".$currentYear.
 	           "&CURRENT_LEVEL3=itemsA".
 	           "&ITEMS_SUPPLIER_ID=".$_REQUEST["ITEMS_SUPPLIER_ID"].
 	           "&ITEMS_ACCEPTED=".$items_accepted
 	    );
 	    exit;
    }
 }


 if (@$_POST["cancel"])
   $action = CANCEL_ACTION;
 else
 if (@$_REQUEST["delete"])
    $action = DELETE_ACTION;
 else
 if (@$_REQUEST["FORM_ACTION"] == INSERT_ACTION)
   $action = INSERT_ACTION;
 else
 if (@$_REQUEST["FORM_ACTION"] == INSERT_ACTION_ACCOUNT)
   $action = INSERT_ACTION_ACCOUNT;
 else
 if (@$_REQUEST["action"] == "delete_acc")
 {
   $action = DELETE_ACTION_ACCOUNT;
   $deleteApID = $_REQUEST["AP_ID"];
 }
 else if (@$_REQUEST["action"] == "delete_item")
 {
   $action = DELETE_ACTION_ITEM;
   $deleteExpenseItemID = $_REQUEST["EXPENSE_ITEM_ID"];
 }
 else if (@$_REQUEST['FORM_ACTION'] == INSERT_ACTION_ITEM) {
 	$action = INSERT_ACTION_ITEM;
 }
 else
   $action = UPDATE_ACTION;

   $x = " class=\"current\" ";

  $smarty->assign('additional_menu3_items',
                  "<li><a href=\"#\" ".($currentL3 == "descA" ? $x : "")."id=\"descA\" onclick=\"setCurrent('descA');  showDiv('descDiv');return false;\"> Description</a></li>
                  <li><a href=\"#\" ".($currentL3 == "itemsA" ? $x : "")."id=\"itemsA\" onclick=\"setCurrent('itemsA');  showDiv('itemsDiv');return false;\">Estimates</a></li>
                  <li><a href=\"#\" id=\"invoiceA\"".($currentL3 == "invoiceA" ? $x : "")." onclick=\"setCurrent('invoiceA');  showDiv('invoiceDiv');return false;\">Invoices</a></li>");

 if ($action == CANCEL_ACTION)
 {
    header("Location: ".$href."&currYear=".$currentYear."&CURRENT_LEVEL3=".$currentL3."&ITEMS_SUPPLIER_ID=".@$_REQUEST['ITEMS_SUPPLIER_ID']);
    exit;
 }


 $isEdit = ($smarty->user->isOwner()
         || $smarty->user->isBookkeeping()
         || $smarty->user->isManagerOwner()
         || $smarty->user->isBuyer()
         || $smarty->user->isBusinessOwner()
         || $smarty->user->isManager());


 if (!$isEdit )
   $form->freeze();

 $expenseList = $dbExpenses->getExpenseList($currentPropertyID, $currentYear);

 if ($action == INSERT_ACTION)
   array_push($expenseList, array("EXPENSE_ID" => -1, "UNIT_NAME"=>"New expense"));

 $is_exists = ( count($expenseList) > 0 );
 if (!$currentExpenseID && $is_exists)
     $currentExpenseID = $expenseList[0]["EXPENSE_ID"];

 $nextID = 0;
 $prevID = 0;
 // Initial data for form
 if ($currentExpenseID)
 {
     if ($action != INSERT_ACTION)
     {
        $i = 0;
        $form_data = array();
        for($i = 0; $i < count($expenseList); $i++)
          if ($expenseList[$i]["EXPENSE_ID"] == $currentExpenseID)
          {
              $form_data = $expenseList[$i];
              if ($i > 0)
                $prevID = $expenseList[$i-1]["EXPENSE_ID"];
              if ($i + 1 < count($expenseList))
                $nextID = $expenseList[$i+1]["EXPENSE_ID"];
              break;
          }
     }
 }

 // correct list for display
 foreach($expenseList as $k=>$v)
 {
   // pass new record
   if ($expenseList[$k]["EXPENSE_ID"] == -1) continue;
   $expenseList[$k]["EVENT_DATE"] =  UtlConvert::dbDateToDisplay($expenseList[$k]["EVENT_DATE"]);
   $expenseList[$k]["RECURRING_YN"] =  '[ '.($expenseList[$k]["RECURRING_YN"] == "Y" ? 'X' : '&nbsp;')." ]";

 }

 $for_choose_expense_form = "<input type='hidden' name='".$menu3->request_property_id."' value='".$menu3->current_property_id."'>".
                            "<input type='hidden' name='".$menu->request_menu_level2."' value='".($menu->current_level2)."'>".
                            "<input type='hidden' name='currYear' value='".$currentYear."'>";

 $for_choose_year_form = "<input type='hidden' name='".$menu3->request_property_id."' value='".$menu3->current_property_id."'>".
                         "<input type='hidden' name='".$menu->request_menu_level2."' value='".($menu->current_level2)."'>";

 $form->registerRule('vdate', 'function', 'validateDate');
 $form->registerRule('vnumeric', 'function', 'validateNumeric');
 $form->registerRule('vinteger', 'function', 'validateInteger');

 // property_id for page menu level 3 - its property
 $form->AddElement("hidden", $menu3->request_property_id, $menu3->current_property_id);
 // menu 2 level
 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
 $form->AddElement("hidden", "CURRENT_LEVEL3", $currentL3, array('id' => 'CURRENT_LEVEL3') );

 $form->AddElement("hidden", "EXPENSE_ID", $currentExpenseID);
 $form->AddElement("hidden", "FORM_ACTION", $action);
 $form->AddElement("hidden", "PROPERTY_ID", $menu3->current_property_id);
 $form->AddElement("hidden", "BUSINESS_ID", $currentBUID);

 $form->AddElement("hidden", "currYear", $currentYear);

 $form->AddElement("hidden", "CHECKSUM");
 $form->AddElement("hidden", "NEXT_DIRECTION_ID", $nextID);
 $form->AddElement("hidden", "PREV_DIRECTION_ID", $prevID);

 $form->AddElement("text", "EVENT_DATE", "Date", array("size" => 11));
 $dates_elements[] = "EVENT_DATE";
 $form->AddElement("select", "UNIT_ID", "Unit", $dbProp->getUnitsList($currentPropertyID, false));
 $form->AddElement("select", "RECURRING_PERIOD", "", $dbExpenses->getPeriodList());
 $form->AddElement("advcheckbox", "RECURRING_YN", "Recurring", "", array("onclick"=>"setEnabledRecurring()"));
 $form->AddElement("text", "RECURRING_ENDDATE", "Recurring Ends", array("size" => 11));
 $dates_elements[] = "RECURRING_ENDDATE";
 $form->AddElement("select", "LOAN_ID", "Loan", $dbExpenses->getLoanList($currentBUID, false));
 
 
 $form->AddElement("textarea", "DESCRIPTION", "Description", array("cols" => $desc_width, "rows" => "5"));

 if (!$IsPost && count(@$form_data) > 0)
 {
      $form_data["EVENT_DATE"] = UtlConvert::dbDateToDisplay($form_data["EVENT_DATE"]);
      $form_data["RECURRING_ENDDATE"] = UtlConvert::dbDateToDisplay($form_data["RECURRING_ENDDATE"]);
      $form_data["RECURRING_YN"] = $form_data["RECURRING_YN"] == "Y" ? 1 : 0;
 }

 // Apply filter for all data cells
 $form->applyFilter('__ALL__', 'trim');

  // Append rule REUIQRED
 $form->addRule('EVENT_DATE', 'Date required.', 'required');
 $form->addRule('DESCRIPTION', 'Description require.', 'required');

 // Append fule for DATE
 $form->addRule("EVENT_DATE", UtlConvert::ErrorDateMsg, 'vdate');
 $form->addRule("RECURRING_ENDDATE", UtlConvert::ErrorDateMsg, 'vdate');

 // ----------- code for items

 $itemsSupplierList     = array();
 $currentItemSupplierID = @$_REQUEST['ITEMS_SUPPLIER_ID'];
 $supplierLovData       = new LovData("supplierLovData", $dbAccounts->getSupplierList($currentBUID));

 if ($action != INSERT_ACTION && $currentExpenseID){
 	$itemsList = array();

 	$itemsSupplierList = $dbAccounts->getSupplierListForItems($currentExpenseID);
 	$f = false;
 	// search current items in list
 	// old code: if (!$currentItemSupplierID && count($itemsSupplierList) > 0 ){
 	if ( ! is_null($currentItemSupplierID) && count($itemsSupplierList) > 0 ){
 		$f = false;
 		foreach($itemsSupplierList as $v)
 			if ($v['SUPPLIER_ID'] == $currentItemSupplierID){
 				$f = true;
 				break;
 			}
 	}
	
 	// old code: if (!$currentItemSupplierID || !$f)
 	if (is_null($currentItemSupplierID) || !$f)
 	   if (count($itemsSupplierList) > 0)
 	      $currentItemSupplierID = $itemsSupplierList[0]['SUPPLIER_ID'];
 	   else
 	      $currentItemSupplierID = 0;

    foreach ($itemsSupplierList as $k=>$v){
    	$itemsSupplierList[$k]["ESTIMATE"] = UtlConvert::dbNumericToDisplay($v["ESTIMATE"]);
    	$itemsSupplierList[$k]["ACTUAL"] =  UtlConvert::dbNumericToDisplay($v["ACTUAL"]);
    	//
    	$itemsSupplierList[$k]["INVOICE"] =  UtlConvert::dbNumericToDisplay($v["INVOICE"]);
    }

 	if ($IsPost)
 	   $itemsList = @$_POST['ITEMS'];
 	else{
       //if ($currentItemSupplierID)
       if ( ! is_null($currentItemSupplierID))
          $itemsList = $dbItems->getExpenseItems($currentExpenseID, $currentItemSupplierID);
       else
          $itemsList = array();
 	}

 	if (!$IsPost && $action == INSERT_ACTION_ITEM){
 		$itemsList[] = array("EXPENSE_ID" => $currentExpenseID, "SUPPLIER_ID" => $currentItemSupplierID);
 	}
 	//print_r($itemsList);
 	$form->addElement('hidden', 'ITEMS_SUPPLIER_ID', $currentItemSupplierID);

 	for($i=0; $i<count($itemsList); $i++){
 		$form->addElement('hidden', "ITEMS[$i][EXPENSE_ID]");
 		//$form->addElement('hidden', "ITEMS[$i][SUPPLIER_ID]");
 		$form->addElement('hidden', "ITEMS[$i][CHECKSUM]");
 		$form->addElement('hidden', "ITEMS[$i][EXPENSE_ITEM_ID]");

 		$form->addElement('text', "ITEMS[$i][ORDER_ROW]", "", array('size' => 2));

 		$form->AddElement("lov", "ITEMS[$i][SUPPLIER_ID]", "", array(),
               array("nameCode"=>"ITEMS[$i][SUPPLIER_ID__CODE]",
                     "imagePath"=>$GLOBALS["PATH_FORM_ROOT"]."images/lov.gif", "sizeCode"=>15), $supplierLovData);

 		$form->addElement('text', "ITEMS[$i][ITEM_NAME]", "", array('size' => 15));
 		$form->addElement('text', "ITEMS[$i][ITEM_COST]", "", array('size' => 8, 'onkeyup'=>"doCalc($i)", 'id'=>"ITEMS[$i][ITEM_COST]"));
 		$form->AddElement("select", "ITEMS[$i][ITEM_UNIT]", "", array( "HR"=>"hour"
 		                                                             , "DY"=>"day"
 		                                                             , "MN"=>"month"
 		                                                             , "EH"=>"each"
 		                                                             , "JB"=>"job"
		                                                             , "FT"=>"sq ft"
																	 , "YD"=>"sq yd"
																	 , "MT"=>"sq m"
																	 , "PT"=>"pint"
																	 , "GN"=>"gallon"
																	 , "LT"=>"liter"
																	 , "LF"=>"lnr ft"
																	 , "LY"=>"lnr yd"
																	 , "LM"=>"lnr m"
																	 , "CF"=>"cu ft"
																	 , "CY"=>"cu yd"
																	 , "CM"=>"cu m"
																	 , "OZ"=>"oz"
																	 , "LB"=>"lb"
																	 , "TN"=>"ton"
																	 , "KG"=>"kg"));
 		$form->addElement('text', "ITEMS[$i][ESTIMATE]", "", array('size' => 7, 'onkeyup'=>"doCalc($i)", 'id' =>"ITEMS[$i][ESTIMATE]"));
        $form->addElement('text', "ITEMS[$i][ESTIMATE_COST]", "", array('size' => 8, 'readonly' =>'readonly', 'id' => "ITEMS[$i][ESTIMATE_COST]", 'class'=>'disabled'));
 		$form->addElement('text', "ITEMS[$i][ACTUAL]", "", array('size' => 7, 'onkeyup'=>"doCalc($i)", 'id'=> "ITEMS[$i][ACTUAL]"));
 		$form->addElement('text', "ITEMS[$i][ACTUAL_COST]", "", array('size' => 8, 'readonly' =>'readonly', 'id' => "ITEMS[$i][ACTUAL_COST]", 'class'=>'disabled'));


 		if (@$itemsList[$i]["EXPENSE_ITEM_ID"] && ($isEdit))
         {
            $form->addElement('link',   "ITEMS[$i][EXPENSE_ITEM_ID_LINK]", "delete",
                          "?".$menu3->getParams()."&".$menu->getParam2().
                           "&action=delete_item&EXPENSE_ITEM_ID=".$itemsList[$i]["EXPENSE_ITEM_ID"].
                           "&EXPENSE_ID=".$currentExpenseID."&CURRENT_LEVEL3=itemsA&ITEMS_SUPPLIER_ID=".$itemsList[$i]['SUPPLIER_ID'], $smarty->deleteImage, $smarty->deleteAttr);

         }

 		// Append rule REUIQRED
        $form->addRule("ITEMS[$i][ITEM_NAME]", 'Require value.', 'required');
        $form->addRule("ITEMS[$i][ITEM_COST]", 'Require value.', 'required');
        // Append rule for NUMBERIC
        $form->addRule("ITEMS[$i][ITEM_COST]", 'Require value.', 'vnumeric');
        $form->addRule("ITEMS[$i][ESTIMATE]", "Must be numeric.", 'vnumeric');
        $form->addRule("ITEMS[$i][ACTUAL]", "Must be numeric.", 'vnumeric');
        $form->addRule("ITEMS[$i][ORDER_ROW]", 'Must be numeric.', 'vnumeric');

        if (@$itemsList[$i]['EXPENSE_ITEM_ID']){
        	$itemsList[$i]['ESTIMATE'] =  UtlConvert::dbNumericToDisplay($itemsList[$i]['ESTIMATE']);
        	$itemsList[$i]['ACTUAL'] =  UtlConvert::dbNumericToDisplay($itemsList[$i]['ACTUAL']);
        	$itemsList[$i]['ITEM_COST'] =  UtlConvert::dbNumericToDisplay($itemsList[$i]['ITEM_COST']);
        	$itemsList[$i]['ESTIMATE_COST'] =  UtlConvert::dbNumericToDisplay($itemsList[$i]['ESTIMATE_COST']);
        	$itemsList[$i]['ACTUAL_COST'] =  UtlConvert::dbNumericToDisplay($itemsList[$i]['ACTUAL_COST']);
        }
 	} // --- for($i=0;...

 	// inital data for form
 	if ($itemsList && is_array($itemsList))
     foreach($itemsList as $k1=>$v1)
       foreach($v1 as $k2=>$v2)
          $form_data["ITEMS[$k1][$k2]"] = $v2;
 }


 /*---------- add submit buttons*/
 $r = array();
 if ($action == INSERT_ACTION || !$currentExpenseID)
   $r["disabled"] = "disabled";
 $r["onclick"] = "return confirm('Delete this expense?')";
 $form->AddElement("submit", "delete", "Delete expense", $r);
 $r = array();
 if ($action == INSERT_ACTION)
   $r["disabled"] = "disabled";
 $form->AddElement("submit", "new", "New expense", $r);

 //new code:
 $r = array();
 if ($action == INSERT_ACTION_ACCOUNT || !$currentItemSupplierID)
   $r["disabled"] = "disabled";
 //old code:
 //if ($action == INSERT_ACTION_ACCOUNT || !$currentExpenseID || !$currentItemSupplierID)
 //  $r["disabled"] = "disabled";


 $r = array();
 if ($action == INSERT_ACTION || $action == INSERT_ACTION_ACCOUNT || !$currentExpenseID)
   $r["disabled"] = "disabled";
 $form->AddElement("submit", "new_item", "New Estimate Item", $r);
 $form->AddElement("submit", "new_account", "New receipt or invoice", $r);

 $r = array();
 if (!$currentExpenseID)
   $r["disabled"] = "disabled";
 $form->AddElement("submit", "accept", "Save", $r);
 $form->AddElement("submit", "cancel", "Cancel", $r);

 $r = array();
 if (!$prevID)
   $r["disabled"] = "disabled";

 $form->AddElement("submit", "prev", "Prev", $r);
 $r = array();
 if (!$nextID)
   $r["disabled"] = "disabled";
 $form->AddElement("submit", "next", "Next", $r);
 $r = array();

 // ----------- code for accounts
 if ($action != INSERT_ACTION)
 {
    $accList = array();
    if ($IsPost)
      $accList = $_POST["ACCOUNTS"];
    else
    {
      $accList = $dbAccounts->getList($currentExpenseID);
      $form_data["ACCOUNTS"] = $accList;
    }

    if (!$IsPost && $action == INSERT_ACTION_ACCOUNT)
      $accList[] = array("EXPENSE_ID"=>$currentExpenseID, "BUSINESS_ID" => $dbProp->getBusinessUnit($currentPropertyID), "PAYMENT_PROPERTY_ID" => $dbExpenses->getPropertyID($currentExpenseID), "RECORD_TYPE" => "E");

    for($i=0; $i < count($accList); $i++)
    {
        $form->addElement("hidden", "ACCOUNTS[$i][AP_ID]");
        $form->addElement("hidden", "ACCOUNTS[$i][EXPENSE_ID]");
        $form->addElement("hidden", "ACCOUNTS[$i][CHECKSUM]");
        $form->addElement("hidden", "ACCOUNTS[$i][BUSINESS_ID]");
        $form->addElement("hidden", "ACCOUNTS[$i][PAYMENT_PROPERTY_ID]");
        $form->addElement("hidden", "ACCOUNTS[$i][RECORD_TYPE]");

        $form->addElement("text", "ACCOUNTS[$i][PAYMENT_DUE_DATE]", "", array("size"=>8));
        $dates_elements[] = "ACCOUNTS[$i][PAYMENT_DUE_DATE]";

        $form->addElement("select", "ACCOUNTS[$i][SUPPLIER_ID]", "", $dbAccounts->getSupplierList($currentBUID), array("style"=>'width:200px'));
        $form->addElement("text", "ACCOUNTS[$i][INVOICE_NUMBER]", "", array("size"=>15));
        $form->addElement("text", "ACCOUNTS[$i][AMOUNT]", "", array("size"=>9));
        $form->addElement("select", "ACCOUNTS[$i][PAYMENT_TYPE_ID]", "", $dbAccounts->getPaymentTypeList());

        if (@$accList[$i]["AP_ID"] && ($isEdit))
        {
            $form->addElement('link',   "ACCOUNTS[$i][AP_ID_LINK]", "delete",
                          "?".$menu3->getParams()."&".$menu->getParam2().
                           "&action=delete_acc&AP_ID=".$accList[$i]["AP_ID"].
                           "&EXPENSE_ID=".$currentExpenseID."&CURRENT_LEVEL3=invoiceA&ITEMS_SUPPLIER_ID=".$currentItemSupplierID, $smarty->deleteImage, $smarty->deleteAttr);

         }
        // Append rule REUIQRED
         $form->addRule("ACCOUNTS[$i][PAYMENT_DUE_DATE]", 'Require value.', 'required');
         $form->addRule("ACCOUNTS[$i][AMOUNT]", 'Require value.', 'required');
         // Append rule for NUMBERIC
         $form->addRule("ACCOUNTS[$i][AMOUNT]", "Must be numeric.", 'vnumeric');

        // correct values
        if (@$accList[$i]["AP_ID"])
        {
             $accList[$i]["AMOUNT"] = UtlConvert::dbNumericToDisplay($accList[$i]["AMOUNT"]);
             $accList[$i]["PAYMENT_DUE_DATE"] = UtlConvert::dbDateToDisplay($accList[$i]["PAYMENT_DUE_DATE"]);
        }

    } // --- for($i=0;...

     // inital data for form
     foreach($accList as $k1=>$v1)
       foreach($v1 as $k2=>$v2)
          $form_data["ACCOUNTS[$k1][$k2]"] = $v2;
 }

 $form->setDefaults(@$form_data);

 if ( ( ($IsPost && $form->validate() && $IsSave) || $action == DELETE_ACTION_ITEM || $action == DELETE_ACTION  || $action == DELETE_ACTION_ACCOUNT) && ($isEdit)) {

    // save form to database
    $values = $form->getSubmitValues();
    $newID = -1;
    $IsError = 0;
    try
    {
        if ($action == INSERT_ACTION)
           $newID = $dbExpenses->Insert($values);
        else if ($action == UPDATE_ACTION || $action == INSERT_ACTION_ACCOUNT)
        {
           $dbAccounts->checkChecksumUpdates($values);
           $dbExpenses->Update($values);
           $dbAccounts->Updates($values);
           if (($dbItemsInsSupplID = $dbItems->Updates($values))!= 0 )
              $currentItemSupplierID = $dbItemsInsSupplID;
        }
        else if ($action == DELETE_ACTION_ITEM)
           $dbItems->Delete($deleteExpenseItemID);
        else if ($action == DELETE_ACTION)
           $dbExpenses->Delete($values);
        else if ($action == DELETE_ACTION_ACCOUNT)
           $dbAccounts->Delete($deleteApID);
        else if ($action == INSERT_ACTION_ITEM){
            if (($dbItemsInsSupplID = $dbItems->Updates($values))!= 0 )
              $currentItemSupplierID = $dbItemsInsSupplID;
        }
        else
           throw new Exception('Unknown operation');

        $smarty->connection->commit();
    }
    catch(SQLException $e)
    {
          $IsError = 1;
          $smarty->connection->rollback();
          $de =  new DatabaseError($smarty->connection);
          $smarty->assign("errorObj", $de->getErrorFromException($e));
    }
    // change for new year
    $currentYear= @getYearFromDisplayDate(@$values["EVENT_DATE"]);
    // redirect to page
    if (!$IsError)
    {
       if ($action == INSERT_ACTION)
           $currentExpenseID = $newID;

       // define next
       if ($action == DELETE_ACTION)
       {
          if ($nextID)
              $currentExpenseID = $nextID;
          else
          if ($prevID)
              $currentExpenseID = $prevID;
          else
              $currentExpenseID = "";
       }

       $href = $GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&".$menu3->getParams()."&EXPENSE_ID=".$currentExpenseID."&currYear=".$currentYear."&CURRENT_LEVEL3=".$currentL3."&ITEMS_SUPPLIER_ID=".$currentItemSupplierID;

        if (@$_REQUEST["new_item"]){
            header("Location: ".$href."&FORM_ACTION=INSERT_ITEM&currYear=".$currentYear."&CURRENT_LEVEL3=itemsA&ITEMS_SUPPLIER_ID=".@$_REQUEST['ITEMS_SUPPLIER_ID']);
            exit;
        }

       header("Location: ".$href);
       exit;
    }
 }

 $property_data = $dbProp->getProperty($menu3->current_property_id);
 if (@$property_data["PROP_ADDRESS1"])
    $header_title = @$property_data["PROP_ADDRESS1"]." - Expense & Maintenance";
 else
    $header_title = "";
 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 // is owner we not display calendar buttons
 if (!$isEdit)
    $dates_elements = array();

 $smarty->assign("dates", $dates_elements);
 // send form data to Smarty
 $smarty->assign('action', $action);
 $smarty->assign('form_data', $renderer->toArray());

 $smarty->assign("expenseList", $expenseList);
 $smarty->assign('is_exists', $is_exists);
 if ($action == INSERT_ACTION)
 {
   $currentExpenseID = -1;
 }
 $smarty->assign("currentExpenseID", $currentExpenseID);
 $smarty->assign("currentBUID", $currentBUID);
 $smarty->assign('for_choose_expense_form', $for_choose_expense_form);
 $smarty->assign('for_choose_year_form', $for_choose_year_form);
 $smarty->assign("header_title", $header_title);
 $smarty->assign("currentYear", $currentYear);
 $smarty->assign("isEdit", ($isEdit) ? "true" : "false");
 $smarty->assign("yearList", $yearList);

 // ---- items
 if ($action != INSERT_ACTION) {
	 $smarty->assign('currentItemSupplierID', @$currentItemSupplierID);
	 $smarty->assign('itemsSupplierList', @$itemsSupplierList);
	 $smarty->assign("script", $supplierLovData->display());
 }
?>
