<?
  /* Page has included for /../index.php */
 require_once dirname(__FILE__)."/../classes/database/rnt_error_message.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

 if (!$smarty->user->isAdmin())
 {
   header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
   exit;
 }

 if (!defined("ADMIN_MESSAGES"))
 {
    define("ADMIN_MESSAGES", "1");
    define("UPDATE_ACTION", "edit");
    define("INSERT_ACTION", "add");
    define("CANCEL_ACTION", "cancel");
    define("DELETE_ACTION", "delete");
    define("VIEW_ACTION", "view");
    define("ALL_CATEGORY_VALUE", "__ALL__VALUES_CAT_RY__");
 }

 $EM = new RNTErrorMessage($smarty->connection);

 $action = @$_REQUEST["action"];
 $currentErrorID = @$_REQUEST["ERROR_ID"];
 $categoryName = @$_REQUEST["CATEGORY_NAME_SELECTED"];

 if (!$action)
   $action = VIEW_ACTION;

 if ($action == CANCEL_ACTION || @$_REQUEST["cancel"])
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->request_menu_level2."=".$menu->current_level2."&CATEGORY_NAME_SELECTED=".$categoryName."#errorID".$currentErrorID);
    exit;
 }

 $form = new HTML_QuickForm('formMessages', 'POST');
 $IsPost = $form->isSubmitted();

 $form->AddElement("hidden", $menu3->request_property_id, $menu3->current_property_id);
 // menu 2 level
 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
 $form_data = array();
 if ($action == VIEW_ACTION)
 {
     $filter = "";
     if ($categoryName != ALL_CATEGORY_VALUE)
        $filter = $categoryName;


     $message_list = $EM->getList($filter);
     if (count($message_list) == 0)
     {
       $message_list = $EM->getList("");
       $categoryName = "";
     }
     $catList = $EM->getCategoryList();

     $categoryList = array();
     foreach($catList as $v)
        $categoryList[$v["VALUE"]] = $v["VALUE"];
     $categoryList = array(ALL_CATEGORY_VALUE => "All Category") + $categoryList;

    $form->AddElement("select", "CATEGORY_NAME_SELECTED", "Select category: ", $categoryList, array("onchange"=>"submit()"));
    $form_data["CATEGORY_NAME_SELECTED"] = $categoryName;
 }
 else if ($action == UPDATE_ACTION || $action == INSERT_ACTION) {
    include dirname(__FILE__)."/../fckeditor/fckeditor.php";
    $longDescription = @$_POST["LONG_DESCRIPTION"];
    $form->AddElement("hidden", "CATEGORY_NAME_SELECTED", $categoryName);
    if ($action != INSERT_ACTION)
       $info = $EM->getMessage($currentErrorID);
    $form->AddElement("hidden", "ERROR_ID", $currentErrorID);
    $form->AddElement("hidden", "action", $action);
    $form->AddElement("hidden", "CHECKSUM");
    $form->AddElement("text", "ERROR_CODE", "Error code");
    $form->AddElement("text", "CLASSIFIED_DESCRIPTION", "Category");
    $form->AddElement("textarea", "SHORT_DESCRIPTION", "Short description", array("cols"=>60, "rows"=>"6"));
    $form->AddElement("advcheckbox", "DISPLAY_SHORT_DESCRIPTION_YN", "Use this short description?");
    $form->AddElement("advcheckbox", "SHOW_LONG_DESCRIPTION_YN", "Show long description?");


//    $form->AddElement("textarea", "LONG_DESCRIPTION", "Long description", array("cols"=>60, "rows"=>"15"));


    $form->addRule("ERROR_CODE", "Error Code is require", 'required');
    $form->addRule("SHORT_DESCRIPTION", "Short Description is require", 'required');
    $form->addRule("ERROR_CODE", "Error Code must be numeric", 'numeric');
    if ($IsPost)
    {
      if (@$code = $_REQUEST["ERROR_CODE"])
      {
         if ($code < 20000 || $code > 20999)
            $form->setElementError("ERROR_CODE", "Error code must be in range 20000..20999.");
      }
    }
    else{
       if ($action != INSERT_ACTION){
           $info["SHOW_LONG_DESCRIPTION_YN"] = $info["SHOW_LONG_DESCRIPTION_YN"] == "Y" ? 1 : 0;
           $info["DISPLAY_SHORT_DESCRIPTION_YN"] = $info["DISPLAY_SHORT_DESCRIPTION_YN"] == "Y" ? 1 : 0;
       }
    }

    $form->AddElement("submit", "cancel", "Cancel");
    $form->AddElement("submit", "Submit", "Save");
    if (@$info)
       foreach($info as $k=>$v)
          $form_data[$k] = $v;

    if (!$IsPost)
      $longDescription = @$info["LONG_DESCRIPTION"];

    if ($action == INSERT_ACTION && !$IsPost)
    {
       $form_data["CLASSIFIED_DESCRIPTION"] = $EM->getCategoryName($categoryName);
       $longDescription = "<b>What does this mean?</b><br><br><b>How do i fix it?</b><br><br><b>What would happen if I ignore it?</b><br>";
       $form_data["SHOW_LONG_DESCRIPTION_YN"] = 1;
       $form_data["DISPLAY_SHORT_DESCRIPTION_YN"] = 1;
    }
    // ------  FCKEditor
    $sBasePath = $GLOBALS["PATH_FORM_ROOT"]."fckeditor/";
    $oFCKeditor = new FCKeditor('LONG_DESCRIPTION') ;
    $oFCKeditor->ToolbarSet = "Visulate";
    $oFCKeditor->BasePath = $sBasePath;
    $oFCKeditor->Value  = $longDescription;
    $smarty->assign("fckEditor", $oFCKeditor);
    /// ---------------- end of FCKEditor
 }

  // Apply filter for all data cells
 $form->applyFilter('__ALL__', 'trim');
 $form->setDefaults(@$form_data);
 if ( (($IsPost && $form->validate()) || $action == DELETE_ACTION) && ($action != VIEW_ACTION)) {
    // save form to database
    $values = $form->getSubmitValues();
    $IsError = 0;
    $NewID = -1;
    try
    {
        if ($action == UPDATE_ACTION)
           $EM->Update($values);
        else
        if ($action == INSERT_ACTION)
           $currentErrorID = $EM->Insert($values);
        else
        if ($action == DELETE_ACTION)
           $EM->Delete($currentErrorID);
        else
           throw new Exception('Unknown operation');

        $smarty->connection->commit();
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
        if ($action == DELETE_ACTION)
            header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&CATEGORY_NAME_SELECTED=".$categoryName);
        else
            {
               $cName = $categoryName;
               $r = $EM->getMessage($currentErrorID);
               if ($cName &&  $r["CLASSIFIED_DESCRIPTION"] != $cName)
                 $cName = $r["CLASSIFIED_DESCRIPTION"];
               header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&CATEGORY_NAME_SELECTED=".$cName."#errorID".$currentErrorID);
            }
        exit;
    }
 }



  // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 $header_title = "Error messages";
 $smarty->assign("header_title", $header_title);
 $smarty->assign("em_list", @$message_list);
 $smarty->assign("is_form", $action == VIEW_ACTION ? "no" : "yes");
 $smarty->assign('form', $renderer->toArray());
 $smarty->assign("categoryName", $categoryName);
?>