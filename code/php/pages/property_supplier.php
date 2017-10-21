<?
 $href = $GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2();
 $submenu3 = array(array("href" => $href, "value"=>"Details"),
                   array("href" => $href."&type=search", "value" => "Find")
          );

 $mobile_device = Context::getMobileDevice();
 if ($mobile_device)
  {
   include dirname(__FILE__)."/property_supplier-supplier.php";
	 $template_name = "mobile-supplier.tpl";
  }
 else
  {
   $type = @$_REQUEST["type"];
   if ($type != "" && $type != "search")
     $type = "";

   if ($type == ""){
     include dirname(__FILE__)."/property_supplier-supplier.php";
     $template_name = "page-property_supplier-supplier.tpl";
     $skey = 0;
   }
   else if ($type == "search"){
     include dirname(__FILE__)."/property_supplier-search.php";
     $template_name = "page-property_supplier-search.tpl";
     $skey = 1;
   }
   else
     echo "error";
   $smarty->assign("submenu2_1", $submenu3);
   $smarty->assign("skey", $skey);
  }

?>
