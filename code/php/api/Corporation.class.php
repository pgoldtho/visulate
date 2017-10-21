<?php

require_once dirname(__FILE__) . "/../classes/SmartyInit.class.php";
require_once dirname(__FILE__) . "/../classes/database/pr_reports.class.php";
require_once dirname(__FILE__) . "/../classes/database/rnt_search.class.php";

require_once dirname(__FILE__) . "/../classes/UtlConvert.class.php";
require_once dirname(__FILE__) . "/../classes/SQLExceptionMessage.class.php";

class Corporation {

    private $resource;
    private $id;

    public function __construct($resource, $id) {
        $this->resource = $resource;
        $this->id = $id;
    }

    public function processGetRequest() {

        $smarty = new SmartyInit('http');
        $dbReport = new PRReports($smarty->connection);
        //    $dbSearch = new LISTSearch($smarty->connection);

        $report_data = $report_data = $dbReport->getCorpDetails($this->id);
        switch ($this->resource) {
            case "details":
                echo json_encode($report_data);
                break;
            case "streetview":
                $lat = $report_data["SUNBIZ-ID"]["ADDR"]["LAT"];
                $long = $report_data["SUNBIZ-ID"]["ADDR"]["LON"];
                if (($lat) && ($long)) {
                    $streetview = $dbReport->get_streetview_url($lat, $long);
                    echo json_encode($streetview);
                } else {
                    echo "streetview not available";
                }
                break;
        }
    }

}
