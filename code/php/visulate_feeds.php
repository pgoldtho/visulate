<?php
    require_once dirname(__FILE__)."/classes/SmartyInit.class.php";
    require_once dirname(__FILE__)."/classes/database/rnt_search.class.php";
    require_once dirname(__FILE__)."/classes/UtlConvert.class.php";
    require_once dirname(__FILE__)."/classes/SQLExceptionMessage.class.php";
    require_once dirname(__FILE__)."/classes/database/pr_reports.class.php";  
    require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
    require_once "HTML/QuickForm.php";
    $smarty = new SmartyInit('http');
    $dbReport = new LISTSearch($smarty->connection);
    $report_code = @$_REQUEST["REPORT_CODE"];
  if ($report_code == "RENTALS")
    {
       $listings = $dbReport->getRentalFeed();

       $smarty->assign('listings', $listings);		
       $smarty->assign('feedTitle', "Visulate Rental Properties");
       $smarty->assign('feedDesc', "Rental properties advertised on the Visulate website");
       $smarty->display('visulate-rental-feed.tpl');
      }
  elseif ($report_code == "SALES")
    {
       $listings = $dbReport->getSalesFeed();

       $smarty->assign('listings', $listings);		
       $smarty->assign('photos', $photos);		
       $smarty->assign('feedTitle', "Investment Properties for Sale");
       $smarty->assign('feedDesc', "Commercial and Investment properties advertised for sale on the Visulate website");
       $smarty->display('visulate-listing-feed.tpl');
    }
  elseif ($report_code == "SITE_MAP")
    {  header('Content-Type: application/xml');
       $listings = $dbReport->getSiteMap(@$_REQUEST["MAP_LEVEL"]);
       $smarty->assign('listings', $listings);		
       $smarty->display('sitemap.tpl');
    }
  elseif ($report_code == "GEOLOC")
    {
	   $lat = htmlentities(@$_REQUEST["LAT"], ENT_QUOTES);
	   $long = htmlentities(@$_REQUEST["LONG"], ENT_QUOTES);
	   if ($lat && $long)
	     {
	     $listings = $dbReport->getGeoLocProperties($lat, $long);
		 if (count($listings) > 0)
		   {
	       $smarty->assign('listings', $listings);
		   }
		 else
           {
		   $smarty->assign('lat', $lat);
		   $smarty->assign('long', $long);
		   }
 
         $smarty->assign('feedTitle', "Visulate Property Records");
         $smarty->assign('feedDesc', "Properties Close to Location $lat, $long");
         $smarty->display('visulate-gmap-feed.tpl');
		 }
	}
?>