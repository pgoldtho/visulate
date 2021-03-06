<?php
 function htp_get($path)
  {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL,$path);
        curl_setopt($ch, CURLOPT_FAILONERROR,1);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION,1);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);
        curl_setopt($ch, CURLOPT_TIMEOUT, 15);
        $retValue = curl_exec($ch);
        curl_close($ch);
        return $retValue;
  }

function process_search($smarty, $template_prefix)
  {
   $dbSearch = new LISTSearch($smarty->connection);
           if ($_POST["ADDRESS1"])
            {
             $smarty->assign("PrmAddress1", $_POST["ADDRESS1"]);
             $smarty->assign("PrmCity", $_POST["CITY"]);
             $smarty->assign("PrmAddr", $_POST["ADDR"]);

             $report_data = $dbSearch->getStreetAddress( $_POST["ADDRESS1"], $_POST["CITY"]);
             $report_file = "owner-list";
             $smarty->assign("data", $report_data);
             }
            elseif (($_POST["LAT"])&&($_POST["LON"]))
             {
              $lat  = htmlentities($_POST["LAT"], ENT_QUOTES);
              $long = htmlentities($_POST["LON"], ENT_QUOTES);

             }
             elseif (($_GET["lat"])&&($_GET["lon"])){
                 $lat  = htmlentities($_GET["lat"], ENT_QUOTES, 'UTF-8');
                 $long = htmlentities($_GET["lon"], ENT_QUOTES, 'UTF-8');
               }
            else
             {
              if ($_GET['q']){
                 $addr    = htmlentities($_GET['q'], ENT_QUOTES);}
              else{
                 $addr = htmlentities($_POST["ADDR"], ENT_QUOTES, 'UTF-8');
                 }
              $display_address = $addr;
              $addr = urlencode($addr);

              $url = "http://maps.googleapis.com/maps/api/geocode/xml?address=".$addr."&sensor=false";
              $response = htp_get($url);
              $xmap = simplexml_load_string($response);
              $lat =  (float) $xmap->result->geometry->location->lat;
              $long = (float) $xmap->result->geometry->location->lng;

              if (!(strlen($lat) > 0)) //Request to Google Maps API failed
               {
                $url = $GLOBALS["HTTP_PATH_FROM_ROOT"]."/cgi-bin/geocode.cgi?address=".$addr;
                $response = htp_get($url);
                $xmap = simplexml_load_string($response);
                $lat =  (float) $xmap->lat;
                $long = (float) $xmap->lon;
                }
              }

         $message = '';
         if (MAINTENANCE_MODE == "Y")
         {
          $message = "<b class='error'>Visulate's property search feature is not currently available.  We are performing routine maintenance.</b>";
         }

         if ((strlen($lat) > 0) &&
             (strlen($long) > 0) &&
             (MAINTENANCE_MODE != "Y") &&
             (is_numeric($lat)) &&
             (is_numeric($long)) &&
             (($lat > 24) && ($lat < 32)) &&
             (($long < -79) && ($long > -87.85))
             )
           {

               $dbCity   = new RNTCities($smarty->connection);
              
               $dbReport = new PRReports($smarty->connection);
               $listings = $dbSearch->getGeoLocProperties($lat, $long);
               $companies = $dbSearch->getGeoCorp($lat, $long);
               $city = $dbCity->getGeoCity($lat, $long);
               $mls_listings = $dbReport->getGeoListings( $lat, $long);

               $streetview = $dbReport->get_streetview_url($lat, $long);
               $smarty->assign("streetview", $streetview);


//               print_r($mls_listings);
               if (count($listings) > 0)
                   {$smarty->assign('listings', $listings);
                    $puma = $dbSearch->getPumaSummary($listings[0]["PUMA"]);}
               if (count($companies) > 0)
                   {$smarty->assign('companies', $companies);}
               if (count($mls_listings) > 0)
                   {$smarty->assign('mls_listings', $mls_listings);}
               if ($puma)
                   {$smarty->assign('puma', $puma);}

               $message = $message.count($listings)." properties and ".count($companies)." companies were found within 150 meters of this location";

               $smarty->assign('lat', $lat);
               $smarty->assign('lon', $long);
               $smarty->assign('city', $city);
            }
          else{
               if (strlen($addr) > 0)
                {
                 $message = " Visulate didn't find the location ".$display_address."<br/>
                 <b class='error'>Enter <i>street address, city, state</i> or <i>street address, ZIP code</i>.</b><br/>
                 or try using the Google search box below.";
                }
               }

       $dbCity   = new RNTCities($smarty->connection);
       $backgroundImg = $dbCity->getRandomImage();
       $smarty->assign("backgroundImg", $backgroundImg);

       $smarty->assign("PrmAddr", $display_address);
       $smarty->assign("pageTitle", "Visulate - Search Florida Real Estate");
       $smarty->assign("pageDesc", "Search Visulate's database of more than 8 million properties and 1.7 million companies in Florida");
       $smarty->assign("message", $message);
       $html_report = $smarty->display($template_prefix."-property-list.tpl");
   }