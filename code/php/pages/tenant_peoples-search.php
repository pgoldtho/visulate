<?php

 require_once dirname(__FILE__)."/../classes/database/rnt_peoples.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

function adjustValue($val){
    if ($val == "%") {
        $val = "";
    }

    if (strpos($val, "%") === FALSE && strlen($val) > 3) {
        $val = "%".$val."%";
    }
    return $val;
}

 $dbPeoples = new RNTPeoples($smarty->connection);

 $dbBU = new RNTBusinessUnit($smarty->connection);

 $header_title = "Peoples - Search";
 $form = new HTML_QuickForm('formPeople', 'POST');
 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
 $form->AddElement("hidden", "type", "search");
 $form->AddElement("text", "NameValue", "Name", array("size"=>40));
 $form->AddElement("text", "PhoneValue", "Phone", array("size"=>20));
 $form->AddElement("text", "EmailValue", "E-mail", array("size"=>30));
 $form->AddElement("text", "SSN", "SSN", array("size"=>20));
 // Button "Find"
 $form->AddElement("submit", "find", "Find");
 // Button "New"
 $currentBUID = Context::getBusinessID();
 $form->AddElement("button", "new", "New", array("onclick"=>"window.location.href='?{$menu->getParam2()}&BUSINESS_ID={$currentBUID}&action=INSERT'"));

 $form->applyFilter('__ALL__', 'trim');

 $warning = "";
 $IsPost  = $form->isSubmitted();
 $values  = $form->getSubmitValues();

// $vNames = array("NameValue", "PhoneValue", "SSN");
// foreach($vNames as $v) {
//     $vNames[$v] = adjustValue(@$vNames[$v]);
// }

 if ($form->isSubmitted() && !($values["NameValue"] || $values["PhoneValue"] || $values["EmailValue"] || $values["SSN"]) )
   $warning = "Enter values for search.";
 else
 if ($IsPost){
    $data = $dbPeoples->findForIncluding(
            adjustValue($values["NameValue"])
        ,   adjustValue($values["PhoneValue"])
        ,   adjustValue($values["EmailValue"])
        ,   $values["SSN"]
    );
    // deviding data to 2 columns data
    foreach($data as $k=>$v){
        $f = array();
        $t = $v["BUSINESS_UNITS"];
        $l = count($t);
        $l1 = intval(($l+1)/2);
        for($i=0; $i < $l1; $i++){
           $f[] = $t[$i];
           if ($i + $l1 < $l) {
               $f[] = $t[$i + $l1];
           }
        }
        $data[$k]["BUSINESS_UNITS"] = $f;
    } // --- end foreach ($data...


    $smarty->assign("data", $data);
    if (count($data) == 0) {
        $warning = "No record found";
    }
 }

 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);
 $smarty->assign('form_data', $renderer->toArray());

 $smarty->assign("header_title", $header_title);
 $smarty->assign("warning", $warning);
?>
