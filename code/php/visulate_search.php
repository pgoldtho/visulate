<?php

require_once dirname(__FILE__) . "/classes/SmartyInit.class.php";
require_once dirname(__FILE__) . "/classes/database/rnt_search.class.php";
require_once dirname(__FILE__) . "/classes/UtlConvert.class.php";
require_once dirname(__FILE__) . "/classes/SQLExceptionMessage.class.php";
require_once dirname(__FILE__) . "/classes/database/pr_reports.class.php";
require_once dirname(__FILE__) . "/classes/database/rnt_cities.class.php";
require_once dirname(__FILE__) . "/classes/User.class.php";
require_once dirname(__FILE__) . "/classes/database/sunbiz_updates.class.php";
require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
require_once "HTML/QuickForm.php";
require_once dirname(__FILE__) . "/classes/Menu.class.php";
require_once dirname(__FILE__) . "/classes/Menu3.class.php";

require_once dirname(__FILE__) . "/search/process_rentals.php";
require_once dirname(__FILE__) . "/search/process_city.php";
require_once dirname(__FILE__) . "/search/process_listing.php";
require_once dirname(__FILE__) . "/search/sales_requests.php";
require_once dirname(__FILE__) . "/search/display_property.php";
require_once dirname(__FILE__) . "/search/find_agent.php";
require_once dirname(__FILE__) . "/search/display_corp.php";
require_once dirname(__FILE__) . "/search/process_search.php";


if (!function_exists('http_response_code')) {

    function http_response_code($newcode = NULL) {
        static $code = 200;
        if ($newcode !== NULL) {
            header('X-PHP-Response-Code: ' . $newcode, true, $newcode);
            if (!headers_sent())
                $code = $newcode;
        }
        return $code;
    }
}

$smarty = new SmartyInit('http');
$dbReport = new PRReports($smarty->connection);

$mobile_device = is_mobile_browser();
if ($mobile_device) {
    $template_prefix = "mobile";
} else {
    $template_prefix = "visulate";
}

$user = $smarty->user;
if (!$user->isLogin()) {
    $smarty->assign("publicUser", "Y");
}

if (!$smarty->user->getRole()) {
    $smarty->user->setRole("PUBLIC");
}
// retrive menu data from database
require_once dirname(__FILE__) . "/classes/database/rnt_menus.class.php";
$rnt_menu = new RNTMenu($smarty->connection);
$is_mobile_browser = Context::getMobileDevice();

if ($is_mobile_browser) {
    $menu_data = $rnt_menu->getConfigMenuMobi();
    $item_menu1 = htmlentities(@$_REQUEST["m1"], ENT_QUOTES);

    if (!$item_menu2)
        $item_menu1 = "m_visulate_search";
    $item_menu2 = htmlentities(@$_REQUEST["REPORT_CODE"], ENT_QUOTES);

    if ($item_menu2 == "COMMERCIAL" || $item_menu2 == "SALES" || $item_menu2 == "LAND" || $item_menu2 == "CITY") {
        $item_menu2 = "m_CITY";
    } elseif ($item_menu2 == "SEARCH") {
        $item_menu2 = "m_PROPERTY_DETAILS";
    }

    if (htmlentities($_REQUEST["CORP_ID"], ENT_QUOTES) ||
            htmlentities($_REQUEST["corp_id"], ENT_QUOTES)) {
        $item_menu2 = "m_PROPERTY_DETAILS";
    }

    if (!$item_menu2)
        $item_menu2 = htmlentities(@$_REQUEST["m2"], ENT_QUOTES);

    if (!$item_menu2)
        $item_menu2 = "m_PROPERTY_DETAILS";
    if (substr($item_menu2, 0, 2) != "m_")
        $item_menu2 = "m_" . $item_menu2;

    $report_code = str_replace("m_", "", $item_menu2);
}
else {
    $menu_data = $rnt_menu->getConfigMenuPC();
    $item_menu1 = "visulate_search";
    $item_menu2 = htmlentities(@$_REQUEST["REPORT_CODE"], ENT_QUOTES);
    $report_code = $item_menu2;

    if ($item_menu2 == "COMMERCIAL" || $item_menu2 == "SALES" || $item_menu2 == "LAND" || $item_menu2 == "SEARCH") {
        $item_menu2 = "CITY";
    }

    if (!$item_menu2)
        $item_menu2 = htmlentities(@$_REQUEST["m2"], ENT_QUOTES);
    if (!$item_menu2)
        $item_menu2 = "LISTINGS";
}

$menu = new Menu($item_menu1, $item_menu2, $menu_data, $smarty->user);
$smarty->assign('menuObj', $menu);

//populate report list array for menu

$reportList = array();
if (!$report_code)
    $report_code = $item_menu2;
$x = array();

$x["href"] = "rental/visulate_search.php?REPORT_CODE=LISTINGS&qtype=COMMERCIAL&state=FL&county=MIAMI-DADE&ZCODE=Sale/Lease:13&MAX=A_MEDIAN";
$x["title"] = "Commercial Real Estate";
$x["code"] = "COMMERCIAL";
$reportList["COMMERCIAL"] = $x;

$x["href"] = "rental/visulate_search.php?REPORT_CODE=LISTINGS&qtype=LAND&state=FL&county=BREVARD&ZCODE=32926&MAX=A_MAX";
$x["title"] = "Vacant Land";
$x["code"] = "LAND";
$reportList["LAND"] = $x;

$x["href"] = "rental/visulate_search.php?REPORT_CODE=LISTINGS&qtype=RESIDENTIAL&state=FL&county=BREVARD&ZCODE=32952&MAX=A_MEDIAN";
$x["title"] = "Residential";
$x["code"] = "RESIDENTIAL";
$reportList["RESIDENTIAL"] = $x;

$qtype = htmlentities($_REQUEST["qtype"], ENT_QUOTES);
if ($qtype)
    $smarty->assign("qtype", $qtype);

$smarty->assign("reportCode", $report_code);
$smarty->assign("ReportList", $reportList);


if ($report_code) {
    // create form
    $form = new HTML_QuickForm('reports', 'POST');
    $IsPost = $form->isSubmitted();
    $header = @$reports[$report_code]["title"];
    $form->addElement("hidden", "REPORT_CODE", $report_code);

    if ($IsPost) {
        $report_data = array();
        if ($report_code == "PROPERTY_DETAILS" or $report_code == "CITY") {
            process_search($smarty, $template_prefix);
        } elseif ($_POST["REPORT_CODE"] == "SAVE2BU") {
            save2BU($smarty);
            display_property($smarty, $template_prefix, $dbReport);
        }
    } elseif ($_SERVER['REQUEST_METHOD'] == 'GET') {

        if (htmlentities($_REQUEST["OWNER_ID"], ENT_QUOTES)) {
            display_owner($smarty, $template_prefix, $dbReport);
        } elseif (htmlentities($_REQUEST["PROP_ID"], ENT_QUOTES) &&
                ($report_code != "LISTINGS")) {
            display_property($smarty, $template_prefix, $dbReport);
        } elseif (htmlentities($_REQUEST["CORP_ID"], ENT_QUOTES) ||
                htmlentities($_REQUEST["corp_id"], ENT_QUOTES)) {
            display_corp($smarty, $template_prefix, $dbReport);
        } else {
            if ($report_code == "RENTALS") {
                process_rentals($smarty, $template_prefix);
            } elseif ($report_code == "CITY") {
                process_city($smarty, $template_prefix);
            } elseif ($report_code == "LISTINGS") {
                process_listing($smarty, $template_prefix, $dbReport);
            } elseif ($report_code == "AJAX") {
                ajax_listings($smarty, $template_prefix, $dbReport);
            } elseif ($report_code == "SALES") {
                sales_request($smarty, $template_prefix, $dbReport);
            } elseif ($report_code == "COMMERCIAL") {
                commercial_sales($smarty, $template_prefix, $dbReport);
            } elseif ($report_code == "LAND") {
                land_sales($smarty, $template_prefix, $dbReport);
            } elseif ($report_code == "AGENT") {
                find_agent($smarty, $template_prefix, $dbReport);
            } elseif ($report_code == "SEARCH" || $report_code == PROPERTY_DETAILS) {
                process_search($smarty, $template_prefix);
            } else {
                $smarty->assign("pageTitle", "Search Florida Property Records");
                $smarty->assign("pageDesc", "Visulate maintains records for over 8,000,000 properties in Florida. Search for usage details, size, building features, current owner and sales history for any property in Brevard, Orange or Volusia county.");
                $html_report = $smarty->display($template_prefix . "-property-list.tpl");
            }
        }
    }
}
?>
