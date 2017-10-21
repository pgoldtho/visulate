<?php
require_once dirname(__FILE__)."/../LOV.class.php";
require_once dirname(__FILE__)."/../UtlConvert.class.php";
require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
require_once dirname(__FILE__)."/rnt_base.class.php";

class RNTLeads extends RNTBase
{
    public function __construct($connection)
    {
         parent::__construct($connection);
    }

    /**
     * Insert lead info.
     *
     * @param  array $info
     * @return int
     */
    private function insertLeadDetails(array $info)
    {
        // construct statement
        $statement = $this->connection->prepareStatement(
            "begin :var1 := RNT_LEADS_PKG.INSERT_ROW("
            . "    X_PEOPLE_BUSINESS_ID => :var2"
            . "  , X_LEAD_DATE          => :var3"
            . "  , X_LEAD_STATUS        => :var4"
            . "  , X_LEAD_TYPE          => :var5"
            . "  , X_REF_PROP_ID        => :var6"
            . "  , X_FOLLOW_UP          => :var7"
            . "  , X_UCODE              => :var8"
            . "  , X_CITY               => :var9"
            . "  , X_MIN_PRICE          => :var10"
            . "  , X_MAX_PRICE          => :var11"
            . "  , X_LTV_TARGET         => :var12"
            . "  , X_LTV_QUALIFIED_YN   => :var13"
            . "  , X_DESCRIPTION        => :var14"
            . "); end;"
        );

        // bind variables
        $statement->set      (1, '23423423123123123');
        $statement->setInt   (2, $info["PEOPLE_BUSINESS_ID"]);
        $statement->setDate  (3, UtlConvert::displayToDBDate($info["LEAD_DATE"]));
        $statement->setString(4, $info["LEAD_STATUS"]);
        $statement->setString(5, $info["LEAD_TYPE"]);
        $statement->setInt   (6, $info["REF_PROP_ID"]);
        $statement->setInt   (7, $info["FOLLOW_UP"]);
        $statement->setInt   (8, $info["UCODE"]);
        $statement->setString(9, $info["CITY"]);
        $statement->set      (10, UtlConvert::DisplayNumericToDB($info["MIN_PRICE"]));
        $statement->set      (11, UtlConvert::DisplayNumericToDB($info["MAX_PRICE"]));
        $statement->set      (12, UtlConvert::DisplayNumericToDB($info["LTV_TARGET"]));
        $statement->setString(13, $info["LTV_QUALIFIED_YN"]);
        $statement->setString(14, $info["DESCRIPTION"]);

        // execute statement
        $statement->executeUpdate();

        // get generated ID
        return OCI8PreparedStatementVars::getVar($statement, 1);
    }

    /**
     * Update lead info.
     *
     * @param  int    $leadId
     * @param  array  $info
     * @return int
     */
    private function updateLeadDetails($leadId, array $info)
    {
        // construct statement
        $statement = $this->connection->prepareStatement(
            "begin RNT_LEADS_PKG.UPDATE_ROW("
            . "    X_LEAD_ID            => :var1"
            . "  , X_PEOPLE_BUSINESS_ID => :var2"
            . "  , X_LEAD_DATE          => :var3"
            . "  , X_LEAD_STATUS        => :var4"
            . "  , X_LEAD_TYPE          => :var5"
            . "  , X_REF_PROP_ID        => :var6"
            . "  , X_FOLLOW_UP          => :var7"
            . "  , X_UCODE              => :var8"
            . "  , X_CITY               => :var9"
            . "  , X_MIN_PRICE          => :var10"
            . "  , X_MAX_PRICE          => :var11"
            . "  , X_LTV_TARGET         => :var12"
            . "  , X_LTV_QUALIFIED_YN   => :var13"
            . "  , X_DESCRIPTION        => :var14"
            . "  , X_CHECKSUM           => :var15"
            . "); end;"
        );

        // bind variables
        $statement->setInt   (1, $leadId);
        $statement->setInt   (2, $info["PEOPLE_BUSINESS_ID"]);
        $statement->setDate  (3, UtlConvert::displayToDBDate($info["LEAD_DATE"]));
        $statement->setString(4, $info["LEAD_STATUS"]);
        $statement->setString(5, $info["LEAD_TYPE"]);
        $statement->set      (6, $info["REF_PROP_ID"]);
        $statement->setInt   (7, $info["FOLLOW_UP"]);
        $statement->setInt   (8, $info["UCODE"]);
        $statement->setString(9, $info["CITY"]);
        $statement->set      (10, UtlConvert::DisplayNumericToDB($info["MIN_PRICE"]));
        $statement->set      (11, UtlConvert::DisplayNumericToDB($info["MAX_PRICE"]));
        $statement->set      (12, UtlConvert::DisplayNumericToDB($info["LTV_TARGET"]));
        $statement->setString(13, $info["LTV_QUALIFIED_YN"]);
        $statement->setString(14, $info["DESCRIPTION"]);
        $statement->setString(15, $info["CHECKSUM"]);

        // execute statement
        $statement->executeUpdate();
        return $leadId;
    }

    /**
     * Save lead info.
     *
     * @param  int   $leadId | NULL
     * @param  array $info
     * @return int
     */
    public function saveLeadDetails($leadId = NULL, array $info)
    {
        // do nothing if no lead info
        if (empty($info)) {
            return NULL;
        }

        // insert lead details
        if (empty($leadId)) {
            return $this->insertLeadDetails($info);
        }

        // update lead details
        return $this->updateLeadDetails($leadId, $info);
    }

    /**
     * Remove lead info.
     *
     * @param int  $leadId
     */
    public function removeLeadDetails($leadId)
    {
        // do nothing if no lead ID
        if (empty($leadId)) {
            return;
        }

        $statement = $this->connection->prepareStatement(
            "begin RNT_LEADS_PKG.DELETE_ROW(X_LEAD_ID => :var1); end;"
        );
        $statement->setInt(1, $leadId);
        $statement->executeUpdate();
    }


    public function findLeadDetails($peopleBusinessId)
    {
        $leadDetails = array();

        if (empty($peopleBusinessId)) {
            return $leadDetails;
        }

        $query = "SELECT LEAD_ID, PEOPLE_BUSINESS_ID, LEAD_DATE, LEAD_STATUS, LEAD_TYPE
                  ,      REF_PROP_ID, FOLLOW_UP, UCODE, CITY, MIN_PRICE, MAX_PRICE
                  ,      LTV_TARGET, LTV_QUALIFIED_YN, DESCRIPTION, CHECKSUM
                  FROM   rnt_leads_v
                  WHERE  people_business_id = :var1";
        $stmt  = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $peopleBusinessId);

        $rs = $stmt->executeQuery();
        if ($rs->next()) {
            $leadDetails = $rs->getRow();
        }
        return $leadDetails;
    }

    /**
     * Transfer the Lead record to the new business unit.
     *
     * @param $peopleId
     * @param $newBusinessId
     * @return bool|null
     */
    public function transferLeadToOtherBU($peopleId, $newBusinessId)
    {
        if (empty($peopleId)) {
            return NULL;
        }
        if (empty($newBusinessId)) {
            return NULL;
        }

        // find out the lead record for person
        // move lead record to new business unit
        // if the lead record is Inactive, change the status to Active.
        $statement = $this->connection->prepareStatement(
            "begin RNT_LEADS_PKG.MOVE_LEAD_TO_OTHER_BU(X_PEOPLE_ID => :var1, X_NEW_BUSINESS_ID => :var2); end;"
        );
        $statement->setInt(1, $peopleId);
        $statement->setInt(2, $newBusinessId);
        $statement->executeUpdate();
        return TRUE;
    }

    public function getLeadTypes()
    {
        $lov = new DBLov($this->connection);
        return $lov->HTMLSelectArray("
                select 'Buy'      as CODE, 'Buy'      as VALUE from dual UNION
                select 'Sell'     as CODE, 'Sell'     as VALUE from dual UNION
                select 'Lease'    as CODE, 'Lease'    as VALUE from dual UNION
                select 'Landlord' as CODE, 'Landlord' as VALUE from dual
                order  by CODE");
    }
}
