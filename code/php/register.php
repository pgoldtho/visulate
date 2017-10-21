<?

 require_once dirname(__FILE__)."/classes/SmartyInit.class.php";
 require_once dirname(__FILE__)."/classes/User.class.php";
 //require_once dirname(__FILE__)."/classes/database/rnt_users.class.php";
 require_once dirname(__FILE__)."/classes/SQLExceptionMessage.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

  $smarty = new SmartyInit();
  $success = false;
  if (@$_REQUEST["isPost"] == "true") {
     $success = true;
     $m = array();
     preg_match("/https?:\/\/[^\/]+/", $GLOBALS["PATH_FORM_ROOT"], $m);
     $basepath = $m[0];

     $smarty->assign('basepath', $basepath);
     $smarty->assign("PATH_FORM_ROOT",$GLOBALS["PATH_FORM_ROOT"]);
     $smarty->assign('header_title', 'Register ');
     $smarty->assign('success', '1');
     $smarty->display('register.tpl');
     exit;
  }


  $form = new HTML_QuickForm('formRegister', 'POST');
  $form->addElement("text", "LOGIN_EMAIL", "E-mail (used as login):", array("size"=>"30", "maxlength" => 50));
  $form->addElement("text", "FIRST_NAME", "First Name:", array("size"=>"30", "maxlength" => 50));
  $form->addElement("text", "LAST_NAME", "Last Name", array("size"=>"30", "maxlength" => 50));
  $form->addElement("text", "TELEPHONE", "Telephone", array("size"=>"20", "maxlength" => 30));
  $form->addElement("submit", "submit", "Request Account");

  // Apply filter for all data cells
  $form->applyFilter('__ALL__', 'trim');

  $form->addRule("LOGIN_EMAIL", 'required', 'required');
  $form->addRule('LOGIN_EMAIL', 'E-mail (login) is a not e-mail address.', 'email');
  $form->addRule("FIRST_NAME", 'required', 'required');
  $form->addRule("LAST_NAME", 'required', 'required');
  $form->addRule("TELEPHONE", 'required', 'required');

  $IsPost = $form->isSubmitted();
  $error = "";

  if ($IsPost && $form->validate()){

     $values = $form->getSubmitValues();

     do {

       // check user for existing in main table
       if ($smarty->user->isExistsUser($values["LOGIN_EMAIL"])){
           $smarty->assign("userAlreadyExists", 1);
           break;
       }

       try {
            // write data to database and send e-mail to user
            $hash = $smarty->user->registerAccount( $values["LOGIN_EMAIL"]
						                                      , $values["LAST_NAME"]
																									, $values["FIRST_NAME"]
																									, ""
																									, $values["TELEPHONE"]);
            
       } catch(SQLException $e) {
            $smarty->connection->rollback();
            $de =  new DatabaseError($smarty->connection);
            $smarty->assign("errorObj", $de->getErrorFromException($e));
            break;
       }

        header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."/register.php?isPost=true");
        exit;
     } while (false);

  }

 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 // send form data to Smarty
 $smarty->assign('form_data', $renderer->toArray());

 $m = array();
 preg_match("/https?:\/\/[^\/]+/", $GLOBALS["PATH_FORM_ROOT"], $m);
 $basepath = $m[0];

 $smarty->assign('basepath', $basepath);
 $smarty->assign("PATH_FORM_ROOT",$GLOBALS["PATH_FORM_ROOT"]);
 $smarty->assign('header_title', 'Register ');
 $smarty->display('register.tpl');
?>