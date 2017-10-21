<?

 require_once dirname(__FILE__)."/../classes/database/rnt_section8.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

 $dbSection8 = new RNTSection8($smarty->connection);

 $dbBU = new RNTBusinessUnit($smarty->connection);

 $header_title = "Section 8 Offices - Search";
 $form = new HTML_QuickForm('formF8', 'POST');
 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
 $form->AddElement("hidden", "type", "search");
 $form->AddElement("text", "searchValue", "Search Section8", array("size"=>20));
 $form->AddElement("submit", "find", "Find");

 $warning = "";
 $IsPost = $form->isSubmitted();
 $value = trim(@$_POST["searchValue"]);
 if ($value == "%")
   $value = "";

 if ($form->isSubmitted() && !$value)
   $warning = "Enter value for search";

 if ($IsPost){
    if (strpos($value, "%") === FALSE && strlen($value) > 3)
      $value = "%".$value."%";
    $data = $dbSection8->findForIncluding($value);
    // deviding data to 2 columns data
    foreach($data as $k=>$v){
        $f = array();
        $t = $v["BUSINESS_UNITS"];
        $l = count($t);
        $l1 = intval(($l+1)/2);
        for($i=0; $i < $l1; $i++){
           $f[] = $t[$i];
           if ($i + $l1 < $l)
              $f[] = $t[$i + $l1];
        }
        $data[$k]["BUSINESS_UNITS"] = $f;
    } // --- end foreach ($data...


    $smarty->assign("data", $data);
    if (count($data) == 0)
      $warning = "No record found";
 }

/*
 <tr><td>
         {if ($item1.IS_INCLUDED == 'Y') }
            <b style="color:#666666">{$item1.BUSINESS_NAME}</b>
         {else}
            {$item1.BUSINESS_NAME}
         {/if}
      </td></tr>
*/
 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);
 $smarty->assign('form_data', $renderer->toArray());

 $smarty->assign("header_title", $header_title);
 $smarty->assign("warning", $warning);
?>
