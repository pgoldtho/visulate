<?php

  require_once dirname(__FILE__)."/../LOV.class.php";
  require_once dirname(__FILE__)."/../UtlConvert.class.php";
  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";

  class RNTPayments extends RNTBase
  {

    public function __construct($connection){
         parent::__construct($connection);
    }

    public function getList($BusinessUnitID, $YearMonth)
    {
        $return = array();
        if ($BusinessUnitID == NULL) {
            return $return;
        }
        
        $query = "select PAYMENT_ID, PAYMENT_DATE, DESCRIPTION,
                         PAID_OR_RECEIVED, AMOUNT, TENANT_ID,
                         BUSINESS_ID, CHECKSUM, SUMMARY_ALLOCATED
                  from   RNT_PAYMENTS_V
                  where  to_char(PAYMENT_DATE, 'RRRRMM') = :var1
                  or     (AMOUNT - SUMMARY_ALLOCATED != 0 and to_char(PAYMENT_DATE, 'RRRRMM') <= :var1)
                  and    BUSINESS_ID = :var2 
                  order  by PAYMENT_DATE desc ";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $YearMonth);
        $stmt->setInt(2, $BusinessUnitID);
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $return[] = $rs->getRow();
        }
        $rs->close();
        
        return $return;
    }

    public function getPayment($id)
    {
        $return = array();
        if ($id == NULL) {
            return $return;
        }
        
        $query = "select PAYMENT_ID, PAYMENT_DATE, DESCRIPTION,
                         PAID_OR_RECEIVED, AMOUNT, TENANT_ID,
                         BUSINESS_ID, CHECKSUM, SUMMARY_ALLOCATED
                  from   RNT_PAYMENTS_V
                  where  PAYMENT_ID = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $id);
        $rs = $stmt->executeQuery();
        
        if($rs->next())
           $return = $rs->getRow();
        $rs->close();
        return $return;
    }

    function getTenantList($businessID)
    {
       $lov = new DBLov($this->connection);
       return $lov->HTMLSelectArray("
            select TENANT_ID as CODE, LAST_NAME||' '||FIRST_NAME as VALUE
            from   RNT_TENANT_V1
            where  BUSINESS_ID = $businessID
            order  by LAST_NAME, FIRST_NAME", false);
    }
/*
    function getPaymentTypeList()
    {
       $lov = new DBLov($this->connection);
       return $lov->HTMLSelectArray("
            select
               PAYMENT_TYPE_ID as CODE, PAYMENT_TYPE_NAME as VALUE
            from RNT_PAYMENT_TYPES
            order by PAYMENT_TYPE_ID ");
    }
*/
   private function Operation(&$value, $operation)
    {
       $proc = "";
       switch($operation )
       {
        case (RNTBase::UPDATE_ROW) : $proc = "UPDATE_ROW"; break;
        case (RNTBase::INSERT_ROW) : $proc = "INSERT_ROW"; break;
        default : throw new Exception("Not allowed value");
       }

       $statement = '';
       if ($operation == RNTBase::UPDATE_ROW)
               $statement =
                 "begin RNT_PAYMENTS_PKG.$proc( X_PAYMENT_ID => :var1,";
       else if ($operation == RNTBase::INSERT_ROW)
         $statement = " begin :var1 := RNT_PAYMENTS_PKG.$proc(";

       $statement .= "   X_PAYMENT_DATE => :var2".
                     " , X_DESCRIPTION => :var3".
                     " , X_PAID_OR_RECEIVED => :var4".
                     " , X_AMOUNT => :var5".
                     " , X_TENANT_ID => :var6".
                     " , X_BUSINESS_ID => :var7";

        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= ",X_CHECKSUM => :var8";

        $statement .= "); end;";

        $prepare = $this->connection->prepareStatement($statement);

        if ($operation == RNTBase::INSERT_ROW)
           // blank value for initial
           $prepare->set(1, '12345678901234567890');
        else if ($operation == RNTBase::UPDATE_ROW)
           $prepare->setInt(1, $value["PAYMENT_ID"]);

        $prepare->setDate(2, UtlConvert::displayToDBDate($value["PAYMENT_DATE"]));
        $prepare->setString(3, $value["DESCRIPTION"]);
        $prepare->setString(4, "RECEIVED" /*$value["PAID_OR_RECEIVED"]*/);
        $prepare->set(5, UtlConvert::DisplayNumericToDB($value["AMOUNT"]));
        $prepare->set(6, $value["TENANT_ID"]);
        $prepare->setInt(7, $value["BUSINESS_ID"]);

        if ($operation == RNTBase::UPDATE_ROW)
            $prepare->setString(8, $value["CHECKSUM"]);

        @$prepare->executeUpdate();

        if ($operation == RNTBase::INSERT_ROW)
          return OCI8PreparedStatementVars::getVar($prepare, 1);
    }

     public function Insert(&$values)
    {
        return $this->Operation($values, RNTBase::INSERT_ROW);
    }

    public function Update(&$values)
    {
        $this->Operation($values, RNTBase::UPDATE_ROW);
    }

    public function Updates(&$values)
    {
        if (!array_key_exists("PAYMENTS", $values))
          return;

        $recs = $values["PAYMENTS"];
/*        echo "<pre>";
        print_r($recs);
        */
        foreach($recs as $v)
        {
           if (!$v["PAYMENT_ID"])
              // then insert
              $this->Operation($v, RNTBase::INSERT_ROW);
           else
              $this->Operation($v, RNTBase::UPDATE_ROW);
        }
    }

    private function setAllocationOp($paymentID, $allocID)
    {
        if (!$paymentID || !$allocID) {
            return;
        }
        $statement = "begin RNT_PAYMENTS_PKG.SET_ALLOCATION(X_PAYMENT_ID => :var1, X_PAY_ALLOC_ID => :var2); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $paymentID);
        $prepare->setInt(2, $allocID);
        @$prepare->executeUpdate();
    }

    public function setAllocation($paymentID, $allocID, $allocID2)
    {
        if ($paymentID || $allocID)
          $this->setAllocationOp($paymentID, $allocID);
        if ($paymentID || $allocID2)
          $this->setAllocationOp($paymentID, $allocID2);

    }

/*
    public function Updates(&$values)
    {
        if (!array_key_exists("ACCOUNTS", $values))
          return;

        $recs = $values["ACCOUNTS"];

        foreach($recs as $v)
        {
           if (!$v["AP_ID"])
              // then insert
              $this->Operation($v, RNTBase::INSERT_ROW);
           else
              $this->Operation($v, RNTBase::UPDATE_ROW);
        }
    }
  */
    public function Delete($id)
    {
        if ($id == null) {
            return;
        }
        $statement = "begin RNT_PAYMENTS_PKG.DELETE_ROW(X_PAYMENT_ID => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $id);
        @$prepare->executeUpdate();
    }

  }
?>