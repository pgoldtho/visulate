<?

  require_once dirname(__FILE__)."/../LOV.class.php";
  require_once dirname(__FILE__)."/../UtlConvert.class.php";
  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";

  class RNTExpenses extends RNTBase
  {

    public function __construct($connection){
         parent::__construct($connection);
    }

    public function getExpenseList($property_id, $year)
    {
        $return = array();
        if ($property_id == NULL) {
            return $return;
        }
        
        $query = "select pev.EXPENSE_ID, pev.PROPERTY_ID, pev.EVENT_DATE,
                         pev.DESCRIPTION, pev.RECURRING_YN, pev.RECURRING_PERIOD,
                         pev.RECURRING_ENDDATE, pev.UNIT_ID, pev.CHECKSUM,
                         pev.UNIT_NAME, nvl(ap.AMOUNT, 0) as INVOICED, 
                         nvl(ei.ESTIMATE, 0) as ESTIMATE,
                         nvl(ei.ACTUAL, 0)   as ACTUAL,
						 pev.LOAN_ID
                  from   RNT_PROPERTY_EXPENSES_V pev,
                         (select expense_id, sum(nvl(amount, 0)) as amount 
                          from   rnt_accounts_payable 
                          where  to_char(payment_due_date, 'RRRR') = :var1
                          group  by expense_id
                         ) ap,
                         (select expense_id,
                                 sum(NVL(ESTIMATE * ITEM_COST, 0))as ESTIMATE,
                                 sum(NVL(ACTUAL * ITEM_COST, 0))  as ACTUAL
                          from   RNT_EXPENSE_ITEMS
                          where  accepted_yn = 'Y'
                          group  by expense_id
                         ) ei
                  where  ap.EXPENSE_ID  (+)= pev.EXPENSE_ID
                  and    ei.EXPENSE_ID  (+)= pev.EXPENSE_ID
                  and    pev.PROPERTY_ID   = :var2
                  and    to_char(pev.EVENT_DATE, 'RRRR') = :var1
                  order  by pev.EVENT_DATE, pev.UNIT_NAME";
        
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $year);
        $stmt->setInt(2, $property_id);
        $rs = $stmt->executeQuery();
              
        while($rs->next()) {
            $return[] = $rs->getRow();
        }
        return $return;
    }

    public function getYearList()
    {
        $return = array();
        $rs =  $this->connection->executeQuery("
                select distinct to_char(EVENT_DATE, 'RRRR') as YEAR
                from RNT_PROPERTY_EXPENSES_V
                order by 1 desc");
        while($rs->next()) {
            $return[] = $rs->getRow();
        }
        return $return;
    }

	 public function getLoanList($business_id, $isRequired)
    {
	 $lov = new DBLov($this->connection);
        return $lov->HTMLSelectArray("
               select l.loan_id as code
		         ,       p.address1||' - Loan Position '||l.position||' ('||to_char(loan_amount, '$999,999,999')||')' as value
				 from rnt_loans l
				 ,    rnt_properties p
				 where p.business_id = :var1
				 and p.property_id = l.property_id
				 order by p.address1, l.position", $isRequired, $business_id);
    }

    function getPeriodList()
    {
       $lov = new DBLov($this->connection);
       return $lov->LOVFromLookupOrdered("EXPENSE_RECCURING", false);
    }

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
                 "begin RNT_PROPERTY_EXPENSES_PKG.$proc( X_EXPENSE_ID => :var1,";
       else if ($operation == RNTBase::INSERT_ROW)
         $statement = " begin :var1 := RNT_PROPERTY_EXPENSES_PKG.$proc(";

       $statement .= "X_PROPERTY_ID       => :var2,".
                     "X_EVENT_DATE        => :var3,".
                     "X_DESCRIPTION       => :var4,".
                     "X_RECURRING_YN      => :var5,".
                     "X_RECURRING_PERIOD  => :var6,".
                     "X_RECURRING_ENDDATE => :var7,".
                     "X_UNIT_ID           => :var8,".
					 "X_LOAN_ID           => :var9";

        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= ",X_CHECKSUM => :var10";

        $statement .= "); end;";

        $prepare = $this->connection->prepareStatement($statement);

        if ($operation == RNTBase::INSERT_ROW)
           // blank value for initial
           $prepare->set(1, '12345678901234567890');
        else if ($operation == RNTBase::UPDATE_ROW)
           $prepare->setInt(1, $value["EXPENSE_ID"]);

        $prepare->setInt(2, $value["PROPERTY_ID"]);
        $prepare->setDate(3, UtlConvert::displayToDBDate($value["EVENT_DATE"]));
        $prepare->setString(4, $value["DESCRIPTION"]);
        // checkbox
        $prepare->setString(5, ($value["RECURRING_YN"] ==  1)  ? "Y" : "N");
        $prepare->setString(6, @$value["RECURRING_PERIOD"]);
        $prepare->setDate(7, UtlConvert::displayToDBDate($value["RECURRING_ENDDATE"]));
        $prepare->set(8, $value["UNIT_ID"]);
		$prepare->set(9, $value["LOAN_ID"]);

        if ($operation == RNTBase::UPDATE_ROW)
            $prepare->setString(10, $value["CHECKSUM"]);

        $prepare->executeUpdate();

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


    public function Delete($values)
    {
        if (@$values["EXPENSE_ID"] == null) {
            return;
        }
        $statement = "begin RNT_PROPERTY_EXPENSES_PKG.DELETE_ROW(X_EXPENSE_ID => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $values["EXPENSE_ID"]);
        @$prepare->executeUpdate();
     }

    public function getPropertyID($expenseID)
    {
        $return = "";
        if ($expenseID == NULL) {
            return $return;
        }
        
        $query = "select PROPERTY_ID from RNT_PROPERTY_EXPENSES_V where EXPENSE_ID = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $expenseID);
        $rs = $stmt->executeQuery();
         
        while($rs->next()) {
            $x = $rs->getRow();
            $return = $x["PROPERTY_ID"];
        }
        return $return;
    }

  }
?>