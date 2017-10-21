<?

 require_once dirname(__FILE__)."/../classes/database/rnt_section8.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

 function setForm(&$form, &$data, $form_action, $currentBUID)
 {
         global $menu;
         global $smarty;
         // set form fields
         // menu 2 level
          $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);

          $form->AddElement("hidden", "SECTION8_ID");
          $form->AddElement("hidden", "FORM_ACTION", $form_action);
          $form->AddElement("hidden", "BUSINESS_ID", $currentBUID);
          $form->AddElement("hidden", "CHECKSUM");
          $form->AddElement("hidden", "SECTION8_BUSINESS_ID");

          $form->AddElement("text", "SECTION_NAME", "Section Name", array("size"=>20));
          // require
          $form->addRule("SECTION_NAME", "set name", 'required');

          // Apply filter for all data cells
          $form->applyFilter('__ALL__', 'trim');
          global $isEdit;
          if ($isEdit){
              $r = array("onclick" => "return confirm('Delete this record?');");
              if ($form_action == INSERT_ACTION)
                 $r = array("disabled");
              $form->AddElement("submit", "delete", "Delete", $r);
              $form->AddElement("submit", "new", "New");
              $form->AddElement("submit", "cancel", "Cancel");

              $form->AddElement("submit", "accept", "Save");
           }
 } // --- function setForm($form, $size)

 function IDinList($array, $id)
 {
    foreach($array as $v)
        if ($v["SECTION8_ID"] == $id)
           return true;
    return false;
 }

 if (!defined("SECTION8"))
 {
    define("SECTION8", "1");
    define("UPDATE_ACTION", "UPDATE");
    define("DELETE_ACTION", "DELETE");
    define("INSERT_ACTION", "INSERT");
    define("CANCEL_ACTION", "CANCEL");
 }
 $actions = array(INSERT_ACTION, UPDATE_ACTION, DELETE_ACTION, CANCEL_ACTION);
 $dbSection8 = new RNTSection8($smarty->connection);

 $dbBU = new RNTBusinessUnit($smarty->connection);
 $buList = $dbBU->getBusinessUnitsLevel2();
 $currentBUID = @$_REQUEST["BUSINESS_ID"];

 if (!$currentBUID)
   $currentBUID = @$buList[0]["BUSINESS_ID"];

 foreach($buList as $k=>$v)
 {
    $buList[$k]["SECTION8_LIST"] = array();
    $s8List = $dbSection8->getList($v["BUSINESS_ID"]);
    foreach($s8List as $k1=>$v1)
        $buList[$k]["SECTION8_LIST"][] = array("SECTION8_ID"=>$v1["SECTION8_ID"], "SECTION_NAME"=>$v1["SECTION_NAME"],
                                               "SECTION8_BUSINESS_ID" => $v1["SECTION8_BUSINESS_ID"]);
 }


// print_r($buList);
 $form = new HTML_QuickForm('formS8', 'POST');

 // -----  Append rules
 $form->registerRule('vdate', 'function', 'validateDate');

 $s8List = $dbSection8->getList($currentBUID);
 $IsPost = $form->isSubmitted();
 $action = @$_REQUEST["action"];
 if (@$_POST["FORM_ACTION"])
    $action = $_POST["FORM_ACTION"];
 if (@$_REQUEST["delete"])
    $action = DELETE_ACTION;
 if (!in_array($action, $actions))
    $action = UPDATE_ACTION;
 $currentS8ID = @$_REQUEST["SECTION8_ID"];
 $currentSection8BU_ID = @$_REQUEST["SECTION8_BUSINESS_ID"];

 if ($currentS8ID == null || $currentSection8BU_ID == null || !IDinList($s8List, $currentS8ID))
 {
     if (count($s8List) == 0)
     {
         $action = INSERT_ACTION;
         $currentS8ID = -1;
     }
     else
     {
        $currentS8ID = $s8List[0]["SECTION8_ID"];
        $currentSection8BU_ID = $s8List[0]["SECTION8_BUSINESS_ID"];
     }
 }

 if (!$currentSection8BU_ID && $currentS8ID)
   $currentSection8BU_ID = $dbSection8->defineSection8BU_ID($currentS8ID, $currentBUID);

 if (! ( $smarty->user->isOwner() || $smarty->user->isManager() || $smarty->user->isManagerOwner() || $smarty->user->isBookkeeping() || $smarty->user->isBusinessOwner()))
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
    exit;
 }

 $isEdit = ($smarty->user->isManager() || $smarty->user->isManagerOwner());

 if (@$_REQUEST["cancel"])
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&SECTION8_ID=".$currentS8ID."&BUSINESS_ID=".$currentBUID);
    exit;
 }

 $warning = array("flag" => "", "message" => "");

 if ($action != INSERT_ACTION && $isEdit){
    $cnt = $dbSection8->getBUCount($currentS8ID);
    if ($cnt > 1)
       $warning = array("flag" => "!", "message" => "Warning: Other business units including this Section8.");
    else if ($cnt == 1)
       $warning = array("flag" => "-", "message" => "Only one business unit include the Section8.");
 }

 $form_data = array();
 if ($action == INSERT_ACTION)
 {
     $form_data = array("SECTION8_ID" => $currentS8ID, "BUSINESS_ID" => $currentBUID);
 }
 else
 {
     if ($IsPost)
       $form_data = $_POST;
     else
       $form_data = $dbSection8->getSection8($currentS8ID);
 }

 setForm($form, $form_data, $action, $currentBUID);

 if (!$IsPost)
    $form->setDefaults(@$form_data);

 if ($IsPost && ($form->validate() || $action == DELETE_ACTION) && $isEdit)
 {

    // save form to database
    $values = $form->getSubmitValues();
    $newID = -1;
    $IsError = 0;
    try
    {
        if ($action == DELETE_ACTION)
           $dbSection8->Delete($values);
        else
        if ($action == UPDATE_ACTION)
           $dbSection8->Update($values);
        else
        if ($action == INSERT_ACTION)
           $newID = $dbSection8->Insert($values);
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
       $s = "Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&BUSINESS_ID=".$currentBUID;

       if ($action == INSERT_ACTION)
           $currentS8ID = $newID;

       if ($action == DELETE_ACTION)
          header($s);
       else
       if (@$_REQUEST["new"])
          header($s."&SECTION8_ID=".$currentS8ID.'&action='.INSERT_ACTION);
       else
       if (@$action == UPDATE_ACTION)
          header($s."&SECTION8_ID=".$currentS8ID);
       if (@$action == INSERT_ACTION)
          header($s."&SECTION8_ID=".$currentS8ID);
       exit;
    } // -- if (!$IsError)
 }

 if (!$isEdit)
   $form->freeze();

 $header_title = "Section 8 Offices - ";
 if ($action == INSERT_ACTION)
   $header_title .= "New";
 else
   $header_title .= $form_data["SECTION_NAME"];
 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 // send form data to Smarty
 $smarty->assign('action', $action);
 $smarty->assign('form_data', $renderer->toArray());
 $smarty->assign('s8List', $s8List);
 $smarty->assign("businessList", $buList);
 $smarty->assign("businessID", $currentBUID);
 $smarty->assign("isEdit", $isEdit);

 // set current record of people
 $smarty->assign("s8ID", $currentS8ID);
 $smarty->assign("s8BU_ID",  $currentSection8BU_ID);
 $smarty->assign("warning", $warning);
 // Element of form who make date
 $smarty->assign("header_title", $header_title);
?>
