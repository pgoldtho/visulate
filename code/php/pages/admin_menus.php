<?php
 require_once dirname(__FILE__)."/../classes/database/rnt_menus.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

 //check user role
 if (!$smarty->user->isAdmin()) {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
    exit;
 }
 if (!defined("ADMIN_MENUS")) {
     define("ACTION_VIEW", "VIEW");
     define("ACTION_INSERT", "INSERT");
     define("ACTION_UPDATE", "UPDATE");
     define("ACTION_DELETE", "DELETE");
     define("ACTION_CANCEL", "CANCEL");
 }

 // check user action
 $action = ACTION_VIEW;
 if ($_REQUEST["action_cancel"]) {
     $action = ACTION_CANCEL;
 }
 elseif ($_REQUEST["action_new"]) {
     //$action = ACTION_INSERT;
     header("Location: ".$GLOBALS["PATH_FORM_ROOT"]
                        ."?".$menu->getParam2()
                        ."&action=INSERT"
     );
     exit;
 }
 elseif ($_REQUEST["action_save"]) {
     $action = ACTION_UPDATE;
 }
 elseif ($_REQUEST["action_delete"]) {
     $action = ACTION_DELETE;
 }
 elseif ($_REQUEST["action"] == "INSERT") {
     $action = ACTION_INSERT;
 }
 else {
     $action = ACTION_VIEW;
 }

 if ($action == ACTION_CANCEL)
 {
     header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2());
     exit;
 }

 // init params and prepare form data
 $RNTMenu   = new RNTMenu($smarty->connection);
 $menu_tree = $RNTMenu->getTreeForAdmin();

 // create form
 $form   = new HTML_QuickForm('formMenu', 'POST');
 $IsPost = $form->isSubmitted();

 $form_data = array();
 if (!$IsPost) {
     $tab_name = @$_REQUEST["TAB_NAME"];

     if ($action == ACTION_INSERT) {
         $tab_data  = array();
     }
     else {
         if (empty($tab_name)) {
             $tab_name = $menu_tree["0"]["TAB_NAME"];
         }
         $tab_data  = $RNTMenu->getTabInfo($tab_name);
     }

     $tab_roles = $RNTMenu->getTabRoles($tab_name);
 }


 // INIT ADDITIONAL FORM RULES
 $form->registerRule('vnumeric', 'function', 'validateNumeric');


 // menu 2 level
 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
 $form->AddElement("hidden", "action", $action);

 // form actions buttons
 $form->AddElement("submit", "action_cancel", "Cancel", array());
 $form->AddElement("submit", "action_save",   "Save",   array());
 $form->AddElement("submit", "action_new",    "New",    array());
 $form->AddElement("submit", "action_delete", "Delete", array());


 // TAB DATA
 $tab_types   = $RNTMenu->getTabTypeList();
 $parent_tabs = $RNTMenu->getParentTabList();
 $form->AddElement("select", "TAB_TYPE",    "Type",     $tab_types, array("style" => "width:140px;"));
 $form->AddElement("select", "PARENT_TAB",  "Parent",   $parent_tabs, array("style" => "width:140px;"));
 $form->AddElement("text",   "DISPLAY_SEQ", "Position", array("size" => 8));
 $form->AddElement("text",   "TAB_NAME",    "Name",     array("size" => 20));
 //$form->AddElement("text", "TAB_PAGENUM", "Page Number", array("size" => 8));
 $form->AddElement("text",   "TAB_TITLE",   "Title",    array("size" => 20));
 $form->AddElement("text",   "TAB_HREF",    "HREF",     array("size" => 20));
 $form->AddElement("hidden", "CHECKSUM", $tab_data["CHECKSUM"]);


 // TAB ROLES
 //$tab_roles = $RNTMenu->getTabRoles($tab_name);
 $tab_roles_cnt = count($tab_roles);
 for ($i = 0; $i < $tab_roles_cnt; $i++) {
     $form->AddElement("hidden", "TAB_ROLES[$i][ROLE_ID]", $tab_roles[$i]["ROLE_ID"]);
     $form->AddElement("hidden", "TAB_ROLES[$i][ROLE_CODE]", $tab_roles[$i]["ROLE_CODE"]);
     $form->AddElement("hidden", "TAB_ROLES[$i][ROLE_NAME]", $tab_roles[$i]["ROLE_NAME"]);
     $form->AddElement("advcheckbox", "TAB_ROLES[$i][IS_ALLOWED_YN]", $tab_roles[$i]["ROLE_NAME"], "", array("N", "Y"));
     $form->AddElement("hidden", "TAB_ROLES[$i][CHECKSUM]", $tab_roles[$i]["CHECKSUM"]);
 }


 // Apply filter for all data cells
 $form->applyFilter('__ALL__', 'trim');

 // prepare rulese for form items
 $form->addRule("TAB_NAME",    "Please set Tab Name",     'required');
 $form->addRule("TAB_TITLE",   "Please set Tab Title",    'required');
 $form->addRule("DISPLAY_SEQ", "Tab position must be numeric", 'vnumeric');

 //
 if (!$IsPost)
 {
     $form->setDefaults(
         array(
             "TAB_TYPE"    => $tab_data["TAB_TYPE"],
             "PARENT_TAB"  => $tab_data["PARENT_TAB"],
             "DISPLAY_SEQ" => $tab_data["DISPLAY_SEQ"],
             "TAB_NAME"    => $tab_data["TAB_NAME"],
             "TAB_TITLE"   => $tab_data["TAB_TITLE"],
             "TAB_HREF"    => $tab_data["TAB_HREF"]
         )
     );

     for ($i = 0; $i < $tab_roles_cnt; $i++) {
         $form->setDefaults(
             array("TAB_ROLES[$i][IS_ALLOWED_YN]" => ($tab_roles[$i]["IS_ALLOWED_YN"] == "Y"))
         );
     }
 }


 if (($IsPost && $form->validate())) {
     // save form to database
     $values = $form->getSubmitValues();

     $IsError = 0;
     try {
         if ($action == ACTION_DELETE) {
               $RNTMenu->Delete($values["TAB_NAME"]);
         }
         elseif ($action == ACTION_UPDATE) {
               $RNTMenu->Update($values);
         }
         else {
               throw new Exception('Unknown operation');
         }

         $smarty->connection->commit();
     }
     catch(SQLException $e) {
         $IsError = 1;
         $smarty->connection->rollback();
         $de =  new DatabaseError($smarty->connection);
         $smarty->assign("errorObj", $de->getErrorFromException($e));
     }

     // redirect to page
     if (!$IsError)
     {
         if ($action == ACTION_DELETE || $action == ACTION_UPDATE)
         {
             header("Location: ".$GLOBALS["PATH_FORM_ROOT"]
                                ."?".$menu->getParam2()
                                .'&TAB_NAME='.$values["TAB_NAME"]
             );
             exit;
         }
     }
 }// ---- end if ((($IsPost && $form->validate())


 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 $smarty->assign('form_data', $renderer->toArray());
 $smarty->assign("menu_tree", $menu_tree);
 $smarty->assign('action', $action);
?>