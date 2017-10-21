<?php
    require_once dirname(__FILE__).'/../classes/database/rnt_supplier.class.php';
    require_once dirname(__FILE__).'/../classes/UtlConvert.class.php';
    require_once dirname(__FILE__).'/../classes/SQLExceptionMessage.class.php';
    require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";
    require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
    require_once 'HTML/QuickForm.php';

    function setForm(&$form, $form_data, $form_action, $date_elements, $currentBUID, $filter)
     {
        global $menu;
        global $menu3;
        global $smarty;
        global $dbSupplier;
        global $currentSupplierID;
        global $isEdit;

        $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
        $form->AddElement("hidden", "SUPPLIER_ID");
        $form->AddElement("hidden", "FORM_ACTION", $form_action);
        $form->AddElement("hidden", "BUSINESS_ID", $currentBUID);
        $form->AddElement("hidden", "CHECKSUM");
        $form->AddElement("text", "searchFilter", "Filter List:", array("value" => $filter, "title" =>'Use "%" for any symbol.'));
        $form->AddElement("text", "NAME", "Name", array("size"=>20,"style"=>"width:195px;"));
        $form->AddElement("text", "PHONE1", "Primary Phone", array("size"=>20,"style"=>"width:195px;"));
        $form->AddElement("text", "PHONE2", "Secondary Phone", array("size"=>20,"style"=>"width:206px;"));
        $form->AddElement("text", "ADDRESS1", "Primary Address", array("size"=>30));
        $form->AddElement("text", "ADDRESS2", "Secondary Address", array("size"=>30));
        $form->AddElement("text", "CITY", "City", array("size"=>20,"style"=>"width:206px;"));
//        $form->AddElement("select", "STATE", "State", $dbSupplier->getStatesList(),array("style"=>"width:206px;"));
        global $StatesLovData;
        $StatesLovData = new LovData("dataStates", $dbSupplier->getStatesList());
        $form->AddElement("lov", "STATE", "State", array(),
          array("nameCode"=>"STATE__CODE",
                "imagePath"=>$GLOBALS["PATH_FORM_ROOT"]."images/lov.gif", "sizeCode"=>20), $StatesLovData);

        $form->AddElement("text", "ZIPCODE", "ZIP code", array("style"=>"width:206px;"));
        $form->AddElement("text", "EMAIL_ADDRESS", "E-mail", array("size"=>25,"style"=>"width:206px;"));
        $form->AddElement("select", "SUPPLIER_TYPE_ID", "Type", $dbSupplier->getSupplierTypes());
        $form->AddElement("textarea", "COMMENTS", "Comments", array("size"=>200,"style"=>"width:206px;"));
        // rule for validate
        $form->addRule("NAME", "set Name", 'required');
        $form->addRule("PHONE1", "set Primary phone",'required');
        $form->addRule("EMAIL_ADDRESS", "E-mail is a not valid e-mail address","email");

        /// ---- Business units for supplier
        $bus = $form_data["BUSINESS_UNITS"];
        $cnt = count($bus);
        for($i = 0; $i < $cnt; $i++)
        {
            $form->AddElement("hidden", "BUSINESS_UNITS[$i][BU_SUPPLIER_ID]");
            $form->AddElement("hidden", "BUSINESS_UNITS[$i][SUPPLIER_ID]");
            $form->AddElement("hidden", "BUSINESS_UNITS[$i][CHECKSUM]");
            //$form->AddElement("select", "BUSINESS_UNITS[$i][BUSINESS_ID]", "Business ", $dbSupplier->getBusinessUnitsList());
            global $BusinessUnitsLovData;
            $BusinessUnitsLovData = new LovData("dataBUs", $dbSupplier->getBusinessUnitsList());
            $form->AddElement("lov", "BUSINESS_UNITS[$i][BUSINESS_ID]", "Business", array(),
                 array("nameCode"=>"BUSINESS_UNITS[$i][BUSINESS_ID__CODE]",
                   "imagePath"=>$GLOBALS["PATH_FORM_ROOT"]."images/lov.gif", "sizeCode"=>20), $BusinessUnitsLovData);

            $form->AddElement("text", "BUSINESS_UNITS[$i][TAX_IDENTIFIER]", "Tax", array("size"=>"14"));
            $form->AddElement("textarea", "BUSINESS_UNITS[$i][NOTES]", "Notes");
            if (@$bus[$i]["BU_SUPPLIER_ID"] && $isEdit)
                    $form->AddElement("link", "BUSINESS_UNITS[$i][DELETE_LINK]", "delete",
                              "?".$menu3->getParams()."&".$menu->getParam2()."&delete_bu=true&BUSINESS_ID=".$currentBUID."&SUPPLIER_ID=".$currentSupplierID."&BU_SUPPLIER_ID=".$bus[$i]["BU_SUPPLIER_ID"],
                              $smarty->deleteImage, $smarty->deleteAttr);
        }
        $form->AddElement("submit", "new_bu", "New");
        // --- end of business units for supplier

        // Apply filter for all data cells
        $form->applyFilter('__ALL__', 'trim');
        $r = array("onclick" => "return confirm('Delete this record?');");
        if($form_action == INSERT_ACTION)
            $r = array("disabled");
        $form->AddElement("submit", "delete", "Delete", $r);
        $form->AddElement("submit", "new", "New");
        $form->AddElement("submit", "cancel", "Cancel");
        $form->AddElement("submit", "accept", "Save");
    } // --- function setForm($form, $size)

 function IDinList($array, $id)
 {
    foreach($array as $v)
        if ($v["SUPPLIER_ID"] == $id)
           return true;
    return false;
 }

 if (!($smarty->user->isManager() 
    || $smarty->user->isManagerOwner() 
		|| $smarty->user->isBusinessOwner() 
		|| $smarty->user->isOwner() 
		|| $smarty->user->isBuyer()
		|| $smarty->user->isBookKeeping()))
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
    exit;
 }


 if (!defined("SUPPLIES"))
 {
     define("SUPPLIES", "1");
     define("UPDATE_ACTION", "UPDATE");
     define("DELETE_ACTION", "DELETE");
     define("INSERT_ACTION", "INSERT");
     define("CANCEL_ACTION", "CANCEL");
     define("INSERT_BUSINESS_UNIT", "INSERT_BUSINESS_UNIT");
     define("DELETE_BUSINESS_UNIT", "DELETE_BUSINESS_UNIT");
 }

 $dbSupplier = new RNTSupplier($smarty->connection);
 // business units
 $dbBU = new RNTBusinessUnit($smarty->connection);
// $buList = $dbBU->getBusinessUnits2();
 $buList = $dbBU->getBusinessUnitsLevel2();
 $currentBUID = @$_REQUEST["BUSINESS_ID"];
 $currentSupplierID = @$_REQUEST["SUPPLIER_ID"];

 if (!$currentBUID){
   if ($currentSupplierID){
     // try to get BU for supplier
     $bb = $dbSupplier->getSupplierBusinessUnits($currentSupplierID);
     if (count($bb) > 0)
        $currentBUID = $bb[0]["BUSINESS_ID"];
   }

   if (!$currentBUID)
       $currentBUID = @$buList[0]["BUSINESS_ID"];
 }

 $filter = trim(@$_REQUEST["searchFilter"]);
 foreach($buList as $k=>$v)
 {
    $buList[$k]["SUPPLIERS"] = array();
    if ($filter)
      $supplierList = $dbSupplier->getListByFilter($v["BUSINESS_ID"], $filter);
    else
      $supplierList = $dbSupplier->getList($v["BUSINESS_ID"]);
    foreach($supplierList as $k1=>$v1)
        $buList[$k]["SUPPLIERS"][] = array("SUPPLIER_ID"=>$v1["SUPPLIER_ID"], "SUPPLIER_NAME"=>$v1["NAME"], "PHONE1"=>$v1["PHONE1"] );
 }

 $StatesLovData = null;
 $BusinessUnitsLovData = null;
 $supplierList = $dbSupplier->getList($currentBUID);
 $isEdit = ($smarty->user->isManager() 
          || $smarty->user->isManagerOwner() 
					|| $smarty->user->isOwner() 
					|| $smarty->user->isBuyer()
					|| $smarty->user->isBusinessOwner());

 $form = new HTML_QuickForm('Vendors', 'POST');

 $IsPost = $form->isSubmitted();
 $action = @$_REQUEST["action"];

 if (@$_REQUEST["FORM_ACTION"])
    $action = $_REQUEST["FORM_ACTION"];
 if (@$_REQUEST["delete"])
    $action = DELETE_ACTION;
 if (@$_REQUEST["delete_bu"])
    $action = DELETE_BUSINESS_UNIT;

 /*if (@$_REQUEST["new"])
    $action = INSERT_ACTION;
 */
 $actions = array(INSERT_ACTION, UPDATE_ACTION, DELETE_ACTION, CANCEL_ACTION, INSERT_BUSINESS_UNIT, DELETE_BUSINESS_UNIT);
 if (!in_array($action, $actions))
    $action = UPDATE_ACTION;
/*
 echo $action;
 exit;*/
 if ($currentSupplierID == null || !IDinList($supplierList, $currentSupplierID))
 {
     if (count($supplierList) == 0)
     {
         $action = INSERT_ACTION;
         $currentSupplierID = -1;
     }
     else
        $currentSupplierID = $supplierList[0]["SUPPLIER_ID"];
 }

 if (@$_REQUEST["cancel"] )
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&SUPPLIER_ID=".$currentSupplierID."&BUSINESS_ID=".$currentBUID."&searchFilter=".urlencode($filter));
    exit;
 }

 if (@$_REQUEST["new"] )
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&SUPPLIER_ID=".$currentSupplierID."&BUSINESS_ID=".$currentBUID."&action=".INSERT_ACTION."&searchFilter=".urlencode($filter));
    exit;
 }

 if (@$_REQUEST["new_bu"] )
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&SUPPLIER_ID=".$currentSupplierID."&BUSINESS_ID=".$currentBUID."&FORM_ACTION=".INSERT_BUSINESS_UNIT."&searchFilter=".urlencode($filter));
    exit;
 }

 $form_data = array();
 if ($action == INSERT_ACTION)
     $form_data = array("SUPPLIER_ID" => $currentSupplierID, "BUSINESS_ID" => $currentBUID, "BUSINESS_UNITS" => array(array()));
 else
 {
     if ($IsPost)
       $form_data = $_POST;
     else
     {
        $form_data = $dbSupplier->getSupplier($currentSupplierID);
        $form_data["BUSINESS_UNITS"] = $dbSupplier->getSupplierBusinessUnits($currentSupplierID);
        if ($action == INSERT_BUSINESS_UNIT)
           $form_data["BUSINESS_UNITS"][] = array("BU_SUPPLIER_ID"=>"");
     }
 }

//    Begin
//    Description: The block to getting the year

        $YEAR = date("Y");
        if(!isset($_GET["YEAR"])){}
        else
        {
            $YEAR = $_GET["YEAR"];
        }

//    End

        $form_data_ = $dbSupplier->getAllNeededData($currentSupplierID,$currentBUID,$YEAR);

        $arr_years = array($YEAR);
        while(list($k,$v) = each($form_data_["YEARS"]))
        {
            if($v!=$YEAR)$arr_years[] = $v;
        }

        $link = $GLOBALS["PATH_FORM_ROOT"]."?m2=property_supplier&SUPPLIER_ID=".$currentSupplierID."&BUSINESS_ID=".$currentBUID;
        $smarty->assign("link",$link);

 $date_elements = array();
 setForm($form, $form_data, $action, $date_elements, $currentBUID, $filter);

 if (!$IsPost)
    $form->setDefaults(@$form_data);

 if (($IsPost && ($form->validate() || $action == DELETE_ACTION ) || $action == DELETE_BUSINESS_UNIT ) && $isEdit)
 {

    // save form to database
    $values = $form->getSubmitValues();
    $newID = -1;
    $IsError = 0;
    try
    {
        if ($action == DELETE_BUSINESS_UNIT){
           $dbSupplier->DeleteBusinessUnits(@$_REQUEST["BU_SUPPLIER_ID"]);
        }
        else
        if ($action == DELETE_ACTION)
           $dbSupplier->Delete($currentSupplierID);
        else
        if ($action == UPDATE_ACTION || $action == INSERT_BUSINESS_UNIT)
        {
           $dbSupplier->Update($values);
           $dbSupplier->UpdateBusinessUnits($values["BUSINESS_UNITS"], $values["SUPPLIER_ID"]);
        }
        else
        if ($action == INSERT_ACTION){
           $newID = $dbSupplier->Insert($values);
           $dbSupplier->UpdateBusinessUnits($values["BUSINESS_UNITS"], $newID);
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
       // --- if inserted or updated values not include business unit
       $bus = $values["BUSINESS_UNITS"];
       $is = false;
       foreach($bus as $v )
         if ($v["BUSINESS_ID"] == $currentBUID){
             $is = true;
             break;
         }

       if (!$is){
          $currentBUID = $bus[0]["BUSINESS_ID"];
       }
       // ---- end
       $s = "Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&BUSINESS_ID=".$currentBUID."&searchFilter=".urlencode($filter);

       if ($action == INSERT_ACTION)
           $currentSupplierID = $newID;

/*       echo $s;
       echo $action." ".$currentBUID;
       exit;*/

       if ($action == DELETE_ACTION)
          header($s);
       else
       if (@$_REQUEST["new"])
          header($s."&SUPPLIER_ID=".$currentSupplierID.'&action='.INSERT_ACTION);
       else
       if (@$action == UPDATE_ACTION || $action == DELETE_BUSINESS_UNIT || $action == INSERT_BUSINESS_UNIT || $action == INSERT_ACTION)
          header($s."&SUPPLIER_ID=".$currentSupplierID);
       exit;
    } // -- if (!$IsError)
 }

 if (!$isEdit)
    $form->freeze();
 $header_title = "Vendor - ";
 if ($action == INSERT_ACTION)
   $header_title .= "New";
 else
 {
    $supplier = $dbSupplier->getSupplier($currentSupplierID);
    $header_title .= $supplier["NAME"];
 }

 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 // send form data to Smarty
 $smarty->assign('action', $action);
 $smarty->assign('form_data', $renderer->toArray());

 $smarty->assign("businessList", $buList);
 $smarty->assign("businessID", $currentBUID);
 $smarty->assign("supplierID", $currentSupplierID);
 $smarty->assign("header_title", $header_title);
 $smarty->assign("script", $StatesLovData->display().$BusinessUnitsLovData->display());

    if(!isset($form_data_["PAID_"]) or $form_data_["PAID_"]=="")$form_data_["PAID_"] = '0';
    if(!isset($form_data_["OWED_"]) or $form_data_["OWED_"]=="")$form_data_["OWED_"] = '0';

    $arr_temp_owed = array();
    $arr_temp_paid = array();

    $arr_temp = $form_data_["ROWS"];
    while(list($k,$v) = each($form_data_["ROWS"]))
    {
//        $float_temp_owed = UtlConvert::dbNumericToDisplay($v["OWED_"]);
//        $float_temp_paid = UtlConvert::dbNumericToDisplay($v["PAID_"]);
        $float_temp_owed = $v["OWED_"];
        $float_temp_paid = $v["PAID_"];

        $arr_temp_owed[] = $float_temp_owed;
        $arr_temp_paid[] = $float_temp_paid;

        if(!$v["OWED_"])$arr_temp[$k]["OWED_"] = 0;
        else $arr_temp[$k]["OWED_"] = $float_temp_owed;

        if(!$v["PAID_"])$arr_temp[$k]["PAID_"] = 0;
        else $arr_temp[$k]["PAID_"] = $float_temp_paid;
    }
    $form_data_["ROWS"] = $arr_temp;

    $int_total_amount_owed = (float)array_sum($arr_temp_owed);
    $int_total_amount_paid = (float)array_sum($arr_temp_paid);

    $smarty->assign("total_amount_owed",UtlConvert::dbNumericToDisplay($int_total_amount_owed));
    $smarty->assign("total_amount_paid",UtlConvert::dbNumericToDisplay($int_total_amount_paid));

    while(list($k,$v) = each($form_data_["ROWS"]))
    {
        $form_data_["ROWS"][$k]["OWED_"] = UtlConvert::dbNumericToDisplay($form_data_["ROWS"][$k]["OWED_"]);
        $form_data_["ROWS"][$k]["PAID_"] = UtlConvert::dbNumericToDisplay($form_data_["ROWS"][$k]["PAID_"]);
    }
    $smarty->assign("form_data_",$form_data_["ROWS"]);
    $smarty->assign("arr_years",$arr_years);
    $smarty->assign("isEdit", $isEdit ? "true" : "false");
    $smarty->assign("filter", "searchFilter=".urlencode($filter));
   

?>