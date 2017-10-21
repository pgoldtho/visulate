<?

 require_once dirname(__FILE__)."/../classes/database/rnt_users.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

 $dbUser = new RNTUser($smarty->connection);

 $dbBU = new RNTBusinessUnit($smarty->connection);

 $header_title = "Partners - Search";
 $form = new HTML_QuickForm('formPartners', 'POST');
 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
 $form->AddElement("hidden", "type", "search");
 $form->AddElement("text", "searchValue", "Partner e-mail", array("size"=>20));
 $form->AddElement("submit", "find", "Find");

 $warning = "";
 $IsPost = $form->isSubmitted();
 $value = trim(@$_POST["searchValue"]);

 if ($form->isSubmitted() && !$value)
   $warning = "Please enter an e-mail address";

 if ($IsPost && $value){
    $data = $dbUser->findForIncluding($value);
    $form->AddElement("submit", "add", "Add");

    foreach($data as $v){
            $hierlist = &$form->AddElement("hierselect", "ROLE_BUSINESS[".$v["USER_ID"]."]", "Add Role-Business Name", array("id"=>"ROLE_BUSINESS__".$v["USER_ID"]));
            if ($smarty->user->isOwner() || $smarty->user->isManager() || $smarty->user->isBookKeeping()|| $smarty->user->isBuyer)
                  $roleList = $dbUser->getOwerManagerRoles();
            else
                  $roleList = $dbUser->getRolesForLevel1();
            $x1 = array();
            $x2 = array();
            foreach($roleList as $k=>$v6){
                 $x1[$v6["ROLE_ID"]] = $v6["ROLE_NAME"];
                 $b = $dbBU->getBusinessUnitByRole($v6["ROLE_CODE"]);
                 foreach($b as $k1=>$v1)
                     $x2[$v6["ROLE_ID"]][$v1["BUSINESS_ID"]] = $v1["BUSINESS_NAME"];
            }
            $hierlist->setMainOptions($x1);
            $hierlist->setSecOptions($x2);
    }

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
