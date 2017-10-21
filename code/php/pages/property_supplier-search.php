<?

 require_once dirname(__FILE__)."/../classes/database/rnt_supplier.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

 $dbSupplier = new RNTSupplier($smarty->connection);

 $dbBU = new RNTBusinessUnit($smarty->connection);

 $types = array("" => "All");
 foreach($dbSupplier->getSupplierTypes() as $k=>$v)
    $types[$k] = $v;

 $states = array("" => "All");
 $states = array_merge($states, $dbSupplier->getStatesList());

 $header_title = "Vendor - Search";
 $form = new HTML_QuickForm('formSupp', 'POST');
 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
 $form->AddElement("hidden", "type", "search");
 $form->AddElement("text", "NameValue", "Name", array("size"=>40));
 $form->AddElement("text", "PhoneValue", "Phone", array("size"=>20));
 $form->AddElement("text", "EmailValue", "E-mail", array("size"=>30));
 $form->AddElement("text", "AddressValue", "Address", array("size"=>35));
 $form->AddElement("text", "CityValue", "City", array("size"=>20));
 $form->AddElement("select", "StateValue", "State", $states, array("style"=>"width:206px;"));
 $form->AddElement("text", "ZipCodeValue", "Zip Code", array("size"=>15));
 $form->AddElement("select", "SupplierTypeIDValue", "Type",  $types);
 $form->AddElement("submit", "find", "Find");
 $form->applyFilter('__ALL__', 'trim');

  $warning = "";
 $IsPost = $form->isSubmitted();
 $values =  $form->getSubmitValues();

 function adjustValue($val){
    if ($val == "%")
       $val = "";

    if (strpos($val, "%") === FALSE && strlen($val) > 3)
      $val = "%".$val."%";
    return $val;
 }

 $vNames = array("NameValue", "PhoneValue", "AddressValue");
 foreach($vNames as $v)
    $vNames[$v] = adjustValue(@$vNames[$v]);

 if ($form->isSubmitted() && !($values["NameValue"] || $values["PhoneValue"] || $values["EmailValue"] || $values["AddressValue"] || $values["CityValue"] ||
       $values["StateValue"] || $values["ZipCodeValue"] || (strlen($values["SupplierTypeIDValue"])>0) ) )
   $warning = "Enter values for search.";
 else
 if ($IsPost){
    $data = $dbSupplier->findForIncluding($values["NameValue"], $values["PhoneValue"], $values["EmailValue"], $values["AddressValue"],
                                          $values["CityValue"], $values["StateValue"], $values["ZipCodeValue"], $values["SupplierTypeIDValue"]);

    $smarty->assign("data", $data);
    if (count($data) == 0)
      $warning = "No record found";
 }

 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);
 $smarty->assign('form_data', $renderer->toArray());
 $smarty->assign("header_title", $header_title);
 $smarty->assign("warning", $warning);
?>
