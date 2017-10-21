<?
 require_once dirname(__FILE__)."/../classes/database/rnt_payment_rules.class.php";
 
 require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";
 
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once dirname(__FILE__)."/../classes/Context.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

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


 if ( ! defined("PAYMENT_ACCOUNTS"))
 {
    define("PAYMENT_ACCOUNTS", "1");
    define("CANCEL_ACTION", "CANCEL");
    define("UPDATE_ACTION", "UPDATE_ACCOUNT");
 }

 $dbBU = new RNTBusinessUnit($smarty->connection);
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
         
 // ----  define params
 if (@$_POST["cancel"])
 {
     $action = CANCEL_ACTION;
 }
 elseif (@$_REQUEST["FORM_ACTION"] == UPDATE_ACTION)
 {
     $action = UPDATE_ACTION;
 }
 else
 {
     $action = UPDATE_ACTION;
 }


 if ($action == CANCEL_ACTION)
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"].
           "?".$menu->request_menu_level2."=".$menu->current_level2.
           "&BUSINESS_ID=".$currentBUID);
    exit;
 } 
 

 // create payment accounts form
 $form   = new HTML_QuickForm('formRules', 'POST');
 $IsPost = $form->isSubmitted();

 // freeze form for any users with role not in list ('BOOKKEEPING', 'MANAGER and OWNER')
 $isEdit = ($smarty->user->isManagerOwner() 
    		 || $smarty->user->isBookkeeping());
 
 if (!$isEdit) {
     $form->freeze();
 }

 // menu 2 level
 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
 $form->AddElement("hidden", "FORM_ACTION", $action);
 
 
 $PaymentRules = new RNTPaymentRules($smarty->connection); 
 
 // Prepare form data 
 $rules_data   = array();
 if (!$IsPost) {
     $rules_data = $PaymentRules->getPaymentRules($currentBUID);
     
     foreach ($rules_data as $k=>$v) {
     	 foreach ($v as $k1=>$v1) {
             $form_data["RULES[$k][$k1]"] = $v1;
     	 }
     }
 } else {
     $rules_data = $_POST["RULES"];
 }

 
 $PaymentAccounts  = $PaymentRules->getPaymentAccountsList($currentBUID);

 for($i = 0; $i < count($rules_data); $i++)
 {
     $form->AddElement(
         "text",
         "RULES[$i][PAYMENT_TYPE_NAME]",
         "Payment Type",
         array("id" => "RULES[$i][PAYMENT_TYPE_NAME]",
               "disabled" => "disabled",
							 "style" => "width:160px;")
     );
     
     $form->AddElement(
         "text",
         "RULES[$i][TRANSACTION_TYPE_NAME]",
         "Transaction Type",
         array("id" => "RULES[$i][TRANSACTION_TYPE_NAME]",
               "disabled" => "disabled",
							 "style" => "width:100px;")
     );

     $form->AddElement(
         "select",
         "RULES[$i][DEBIT_ACCOUNT]",
         "Debit Account",
         $PaymentAccounts,
         array("id" => "RULES[$i][DEBIT_ACCOUNT]",
               "style" => "width:200px;")
     );
     $form->AddElement(
         "select",
         "RULES[$i][CREDIT_ACCOUNT]",
         "Ñredit Account",
         $PaymentAccounts,
         array("id" => "RULES[$i][CREDIT_ACCOUNT]",
               "style" => "width:200px;")
     );
     
     $form->AddElement("hidden", "RULES[$i][BUSINESS_ID]");
     $form->AddElement("hidden", "RULES[$i][PAYMENT_TYPE_ID]");
     $form->AddElement("hidden", "RULES[$i][TRANSACTION_TYPE]");
     $form->AddElement("hidden", "RULES[$i][CHECKSUM]", $rules_data[$i]["CHECKSUM"]);
 }


 
 if ($isEdit)
 {
     $form->AddElement("submit", "cancel", "Cancel", array());
     $form->AddElement("submit", "save", "Save", array());
 }


 if (!$IsPost)
 {
     $form->setDefaults($form_data);
 }


 if ($IsPost && $form->validate() && $isEdit)
 {
     // save form to database
     $values = $form->getSubmitValues();
     $IsError = 0;
     try
     {
         if ($action == UPDATE_ACTION)
         {
             $PaymentRules->Update($values);
         }
         else
         {
             throw new Exception('Unknown operation');
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
    
     // redirect to page
     if (!$IsError)
     {
         if ($_REQUEST["save"])
         {
       	     $action = UPDATE_ACTION;
         }
         else
         {
             $action = UPDATE_ACTION;
         }
         
         header("Location: ".$GLOBALS["PATH_FORM_ROOT"].
                "?".$menu->request_menu_level2."=".$menu->current_level2.
                "&FORM_ACTION=".$action.
                "&BUSINESS_ID=".$currentBUID
         );
         exit;       
     }
 }
  
  
 
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 $form->accept($renderer);

 // send form data to Smarty
 $smarty->assign('action', $action);
 $smarty->assign('form_data', $renderer->toArray());
 $smarty->assign("isEdit", $isEdit ? "true" : "false");
 
 
 $smarty->assign("businessList", $buList);
 $smarty->assign("businessID", $currentBUID);
 $smarty->assign("businessName", $currentBU["BUSINESS_NAME"]);

?>