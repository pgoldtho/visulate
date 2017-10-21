<?

 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_users.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

 if (!$smarty->user->isAdmin())
 {
   header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
   exit;
 }

 if (!defined("ADMIN_ASSIGNMENTS"))
 {
     define("ACTION_VIEW", "VIEW");
     define("ACTION_INSERT", "INSERT");
     define("ACTION_DELETE", "DELETE");
     define("ACTION_INITIAL_INSERT", "INI_INSERT");
     define("ACTION_CHANGE_ACTIVE", "CHANGE_ACTIVE");
     define("ACTION_CANCEL", "CANCEL");
 }

 $dbUser = new RntUser($smarty->connection);
 $userAssignList = $dbUser->getUserAssignmentsList();

 $action = ACTION_VIEW;
 $currentAssignID = 0;
 $roleID = 0;

 // cancel
 if (@$_REQUEST["cancel"])
    $action = ACTION_CANCEL;
 else if (@$_GET["action"] == "INITIAL_INSERT")
 {
    $action = ACTION_INITIAL_INSERT;
    $roleID = @$_GET["role_id"];
    if ($roleID == null)
      $action = ACTION_VIEW;
 }
 else if (@$_POST["action"] == "INSERT")
    $action = ACTION_INSERT;
 else if (@$_GET["action"] == "DEL")
 {
    $action = ACTION_DELETE;
    $currentAssignID = @$_GET["USER_ASSIGN_ID"];
 }
 else
    $action = ACTION_VIEW;

 if ($action == ACTION_CANCEL)
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2());
    exit;
 }

 if ($action != ACTION_INSERT && $action != ACTION_INITIAL_INSERT)
 {
     $formAdd = new HTML_QuickForm('formAdd', 'GET');
     $formAdd->AddElement("select", "role_id", "Role", $dbUser->getRolesLOV());
     $formAdd->AddElement("submit", "create", "New");
     $formAdd->AddElement("hidden", "action", "INITIAL_INSERT");
     // menu 2 level
     $formAdd->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
 }
 else
 {
     $form = new HTML_QuickForm('formAssign', 'POST');
     $IsPost = $form->isSubmitted();

     // menu 2 level
     $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
     $form->AddElement("hidden", "action", "INSERT");
     $form->AddElement("select", "USER_ID", "User", $dbUser->getUserListLOV());
     $role_id = 0;
     if ($action == ACTION_INITIAL_INSERT)
        $role_id = $roleID;
     else
        $role_id = $_POST["ROLE_ID"];

     $role_code = $dbUser->getRoleCode($role_id);
     $business_unit = new RNTBusinessUnit($smarty->connection);
     $form->AddElement("select", "ROLE_ID", "Role", array($role_id=>$dbUser->get_role_name($role_id)));
     $form->AddElement("select", "BUSINESS_ID", "Business Unit", $business_unit->getBusinessUnitsFullLOV($role_code));
     $form->AddElement("submit", "accept", "Save");
     $form->AddElement("submit", "cancel", "Cancel");
     // Apply filter for all data cells
     $form->applyFilter('__ALL__', 'trim');
     // Append rule REUIQRED
     $form->addRule('USER_ID', 'Set User.', 'required');
     $form->addRule('ROLE_ID', 'Set Role.', 'required');
     $form->addRule('BUSINESS_ID', 'Set Business Unit.', 'required');
   }


   // if form present
   $IsPost = false;
   $IsValidate = false;
   $form_data = array();
   if (@$form)
   {
       $IsPost = $form->isSubmitted();
       $IsValidate = $form->validate();
       $form_data = $form->getSubmitValues();
   }
   if (($action == ACTION_INSERT && $IsPost && $IsValidate) || $action == ACTION_DELETE)
     {
        $IsError = false;
        try
        {
           if ($action == ACTION_INSERT)
              $currentAssignID = $dbUser->addAssignment($form_data);
           else if ($action = ACTION_DELETE)
              $dbUser->deleteAssignment($currentAssignID);
           else
              throw new Exception('Unknown operation');

           $smarty->connection->commit();
        }
        catch(SQLException $e)
        {
             $IsError = true;
             $smarty->connection->rollback();
             $de =  new DatabaseError($smarty->connection);
             $smarty->assign("errorObj", $de->getErrorFromException($e));
        }

        if (!$IsError)
        {
          $base = "Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2();
          if ($action == ACTION_INSERT)
            header($base."#assignID".$currentAssignID);
          else if ($action == ACTION_DELETE)
            header($base);
          exit;
        }
   } // --- if ($action == ACTION_INSERT && $IsPost && $form->validate())

 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);

 if ($action == ACTION_INSERT || $action == ACTION_INITIAL_INSERT)
 {
    // generate code
   $form->accept($renderer);
   $smarty->assign('form_data', $renderer->toArray());
 }
 else
 {
    $formAdd->accept($renderer);
    $smarty->assign('form_add_data', $renderer->toArray());
 }

 $smarty->assign("userAssignList", $userAssignList);
?>
