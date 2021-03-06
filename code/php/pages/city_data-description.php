<?php
require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
require_once "HTML/QuickForm.php";

require_once dirname(__FILE__)."/../classes/database/rnt_cities.class.php";

require_once dirname(__FILE__)."/../ckeditor/ckeditor.php";


// check user permissions
if ( ! $smarty->user->isSiteEditor())
{
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
    exit;
}

// define user actions
if ( ! defined("CITY_DATA_DESCRIPTION")) {
    define("ACTION_VIEW", "VIEW");
    define("ACTION_UPDATE", "UPDATE");
    define("ACTION_CANCEL", "CANCEL");
}

// check user's action
$action = ACTION_VIEW;
if ($_REQUEST["action_cancel"])
{
    $action = ACTION_CANCEL;
}
elseif ($_REQUEST["action_save"])
{
    $action = ACTION_UPDATE;
}
else
{
    $action = ACTION_VIEW;
}

// dispatch "cancel" action
if ($action == ACTION_CANCEL)
{
     header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2());
     exit;
}


$form      = new HTML_QuickForm('formCityData', 'POST');
$RNTCities = new RNTCities($smarty->connection);

if (! $form->isSubmitted())
{
    $location  = $_REQUEST["location"] ? $_REQUEST["location"] : "US";
    $city_id   = $_REQUEST["city_id"];
    if ($city_id)
      {
      $city_data  = $RNTCities->getCityData($city_id);
      $city_description = $city_data["DESCRIPTION"];
      $page_title       = $city_data["NAME"];
      if ($page_title == "ANY")
          $page_title = $city_data["STATE"]." - ".$city_data["COUNTY"]." County";
      }
    else
      {
      $city_data  = $RNTCities->getCountyData($location);
      $city_description = $city_data["DESCRIPTION"];
      $page_title       = $city_data["STATE"]." - ".$city_data["COUNTY"]." County";
      }

}
    
$cities_tree_data = $RNTCities->getCitiesTreeMenuData();
$cities_tree_html = $RNTCities->buildCitiesMenuTreeHtml($cities_tree_data);


// ************************** START FORM DECLARATION ************************ //
$form->AddElement("hidden", "action", $action);
$form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
$form->AddElement("hidden", "CITY_ID");
$form->AddElement("hidden", "NAME");
$form->AddElement("hidden", "COUNTY");
$form->AddElement("hidden", "STATE");
$form->AddElement("hidden", "CHECKSUM");
$form->AddElement("submit", "action_cancel", "Cancel", array());
$form->AddElement("submit", "action_save",   "Save",   array());


// ------ CKEditor -------------------------------------------------------------
$sBasePath  = $GLOBALS["PATH_FORM_ROOT"]."ckeditor/";
$oCKeditor  = new CKeditor() ;

// CKeditor's config
$cke_config = array();
$cke_config['toolbar'] = array(
    array( 'Source', '-','Templates' ),
    array( 'Cut','Copy','Paste','PasteText','PasteFromWord','-', 'SpellChecker', 'Scayt' ),
    //array( 'Undo','Redo','-','Find','Replace' ),
    //array( 'Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField' ),
    array( 'Bold','Italic', 'Underline','Strike','-','Subscript','Superscript', 'TextColor' ),
    array( 'NumberedList','BulletedList','-','Outdent','Indent' ),
    array( 'JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock' ),
    array( 'Link','Unlink','Anchor' ),
    array( 'Image','Flash','Table', 'SpecialChar' ),
    array( 'Format','Font','FontSize')
);
$cke_config['height'] = 512;

// CKeditor's properties
$oCKeditor->basePath = $sBasePath;
//$oCKeditor->Value  = $city_description;		   

$smarty->assign("ckEditor", $oCKeditor);
$smarty->assign("cke_config", $cke_config);
$smarty->assign("city_description", $city_description);	
// ------ end of CKEditor-------------------------------------------------------
// ************************** END FORM DECLARATION ************************** //


// ************************** START FORM DISPATCHER ************************* //
$isPost = $form->isSubmitted();
if ( ! $isPost)
{
    $form->setDefaults(
        array(
            "CITY_ID"  => $city_data["CITY_ID"],
            "NAME"     => $city_data["NAME"],
            "COUNTY"   => $city_data["COUNTY"],
            "STATE"    => $city_data["STATE"],
            "CHECKSUM" => $city_data["CHECKSUM"]
        )
    );
}
elseif ($isPost && $form->validate())
{
    $values = $form->getSubmitValues();
    
    $isError = 0;
    try {
        if ($action == ACTION_UPDATE) {
            $RNTCities->updateCityData($values);                         
        }
        else {
             throw new Exception('Unknown operation');
        }
        
        $smarty->connection->commit();
    }
    catch(SQLException $e) {
        $isError = 1;
        $smarty->connection->rollback();
        
        $de =  new DatabaseError($smarty->connection);
        $smarty->assign("errorObj", $de->getErrorFromException($e));
    }
    
    // redirect to page
    if ( ! $isError)
    {
        if ($action == ACTION_UPDATE)
        {
            header("Location: ".$GLOBALS["PATH_FORM_ROOT"]
                               ."?".$menu->getParam2()
                               .'&city_id='.$values["CITY_ID"]
            );
            exit;
        }
    }
}
// ************************** END FORM DISPATCHER *************************** //


// create renderer
$renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);

// generate code
$form->accept($renderer);
$smarty->assign('form_data', $renderer->toArray());
$smarty->assign("page_title", $page_title);
$smarty->assign("cities_tree_data", $cities_tree_data);
$smarty->assign("cities_tree_html", $cities_tree_html);
$smarty->assign("location", $location);
?>
