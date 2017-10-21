<?php
  function get_region_submenu($regionList)
  {
    $href = $GLOBALS["PATH_FORM_ROOT"]."visulate_search.php?REPORT_CODE=CITY&state=FL";
    $submenu = array();
    $submenu[] = array("href" => $href,
                       "value"=> "All");


    foreach($regionList as $region)
      {
      $submenu[] = array("href" => $href."&region_id=".$region["REGION_ID"],
                         "value"=> $region["NAME"]);
      }
    return $submenu;
   }

  function get_skey($region_id, $regions)
  {
    if ($region_id == 0) $skey = 0;
    elseif ($region_id == $regions[0][REGION_ID]) $skey = 1;
    elseif ($region_id == $regions[1][REGION_ID]) $skey = 2;
    elseif ($region_id == $regions[2][REGION_ID]) $skey = 3;
    elseif ($region_id == $regions[3][REGION_ID]) $skey = 4;
    elseif ($region_id == $regions[4][REGION_ID]) $skey = 5;
    elseif ($region_id == $regions[5][REGION_ID]) $skey = 6;
    elseif ($region_id == $regions[6][REGION_ID]) $skey = 7;
    elseif ($region_id == $regions[7][REGION_ID]) $skey = 8;
    elseif ($region_id == $regions[8][REGION_ID]) $skey = 9;
    elseif ($region_id == $regions[9][REGION_ID]) $skey = 10;
    else  $skey = 0;

    return $skey;
   }