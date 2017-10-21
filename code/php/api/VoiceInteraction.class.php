<?php

require_once dirname(__FILE__) . "/../classes/SmartyInit.class.php";
require_once dirname(__FILE__) . "/../classes/database/pr_reports.class.php";
require_once dirname(__FILE__) . "/../classes/database/rnt_search.class.php";

require_once dirname(__FILE__) . "/../classes/UtlConvert.class.php";
require_once dirname(__FILE__) . "/../classes/SQLExceptionMessage.class.php";

class VoiceInteraction {

    private $topic;
    private $requestType;

    public function __construct($topic, $requestType) {
        $this->topic = $topic;
        $this->requestType = $requestType;
    }

    function htp_get($path) {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $path);
        curl_setopt($ch, CURLOPT_FAILONERROR, 1);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_TIMEOUT, 15);
        $retValue = curl_exec($ch);
        curl_close($ch);
        return $retValue;
    }
    
    function geocodeAddress($address) {
        $coordinates["lat"] = 0;
        $coordinates["long"] = 0;
        
        $addr = urlencode($address);
        echo json_encode($addr);
        
        $url = "http://maps.googleapis.com/maps/api/geocode/xml?address=" . $addr . "&sensor=false";
        $response = $this->htp_get($url);
        $xmap = simplexml_load_string($response);
        $coordinates["lat"] = (float) $xmap->result->geometry->location->lat;
        $coordinates["long"] = (float) $xmap->result->geometry->location->lng;

        if (!(strlen($coordinates["lat"]) > 0)) { //Request to Google Maps API failed
            $url = $GLOBALS["HTTP_PATH_FROM_ROOT"] . "https://visulate.com/cgi-bin/geocode.cgi?address=" . $addr;
            $response = htp_get($url);
            $xmap = simplexml_load_string($response);
            $coordinates["lat"] = (float) $xmap->lat;
            $coordinates["long"] = (float) $xmap->lon;
        }
        return $coordinates;
    }

    public function processRequest() {
        header('Content-Type: application/json');
        ob_start();
        $json = file_get_contents('php://input');
        $request = json_decode($json, true);
        $action = $request["result"]["action"];
        $parameters = $request["result"]["parameters"];


        $param1value = $parameters["address"];
        $param2value = $parameters["geo-city"];
        
        $mapCoordinates = $this->geocodeAddress($param1value . "+" . $param2value . "+Florida" );
        
        $smarty = new SmartyInit('http');
        $dbSearch = new LISTSearch($smarty->connection);
        $dbReport = new PRReports($smarty->connection);
        
        $properties = $dbSearch->getGeoLocProperties($mapCoordinates["lat"], $mapCoordinates["long"]);
        
        $propId = $properties[0]["PROP_ID"];
        
        if ($propId > 0) {
            $prop = $dbReport->getPropSummary($propId);
           // file_put_contents('/tmp/voice.txt', print_r($prop, true));
            $outputtext = $prop;
        } else {
            $outputtext = "I'm Sorry. I wasn't able to find anything for that address.";
        }

        $output["contextOut"] = array(array("name" => "$action-context", "parameters" =>
                array("param1" => $param1value, "param2" => $param2value)));
        $output["speech"] = $outputtext;
        $output["displayText"] = $outputtext;
        $output["source"] = "Visulate";
        ob_end_clean();

        echo json_encode($output);
        exit();
    }
}
