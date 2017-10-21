<?
 require_once dirname(__FILE__)."/../classes/database/rnt_payment_accounts.class.php";
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
    define("INSERT_ACTION", "INSERT_ACCOUNT");
    define("UPDATE_ACTION", "UPDATE_ACCOUNT");
    define("DELETE_ACTION", "DELETE_ACCOUNT");
    define("SELECT_ACCOUNTS_BY_TYPE", "SELECT_ACCOUNTS_BY_TYPE");
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
 elseif (@$_REQUEST["FORM_ACTION"] == SELECT_ACCOUNTS_BY_TYPE)
 {
     $action = SELECT_ACCOUNTS_BY_TYPE;
 }
 elseif (@$_REQUEST["FORM_ACTION"] == INSERT_ACTION)
 {
     $action = INSERT_ACTION;
 }
 elseif (@$_REQUEST["FORM_ACTION"] == UPDATE_ACTION)
 {
     $action = UPDATE_ACTION;
 }
 elseif (@$_REQUEST["FORM_ACTION"] == DELETE_ACTION)
 {
     $action = DELETE_ACTION;
     $del_account_id = $_REQUEST["account_id"];
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
 $form   = new HTML_QuickForm('formAcc', 'POST');
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
 
 
 $PaymentAccounts = new RNTPaymentAccounts($smarty->connection); 
 
 $account_types_list = array();
 $account_types_list = $PaymentAccounts->getAccountTypesList();
 if (isset($_REQUEST["ACCOUNT_TYPE_MAIN"]))
 {
     $account_type = $_REQUEST["ACCOUNT_TYPE_MAIN"];
 } else {
     $account_type = current(array_keys($account_types_list));
 }

 
 // Prepare form data 
 $accounts_data   = array();
 if (!$IsPost) {
      if($isEdit) {
        $accounts_data = $PaymentAccounts->getPaymentAccounts(
            $currentBUID,
            $account_type);
            }
      else {
        $accounts_data = $PaymentAccounts->getPaymentAccounts($currentBUID);
        }
     
     if ($action == INSERT_ACTION) {
        $accounts_data[] = array("BUSINESS_ID" => $currentBUID,
                                 "ACCOUNT_TYPE"=> $account_type);
     }
          
     foreach ($accounts_data as $k=>$v) {
     	 foreach ($v as $k1=>$v1) {
             $form_data["ACCOUNTS[$k][$k1]"] = $v1;
     	 }
     }
 } else {
     $accounts_data = $_POST["ACCOUNTS"];
 }

 
 $form->AddElement(
     "select",
     "ACCOUNT_TYPE_MAIN",
     "Account Type",
     $account_types_list,
     array("id"   => "ACCOUNT_TYPE_MAIN",
           "onchange" => "formAcc.FORM_ACTION.value = 'SELECT_ACCOUNTS_BY_TYPE';
                          formAcc.ACCOUNT_TYPE_MAIN.value = this.value;
                          formAcc.submit();")
 );

 
 $OwnerTypes = array();
 $Owner      = array();
 $OwnerTypes = $PaymentAccounts->getOwnerTypesList();
 $Owners     = $PaymentAccounts->getOwnersList($currentBUID);

 
 for($i = 0; $i < count($accounts_data); $i++)
 {
     $form->AddElement(
         "text",
         "ACCOUNTS[$i][ACCOUNT_NUMBER]",
         "Account Number",
         array("id"   => "ACCOUNTS[$i][ACCOUNT_NUMBER]",
               "size" => 8)
     );
     
     $form->AddElement(
         "text",
         "ACCOUNTS[$i][NAME]",
         "Name",
         array("id"   => "ACCOUNTS[$i][NAME]",
               "size" => 28)
     );
     
     $form->addElement(
         "advcheckbox",
         "ACCOUNTS[$i][CURRENT_BALANCE_YN]",
         "Current",
         null,     
         null,     
         array("N","Y")
     );
     
     /*
     $sel =& $form->addElement(
         "hierselect",
         "ACCOUNTS[$i][OWNER_TYPE]",
         'Owner Type',
         null,
         null
     );
     $sel->setOptions(array($OwnerTypes, $Owners));
     */


     $form->AddElement(
         "select",
         "ACCOUNTS[$i][OWNER_TYPE]",
         "Owner Type",
         $OwnerTypes,
         array("id"   => "ACCOUNTS[$i][OWNER_TYPE]",
               "onchange" =>"var x_value = this.value;                             
                             with (document) {
                                 var x_items = new Array(
                                     getElementById('ACCOUNTS[$i][OWNER_TYPE_BUSINESS]'),
                                     getElementById('ACCOUNTS[$i][USER_ASSIGN_ID]'),
                                     getElementById('ACCOUNTS[$i][PEOPLE_BUSINESS_ID]')
                                 );
                                 
                                 for (i = 0; i < x_items.length; i++) {                                     
                                     x_items[i].style.display = (i == x_value) ? 'block' : 'none';
                                     x_items[i].selectedIndex = 0;
                                 }
                             }"
         )
     );
     
     $business_style = "display:none; width:200px;";
     $user_assign_style = "display:none; width:200px;";
     $people_business_style = "display:none; width:200px;";
     if ( ! empty($accounts_data[$i]["USER_ASSIGN_ID"])) {
         $user_assign_style = "display:block; width:200px;";
     }
     elseif (! empty($accounts_data[$i]["PEOPLE_BUSINESS_ID"])) {
         $people_business_style = "display:block; width:200px;";
     }
     else {
         $business_style = "display:block; width:200px;";
     }
     
     $form->AddElement(
         "select",
         "ACCOUNTS[$i][OWNER_TYPE_BUSINESS]",
         "Owner",
         $Owners[0],
         array("id"    => "ACCOUNTS[$i][OWNER_TYPE_BUSINESS]",
               "style" => $business_style, //"display:none",
               "disabled" => "disabled"
         )
     );

     $form->AddElement(
         "select",
         "ACCOUNTS[$i][USER_ASSIGN_ID]",
         "Owner",
         $Owners[1],
         array("id"    => "ACCOUNTS[$i][USER_ASSIGN_ID]",
               "style" => $user_assign_style //"display:none"
         )
     );
     $form->AddElement(
         "select",
         "ACCOUNTS[$i][PEOPLE_BUSINESS_ID]",
         "Owner",
         $Owners[2],
         array("id"    => "ACCOUNTS[$i][PEOPLE_BUSINESS_ID]",
               "style" => $people_business_style //"display:none"
         )
     );
     
     $has_detail_data = $PaymentAccounts->has_detail_data(
         $accounts_data[$i]["ACCOUNT_ID"]
     );
     if ( ! is_null($accounts_data[$i]["ACCOUNT_ID"])
          and ! $has_detail_data
          and $isEdit)
     {
         $form->addElement(
             'link',
             "ACCOUNTS[$i][ACCOUNT_ID_LINK]",
             "delete",
             "?".$menu->getParam2().
             "&FORM_ACTION=DELETE_ACCOUNT&account_id=".$accounts_data[$i]["ACCOUNT_ID"],
             $smarty->deleteImage,
             $smarty->deleteAttr
         );
     }

     $form->AddElement("hidden", "ACCOUNTS[$i][ACCOUNT_ID]");
     $form->AddElement("hidden", "ACCOUNTS[$i][BUSINESS_ID]");
     $form->AddElement("hidden", "ACCOUNTS[$i][ACCOUNT_TYPE]");
     $form->AddElement("hidden", "ACCOUNTS[$i][CHECKSUM]", $accounts_data[$i]["CHECKSUM"]);
 }

 
 if ($isEdit)
 {
     $form->AddElement("submit", "cancel", "Cancel", array());
     $form->AddElement("submit", "save", "Save", array());
     $form->AddElement("submit", "new", "New", array());
 }


 if (!$IsPost)
 {
     $form_data["ACCOUNT_TYPE_MAIN"] = $account_type;
     $form->setDefaults($form_data);
 }


 if ((($IsPost && $form->validate()) OR $action == DELETE_ACTION)
      && $isEdit)
 {
     // save form to database
     $values = $form->getSubmitValues();
     $IsError = 0;
     try
     {
         if ($action == INSERT_ACTION 
             || $action == UPDATE_ACTION)
         {
             $PaymentAccounts->Update($values);
         }
         elseif ($action == DELETE_ACTION)
         {
             $PaymentAccounts->Delete($del_account_id);
         }
         elseif ($action == SELECT_ACCOUNTS_BY_TYPE)
         {
             //
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
         if (@$_REQUEST["new"])
         {
       	     $action = INSERT_ACTION;
         }
         elseif ($_REQUEST["save"])
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
                "&BUSINESS_ID=".$currentBUID.
                (isset($_REQUEST["ACCOUNT_TYPE_MAIN"]) 
                 ? "&ACCOUNT_TYPE_MAIN=".$_REQUEST["ACCOUNT_TYPE_MAIN"]
                 : "")
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