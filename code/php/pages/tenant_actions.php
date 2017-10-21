<?
 require_once dirname(__FILE__)."/../classes/database/rnt_properties.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_agreement.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_tenants.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once dirname(__FILE__)."/../ckeditor/ckeditor.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";
 
 
 $mobile_device = Context::getMobileDevice();
 if ($mobile_device)
  {   
	 $template_name = "mobile-tenant_actions.tpl";
  }
	 
 
  if (! ( $smarty->user->isOwner() 
	     || $smarty->user->isManager() 
			 || $smarty->user->isManagerOwner() 
			 || $smarty->user->isBookkeeping() 
			 || $smarty->user->isBusinessOwner()))
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
    exit;
 }

 $isEdit = ($smarty->user->isManager() || $smarty->user->isManagerOwner());

 if (!defined("TENANT_ACTIONS"))
 {
    define("TENANT_ACTIONS", "1");
    define("UPDATE_ACTION", "UPDATE");
    define("DELETE_ACTION", "DELETE");
    define("INSERT_ACTION", "INSERT");
    define("CANCEL_ACTION", "CANCEL");
 }

 $form = new HTML_QuickForm('formAction', 'POST');
 

 $IsPost = $form->isSubmitted();
 $action = UPDATE_ACTION;
 $currentActionID = @$_REQUEST["ACTION_ID"];
 $dates_elements = array();
 if (@$_POST["cancel"])
   $action = CANCEL_ACTION;
 else if (@$_REQUEST["action"] == "delete")
  $action = DELETE_ACTION;
 else if (@$_REQUEST["action"] == "create" || @$_REQUEST["FORM_ACTION"] == "INSERT")
  {
  $action = INSERT_ACTION;
  $template_id = @$_REQUEST["TEMPLATE"];
  }
 else
  $action = UPDATE_ACTION;

 if (!$isEdit)
   $form->freeze();

 $currentPropertyID = $menu3->current_property_id;
 $currentAgreementID = @$_REQUEST["AGREEMENT_ID"];
 

 $dbAgr = new RNTAgreement($smarty->connection);
 $dbProp = new RNTProperties($smarty->connection);
 $dbTenant = new RNTTenants($smarty->connection);

 $property_data = $dbProp->getProperty($menu3->current_property_id);
 $form->addElement("select", "TEMPLATE", "", $dbAgr->getTemplateList($currentPropertyID));
 $is_exists = true;
 $row_order = 0;

 // ---- initial current unit
 $unit_list = $dbProp->getPropertyUnitsList($currentPropertyID);
 $currentUnitID = @$_REQUEST["UNIT_ID"];
 // if selected agreemnt
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

 $agrData = array();
 if (!$currentAgreementID)
      // Get first agreement from database for current property
     $agrData = $dbAgr->getFirstAgreementForUnit($currentUnitID);
 else
     $agrData = $dbAgr->getAgreement($currentAgreementID);

 if (($is_agreement_exists = count($agrData)) > 0)
 {
    $currentAgreementID = $agrData["AGR_AGREEMENT_ID"];
    $dbAgr->setAgreementID($currentAgreementID);
 }


  if (@$_REQUEST["s_new_action"])
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2().
		                  "&".$menu3->getParams().
											"&AGREEMENT_ID=".$_REQUEST["AGREEMENT_ID"].
											"&TEMPLATE=".$_REQUEST["TEMPLATE"].
											"&action=create");			
    exit;
 }

  if (@$_REQUEST["s_prev_agreement"])
  {
      header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&".$menu3->getParams()."&AGREEMENT_ID=".$dbAgr->getPrevID().'&FORM_ACTION='.UPDATE_ACTION."&UNIT_ID=".$currentUnitID);
      exit;
  }

  if (@$_REQUEST["s_next_agreement"])
  {
      header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&".$menu3->getParams()."&AGREEMENT_ID=".$dbAgr->getNextID().'&FORM_ACTION='.UPDATE_ACTION."&UNIT_ID=".$currentUnitID);
      exit;
  }

 if ($action == CANCEL_ACTION)
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&".$menu3->getParams()."&AGR_AGREEMENT_ID=".$currentAgreementID);
    exit;
 }

 if ($is_agreement_exists)
 {
 
     $agr_start   = UtlConvert::dbDateToDisplay($agrData["AGR_AGREEMENT_DATE"]);
     $agr_end     = UtlConvert::dbDateToDisplay($agrData["AGR_END_DATE"]);
     $agr_deposit = UtlConvert::dbNumericToDisplay($agrData["AGR_DEPOSIT"]);
     $agr_last    = UtlConvert::dbNumericToDisplay($agrData["AGR_LAST_MONTH"]);
     $agr_rent    = UtlConvert::dbNumericToDisplay($agrData["AGR_AMOUNT"]);
     $agr_term    = $agrData["AGR_TERM"];
     $agr_period  = $agrData["AGR_AMOUNTH_PERIOD_NAME"];
     $agr_latefee = UtlConvert::dbNumericToDisplay($agrData["AGR_DISCOUNT_AMOUNT"]);
     $agr_late_period = $agrData["AGR_DISCOUNT_PERIOD"];

     $agrDataDisplay = array(
        array("name"=>"Date Available", "value" => UtlConvert::dbDateToDisplay($agrData["AGR_DATE_AVAILABLE"])),
        array("name"=>"Unit",                   "value" => $agrData["AGR_UNIT_NAME"]),
        array("name"=>"Term (".$agr_period.")", "value" => $agr_term),
        array("name"=>"Rent",                   "value" => $agr_rent),
        array("name"=>"Rent period",            "value" => $agr_period),
        array("name"=>"Late Fee/Discount",      "value" => $agr_latefee),
        array("name"=>"Grace Period",           "value" => $agr_late_period),
        array("name"=>"Fee Type",               "value" => $agrData["AGR_DISCOUNT_TYPE_NAME"]),
        array("name"=>"Agreement Date",         "value" => $agr_start),
        array("name"=>"End Date",               "value" => $agr_end),
        array("name"=>"Deposit",                "value" => $agr_deposit),
        array("name"=>"Last Month",             "value" => $agr_last)
      );


     $tenantList = $dbAgr->getTenantList4Action($currentAgreementID);
     foreach($tenantList as &$v)
     {
        $v["ARREAR_AMOUNT"] = UtlConvert::dbNumericToDisplay($v["ARREAR_AMOUNT"]);
        $v["DEPOSIT_BALANCE"] = UtlConvert::dbNumericToDisplay($v["DEPOSIT_BALANCE"]);
        $v["LAST_MONTH_BALANCE"] = UtlConvert::dbNumericToDisplay($v["LAST_MONTH_BALANCE"]);
        
        $tenant_name = $v["TENANT_NAME"];
        $unpaid_balance = $v["ARREAR_AMOUNT"];
     }
     unset($v);
     $TenantRunningTotal  = $dbAgr->getTenantRunningTotal($currentAgreementID);
     foreach($TenantRunningTotal as &$v)
     {
        $v["START_DATE"] = UtlConvert::dbDateToDisplay($v["START_DATE"]);
        $v["PAYMENT_DATE"] = UtlConvert::dbDateToDisplay($v["PAYMENT_DATE"]);
        $v["ARREARS"] = UtlConvert::dbNumericToDisplay($v["ARREARS"]);
        $v["ALLOCATED_AMOUNT"] = UtlConvert::dbNumericToDisplay($v["ALLOCATED_AMOUNT"]);
        $v["DUE_AMOUNT"] = UtlConvert::dbNumericToDisplay($v["DUE_AMOUNT"]);
        
     }
     unset($v);

     $actionList = $dbAgr->getActionList($currentAgreementID);
     foreach($actionList as &$v){
        $v["ACTION_DATE"] = UtlConvert::dbDateToDisplay($v["ACTION_DATE"]);
        $v["ACTION_COST"] = UtlConvert::dbNumericToDisplay($v["ACTION_COST"]);
        if ($isEdit)
        {
            $v["DELETE_LINK"] = '<a href="?'.$menu->getParam2()."&".$menu3->getParams().
                                "&AGREEMENT_ID=".$currentAgreementID.'&ACTION_ID='.$v["ACTION_ID"].
                                '&action=delete" onclick="'.$smarty->deleteAttr["onclick"].'">'.$smarty->deleteImage."</a>";
            $v["EDIT_LINK"] = '<a href="?'.$menu->getParam2()."&".$menu3->getParams().
                                "&AGREEMENT_ID=".$currentAgreementID.'&ACTION_ID='.$v["ACTION_ID"].
                                '&action=edit">edit</a>';
         }
     }
     

     
     if ($action == INSERT_ACTION)
       array_unshift($actionList, array("ACTION_ID"=> -1));

     $form->registerRule('vdate', 'function', 'validateDate');
     $form->registerRule('vnumeric', 'function', 'validateNumeric');
     $form->registerRule('vinteger', 'function', 'validateInteger');

     if (($currentActionID || $action == INSERT_ACTION) )
     {

          // property_id for page menu level 3
         $form->AddElement("hidden", $menu3->request_property_id, $menu3->current_property_id);
         // menu 2 level
         $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
         $form->AddElement("hidden", "FORM_ACTION", $action);
         $form_data = $dbAgr->getActionData($currentActionID);

         
         $a_id = @$form_data["ACTION_ID"];
         if ($action == INSERT_ACTION)
            $a_id = -1;
         $form->addElement("hidden", "ACTION_ID", $a_id);
         $form->addElement("hidden", "CHECKSUM", @$form_data["CHECKSUM"]);
         $agr_id = @$form_data["AGREEMENT_ID"];

         $comments = @$form_data["COMMENTS"];

         date_default_timezone_set('America/New_York');
         $today = date("m/d/Y");
         
         if ($action == INSERT_ACTION)
            $agr_id = $currentAgreementID;
            
         if ($template_id > 0 )
         {
           $comments = $dbAgr->getTemplateText($template_id);
           $comments = str_replace("{{SYSDATE}}",   $today, $comments);
           $comments = str_replace("{{TENANT}}",    $tenant_name, $comments);
           $comments = str_replace("{{START}}",     $agr_start, $comments);
           $comments = str_replace("{{END}}",       $agr_end, $comments);
           $comments = str_replace("{{RENT}}",      $agr_rent, $comments);
           $comments = str_replace("{{SECURITY}}",  $agr_deposit, $comments);
           $comments = str_replace("{{LAST}}",      $agr_last, $comments);
           $comments = str_replace("{{TERM}}",      $agr_term, $comments);
           $comments = str_replace("{{PERIOD}}",    $agr_period, $comments);
           $comments = str_replace("{{LATE_FEE}}",  $agr_latefee, $comments);
           $comments = str_replace("{{LF_PERIOD}}", $agr_late_period, $comments);
           $comments = str_replace("{{UNPAID}}", '$'.$unpaid_balance, $comments);
           $comments = str_replace("{{ADDRESS}}", $property_data["PROP_ADDRESS1"], $comments);
           $comments = str_replace("{{CITY}}",    $property_data["PROP_CITY"], $comments);
           $comments = str_replace("{{STATE}}",   $property_data["PROP_STATE"], $comments);
           $comments = str_replace("{{ZIP}}",     $property_data["PROP_ZIPCODE"], $comments);
         }



 // ------ CKEditor
 $sBasePath  = $GLOBALS["PATH_FORM_ROOT"]."ckeditor/";
 $oCKeditor = new CKeditor() ;
  $cke_config = array();

	$cke_config['toolbar'] = array(
	     array( 'Source', '-','Print', 'Preview' ),
	     array( 'Cut','Copy','Paste','PasteText','PasteFromWord','-', 'SpellChecker', 'Scayt' ),
	     array( 'Undo','Redo','-','Find','Replace' ),
//	     array( 'Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField' ),	     
	     array( 'Bold','Italic', 'Underline','Strike','-','Subscript','Superscript', 'TextColor' ),   
	     array( 'NumberedList','BulletedList','-','Outdent','Indent' ),	     
	     array( 'JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock' )	,     
	     array( 'Link','Unlink','Anchor' ),	
			 array( 'Image','Flash','Table', 'SpecialChar' ),
			 array( 'Format','Font','FontSize' )
	     
	 );
	 
	$cke_config['height'] = 512;
  $oCKeditor->basePath   = $sBasePath;
  $smarty->assign("ckEditor", $oCKeditor);
 // ------ end of CKEditor
         
         $form->AddElement("hidden", "AGREEMENT_ID", $agr_id);
         $form->AddElement("text", "ACTION_DATE", "", array("size"=>8));
         $dates_elements[] = "ACTION_DATE";

         $form->AddElement("select", "ACTION_TYPE", "", $dbAgr->getActionTypes());
         $form->AddElement("text", "ACTION_COST", "", array("size"=>"10"));
         $form->AddElement("advcheckbox", "RECOVERABLE_YN", "", "", array("N", "Y"));

         $form->AddElement("submit", "accept", "Save");
         $form->AddElement("submit", "cancel", "Cancel");

         $form->addRule('ACTION_DATE', 'Field required.', 'required');
         $form->addRule('ACTION_COST', 'Field required.', 'required');
         // Append rule for NUMBERIC
         $form->addRule('ACTION_COST', "Must be numeric.", 'vnumeric');
         // Append fule for DATE
         $form->addRule("ACTION_DATE", UtlConvert::ErrorDateMsg, 'vdate');
         
         $form->setDefaults(array('ACTION_DATE'=>$today, 'ACTION_COST'=>'0'));

         if (!$IsPost && $action != INSERT_ACTION)
         {
            $form_data["ACTION_DATE"] = UtlConvert::dbDateToDisplay($form_data["ACTION_DATE"]);
            $form_data["ACTION_COST"] = UtlConvert::dbNumericToDisplay($form_data["ACTION_COST"]);
            $form_data["RECOVERABLE_YN"] = ($form_data["RECOVERABLE_YN"] == 'Y');
         }

        // Apply filter for all data cells
        $form->applyFilter('__ALL__', 'trim');
           		
     }

     if (!$IsPost){
        $form->setDefaults(@$form_data);
      }
		   
			 //$form_data["COMMENTS"]; 
     if ((($IsPost && $form->validate()) || $action == DELETE_ACTION) && ($isEdit )) {
        // save form to database
        $values = $form->getSubmitValues();
        $newID = -1;
        $IsError = 0;
        try
        {
            if ($action == DELETE_ACTION)
               $dbAgr->DeleteAction($currentActionID);
            else
            if ($action == UPDATE_ACTION)
               $dbAgr->UpdateAction($values);
            else if ($action == INSERT_ACTION)
               $dbAgr->InsertAction($values);
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
             if ($action == DELETE_ACTION || $action == INSERT_ACTION || $action == UPDATE_ACTION)
             {
                header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&".$menu3->getParams()."&AGREEMENT_ID=".$currentAgreementID);
                exit;
             }
        }

     }
		 else
		 { 
		  if ($_POST["COMMENTS"])
		    $oCKeditor->Value  = ($_POST["COMMENTS"]);
//	      $oFCKeditor->Value  = ($_POST["COMMENTS"]);
		 }// ---- end if ((($IsPost && $form->validate()) 

      $r_prev = array("disabled" => "disabled");
      $r_next = array("disabled" => "disabled");

      if ($currentAgreementID)
      {
         if ($dbAgr->isHasPrev())
               $smarty->assign("prev_agreement", "Prev");
         if ($dbAgr->isHasNext())
               $smarty->assign("next_agreement", "Next");

      }



 } // ---- if $is_agrmeement_exists

 $header_title = @$property_data["PROP_ADDRESS1"]." - Agreement Actions";
 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);
 //$template_form->accept($renderer);

 // is owner we not display calendar buttons
 if (!$isEdit)
    $dates_elements = array();

 $smarty->assign("dates", $dates_elements);

 // send form data to Smarty
 $smarty->assign('action', $action);
 $smarty->assign('form_data', $renderer->toArray());

 $smarty->assign('agrData', @$agrDataDisplay);
 $smarty->assign("cke_config", $cke_config);
 $smarty->assign("comments", $comments);
 $smarty->assign('tenantList', @$tenantList);
 $smarty->assign('actionList', @$actionList);
 $smarty->assign('currentActionID',  $currentActionID);
 if ($action == INSERT_ACTION)
     $smarty->assign('currentActionID',  -1);
 $smarty->assign('href_for_add', $GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&".$menu3->getParams()."&AGREEMENT_ID=".$currentAgreementID."&action=create");
 $smarty->assign("hidden_fields", "<input type=\"hidden\" name=\"".$menu->request_menu_level2."\" value=\"".$menu->current_level2."\">".
                                  "<input type=\"hidden\" name=\"".$menu3->request_property_id."\" value=\"".$menu3->current_property_id."\">".
                                  "<input type=\"hidden\" name=\"AGREEMENT_ID\" value=\"".$currentAgreementID."\">");
 $smarty->assign("isEdit", $isEdit ? "true" : "false");
 $smarty->assign('is_exists', $is_agreement_exists ? "true" : "false");
 $smarty->assign("header_title", $header_title);
 $smarty->assign("unit_list", $unit_list);
 $smarty->assign("currentUnitID", $currentUnitID);
 $smarty->assign("PATH_FROM_ROOT", $GLOBALS["PATH_FORM_ROOT"]);
 $smarty->assign("TenantRunningTotal", @$TenantRunningTotal);
?>