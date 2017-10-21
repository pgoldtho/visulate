<?
 $href = $GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2();
 $submenu3 = array(array("href" => $href, "value"=>"Section8"),
                   array("href" => $href."&type=search", "value" => "Find")
          );

 $type = @$_REQUEST["type"];
 if ($type != "" && $type != "search")
   $type = "";

 if ($type == ""){
   include dirname(__FILE__)."/property_section8-section8.php";
   $template_name = "page-property_section8-section8.tpl";
   $skey = 0;
 }
 else if ($type == "search"){
   include dirname(__FILE__)."/property_section8-search.php";
   $template_name = "page-property_section8-search.tpl";
   $skey = 1;
 }
 else
   echo "error";
 $smarty->assign("submenu2_1", $submenu3);
 $smarty->assign("skey", $skey);

?>
