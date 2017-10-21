<?php
function find_agent($smarty, $template_prefix, $dbReport)
  {
     $license = htmlentities($_REQUEST["LICENSE"], ENT_QUOTES);
     if ($license)
       {
        $report_data = $dbReport->getAgent($license);
        $smarty->assign("agent", $report_data);

        if ($report_data["LICENSE_TYPE"]=='CQ RE Corp.'){
         $smarty->assign("pageTitle", "Florida Real Estate Office: ".$report_data["NAME"]);
         $smarty->assign("pageDesc", $report_data["FIRST_NAME"]." ".$report_data["LAST_NAME"]." is a real estate office in ".$report_data["CITY"]
                        .", ".$report_data["STATE"]);
         }
         else{
         $smarty->assign("pageTitle", "Florida Real Estate Professional: ".$report_data["NAME"]);
         $smarty->assign("pageDesc", $report_data["FIRST_NAME"]." ".$report_data["LAST_NAME"]." is a real estate professional based in ".$report_data["CITY"]
                        .", ".$report_data["STATE"]);
         }
       }
     else
       {
        $zipcode = htmlentities($_REQUEST["ZIPCODE"], ENT_QUOTES);
        if (! is_numeric($zipcode)) $zipcode = 32952;
        $zipdata = $dbReport->getZipcodeData($zipcode);
        $report_data = $dbReport->getCourses($zipcode);
        $smarty->assign("data", $report_data);
        $smarty->assign("zipcode", $zipcode);
        $smarty->assign("zipdata", $zipdata);

        $course = htmlentities($_REQUEST["COURSE"], ENT_QUOTES);
        if ($course)
          {
           $report_data = $dbReport->getAgentList($zipcode, $course);
           $smarty->assign("agentdata", $report_data);
          }

        $smarty->assign("pageTitle", "Find Real Estate Professionals by Training Course for Zipcode $zipcode");
        $smarty->assign("pageDesc", "List of training courses attended by real estate professionals in zipcode $zipcode");
       }
     $html_report = $smarty->display($template_prefix."-agent-zipcode.tpl");
   }