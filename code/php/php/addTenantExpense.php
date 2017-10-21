<?
  require_once dirname(__FILE__)."/../classes/SmartyInit.class.php";
  require_once dirname(__FILE__).'/../classes/database/rnt_supplier.class.php';
  require_once dirname(__FILE__).'/../classes/database/rnt_business_units.class.php';
  require_once dirname(__FILE__).'/../classes/UtlConvert.class.php';
  require_once dirname(__FILE__).'/../classes/SQLExceptionMessage.class.php';
  require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
  require_once 'HTML/QuickForm.php';

  $smarty = new SmartyInit();

  if (!$smarty->user->isLogin())
  {
       // goto login page
       header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."login.php");
       exit;
  }

  if (!$smarty->user->isManager() && !$smarty->user->isManagerOwner())
  {
     header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
     exit;
  }

  define("NEW_SUPPLIER", "NEW_SUPPLIER");
  define("FROM_EXISTS_SUPPLIER", "FROM_EXISTS_SUPPLIER");
  $type = @$_REQUEST["type"];
  if ($type != NEW_SUPPLIER && $type != FROM_EXISTS_SUPPLIER)
    $type = NEW_SUPPLIER;

  $currentBUID = @$_REQUEST["BUSINESS_ID"];
  if (@$_REQUEST["new"])
  {
     // update form for new record
     header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."php/addTenantExpense.php?BUSINESS_ID=".$currentBUID."&type=".NEW_SUPPLIER);
     exit;
  }

  if (@$_REQUEST["add"])
  {
     // update form for new record
     header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."php/addTenantExpense.php?BUSINESS_ID=".$currentBUID."&type=".FROM_EXISTS_SUPPLIER);
     exit;
  }
   // set current user_id
  $smarty->user->set_database_user();
  $smarty->assign("role",  $smarty->user->getRole());

  $dbSupplier = new RNTSupplier($smarty->connection);

  function setForm(&$form, $form_data, $form_action, $currentBUID)
     {
        global $smarty;
        global $dbSupplier;
        global $type;

        $form->AddElement("hidden", "FORM_ACTION", $form_action);
        $form->AddElement("hidden", "BUSINESS_ID", $currentBUID);
        $form->AddElement("hidden", "type", $type);

        if ($type == NEW_SUPPLIER) {
                $form->AddElement("hidden", "SUPPLIER_ID");
                $form->AddElement("text", "NAME", "Name", array("size"=>20));
                $form->AddElement("text", "PHONE1", "Primary Phone", array("size"=>20));
                $form->AddElement("text", "PHONE2", "Secondary Phone", array("size"=>20));
                $form->AddElement("text", "ADDRESS1", "Primary Address", array("size"=>30));
                $form->AddElement("text", "ADDRESS2", "Secondary Address", array("size"=>30));
                $form->AddElement("text", "CITY", "City", array("size"=>20));
                $form->AddElement("select", "STATE", "State", $dbSupplier->getStatesList());
                $form->AddElement("text", "ZIPCODE", "ZIP code");
                $form->AddElement("text", "EMAIL_ADDRESS", "E-mail", array("size"=>25));
                $form->AddElement("select", "SUPPLIER_TYPE_ID", "Type", $dbSupplier->getSupplierTypes());
                $form->AddElement("textarea", "COMMENTS", "Comments", array("size"=>200));
                // rule for validate
                $form->addRule("NAME", "set Name", 'required');
                $form->addRule("PHONE1", "set Primary phone",'required');
                $form->addRule("EMAIL_ADDRESS", "E-mail is a not valid e-mail addess","email");
                $form->addRule("ZIPCODE", "Zip code must be numeric", 'numeric');
        }
        else {
                $form->AddElement("select", "SUPPLIER_ID", "Supplier", $dbSupplier->getSupplierForAdd($currentBUID));
                $form->addRule("SUPPLIER_ID", "Supplier Name required.","required");
        }
        $form->AddElement("text", "SSN", "SSN", "SSN", array("size"=>14));
        // Apply filter for all data cells
        $form->applyFilter('__ALL__', 'trim');
       // $form->AddElement("submit", "new", "New");
        $form->AddElement("submit", "cancel", "Close", array("onclick"=>"window.close()"));
        $form->AddElement("submit", "accept", "Save");
    } // --- function setForm($form, $size)

 $form = new HTML_QuickForm('suppl', 'POST');

 $form_data = array("SUPPLIER_ID"=>"");
 $form_action = "INSERT";

 $smarty->assign("currentBUID", $currentBUID);
 $success = @$_REQUEST["success"];
 $smarty->assign("success", $success);
 setForm($form, $form_data, $form_action, $currentBUID);
 $form->setDefaults(@$form_data);

 $IsPost = $form->isSubmitted();

 if ($IsPost && ($form->validate()) && ($smarty->user->isManager() || $smarty->user->isManagerOwner()))
 {

    // save form to database
    $values = $form->getSubmitValues();
    // corrent business units to parent business unit
    $dbBU = new RNTBusinessUnit($smarty->connection);
    $bu = $dbBU->getBusinessUnit($values["BUSINESS_ID"]);
    $values["BUSINESS_ID"] = $bu["PARENT_BUSINESS_ID"];

    $newID = -1;
    $IsError = 0;
    try
    {
        if ($type == NEW_SUPPLIER){
            $newID = $dbSupplier->Insert($values);
            $dbSupplier->UpdateBusinessUnits(array(array("BUSINESS_ID" => $bu["PARENT_BUSINESS_ID"],
                                                   "SUPPLIER_ID" => $newID,
                                                   "TAX_IDENTIFIER" => $values["SSN"],
                                                   "NOTES" => ""
                                                   )) , $newID);
        }
        else {
            $dbSupplier->UpdateBusinessUnits(array(array("BUSINESS_ID" => $bu["PARENT_BUSINESS_ID"],
                                                         "SUPPLIER_ID" => $values["SUPPLIER_ID"],
                                                         "TAX_IDENTIFIER" => $values["SSN"],
                                                          "NOTES" => ""
                                                          )) , $values["SUPPLIER_ID"]);
        }
        $smarty->connection->commit();
    }
    catch(SQLException $e)
    {
          $IsError = 1;
          $emsg = new SQLExceptionMessage($e);
          $de =  new DatabaseError($smarty->connection);
          $smarty->assign("errorObj", $de->getErrorFromException($e));
    }

    if (!$IsError)
    {
       header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."php/addTenantExpense.php?BUSINESS_ID=".$currentBUID."&success=true&type=$type");
       exit;
    }


 } // --- if ($IsPost && ($form->validate()) && ($smarty->user->isManager() || $smarty->user->isManagerOwner()))

 if ($success)
 {
    $dbBU = new RNTBusinessUnit($smarty->connection);
    $bu = $dbBU->getBusinessUnit($currentBUID);
    $lst = $dbSupplier->getList($bu["PARENT_BUSINESS_ID"]);
    $smarty->assign("listSupplier", $lst);
 }
 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 // send form data to Smarty
 $smarty->assign('form_data', $renderer->toArray());
 $xtype_name = NEW_SUPPLIER;
 if ($type == NEW_SUPPLIER)
    $xtype_name = FROM_EXISTS_SUPPLIER;

 $smarty->assign("fromExistsLinkHref", $GLOBALS["PATH_FORM_ROOT"]."php/addTenantExpense.php?BUSINESS_ID=".$currentBUID."&type=".$xtype_name);
 $smarty->assign('type', $type);


 $smarty->display("addTenantExpense.tpl");
 $smarty->connection->close();
?>
