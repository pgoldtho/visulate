<?php
require_once dirname(__FILE__)."/../LOV.class.php";
require_once dirname(__FILE__)."/../UtlConvert.class.php";
require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
require_once dirname(__FILE__)."/rnt_base.class.php";

class RNTLeadActions extends RNTBase
{
    public function __construct($connection)
    {
         parent::__construct($connection);
    }

    /**
     * Insert action info.
     *
     * @param  array $info
     * @return int
     */
    private function insertLeadAction(array $info)
    {
        // construct statement
        $statement = $this->connection->prepareStatement(
            "begin :var1 := RNT_LEAD_ACTIONS_PKG.INSERT_ROW("
            ."     X_LEAD_ID      => :var2"
            ."   , X_ACTION_DATE  => :var3"
            ."   , X_ACTION_TYPE  => :var4"
            ."   , X_BROKER_ID    => :var5"
            ."   , X_DESCRIPTION  => :var6"
            . "); end;"
        );

        // bind variables
        $statement->set      (1, '23423423123123123');
        $statement->setInt   (2, $info["LEAD_ID"]);
        $statement->setDate  (3, UtlConvert::displayToDBDate($info["ACTION_DATE"]));
        $statement->setString(4, $info["ACTION_TYPE"]);
        $statement->setInt   (5, $info["BROKER_ID"]);
        $statement->setString(6, $info["DESCRIPTION"]);

        // execute statement
        $statement->executeUpdate();

        // get generated ID
        return OCI8PreparedStatementVars::getVar($statement, 1);
    }

    /**
     * Update action info.
     *
     * @param  int    $leadActionId
     * @param  array  $info
     * @return int
     */
    private function updateLeadAction($leadActionId, array $info)
    {
        // construct statement
        $statement = $this->connection->prepareStatement(
            "begin RNT_LEAD_ACTIONS_PKG.UPDATE_ROW("
            . "    X_ACTION_ID   => :var1"
            . "  , X_LEAD_ID     => :var2"
            . "  , X_ACTION_DATE => :var3"
            . "  , X_ACTION_TYPE => :var4"
            . "  , X_BROKER_ID   => :var5"
            . "  , X_DESCRIPTION => :var6"
            . "  , X_CHECKSUM    => :var7"
            . "); end;"
        );

        // bind variables
        $statement->setInt   (1, $leadActionId);
        $statement->setInt   (2, $info["LEAD_ID"]);
        $statement->setDate  (3, UtlConvert::displayToDBDate($info["ACTION_DATE"]));
        $statement->setString(4, $info["ACTION_TYPE"]);
        $statement->setInt   (5, $info["BROKER_ID"]);
        $statement->setString(6, $info["DESCRIPTION"]);
        $statement->setString(7, $info["CHECKSUM"]);

        // execute statement
        $statement->executeUpdate();
        return $leadActionId;
    }

    /**
     * Find out lead actions list.
     *
     * @param $leadId
     * @return array
     */
    public function getLeadActionList($leadId)
    {
        $actionList = array();

        if (empty($leadId)) {
            return $actionList;
        }

        $query = "SELECT ACTION_ID, LEAD_ID, ACTION_DATE, ACTION_TYPE
                  ,      BROKER_ID, DESCRIPTION, CHECKSUM
                  FROM   rnt_lead_actions_v
                  WHERE  lead_id = :var1";
        $stmt  = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $leadId);

        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $r = $rs->getRow();
            $actionList[$r['ACTION_ID']] = $r;
        }
        return $actionList;
    }

    /**
     * Find out lead action details.
     *
     * @param $leadActionId
     * @return array
     */
    public function getLeadAction($leadActionId)
    {
        $actionDetails = array();

        if (empty($leadActionId)) {
            return $actionDetails;
        }

        $query = "SELECT ACTION_ID, LEAD_ID, ACTION_DATE, ACTION_TYPE
                  ,      BROKER_ID, DESCRIPTION, CHECKSUM
                  FROM   rnt_lead_actions_v
                  WHERE  action_id = :var1";
        $stmt  = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $leadActionId);

        $rs = $stmt->executeQuery();
        if ($rs->next()) {
            $actionDetails = $rs->getRow();
        }
        return $actionDetails;
    }

    public function getBrokerList($peopleID, $businessID)
    {
        $query   = "select license_number as code
                    ,      licensee_name   as value
                    from   pr_licensed_agents a
                    where  exists (
                              select 1
                              from   RNT_PROPERTIES p
                              where  property_id = (
                                        select ref_prop_id from rnt_leads
                                        where  people_business_id = (
                                                  select people_business_id from rnt_people_bu
                                                  where  people_id = :var1 and business_id = :var2
                                               )
                                     )
                              and    a.city    = upper(p.city)
                              and    a.state   = upper(p.state)
                              and    a.zipcode = p.zipcode
                           )
                    and    secondary_status = 'Active'";
        $stmt  = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $peopleID);
        $stmt->setInt(2, $businessID);

        $rs = $stmt->executeQuery();

        $return = array();
        $return[""] = "";
        while($rs->next())
        {
            $r = $rs->getRow();
            $return[$r["CODE"]] = $r["VALUE"];
        }
        $rs->close();
        return $return;
        /*
        $lov = new DBLov($this->connection);
        return $lov->HTMLSelectArray(
            "select 1 as CODE, 'Test Broker 1' as VALUE from dual UNION
             select 2 as CODE, 'Test Broker 2' as VALUE from dual
             order by value");
        */
    }

    /**
     * Save lead's action info.
     *
     * @param  int   $leadActionId
     * @param  array $info
     * @return null
     */
    public function saveLeadAction($leadActionId, array $info)
    {
        // do nothing if no action info
        if (empty($info)) {
            return NULL;
        }

        // insert lead action
        if (empty($leadActionId)) {
            return $this->insertLeadAction($info);
        }

        // update lead action
        return $this->updateLeadAction($leadActionId, $info);
    }

    /**
     * Remove lead's action info.
     *
     * @param int $leadActionId
     */
    public function removeLeadAction($leadActionId)
    {
        // do nothing if no lead action ID
        if (empty($leadActionId)) {
            return;
        }

        $statement = $this->connection->prepareStatement(
            "begin RNT_LEAD_ACTIONS_PKG.DELETE_ROW(X_ACTION_ID => :var1); end;"
        );
        $statement->setInt(1, $leadActionId);
        $statement->executeUpdate();
    }

    public function getLeadActionTypes()
    {
        $lov = new DBLov($this->connection);
        return $lov->HTMLSelectArray("
                select 'Phone Call'    as CODE, 'Phone Call'    as VALUE from dual UNION
                select 'Email'         as CODE, 'Email'         as VALUE from dual UNION
                select 'Letter'        as CODE, 'Letter'        as VALUE from dual UNION
                select 'Referral'      as CODE, 'Referral'      as VALUE from dual UNION
                select 'Offer'         as CODE, 'Offer'         as VALUE from dual UNION
                select 'Counter Offer' as CODE, 'Counter Offer' as VALUE from dual UNION
                select 'Sale Agreed'   as CODE, 'Sale Agreed'   as VALUE from dual UNION
                select 'Inspection'    as CODE, 'Inspection'    as VALUE from dual UNION
                select 'Withdrawn'     as CODE, 'Withdrawn'     as VALUE from dual UNION
                select 'Closing'       as CODE, 'Closing'       as VALUE from dual
                order  by CODE");
    }
}
