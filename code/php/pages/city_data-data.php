<?

require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
require_once "HTML/QuickForm.php";

require_once dirname(__FILE__)."/../classes/database/rnt_cities.class.php";
require_once dirname(__FILE__)."/../classes/database/rnt_prvalues.class.php";

// check user permissions
if ( ! $smarty->user->isSiteEditor())
{
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
    exit;
}

// define user actions
if ( ! defined("CITY_DATA_DATA")) {
    define("ACTION_VIEW", "VIEW");
    define("ACTION_ADD_YEAR", "ADD_YEAR");
    define("ACTION_UPDATE", "UPDATE");
    define("ACTION_CANCEL", "CANCEL");
    define("ACTION_SELECT_UCODE", "SELECT_UCODE");
    define("ACTION_SELECT_YEAR", "SELECT_YEAR");
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
elseif ($_REQUEST["action_new"])
{
    $action = ACTION_ADD_YEAR;
}
elseif ($_REQUEST["action"] && ($_REQUEST["action"]=="SELECT_UCODE"))
{    
    $action = ACTION_SELECT_UCODE;
}
elseif ($_REQUEST["action"] && ($_REQUEST["action"]=="SELECT_YEAR"))
{    
    $action = ACTION_SELECT_YEAR;
}
else
{
    $action = ACTION_VIEW;
}

// dispatch "cancel" action



$form      = new HTML_QuickForm('formCityPRData', 'POST');
$RNTCities = new RNTCities($smarty->connection);
$cities_tree_data = $RNTCities->getCitiesTreeMenuData();
$cities_tree_html = $RNTCities->buildCitiesMenuTreeHtml($cities_tree_data);

$city_id    = $_REQUEST["city_id"];
if (! $form->isSubmitted())
{
    $location   = $_REQUEST["location"] ? $_REQUEST["location"] : "US";
    $city_id    = $_REQUEST["city_id"];
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

$ucode   = $_REQUEST["filter_ucode"]; 
$year    = $_REQUEST["filter_year"]; 

$RNTPRValues      = new RNTPRValues($smarty->connection);
$city_ucodes_lov  = $RNTPRValues->getCityUsageCodesLOV($city_id, $year);
$city_years_lov   = $RNTPRValues->getCityYearsLOV($city_id, $ucode);

if ($action != ACTION_ADD_YEAR)
{
    $city_pr_values   = $RNTPRValues->getCityPRValues($city_id, $ucode, $year);
}
else
{
    $next_year      = $RNTPRValues->getCityNextYear($city_id, $ucode);    
    $last_pr_values = $RNTPRValues->getCityPRValues($city_id, $ucode, ($next_year - 1));
    $city_pr_values = array('A'=>array(), 'B'=>array(), 'C'=>array());
    
    foreach ($city_pr_values as $prop_class => &$pr_values)
    {
        $pr_values["CITY_ID"]      = $city_id;
        $pr_values["UCODE"]        = $ucode;
        $pr_values["PROP_CLASS"]   = $prop_class;
        $pr_values["YEAR"]         = $next_year;
        $pr_values["MIN_PRICE"]    = ! empty($last_pr_values) ? $last_pr_values[$prop_class]["MIN_PRICE"] : null;
        $pr_values["MAX_PRICE"]    = ! empty($last_pr_values) ? $last_pr_values[$prop_class]["MAX_PRICE"] : null;
        $pr_values["MEDIAN_PRICE"] = ! empty($last_pr_values) ? $last_pr_values[$prop_class]["MEDIAN_PRICE"] : null;
        $pr_values["RENT"]         = ! empty($last_pr_values) ? $last_pr_values[$prop_class]["RENT"] : null;
		$pr_values["VACANCY_PERCENT"] = ! empty($last_pr_values) ? $last_pr_values[$prop_class]["VACANCY_PERCENT"] : null;
        $pr_values["REPLACEMENT"]  = ! empty($last_pr_values) ? $last_pr_values[$prop_class]["REPLACEMENT"] : null;
        $pr_values["MAINTENANCE"]  = ! empty($last_pr_values) ? $last_pr_values[$prop_class]["MAINTENANCE"] : null;
        $pr_values["MGT_PERCENT"]  = ! empty($last_pr_values) ? $last_pr_values[$prop_class]["MGT_PERCENT"] : null;
        $pr_values["CAP_RATE"]     = ! empty($last_pr_values) ? $last_pr_values[$prop_class]["CAP_RATE"] : null;
        $pr_values["UTILITIES"]    = ! empty($last_pr_values) ? $last_pr_values[$prop_class]["UTILITIES"] : null;
        $pr_values["CHECKSUM"]     = null;
    }
    unset($pr_values); 
}

// ************************** START FORM DECLARATION ************************ //
$form->AddElement("hidden", "type", "data");
$form->AddElement("hidden", "action", $action);
$form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
$form->AddElement("hidden", "city_id", $city_id);
$form->AddElement("select", "filter_ucode", "Usage", $city_ucodes_lov,
                  array("id"       => "FILTER_UCODE",
                        "style"    => "width:160px;",
                        "onchange" => " this.form.action.value = 'SELECT_UCODE';"
                                     ." this.form.submit();")
                 );
$form->AddElement("select", "filter_year",  "Year",  $city_years_lov,
                  array("id"       => "FILTER_YEAR",
                        "style"    => "width:120px;",
                        "onchange" => " this.form.action.value = 'SELECT_YEAR';"
                                     ." this.form.submit();")
                 );
                 
$attr = array("size"=>"10");
foreach ($city_pr_values as $prop_class => $pr_values)
{
    $form->AddElement("hidden", "PR_VALUES[{$prop_class}][CITY_ID]");
    $form->AddElement("hidden", "PR_VALUES[{$prop_class}][UCODE]");
    $form->AddElement("hidden", "PR_VALUES[{$prop_class}][PROP_CLASS]");
    $form->AddElement("hidden", "PR_VALUES[{$prop_class}][YEAR]");
    $form->addElement("text", "PR_VALUES[{$prop_class}][MIN_PRICE]", "", $attr);
    $form->addElement("text", "PR_VALUES[{$prop_class}][MAX_PRICE]", "", $attr);
    $form->addElement("text", "PR_VALUES[{$prop_class}][MEDIAN_PRICE]", "", $attr);
    $form->addElement("text", "PR_VALUES[{$prop_class}][RENT]", "", $attr);
    $form->addElement("text", "PR_VALUES[{$prop_class}][REPLACEMENT]", "", $attr);
    $form->addElement("text", "PR_VALUES[{$prop_class}][MAINTENANCE]", "", $attr);
    $form->addElement("text", "PR_VALUES[{$prop_class}][MGT_PERCENT]", "", $attr);
    $form->addElement("text", "PR_VALUES[{$prop_class}][CAP_RATE]", "", $attr);
    $form->addElement("text", "PR_VALUES[{$prop_class}][UTILITIES]", "", $attr);
	$form->addElement("text", "PR_VALUES[{$prop_class}][VACANCY_PERCENT]", "", $attr);
    $form->AddElement("hidden", "PR_VALUES[{$prop_class}][CHECKSUM]");
}

$form->AddElement("submit", "action_cancel", "Cancel", array());
$form->AddElement("submit", "action_save",   "Save",   array());
$form->AddElement("submit", "action_new",    "New", 
                  array('onclick'=>"if (this.form.filter_ucode.selectedIndex == 0) "
                                  ."{ "
                                  ."    alert('Please choose usage code from list!'); "
                                  ."    return false; "
                                  ."} "
                                  ."this.form.action.value = 'ADD_YEAR'; "
                                  ."return true; "
                  ));
// ************************** END FORM DECLARATION ************************** //

// ************************** START FORM DISPATCHER ************************* //
$isPost = $form->isSubmitted();

if ( ! $isPost)
{   
    $form_data = array(
        "filter_ucode" => $ucode,
        "filter_year"  => $year,
        "city_id"      => $city_id
    );
    
    foreach ($city_pr_values as $prop_class => $pr_values)
    {
        $form_data["PR_VALUES[{$prop_class}][CITY_ID]"]      = $pr_values["CITY_ID"];
        $form_data["PR_VALUES[{$prop_class}][UCODE]"]        = $pr_values["UCODE"];
        $form_data["PR_VALUES[{$prop_class}][PROP_CLASS]"]   = $pr_values["PROP_CLASS"];
        $form_data["PR_VALUES[{$prop_class}][YEAR]"]         = $pr_values["YEAR"];
        $form_data["PR_VALUES[{$prop_class}][MIN_PRICE]"]    = UtlConvert::dbNumericToDisplay($pr_values["MIN_PRICE"]);
        $form_data["PR_VALUES[{$prop_class}][MAX_PRICE]"]    = UtlConvert::dbNumericToDisplay($pr_values["MAX_PRICE"]);
        $form_data["PR_VALUES[{$prop_class}][MEDIAN_PRICE]"] = UtlConvert::dbNumericToDisplay($pr_values["MEDIAN_PRICE"]);
        $form_data["PR_VALUES[{$prop_class}][RENT]"]         = UtlConvert::dbNumericToDisplay($pr_values["RENT"]);
		$form_data["PR_VALUES[{$prop_class}][VACANCY_PERCENT]"] = UtlConvert::dbNumericToDisplay($pr_values["VACANCY_PERCENT"]);
        $form_data["PR_VALUES[{$prop_class}][REPLACEMENT]"]  = UtlConvert::dbNumericToDisplay($pr_values["REPLACEMENT"]);
        $form_data["PR_VALUES[{$prop_class}][MAINTENANCE]"]  = UtlConvert::dbNumericToDisplay($pr_values["MAINTENANCE"]);
        $form_data["PR_VALUES[{$prop_class}][MGT_PERCENT]"]  = UtlConvert::dbNumericToDisplay($pr_values["MGT_PERCENT"]);
        $form_data["PR_VALUES[{$prop_class}][CAP_RATE]"]     = UtlConvert::dbNumericToDisplay($pr_values["CAP_RATE"]);
        $form_data["PR_VALUES[{$prop_class}][UTILITIES]"]    = UtlConvert::dbNumericToDisplay($pr_values["UTILITIES"]);
        $form_data["PR_VALUES[{$prop_class}][CHECKSUM]"]     = $pr_values["CHECKSUM"];
    }
    
    $form->setDefaults($form_data);
}
elseif ($isPost && $form->validate())
{
    $values = $form->getSubmitValues();
        
    $isError = 0;
    try {
        if ($action == ACTION_UPDATE) {
            $RNTPRValues->updateCityPRValues($values["PR_VALUES"]);
        }
        elseif ($action == ACTION_ADD_YEAR) {
           $RNTPRValues->insertCityPRValues($city_pr_values);
        }
        elseif ($action == ACTION_SELECT_UCODE) {
            // do nothig
        }
        elseif ($action == ACTION_SELECT_YEAR) {
            // do nothig
        }
        elseif ($action == ACTION_CANCEL) {
            //do nothing
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
        if ($action == ACTION_ADD_YEAR)
        {
            header("Location: ".$GLOBALS["PATH_FORM_ROOT"]
                               ."?".$menu->getParam2()
                               .'&city_id='.$values["city_id"]
                               .'&filter_ucode='.$values["filter_ucode"]
                               .'&filter_year='.$next_year
                               .'&type=data'
            );
            exit;
        }
        elseif (in_array($action, array( ACTION_CANCEL, ACTION_UPDATE, ACTION_SELECT_UCODE,ACTION_SELECT_YEAR)))
        {
            header("Location: ".$GLOBALS["PATH_FORM_ROOT"]
                               ."?".$menu->getParam2()
                               .'&city_id='.$values["city_id"]
                               .'&filter_ucode='.$values["filter_ucode"]
                               .'&filter_year='.$values["filter_year"]
                               .'&type=data'
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