<?
  require_once dirname(__FILE__)."/../classes/SmartyInit.class.php";
  require_once dirname(__FILE__).'/../classes/database/rnt_supplier.class.php';
  require_once dirname(__FILE__).'/../classes/database/rnt_business_units.class.php';
  require_once dirname(__FILE__).'/../classes/UtlConvert.class.php';
  require_once dirname(__FILE__).'/../classes/SQLExceptionMessage.class.php';
  require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
  require_once 'HTML/QuickForm.php';

  $smarty = new SmartyInit();

  if (!$smarty->user->isLogin())
       exit;

  if (!$smarty->user->isManager() && !$smarty->user->isManagerOwner())
     exit;

  $searchString = @$_POST["value"];

  if (!$searchString){
    echo "<b>Search string not specified.</b>";
    exit;
  }

   // set current user_id
  $smarty->user->set_database_user();
  $smarty->assign("role",  $smarty->user->getRole());
  $dbSupplier = new RNTSupplier($smarty->connection);
  $find = $dbSupplier->findList($searchString);

  if (count($find) == 0 )
    echo "<b>No records found</b>";
  else {
    echo "<ul>";
    foreach($find as $v){
       echo "<li><a class=\"s\" href=\"?m2=property_supplier&SUPPLIER_ID=".$v["SUPPLIER_ID"]."\">";
       $x = "";
       foreach($v as $k=>$v1)
          if ($k != "SUPPLIER_ID" && $v1){
             echo $x.$v1;
             $x = ", ";
          }
        echo "</a></li>";
    }
    echo "</ul>";
  }


  $smarty->connection->close();
?>