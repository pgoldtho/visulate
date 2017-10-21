<?
  require_once dirname(__FILE__)."/../classes/SmartyInit.class.php";
  require_once dirname(__FILE__).'/../classes/database/rnt_section8.class.php';
  require_once dirname(__FILE__).'/../classes/UtlConvert.class.php';
  require_once dirname(__FILE__).'/../classes/SQLExceptionMessage.class.php';
  require_once dirname(__FILE__).'/../classes/database/rnt_business_units.class.php';
  require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
  require_once 'HTML/QuickForm.php';

  $smarty = new SmartyInit();

  if (!$smarty->user->isLogin())
       exit;

  if (!$smarty->user->isManager() && !$smarty->user->isManagerOwner())
     exit;

  function echoBusinessName($business_id, $connection){
      $BU = new RNTBusinessUnit($connection);
      $d = $BU->getBusinessUnit($business_id);
      echo "<span style=\"color:#aaaaaa\">".$d["BUSINESS_NAME"]."</span>";
  }

   // set current user_id
  $smarty->user->set_database_user();
  $smarty->assign("role",  $smarty->user->getRole());

  // define variables
  $section8_id = @$_REQUEST["section8_id"];
  $business_id = @$_REQUEST["business_id"];

  $dbSection8 = new RNTSection8($smarty->connection);
  if (!$section8_id || !$business_id){
      echo "Can not define variables";
  }

  // update database
  if ($dbSection8->isExistsBU4Section8($business_id, $section8_id))
      echoBusinessName($business_id, $smarty->connection);
  else{
     // update database

    $IsError = 0;
    try
    {
        $dbSection8->insertOfficesBU($business_id, $section8_id);

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
       echoBusinessName($business_id, $smarty->connection);

  }

  $smarty->connection->close();
?>
