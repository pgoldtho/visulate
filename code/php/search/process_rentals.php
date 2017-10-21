<?php
function process_rentals($smarty, $template_prefix)
  {
    if ($_GET['state'])
       $state     = htmlentities($_GET['state'], ENT_QUOTES);
    else
       $state = null;
    if ($_GET['county'])
        $county    = htmlentities($_GET['county'], ENT_QUOTES);
    else
      $county = null;
    if ($_GET['agreement'])
      $agreement = htmlentities($_GET['agreement'], ENT_QUOTES);
    else
      $agreement = null;

    $dbSearch = new LISTSearch($smarty->connection);

    if (($agreement=='ANY') or (is_null($agreement))) {
      if (is_null($state)){
        $searchList = $dbSearch->getStateCountList();
        }
      elseif($county=='ANY'){
        $searchList = $dbSearch->getCountyList($state);
        }
      else{
        $searchList = $dbSearch->getPropertyList($county, $state);
        }
      $smarty->assign('locations', $searchList);
      $smarty->assign("pageTitle", "Visulate Rental Property Search Results $state $county");
      $smarty->assign("pageDesc", "List of $state $county rental properties.");
      $smarty->display($template_prefix.'_search.tpl');
      }
    else{
       $searchList = $dbSearch->getPropertyList($county, $state);
       $property   = $dbSearch->getAgreement($agreement);
       foreach ($property as $a){
         $photos =  $dbSearch->getPhotos($a['PROPERTY_ID']);
         }
       $smarty->assign('locations', $searchList);
       $smarty->assign('agreement', $property);
       $smarty->assign('pictures', $photos);
       $smarty->assign("reportCode", "RENTALS");
       $smarty->assign("pageTitle", "Visulate Rental Property Search Result");
       $smarty->assign("pageDesc", "Property available for rent");
       $smarty->display($template_prefix.'_agreement.tpl');

      }
      return;
    }
