<?
  require_once dirname(__FILE__)."/../classes/SmartyInit.class.php";
  require_once dirname(__FILE__).'/../classes/database/rnt_users.class.php';
  require_once dirname(__FILE__).'/../classes/UtlConvert.class.php';
  require_once dirname(__FILE__).'/../classes/SQLExceptionMessage.class.php';
  require_once dirname(__FILE__).'/../classes/database/rnt_business_units.class.php';
  require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
  require_once 'HTML/QuickForm.php';

  $smarty = new SmartyInit();

  if (!$smarty->user->isLogin())
       exit;

  if (!(  $smarty->user->isBusinessOwner())) {
     outError(
		       "You need to be a business owner to add partner relationships.  Please
		       contact the owner of the business unit that you want to update or
		       press the 'Change role' link at the top of this page and select 
		       'Business Owner'.");
     exit;
  }

  function outError($message){
    ?>
      <span style="color:red">
         <?=$message?>
      </span>
    <?
  }

  function outSuccess($user_id){
    ?>
      <span style="color:green">
         Successful update. Please reload page to see updated status.
      </span>
    <?
  }

   // set current user_id
  $smarty->user->set_database_user();
  $smarty->assign("role",  $smarty->user->getRole());

  // define variables
  $user_id = @$_REQUEST["user_id"];
  $business_id = @$_REQUEST["business_id"];
  $role_id = @$_REQUEST["role_id"];

  $dbUser = new RNTUser($smarty->connection);
  if (!$role_id || !$business_id || !$user_id){
      echo "Can not define variables";
  }

     // update database

    $IsError = 0;
    try
    {
        $dbUser->addAssignment(array("USER_ID"=>$user_id,
                                     "BUSINESS_ID"=>$business_id,
                                     "ROLE_ID" => $role_id));

        $smarty->connection->commit();
    }
    catch(SQLException $e)
    {
          $IsError = 1;
          $smarty->connection->rollback();
          $de =  new DatabaseError($smarty->connection);
          $a = $de->getErrorFromException($e);
          outError($a["short"]);
    }

  if (!$IsError)
      outSuccess($user_id);

  $smarty->connection->close();
?>
