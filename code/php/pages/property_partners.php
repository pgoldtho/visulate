<?
 $href = $GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2();
 $submenu3 = array(array("href" => $href, "value"=>"Partners"),
                   array("href" => $href."&type=search", "value" => "Find")
          );

 $type = @$_REQUEST["type"];
 if ($type != "" && $type != "search")
   $type = "";

 if ($type == ""){
   include dirname(__FILE__)."/property_partners-partner.php";
   $template_name = "page-property_partners-partner.tpl";
   $skey = 0;
 }
 else if ($type == "search"){
   include dirname(__FILE__)."/property_partners-search.php";
   $template_name = "page-property_partners-search.tpl";
   $skey = 1;
 }
 else
   echo "error";
 $smarty->assign("submenu2_1", $submenu3);
 $smarty->assign("skey", $skey);

?>
