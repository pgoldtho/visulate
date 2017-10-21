<?

 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_users.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

 if (!$smarty->user->isAdmin())
 {
   header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
   exit;
 }

 if (!defined("ADMIN_USERS"))
 {
     define("ACTION_VIEW", "VIEW");
     define("ACTION_INSERT", "INSERT");
     define("ACTION_CHANGE_ACTIVE", "CHANGE_ACTIVE");
     define("ACTION_UPDATE", "UPDATE");
     define("ACTION_CANCEL", "CANCEL");
     define("ACTION_RESET_PASSWORD", "RESET_PASSWORD");
 }

 $dbUser = new RntUser($smarty->connection);
 $userList = $dbUser->getUserList();

 $action = ACTION_VIEW;
 $currentUserID = 0;

 // change active flag
 if (@$_GET["action"] == "changeActive")
 {
    $action = ACTION_CHANGE_ACTIVE;
    $currentUserID = @$_GET["USER_ID"];
 }
 else  if (@$_GET["action"] == "resetPassword")
 {
    $action = ACTION_RESET_PASSWORD;
    $currentUserID = @$_GET["USER_ID"];
 }
 // cancel
 else if (@$_REQUEST["cancel"])
    $action = ACTION_CANCEL;
 // edit action
 else if (@$_REQUEST["action"] == "UPDATE")
 {
    $action = ACTION_UPDATE;
    $currentUserID = @$_REQUEST["USER_ID"];
 }
 else if (@$_REQUEST["action"] == "INSERT")
    $action = ACTION_INSERT;
 else
    $action = ACTION_VIEW;

 if ($action == ACTION_CANCEL)
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2());
    exit;
 }

 $form = new HTML_QuickForm('formUser', 'POST');
 $IsPost = $form->isSubmitted();

 // menu 2 level
 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
 $form->AddElement("hidden", "CHECKSUM");
 $form->AddElement("hidden", "action", $action);
 $form->AddElement("hidden", "USER_ID");
 $form->AddElement("text", "USER_LASTNAME", "Last Name");
 $form->AddElement("text", "USER_NAME", "First Name");
 $form->AddElement("text", "PRIMARY_PHONE", "Primary Phone");
 $form->AddElement("text", "SECONDARY_PHONE", "Secondary Phone");
 $form->AddElement("text", "USER_LOGIN", "E-mail (login)");
 $form->AddElement("advcheckbox", "IS_ACTIVE_YN", "Active?");
 $form->AddElement("advcheckbox", "IS_SUBSCRIBED_YN", "Subscribed?");
 $form->AddElement("text", "NEW_PASSWORD", "New Password");
 $form->AddElement("submit", "accept", "Save");
 $form->AddElement("submit", "cancel", "Cancel");
 // Apply filter for all data cells
 $form->applyFilter('__ALL__', 'trim');
 // Append rule REUIQRED
 $form->addRule('USER_NAME', 'Set First Name.', 'required');
 $form->addRule('USER_LASTNAME', 'Set Last Name.', 'required');
 $form->addRule('USER_LOGIN', 'Set E-mail (login).', 'required');
 $form->addRule('USER_LOGIN', 'Field E-mail (login) is a not e-mail address.', 'email');

 // if form present
 $IsForm = ($action == ACTION_INSERT || $action == ACTION_UPDATE);
 $form_data = array();

 // init array
 if ($IsForm)
 {
    if (!$IsPost)
    {
       if ($action == ACTION_UPDATE)
       {
           $form_data = $dbUser->getUser($currentUserID);
           $form_data["IS_ACTIVE_YN"] = ($form_data["IS_ACTIVE_YN"] == "Y");
           $form_data["IS_SUBSCRIBED_YN"] = ($form_data["IS_SUBSCRIBED_YN"] == "Y");
           $form->setDefaults($form_data);
       }
       else
           // for new user record
           $form_data["IS_ACTIVE_YN"] = 1;
    }
    else
       $form_data = $form->getSubmitValues();
 } // --- if ($IsForm)

 if ($action == ACTION_CHANGE_ACTIVE || $action == ACTION_RESET_PASSWORD || ($IsPost && $form->validate()))
 {
     $IsError = false;

     try
     {
       if ($action == ACTION_CHANGE_ACTIVE)
         // change active flag for user
         $dbUser->changeActive($currentUserID);
       else if ($action == ACTION_RESET_PASSWORD)
         $dbUser->setPassword($currentUserID, /*$smarty->user->getWrappedPassword(*/User::DEFAULT_PASSWORD/*)*/);
       else if ($action == ACTION_UPDATE)
         $dbUser->Update($form_data);
       else if ($action == ACTION_INSERT)
         $currentUserID = $dbUser->Insert($form_data);
       else
         throw new Exception('Unknown operation');

       $smarty->connection->commit();
     }
     catch(SQLException $e)
     {
         $IsError = true;
         $smarty->connection->rollback();
         $de =  new DatabaseError($smarty->connection);
         echo "<pre>";
         print_r($e);
         $smarty->assign("errorObj", $de->getErrorFromException($e));
     }

     if (!$IsError)
     {
         if ($action == ACTION_CHANGE_ACTIVE || $action == ACTION_UPDATE || $action == ACTION_INSERT || $action == ACTION_RESET_PASSWORD)
           header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."#user".$currentUserID);
         exit;
     }
 } // --- if (...

 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 $smarty->assign("userList", $userList);
 $smarty->assign('form_data', $renderer->toArray());
 // if action insert or update
 $smarty->assign("isForm", $IsForm);
 $smarty->assign("action", $action);
 $smarty->assign("currentUserID", $currentUserID);

?>
