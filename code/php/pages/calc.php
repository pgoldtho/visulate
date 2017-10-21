<?php
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_cities.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

///////////////////////////////////////////////////
//Main Body
///////////////////////////////////////////////////
    $smarty = new SmartyInit('http');
    //$dbReport = new PRReports($smarty->connection);

    //$mobile_device = Context::getMobileDevice();
    $mobile_device = is_mobile_browser();
    if ($mobile_device)
    {
        $template_prefix = "mobile";
    }
    else
     {
        $template_prefix = "visulate";
    }

    $user = $smarty->user;
    if (!$user->isLogin())
    {

      $smarty->assign("publicUser", "Y");
    }

    if (!$smarty->user->getRole())
    {
      $smarty->user->setRole("PUBLIC");
    }
  // retrive menu data from database
  require_once dirname(__FILE__)."/../classes/database/rnt_menus.class.php";
  $rnt_menu  = new RNTMenu($smarty->connection);
  $is_mobile_browser = Context::getMobileDevice();

  if ($is_mobile_browser)
  {
   $menu_data = $rnt_menu->getConfigMenuMobi();
   $item_menu1 = htmlentities(@$_REQUEST["m1"], ENT_QUOTES);

   if (!$item_menu2) $item_menu1 = "calc";
   if (!$item_menu2) $item_menu2 = htmlentities(@$_REQUEST["m2"], ENT_QUOTES);
   if (!$item_menu2) $item_menu2 = "cap-rate";
  }

  if ($item_menu2 == "cap-rate")
   {
    $smarty->assign('pageTitle','Income Valuation Estimate');
    $smarty->assign('pageDesc','Use this form to calculate the income value for a rental property');
   }
  elseif ($item_menu2 == "repair")
   {
    $smarty->assign('pageTitle','Rehab Repair Estimates');
    $smarty->assign('pageDesc','Use this form to estimate the repair cost for a property');
   }
  elseif ($item_menu2 == "mortgage")
   {
    $smarty->assign('pageTitle','Mortgage Payment Calculator');
    $smarty->assign('pageDesc','Use this form to calculate monthly mortgage payments.');
   }
  elseif ($item_menu2 == "cash-flow")
   {
    $smarty->assign('pageTitle','Real Estate Investment Worksheet');
    $smarty->assign('pageDesc','Use this form to help evaluate potential cash flow for a real estate investment.');
   }

  $menu = new Menu($item_menu1, $item_menu2, $menu_data, $smarty->user);
  $smarty->assign('menuObj',$menu);
  $smarty->assign('menu2', $item_menu2);

  $dbCity   = new RNTCities($smarty->connection);
  $backgroundImg = $dbCity->getRandomImage();
  $smarty->assign("backgroundImg", $backgroundImg);

  $html_report = $smarty->display($template_prefix."-calc.tpl");
