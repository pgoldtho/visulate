<?
  require_once dirname(__FILE__)."/../LOV.class.php";
  require_once dirname(__FILE__)."/../UtlConvert.class.php";
  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";

class RNTPaymentAccounts extends RNTBase {

    public function __construct($connection){
         parent::__construct($connection);
    }
   
    /**
     * Get list of account types.
     *
     * @return    array
     */
    public function getAccountTypesList()
    {
        $result = array();
        $rs =  $this->connection->executeQuery("
                select account_type, display_title
                from   rnt_account_types
                order  by account_type
                ");
        while($rs->next())
        {
             $r = $rs->getRow();
             $result[$r["ACCOUNT_TYPE"]] = $r["DISPLAY_TITLE"];
        }
        $rs->close();
        return $result;
    }
    
    /**
     * Get list of owners types
     * @return   array
     */
    public function getOwnerTypesList()
    {
        return array('Business', 'User', 'Tenant');
    }    
    
    
    /**
     * Get list owners grouped by owners types
     *
     * @param unknown_type $currentBUID
     * @return    array
     */
    public function getOwnersList($p_business_id)
    {
        $resulr = array();
        
        $query = "select business_id, business_name 
                  from   RNT_BUSINESS_UNITS
                  where  business_id = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $p_business_id);
        $rs = $stmt->executeQuery();
        
        $rs->next();
        $r  = $rs->getRow();
        $result[0][$r["BUSINESS_ID"]] = $r["BUSINESS_NAME"];
        $rs->close();

        // List of users
        
        $result[1] = array("" => "- Select user -");
        
        $query = "select user_assign_id, user_name||' - '||role_name as user_role
                  from   rnt_user_assignments_v
                  where  business_id = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $p_business_id);
        $rs = $stmt->executeQuery();
        while($rs->next()) 
        {
            $r = $rs->getRow();
            $result[1][$r["USER_ASSIGN_ID"]] = $r["USER_ROLE"];
        }
        $rs->close();
        
        // List of people
        $result[2] = array("" => "- Select person -");
        
        $query = "select pbu.people_business_id,
                         pbu.people_id,
                         p.last_name||' '||p.first_name as full_name
                  from   rnt_people_bu pbu,
                         rnt_people p
                  where  pbu.people_id = p.people_id
                  and    pbu.business_id = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $p_business_id);
        $rs = $stmt->executeQuery();        
        while($rs->next())
        {
             $r = $rs->getRow();
             $result[2][$r["PEOPLE_BUSINESS_ID"]] = $r["FULL_NAME"];
        }
        $rs->close();
        
      return $result;  
    }
    
    
    /**
     * Check detail data on account
     *
     * @param    p_account_id   ID of payment account
     * @return   true if exists detail data on accout,
     *           false in overwice
     */
    public function has_detail_data($p_account_id)
    {
        if (empty($p_account_id))
        {
            return FALSE;
        }
        
        $result = FALSE;
        
        $query = "select 'Y' as retval from rnt_pt_rules
                  where  debit_account  = :var1
                  or     credit_account = :var1
                  union
                  select 'Y' as retval from rnt_ledger_entries
                  where  debit_account  = :var1 
                  or     credit_account = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $p_account_id);
        $rs = $stmt->executeQuery();
        //      
        $rs->next();
        $r  = $rs->getRow();
        $result = ! empty($r["RETVAL"]);
        $rs->close();
        
        return $result;
    }
    
    
    /**
     * Get payment accounts list
     *
     * @param     number    $p_business_id
     * @return    array     - if specify $p_business_id,
     *            null      - if not.
     */
    public function getPaymentAccounts($p_business_id, $p_account_type_id = null)
    {
        if (is_null($p_business_id))
        {
            return;    
        }
        
        $result = array();
        
        $query  = "select account_id,".
                        (is_null($p_account_type_id)
                          ? "account_number||'-'||account_type account_number,"
                          : "account_number,").
                         "business_id,
                          name,
                          account_type,
                          current_balance_yn,
                          
                          -- see getOwnerTypesList()
                          decode(user_assign_id,
                                 null, decode(people_business_id,
                                              null, 0, 2), 1) as owner_type,
                                              
                          user_assign_id,
                          people_business_id,
                          RNT_ACCOUNTS_PKG.get_checksum(account_id) as checksum
                   from   rnt_accounts
                   where  business_id = :var1 ".
                         (is_null($p_account_type_id)
                          ? ""
                          : "and account_type = :var2 ").
                  "order  by account_number";
                   
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $p_business_id);
        if (! is_null($p_account_type_id)) {
            $stmt->setString(2, $p_account_type_id);
        }
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $result[] = $rs->getRow();
        }
        
        return $result;
    }// func getPaymentAccounts()
    
    
    
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
                               RNT_ACCOUNTS_PKG.$proc(
                                   X_ACCOUNT_ID => :var1,";
        }
        elseif ($operation == RNTBase::INSERT_ROW)
        {
            $statement = "begin
                              :var1 :=  RNT_ACCOUNTS_PKG.$proc(";
        }
        
        $statement .= "
                       X_ACCOUNT_NUMBER     => :var2,
                       X_BUSINESS_ID        => :var3,
                       X_NAME               => :var4,
                       X_ACCOUNT_TYPE       => :var5,
                       X_USER_ASSIGN_ID     => :var6,
                       X_PEOPLE_BUSINESS_ID => :var7,
                       X_CURRENT_BALANCE_YN => :var8";

        if ($operation == RNTBase::UPDATE_ROW)
        {
            $statement .= ", X_CHECKSUM => :var9";
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
           $prepare->setInt(1, $value["ACCOUNT_ID"]);
        }
        
        $prepare->setInt(2, $value["ACCOUNT_NUMBER"]);       
        $prepare->setInt(3, $value["BUSINESS_ID"]);
        $prepare->setString(4, $value["NAME"]);
        $prepare->setString(5, $value["ACCOUNT_TYPE"]);        
        $prepare->set(6, $value["USER_ASSIGN_ID"]);
        $prepare->set(7, $value["PEOPLE_BUSINESS_ID"]);
        $prepare->setString(8, $value["CURRENT_BALANCE_YN"]);

        if ($operation == RNTBase::UPDATE_ROW)
        {
            $prepare->setString(9, $value["CHECKSUM"]);
        }
        
        $prepare->executeUpdate();

        if ($operation == RNTBase::INSERT_ROW)
        {
          return OCI8PreparedStatementVars::getVar($prepare, 1);
        }
    } // func Operation()
    

    public function Update($values)
    {
        if ( ! array_key_exists("ACCOUNTS", $values))
        {
            return;
        }
        
        $values_r   = $values["ACCOUNTS"];

        foreach($values_r as $v)
        {
           if ( ! $v["ACCOUNT_ID"])
           {
               $this->Operation($v, RNTBase::INSERT_ROW);
           }
           else
           {
               $this->Operation($v, RNTBase::UPDATE_ROW);
           }
        }
    }

    public function Delete($p_account_id)
    {
        if (is_null($p_account_id))
        {
            return;
        }
        
        $statement = "begin RNT_ACCOUNTS_PKG.DELETE_ROW(X_ACCOUNT_ID => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $p_account_id);
        $prepare->executeUpdate();
    }
    
}

?>
