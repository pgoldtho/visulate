<?

  require_once dirname(__FILE__)."/../../classes/SmartyInit.class.php";
  require_once dirname(__FILE__).'/../../classes/SQLExceptionMessage.class.php';
  require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
  require_once 'HTML/QuickForm.php';

  require_once dirname(__FILE__)."/../../classes/database/rnt_error_message.class.php";

  $smarty = new SmartyInit();

  if (!$smarty->user->isLogin())
  {
       // goto login page
       header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."login.php");
       exit;
  }

  $EM = new RNTErrorMessage($smarty->connection);
  $error_code = $_REQUEST["code"];
  $errorVal = $EM->getLongDescription($error_code);
  $smarty->assign("errorValue", $errorVal);
  $smarty->display("errorLong.tpl");
  $smarty->connection->close();
?>


