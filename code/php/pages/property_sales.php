<?php
  $href = $GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2();
    require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
    require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
    require_once dirname(__FILE__)."/../classes/database/pr_reports.class.php"; 
    require_once dirname(__FILE__)."/../classes/database/pr_properties.class.php"; 
        require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";
        require_once dirname(__FILE__)."/../classes/database/rnt_properties.class.php";
    require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
    require_once "HTML/QuickForm.php";

 if (! ( $smarty->user->isOwner()
      || $smarty->user->isManager()
      || $smarty->user->isManagerOwner()
      || $smarty->user->isBookkeeping()
      || $smarty->user->isBuyer()
      || $smarty->user->isBusinessOwner()))
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
    exit;
 }

//Initiate objects from database clasees
 $dbBU        = new RNTBusinessUnit($smarty->connection);
 $dbReport    = new PRReports($smarty->connection);
 $dbProp      = new PRProperties($smarty->connection);
 $dbRntProp   = new RNTProperties($smarty->connection);


// Get or Set Current Business Unit
 $buList      = $dbBU->getAllBusinessUnits();
 $currentBUID = $_REQUEST["BUSINESS_ID"];

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
 
 //populate array for buiness units menu
 $smarty->assign("businessList", $buList);
 $smarty->assign("businessID", $currentBUID);
 
 // Define constants for form actions
 if (!defined("LISTING_DETAILS"))
 {
    define("LISTING_DETAILS",       "1");
    define("UPDATE_ACTION",          "UPDATE");
    define("INSERT_ACTION",          "INSERT");
    define("QUERY_ACTION",           "QUERY");
    define("CANCEL_ACTION",          "CANCEL");
    define("FIND_ACTION",            "FIND");
 }
 
 $report_data = array();
   
 // Find the form action
 if (@$_POST["btnCancel"]
    || @$_REQUEST["btnNew"]
      || @$_REQUEST["FORM_ACTION"] == CANCEL_ACTION)
  {
     $action = CANCEL_ACTION;
  }
 elseif (@$_REQUEST["FORM_ACTION"] == UPDATE_ACTION)
  {
     $action = UPDATE_ACTION;
  }
 elseif (  @$_REQUEST["FORM_ACTION"] == INSERT_ACTION)
  {
     $action = INSERT_ACTION;
  }
 elseif (@$_REQUEST["FORM_ACTION"] == QUERY_ACTION)
  {
     $action = FIND_ACTION;
  }
 else
  { 
     $action = QUERY_ACTION;
  }

 if ($action == CANCEL_ACTION)
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"].
           "?".$menu->request_menu_level2."=".$menu->current_level2.
           "&BUSINESS_ID=".$currentBUID);
    exit;
 } 
 
  $form = new HTML_QuickForm('formPL', 'POST');

  // menu level 2
  $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
  $form->AddElement("hidden", "FORM_ACTION", $action);
 
  $IsPost = $form->isSubmitted();               
  $form->registerRule('vdate', 'function', 'validateDate');
  $form->registerRule('vnumeric', 'function', 'validateNumeric');
  $form->registerRule('vinteger', 'function', 'validateInteger');

  // get property list for left menu
  $prop = $dbProp->getBUProperties($currentBUID);     
  $smarty->assign('data', $prop);

  // $disabled controls the enabled/disabled state of the Property record
  // $disabled2 controls the enabled/disabled state of the Listing record
  if ($action == QUERY_ACTION)
               {
               $disabled = "disabled";
               $disabled2 = "disabled";
               $form->addElement("submit", "btnFind", "Find");
         $form->AddElement("submit", "btnCancel", "Cancel", array());
         $smarty->assign("user_hint", "Enter a Street Address and City then press the 'Find' button");
                  }
    elseif ($action == INSERT_ACTION )
              {
               $disabled = "";
               $disabled2 = "";
         $form->addElement("submit", "btnSubmit", "Save" );
         $form->AddElement("submit", "btnCancel", "Cancel", array());
         $smarty->assign("user_hint", "Enter listing details then press the 'Save' button.");
              }
    elseif ($action == UPDATE_ACTION)
              {
               $report_data = $dbReport->getPropertyDetails($_REQUEST["PROP_ID"]);
               $source = $dbProp->getSource($_REQUEST["PROP_ID"]);
    
                 if ($source == "Visulate")   $disabled = "";
               else  $disabled = "disabled";
     
         $disabled2 = "";
         $form->addElement("submit", "btnNew", "New" );    
         $form->addElement("submit", "btnSubmit", "Save" );
          
                 $listing = $dbProp->getListing($_REQUEST["PROP_ID"], $currentBUID);
 
                 if (!$listing["PL_PROP_ID"])
                           {
                            $listing["PL_PROP_ID"] = $_REQUEST["PROP_ID"];
                            $listing["PL_BUSINESS_ID"] = $currentBUID;
                           }

         $dates_elements = array();
         $form->registerRule('vdate', 'function', 'validateDate');
         $form->registerRule('vnumeric', 'function', 'validateNumeric');
         $form->registerRule('vinteger', 'function', 'validateInteger');
             
         $form->AddElement("vinteger", "PL_PROP_ID", $listing["PL_PROP_ID"]);
         $form->AddElement("hidden", "PL_BUSINESS_ID", $listing["PL_BUSINESS_ID"]);
         $form->AddElement("hidden", "PL_CHECKSUM", $listing["PL_CHECKSUM"]);
    
         $form->addElement("submit", "btnSubmit", "Save");
         $form->AddElement("submit", "btnCancel", "Cancel", array());

         $form->addRule("PL_LISTING_DATE", 'Enter a listing date.', 'required');
         $form->addRule("PL_PRICE", 'Enter a listing price.', 'required');
         $form->addRule("PL_PRICE", "Listing price must be numeric", 'vnumeric');
         $form->addRule("PL_LISTING_DATE", UtlConvert::ErrorDateMsg, 'vdate');
             
         $listing["PL_LISTING_DATE"] = UtlConvert::dbDateToDisplay($listing["PL_LISTING_DATE"]);
         $listing["PL_PRICE"] = UtlConvert::dbNumericToDisplay($listing["PL_PRICE"]);

         $smarty->assign("dates", $dates_elements);
        }

    // Process the form
    if ($IsPost && $form->validate() )
    { 
     $values = $form->getSubmitValues();
     $IsError = 0;
     try
     {
         if ($action == FIND_ACTION )
         { 
         // Find a list of properties that match the search criteria.
         // Assign to the 'data' array for display by smarty in the left menu. or assign 'data0' array if no properties are found.         
           if ( $values["PR_ADDRESS1"] || $values["PR_CITY"])
           {
           $prop = $dbReport->getProperty( $values["PR_ADDRESS1"], $values["PR_CITY"]);     
           $smarty->assign('data', $prop);
           $smarty->assign("user_hint", "Select a property from the list on the left of the screen or click on the 'Enter a New Property' link");
           
           if (count($prop) == 0)
             $smarty->assign("user_hint", "No records found for the search criteria.  Refine your search or click on the 'Enter a New Property' link");
             $smarty->assign('data0', 'No Properties');
          }

         }
         elseif ($action == UPDATE_ACTION )
         { 
         // Update the listing values and commit the record then requery the form.
           if ($_POST["btnSubmit"])
           {
            $values = $form->getSubmitValues();
            if ($values["PR_STATE"])
            {
             $dbProp->updateProperty($values);            
            }
            $values["PL_DESCRIPTION"] = strip_tags($values["PL_DESCRIPTION"]);
            $dbProp->SetListing($values);
            $smarty->connection->commit();
  
                   $report_data = $dbReport->getPropertyDetails($values["PL_PROP_ID"]);
            $listing = $dbProp->getListing($values["PL_PROP_ID"], $currentBUID);
           }
         }
         elseif ($action == INSERT_ACTION )
         { 
         // Insert new property and listing record
            $values = $form->getSubmitValues();
            $values["PL_DESCRIPTION"] = strip_tags($values["PL_DESCRIPTION"]);
            $values["PL_BUSINESS_ID"] = $currentBUID;
            $dbProp->InsertProperty($values);
            $smarty->connection->commit();

                   $report_data = $dbReport->getPropertyDetails($values["PL_PROP_ID"]);
            $listing = $dbProp->getListing($values["PL_PROP_ID"], $currentBUID);
           
         }
         else
         {
             throw new Exception("Unknown operation $action");
         }
         
         
     }
     catch(SQLException $e)
     {
         $IsError = 1;
         $smarty->connection->rollback();
         $de =  new DatabaseError($smarty->connection);
         $smarty->assign("errorObj", $de->getErrorFromException($e));
     }
     
     // redirect to page
     if (!$IsError)
     {
      if (@$_REQUEST["btnCancel"])
      {
        $action = CANCEL_ACTION;
      }
      elseif (@$_REQUEST["btnSave"])
      {
        $action = UPDATE_ACTION;
      }
      elseif (@$_REQUEST["btnNew"])
      {
        $action = CANCEL_ACTION;
      }
      elseif (@$_REQUEST["btnFind"])
      {
        $action = FIND_ACTION;
      }
      else
      {
       $action = UPDATE_ACTION;
      }     

      if ($action != FIND_ACTION)
       {
         header("Location: ".$GLOBALS["PATH_FORM_ROOT"].
                "?".$menu->request_menu_level2."=".$menu->current_level2.
                "&FORM_ACTION=".$action.
                "&PROP_ID=".$values["PL_PROP_ID"]);     
       }   
    
     }
   }
   
   
    $listing["PL_PUBLISH_YN"] = ($listing["PL_PUBLISH_YN"] == "Y");    
    $listing["PL_SOLD_YN"] = ($listing["PL_SOLD_YN"] == "Y");    

    $form->AddElement("hidden", "PR_CHECKSUM", $report_data["PROPERTY"]["CHECKSUM"]);
    
    $form->AddElement("text", "PR_PROP_ID", "Property ID",
                                  array("value" => $report_data["PROPERTY"]["PROP_ID"],  "size" => 16));
                                  
    $form->AddElement("text", "PR_ADDRESS1", "Street Address",
                                  array("value" => $report_data["PROPERTY"]["ADDRESS1"],  "size" => 40));
    $form->AddElement("text", "PR_ADDRESS2", "Address Line 2",  
                                   array("value" => $report_data["PROPERTY"]["ADDRESS2"], "size" => 40, $disabled));
    $form->AddElement("text", "PR_CITY", "City",  
                                   array("value" => $report_data["PROPERTY"]["CITY"], "size" => 40));


    $state_sel =& $form->AddElement("select", "PR_STATE", "State", $dbRntProp->getStatesList(),
                  array("size" => 1, $disabled));
    $state_sel->setValue($report_data["PROPERTY"]["STATE"]);                  
       
       
    $form->AddElement("text", "PR_ZIPCODE", "Zipcode",  
                                   array("value" => $report_data["PROPERTY"]["ZIPCODE"], "size" => 5, $disabled));
    $form->AddElement("text", "PR_ACREAGE", "Acreage",  
                                  array("value" => $report_data["PROPERTY"]["ACREAGE"],"size" => 6, $disabled));
    $form->AddElement("text", "PR_SQ_FT", "Sq Ft",  
                                   array("value" => $report_data["PROPERTY"]["SQ_FT"],"size" => 8, $disabled));
    
    $usage_sel =& $form->AddElement("select", "PR_UCODE", "Usage", $dbProp->getUseCodesList($action),
                                             array("size" => 1, $disabled));
      $usage = array_keys($report_data["PROPERTY_USAGE"]);
      $usage_sel->setValue($usage[0]);

        if ($action == UPDATE_ACTION )
        {
        // Add a link to the Public Records Data
      $form->AddElement("link", "PR_PUBLIC_RECORD", "Additional Details",  
                        "visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID=".$listing["PL_PROP_ID"],
                                              $source." Public Record Data", "");
    }

    $form->AddElement("text", "PL_LISTING_DATE", "Listing Date",  
                                   array("value" => $listing["PL_LISTING_DATE"],
                                                    "size" => 12, $disabled2));
    $dates_elements[] = "PL_LISTING_DATE";    
    $form->AddElement("text", "PL_PRICE", "Price",  
                                   array("value" => $listing["PL_PRICE"],
                                                    "size" => 12, $disabled2));
    
    $publish_chk =& $form->AddElement("advcheckbox", "PL_PUBLISH_YN", "Publish", "",  array("N", "Y"));
    $publish_chk->setValue($listing["PL_PUBLISH_YN"]);

    $sold_chk =& $form->AddElement("advcheckbox", "PL_SOLD_YN", "Sold/Withdrawn", "",  array("N", "Y"));
    $sold_chk->setValue($listing["PL_SOLD_YN"]);

    $form->AddElement("text", "PL_SOURCE", "Source Reference",  
                                  array("value" => $listing["PL_SOURCE"],
                                                  "size" => 40, $disabled2));
    $form->AddElement("text", "PL_AGENT_NAME", "Agent",  
                                array("value" => $listing["PL_AGENT_NAME"],
                                                    "size" => 40, $disabled2));
    $form->AddElement("text", "PL_AGENT_PHONE", "Agent Phone",  
                                array("value" => $listing["PL_AGENT_PHONE"],
                                                    "size" => 40, $disabled2));
    $form->AddElement("text", "PL_AGENT_EMAIL", "Agent Email",  
                                array("value" => $listing["PL_AGENT_EMAIL"],
                                                    "size" => 40, $disabled2));
    $form->AddElement("text", "PL_AGENT_WEBSITE", "Agent Website",  
                                array("value" => $listing["PL_AGENT_WEBSITE"],
                                                  "size" => 40, $disabled2));
    $textarea =& $form->AddElement("textarea", "PL_DESCRIPTION", "Description", 
                             array("cols" => "70", "rows" => "8"  ));
    
    $textarea->setValue($listing["PL_DESCRIPTION"]);

    $form->addRule("PL_PRICE", "Listing price must be numeric", 'vnumeric');
    $form->addRule("PL_LISTING_DATE", UtlConvert::ErrorDateMsg, 'vdate');
            
    $listing["PL_LISTING_DATE"] = UtlConvert::dbDateToDisplay($listing["PL_LISTING_DATE"]);
    $listing["PL_PRICE"] = UtlConvert::dbNumericToDisplay($listing["PL_PRICE"]);

    $smarty->assign("dates", $dates_elements);

    if ($action == INSERT_ACTION)
    {
          $form->addRule("PR_ADDRESS1", 'Enter a Street Address.', 'required');
          $form->addRule("PR_CITY", 'Enter a City.', 'required');
          $form->addRule("PR_STATE", 'Select a State.', 'required');
          $form->addRule("PR_ZIPCODE", 'Enter a Zipcode.', 'required');
          $form->addRule("PR_UCODE", 'Select a Usage Code.', 'required');
          $form->addRule("PL_LISTING_DATE", 'Enter a Listing Date.', 'required');
          $form->addRule("PL_PRICE", 'Enter the Listing Price.', 'required');
          $form->validate();
        }
        elseif ($action == UPDATE_ACTION)
        {
      $form->addRule("PL_LISTING_DATE", 'Enter a Listing Date.', 'required');
          $form->addRule("PL_PRICE", 'Enter the Listing Price.', 'required');
          $form->validate();
        }

    
    
//    $smarty->assign("script", /*$BULovData->display().*/
//                           $StatesLovData->display());
 
      
    $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
    $form->accept($renderer);
    $smarty->assign('form_data', $renderer->toArray());
      
      
  
  
?>
