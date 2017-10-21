<?
 require_once dirname(__FILE__)."/../classes/database/pr_reports.class.php";
 require_once dirname(__FILE__)."/../php/PropertyEstimatesDownloader.php";
 require_once dirname(__FILE__)."/../classes/SmartyInit.class.php";

  $smarty = new SmartyInit('http');
  $dbReport = new PRReports($smarty->connection);
  $prop_id = htmlentities($_REQUEST["PROP_ID"], ENT_QUOTES);
  $rent    = htmlentities($_REQUEST["RENT"], ENT_QUOTES);

  if (is_numeric($prop_id))
    $report_data = $dbReport->getPropertyDetails($prop_id);
  else
    exit;
  if ($report_data["PROPERTY"]["ADDRESS1"] == "1600 Pennsylvania Avenue NW")
    exit;

  
  $ucode = 90001;
  foreach ($report_data["PROPERTY_USAGE"] as $k => $v)
   { $ucode = $k; }
  $default_values = $dbReport->getDefaults($prop_id, $ucode);
  $pclass     = $default_values["A"]["PCLASS"];


  foreach ($default_values as $k => $v){

        $default_values[$k]["NOI"] = round(($default_values[$k]["ANNUAL_RENT"] - $default_values[$k]["VACANCY_AMOUNT"]
                               - $default_values[$k]["INSURANCE"] - $default_values[$k]["MAINTENANCE"]
                                                   - $default_values[$k]["UTILITIES"]
                                                                   - $default_values[$k]["TAX"] - $default_values[$k]["MGT_AMOUNT"]));
                        $default_values[$k]["VALUE"] = round($default_values[$k]["NOI"] / $default_values[$k]["CAP_RATE"] * 100);
        $default_values[$k]["DOWN"] = round($default_values[$k]["VALUE"] * 25/100);
        $default_values[$k]["LOAN"] = round($default_values[$k]["VALUE"] * 75/100);
        $default_values[$k]["COSTS"] = round($default_values[$k]["VALUE"] * 4/100);
      }

  $propertyData = array( "PROP_ADDRESS1"      => $report_data["PROPERTY"]["ADDRESS1"]
                       , "PROP_ADDRESS2"      => $report_data["PROPERTY"]["ADDRESS2"]
                       , "PROP_CITY"          => $report_data["PROPERTY"]["CITY"]
                       , "PROP_STATE"         => $report_data["PROPERTY"]["STATE"]
                       , "PROP_STATE_NAME"    => ""
                       , "PROP_ZIPCODE"       => $report_data["PROPERTY"]["ZIPCODE"]
                       , "PROP_YEAR_BUILT"    => $report_data["PROPERTY"]["YEAR_BUILT"]
                       , "PROP_BUILDING_SIZE" => $report_data["PROPERTY"]["SQ_FT"]
                       , "PROP_LOT_SIZE"      => $report_data["PROPERTY"]["ACREAGE"]
                       , "PROP_DESCRIPTION"   => ""
                       , "PROP_PROP_ID"       => $prop_id);

  if (is_numeric($rent))
    $default_values[$pclass]["MONTHLY_RENT"] = $rent;


  $estimate = array( "MONTHLY_RENT"    => $default_values[$pclass]["MONTHLY_RENT"]
                   , "OTHER_INCOME"    => 0
                   , "VACANCY_PCT"     => $default_values[$pclass]["VACANCY_PERCENT"]
                   , "REPLACE_3YEARS"  => 0
                   , "REPLACE_5YEARS"  => 0
                   , "REPLACE_12YEARS" => 0
                   , "MAINTENANCE"     => $default_values[$pclass]["MAINTENANCE"]
                   , "UTILITIES"       => $default_values[$pclass]["UTILITIES"]
                   , "PROPERTY_TAXES"  => $default_values[$pclass]["TAX"]
                   , "INSURANCE"       => $default_values[$pclass]["INSURANCE"]
                   , "MGT_FEES"        => $default_values[$pclass]["MGT_AMOUNT"]
                   , "DOWN_PAYMENT"    => $default_values[$pclass]["DOWN"]
                   , "CLOSING_COSTS"   => $default_values[$pclass]["COSTS"]
                   , "PURCHASE_PRICE"  => $default_values[$pclass]["VALUE"]
                   , "CAP_RATE"        => $default_values[$pclass]["CAP_RATE"]
                   , "LOAN1_AMOUNT"    => $default_values[$pclass]["LOAN"]
                   , "LOAN1_TYPE"      => 'Amortizing'
                   , "LOAN1_TERM"      => 30
                   , "LOAN1_RATE"      => 5
                   , "LOAN2_AMOUNT"    => 0
                   , "LOAN2_TYPE"      => 'Interest Only'
                   , "LOAN2_TERM"      => ""
                   , "LOAN2_RATE"      => 8 );

  $propertyData['PROP_ESTIMATE'] = $estimate;
  
  $template_spreadsheet = realpath(TEMPLATE_DIR.'/').'/'.'single_property2.xls';
  $aPropertyDownloader  = new PropertyEstimatesDownloader($template_spreadsheet, $propertyData);
  $aPropertyDownloader->getXLS();
?>