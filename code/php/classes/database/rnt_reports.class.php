<?
  require_once dirname(__FILE__)."/../LOV.class.php";
  require_once dirname(__FILE__)."/../UtlConvert.class.php";
  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";

class RNTReports extends RNTBase
{

    public function __construct($connection){
         parent::__construct($connection);
    }

    public function getPaymentType($id)
    {
        if ($id == NULL) {
            $id = 0;
        }
        return $this->getSingleRow(
			          " select payment_type_name
			            ,      description
			            ,      depreciation_term
							    from rnt_payment_types
			            where payment_type_id = :var1", $id);
    }

    public function getAccountPeriods($business_id)
    {
        $result = array();
        $query = "select period_id
                  ,      business_id
                  ,      to_char(start_date, 'mm/dd/yyyy') p_start_date
                  ,      to_char(start_date - 1, 'mm/dd/yyyy') next_end_date
                  ,      closed_yn
                  from   rnt_account_periods
                  where  business_id = :var1
                  order  by to_date(start_date) desc";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $business_id);
        $rs = $stmt->executeQuery();
        
        $period_end = "Date";
        while($rs->next()) {
            $r = $rs->getRow();
            
			$period_start = $r["P_START_DATE"];
			$next_end = $r["NEXT_END_DATE"];
			$result[$r["PERIOD_ID"]] =  $period_start . " to " . $period_end;		                 
			$period_end = $next_end;
		}
		return $result;
    }
	  
    public function getBalanceSheet( $business_id
                                   , $effective_date
                                   , $date_fmt = "mm/dd/yyyy")
    {
	    $effective_date = htmlentities($effective_date, ENT_QUOTES);
        $effective_date   = "to_date('" . $effective_date ."', '$date_fmt')";
        $query = "select a.account_type
               ,      a.name
               ,      a.current_balance_yn                             current_yn
               ,      'DEBIT'                                          txn_type
               ,      sum(rnt_ledger_pkg.get_txn_amount(le.ledger_id)) txn_amount
               from rnt_accounts a
               ,    rnt_ledger_entries le
               where a.account_id = le.debit_account
               and a.business_id = :var1
               and le.entry_date <= $effective_date
               group by account_type, a.name, a.current_balance_yn
               UNION
               select a.account_type
               ,      a.name
               ,      a.current_balance_yn                             current_yn
               ,      'CREDIT'                                          txn_type
               ,      sum(rnt_ledger_pkg.get_txn_amount(le.ledger_id)) txn_amount
               from rnt_accounts a
               ,    rnt_ledger_entries le
               where a.account_id = le.credit_account
               and a.business_id = :var1
               and le.entry_date <= $effective_date
               group by account_type, a.name, a.current_balance_yn
               order by 1, 2 ";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $business_id);
        $rs = $stmt->executeQuery();
        
        $current_assets = array();
        $long_term_assets = array();
        $current_liabilities = array();
        $long_term_liabilities = array();
        $equity = array();
        $earning = array();
        
        while($rs->next())
        {
            $r = $rs->getRow();
            
            $amount = $this->sumGL($r["ACCOUNT_TYPE"], $r["TXN_TYPE"], 0, $r["TXN_AMOUNT"]);
            if ($r["ACCOUNT_TYPE"] == "ASSET")
		    {
		        if ($r["CURRENT_YN"] == "Y")
		        {
		            $current_assets[$r["NAME"]] = $current_assets[$r["NAME"]] + $amount;
					$current_asset_total = $current_asset_total + $amount;
				}
				else	
				{
					$long_term_assets[$r["NAME"]] = $long_term_assets[$r["NAME"]] + $amount;
					$long_term_asset_total = $long_term_asset_total + $amount;
			    }
			}
			elseif ($r["ACCOUNT_TYPE"] == "LIABILITY")
		    {
		        if ($r["CURRENT_YN"] == "Y")
		        {
		            $current_liabilities[$r["NAME"]] = $current_liabilities[$r["NAME"]] + $amount;
					$current_liability_total = $current_liability_total + $amount;
				}
				else	
				{
				    $long_term_liabilities[$r["NAME"]] = $long_term_liabilities[$r["NAME"]] + $amount;
					$long_term_liability_total = $long_term_liability_total + $amount;
				}
			}
			elseif($r["ACCOUNT_TYPE"] == "EQUITY")
		    {
		        $equity[$r["NAME"]] = $equity[$r["NAME"]] + $amount;
		        $equity_total = $equity_total + $amount;
		    }
		    elseif($r["ACCOUNT_TYPE"] == "REVENUE")
		    {
		        $retained_earnings = $retained_earnings + $amount;
		        $equity_total      = $equity_total + $amount;
		    }
		    else
		    {
		        $retained_earnings = $retained_earnings - $amount;
		        $equity_total      = $equity_total - $amount;
		    }
	    }
	    
	    
	    $result = array( "CURRENT_ASSETS"            => $current_assets
		               , "CURRENT_ASSET_TOTAL"       => $current_asset_total
		               , "LONG_TERM_ASSETS"          => $long_term_assets
		               , "LONG_TERM_ASSET_TOTAL"     => $long_term_asset_total
		               , "ASSET_TOTAL"               => $current_asset_total + $long_term_asset_total
		               , "CURRENT_LIABILITIES"       => $current_liabilities
		               , "CURRENT_LIABILITY_TOTAL"   => $current_liability_total
		               , "LONG_TERM_LIABILITIES"     => $long_term_liabilities
		               , "LONG_TERM_LIABILITY_TOTAL" => $long_term_liability_total
		               , "LIABILITY_TOTAL"           => $current_liability_total + $long_term_liability_total 
		               , "EQUITY"                    => $equity
		               , "RETAINED_EARNINGS"         => $retained_earnings
		               , "EQUITY_TOTAL"              => $equity_total
		               , "TOTAL_EQUITY_LIABILITIES"  => $equity_total + $current_liability_total + $long_term_liability_total 
		          );
        return $result;
	}	  
	  
    public function getIncome( $business_id
                             , $property_id = ""
		                     , $start_date
		                     , $end_date
							 , $report_type = "CASH")
    {
	  if ($report_type == "CASH")
	   {
	    $query = "select a.account_type
               ,      a.name
               ,      'DEBIT'                                          txn_type
               ,       sum(pa.amount) txn_amount
               from rnt_accounts a
               ,    rnt_ledger_entries le
               ,    rnt_payment_allocations pa
               ,    rnt_accounts_receivable ar
               where a.account_id = le.debit_account
               and a.account_type in ('COST', 'EXPENSE', 'REVENUE')
               and a.business_id = :var1
               and pa.payment_date > $start_date
               and pa.payment_date <= $end_date".
               ($property_id ? "and PROPERTY_ID = $property_id" : "").
               "and pa.ar_id = ar.ar_id
               and ar.ar_id = le.ar_id
               and a.business_id = ar.business_id
			   and a.account_number < 6700
               group by account_type, a.name, a.current_balance_yn
               UNION			   
               select a.account_type
               ,      a.name
               ,      'DEBIT'                                          txn_type
               ,       sum(pa.amount) txn_amount
               from rnt_accounts a
               ,    rnt_ledger_entries le
               ,    rnt_payment_allocations pa
               ,    rnt_accounts_payable ap
               where a.account_id = le.debit_account
               and a.account_type in ('COST', 'EXPENSE', 'REVENUE')
               and a.business_id = :var1
               and pa.payment_date > $start_date
               and pa.payment_date <= $end_date".
               ($property_id ? "and PROPERTY_ID = $property_id" : "").
               "and pa.ap_id = ap.ap_id
               and ap.ap_id = le.ap_id
               and a.business_id = ap.business_id
			   and a.account_number < 6700
               group by account_type, a.name, a.current_balance_yn
			   UNION
               select a.account_type
               ,      a.name
               ,      'DEBIT'                                          txn_type
               ,       sum(pa.amount) txn_amount
               from rnt_accounts a
               ,    rnt_ledger_entries le
               ,    rnt_payment_allocations pa
               where a.account_id = le.debit_account
               and a.account_type in ('COST', 'EXPENSE', 'REVENUE')
               and a.business_id = :var1
               and pa.payment_date > $start_date
               and pa.payment_date <= $end_date".
               ($property_id ? "and PROPERTY_ID = $property_id" : "").
               "and pa.pay_alloc_id = le.pay_alloc_id
			   and a.account_number < 6700
               group by account_type, a.name, a.current_balance_yn
UNION
               select a.account_type
               ,      a.name
               ,      'CREDIT'                                          txn_type
               ,       sum(pa.amount) txn_amount
               from rnt_accounts a
               ,    rnt_ledger_entries le
               ,    rnt_payment_allocations pa
               ,    rnt_accounts_receivable ar
               where a.account_id = le.credit_account
               and a.account_type in ('COST', 'EXPENSE', 'REVENUE')
               and a.business_id = :var1
               and pa.payment_date > $start_date
               and pa.payment_date <= $end_date".
               ($property_id ? "and PROPERTY_ID = $property_id" : "").
               "and pa.ar_id = ar.ar_id
               and ar.ar_id = le.ar_id
               and a.business_id = ar.business_id
			   and a.account_number < 6700
               group by account_type, a.name, a.current_balance_yn
               UNION			   
               select a.account_type
               ,      a.name
               ,      'CREDIT'                                          txn_type
               ,       sum(pa.amount) txn_amount
               from rnt_accounts a
               ,    rnt_ledger_entries le
               ,    rnt_payment_allocations pa
               ,    rnt_accounts_payable ap
               where a.account_id = le.credit_account
               and a.account_type in ('COST', 'EXPENSE', 'REVENUE')
               and a.business_id = :var1
               and pa.payment_date > $start_date
               and pa.payment_date <= $end_date".
               ($property_id ? "and PROPERTY_ID = $property_id" : "").
               "and pa.ap_id = ap.ap_id
               and ap.ap_id = le.ap_id
               and a.business_id = ap.business_id
			   and a.account_number < 6700
               group by account_type, a.name, a.current_balance_yn
			   UNION
               select a.account_type
               ,      a.name
               ,      'CREDIT'                                          txn_type
               ,       sum(pa.amount) txn_amount
               from rnt_accounts a
               ,    rnt_ledger_entries le
               ,    rnt_payment_allocations pa
               where a.account_id = le.credit_account
               and a.account_type in ('COST', 'EXPENSE', 'REVENUE')
               and a.business_id = :var1
               and pa.payment_date > $start_date
               and pa.payment_date <= $end_date".
               ($property_id ? "and PROPERTY_ID = $property_id" : "").
               "and pa.pay_alloc_id = le.pay_alloc_id
			   and a.account_number < 6700
               group by account_type, a.name, a.current_balance_yn";
	   }
	  else
	   {
        $query = "select a.account_type
               ,      a.name
               ,      'DEBIT'                                          txn_type
               ,      sum(rnt_ledger_pkg.get_txn_amount(le.ledger_id)) txn_amount
               from rnt_accounts a
               ,    rnt_ledger_entries le
               where a.account_id = le.debit_account
               and a.account_type in ('COST', 'EXPENSE', 'REVENUE')
               and a.business_id = :var1
               and le.entry_date > $start_date
               and le.entry_date <= $end_date".
               ($property_id ? "and PROPERTY_ID = $property_id" : "").
               "group by account_type, a.name, a.current_balance_yn
               UNION
               select a.account_type
               ,      a.name
               ,      'CREDIT'                                          txn_type
               ,      sum(rnt_ledger_pkg.get_txn_amount(le.ledger_id)) txn_amount
               from rnt_accounts a
               ,    rnt_ledger_entries le
               where a.account_id = le.credit_account
               and a.account_type in ('COST', 'EXPENSE', 'REVENUE')
               and a.business_id = :var1
               and le.entry_date > $start_date
               and le.entry_date <= $end_date".
               ($property_id ? "and PROPERTY_ID = $property_id" : "").
               "group by account_type, a.name, a.current_balance_yn
               order by 1, 2 ";
		}
        
        $revenue = array();
        $expense = array();
		
		$stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $business_id);
		
		
        $rs = $stmt->executeQuery();

        while($rs->next()) {
            $r = $rs->getRow();
            
            $amount = $this->sumGL($r["ACCOUNT_TYPE"], $r["TXN_TYPE"], 0, $r["TXN_AMOUNT"]);
            if ($r["ACCOUNT_TYPE"] == "REVENUE")
		    {
		        $revenue[$r["NAME"]] = $revenue[$r["NAME"]] + $amount;
		        $gross_income = $gross_income + $amount;
		        $net_income = $net_income + $amount;
		    }
			else
			{
			    $expense[$r["NAME"]] = $expense[$r["NAME"]] + $amount;
			    $net_income = $net_income - $amount;
			    $total_expense = $total_expense + $amount;
			}
	    }
	    
	    $result = array ( "REVENUE"       => $revenue
	                    , "GROSS"         => $gross_income
	                    , "EXPENSE"       => $expense
		                , "TOTAL_EXPENSE" => $total_expense
		                , "NET_INCOME"    => $net_income);
		return $result;
	}
	  
    public function getIncomeStatement( $business_id
                                      , $property_id = ""
		                              , $effective_date
		                              , $statement_type
									  , $report_type = "CASH"
									  , $date_fmt = "mm/dd/yyyy")	  
		{
		$result = array();
		$this_result = array();
		
		$effective_date = htmlentities($effective_date, ENT_QUOTES);
		$date_fmt = htmlentities($date_fmt, ENT_QUOTES);

		$v_date = "to_date('$effective_date', '$date_fmt')";
		$end_date = $v_date;
		for( $i = 1; $i < 4; $i++) {
		  $query = "select to_char($end_date, 'mm/dd/yyyy') e_date from dual";
		  $rs = $this->connection->executeQuery($query);   		
       while($rs->next())
        {
		     $r = $rs->getRow();
		     $period[$i] = $r["E_DATE"];
		     }
		  
		  $months = $i * -1 * $statement_type;
		  $start_date = "add_months($v_date, '$months')";
//		  print "$i = $start_date - $end_date\n";
     
      $this_result[$i] = $this->getIncome($business_id, $property_id, $start_date, $end_date, $report_type);
		  $end_date = $start_date;
		} 

		if ($statement_type == 1) $statement = "Month Ending:";
		elseif ($statement_type == 3) $statement = "Quater Ending:";
		else $statement = "Year Ending:";
		
		
		
		
		for( $i = 1; $i < 4; $i++) {
		  $result[$statement][$i] = $period[$i];
		  $result["Revenue:"][1] = "";
		  foreach ($this_result[$i]["REVENUE"] as $key => $value) {
		    $result[$key][$i] = $value;
		  }
		}
		for( $i = 1; $i < 4; $i++) {
  		$result["Total Gross Income"][$i] = $this_result[$i]["GROSS"];  
  	}
  	$result["Expenses:"][1] = "";
  	for( $i = 1; $i < 4; $i++) {
		  foreach ($this_result[$i]["EXPENSE"] as $key => $value) {
		    $result[$key][$i] = $value;
		  }
		}
		for( $i = 1; $i < 4; $i++) {
     $result["Total Expense"][$i] = $this_result[$i]["TOTAL_EXPENSE"];  
		}
  	$result["Result:"][1] = "";
		for( $i = 1; $i < 4; $i++) {
     $result["Net Income"][$i] = $this_result[$i]["NET_INCOME"];  
		}
  	
  	
		return $result;
		}

    public function getIncomeStmts( $business_id
                                  , $property_id = ""
		                          , $effective_date 
							      , $report_type = "CASH")
    {
		 $result["Monthly Income"] =
		  $this->getIncomeStatement($business_id, $property_id, $effective_date, 1, $report_type);
		 $result["Quarterly Income"] =
		  $this->getIncomeStatement($business_id, $property_id, $effective_date, 3, $report_type);
		 $result["Annual Income"] =
		  $this->getIncomeStatement($business_id, $property_id, $effective_date, 12, $report_type);
		  
		 return $result;
		}		                                  


	  
    public function getTransactionHistory( $business_id
                                         , $propertyID = ""
                                         , $start_date
                                         , $end_date
                                         , $date_fmt = "mm/dd/yyyy")
		
     {
     $result = array();
     $start_date = htmlentities($start_date, ENT_QUOTES);
	 $end_date = htmlentities($end_date, ENT_QUOTES);
     $start_date   = "to_date('" . $start_date ."', '$date_fmt')";
	 $end_date     = "to_date('" . $end_date ."', '$date_fmt')";
     
     $query = "select to_char(le.entry_date, 'mm/dd/yyyy')        entry_date
               ,      le.description
               ,      rnt_ledger_pkg.get_txn_amount(le.ledger_id) amount
               ,      dr.account_number||' - '||dr.name           debit_account
               ,      cr.account_number||' - '||cr.name           credit_account
               from rnt_ledger_entries le
               ,    rnt_accounts dr
               ,    rnt_accounts cr
               where le.debit_account = dr.account_id
               and le.credit_account = cr.account_id
               and cr.business_id = :var1
               and le.entry_date >= $start_date
               and le.entry_date <= $end_date".
              ($propertyID ? "and PROPERTY_ID = :var2 " : "").
               "order by to_date(le.entry_date), le.property_id, amount";
               
		$stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $business_id);
    	if ($propertyID)
	    	$stmt->setInt(2, $propertyID);
        $rs = $stmt->executeQuery();


    while($rs->next())
     {
      $r[] = $rs->getRow();
     }
     return $r;
	  }  
	  
	  
    public function getCommissions( $business_id
                                   , $propertyID = ""
                                   , $start_date
                                   , $end_date
                                   , $date_fmt = "mm/dd/yyyy")
		
     {
     $result = array();
	 $start_date = htmlentities($start_date, ENT_QUOTES);
	 $end_date = htmlentities($end_date, ENT_QUOTES);
     $start_date   = "to_date('" . $start_date ."', '$date_fmt')";
	 $end_date     = "to_date('" . $end_date ."', '$date_fmt')";
     
     $query = "select to_char(le.entry_date, 'mm/dd/yyyy')        entry_date
               ,      le.description
               ,      rnt_ledger_pkg.get_txn_amount(le.ledger_id) amount
               ,      dr.account_number||' - '||dr.name           debit_account
               ,      cr.account_number||' - '||cr.name           credit_account
               from rnt_ledger_entries le
               ,    rnt_accounts dr
               ,    rnt_accounts cr
               ,    rnt_payment_types pt
               where le.debit_account = dr.account_id
               and le.credit_account = cr.account_id
               and le.payment_type_id = pt.payment_type_id
               and pt.payment_type_name like '%Rent%'
               and cr.business_id = :var1
               and le.entry_date >= $start_date
               and le.entry_date <= $end_date".
              ($propertyID ? "and PROPERTY_ID = :var2 " : "").
               "order by to_date(le.entry_date), le.property_id, amount";
               
    	$stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $business_id);
		if ($propertyID)
		  $stmt->setInt(2, $propertyID);		
        $rs = $stmt->executeQuery();
    while($rs->next())
     {
      $r[] = $rs->getRow();
     }
     return $r;
	  }  	  
		    
    public function getGLsummary($business_id,
                                 $start_date,
                                 $end_date,
                                 $date_fmt = "mm/dd/yyyy")
    {
		$result = array();
		
		$start_date = htmlentities($start_date, ENT_QUOTES);
		$end_date = htmlentities($end_date, ENT_QUOTES);
		$start_date   = "to_date('" . $start_date ."', '$date_fmt')";
		$end_date     = "to_date('" . $end_date ."', '$date_fmt')";
		
		$query = "select a.account_number||' - '||a.name                  account
		          ,      a.account_id
		          ,      'CREDIT'                                          trn_type
		          ,      sum( rnt_ledger_pkg.get_txn_amount(re.ledger_id)) amount
		          from rnt_accounts a
              ,    rnt_ledger_entries re
              where re.credit_account = a.account_id
              and a.business_id = :var1
              and re.entry_date  >= $start_date
              and re.entry_date  <= $end_date
              group by a.account_number||' - '||a.name,  a.account_id
							UNION
							select a.account_number||' - '||a.name                  account
							,      a.account_id
		          ,      'DEBIT'                                          trn_type
		          ,      sum( rnt_ledger_pkg.get_txn_amount(re.ledger_id)) amount
		          from rnt_accounts a
              ,    rnt_ledger_entries re
              where re.debit_account = a.account_id
              and a.business_id = :var1
              and re.entry_date  >= $start_date
              and re.entry_date  <= $end_date
              group by a.account_number||' - '||a.name,  a.account_id
							order by 1";
              
      	$stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $business_id);
	    $rs = $stmt->executeQuery();	
				
      $account = "No transactions were recorded in this period";
        while($rs->next())
        {
             $r = $rs->getRow();
             if ($r["ACCOUNT"] != $account)
             {
              if ($account != "No transactions were recorded in this period")
              {
                if ($debit >= $credit) 
                  {
                   $debit_amount = $debit - $credit;
                   $total_debit  = $total_debit + $debit_amount;
                  }
                else
                  {
                   $credit_amount = $credit - $debit;
                   $total_credit  = $total_credit + $credit_amount;
                  }
                $result[$account] = 
							                array( "ACCOUNT"       => $account
							                     , "ACCOUNT_ID"    => $account_id
															     , "DEBIT"         => $debit
															     , "CREDIT"        => $credit
																	 , "DEBIT_AMOUNT"  => $debit_amount
																	 , "CREDIT_AMOUNT" => $credit_amount);
              }
              $account = $r["ACCOUNT"];
              $account_id = $r["ACCOUNT_ID"];
              $debit   = 0;
              $credit  = 0;
              $debit_amount = "";
              $credit_amount = "";
            }
            
            if ($r["TRN_TYPE"] == "DEBIT")  
						   $debit = $r["AMOUNT"];
            else
						    $credit = $r["AMOUNT"];
							
      }
      if ($debit >= $credit) 
         {
          $debit_amount = $debit - $credit;
          $total_debit  = $total_debit + $debit_amount;
         }
         else
         {
          $credit_amount = $credit - $debit;
          $total_credit  = $total_credit + $credit_amount;
         }
      $result[$account] = 
               array( "ACCOUNT"       => $account
                    , "ACCOUNT_ID"    => $account_id
							      , "DEBIT"         => $debit
  						      , "CREDIT"        => $credit
										, "DEBIT_AMOUNT"  => $debit_amount
										, "CREDIT_AMOUNT" => $credit_amount);

      $result["Total"] = 
               array( "ACCOUNT"       => "Total"
                    , "ACCOUNT_ID"    => ""
							      , "DEBIT"         => ""
  						      , "CREDIT"        => ""
										, "DEBIT_AMOUNT"  => $total_debit
										, "CREDIT_AMOUNT" => $total_credit);
										
      return $result;										
    }
    
    public function sumGL( $account_type
                         , $debit_credit
                         , $value1
                         , $value2 )
    {
      if ($debit_credit == "DEBIT")
        {
				 if ($account_type == "ASSET"
					 ||$account_type == "EXPENSE")
							{$result = $value1 + $value2;}
				 else
							{$result = $value1 - $value2;}
				}
       else
        {
				 if ($account_type == "ASSET"
					 ||$account_type == "EXPENSE")
							{$result = $value1 - $value2;}
				 else
							{$result = $value1 + $value2;}
				}
      return $result;
    }
                         
    
    public function getGLdetails($business_id,
                                 $start_date,
                                 $end_date,
                                 $account_id = null,
                                 $date_fmt = "mm/dd/yyyy")
    {
		$result = array();

	    $start_date = htmlentities($start_date, ENT_QUOTES);
  	    $end_date = htmlentities($end_date, ENT_QUOTES);
		
		$p_start_date = $start_date;
		$start_date   = "to_date('" . $start_date ."', '$date_fmt')";
		$end_date     = "to_date('" . $end_date ."', '$date_fmt')";

    // report can be called for a single account or all accounts		
		if ($account_id == NULL){
		  $query = "select account_number||' - '||account_name account
		            ,      account_type
		            ,      account_id
		            ,      to_char(entry_date, 'mm/dd/yyyy') ent_date
		            ,      description
					  		,      transaction_type
						  	,      amount
  							from rnt_ledger_transactions_v
	  						where business_id = :var1
                and entry_date  >= $start_date
                and entry_date  <= $end_date
				  			order by account_number, entry_date";
				}
			else{
  		  $query = "select account_number||' - '||account_name account
  		            ,      account_type
  		            ,      account_id
	  	            ,      to_char(entry_date, 'mm/dd/yyyy') ent_date
		              ,      description
			  		  		,      transaction_type
				  		  	,      amount
  				   			from rnt_ledger_transactions_v
	  					  	where business_id = :var1
                  and entry_date  >= $start_date
                  and entry_date  <= $end_date
                  and account_id = :var2
	  			  			order by account_number, entry_date";
           }

     	$stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $business_id);
		if ($account_id)
		  $stmt->setInt(2, $account_id);
	    $rs = $stmt->executeQuery();
		

			$i  = 0;
			$account_debit   = 0;
			$account_credit  = 0;
			$account_balance = 0;
      $account = "No transactions were recorded in this period";
        while($rs->next())
        {
             $r = $rs->getRow();
             if ($r["TRANSACTION_TYPE"] == "DEBIT")
                {$debit  = $r["AMOUNT"];
                 $credit = "";
								 $total_debit = $total_debit + $debit;
								 $debit_credit = "DEBIT";
								}
             else
                {$credit = $r["AMOUNT"];
                 $debit  = "";
								 $total_credit = $total_credit + $credit;
								 $debit_credit = "CREDIT";
                 }
             $i = $i + 1;
             if ($r["ACCOUNT"] != $account)
             {
              if ($account != "No transactions were recorded in this period") 
							  // its not the first run
							 {
                 $result[$i] = array( "ACCOUNT"     => ""
								  						      , "DATE"        => ""
									  						    , "DESC"        => "<b>$account Total</b>"
										  							, "DEBIT"       => $account_debit
											  						, "CREDIT"      => $account_credit
																		, "BALANCE"     => $account_balance);
					       $i = $i + 1;
					       $account_debit   = 0;
					       $account_credit  = 0;
					       $account_balance = 0;
					     }
             
               $account      = $r["ACCOUNT"];
               $account_type = $r["ACCOUNT_TYPE"];
               $b_account_id = $r["ACCOUNT_ID"];
               
               
               if ($account_type == "ASSET"
							   ||$account_type == "LIABILITY"
								 ||$account_type == "EQUITY") // its a balance sheet account
                 {
                  $statement = "select  RNT_LEDGER_PKG.GET_ACCOUNT_BALANCE
									                                ( " . $b_account_id . "
																	, " . $start_date . ") balance
    													  from dual";
                  $rsq = $this->connection->executeQuery($statement); 
                  while ($rsq->next())
                   {
                   $rq = $rsq->getRow();
								   $opening_balance = $rq["BALANCE"];  
								   
								   }
                  $result[$i] = array( "ACCOUNT"     => $account
		    					  						      , "DATE"        => $p_start_date
				    											    , "DESC"        => "Opening Balance"
						    											, "DEBIT"       => ""
								    									, "CREDIT"      => ""
										    							, "BALANCE"     => $opening_balance);
					        $i = $i + 1;     
					        $account_balance = $this->sumGL( $account_type
					                                , $debit_credit
					                                , $opening_balance
					                                , $r["AMOUNT"]);
					        if ($debit_credit == "DEBIT")
					          {$account_debit = $account_debit + $debit;}
					        else
					          {$account_credit = $account_credit + $credit;}
									

                  $result[$i] = array( "ACCOUNT"     => ""
									    					      , "DATE"        => $r["ENT_DATE"]
											    				    , "DESC"        => $r["DESCRIPTION"]
													    				, "DEBIT"       => $debit
															    		, "CREDIT"      => $credit
																	    , "BALANCE"     => $account_balance);																	
                 }
               else  // it's a income statement account
                 {
 					        $account_balance = $this->sumGL( $account_type
					                                , $debit_credit
					                                , $opening_balance
					                                , $r["AMOUNT"]);
					        if ($debit_credit == "DEBIT")
					          {$account_debit = $account_debit + $debit;}
					        else
					          {$account_credit = $account_credit + $credit;}

                   $result[$i] = array( "ACCOUNT"     => $account
									    					      , "DATE"        => $r["ENT_DATE"]
											    				    , "DESC"        => $r["DESCRIPTION"]
													    				, "DEBIT"       => $debit
															    		, "CREDIT"      => $credit
																	    , "BALANCE"     => $account_balance);																	

                 }
						  }
						  else // it's not a new account
						  {
  			        $account_balance = $this->sumGL( $account_type
					                                , $debit_credit
					                                , $account_balance
					                                , $r["AMOUNT"]);
					        if ($debit_credit == "DEBIT")
					          {$account_debit = $account_debit + $debit;}
					        else
					          {$account_credit = $account_credit + $credit;}
						  
               $result[$i] = array( "ACCOUNT"     => ""
														      , "DATE"        => $r["ENT_DATE"]
															    , "DESC"        => $r["DESCRIPTION"]
																	, "DEBIT"       => $debit
																	, "CREDIT"      => $credit
																	, "BALANCE"     => $account_balance);
						  }
          }
					$i = $i + 1;          
          $result[$i] = array( "ACCOUNT"     => ""
					  						      , "DATE"        => ""
						  						    , "DESC"        => "<b>$account Total</b>"
															, "DEBIT"       => $account_debit
															, "CREDIT"      => $account_credit
															, "BALANCE"     => $account_balance);

          
      return $result;										
    }    
    
    
    /**
     * Get prepared data
     *
     * @param  array $params
     * @return array
     */
    public function getReportData($business_id,
                                  $report_basis,
                                  $start_date,
                                  $end_date,
                                  $date_fmt = "mm/dd/yyyy")
    {
		$result = array();
		
		$report_basis = strtoupper($report_basis);
        $start_date = htmlentities($start_date, ENT_QUOTES);
	    $end_date = htmlentities($end_date, ENT_QUOTES);

		$start_date   = "to_date('" . $start_date ."', '$date_fmt')";
		$end_date     = "to_date('" . $end_date ."', '$date_fmt')";

		$query = "select decode(grouping(p.address1), 1,
                                'Total',
                                p.address1
                         ) as property_name,
                         decode(grouping(pt.payment_type_name), 1,
                                'Total',
                                pt.payment_type_name
                         ) as payment_type,
                         sum(pa.amount) as amount,
                         row_number() over (partition by p.address1 order by p.address1) as rnum,
                         'INCOME' as type_amount
                  from   rnt_payment_types       pt,
                         rnt_accounts_receivable ar,
                         rnt_payment_allocations pa,
                         rnt_properties          p
                  where  ar.business_id  = :var1
                  and    ar.payment_type = pt.payment_type_id
                  and    ar.ar_id        = pa.ar_id
                  and    ar.payment_property_id = p.property_id(+)
                  and    " . ($report_basis == "CASH" ? "pa.payment_date" : "ar.payment_due_date") . " >= $start_date
                  and    " . ($report_basis == "CASH" ? "pa.payment_date" : "ar.payment_due_date") . " <= $end_date
                  group  by cube(p.address1, payment_type_name)
                  union
                  select decode(grouping(p.address1), 1,
                                'Total',
                                p.address1
                         ) as property_name,
                         decode(grouping(pt.payment_type_name), 1,
                                'Total',
                                pt.payment_type_name
                         ) as payment_type,
                         sum(pa.amount) as amount,
                         row_number() over (partition by p.address1 order by p.address1) as rnum,
                         'EXPENSE' as type_amount
                  from   rnt_payment_types       pt,
                         rnt_accounts_payable    ap,
                         rnt_payment_allocations pa,
                         rnt_properties          p
                  where  ap.business_id     = :var1
                  and    ap.payment_type_id = pt.payment_type_id
                  and    ap.ap_id           = pa.ap_id
                  and    ap.payment_property_id = p.property_id(+)
                  and    " . ($report_basis == "CASH" ? "pa.payment_date" : "ap.payment_due_date") . " >= $start_date
                  and    " . ($report_basis == "CASH" ? "pa.payment_date" : "ap.payment_due_date") . " <= $end_date
                  group  by cube(p.address1, payment_type_name)
                  order  by property_name, type_amount desc, rnum";
        
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $business_id);
	    $rs = $stmt->executeQuery();
        
        $property_name = "$$$$$$$";
        while($rs->next())
        {
             $r = $rs->getRow();
             if ($r["PROPERTY_NAME"] != $property_name)
             {
             	$property_name = $r["PROPERTY_NAME"];
             	$result[$property_name] = array(
             	    "INCOMES"  => array(),
             	    "EXPENSES" => array()
             	);
             }

             $payment = array(
                     "PAYMENT_TYPE" => $r["PAYMENT_TYPE"],
                     "AMOUNT"       => $r["AMOUNT"]
             );
             
             if (strtoupper($r["TYPE_AMOUNT"]) == "INCOME") {
                 $result[$property_name]["INCOMES"][]  = $payment;
             } else {
                 $result[$property_name]["EXPENSES"][] = $payment;
             }
        }     

        //require('FirePHPCore/FirePHP.class.php');
		//$firephp = FirePHP::getInstance(true);
		//$firephp->fb($result, 'result', FirePHP::LOG);

        return $result;
    }
    
// End

    public function getExpenseDetailsData($business_id,
                                          $payment_type_id,
                                          $report_basis,
                                          $start_date,
                                          $end_date,
                                          $date_fmt = "mm/dd/yyyy")
    {
		$result = array();
		
		$report_basis = strtoupper($report_basis);
  	    $start_date = htmlentities($start_date, ENT_QUOTES);
	    $end_date = htmlentities($end_date, ENT_QUOTES);

		$start_date   = "to_date('" . $start_date ."', '$date_fmt')";
		$end_date     = "to_date('" . $end_date ."', '$date_fmt')";

		$query = "select p.address1
              ,      to_char(ap.payment_due_date, 'mm/dd/yyyy') payment_due_date
              ,      s.name
              ,      pe.description
              ,      ap.amount
              from rnt_accounts_payable    ap
              ,    rnt_payment_allocations pa
              ,    rnt_properties          p
              ,    rnt_property_expenses   pe
              ,    rnt_suppliers_all       s
              where ap.payment_type_id   = :var2
              and ap.business_id         = :var1
              and ap.payment_property_id = p.property_id (+)
              and ap.expense_id          = pe.expense_id
              and ap.ap_id               = pa.ap_id     
              and s.supplier_id          = ap.supplier_id
              and " . ($report_basis == "CASH" ? "pa.payment_date" : "ap.payment_due_date") . " >= $start_date
              and " . ($report_basis == "CASH" ? "pa.payment_date" : "ap.payment_due_date") . " <= $end_date
              order by p.address1, ap.payment_due_date";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $business_id);
		$stmt->setInt(2, $payment_type_id);
	    $rs = $stmt->executeQuery();
        
        $property_name = "$$$$$$$";
        while($rs->next())
        {
             $r = $rs->getRow();
             if ($r["ADDRESS1"] != $property_name)
             {
             	$property_name = $r["ADDRESS1"];
             	$result[$property_name] = array(
             	         "TOTAL_EXPENSE" => $total,
             	         "EXPENSES"      => array()
             	);
             	$total = 0;
             }

             $payment = array(
                     "PAYMENT_DUE_DATE" => $r["PAYMENT_DUE_DATE"],
                     "NAME"             => $r["NAME"],
                     "DESCRIPTION"      => $r["DESCRIPTION"],
                     "AMOUNT"           => $r["AMOUNT"]
             );
             $total = $total + $r["AMOUNT"];
             $result[$property_name]["EXPENSES"][] = $payment;
             $result[$property_name]["TOTAL_AMOUNT"] = $total;

        }     

        return $result;
    }

    function getAvailableYears(){
    	$lov = new DBLov($this->connection);
    	//where BUSINESS_ID = $business_id
        return $lov->HTMLSelectArray("
            select year_char as CODE, year_char as VALUE
			from ( 
			        select to_char(payment_due_date, 'RRRR') year_char
			        from rnt_accounts_receivable
			        union 
			        select to_char(payment_due_date, 'RRRR')
			        from rnt_accounts_payable
			     )       
			where year_char < to_char(SYSDATE, 'RRRR')
			order by year_char");
    }	
    
    
    function getYearTaxData($business_id, $year){
    	$result = array();
    	
    	// Incoming
    	$sql =  "
				select PROPERTY,
				       PAYMENT_TYPE,
				       AMOUNT as TYPE_AMOUNT,
				       sum(AMOUNT) over (partition by PROPERTY) as PROPERTY_AMOUNT
				from (        
				
				select nvl(p.address1  , 'Business Unit')     PROPERTY
				,      pt.payment_type_name                   PAYMENT_TYPE
				,      sum(pa.amount)                         AMOUNT
				from rnt_payment_types       pt
				,    rnt_accounts_receivable ar
				,    rnt_payment_allocations pa
				,    rnt_properties          p
				where pt.payment_type_id = ar.payment_type
				and   ar.ar_id           = pa.ar_id
				and   ar.payment_property_id     = p.property_id (+)
				and to_char(ar.payment_due_date, 'YYYY') = :var1
				and ar.business_id = :var2
				group by p.address1, pt.payment_type_name
				)
				order by PROPERTY, PAYMENT_TYPE    	
    	";
    	
    	// convert data to well formed array
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $year);
		$stmt->setInt(2, $business_id);
	    $rs = $stmt->executeQuery();
		
    	$res = array();
    	$property_name = "$$$$$$$";
        while($rs->next()){
             $r = $rs->getRow();
             if ($r["PROPERTY"] != $property_name){
             	$property_name = $r["PROPERTY"];
             	$res[$property_name] = array("PROPERTY_NAME" => $property_name, 
             	                             "PROPERTY_AMOUNT" => UtlConvert::dbNumericToDisplay($r["PROPERTY_AMOUNT"]),
             	                             "ITEMS" => array() );
             }
             	                             
          	 $res[$property_name]["ITEMS"][] = array("TYPE" => $r["PAYMENT_TYPE"],
                                                     "TYPE_AMOUNT" => UtlConvert::dbNumericToDisplay($r["TYPE_AMOUNT"]));
             
        }     
        
        
        $rs->close();
        $result["INCOMING"] = $res;
        $year = htmlentities($year, ENT_QUOTES);
        // Common incoming by type
        $sql = "select PAYMENT_TYPE,
				       AMOUNT,
				       sum(AMOUNT) over() as SUMM
				from (         
				select pt.payment_type_name PAYMENT_TYPE
				,      sum(pa.amount) AMOUNT
				from rnt_payment_types pt
				,    rnt_accounts_receivable ar
				,    rnt_payment_allocations pa
				where pt.payment_type_id = ar.payment_type
				and   ar.ar_id = pa.ar_id
				and to_char(ar.payment_due_date, 'YYYY') = '$year'
				and ar.business_id = :var1
				group by  pt.payment_type_name)
				order by PAYMENT_TYPE";
    	$res = $this->sql2array($sql, $business_id);
    	foreach ($res as $k => $v){
    		$res[$k]["AMOUNT"] = UtlConvert::dbNumericToDisplay($v["AMOUNT"]);
    		
    	}
    	$result["INCOMING_COMMON"] = array();
    	if (count($res) > 0)
    	    $result["INCOMING_COMMON"] = array("COMMON_SUM"=> UtlConvert::dbNumericToDisplay($res[0]["SUMM"]), "ITEMS" => $res);
    	
    	// -------------- expenses
    	// Expenses
    	$sql =  "
				select PROPERTY_NAME,
				       PAYMENT_TYPE,
				       AMOUNT as TYPE_AMOUNT,
				       sum(AMOUNT) over(partition by PROPERTY_NAME) as PROPERTY_AMOUNT
				from (        
				        select nvl(p.address1  , 'Business Unit')     PROPERTY_NAME
				        ,      pt.payment_type_name                   PAYMENT_TYPE
				        ,      sum(pa.amount)                         AMOUNT
				        from rnt_payment_types       pt
				        ,    rnt_accounts_payable    ap
				        ,    rnt_payment_allocations pa
				        ,    rnt_properties          p
				        where pt.payment_type_id = ap.payment_type_id
				        and   ap.ap_id           = pa.ap_id
				        and   ap.payment_property_id     = p.property_id (+)
				        and to_char(ap.payment_due_date, 'YYYY') = :var1
				        and ap.business_id = :var2
				        group by p.address1, pt.payment_type_name
				     )        
				order by PROPERTY_NAME, PAYMENT_TYPE
    	";
    	
    	// convert data to well formed array
    	        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $year);
		$stmt->setInt(2, $business_id);
	    $rs = $stmt->executeQuery();
		
    	$res = array();
    	$property_name = "$$$$$$$";
        while($rs->next()){
             $r = $rs->getRow();
             if ($r["PROPERTY_NAME"] != $property_name){
             	$property_name = $r["PROPERTY_NAME"];
             	$res[$property_name] = array("PROPERTY_NAME" => $property_name, 
             	                             "PROPERTY_AMOUNT" => UtlConvert::dbNumericToDisplay($r["PROPERTY_AMOUNT"]),
             	                             "ITEMS" => array() );
             }
             	                             
          	 $res[$property_name]["ITEMS"][] = array("TYPE" => $r["PAYMENT_TYPE"],
                                                     "TYPE_AMOUNT" => UtlConvert::dbNumericToDisplay($r["TYPE_AMOUNT"]));
             
        }     
        
        
        $rs->close();
        $result["EXPENSES"] = $res;
        $year = htmlentities($year, ENT_QUOTES);
        // Common incoming by type
        $sql = "select PAYMENT_TYPE,
				       AMOUNT,
				       sum(AMOUNT) over() as SUMM
				from (       
				        select pt.payment_type_name PAYMENT_TYPE
				        ,      sum(pa.amount) AMOUNT
				        from rnt_payment_types pt
				        ,    rnt_accounts_payable ap
				        ,    rnt_payment_allocations pa
				        where pt.payment_type_id = ap.payment_type_id
				        and   ap.ap_id = pa.ap_id
				        and to_char(ap.payment_due_date, 'YYYY') = '$year'
				        and ap.business_id = :var1
				        group by  pt.payment_type_name
				     )
				order by PAYMENT_TYPE";
    	$res = $this->sql2array($sql, $business_id);
    	foreach ($res as $k => $v){
    		$res[$k]["AMOUNT"] = UtlConvert::dbNumericToDisplay($v["AMOUNT"]);
    		
    	}
    	$result["EXPENSES_COMMON"] = array();
    	if (count($res) > 0)
    	    $result["EXPENSES_COMMON"] = array("COMMON_SUM"=> UtlConvert::dbNumericToDisplay($res[0]["SUMM"]), "ITEMS" => $res);    
    	    
    	return $result;
    }
    	
}    