<?php
function getMaxMin($listings, $max, $zcode)
  {
    $rv = array();
    if ($max=='ANY')
     {
     $max = 'B_MEDIAN';
     }
    if (!$listings[$zcode])
    {
         $rv["maxval"] = 100000;
         $rv["minval"] = 0;
    }
    elseif ($max=='A_MAX')
        {
         $rv["maxval"] = $listings[$zcode]['A_MAX'];
         $rv["minval"] = $listings[$zcode]['A_MEDIAN'];
        }
    elseif($max=='A_MEDIAN')
        {
         $rv["maxval"] = $listings[$zcode]['A_MEDIAN'];
         $rv["minval"] = $listings[$zcode]['A_MIN'];
        }
    elseif($max=='A_MIN')
        {
         $rv["maxval"] = $listings[$zcode]['A_MIN'];
         $rv["minval"] = $listings[$zcode]['B_MEDIAN'];
        }
    elseif($max=='B_MEDIAN')
        {
         $rv["maxval"] = $listings[$zcode]['B_MEDIAN'];
         $rv["minval"] = $listings[$zcode]['C_MAX'];
        }
    elseif($max=='C_MAX')
        {
         $rv["maxval"] = $listings[$zcode]['C_MAX'];
         $rv["minval"] = $listings[$zcode]['C_MEDIAN'];
        }
    elseif($max=='C_MEDIAN')
        {
         $rv["maxval"] = $listings[$zcode]['C_MEDIAN'];
         $rv["minval"] = 0;
        }
    if (($listings[$zcode])&&($listings[$zcode]['TOTAL'] < 15)) $rv["minval"] = 0;
    return $rv;
    }

function  process_listing($smarty, $template_prefix, $dbReport)
  {
    if ($_GET['qtype'])
      $qtype = htmlentities($_GET['qtype'], ENT_QUOTES);
    else
      $qtype = 'COMMERCIAL';

    if ($_GET['state'])
       $state     = htmlentities($_GET['state'], ENT_QUOTES);
    else
       $state = 'FL';

    if ($_GET['county'])
        $county    = htmlentities($_GET['county'], ENT_QUOTES);
    else
      $county = 'ANY';

    if ($_GET['ZCODE'])
      $zcode = htmlentities($_GET['ZCODE'], ENT_QUOTES);
    else
      $zcode = 'ANY';

    if ($_GET['MAX'])
      $max = htmlentities($_GET['MAX'], ENT_QUOTES);
    else
      $max = 'ANY';

    if ($_GET['PROP_ID'])
      $prop_id = htmlentities($_GET['PROP_ID'], ENT_QUOTES);
    else
      $prop_id = 'ANY';

    $dbSearch = new LISTSearch($smarty->connection);
    if ($qtype=='LAND')
      {
       $pageTitle = 'Vacant Land for Sale';
       $pageDesc = 'List of vacant land parcels currently listed for sale';
      }
    elseif ($qtype=='RENTAL')
      {
       $pageTitle = 'Rental Listings';
       $pageDesc = 'List of residential rental properties';
      }
    elseif ($qtype=='COMMERCIAL')
      {
       $pageTitle = 'Income and Commercial';
       $pageDesc = 'List of income and commercial properties';
      }
    elseif ($qtype=='LATEST')
      {
       $pageTitle = 'Latest Listings';
       $pageDesc = 'Latest listings added to Visulate';
      }
    elseif ($qtype=='HOMEPAGE')
      {
       $pageTitle = 'Latest Commercial Listings';
       $pageDesc = 'Latest Commercial listings added to Visulate';
      }
    else
      {
       $qtype='RESIDENTIAL';
       $pageTitle = 'Homes for Sale';
       $pageDesc = 'List of single family homes, condos, townhouses currently listed for sale';
      }

    if (($prop_id=='ANY') or (is_null($prop_id))) {
      // Search for a property
      if ($state=='ANY'){
        $searchList = $dbSearch->getStateCountListings($qtype);
        $url = '/rental/visulate_search.php?REPORT_CODE=LISTINGS&qtype='.$qtype;
        $pageTitle = 'Search '.$pageTitle;
        }
      elseif($county=='ANY' ){
        $searchList = $dbSearch->getCountyListings($qtype, $state);
        $pageTitle = 'Florida Commercial Real Estate - Visulate';
        $pageDesc .= 'Latest commercial real estate listings in Florida.  Search by county and usage type.';
        $url = '/rental/visulate_search.php?REPORT_CODE=LISTINGS&qtype='.$qtype.'&state='.$state;
        $displayLocation = 'Florida';

        $listings = $dbReport->getFloridaPriceRange();
        $smarty->assign('listingTable', $listings);
        }
      else
       {
        $searchList = $dbSearch->getCountyListings($qtype, $state);
        $listings = $dbReport->getPriceRange($qtype, $county, $state);

        $smarty->assign('listingTable', $listings);
        $url = '/rental/visulate_search.php?REPORT_CODE=LISTINGS&qtype='.$qtype.'&state='.$state.'&county='.$county;
        $smarty->assign('selected', 'style="color: blue; font-weight: bold;"');
        $displayLocation = $county.', County Florida';
        if ($zcode!='ANY')
          {
           if ($max == 'ANY') $max = 'B_MEDIAN';
           $values = getMaxMin($listings, $max, $zcode);
           if ($listings[$zcode])
           {
             $pageTitle .= ' in '.$listings[$zcode]["NAME"]
                        .' Priced from $'.number_format($values["minval"]+1)
                        .' to $'.number_format($values["maxval"]);
             $pageDesc .= ' in '.$listings[$zcode]["NAME"]
                              .' Priced from $'.number_format($values["minval"])
                              .' to $'.number_format($values["maxval"]);
            }
           $smarty->assign('max', $max);
           $smarty->assign('zcode', $zcode);
          }
        else
          {
           $pageTitle = 'Search '.$pageTitle.' in '. ucfirst(strtolower($county)).' County, '.$state;
           $pageDesc .= ' in '. ucfirst(strtolower($county)).' County, '.$state;
           $displayLocation = $county.', County Florida';
          }

       }

      $smarty->assign('locations', $searchList);
      $smarty->assign('current_county', $county);
      $smarty->assign('mapLocation', $county.' county '.$state);
      $smarty->assign('url', $url);
      $smarty->assign('qtype', $qtype);
      $smarty->assign('county', $county);
      $smarty->assign("reportCode", "LISTINGS");
      $smarty->assign("pageTitle", $pageTitle);
      $smarty->assign("pageDesc", $pageDesc);
      $smarty->assign("displayLocation", $displayLocation);
      $smarty->display($template_prefix.'_search.tpl');
      }
    else{
       // Found a property, display its details
       $url = '/rental/visulate_search.php?REPORT_CODE=LISTINGS&qtype='.$qtype.'&state='.$state.'&county='.$county;
       $report_data      = $dbReport->getPropertyDetails($prop_id);
       $canonical        = 'property/'.$prop_id;

       $display_property = $report_data["PROPERTY"]["ADDRESS1"]
                           .", ".$report_data["PROPERTY"]["CITY"];
  /*
       $ucode = 90001; // default value 90001 = Single Family
       foreach ($report_data["PROPERTY_USAGE"] as $k => $v)
                   {
                   $ucode = $k;
                   }
   *
   */
       $mls      = $dbReport->getMLS($prop_id);

       // Populate MLS list for display on left of page
       if ($qtype=='LATEST')
        {$mlsList = $dbReport->getMLSlatest($county, $state);}
       elseif ($qtype=='HOMEPAGE')
         {$mlsList = $dbReport->getLatestCommercial();}
       else {
         $listings = $dbReport->getPriceRange($qtype, $county, $state);
         $values = getMaxMin($listings, $max, $zcode);
         $mlsList  = $dbReport->getPriceRangeListings($qtype, $zcode, $values["maxval"], $values["minval"], $county);}

       $photos   = $dbReport->getPropPhotos($prop_id);
       $pageDesc = $mls[1]["LINK_TEXT"]." ".$mls[1]["TITLE"];
       if ($pageDesc == " ") $pageDesc = $display_property." is no longer listed for sale.";

       $smarty->assign("data", $report_data);
       $smarty->assign("data1", $searchList);
//       $smarty->assign("comps", $comps);
       $smarty->assign("photos", $photos);
       $smarty->assign("prop_id", $prop_id);
       $smarty->assign("lease_type", $lease_type);
       $smarty->assign("url", $url);
       $smarty->assign('max', $max);
       $smarty->assign('zcode', $zcode);
       $smarty->assign('qtype', $qtype);
       $smarty->assign("mls", $mls);
       $smarty->assign("searchResults", $mlsList);
       $smarty->assign("pageTitle", "$display_property");
       $smarty->assign("pageDesc", $pageDesc);
       $smarty->assign("canonical", $canonical);

       if  ($template_prefix=="mobile")
         {$menu3 = array();
          foreach ($mlsList as $k => $v)
           {$menu3[] = array
               ("href"=>$url."&MAX=".$max."&ZCODE=".$zcode."&PROP_ID=".$mlsList[$k]["PROP_ID"]
               , "value"=>$mlsList[$k]["ADDRESS1"]);
           // if ($mlsList[$k]["PROP_ID"] == $prop_id) {$skey = $k;}
           }
           $menu3[] = array
               ("href"=>$url."&MAX=".$max."&ZCODE=".$zcode
               , "value"=>"Return to Search Screen");
           $smarty->assign(submenu2_1, $menu3);
           $smarty->assign(skey, $skey);
           $smarty->assign(listingReport, "Y");

           }

       $html_report = $smarty->display($template_prefix."-listings.tpl");
      }
    }

 function ajax_listings($smarty, $template_prefix, $dbReport)
  {
    if ($_GET['qtype'])
      $qtype = htmlentities($_GET['qtype'], ENT_QUOTES);
    else
      $qtype = 'ANY';

    if ($_GET['state'])
       $state     = htmlentities($_GET['state'], ENT_QUOTES);
    else
       $state = 'ANY';

    if ($_GET['county'])
        $county    = htmlentities($_GET['county'], ENT_QUOTES);
    else
      $county = 'ANY';

    if ($_GET['city'])
        $city    = htmlentities($_GET['city'], ENT_QUOTES);
    else
      $city = 'ANY';


    if ($_GET['ZCODE'])
      $zcode = htmlentities($_GET['ZCODE'], ENT_QUOTES);
    else
      $zcode = 'ANY';

    if ($_GET['MAX'])
      $max = htmlentities($_GET['MAX'], ENT_QUOTES);
    else
      $max = 'B_MEDIAN';

    $dbSearch = new LISTSearch($smarty->connection);


    $smarty->assign('listingTable', $listings);
    $url = '/rental/visulate_search.php?REPORT_CODE=LISTINGS&qtype='.$qtype.'&state='.$state.'&county='.$county.'&city='.$city;

    if ($qtype=='LATEST')
     {
      $commlist = $dbReport->getMLScommercial($county, $state);
      $smarty->assign('commlist', $commlist);
      $resultList = $dbReport->getMLSlatest($county, $state);
      $pageDesc = $county.' Latest Listings';
     }
    elseif ($qtype=='COMMERCIAL')
     {
      $commlist = $dbReport->getMLScommercial($county, $state);

      $zcodeFound = "N";
      foreach ($commlist as $zlist){
        if ($zlist["ZCODE"] == $zcode) $zcodeFound = "Y";
      }
      if ($zcodeFound == "N") $zcode = $commlist[0]["ZCODE"];

      $smarty->assign('commlist', $commlist);
      $listings = $dbReport->getPriceRange($qtype, $county, $state);
      $values = getMaxMin($listings, $max, $zcode);
      $resultList = $dbReport->getPriceRangeListings($qtype, $zcode, $values["maxval"], $values["minval"], $county);
      if ($listings){
        $pageDesc = $listings[$zcode]["NAME"].' in '.$county
                              .' Priced from $'.number_format($values["minval"])
                              .' to $'.number_format($values["maxval"]);}
      else{
        $pageDesc = 'Commercial properties in '.$county
                              .' Priced from $'.number_format($values["minval"])
                              .' to $'.number_format($values["maxval"]);}

     }
    elseif ($qtype=='HOMEPAGE')
    {
     $commlist = $dbReport->getLatestCommercial();
     $smarty->assign('commlist', $commlist);
     $resultList = $dbReport->getLatestCommercial();
     $pageDesc = 'Latest Commercial Listings';

    }
    else
     {
      $ziplist = $dbReport->getMLSzipcodes($city, $county, $state);

      $zcodeFound = "N";
      foreach ($ziplist as $zlist){
        if ($zlist["ZCODE"] == $zcode) $zcodeFound = "Y";
        }
      if ($zcodeFound == "N") $zcode = $ziplist[0]["ZCODE"];


      $smarty->assign('ziplist', $ziplist);
      $listings = $dbReport->getPriceRange($qtype, $county, $state);
      $values = getMaxMin($listings, $max, $zcode);
      $resultList = $dbReport->getPriceRangeListings($qtype, $zcode, $values["maxval"], $values["minval"], $county);

      if ($qtype=='LAND')
       {$pageDesc = 'Vacant land';}
      else
       {$pageDesc = 'Residential Properties';}

      if ($listings){
      $pageDesc.=' in '.$listings[$zcode]["NAME"]
                .' Priced from $'.number_format($values["minval"])
                .' to $'.number_format($values["maxval"]);}
     }


      $searchList = $dbSearch->getCountyListings($qtype, $state);
      //print_r($searchList);
      $smarty->assign('locations', $searchList);


       $smarty->assign('max', $max);
       $smarty->assign('zcode', $zcode);
       $smarty->assign('resultList', $resultList);
       $smarty->assign('url', $url);
       $smarty->assign('qtype', $qtype);

       $smarty->assign('city', $city);
       $smarty->assign('county', $county);

       $smarty->assign("pageDesc", $pageDesc);

     $html_report = $smarty->display($template_prefix."-ajax-listings.tpl");
   }
