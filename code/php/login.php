<?
 require_once dirname(__FILE__)."/classes/SmartyInit.class.php";
 require_once dirname(__FILE__)."/classes/User.class.php";
 require_once dirname(__FILE__)."/classes/database/rnt_users.class.php";
 require_once dirname(__FILE__)."/classes/SQLExceptionMessage.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

	$mobile_device = is_mobile_browser();
	Context::setMobileDevice($mobile_device);

  $smarty = new SmartyInit();
  $user = $smarty->user;
  // destroy session
  if (@$_REQUEST["destroy"])
      $user->destroy();

  $hash = @$_REQUEST["hash"];

  $isFirstAccount = ($hash != "");

  $form = new HTML_QuickForm('formLogin', 'POST');
  $form->addElement("hidden", "hash", $hash);
  $form->addElement("text", "user", "Username (E-mail):", array("size"=>"20"));
  $form->addElement("password", "pass", "Password:", array("size"=>"20", "autocomplete"=>"off"));
  $form->addRule("user", "Set login", "required");
  $form->addRule("pass", "Set password", "required");
  $form->addElement("submit", "submit", "Login");

  $IsPost = $form->isSubmitted();
  $values = array();
  $error = "";

  if (@$_GET["login"])
     $values["user"] = $_GET["login"];

  $form->setDefaults($values);
  $values = $form->getSubmitValues();
  if ($IsPost && $form->validate())
  {
     do {
        if ($isFirstAccount){
            try{
                 $user->firstRegistration($values["user"], $values["pass"], $values["hash"]);
             }
             catch(SQLException $e){
                  $smarty->connection->rollback();
                  $de =  new DatabaseError($smarty->connection);
                  $smarty->assign("errorObj", $de->getErrorFromException($e));
            }
        }

        // login user
        if ($user->Login($values["user"], $values["pass"])) {
           // if user is login then redirect to next login page
           header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."login2.php");
           exit;
        }

         if ($values["user"] != "" && $values["pass"] != "")
            $error = "Verify entered login and password.";
    } while (false);
  }

  if ($IsPost && $error == "")
  {
     if (@$values["user"] == "" && @$values["pass"] == "")
        $error = "Set e-mail and password.";
     else
     {
         if (@$values["user"] == "")
             $error .= " Set e-mail.";
         if (@$values["pass"] == "")
             $error .= " Set password.";
     }
  }
 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 // send form data to Smarty
 $smarty->assign('values', $renderer->toArray());
 $smarty->assign('recover', "<a href=\"".$GLOBALS["PATH_FORM_ROOT"]."recover.php?USER_NAME=".@$values["user"]."\">
     I can't remember my password</a>");
 $smarty->assign('basepath', get_basepath());
 $smarty->assign("PATH_FORM_ROOT",$GLOBALS["PATH_FORM_ROOT"]);
 $smarty->assign('error', $error);
 $smarty->assign('header_title', 'Login ');
 $smarty->assign("isFirst", $isFirstAccount);

 
 if ($mobile_device)
   $smarty->display('mobile-login.tpl');
 else
   $smarty->display('login.tpl');
?>