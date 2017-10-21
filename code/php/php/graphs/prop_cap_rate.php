<?
  require_once dirname(__FILE__)."/../../classes/SmartyInit.class.php";
  require_once dirname(__FILE__).'/../../classes/database/rnt_business_units.class.php';
  require_once dirname(__FILE__).'/../../classes/database/rnt_summary_analysis.class.php';
  require_once dirname(__FILE__).'/../../classes/UtlConvert.class.php';
  require_once dirname(__FILE__).'/../../classes/SQLExceptionMessage.class.php';
  require_once dirname(__FILE__).'/../../jpgraph/jpgraph.php';
  require_once dirname(__FILE__).'/../../jpgraph/jpgraph_bar.php';

  $smarty = new SmartyInit();

  if (!$smarty->user->isLogin())
  {
       // goto login page
       header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."login.php");
       exit;
  }

  if ( !($smarty->user->isManager() || $smarty->user->isManagerOwner() || $smarty->user->isBookKeeping() || $smarty->user->isBusinessOwner() || $smarty->user->isOwner() ) )
  {
     header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
     exit;
  }

  $currentBUID = @$_REQUEST["BUSINESS_ID"];

   // set current user_id
  $smarty->user->set_database_user();

  $dbSum = new RNTSummaryAnalysis($smarty->connection);

  $cash_flow_data = $dbSum->getNOI($currentBUID);

  //Define data
  $graph_data = array("ADDRESS1" => array(),
                      "CAP_RATE_VALUE" => array()
                      );
  $maxValue = abs($cash_flow_data[0]["CAP_RATE_VALUE"]);
  foreach($cash_flow_data as $v) {
     $graph_data["ADDRESS1"][]  = $v["ADDRESS1"];
     $graph_data["CAP_RATE_VALUE"][]  = $v["CAP_RATE_VALUE"];
     if (abs($v["CAP_RATE_VALUE"]) > $maxValue)
        $maxValue = abs($v["CAP_RATE_VALUE"]);
  }

  if ($maxValue == 0)
    $maxValue = 1;

  $graph = new Graph(390, 300, "auto");
  $graph->SetScale("textlin", -1*$maxValue, $maxValue);
  $graph->Set90AndMargin(150,20,50,30);
  $graph->xaxis->SetTickLabels($graph_data["ADDRESS1"]);
  $graph->xaxis->SetLabelAlign('right','center','left');
  $graph->xaxis->SetLabelMargin(120);
  $graph->yaxis->SetLabelAlign('center','center');

  $graph->SetBackgroundGradient("white", "white");
  $graph->ygrid->SetLineStyle('dashed');
  $graph->ygrid->SetColor('#808080');

  $graph->xaxis->SetFont(FF_FONT0,FS_NORMAL);
  $graph->yaxis->SetFont(FF_FONT0,FS_NORMAL);

  $b1 = new BarPlot($graph_data["CAP_RATE_VALUE"]);
  $b1->SetFillColor("#012e5c");
  $b1->SetAbsWidth(10);
  $graph->Add($b1);

  $graph->Stroke();

  $smarty->connection->close();
?>
