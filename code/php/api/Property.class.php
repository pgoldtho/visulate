<?php

///namespace api\property;

require_once dirname(__FILE__) . "/../classes/SmartyInit.class.php";
require_once dirname(__FILE__) . "/../classes/database/pr_reports.class.php";
require_once dirname(__FILE__) . "/../classes/database/rnt_search.class.php";

require_once dirname(__FILE__) . "/../classes/UtlConvert.class.php";
require_once dirname(__FILE__) . "/../classes/SQLExceptionMessage.class.php";

class Property {

    private $resource;
    private $id;

    public function __construct($resource, $id) {
        $this->resource = $resource;
        $this->id = $id;
    }

    public function processGetRequest() {

        $smarty = new SmartyInit('http');
        $dbReport = new PRReports($smarty->connection);
        $dbSearch = new LISTSearch($smarty->connection);

        $property_details = $dbReport->getPropertyDetails($this->id);
        switch ($this->resource) {
            case "details":
                echo json_encode($property_details);
                break;
            case "value":
                $ucode = 90001;
                foreach ($property_details["PROPERTY_USAGE"] as $k => $v) {
                    $ucode = $k;
                    $usage = $v;
                }
                $prop_class = $property_details["PROPERTY"]["PROP_CLASS"];
                $report_data = $dbReport->getDefaults($this->id, $ucode);

                if ($property_details["PROPERTY"]["PUMA"]) {
                    $puma = $dbSearch->getPumaSummary($property_details["PROPERTY"]["PUMA"]);
                }
                echo json_encode(array_merge($report_data[$prop_class],  $puma));
              //   echo json_encode($puma);
                break;
            case "streetview":
                $streetview_url = $dbReport->get_streetview_url($property_details["PROPERTY"]["LAT"], $property_details["PROPERTY"]["LON"]);
                echo $streetview_url;
                break;
        }
    }

}
