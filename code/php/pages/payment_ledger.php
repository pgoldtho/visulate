<?
// Get main ulr for use in l3 sub-tab
 $href     = $GLOBALS["PATH_FORM_ROOT"] . "?" . $menu->getParam2();

 require_once dirname(__FILE__)."/../classes/database/rnt_payment_rules.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_reports.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_ledger.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_payment_accounts.class.php";
  
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once dirname(__FILE__)."/../classes/Context.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

// Test user role and display form for valid users
 if (! ($smarty->user->isOwner() 
        || $smarty->user->isManager() 
        || $smarty->user->isManagerOwner()
        || $smarty->user->isBookkeeping() 
        || $smarty->user->isBuyer()
        || $smarty->user->isBusinessOwner()))
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
    exit;
 }
 
 //Create database class objects 
 $dbLedger   = new RNTLedger($smarty->connection);
 $dbBU       = new RNTBusinessUnit($smarty->connection);
 $dbReport   = new RNTReports($smarty->connection);
 $dbAccount  = new RNTPaymentAccounts($smarty->connection);
 
 //Find and validate current business unit
 $buList = $dbBU->getBusinessUnits();
 $currentBUID = @$_REQUEST["BUSINESS_ID"];

 if ($currentBUID == null) {
     $currentBUID = Context::getBusinessID();
 } else {
     Context::setBusinessID($currentBUID);
 }

 if ( ! $currentBUID) {
     $currentBUID = $buList[0]["BUSINESS_ID"];
 }

 if ($currentBUID) {
    $smarty->user->verifyBUAccess($currentBUID);
 }

 $currentBU   = $dbBU->getBusinessUnit($currentBUID);
         
         
 // define contants for use in flow control
  if ( ! defined("CREATE_ACTION"))
 {
    define("CANCEL_ACTION", "CANCEL");
    define("CREATE_ACTION", "INSERT_PERIOD");
    define("UPDATE_ACTION", "UPDATE_PERIOD");
    define("DELETE_ACTION", "DELETE_PERIOD");
    define("SELECT_ACTION", "SELECT_PERIOD");
    define("SELECT_ACCOUNT", "SELECT_ACCOUNT");
    define("DEFAULT_ACTION", "DEFAULT_ACTION");
 }
 
 // test input parameters and determine form action. 
 if (@$_POST["create"] == "Create")
 {
     $action = CREATE_ACTION;
 }
 elseif (@$_POST["delete"] == "Delete")
 {
     $action = DELETE_ACTION;
 }
 else
 {
     $action = DEFAULT_ACTION;
 }



 
 // create payment accounts form
 $form   = new HTML_QuickForm('formLedger', 'POST');
 $IsPost = $form->isSubmitted();

 // freeze form for any users with role not in list ('BOOKKEEPING', 'OWNER-MANAGER')
 $isEdit = ($smarty->user->isManagerOwner() 
    		 || $smarty->user->isBookkeeping());
 
 
 // Render controls for users with edit privilege
 if ($isEdit) 
 {
     $dates_elements = array();
     $form->AddElement("text", "PERIOD_START", "Create Period (start date):", array("size"=>9));
     $dates_elements[] = "PERIOD_START";
  	 $form->AddElement("submit", "create", "Create", 
		                    array('onclick' => "return confirm('This will create a new accounting period.')"));
  	 $form->AddElement("submit", "delete", "Delete", 
		                    array('onclick' => "return confirm('This will delete the accounting period.')"));
	                    
     $smarty->assign("dates", $dates_elements);  
     $form->addRule('PERIOD_START', "Please enter a start date for the Accounting Period.", 'required');
     $form->addRule("PERIOD_START", UtlConvert::ErrorDateMsg, 'vdate');             
 }     


// Process insert, update and delete requests
if ($action == CREATE_ACTION &&  $form->validate()) {
    $values  = $form->getSubmitValues();
    $IsError = 0;
    
    try {
        $newPeriod = $dbLedger->newPeriod( $currentBUID, $values["PERIOD_START"]);
    }
    catch(SQLException $e)
    {
          $IsError = 1;
          $smarty->connection->rollback();
          $de =  new DatabaseError($smarty->connection);

          $smarty->assign("errorObj", $de->getErrorFromException($e));
    }
  }
elseif ($action == DELETE_ACTION ) {
    $values  = $form->getSubmitValues();
    $IsError = 0;
    
    try {
        $newPeriod = $dbLedger->deletePeriod( $values["ACCOUNT_PERIOD"]);
    }
    catch(SQLException $e)
    {
          $IsError = 1;
          $smarty->connection->rollback();
          $de =  new DatabaseError($smarty->connection);

          $smarty->assign("errorObj", $de->getErrorFromException($e));
    }    

 }


 // menu 2 level
 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
 $form->AddElement("hidden", "FORM_ACTION", $action);
 
// Get values for Account drop down list
// $account_id = @$_REQUEST["ACCOUNT_ID"];

  $account_list = array();
  $account_list = $dbLedger->getAccountList($currentBUID);
  
   if (isset($_REQUEST["ACCOUNT_ID"]))
    {
     $account_id = @$_REQUEST["ACCOUNT_ID"];
    } else {
     $account_id = current(array_keys($account_list));
    }
    
  $select_element = 
	   $form->AddElement(
     "select",
     "ACCOUNT_ID",
     "Account",
     $account_list,
     array("id"       => "ACCOUNT_ID",		      
           "onchange" => "formLedger.FORM_ACTION.value = 'SELECT_ACCOUNT';
                          formLedger.ACCOUNT_ID.value = this.value;
                          formLedger.submit();")
   );    

 $select_element->setSelected($account_id);
 
// Get values for Account Period drop down list
  $period_list = array();
  $period_list = $dbReport->getAccountPeriods($currentBUID);
   if (isset($_REQUEST["ACCOUNT_PERIOD"]))
 {
     $account_period = $_REQUEST["ACCOUNT_PERIOD"];
 } else {
     $account_period = current(array_keys($period_list));
 }

 $period_dates = array();
 $period_dates = $dbLedger->getPeriodDates($account_period);

 
 //Add Account Period Drop down to form.
  $form->AddElement(
     "select",
     "ACCOUNT_PERIOD",
     "Accounting Period",
     $period_list,
     array("id"       => "ACCOUNT_PERIOD",		      
           "onchange" => "formLedger.FORM_ACTION.value = 'SELECT_PERIOD';
                          formLedger.ACCOUNT_PERIOD.value = this.value;
                          formLedger.submit();")
   );

 if (!$IsPost)
 {
     $form_data["ACCOUNT_PERIOD"] = $account_period;
     $form->setDefaults($form_data);
 }
 
 	$smarty->assign("form_data", $period_list);        
 	$smarty->assign("acct_period", $account_period);


 	   
 if (isset($_REQUEST["ACCOUNT_ID"])){
     // Assemble data for Account Details
    $gl_details = array();
    $gl_details = $dbReport->getGLdetails (
  	                                   $currentBUID,
		 	                                 $period_dates["PERIOD_START"],
                                       $period_dates["PERIOD_END"],
																			 $account_id );
    //print_r($gl_details);     
	   	 $smarty->assign("title", "Account Details");
		   $smarty->assign("data", $gl_details);        
    }
 else {		   
     // Assemble data for Account Summary
    $gl_summary = array();
    $gl_summary = $dbReport->getGLsummary (
  	                                   $currentBUID,
		 	                                 $period_dates["PERIOD_START"],
                                       $period_dates["PERIOD_END"] );
   // print_r($gl_summary);     
	   	 $smarty->assign("title", "Account Summary");
		   $smarty->assign("data", $gl_summary);        
    }


		   


// Render form using Smarty Template		   
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 $form->accept($renderer);
 $smarty->assign('form_data', $renderer->toArray());
 $smarty->assign("businessList", $buList);
 $smarty->assign("businessID", $currentBUID);
 $smarty->assign("businessName", $currentBU["BUSINESS_NAME"]);
 $smarty->assign("isEdit", $isEdit ? "true" : "false");

 //Level 3 sub-tab processing
 $details_href = $href . '&ACCOUNT_ID='.$account_id
                       . '&ACCOUNT_PERIOD='.$account_period;
               
 if (isset($_REQUEST["ACCOUNT_ID"]))               
 {$skey = 1;}
 else
  {$skey = 0;}

 $x = " class='current' ";
 $smarty->assign("additional_menu3_items",
                 "<li><a href='$href' ".($skey == 0 ? $x : "")."id='m3smry'>Summary</a></li>"
               . "<li><a href='$details_href' ".($skey == 1 ? $x : "")."id='m3dets'>Details</a></li>"
 );		 			 
 
 

?>