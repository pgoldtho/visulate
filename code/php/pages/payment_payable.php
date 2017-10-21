<?
 require_once dirname(__FILE__)."/../classes/database/rnt_payment_rules.class.php";

 require_once dirname(__FILE__)."/../classes/database/rnt_acc_payable.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_acc_receivable.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once dirname(__FILE__)."/../classes/Context.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

 $mobile_device = Context::getMobileDevice();
 if ($mobile_device)
  {   
	 $template_name = "mobile-payable.tpl";
  }


 if (! ( $smarty->user->isOwner()
      || $smarty->user->isManager()
			|| $smarty->user->isManagerOwner()
			|| $smarty->user->isBookkeeping()
			|| $smarty->user->isBuyer()
			|| $smarty->user->isBusinessOwner()))
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
    exit;
 }

 $isEdit = ($smarty->user->isManager()
         || $smarty->user->isManagerOwner()
         || $smarty->user->isBuyer()
		 || $smarty->user->isBookkeeping());


 if (!defined("ACC_PAYABLE"))
 {
    define("ACC_PAYABLE", "1");
    define("INSERT_OTHER_PAYMENT", "INSERT_OTHER_PAYMENT");
    define("DELETE_OTHER_PAYMENT", "DELETE_OTHER");
    define("DELETE_PAYMENT", "DELETE_PAYMENT");
    define("CANCEL_ACTION", "CANCEL");
    define("UPDATE_PAYABLE", "UPDATE_PAYABLE");
    define("UPDATE_PAYABLE_LIST", "UPDATE_PAYABLE_LIST");
 }

 $currentL3 = @$_REQUEST['CURRENT_LEVEL3'];
 if (!$currentL3){
 	// TODO  set menu 3 depend from submit button
 	$currentL3 = "sched";
 }

 $x = " class=\"current\" ";

 $smarty->assign('additional_menu3_items',
                 "<li><a href=\"#\" ".($currentL3 == "sched" ? $x : "")."id=\"sched\" onclick=\"setCurrent('sched');  showDiv('schedDiv');return false;\"> Scheduled</a></li>
                  <li><a href=\"#\" ".($currentL3 == "unsched" ? $x : "")."id=\"unsched\" onclick=\"setCurrent('unsched');  showDiv('unschedDiv');return false;\">Unscheduled</a></li>");


 $dbBU = new RNTBusinessUnit($smarty->connection);
 $buList = $dbBU->getBusinessUnits();
 $currentBUID = @$_REQUEST["BUSINESS_ID"];

 if ($currentBUID == null)
   $currentBUID = Context::getBusinessID();
 else
   Context::setBusinessID($currentBUID);

 if (!$currentBUID)
   $currentBUID = @$buList[0]["BUSINESS_ID"];

 if ($currentBUID)
    $smarty->user->verifyBUAccess($currentBUID);

 $dbAccPayment = new RNTAccountPayable($smarty->connection);
 $dbAccReceiv = new  RNTAccountReceiveable($smarty->connection);

 $form = new HTML_QuickForm('formPay', 'POST');

 if (!$isEdit)
   $form->freeze();

 $currYearMonth = @$_REQUEST['YEAR_MONTH_HIDDEN'];
 $monthList = $dbAccPayment->getMonthList($currentBUID);
 $href = $GLOBALS["PATH_FORM_ROOT"].
       "?".$menu->getParam2().
       "&BUSINESS_ID=".$currentBUID.
       "&CURRENT_LEVEL3=".$currentL3;

 $lmonths = array();
 $nextMonth = false;
 $prevMonth = false;
 foreach($monthList as $k=>$v)
    $lmonths[] = array($k, $v);

 if (!$currYearMonth)
   $currYearMonth = @$lmonths[0][0];

 for($i=0; $i < count($lmonths); $i++)
   if ($lmonths[$i][0] == $currYearMonth)
   {
      if ($i > 0 )
         $nextMonth = array($lmonths[$i-1][0], $lmonths[$i-1][1]);
      if ($i + 1 < count($lmonths))
         $prevMonth = array($lmonths[$i+1][0], $lmonths[$i+1][1]);
   }

 if ($nextMonth)
   $form->addElement("link", "NEXT_YEAR_LINK", "",
                $href."&YEAR_MONTH_HIDDEN=".$nextMonth[0],
                ">>".$nextMonth[1]);

 if ($prevMonth)
   $form->addElement("link", "PREV_YEAR_LINK", "",
                $href."&YEAR_MONTH_HIDDEN=".$prevMonth[0],
                $prevMonth[1]."<<");

 $href .= "&YEAR_MONTH_HIDDEN=".$currYearMonth;
 if (count($monthList) > 0)
    $form->addElement("select", "YEAR_MONTH", "Month", $monthList, array("onchange"=>"javascript:formPay.YEAR_MONTH_HIDDEN.value=this.value; formPay.submit();"));

 $form_data['YEAR_MONTH'] = $currYearMonth;
 $form->addElement("hidden", "YEAR_MONTH_HIDDEN", $currYearMonth);

 $IsPost = $form->isSubmitted();
 $dates_elements = array();

 $action = @$_REQUEST["FORM_ACTION"];

 if (@$_POST["generateList"])
    $action = UPDATE_PAYABLE_LIST;

 if ($action == UPDATE_PAYABLE_LIST)
 {
            // update due list
           $IsError = 0;
           do{

                   $date_of_generation = @$_REQUEST["UPDATE_LIST_DATE"];

                   if (!$date_of_generation){
                      $form->setElementError("UPDATE_LIST_DATE", "Update date required.");
                      break;
                   }

                   if (!UtlConvert::validateDisplayDate($date_of_generation)){
                      $form->setElementError("UPDATE_LIST_DATE", UtlConvert::ErrorDateMsg);
                      break;
                   }

                   try{
                     $dbAccPayment->generatePayableList($currentBUID, $date_of_generation);
                   }
                   catch(SQLException $e)
                   {
                      $IsError = 1;
                      $smarty->connection->rollback();
                      $de =  new DatabaseError($smarty->connection);
                      $smarty->assign("errorObj", $de->getErrorFromException($e));
                   }
                   if (!$IsError)
                   {
                      header("Location: ".$href."&msgSuccess=Was generated list&UPDATE_LIST_DATE=".$_POST["UPDATE_LIST_DATE"]);
                      exit;
                   }
            } while(false);
 }

 // --- delete uallocated payment action
 if ($action == DELETE_PAYMENT){
           $IsError = 0;
           do{

                   try{
                     $dbAccPayment->Delete($_REQUEST["AP_ID"]);
                   }
                   catch(SQLException $e)
                   {
                      $IsError = 1;
                      $smarty->connection->rollback();
                      $de =  new DatabaseError($smarty->connection);
                      $smarty->assign("errorObj", $de->getErrorFromException($e));
                   }
                   if (!$IsError)
                   {
                      header("Location: ".$href);
                      exit;
                   }
            } while(false);
 }

 if (@$_REQUEST["cancel"]) {
       header("Location: ".$href);
       exit;
 }

 $summary = $dbAccPayment->getSum($currYearMonth, $currentBUID);
 foreach($summary as $k=>$v)
   $summary[$k] = UtlConvert::dbNumericToDisplay($summary[$k]);


 // delete other payment
 if ($action == DELETE_OTHER_PAYMENT && ($isEdit) )
 {
    $apID = $_REQUEST["AP_ID"];
    $IsError = 0;
    try
    {
        $dbAccPayment->OtherDelete($apID);
        $smarty->connection->commit();
    }
    catch(SQLException $e)
    {
          $IsError = 1;
          $smarty->connection->rollback();
          $de =  new DatabaseError($smarty->connection);
          $smarty->assign("errorObj", $de->getErrorFromException($e));
    }

    // redirect to page
    if (!$IsError)
    {
       header("Location: ".$href);
       exit;
    }
 }


 if (@$action == "createOtherPayment")
   $action = INSERT_OTHER_PAYMENT;
 else
   $action = UPDATE_PAYABLE;

 $IsSave = @$_REQUEST["save"];

 $form->registerRule('vdate', 'function', 'validateDate');
 $form->registerRule('vnumeric', 'function', 'validateNumeric');
 $form->registerRule('vinteger', 'function', 'validateInteger');

 // property_id for page menu level 3 - its property
 $form->AddElement("hidden", $menu3->request_property_id, $menu3->current_property_id);
 // menu 2 level
 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
 $form->AddElement("hidden", "BUSINESS_ID", $currentBUID);
 $form->AddElement("hidden", "FORM_ACTION", "");
 // additional menu 3 level
 $form->AddElement("hidden", "CURRENT_LEVEL3", $currentL3, array('id' => 'CURRENT_LEVEL3') );

 $form->addElement("submit", "save", "Save");
 $form->addElement("submit", "cancel", "Cancel");


 // --- PAYMENTS account ----------------------------------------------------------------

 if ($IsPost)
 {
    $payList = @$_POST["PAYMENTS"];
    if ($payList) {

        foreach($payList as &$v1)
        {
           $x = $dbAccPayment->getPaymentByIDExpense($v1["AP_ID"]);
           $v1["PROPERTY_SUPPLIER_NAME"] = $x["PROPERTY_SUPPLIER_NAME"];
           $v1["VPAYMENT_DUE_DATE"] = $v1["PAYMENT_DUE_DATE"];
        }
        unset($v1);
    }
 }
 else
 {
   $payList = $dbAccPayment->getPaymentList($currentBUID, $currYearMonth);

   foreach($payList as &$v1){
       $v1["PAYMENT_DUE_DATE"] = UtlConvert::dbDateToDisplay($v1["PAYMENT_DUE_DATE"]);
       $v1["VPAYMENT_DUE_DATE"] = $v1["PAYMENT_DUE_DATE"];
       $v1["PAYMENT_DATE"] = UtlConvert::dbDateToDisplay($v1["PAYMENT_DATE"]);
       $v1["AMOUNT"] = UtlConvert::dbNumericToDisplay($v1["AMOUNT"]);
       //
       $pt_accs = $dbAccReceiv->getPtAccounts($currentBUID, $v1["PAYMENT_TYPE_ID"]);
       $v1["DEBIT_ACCOUNT"]  = empty($v1["DEBIT_ACCOUNT"])
                             ? $pt_accs["APS"]["DEBIT_ACCOUNT"]
                             : $v1["DEBIT_ACCOUNT"];
       $v1["CREDIT_ACCOUNT"] = empty($v1["CREDIT_ACCOUNT"])
                             ? $pt_accs["APP"]["CREDIT_ACCOUNT"]
                             : $v1["CREDIT_ACCOUNT"];
   }
   unset($v1);
 }


 $dbPTRules  = new RNTPaymentRules($smarty->connection);
 $buAccounts = $dbPTRules->getPaymentAccountsList($currentBUID);
 //
 for($i=0; $i < count($payList); $i++)
 {
    $form->addElement("hidden", "PAYMENTS[$i][AP_ID]");
    $form->addElement("hidden", "PAYMENTS[$i][BUSINESS_ID]");
    $form->addElement("hidden", "PAYMENTS[$i][CHECKSUM]");
    $form->addElement("hidden", "PAYMENTS[$i][RECORD_TYPE]");
    $form->addElement("hidden", "PAYMENTS[$i][INVOICE_NUMBER]");

    $form->addElement("text", "PAYMENTS[$i][VPAYMENT_DUE_DATE]", "", array("size" => 8, "disabled" => "disabled"));
    $form->addElement("hidden", "PAYMENTS[$i][PAYMENT_DUE_DATE]");
    $form->addElement("hidden", "PAYMENTS[$i][PAYMENT_TYPE_ID]");
    $form->addElement("hidden", "PAYMENTS[$i][EXPENSE_ID]");
    $form->addElement("hidden", "PAYMENTS[$i][PROPERTY_ID]");
    $form->addElement("hidden", "PAYMENTS[$i][PAYMENT_PROPERTY_ID]");
    $form->addElement("hidden", "PAYMENTS[$i][SUPPLIER_ID]");
    $form->addElement("hidden", "PAYMENTS[$i][LOAN_ID]");
    $form->addElement("hidden", "PAYMENTS[$i][BUSINESS_ID]");

    $form->addElement("text", "PAYMENTS[$i][AMOUNT]", "", array("size"=>8));

    $form->addElement("text", "PAYMENTS[$i][PAYMENT_TYPE_NAME]", "", array("size"=>12, "disabled"=>"disabled"));

    $form->addElement("text", "PAYMENTS[$i][PAYMENT_DATE]", "", array("size"=>8));
    $dates_elements[] = "PAYMENTS[$i][PAYMENT_DATE]";

    $form->addElement('link', "PAYMENTS[$i][FOR]", "for",
                          "?m2=property_expense&currYear=".substr($currYearMonth, 0, 4).
                          "&prop_id=".$payList[$i]["PROPERTY_ID"]."&EXPENSE_ID=".$payList[$i]["EXPENSE_ID"],
                           $payList[$i]["PROPERTY_SUPPLIER_NAME"]);
    $sysDate = date("m/d/Y");
    if ($isEdit) {
            if (!@$payList[$i]["PAYMENT_DATE"]) {
               $form->addElement("button", "PAYMENTS[$i][BUTTON]", "Paid", array("onclick"=>"javascript: Paid($i, this, '$sysDate')"));
               // link for delete
               $form->addElement('link',   "PAYMENTS[$i][DELETE_LINK_AP_ID]", "delete",
                              "?".$menu3->getParams()."&".$menu->getParam2()."&FORM_ACTION=".DELETE_PAYMENT."&AP_ID=".$payList[$i]["AP_ID"]."&YEAR_MONTH_HIDDEN=".$currYearMonth."&BUSINESS_ID=".$currentBUID,
                              $smarty->deleteImage,$smarty->deleteAttr);
            }
            else
               $form->addElement("button", "PAYMENTS[$i][BUTTON]", "Clear", array("onclick"=>"javascript: Paid($i, this, '$sysDate')"));
    }

    $form->addElement(
        "select",
        "PAYMENTS[$i][DEBIT_ACCOUNT]",
        "Debit Account",
        $buAccounts,
        array("id" => "PAYMENTS[$i][DEBIT_ACCOUNT]",
              "style" => "width:150px;")
    );
    $form->addElement(
        "select",
        "PAYMENTS[$i][CREDIT_ACCOUNT]",
        "Credit Account",
        $buAccounts,
        array("id" => "PAYMENTS[$i][CREDIT_ACCOUNT]",
              "style" => "width:150px;")
    );

    /*
    if  (@$payList[$i]["AP_ID"])
           $form->addElement('link', "PAYMENTS[$i][LINK_DELETE]", "delete",
                          "?".$menu->getParam2()."&BUSINESS_ID=".$currentBUID.
                           "&FORM_ACTION=DELETE&AP_ID=".$payList[$i]["AP_ID"]."&YEAR_MONTH_HIDDEN=".$currYearMonth,
                           $smarty->deleteImage, array("onclick"=>"return confirm('Delete record?');"));
    */

    // append rules
    $form->addRule("PAYMENTS[$i][AMOUNT]", "required", 'required');
    $form->addRule("PAYMENTS[$i][AMOUNT]", "Amount must be numeric", 'vnumeric');
    $form->addRule("PAYMENTS[$i][PAYMENT_DATE]",  UtlConvert::ErrorDateMsg, 'vdate');
 }

 if (@$payList)
 {
     foreach($payList as $k1=>$v1)
       foreach($v1 as $k2=>$v2)
           $form_data["PAYMENTS[$k1][$k2]"] = $v2;
 }


 // --- OTHER PAYMENTS account ----------------------------------------------------------------

 if ($IsPost)
    $otherAccList = @$_POST["OTHER_PAYMENTS"];
 else
 {
   $otherAccList = $dbAccPayment->getListProp($currentBUID, $currYearMonth);
   foreach($otherAccList as &$v1){
       $v1["PAYMENT_DUE_DATE"] = UtlConvert::dbDateToDisplay($v1["PAYMENT_DUE_DATE"]);
       $v1["PAYMENT_DATE"] = UtlConvert::dbDateToDisplay($v1["PAYMENT_DATE"]);
       $v1["AMOUNT"] = UtlConvert::dbNumericToDisplay($v1["AMOUNT"]);
       //
       $pt_accs = $dbAccReceiv->getPtAccounts($currentBUID, $v1["PAYMENT_TYPE_ID"]);
       $v1["DEBIT_ACCOUNT"]  = empty($v1["DEBIT_ACCOUNT"])
                             ? $pt_accs["APS"]["DEBIT_ACCOUNT"]
                             : $v1["DEBIT_ACCOUNT"];
       $v1["CREDIT_ACCOUNT"] = empty($v1["CREDIT_ACCOUNT"])
                             ? $pt_accs["APP"]["CREDIT_ACCOUNT"]
                             : $v1["CREDIT_ACCOUNT"];
   }
   unset($v1);
 }

 if (!$IsPost && $action == INSERT_OTHER_PAYMENT) {
     $pt = key($dbAccPayment->getPaymentTypeList());
     $pt_accs = $dbAccReceiv->getPtAccounts($currentBUID, $pt);

     $otherAccList[] = array(
         "BUSINESS_ID"=>$currentBUID,
         "DEBIT_ACCOUNT"  => $pt_accs["APS"]["DEBIT_ACCOUNT"],
         "CREDIT_ACCOUNT" => $pt_accs["APP"]["CREDIT_ACCOUNT"]
     );
 }


 // for debit/credit values updated automatically when the user changes the payment type
    $ptAccountsList = $dbAccPayment->getPtAccountsList($currentBUID);
    $smarty->assign("ptAccountsList", json_encode($ptAccountsList));

 for($i=0; $i < count($otherAccList); $i++)
 {
    $form->addElement("hidden", "OTHER_PAYMENTS[$i][AP_ID]");
    $form->addElement("hidden", "OTHER_PAYMENTS[$i][BUSINESS_ID]");
    $form->addElement("hidden", "OTHER_PAYMENTS[$i][CHECKSUM]");
    $form->addElement("hidden", "OTHER_PAYMENTS[$i][LOAN_ID]");
    $form->addElement("hidden", "OTHER_PAYMENTS[$i][EXPENSE_ID]");
     $form->addElement("hidden", "OTHER_PAYMENTS[$i][INVOICE_NUMBER]");

    $form->addElement("text", "OTHER_PAYMENTS[$i][PAYMENT_DUE_DATE]", "", array("size" => 8));
    $dates_elements[] = "OTHER_PAYMENTS[$i][PAYMENT_DUE_DATE]";
    $form->addElement("text", "OTHER_PAYMENTS[$i][AMOUNT]", "", array("size"=>8));

    $form->addElement("select",
                      "OTHER_PAYMENTS[$i][PAYMENT_PROPERTY_ID]",
                      "",
                      $dbAccReceiv->getPropListWithNull($currentBUID),
                      array("style" => "width:100px;"));

    $form->addElement("select",
                      "OTHER_PAYMENTS[$i][PAYMENT_TYPE_ID]",
                      "",
                      $dbAccPayment->getPaymentTypeList(),
                      array("onchange" => "setDefaultAccounts($i, this);",
                            "style" => "width:100px;")
    );

    $form->addElement("select", "OTHER_PAYMENTS[$i][SUPPLIER_ID]", "", $dbAccPayment->getSupplierList($currentBUID));
//    $supplierLovData = new LovData("supplierLovData", $dbAccPayment->getSupplierList($currentBUID));
//    $form->AddElement("lov", "OTHER_PAYMENTS[$i][SUPPLIER_ID]", "Supplier Name", array(),
//               array("nameCode"=>"OTHER_PAYMENTS[$i][SUPPLIER_ID__CODE]",
//                     "imagePath"=>$GLOBALS["PATH_FORM_ROOT"]."images/lov.gif", "sizeCode"=>20), $supplierLovData);



    $form->addElement("text", "OTHER_PAYMENTS[$i][PAYMENT_DATE]", "", array("size"=>8));
    $dates_elements[] = "OTHER_PAYMENTS[$i][PAYMENT_DATE]";

    $form->addElement(
        "select",
        "OTHER_PAYMENTS[$i][DEBIT_ACCOUNT]",
        "Debit Account",
        $buAccounts,
        array("id" => "OTHER_PAYMENTS[$i][DEBIT_ACCOUNT]",
              "style" => "width:100px;")
    );
    $form->addElement(
        "select",
        "OTHER_PAYMENTS[$i][CREDIT_ACCOUNT]",
        "Credit Account",
        $buAccounts,
        array("id" => "OTHER_PAYMENTS[$i][CREDIT_ACCOUNT]",
              "style" => "width:100px;")
    );


    $form->addRule("OTHER_PAYMENTS[$i][AMOUNT]", "required", 'required');
    $form->addRule("OTHER_PAYMENTS[$i][AMOUNT]", "Amount must be numeric", 'vnumeric');
    $form->addRule("OTHER_PAYMENTS[$i][PAYMENT_DUE_DATE]", "required", 'required');
    $form->addRule("OTHER_PAYMENTS[$i][PAYMENT_DUE_DATE]",  UtlConvert::ErrorDateMsg, 'vdate');
    $form->addRule("OTHER_PAYMENTS[$i][PAYMENT_DATE]",  UtlConvert::ErrorDateMsg, 'vdate');

    if  (@$otherAccList[$i]["AP_ID"])
           $form->addElement('link', "OTHER_PAYMENTS[$i][LINK_DELETE]", "delete",
                          "?".$menu->getParam2()."&BUSINESS_ID=".$currentBUID.
                           "&FORM_ACTION=DELETE_OTHER&AP_ID=".$otherAccList[$i]["AP_ID"]."&YEAR_MONTH_HIDDEN=".$currYearMonth,
                           $smarty->deleteImage, array("onclick"=>"return confirm('Delete record?');"));
 }
 if ($otherAccList)
 {
     foreach($otherAccList as $k1=>$v1)
       foreach($v1 as $k2=>$v2)
           $form_data["OTHER_PAYMENTS[$k1][$k2]"] = $v2;
 }

 // append for update list
 if ($isEdit){
 	$form->addElement("text", "UPDATE_LIST_DATE", "", array("size"=> 9));
 	$dates_elements[] = "UPDATE_LIST_DATE";

 	if (!@$_REQUEST["UPDATE_LIST_DATE"])
 	   $form_data["UPDATE_LIST_DATE"] = date("m/d/Y");
 	else
 	   $form_data["UPDATE_LIST_DATE"] = @$_REQUEST["UPDATE_LIST_DATE"];

 }


 // Apply filter for all data cells
 $form->applyFilter('__ALL__', 'trim');
 $form->setDefaults(@$form_data);


 if ($IsPost && $form->validate() && $action == UPDATE_PAYABLE && ($isEdit))
 {
     $IsError = 0;
     $values = $form->getSubmitValues();

     try
     {
        if ($action == UPDATE_PAYABLE)
        {
           // update amount
           if (@$values["PAYMENTS"])
           {
               foreach($values["PAYMENTS"] as $v)
                    $dbAccPayment->Update($v);
           }

           // update other list
           if(@$values["OTHER_PAYMENTS"]) {
               $dbAccPayment->OtherUpdates($values["OTHER_PAYMENTS"]);
           }
        } //  --- if ($action == UPDATE_PAYABLE)

        $smarty->connection->commit();
     }
     catch(SQLException $e)
     {
        $IsError = 1;
        $smarty->connection->rollback();
        $de =  new DatabaseError($smarty->connection);
        $smarty->assign("errorObj", $de->getErrorFromException($e));
     }

     if (!$IsError)
     {
        header("Location: ".$href);
        exit;

     }
 }

 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 $smarty->assign("dates", $dates_elements);
 // send form data to Smarty
 $smarty->assign('action', $action);
 $smarty->assign('form_data', $renderer->toArray());
 $buInfo =  $dbBU->getBusinessUnit($currentBUID);
 $smarty->assign("header_title", $buInfo["BUSINESS_NAME"]." Payables");
 $smarty->assign("currYearMonth", $currYearMonth);
 $smarty->assign("businessList", $buList);
 $smarty->assign("businessID", $currentBUID);
 $smarty->assign("summary", $summary);
 $smarty->assign("isEdit", $isEdit ? "true" : "false");
 $msgSuccess = @$_REQUEST["msgSuccess"];
 $smarty->assign("msgSuccess", $msgSuccess);
 if (@$supplierLovData)
    $smarty->assign("script", $supplierLovData->display());

?>