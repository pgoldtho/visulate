<?
 require_once dirname(__FILE__)."/../classes/database/rnt_payment_rules.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_journal.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_acc_payable.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_acc_receivable.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once dirname(__FILE__)."/../classes/Context.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

// Display journal form for users with the following roles
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

// $isEdit users have update privileges all othere users get read only access
 $isEdit = ($smarty->user->isManager() 
         || $smarty->user->isManagerOwner() 
         || $smarty->user->isBuyer()
		     || $smarty->user->isBookkeeping());

 
 
 if (!defined("PROPERTY_PAYMENTS"))
 {
    define("PROPERTY_PAYMENTS", "1");
    define("INSERT_OTHER_PAYMENT", "INSERT_OTHER_PAYMENT");
    define("DELETE_OTHER_PAYMENT", "DELETE_OTHER_PAYMENT");
    define("UPDATE_OTHER_PAYMENT", "UPDATE_OTHER_PAYMENT");
    define("CANCEL_ACTION", "CANCEL");
    define("UPDATE_LIST_ACTION", "UPDATE_LIST_ACTION");
 }

 
//Select and validate access rights for business units. 
 $dbBU        = new RNTBusinessUnit($smarty->connection);
 $buList      = $dbBU->getBusinessUnits();
 $currentBUID = @$_REQUEST["BUSINESS_ID"];
 $msgSuccess  = @$_REQUEST["msgSuccess"];
 
 if ($currentBUID == null)
   $currentBUID = Context::getBusinessID();
 else
   Context::setBusinessID($currentBUID);

 if (!$currentBUID)
   $currentBUID = @$buList[0]["BUSINESS_ID"];

 if ($currentBUID)
    $smarty->user->verifyBUAccess($currentBUID);
    
    
//Intantiate Journal object
 $dbJournal    = new RNTJournal($smarty->connection);
 $dbAccPayment = new RNTAccountPayable($smarty->connection);
 $dbAccReceiv  = new RNTAccountReceiveable($smarty->connection);
 $dbPTRules    = new RNTPaymentRules($smarty->connection);
 $ptAccounts   = $dbPTRules->getPaymentAccountsList($currentBUID);

 
 $form      = new HTML_QuickForm('formJournal', 'POST');

 if (!$isEdit)
   $form->freeze();

// Get Month list for LOV
 $currYearMonth = @$_REQUEST['YEAR_MONTH_HIDDEN'];
 $monthList     = $dbJournal->getMonthList($currentBUID);
 $href = $GLOBALS["PATH_FORM_ROOT"].
         "?".$menu->getParam2().
         "&BUSINESS_ID=".$currentBUID;

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
    $form->addElement("select", "YEAR_MONTH", "Month", $monthList, 
		     array("onchange"=>"javascript:formJournal.YEAR_MONTH_HIDDEN.value=this.value; formJournal.submit();"));

 $form_data['YEAR_MONTH'] = $currYearMonth;
 $form->addElement("hidden", "YEAR_MONTH_HIDDEN", $currYearMonth);



 $IsPost = $form->isSubmitted();
 $dates_elements = array();

 $action = @$_REQUEST["FORM_ACTION"];

 if (@$_REQUEST["cancel"]) {
       header("Location: ".$href);
       exit;
 }

 if (@$_REQUEST["generateList"])
    $action = UPDATE_LIST_ACTION;

 if (@$_REQUEST["deleteList"])
    $action = DELETE_LIST_ACTION;


 if ($action == "createOtherPayment")
 {
       header("Location: ".$href."&FORM_ACTION=INSERT_OTHER_PAYMENT#bottomOther");
       exit;
 }
 else if ($action == UPDATE_LIST_ACTION)
 {
     // update due list
     $IsError = 0;
     do {
         $date_of_generation = @$_REQUEST["UPDATE_LIST_DATE"];
         
         if (!$date_of_generation) {
             $form->setElementError("UPDATE_LIST_DATE", "Update date required.");
             break;
         }
         
         if (!UtlConvert::validateDisplayDate($date_of_generation)) {
             $form->setElementError("UPDATE_LIST_DATE", UtlConvert::ErrorDateMsg);
             break;
         }
         
         try {
             $dbJournal->generateContraEntries($currentBUID, $date_of_generation);
         }
         catch (SQLException $e) {
             print $e;
             
             $IsError = 1;
             $smarty->connection->rollback();
             $de =  new DatabaseError($smarty->connection);
             $smarty->assign("errorObj", $de->getErrorFromException($e));
         }
         
         if (!$IsError) {
             header("Location: ".$href."&msgSuccess=Contra Entries generated to $date_of_generation");
             exit;
         }
     } while(false);
 }
 else if ($action == INSERT_OTHER_PAYMENT)
 {
     //
 }
 else if ($action == DELETE_OTHER_PAYMENT)
 {
     $paymentID = $_REQUEST["PAYMENT_ID"];
     $IsError = 0;
     try
     {
         $dbJournal->deletePayment($paymentID);

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
 else
 {
     $action = UPDATE_OTHER_PAYMENT;
 }


 $IsSave = @$_REQUEST["save"];
 
 if ($isEdit){
    $form->addElement("submit", "save", "Save");
    $form->addElement("submit", "cancel", "Cancel");
 }

 $form->registerRule('vdate', 'function', 'validateDate');
 $form->registerRule('vnumeric', 'function', 'validateNumeric');
 $form->registerRule('vinteger', 'function', 'validateInteger');

 // property_id for page menu level 3 - its property
 $form->AddElement("hidden", $menu3->request_property_id, $menu3->current_property_id);
 // menu 2 level
 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
 $form->AddElement("hidden", "BUSINESS_ID", $currentBUID);
 $form->AddElement("hidden", "FORM_ACTION", "");
 
 $form->addElement("text", "UPDATE_LIST_DATE", "", array("size"=>8));
 $dates_elements[] = "UPDATE_LIST_DATE";
 
 if (!@$_REQUEST["UPDATE_LIST_DATE"]) {
   $form_data["UPDATE_LIST_DATE"] = date("m/d/Y");
 }

 if ($currYearMonth){
     $date = substr($currYearMonth, 4)."/01/".substr($currYearMonth, 0, 4);
 }


 if ($IsPost)
     $contraList = @$_POST["OTHER_PAYMENTS"];
 else
 {
     $contraList = $dbJournal->getList($currentBUID, $currYearMonth);
     foreach($contraList as &$v1)
     {
         $v1["PAYMENT_DATE"] = UtlConvert::dbDateToDisplay($v1["PAYMENT_DATE"]);
         $v1["AMOUNT"] = UtlConvert::dbNumericToDisplay($v1["AMOUNT"]);
       
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
     
     $contraList[] = array(
         "BUSINESS_ID"=>$currentBUID,
         "DEBIT_ACCOUNT"  => $pt_accs["APS"]["DEBIT_ACCOUNT"],
         "CREDIT_ACCOUNT" => $pt_accs["APP"]["CREDIT_ACCOUNT"]
     );
 }

 for($i=0; $i < count($contraList); $i++)
 {
    $form->addElement("hidden", "OTHER_PAYMENTS[$i][PAYMENT_ID]");
    $form->addElement("hidden", "OTHER_PAYMENTS[$i][BUSINESS_ID]");

    $form->addElement("text", "OTHER_PAYMENTS[$i][PAYMENT_DATE]", "", array("size" => 8));
    $dates_elements[] = "OTHER_PAYMENTS[$i][PAYMENT_DATE]";

    $form->addElement("text", "OTHER_PAYMENTS[$i][AMOUNT]", "", array("size"=>8));
    $form->addElement("text", "OTHER_PAYMENTS[$i][DESCRIPTION]", "", array("size" => 30));
    
    $form->addElement("select",
                      "OTHER_PAYMENTS[$i][PROPERTY_ID]",
                      "",
                      $dbAccReceiv->getPropListWithNull($currentBUID),
                      array("style" => "width:170px;")
    );
    $form->addElement("select",
                      "OTHER_PAYMENTS[$i][DEBIT_ACCOUNT]",
                      "Debit Account",
                      $ptAccounts,
                      array("id" => "OTHER_PAYMENTS[$i][DEBIT_ACCOUNT]",
                            "style" => "width:300px;")
    );
    $form->addElement("select",
                      "OTHER_PAYMENTS[$i][CREDIT_ACCOUNT]",
                      "Credit Account",
                      $ptAccounts,
                      array("id" => "OTHER_PAYMENTS[$i][CREDIT_ACCOUNT]",
                            "style" => "width:300px;")
    );
    
    // add rules for form elements
    $form->addRule("OTHER_PAYMENTS[$i][AMOUNT]", "required", 'required');
    $form->addRule("OTHER_PAYMENTS[$i][AMOUNT]", "Amount must be numeric", 'vnumeric');
    $form->addRule("OTHER_PAYMENTS[$i][PAYMENT_DATE]", "required", 'required');
    $form->addRule("OTHER_PAYMENTS[$i][PAYMENT_DATE]",  UtlConvert::ErrorDateMsg, 'vdate');
    $form->addRule("OTHER_PAYMENTS[$i][DESCRIPTION]", "required", 'required');
    
    if ($contraList[$i]["PAYMENT_ID"])
    {
        $form->addElement('link',
                          "OTHER_PAYMENTS[$i][LINK_DELETE]",
                          "delete",
                          "?".$menu->getParam2().
                          "&BUSINESS_ID=".$currentBUID.
                          "&FORM_ACTION=DELETE_OTHER_PAYMENT&PAYMENT_ID=".$contraList[$i]["PAYMENT_ID"].
                          "&YEAR_MONTH_HIDDEN=".$currYearMonth,
                          $smarty->deleteImage,
                          array("onclick"=>"return confirm('Delete record?');")
        );
    }
 }
 
 
 if ($contraList)
 {
     foreach($contraList as $k1=>$v1)
       foreach($v1 as $k2=>$v2)
           $form_data["OTHER_PAYMENTS[$k1][$k2]"] = $v2;
 }
 $form->applyFilter('__ALL__', 'trim');
 $form->setDefaults(@$form_data);

 
 if ($IsPost && $form->validate() && $action == UPDATE_OTHER_PAYMENT && ($isEdit))
 {
     $IsError = 0;
     $values = $form->getSubmitValues();

     try
     {
        if ($action == UPDATE_OTHER_PAYMENT && $values["OTHER_PAYMENTS"])
        {
            $dbJournal->Updates($values["OTHER_PAYMENTS"]);
        }
        
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
 
 
//print_r($form_data);
  // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 $smarty->assign("dates", $dates_elements);
 // send form data to Smarty
 $smarty->assign('action', $action);
 $smarty->assign('form_data', $renderer->toArray());
 $buInfo =  $dbBU->getBusinessUnit($currentBUID);
 $smarty->assign("header_title", $buInfo["BUSINESS_NAME"]." Journal");
 $smarty->assign("currYearMonth", $currYearMonth);
 $smarty->assign("businessList", $buList);
 $smarty->assign("businessID", $currentBUID);
 $smarty->assign("msgSuccess", $msgSuccess);
 $smarty->assign("isEdit", $isEdit ? "true" : "false");
 
?>