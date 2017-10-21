<?php

$href = $GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2();

if (! $smarty->user->isSiteEditor() )
{
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
    exit;
}   

$submenu3 = array(array("href" => $href, "value"=>"Description"),
                  array("href" => $href."&type=data", "value" => "Data"));

// check menu level 3
$type = @$_REQUEST["type"];
$type = in_array($type, array("", "data")) ? $type : "";

if ($type == "")
{
    include dirname(__FILE__)."/city_data-description.php";
    $template_name = "page-city_data-description.tpl";
    $skey = 0;
}
elseif ($type == "data")
{
    include dirname(__FILE__)."/city_data-data.php";
    $template_name = "page-city_data-data.tpl";
    $skey = 1;
}
else
{
    echo "error";
}

$smarty->assign("submenu2_1", $submenu3);
$smarty->assign("skey", $skey);

?>