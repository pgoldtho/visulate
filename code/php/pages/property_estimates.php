<?
 require_once dirname(__FILE__)."/../classes/database/rnt_properties.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_estimate.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";

 require_once dirname(__FILE__)."/../php/PropertyEstimatesDownloader.php";

 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

 if (! ( $smarty->user->isOwner() 
      || $smarty->user->isManager() 
			|| $smarty->user->isManagerOwner() 
			|| $smarty->user->isBookkeeping() 
			|| $smarty->user->isBuyer()
			|| $smarty->user->isBusinessOwner()))
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
    exit;
 }

 $isEdit = ($smarty->user->isOwner() /*|| $smarty->user->isBookkeeping()*/ 
         || $smarty->user->isManagerOwner() 
         || $smarty->user->isBuyer()
				 || $smarty->user->isBusinessOwner());

 function setFormFields(&$form, &$dates_elements, $data)
 {
         global $menu3;
         global $menu;
         global $smarty;
         global $isEdit;
         global $dbEstimate;
         

	     $form->addElement("hidden", "PROPERTY_ID");
	     $form->addElement("hidden", "BUSINESS_ID");
	     $form->addElement("hidden", "PROPERTY_ESTIMATES_ID");
	     $form->addElement("hidden", "CHECKSUM");         
         // set form fields
	 	 $form->addElement("text", "ESTIMATE_YEAR", "Year", array("id"=>"ESTIMATE_YEAR", "size" => 5));
	 	 $form->addElement("select", "HELPER_SELECT_YEAR", "", $dbEstimate->getYearList5(), array("onchange" => "$('ESTIMATE_YEAR').value = this.options[this.selectedIndex].value;this.selectedIndex=0;"));
	 	 $form->addElement("text", "ESTIMATE_TITLE", "Title", array("id"=>"ESTIMATE_TITLE", "size" => 60));
	 	 $form->addElement("text", "MONTHLY_RENT", "Monthly Rent", array("id"=>"MONTHLY_RENT", "size" => 10));
	 	 $form->addElement("text", "OTHER_INCOME", "Other Income", array("id"=>"OTHER_INCOME", "size" => 10));
	 	 $form->addElement("text", "VACANCY_PCT", "Vacancy and <br/> Unpaid Rent", array("id"=>"VACANCY_PCT", "size" => 4));
     
	 	 $form->addElement("text", "REPLACE_3YEARS", "3 Year Replacements", array("id"=>"REPLACE_3YEARS", "size" => 10));
	 	 $form->addElement("text", "REPLACE_5YEARS", "5 Year Replacements", array("id"=>"REPLACE_5YEARS", "size" => 10));
	 	 $form->addElement("text", "REPLACE_12YEARS", "12 Year Replacements", array("id"=>"REPLACE_12YEARS", "size" => 10));
	 	 
	 	 $form->addElement("text", "MAINTENANCE", "Maintenance", array("id"=>"MAINTENANCE", "size" => 10));
	 	 $form->addElement("text", "UTILITIES", "Utilities", array("id"=>"UTILITIES", "size" => 10));
	 	 $form->addElement("text", "PROPERTY_TAXES", "Property Taxes", array("id"=>"PROPERTY_TAXES", "size" => 10));
	 	 $form->addElement("text", "INSURANCE", "Insurance", array("id"=>"INSURANCE", "size" => 10));
	 	 $form->addElement("text", "MGT_FEES", "Management Fees", array("id"=>"MGT_FEES", "size" => 10));
	 	  
	 	 $form->addElement("text", "PURCHASE_PRICE", "Market Value", array("id"=>"PURCHASE_PRICE", "size" => 10));
	 	 $form->addElement("text", "DOWN_PAYMENT", "Down Payment", array("id"=>"DOWN_PAYMENT", "size" => 10));
	 	 $form->addElement("text", "CLOSING_COSTS", "Closing Costs", array("id"=>"CLOSING_COSTS", "size" => 10));
	 	  
	 	 $form->addElement("text", "CAP_RATE", "CAP Rate", array("id"=>"CAP_RATE", "size" => 10));
	 	  
	 	 $form->addElement("text", "LOAN1_AMOUNT", "1st Loan Amount", array("id"=>"LOAN1_AMOUNT", "size" => 10, "onchange"=>"dosum()"));
	 	 $form->addElement("select", "LOAN1_TYPE", "Type", array("Amortizing" => "Amortizing", "Interest Only" => "Interest Only"),
	 	                        array("id"=>"LOAN1_TYPE", "onchange"=>"dosum()"));
	     $form->addElement("text", "LOAN1_TERM", "Term", array("id"=>"LOAN1_TERM", "size" => 10, "onchange"=>"dosum()"));         	                        
	     $form->addElement("text", "LOAN1_RATE", "Interest Rate", array("id"=>"LOAN1_RATE", "size" => 10, "onchange"=>"dosum()"));         	                                      
	
	     $form->addElement("text", "LOAN2_AMOUNT", "2nd Loan Amount", array("id"=>"LOAN2_AMOUNT", "size" => 10, "onchange"=>"dosum2()"));
	     $form->addElement("select", "LOAN2_TYPE", "Type", array("Amortizing" => "Amortizing", "Interest Only" => "Interest Only"),
	 	                        array("id"=>"LOAN2_TYPE", "onchange"=>"dosum2()"));              
	     $form->addElement("text", "LOAN2_TERM", "Term", array("id"=>"LOAN2_TERM", "size" => 10, "onchange"=>"dosum2()"));         	                        
	     $form->addElement("text", "LOAN2_RATE", "Interest Rate", array("id"=>"LOAN2_RATE", "size" => 10, "onchange"=>"dosum2()"));                   
	      
	     $form->addElement("textarea", "NOTES", "Notes", array("id"=>"NOTES", "rows" => 10, "cols"=>60));                   
	     
	     $form->addElement('submit', 'accept', 'Save', array('onclick' => 'javascript:compute_value(this.form)'));
	     $form->addElement('submit', 'saveas', 'Save As', array('onclick' => 'javascript:compute_value(this.form)'));
	     $form->addElement('submit', 'cancel', 'Cancel');
	     $form->addElement('submit', 'delete', 'Delete', array('onclick' => "return confirm('Delete this record?')"));
	     $form->addElement('submit', 'new', 'New');
	     $form->addElement('button', 'GET_DATA_FOR_YEAR', 'Get Last 12 Months Data', array('id' => 'GET_DATA_FOR_YEAR'));
	     
         $form->applyFilter('__ALL__', 'trim');
         
         // require
         $form->addRule("ESTIMATE_YEAR", "Please set Estimate Year", 'required');
         $form->addRule("MONTHLY_RENT", "Please set Monthly Rent", 'required');
         
         // rule for validate
         $form->addRule("MONTHLY_RENT", "Value must be numeric", 'vnumeric');
         $form->addRule("OTHER_INCOME", "Value must be numeric", 'vnumeric');
         $form->addRule("VACANCY_PCT", "Value must be numeric", 'vnumeric');
         $form->addRule("REPLACE_3YEARS", "Value must be numeric", 'vnumeric');
         $form->addRule("REPLACE_5YEARS", "Value must be numeric", 'vnumeric');
         $form->addRule("REPLACE_12YEARS", "Value must be numeric", 'vnumeric');
         $form->addRule("MAINTENANCE", "Value must be numeric", 'vnumeric');
         $form->addRule("UTILITIES", "Value must be numeric", 'vnumeric');
         $form->addRule("PROPERTY_TAXES", "Value must be numeric", 'vnumeric');
         $form->addRule("INSURANCE", "Value must be numeric", 'vnumeric');
         $form->addRule("MGT_FEES", "Value must be numeric", 'vnumeric');
         $form->addRule("DOWN_PAYMENT", "Value must be numeric", 'vnumeric');
         $form->addRule("CLOSING_COSTS", "Value must be numeric", 'vnumeric');
         $form->addRule("PURCHASE_PRICE", "Value must be numeric", 'vnumeric');
         $form->addRule("CAP_RATE", "Value must be numeric", 'vnumeric');
         $form->addRule("LOAN1_AMOUNT", "Value must be numeric", 'vnumeric');
         $form->addRule("LOAN1_TERM", "Value must be numeric", 'vnumeric');
         $form->addRule("LOAN1_RATE", "Value must be numeric", 'vnumeric');
         $form->addRule("LOAN2_AMOUNT", "Value must be numeric", 'vnumeric');
         $form->addRule("LOAN2_TERM", "Value must be numeric", 'vnumeric');
         $form->addRule("LOAN2_RATE", "Value must be numeric", 'vnumeric');
         
 } // --- function setFormFields(....

 if (!defined("PROPERTY_ESTIMATE"))
 {
    define("PROPERTY_ESTIMATE", "1");
    define("UPDATE_ACTION", "UPDATE");
    define("INSERT_ACTION", "INSERT");
    define("PREPARE_INSERT_ACTION", "PREPARE_INSERT");
    define("CANCEL_ACTION", "CANCEL");
    define("DELETE_ACTION", "DELETE");
 }

 $form = new HTML_QuickForm('calc', 'POST');
 $IsPost = $form->isSubmitted();
 
 if (!$isEdit)
   $form->freeze();
   
 $action = UPDATE_ACTION;
 // ----  define params
 if (@$_REQUEST['saveas'])
    $action = INSERT_ACTION;
 else   
 if (@$_POST["cancel"])
   $action = CANCEL_ACTION;
 else
 if (@$_REQUEST["FORM_ACTION"] == INSERT_ACTION)
   $action = INSERT_ACTION;
 else
 if (@$_REQUEST["delete"])
 {
    $action = DELETE_ACTION;
    $delete_id = $_REQUEST["PROPERTY_ESTIMATES_ID"];
 }
 else
 if (@$_REQUEST["new"])
 {
    $action = PREPARE_INSERT_ACTION;
 }
 else
   $action = UPDATE_ACTION;

   
 $currentPropertyID = $menu3->current_property_id;
 $currentEstimatePropID = @$_REQUEST["PROPERTY_ESTIMATES_ID"];

 $dbProp = new RNTProperties($smarty->connection);
 $dbEstimate = new RNTEstimate($smarty->connection);

 // -----  Append rules
 $form->registerRule('vdate', 'function', 'validateDate');
 $form->registerRule('vnumeric', 'function', 'validateNumeric');
 $form->registerRule('vinteger', 'function', 'validateInteger');

  $estimateList = $dbEstimate->getEstimateList($currentPropertyID);   
 
  if (!$currentEstimatePropID){
 	if (count($estimateList) > 0)
 	   $currentEstimatePropID = $estimateList[0]["PROPERTY_ESTIMATES_ID"];
 	else
 	   $action = INSERT_ACTION;   
 }


if (@$_REQUEST['IS_SPREADSHEET_DOWNLOAD'])
{
    // check spreadsheet download process errors
    $errorMsg = '';

    // load property's data into DB
    try {
        // set spreadsheet template
        $template_spreadsheet = realpath(TEMPLATE_DIR.'/').'/'.'single_property2.xls';
        // set spreadsheet data
        $propertyData                  = $dbProp->getProperty($currentPropertyID);
        $propertyData['PROP_ESTIMATE'] = empty($currentEstimatePropID)
            ? array()
            : $dbEstimate->getEstimate($currentEstimatePropID);
        // generate spreadsheet
        //print_r($propertyData);
        $aPropertyDownloader  = new PropertyEstimatesDownloader($template_spreadsheet, $propertyData);
        $aPropertyDownloader->getXLS();
     //   $errorMsg = '<pre>'.print_r($propertiesList, true).'</pre>';
    }
    catch (Exception $e) {
        $errorMsg = $e->getMessage();
    }

    if ( ! empty($errorMsg)) {
        $smarty->assign('downloadSpreadsheetFileError', nl2br($errorMsg));
    }

    $IsPost = false;
} // if (@$_REQUEST['IS_SPREADSHEET_DOWNLOAD'])


 if ($action == CANCEL_ACTION)
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->request_menu_level2."=".$menu->current_level2."&".$menu3->request_property_id."=".$menu3->current_property_id.'&PROPERTY_ESTIMATES_ID='.$currentEstimatePropID);
    exit;
 }

 if ($action == PREPARE_INSERT_ACTION){
 	header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->request_menu_level2."=".$menu->current_level2."&".$menu3->request_property_id."=".$menu3->current_property_id.'&PROPERTY_ESTIMATES_ID='.$currentEstimatePropID.'&FORM_ACTION='.INSERT_ACTION);
    exit;
 }
 
   if (!$IsPost)
     if ($currentEstimatePropID && $action != INSERT_ACTION){
        $form_data = $dbEstimate->getEstimate($currentEstimatePropID);
        $form_data['ESTIMATE_YEAR'] = $form_data['ESTIMATE_YEAR_VAL'];
		$form_data['MONTHLY_RENT'] = UtlConvert::dbNumericToDisplay($form_data['MONTHLY_RENT']);
		$form_data['OTHER_INCOME'] = UtlConvert::dbNumericToDisplay($form_data['OTHER_INCOME']);
		$form_data['VACANCY_PCT'] = UtlConvert::dbNumericToDisplay($form_data['VACANCY_PCT'], 0);
		$form_data['REPLACE_3YEARS'] = UtlConvert::dbNumericToDisplay($form_data['REPLACE_3YEARS']);
		$form_data['REPLACE_5YEARS'] = UtlConvert::dbNumericToDisplay($form_data['REPLACE_5YEARS']);
		$form_data['REPLACE_12YEARS'] = UtlConvert::dbNumericToDisplay($form_data['REPLACE_12YEARS']);
		$form_data['MAINTENANCE'] = UtlConvert::dbNumericToDisplay($form_data['MAINTENANCE']);
		$form_data['UTILITIES'] = UtlConvert::dbNumericToDisplay($form_data['UTILITIES']);
		$form_data['PROPERTY_TAXES'] = UtlConvert::dbNumericToDisplay($form_data['PROPERTY_TAXES']);
		$form_data['INSURANCE'] = UtlConvert::dbNumericToDisplay($form_data['INSURANCE']);
		$form_data['MGT_FEES'] = UtlConvert::dbNumericToDisplay($form_data['MGT_FEES']);
		$form_data['DOWN_PAYMENT'] = UtlConvert::dbNumericToDisplay($form_data['DOWN_PAYMENT']);
		$form_data['CLOSING_COSTS'] = UtlConvert::dbNumericToDisplay($form_data['CLOSING_COSTS']);
		$form_data['PURCHASE_PRICE'] = UtlConvert::dbNumericToDisplay($form_data['PURCHASE_PRICE']);
		$form_data['CAP_RATE'] = UtlConvert::dbNumericToDisplay($form_data['CAP_RATE']);
		$form_data['LOAN1_AMOUNT'] = UtlConvert::dbNumericToDisplay($form_data['LOAN1_AMOUNT']);
		$form_data['LOAN1_TERM'] = UtlConvert::dbNumericToDisplay($form_data['LOAN1_TERM']);
		$form_data['LOAN1_RATE'] = UtlConvert::dbNumericToDisplay($form_data['LOAN1_RATE']);
		$form_data['LOAN2_AMOUNT'] = UtlConvert::dbNumericToDisplay($form_data['LOAN2_AMOUNT']);
		$form_data['LOAN2_TERM'] = UtlConvert::dbNumericToDisplay($form_data['LOAN2_TERM']);
		$form_data['LOAN2_RATE'] = UtlConvert::dbNumericToDisplay($form_data['LOAN2_RATE']);
     }
     else 
        $form_data = array();

 $currentBUID = 0;
 if (!$currentBUID){
 	// try set BUSINNESS_ID from estimate
 	if ($currentEstimatePropID){
 	  $d = $dbEstimate->getEstimate($currentEstimatePropID);
 	  $currentBUID = @$d["BUSINESS_ID"];
 	  if (!$currentBUID)
 	     $currentBUID = $dbProp->getBusinessUnit($currentPropertyID);
 	}  
 	else {
 	  // try set BUSINESS_ID from property	
 	  $currentBUID = $dbProp->getBusinessUnit($currentPropertyID);
 	}
 	
 }   
 $currentPropertyID = $menu3->current_property_id;   
     
 // property_id for page menu level 3
 $form->AddElement("hidden", $menu3->request_property_id, $menu3->current_property_id);
 // menu 2 level
 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
 $form->AddElement("hidden", "FORM_ACTION", $action);

 // set form fields for loan records
 setFormFields($form, $dates_elements, @$form_data);

 if (!$IsPost){
 	if ($action == INSERT_ACTION) 
 	$form_data['ESTIMATE_YEAR'] = date('Y');
 	$form_data["PROPERTY_ID"] = $currentPropertyID;
 	$form_data["BUSINESS_ID"] = $currentBUID;
 	$form_data["PROPERTY_ESTIMATES_ID"] = $currentEstimatePropID;
 	$prop = $dbProp->getProperty($currentPropertyID);
  $form->setDefaults(@$form_data);
 }   

 if (( ($IsPost && $form->validate()) || $action == DELETE_ACTION ) && ($isEdit)) {

    // save form to database
    $values = $form->getSubmitValues();
    $IsError = 0;
    try
    {
    	
        if ($action == INSERT_ACTION)
           $newID = $dbEstimate->Insert($values);
        else if ($action == UPDATE_ACTION)   
           $dbEstimate->Update($values);
        else if ($action == DELETE_ACTION){
           // try to calculate next ID
           $estList = $dbEstimate->getEstimateList($currentPropertyID);   
           $key = false;
           $id= "";
           foreach($estList as $k=>$v){
           	  if ($v["PROPERTY_ESTIMATES_ID"] == $delete_id){
           	  	$id  = $v["PROPERTY_ESTIMATES_ID"];
           	  	$key = $k;
           	  	break;
           	  }
           }
           $fromDeleteID = "";
           if ($key + 1 >= count($estList)){
              if (count($estList) > 1)
                  $fromDeleteID = $estList[$key - 1]["PROPERTY_ESTIMATES_ID"];
           } else {
           	  if (count($estList) > 1)
                  $fromDeleteID = $estList[$key+1]["PROPERTY_ESTIMATES_ID"];
           }      
           $dbEstimate->Delete($delete_id);
        }
        else
           throw new Exception('Unknown operation');

        $smarty->connection->commit();
    }
    catch(SQLException $e)
    {
          $IsError = 1;
          $smarty->connection->rollback();
          to_log($e, $smarty);
          $de =  new DatabaseError($smarty->connection);
          $smarty->assign("errorObj", $de->getErrorFromException($e));
    }


    // redirect to page
 
    if (!$IsError)
    {
    	if ($action == INSERT_ACTION) 
           $currentEstimatePropID = $newID;
       else if ($action == DELETE_ACTION)
           $currentEstimatePropID = $fromDeleteID;
           
       header("Location: ".$GLOBALS["PATH_FORM_ROOT"].'?'.$menu->getParam2().'&'.$menu3->getParams().'&PROPERTY_ESTIMATES_ID='.$currentEstimatePropID);
       exit;
    }
 } 
 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 // send form data to Smarty
 $smarty->assign('action', $action);
 $smarty->assign('form_data', $renderer->toArray());
 foreach($estimateList as $k=>$v){
 	$estimateList[$k]['ESTIMATE_YEAR'] = UtlConvert::dbDateToDisplay($estimateList[$k]['ESTIMATE_YEAR']);
 	$estimateList[$k]['href'] = '?'.$menu->getParam2().'&'.$menu3->getParams().'&PROPERTY_ESTIMATES_ID='.$v['PROPERTY_ESTIMATES_ID'];  
 	if ($estimateList[$k]['ESTIMATE_TITLE'] == "") 
 	    $estimateList[$k]['ESTIMATE_TITLE'] = '&lt;Empty&gt;';
 }
 $smarty->assign('estimateList', $estimateList);
 $smarty->assign('currentEstimatePropID', $currentEstimatePropID);
 $smarty->assign('action', $action);
 $smarty->assign("PATH_FORM_ROOT", $GLOBALS["PATH_FORM_ROOT"]);
 $smarty->assign("isEdit", ($isEdit) ? "true" : "false");

?>
