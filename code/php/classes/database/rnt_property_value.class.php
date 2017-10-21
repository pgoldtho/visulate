<?
  require_once dirname(__FILE__)."/../LOV.class.php";
  require_once dirname(__FILE__)."/../UtlConvert.class.php";
  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";

class RNTPropertyValue extends RNTBase {

    public function __construct($connection){
         parent::__construct($connection);
    }
   
    public function getValueMethodsList()
    {
       $lov = new DBLov($this->connection);
       return $lov->HTMLSelectArray("
            select LOOKUP_CODE as CODE, LOOKUP_VALUE as VALUE
            from   RNT_LOOKUP_VALUES_V
            where  LOOKUP_TYPE_CODE = 'VALUATION_METHOD'
            order  by LOOKUP_CODE");
    }

    
    private function Operation($value, $operation)
    {
        $proc = "";
        switch($operation )
        {
            case (RNTBase::UPDATE_ROW) : $proc = "UPDATE_ROW"; break;
            case (RNTBase::INSERT_ROW) : $proc = "INSERT_ROW"; break;
            default: throw new Exception("Not allowed value");
        }

        $statement = '';
        if ($operation == RNTBase::UPDATE_ROW)
        {
            $statement = "begin
                               RNT_PROPERTY_VALUE_PKG.$proc(
                                   X_VALUE_ID => :var1,";
        }
        elseif ($operation == RNTBase::INSERT_ROW)
        {
            $statement = "begin
                              :var1 := RNT_PROPERTY_VALUE_PKG.$proc(";
        }
       
        $statement .= "
                       X_PROPERTY_ID  => :var2,
                       X_VALUE_DATE   => :var3,
                       X_VALUE_METHOD => :var4,
                       X_VALUE        => :var5,
                       X_CAP_RATE     => :var6";

        if ($operation == RNTBase::UPDATE_ROW)
        {
            $statement .= ", X_CHECKSUM => :var7";
        }
        
        $statement .= "); end;";
      
        $prepare = $this->connection->prepareStatement($statement);

        if ($operation == RNTBase::INSERT_ROW)
        {
           // blank value for initial
           $prepare->set(1, '23423423123');
        }
        elseif ($operation == RNTBase::UPDATE_ROW)
        {
           $prepare->setInt(1, $value["VALUE_ID"]);
        }
        
        $prepare->setInt(2, $value["PROPERTY_ID"]);       
        $prepare->setDate(3, UtlConvert::displayToDBDate($value["VALUE_DATE"]));
        $prepare->setString(4, $value["VALUE_METHOD"]);
        $prepare->set(5, UtlConvert::DisplayNumericToDB($value["VALUE"]));
        //$prepare->set(6, $value["CAP_RATE"]);
        $prepare->set(6, 1);

        if ($operation == RNTBase::UPDATE_ROW)
        {
            $prepare->setString(7, $value["CHECKSUM"]);
        }
        
        $prepare->executeUpdate();

        if ($operation == RNTBase::INSERT_ROW)
        {
          return OCI8PreparedStatementVars::getVar($prepare, 1);
        }
    } // func Operation()
    

    public function Update($values)
    {
        if ( ! array_key_exists("VALUES", $values))
        {
            return;
        }
        
        $values_r   = $values["VALUES"];

        foreach($values_r as $v)
        {
           if ( ! $v["VALUE_ID"])
           {
               $this->Operation($v, RNTBase::INSERT_ROW);
           }
           else
           {
               $this->Operation($v, RNTBase::UPDATE_ROW);
           }
        }
    }

    public function Delete($value_id)
    {
        if (is_null($value_id))
        {
            return;
        }
        
        $statement = "begin RNT_PROPERTY_VALUE_PKG.DELETE_ROW(X_VALUE_ID => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $value_id);
        $prepare->executeUpdate();
    }
    

    /**
     * Get property values
     *
     * @param     int      $propertyID
     * @return    array
     */
    public function getPropertyValues($propertyID)
    {
        $result = array();

        $query  = "select pv.value_id,
                          pv.property_id,
                          pv.value_date,
                          pv.value_method,
                          pv.value,
                          pv.value - nvl(loans.loan_amount, 0)  as equity,
                          nvl(loans.loan_amount, 0)/pv.value * 100 as LTV,
                          nvl(loans.loan_amount, 0) as loan_amount,
                          RNT_PROPERTY_VALUE_PKG.get_checksum(pv.value_id) as checksum
                   from   rnt_property_value pv,
                          (select property_id,
                                  sum(nvl(PRINCIPAL_BALANCE, 0)) loan_amount
                           from   rnt_loans
                           where  settlement_date is null
                           group  by property_id
                          ) loans,
                          (select LOOKUP_CODE as CODE, LOOKUP_VALUE as VALUE
                           from   RNT_LOOKUP_VALUES_V
                           where  LOOKUP_TYPE_CODE = 'VALUATION_METHOD'
                          ) vm
                   where  loans.property_id (+)= pv.property_id
                   and    pv.value_method      = vm.code
                   and    pv.property_id       = :var1
                   order  by pv.value_date desc";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $propertyID);
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $result[] = $rs->getRow();
        }

        return $result;
    } //end func getPropertyValues
}

?>
