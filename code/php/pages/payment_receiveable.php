<?
 require_once dirname(__FILE__)."/../classes/database/rnt_payment_rules.class.php";

 require_once dirname(__FILE__)."/../classes/database/rnt_acc_receivable.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once dirname(__FILE__)."/../classes/Context.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";


 $mobile_device = Context::getMobileDevice();
 if ($mobile_device)
  {   
	 $template_name = "mobile-receiveable.tpl";
  }


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

 $isEdit = ($smarty->user->isManager()
         || $smarty->user->isManagerOwner()
         || $smarty->user->isBuyer()
		 || $smarty->user->isBookkeeping());

 if (!defined("PROPERTY_PAYMENTS"))
 {
    define("PROPERTY_PAYMENTS", "1");
    define("INSERT_OTHER_PAYMENT", "INSERT_OTHER_PAYMENT");
    define("DELETE_OTHER_PAYMENT", "DELETE_OTHER");
    define("DELETE_ACTION_ALLOCATION", "DELETE_ALLOCATION");
    define("CANCEL_ACTION", "CANCEL");
    define("UPDATE_RECEIVABLE", "UPDATE_RECEIVABLE");
    define("UPDATE_LIST_ACTION", "UPDATE_LIST_ACTION");
    define("DELETE_LIST_ACTION", "DELETE_LIST_ACTION");
 }


 $currentL3 = @$_REQUEST['CURRENT_LEVEL3'];
 if (!$currentL3){
 	// TODO  set menu 3 depend from submit button
 	$currentL3 = "sched";
 }

 $x = " class=\"current\" ";

 $smarty->assign('additional_menu3_items',
                 "<li><a href=\"#\" ".($currentL3 == "sched" ? $x : "")."id=\"sched\" onclick=\"setCurrent('sched');  showDiv('schedDiv');return false;\"> Scheduled</a></li>
                  <li><a href=\"#\" ".($currentL3 == "unsched" ? $x : "")."id=\"unsched\" onclick=\"setCurrent('unsched');  showDiv('unschedDiv');return false;\">Unscheduled</a></li>");


 $dbBU = new RNTBusinessUnit($smarty->connection);
 $buList = $dbBU->getBusinessUnits();
 $currentBUID = @$_REQUEST["BUSINESS_ID"];
 $msgSuccess = @$_REQUEST["msgSuccess"];

 if ($currentBUID == null)
   $currentBUID = Context::getBusinessID();
 else
   Context::setBusinessID($currentBUID);

 if (!$currentBUID)
   $currentBUID = @$buList[0]["BUSINESS_ID"];

 if ($currentBUID)
    $smarty->user->verifyBUAccess($currentBUID);

 $dbAccReceiv = new  RNTAccountReceiveable($smarty->connection);

 $form = new HTML_QuickForm('formPay', 'POST');

 if (!$isEdit)
   $form->freeze();

 $currYearMonth = @$_REQUEST['YEAR_MONTH_HIDDEN'];
 $monthList = $dbAccReceiv->getMonthList($currentBUID);
 $href = $GLOBALS["PATH_FORM_ROOT"].
         "?".$menu->getParam2().
         "&BUSINESS_ID=".$currentBUID.
         "&CURRENT_LEVEL3=".$currentL3;

 $lmonths = array();
 $nextMonth = false;
 $prevMonth = false;
 foreach($monthList as $k=>$v)
    $lmonths[] = array($k, $v);

 if (!$currYearMonth)
   $currYearMonth = @$lmonths[0][0];

 for($i=0; $i < count($lmonths); $i++)
   if ($lmonths[$i][0] == $currYearMonth)
   {
      if ($i > 0 )
         $nextMonth = array($lmonths[$i-1][0], $lmonths[$i-1][1]);
      if ($i + 1 < count($lmonths))
         $prevMonth = array($lmonths[$i+1][0], $lmonths[$i+1][1]);
   }

 if ($nextMonth)
   $form->addElement("link", "NEXT_YEAR_LINK", "",
                $href."&YEAR_MONTH_HIDDEN=".$nextMonth[0],
                ">>".$nextMonth[1]);

 if ($prevMonth)
   $form->addElement("link", "PREV_YEAR_LINK", "",
                $href."&YEAR_MONTH_HIDDEN=".$prevMonth[0],
                $prevMonth[1]."<<");

 $href .= "&YEAR_MONTH_HIDDEN=".$currYearMonth;
 if (count($monthList) > 0)
    $form->addElement("select", "YEAR_MONTH", "Month", $monthList, array("onchange"=>"javascript:formPay.YEAR_MONTH_HIDDEN.value=this.value; formPay.submit();"));

 $form_data['YEAR_MONTH'] = $currYearMonth;
 $form->addElement("hidden", "YEAR_MONTH_HIDDEN", $currYearMonth);

 $IsPost = $form->isSubmitted();
 $dates_elements = array();

 $action = @$_REQUEST["FORM_ACTION"];

 if (@$_REQUEST["cancel"]) {
       header("Location: ".$href);
       exit;
 }

 if (@$_REQUEST["generateList"])
    $action = UPDATE_LIST_ACTION;

 if (@$_REQUEST["deleteList"])
    $action = DELETE_LIST_ACTION;

 $summary = $dbAccReceiv->getSum($currYearMonth, $currentBUID);
 foreach($summary as $k=>$v)
   $summary[$k] = UtlConvert::dbNumericToDisplay($summary[$k]);

 if ($action == DELETE_ACTION_ALLOCATION && ($isEdit) )
 {
    $deleteAllocID = $_REQUEST["PAY_ALLOC_ID"];
    $IsError = 0;
    try
    {
        // delete ledger entry for allocation
        $dbAccReceiv->DeleteAllocDetails($deleteAllocID);
        // delete allocation
        $dbAccReceiv->DeleteAllocation($deleteAllocID);
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
       header("Location: ".$href);
       exit;
    }
 }

 if ($action == DELETE_OTHER_PAYMENT && ($isEdit) )
 {
    $deleteArID = $_REQUEST["AR_ID"];
    $IsError = 0;
    try
    {
        $dbAccReceiv->DeleteRow2($deleteArID);
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
       header("Location: ".$href);
       exit;
    }
 }

 if ($action == "createOtherPayment")
 {

       header("Location: ".$href."&FORM_ACTION=INSERT_OTHER_PAYMENT#bottomOther");
       exit;
 }
 else if ($action == UPDATE_LIST_ACTION)
 {
           // update due list
           $IsError = 0;
           do{

                   $date_of_generation = @$_REQUEST["UPDATE_LIST_DATE"];
                   if (!$date_of_generation){
                      $form->setElementError("UPDATE_LIST_DATE", "Update date required.");
                      break;
                   }

                   if (!UtlConvert::validateDisplayDate($date_of_generation)){
                      $form->setElementError("UPDATE_LIST_DATE", UtlConvert::ErrorDateMsg);
                      break;
                   }

                   $is_late_fee = @$_REQUEST["IS_GENERATE_LATE_FEE"] ;

                   try{
                     $dbAccReceiv->generateReceivableList($currentBUID, $date_of_generation, $is_late_fee);
                   }
                   catch(SQLException $e)
                   {
                      $IsError = 1;
                      $smarty->connection->rollback();
                      $de =  new DatabaseError($smarty->connection);
                      $smarty->assign("errorObj", $de->getErrorFromException($e));
                   }
                   if (!$IsError)
                   {
                      header("Location: ".$href."&msgSuccess=Generated list to $date_of_generation");
                      exit;
                   }
            } while(false);
 }
 else if ($action == DELETE_LIST_ACTION)
 {
           // delete due list
           $IsError = 0;
           do{

                   $date_from_delete = @$_REQUEST["DELETE_LIST_DATE"];
                   if (!$date_from_delete){
                      $form->setElementError("DELETE_LIST_DATE", "Date delete from required.");
                      break;
                   }

                   if (!UtlConvert::validateDisplayDate($date_from_delete)){
                      $form->setElementError("DELETE_LIST_DATE", UtlConvert::ErrorDateMsg);
                      break;
                   }

                   try{
                     $dbAccReceiv->deleteReceivableList($currentBUID, $date_from_delete);
                   }
                   catch(SQLException $e)
                   {
                      $IsError = 1;
                      $smarty->connection->rollback();
                      $de =  new DatabaseError($smarty->connection);
                      $smarty->assign("errorObj", $de->getErrorFromException($e));
                   }
                   if (!$IsError)
                   {

                      // calculate previous month for display
                      $mn = array();
                      preg_match("/(.*)\/(.*)\/(.*)/", $date_from_delete, $mn);
                      list(, $m, $d, $y) = $mn;
                      $jd = GregorianToJD((int)$m, (int)$d, (int)$y);
                      $jd--;
                      $gregorian = JDToGregorian($jd);
                      $mn = array();
                      preg_match("/(.*)\/(.*)\/(.*)/", $gregorian, $mn);
                      list(, $m, $d, $y) = $mn;
                      $m = str_pad($m, 2, "0", STR_PAD_LEFT);
                      $href = $GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&BUSINESS_ID=".$currentBUID."&YEAR_MONTH_HIDDEN=".$y.$m;

                      header("Location: ".$href."&msgSuccess=Was delete rows from list from $date_from_delete");
                      exit;
                   }
            } while(false);
 }
 else if ($action == INSERT_OTHER_PAYMENT);
 else
    $action = UPDATE_RECEIVABLE;


 $IsSave = @$_REQUEST["save"];

 $form->registerRule('vdate', 'function', 'validateDate');
 $form->registerRule('vnumeric', 'function', 'validateNumeric');
 $form->registerRule('vinteger', 'function', 'validateInteger');

 // property_id for page menu level 3 - its property
 $form->AddElement("hidden", $menu3->request_property_id, $menu3->current_property_id);
 // menu 2 level
 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
 $form->AddElement("hidden", "BUSINESS_ID", $currentBUID);
 $form->AddElement("hidden", "FORM_ACTION", "");
 // additional menu 3 level
 $form->AddElement("hidden", "CURRENT_LEVEL3", $currentL3, array('id' => 'CURRENT_LEVEL3') );

 $form->addElement("text", "DELETE_LIST_DATE", "", array("size"=>8));
 $form->addElement("text", "UPDATE_LIST_DATE", "", array("size"=>8));
 $form->addElement("advcheckbox", "IS_GENERATE_LATE_FEE", " With Late Fee rows?", "",  array("N", "Y"));

 $dates_elements[] = "UPDATE_LIST_DATE";
 $dates_elements[] = "DELETE_LIST_DATE";
 if (!@$_REQUEST["UPDATE_LIST_DATE"])
   $form_data["UPDATE_LIST_DATE"] = date("m/d/Y");

 if (!@$_REQUEST["DELETE_LIST_DATE"]){
   $date = date("m")."/01/".date("Y");
   if ($currYearMonth){
      $date = substr($currYearMonth, 4)."/01/".substr($currYearMonth, 0, 4);
   }

   $form_data["DELETE_LIST_DATE"] = $date;
 }

 // RECEIVABLE ACCOUNTS

 if ($IsPost)
 {
    $posts = @$_POST["RECEIVABLE"];
    if (!$posts)
      $posts = array();

    ksort($posts);
    $accList = array();

    foreach($posts as $v_post)
    {
       $v = $dbAccReceiv->getReceivable($v_post["AR_ID"]);
       $amount_due = $v["AMOUNT"];
       $v["AMOUNT"] = UtlConvert::dbNumericToDisplay($v["AMOUNT"]);
       $v["PAYMENT_DUE_DATE"] = UtlConvert::dbDateToDisplay($v["PAYMENT_DUE_DATE"]);

       $pt_accs = $dbAccReceiv->getPtAccounts($currentBUID, $v["PAYMENT_TYPE"]);
       $v["DEBIT_ACCOUNT"]  = empty($v["DEBIT_ACCOUNT"])
                            ? $pt_accs["ARS"]["DEBIT_ACCOUNT"]
                            : $v["DEBIT_ACCOUNT"];
       $v["CREDIT_ACCOUNT"] = empty($v["CREDIT_ACCOUNT"])
                            ? $pt_accs["ARS"]["CREDIT_ACCOUNT"]
                            : $v["CREDIT_ACCOUNT"];

       $alloc_sum = 0;
       $dbAllocList = $dbAccReceiv->getListAllocations($v_post["AR_ID"]);
       foreach($dbAllocList as $v1)
       {
          $v["IS_DISABLED"] = "TRUE";
          $alloc_sum += $v1["AMOUNT"];
          $v["ALLOCATIONS"][] = array("PAY_ALLOC_ID" => $v1["PAY_ALLOC_ID"],
                                      "AMOUNT" => UtlConvert::dbNumericToDisplay($v1["AMOUNT"]),
                                      "PAYMENT_DATE" => UtlConvert::dbDateToDisplay($v1["PAYMENT_DATE"]),
                                      "AR_ID" => $v1["AR_ID"],
                                      "SUM_REMAINDER" => UtlConvert::dbNumericToDisplay($amount_due - $alloc_sum + $v1["AMOUNT"]),
                                      //
                                      //"DEBIT_ACCOUNT" =>  $v1["DEBIT_ACCOUNT"],
                                      //"CREDIT_ACCOUNT" =>  $v1["CREDIT_ACCOUNT"]
                                      "DEBIT_ACCOUNT" => empty($v1["DEBIT_ACCOUNT"])
                                                       ? $pt_accs["ARP"]["DEBIT_ACCOUNT"]
                                                       : $v1["DEBIT_ACCOUNT"],
                                      "CREDIT_ACCOUNT" => empty($v1["CREDIT_ACCOUNT"])
                                                        ? $pt_accs["ARP"]["CREDIT_ACCOUNT"]
                                                        : $v1["CREDIT_ACCOUNT"]
                                     );
       } // -- foreach($dbAllocList as $v1)

       if ($amount_due - $alloc_sum > 0){
              $v["ALLOCATIONS"][] = array("PAY_ALLOC_ID"=>"",
                                          "AMOUNT" => "",
                                          "PAYMENT_DATE" => "",
                                          "AR_ID" => $v["AR_ID"],
                                          "SUM_REMAINDER" => UtlConvert::dbNumericToDisplay($amount_due - $alloc_sum),
                                          //
                                          "DEBIT_ACCOUNT"  => $pt_accs["ARP"]["DEBIT_ACCOUNT"],
                                          "CREDIT_ACCOUNT" => $pt_accs["ARP"]["CREDIT_ACCOUNT"]
                                         );
              $v_alloc_post = @$v_post["ALLOCATIONS"];
              if ($v_alloc_post) {
                  $a = "";
                  foreach($v_alloc_post as $va)
                      if (!@$va["PAY_ALLOC_ID"] && (@$va["AMOUNT"] || @$va["PAYMENT_DATE"])) {
                           $v["ALLOCATIONS"][count($v["ALLOCATIONS"])-1]["AMOUNT"] = @$va["AMOUNT"];
                           $v["ALLOCATIONS"][count($v["ALLOCATIONS"])-1]["PAYMENT_DATE"] = @$va["PAYMENT_DATE"];
                           break;
                      }
              } // --- if ($v_alloc_post)
       }

       $accList[] = $v;
   } // ---  foreach($posts as $v)
 }  // ---  if ($IsPost)
 else
 {
         $accList = $dbAccReceiv->getList($currentBUID, $currYearMonth);
         foreach($accList as &$v)
         {
            $dbAllocList = $dbAccReceiv->getListAllocations($v["AR_ID"]);
            $amount_due = $v["AMOUNT"];
            $v["AMOUNT"] = UtlConvert::dbNumericToDisplay($v["AMOUNT"]);
            $v["PAYMENT_DUE_DATE"] = UtlConvert::dbDateToDisplay($v["PAYMENT_DUE_DATE"]);

            $pt_accs = $dbAccReceiv->getPtAccounts($currentBUID, $v["PAYMENT_TYPE"]);
            $v["DEBIT_ACCOUNT"]  = empty($v["DEBIT_ACCOUNT"])
                                 ? $pt_accs["ARS"]["DEBIT_ACCOUNT"]
                                 : $v["DEBIT_ACCOUNT"];
            $v["CREDIT_ACCOUNT"] = empty($v["CREDIT_ACCOUNT"])
                                 ? $pt_accs["ARS"]["CREDIT_ACCOUNT"]
                                 : $v["CREDIT_ACCOUNT"];

            $alloc_sum = 0;
            foreach($dbAllocList as $v1)
            {
              $v["IS_DISABLED"] = "TRUE";
              $alloc_sum += $v1["AMOUNT"];
              $v["ALLOCATIONS"][] = array("PAY_ALLOC_ID" => $v1["PAY_ALLOC_ID"],
                                          "AMOUNT" => UtlConvert::dbNumericToDisplay($v1["AMOUNT"]),
                                          "PAYMENT_DATE" => UtlConvert::dbDateToDisplay($v1["PAYMENT_DATE"]),
                                          "AR_ID" => $v1["AR_ID"],
                                          "SUM_REMAINDER" => UtlConvert::dbNumericToDisplay($amount_due - $alloc_sum + $v1["AMOUNT"]),
                                          //
                                          //"DEBIT_ACCOUNT" => $v1["DEBIT_ACCOUNT"],
                                          //"CREDIT_ACCOUNT" => $v1["CREDIT_ACCOUNT"]
                                          "DEBIT_ACCOUNT" => empty($v1["DEBIT_ACCOUNT"])
                                                           ? $pt_accs["ARP"]["DEBIT_ACCOUNT"]
                                                           : $v1["DEBIT_ACCOUNT"],
                                          "CREDIT_ACCOUNT" => empty($v1["CREDIT_ACCOUNT"])
                                                            ? $pt_accs["ARP"]["CREDIT_ACCOUNT"]
                                                            : $v1["CREDIT_ACCOUNT"]
                                         );
            }

            if ($amount_due - $alloc_sum > 0) {
              $v["ALLOCATIONS"][] = array("PAY_ALLOC_ID"=>"",
                                          "AMOUNT" => "",
                                          "PAYMENT_DATE" => "",
                                          "AR_ID" => $v["AR_ID"],
                                          "SUM_REMAINDER" => UtlConvert::dbNumericToDisplay($amount_due - $alloc_sum),
                                          //
                                          "DEBIT_ACCOUNT"  => $pt_accs["ARP"]["DEBIT_ACCOUNT"],
                                          "CREDIT_ACCOUNT" => $pt_accs["ARP"]["CREDIT_ACCOUNT"]
                                         );
            }
         }
 } // --- else


 $dbPTRules  = new RNTPaymentRules($smarty->connection);
 $buAccounts = $dbPTRules->getPaymentAccountsList($currentBUID);

 for($i=0; $i < count($accList); $i++)
 {
    $form->addElement("hidden", "RECEIVABLE[$i][AR_ID]");
    $form->addElement("hidden", "RECEIVABLE[$i][BUSINESS_ID]");
    $form->addElement("hidden", "RECEIVABLE[$i][CHECKSUM]");
    $form->addElement("hidden", "RECEIVABLE[$i][LOAN_ID]");
    $form->addElement("hidden", "RECEIVABLE[$i][PAYMENT_TYPE]");
    $form->addElement("hidden", "RECEIVABLE[$i][TENANT_ID]");
    $form->addElement("hidden", "RECEIVABLE[$i][AGREEMENT_ID]");
    $form->addElement("text", "RECEIVABLE[$i][PAYMENT_DUE_DATE]", "", array("size"=>8, "disabled"=>"disabled"));
    $t = $accList[$i]["ADDRESS1"]." - ";
    if ($accList[$i]["UNITS"] > 1)
       $t.= $accList[$i]["UNIT_NAME"]." - ";

    $form->addElement("link", "RECEIVABLE[$i][UNIT_NAME]", "",
                     $GLOBALS["PATH_FORM_ROOT"]."?m2=tenant_agreements&prop_id=".$accList[$i]["PROPERTY_ID"]."&AGR_AGREEMENT_ID=".$accList[$i]["AGREEMENT_ID"],
                     $t.$accList[$i]["RECEIVABLE_TYPE_NAME"],
                     array("size"=>8, "title"=>"View agreement"));
    $form->addElement("link", "RECEIVABLE[$i][TENANT_NAME]", "",
                     $GLOBALS["PATH_FORM_ROOT"]."?m2=tenant_tenants&prop_id=".$accList[$i]["PROPERTY_ID"].
                                                "&TENANT_ID=".$accList[$i]["TENANT_ID"],
                     $accList[$i]["TENANT_NAME"],
                     array("size"=>8, "title"=>"View tenant info"));

    $form->addElement("hidden", "RECEIVABLE[$i][DEBIT_ACCOUNT]");
    $form->addElement("select",
                      "RECEIVABLE[$i][CREDIT_ACCOUNT]", "Credit Account",
                      $buAccounts,
                      array("id" => "RECEIVABLE[$i][CREDIT_ACCOUNT]",
                            "style" => "width:100px;")
    );

    $r = array("size"=>8);
    if (@$accList[$i]["IS_DISABLED"])
       $r["disabled"] = "disabled";

    $form->addElement("text", "RECEIVABLE[$i][AMOUNT]", "", $r);

    if (!@$accList[$i]["IS_DISABLED"])
    {
       $form->addRule("RECEIVABLE[$i][AMOUNT]", "required", 'required');
       $form->addRule("RECEIVABLE[$i][AMOUNT]", "Amount must be numeric", 'vnumeric');
    }

    $sysDate = date("m/d/Y");
    if (@$accList[$i]["ALLOCATIONS"])
    {
            for($j=0; $j < count($accList[$i]["ALLOCATIONS"]); $j++ )
            {
                 $r = array("size"=>8);
                 $readonly = array("size"=>8);
                 if (@$accList[$i]["ALLOCATIONS"][$j]["PAY_ALLOC_ID"]) {
                     $r["disabled"] = "disabled";

                     $readonly["readonly"] = "readonly";
                     $readonly["style"]    = "background-color:#c0c0c0; color:#808080;";
                 }
                 $form->addElement("text", "RECEIVABLE[$i][ALLOCATIONS][$j][AMOUNT]", "", $r);
                 $form->addElement("text", "RECEIVABLE[$i][ALLOCATIONS][$j][SUM_REMAINDER]", "", array("size"=>8, "disabled"=>"disabled"));
                 $form->addElement("text", "RECEIVABLE[$i][ALLOCATIONS][$j][PAYMENT_DATE]", "", $readonly);
                 $form->addElement("hidden", "RECEIVABLE[$i][ALLOCATIONS][$j][AR_ID]");
                 $form->addElement("hidden", "RECEIVABLE[$i][ALLOCATIONS][$j][PAY_ALLOC_ID]");

                 $form->addElement("select",
                                   "RECEIVABLE[$i][ALLOCATIONS][$j][DEBIT_ACCOUNT]", "Debit Account",
                                   $buAccounts,
                                   array("id" => "RECEIVABLE[$i][ALLOCATIONS][$j][DEBIT_ACCOUNT]",
                                         "style" => "width:100px;")
                 );
                 $form->addElement("hidden","RECEIVABLE[$i][ALLOCATIONS][$j][CREDIT_ACCOUNT]");

                 if (@$accList[$i]["ALLOCATIONS"][$j]["PAY_ALLOC_ID"])
                 {
                    // if allocation in database
                    $r["disabled"] = "disabled";
                    $form->addElement('link',   "RECEIVABLE[$i][ALLOCATIONS][$j][LINK_DELETE_ALLOC]", "delete",
                                  "?".$menu->getParam2()."&BUSINESS_ID=".$currentBUID.
                                   "&FORM_ACTION=DELETE_ALLOCATION&PAY_ALLOC_ID=".$accList[$i]["ALLOCATIONS"][$j]["PAY_ALLOC_ID"]."&YEAR_MONTH_HIDDEN=".$currYearMonth,
                                   $smarty->deleteImage, array("onclick"=>"return confirm('Delete payment allocation?');"));
                 }
                 else
                 {
                    // if new allocation
                    $dates_elements[] = "RECEIVABLE[$i][ALLOCATIONS][$j][PAYMENT_DATE]";
                    if ($j ==0)
                        // nothing allocation - copy sum from amount
                        $form->addElement("button", "RECEIVABLE[$i][ALLOCATIONS][$j][BUTTON]", "Paid", array("onclick"=>"javascript: PaidSrc($i, $j, this, '$sysDate')"));
                    else
                        // copy sum from remainder
                        $form->addElement("button", "RECEIVABLE[$i][ALLOCATIONS][$j][BUTTON]", "Paid", array("onclick"=>"javascript: Paid($i, $j, this, '$sysDate')"));

                    if ((@$accList[$i]["ALLOCATIONS"][$j]["AMOUNT"] || @$accList[$i]["ALLOCATIONS"][$j]["PAYMENT_DATE"]) && !@$accList[$i]["ALLOCATIONS"][$j]["PAY_ALLOC_ID"])
                    {
                       // validate rule for alocations
                       $form->addRule("RECEIVABLE[$i][ALLOCATIONS][$j][AMOUNT]", "required", 'required');
                       $form->addRule("RECEIVABLE[$i][ALLOCATIONS][$j][AMOUNT]", "Amount must be numeric", 'vnumeric');
                       $form->addRule("RECEIVABLE[$i][ALLOCATIONS][$j][PAYMENT_DATE]",  UtlConvert::ErrorDateMsg, 'vdate');
                       $form->addRule("RECEIVABLE[$i][ALLOCATIONS][$j][PAYMENT_DATE]", "required", 'required');
                    }

                 } // --- if (@$accList[$i]["ALLOCATIONS"])


            } // ---     for($j=0; $j < count($accList[$i]["ALLOCATIONS"]); $j++ )
    }
 } // --- for($i=0;...

 // inital data for form
 foreach($accList as $k1=>$v1)
   foreach($v1 as $k2=>$v2){
      if (@$k2 == "ALLOCATIONS")
      {
          foreach($v2 as $k3=>$v3) {
            foreach($v3 as $k4=>$v4) {
               $form_data["RECEIVABLE[$k1][ALLOCATIONS][$k3][$k4]"] = $v4;
            }
          }
      }

      $form_data["RECEIVABLE[$k1][$k2]"] = $v2;
   }

  if ($isEdit){
    $form->addElement("submit", "save", "Save");
    $form->addElement("submit", "cancel", "Cancel");
  }



  // --- OTHER PAYMENTS account ----------------------------------------------------------------

 if ($IsPost)
    $otherAccList = @$_POST["OTHER_PAYMENTS"];
 else
 {
   $otherAccList = $dbAccReceiv->getListProp($currentBUID, $currYearMonth);
   foreach($otherAccList as &$v1){
       $v1["PAYMENT_DUE_DATE"] = UtlConvert::dbDateToDisplay($v1["PAYMENT_DUE_DATE"]);
       $v1["PAYMENT_DATE"] = UtlConvert::dbDateToDisplay($v1["PAYMENT_DATE"]);
       $v1["AMOUNT"] = UtlConvert::dbNumericToDisplay($v1["AMOUNT"]);
       //
       $pt_accs = $dbAccReceiv->getPtAccounts($currentBUID, $v1["PAYMENT_TYPE"]);
       $v1["DEBIT_ACCOUNT"]  = empty($v1["DEBIT_ACCOUNT"])
                             ? $pt_accs["ARP"]["DEBIT_ACCOUNT"]
                             : $v1["DEBIT_ACCOUNT"];
       $v1["CREDIT_ACCOUNT"] = empty($v1["CREDIT_ACCOUNT"])
                             ? $pt_accs["ARS"]["CREDIT_ACCOUNT"]
                             : $v1["CREDIT_ACCOUNT"];
   }
   unset($v1);
 }

 if (!$IsPost && $action == INSERT_OTHER_PAYMENT) {
   $pt = key($dbAccReceiv->getPaymentPropTypeList());
   $pt_accs = $dbAccReceiv->getPtAccounts($currentBUID, $pt);
   $otherAccList[] = array(
       "BUSINESS_ID"    => $currentBUID,
       "RECORD_TYPE"    => $dbAccReceiv->getOtherTypeVal(),
       "DEBIT_ACCOUNT"  => $pt_accs["ARP"]["DEBIT_ACCOUNT"],
       "CREDIT_ACCOUNT" => $pt_accs["ARS"]["CREDIT_ACCOUNT"]
   );
 }

 // for debit/credit values updated automatically when the user changes the payment type
    $ptAccountsList = $dbAccReceiv->getPtAccountsList($currentBUID);
    $smarty->assign("ptAccountsList", json_encode($ptAccountsList));

 for($i=0; $i < count($otherAccList); $i++)
 {
    $form->addElement("hidden", "OTHER_PAYMENTS[$i][AR_ID]");
    $form->addElement("hidden", "OTHER_PAYMENTS[$i][BUSINESS_ID]");
    $form->addElement("hidden", "OTHER_PAYMENTS[$i][CHECKSUM]");
    $form->addElement("hidden", "OTHER_PAYMENTS[$i][LOAN_ID]");
    $form->addElement("hidden", "OTHER_PAYMENTS[$i][TENANT_ID]");
    $form->addElement("hidden", "OTHER_PAYMENTS[$i][AGREEMENT_ID]");
    $form->addElement("hidden", "OTHER_PAYMENTS[$i][RECORD_TYPE]");


    $form->addElement("text", "OTHER_PAYMENTS[$i][PAYMENT_DUE_DATE]", "", array("size" => 8));
    $dates_elements[] = "OTHER_PAYMENTS[$i][PAYMENT_DUE_DATE]";
    $form->addElement("text", "OTHER_PAYMENTS[$i][AMOUNT]", "", array("size"=>8));

    $form->addElement("select", "OTHER_PAYMENTS[$i][PAYMENT_PROPERTY_ID]", "", $dbAccReceiv->getPropList($currentBUID));

    $form->addElement("select",
                      "OTHER_PAYMENTS[$i][PAYMENT_TYPE]",
                      "",
                      $dbAccReceiv->getPaymentPropTypeList(),
                      array("onchange" => "setDefaultAccounts($i, this);")
    );
    $form->addElement("text", "OTHER_PAYMENTS[$i][PAYMENT_DATE]", "", array("size"=>8));
    $dates_elements[] = "OTHER_PAYMENTS[$i][PAYMENT_DATE]";

    $form->addRule("OTHER_PAYMENTS[$i][AMOUNT]", "required", 'required');
    $form->addRule("OTHER_PAYMENTS[$i][AMOUNT]", "Amount must be numeric", 'vnumeric');
    $form->addRule("OTHER_PAYMENTS[$i][PAYMENT_DUE_DATE]", "required", 'required');
    $form->addRule("OTHER_PAYMENTS[$i][PAYMENT_DUE_DATE]",  UtlConvert::ErrorDateMsg, 'vdate');
    $form->addRule("OTHER_PAYMENTS[$i][PAYMENT_DATE]",  UtlConvert::ErrorDateMsg, 'vdate');

    $form->addElement(
        "select",
        "OTHER_PAYMENTS[$i][DEBIT_ACCOUNT]",
        "Debit Account",
        $buAccounts,
        array("id" => "OTHER_PAYMENTS[$i][DEBIT_ACCOUNT]",
              "style" => "width:100px;")
    );
    $form->addElement(
        "select",
        "OTHER_PAYMENTS[$i][CREDIT_ACCOUNT]",
        "Credit Account",
        $buAccounts,
        array("id" => "OTHER_PAYMENTS[$i][CREDIT_ACCOUNT]",
              "style" => "width:100px;")
    );

    $form->addElement("button", "OTHER_PAYMENTS[$i][BUTTON]",
                      "Paid", array("onclick"=>"javascript: PaidUnsched($i, this, '".date("m/d/Y")."')"));

    if  (@$otherAccList[$i]["AR_ID"])
           $form->addElement('link', "OTHER_PAYMENTS[$i][LINK_DELETE]", "delete",
                          "?".$menu->getParam2()."&BUSINESS_ID=".$currentBUID.
                           "&FORM_ACTION=DELETE_OTHER&AR_ID=".$otherAccList[$i]["AR_ID"]."&YEAR_MONTH_HIDDEN=".$currYearMonth,
                           $smarty->deleteImage, array("onclick"=>"return confirm('Delete record?');"));
 }
 if ($otherAccList)
 {
     foreach($otherAccList as $k1=>$v1)
       foreach($v1 as $k2=>$v2)
           $form_data["OTHER_PAYMENTS[$k1][$k2]"] = $v2;
 }
 // Apply filter for all data cells
 $form->applyFilter('__ALL__', 'trim');
 $form->setDefaults(@$form_data);


 if ($IsPost && $form->validate() && $action == UPDATE_RECEIVABLE && ($isEdit))
 {
     $IsError = 0;
     $values = $form->getSubmitValues();

     try
     {
        if ($action == UPDATE_RECEIVABLE)
        {
           // update amount
           if (@$values["RECEIVABLE"])
           {
               foreach($values["RECEIVABLE"] as $v)
               {
                 if ($v["AMOUNT"] > 0)
                 {
                    $dbAccReceiv->Update(
                        array("AMOUNT"   => $v["AMOUNT"],
                              "AR_ID"    => $v["AR_ID"],
                              "CHECKSUM" => $v["CHECKSUM"])
                    );
                 }

                 // update ledger entry info for scheduled receivable
                 $dbAccReceiv->UpdateAccounts(
                     array("AR_ID"          => $v["AR_ID"],
                           "DEBIT_ACCOUNT"  => $v["DEBIT_ACCOUNT"],
                           "CREDIT_ACCOUNT" => $v["CREDIT_ACCOUNT"])
                 );

               }

               // update allocations
               foreach($values["RECEIVABLE"] as $v)
                    if (@$v["ALLOCATIONS"])
                    {
                        foreach($v["ALLOCATIONS"] as $v_alloc)
                        {
                           $pay_alloc_id = $v_alloc["PAY_ALLOC_ID"];
                           if (!$pay_alloc_id) {
                               if (@$v_alloc["AMOUNT"]  && @$v_alloc["PAYMENT_DATE"])
                               {
                                   $pay_alloc_id = $dbAccReceiv->InsertAllocation(
                                       array("AMOUNT" => $v_alloc["AMOUNT"],
                                             "AR_ID"  => $v_alloc["AR_ID"],
                                             "PAYMENT_DATE" => $v_alloc["PAYMENT_DATE"])
                                   );
                               }
                           }//if rules are ok!

                           // update ledger entry info for allocation
                           if ($pay_alloc_id) {
                               $dbAccReceiv->UpdateAllocAccounts(
                                   array("AR_ID"          => $v_alloc["AR_ID"],
                                         "PAY_ALLOC_ID"   => $pay_alloc_id,
                                         "PAYMENT_DATE"   => $v_alloc["PAYMENT_DATE"],
                                         "DEBIT_ACCOUNT"  => $v_alloc["DEBIT_ACCOUNT"],
                                         "CREDIT_ACCOUNT" => $v_alloc["CREDIT_ACCOUNT"])
                               );
                           }

                        }//for allocations
                    }
           } // --- if (@$values["RECEIVABLE"])

           // -- update other patyments
           foreach($values["OTHER_PAYMENTS"] as $v)
           {
              if (@$v["AR_ID"]) {
                $dbAccReceiv->UpdateRow2($v);
              } else {
                $dbAccReceiv->InsertRow2($v);
              }
           }
        } //  --- if ($action == UPDATE_RECEIVABLE)
     }
     catch(SQLException $e)
     {
        $IsError = 1;
        $smarty->connection->rollback();
        $de =  new DatabaseError($smarty->connection);
        $smarty->assign("errorObj", $de->getErrorFromException($e));
     }

     if (!$IsError)
     {
        header("Location: ".$href);
        exit;

     }
 }

 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 $smarty->assign("dates", $dates_elements);
 // send form data to Smarty
 $smarty->assign('action', $action);
 $smarty->assign('form_data', $renderer->toArray());
 $buInfo =  $dbBU->getBusinessUnit($currentBUID);
 $smarty->assign("header_title", $buInfo["BUSINESS_NAME"]." Receivables");
 $smarty->assign("currYearMonth", $currYearMonth);
 $smarty->assign("businessList", $buList);
 $smarty->assign("businessID", $currentBUID);
 $smarty->assign("summary", $summary);
 $smarty->assign("msgSuccess", $msgSuccess);
 $smarty->assign("isEdit", $isEdit ? "true" : "false");

?>