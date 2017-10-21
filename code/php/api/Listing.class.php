<?php

require_once dirname(__FILE__) . "/../classes/SmartyInit.class.php";
require_once dirname(__FILE__) . "/../classes/database/pr_reports.class.php";
require_once dirname(__FILE__) . "/../classes/database/rnt_search.class.php";

require_once dirname(__FILE__) . "/../classes/UtlConvert.class.php";
require_once dirname(__FILE__) . "/../classes/SQLExceptionMessage.class.php";

class Listing {

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
        
        $property_details = $dbReport->getPropertyDetails($this->id);
        $report_data = $report_data = $dbReport->getMLS($this->id);
        switch ($this->resource) {
            case "details":
                echo json_encode(array_merge($property_details, array("LISTING" => $report_data)));
                break;
            
        }
    }

}
