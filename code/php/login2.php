<?
  require_once dirname(__FILE__)."/classes/SmartyInit.class.php";
  require_once dirname(__FILE__)."/classes/User.class.php";
  require_once dirname(__FILE__)."/classes/database/rnt_users.class.php";
  require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
  require_once "HTML/QuickForm.php";

  $smarty = new SmartyInit();
  $user = $smarty->user;

  if (@$_POST["logout"])
      $user->destroy();

  if (!$user->isLogin())
  {
      // if user is not login then redirect to login page
      header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."login.php");
      exit;
  }
 else
  {
	$mobile_device = is_mobile_browser();
	Context::setMobileDevice($mobile_device);
  }


  // set current user_id
  $smarty->user->set_database_user();

  $error = "";
  $needChoose = false;
  if (!$smarty->user->isHasAssignment())
     // User not have a assignment
     $error = "You have not assignment. Address to administrator.";
  else
  {
     // check count of roles
     $roles = $smarty->user->getRoles();
     if ($smarty->user->needChooseRoles())
        $needChoose = true;
     else
     {
        if (array_key_exists("MANAGER", $roles))
            $smarty->user->setRole("MANAGER");
        else if (array_key_exists("MANAGER_OWNER", $roles))
            $smarty->user->setRole("MANAGER_OWNER");
        else if (array_key_exists("OWNER", $roles))
           $smarty->user->setRole("OWNER");
        else if (array_key_exists("ADMIN", $roles))
           $smarty->user->setRole("ADMIN");
        else if (array_key_exists("BUSINESS_OWNER", $roles))
           $smarty->user->setRole("BUSINESS_OWNER");

        // Redirect to index page
        header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
        exit;
     }
  }

  $form = new HTML_QuickForm('formLogin', 'POST');
  if ($needChoose)
  {
    if ($mobile_device)
      { 
        // limit list of roles until all roles have mobile templates
        $roles = array ( 'MANAGER_OWNER' => 'Owner Manager'
				               , 'MANAGER'       => 'Manager');
      }
    else
      {
      $roles = $smarty->user->getRoleNames();
      }
    
    $form->addElement("select", "role", "Choose role:", $roles);
    $form->addElement("submit", "submit", "Continue");
  }
  $form->addElement("submit", "logout", "Logout");

  $IsPost = $form->isSubmitted();

  $values = array();
  if (!$IsPost)
    $values["role"] = $smarty->user->getRole();
    

  $form->setDefaults($values);
  $values = $form->getSubmitValues();

  if ($IsPost && $form->validate())
  {
     // user choose the role
     $smarty->user->setRole($values["role"]);
     
     // redirect to index page
     header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
     exit;
  }

 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 // send form data to Smarty
 $smarty->assign('values', $renderer->toArray());
 $smarty->assign('error', $error);
 $smarty->assign('header_title', 'Choose the role - ');
 $m = array();
 preg_match("/https?:\/\/[^\/]+/", $GLOBALS["PATH_FORM_ROOT"], $m);
 $basepath = $m[0];
 $smarty->assign('basepath', $basepath);
 $smarty->assign("PATH_FORM_ROOT",$GLOBALS["PATH_FORM_ROOT"]);

 if ($mobile_device)
   $smarty->display('mobile-login2.tpl');
 else
   $smarty->display('login2.tpl');
?>