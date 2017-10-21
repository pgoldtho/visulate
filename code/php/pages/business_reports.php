<?
 require_once dirname(__FILE__)."/../classes/database/pr_reports.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once dirname(__FILE__)."/../classes/Context.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";


//Menu Items
 $report_code = @$_REQUEST["REPORT_CODE"];
 
 $reports = array();

 $reports["PROPERTY_DETAILS"] = array(
     "roles" => array( "MANAGER_OWNER"
                     , "BUSINESS_OWNER"
                     , "BUYER" ),
     "title" => "Property Details"
 );
 
  $reports["OWNER_DETAILS"] = array(
     "roles" => array( "MANAGER_OWNER"
                     , "BUSINESS_OWNER"
                     , "BUYER" ),
     "title" => "Owner Details"
 );

 $reports["PROPERTY_SELLERS"] = array(
     "roles" => array( "MANAGER_OWNER"
                     , "BUSINESS_OWNER"
                     , "BUYER" ),
     "title" => "Buyers and Sellers"
 );

 $reports["OUT_STATE"] = array(
     "roles" => array( "MANAGER_OWNER"
                     , "BUSINESS_OWNER"
                     , "BUYER" ),
     "title" => "Out of State Property Owners"
 );

 $reports["RECENT_SALES"] = array(
     "roles" => array( "MANAGER_OWNER"
                     , "BUSINESS_OWNER"
                     , "BUYER" ),
     "title" => "Recent Sales by Deed Type"
 );
 
 $reports["MULTI_OWNER"] = array(
     "roles" => array( "MANAGER_OWNER"
                     , "BUSINESS_OWNER"
                     , "BUYER" ),
     "title" => "Owners of 5 or More Properties "
 );
 
 $reports["15_YEARS"] = array(
     "roles" => array( "MANAGER_OWNER"
                     , "BUSINESS_OWNER"
                     , "BUYER" ),
     "title" => "Long Term Owners"
 );
 

 $dbReport = new PRReports($smarty->connection);
 
 //populate report list array for menu
 $reportList = array();
 foreach ($reports as $k=>$v) {
   if (!in_array($smarty->user->getRole(), $v["roles"]))
      continue;
   $x=array();
   $x["href"] = "?m2=business_reports&REPORT_CODE=".$k;
   $x["title"] = $v["title"];
   $x["code"] = $k;
   $reportList[$k] = $x;
 }

// check for currently selected report
 if (!$report_code || !array_key_exists($report_code, $reportList)){
   reset($reportList);
    $report_code = key($reportList);
 }

 if ($report_code) {
        // create form
     $form = new HTML_QuickForm('reports', 'POST');
     $IsPost = $form->isSubmitted();
     $header = @$reports[$report_code]["title"];
     $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
     $form->addElement("hidden", "REPORT_CODE", $report_code);

     if ( $report_code == "PROPERTY_SELLERS" )
      {
        $form->AddElement("text", "START_DATE", "Period Start", array('size'=>10));
         $dates_elements[] = "START_DATE";
         $form->AddElement("text", "END_DATE", "Period End", array('size'=>10));
         $dates_elements[] = "END_DATE";
          $form->AddElement("text", "OWNER_NAME", "Owner Name", array('size'=>30,'maxlength' => 80));
          $form->AddElement("text", "SALE_COUNT", "Transaction Count", array('size'=>2));

         $form->registerRule('vdate', 'function', 'validateDate');
         $form->registerRule('vnumeric', 'function', 'validateNumeric');
         
         
         $form->addRule("START_DATE", UtlConvert::ErrorDateMsg, 'vdate');
         $form->addRule("END_DATE", UtlConvert::ErrorDateMsg, 'vdate');
         $smarty->assign("dates", $dates_elements);
         $form->addRule('SALE_COUNT', 'Transaction count must be a number (e.g. purchased or sold 2 properties)', 'vnumeric');  
         $form->addRule('SALE_COUNT', 'Please enter a transaction count (e.g. purchased or sold 2 properties)', 'required');  
         $form->AddElement("submit", "submit_html", "Search");
     }
     elseif ( $report_code == "PROPERTY_DETAILS" )
     {
         $form->AddElement("text", "ADDRESS1", "Address Line 1", array('size'=>30,'maxlength' => 80));
         $form->AddElement("text", "CITY", "City", array('size'=>30));
         $form->addElement("submit", "submit_html", "Search");
         $form->addRule('ADDRESS1', 'Enter an address line then press Search', 'required');  
      }
     elseif ( $report_code == "OWNER_DETAILS" )
     {
          $form->AddElement("text", "OWNER_NAME", "Owner Name", array('size'=>30,'maxlength' => 80));
         $form->AddElement("submit", "submit_html", "Search");
         $form->addRule('OWNER_NAME', 'Enter an owner name then press Search.', 'required');
     }
     elseif ( $report_code == "OUT_STATE"
           || $report_code == "RECENT_SALES"
           || $report_code == "MULTI_OWNER"
           || $report_code == "15_YEARS")
     {
          $form->AddElement("text", "CITY", "City", array('size'=>30,'maxlength' => 80));
          $form->AddElement("text", "ZIPCODE", "Zipcode", array('size'=>5));
         $form->AddElement("submit", "submit_html", "Search");
     }

  
  
  
// Post Form Parameters  

     if ($IsPost && $form->validate())
     {
        $report_data = array();
  
        if ($report_code == "PROPERTY_DETAILS")
        {
         $smarty->assign("PrmAddress1", $_POST["ADDRESS1"]);
         $smarty->assign("PrmCity", $_POST["CITY"]);
         
         $report_data = $dbReport->getProperty( $_POST["ADDRESS1"], $_POST["CITY"]);
         $report_file = "owner-list";
         $smarty->assign("data", $report_data);
       }
       elseif ($report_code == "OWNER_DETAILS")
        {
         $smarty->assign("PrmOwnerName", $_POST["OWNER_NAME"]);

         $report_data = $dbReport->getOwner($_POST["OWNER_NAME"]);
         $report_file = "owner-list";
         $smarty->assign("data", $report_data);
       }
       elseif ($report_code == "PROPERTY_SELLERS")
        {
          $start_date = $_POST["START_DATE"];
          $end_date   = $_POST["END_DATE"];
          $owner_name = $_POST["OWNER_NAME"];
          $sale_count = $_POST["SALE_COUNT"];
  
         $smarty->assign("PrmPeriodStart", $start_date);
         $smarty->assign("PrmPeriodEnd",   $end_date);
         $smarty->assign("PrmOwner",       $owner_name);
         $smarty->assign("PrmCount",       $sale_count);
         
   
         $report_file = "seller-list";
          $report_data = $dbReport->getBuyers($start_date, $end_date, $owner_name, $sale_count);
           $smarty->assign("bdata", $report_data);
          $report_data = $dbReport->getSellers($start_date, $end_date, $owner_name, $sale_count);
          $smarty->assign("sdata", $report_data);
        }
       elseif ($report_code == "OUT_STATE")
        {
         $smarty->assign("PrmCity", $_POST["CITY"]);
         $smarty->assign("PrmZipcode", $_POST["ZIPCODE"]);         

         $report_data = $dbReport->getOutStateOwner($_POST["CITY"], $_POST["ZIPCODE"]);
         $report_file = "owner-list";
         $smarty->assign("data", $report_data);
       }
       elseif ($report_code == "RECENT_SALES")
        {
         $smarty->assign("PrmCity", $_POST["CITY"]);
         $smarty->assign("PrmZipcode", $_POST["ZIPCODE"]);         

         $report_data = $dbReport->RecentTransactions($_POST["CITY"], $_POST["ZIPCODE"], null);
         $report_file = "pr-sales-summary";
         $smarty->assign("data", $report_data);
       }
       elseif ($report_code == "MULTI_OWNER")
        {
         $smarty->assign("PrmCity", $_POST["CITY"]);
         $smarty->assign("PrmZipcode", $_POST["ZIPCODE"]);         

         $report_data = $dbReport->MultiplePropertyOwners($_POST["CITY"], $_POST["ZIPCODE"]);
         $report_file = "pr-multi-owner";
         $smarty->assign("data", $report_data);
       }
       elseif ($report_code == "15_YEARS")
        {
         $smarty->assign("PrmCity", $_POST["CITY"]);
         $smarty->assign("PrmZipcode", $_POST["ZIPCODE"]);         

         $report_data = $dbReport->over15years($_POST["CITY"], $_POST["ZIPCODE"]);
         $report_file = "pr-multi-owner";
         $smarty->assign("data", $report_data);
       }       
       
    
      //Submit to Smarty for rendering.
        $smarty->assign("is_report", "true");
        $smarty->assign("title", "Visulate - $header");
       $html_report = $smarty->fetch("reports/$report_file.tpl");
      }
     elseif ($_SERVER['REQUEST_METHOD']=='GET')
      {
       if  ($report_code == "OWNER_DETAILS")  {
          if ($_REQUEST["OWNER_ID"])
           {
            $report_data = $dbReport->getOwnerDetails($_REQUEST["OWNER_ID"]);
            $report_file = "owner-details";
            $smarty->assign("data", $report_data);
           }
         }
        elseif ($report_code == "PROPERTY_DETAILS"){
          if ($_REQUEST["PROP_ID"])
           {
            $report_data = $dbReport->getPropertyDetails($_REQUEST["PROP_ID"]);
           $report_file = "pr-property-details";
           $smarty->assign("data", $report_data);
          }
         }
       elseif ($report_code == "RECENT_SALES")
        {
         $smarty->assign("PrmCity", $_REQUEST["CITY"]);
         $smarty->assign("PrmZipcode", $_REQUEST["ZIPCODE"]);         

         if ($_REQUEST["DEED_CODE"])
           {
           $report_data = $dbReport->RecentTransactions($_REQUEST["CITY"], $_REQUEST["ZIPCODE"], $_REQUEST["DEED_CODE"] );
           $report_file = "owner-list";
           $smarty->assign("data", $report_data);
           }
       }

       //Submit to Smarty for rendering.
        $smarty->assign("is_report", "true");
        $smarty->assign("title", "Visulate - $header");
       $html_report = $smarty->fetch("reports/$report_file.tpl");
      }//end if request method is GET
      
 }//end if report_code not null

 $smarty->assign("isReport", $report_code != "");

 if ($report_code) {
     // create renderer
     $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
     // generate code
     $form->accept($renderer);
     $smarty->assign('form_data', $renderer->toArray());

     $smarty->assign("header_title", $header);

     if (($IsPost)||
          ($_SERVER['REQUEST_METHOD']=='GET')){
        if ($report_file)
           $smarty->assign("report_text", $html_report);
     }

 } else {
    $smarty->assign("header_title", "Choose a report from the list on the left side of this page.");
 }

 $smarty->assign("ReportList", $reportList);
 $smarty->assign("reportCode", $report_code);

?>