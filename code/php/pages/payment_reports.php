<?
 require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_acc_payable.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_properties.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_agreement.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_reports.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once dirname(__FILE__)."/../classes/Context.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";


//Menu Items
 $report_code = @$_REQUEST["REPORT_CODE"];
 $reports = array();
 
 $reports["GL_BALANCE"] = array(
     "roles" => array("MANAGER_OWNER"
		                , "MANAGER"
										, "BUSINESS_OWNER"
										, "BOOKKEEPING"
										, "BUYER" 
										, "OWNER" ),
     "title" => "Balance Sheet"
 );
 
 $reports["GL_INCOME"] = array(
     "roles" => array("MANAGER_OWNER"
		                , "MANAGER"
										, "BUSINESS_OWNER"
										, "BOOKKEEPING"
										, "BUYER" 
										, "OWNER" ),
     "title" => "Income Statement"
 );

 $reports["PROPERTY_SUMMARY"] = array(
     "roles" => array("MANAGER_OWNER"
		                , "MANAGER"
										, "BUSINESS_OWNER"
										, "BOOKKEEPING"
										, "BUYER" ),
     "title" => "Property Summary"
 );
 
 $reports["INCOME_AND_EXPENSES"] = array(
     "roles" => array("MANAGER_OWNER"
		                , "MANAGER"
										, "BUSINESS_OWNER"
										, "BOOKKEEPING"
										, "BUYER" ),
     "title" => "Income and Expenses"
 );
 
 $reports["EXPENSE_DETAILS"] = array(
     "roles" => array("MANAGER_OWNER"
		                , "MANAGER"
										, "BUSINESS_OWNER"
										, "BOOKKEEPING"
										, "BUYER" ),
     "title" => "Expense Details"
 );

 $reports["GL_HISTORY"] = array(
     "roles" => array("MANAGER_OWNER"
		                , "MANAGER"
										, "BUSINESS_OWNER"
										, "BOOKKEEPING"
										, "BUYER" 
										, "OWNER" ),
     "title" => "General Ledger History"
 );

 $reports["GL_SUMMARY"] = array(
     "roles" => array("MANAGER_OWNER"
		                , "MANAGER"
										, "BUSINESS_OWNER"
										, "BOOKKEEPING"
										, "BUYER" 
										, "OWNER" ),
     "title" => "General Ledger Summary"
 );
 
 $reports["GL_DETAILS"] = array(
     "roles" => array("MANAGER_OWNER"
		                , "MANAGER"
										, "BUSINESS_OWNER"
										, "BOOKKEEPING"
										, "BUYER" 
										, "OWNER" ),
     "title" => "General Ledger Details"
 );

 $reports["COMMISSIONS"] = array(
     "roles" => array("MANAGER_OWNER"
		                , "MANAGER"
										, "BUSINESS_OWNER"
										, "BOOKKEEPING"
										, "OWNER" ),
     "title" => "Property Manager Commission"
 );

 $reports["TENANT_MONTH_STATEMENT"] = array(
     "roles" => array("MANAGER_OWNER", "MANAGER", "OWNER", "BOOKKEEPING"),
     "title" => "Monthly Tenant Statements"
 );
 

 

 if (!defined("HOME_SUMMARY")){
      define("HOME_SUMMARY", "1");
 }

 $dbBU     = new RNTBusinessUnit($smarty->connection);
 $dbProp   = new RNTProperties($smarty->connection);
 $dbReport = new RNTReports($smarty->connection);
 $dbAgr    = new RNTAgreement($smarty->connection);
 $dbAP     = new RNTAccountPayable($smarty->connection);

 $reportList = array();
 foreach ($reports as $k=>$v) {
 	if (!in_array($smarty->user->getRole(), $v["roles"]))
 	   continue;
 	$x=array();
 	$x["href"] = "?m2=payment_reports&REPORT_CODE=".$k;
 	$x["title"] = $v["title"];
 	$x["code"] = $k;
 	$reportList[$k] = $x;
 }

 if (!$report_code || !array_key_exists($report_code, $reportList)){
 	reset($reportList);
    $report_code = key($reportList);
 }

 if ($report_code) {
 	     // create form
		 $form = new HTML_QuickForm('reports', 'POST');
		 $IsPost = $form->isSubmitted();
     $form->registerRule('vnumeric', 'function', 'validateNumeric');
         $header = @$reports[$report_code]["title"];


 	     // property_id for page menu level 3 - its property
	     // $form->AddElement("hidden", $menu3->request_property_id, $menu3->current_property_id);
	     // menu 2 level
	     $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
	     $form->addElement("submit", "submit_html", "Html");
	     $form->addElement("submit", "submit_pdf", "Pdf");
	     $form->addElement("hidden", "REPORT_CODE", $report_code);

//Generate Form for Report Parameters
		 if ( $report_code == "INCOME_AND_EXPENSES" 
		   || $report_code == "EXPENSE_DETAILS"
			 || $report_code == "GL_SUMMARY"
			 || $report_code == "GL_DETAILS") 
		 {
   		    // $form->addElement("select", "year", "Select year", $dbReport->getAvailableYears());

   		     // parameter: Business Unit (list)
		     $form->addElement("select", "BUSINESS_ID", "Business Name", $dbBU->getBusinessUnitsList());

		     // parameters: period start and period end dates
  	         $form->AddElement("text", "PERIOD_START_DATE", "Report period start", array('size' => 10));
  	         $dates_elements[] = "PERIOD_START_DATE";
  	         $form->AddElement("text", "PERIOD_END_DATE", "Report period end", array('size' => 10));
  	         $dates_elements[] = "PERIOD_END_DATE";

  	         // Append rules for DATE elements
  	         $form->registerRule('vdate', 'function', 'validateDate');

  	         // add rules for period start date
  	         //$form->addRule("PERIOD_START_DATE", 'Invalid date format', 'regex', '/^(0[1-9]|1[0-2])\/(0[1-9]|[1-2][0-9]|3[0-1])\/[0-9]{4}$/');
  	         $form->addRule("PERIOD_START_DATE", UtlConvert::ErrorDateMsg, 'vdate');

  	         // add rules for period end date
  	         //$form->addRule("PERIOD_END_DATE", 'Invalid date format', 'regex', '/^(0[1-9]|1[0-2])\/(0[1-9]|[1-2][0-9]|3[0-1])\/[0-9]{4}$/');
  	         $form->addRule("PERIOD_END_DATE", UtlConvert::ErrorDateMsg, 'vdate');
  	         $smarty->assign("dates", $dates_elements);
  	         
  	         if ($report_code == "EXPENSE_DETAILS") 
  	        {
  	         $form->addElement(
  	              "select",
  	              "PAYMENT_TYPE_ID",
  	              "Expense Type",
  	              $dbAP->getPaymentTypeList() );				                   
  	         }
  	         
  	        // parameter: selector of accrual/cash basis
 	          if ( $report_code == "EXPENSE_DETAILS" 
						  || $report_code == "INCOME_AND_EXPENSES" ) 
 	          {
  	         $form->addElement(
  	              "select",
  	              "BASIS",
  	              "Select basis",
  	              array("accrual"=>"Accrual", "cash" => "Cash")
  	         );
  	        }
		 }
		 elseif ($report_code == "TENANT_MONTH_STATEMENT")
		 {
		 	 $businessList = $dbBU->getBusinessUnitsList();
		 	 $b_x = array();
		 	 $p_x = array();
		 	 $a_x = array();
		 	 foreach($businessList as $k=>$v) {
		 	     $b_x[$k] = $v;
		 	     $propertiesList = $dbProp->getPropertyLOV($k);
		 	     $p_x[$k][""] = "-- All --";
		 	     $f = 0;
		 	 	 foreach($propertiesList as $k1=>$v1) {
		 	 	     $f = 1;
		 	 	     $p_x[$k][$k1] = $v1;
		 	 	     $a_x[$k][$k1][""] = "-- Only for Active Agreements --";
		 	 	     $agrList = $dbAgr->getAgreementsForProp($k1);
		 	 	     $ff = 0;

		 	 	     foreach($agrList as $k2=>$v2) {
		 	 	         $a_x[$k][$k1][$k2] = $v2;
		 	 	         $ff = 1;
		 	 	 	 }

		 	 	 	 if (!$ff)
		 	 	 	     $p_x[$k][$k1][""] = " -- Empty -- ";
		 	 	 }
		 	 	 if (!$f) {
		 	 	     $p_x[$k][""] = " -- Empty -- ";
		 	 	     $a_x[$k][""][""] = " -- Empty -- ";
		 	 	 }
		 	 }
		 	 $sel = &$form->addElement('hierselect', 'AGREEMENTS', 'Select:');
             $sel->setOptions(array($b_x, $p_x, $a_x));
		 }
		 elseif ($report_code == "PROPERTY_SUMMARY")
		 {
		 	 $businessList = $dbBU->getBusinessUnitsList();
		 	 $b_x = array();
		 	 $p_x = array();
		 	 foreach($businessList as $k=>$v) {
		 	     $b_x[$k] = $v;
		 	     $propertiesList = $dbProp->getPropertyLOV($k);
		 	     $p_x[$k][""] = "-- All --";
		 	 	 foreach($propertiesList as $k1=>$v1) {
		 	 	 	   $p_x[$k][$k1] = $v1;
		 	 	 }
	 	 	 
		 	 }
		 	$sel = &$form->addElement('hierselect', 'PROPERTIES', 'Select:');
         $sel->setOptions(array($b_x, $p_x));
		 }
		 elseif ($report_code == "GL_BALANCE")
		 	 {
    		 $form->addElement("select", "BUSINESS_ID", "Business Name", $dbBU->getBusinessUnitsList());
  	     $form->AddElement("text", "EFFECTIVE_DATE", "Effective Date", array('size' => 10));
  	     $dates_elements[] = "EFFECTIVE_DATE";
  	        
  	     $form->registerRule('vdate', 'function', 'validateDate');
         $form->addRule("EFFECTIVE_DATE", UtlConvert::ErrorDateMsg, 'vdate');
         $smarty->assign("dates", $dates_elements);		 
  	   }		
		 elseif ($report_code == "GL_INCOME")
		 	 {
			 $form->AddElement("select", "REPORT_TYPE", "Accounting Basis",
                           array("CASH"=>"Cash", "ACCRUAL" => "Accrual"));
//    		 $form->addElement("select", "BUSINESS_ID", "Business Name", $dbBU->getBusinessUnitsList());
    		 $businessList = $dbBU->getBusinessUnitsList();
    	 	 $b_x = array();
   		 	 $p_x = array();
		   	 foreach($businessList as $k=>$v) {
		 	     $b_x[$k] = $v;
		 	     $propertiesList = $dbProp->getPropertyLOV($k);
		 	     $p_x[$k][""] = "-- All --";
		 	 	   foreach($propertiesList as $k1=>$v1) {
		 	 	 	   $p_x[$k][$k1] = $v1;
		 	 	   }
         }
    		 $sel = &$form->addElement('hierselect', 'PROPERTIES', 'Business:');
         $sel->setOptions(array($b_x, $p_x));

         
  	     $form->AddElement("text", "EFFECTIVE_DATE", "Effective Date", array('size' => 10));
  	     $dates_elements[] = "EFFECTIVE_DATE";
/*  	     
   	     $form->addElement("select",
  	              "STATEMENT_TYPE",
  	              "Statement Type",
  	              array("1"=>"Monthly", "3" => "Quarterly", "12" => "Annual")
  	         );
*/  	        
  	     $form->registerRule('vdate', 'function', 'validateDate');
         $form->addRule("EFFECTIVE_DATE", UtlConvert::ErrorDateMsg, 'vdate');
         $smarty->assign("dates", $dates_elements);		 
  	   }		
		 
		 
		 elseif ($report_code == "GL_HISTORY" ||
		         $report_code == "COMMISSIONS")
		 {
		 	 $businessList = $dbBU->getBusinessUnitsList();
		 	 $b_x = array();
		 	 $p_x = array();
		 	 foreach($businessList as $k=>$v) {
		 	     $b_x[$k] = $v;
		 	     $propertiesList = $dbProp->getPropertyLOV($k);
		 	     $p_x[$k][""] = "-- All --";
		 	 	 foreach($propertiesList as $k1=>$v1) {
		 	 	 	   $p_x[$k][$k1] = $v1;
		 	 	 }
	 	 	 
		 	 }
		 	$sel = &$form->addElement('hierselect', 'PROPERTIES', 'Select:');
         $sel->setOptions(array($b_x, $p_x));


		     // parameters: period start and period end dates
  	         $form->AddElement("text", "PERIOD_START_DATE", "Report period start", array('size' => 10));
  	         $dates_elements[] = "PERIOD_START_DATE";
  	         $form->AddElement("text", "PERIOD_END_DATE", "Report period end", array('size' => 10));
  	         $dates_elements[] = "PERIOD_END_DATE";
  	         
  	         if ($report_code == "COMMISSIONS")
  	            {
                 $form->AddElement("text", "PERCENTAGE", "Percentage Amount", array('size' => 5));
                 $form->addRule('PERCENTAGE', "Percentage Amount must be numeric.", 'vnumeric');
                 }
  	         // Append rules for DATE elements
  	         $form->registerRule('vdate', 'function', 'validateDate');
  	         $form->addRule("PERIOD_START_DATE", UtlConvert::ErrorDateMsg, 'vdate');
  	         $form->addRule("PERIOD_END_DATE", UtlConvert::ErrorDateMsg, 'vdate');
  	         $smarty->assign("dates", $dates_elements);		 	 
		 	 
         
         
		 }		 
		 
// Post Form Parameters		 

		 if ($IsPost && $form->validate())
         {
		 	 $report_data = array();
		 	 if ($report_code == "INCOME_AND_EXPENSES")
		 	 {
		 	     //$report_data = $dbReport->getYearTaxData(@$_POST["BUSINESS_ID"], @$_POST["year"]);

		 	     $bInfo = $dbBU->getBusinessUnit($_POST["BUSINESS_ID"]);
  	             $businessName = $bInfo["BUSINESS_NAME"];

  	             $smarty->assign("PrmBusinessName", $businessName);
  	             $smarty->assign("PrmPeriodStart", $_POST["PERIOD_START_DATE"]);
  	             $smarty->assign("PrmPeriodEnd", $_POST["PERIOD_END_DATE"]);

  	             $report_data = $dbReport->getReportData(
		 	                        $_POST["BUSINESS_ID"],
                                    $_POST["BASIS"],
                                    $_POST["PERIOD_START_DATE"],
                                    $_POST["PERIOD_END_DATE"]
                 );

  	             $report_file = "year-tax";
		 	 }
		 	 else	 if ($report_code == "EXPENSE_DETAILS")
		 	 {
		 	     $bInfo = $dbBU->getBusinessUnit($_POST["BUSINESS_ID"]);
  	             $businessName = $bInfo["BUSINESS_NAME"];
  	             
  	       $ptInfo = $dbReport->getPaymentType($_POST["PAYMENT_TYPE_ID"]);
  	             $paymentType = $ptInfo["PAYMENT_TYPE_NAME"];

  	             $smarty->assign("PrmBusinessName", $businessName);
  	             $smarty->assign("PrmPaymentType",  $paymentType);
  	             $smarty->assign("PrmBasis",       ucwords($_POST["BASIS"]));   
  	             $smarty->assign("PrmPeriodStart", $_POST["PERIOD_START_DATE"]);
  	             $smarty->assign("PrmPeriodEnd", $_POST["PERIOD_END_DATE"]);

  	             $report_data = $dbReport->getExpenseDetailsData(
		 	                              $_POST["BUSINESS_ID"],
		 	                              $_POST["PAYMENT_TYPE_ID"],
                                    $_POST["BASIS"],
                                    $_POST["PERIOD_START_DATE"],
                                    $_POST["PERIOD_END_DATE"]
                 );

  	             $report_file = "expense-details";
  	            //  print_r($report_data);
		 	 }
		 	 else	 if ($report_code == "GL_SUMMARY")
		 	 {
		 	     $bInfo = $dbBU->getBusinessUnit($_POST["BUSINESS_ID"]);
  	             $businessName = $bInfo["BUSINESS_NAME"];
  	       
  	             $smarty->assign("PrmBusinessName", $businessName);
  	             $smarty->assign("PrmPeriodStart", $_POST["PERIOD_START_DATE"]);
  	             $smarty->assign("PrmPeriodEnd",   $_POST["PERIOD_END_DATE"]);

  	             $report_data = $dbReport->getGLsummary(
		 	                              $_POST["BUSINESS_ID"],
                                    $_POST["PERIOD_START_DATE"],
                                    $_POST["PERIOD_END_DATE"]
                 );

  	             $report_file = "gl-summary";
  	              //print_r($report_data);
		 	 }
		 	 else	 if ($report_code == "GL_DETAILS")
		 	 {
		 	     $bInfo = $dbBU->getBusinessUnit($_POST["BUSINESS_ID"]);
  	             $businessName = $bInfo["BUSINESS_NAME"];
  	       
  	             $smarty->assign("PrmBusinessName", $businessName);
  	             $smarty->assign("PrmPeriodStart", $_POST["PERIOD_START_DATE"]);
  	             $smarty->assign("PrmPeriodEnd",   $_POST["PERIOD_END_DATE"]);

  	             $report_data = $dbReport->getGLdetails(
		 	                              $_POST["BUSINESS_ID"],
                                    $_POST["PERIOD_START_DATE"],
                                    $_POST["PERIOD_END_DATE"]
                 );

  	             $report_file = "gl-details";
  	              //print_r($report_data);
		 	 }
		 	 else if ($report_code == "TENANT_MONTH_STATEMENT")
		 	 {
		 	 	 //$report_data = $dbReport->getYearTaxData(@$_POST["BUSINESS_ID"], @$_POST["year"]);
  	             $report_file = "tenant-statement";
  	             @list($businessID, $propertyID, $agreementID) = $_POST["AGREEMENTS"];
  	             $propertyName = "All";
  	             $agreementName = "All Active";
  	             $bInfo = $dbBU->getBusinessUnit($businessID);
  	             $businessName = $bInfo["BUSINESS_NAME"];
  	             if ($propertyID){
  	                 $pInfo = $dbProp->getProperty($propertyID);
  	                 $propertyName = $pInfo["PROP_ADDRESS1"];
  	             }
  	             if ($agreementID){
  	             	$agreementName = "Selected";
  	             }
  	           	 $smarty->assign("PrmBusinessName", $businessName);
		 	 	 $smarty->assign("PrmPropertyName",  $propertyName);
		 	 	 $smarty->assign("PrmAgreementName",  $agreementName);
		 	 	 $report_data = array();
		 	 	 $propList = $dbProp->getPropertyBusinessUnits($businessID, $propertyID);
		 	 	 foreach($propList as $v){
		 	 	 	$pData = array("PROPERTY"=>$v, "AGREEMENTS" => array());
		 	 	 	$agrList = $dbAgr->getAgreementsForProp3($v["PROPERTY_ID"], $agreementID);
		 	 	 	foreach($agrList as $v1){
 	 	 		        $tenantList = $dbAgr->getTenantList4Action($v1["AGREEMENT_ID"]);
                        foreach($tenantList as &$vx){
					        $vx["ARREAR_AMOUNT"] = UtlConvert::dbNumericToDisplay($vx["ARREAR_AMOUNT"]);
					        $vx["DEPOSIT_BALANCE"] = UtlConvert::dbNumericToDisplay($vx["DEPOSIT_BALANCE"]);
					        $vx["LAST_MONTH_BALANCE"] = UtlConvert::dbNumericToDisplay($vx["LAST_MONTH_BALANCE"]);
					    }
					    unset($vx);

	                    $TenantRunningTotal  = $dbAgr->getTenantRunningTotal($v1["AGREEMENT_ID"]);
					    foreach($TenantRunningTotal as &$vx){
					        $vx["START_DATE"] = UtlConvert::dbDateToDisplay($vx["START_DATE"]);
					        $vx["PAYMENT_DATE"] = UtlConvert::dbDateToDisplay($vx["PAYMENT_DATE"]);
					        $vx["ARREARS"] = UtlConvert::dbNumericToDisplay($vx["ARREARS"]);
					        $vx["ALLOCATED_AMOUNT"] = UtlConvert::dbNumericToDisplay($vx["ALLOCATED_AMOUNT"]);
					        $vx["DUE_AMOUNT"] = UtlConvert::dbNumericToDisplay($vx["DUE_AMOUNT"]);
					     }
					     unset($vx);

				     $pData["AGREEMENTS"][] = array("DATA" => $v1, "TENANTS" => $tenantList, "RUNNINGTOTAL" => $TenantRunningTotal);
		 	 	    } // ---- foreach($agrList as $v1){ ...
				    $report_data[] = $pData;
		 	      }
		 	  // print_r($report_data);
		 	 }
 		 	 else if ($report_code == "GL_BALANCE")
		 	 {
  	     $report_file = "gl-balance";
  	        
    	 $form->addElement("select", "BUSINESS_ID", "Business Name", $dbBU->getBusinessUnitsList());
  	     $form->AddElement("text", "EFFECTIVE_DATE", "Effective Date", array('size' => 10));
  	     $dates_elements[] = "EFFECTIVE_DATE";
  	        
  	     $form->registerRule('vdate', 'function', 'validateDate');
         $form->addRule("EFFECTIVE_DATE", UtlConvert::ErrorDateMsg, 'vdate');
         
        $bInfo = $dbBU->getBusinessUnit($_POST["BUSINESS_ID"]);
  	             $businessName = $bInfo["BUSINESS_NAME"];

  	     $smarty->assign("PrmBusinessName",  $businessName);
         $smarty->assign("PrmEffectiveDate", $_POST["EFFECTIVE_DATE"]);
		 	 	 $report_data = $dbReport->getBalanceSheet($_POST["BUSINESS_ID"],
                                                   $_POST["EFFECTIVE_DATE"]);
 		 	 	 $report_data[] = $pData;
  	   }		 	 
 		 	 else if ($report_code == "GL_INCOME")
		 	 {
  	     $report_file = "gl-income";
         @list($businessID, $propertyID) = $_POST["PROPERTIES"];
         $propertyName = "All";
  	     $bInfo = $dbBU->getBusinessUnit($businessID);
  	     $businessName = $bInfo["BUSINESS_NAME"];

  	     if ($propertyID){
  	          $pInfo = $dbProp->getProperty($propertyID);
  	          $propertyName = $pInfo["PROP_ADDRESS1"];
  	      }  	        
  	      
  	     $form->AddElement("text", "EFFECTIVE_DATE", "Effective Date", array('size' => 10));
		 $form->AddElement("select", "REPORT_TYPE", "Accounting Basis",
                           array("CASH"=>"Cash", "ACCRUAL" => "Accrual"));
  	     $dates_elements[] = "EFFECTIVE_DATE";
  	     $form->registerRule('vdate', 'function', 'validateDate');
         $form->addRule("EFFECTIVE_DATE", UtlConvert::ErrorDateMsg, 'vdate');

  	     $smarty->assign("PrmBusinessName",  $businessName);
  	     $smarty->assign("PrmPropertyName",  $propertyName);
         $smarty->assign("PrmEffectiveDate", $_POST["EFFECTIVE_DATE"]);
		 $smarty->assign("PrmReportType", $_POST["REPORT_TYPE"]);

		 	 	 $report_data = $dbReport->getIncomeStmts($businessID,
		 	 	                                          $propertyID,
                                                  $_POST["EFFECTIVE_DATE"],
												  $_POST["REPORT_TYPE"]
																	  						 );

  	   }		 	 
  	   
 		 	 else if ($report_code == "PROPERTY_SUMMARY")
		 	 {
  	        $report_file = "property-summary";
  	        @list($businessID, $propertyID) = $_POST["PROPERTIES"];
  	        $propertyName = "All";

  	        $bInfo = $dbBU->getBusinessUnit($businessID);
  	        $businessName = $bInfo["BUSINESS_NAME"];
  	        if ($propertyID){
  	            $pInfo = $dbProp->getProperty($propertyID);
  	            $propertyName = $pInfo["PROP_ADDRESS1"];
  	        }
   	        $smarty->assign("PrmBusinessName", $businessName);
         	  $smarty->assign("PrmPropertyName",  $propertyName);
		 	 	 $report_data = $dbProp->getPropertyBusinessUnits($businessID, $propertyID);
 		 	 	$report_data[] = $pData;
  	   }
 		 	 else if ($report_code == "GL_HISTORY")
		 	 {
  	        $report_file = "gl-history";
  	        @list($businessID, $propertyID) = $_POST["PROPERTIES"];
  	        $propertyName = "All";

  	        $bInfo = $dbBU->getBusinessUnit($businessID);
  	        $businessName = $bInfo["BUSINESS_NAME"];
  	        if ($propertyID){
  	            $pInfo = $dbProp->getProperty($propertyID);
  	            $propertyName = $pInfo["PROP_ADDRESS1"];
  	        }
   	        $smarty->assign("PrmBusinessName", $businessName);
         	$smarty->assign("PrmPropertyName",  $propertyName);
            $smarty->assign("PrmPeriodStart", $_POST["PERIOD_START_DATE"]);
            $smarty->assign("PrmPeriodEnd", $_POST["PERIOD_END_DATE"]);

		 	 	 $report_data = $dbReport->getTransactionHistory( $businessID
					                                            , $propertyID
																, $_POST["PERIOD_START_DATE"]
                                                      , $_POST["PERIOD_END_DATE"]);
 		 	 	 $report_data[] = $pInfo;
  	   }
 		 	 else if ($report_code == "COMMISSIONS")
		 	 {
  	        $report_file = "gl-history";
  	        @list($businessID, $propertyID) = $_POST["PROPERTIES"];
  	        $propertyName = "All";

  	        $bInfo = $dbBU->getBusinessUnit($businessID);
  	        $businessName = $bInfo["BUSINESS_NAME"];
  	        if ($propertyID){
  	            $pInfo = $dbProp->getProperty($propertyID);
  	            $propertyName = $pInfo["PROP_ADDRESS1"];
  	        }
   	        $smarty->assign("PrmBusinessName", $businessName);
         	  $smarty->assign("PrmPropertyName",  $propertyName);
            $smarty->assign("PrmPeriodStart", $_POST["PERIOD_START_DATE"]);
            $smarty->assign("PrmPeriodEnd", $_POST["PERIOD_END_DATE"]);

		 	 	 $report_data = $dbReport->getCommissions( $businessID
					                                       , $propertyID
																								 , $_POST["PERIOD_START_DATE"]
                                                 , $_POST["PERIOD_END_DATE"]);
 		 	 	 $report_data[] = $pInfo;
  	   }  	   
  	   

//Submit to Smarty for rendering.		 	 

		 	 $smarty->assign("is_pdf_report", @$_POST["submit_pdf"] != "");

		 	 $smarty->assign("is_report", "true");
		 	 $smarty->assign("title", "Visulate - $header");
		   $smarty->assign("data", $report_data);

		     $html_report = $smarty->fetch("reports/$report_file.tpl");

		 	 if (@$_POST["submit_pdf"]){
		 	     include  realpath(dirname(__FILE__)."/../dompdf/dompdf_config.inc.php");
		 	     /*
		         require('FirePHPCore/FirePHP.class.php');
		         $firephp = FirePHP::getInstance(true);
		         $firephp->setEnabled(true);
		         */
	 	         $dompdf = new DOMPDF();
	 	         $dompdf->set_paper("letter", "landscape");
		         $dompdf->load_html($html_report);

		         $dompdf->render();

			     header("Content-type: application/pdf");
			     $output = $dompdf->output();
			     header("Content-Length: " . strlen($output));
			     header('Content-Disposition: attachment; filename='.$report_file.'.pdf');
			     echo $output;
			     exit;
		 	 }
         }
 }//if report_code not null

 $smarty->assign("isReport", $report_code != "");

 if ($report_code) {
		 // create renderer
		 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
		 // generate code
		 $form->accept($renderer);
		 $smarty->assign('form_data', $renderer->toArray());

		 $smarty->assign("header_title", $header);

		 if ($IsPost){
		 	 if ($report_file)
		 	    $smarty->assign("report_text", $html_report);
		 }

 } else {
    $smarty->assign("header_title", "Choose a report from the list on the left side of this page.");
 }

 $smarty->assign("ReportList", $reportList);
 $smarty->assign("reportCode", $report_code);

?>