<?
 $href = $GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2();

 if (! ($smarty->user->isOwner()
        || $smarty->user->isManager()
	    	|| $smarty->user->isManagerOwner()
		    || $smarty->user->isBuyer()
		    || $smarty->user->isBookkeeping()
		    || $smarty->user->isBusinessOwner()))
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
    exit;
 } elseif ($smarty->user->isBuyer()) {

     $submenu3 = array(array("href" => $href, "value"=>"Estimates"),
                       array("href" => $href."&type=status", "value" => "Status")
     );

     $type = (htmlentities($_REQUEST["type"], ENT_QUOTES));
     if ($type != "" && $type != "status")
         $type = "";

     if ($type == ""){
         $template_name = "page-property_home_summary-estimates.tpl";
         $skey = 0;
     }
     else if ($type == "status"){
         $template_name = "page-property_home_summary-status.tpl";
         $skey = 1;
     }
     else
         echo "error";

     $smarty->assign("submenu2_1", $submenu3);
     $smarty->assign("skey", $skey);

     include dirname(__FILE__)."/property_home_summary-buyer.php";
 }
 else
 {
     $submenu3 = array(array("href" => $href, "value"=>"Alerts"),
                       array("href" => $href."&type=cash", "value" => "Cashflow"),
                       array("href" => $href."&type=perf", "value" => "Performance"),
     );

     $mobile_device = Context::getMobileDevice();

     
     $type = @$_REQUEST["type"];
     if ($type != "" && $type != "cash" && $type != "perf")
         $type = "";

     if ($mobile_device) {
         $template_name = "mobile-home_summary.tpl";
     }
     else if ($type == "") {
         $template_name = "page-property_home_summary.tpl";
         $skey = 0;
     }
     else if ($type == "cash") {
         $template_name = "page-property_home_summary-cash.tpl";
         $skey = 1;
     }
     else if ($type == "perf") {
         $template_name = "page-property_home_summary-perf.tpl";
         $skey = 2;
     }
     else
        echo "error";

     $smarty->assign("submenu2_1", $submenu3);
     $smarty->assign("skey", $skey);

     include dirname(__FILE__)."/property_home_summary-others.php";
 }
?>
