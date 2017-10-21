<?php
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

 require_once dirname(__FILE__)."/../classes/database/rnt_menus.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_menu_pages.class.php";

 require_once dirname(__FILE__)."/../ckeditor/ckeditor.php";

 $is_editor = $smarty->user->isAdmin() || $smarty->user->isSiteEditor();

 $mobile_device = Context::getMobileDevice();
 if ($mobile_device)
 {
   $template_name = "mobile-dbcontent.tpl";
   $tab_name = @$_REQUEST["tab"];
 }
else { $tab_name  = $menu->current_level2;}

 $menu_name = @$_REQUEST["menu"];
 $page_name = @$_REQUEST["page"];
 $subpage   = @$_REQUEST["subpage"];


 if (!defined("ADMIN_MENUS")) {
     define("ACTION_VIEW", "VIEW");
     define("ACTION_UPDATE", "UPDATE");
 }
 // check user action
 $action = ACTION_VIEW;
 if ($_REQUEST["ACTION_CANCEL"]) {
     header("Location: ".$GLOBALS["PATH_FORM_ROOT"]
                        ."?".$menu->getParam2()
                        ."&menu=".$menu_name
                        ."&page=".$page_name
                        ."&subpage=".$subpage
     );
     exit;
 }
 elseif ($_REQUEST["ACTION_SAVE"]) {
     $action = ACTION_UPDATE;
 }
 else {
     $action = ACTION_VIEW;
 }


 $RNTMenu = new RNTMenu($smarty->connection);
 $RNTMenuPages = new RNTMenuPages($smarty->connection);

 // current menu
 $menu_tree_l3 = $RNTMenu->getTreeMenuL3($tab_name);
 $menu_name    = empty($menu_name) ? $menu_tree_l3[0]["MENU"] : $menu_name;

 // current page
 $firs_menu_page = $RNTMenuPages->getFirstPage($tab_name, $menu_name);
 $page_name      = empty($page_name) ? $firs_menu_page["PAGE_NAME"] : $page_name;

 // current sub page
 $subpages = $RNTMenuPages->getSubPages($tab_name, $menu_name, $page_name);
 $subpage  = empty($subpage) ? $subpages[0]["SUB_PAGE"] : $subpage;
 

 // prepare submenu level 2_1 of sub pages
 $href = $GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2();
 $submenu = array();
 $skey    = 0;
 foreach ($subpages as $key=>$page) {
     $submenu[] = array(
         "href"  => $href."&menu=".$menu_name
                         ."&page=".$page_name
                         ."&subpage=".$page["SUB_PAGE"],
         "value" => $page["SUB_PAGE"]
     );

     if ($subpage == $page["SUB_PAGE"]) {
         $skey = $key;
     }
 }


 // current page content
 $dbcontent = $RNTMenuPages->getPage($tab_name, $menu_name, $page_name, $subpage);
 $header_content = $dbcontent["HEADER_CONTENT"];
 $body_content   = $dbcontent["BODY_CONTENT"];
 $extra_head     = str_replace("&apos;", "'", $dbcontent["EXTRA_HEAD"]);

 /*
 require_once('FirePHPCore/FirePHP.class.php');
 $firephp = FirePHP::getInstance(true);
 $firephp->log(array($extra_head), 'dbcontent');
 */
 
 $form = new HTML_QuickForm('formDBContent', 'POST');
 $IsPost = $form->isSubmitted();

 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
 $form->AddElement("hidden", "action",  $action);
 $form->AddElement("hidden", "menu", $menu_name);
 $form->AddElement("hidden", "page", $page_name);
 $form->AddElement("hidden", "subpage", $subpage);

 $form->AddElement("hidden", "TAB_NAME",    $dbcontent["TAB_NAME"]);
 $form->AddElement("hidden", "MENU_NAME",   $dbcontent["MENU_NAME"]);
 $form->AddElement("hidden", "PAGE_NAME",   $dbcontent["PAGE_NAME"]);
 $form->AddElement("hidden", "SUB_PAGE",    $dbcontent["SUB_PAGE"]);
 $form->AddElement("hidden", "PAGE_TITLE",  $dbcontent["PAGE_TITLE"]);
 $form->AddElement("hidden", "DISPLAY_SEQ", $dbcontent["DISPLAY_SEQ"]);
 $form->addElement('textarea', "HEADER_CONTENT", null, array("rows"=>"6", "cols"=>"85"));
 $form->AddElement("hidden", "CHECKSUM",    $dbcontent["CHECKSUM"]);

 if (!$IsPost) {
     $header_content = empty($header_content) 
                     ? "<head><title>".$dbcontent["SUB_PAGE"]." - ".$dbcontent["PAGE_TITLE"]."</title></head>"
                     : $header_content;
     $form->setDefaults(array("HEADER_CONTENT" => $header_content));
 }

 // DBCONTENT
 $content = (!$IsPost) ? $body_content : $_POST["BODY_CONTENT"];
 // ------ CKEditor
 $sBasePath  = $GLOBALS["PATH_FORM_ROOT"]."ckeditor/";
 $oCKeditor = new CKeditor() ;
  $cke_config = array();

	$cke_config['toolbar'] = array(
	     array( 'Source', '-','Templates' ),
	     array( 'Cut','Copy','Paste','PasteText','PasteFromWord','-', 'SpellChecker', 'Scayt' ),
	     array( 'Undo','Redo','-','Find','Replace' ),
//	     array( 'Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField' ),	     
	     array( 'Bold','Italic', 'Underline','Strike','-','Subscript','Superscript', 'TextColor' ),   
	     array( 'NumberedList','BulletedList','-','Outdent','Indent' ),	     
	     array( 'JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock' )	,     
	     array( 'Link','Unlink','Anchor' ),	
			 array( 'Image','Flash','Table', 'SpecialChar' ),
			 array( 'Format','Font','FontSize' )
	     
	 );
	 
	$cke_config['height'] = 512;
  $oCKeditor->basePath   = $sBasePath;
  $smarty->assign("ckEditor", $oCKeditor);
 // ------ end of CKEditor

 $form->AddElement("submit", "ACTION_CANCEL", "Cancel", array());
 $form->AddElement("submit", "ACTION_SAVE",   "Save",   array());

 if ($IsPost && $form->validate()) {
     // save form to database
     $values = $form->getSubmitValues();

     $IsError = 0;
     try {
         if ($action == ACTION_UPDATE) {
               $RNTMenuPages->updatePageContent($values);
         }
         else {
               throw new Exception('Unknown operation');
         }

         $smarty->connection->commit();
     }
     catch(SQLException $e) {
         $IsError = 1;
         $smarty->connection->rollback();
         $de =  new DatabaseError($smarty->connection);
         $smarty->assign("errorObj", $de->getErrorFromException($e));
     }

     // redirect to page
     if (!$IsError)
     {
         if ($action == ACTION_UPDATE)
         {
             header("Location: ".$GLOBALS["PATH_FORM_ROOT"]
                                ."?".$menu->getParam2()
                                ."&menu=".$menu_name
                                ."&page=".$page_name
                                ."&subpage=".$subpage
             );
             exit;
         }
     }
 }// ---- end if ((($IsPost && $form->validate())

 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 $smarty->assign('form_data', $renderer->toArray());
 $smarty->assign("menu_tree_l3", $menu_tree_l3);

 $smarty->assign("submenu2_1", $submenu);
 $smarty->assign("skey", $skey);

 $smarty->assign("menu", $menu_name);
 $smarty->assign("page", $page_name);
 $smarty->assign("subpage", $subpage);
 $smarty->assign("tab", $tab_name);

 $smarty->assign("header_content", $header_content);
 $smarty->assign("body_content", $body_content);
 $smarty->assign("cke_config", $cke_config);
 $smarty->assign("extra_head", $extra_head);

 $smarty->assign("is_editor", $is_editor);
?>