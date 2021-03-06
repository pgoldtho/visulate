<?

  require_once dirname(__FILE__)."/../LOV.class.php";
  require_once dirname(__FILE__)."/../UtlConvert.class.php";
  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";
  require_once dirname(__FILE__)."/rnt_properties.class.php";
  class RNTLoans extends RNTBase
  {

    public function __construct($connection){
         parent::__construct($connection);
    }

    public function getLoansList($id)
    {
        $return = array();
        if ($id == NULL) {
            return $return;
        }
        
        $query = "select LOAN_ID, PROPERTY_ID, POSITION,
                         LOAN_DATE, LOAN_AMOUNT, TERM,
                         INTEREST_RATE, CREDIT_LINE_YN, ARM_YN, INTEREST_ONLY_YN,
                         BALLOON_DATE, CLOSING_COSTS, SETTLEMENT_DATE,
						 rnt_loans_pkg.get_mortgage_payment( loan_amount
                                                           , interest_rate
                                                           , term
                                                           , replace(interest_only_yn, 'N', 'A')) payment,
                         CHECKSUM
                  from   RNT_LOANS_V
                  where  PROPERTY_ID = :var1
                  order  by POSITION";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $id);
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $r = $rs->getRow();
            $r1 = array();
            
            foreach($r as $k=>$v) {
                $r1["LOAN_".$k] = $v;
            }
            $return[] = $r1;
        }
        return $return;
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
                 "begin RNT_LOANS_PKG.$proc( X_LOAN_ID => :var1,";
       else if ($operation == RNTBase::INSERT_ROW)
         $statement = " begin :var1 := RNT_LOANS_PKG.$proc(";

       $statement .= "X_PROPERTY_ID        => :var2,".
                      "X_POSITION           => :var3,".
                      "X_LOAN_DATE          => :var4,".
                      "X_LOAN_AMOUNT        => :var5,".
                      "X_TERM               => :var6,".
                      "X_INTEREST_RATE      => :var7,".
                      "X_CREDIT_LINE_YN     => :var8,".
                      "X_ARM_YN             => :var9,".
					  "X_INTEREST_ONLY_YN   => :var10,".
                      "X_BALLOON_DATE       => :var11,".
                      "X_CLOSING_COSTS      => :var12,".
                      "X_SETTLEMENT_DATE    => :var13";

        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= ",X_CHECKSUM => :var14";

        $statement .= "); end;";

        $prepare = $this->connection->prepareStatement($statement);

        if ($operation == RNTBase::INSERT_ROW)
           // blank value for initial
           $prepare->set(1, '12345678901234567890');
        else if ($operation == RNTBase::UPDATE_ROW)
           $prepare->setInt(1, $value["LOAN_LOAN_ID"]);

        $prepare->setInt(2, $value["LOAN_PROPERTY_ID"]);
        $prepare->set(3, $value["LOAN_POSITION"]);
        $prepare->setDate(4, UtlConvert::displayToDBDate($value["LOAN_LOAN_DATE"]));
        // float
        $prepare->set(5, UtlConvert::DisplayNumericToDB($value["LOAN_LOAN_AMOUNT"]));
        // int
        $prepare->set(6, $value["LOAN_TERM"]);
        // float
        $prepare->set(7, UtlConvert::DisplayNumericToDB($value["LOAN_INTEREST_RATE"]));
        // checkbox
        $prepare->setString(8, ($value["LOAN_CREDIT_LINE_YN"] ==  1)  ? "Y" : "N");
        // checkbox
        $prepare->setString(9, ($value["LOAN_ARM_YN"] ==  1)  ? "Y" : "N");
		$prepare->setString(10, ($value["LOAN_INTEREST_ONLY_YN"] ==  1)  ? "Y" : "N");
        $prepare->setDate(11, UtlConvert::displayToDBDate($value["LOAN_BALLOON_DATE"]));
        $prepare->set(12, UtlConvert::DisplayNumericToDB($value["LOAN_CLOSING_COSTS"]));
        $prepare->setDate(13, UtlConvert::displayToDBDate($value["LOAN_SETTLEMENT_DATE"]));

        if ($operation == RNTBase::UPDATE_ROW)
            $prepare->setString(14, $value["LOAN_CHECKSUM"]);

        @$prepare->executeUpdate();

        if ($operation == RNTBase::INSERT_ROW)
          return OCI8PreparedStatementVars::getVar($prepare, 1);
    }

    public function Update(&$values)
    {
        if (!array_key_exists("LOANS", $values)) {
            return;
        }
        
        $recs = $values["LOANS"];
        foreach($recs as $v) {
            if (!$v["LOAN_LOAN_ID"]) {
                // then insert
                $this->Operation($v, RNTBase::INSERT_ROW);
            } else {
                $this->Operation($v, RNTBase::UPDATE_ROW);
            }
        }
    }

    public function Delete($id)
    {
        if ($id == null) {
            return;
        }
        
        $statement = "begin RNT_LOANS_PKG.DELETE_ROW(X_LOAN_ID => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $id);
        @$prepare->executeUpdate();
    }
	public function getAccountBals($propertyID)
	{
	 $return = array();
	 $business = $this->getSingleRow(
	    "select business_id
		 from rnt_properties
		 where property_id = :var1", $propertyID);
		 
     $query =
	   "select a.account_number||' '||a.name account
	    ,      rnt_ledger_pkg.get_account_balance(a.account_id, sysdate, :var1) balance
		from rnt_accounts a
		where a.business_id = :var2
		and current_balance_yn = 'N'
		order by a.account_number";

		
		$stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $propertyID);
		$stmt->setInt(2, $business["BUSINESS_ID"]);
		$rs = $stmt->executeQuery();
		        
        while($rs->next()) {
            $r = $rs->getRow();
            $return[] = $r;
		}  
		
		$query =
	   "select 'Loan '||position||' Principal Balance'
	           ||' on '||to_char(balance_date, 'mm/dd/yyyy') account
	    ,      principal_balance balance
		from rnt_loans
		where property_id = :var1";
		
		$stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $propertyID);
		$rs = $stmt->executeQuery();
		        
        while($rs->next()) {
            $r = $rs->getRow();
            $return[] = $r;
		}  


	return $return;
	}
	
	public function getPayments($loanID)
	{
	 $return = array();
        
        $query = "select to_char(pa.payment_date, 'MM/DD/YYYY') payment_date
		          ,      l.position
		          ,      pa.amount
				  ,      pe.description
				  ,      pe.expense_id
				  ,      pe.property_id
				  ,      pt.payment_type_name payment_type
				  ,      to_char(pe.event_date, 'YYYY') expense_year
				  from rnt_payment_allocations pa
				  ,    rnt_accounts_payable ap
				  ,    rnt_property_expenses pe
				  ,    rnt_payment_types pt
				  ,    rnt_loans l
				  where pe.loan_id = :var1
				  and pe.expense_id = ap.expense_id
				  and ap.ap_id = pa.ap_id
				  and ap.payment_type_id = pt.payment_type_id
				  and pt.payment_type_name like '%Mortgage%'
				  and l.loan_id = pe.loan_id
				  order by ap.payment_due_date";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $loanID);

        $rs = $stmt->executeQuery();
		$p_total = 0;
		$i_total = 0;
		$pi_total = 0;
        
        while($rs->next()) {
            $r = $rs->getRow();
            $return[] = $r;
			if ($r["PAYMENT_TYPE"] == "Mortgage Interest")
			   {$i_total = $i_total + $r["AMOUNT"];}
			elseif ($r["PAYMENT_TYPE"] == "Mortgage Payment Principal")
			   {$p_total = $p_total + $r["AMOUNT"];}
			else
			   {$pi_total = $pi_total + $r["AMOUNT"];}
        }
		$r["DESCRIPTION"] = "Total";
		$r["PAYMENT_TYPE"] = "Mortgage Payment P&I";
		$r["AMOUNT"] = $pi_total;
		$return[] = $r;
		
		$r["PAYMENT_TYPE"] = "Mortgage Interest";
		$r["AMOUNT"] = $i_total;
		$return[] = $r;
		
		$r["PAYMENT_TYPE"] = "Mortgage Payment Principal";
		$r["AMOUNT"] = $p_total;
		$return[] = $r;
        return $return;
	}
	


    public function getRent($propertyID, $Year)
    {
        $return = array();
        
        if (!$Year) {
            $Year = date('Y');
        }
        
        if ($Year == date('Y')) {
            $need_date = date("m/d/Y");
        } else {
            $need_date = "01/01/".(intval($Year)+1);
        }
        
        /// define is whole year
        list($minDate, $maxDate) = $this->getMinMaxDate($propertyID);
/*
cash on cash =  (Incoming - Expense) / Cash Invested * 100
cap rate = NOI/ purchase price * 100;   NOI = income - expenses with an noi_yn = 'Y'
*/
        $needStr = UtlConvert::displayToDBDate($need_date);
        
        $val =  $this->getSingleRow(
             "select 1 as VALUE
              from DUAL
              where  ADD_MONTHS(to_date('$needStr', 'RRRR-MM-DD HH24:MI:SS'), -12) > to_date('$minDate', 'RRRR-MM-DD HH24:MI:SS')");
        
        $is_whole_year = count($val) > 0;
        ///
        $return  = array("RECEIVABLE"  => array(), "PAYABLE" => array());
        
        $row = $this->getSingleRow(
             "select sum(decode(g.NOI_YN, 'Y', g.AMOUNT_GROSS, 0)) - sum(decode(e.NOI_YN, 'Y', e.EXPENSE_AMOUNT, 0))  as X,
                     sum(decode(g.NOI_YN, 'N', g.AMOUNT_GROSS, 0)) - sum(decode(e.NOI_YN, 'N', e.EXPENSE_AMOUNT, 0))  as Y
              from   (select NVL(sum(ap.amount), 0) EXPENSE_AMOUNT, pt.NOI_YN
                      from   RNT_ACCOUNTS_PAYABLE ap,
                             RNT_PAYMENT_TYPES pt
                      where  ap.payment_due_date >= add_months(to_date('$need_date', 'MM/DD/RRRR'), -12)
                      and    ap.payment_due_date < to_date('$need_date', 'MM/DD/RRRR')
                      and    ap.payment_property_id = :var1
                      and    ap.PAYMENT_TYPE_ID = pt.PAYMENT_TYPE_ID
                      group  by pt.NOI_YN
                     ) e,
                     (select NVL(sum(pa.amount), 0) as AMOUNT_GROSS, pt.NOI_YN
                      from   rnt_accounts_receivable ar,
                             rnt_payment_allocations pa,
                             RNT_PAYMENT_TYPES pt
                      where ar.payment_due_date >= add_months(to_date('$need_date', 'MM/DD/RRRR'), -12)
                      and ar.payment_due_date < to_date('$need_date', 'MM/DD/RRRR')
                      and ar.ar_id = pa.ar_id
                      and ar.payment_property_id = :var1
                      and ar.PAYMENT_TYPE = pt.PAYMENT_TYPE_ID
                      group by pt.NOI_YN
                     ) g
              where  e.NOI_YN = g.NOI_YN(+) ", $propertyID);
         $noi_base = $row["X"];
         
         $return["DEBT_SERVICE"] = $row["Y"];
         
         $amount_gross = 0;
         
         $rs =  $this->connection->executeQuery("
              select NVL(sum(pa.amount), 0) as AMOUNT_GROSS
              from rnt_accounts_receivable ar
              ,    rnt_payment_allocations pa
              where ar.payment_due_date >= add_months(to_date('$need_date', 'MM/DD/RRRR'), -12)
                and ar.payment_due_date < to_date('$need_date', 'MM/DD/RRRR')
                and ar.ar_id = pa.ar_id
                and ar.payment_property_id = $propertyID
              ");
         
         while($rs->next()) {
             $r = $rs->getRow();
             $amount_gross = $r["AMOUNT_GROSS"];
         }
         $return["AMOUNT_GROSS"] = $amount_gross;
         
         $rs =  $this->connection->executeQuery(
                               "select payment_type_name, NVL(sum(pa.amount), 0) as AMOUNT_GROSS
                                from rnt_accounts_receivable ar
                                ,    rnt_payment_allocations pa
                                ,    rnt_payment_types pt
                                where ar.payment_due_date >= add_months(to_date('$need_date', 'MM/DD/RRRR'), -12)
                                  and ar.payment_due_date < to_date('$need_date', 'MM/DD/RRRR')
                                  and ar.ar_id = pa.ar_id
                                  and ar.payment_property_id = $propertyID
                                  and pt.payment_type_id = ar.payment_type
                                 group by payment_type_name
                                 order by payment_type_name");

         while($rs->next()){
           $r = $rs->getRow();
           $return["RECEIVABLE"][] = array("NAME"=>$r["PAYMENT_TYPE_NAME"], "AMOUNT" => $r["AMOUNT_GROSS"]);
         }


        $rs =  $this->connection->executeQuery("
                        select NVL(sum(ap.amount), 0) EXPENSE_AMOUNT
                        from RNT_ACCOUNTS_PAYABLE ap
                        where ap.payment_due_date >= add_months(to_date('$need_date', 'MM/DD/RRRR'), -12)
                          and ap.payment_due_date < to_date('$need_date', 'MM/DD/RRRR')
                          and ap.payment_property_id = $propertyID
                         -- and ap.PAYMENT_TYPE_ID != RNT_ACCOUNTS_RECEIVABLE_PKG.PAYMENT_TYPE_MORTGAGE_PAYMENT()
                      ");
        $amount_expense = 0;
        while($rs->next())
        {
           $r = $rs->getRow();
           $amount_expense = $r["EXPENSE_AMOUNT"];
        }
        $return["EXPENSE_AMOUNT"] = $amount_expense;

        $rs =  $this->connection->executeQuery("select PAYMENT_TYPE_NAME, NVL(sum(ap.amount), 0) EXPENSE_AMOUNT
                        from RNT_ACCOUNTS_PAYABLE ap,
                             RNT_PAYMENT_TYPES pt
                        where ap.payment_due_date >= add_months(to_date('$need_date', 'MM/DD/RRRR'), -12)
                          and ap.payment_due_date < to_date('$need_date', 'MM/DD/RRRR')
                          and ap.payment_property_id = $propertyID
                          --and ap.PAYMENT_TYPE_ID != RNT_ACCOUNTS_RECEIVABLE_PKG.PAYMENT_TYPE_MORTGAGE_PAYMENT()
                          --and pt.NOI_YN = 'Y'
                          and pt.PAYMENT_TYPE_ID = ap.PAYMENT_TYPE_ID
                        group by PAYMENT_TYPE_NAME
                        order by PAYMENT_TYPE_NAME");


         while($rs->next()){
           $r = $rs->getRow();
           $return["PAYABLE"][] = array("NAME"=>$r["PAYMENT_TYPE_NAME"], "AMOUNT" => $r["EXPENSE_AMOUNT"]);
         }

        $loan_amount = 0;
        /*  previous version
                        select NVL(sum(LOAN_AMOUNT), 0) LOAN_AMOUNT
                        from RNT_LOANS
                        where loan_date >= add_months(to_date('$need_date', 'MM/DD/RRRR'), -12)
                          and loan_date <= to_date('$need_date', 'MM/DD/RRRR')
                          and SETTLEMENT_DATE is null
                          and PROPERTY_ID = $propertyID
        */
        $rs =  $this->connection->executeQuery("
                        select NVL(sum(LOAN_AMOUNT), 0) LOAN_AMOUNT
                        from RNT_LOANS
                        where SETTLEMENT_DATE is null
                          and PROPERTY_ID = $propertyID
                      ");
        while($rs->next())
        {
           $r = $rs->getRow();
           $loan_amount = $r["LOAN_AMOUNT"];
        }

        $return["AMOUNT_LOAN"] = $loan_amount;

        $closing_costs = 0;
        $rs =  $this->connection->executeQuery("
                        select NVL(sum(CLOSING_COSTS), 0) CLOSING_COSTS
                        from RNT_LOANS
                        where loan_date >= add_months(to_date('$need_date', 'MM/DD/RRRR'), -12)
                          and loan_date < to_date('$need_date', 'MM/DD/RRRR')
                          and PROPERTY_ID = $propertyID
                      ");
        while($rs->next())
        {
           $r = $rs->getRow();
           $closing_costs = $r["CLOSING_COSTS"];
        }
        $return["CLOSING_COSTS"] = $closing_costs;

        $prop = new RNTProperties($this->connection);
        $r = $prop->getProperty($propertyID);
        $purchase_price = $r["PROP_PURCHASE_PRICE"];
        $return ["IS_SOLD"] = strlen($r["PROP_DATE_SOLD"]) > 0;

        $return["NOI"] = $noi_base;
        if (!$return["NOI"]) $return["NOI"] = "0.00";
        if ($purchase_price && $is_whole_year)
           $return["CAP_RATE"] = (($return["NOI"])/$purchase_price)*100;
        else
           $return["CAP_RATE"] = "0.00";

        $return["PURCHASE_PRICE"] = $purchase_price;
        $return["NET_EQUITY"] = $purchase_price - $loan_amount;
        $return["CASH_INVESTED"] = $return["NET_EQUITY"] + $closing_costs;

        $return["CASH_ON_CASH"] = "0.00";
        if ($return["CASH_INVESTED"] != 0)
           $return["CASH_ON_CASH"] = (($return["AMOUNT_GROSS"] - $return["EXPENSE_AMOUNT"])/$return["CASH_INVESTED"])*100;

        if (!$return["CASH_ON_CASH"])
          $return["CASH_ON_CASH"] = "0.00";

        $return["WARN"] =  ($is_whole_year) ? "" : "Warning: cap rate and cash on cash figures were calculated using less than 12 months data.";

        if ($return["CASH_INVESTED"] <= 0)
            $return["WARN"] .= " Cash on Cash not calculated because total Cash Invested is zero or negative.";
        return $return;
     }

     function getMinMaxDate($propertyID)
     {
         $return = array();
         
         $query = "select min(MIN_DATE) as MIN_DATE, max(MAX_DATE) as MAX_DATE
                   from   (select min(PAYMENT_DUE_DATE) as MIN_DATE, max(PAYMENT_DUE_DATE) as MAX_DATE
                           from   RNT_ACCOUNTS_PAYABLE
                           where  PAYMENT_PROPERTY_ID = :var1
                           union all
                           select min(PAYMENT_DUE_DATE), max(PAYMENT_DUE_DATE)
                           from   RNT_ACCOUNTS_RECEIVABLE
                           where  PAYMENT_PROPERTY_ID = :var1 
                          )";
         $stmt = $this->connection->prepareStatement($query);
         $stmt->setInt(1, $propertyID);
         $rs = $stmt->executeQuery();
         
         while($rs->next()) {
             $r = $rs->getRow();
             $return = array($r["MIN_DATE"], $r["MAX_DATE"]);
         }
         return $return;
     }


     function getMinMaxYear() 
     {
         $return = array();
         $rs =  $this->connection->executeQuery(
         "select to_char(min(MIN_DATE), 'RRRR') as MIN_YEAR, to_char(max(MAX_DATE), 'RRRR') as MAX_YEAR
          from   (select min(PAYMENT_DUE_DATE) as MIN_DATE, max(PAYMENT_DUE_DATE) as MAX_DATE
                  from   RNT_ACCOUNTS_PAYABLE
                  union all
                  select min(PAYMENT_DUE_DATE), max(PAYMENT_DUE_DATE)
                  from   RNT_ACCOUNTS_RECEIVABLE
                 )"
         );
         
         while($rs->next()) {
             $r = $rs->getRow();
             $return = array($r["MIN_YEAR"], $r["MAX_YEAR"]);
         }
         return $return;
     }

  }
?>