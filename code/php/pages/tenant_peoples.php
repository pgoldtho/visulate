<?

 require_once dirname(__FILE__)."/../classes/database/rnt_peoples.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

 $href = $GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2();
 $submenu3 = array(array("href" => $href, "value"=>"Peoples"),
                   array("href" => $href."&type=search", "value" => "Find")
          );

 $type = @$_REQUEST["type"];
 
 $mobile_device = Context::getMobileDevice();
 if ($mobile_device)
  {
   include dirname(__FILE__)."/tenant_peoples-people.php";
	 $template_name = "mobile-tenant-contact.tpl";
  }
 else
  {
 
   if ($type != "" && $type != "search")
     $type = "";

   if ($type == ""){
     include dirname(__FILE__)."/tenant_peoples-people.php";
     $template_name = "page-tenant_peoples-people.tpl";
     $skey = 0;
   }
   else if ($type == "search"){
     include dirname(__FILE__)."/tenant_peoples-search.php";
     $template_name = "page-tenant_peoples-search.tpl";
     $skey = 1;
   }
   else
     echo "error";
   $smarty->assign("submenu2_1", $submenu3);
   $smarty->assign("skey", $skey);
  }
?>

