<?
 $href = $GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2();

 require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_properties.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once dirname(__FILE__)."/../classes/Context.class.php";

 require_once dirname(__FILE__)."/../php/PropertyLoader.php";
 require_once dirname(__FILE__)."/../php/PropertyDownloader.php";

 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

 if (!defined("HOME_SUMMARY"))
 {
     define("HOME_SUMMARY", "1");
 }

 $dbBU        = new RNTBusinessUnit($smarty->connection);
 $buList      = $dbBU->getAllBusinessUnits();
 $currentBUID = $_REQUEST["BUSINESS_ID"];

 //print_r($buList);

 if ($currentBUID == null) {
    $currentBUID = Context::getBusinessID();
 }
 else {
     Context::setBusinessID($currentBUID);
 }

 if (!$currentBUID) {
     $currentBUID = $buList[0]["BUSINESS_ID"];
 }

 if ($currentBUID) {
     $smarty->user->verifyBUAccess($currentBUID);
 }

 $dbProp = new RNTProperties($smarty->connection);
 $repairEstimates   = $dbProp->getRepairEstimates($currentBUID);
 $cashFlowEstimates = $dbProp->getCashFlowEstimates($currentBUID);
 $propertiesList    = $dbProp->getPropertiesList($currentBUID);
 $activeList        = $dbProp->getActivePropertiesList($currentBUID);

 $smarty->assign("businessList", $buList);
 $smarty->assign("businessID", $currentBUID);
 $smarty->assign("repairEstimates", $repairEstimates);
 $smarty->assign("cashFlowEstimates", $cashFlowEstimates);


// ******************************************************************
// **    FOLLOWING CODE ONLY FOR "PROPERTY-SUMMARY-STATUS" PAGE    **
// ******************************************************************
if ($_REQUEST["type"] != "status")
{
    return;
}

 if (!defined("PROPERTY_STATUS"))
 {
     define("PROPERTY_STATUS", "1");
     define("UPDATE_ACTION", "UPDATE");
     define("CANCEL_ACTION", "CANCEL");
 }

 // Create agreement advertise form
 $form   = new HTML_QuickForm('formProp', 'POST');
 $isPost = $form->isSubmitted();

 // Put restrictions on users that can change status of properties
 $isEdit = ($smarty->user->isManager()
         OR $smarty->user->isAdvertise()
         OR $smarty->user->isManagerOwner()
         OR $smarty->user->isBuyer()
 );
 if (!$isEdit) {
     $form->freeze();
 }


//
// HANDLE "SPREADSHEET-UPLOAD" ACTION
//
if (@$_REQUEST['IS_SPREADSHEET_UPLOAD'])      /* && $isEdit*/
{
    $file_name_tmp = trim($_FILES['spreadsheetFile']['tmp_name']);
    $file_name     = trim($_FILES['spreadsheetFile']['name']);
    $file_error    = $_FILES['spreadsheetFile']['error'];

    // check file upload process errors
    $errorMsg = '';
    if (empty($file_name))
    {
        $errorMsg = 'Spreadsheet file not loaded.';
    }
    elseif ($file_error)
    {
        switch ($file_error) {
            case UPLOAD_ERR_INI_SIZE:
                $errorMsg = 'Maximum allowed file size is '.ini_get('upload_max_filesize').' bytes.';
                break;
            case UPLOAD_ERR_FORM_SIZE:
                $errorMsg = 'Maximum allowed file size is '.$_REQUEST['MAX_FILE_SIZE'].' bytes.';
                break;
            case UPLOAD_ERR_PARTIAL:
                $errorMsg = 'File loaded is partial.';
                break;
            case UPLOAD_ERR_NO_FILE:
                $errorMsg = 'No file was uploaded';
                break;
            case UPLOAD_ERR_NO_TMP_DIR:
                $errorMsg = 'Missing a temporary folder';
                break;
            case UPLOAD_ERR_CANT_WRITE:
                $errorMsg = 'Failed to write file to disk';
                break;
            case UPLOAD_ERR_EXTENSION:
                $errorMsg = 'File upload stopped by extension';
                break;
            default:
                $errorMsg = 'Unknown upload error';
                break;
        }
    }
    else
    {
        preg_match('/(.*)\\.(.+$)/', $file_name, $matches);
        list(, $name, $ext) = $matches;

        if ( ! in_array(strtolower($ext), $CONFIG_ALLOWED_SPREADSHEET_EXTENSIONS))
        {
            $errorMsg = 'Please select a file of type: <b>'
                . implode(', ', $CONFIG_ALLOWED_SPREADSHEET_EXTENSIONS)
                . "</b>.";
        }
    }

    // if there are no errors - do action
    do {
        if (! empty($errorMsg)) {
            break;
        }

        // try to moving file
        if ( ! is_uploaded_file($file_name_tmp)){
            $errorMsg = 'Problem in upload file.';
            break;
        }

        if ( ! move_uploaded_file($file_name_tmp, realpath(UPLOAD_DIR.'/').'/'.$file_name) ) {
            $errorMsg = "Can't upload file.";
            break;
        }

        // load property's data into DB
        try {
            $full_file_name  = realpath(UPLOAD_DIR.'/').'/'.$file_name;

            $aPropertyLoader = new PropertyLoader($full_file_name);
            $aPropertyData   = $aPropertyLoader->getPropertyData();

            $loadedPropDump = '';
            $loadedPropCnt  = 0;
            foreach ($aPropertyData as $prop)
            {
                // add property from spreadsheet to business unit
                // result if success - new property ID, in otherwise - FALSE
                $newPropId       = $dbProp->loadPropertyDataFromSpreadsheet($currentBUID, $prop);
                $loadedPropCnt  += (empty($newPropId) ? 0 : 1);
                $loadedPropDump .= "<pre>$newPropId</pre>";
            }
        }
        catch (Exception $e) {
            $errorMsg = $e->getMessage();
        }

    } while(false);

    if ( ! empty($errorMsg)) {
        $smarty->assign('uploadSpreadsheetFileError', nl2br($errorMsg));
    }
    else {
        $businessUnitInfo = $dbBU->getBusinessUnit($currentBUID);
        $smarty->assign('uploadSpreadsheetFileOk', "Added {$loadedPropCnt} properties to {$businessUnitInfo['BUSINESS_NAME']}");
        $smarty->assign('loadedPropDump', $loadedPropDump);
    }

    $isPost = false;
} // if (@$_REQUEST['IS_SPREADSHEET_UPLOAD'])


if (@$_REQUEST['IS_SPREADSHEET_DOWNLOAD'])
{
    // check spreadsheet download process errors
    $errorMsg = '';

    // load property's data into DB
    try {
        foreach ($activeList as $key => &$property)
        {
            $property["estimates"] = $dbProp->getPropertyEstimatesForSpreadsheet($property["PROPERTY_ID"]);
        }

        $template_spreadsheet = realpath(TEMPLATE_DIR.'/').'/'.'address2irr.xls';

        $aPropertyDownloader  = new PropertyDownloader($template_spreadsheet, $activeList);
        $aPropertyDownloader->getXLS();
        //$aPropertyDownloader->getXLSX();
        //$errorMsg = '<pre>'.print_r($propertiesList, true).'</pre>';
    }
    catch (Exception $e) {
        $errorMsg = $e->getMessage();
    }

    if ( ! empty($errorMsg)) {
        $smarty->assign('downloadSpreadsheetFileError', nl2br($errorMsg));
    }

    $isPost = false;
} // if (@$_REQUEST['IS_SPREADSHEET_DOWNLOAD'])


//
// GENERATE PROPERTY_HOME_SUMMARY_STATUS PAGE
//

 // menu level 2
 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
 // menu level 3
 $form->AddElement("hidden", "type", "status");


 $propertiesList = array();
 if ($isPost) {
     $propertiesList = $_POST["PROPERTIES"];
 }
 else {
     $propertiesList = $dbProp->getPropertiesList($currentBUID);
 }

 $StatusLovData = new LovData("dataStatus", $dbProp->getStatusList());
 //$i = 0;
 for($i = 0; $i < count($propertiesList); $i++)
 {
     $form->AddElement(
         "lov",
         "PROPERTIES[$i][STATUS]",
         $propertiesList[$i]["ADDRESS1"],
         $propertiesList[$i]["STATUS"],
         array("nameCode"  => "PROPERTIES[$i][STATUS__CODE]",
               "imagePath" => $GLOBALS["PATH_FORM_ROOT"]."images/lov.gif",
               "sizeCode"  => 15),
         $StatusLovData
     );

     $form->AddElement("hidden", "PROPERTIES[$i][STATUS_OLD]");
     $form->AddElement("hidden", "PROPERTIES[$i][PROPERTY_ID]");
     $form->AddElement("hidden", "PROPERTIES[$i][CHECKSUM]");
 }

 $form->addElement("submit", "save", "Save");
 $form->addElement("submit", "cancel", "Cancel");

 // Apply filter for all data cells
 $form->applyFilter('__ALL__', 'trim');

 if ($isPost && $form->validate()) {
     $action = ""; //UPDATE_ACTION;
     if ($_POST["cancel"]) {
         $action = CANCEL_ACTION;
     } elseif ($_POST["save"]) {
         $action = UPDATE_ACTION;
     }

     if ($action == UPDATE_ACTION) {
         $submit_values  = $form->getSubmitValues();
         $IsError = 0;

         try {
             $upd = 0;
             foreach($submit_values["PROPERTIES"] as $key=>$property)
             {
                 if ($property["STATUS"] != $property["STATUS_OLD"])
                 {
                     $new = array("status"   => $property["STATUS"],
                                  "checksum" => $property["CHECKSUM"]);
                     //
                     $upd += $dbProp->updatePropertyStatus(
                         $property['PROPERTY_ID'],
                         $new
                     );
                 }
             }
             //
             $smarty->connection->commit();
         } catch(SQLException $e) {
             $IsError = 1;
             $smarty->connection->rollback();
             $de =  new DatabaseError($smarty->connection);
             $smarty->assign("errorObj", $de->getErrorFromException($e));
         }

         // Refresh screen on success update
         if (!$IsError)
         {
             header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?"
                                .$menu->request_menu_level2."="
                                .$menu->current_level2."&type=status");
             exit;
         }
     }
     elseif ($action == CANCEL_ACTION) {
         header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?"
                            .$menu->request_menu_level2."="
                            .$menu->current_level2."&type=status");
         exit;
     }
 }// form was submited?


 if (!$isPost) {
     foreach($propertiesList as $key=>$property)
     {
         foreach($property as $k=>$v)
         $defaults["PROPERTIES[$key][$k]"] = $v;
     }

     $form->setDefaults($defaults);
 }

 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 $form->accept($renderer);

 $smarty->assign('isEdit', ($isEdit) ? "true" : "false");
 $smarty->assign('form_data', $renderer->toArray());
 $smarty->assign("script", $StatusLovData->display());
?>
