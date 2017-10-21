<?
 $href = $GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2();

 require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_summary_analysis.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_reports.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once dirname(__FILE__)."/../classes/Context.class.php";


 if (!defined("HOME_SUMMARY"))
 {
    define("HOME_SUMMARY", "1");
 }

 $dbBU = new RNTBusinessUnit($smarty->connection);
 $buList = $dbBU->getAllBusinessUnits();
 $currentBUID = @$_REQUEST["BUSINESS_ID"];
 $mobile_device = Context::getMobileDevice();

 if ($currentBUID == null)
   $currentBUID = Context::getBusinessID();
 else
   Context::setBusinessID($currentBUID);

 if (!$currentBUID)
   $currentBUID = @$buList[0]["BUSINESS_ID"];

 if ($currentBUID)
    $smarty->user->verifyBUAccess($currentBUID);

 $dbAnalys = new RNTSummaryAnalysis($smarty->connection);
 $dbReport = new RNTReports($smarty->connection);

 $list1 = $dbAnalys->getPeriodAnalysesValues($currentBUID);
 $list2 = $dbAnalys->getNOI($currentBUID);

 $cashFlowList  = array("MONTHS"=>array(""), "INCOME"=>array("Income"), "EXPENSE"=>array("Expense"), "CASH_FLOW"=>array("Cash Flow"));
 $uncollectedIncomeList = array();
 $unpaidInvoicesList = array();
 $unpaidInvoicesList = array();
 $NOIList = array();
 $CapRateList = array();

 foreach($list1 as $v){
      $style = "";
      if ($v["CASH_FLOW"] < 0)
         $style = "style=\"color:red\"";
      else if ($v["CASH_FLOW"] > 0)
         $style = "style=\"color:green\"";
      $cashFlowList["MONTHS"][] = $v["MONTH_NAME"];
      $cashFlowList["INCOME"][] = "<nobr><a class=\"s\" href=\"?m2=payment_receiveable&BUSINESS_ID=$currentBUID&YEAR_MONTH_HIDDEN=".$v["YEAR_MONTH"]."\">".UtlConvert::dbNumericToDisplay($v["INCOME_AMOUNT"])."</a></nobr>";
      $cashFlowList["EXPENSE"][] = "<nobr><a class=\"s\" href=\"?m2=payment_payable&BUSINESS_ID=$currentBUID&YEAR_MONTH_HIDDEN=".$v["YEAR_MONTH"]."\">".UtlConvert::dbNumericToDisplay($v["EXPENSE_AMOUNT"])."</a></nobr>";
      $cashFlowList["CASH_FLOW"][] = "<span $style>".UtlConvert::dbNumericToDisplay($v["CASH_FLOW"])."</span>";
 }

 $currentYearCashList =  $dbAnalys->getCurrentYearCashFlow($currentBUID);
 $currentYearCashFlowList = array("MONTH_NAME"=>array(""), "INCOME_AMOUNT"=>array("Income"), "EXPENSE_AMOUNT"=>array("Expense"), "CASH_FLOW"=>array("Cash Flow"));
 foreach($currentYearCashList as $v){
      $style = "";
      if ($v["CASH_FLOW"] < 0)
         $style = "style=\"color:red\"";
      else if ($v["CASH_FLOW"] > 0)
         $style = "style=\"color:green\"";
      $currentYearCashFlowList["MONTH_NAME"][] = $v["MONTH_NAME"];
      $currentYearCashFlowList["INCOME_AMOUNT"][] = "<nobr><a class=\"s\" href=\"?m2=payment_receiveable&BUSINESS_ID=$currentBUID&YEAR_MONTH_HIDDEN=".$v["YEAR_MONTH"]."\">".UtlConvert::dbNumericToDisplay($v["INCOME_AMOUNT"])."</a></nobr>";
      $currentYearCashFlowList["EXPENSE_AMOUNT"][] = "<nobr><a class=\"s\" href=\"?m2=payment_payable&BUSINESS_ID=$currentBUID&YEAR_MONTH_HIDDEN=".$v["YEAR_MONTH"]."\">".UtlConvert::dbNumericToDisplay($v["EXPENSE_AMOUNT"])."</a></nobr>";
      $currentYearCashFlowList["CASH_FLOW"][] = "<span $style>".UtlConvert::dbNumericToDisplay($v["CASH_FLOW"])."</span>";
 }

 $r1 = array();
 $r2 = array();
 $r3 = array();
 foreach($list1 as $v){
 	$r1[] = $v['MONTH_NAME'];
 	$style = "";
 	if ($v["UNCOLLECTED_INCOME"] > $v["OWED_AMOUNT"]*0.05)
       $style = "style=\"color:red\"";

    $r2[] = "<nobr><a $style class=\"s\" href=\"?m2=payment_receiveable&BUSINESS_ID=$currentBUID&YEAR_MONTH_HIDDEN=".$v["YEAR_MONTH"]."\">".UtlConvert::dbNumericToDisplay($v["UNCOLLECTED_INCOME"])."</a></nobr>";
    $style = "";
    if ($v["UNPAID_INVOICES"] > $v["INVOICED_AMOUNT"]*0.05)
       $style = "style=\"color:red\"";
    $r3[] = "<nobr><a $style class=\"s\" href=\"?m2=payment_payable&BUSINESS_ID=$currentBUID&YEAR_MONTH_HIDDEN=".$v["YEAR_MONTH"]."\">".UtlConvert::dbNumericToDisplay($v["UNPAID_INVOICES"])."</a></nobr>";
 }

 $income_invoice = array("MONTH_NAMES" => $r1,
                         "UNCOLLECTED_INCOME" => $r2,
                         "UNPAID_INVOICES" => $r3
                          );


  // NOI
  foreach($list2 as $v){
    $style = "";
    if ($v["NOI_VALUE"] <= 0)
       $style = "style=\"color:red\"";
    $NOIList[] = "<nobr><a $style class=\"s\" href=\"?m2=property_finance&prop_id=".$v["PROPERTY_ID"]."\">".$v["ADDRESS1"].": ".UtlConvert::dbNumericToDisplay($v["NOI_VALUE"])."</a></nobr>";
 }

  // Cap Rate
  foreach($list2 as $v){
    $style = "";
    if ($v["CAP_RATE_VALUE"] <= 0)
       $style = "style=\"color:red\"";
    $CapRateList[] = "<nobr><a class=\"s\" $style href=\"?m2=property_finance&prop_id=".$v["PROPERTY_ID"]."\">".$v["ADDRESS1"].": ".UtlConvert::dbNumericToDisplay($v["CAP_RATE_VALUE"])."</a></nobr>";
 }

 $alertList = array();
 $alerts = $dbAnalys->getAlertList($currentBUID);
 if ($mobile_device)
  {
   $agreement_m2  = 'm_agreements';
   $tenant_m2     = 'm_tenants';
   $receivable_m2 = 'm_receivable';
   $payable_m2    = 'm_payable';
   $expense_m2    = 'm_jobs';
  }
 else
  {
   $agreement_m2  = 'tenant_agreements';
   $tenant_m2     = 'tenant_tenants';
   $receivable_m2 = 'payment_receiveable';
   $payable_m2    = 'payment_payable';
   $expense_m2    = 'property_expense';
  }
 
 foreach($alerts as $v) {
     $href = "";
     if ($v["IS_AGREEMENT_EXPIRED"] == "Y")
          $href = "?m2=".$agreement_m2."&prop_id=".$v["PROPERTY_ID"]."&UNIT_ID=".$v["UNIT_ID"]."&AGR_AGREEMENT_ID=".$v["AGREEMENT_ID"];
     else if ($v["IS_VACANT"] == "Y") {
             if (!$v["UNIT_ID"])
                 $href = "?m2=".$agreement_m2."&prop_id=".$v["PROPERTY_ID"];
             else
                 $href = "?m2=".$agreement_m2."&prop_id=".$v["PROPERTY_ID"]."&UNIT_ID=".$v["UNIT_ID"];
          }
     else if ($v["IS_TENANT_OWED"] == "Y")
          $href = "?m2=".$tenant_m2."&prop_id=".$v["PROPERTY_ID"]."&TENANT_ID=".$v["TENANT_ID"];
     else if ($v["IS_UNCOLLECTED_INCOME"] == "Y")
          $href = "?m2=".$receivable_m2."&BUSINESS_ID=".$v["BUSINESS_ID"]."&YEAR_MONTH_HIDDEN=".$v["PAYMENT_DUE_MONTH"];
     else if ($v["IS_UNPAID_BALANCE"] == "Y")
          $href = "?m2=".$payable_m2."&BUSINESS_ID=".$v["BUSINESS_ID"]."&YEAR_MONTH_HIDDEN=".$v["PAYMENT_DUE_MONTH"];
     else if ($v["IS_UNINVOICED"] == "Y")
          $href = "?m2=".$expense_m2."&EXPENSE_ID=".$v["AGREEMENT_ID"]."&prop_id=".$v["PROPERTY_ID"]."&currYear=".$v["PAYMENT_DUE_MONTH"];
     /*else if ($v["IS_NO_PROPERTIES"] == "Y")
          $href = "?m2=property_details&BUSINESS_ID=".$v["BUSINESS_ID"];*/

     $alertList[] = "<a href=\"$href\">".$v["DESCRIPTION"]."</a>";
 }

 $summaryTable = $dbAnalys->getSummaryTable($currentBUID);
 $valuesTable = $summaryTable;
 $total_noi = 0;
 foreach ($summaryTable as &$v){
        $total_noi = $total_noi + $v["NOI_VALUE"];
        $v["INCOME_AMOUNT"]      = UtlConvert::dbNumericToDisplay($v["INCOME_AMOUNT"]);
        $v["EXPENSE_AMOUNT"]     = UtlConvert::dbNumericToDisplay($v["EXPENSE_AMOUNT"]);
        $v["IS_CASH_FLOW_GOOD"]  = $v["CASH_FLOW"] > 0 ? "yes" : "no";
        $v["CASH_FLOW"]          = UtlConvert::dbNumericToDisplay($v["CASH_FLOW"]);
        $v["UNCOLLECTED_INCOME"] = UtlConvert::dbNumericToDisplay($v["UNCOLLECTED_INCOME"]);
        $v["UNPAID_INVOICES"]    = UtlConvert::dbNumericToDisplay($v["UNPAID_INVOICES"]);
        $v["NOI_VALUE"]          = UtlConvert::dbNumericToDisplay($v["NOI_VALUE"]);
        $v["CAP_RATE_VALUE"]     = UtlConvert::dbNumericToDisplay($v["CAP_RATE_VALUE"]);
        $v["ADDRESS1"]           =  "<a href=\"?m2=property_summary&prop_id=".$v["PROPERTY_ID"]."\">".$v["ADDRESS1"]."</a>";
 }
 unset($v);
 
 foreach ($valuesTable as &$v){
    $v["NOI"] = UtlConvert::dbNumericToDisplay($v["NOI_VALUE"]);
	$v["5CAP"] = UtlConvert::dbNumericToDisplay($v["NOI_VALUE"]/5*100);
	$v["6CAP"] = UtlConvert::dbNumericToDisplay($v["NOI_VALUE"]/6*100);
	$v["7CAP"] = UtlConvert::dbNumericToDisplay($v["NOI_VALUE"]/7*100);
	$v["8CAP"] = UtlConvert::dbNumericToDisplay($v["NOI_VALUE"]/8*100);
	$v["9CAP"] = UtlConvert::dbNumericToDisplay($v["NOI_VALUE"]/9*100);
	$v["10CAP"] = UtlConvert::dbNumericToDisplay($v["NOI_VALUE"]/10*100);
	$v["11CAP"] = UtlConvert::dbNumericToDisplay($v["NOI_VALUE"]/11*100);
	$v["12CAP"] = UtlConvert::dbNumericToDisplay($v["NOI_VALUE"]/12*100);
	}
 unset($v);

 $valuesTable[] = array(
     "ADDRESS1" => "<b>Total</b>",
     "NOI" => UtlConvert::dbNumericToDisplay($total_noi),
     "5CAP" => UtlConvert::dbNumericToDisplay($total_noi/5 *100),
     "6CAP" => UtlConvert::dbNumericToDisplay($total_noi/6 *100),
     "7CAP" => UtlConvert::dbNumericToDisplay($total_noi/7 *100),
     "8CAP" => UtlConvert::dbNumericToDisplay($total_noi/8 *100),
     "9CAP" => UtlConvert::dbNumericToDisplay($total_noi/9 *100),
     "10CAP" => UtlConvert::dbNumericToDisplay($total_noi/10 *100),
     "11CAP" => UtlConvert::dbNumericToDisplay($total_noi/11 *100),
     "12CAP" => UtlConvert::dbNumericToDisplay($total_noi/12 *100));
	
 
 $curDate = date("m/d/Y");
 $incomeStatement = $dbReport->getIncomeStatement($currentBUID, "", $curDate, 1);

 $cashFlowSum = $dbAnalys->getCashFlowSum($currentBUID);
 foreach($cashFlowSum as $k=>$v)
    foreach($v as $k1=>$v1)
       foreach($v1 as $k2=>$v2)
           $cashFlowSum[$k][$k1][$k2] = UtlConvert::dbNumericToDisplay($v2);

 $isExistsBULevel2 = $smarty->user->isExistsBULevel2();
 $isOnlyAlerts = false;

 if (!$isExistsBULevel2){
 	$isOnlyAlerts = true;
 	if ($smarty->user->isManagerOwner() || $smarty->user->isBusinessOwner())
      $alertList[] = "You have no Business SubUnits (Business Unit of second level). <a href=\"?".$menu->request_menu_level2."=property_business_units\">Define first Sub Business Units</a>.";
    else
      $alertList[] = "You have Business SubUnits. OwnerManager or BusinessOwner must defined it.";
 } else {

 	// check if for all business units exists properties
 	if (!$dbBU->isExistsProperties($currentBUID)){
 		$isOnlyAlerts = true;
 	}

 	$noProp = $dbAnalys->getBUwhereNotProperties($currentBUID);
 	foreach ($noProp as $v) {
 		if ($smarty->user->isOwner() || $smarty->user->isManagerOwner() || $smarty->user->isManager() || $smarty->user->isBusinessOwner())
            array_unshift($alertList, "<span class=error>You have no properties in Business Unit \"".$v["BUSINESS_NAME"]."\". <a href=\"?".$menu->request_menu_level2."=property_details&BUSINESS_ID=".$v["BUSINESS_ID"]."&withoutContext=true\">Define first it</a></span>.");
        else
            // its manager
            array_unshift($alertList, "You have no properties in Business Unit \"".$v["BUSINESS_NAME"]."\". Owners must define it.");
 	}
 }

 $buInfo =  $dbBU->getBusinessUnit($currentBUID);
 $smarty->assign("header_title", @$buInfo["BUSINESS_NAME"]." Business Summary - ".date("M d, Y"));
 $smarty->assign("businessList", $buList);
 $smarty->assign("businessID", $currentBUID);
 $smarty->assign("cashFlowList", $cashFlowList);
 $smarty->assign("uncollectedIncomeList", $uncollectedIncomeList);
 $smarty->assign("unpaidInvoicesList", $unpaidInvoicesList);
 $smarty->assign("NOIList", $NOIList);
 $smarty->assign("CapRateList", $CapRateList);
 $smarty->assign("alertList", $alertList);
 $smarty->assign("summaryTable", $summaryTable);
 $smarty->assign("valuesTable", $valuesTable);
 $smarty->assign("currentMonthCashFlow", $currentMonthCashFlowList);
 $smarty->assign("currentYearCashFlow", $currentYearCashFlowList);
 $smarty->assign("CashFlowSum", $cashFlowSum);
 $smarty->assign("isOnlyAlerts", $isOnlyAlerts);
 $smarty->assign("income_invoice", $income_invoice);
  $smarty->assign("income_statement", $incomeStatement);

?>
