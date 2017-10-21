<?

 require_once dirname(__FILE__)."/classes/SmartyInit.class.php";
 require_once dirname(__FILE__)."/classes/User.class.php";
 require_once dirname(__FILE__)."/classes/database/rnt_users.class.php";
 require_once dirname(__FILE__)."/classes/SQLExceptionMessage.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

  $smarty = new SmartyInit();
  // User not login - go to main page.
  if (!$smarty->user->isLogin() || @$_POST["cancel"])
  {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
    exit;
  }

  $userInfo = $smarty->user->getUserInfo();
  $form = new HTML_QuickForm('formPref', 'POST');
  $isChangePassword = @$_POST["isChangePass"] == 1;

  $form->addElement("text", "USER_LOGIN", "Login:", array("size"=>"30", "disabled"=>"disabled", "value"=>$userInfo["USER_LOGIN"]));
  $form->addElement("text", "USER_NAME", "First Name:", array("size"=>"40"));
  $form->addElement("text", "USER_LASTNAME", "Last Name:", array("size"=>"40"));
  $form->addElement("text", "PRIMARY_PHONE", "Phone1:", array("size"=>"25"));
  $form->addElement("text", "SECONDARY_PHONE", "Phone2:", array("size"=>"25"));
  $form->addElement("advcheckbox", "isChangePass", "", "Change Password?", array("onchange" => "formPref.OLD_PASSWORD.disabled=!formPref.OLD_PASSWORD.disabled;formPref.NEW_PASSWORD.disabled=!formPref.NEW_PASSWORD.disabled;formPref.NEW_PASSWORD_CONFIRM.disabled=!formPref.NEW_PASSWORD_CONFIRM.disabled;"));
  $r = array("size" => 20);
  if (!$isChangePassword)
     $r["disabled"] = "disabled";
	 $r["autocomplete"] = "off";
  $form->addElement("password", "OLD_PASSWORD", "Old password:", $r);
  $form->addElement("password", "NEW_PASSWORD", "New password:", $r);
  $form->addElement("password", "NEW_PASSWORD_CONFIRM", "Confirm new password:", $r);
  $form->addRule("USER_NAME", "required", "required");
  $form->addRule("USER_LASTNAME", "required", "required");

  $form->addRule(array("NEW_PASSWORD", "NEW_PASSWORD_CONFIRM"), "New password and confirm new password do not match.", "compare");
  $form->addElement("submit", "cancel", "Cancel");
  $form->addElement("submit", "submit", "Apply");

  $IsPost = $form->isSubmitted();
  if ($IsPost)
     $values = $_POST;
  else
     $values = array();
  $error = "";

  if ($IsPost && $isChangePassword)
  {
     if (@$values["NEW_PASSWORD"] == "" || @$values["NEW_PASSWORD_CONFIRM"] == "")
        $form->_errors[] = "New password and confirm new password cannot be empty.";
  }

  if (!$IsPost){
     $values["USER_NAME"] = $userInfo["USER_NAME"];
     $values["USER_LASTNAME"] = $userInfo["USER_LASTNAME"];
     $values["PRIMARY_PHONE"] = $userInfo["PRIMARY_PHONE"];
     $values["SECONDARY_PHONE"] = $userInfo["SECONDARY_PHONE"];
  }

  $form->setDefaults($values);
  $values = $form->getSubmitValues();

  if ($IsPost && $form->validate())
  {

     $success = false;
     try
     {
         // update data
         $smarty->user->updateUserData($values["USER_NAME"], $values["USER_LASTNAME"], $values["PRIMARY_PHONE"], $values["SECONDARY_PHONE"]);
         $success = true;
         // change password for user
         if ($isChangePassword)
            $success = $smarty->user->changePassword($values["OLD_PASSWORD"], $values["NEW_PASSWORD"]);
         $smarty->connection->commit();
     }
     catch(SQLException $e)
     {
          $emsg = new SQLExceptionMessage($e);
          $form->_errors[] = $emsg->getMessage();
          $smarty->connection->rollback();
          $success = false;
     }

     if ($success)
     {
         // notice to user that password has changed
         header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."pref.php?ok=true");
         exit;
     }
     else
         $form->_errors[] = "Cannot save profile.";
  }

  $success_message = "";
  if (@$_REQUEST["ok"])
    $success_message = "Profile saved successfuly.";

 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 // send form data to Smarty

 $smarty->assign('values', $renderer->toArray());
 $smarty->assign('error', implode("<br>", @$form->_errors));
 $smarty->assign('header_title', 'Preferences - ');
 $smarty->assign('success_message', $success_message);

 $smarty->display('pref.tpl');
?>
