<?

 require_once dirname(__FILE__)."/classes/SmartyInit.class.php";
 require_once dirname(__FILE__)."/classes/User.class.php";
 require_once dirname(__FILE__)."/classes/database/rnt_users.class.php";
 require_once dirname(__FILE__).'/classes/SQLExceptionMessage.class.php';
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

  $smarty = new SmartyInit();

  if (@$_GET["success"]){
     $smarty->assign("user", @$_GET["USER_NAME"]);
     $smarty->assign("href", $GLOBALS["PATH_FORM_ROOT"]."login.php?login=".@$_GET["USER_NAME"]);
     $m = array();
     preg_match("/https?:\/\/[^\/]+/", $GLOBALS["PATH_FORM_ROOT"], $m);
     $basepath = $m[0];
     $smarty->assign('basepath', $basepath);
     $smarty->assign("PATH_FORM_ROOT",$GLOBALS["PATH_FORM_ROOT"]);
     $smarty->display('recover_success.tpl');
     exit;
  }

  $form = new HTML_QuickForm('formLogin', 'POST');
  $form->addElement("text", "user", "E-mail:", array("size"=>"20"));
  $form->addRule("user", "Set login", "required");
  $form->addElement("submit", "submit", "Recover");

  $IsPost = $form->isSubmitted();
  $values = array();
  $error = "";

  if (@$_GET["USER_NAME"])
     $values["user"] = $_GET["USER_NAME"];

  $form->setDefaults($values);
  $values = $form->getSubmitValues();

  if (@$values["user"] == "" && !@$_GET["USER_NAME"])
        $error = "Enter your email address in the E-mail field then press the Recover button.";

  if ($IsPost && $form->validate())
  {
    try
    {
        $user = $smarty->user;
        $user->recover_password($values["user"]);
        header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."recover.php?USER_NAME=".$values["user"]."&success=1");
    }
    catch(SQLException $e)
    {
          $de =  new DatabaseError($smarty->connection);
          $smarty->assign("errorObj", $de->getErrorFromException($e));
    }
  }
 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 // send form data to Smarty
 $smarty->assign('values', $renderer->toArray());
 $smarty->assign('error', $error);
 $smarty->assign('header_title', 'Password Recovery');
 $smarty->assign('link', $GLOBALS["PATH_FORM_ROOT"]."login.php");
 $m = array();
 preg_match("/https?:\/\/[^\/]+/", $GLOBALS["PATH_FORM_ROOT"], $m);
 $basepath = $m[0];
 $smarty->assign('basepath', $basepath);
 $smarty->assign("PATH_FORM_ROOT",$GLOBALS["PATH_FORM_ROOT"]);

 $smarty->display('recover.tpl');
?>