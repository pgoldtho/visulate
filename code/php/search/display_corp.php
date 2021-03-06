<?php
 function display_corp($smarty, $template_prefix, $dbReport)
  {
     $is_editor = $smarty->user->isAdmin() || $smarty->user->isSiteEditor();

     // Convert CORP_ID to corp_id for Bing
     if (htmlentities($_REQUEST["corp_id"], ENT_QUOTES))
       $corp_id = strtoupper(htmlentities($_REQUEST["corp_id"], ENT_QUOTES));
     else
       $corp_id = htmlentities($_REQUEST["CORP_ID"], ENT_QUOTES);

     $report_data = $dbReport->getCorpDetails($corp_id);
     $canonical = 'rental/visulate_search.php?CORP_ID='.$corp_id;

     if (empty($report_data))
     {
      http_response_code(404);
      //exit;
       // header("HTTP/1.0 404 Not Found");
     }

     if ($is_editor)
     {

        $sunbiz = new PRSunbiz($smarty->connection);

        if (!defined("ADMIN_MENUS")) {
        define("ACTION_VIEW", "VIEW");
        define("ACTION_INSERT", "INSERT");
        define("ACTION_UPDATE", "UPDATE");
        define("ACTION_DELETE", "DELETE");
        define("ACTION_CANCEL", "CANCEL");
        }

        // check user action
        $action = ACTION_VIEW;
        if ($_REQUEST["action_cancel"]) {
            $action = ACTION_CANCEL;
        }
        elseif ($_REQUEST["action_save"]) {
            $action = ACTION_UPDATE;
        }
        elseif ($_REQUEST["action_add"]) {
            $action = ACTION_INSERT;
        }
        elseif ($_REQUEST["action"] == "DEL_OFFICER") {
           $action = ACTION_DELETE;
        }
        else {
         $action = ACTION_VIEW;
       }



          // create form
       $form   = new HTML_QuickForm('visulate_search', 'GET');
       $IsPost = $form->isSubmitted();




       if ($action == ACTION_CANCEL)
        {
        print "<script>top.location = '".$GLOBALS["PATH_FORM_ROOT"]."visulate_search.php?CORP_ID=".$corp_id."';</script>";
        exit;
        }
        elseif ($action == ACTION_UPDATE)
        {

         $corpID      = htmlentities($_REQUEST["CORP_ID"], ENT_QUOTES);
         $name        = htmlentities($_REQUEST["NAME"], ENT_QUOTES);
         $status      = htmlentities($_REQUEST["STATUS"], ENT_QUOTES);
         $filing_type = htmlentities($_REQUEST["FILING_TYPE"], ENT_QUOTES);
         $filing_date = htmlentities($_REQUEST["FILING_DATE"], ENT_QUOTES);
         $fei_number  = htmlentities($_REQUEST["FEI_NUMBER"], ENT_QUOTES);
         $address1    = htmlentities($_REQUEST["ADDRESS1"], ENT_QUOTES);
         $address2    = htmlentities($_REQUEST["ADDRESS2"], ENT_QUOTES);
         $city        = htmlentities($_REQUEST["CITY"], ENT_QUOTES);
         $state       = htmlentities($_REQUEST["STATE"], ENT_QUOTES);
         $zipcode     = htmlentities($_REQUEST["ZIPCODE"], ENT_QUOTES);
         $prop_id     = htmlentities($_REQUEST["CPROP_ID"], ENT_QUOTES);
         $lat         = htmlentities($_REQUEST["LAT"], ENT_QUOTES);
         $lon         = htmlentities($_REQUEST["LON"], ENT_QUOTES);

         $msg = '';
         if ($name == NULL) $msg = "<br/>Name cannot be null";
         if ($filing_type == NULL) $msg = $msg."<br/>Filing Type cannot be null";
         if ($filing_date == NULL) $msg = $msg."<br/>Filing Date cannot be null";
         if ($address1 == NULL) $msg = $msg."<br/>Address1 cannot be null";
         if ($city == NULL) $msg = $msg."<br/>City cannot be null";
         if ($state == NULL) $msg = $msg."<br/>State cannot be null";
         if ($zipcode == NULL) $msg = $msg."<br/>Zipcode cannot be null";
         if (strlen($zipcode) != 5) $msg = $msg."<br/>Zipcode must be 5 digits";

         if (!$msg)
         {
           $IsError = 0;
           try {
               $sunbiz->update_corp($corpID, $name, $status, $filing_type, $filing_date, $fei_number);
               $sunbiz->update_corp_addr($corpID, $address1, $address2, $city, $state, $zipcode, $prop_id, $lat, $lon);

               $smarty->connection->commit();
               }
           catch(SQLException $e)
           {
           //print_r($e);
           $IsError = 1;
           $msg = $msg."<br/>A database error occurred";
           $smarty->connection->rollback();
           }
         }
         else
         {
           $IsError = 1;
         }


         if ($IsError)
           {
            $smarty->assign("errorMsg2", "<fieldset><legend>Update Failed</legend>
            <p class='error'> $msg</p></fieldset>");
           }
         else
          {
           print "<script>top.location = '".$GLOBALS["PATH_FORM_ROOT"]."visulate_search.php?CORP_ID=".$corp_id."';</script>";
           exit;
           }
        }
        elseif ($action == ACTION_INSERT)
        {

         $corpID     = htmlentities($_REQUEST["CORP_ID"], ENT_QUOTES);
         $name       = htmlentities($_REQUEST["ONAME"], ENT_QUOTES);
         $type       = htmlentities($_REQUEST["OTYPE"], ENT_QUOTES);
         $title_code = htmlentities($_REQUEST["OPOSITION"], ENT_QUOTES);
         $address1   = htmlentities($_REQUEST["OADDRESS1"], ENT_QUOTES);
         $address2   = htmlentities($_REQUEST["OADDRESS2"], ENT_QUOTES);
         $city       = htmlentities($_REQUEST["OCITY"], ENT_QUOTES);
         $state      = htmlentities($_REQUEST["OSTATE"], ENT_QUOTES);
         $zipcode    = htmlentities($_REQUEST["OZIPCODE"], ENT_QUOTES);
         $msg = '';
         if ($name == NULL) $msg = "<br/>Name cannot be null";
         if ($title_code == NULL) $msg = $msg."<br/>Position cannot be null";
         if ($address1 == NULL) $msg = $msg."<br/>Address1 cannot be null";
         if ($city == NULL) $msg = $msg."<br/>City cannot be null";
         if ($state == NULL) $msg = $msg."<br/>State cannot be null";
         if ($zipcode == NULL) $msg = $msg."<br/>zipcode cannot be null";

         if (!$msg)
         {
           $IsError = 0;
           try {
               $sunbiz->add_officer($corpID, $name, $type, $title_code, $address1, $address2, $city, $state, $zipcode);
               $smarty->connection->commit();
               }
           catch(SQLException $e)
           {
           $IsError = 1;
           $msg = $msg."<br/>A database error occurred";
           $smarty->connection->rollback();
           }
         }
         else
         {
           $IsError = 1;
         }


         if ($IsError)
           {
            $smarty->assign("errorMsg", "<fieldset><legend>Insert of New Officer Failed</legend>
            <p class='error'> $msg</p></fieldset>");
           }
         else
          {
           print "<script>top.location = '".$GLOBALS["PATH_FORM_ROOT"]."visulate_search.php?CORP_ID=".$corp_id."';</script>";
           exit;
           }


        }
        elseif ($action == ACTION_DELETE)
        {
         $sunbiz->rm_officer($corp_id,  htmlentities($_REQUEST["PN_ID"], ENT_QUOTES), NULL);
         print "<script>top.location = '".$GLOBALS["PATH_FORM_ROOT"]."visulate_search.php?CORP_ID=".$corp_id."';</script>";
         exit;
        }



       $form_data = array();
       // form actions buttons
       $form->AddElement("submit", "action_cancel", "Cancel", array());
       $form->AddElement("submit", "action_save",   "Save",   array());
       $form->AddElement("submit", "action_add",   "Add Officer",   array());



       $form->AddElement("hidden", "CORP_ID", $corp_id);
       $form->AddElement("text", "NAME", "Name", array("size"=> 40));
       $form->AddElement("select", "STATUS", "Status", array("A"=>"Active","I"=>"Inactive","H"=>"Hidden"));
       $form->AddElement("text", "FILING_TYPE", "Filing Type", array("size"=> 40));
       $form->AddElement("text", "FILING_DATE", "Filing Date", array("size"=> 40));
       $form->AddElement("text", "FEI_NUMBER",  "FEI Number", array("size"=> 40));

       $form->AddElement("text", "ADDRESS1",  "Address 1", array("size"=> 40));
       $form->AddElement("text", "ADDRESS2",  "Address 2", array("size"=> 40));
       $form->AddElement("text", "CITY",  "City", array("size"=> 40));
       $form->AddElement("text", "STATE",  "State", array("size"=> 2));
       $form->AddElement("text", "ZIPCODE",  "Zipcode", array("size"=> 6));
       $form->AddElement("text", "CPROP_ID",  "Prop ID", array("size"=> 10));
       $form->AddElement("text", "LAT",  "Latitude", array("size"=> 20));
       $form->AddElement("text", "LON",  "Longitude", array("size"=> 20));

       $form->AddElement("text", "ONAME",  "Name", array("size"=> 40));
       $form->AddElement("select", "OTYPE",  "Officer Type",  array("P"=>"Person","C"=>"Company"));
       $form->AddElement("text", "OPOSITION",  "Position", array("size"=> 6));
       $form->AddElement("text", "OADDRESS1",  "Address 1", array("size"=> 40));
       $form->AddElement("text", "OADDRESS2",  "Address 2", array("size"=> 40));
       $form->AddElement("text", "OCITY",  "City", array("size"=> 40));
       $form->AddElement("text", "OSTATE",  "State", array("size"=> 2));
       $form->AddElement("text", "OZIPCODE",  "Zipcode", array("size"=> 6));



// if (!$IsPost)
 //{
     $form->setDefaults(
         array(
             "NAME"         => $report_data["SUNBIZ-ID"]["NAME"],
             "STATUS"       => $report_data["SUNBIZ-ID"]["STATUS"],
             "FILING_TYPE"  => $report_data["SUNBIZ-ID"]["FILING_TYPE"],
             "FILING_DATE"  => $report_data["SUNBIZ-ID"]["FILING_DATE"],
             "FEI_NUMBER"   => $report_data["SUNBIZ-ID"]["FEI_NUMBER"],

             "ADDRESS1"   => $report_data["SUNBIZ-ID"]["ADDR"]["ADDRESS1"],
             "ADDRESS2"   => $report_data["SUNBIZ-ID"]["ADDR"]["ADDRESS2"],
             "CITY"       => $report_data["SUNBIZ-ID"]["ADDR"]["CITY"],
             "STATE"      => $report_data["SUNBIZ-ID"]["ADDR"]["STATE"],
             "ZIPCODE"    => $report_data["SUNBIZ-ID"]["ADDR"]["ZIPCODE"],
             "CPROP_ID"   => $report_data["SUNBIZ-ID"]["ADDR"]["PROP_ID"],
             "LAT"        => $report_data["SUNBIZ-ID"]["ADDR"]["LAT"],
             "LON"        => $report_data["SUNBIZ-ID"]["ADDR"]["LON"],
             "GEO_FOUND"  => $report_data["SUNBIZ-ID"]["ADDR"]["GEO_FOUND"]

         )
    );
   // }

       $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
       // generate code
       $form->accept($renderer);

       $smarty->assign('form_data', $renderer->toArray());
       $smarty->assign('action', $action);

      }

//print_r($report_data);

     $lat =  $report_data["SUNBIZ-ID"]["ADDR"]["LAT"];
     $long = $report_data["SUNBIZ-ID"]["ADDR"]["LON"];


     $mls_listings = $dbReport->getGeoListings( $report_data["SUNBIZ-ID"]["ADDR"]["LAT"]
                                              , $report_data["SUNBIZ-ID"]["ADDR"]["LON"]);
     if (($lat)&&($long)){
     $streetview = $dbReport->get_streetview_url($lat, $long);
     $smarty->assign("streetview", $streetview);
     }

/*
     if ((strlen($report_data["SUNBIZ-ID"]["ADDR"]["LAT"]) > 0) &&
         (strlen($report_data["SUNBIZ-ID"]["ADDR"]["LON"]) > 0) && (MAINTENANCE_MODE != "Y"))
      {

        $dbCity   = new RNTCities($smarty->connection);
        $city = $dbCity->getGeoCity($report_data["SUNBIZ-ID"]["ADDR"]["LAT"]
                                  , $report_data["SUNBIZ-ID"]["ADDR"]["LON"]
                                  , $report_data["SUNBIZ-ID"]["ADDR"]["CITY"]);
        $smarty->assign("cityDataValues", $city);
      }
*/
     $smarty->assign("is_editor", $is_editor);
     $smarty->assign("canonical", $canonical);
     $smarty->assign("data", $report_data);
     $smarty->assign("mls_listings", $mls_listings);
     $smarty->assign("pageTitle", $report_data["SUNBIZ-ID"]["NAME"]." Corporate Details");
     $smarty->assign("pageDesc", $report_data["SUNBIZ-ID"]["NAME"]." is a Florida Corporation based in ".$report_data["SUNBIZ-ID"]["ADDR"]["CITY"]);
     $html_report = $smarty->display($template_prefix."-corp-details.tpl");

   }