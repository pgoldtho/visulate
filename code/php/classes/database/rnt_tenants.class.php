<?
  require_once dirname(__FILE__)."/../LOV.class.php";
  require_once dirname(__FILE__)."/../UtlConvert.class.php";
  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";

class RNTTenants extends RNTBase
{
    private $tenantList;

    public function __construct($connection){
         parent::__construct($connection);
    }

    private function append_prefix($array)
    {
        $return = array();
        foreach($array as $k=>$v)
          $return["TENANT_".$k] = $v;
        return $return;
    }
    public function getShortList($agreement_id)
    {
        $r = array();
        if ($agreement_id == null) {
            return $r;
        }
        
        $query = "select TENANT_ID, AGREEMENT_ID, STATUS,
                         DEPOSIT_BALANCE, LAST_MONTH_BALANCE, PEOPLE_ID,
                         SECTION8_VOUCHER_AMOUNT, SECTION8_TENANT_PAYS, SECTION8_ID,
                         CHECKSUM, TENANT_STATUS_NAME, TENANT_NAME,
                         SECTION8_NAME
                  from   RNT_TENANT_V
                  where  AGREEMENT_ID = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $agreement_id);
        $rs = $stmt->executeQuery();
      
        while($rs->next()) {
            $r[] = $this->append_prefix($rs->getRow());
        }
        $rs->close();
        return $r;
    }

    public function getPeopleList($business_ID)
    {
       $lov = new DBLov($this->connection);
       return $lov->HTMLSelectArray("
            select PEOPLE_ID as CODE, LAST_NAME||' '||FIRST_NAME as VALUE
            from RNT_PEOPLE_LIST_V
            where BUSINESS_ID = :var1
            order by LAST_NAME||' '||FIRST_NAME", false, $business_ID);
    }


    function getStatusList()
    {
       $lov = new DBLov($this->connection);
       return $lov->LOVFromLookup("TENANT_STATUS");
    }

    function getSection8List($BusinessID)
    {
       $lov = new DBLov($this->connection);
       return $lov->HTMLSelectArray(
            "select SECTION8_ID CODE, SECTION_NAME VALUE
             from RNT_SECTION8_OFFICES_V
             where BUSINESS_ID = :var1
             order by SECTION_NAME", false, $BusinessID);
    }

    private function Operation(&$value, $operation)
    {
       $proc = "";
       switch($operation )
       {
        case (RNTBase::UPDATE_ROW) : $proc = "SHORT_UPDATE_ROW"; break;
        case (RNTBase::INSERT_ROW) : $proc = "INSERT_ROW"; break;
        default : throw new Exception("Not allowed value");
       }

       $statement = "";
       if ($operation == RNTBase::UPDATE_ROW)
               $statement =
                "begin RNT_TENANT_PKG.$proc(X_TENANT_ID => :var1,";
       else if ($operation == RNTBase::INSERT_ROW)
         $statement = " begin :var1 := RNT_TENANT_PKG.$proc(";

        $statement .= "X_AGREEMENT_ID            => :var2,".
                      "X_STATUS                  => :var3,".
                      "X_DEPOSIT_BALANCE         => :var4,".
                      "X_LAST_MONTH_BALANCE      => :var5,".
                      "X_PEOPLE_ID               => :var6,".
                      "X_SECTION8_VOUCHER_AMOUNT => :var7,".
                      "X_SECTION8_TENANT_PAYS    => :var8,".
                      "X_SECTION8_ID             => :var9";

        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= " , X_CHECKSUM => :var10";

        $statement .= "); end;";

        $prepare = $this->connection->prepareStatement($statement);

        if ($operation == RNTBase::INSERT_ROW)
           // blank value for initial
           $prepare->set(1, '23423423123123123');
        else if ($operation == RNTBase::UPDATE_ROW)
           $prepare->setInt(1, $value["TENANT_TENANT_ID"]);

        $prepare->setInt(2, $value["TENANT_AGREEMENT_ID"]);
        $prepare->setString(3, $value["TENANT_STATUS"]);
        $prepare->set(4, UtlConvert::DisplayNumericToDB($value["TENANT_DEPOSIT_BALANCE"]));
        $prepare->set(5, UtlConvert::DisplayNumericToDB($value["TENANT_LAST_MONTH_BALANCE"]));
        $prepare->setInt(6, $value["TENANT_PEOPLE_ID"]);
        $prepare->set(7, UtlConvert::DisplayNumericToDB($value["TENANT_SECTION8_VOUCHER_AMOUNT"]));
        $prepare->set(8, UtlConvert::DisplayNumericToDB($value["TENANT_SECTION8_TENANT_PAYS"]));
        $prepare->set(9, $value["TENANT_SECTION8_ID"]);

        if ($operation == RNTBase::UPDATE_ROW)
            $prepare->setString(10, $value["TENANT_CHECKSUM"]);

        @$prepare->executeUpdate();

        if ($operation == RNTBase::INSERT_ROW)
          return OCI8PreparedStatementVars::getVar($prepare, 1);
    }

    public function Delete($id)
    {
        if ($id == null) {
            return;
        }
        $statement = "begin RNT_TENANT_PKG.DELETE_ROW(X_TENANT_ID => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $id);
        $prepare->executeUpdate();
    }


    public function updateTenants($values)
    {
        if (!array_key_exists("TENANTS", $values)) {
            return;
        }

        $tenants = $values["TENANTS"];
        foreach($tenants as $v)
        {
           if (!$v["TENANT_TENANT_ID"])
              // then insert
              $this->Operation($v, RNTBase::INSERT_ROW);
           else
              $this->Operation($v, RNTBase::UPDATE_ROW);
        }
    }


    function getFirstTenantForProperty($property_id)
    {
        $r = array();
        if ($property_id == null) {
            return $r;
        }
        
        $query = "select TENANT_ID, AGREEMENT_ID, STATUS,
                         DEPOSIT_BALANCE, LAST_MONTH_BALANCE, PEOPLE_ID,
                         SECTION8_VOUCHER_AMOUNT, SECTION8_TENANT_PAYS, SECTION8_ID,
                         TENANT_NOTE, CHECKSUM, TENANT_STATUS_NAME,
                         LAST_NAME, FIRST_NAME, PHONE1,
                         PHONE2, EMAIL_ADDRESS, SSN,
                         DRIVERS_LICENSE, DATE_OF_BIRTH,
                         SECTION8_NAME, UNIT_NAME, AMOUNT, AMOUNTH_PERIOD_NAME,
                         AGREEMENT_DATE
                  from   RNT_TENANT_V1
                  where  exists (select 1
                                 from   RNT_TENANCY_AGREEMENT ta,
                                        RNT_PROPERTY_UNITS pu
                                 where  ta.AGREEMENT_ID = RNT_TENANT_V1.AGREEMENT_ID
                                 and pu.UNIT_ID = ta.UNIT_ID
                                 and pu.PROPERTY_ID = :var1)
                  order  by UNIT_NAME, LAST_NAME, FIRST_NAME";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $property_id);
        $rs = $stmt->executeQuery();
        
        if ($rs->next()) {
            $r = $rs->getRow();
        }
        $rs->close();
        return $r;
    }

  function getTenant($tenant_id)
  {
      $r = array();
      if ($tenant_id == null) {
          return $r;
      }
      
      $query = "select TENANT_ID, AGREEMENT_ID, STATUS,
                       DEPOSIT_BALANCE, LAST_MONTH_BALANCE, PEOPLE_ID,
                       SECTION8_VOUCHER_AMOUNT, SECTION8_TENANT_PAYS, SECTION8_ID,
                       TENANT_NOTE, CHECKSUM, TENANT_STATUS_NAME,
                       LAST_NAME, FIRST_NAME, PHONE1,
                       PHONE2, EMAIL_ADDRESS, SSN,
                       DRIVERS_LICENSE, DATE_OF_BIRTH,
                       SECTION8_NAME, UNIT_NAME, AMOUNT, AMOUNTH_PERIOD_NAME,
                       AGREEMENT_DATE
                from   RNT_TENANT_V1
                where  TENANT_ID = :var1";
      $stmt = $this->connection->prepareStatement($query);
      $stmt->setInt(1, $tenant_id);
      $rs = $stmt->executeQuery();
      
      if ($rs->next()) {
          $r = $rs->getRow();
      }
      $rs->close();
      return $r;
  }

  public function Update(&$value)
  {
      $statement =
                "begin RNT_TENANT_PKG.UPDATE_ROW(".
                   "X_TENANT_ID => :var1,".
                   "X_AGREEMENT_ID            => :var2,".
                   "X_STATUS                  => :var3,".
                   "X_DEPOSIT_BALANCE         => :var4,".
                   "X_LAST_MONTH_BALANCE      => :var5,".
                   "X_PEOPLE_ID               => :var6,".
                   "X_SECTION8_VOUCHER_AMOUNT => :var7,".
                   "X_SECTION8_TENANT_PAYS    => :var8,".
                   "X_SECTION8_ID             => :var9,".
                   "X_CHECKSUM                => :var10,".
                   "X_TENANT_NOTE             => :var11); end;";

        $prepare = $this->connection->prepareStatement($statement);

        $prepare->setInt(1, $value["TENANT_ID"]);
        $prepare->setInt(2, $value["AGREEMENT_ID"]);
        $prepare->setString(3, $value["STATUS"]);
        $prepare->set(4, UtlConvert::DisplayNumericToDB($value["DEPOSIT_BALANCE"]));
        $prepare->set(5, UtlConvert::DisplayNumericToDB($value["LAST_MONTH_BALANCE"]));
        $prepare->setInt(6, $value["PEOPLE_ID"]);
        $prepare->set(7, UtlConvert::DisplayNumericToDB($value["SECTION8_VOUCHER_AMOUNT"]));
        $prepare->set(8, UtlConvert::DisplayNumericToDB($value["SECTION8_TENANT_PAYS"]));
        $prepare->set(9, $value["SECTION8_ID"]);
        $prepare->setString(10, $value["CHECKSUM"]);
        $prepare->setString(11, $value["TENANT_NOTE"]);
        @$prepare->executeUpdate();
  }


  public function setTenantList($property_id)
  {
      if (!$property_id) {
          return;
      }
      
      $result = array();
      
      $query = "select TENANT_ID
                from RNT_TENANT_V1
                where exists (select 1
                              from RNT_TENANCY_AGREEMENT ta,
                                   RNT_PROPERTY_UNITS pu
                              where ta.AGREEMENT_ID = RNT_TENANT_V1.AGREEMENT_ID
                                and pu.UNIT_ID = ta.UNIT_ID
                                and pu.PROPERTY_ID = :var1)
                order by UNIT_NAME, LAST_NAME, FIRST_NAME";
      $stmt = $this->connection->prepareStatement($query);
      $stmt->setInt(1, $property_id);
      $rs = $stmt->executeQuery();
      
      while($rs->next()) {
          $r = $rs->getRow();
          $result[] = $r["TENANT_ID"];
      }
      $rs->close();
      $this->tenantList = $result;
  
  }

    public function getTenantCount()
    {
       return count($this->tenantList);
    }

    private function getForDirection($currentID, $direction)
    {
        if ($currentID == NULL)
           return 0;
        $key = array_search($currentID, $this->tenantList);
        if ($key === FALSE)
           return $currentID;
        $key += $direction;

        if ( $key < 0 || $key > $this->getTenantCount() )
            return $currentID;

        return $this->tenantList[$key];
    }

    public function getCurrentRowNum($currentID)
    {
        $key = array_search($currentID, $this->tenantList);
        if ($key === FALSE)
           return 0;
        return $key+1;
    }

    // return prev agreement
    public function getPrevID($currentID)
    {
       return $this->getForDirection($currentID, -1);
    }

    // return next agreement
    public function getNextID($currentID)
    {
       return $this->getForDirection($currentID, 1);
    }

    // return true if agreement has next agreement in order sequence
    public function isHasNext($currentID)
    {
        return ($this->getCurrentRowNum($currentID) < $this->getTenantCount());
    }

    // return true if agreement has prev agreement in order sequence
    public function isHasPrev($currentID)
    {
        return ($this->getCurrentRowNum($currentID) > 1);
    }


}

?>