<?
  require_once dirname(__FILE__)."/../../classes/config.php";
  $path = $_REQUEST["path"];
  if ($path)
     header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."help/docs/".$path.".html");
  else
     header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."help/docs/pathNotFound.html");
?>