<?php
 require_once dirname(__FILE__)."/menu_functions.php";
function sales_request($smarty, $template_prefix, $dbReport)
  {
     if ($_GET['region_id'])
        $region_id    = htmlentities($_GET['region_id'], ENT_QUOTES);
     else
      $region_id = 0;

     $dbCity   = new RNTCities($smarty->connection);
     $regions = $dbCity->getRegions();
     $skey = get_skey($region_id, $regions);
     if ($skey == 0) $region_id = NULL;

     $submenu3 = get_region_submenu($regions);
     $smarty->assign("submenu2_1", $submenu3);
     $smarty->assign("skey", $skey);
     $smarty->assign("region_id", $region_id);


      if (htmlentities($_REQUEST["county"], ENT_QUOTES))
        $county = htmlentities($_REQUEST["county"], ENT_QUOTES);
      else
        $county = 'BREVARD';

     //$cityDataValues = $dbCity->getCityDesc("ANY", $county, "FL");
     //$smarty->assign("cityDataValues", $cityDataValues);

      $smarty->assign('getState', 'FL');
      $smarty->assign('getCounty', $county);

      $dbSearch = new LISTSearch($smarty->connection);
      $searchList = $dbSearch->getCountyCities($county, 'FL');
      $smarty->assign('locations', $searchList);

      if (htmlentities($_REQUEST["YEAR"], ENT_QUOTES))
      {
       $year = htmlentities($_REQUEST['YEAR']);
       $report_data = $dbReport->YearSales($year, $county);
       $smarty->assign("data", $report_data);
       $smarty->assign("pageTitle", ucfirst(strtolower($county))." County, Florida $year Property Sales");
       $smarty->assign("pageDesc", "Visulate sales data for all types of property in ".ucfirst(strtolower($county))." County Florida in $year");
       $smarty->assign("pageText",
       "This page shows property sales history for ".ucfirst(strtolower($county))." County Florida in $year
       It shows a breakdown of the number of properties sold, total sales volume and median price by city and month.
       The data is sourced from public records and is deemed reliable but not guaranteed.
       It may contain inaccuracies. Click on the city to see the details for individual sales in a month.");

       $html_report = $smarty->display($template_prefix."-year-details.tpl");
      }
      elseif (htmlentities($_REQUEST["MONTH_YEAR"], ENT_QUOTES))
      {
       $city = ucwords(strtolower(htmlentities($_REQUEST["CITY"], ENT_QUOTES)));
       $report_data = $dbReport->MonthSales(htmlentities($_REQUEST["MONTH_YEAR"], ENT_QUOTES)
                                          , htmlentities($_REQUEST["CITY"], ENT_QUOTES)
                                          , $county);
       $month_year = explode('-', htmlentities($_REQUEST["MONTH_YEAR"], ENT_QUOTES));
       $year = $month_year[1];
       $n_month = $month_year[0];
       if ($n_month == 01) $month = "January";
           elseif ($n_month == 02) $month = "February";
           elseif ($n_month == 03) $month = "March";
           elseif ($n_month == 04) $month = "April";
           elseif ($n_month == 05) $month = "May";
           elseif ($n_month == 06) $month = "June";
           elseif ($n_month == 07) $month = "July";
           elseif ($n_month == 08) $month = "August";
           elseif ($n_month == 09) $month = "September";
           elseif ($n_month == 10) $month = "October";
           elseif ($n_month == 11) $month = "November";
       else $month = "December";

       $smarty->assign("year", $year);
       $smarty->assign("month", $month);
       $smarty->assign("data", $report_data);
       $smarty->assign("pageTitle", ucfirst(strtolower($city)).", Florida Property Sales - $month $year");
       $smarty->assign("pageDesc", "Visulate sales data for all types of property in $city, Florida $month $year");
       $smarty->assign("pageText",
        "This page shows property sales history for ".ucfirst(strtolower($city)).", Flordia in $month $year.
         It shows the property address, sales date, and sales amount for Warranty Deeds recorded in $month $year.
         The data is sourced from public records is deemed reliable but not guaranteed. It may contain inaccuracies.
         Click on the address to see the property details.");
       $html_report = $smarty->display($template_prefix."-month-details.tpl");
      }
     else
      {
       $report_data = $dbReport->AllSales($county);
       $smarty->assign("allSales", $report_data);
       $smarty->assign("pageTitle", ucfirst(strtolower($county))." County, Florida Property Sales");
       $smarty->assign("pageDesc", "Sales data for all types of property in ".ucfirst(strtolower($county)).
       " County, Florida.
       Displays sales data recorded in the Visulate database and shows a breakdown by year of the
       number of properties sold, total sales volume and median price.");
       $smarty->assign("pageText",
       "This page shows sales data for all types of property in ".ucfirst(strtolower($county)).
       " County, Florida.  It shows a breakdown by year of the number of properties sold, total
       sales volume and median price.  Click on a year in the ".ucfirst(strtolower($county)).
       " County Sales History table for additional details");
       $html_report = $smarty->display($template_prefix."_city.tpl");
      }
    }

  function commercial_sales($smarty, $template_prefix, $dbReport)
  {

     if ($_GET['region_id'])
        $region_id    = htmlentities($_GET['region_id'], ENT_QUOTES);
     else
      $region_id = 0;

     $dbCity   = new RNTCities($smarty->connection);
     $regions = $dbCity->getRegions();
     $skey = get_skey($region_id, $regions);
     if ($skey == 0) $region_id = NULL;

     $submenu3 = get_region_submenu($regions);
     $smarty->assign("submenu2_1", $submenu3);
     $smarty->assign("skey", $skey);
     $smarty->assign("region_id", $region_id);

      if (htmlentities($_REQUEST["county"], ENT_QUOTES))
        $county = htmlentities($_REQUEST["county"], ENT_QUOTES);
      else
        $county = 'BREVARD';



      $smarty->assign('getState', 'FL');
      $smarty->assign('getCounty', $county);

      $dbSearch = new LISTSearch($smarty->connection);
      $searchList = $dbSearch->getCountyCities($county, 'FL');
      $smarty->assign('locations', $searchList);

      if (htmlentities($_REQUEST["YEAR"], ENT_QUOTES))
        {
         $year = htmlentities($_REQUEST["YEAR"], ENT_QUOTES);
         $report_data = $dbReport->CommercialSalesYear(htmlentities($_REQUEST["YEAR"], ENT_QUOTES), $county);
         $smarty->assign("data", $report_data);
         $smarty->assign("pageTitle", "$year Commercial Property Sales ".ucfirst(strtolower($county))." County, Florida");
         $smarty->assign("pageDesc", ucfirst(strtolower($county))." County, Florida Commercial Property Sales data for property sales in $year.");
         $smarty->assign("pageText",
         "This page shows commercial property sales data for ".ucfirst(strtolower($county))." County, Florida.
         It shows a breakdown by property type of ".ucfirst(strtolower($county))." commercial sales in $year. The data was sourced
         from public records and is deemed reliable but not guaranteed. It should be independently verified.
         Click on the property class to see a breakdown of individual sales.");

         $html_report = $smarty->display($template_prefix."-commercial-year.tpl");
         }
    elseif (htmlentities($_REQUEST["CLASS"], ENT_QUOTES) && htmlentities($_REQUEST["CYEAR"], ENT_QUOTES))
    {
     $year  = htmlentities($_REQUEST["CYEAR"], ENT_QUOTES);
     $display_class = $dbReport->getUcodeDesc(htmlentities($_REQUEST["CLASS"], ENT_QUOTES));
     $report_data = $dbReport->CommercialClassSales(htmlentities($_REQUEST["CLASS"], ENT_QUOTES)
                , htmlentities($_REQUEST["CYEAR"], ENT_QUOTES)
                , $county);
     $smarty->assign("data", $report_data);
     $smarty->assign("display_class", $display_class);
     $smarty->assign("pageTitle", ucfirst(strtolower($county))." County, Florida $display_class Property Sales Florida $year");
     $smarty->assign("pageDesc", "Location and sales data for  Florida $display_class property sales in $year.");
     $smarty->assign("cclass", "COMM");
     $smarty->assign("pageText",
     "This page shows location and sales data for ".ucfirst(strtolower($county))." County, Florida $display_class sales
     in $year. It displays sales data recorded in the Visulate database.
     The data was sourced from public records and is deemed reliable but not guaranteed.
     It should be independently verified. Click on a property address in the Sales Records table for additional details");

     $html_report = $smarty->display($template_prefix."-commercial-class.tpl");
    }
    else
     {
      $report_data = $dbReport->CommercialSales($county);
      $smarty->assign("commercialSummary", $report_data);
      $smarty->assign("pageTitle", "Commercial Property Sales ".ucfirst(strtolower($county))." County, Florida");
      $smarty->assign("pageDesc", "Commercial property sales data for ".ucfirst(strtolower($county))." County, Florida.
      Displays sales data recorded in the Visulate database and shows a breakdown by year of the
      number of properties sold, total sales volume and median price.");
      $smarty->assign("pageText",
      "This page shows commercial property sales data for ".ucfirst(strtolower($county))." County, Florida.
      It shows a breakdown by year of the  number of properties sold, total sales volume and median price.
      Click on a year in the ".ucfirst(strtolower($county))." Commercial Sales table for additional details");


      $html_report = $smarty->display($template_prefix."_city.tpl");
     }
   }

  function land_sales($smarty, $template_prefix, $dbReport)
  {

     if ($_GET['region_id'])
        $region_id    = htmlentities($_GET['region_id'], ENT_QUOTES);
     else
      $region_id = 0;

     $dbCity   = new RNTCities($smarty->connection);
     $regions = $dbCity->getRegions();
     $skey = get_skey($region_id, $regions);
     if ($skey == 0) $region_id = NULL;

     $submenu3 = get_region_submenu($regions);
     $smarty->assign("submenu2_1", $submenu3);
     $smarty->assign("skey", $skey);
     $smarty->assign("region_id", $region_id);

      if (htmlentities($_REQUEST["county"], ENT_QUOTES))
        $county = htmlentities($_REQUEST["county"], ENT_QUOTES);
      else
        $county = 'BREVARD';

      $smarty->assign('getState', 'FL');
      $smarty->assign('getCounty', $county);

      $dbSearch = new LISTSearch($smarty->connection);
      $searchList = $dbSearch->getCountyCities($county, 'FL');
      $smarty->assign('locations', $searchList);


    if (htmlentities($_REQUEST["YEAR"], ENT_QUOTES))
    {
     $year = htmlentities($_REQUEST["YEAR"], ENT_QUOTES);
     $report_data = $dbReport->LandSalesYear(htmlentities($_REQUEST["YEAR"], ENT_QUOTES), $county);
     $smarty->assign("data", $report_data);
     $smarty->assign("pageTitle", "$year Land Sales ".ucfirst(strtolower($county))." County, Florida");
     $smarty->assign("pageDesc", "Land Sales data for property sales in $year.");
     $smarty->assign("pageText",
     "This page shows land sales data for ".ucfirst(strtolower($county)).
     " County, Florida. It displays sales data recorded in the
     Visulate database and shows a breakdown by usage type of in $year
     The data was sourced from public records and is deemed reliable but not guaranteed.
     It should be independently verified. Click on the property class to see a breakdown of individual sales.");

     $html_report = $smarty->display($template_prefix."-land-year.tpl");
    }
    elseif (htmlentities($_REQUEST["CLASS"], ENT_QUOTES)
         && htmlentities($_REQUEST["CYEAR"], ENT_QUOTES))
    {
     $year  = htmlentities($_REQUEST["CYEAR"], ENT_QUOTES);
     $display_class = $dbReport->getUcodeDesc(htmlentities($_REQUEST["CLASS"], ENT_QUOTES));
     $report_data = $dbReport->CommercialClassSales(htmlentities($_REQUEST["CLASS"], ENT_QUOTES)
                                                  , htmlentities($_REQUEST["CYEAR"], ENT_QUOTES)
                                                  , $county);
     $smarty->assign("data", $report_data);
     $smarty->assign("display_class", $display_class);
     $smarty->assign("pageTitle", "$display_class Land Sales in $year for ".ucfirst(strtolower($county))." County, Florida");
     $smarty->assign("pageDesc", "Location and sales data for $display_class land sales in $year for "
     .ucfirst(strtolower($county))." County, Florida");
     $smarty->assign("pageText",
     "This page shows land sales data for $display_class land in ".ucfirst(strtolower($county)).
     " County, Florida. It displays data recorded in the Visulate database for sales in $year
     The data was sourced from public records and is deemed reliable but not guaranteed.
     It should be independently verified. Click on an address in the Sales Records table for additional details.");

     $smarty->assign("lclass", "LAND");
     $html_report = $smarty->display($template_prefix."-commercial-class.tpl");
    }
    else
    {
      $report_data = $dbReport->LandSales($county);
      $smarty->assign("landSales", $report_data);
      $smarty->assign("pageTitle", "Land Sales ".ucfirst(strtolower($county))." County, Florida");
      $smarty->assign("pageDesc",
      "Land sales data for ".ucfirst(strtolower($county))." County, Florida. Displays sales data recorded in the Visulate database and
      shows a breakdown by year of the number of properties sold, total sales volume and median price.");
      $smarty->assign("pageText",
      "This page shows land sales data for ".ucfirst(strtolower($county))." County, Florida.
      It displays sales data recorded in the Visulate database and
      shows a breakdown by year of the number of properties sold, total sales volume and median price.
      Click on a year in the ".ucfirst(strtolower($county))." Land Sales table for additional details");
      $html_report = $smarty->display($template_prefix."_city.tpl");
     }
  }
