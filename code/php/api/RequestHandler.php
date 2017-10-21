<?php

require_once dirname(__FILE__) . "/Property.class.php";
require_once dirname(__FILE__) . "/Corporation.class.php";
require_once dirname(__FILE__) . "/Listing.class.php";
require_once dirname(__FILE__) . "/VoiceInteraction.class.php";


header('Content-Type: application/json');

$method = $_SERVER['REQUEST_METHOD'];
$p1 = filter_input(INPUT_GET, "p1", FILTER_SANITIZE_ENCODED);
$p2 = filter_input(INPUT_GET, "p2", FILTER_SANITIZE_ENCODED);
$p3 = filter_input(INPUT_GET, "p3", FILTER_SANITIZE_ENCODED);
        
        
        
switch ($method) {
    case 'PUT':
        raise_error(404);
    case 'POST':
        switch ($p1) {
            case 'voice':
                $voiceInteraction = new VoiceInteraction($p2, $p3);
                $voiceInteraction->processRequest();
                break;
            default:
                raise_error(404);
        }
    case 'GET':
        switch ($p1) {
            case 'property':
                $property = new Property($p2, $p3);
                $property->processGetRequest();
                break;
            case 'corp':
                $corporation = new Corporation($p2, $p3);
                $corporation->processGetRequest();
                break;
            case 'mls':
                $listing = new Listing($p2, $p3);
                $listing->processGetRequest();
                break;
            default:
                raise_error(404);
        }
    case 'HEAD':
        exit();
    case 'DELETE':
        raise_error(404);
    case 'OPTIONS':
        header('Allow: OPTIONS, GET, HEAD');
        exit();
    default:
        raise_error(404);
}

function raise_error($status_code) {
    switch ($status_code) {
        case 404:
            http_response_code(404);
            echo '{ "name": "Not Found Exception", "message": "The requested resource was not found.", "code": 0, "status": 404}';
            exit();
    }
}
