<?
 require_once dirname(__FILE__)."/../classes/database/rnt_properties.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_property_value.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_loans.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
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

 $isEdit = ($smarty->user->isOwner()
        || $smarty->user->isBookkeeping()
        || $smarty->user->isManagerOwner()
        || $smarty->user->isBuyer()
        || $smarty->user->isBusinessOwner());

 function setFormLoanFields(&$form, $size, &$dates_elements, $loans_data)
 {
         global $menu3;
         global $menu;
         global $smarty;
         global $currYear;
         global $isEdit;
         $form->AddElement("hidden", "CURR_YEAR", $currYear);
         // set form fields
         for($i=0; $i<$size; $i++)
         {
              $form->AddElement("hidden", "LOANS[$i][LOAN_LOAN_ID]");
              $form->AddElement("hidden", "LOANS[$i][LOAN_PROPERTY_ID]");
              $form->AddElement("hidden", "LOANS[$i][LOAN_CHECKSUM]");

              $form->AddElement("text", "LOANS[$i][LOAN_LOAN_DATE]", "Loan Date", array("size"=>10));
              $dates_elements[] = "LOANS[$i][LOAN_LOAN_DATE]";
              $form->AddElement("text", "LOANS[$i][LOAN_POSITION]", "Position", array("size"=>3));
              $form->AddElement("text", "LOANS[$i][LOAN_LOAN_AMOUNT]", "Amount", array("size"=>10));
              $form->AddElement("text", "LOANS[$i][LOAN_TERM]", "Term", array("size"=>4));
              $form->AddElement("text", "LOANS[$i][LOAN_INTEREST_RATE]", "Interest Rate", array("size"=>8));
              $form->AddElement("advcheckbox", "LOANS[$i][LOAN_CREDIT_LINE_YN]", "Credit Line", "",  array("N", "Y"));
              $form->AddElement("advcheckbox", "LOANS[$i][LOAN_ARM_YN]", "ARM", "",  array("N", "Y"));
			  $form->AddElement("advcheckbox", "LOANS[$i][LOAN_INTEREST_ONLY_YN]", "Interest Only", "",  array("N", "Y"));
              $form->AddElement("text", "LOANS[$i][LOAN_CLOSING_COSTS]", "Closing Cost", array("size"=>8));
			  $form->AddElement("text", "LOANS[$i][LOAN_PAYMENT]", "Payment", array("size"=>8, "disabled"=>"disabled"));
              $form->AddElement("text", "LOANS[$i][LOAN_BALLOON_DATE]", "Balloon Date", array("size"=>10));
              $dates_elements[] = "LOANS[$i][LOAN_BALLOON_DATE]";
              $form->AddElement("text", "LOANS[$i][LOAN_SETTLEMENT_DATE]", "Settlement Date", array("size"=>10));
              $dates_elements[] = "LOANS[$i][LOAN_SETTLEMENT_DATE]";
              if (@$loans_data[$i]["LOAN_LOAN_ID"] && $isEdit)
                  $form->addElement('link', "LOANS[$i][LOAN_LOAN_ID_LINK]", "delete",
                          "?".$menu3->getParams()."&".$menu->getParam2()."&action=del_loan&loan_id=".$loans_data[$i]["LOAN_LOAN_ID"], $smarty->deleteImage, $smarty->deleteAttr);
              // require
              $form->addRule("LOANS[$i][LOAN_LOAN_DATE]", "Please set Loan Date", 'required');
              $form->addRule("LOANS[$i][LOAN_POSITION]", "Please set Position", 'required');
              $form->addRule("LOANS[$i][LOAN_LOAN_AMOUNT]", "Please set Amount", 'required');
              $form->addRule("LOANS[$i][LOAN_TERM]", "Please set Term", 'required');
              $form->addRule("LOANS[$i][LOAN_INTEREST_RATE]", "Please set Interest Rate", 'required');
              //$form->addRule("LOANS[$i][LOAN_CREDIT_LINE_YN]", "Please set Credit Line", 'required');
              //$form->addRule("LOANS[$i][LOAN_ARM_YN]", "Please set ARM", 'required');

              // rule for validate
              $form->addRule("LOANS[$i][LOAN_LOAN_DATE]", UtlConvert::ErrorDateMsg, 'vdate');
              $form->addRule("LOANS[$i][LOAN_CLOSING_COSTS]", 'Closing cost must be numeric', 'vnumeric');
              $form->addRule("LOANS[$i][LOAN_BALLOON_DATE]", UtlConvert::ErrorDateMsg, 'vdate');
              $form->addRule("LOANS[$i][LOAN_SETTLEMENT_DATE]", UtlConvert::ErrorDateMsg, 'vdate');
              $form->addRule("LOANS[$i][LOAN_POSITION]", "Position must be numeric", 'vnumeric');
              $form->addRule("LOANS[$i][LOAN_LOAN_AMOUNT]", "Amount must be numeric", 'vnumeric');
              $form->addRule("LOANS[$i][LOAN_INTEREST_RATE]", 'Interest rate must be numeric', 'vnumeric');
              $form->addRule("LOANS[$i][LOAN_TERM]", "Term must be integer", 'vinteger');
         } // ---  for($i=0; $i<$num_loans; $i++)
 } // --- function setFormLoanFields($form, $size)

 if (!defined("PROPERTY_FINANCE"))
 {
    define("PROPERTY_FINANCE", "1");
    define("UPDATE_ACTION", "UPDATE");
    define("INSERT_ACTION_LOAN", "INSERT_LOAN");
    define("CANCEL_ACTION", "CANCEL");
    define("DELETE_ACTION", "DELETE");
    define("INSERT_ACTION_VALUE", "INSERT_VALUE");
    define("UPDATE_ACTION_VALUE", "UPDATE_VALUE");
    define("DELETE_ACTION_VALUE", "DELETE_VALUE");
 }

 $form = new HTML_QuickForm('formFin', 'POST');
 $IsPost = $form->isSubmitted();
 
 if ( ! $isEdit)
 {
     $form->freeze();
 }
 $currentL3 = @$_REQUEST['CURRENT_LEVEL3'];

 if (!$currentL3){
 	// TODO  set menu 3 depend from submit button
 	$currentL3 = "valueA";
 }
 
   
 //$action = UPDATE_ACTION;

 // ----  define params
 if (@$_POST["cancel"])
 {
     $action = CANCEL_ACTION;
 }
 elseif (@$_REQUEST["FORM_ACTION"] == INSERT_ACTION_LOAN)
 {
     $action = INSERT_ACTION_LOAN;
 }
 elseif (@$_REQUEST["action"] == "del_loan")
 {
     $action = DELETE_ACTION;
     $delete_id = $_REQUEST["loan_id"];
 }
 elseif (@$_REQUEST["FORM_ACTION"] == INSERT_ACTION_VALUE)
 {
     $action = INSERT_ACTION_VALUE;
 }
 elseif (@$_REQUEST["FORM_ACTION"] == UPDATE_ACTION_VALUE)
 {
     $action = UPDATE_ACTION_VALUE;
 }
 elseif (@$_REQUEST["action"] == "del_value")
 {
     $action = DELETE_ACTION_VALUE;
     $del_value_id = $_REQUEST["value_id"];
 }
 else
 {
     $action = UPDATE_ACTION;
 }


 if ($action == CANCEL_ACTION)
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->request_menu_level2."=".$menu->current_level2."&".$menu3->request_property_id."=".$menu3->current_property_id);
    exit;
 }
 $currentPropertyID = $menu3->current_property_id;

 $dbProp       = new RNTProperties($smarty->connection);
 $dbPropValue  = new RNTPropertyValue($smarty->connection);
 $dbLoans      = new RNTLoans($smarty->connection);

 // ---- init Year
 $currYear = @$_REQUEST["currYear"];
 if (!$currYear)
    $currYear = @$_REQUEST["CURR_YEAR"];
 if (!$currYear)
    $currYear = date("Y");

 list($minYear, $maxYear) = $dbLoans->getMinMaxYear();
// $maxYear = date('Y');
 $listYear = array();
 for($i = $minYear; $i <= $maxYear; $i++)
   if ($i == date("Y"))
     $listYear[$i] = "Last 12 month";
   else
     $listYear[$i] = $i;

 if (count($listYear) == 0)
    $listYear[date("Y")] = "Last 12 month";

 // -----  Append rules
 $form->registerRule('vdate', 'function', 'validateDate');
 $form->registerRule('vnumeric', 'function', 'validateNumeric');
 $form->registerRule('vinteger', 'function', 'validateInteger');

 $form_data = array();
 // loans array size
 $loans_data = array();
 $num_loans = 0;
 if (!$IsPost)
 {
    $loans_data = $dbLoans->getLoansList($currentPropertyID);
	$account_bals = $dbLoans->getAccountBals($currentPropertyID);
    if ($action == INSERT_ACTION_LOAN)
       $loans_data[] = array("LOAN_PROPERTY_ID"=>$currentPropertyID);
    $num_loans = count(@$loans_data);
    // populate loan records for form
	$payments = array();
    foreach($loans_data as $k1=>$v1)
    {
       if (array_key_exists("LOAN_LOAN_ID", $v1)) // record its not new
       {
           // correct data
           $v1["LOAN_LOAN_DATE"] = UtlConvert::dbDateToDisplay($v1["LOAN_LOAN_DATE"]);
           $v1["LOAN_BALLOON_DATE"] = UtlConvert::dbDateToDisplay($v1["LOAN_BALLOON_DATE"]);
           $v1["LOAN_CLOSING_COSTS"] = UtlConvert::dbNumericToDisplay($v1["LOAN_CLOSING_COSTS"]);
           $v1["LOAN_SETTLEMENT_DATE"] = UtlConvert::dbDateToDisplay($v1["LOAN_SETTLEMENT_DATE"]);
           $v1["LOAN_LOAN_AMOUNT"] = UtlConvert::dbNumericToDisplay($v1["LOAN_LOAN_AMOUNT"]);
           $v1["LOAN_INTEREST_RATE"] = UtlConvert::dbNumericToDisplay($v1["LOAN_INTEREST_RATE"]);
		   $v1["LOAN_PAYMENT"] = UtlConvert::dbNumericToDisplay($v1["LOAN_PAYMENT"]);
           $v1["LOAN_CREDIT_LINE_YN"] = ($v1["LOAN_CREDIT_LINE_YN"] == "Y");
           $v1["LOAN_ARM_YN"] = ($v1["LOAN_ARM_YN"] == "Y");
		   $v1["LOAN_INTEREST_ONLY_YN"] = ($v1["LOAN_INTEREST_ONLY_YN"] == "Y");
		   $payments[$v1["LOAN_POSITION"]] = $dbLoans->getPayments($v1["LOAN_LOAN_ID"]);
       }
       else
       {
           $v1["LOAN_CREDIT_LINE_YN"] = 0;
           $v1["LOAN_ARM_YN"] = 0;
		   $v1["LOAN_INTEREST_ONLY_YN"] = 0;
       }

       foreach($v1 as $k2=>$v2)
          $form_data["LOANS[$k1][$k2]"] = $v2;
    }
 }
 else
 {
   $num_loans = count($_POST["LOANS"]);
   $loans_data = $_POST["LOANS"];
 }
 //print_r($payments);
 $form_data["PAYMENT_HISTORY"] = $payments;
 $form_data["ACCOUNT_BALS"] = $account_bals;

 // property_id for page menu level 3
 $form->AddElement("hidden", $menu3->request_property_id, $menu3->current_property_id);
 // menu 2 level
 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
 $form->AddElement("hidden", "FORM_ACTION", $action);

 $dates_elements = array();
 // set form fields for loan records
 setFormLoanFields($form, $num_loans, $dates_elements, $loans_data);

 if ($isEdit)
 {
     $form->AddElement("submit", "cancel", "Cancel", array());
     $form->AddElement("submit", "accept", "Save", array("onclick" => "return changeSettlementDate(this.form)"));
     $form->AddElement("submit", "new_loan", "New Loan");
 }

 /*SUMMARY--------------*/
     $calcValues = $dbLoans->getRent($currentPropertyID, $currYear);
     $smarty->assign("isSold", $calcValues["IS_SOLD"] ? "true" : "false");
     $form->AddElement("text", "CALC_NOI", "Net Operating Income",  array("value" => UtlConvert::dbNumericToDisplay($calcValues["NOI"]), "size" => 12, "disabled"=>"disabled"));
     $form->AddElement("text", "DEBT_SERVICE", "Debt Service",  array("value" => UtlConvert::dbNumericToDisplay($calcValues["DEBT_SERVICE"]), "size" => 12, "disabled"=>"disabled"));

     $form->AddElement("text", "CALC_CAP_RATE", "Cap Rate",  array("value" => UtlConvert::dbNumericToDisplay($calcValues["CAP_RATE"]), "size" => 8, "disabled"=>"disabled"));
     $form->AddElement("text", "CALC_PURCHASE_PRICE", "Purchase Price",  array("value" => UtlConvert::dbNumericToDisplay($calcValues["PURCHASE_PRICE"]), "size" => 12, "disabled"=>"disabled"));
     $form->AddElement("text", "CALC_CASH_INVESTED", "Cash Invested",  array("value" => UtlConvert::dbNumericToDisplay($calcValues["CASH_INVESTED"]), "size" => 12, "disabled"=>"disabled"));
     $form->AddElement("text", "CALC_CASH_ON_CASH", "Cash on Cash",  array("value" => UtlConvert::dbNumericToDisplay($calcValues["CASH_ON_CASH"]), "size" => 8, "disabled"=>"disabled"));
     $form->AddElement("select", "currYear", "Selected Year", $listYear, array("onchange"=>"this.form.submit();"));

     $form->AddElement("text", "CALC_AMOUNT_GROSS", "Gross Income:",  array("value" => UtlConvert::dbNumericToDisplay($calcValues["AMOUNT_GROSS"]), "size" => 12, "disabled"=>"disabled"));
     $form->AddElement("text", "CALC_AMOUNT_EXPENSE", "Total Expenses:",  array("value" => UtlConvert::dbNumericToDisplay($calcValues["EXPENSE_AMOUNT"]), "size" => 12, "disabled"=>"disabled"));
     $form->AddElement("text", "CALC_AMOUNT_LOAN", "Total Loans",  array("value" => UtlConvert::dbNumericToDisplay($calcValues["AMOUNT_LOAN"]), "size" => 12, "disabled"=>"disabled"));
     $form->AddElement("text", "CALC_CLOSING_COSTS", "Closing Costs",  array("value" => UtlConvert::dbNumericToDisplay($calcValues["CLOSING_COSTS"]), "size" => 12, "disabled"=>"disabled"));
     $form->AddElement("static", "CALC_WARN", $calcValues["WARN"]);
     $form->AddElement("hidden", "CURRENT_LEVEL3", $currentL3, array('id' => 'CURRENT_LEVEL3') );
	 
     $i = 0;
     foreach($calcValues["RECEIVABLE"] as $v)
        $form->AddElement("text", "DETAILS[RECEIVABLE][".($i++)."]", $v["NAME"],  array("value" => UtlConvert::dbNumericToDisplay($v["AMOUNT"]), "size" => 8, "disabled"=>"disabled"));
     $i=0;
     foreach($calcValues["PAYABLE"] as $v)
        $form->AddElement("text", "DETAILS[PAYABLE][".($i++)."]", $v["NAME"],  array("value" => UtlConvert::dbNumericToDisplay($v["AMOUNT"]), "size" => 8, "disabled"=>"disabled"));
     $f = &$form->getElement("currYear");
     $f->setValue($currYear);

 /*-----------------------*/
 
 /**
  * FORM "Property Values"
  */
 
 $prop_values_data = array();
 if (!$IsPost)
 {
     $prop_values_data = $dbPropValue->getPropertyValues($currentPropertyID);
     
     if ($action == INSERT_ACTION_VALUE)
     {
        $prop_values_data[] = array("PROPERTY_ID"=>$currentPropertyID);
     }
          
     foreach ($prop_values_data as $k=>$v)
     {
         $v["VALUE_DATE"]  = UtlConvert::dbDateToDisplay($v["VALUE_DATE"]);
         $v["VALUE"]  = UtlConvert::dbNumericToDisplay($v["VALUE"]);
         $v["EQUITY"] = UtlConvert::dbNumericToDisplay($v["EQUITY"]);        
         $v["LTV"]    = UtlConvert::dbNumericToDisplay($v["LTV"]);
         
     	 foreach ($v as $k1=>$v1)
     	 {
             $form_data["VALUES[$k][$k1]"] = $v1;
     	 }
     }
 }
 else
 {
    $prop_values_data = $_POST["VALUES"];
 }

 $ValueMethodsLov = new LovData("dataValueMethods", $dbPropValue->getValueMethodsList());
 for($i = 0; $i < count($prop_values_data); $i++)
 {
     $form->AddElement("text", "VALUES[$i][VALUE_DATE]", "Value date", array("size"=>8));
     $dates_elements[] = "VALUES[$i][VALUE_DATE]";
     
	 $form->AddElement("select", "VALUES[$i][VALUE_METHOD]", "Value Method", $dbPropValue->getValueMethodsList(), true);
/* 	 $form->AddElement(
         "lov",
         "VALUES[$i][VALUE_METHOD]",
         "Value method",
         $prop_values_data[$i]["VALUE_METHOD"],
         array("nameCode"  => "VALUES[$i][VALUE_METHOD__CODE]",
               "imagePath" => $GLOBALS["PATH_FORM_ROOT"]."images/lov.gif",
               "sizeCode"  => 10),
         $ValueMethodsLov
     );
*/
     $form->AddElement(
         "text",
         "VALUES[$i][VALUE]",
         "Value",
         array("id"      => "VALUES[$i][VALUE]",
               "size"    => 10,
               'onkeyup' => "doCalcDetails($i)")
     );
     $form->AddElement(
         "text",
         "VALUES[$i][EQUITY]",
         "Equity",
         array("id"       => "VALUES[$i][EQUITY]",
               "size"     => 10,
               "readonly" => "readonly",
               "class"    => "text_item_readonly")
     );
     $form->AddElement(
         "text",
         "VALUES[$i][LTV]",
         "LTV",
         array("id"       => "VALUES[$i][LTV]",
               "size"     => 5,
               "readonly" => "readonly",
               "class"    => "text_item_readonly")
     );

     $form->AddElement(
         "text",
         "VALUES[$i][LOAN_AMOUNT]",
         "loan amount",
         array("id"    => "VALUES[$i][LOAN_AMOUNT]",
               "style" => "display:none")
     );
     
     if ( ! is_null($prop_values_data[$i]["VALUE_ID"]) AND $isEdit)
     {
         $form->addElement(
             'link',
             "VALUES[$i][VALUE_ID_LINK]",
             "delete",
             "?".$menu->getParam2().
             "&".$menu3->getParams().
             "&action=del_value&value_id=".$prop_values_data[$i]["VALUE_ID"],
             $smarty->deleteImage,
             $smarty->deleteAttr
         );
     }

     $form->AddElement("hidden", "VALUES[$i][VALUE_ID]");
     $form->AddElement("hidden", "VALUES[$i][PROPERTY_ID]");
     $form->AddElement("hidden", "VALUES[$i][CHECKSUM]");
 }

 if ($isEdit)
 {
     $form->AddElement("submit", "cancel_value", "Cancel", array());
     $form->AddElement("submit", "accept_value", "Save", array());
     $form->AddElement("submit", "new_value", "New Value", array());
 }

 
 
 if (!$IsPost)
 {
     $form->setDefaults(@$form_data);
 }

 if (( ($IsPost && $form->validate()) 
       OR $action == DELETE_ACTION 
       OR $action == DELETE_ACTION_VALUE) && ($isEdit))
 {
     // save form to database
     $values = $form->getSubmitValues();
     $IsError = 0;
     try
     {
         if ($values["FORM_ACTION"] == INSERT_ACTION_LOAN || $values["FORM_ACTION"] == UPDATE_ACTION)
         {
             $dbLoans->Update($values);
         }
         elseif ($action == DELETE_ACTION)
         {
             $dbLoans->Delete($delete_id);
         }
         elseif (($action == INSERT_ACTION_VALUE)
                 OR ($action == UPDATE_ACTION_VALUE))
         {
             $dbPropValue->Update($values);
         }  
         elseif ($action == DELETE_ACTION_VALUE)
         {
             $dbPropValue->Delete($del_value_id);
         }  
         else
         {
             throw new Exception('Unknown operation');
         }
         
         $smarty->connection->commit();
     }
     catch(SQLException $e)
     {
         $IsError = 1;
         $smarty->connection->rollback();
         $de =  new DatabaseError($smarty->connection);
         $smarty->assign("errorObj", $de->getErrorFromException($e));
     }
    
     // redirect to page
     if (!$IsError)
     {
         if (@$_REQUEST["new_loan"])
         {
       	     $action = INSERT_ACTION_LOAN;
         }
         elseif ($_REQUEST["new_value"])
         {
       	     $action = INSERT_ACTION_VALUE;
         }
         elseif ($_REQUEST["accept_value"])
         {
       	     $action = UPDATE_ACTION_VALUE;
         }
         else
         {
             $action = UPDATE_ACTION;
         }
         
         header("Location: ".$GLOBALS["PATH_FORM_ROOT"].
                "?".$menu->request_menu_level2."=".$menu->current_level2.
                "&".$menu3->request_property_id."=".$menu3->current_property_id.
                "&FORM_ACTION=".$action.
                "&currYear=".$currYear);
         exit;       
     }
 }
 else
 {
     if (@$_REQUEST["new_loan"])
     {
         header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->request_menu_level2."=".$menu->current_level2."&".$menu3->request_property_id."=".$menu3->current_property_id."&FORM_ACTION=".INSERT_ACTION_LOAN."&currYear=".$currYear);
         exit;
     }    
 }
/* 
 if ($_REQUEST["new_value"])
 {
    
     header("Location: ".$GLOBALS["PATH_FORM_ROOT"].
            "?".$menu->request_menu_level2."=".$menu->current_level2.
            "&".$menu3->request_property_id."=".$menu3->current_property_id.
            "&FORM_ACTION=".INSERT_ACTION_VALUE.
            "&currYear=".$currYear);
     exit;
 }
 elseif ($_REQUEST["accept_value"])
 {
    
     header("Location: ".$GLOBALS["PATH_FORM_ROOT"].
            "?".$menu->request_menu_level2."=".$menu->current_level2.
            "&".$menu3->request_property_id."=".$menu3->current_property_id.
            "&FORM_ACTION=".UPDATE_ACTION_VALUE.
            "&currYear=".$currYear);
     exit;
 }
*/
 
 $property_data = $dbProp->getProperty($currentPropertyID);
 $header_title = @$property_data["PROP_ADDRESS1"]." - Finance";

 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);
 if ($isEdit){
  $smarty->assign('additional_menu3_items',
                  "<li><a href=\"#\" ".($currentL3 == "valueA" ? $x : "")."id=\"valueA\" onclick=\"setCurrent('valueA');  showDiv('valueDiv');return false;\"> Values</a></li>
                  <li><a href=\"#\" ".($currentL3 == "paymentA" ? $x : "")."id=\"paymentA\" onclick=\"setCurrent('paymentA');  showDiv('paymentDiv');return false;\">Payment History</a></li></li>");
    }				  

 // send form data to Smarty
 $smarty->assign('action', $action);
 $smarty->assign('form_data', $renderer->toArray());
 $smarty->assign('payments', $payments);
 $smarty->assign('account_bals', $account_bals);
 
 $smarty->assign("isEdit", $isEdit ? "true" : "false");
 $smarty->assign("header_title", $header_title);
 $smarty->assign("dates", $isEdit ? $dates_elements : array());

 $smarty->assign("action", $GLOBALS["PATH_FORM_ROOT"]);
 $smarty->assign("hiden", "<input name=\"".$menu->request_menu_level2."\" value=\"".$menu->current_level2."\" type=\"hidden\">".
                          "<input name=\"".$menu3->request_property_id."\" value=\"".$menu3->current_property_id."\" type=\"hidden\">");

 $smarty->assign("script", $ValueMethodsLov->display());
?>
