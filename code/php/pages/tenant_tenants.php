<?
 require_once dirname(__FILE__)."/../classes/database/rnt_properties.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_tenants.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";

 require_once dirname(__FILE__)."/../classes/database/rnt_acc_receivable.class.php";

 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

 $mobile_device = Context::getMobileDevice();
 if ($mobile_device)
  {   
	 $template_name = "mobile-tenant_tenants.tpl";
  }

 if (! ( $smarty->user->isOwner() || $smarty->user->isManager() || $smarty->user->isManagerOwner() || $smarty->user->isBookkeeping() || $smarty->user->isBusinessOwner()))
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
    exit;
 }

 $isEdit = ($smarty->user->isManager() || $smarty->user->isManagerOwner());

 if (!defined("TENANT_TENANTS"))
 {
    define("TENANT_TENANTS", "1");
    define("UPDATE_ACTION", "UPDATE");
    define("DELETE_ACTION", "DELETE");
    define("CANCEL_ACTION", "CANCEL");
 }

 $form = new HTML_QuickForm('formTenants', 'POST');
 $IsPost = $form->isSubmitted();
 $action = UPDATE_ACTION;
 $dates_elements = array();

 if (@$_POST["cancel"])
   $action = CANCEL_ACTION;
 else
 if (@$_REQUEST["action"] == "delete_tenant")
 {
    $deleteTenantID = @$_GET["TENANT_ID"];
    $action = DELETE_ACTION_TENANT;
 }
 else
   $action = UPDATE_ACTION;

 if (!$isEdit)
   $form->freeze();

 $currentPropertyID = $menu3->current_property_id;
 $currentTenantID = @$_REQUEST["TENANT_ID"];

 $dbProp = new RNTProperties($smarty->connection);
 $dbTenant = new RNTTenants($smarty->connection);

 if (!$currentTenantID)
 {
    $form_data = $dbTenant->getFirstTenantForProperty($currentPropertyID);
    if (@$form_data["TENANT_ID"])
       $currentTenantID = $form_data["TENANT_ID"];
 }
 else
    $form_data = $dbTenant->getTenant($currentTenantID);

 if ($action == CANCEL_ACTION)
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&".$menu3->getParams()."&TENANT_ID=".$currentTenantID);
    exit;
 }

 $form->registerRule('vdate', 'function', 'validateDate');
 $form->registerRule('vnumeric', 'function', 'validateNumeric');
 $form->registerRule('vinteger', 'function', 'validateInteger');

 // property_id for page menu level 3
 $form->AddElement("hidden", $menu3->request_property_id, $menu3->current_property_id);
 // menu 2 level
 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);


 // for balance table
 $dbAccReceiv = new  RNTAccountReceiveable($smarty->connection);
 $paymentDueList = $dbAccReceiv->getListTenantPaymentDue($currentTenantID);
 $sum_due = 0;
 $sum_made = 0;
 foreach($paymentDueList as $k=>$v)
 {
   $sum_due += $v["AMOUNT"];
   $paymentDueList[$k]["PAYMENT_DUE_DATE"] = UtlConvert::dbDateToDisplay($v["PAYMENT_DUE_DATE"]);
   $paymentDueList[$k]["AMOUNT"] = UtlConvert::dbNumericToDisplay($v["AMOUNT"]);
 }

 $paymentMadeList = $dbAccReceiv->getListTenantPaymentMade($currentTenantID);
 foreach($paymentMadeList as $k=>$v)
 {
   $sum_made += $v["AMOUNT"];
   $paymentMadeList[$k]["PAYMENT_DATE"] = UtlConvert::dbDateToDisplay($v["PAYMENT_DATE"]);
   $paymentMadeList[$k]["AMOUNT"] = UtlConvert::dbNumericToDisplay($v["AMOUNT"]);
 }
 if ($sum_due == 0) $sum_due = floatval(0);
 if ($sum_made == 0) $sum_made = floatval(0);
 $sum_balance = UtlConvert::dbNumericToDisplay($sum_due - $sum_made);
 if ($sum_balance == "") $sum_balance = "0.00";
 $sum_balance_revert = UtlConvert::dbNumericToDisplay($sum_made - $sum_due);
 if ($sum_balance_revert == "") $sum_balance_revert = "0.00";
 $sum_due = UtlConvert::dbNumericToDisplay($sum_due);
 if ($sum_due == "") $sum_due = "0.00";
 $sum_made = UtlConvert::dbNumericToDisplay($sum_made);
 if ($sum_made == "") $sum_made= "0.00";

 // ---- end of balance table

 $mailto_text = "Balance: $sum_balance_revert%0d%0a%0d%0a".
                "Payments Due%0d%0a%0d%0aDate Due       Type                     Amount%0d%0a------------------------------------------------";
 foreach($paymentDueList as $v)
    $mailto_text .= "%0d%0a".$v["PAYMENT_DUE_DATE"]." ".str_pad($v["RECEIVABLE_TYPE_NAME"], 20, " ", STR_PAD_RIGHT)." ".str_pad($v["AMOUNT"], 16, " ", STR_PAD_LEFT);
 $mailto_text .=  "%0d%0aTotal:                      ".str_pad($sum_due, 20, " ", STR_PAD_LEFT);
 $mailto_text .=  "%0d%0a%0d%0a%0d%0aPayments Made%0d%0a%0d%0aDate             Amount%0d%0a---------------------------";
 foreach($paymentMadeList as $v)
    $mailto_text .= "%0d%0a".$v["PAYMENT_DATE"]." ".str_pad($v["AMOUNT"], 16, " ", STR_PAD_LEFT);
 $mailto_text .=  "%0d%0aTotal: ".str_pad($sum_made, 20, " ", STR_PAD_LEFT);

 $dbTenant->setTenantList($currentPropertyID);

 if (@$form_data){
     $form->AddElement("hidden", "TENANT_ID");
     $form->AddElement("hidden", "AGREEMENT_ID");
     $form->AddElement("hidden", "PEOPLE_ID");
     $form->AddElement("hidden", "CHECKSUM");
     $form->AddElement("hidden", "FORM_ACTION", $action);

     $form->AddElement("text", "UNIT_NAME", "Unit Name", array("size"=>20, "disabled"=>"disabled"));
/*     $form->AddElement("text", "LAST_NAME", "Last Name", array("size"=>20, "disabled"=>"disabled"));
     $form->AddElement("text", "FIRST_NAME", "First Name", array("size"=>20, "disabled"=>"disabled"));
     */
//     $elementName=null, $elementLabel=null, $href=null, $text=null, $attributes=null
     if ($isEdit && !$mobile_device)
       $form->AddElement("link", "LAST_NAME", "Tenant Name", "?m2=tenant_peoples&PEOPLE_ID=".$form_data["PEOPLE_ID"],
                         $form_data["LAST_NAME"]." ".$form_data["FIRST_NAME"]);
     else
     {
       $form->AddElement("text", "LAST_NAME", "Last Name",  $form_data["LAST_NAME"] );
       $form->AddElement("text", "FIRST_NAME", "First Name", $form_data["FIRST_NAME"]);
     }
     $form->addElement("select", "STATUS", "Tenant Status", $dbTenant->getStatusList());

     $currentBUID = $dbProp->getBusinessUnit($currentPropertyID);
     $form->addElement("select", "SECTION8_ID", "Section8 Office", $dbTenant->getSection8List($currentBUID));
     $form->AddElement("text", "PHONE1", "Phone 1", array("size"=>15, "disabled"=>"disabled"));
     $form->AddElement("text", "PHONE2", "Phone 2", array("size"=>15, "disabled"=>"disabled"));
     $form->AddElement("text", "DATE_OF_BIRTH", "Date of birth", array("size"=>8, "disabled"=>"disabled"));
     $form->AddElement("text", "DRIVERS_LICENSE", "Drivers License", array("size"=>15, "disabled"=>"disabled"));
     //$form->AddElement("text", "EMAIL_ADDRESS", "E-mail", array("size"=>20, "disabled"=>"disabled"));
     if (@$form_data["EMAIL_ADDRESS"]) {
       if ($isEdit)
          $form->AddElement("link", "EMAIL_ADDRESS", "E-mail", "mailto:".htmlentities($form_data["LAST_NAME"]." ".$form_data["FIRST_NAME"])."<".$form_data["EMAIL_ADDRESS"].">?subject=".htmlentities("payments summary table")."&body=".htmlentities($mailto_text), $form_data["EMAIL_ADDRESS"]);
       else
          $form->AddElement("text", "EMAIL_ADDRESS", "E-mail", $form_data["EMAIL_ADDRESS"], $form_data["EMAIL_ADDRESS"]);
     }
     $form->AddElement("text", "SSN", "SSN", array("size"=>15, "disabled"=>"disabled"));
     $form->AddElement("text", "AMOUNT", "Rent", array("size"=>8, "disabled"=>"disabled"));
     $form->AddElement("text", "AMOUNTH_PERIOD_NAME", "Amount Period", array("size"=>12, "disabled"=>"disabled"));
     $form->AddElement("text", "AGREEMENT_DATE", "Effective Date", array("size"=>8, "disabled"=>"disabled"));
     $form->AddElement("text", "DEPOSIT_BALANCE", "Deposit Balance", array("size"=>8));
     $form->AddElement("text", "LAST_MONTH_BALANCE", "Last Month Balance", array("size"=>8));
     $form->AddElement("text", "SECTION8_VOUCHER_AMOUNT", "Section8 voucher amount", array("size"=>8));
     $form->AddElement("text", "SECTION8_TENANT_PAYS", "Section8 tenant pays", array("size"=>8));
     $form->AddElement("textarea", "TENANT_NOTE", "Notes", array("rows"=>"7", "cols"=>"50"));

     if ($isEdit)
     {
         $form->AddElement("submit", "accept", "Save");
         $form->AddElement("submit", "cancel", "Cancel");
     }

     $r = array();
     if (!$dbTenant->isHasPrev($currentTenantID))
       $r = array("disabled"=>"disabled");
     $form->AddElement("submit", "prev", "Prev", $r);

     $r = array();
     if (!$dbTenant->isHasNext($currentTenantID))
       $r = array("disabled"=>"disabled");
     $form->AddElement("submit", "next", "Next", $r);

     if (!$IsPost)
     {
        $form_data["DATE_OF_BIRTH"] = UtlConvert::dbDateToDisplay($form_data["DATE_OF_BIRTH"]);
        $form_data["AGREEMENT_DATE"] = UtlConvert::dbDateToDisplay($form_data["AGREEMENT_DATE"]);

        $nums = array("DEPOSIT_BALANCE", "LAST_MONTH_BALANCE", "AMOUNT", "SECTION8_VOUCHER_AMOUNT", "SECTION8_TENANT_PAYS");
        foreach($nums as $v)
           $form_data[$v] = UtlConvert::dbNumericToDisplay($form_data[$v]);
     }


     // Apply filter for all data cells
     $form->applyFilter('__ALL__', 'trim');

     $form->addRule('DEPOSIT_BALANCE', 'Required.', 'required');
     $form->addRule('LAST_MONTH_BALANCE', 'Required.', 'required');
     $form->addRule('STATUS', 'Required.', 'required');

     $form->addRule("DEPOSIT_BALANCE", 'Must be numeric.', 'vnumeric');
     $form->addRule("LAST_MONTH_BALANCE", 'Must be numeric.', 'vnumeric');
     $form->addRule("SECTION8_VOUCHER_AMOUNT", 'Must be numeric.', 'vnumeric');
     $form->addRule("SECTION8_TENANT_PAYS", 'Must be numeric.', 'vnumeric');

     $form->setDefaults(@$form_data);
     $form->validate();

 }

 $s = "Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&".$menu3->getParams().
      "&TENANT_ID=";

 if (@$_REQUEST["prev"])
 {
      header($s.$dbTenant->getPrevID($currentTenantID));
      exit;
 }
 else
 if (@$_REQUEST["next"])
 {

    header($s.$dbTenant->getNextID($currentTenantID));
    exit;
 }

 if ((($IsPost && $form->validate()) ) && ($isEdit)) {

    // save form to database
    $values = $form->getSubmitValues();
    $IsError = 0;
    try
    {
        if ($action == UPDATE_ACTION)
        {
           $dbTenant->Update($values);
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

    // redirect to page
    if (!$IsError)
    {
       $s = "Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&".$menu3->getParams()."&TENANT_ID=".$currentTenantID;
       if ($action == UPDATE_ACTION)
       {
          header($s);
          exit;
       }
    }
 }

 $property_data = $dbProp->getProperty($menu3->current_property_id);
 $header_title = @$property_data["PROP_ADDRESS1"]." - Tenant Details";
 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 // is owner we not display calendar buttons
 if (!$isEdit)
    $dates_elements = array();

 $smarty->assign("dates", $dates_elements);

 $smarty->assign("isExists", isset($form_data["TENANT_ID"]) ? "true": "false");

 // send form data to Smarty
 $smarty->assign('action', $action);
 $smarty->assign('form_data', $renderer->toArray());
 $smarty->assign("header_title", $header_title);
 $smarty->assign("isEdit", $isEdit ? "true" : "false");

 $smarty->assign("paymentDue", $paymentDueList);
 $smarty->assign("paymentMade", $paymentMadeList);

 $smarty->assign("sum_due", $sum_due);
 $smarty->assign("sum_made", $sum_made);
 $smarty->assign("sum_balance", $sum_balance);
?>
