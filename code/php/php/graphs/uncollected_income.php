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

  $cash_flow_data = $dbSum->getUncollectedIncome($currentBUID);

  //Define data
  $graph_data = array("MONTH_NAME" => array(), "UNCOLLECTED_INCOME" => array());
  foreach($cash_flow_data as $v) {
     $graph_data["MONTH_NAME"][] = $v["MONTH_NAME"];
     $graph_data["UNCOLLECTED_INCOME"][] = $v["UNCOLLECTED_INCOME"];
  }

  $graph = new Graph(390, 300);
  $graph->setScale("textlin", 0, 0);
  $graph->SetBackgroundGradient("white", "white");
  // set legend attributes
  $graph->legend->SetFillColor('white');
  $graph->legend->SetShadow(0);
  $graph->legend->SetColor("#404040");
  $graph->legend->Pos(0.05,0.01);
  $graph->ygrid->SetLineStyle('dashed');
  $graph->ygrid->SetColor('#808080');

  $graph->xaxis->SetFont(FF_FONT0,FS_NORMAL);
  $graph->yaxis->SetFont(FF_FONT0,FS_NORMAL);
  $graph->xaxis->SetTickLabels($graph_data["MONTH_NAME"]);
  $graph->legend->SetFont(FF_FONT0,FS_NORMAL);

  $b1 = new BarPlot($graph_data["UNCOLLECTED_INCOME"]);
  $b1->SetFillColor("#012e5c");
  $b1->SetAbsWidth(10);
  $b1->SetAlign("left");
  $graph->Add($b1);
  $graph->Stroke();

  $smarty->connection->close();
?>
