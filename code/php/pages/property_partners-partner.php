<?php
    require_once dirname(__FILE__).'/../classes/database/rnt_users.class.php';
    require_once dirname(__FILE__).'/../classes/UtlConvert.class.php';
    require_once dirname(__FILE__).'/../classes/SQLExceptionMessage.class.php';
    require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";
    require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
    require_once 'HTML/QuickForm.php';

    function setForm(&$form, $form_data, $form_action, $date_elements, $currentBUID, $isAppendRole)
     {
        global $menu;
        global $smarty;
        global $dbUser;
        global $dbBU;

        $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
        $form->AddElement("hidden", "USER_ID");
        $form->AddElement("hidden", "FORM_ACTION", $form_action);
        $form->AddElement("hidden", "BUSINESS_ID", $currentBUID);
        $form->AddElement("hidden", "CHECKSUM");

        $el = $form->AddElement("text", "USER_LASTNAME", "Last Name", array("size"=>20));
        $el = $form->AddElement("text", "USER_NAME", "First Name", array("size"=>20));
        $el = $form->AddElement("text", "PRIMARY_PHONE", "Primary Phone", array("size"=>15));
        $el = $form->AddElement("text", "SECONDARY_PHONE", "Secondary Phone", array("size"=>15));
        $el = $form->AddElement("text", "USER_LOGIN", "E-mail (login)", array("size"=>25));
        $e = &$form->AddElement("advcheckbox", "IS_SUBSCRIBED_YN", "Subscription?", "",  array("N", "Y"));
        $e = &$form->AddElement("advcheckbox", "IS_ACTIVE_YN", "Account Enabled?", "",  array("N", "Y"));
        
        
        $e->freeze();
        unset($e);

        // rule for validate
        $form->addRule('USER_NAME', 'Set First Name.', 'required');
        $form->addRule('USER_LASTNAME', 'Set Last Name.', 'required');
        $form->addRule('USER_LOGIN', 'Set E-mail (login).', 'required');
        $form->addRule('USER_LOGIN', 'Field E-mail (login) is a not e-mail address.', 'email');

        // ---- append roles
        if ($isAppendRole){

            $hierlist = &$form->AddElement("hierselect", "ROLE_BUSINESS", "");
            if ($smarty->user->isOwner() 
	    || $smarty->user->isManager()
	    || $smarty->user->isBuyer()
	    || $smarty->user->isBookKeeping())
              $roleList = $dbUser->getOwerManagerRoles();
            else
              $roleList = $dbUser->getRolesForLevel1();
            $x1 = array();
            $x2 = array();
            foreach($roleList as $k=>$v){
               $x1[$v["ROLE_ID"]] = $v["ROLE_NAME"];
               $b = $dbBU->getBusinessUnitByRole($v["ROLE_CODE"]/*, $currentBUID*/);
               foreach($b as $k1=>$v1)
                  $x2[$v["ROLE_ID"]][$v1["BUSINESS_ID"]] = $v1["BUSINESS_NAME"];
            }
            $hierlist->setMainOptions($x1);
            $hierlist->setSecOptions($x2);
        }

        // -----

        // Apply filter for all data cells
        $form->applyFilter('__ALL__', 'trim');
        $r = array();
        if($form_action == INSERT_ACTION)
            $r = array("disabled");
        $form->AddElement("submit", "delete", "Delete", $r);
        $form->AddElement("submit", "new", "New", $r);
        $form->AddElement("submit", "cancel", "Cancel");
        $form->AddElement("submit", "accept", "Save");
        $form->AddElement("submit", "newRole", "New", $r);

    } // --- function setForm($form, $size)

 function IDinList($array, $id)
 {
    foreach($array as $v)
        if ($v["USER_ID"] == $id)
           return true;
    return false;
 }

 $isEdit = (  $smarty->user->isBusinessOwner());

 if (!(  $smarty->user->isManager() 
      || $smarty->user->isManagerOwner() 
      || $smarty->user->isOwner() 
      || $smarty->user->isBusinessOwner()
      || $smarty->user->isBuyer()
      || $smarty->user->isBookKeeping()))
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
    exit;
 }


 if (!defined("PARTNERS"))
 {
     define("PARTNERS", "1");
     define("UPDATE_ACTION", "UPDATE");
     define("DELETE_ACTION", "DELETE");
     define("DELETE_ROLE_ACTION", "DELETE_ROLE");
     define("INSERT_ACTION", "INSERT");
     define("INSERT_ROLE_ACTION", "INSERT_ROLE");
     define("CANCEL_ACTION", "CANCEL");
 }

// $dbSupplier = new RNTSupplier($smarty->connection);
 // business units
 $dbBU = new RNTBusinessUnit($smarty->connection);
 $dbUser = new RNTUser($smarty->connection);
 if (  $smarty->user->isManager() 
    || $smarty->user->isOwner() 
    || $smarty->user->isBuyer()
		|| $smarty->user->isBookKeeping())
    $buList = $dbBU->getBusinessUnitsLevel2();
 else
    $buList = $dbBU->getBusinessUnits2();
 $currentBUID = @$_REQUEST["BUSINESS_ID"];


  if (!$currentBUID)
   $currentBUID = @$buList[0]["BUSINESS_ID"];

 foreach($buList as $k=>$v)
 {
    $buList[$k]["PARTNERS"] = array();
    $partnersList = $dbUser->getUserAssignmentList($v["BUSINESS_ID"]);
    foreach($partnersList as $k1=>$v1)
        $buList[$k]["PARTNERS"][] = array("USER_ID"=>$v1["USER_ID"], "USER_FULLNAME"=>$v1["USER_FULLNAME"]);
 }

 $partnersList = $dbUser->getUserAssignmentList($currentBUID);

 $currentUserID = @$_REQUEST["USER_ID"];

 if (@$_REQUEST["action"] == "EnableAccount"){
    // call db proc for send e-mail
    //$dbUser->sendEmailAndActivateAccount($currentUserID);
    $passwd = $dbUser->activateAccountGetPasswd($currentUserID);
    //header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&USER_ID=".$currentUserID."&BUSINESS_ID=".$currentBUID);
    //exit;
 }

 if (@$_REQUEST["action"] == "DisableAccount"){
    $dbUser->disableAccount($currentUserID);
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&USER_ID=".$currentUserID."&BUSINESS_ID=".$currentBUID);
    exit;
 }
 

 $form = new HTML_QuickForm('partners', 'POST');

 $IsPost = $form->isSubmitted();
 $action = @$_REQUEST["action"];

 if (@$_POST["FORM_ACTION"])
    $action = $_POST["FORM_ACTION"];
 if (@$_REQUEST["delete"])
    $action = DELETE_ACTION;
 $actions = array(INSERT_ACTION, UPDATE_ACTION, DELETE_ACTION, CANCEL_ACTION, INSERT_ROLE_ACTION, DELETE_ROLE_ACTION);
 if (!in_array($action, $actions))
    $action = UPDATE_ACTION;

 if ($currentUserID == null || !IDinList($partnersList, $currentUserID))
 {
     if (count($partnersList) == 0)
     {
         $action = INSERT_ACTION;
         $currentUserID = -1;
     }
     else
        $currentUserID = $partnersList[0]["USER_ID"];
 }

 if (@$_REQUEST["new"]){
     header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&USER_ID=".$currentUserID."&BUSINESS_ID=".$currentBUID."&action=".INSERT_ACTION);
     exit;
 }

 if (@$_REQUEST["newRole"]){
     header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&USER_ID=".$currentUserID."&BUSINESS_ID=".$currentBUID."&action=".INSERT_ROLE_ACTION);
     exit;
 }

 if (@$_REQUEST["cancel"])
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&USER_ID=".$currentUserID."&BUSINESS_ID=".$currentBUID);
    exit;
 }

 $form_data = array();
 $isAppendRole = false;
 if ($action == INSERT_ACTION){
     $form_data = array("USER_ID" => $currentUserID, "BUSINESS_ID" => $currentBUID);
     $isAppendRole = true;
 }
 else
 {
     if ($IsPost)
       $form_data = $_POST;
     else {
       $form_data = $dbUser->getUser($currentUserID);
       $form_data["IS_ACTIVE_YN"] = $form_data["IS_ACTIVE_YN"] == "Y";
       $form_data["IS_SUBSCRIBED_YN"] = $form_data["IS_SUBSCRIBED_YN"] == "Y";
     }

     $userRolesList = $dbUser->getUserAssignmentsForBusinessOwner($currentUserID);

     if ($action == INSERT_ROLE_ACTION)
       $isAppendRole = true;
 }

 $date_elements = array();
 setForm($form, $form_data, $action, $date_elements, $currentBUID, $isAppendRole);
 if (!$isEdit)
   $form->freeze();

 if (!$IsPost)
    $form->setDefaults(@$form_data);

 if ( (($IsPost && $form->validate()) || $action == DELETE_ACTION || $action == DELETE_ROLE_ACTION ) && $isEdit)
 {

    // save form to database
    $values = $form->getSubmitValues();
    $IsError = 0;

    try
    {
/*        if ($action == DELETE_ACTION)
           $dbUser->Delete($currentPeopleID);
        else*/
        if ($action == UPDATE_ACTION || $action == INSERT_ROLE_ACTION){
           $dbUser->Update($values);
           if (@$values["ROLE_BUSINESS"])
              $dbUser->addAssignment(array("USER_ID" => $currentUserID, "ROLE_ID" => $values["ROLE_BUSINESS"][0], "BUSINESS_ID" => $values["ROLE_BUSINESS"][1]));
        }
        else if ($action == DELETE_ROLE_ACTION){
           $dbUser->deleteAssignment($_REQUEST["USER_ASSIGN_ID"]);
        }
        else
        if ($action == INSERT_ACTION){
           $currentUserID = $dbUser->Insert($values);
           if (@$values["ROLE_BUSINESS"])
              $dbUser->addAssignment(array("USER_ID" => $currentUserID, "ROLE_ID" => $values["ROLE_BUSINESS"][0], "BUSINESS_ID" => $values["ROLE_BUSINESS"][1]));
        }
        else
           throw new Exception('Unknown operation');

        $smarty->connection->commit();
    }
    catch(SQLException $e)
    {
          $IsError = 1;
          $de =  new DatabaseError($smarty->connection);
          $smarty->assign("errorObj", $de->getErrorFromException($e));
          $smarty->connection->rollback();
    }

    // redirect to page
    if (!$IsError)
    {
       // check is last business_id in current business_id
       $bus = $dbUser->getUserAssignments($currentUserID);
       $find = false;
       foreach($bus as $v)
          if ($bus["BUSINESS_ID"] == $currentBUID){
             $find = true;
             break;
          }

       if (!$find) $currentBUID = $bus[0]["BUSINESS_ID"];

       $s = "Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&BUSINESS_ID=".$currentBUID."&USER_ID=".$currentUserID;

       if (@$_REQUEST["new"])
          header($s.'&action='.INSERT_ACTION);
       else
          header($s);
       exit;
    } // -- if (!$IsError)
 }

 $header_title = "Partners - ";
 if ($action == INSERT_ACTION)
   $header_title .= "New";
 else
 {
    $partner = $dbUser->getUser($currentUserID);
    $header_title .= $partner["USER_LASTNAME"]." ".$partner["USER_NAME"];
 }

 if (@$userRolesList){
   //  if (count($userRolesList) > 1) { // not allowed delete one user assignment
         foreach($userRolesList as &$v)
            $v["DELETE_LINK"] = "<a href=\"?".
               $menu3->getParams()."&".$menu->getParam2()."&action=".DELETE_ROLE_ACTION."&USER_ID=".$currentUserID."&USER_ASSIGN_ID=".$v["USER_ASSIGN_ID"]."&BUSINESS_ID=".$currentBUID."\"
                onclick=\"return confirm('Delete this record?')\"><img border=\"0\" width=\"14\" height=\"14\" src=\"images/delete.gif\">";

         unset($v);
  //    }
 }

 $actionList = array();
 if ($action != INSERT_ACTION){
    $u = $dbUser->getUser($currentUserID);
    $actionList[] = array("alt"=>"Compose e-mail", "href"=> "mailto:".$u["USER_LOGIN"]."?subject=".("Visulate Rental")."&body=".("Hello, ".$u["USER_NAME"]." ".$u["USER_LASTNAME"].".\n\n"), "text"=>"Send an E-mail to ".$u["USER_NAME"]." ".$u["USER_LASTNAME"]);
    if ($u["IS_ACTIVE_YN"] == "N")
        $actionList[] = array("alt"=>"Activate account and send e-mail to user","href"=> "?".$menu3->getParams()."&".$menu->getParam2()."&action=EnableAccount&BUSINESS_ID=".$currentBUID."&USER_ID=".$currentUserID, "text"=>"Enable Account for ".$u["USER_NAME"]." ".$u["USER_LASTNAME"]);
    else
        $actionList[] = array("alt"=>"Disable account","href"=> "?".$menu3->getParams()."&".$menu->getParam2()."&action=DisableAccount&BUSINESS_ID=".$currentBUID."&USER_ID=".$currentUserID, "text"=>"Disable Account for ".$u["USER_NAME"]." ".$u["USER_LASTNAME"]);
    if ($passwd) 
       $actionList[] =array("alt"=>"Compose e-mail"
                           , "href"=> "mailto:".$u["USER_LOGIN"]."?subject=".("Visulate Rental")."&body=".("Hi ".$u["USER_NAME"].", I've setup your Visulate account. Login as ".$u["USER_LOGIN"]." password ".$passwd["PASSWD"])
                           , "text"=>"Send login details to ".$u["USER_NAME"]." ".$u["USER_LASTNAME"]);

       
 }

 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 // send form data to Smarty
 $smarty->assign('action', $action);
 $smarty->assign('form_data', $renderer->toArray());

 $smarty->assign("businessList", $buList);
 $smarty->assign("businessID", $currentBUID);
 $smarty->assign("userID", $currentUserID);
 $smarty->assign("header_title", $header_title);
 $smarty->assign("userRolesList", @$userRolesList);
 $smarty->assign("actionList", $actionList);
 $smarty->assign("isEdit", $isEdit ? "true" : "false");


?>