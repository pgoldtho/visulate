<?php

    require_once dirname(__FILE__)."/../classes/database/rnt_summary.class.php";

    require_once dirname(__FILE__)."/../classes/database/rnt_properties.class.php";
//    require_once dirname(__FILE__)."/../classes/database/rnt_loans.class.php";
    require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
    require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
    require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
    require_once "HTML/QuickForm.php";

    if (! ( $smarty->user->isOwner() || $smarty->user->isManager() || $smarty->user->isManagerOwner() || $smarty->user->isBookkeeping() || $smarty->user->isBusinessOwner()))
    {
        header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
        exit;
    }

    $currentPropertyID = $menu3->current_property_id;

    $dbProp = new RNTProperties($smarty->connection);

    $property_data = $dbProp->getProperty($currentPropertyID);
    $header_title = @$property_data["PROP_ADDRESS1"];

    $dbSummary = new RNTSummary($smarty->connection);

    $year = date("Y");
    if(!isset($_GET["year"])){}
    else
    {
        $year = $_GET["year"];
    }

    $arr_data_from_db_at_center = $dbSummary->getResultsAtCenter($currentPropertyID,$year);

////////////////////////////////////////////////////////////////////////////////
//    Block: by Pavel Kamnev
//    Description: getting year from URL or default (current)
//    Begin
////////////////////////////////////////////////////////////////////////////////

    if(@$arr_data_from_db_at_center["RECEIVABLE"]["years"][0]!=@$year)
    {
       @ array_unshift($arr_data_from_db_at_center["RECEIVABLE"]["years"],$year);
    }
    elseif(@$arr_data_from_db_at_center["PAYABLE"]["years"][0]!=$year)
    {
       @ array_unshift($arr_data_from_db_at_center["PAYABLE"]["years"],$year);
    }

////////////////////////////////////////////////////////////////////////////////
//    End
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//    Block: by Pavel Kamnev
//    Description: getting checked radio from URL or default (first), and detail data at right
//    Begin
////////////////////////////////////////////////////////////////////////////////

    $radio_id = 0;
    if(!isset($arr_data_from_db_at_center["RECEIVABLE"]["types"])){}
    else
    {
        $radio_id = $arr_data_from_db_at_center["RECEIVABLE"]["types"][0]["PAYMENT_TYPE_ID"];
    }
    if(!isset($_GET["radio_id"])){}
    else
    {
        $radio_id = $_GET["radio_id"];
    }

    $type = "RECEIVABLE";
    if(!isset($_GET["type"])){}
    else
    {
        $type = $_GET["type"];
    }
    $arr_right = $dbSummary->getResultsAtRight($currentPropertyID,$radio_id,$year,$type);

    $smarty->assign('checked',$radio_id);
    $smarty->assign('type',$type);

////////////////////////////////////////////////////////////////////////////////
//    End
////////////////////////////////////////////////////////////////////////////////

//    Array send data to template
    $arr_data_to_tpl = array("RECEIVABLE"=>array(),"PAYABLE"=>array());

    $radio_text = "";

//    Filling RECEIVABLE data

    $flt_Income_Total_Owed = floatval(0);
    $flt_Income_Total_Received = floatval(0);

    if(!isset($arr_data_from_db_at_center["RECEIVABLE"]["types"])){}
    else
    while(list($k,$v) = each($arr_data_from_db_at_center["RECEIVABLE"]["types"]))
    {
        $temp = array();
        $temp["label"] = $v["PAYMENT_TYPE_NAME"];

        $str_AMOUNT_OWED = $v["AMOUNT_OWED"];
        $str_AMOUNT_OWED = str_replace(",",".",$str_AMOUNT_OWED);
        $str_AMOUNT_RECEIVED = $v["AMOUNT_RECEIVED"];
        $str_AMOUNT_RECEIVED = str_replace(",",".",$str_AMOUNT_RECEIVED);

        $temp["AMOUNT_OWED"] = UtlConvert::dbNumericToDisplay($v["AMOUNT_OWED"]);
        $temp["AMOUNT_OWED"] = !$temp["AMOUNT_OWED"]?0:$temp["AMOUNT_OWED"];
        $flt_Income_Total_Owed += floatval($str_AMOUNT_OWED);

        $temp["AMOUNT_RECEIVED"] = UtlConvert::dbNumericToDisplay($v["AMOUNT_RECEIVED"]);
        $temp["AMOUNT_RECEIVED"] = !$temp["AMOUNT_RECEIVED"]?0:$temp["AMOUNT_RECEIVED"];
        $flt_Income_Total_Received += floatval($str_AMOUNT_RECEIVED);

        $temp["id"] = $v["PAYMENT_TYPE_ID"];
        $arr_data_to_tpl["RECEIVABLE"][$k] = $temp;

        if($temp["id"]==$radio_id)
        {
            $radio_text = $temp["label"];
        }
    }

//    Filling PAYABLE data

    $flt_Expense_Total_Owed = floatval(0);
    $flt_Expense_Total_Received = floatval(0);

    if(!isset($arr_data_from_db_at_center["PAYABLE"]["types"])){}
    else
    while(list($k,$v) = each($arr_data_from_db_at_center["PAYABLE"]["types"]))
    {
        $temp = array();
        $temp["label"] = $v["PAYMENT_TYPE_NAME"];

        $str_AMOUNT_OWED = $v["AMOUNT_OWED"];
        $str_AMOUNT_OWED = str_replace(",",".",$str_AMOUNT_OWED);
        $str_AMOUNT_RECEIVED = $v["AMOUNT_RECEIVED"];
        $str_AMOUNT_RECEIVED = str_replace(",",".",$str_AMOUNT_RECEIVED);

        $temp["AMOUNT_OWED"] = UtlConvert::dbNumericToDisplay($v["AMOUNT_OWED"]);
        $temp["AMOUNT_OWED"] = !$temp["AMOUNT_OWED"]?0:$temp["AMOUNT_OWED"];
        $flt_Expense_Total_Owed += floatval($str_AMOUNT_OWED);

        $temp["AMOUNT_RECEIVED"] = UtlConvert::dbNumericToDisplay($v["AMOUNT_RECEIVED"]);
        $temp["AMOUNT_RECEIVED"] = !$temp["AMOUNT_RECEIVED"]?0:$temp["AMOUNT_RECEIVED"];
        $flt_Expense_Total_Received += floatval($str_AMOUNT_RECEIVED);

        $temp["id"] = $v["PAYMENT_TYPE_ID"];
        $arr_data_to_tpl["PAYABLE"][$k] = $temp;

        if($temp["id"]==$radio_id)
        {
            $radio_text = $temp["label"];
        }
    }

    $int_business_id = $dbSummary->getBusinessIdByPropertyId($currentPropertyID);

    $arr_right_to_tpl = array();

    while(list($k,$v) = each($arr_right))
    {
        $arr_ = explode("/",$v["DATE_"]);

        $href = $GLOBALS["PATH_FORM_ROOT"]."?m2=payment_receiveable&BUSINESS_ID=".$int_business_id."&YEAR_MONTH_HIDDEN=".$arr_[2].$arr_[0];
        if($type=="PAYABLE")
        {
            $href = $GLOBALS["PATH_FORM_ROOT"]."?m2=payment_payable&BUSINESS_ID=".$int_business_id."&YEAR_MONTH_HIDDEN=".$arr_[2].$arr_[0];
        }

        $temp = array();
        $temp["date"] = $v["DATE_"];
        $temp["href"] = $href;
        $temp["AMOUNT_OWED"] = UtlConvert::dbNumericToDisplay($v["AMOUNT_OWED"]);
        $temp["AMOUNT_OWED"] = !$temp["AMOUNT_OWED"]?0:$temp["AMOUNT_OWED"];
        $temp["AMOUNT_RECEIVED"] = UtlConvert::dbNumericToDisplay($v["AMOUNT_RECEIVED"]);
        $temp["AMOUNT_RECEIVED"] = !$temp["AMOUNT_RECEIVED"]?0:$temp["AMOUNT_RECEIVED"];
        $arr_right_to_tpl[$k] = $temp;
    }

////////////////////////////////////////////////////////////////////////////////
//    End
////////////////////////////////////////////////////////////////////////////////

    $dates_elements = array();

    $link = $GLOBALS["PATH_FORM_ROOT"]."?m2=property_summary&prop_id=".$currentPropertyID;
    $smarty->assign('link',$link);

    $smarty->assign('radio_id',$radio_id);

    $isData = 1;
    if(!isset($arr_center["types"]))
    {
        $isData = 0;
    }
    else
    if(!sizeof($arr_center["types"]))
    {
        $isData = 0;
    }

    $smarty->assign('radio_text',$radio_text);

    $smarty->assign('year',$year);
    $smarty->assign('isData',$isData=1);

//    $arr_years = array_merge($arr_data_from_db_at_center["RECEIVABLE"]["years"],$arr_data_from_db_at_center["PAYABLE"]["years"]);

    $arr_years = $arr_data_from_db_at_center["RECEIVABLE"]["years"];

     while(@list($k,$v) = each($arr_data_from_db_at_center["PAYABLE"]["years"]))
        $arr_years[] = $v;

    $arr_years = @array_unique($arr_years);

    $smarty->assign('select_years',$arr_years);

    $smarty->assign('data_receivable',$arr_data_to_tpl["RECEIVABLE"]);
    $smarty->assign('data_payable',$arr_data_to_tpl["PAYABLE"]);

    $smarty->assign('data_at_right',$arr_right_to_tpl);

    $smarty->assign("header_title", $header_title);

    $Income_Total_Owed = "";
    if($flt_Income_Total_Owed)$Income_Total_Owed = UtlConvert::dbNumericToDisplay($flt_Income_Total_Owed);
    else $Income_Total_Received = 0;
    $smarty->assign("Income_Total_Owed",$Income_Total_Owed);

    $Income_Total_Received = "";
    if($flt_Income_Total_Received)$Income_Total_Received = UtlConvert::dbNumericToDisplay($flt_Income_Total_Received);
    else $Income_Total_Received = 0;
    $smarty->assign("Income_Total_Received",$Income_Total_Received);

    $Expense_Total_Owed = "";
    if($flt_Expense_Total_Owed)$Expense_Total_Owed = UtlConvert::dbNumericToDisplay($flt_Expense_Total_Owed);
    else $Expense_Total_Owed = 0;
    $smarty->assign("Expense_Total_Owed",$Expense_Total_Owed);

    $Expense_Total_Received = "";
    if($flt_Expense_Total_Received)$Expense_Total_Received = UtlConvert::dbNumericToDisplay($flt_Expense_Total_Received);
    else $Expense_Total_Received = 0;
    $smarty->assign("Expense_Total_Received",$Expense_Total_Received);

?>
