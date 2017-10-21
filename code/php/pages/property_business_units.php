<?
  /* Page has included for /../index.php */
 require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_agreement.class.php";
 require_once dirname(__FILE__)."/../ckeditor/ckeditor.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

 if (!defined("BUSINESS_UNIT"))
 {
    define("BUSINESS_UNIT", "1");
    define("UPDATE_ACTION", "UPDATE");
    define("INSERT_ACTION", "INSERT");
    define("CANCEL_ACTION", "CANCEL");
    define("DELETE_ACTION", "DELETE");
    define("VIEW_ACTION", "VIEW");
	define("EDIT_TEMPLATE", "EDIT_TEMPLATE");
	define("SAVE_TEMPLATE", "SAVE_TEMPLATE");	
	define("EDIT_BU", "EDIT_BU");	
 }
 $BU = new RNTBusinessUnit($smarty->connection);
 $dbTemplate = new RNTAgreement($smarty->connection);

 $bu_tree = $BU->getTreeForUser();

 $smarty->assign("bu_tree", $bu_tree);
 $action = "";
 $action_type = "";
 $current_parent_id = -1;
 $current_id = -1;
 if (@$_GET["action"] == "ins")
 {
     $action = INSERT_ACTION;
     $current_parent_id = intval($_GET["parent"]);
 }
 else if (@$_GET["action"] == "upd")
 {
     $action = UPDATE_ACTION;
     $current_id = intval($_GET["id"]);
 }
 else if(@$_GET["action"] == "del")
 {
     $action = DELETE_ACTION;
     $current_id = intval($_GET["id"]);
 }
 else
  {
   if (array_key_exists('FORM_ACTION', $_POST))
   {
    $action = $_POST["FORM_ACTION"];
 
    if ($action != DELETE_ACTION
		 && $action != INSERT_ACTION
		 && $action != UPDATE_ACTION 
		 && $action != CANCEL_ACTION 
		 && $action != VIEW_ACTION)
      $action = VIEW_ACTION;
   if ($action == INSERT_ACTION)
      $current_parent_id = $_POST["PARENT_BUSINESS_ID"];
   if ($action == UPDATE_ACTION)
      {
      $current_id = $_POST["BUSINESS_ID"];
	  if (array_key_exists('edit_template', $_POST))
	     {
	      $action_type = EDIT_TEMPLATE;
		  $template = $_POST["TEMPLATE"];
		 }
	  elseif (array_key_exists('save_template', $_POST))
	     $action_type = SAVE_TEMPLATE;
	  elseif (array_key_exists('cancel_template', $_POST))	{
	     $action_type = CANCEL_TEMPLATE;}
	  else
	     $action_type = EDIT_BU;
	  }
 }
}
 if (@$_POST["cancel"])
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->request_menu_level2."=".$menu->current_level2);
    exit;
 }
 elseif ($action_type==CANCEL_TEMPLATE)
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->request_menu_level2."=".$menu->current_level2."&action=upd&id=".$current_id);	  
	exit;
 }
 $form = new HTML_QuickForm('formBU', 'POST');
 $IsPost = $form->isSubmitted();

 if (!$IsPost)
 {
    if ($action == UPDATE_ACTION)
    {
       if ($r = $BU->getBusinessUnit($current_id))
          $form->setDefaults($r);
		  if (array_key_exists('TEMPLATE', $_GET))
		    {
            $template = $_GET["TEMPLATE"];
			$form->AddElement("hidden", "TEMPLATE_ID", $template);
			if ($template == 0)
			  {
			   $form->AddElement("text", "TEMPLATE_NAME", "Template Name");
			   $form->AddElement("hidden", "TEMPLATE_ACTION", "INSERT");
			  }
			else
			  {
			   $templateDetails = $dbTemplate->getTemplateName($template);
			   $form->AddElement("hidden", "T_CHECKSUM", $templateDetails["CHECKSUM"]);			  
			   $form->AddElement("text", "TEMPLATE_NAME", "Template Name"
			                    , array("value" => $templateDetails["NAME"] ));
			   $form->AddElement("hidden", "TEMPLATE_ACTION", "UPDATE");
			  }
			
            $form->AddElement("submit", "save_template", "Save", array());
			$form->AddElement("submit", "cancel_template", "Close/Cancel", array());
			$t_content = $dbTemplate->getTemplateText($template);
			
			
			
           // ------ CKEditor
           $sBasePath  = $GLOBALS["PATH_FORM_ROOT"]."ckeditor/";
           $oCKeditor = new CKeditor() ;
           $cke_config = array();

	       $cke_config['toolbar'] = array(
	          array( 'Source', '-','Print', 'Preview' ),
	          array( 'Cut','Copy','Paste','PasteText','PasteFromWord','-', 'SpellChecker', 'Scayt' ),
	          array( 'Undo','Redo','-','Find','Replace' ),
 	          array( 'Bold','Italic', 'Underline','Strike','-','Subscript','Superscript', 'TextColor' ),   
	          array( 'NumberedList','BulletedList','-','Outdent','Indent' ),	     
	          array( 'JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock' )	,     
	          array( 'Link','Unlink','Anchor' ),	
			  array( 'Image','Flash','Table', 'SpecialChar' ),
			  array( 'Format','Font','FontSize' ));
	 
	       $cke_config['height'] = 512;
           $oCKeditor->basePath   = $sBasePath;
           $smarty->assign("ckEditor", $oCKeditor);
           $smarty->assign("cke_config", $cke_config);
           // ------ end of CKEditor
			
			}

    }
    else if ($action == INSERT_ACTION)
         $form->setDefaults(array("PARENT_BUSINESS_ID" => $current_parent_id));
 }

 $form->AddElement("hidden", $menu3->request_property_id, $menu3->current_property_id);
 // menu 2 level
 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
 $form->AddElement("hidden", "CHECKSUM");
 $form->AddElement("hidden", "FORM_ACTION", $action);
 $form->AddElement("hidden", "PARENT_BUSINESS_ID");
 $form->AddElement("hidden", "BUSINESS_ID");
 $form->AddElement("text", "BUSINESS_NAME", "Business Name");
 $form->AddElement("submit", "accept", "Save", array());
 $form->AddElement("submit", "cancel", "Cancel", array());
 $form->AddElement("select", "TEMPLATE", "", $dbTemplate->getBUTemplateList($current_id));
 $form->AddElement("submit", "edit_template", "Edit", array());
 // Apply filter for all data cells
 $form->applyFilter('__ALL__', 'trim');

 // Append rule REUIQRED
 $form->addRule('BUSINESS_NAME', 'Enter Business Name.', 'required');
 $form->addRule('TEMPLATE_NAME', 'Enter Template Name.', 'required');

 if ( (($IsPost && $form->validate()) 
       || $action == DELETE_ACTION) 
	      && ($smarty->user->isBusinessOwner() || $smarty->user->isManagerOwner())) {
		  
    if (array_key_exists('TEMPLATE_ACTION', $_POST) &&
	    $_POST["TEMPLATE_NAME"] == null) {
		throw new Exception('Template Name cannot be blank.  You have reached this screen because you attempted to save an agreement template without a name.  Use the back button to return to the business unit screen and fix the problem.');	
		}
    else
	{
    // save form to database
    $values = $form->getSubmitValues();
    $IsError = 0;
    $NewID = -1;
    try
    {
        if ($action == UPDATE_ACTION)
		   {
           $BU->Update($values);
		   if (array_key_exists('TEMPLATE_ACTION', $_POST))
		    {
			    $template_action = $_POST["TEMPLATE_ACTION"];
			    if ($template_action == "INSERT")
			      {
			      $template = $dbTemplate->insertNewTemplate($values);
				  $smarty->connection->commit();
  				  }
			    elseif ($template_action == "UPDATE")
			      {
			      $dbTemplate->updateTemplate($values);
				  $smarty->connection->commit();
				  $template = $_POST["TEMPLATE_ID"];
				  }
                else
                  throw new Exception('Unknown operation');				  
			}
		   }
        else
        if ($action == INSERT_ACTION)
           $NewID = $BU->Insert($values);
        else
        if ($action == DELETE_ACTION)
           $BU->Delete($current_id);
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
    }
    if (!$IsError)
    { 
	  if ($action_type == EDIT_BU)
	    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->request_menu_level2."=".$menu->current_level2."&action=upd&id=".$current_id);
	  elseif ($action_type == EDIT_TEMPLATE)
	    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->request_menu_level2."=".$menu->current_level2."&action=upd&id=".$current_id."&TEMPLATE=".$template);
	  elseif ($action_type == SAVE_TEMPLATE)
	    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->request_menu_level2."=".$menu->current_level2."&action=upd&id=".$current_id."&TEMPLATE=".$template);
	  else
        header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->request_menu_level2."=".$menu->current_level2);
      exit;
    }
 }

 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 // send form data to Smarty
 if ($action == INSERT_ACTION || $action == UPDATE_ACTION )
    $smarty->assign('isForm', "true");
 else
    $smarty->assign('isForm', "false");

 $smarty->assign('action', $action);
 $smarty->assign('id', -1);
 if ($action == INSERT_ACTION)
   $smarty->assign('id', $current_parent_id);
 else if ($action == UPDATE_ACTION)
   $smarty->assign('id', $current_id);

 $smarty->assign('form_data', $renderer->toArray());
 $header_title = "Business units";
 $smarty->assign("header_title", $header_title);
 $oCKeditor->Value  = $t_content;		   
 $smarty->assign("t_content", $t_content);		   


?>