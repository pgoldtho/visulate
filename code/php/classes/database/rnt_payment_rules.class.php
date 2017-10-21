<?
  require_once dirname(__FILE__)."/../LOV.class.php";
  require_once dirname(__FILE__)."/../UtlConvert.class.php";
  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";

class RNTPaymentRules extends RNTBase {

    public function __construct($connection){
         parent::__construct($connection);
    }
    
    
    /**
     * Get exists payment accounts for business unit
     */
    public function getPaymentAccountsList($p_business_id)
    {
        if (empty($p_business_id))
        {
            return;    
        }

        $result = array();
        
        $query = "select account_id, to_char(account_number) || ' - ' ||name as account_name
                  from   rnt_accounts
                  where  business_id = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $p_business_id);
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
             $r = $rs->getRow();
             $result[$r["ACCOUNT_ID"]] = $r["ACCOUNT_NAME"];
        }
        $rs->close();
        return $result;
    }
    
    /**
     * Get payment rules list
     *
     * @param     number    $p_business_id
     * @return    array     - if specify $p_business_id,
     *            null      - if not.
     */
    public function getPaymentRules($p_business_id)
    {
        if (is_null($p_business_id))
        {
            return;    
        }
        
        $result = array();
        
        $query  = "select ptr.business_id,
                          ptr.payment_type_id,
                          pt.payment_type_name,
                          ptr.transaction_type,
                          decode(ptr.transaction_type,
                                 'APS', 'AP Scheduled',
                                 'APP', 'AP Paid',
                                 'ARS', 'AR Scheduled',
                                 'ARP', 'AR Paid',
                                 'DEP', 'Depreciation'
                          ) as transaction_type_name,
                          ptr.debit_account,
                          ptr.credit_account,
                          RNT_PT_RULES_PKG.get_checksum(
                              ptr.business_id,
                              ptr.payment_type_id,
                              ptr.transaction_type
                          ) as checksum
                   from   rnt_pt_rules ptr,
                          rnt_payment_types pt
                   where  ptr.payment_type_id = pt.payment_type_id 
                   and    ptr.business_id     = :var1 
                   order  by pt.payment_type_name, ptr.transaction_type desc";
        
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $p_business_id);
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $result[] = $rs->getRow();
        }
        
        return $result;
    }// func getPaymentRules()
    
    
    
    private function Operation($value, $operation)
    {
        $proc = "";
        switch($operation)
        {
            case (RNTBase::UPDATE_ROW) : $proc = "UPDATE_ROW"; break;
            default: throw new Exception("Not allowed value");
        }

        $statement = '';
        if ($operation == RNTBase::UPDATE_ROW)
        {
            $statement = "begin
                               RNT_PT_RULES_PKG.$proc(
                                   X_BUSINESS_ID      => :var1,
                                   X_PAYMENT_TYPE_ID  => :var2,
                                   X_TRANSACTION_TYPE => :var3,
                                   X_DEBIT_ACCOUNT    => :var4,
                                   X_CREDIT_ACCOUNT   => :var5,
                                   X_CHECKSUM         => :var6);
                          end;";
        }
        
        $prepare = $this->connection->prepareStatement($statement);

        $prepare->setInt(1, $value["BUSINESS_ID"]);
        $prepare->setInt(2, $value["PAYMENT_TYPE_ID"]);
        $prepare->setString(3, $value["TRANSACTION_TYPE"]);
        $prepare->setInt(4, $value["DEBIT_ACCOUNT"]);        
        $prepare->setInt(5, $value["CREDIT_ACCOUNT"]);
        $prepare->setString(6, $value["CHECKSUM"]);
        
        $prepare->executeUpdate();
    } // func Operation()
    

    public function Update($values)
    {
        if ( ! array_key_exists("RULES", $values))
        {
            return;
        }
        
        $values_r   = $values["RULES"];

        foreach($values_r as $v)
        {
           if ( ! $v["CHECKSUM"])
           {
               $this->Operation($v, RNTBase::INSERT_ROW);
           }
           else
           {
               $this->Operation($v, RNTBase::UPDATE_ROW);
           }
        }
    }
   

}

?>
