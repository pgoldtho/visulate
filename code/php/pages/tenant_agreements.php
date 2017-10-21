<?
 /**
  * Switch page by submenu level 3
  */
 $href     = $GLOBALS["PATH_FORM_ROOT"] . "?" . $menu->getParam2();

 $mobile_device = Context::getMobileDevice();
 if ($mobile_device)
  {
	 $template_name = "mobile-tenant_agreements.tpl";
   $skey = 0;
  }
 else
  {
   $type = @$_REQUEST["type"];
   if ($type != "" && $type != "advertise" )
   {
     $type = "";
   }

   if ($type == "")
   {
     $template_name = "page-tenant_agreements.tpl";
     $skey = 0;
   }
   else if ($type == "advertise")
   {
     $template_name = "page-tenant_agreements-advertise.tpl";
     $skey = 1;
   }
   else
   {
       echo "error";
   }
  }

 require_once dirname(__FILE__)."/../classes/database/rnt_properties.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_agreement.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

 if ($type == "advertise")
 {
 /**
  * Tenant agreements advertise
  */
     require_once dirname(__FILE__)."/../classes/database/rnt_property_photos.class.php";

     if (!defined("AGREEMENT_ADVERTISE")) {
         define("AGREEMENT_ADVERTISE", "1");
         define("UPDATE_ACTION", "UPDATE");
         define("CANCEL_ACTION", "CANCEL");
     }

     // create agreement advertise form
     $form   = new HTML_QuickForm('formAdv', 'POST');
     $IsPost = $form->isSubmitted();

     // freeze form for any users with role not in list ('MANAGER', 'MANAGER and OWNER')
     $isEdit = ($smarty->user->isManager()
             || $smarty->user->isAdvertise()
		     || $smarty->user->isManagerOwner());
     if (!$isEdit) {
         $form->freeze();
     }

     $currentPropertyID  = $_REQUEST["PropertyId"];
     $currentAgreementID = $_REQUEST["AgreementId"];
     $currentUnitID      = $_REQUEST["UnitId"];

     /**
      * add form elements
      */
     $form->AddElement("hidden", $menu3->request_property_id, $menu3->current_property_id);
     // menu 2 level
     $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
     $form->AddElement("hidden", "type", "advertise");

     $form->AddElement("hidden", "PropertyId", $currentPropertyID);
     $form->AddElement("hidden", "AgreementId", $currentAgreementID);
     $form->AddElement("hidden", "UnitId", $currentUnitID);
     $form->AddElement("hidden", "property_checksum");
     $form->AddElement("hidden", "agreement_checksum");
     $form->AddElement("hidden", "unit_checksum");

     $form->addElement("text", "ad_title", "Title:&nbsp;", array("size"=>"40", "maxlength" => "300"));
     $form->addElement("textarea", "property_description", "Property Description", array("cols"=>"80", "rows"=>"6"));
     $form->addElement("textarea", "unit_description", "Unit Description", array("cols"=>"80", "rows"=>"6"));

     $form->addElement("text", "ad_contact", "Contact:", array("size"=>"40"));
     $form->addElement("text", "ad_phone", "Phone:", array("size"=>"10"));
     $form->addElement("text", "ad_email", "E-mail:", array("size"=>"40"));

     $group[] =& HTML_QuickForm::createElement("radio", "ad_publish_yn", null, "Publish", "Y");
     $group[] =& HTML_QuickForm::createElement("radio", "ad_publish_yn", null, "Don't Publish", "N");
     $form->addGroup($group, "action", null, "<br>", false);

     $form->addElement("submit", "save", "Save");
     $form->addElement("submit", "cancel", "Cancel");

     // Apply filter for all data cells
     $form->applyFilter('__ALL__', 'trim');

     if ($smarty->user->isAdvertise()) {
         $form->addRule('property_description', 'Please enter Property Description.', 'required');
         $form->addRule('ad_title', 'Please enter Title.', 'required');
         $form->addRule('ad_contact', 'Please enter Contact Details.', 'required');
         $form->addRule('ad_phone', 'Please enter Phone Number.', 'required');
     }
     $form->addRule('ad_email', 'E-mail is a not e-mail address.', 'email');

     // init database interface objects
     $dbAgr  = new RNTAgreement($smarty->connection);
     $dbProp = new RNTProperties($smarty->connection);

     if ($IsPost && $form->validate()) {
         $action = ""; //UPDATE_ACTION;
         if ($_POST["cancel"]) {
             $action = CANCEL_ACTION;
         } elseif ($_POST["save"]) {
             $action = UPDATE_ACTION;
         }

         if ($action == UPDATE_ACTION) {
             $values  = $form->getSubmitValues();
             $IsError = 0;

             try {
                 /**
                  * update property
                  */
                 $prop_values = array(
                     "property_checksum"    => htmlentities($values['property_checksum']),
                     "property_description" => htmlentities($values['property_description'])
                 );
                 $dbProp->updatePropertyDescription($values['PropertyId'], $prop_values);

                 /**
                  * update property unit
                  */
                 $unit_values = array(
                     "unit_checksum"    => htmlentities($values['unit_checksum']),
                     "unit_description" => htmlentities($values['unit_description'])
                 );
                 $dbProp->updateUnitDescription($values['UnitId'], $unit_values);

                 /**
                  * update agreement
                  */
                 $agr_values = array(
                     'ad_title'      => htmlentities($values['ad_title']),
                     'ad_contact'    => htmlentities($values['ad_contact']),
                     'ad_email'      => htmlentities($values['ad_email']),
                     'ad_publish_yn' => htmlentities($values['ad_publish_yn']),
                     'ad_phone'      => htmlentities($values['ad_phone']),
                     'agreement_checksum' => htmlentities($values['agreement_checksum'])
                 );
                 $dbAgr->updateAgreementAd($values['AgreementId'], $agr_values);
                 //
                 $smarty->connection->commit();
             } catch(SQLException $e) {
                 $IsError = 1;
                 $smarty->connection->rollback();
                 $de =  new DatabaseError($smarty->connection);
                 $smarty->assign("errorObj", $de->getErrorFromException($e));
             }

             // on success updates - redirect to page
             if (!$IsError)
             {
                 header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->request_menu_level2."=".$menu->current_level2."&type=advertise&PropertyId=".$currentPropertyID."&AgreementId=".$currentAgreementID.'&UnitId='.$currentUnitID);
                 exit;
             }
         }
     }// form was submited?

     $property_info  = $dbProp->getProperty($currentPropertyID);
     $agreement_info = $dbAgr->getAgreement($currentAgreementID);
     $unit_info      = $dbProp->getPropertyUnit($currentUnitID);

     // property photos
     $dbPropertyPhotos = new RNTPropertyPhotos($smarty->connection);
     $photo_list       = $dbPropertyPhotos->getList($currentPropertyID);
     foreach ($photo_list as $k => $v)
     {
         $photo_list[$k]['PHOTO_FILENAME'] = UPLOAD_URL
                                           .'/'.$currentPropertyID
                                           .'/thumbnail_'.$v['PHOTO_FILENAME'];
         $photo_list[$k]['VGA_FILENAME']   = UPLOAD_URL
                                           .'/'.$currentPropertyID
                                           .'/vga_'.$v['PHOTO_FILENAME'];

         $photo_list[$k]['LARGE_PHOTO_FILENAME'] = UPLOAD_URL
                                                 .'/'.$currentPropertyID
                                                 .'/'.$v['PHOTO_FILENAME'];
     }
     // end property photos

     if (!$isPost) {
          $form->setDefaults(
              array(
                  "PropertyId"    => $property_info["PROP_PROPERTY_ID"],
                  "AgreementId"   => $agreement_info["AGR_AGREEMENT_ID"],
                  "UnitId"        => $unit_info["UNIT_UNIT_ID"],
                  "property_checksum"  => $property_info["PROP_CHECKSUM"],
                  "agreement_checksum" => $agreement_info["AGR_CHECKSUM"],
                  "unit_checksum"      => $unit_info["UNIT_CHECKSUM"],
                  "ad_title"             => $agreement_info["AGR_AD_TITLE"],
                  "property_description" => $property_info["PROP_DESCRIPTION"],
                  "unit_description"     => $unit_info["UNIT_DESCRIPTION"],
                  "ad_contact"           => $agreement_info["AGR_AD_CONTACT"],
                  "ad_phone"             => $agreement_info["AGR_AD_PHONE"],
                  "ad_email"             => $agreement_info["AGR_AD_EMAIL"],
                  "ad_publish_yn"        => $agreement_info["AGR_AD_PUBLISH_YN"]
              )
          );
     }

     $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
     $form->accept($renderer);

     $smarty->assign('isEdit', ($isEdit) ? "true" : "false");
     $smarty->assign('property_info', $property_info);
     $smarty->assign('agreement_info', $agreement_info);
     $smarty->assign('unit_info', $unit_info);
     $smarty->assign('photos_list', $photo_list);
     $smarty->assign('form_data', $renderer->toArray());
 }
 else
 {

 /**
  * Tenant agreements details
  */
 require_once dirname(__FILE__)."/../classes/database/rnt_tenants.class.php";

 if (!defined("TENANT_AGREEMENT"))
 {
    define("TENANT_AGREEMENT", "1");
    define("UPDATE_ACTION", "UPDATE");
    define("DELETE_ACTION", "DELETE");
    define("INSERT_ACTION_AGREEMENT", "INSERT_AGREEMENT");
    define("INSERT_ACTION_TENANT", "INSERT_TENANT");
    define("DELETE_ACTION_TENANT", "DELETE_TENANT");
    define("CANCEL_ACTION", "CANCEL");
 }

 $form = new HTML_QuickForm('formAgr', 'POST');
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
 if (@$_REQUEST["FORM_ACTION"] == INSERT_ACTION_AGREEMENT)
   $action = INSERT_ACTION_AGREEMENT;
 else
 if (@$_REQUEST["FORM_ACTION"] == INSERT_ACTION_TENANT)
   $action = INSERT_ACTION_TENANT;
 else
 if (@$_REQUEST["delete_agr"])
   $action = DELETE_ACTION;
 else
   $action = UPDATE_ACTION;

 $isEdit = ( $smarty->user->isManager()
          || $smarty->user->isAdvertise()
          || $smarty->user->isManagerOwner());

 if (!$isEdit)
   $form->freeze();

 $currentPropertyID = $menu3->current_property_id;
 $currentAgreementID = @$_REQUEST["AGR_AGREEMENT_ID"];

 $dbAgr = new RNTAgreement($smarty->connection);
 $dbProp = new RNTProperties($smarty->connection);
 $dbTenant = new RNTTenants($smarty->connection);

 //-------------------- initial business unit
 $currentBUID = $dbProp->getBusinessUnit($currentPropertyID);
 Context::setBusinessID($currentBUID);
 //--------------

 // ---- initial current unit
 $unit_list = $dbProp->getPropertyUnitsList($currentPropertyID);
 $currentUnitID = @$_REQUEST["UNIT_ID"];

 // if selected agreement
 if (@$_POST["AGR_UNIT_ID"])
    $currentUnitID = @$_POST["AGR_UNIT_ID"];
 else
 if ($currentAgreementID)
 {
     $agr_data = $dbAgr->getAgreement($currentAgreementID);
     $currentUnitID = $agr_data["AGR_UNIT_ID"];
  }
  else
  if  (!$currentAgreementID && $currentUnitID)
  {}
  else
  {
      // select first unit name. Property always have one or more units
      $currentUnitID = $unit_list[0]["UNIT_UNIT_ID"];
   }
 // ---- end of initial current unit

 $is_exists = true;
 $row_order = 0;

 if ($action != INSERT_ACTION_AGREEMENT)
 {

     if (!$currentAgreementID)
        // Get first agreement from database for current property
       $form_data = $dbAgr->getFirstAgreementForUnit($currentUnitID);
     else
       $form_data = $dbAgr->getAgreement($currentAgreementID);
     if ($is_exists = count($form_data) > 0)
     {
       $currentAgreementID = $form_data["AGR_AGREEMENT_ID"];
       $dbAgr->setAgreementID($currentAgreementID);
     }

     $issues_list_exception = $dbAgr->getIssuesList($currentAgreementID);
     $issues_list = array();
     foreach($issues_list_exception as $v)
     {
          $de =  new DatabaseError($smarty->connection);
          $issues_list[] = $de->getErrorFromExceptionMessage($v);
     }
     $smarty->assign("issues_list", $issues_list);
 }


 if ($action == CANCEL_ACTION)
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->request_menu_level2."=".$menu->current_level2."&".$menu3->request_property_id."=".$menu3->current_property_id."&AGR_AGREEMENT_ID=".@$_REQUEST["AGR_AGR_ID_FOR_CANCEL"]."&UNIT_ID=".$currentUnitID);
    exit;
 }

 $form->registerRule('vdate', 'function', 'validateDate');
 $form->registerRule('vnumeric', 'function', 'validateNumeric');
 $form->registerRule('vinteger', 'function', 'validateInteger');

 // property_id for page menu level 3
 $form->AddElement("hidden", $menu3->request_property_id, $menu3->current_property_id);
 // menu 2 level
 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);

 $form->AddElement("hidden", "AGR_CHECKSUM");
 $form->AddElement("hidden", "AGR_AGREEMENT_ID");
 $form->AddElement("hidden", "AGR_ROW_NUM_IN_UNIT");
 $form->AddElement("hidden", "AGR_ROW_COUNT_IN_UNIT");
 $form->AddElement("hidden", "AGR_UNIT_ID", $currentUnitID);
 $form->AddElement("hidden", "FORM_ACTION", $action);
 $form->AddElement("hidden", "AGR_AGR_ID_FOR_CANCEL");

 $form->AddElement("text", "AGR_DATE_AVAILABLE", "Date available", array("size"=>11));
 $dates_elements[] = "AGR_DATE_AVAILABLE";
 $unit_info = $dbProp->getPropertyUnit($currentUnitID);
 $form->AddElement("text", "AGR_UNIT_NAME", "Unit", array("value"=>$unit_info["UNIT_UNIT_NAME"], "disabled"=>"disabled", "size"=>"12")/*$dbProp->getUnitsList($currentPropertyID)*/);
 $form->AddElement("text", "AGR_TERM", "Term (Month)", array("size"=>4));
 $form->AddElement("text", "AGR_AMOUNT", "Rent", array("size"=>8));
 $form->AddElement("select", "AGR_AMOUNT_PERIOD", "Rent Period", $dbAgr->getRentPeriodList());
 $form->AddElement("text", "AGR_DISCOUNT_AMOUNT", "Late Fee", array("size"=>8));
 $form->AddElement("text", "AGR_DISCOUNT_PERIOD", "Late Fee Period (days)", array("size"=>8));
 $form->AddElement("select", "AGR_DISCOUNT_TYPE", "Fee Type", $dbAgr->getFeeTypeList(false));
 $form->AddElement("text", "AGR_AGREEMENT_DATE", "Start Date", array("size"=>11));
 $dates_elements[] = "AGR_AGREEMENT_DATE";
 $form->AddElement("text", "AGR_END_DATE", "End Date", array("size"=>11));
 $dates_elements[] = "AGR_END_DATE";
 $form->AddElement("text", "AGR_DEPOSIT", "Deposit", array("size"=>10));
 $form->AddElement("text", "AGR_LAST_MONTH", "Last Month", array("size"=>10));


 if (!$IsPost && count(@$form_data) > 0)
 {
      $form_data["AGR_DATE_AVAILABLE"] = UtlConvert::dbDateToDisplay($form_data["AGR_DATE_AVAILABLE"]);
      $form_data["AGR_AGREEMENT_DATE"] = UtlConvert::dbDateToDisplay($form_data["AGR_AGREEMENT_DATE"]);
      $form_data["AGR_END_DATE"] = UtlConvert::dbDateToDisplay($form_data["AGR_END_DATE"]);
      $form_data["AGR_AMOUNT"]  =  UtlConvert::dbNumericToDisplay($form_data["AGR_AMOUNT"], 2);
      $form_data["AGR_DISCOUNT_AMOUNT"]  =  UtlConvert::dbNumericToDisplay($form_data["AGR_DISCOUNT_AMOUNT"], 2);
      $form_data["AGR_DEPOSIT"]  =  UtlConvert::dbNumericToDisplay($form_data["AGR_DEPOSIT"], 2);
      $form_data["AGR_LAST_MONTH"]  =  UtlConvert::dbNumericToDisplay($form_data["AGR_LAST_MONTH"], 2);
 }

 if (!$IsPost && ($action == INSERT_ACTION_AGREEMENT))
 {
      $form_data["AGR_AMOUNT_PERIOD"] = "MONTH";
      $form_data["AGR_DEPOSIT"] = "0.00";
      $form_data["AGR_LAST_MONTH"] = "0.00";
      $form_data["AGR_AGR_ID_FOR_CANCEL"] = $currentAgreementID;
 }

 // Apply filter for all data cells
 $form->applyFilter('__ALL__', 'trim');

  // Append rule REUIQRED
 $form->addRule('AGR_UNIT_ID', 'Please select a Unit from the list on the left of this page.', 'required');
// $form->addRule('AGR_AGREEMENT_DATE', 'Please set Agreement Date.', 'required');
 $form->addRule('AGR_TERM', 'Please enter Term of this agreement.', 'required');
 $form->addRule('AGR_AMOUNT', 'Please enter the Rent Amount.', 'required');
 $form->addRule('AGR_AMOUNT_PERIOD', 'Please enter the Rental Period.', 'required');
 $form->addRule('AGR_DATE_AVAILABLE', 'Please enter the date this property will become available.', 'required');
 // Append rule for NUMBERIC
 $form->addRule('AGR_TERM', 'Term must be a number.', 'vinteger');
 $form->addRule('AGR_DISCOUNT_PERIOD', "Late Fee Period must be a number.", 'vinteger');
 $form->addRule('AGR_AMOUNT', "Rent amount must be numeric.", 'vnumeric');
 $form->addRule('AGR_DEPOSIT', "Deposit amount must be numeric.", 'vnumeric');
 $form->addRule('AGR_LAST_MONTH', "Last Month amount must be numeric.", 'vnumeric');
 $form->addRule('AGR_DISCOUNT_AMOUNT', "Late Fee must be numeric.", 'vnumeric');
 // Append fule for DATE
 $form->addRule("AGR_AGREEMENT_DATE", UtlConvert::ErrorDateMsg, 'vdate');
 $form->addRule("AGR_DATE_AVAILABLE", UtlConvert::ErrorDateMsg, 'vdate');
 if ($isEdit)
 {
     $r = array();
     if (!$is_exists)
       $r["disabled"] = "disabled";
     $form->AddElement("submit", "accept", "Save", $r);
     $form->AddElement("submit", "cancel", "Cancel", $r);
     // if new agreement then disable "delete" button
     $r = array();
     if ($action == INSERT_ACTION_AGREEMENT || !$is_exists)
        $r["disabled"] = "disabled";
     $r["onclick"] = "return confirm('Delete agreement?')";
     $form->AddElement("submit", "delete_agr", "Delete", $r);
     $form->AddElement("submit", "new_agreement", "New vacancy");
     $r = array();
     if ($action == INSERT_ACTION_AGREEMENT || !$is_exists)
        $r["disabled"] = "disabled";
     $form->addElement("submit", "add_tenant", "Add tenant", $r);
 }

 $r_prev = array("disabled" => "disabled");
 $r_next = array("disabled" => "disabled");

 if ($currentAgreementID)
 {
    if ($dbAgr->isHasPrev())
       $r_prev = array();
    if ($dbAgr->isHasNext())
       $r_next = array();
 }

 $form->AddElement("submit", "prev_agreement", "Prev", $r_prev);
 $form->AddElement("submit", "next_agreement", "Next", $r_next);

 $tenantLovData = new LovData("tenantLovData", $dbTenant->getPeopleList($currentBUID));
 $section8LovData = new LovData("section8LovData", $dbTenant->getSection8List($currentBUID));

 // ----------- code for tenants
 // query agreement tenants
 if ($action != INSERT_ACTION_AGREEMENT)
 {
    $tenant_list = array();
    if ($IsPost)
      $tenant_list = $_POST["TENANTS"];
    else
    {
      $tenant_list = $dbTenant->getShortList($currentAgreementID);
      $form_data["TENANTS"] = $tenant_list;
    }

    if (!$IsPost && $action == INSERT_ACTION_TENANT)
      $tenant_list[] = array("TENANT_AGREEMENT_ID"=>$currentAgreementID);

    for($i=0; $i < count($tenant_list); $i++)
    {
        $form->addElement("select", "TENANTS[$i][TENANT_PEOPLE_ID]", "Tenant Name", $dbTenant->getPeopleList($currentBUID));
        /*
        $form->AddElement("lov", "TENANTS[$i][TENANT_PEOPLE_ID]", "Tenant Name", array(),
               array("nameCode"=>"TENANTS[$i][TENANT_PEOPLE_ID__CODE]",
                     "imagePath"=>$GLOBALS["PATH_FORM_ROOT"]."images/lov.gif", "sizeCode"=>20), $tenantLovData);
       */
        $form->addElement("select", "TENANTS[$i][TENANT_STATUS]", "Tenant Status", $dbTenant->getStatusList(), array("onchange"=>"changeStatusTenant(this)"));

        $form->addElement("text", "TENANTS[$i][TENANT_DEPOSIT_BALANCE]", "", array("size"=>6));
        $form->addElement("text", "TENANTS[$i][TENANT_LAST_MONTH_BALANCE]", "", array("size"=>6));
        $form->addElement("select", "TENANTS[$i][TENANT_SECTION8_ID]", "Section8 Office", $dbTenant->getSection8List($currentBUID));
        /*
        $form->AddElement("lov", "TENANTS[$i][TENANT_SECTION8_ID]", "Section8 Office", array(),
               array("nameCode"=>"TENANTS[$i][TENANT_SECTION8_ID__CODE]",
                     "imagePath"=>$GLOBALS["PATH_FORM_ROOT"]."images/lov.gif", "sizeCode"=>15), $section8LovData);
*/
//        $form->addElement("text", "TENANTS[$i][TENANT_SECTION8_VOUCHER_AMOUNT]", "", array("size"=>6));
        $form->addElement("text", "TENANTS[$i][TENANT_SECTION8_TENANT_PAYS]", "", array("size"=>6));

        $form->addElement("hidden", "TENANTS[$i][TENANT_TENANT_ID]");
        $form->addElement("hidden", "TENANTS[$i][TENANT_AGREEMENT_ID]");
        $form->addElement("hidden", "TENANTS[$i][TENANT_CHECKSUM]");
        if (@$tenant_list[$i]["TENANT_TENANT_ID"])
        {
            $form->addElement('link',   "TENANTS[$i][TENANT_TENANT_ID_NOTE]", "note",
                          "?".$menu3->getParams()."&m2=tenant_tenants".
                           "&TENANT_ID=".$tenant_list[$i]["TENANT_TENANT_ID"], "View/Add note");
            if($isEdit)
                $form->addElement('link',   "TENANTS[$i][TENANT_TENANT_ID_LINK]", "delete",
                              "?".$menu3->getParams()."&".$menu->getParam2().
                               "&action=delete_tenant&TENANT_ID=".$tenant_list[$i]["TENANT_TENANT_ID"].
                               "&AGR_AGREEMENT_ID=".$currentAgreementID, $smarty->deleteImage, $smarty->deleteAttr);
         }
        // Append rule REUIQRED
         $form->addRule("TENANTS[$i][TENANT_DEPOSIT_BALANCE]", 'Deposit Balance require value.', 'required');
         $form->addRule("TENANTS[$i][TENANT_LAST_MONTH_BALANCE]", 'Last Month Balance require value.', 'required');
         $form->addRule("TENANTS[$i][TENANT_PEOPLE_ID]", 'Tenant name require value.', 'required');
         // Append rule for NUMBERIC
         $form->addRule("TENANTS[$i][TENANT_DEPOSIT_BALANCE]", "Must be numeric.", 'vnumeric');
         $form->addRule("TENANTS[$i][TENANT_LAST_MONTH_BALANCE]", "Must be numeric.", 'vnumeric');
//         $form->addRule("TENANTS[$i][TENANT_SECTION8_VOUCHER_AMOUNT]", "Must be numeric.", 'vnumeric');
         $form->addRule("TENANTS[$i][TENANT_SECTION8_TENANT_PAYS]", "Must be numeric.", 'vnumeric');

        // correct values
        if (@$tenant_list[$i]["TENANT_TENANT_ID"])
        {

           $nums = array("TENANT_DEPOSIT_BALANCE", "TENANT_LAST_MONTH_BALANCE",
                         "TENANT_SECTION8_TENANT_PAYS");
           foreach($nums as $v)
             $tenant_list[$i][$v] = UtlConvert::dbNumericToDisplay($tenant_list[$i][$v]);
        }

    } // --- for($i=0;...

     // inital data for form
     foreach($tenant_list as $k1=>$v1)
       foreach($v1 as $k2=>$v2)
          $form_data["TENANTS[$k1][$k2]"] = $v2;
 }

 if (!$IsPost)
    $form->setDefaults(@$form_data);

 if ((($IsPost && $form->validate()) || $action == DELETE_ACTION || $action == DELETE_ACTION_TENANT) && ($isEdit)) {

    // save form to database
    $values = $form->getSubmitValues();
    $newID = -1;
    $IsError = 0;
    try
    {

        if ($action == DELETE_ACTION)
           $dbAgr->Delete($currentAgreementID);
        else
        if ($action == DELETE_ACTION_TENANT)
        {
           $dbTenant->Delete($deleteTenantID);
        }
        else
        if ($action == UPDATE_ACTION)
        {
           $dbAgr->Update($values);
           $dbTenant->updateTenants($values);
        }
        else
        if ($action == INSERT_ACTION_AGREEMENT)
           $newID = $dbAgr->Insert($values);
        else
        if ($action == INSERT_ACTION_TENANT)
        {
           $dbAgr->Update($values);
           $dbTenant->updateTenants($values);
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
          /*
          print_r($de);
          print_r(get_class_methods('Exception'));
          print_r($e->getMessage());
          print_r($e->getTraceAsString());
          */
          $smarty->assign("errorObj", $de->getErrorFromException($e));
    }

    // redirect to page
    if (!$IsError)
    {
       $s = "Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->request_menu_level2."=".$menu->current_level2."&".$menu3->request_property_id."=".$menu3->current_property_id;
       if ($action == INSERT_ACTION_AGREEMENT)
           $currentAgreementID = $newID;

       if ($action == DELETE_ACTION)
          header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&".$menu3->getParams());
       else
       if (@$_REQUEST["new_agreement"])
          header($s."&AGR_AGREEMENT_ID=".$currentAgreementID.'&FORM_ACTION='.INSERT_ACTION_AGREEMENT."&UNIT_ID=".$currentUnitID);
       else
       if (@$_REQUEST["add_tenant"])
          header($s."&AGR_AGREEMENT_ID=".$currentAgreementID.'&FORM_ACTION='.INSERT_ACTION_TENANT."&UNIT_ID=".$currentUnitID);
       else
       if (@$_REQUEST["prev_agreement"])
          header($s."&AGR_AGREEMENT_ID=".$dbAgr->getPrevID().'&FORM_ACTION='.UPDATE_ACTION."&UNIT_ID=".$currentUnitID);
       else
       if (@$_REQUEST["next_agreement"])
          header($s."&AGR_AGREEMENT_ID=".$dbAgr->getNextID().'&FORM_ACTION='.UPDATE_ACTION."&UNIT_ID=".$currentUnitID);
       else
          header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->request_menu_level2."=".$menu->current_level2."&".$menu3->request_property_id."=".$menu3->current_property_id."&AGR_AGREEMENT_ID=".$currentAgreementID.'&FORM_ACTION='.UPDATE_ACTION);
       exit;
    }
 }

  if (@$_REQUEST["new_agreement"])
  {
     header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->request_menu_level2."=".$menu->current_level2."&".$menu3->request_property_id."=".$menu3->current_property_id."&AGR_AGREEMENT_ID=".$currentAgreementID.'&FORM_ACTION='.INSERT_ACTION_AGREEMENT."&UNIT_ID=".$currentUnitID);
     exit;
 }

 if (!$isEdit)
 {
    $s = "Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->request_menu_level2."=".$menu->current_level2."&".$menu3->request_property_id."=".$menu3->current_property_id;
    if (@$_REQUEST["prev_agreement"])
    {
      header($s."&AGR_AGREEMENT_ID=".$dbAgr->getPrevID());
      exit;
    }
    else
    if (@$_REQUEST["next_agreement"])
    {
       header($s."&AGR_AGREEMENT_ID=".$dbAgr->getNextID());
       exit;
    }
 }

 $property_data = $dbProp->getProperty($menu3->current_property_id);


 $header_title = @$property_data["PROP_ADDRESS1"]." (Unit : ".$unit_info["UNIT_UNIT_NAME"].") - Tenancy Agreements";
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
 $smarty->assign("isEdit", $isEdit ? "true" : "false");
 $smarty->assign('is_exists', $is_exists);
 $smarty->assign("header_title", $header_title);
 $smarty->assign("unit_list", $unit_list);
 $smarty->assign("currentUnitID", $currentUnitID);
 $smarty->assign("script", $tenantLovData->display().$section8LovData->display());


}


 $adv_href = $href . '&type=advertise'
               . '&PropertyId='.$currentPropertyID
               . '&AgreementId='.$currentAgreementID
               . '&UnitId='.$currentUnitID;

 $x = " class='current' ";
 $smarty->assign("additional_menu3_items",
                 "<li><a href='$href' ".($skey == 0 ? $x : "")."id='agr'>Details</a></li>"
               . "<li><a href='$adv_href' ".($skey == 1 ? $x : "")."id='adv'>Advertise</a></li>"
 );


 // Next/Prior for advertising
 $adv_mouseover = "onmouseover=\"formAgr.submit();\"";

 if (($agreement_info["AGR_AD_PUBLISH_YN"]) == "N")
     { $advertise_view_onclick	 =
                          "onclick=\"var result=false;"
                          ." if (confirm('The publish flag is not set. Do you want to continue?'))"
                          ." {"
                          ."     result = true; "
                          ." }"
                          ." return result;\"";
													}
  else{$advertise_view_onclick = "";}


 $smarty->assign("advertise_prev",
                 "<a href='?m2=ad_property_details&type=map' style='float: left;' $adv_mouseover>Previous Page - Upload Photos</a>");
 $smarty->assign("advertise_next",
                 "<a href='$adv_href' ".($skey == 1 ? $x : "")."id='adv' style='float: right;' $adv_mouseover>
								 Next Page - Add Description and Publish</a>");
 $smarty->assign("advertise_home",
                 "<a href='$href' ".($skey == 0 ? $x : "")."id='agr' style='float: left;'>
								 Previous Page - Agreement Details</a>");
 $smarty->assign("advertise_view",
                 "<a href='$HTTP_PATH_FROM_ROOT/rental/visulate_search.php?REPORT_CODE=RENTALS&agreement=$currentAgreementID' style='float: right;' target=\"_blank\" $advertise_view_onclick>
								 Next Page - View Listing</a>");


?>
