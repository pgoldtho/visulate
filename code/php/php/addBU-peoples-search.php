<?php
    require_once dirname(__FILE__)."/../classes/SmartyInit.class.php";
    require_once dirname(__FILE__).'/../classes/database/rnt_peoples.class.php';
    require_once dirname(__FILE__).'/../classes/UtlConvert.class.php';
    require_once dirname(__FILE__).'/../classes/SQLExceptionMessage.class.php';
    require_once dirname(__FILE__).'/../classes/database/rnt_business_units.class.php';
    require_once dirname(__FILE__).'/../classes/database/rnt_leads.class.php';
    require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
    require_once 'HTML/QuickForm.php';

    $smarty = new SmartyInit();

    if ( ! $smarty->user->isLogin()) {
        exit;
    }

    if ( ! $smarty->user->isManager() && ! $smarty->user->isManagerOwner()) {
        exit;
    }

    // set current user_id
    $smarty->user->set_database_user();
    $smarty->assign("role",  $smarty->user->getRole());

    // define variables
    $people_id      = @$_REQUEST["people_id"];
    $business_id    = @$_REQUEST["business_id"];
    $inclusion_type = strtoupper(@$_REQUEST["inclusion_type"]);

    if (empty($people_id) || empty($business_id) || empty($inclusion_type)) {
        echo "Can not define variables";
        exit;
    }

    // update database
    $IsError = 0;

// if (FALSE) {
    try {
        $dbPeoples = new RNTPeoples($smarty->connection);
        if (! $dbPeoples->isExistsBU4People($business_id, $people_id)) {
            $dbPeoples->insertPeopleBU($business_id, $people_id);
        }

        if ('LEAD' == $inclusion_type) {
            // the Lead record should transfer to the new selected business unit.
            $dbLeads = new RNTLeads($smarty->connection);
            $dbLeads->transferLeadToOtherBU($people_id, $business_id);
        }
        elseif ('TENANT' == $inclusion_type) {
            // check agreements for business unit
            // add new tenant
        }
        $smarty->connection->commit();
    }
    catch(SQLException $e) {
        $IsError = 1;
        $smarty->connection->rollback();
        $de =  new DatabaseError($smarty->connection);
//        echo $de->getMessageInfo($e);
    }

    if ( ! $IsError) {
        $BU = new RNTBusinessUnit($smarty->connection);
        $d  = $BU->getBusinessUnit($business_id);
        if ($inclusion_type == 'TENANT')
        {
            echo "<span style=\"color:#aaaaaa\">".$d["BUSINESS_NAME"]."</span>";
        }
    }
// }

    $smarty->connection->close();
?>