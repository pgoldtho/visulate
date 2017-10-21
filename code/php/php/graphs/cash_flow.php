<?
  require_once dirname(__FILE__)."/../../classes/SmartyInit.class.php";
  require_once dirname(__FILE__).'/../../classes/database/rnt_business_units.class.php';
  require_once dirname(__FILE__).'/../../classes/database/rnt_summary_analysis.class.php';
  require_once dirname(__FILE__).'/../../classes/UtlConvert.class.php';
  require_once dirname(__FILE__).'/../../classes/SQLExceptionMessage.class.php';
  require_once dirname(__FILE__).'/../../jpgraph/jpgraph.php';
  require_once dirname(__FILE__).'/../../jpgraph/jpgraph_line.php';

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

  $cash_flow_data = $dbSum->getCashFlow($currentBUID);

  //Define data
  $graph_data = array("MONTH_NAME" => array(),
                      "INCOME_AMOUNT" => array(),
                      "EXPENSE_AMOUNT" => array(),
                      "CASH_FLOW" => array()
                      );
  foreach($cash_flow_data as $v) {
     $graph_data["MONTH_NAME"][]  = $v["MONTH_NAME"];
     $graph_data["INCOME_AMOUNT"][]  = $v["INCOME_AMOUNT"];
     $graph_data["EXPENSE_AMOUNT"][]  = $v["EXPENSE_AMOUNT"];
     $graph_data["CASH_FLOW"][]  = $v["CASH_FLOW"];
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

  // incoming
  $p1 = new LinePlot($graph_data["INCOME_AMOUNT"]);
  $p1->SetWeight(1);
  $p1->SetColor("green");
  $p1->mark->SetType(MARK_SQUARE);
  $p1->mark->SetFillColor("green");
  $p1->SetLegend("Income");
  $graph->Add($p1);
  // expese
  $p2 = new LinePlot($graph_data["EXPENSE_AMOUNT"]);
  $p2->SetWeight(1);
  $p2->SetColor("red");
  $p2->mark->SetType(MARK_UTRIANGLE);
  $p2->mark->SetFillColor("red");
  $p2->SetLegend("Expense");
  $graph->Add($p2);
  // cash flow
  $p3 = new LinePlot($graph_data["CASH_FLOW"]);
  $p3->SetWeight(1);
  $p3->SetColor("orange");
  $p3->mark->SetColor("orange");
  $p3->mark->SetType(MARK_DIAMOND);
  $p3->mark->SetFillColor("orange");
  $p3->SetLegend("Cash Flow");
  $graph->Add($p3);

  $graph->Stroke();

  $smarty->connection->close();
?>
