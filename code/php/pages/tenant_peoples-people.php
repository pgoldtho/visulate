<?php

 require_once dirname(__FILE__)."/../classes/database/rnt_peoples.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";

require_once dirname(__FILE__)."/../classes/database/rnt_agreement.class.php";
require_once dirname(__FILE__)."/../classes/database/rnt_properties.class.php";
require_once dirname(__FILE__)."/../classes/database/pr_properties.class.php";
require_once dirname(__FILE__)."/../classes/database/pr_reports.class.php";
require_once dirname(__FILE__)."/../classes/database/rnt_leads.class.php";
require_once dirname(__FILE__)."/../classes/database/rnt_lead_actions.class.php";
require_once dirname(__FILE__)."/../ckeditor/ckeditor.php";

 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

 function setForm(&$form, &$data, $form_action, &$date_elements, $currentBUID)
 {
         global $menu;
         global $smarty;
         // set form fields
         // menu 2 level
          $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);

          $form->AddElement("hidden", "PEOPLE_ID");
          $form->AddElement("hidden", "FORM_ACTION", $form_action);
          $form->AddElement("hidden", "BUSINESS_ID", $currentBUID);
          $form->AddElement("hidden", "PEOPLE_BUSINESS_ID");
          $form->AddElement("hidden", "CHECKSUM");
          $form->AddElement("text", "LAST_NAME", "Last Name", array("size"=>20));
          $form->AddElement("text", "FIRST_NAME", "First Name", array("size"=>20));
          $form->AddElement("text", "PHONE1", "Primary Phone", array("size"=>20));
          $form->AddElement("text", "PHONE2", "Secondary Phone", array("size"=>20));
          $form->AddElement("text", "DATE_OF_BIRTH", "Date of Birth", array("size" => 8));
          $date_elements[] = "DATE_OF_BIRTH";
          $form->AddElement("text", "EMAIL_ADDRESS", "E-mail", array("size"=>25));
          $form->AddElement("text", "SSN", "SSN", array("size"=>22));
          $form->AddElement("text", "DRIVERS_LICENSE", "Drivers License", array("size"=>12));
       //   $form->AddElement("advcheckbox", "IS_ENABLED_YN", "Enabled?", "",  array("N", "Y"));
          //$data["IS_ENABLED_YN"] = ($data["IS_ENABLED_YN"] == "Y");
          // require
          $form->addRule("LAST_NAME", "set Last name", 'required');
          $form->addRule("FIRST_NAME", "set First name", 'required');

          // rule for validate
          $form->addRule("EMAIL_ADDRESS", "E-mail is a not valid e-mail addess", "email");
          $form->addRule("DATE_OF_BIRTH", UtlConvert::ErrorDateMsg, 'vdate');
          // Apply filter for all data cells
          $form->applyFilter('__ALL__', 'trim');

          $r = array("onclick" => "return confirm('Delete this record?');");
          if ($form_action == INSERT_ACTION)
             $r = array("disabled");
          $form->AddElement("submit", "delete", "Delete", $r);
          $form->AddElement("submit", "new", "New");
          $form->AddElement("submit", "cancel", "Cancel");

          $form->AddElement("submit", "accept", "Save");
 } // --- function setForm($form, $size)

 function IDinList($array, $id)
 {
    foreach($array as $v)
        if ($v["PEOPLE_ID"] == $id)
           return TRUE;
    return FALSE;
 }

define('IS_AJAX', isset($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest');

 if (!defined("TENAT_PEOPLE"))
 {
     define("TENANT_PEOPLE", "1");
     define("UPDATE_ACTION", "UPDATE");
     define("DELETE_ACTION", "DELETE");
     define("INSERT_ACTION", "INSERT");
     define("CANCEL_ACTION", "CANCEL");

     define("FIND_PROPERTY_ACTION",       "FIND_PROPERTY");
     define("LEAD_DETAILS_SAVE_ACTION",   "LEAD_DETAILS_SAVE");

     define("LEAD_ACTIONS_SAVE_ACTION",   "LEAD_ACTIONS_SAVE");
     define("LEAD_ACTIONS_CANCEL_ACTION", "LEAD_ACTIONS_CANCEL");
     define("LEAD_ACTIONS_DELETE_ACTION", "LEAD_ACTIONS_DELETE");
     define("LEAD_ACTIONS_INSERT_ACTION", "LEAD_ACTIONS_INSERT");
     define("LEAD_ACTIONS_EDIT_ACTION",   "LEAD_ACTIONS_EDIT");
 }
 $actions = array(INSERT_ACTION, UPDATE_ACTION, DELETE_ACTION, CANCEL_ACTION);
 $dbPeople = new RNTPeoples($smarty->connection);

 $dbBU = new RNTBusinessUnit($smarty->connection);
 $buList = $dbBU->getBusinessUnitsLevel2();
 $currentBUID = @$_REQUEST["BUSINESS_ID"];
 $isEdit = ($smarty->user->isManager() || $smarty->user->isManagerOwner());

 if (!$currentBUID)
   $currentBUID = @$buList[0]["BUSINESS_ID"];

 foreach($buList as $k=>$v)
 {
    $buList[$k]["PEOPLES"] = array();
    $peopleList = $dbPeople->getList($v["BUSINESS_ID"]);
//    print_r($peopleList);
    foreach($peopleList as $k1=>$v1)
        $buList[$k]["PEOPLES"][] = array("PEOPLE_ID"=>$v1["PEOPLE_ID"], "PEOPLE_NAME"=>$v1["LAST_NAME"]." ".$v1["FIRST_NAME"], "PHONE1"=>$v1["PHONE1"]);
 }

// print_r($buList);
 $form = new HTML_QuickForm('formPeople', 'POST');

 // -----  Append rules
 $form->registerRule('vdate', 'function', 'validateDate');

 $peopleList = $dbPeople->getList($currentBUID);
 $currentPeopleID = @$_REQUEST["PEOPLE_ID"];


$IsPost = $form->isSubmitted();
$action = @$_REQUEST["action"];
if (@$_POST["FORM_ACTION"])
    $action = $_POST["FORM_ACTION"];
if (@$_REQUEST["delete"])
    $action = DELETE_ACTION;
if (!in_array($action, $actions))
    $action = UPDATE_ACTION;


 // catch other forms' actions
$extraAction    = NULL;
$postedFormName = empty($_POST["FORM_NAME"]) ? "" : $_POST["FORM_NAME"];
if (in_array(@$_REQUEST["action"], array("editLeadAction","deleteLeadAction"))) {
    $postedFormName = "LEAD_ACTIONS_FORM";
}
switch ($postedFormName) {
    case "FIND_PROPERTY_FORM":
        $extraAction = FIND_PROPERTY_ACTION;
    break;

    case "LEAD_DETAILS_FORM":
        $extraAction = LEAD_DETAILS_SAVE_ACTION;
    break;

    case "LEAD_ACTIONS_FORM":
        $extraAction = LEAD_ACTIONS_CANCEL_ACTION;
        if (@$_POST['acceptLeadAction']) {
            $extraAction = LEAD_ACTIONS_SAVE_ACTION;
        }
        elseif (@$_POST['cancelLeadAction']) {
            $extraAction = LEAD_ACTIONS_CANCEL_ACTION;
        }
        elseif (@$_REQUEST["action"] == "editLeadAction") {
            $extraAction = LEAD_ACTIONS_EDIT_ACTION;
        }
        elseif (@$_REQUEST["action"] == "deleteLeadAction") {
            $extraAction = LEAD_ACTIONS_DELETE_ACTION;
        }
    break;

    case "LEAD_ACTIONS_TOOLBAR_FORM":
        $extraAction = LEAD_ACTIONS_CANCEL_ACTION;
        if (@$_POST["s_new_action"]) {
            $extraAction = LEAD_ACTIONS_INSERT_ACTION;
        }
    break;

    default:
    break;
}
$IsPost = $IsPost && empty($extraAction);




 if ($currentPeopleID == NULL || !IDinList($peopleList, $currentPeopleID))
 {
     if (count($peopleList) == 0)
     {
         $action = INSERT_ACTION;
         $currentPeopleID = -1;
     }
     else
     {
        $currentPeopleID = $peopleList[0]["PEOPLE_ID"];
     }
 }

 // get Tenant Agreements List
 $peopleAgreements = $dbPeople->getTenancyAgreements($currentPeopleID, $currentBUID);

 if (! ( $smarty->user->isOwner() || $smarty->user->isManager() || $smarty->user->isManagerOwner() || $smarty->user->isBookkeeping() || $smarty->user->isBusinessOwner()))
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
    exit;
 }

 if (@$_REQUEST["cancel"])
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&PEOPLE_ID=".$currentPeopleID."&BUSINESS_ID=".$currentBUID);
    exit;
 }

 $form_data = array();
 if ($action == INSERT_ACTION)
 {
     $form_data = array("PEOPLE_ID" => $currentPeopleID, "BUSINESS_ID" => $currentBUID);
 }
 else
 {
     if ($IsPost)
       $form_data = $_POST;
     else
     {
       $form_data = $dbPeople->getPeople($currentPeopleID, $currentBUID);
       $form_data["DATE_OF_BIRTH"] = UtlConvert::dbDateToDisplay($form_data["DATE_OF_BIRTH"]);
     }
 }

 $date_elements = array();
 setForm($form, $form_data, $action, $date_elements, $currentBUID);

 if (!$IsPost)
    $form->setDefaults(@$form_data);

 if ($IsPost && ($form->validate() || $action == DELETE_ACTION))
 {
    // save form to database
    $values = $form->getSubmitValues();
    $newID = -1;
    $IsError = 0;
    try
    {
        if ($action == DELETE_ACTION) {
            $dbPeople->Delete($values);
        }
        else if ($action == UPDATE_ACTION) {
            $dbPeople->Update($values);
        }
        else if ($action == INSERT_ACTION) {
            $person = $dbPeople->getPeopleByName($values['LAST_NAME'], $values['FIRST_NAME']);
            if (empty($person)) {
                $newID = $dbPeople->Insert($values);
            }
            else {
                $dbPeople->insertPeopleBU($currentBUID, $person['PEOPLE_ID']);
            }
        }
        else {
            throw new Exception('Unknown operation');
        }

        $smarty->connection->commit();
    }
    catch(SQLException $e)
    {
          $IsError = 1;
          $smarty->connection->rollback();
          $de =  new DatabaseError($smarty->connection);
          $smarty->assign("errorObj", $de->getErrorFromException($e));
    }

     if (IS_AJAX) {
         $response = array("status" => (!$IsError ? "OK" : "ERROR"));
         echo json_encode($response);
         exit;
     }

    // redirect to page
    if (!$IsError)
    {
       $s = "Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&BUSINESS_ID=".$currentBUID;

       if ($action == INSERT_ACTION)
           $currentPeopleID = $newID;

       if ($action == DELETE_ACTION)
          header($s);
       else
       if (@$_REQUEST["new"])
          header($s."&PEOPLE_ID=".$currentPeopleID.'&action='.INSERT_ACTION);
       else
       if (@$action == UPDATE_ACTION)
          header($s."&PEOPLE_ID=".$currentPeopleID);
       if (@$action == INSERT_ACTION)
          header($s."&PEOPLE_ID=".$currentPeopleID);
       exit;
    } // -- if (!$IsError)
 }

 $warning = array("flag" => "", "message" => "");

 if ($action != INSERT_ACTION && $isEdit){
    $cnt = $dbPeople->getBUCount($currentPeopleID);
    if ($cnt > 1)
       $warning = array("flag" => "!", "message" => "Warning: Other business units including this People record.");
    else if ($cnt == 1)
       $warning = array("flag" => "-", "message" => "Only one business unit include the People record.");
 }

 $smarty->assign("warning", $warning);

 $header_title = "People - ";
 if ($action == INSERT_ACTION)
   $header_title .= "New";
 else
   $header_title .= $form_data["LAST_NAME"]." ".$form_data["FIRST_NAME"];
 // create renderer

 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);

 // send form data to Smarty
 $smarty->assign('action', $action);
 $smarty->assign('form_data', $renderer->toArray());
 $smarty->assign('peopleList', $peopleList);
 $smarty->assign("businessList", $buList);
 $smarty->assign("businessID", $currentBUID);

 $smarty->assign("peopleAgreements",$peopleAgreements);

 // set current record of people
 $smarty->assign("peopleID", $currentPeopleID);
 // Element of form who make date
 $smarty->assign("dates", $date_elements);
 $smarty->assign("header_title", $header_title);
 $smarty->assign("isEdit", $isEdit);


// ------------------------------------------------------------------------------------------------

class FindProperty {

    protected static $instance;

    /**
     * @var HTML_QuickForm
     */
    private $form;

    /**
     * @var HTML_QuickForm_Renderer_ArraySmarty
     */
    private $renderer;

    private $smarty;
    private $tpl;
    private $menu;
    private $currentBUID;
    private $currentPeopleID;
    private $peopleBusinessID;
    private $extraAction;


    private function __construct(){}

    private function __clone()    {}

    private function __wakeup()   {}

    /**
     * @return FindProperty
     */
    public static function getInstance() {
        if ( is_null(self::$instance) ) {
            $className = __CLASS__;
            self::$instance = new $className;
        }
        return self::$instance;
    }

    public function setContext(array $context) {
        $this->menu            = $context['menu'];
        $this->currentBUID     = $context['currentBUID'];
        $this->currentPeopleID = $context['currentPeopleID'];
        $this->extraAction     = $context['extraAction'];
        $this->smarty          = $context['smarty'];
        $this->tpl             = $context['tpl'];

        $dbPeople               = new RNTPeoples($this->smarty->connection);
        $peopleInfo             = $dbPeople->getPeople($this->currentPeopleID, $this->currentBUID);
        $this->peopleBusinessID = $peopleInfo["PEOPLE_BUSINESS_ID"];

        return $this;
    }

    /**
     * @return $this
     */
    public function buildForm() {
        $this->form = new HTML_QuickForm('formFindProperty', 'POST');
        $this->form->addElement("hidden", $this->menu->request_menu_level2, $this->menu->current_level2);
        $this->form->addElement("hidden", "FORM_NAME", "FIND_PROPERTY_FORM");
        $this->form->addElement("hidden", "PEOPLE_ID", $this->currentPeopleID);
        $this->form->addElement("hidden", "BUSINESS_ID", $this->currentBUID);
        $this->form->addElement("text", "REF_PROPERTY_ID", "Reference Property", array("id"=>"REF_PROPERTY_ID","size"=>20));
        $this->form->addElement("submit", "findPropertyByRefId", "Find");

        // register rule
        $this->form->registerRule('vinteger', 'function', 'validateInteger');

        // append form rules
        $this->form->addRule('REF_PROPERTY_ID', 'Must be an integer.', 'vinteger', 'client');
        $this->form->applyFilter('__ALL__', 'trim');

        return $this;
    }

    /**
     * @return $this
     * @throws Exception
     */
    public function renderForm() {
        $this->renderer = new HTML_QuickForm_Renderer_ArraySmarty($this->tpl);
        $this->form->accept($this->renderer);
        return $this;
    }

    /**
     * @return array
     * @throws Exception
     */
    public function toArray() {
        if (empty($this->renderer)) {
            throw new Exception('Unknown renderer for "Find Property" form.');
        }
        return $this->renderer->toArray();
    }

    public function processForm()
    {
        $isFormPosted  = ($this->extraAction == FIND_PROPERTY_ACTION) && $this->form->isSubmitted();
        $formData      = $isFormPosted ? $_POST : array();
        $refPropertyID = @$_REQUEST["REF_PROPERTY_ID"];

        if ( ! $isFormPosted)
        {
            $dbLeads       = new RNTLeads($this->smarty->connection);
            $leadData      = $dbLeads->findLeadDetails($this->peopleBusinessID);
            if (  empty($refPropertyID))
            {
                $refPropertyID = $leadData["REF_PROP_ID"];
            }

            $formData["REF_PROPERTY_ID"] = $refPropertyID;
            $this->form->setDefaults($formData);
        }

        if ($isFormPosted) {
            $location = "Location: ".$GLOBALS["PATH_FORM_ROOT"]."?". $this->menu->getParam2()
                      . "&BUSINESS_ID=".$this->currentBUID
                      . "&PEOPLE_ID=".$this->currentPeopleID;

            $formFindPropertyErrors = array();

            if ($this->form->validate()) {
                // redirect after save data
                $location .= "&REF_PROPERTY_ID=".$formData["REF_PROPERTY_ID"];
            }
            else {
                $formFindPropertyErrors[] = $this->form->getElementError("REF_PROPERTY_ID");
            }
            Context::writeValue("formFindPropertyErrors", $formFindPropertyErrors);
            header($location);
            exit;
        }

//        $dbPrProperties = new PRProperties($this->smarty->connection);
//        $propPhotos     = $dbPrProperties->getPropPhotos($refPropertyID);

        $dbReport    = new PRReports($this->smarty->connection);
        $propPhotos  = $dbReport->getPropPhotos($refPropertyID);
        $report_data = $dbReport->getPropertyDetails($refPropertyID);
        if (empty($propPhotos))
        {
            $streetViewUrl = $dbReport->get_streetview_url($report_data["PROPERTY"]["LAT"], $report_data["PROPERTY"]["LON"]);
            $this->smarty->assign("street_view_url", $streetViewUrl);
        }

        $findPropertyFormData = $this->renderForm()->toArray();
        $this->smarty->assign('form_find_property_data', $findPropertyFormData);
        $this->smarty->assign('form_find_property_photos', $propPhotos);
        $this->smarty->assign('formFindPropertyErrors', Context::readValue("formFindPropertyErrors"));
        Context::writeValue("formFindPropertyErrors", array());
    }
}

FindProperty::getInstance()
    ->setContext(array(
        'menu'              => $menu
    ,   'currentBUID'       => $currentBUID
    ,   'currentPeopleID'   => $currentPeopleID
    ,   'extraAction'       => $extraAction
    ,   'smarty'            => $smarty
    ,   'tpl'               => $tpl
    ))
    ->buildForm()
    ->processForm();

// ------------------------------------------------------------------------------------------------

class LeadDetails {

    /**
     * @var LeadDetails
     */
    protected static $instance;

    /**
     * @var HTML_QuickForm
     */
    private $form;

    /**
     * @var HTML_QuickForm_Renderer_ArraySmarty
     */
    private $renderer;

    private $smarty;
    private $tpl;
    private $menu;
    private $currentBUID;
    private $currentPeopleID;
    private $peopleBusinessID;
    private $extraAction;

    private function __construct(){}

    private function __clone()    {}

    private function __wakeup()   {}

    /**
     * @return FindProperty
     */
    public static function getInstance() {
        if ( is_null(self::$instance) ) {
            $className = __CLASS__;
            self::$instance = new $className;
        }
        return self::$instance;
    }

    public function setContext(array $context) {
        $this->menu             = $context['menu'];
        $this->currentBUID      = $context['currentBUID'];
        $this->currentPeopleID  = $context['currentPeopleID'];
        $this->extraAction      = $context['extraAction'];
        $this->smarty           = $context['smarty'];
        $this->tpl              = $context['tpl'];

        $dbPeople               = new RNTPeoples($this->smarty->connection);
        $peopleInfo             = $dbPeople->getPeople($this->currentPeopleID, $this->currentBUID);
        $this->peopleBusinessID = $peopleInfo["PEOPLE_BUSINESS_ID"];

        return $this;
    }

    /**
     * @return $this
     */
    public function buildForm()
    {
        $this->form = new HTML_QuickForm('formLeadDetails', 'POST');
        $this->form->AddElement("hidden", $this->menu->request_menu_level2, $this->menu->current_level2);
        $this->form->AddElement("hidden", "FORM_NAME", "LEAD_DETAILS_FORM");
        $this->form->AddElement("hidden", "LEAD_ID", "");
        $this->form->addElement("hidden", "PEOPLE_ID", $this->currentPeopleID);
        $this->form->addElement("hidden", "BUSINESS_ID", $this->currentBUID);
        $this->form->AddElement("hidden", "PEOPLE_BUSINESS_ID", $this->peopleBusinessID);
        $this->form->AddElement("hidden", "REF_PROP_ID", "");
        $this->form->AddElement("hidden", "CHECKSUM", "");

        $group[] =& HTML_QuickForm::createElement("radio", "LEAD_STATUS", NULL, " Active", "Active");
        $group[] =& HTML_QuickForm::createElement("radio", "LEAD_STATUS", NULL, " Inactive", "Inactive");
        $this->form->addGroup($group, "status", "Status", "&nbsp;&nbsp;&nbsp;", FALSE);

        $dbPrProperties = new PRProperties($this->smarty->connection);
        $this->form->AddElement("select", "UCODE", "Property type", $dbPrProperties->getUseCodesList("INSERT"), array("style" => "width:150px;"));

        // Buy, Sell, Lease or Landlord
        $dbLeads = new RNTLeads($this->smarty->connection);
        $this->form->AddElement("select", "LEAD_TYPE", "Type", $dbLeads->getLeadTypes(), array("style" => "width:150px;"));

        $this->form->AddElement("text", "FOLLOW_UP", "Follow-Up Every", array("size"=>4));
        $this->form->AddElement("text", "CITY", "City", array("style" => "width:150px;"));
        $this->form->AddElement("text", "MIN_PRICE", "Price Range", array("size"=>10));
        $this->form->AddElement("text", "MAX_PRICE", "to", array("size"=>10));
        $this->form->AddElement("text", "LTV_TARGET", "LTV Target", array("size"=>4));
        $this->form->AddElement("advcheckbox", "LTV_QUALIFIED_YN", "Pre-Approved", "", null, array("N", "Y"));
        $this->form->AddElement("textarea", "DESCRIPTION", "", array("cols"=>80, "rows"=>"6"));
        $this->form->AddElement("submit", "saveLead", "Save");

        // register rule
        $this->form->registerRule('vinteger', 'function', 'validateInteger');

        // append rules
//        $this->form->addRule('REF_PROP_ID', 'Enter Reference Property ID and presses Find.', 'required');
        $this->form->addRule("FOLLOW_UP", 'Value of Follow-Up days must be integer.', 'vinteger');
        $this->form->addRule("MIN_PRICE", 'Value of Prise Range must be numeric.', 'numeric');
        $this->form->addRule("MAX_PRICE", 'Value of Prise Range must be numeric.', 'numeric');

        // append filters
        $this->form->applyFilter('__ALL__', 'trim');

        return $this;
    }

    /**
     * @return $this
     * @throws Exception
     */
    public function renderForm() {
        $this->renderer = new HTML_QuickForm_Renderer_ArraySmarty($this->tpl);
        $this->form->accept($this->renderer);
        return $this;
    }

    /**
     * @return array
     * @throws Exception
     */
    public function toArray() {
        if (empty($this->renderer)) {
            throw new Exception('Unknown renderer for "Lead Details" form.');
        }
        return $this->renderer->toArray();
    }

    public function processForm()
    {
        $isFormPosted  = ($this->extraAction == LEAD_DETAILS_SAVE_ACTION) && $this->form->isSubmitted();
        $refPropertyID = empty($_REQUEST["REF_PROPERTY_ID"]) ? null : $_REQUEST["REF_PROPERTY_ID"];
        $formData      = $isFormPosted ? $this->form->getSubmitValues() : array();

        $dbLeads = new RNTLeads($this->smarty->connection);

        if ( ! $isFormPosted)
        {
            // find out lead's info
            $formData = $dbLeads->findLeadDetails($this->peopleBusinessID);

            //if (empty($formData))
            if (!empty($refPropertyID) && $refPropertyID != $formData['REF_PROP_ID'])
            {
                $dbReport       = new PRReports($this->smarty->connection);
                $report_data    = $dbReport->getPropertyDetails($refPropertyID);

                $property_usage = $report_data["PROPERTY_USAGE"];
                $property_usage = each($property_usage);
                $prop_ucode     = $property_usage['key'];
                $property       = $report_data["PROPERTY"];
                $prop_city      = $property['CITY'];
                $prop_class     = $property['PROP_CLASS'];
                $prop_defaults  = $dbReport->getDefaults($refPropertyID, $prop_ucode);
                $prop_defaults  = $prop_defaults["{$prop_class}"];

                $formData["REF_PROP_ID"]        = $refPropertyID;
                $formData["UCODE"]              = $prop_ucode;
                $formData["CITY"]               = $prop_city;
                $formData["MIN_PRICE"]          = $prop_defaults['LOW_MARKET_VALUE'];
                $formData["MAX_PRICE"]          = $prop_defaults['HIGH_MARKET_VALUE'];
            }

            $this->form->setDefaults($formData);
        }

        if ($isFormPosted)
        {
            $location = "Location: ".$GLOBALS["PATH_FORM_ROOT"]."?". $this->menu->getParam2()
                      . "&BUSINESS_ID=".$this->currentBUID
                      . "&PEOPLE_ID=".$this->currentPeopleID
                      . (empty($formData["REF_PROP_ID"]) ? "" : "&REF_PROPERTY_ID=".$formData["REF_PROP_ID"]);

            $leadDetailsErrors = array();

            if ($this->form->validate())
            {
                // save lead details
                try {
                    $leadId  = empty($formData['LEAD_ID']) ? NULL : $formData['LEAD_ID'];
                    $dbLeads->saveLeadDetails($leadId, $formData);
                    $this->smarty->connection->commit();
                }
                catch(SQLException $e) {
                    $this->smarty->connection->rollback();
                    $de = new DatabaseError($this->smarty->connection);
                    $this->smarty->assign("leadDetailsErrorObj", $de->getErrorFromException($e));
                    $leadDetailsErrors[] = $e->getMessage();
                }
            }
            else
            {
                foreach(array("REF_PROP_ID", "FOLLOW_UP", "MIN_PRICE", "MAX_PRICE") as $element) {
                    $error = $this->form->getElementError($element);
                    if (empty($error)) {
                        continue;
                    }
                    $leadDetailsErrors[] = $error;
                }
            }

            Context::writeValue("leadDetailsErrors", $leadDetailsErrors);
            header($location);
            exit;
        }

        $leadDetailsFormData = $this->renderForm()->toArray();
        $this->smarty->assign('form_lead_details', $leadDetailsFormData);
        $this->smarty->assign('leadDetailsErrors', Context::readValue("leadDetailsErrors"));
        Context::writeValue("leadDetailsErrors", array());
    }
}

LeadDetails::getInstance()
    ->setContext(array(
            'menu'              => $menu
        ,   'currentBUID'       => $currentBUID
        ,   'currentPeopleID'   => $currentPeopleID
        ,   'extraAction'       => $extraAction
        ,   'smarty'            => $smarty
        ,   'tpl'               => $tpl
    ))
    ->buildForm()
    ->processForm();

// ------------------------------------------------------------------------------------------------

class LeadActionsToolbar {

    /**
     * @var LeadActions
     */
    protected static $instance;

    /**
     * @var HTML_QuickForm
     */
    private $form;

    /**
     * @var HTML_QuickForm_Renderer_ArraySmarty
     */
    private $renderer;

    private $smarty;
    private $tpl;
    private $menu;
    private $currentBUID;
    private $currentPeopleID;
    private $peopleBusinessID;
    private $extraAction;


    private function __construct(){}

    private function __clone()    {}

    private function __wakeup()   {}

    public static function getInstance() {
        if ( is_null(self::$instance) ) {
            $className = __CLASS__;
            self::$instance = new $className;
        }
        return self::$instance;
    }

    public function setContext(array $context) {
        $this->menu            = $context['menu'];
        $this->currentBUID     = $context['currentBUID'];
        $this->currentPeopleID = $context['currentPeopleID'];
        $this->extraAction     = $context['extraAction'];
        $this->smarty          = $context['smarty'];
        $this->tpl             = $context['tpl'];

        $dbPeople               = new RNTPeoples($this->smarty->connection);
        $peopleInfo             = $dbPeople->getPeople($this->currentPeopleID, $this->currentBUID);
        $this->peopleBusinessID = $peopleInfo["PEOPLE_BUSINESS_ID"];

        return $this;
    }

    public function buildForm()
    {
        $this->form = new HTML_QuickForm('formLeadActionsToolbar', 'POST');
        $this->form->addElement("hidden", $this->menu->request_menu_level2, $this->menu->current_level2);
        $this->form->addElement("hidden", "FORM_NAME", "LEAD_ACTIONS_TOOLBAR_FORM");
        $this->form->addElement("hidden", "LEAD_ID", "");
        $this->form->addElement("hidden", "PEOPLE_ID", $this->currentPeopleID);
        $this->form->addElement("hidden", "BUSINESS_ID", $this->currentBUID);
        $this->form->AddElement("hidden", "PEOPLE_BUSINESS_ID", $this->peopleBusinessID);

        $dbTemplate = new RNTAgreement($this->smarty->connection);
        $buTemplateList = $dbTemplate->getBUTemplateList($this->currentBUID);
        $buTemplateList[0] = 'Default Template';
        $this->form->addElement("select", "TEMPLATE", "", $buTemplateList);
        $this->form->addElement("submit", "s_new_action", "New action");

        $this->form->addRule("LEAD_ID", "Lead Details must be defined.", 'required');

        return $this;
    }

    public function renderForm() {
        $this->renderer = new HTML_QuickForm_Renderer_ArraySmarty($this->tpl);
        $this->form->accept($this->renderer);
        return $this;
    }

    public function toArray() {
        if (empty($this->renderer)) {
            throw new Exception('Unknown renderer for "Lead Actions" form.');
        }
        return $this->renderer->toArray();
    }

    public function processForm()
    {
        $isFormPosted  = ($this->extraAction == LEAD_ACTIONS_INSERT_ACTION) && $this->form->isSubmitted();
        $formData      = $isFormPosted ? $this->form->getSubmitValues() : array();

        if ( ! $isFormPosted)
        {
            $templateID    = @$_REQUEST["TEMPLATE"];
            $currentLeadID = @$_REQUEST["LEAD_ID"];

//            $dbPeople    = new RNTPeoples($this->smarty->connection);
//            $peopleInfo  = $dbPeople->getPeople($this->currentPeopleID, $this->currentBUID);

            if (empty($currentLeadID)) {
                $dbLeads       = new RNTLeads($this->smarty->connection);
                $leadDetails   = $dbLeads->findLeadDetails($this->peopleBusinessID);
                $currentLeadID = $leadDetails["LEAD_ID"];
            }

            if (empty($formData)) {
                $formData["PEOPLE_BUSINESS_ID"] = $this->peopleBusinessID;
                $formData["LEAD_ID"]            = $currentLeadID;
                $formData["TEMPLATE"]           = $templateID;
            }
            $this->form->setDefaults($formData);
        }

        if ($isFormPosted)
        {
            $location = "Location: ".$GLOBALS["PATH_FORM_ROOT"]."?". $this->menu->getParam2()
                . "&BUSINESS_ID=".$this->currentBUID
                . "&PEOPLE_ID=".$this->currentPeopleID
                . (empty($formData["LEAD_ID"]) ? "" : "&LEAD_ID=".$formData["LEAD_ID"])
                . (empty($formData["TEMPLATE"]) ? "" : "&TEMPLATE=".$formData["TEMPLATE"]);

            $leadActionsToolbarFormErrors = array();

            if ($this->form->validate()) {
                $location .= "&action=editLeadAction";
            }
            else {
                foreach(array("LEAD_ID") as $element) {
                    $error = $this->form->getElementError($element);
                    if (empty($error)) {
                        continue;
                    }
                    $leadActionsToolbarFormErrors[] = $error;
                }
            }

            Context::writeValue("leadActionsToolbarFormErrors", $leadActionsToolbarFormErrors);
            header($location);
            exit;
        }

        $leadActionsToolbarFormData = $this->renderForm()->toArray();
        $this->smarty->assign('form_lead_actions_toolbar', $leadActionsToolbarFormData);
        $this->smarty->assign("leadActionsToolbarFormErrors", Context::readValue("leadActionsToolbarFormErrors"));
        Context::writeValue("leadActionsToolbarFormErrors", array());
    }
}

LeadActionsToolbar::getInstance()
    ->setContext(array(
        'menu'              => $menu
    ,   'currentBUID'       => $currentBUID
    ,   'currentPeopleID'   => $currentPeopleID
    ,   'extraAction'       => $extraAction
    ,   'smarty'            => $smarty
    ,   'tpl'               => $tpl
    ))
    ->buildForm()
    ->processForm();

// ------------------------------------------------------------------------------------------------

class LeadActions {

    /**
     * @var LeadActions
     */
    protected static $instance;

    /**
     * @var HTML_QuickForm
     */
    private $form;

    /**
     * @var HTML_QuickForm_Renderer_ArraySmarty
     */
    private $renderer;

    private $smarty;
    private $tpl;
    private $menu;
    private $currentBUID;
    private $currentPeopleID;
    private $peopleBusinessID;
    private $extraAction;


    private function __construct(){}

    private function __clone()    {}

    private function __wakeup()   {}

    public static function getInstance() {
        if ( is_null(self::$instance) ) {
            $className = __CLASS__;
            self::$instance = new $className;
        }
        return self::$instance;
    }

    public function setContext(array $context) {
        $this->menu             = $context['menu'];
        $this->currentBUID      = $context['currentBUID'];
        $this->currentPeopleID  = $context['currentPeopleID'];
        $this->extraAction      = $context['extraAction'];
        $this->smarty           = $context['smarty'];
        $this->tpl              = $context['tpl'];

        $dbPeople               = new RNTPeoples($this->smarty->connection);
        $peopleInfo             = $dbPeople->getPeople($this->currentPeopleID, $this->currentBUID);
        $this->peopleBusinessID = $peopleInfo["PEOPLE_BUSINESS_ID"];

        return $this;
    }

    public function buildForm()
    {
        $this->form = new HTML_QuickForm('formLeadActions', 'POST');
        $this->form->registerRule('vdate',    'function', 'validateDate');
        $this->form->registerRule('vnumeric', 'function', 'validateNumeric');
        $this->form->registerRule('vinteger', 'function', 'validateInteger');

        $this->form->addElement("hidden", $this->menu->request_menu_level2, $this->menu->current_level2);
        $this->form->addElement("hidden", "FORM_NAME", "LEAD_ACTIONS_FORM");
        $this->form->addElement("hidden", "PEOPLE_ID", $this->currentPeopleID);
        $this->form->addElement("hidden", "BUSINESS_ID", $this->currentBUID);
//        $this->form->AddElement("hidden", "PEOPLE_BUSINESS_ID", "");
        $this->form->addElement("hidden", "LEAD_ID", "");

        // ------ start of CKEditor
        $oCKeditor  = new CKeditor();
        $oCKeditor->basePath = $GLOBALS["PATH_FORM_ROOT"]."ckeditor/";
        $cke_config = array(
            'toolbar' => array(
                array( 'Source', '-','Print', 'Preview' ),
                array( 'Cut','Copy','Paste','PasteText','PasteFromWord','-', 'SpellChecker', 'Scayt' ),
                array( 'Undo','Redo','-','Find','Replace' ),
                //array( 'Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField' ),
                array( 'Bold','Italic', 'Underline','Strike','-','Subscript','Superscript', 'TextColor' ),
                array( 'NumberedList','BulletedList','-','Outdent','Indent' ),
                array( 'JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock' )	,
                array( 'Link','Unlink','Anchor' ),
                array( 'Image','Flash','Table', 'SpecialChar' ),
                array( 'Format','Font','FontSize' )
            ),
            'height' => 512
        );
        $this->smarty->assign("ckEditor", $oCKeditor);
        $this->smarty->assign("cke_config", $cke_config);
        // ------ end of CKEditor

        $this->form->addElement("hidden", "ACTION_ID", "");
        $this->form->addElement("hidden", "CHECKSUM");

//        $dates_elements[] = "ACTION_DATE";
        $this->form->addElement("text", "ACTION_DATE", "", array("size"=>8));
        $this->form->addRule('ACTION_DATE', 'Field required.', 'required');
        $this->form->addRule("ACTION_DATE", UtlConvert::ErrorDateMsg, 'vdate');
        $this->smarty->append("dates", "ACTION_DATE");

        $dbLeadActions = new RNTLeadActions($this->smarty->connection);
        $this->form->addElement("select", "ACTION_TYPE", "", $dbLeadActions->getLeadActionTypes());
        $this->form->addElement("select", "BROKER_ID", "", $dbLeadActions->getBrokerList($this->currentPeopleID,$this->currentBUID), array('style'=>'width:100px;'));
        $this->form->addElement("submit", "acceptLeadAction", "Save");
        $this->form->addElement("submit", "cancelLeadAction", "Cancel");

        // Add field's rules
        $this->form->addRule("LEAD_ID", "Lead Details must be defined.", 'required');

        // Apply filter for all data cells
        $this->form->applyFilter('__ALL__', 'trim');

        return $this;
    }

    public function renderForm() {
        $this->renderer = new HTML_QuickForm_Renderer_ArraySmarty($this->tpl);
        $this->form->accept($this->renderer);
        return $this;
    }

    public function toArray() {
        if (empty($this->renderer)) {
            throw new Exception('Unknown renderer for "Lead Actions" form.');
        }
        return $this->renderer->toArray();
    }

    public function processForm()
    {
        $formActions  = array(LEAD_ACTIONS_SAVE_ACTION, LEAD_ACTIONS_CANCEL_ACTION, LEAD_ACTIONS_DELETE_ACTION);
        $isFormPosted = in_array($this->extraAction, $formActions) && $this->form->isSubmitted();
        $formData     = $isFormPosted ? $this->form->getSubmitValues() : array();

        $dbLeadActions  = new RNTLeadActions($this->smarty->connection);

        if ($this->extraAction == LEAD_ACTIONS_CANCEL_ACTION) {
            $location = "Location: ".$GLOBALS["PATH_FORM_ROOT"]."?". $this->menu->getParam2()
                . "&BUSINESS_ID=".$this->currentBUID
                . "&PEOPLE_ID=".$this->currentPeopleID
                . (empty($formData["LEAD_ID"]) ? "" : "&LEAD_ID=".$formData["LEAD_ID"]);
            header($location);
            exit;
        }

        if ($this->extraAction == LEAD_ACTIONS_DELETE_ACTION)
        {
            $location = "Location: ".$GLOBALS["PATH_FORM_ROOT"]."?". $this->menu->getParam2()
                . "&BUSINESS_ID=".$this->currentBUID
                . "&PEOPLE_ID=".$this->currentPeopleID
                . (empty($_REQUEST["LEAD_ID"]) ? "" : "&LEAD_ID=".$_REQUEST["LEAD_ID"]);

            try {
                $leadActionID = empty($_REQUEST['LEAD_ACTION_ID']) ? NULL : $_REQUEST['LEAD_ACTION_ID'];
                $leadActionID = ($leadActionID  == -1) ? NULL : $leadActionID;
                $dbLeadActions->removeLeadAction($leadActionID);
                $this->smarty->connection->commit();
            }
            catch(SQLException $e) {
                $this->smarty->connection->rollback();
                $de = new DatabaseError($this->smarty->connection);
                $this->smarty->assign("leadDetailsErrorObj", $de->getErrorFromException($e));
                $leadDetailsErrors[] = $e->getMessage();
            }
            header($location);
            exit;
        }

        if ( ! $isFormPosted)
        {
            $currentLeadID       = @$_REQUEST["LEAD_ID"];
            $currentLeadActionID = @$_REQUEST["LEAD_ACTION_ID"];
            $templateID          = @$_REQUEST["TEMPLATE"];

            date_default_timezone_set('America/New_York');
            $today = date("m/d/Y");

            $dbLeads       = new RNTLeads($this->smarty->connection);
            $leadDetails   = $dbLeads->findLeadDetails($this->peopleBusinessID);
            $refPropertyID = $leadDetails["REF_PROP_ID"];
            if (empty($currentLeadID)) {
                $currentLeadID = $leadDetails["LEAD_ID"];
            }

            $leadActionList = $dbLeadActions->getLeadActionList($currentLeadID);
            foreach($leadActionList as &$action)
            {
                $action["ACTION_DATE"] = UtlConvert::dbDateToDisplay($action["ACTION_DATE"]);
                $action["DELETE_LINK"] = '<a href="?'.$this->menu->getParam2()
                    . "&BUSINESS_ID=".$this->currentBUID
                    . "&PEOPLE_ID=".$this->currentPeopleID
                    . "&LEAD_ID=".$currentLeadID
                    . '&LEAD_ACTION_ID='.$action["ACTION_ID"]
                    . '&action=deleteLeadAction" onclick="'.$this->smarty->deleteAttr["onclick"].'">'
                    . $this->smarty->deleteImage."</a>";
                $action["EDIT_LINK"] = '<a href="?'.$this->menu->getParam2()
                    . "&BUSINESS_ID=".$this->currentBUID
                    . "&PEOPLE_ID=".$this->currentPeopleID
                    . "&LEAD_ID=".$currentLeadID
                    . '&LEAD_ACTION_ID='.$action["ACTION_ID"]
                    . '&action=editLeadAction">edit</a>';
            }

            $leadActionText = "";
            if ( ! empty($templateID))
            {
                $dbTemplate     = new RNTAgreement($this->smarty->connection);
                $leadActionText = $dbTemplate->getTemplateText($templateID);
                $leadActionText = str_replace("{{SYSDATE}}",   $today, $leadActionText);
                $leadActionText = str_replace("{{TENANT}}",    "",     $leadActionText);
                $leadActionText = str_replace("{{START}}",     "",     $leadActionText);
                $leadActionText = str_replace("{{END}}",       "",     $leadActionText);
                $leadActionText = str_replace("{{RENT}}",      "",     $leadActionText);
                $leadActionText = str_replace("{{SECURITY}}",  "",     $leadActionText);
                $leadActionText = str_replace("{{LAST}}",      "",     $leadActionText);
                $leadActionText = str_replace("{{TERM}}",      "",     $leadActionText);
                $leadActionText = str_replace("{{PERIOD}}",    "",     $leadActionText);
                $leadActionText = str_replace("{{LATE_FEE}}",  "",     $leadActionText);
                $leadActionText = str_replace("{{LF_PERIOD}}", "",     $leadActionText);
                $leadActionText = str_replace("{{UNPAID}}",    "$",    $leadActionText);

                $dbProp         = new RNTProperties($this->smarty->connection);
                $property_data  = $dbProp->getProperty($refPropertyID);
                $leadActionText = str_replace("{{ADDRESS}}", $property_data["PROP_ADDRESS1"], $leadActionText);
                $leadActionText = str_replace("{{CITY}}",    $property_data["PROP_CITY"],     $leadActionText);
                $leadActionText = str_replace("{{STATE}}",   $property_data["PROP_STATE"],    $leadActionText);
                $leadActionText = str_replace("{{ZIP}}",     $property_data["PROP_ZIPCODE"],  $leadActionText);
            }

            if ( ! empty($currentLeadActionID)) {
                $formData = @$leadActionList[$currentLeadActionID];
                $formData = empty($formData) ? $dbLeadActions->getLeadAction($currentLeadActionID) : $formData;
                $leadActionText = @$formData['DESCRIPTION'];
            }

            if (empty($formData)) {
                $formData["LEAD_ID"]     = $currentLeadID;
                $formData["ACTION_ID"]   = -1;
                $formData["ACTION_DATE"] = $today;
                if ($this->extraAction == LEAD_ACTIONS_EDIT_ACTION) {
                    array_unshift($leadActionList, $formData);
                }
            }

            $this->form->setDefaults($formData);
        }

        if ($isFormPosted)
        {
            $location = "Location: ".$GLOBALS["PATH_FORM_ROOT"]."?". $this->menu->getParam2()
                . "&BUSINESS_ID=".$this->currentBUID
                . "&PEOPLE_ID=".$this->currentPeopleID
                . (empty($formData["LEAD_ID"]) ? "" : "&LEAD_ID=".$formData["LEAD_ID"]);

            $leadActionsErrors = array();

            if ($this->form->validate()) {
                // save lead action
                try {
                    $leadActionID            = empty($formData['ACTION_ID']) ? NULL : $formData['ACTION_ID'];
                    $leadActionID            = ($leadActionID  == -1) ? NULL : $leadActionID;
                    $formData['DESCRIPTION'] = $formData['ACTION_DESCRIPTION'];

                    $dbLeadActions->saveLeadAction($leadActionID, $formData);
                    $this->smarty->connection->commit();
                }
                catch(SQLException $e) {
                    $this->smarty->connection->rollback();
                    $de = new DatabaseError($this->smarty->connection);
                    $this->smarty->assign("leadDetailsErrorObj", $de->getErrorFromException($e));
                    $leadDetailsErrors[] = $e->getMessage();
                }
            }
            else {
                foreach(array("LEAD_ID", "ACTION_DATE") as $element) {
                    $error = $this->form->getElementError($element);
                    if (empty($error)) {
                        continue;
                    }
                    $leadActionsErrors[] = $error;
                }
            }

            Context::writeValue("leadActionsToolbarFormErrors", $leadActionsErrors);
            header($location);
            exit;
        }

        $leadActionsFormData = $this->renderForm()->toArray();
        $this->smarty->assign('form_lead_actions', $leadActionsFormData);
        $this->smarty->assign("leadActionsErrors", Context::readValue("leadActionsErrors"));
        $this->smarty->assign("leadActionText", $leadActionText);
        $this->smarty->assign('leadActionList', $leadActionList);
        $this->smarty->assign('currentLeadActionID', (empty($currentLeadActionID) ? -1 : $currentLeadActionID));
        Context::writeValue("leadActionsErrors", array());
    }
}

LeadActions::getInstance()
    ->setContext(array(
        'menu'              => $menu
    ,   'currentBUID'       => $currentBUID
    ,   'currentPeopleID'   => $currentPeopleID
    ,   'extraAction'       => $extraAction
    ,   'smarty'            => $smarty
    ,   'tpl'               => $tpl
    ))
    ->buildForm()
    ->processForm();


class PageContext {

    protected static $instance;

    private $context = array();

    private function __construct(){}

    private function __clone()    {}

    private function __wakeup()   {}

    public static function getInstance() {
        if ( is_null(self::$instance) ) {
            $className = __CLASS__;
            self::$instance = new $className;
        }
        return self::$instance;
    }

    public function set($param, $value) {
        $this->context["{$param}"] = $value;
    }

    public function get($param) {
        return $this->context["{$param}"];
    }
}

?>
