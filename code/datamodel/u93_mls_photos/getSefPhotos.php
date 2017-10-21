<?php
    require_once("phrets.php");
    require_once dirname(__FILE__)."/../../visulate/visulate/code/php/classes/SmartyInit.class.php";
    require_once dirname(__FILE__)."/../../visulate/visulate/code/php/classes/database/rnt_search.class.php";
    require_once dirname(__FILE__)."/../../visulate/visulate/code/php/classes/UtlConvert.class.php";
    require_once dirname(__FILE__)."/../../visulate/visulate/code/php/classes/SQLExceptionMessage.class.php";

    $image_directory = "/home/pgoldtho/rntmgr/images/mls";
    $source_id = 8;

    $smarty = new SmartyInit('http');
    $dbReport = new LISTSearch($smarty->connection);

    $credentials = $dbReport->getMlsCredentials($source_id);
    $rets_login_url = $credentials["RETS_LOGIN_URL"];
    $rets_username = $credentials["RETS_USERNAME"];
    $rets_password = $credentials["RETS_PASSWORD"];


    $listings = $dbReport->getMlsNumbers($source_id, 'ACTIVE' );
   
    $rets = new phRETS;
    $rets->SetParam("offset_support", true);
    $rets->AddHeader("User-Agent", $rets_username);

    $connect = $rets->Connect($rets_login_url, $rets_username, $rets_password, $rets_password);

    if (!($connect)){
      print_r($rets->Error());
      exit;
    }

    foreach ($listings as $mlsNumber){

      $current_photos = count(glob("$image_directory/$source_id/$mlsNumber*.jpg"));
      $required_photos = $dbReport->countMlsPhotos($source_id, $mlsNumber);

      
      if ($current_photos != $required_photos)
      {
        $photos = $rets->GetObject("Property", "Photo", $mlsNumber, "*", 0);
        foreach ($photos as $photo) {
           if ($photo['Success'] == true) {
               file_put_contents("$image_directory/$source_id/{$photo['Content-ID']}-{$photo['Object-ID']}.jpg", $photo['Data']);
           }
        }
       }
      }
        
    $rets->Disconnect();

    $expired_listings = $dbReport->getMlsNumbers($source_id,  'INACTIVE' );
    foreach ($expired_listings as $mlsNumber){

      foreach (glob("$image_directory/$source_id/$mlsNumber*.jpg") as $filename) {
         echo "$filename size " . filesize($filename) . "\n";
         unlink($filename);
      }

    }

?>