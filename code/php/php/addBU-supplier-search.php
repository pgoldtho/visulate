<?
  require_once dirname(__FILE__)."/../classes/SmartyInit.class.php";
  require_once dirname(__FILE__).'/../classes/database/rnt_supplier.class.php';
  require_once dirname(__FILE__).'/../classes/UtlConvert.class.php';
  require_once dirname(__FILE__).'/../classes/SQLExceptionMessage.class.php';
  require_once dirname(__FILE__).'/../classes/database/rnt_business_units.class.php';
  require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
  require_once 'HTML/QuickForm.php';

  $smarty = new SmartyInit();

  if (!$smarty->user->isLogin())
       exit;

  if (!$smarty->user->isManager() && !$smarty->user->isManagerOwner() && !$smarty->user->isOwner() && !$smarty->user->isBusinessOwner())
     exit;

  function echoBusinessName($business_id, $supplier_id, $dbSupplier){
      $d = $dbSupplier->getSearchBusinessUnit($business_id, $supplier_id);
      echo "<span style=\"color:#aaaaaa\">".$d["BUSINESS_NAME"].", Tax: ".$d["TAX_IDENTIFIER"]."</span>";
  }

   // set current user_id
  $smarty->user->set_database_user();
  $smarty->assign("role",  $smarty->user->getRole());

  // define variables
  $supplier_id = @$_REQUEST["supplier_id"];
  $business_id = @$_REQUEST["business_id"];
  $tax = @$_REQUEST["taxValue"];

  $dbSupplier = new RNTSupplier($smarty->connection);
  if (!$supplier_id || !$business_id){
      echo "Can not define variables";
  }

  // update database
  if ($dbSupplier->isExistsBU4Supplier($business_id, $supplier_id))
      echoBusinessName($business_id, $supplier_id, $dbSupplier);
  else{
     // update database

    $IsError = 0;
    try
    {
        $values = array(array("BUSINESS_ID"    =>$business_id,
                              "SUPPLIER_ID"    =>$supplier_id,
                              "TAX_IDENTIFIER" =>$tax,
                              "NOTES"          => ""));
        $dbSupplier->UpdateBusinessUnits($values, $supplier_id);

        $smarty->connection->commit();
    }
    catch(SQLException $e)
    {
          $IsError = 1;
          $smarty->connection->rollback();
          $de =  new DatabaseError($smarty->connection);
          echo $de->getMessageInfo($e);
    }

    if (!$IsError)
      echoBusinessName($business_id, $supplier_id, $dbSupplier);
  }

  $smarty->connection->close();
?>
