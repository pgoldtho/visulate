<?
  /* Page has included for /../index.php */
 require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

 if (!$smarty->user->isAdmin())
 {
   header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
   exit;
 }

 if (!defined("BUSINESS_UNIT"))
 {
    define("BUSINESS_UNIT", "1");
    define("UPDATE_ACTION", "UPDATE");
    define("INSERT_ACTION", "INSERT");
    define("CANCEL_ACTION", "CANCEL");
    define("DELETE_ACTION", "DELETE");
    define("VIEW_ACTION", "VIEW");
 }

 $BU = new RNTBusinessUnit($smarty->connection);

 $bu_tree = $BU->getTreeForAdmin();

 $smarty->assign("bu_tree", $bu_tree);
 $action = "";
 $current_parent_id = -1;
 $current_id = -1;
 if (@$_GET["action"] == "ins")
 {
     $action = INSERT_ACTION;
     $current_parent_id = intval($_GET["parent"]);
 }
 else if (@$_GET["action"] == "upd")
 {
     $action = UPDATE_ACTION;
     $current_id = intval($_GET["id"]);
 }
 else if(@$_GET["action"] == "del")
 {
     $action = DELETE_ACTION;
     $current_id = intval($_GET["id"]);
 }
 else
 if (@$_POST["FORM_ACTION"])
 {
    $action = $_POST["FORM_ACTION"];
    if ($action != DELETE_ACTION && $action != INSERT_ACTION && $action != UPDATE_ACTION && $action != CANCEL_ACTION && $action != VIEW_ACTION)
      $action = VIEW_ACTION;
   if ($action == INSERT_ACTION)
      $current_parent_id = $_POST["PARENT_BUSINESS_ID"];
   if ($action == UPDATE_ACTION)
      $current_id = $_POST["BUSINESS_ID"];
 }

 if (@$_POST["cancel"])
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->request_menu_level2."=".$menu->current_level2);
    exit;
 }

 $form = new HTML_QuickForm('formBU', 'POST');
 $IsPost = $form->isSubmitted();

 if (!$IsPost)
 {
    if ($action == UPDATE_ACTION)
    {
       if ($r = $BU->getBusinessUnit($current_id))
          $form->setDefaults($r);
    }
    else if ($action == INSERT_ACTION)
         $form->setDefaults(array("PARENT_BUSINESS_ID" => $current_parent_id));
 }

 $form->AddElement("hidden", $menu3->request_property_id, $menu3->current_property_id);
 // menu 2 level
 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
 $form->AddElement("hidden", "CHECKSUM");
 $form->AddElement("hidden", "FORM_ACTION", $action);
 $form->AddElement("hidden", "PARENT_BUSINESS_ID");
 $form->AddElement("hidden", "BUSINESS_ID");
 $form->AddElement("text", "BUSINESS_NAME", "Business Name", array("size"=>40));
 $form->AddElement("submit", "accept", "Save", array());
 $form->AddElement("submit", "cancel", "Cancel", array());
 // Apply filter for all data cells
 $form->applyFilter('__ALL__', 'trim');

 // Append rule REUIQRED
 $form->addRule('BUSINESS_NAME', 'Set Business name.', 'required');
 if ( (($IsPost && $form->validate()) || $action == DELETE_ACTION)) {

    // save form to database
    $values = $form->getSubmitValues();
    $IsError = 0;
    $NewID = -1;
    try
    {
        if ($action == UPDATE_ACTION)
           $BU->Update($values);
        else
        if ($action == INSERT_ACTION)
           $NewID = $BU->Insert($values);
        else
        if ($action == DELETE_ACTION)
           $BU->Delete($current_id);
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


    if (!$IsError)
    {
        header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2());
        exit;
    }
 }

 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 // send form data to Smarty
 if ($action == INSERT_ACTION || $action == UPDATE_ACTION)
    $smarty->assign('isForm', "true");
 else
    $smarty->assign('isForm', "false");

 $smarty->assign('action', $action);
 $smarty->assign('id', -1);
 if ($action == INSERT_ACTION)
   $smarty->assign('id', $current_parent_id);
 else if ($action == UPDATE_ACTION)
   $smarty->assign('id', $current_id);

 $smarty->assign('form_data', $renderer->toArray());
 $header_title = "Business units";
 $smarty->assign("header_title", $header_title);

?>