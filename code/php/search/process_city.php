<?php
 require_once dirname(__FILE__)."/menu_functions.php";
 function process_city($smarty, $template_prefix)
  {
    $dbSearch = new LISTSearch($smarty->connection);
    $dbCity   = new RNTCities($smarty->connection);
    $dbReport = new PRReports($smarty->connection);
     if ($_GET['state'])
      {
           $state     = htmlentities($_GET['state'], ENT_QUOTES);
           $smarty->assign('getState', $state);
           }
        else
           $state = 'FL';
    if ($_GET['county'])
      {
        $county    = htmlentities($_GET['county'], ENT_QUOTES);
        $smarty->assign('getCounty', $county);
        $commlist = $dbReport->getMLScommercial($county, $state);
        $smarty->assign('commlist', $commlist);
        }
    else
      $county = null;
    if ($_GET['city'])
      {
        $city    = htmlentities($_GET['city'], ENT_QUOTES);
        $ziplist = $dbReport->getMLSzipcodes($city, $county, $state);
        $smarty->assign('ziplist', $ziplist);
        $smarty->assign('getCity', $city);
      }
    else
      $city = null;

    if ($_GET['ucode'])
        $ucode    = htmlentities($_GET['ucode'], ENT_QUOTES);
    else
      $ucode = null;

    if ($_GET['year'])
        $year    = htmlentities($_GET['year'], ENT_QUOTES);
    else
      $year = null;

    if ($_GET['yucode'])
        $yucode    = htmlentities($_GET['yucode'], ENT_QUOTES);
    else
      $yucode = null;

     if ($_GET['region_id'])
        $region_id    = htmlentities($_GET['region_id'], ENT_QUOTES);
    else
      $region_id = 0;

    if ($state == 'FL') $display_state = 'Florida';




    $regions = $dbCity->getRegions();
    $skey = get_skey($region_id, $regions);
    if ($skey == 0) $region_id = NULL;


    $submenu3 = get_region_submenu($regions);
    $smarty->assign("submenu2_1", $submenu3);
    $smarty->assign("skey", $skey);
    $smarty->assign("region_id", $region_id);

    if (is_null($state)){
        $searchList = $dbSearch->getStateCountList();
        }
    elseif($county==null||$county=='ANY'){
        $searchList = $dbSearch->getCountyStats($state, $region_id);
        if ($region_id)
        {
         $cityDataValues = $dbCity->getRegionDesc($region_id);
         $pageDesc =  $cityDataValues["META_DESCRIPTION"];
         $displayLocation = $cityDataValues["DISPLAY_NAME"]." Florida"; }
        else
        {$cityDataValues = $dbCity->getCityDesc("ANY", "ANY", $state);
        $displayLocation = "Florida";
        $pageDesc = "Florida is the fourth largest state in the country in terms of both population and GDP.
        If Florida was a country, it would be in the top twenty of the world.
        Florida's economy is larger than Saudi Arabia's or the combined economies of Argentina and Peru.";
        $smarty->assign("canonical", "/");
        }
        }
    else{
        $searchList = $dbSearch->getCountyCities($county, $state);
        $cityDataValues = $dbCity->getCityDesc("ANY", $county, $state);
        $displayLocation = ucwords(strtolower($county))." County ".$display_state;
        $pageDesc =  $cityDataValues["META_DESCRIPTION"];
        }

    if ($yucode && $year) {
        $salesData = $dbSearch->getCitySalesData($city, $county, $state, $year, $yucode);
        if ($city) $cityValues = $dbSearch->getCityValues($city, $county, $state, $yucode);
        }
        else
        {
         if ($county) $cityData = $dbSearch->getCityData($city, $county, $state, $ucode);
         if ($city)
            { $cityValues = $dbSearch->getCityValues($city, $county, $state, '');
              $cityDataValues = $dbCity->getCityDesc($city, $county, $state);
              $pageDesc =  $cityDataValues["META_DESCRIPTION"];
              $displayLocation = ucwords(strtolower($city)).", ".$display_state;
            }
         }


    $pcountPlot = '[';
    $sqftPlot = '[';

    foreach($cityData as $cityd){
      if ($pcountPlot != '['){
          $pcountPlot = $pcountPlot.", ";
          $sqftPlot = $sqftPlot.", ";
           }
      $pcountPlot = $pcountPlot."['".str_replace('&', '&amp;', $cityd["PROP_USAGE"])."',".$cityd["PROP_COUNT"]."]";
      $sqftPlot = $sqftPlot."['".str_replace('&', '&amp;', $cityd["PROP_USAGE"])."',".$cityd["TOTAL_SQFT"]."]";
    }
    $pcountPlot = $pcountPlot."]";
    $sqftPlot = $sqftPlot."]";

    $valuePlot = array();
    $curUcode  = 8888888888888;
    $aPlot = '[';
    $bPlot = '[';
    $cPlot = '[';
    foreach ($cityValues as $value){

      if ($curUcode == 8888888888888){
          $curUcode = $value["UCODE"];
        }
      elseif ($curUcode != $value["UCODE"]){
        $valuePlot[$curUcode] = array( 'A' => $aPlot."]"
                                     , 'B' => $bPlot."]"
                                     , 'C' => $cPlot."]");
        $curUcode = $value["UCODE"];
        $aPlot = '[';
        $bPlot = '[';
        $cPlot = '[';

      }

      if ($value["PROP_CLASS"] == 'A'){
        if ($aPlot != '[') $aPlot = $aPlot.", ";
         $aPlot = $aPlot."[".$value["YEAR"].",".$value["MEDIAN_PRICE"]."]";
      }
      if ($value["PROP_CLASS"] == 'B'){
        if ($bPlot != '[') $bPlot = $bPlot.", ";
        $bPlot = $bPlot."[".$value["YEAR"].",".$value["MEDIAN_PRICE"]."]";
      }
      if ($value["PROP_CLASS"] == 'C'){
        if ($cPlot != '[') $cPlot = $cPlot.", ";
        $cPlot = $cPlot."[".$value["YEAR"].",".$value["MEDIAN_PRICE"]."]";
      }
    }
    $valuePlot[$curUcode] = array( 'A' => $aPlot."]"
                                 , 'B' => $bPlot."]"
                                 , 'C' => $cPlot."]");

 //print_r($searchList);
    $smarty->assign('locations', $searchList);
    $smarty->assign('salesData', $salesData);
    $smarty->assign('cityData', $cityData);
    $smarty->assign('cityDataValues', $cityDataValues);
    $smarty->assign('cityValues', $cityValues);
    $smarty->assign('pcountPlot', $pcountPlot);
    $smarty->assign('sqftPlot', $sqftPlot);
    $smarty->assign('vPlot', $valuePlot);
    $smarty->assign('displayLocation', $displayLocation);

    if ($city != null)
      {
      $smarty->assign("pageTitle", "".ucwords(strtolower($city)).", $display_state ");
      $smarty->assign("pageDesc", "Real Estate Market Data for $state $display_county cities.");
      $smarty->assign("pageText",
      ucwords(strtolower($city))." is located in ".ucfirst(strtolower($county))." County, $display_state.
      This page shows a breakdown by usage type of sales data for property sales in "
      .ucwords(strtolower($city))."  A sales summary for each property type is shown in a series of tables
      and graphs.  They show the median price per sq ft for A, B and C class properties in ".ucwords(strtolower($city))
      .".  Click on the year on any of the summary tables to see a list of individual sales for the property type.");
      }
    elseif($county != null)
      {
      $smarty->assign("pageTitle", ucfirst(strtolower($county))." County, $display_state");
      $smarty->assign("pageText",
      "This page shows market data for ".ucfirst(strtolower($county))." County, $display_state.  Click on the items
      in the County Sales History menu to see a breakdown of property sales by year/month or usage type.
      Click on the items in the ".ucfirst(strtolower($county))." Cities menu to see a breakdown of sales
      data for each city in ".ucfirst(strtolower($county)));
       $listings = $dbReport->getPriceRange("COMMERCIAL", $county, $state);
       $smarty->assign('listingTable', $listings);
      }
    elseif ($displayLocation)
      {
       $smarty->assign("pageTitle", $displayLocation);
      }
    else
      {
      $smarty->assign("pageTitle", "Florida Real Estate");
      $smarty->assign("pageText",
      "There are 67 counties in Florida.
      This page provides access to real estate data for each of them derived from Florida property tax
      and other public records.  Select a county from  the list on the left of the page.");
      }

    $smarty->assign("pageDesc", $pageDesc);
    $smarty->display($template_prefix.'_city.tpl');


    return;
    }