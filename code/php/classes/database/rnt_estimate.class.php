<?
  require_once dirname(__FILE__)."/../LOV.class.php";
  require_once dirname(__FILE__)."/../UtlConvert.class.php";
  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";

  class RNTEstimate extends RNTBase
  {

    public function __construct($connection){
         parent::__construct($connection);
    }

    public function save2BU($value)
     {
        $statement = "
          begin
         :var1 := rnt_properties_pkg.estimate2BU(".
        "  X_PROP_ID         => :var2".
        ", X_BUSINESS_ID     => :var3".
        ", X_ESTIMATE_TITLE  => :var4".
        ", X_MONTHLY_RENT    => :var5".
        ", X_OTHER_INCOME    => :var6".
        ", X_VACANCY_PCT     => :var7".
        ", X_REPLACE_3YEARS  => :var8".
        ", X_REPLACE_5YEARS  => :var9".
        ", X_REPLACE_12YEARS => :var10".
        ", X_MAINTENANCE     => :var11".
        ", X_UTILITIES       => :var12".
        ", X_PROPERTY_TAXES  => :var13".
        ", X_INSURANCE       => :var14".
        ", X_MGT_FEES        => :var15".
        ", X_DOWN_PAYMENT    => :var16".
        ", X_CLOSING_COSTS   => :var17".
        ", X_PURCHASE_PRICE  => :var18".
        ", X_CAP_RATE        => :var19".
        ", X_LOAN1_AMOUNT    => :var20".
        ", X_LOAN1_TYPE      => :var21".
        ", X_LOAN1_TERM      => :var22".
        ", X_LOAN1_RATE      => :var23".
        ", X_LOAN2_AMOUNT    => :var24".
        ", X_LOAN2_TYPE      => :var25".
        ", X_LOAN2_TERM      => :var26".
        ", X_LOAN2_RATE      => :var27);";
        $statement .= " end;";

        $prepare = $this->connection->prepareStatement($statement);

        $prepare->set(1, '23423423123');
        $prepare->set(2, $value["PROP_ID"]);
        $prepare->set(3, $value["BUSINESS_ID"]);
        $prepare->setString(4, $value["ESTIMATE_TITLE"]);
        $prepare->set(5, UtlConvert::DisplayNumericToDB($value["MONTHLY_RENT"]));
        $prepare->set(6, UtlConvert::DisplayNumericToDB($value["OTHER_INCOME"]));
        $prepare->set(7, UtlConvert::DisplayNumericToDB($value["VACANCY_PCT"]));
        $prepare->set(8, UtlConvert::DisplayNumericToDB($value["REPLACE_3YEARS"]));
        $prepare->set(9, UtlConvert::DisplayNumericToDB($value["REPLACE_5YEARS"]));
        $prepare->set(10, UtlConvert::DisplayNumericToDB($value["REPLACE_12YEARS"]));
        $prepare->set(11, UtlConvert::DisplayNumericToDB($value["MAINTENANCE"]));
        $prepare->set(12, UtlConvert::DisplayNumericToDB($value["UTILITIES"]));
        $prepare->set(13, UtlConvert::DisplayNumericToDB($value["PROPERTY_TAXES"]));
        $prepare->set(14, UtlConvert::DisplayNumericToDB($value["INSURANCE"]));
        $prepare->set(15, UtlConvert::DisplayNumericToDB($value["MGT_FEES"]));
        $prepare->set(16, UtlConvert::DisplayNumericToDB($value["DOWN_PAYMENT"]));
        $prepare->set(17, UtlConvert::DisplayNumericToDB($value["CLOSING_COSTS"]));
        $prepare->set(18, UtlConvert::DisplayNumericToDB($value["PURCHASE_PRICE"]));
        $prepare->set(19, UtlConvert::DisplayNumericToDB($value["CAP_RATE"]));
        $prepare->set(20, UtlConvert::DisplayNumericToDB($value["LOAN1_AMOUNT"]));
        $prepare->set(21, $value["LOAN1_TYPE"]);
        $prepare->set(22, UtlConvert::DisplayNumericToDB($value["LOAN1_TERM"]));
        $prepare->set(23, UtlConvert::DisplayNumericToDB($value["LOAN1_RATE"]));
        $prepare->set(24, UtlConvert::DisplayNumericToDB($value["LOAN2_AMOUNT"]));
        $prepare->set(25, $value["LOAN2_TYPE"]);
        $prepare->set(26, UtlConvert::DisplayNumericToDB($value["LOAN2_TERM"]));
        $prepare->set(27, UtlConvert::DisplayNumericToDB($value["LOAN2_RATE"]));
        

        @$prepare->executeUpdate();
        return OCI8PreparedStatementVars::getVar($prepare, 1);
     }

    public function getYearList5()
    {
        $start = intval(date("Y"))-5;
        $list  = array(""=>"");
        for($i=1; $i<=10; $i++) {
            $list[$start + $i] = $start + $i;
        }
        return $list;   
    }
    
    public function getEstimateList($propertyID)
    {
        return 	$this->sql2array("
                           select PROPERTY_ESTIMATES_ID, PROPERTY_ID, BUSINESS_ID, 
                                  ESTIMATE_YEAR, ESTIMATE_TITLE
                           from   RNT_PROPERTY_ESTIMATES_V
                           where  PROPERTY_ID = :var1
                           order  by ESTIMATE_YEAR, ESTIMATE_TITLE", $propertyID);
    }
    
    
    public function getEstimate($propertyEstimateID)
    {
        return 	$this->getSingleRow("
                         select 
							   PROPERTY_ESTIMATES_ID, PROPERTY_ID, BUSINESS_ID, 
							   ESTIMATE_YEAR, to_char(ESTIMATE_YEAR, 'RRRR') as ESTIMATE_YEAR_VAL, ESTIMATE_TITLE, MONTHLY_RENT, 
							   OTHER_INCOME, VACANCY_PCT, REPLACE_3YEARS, 
							   REPLACE_5YEARS, REPLACE_12YEARS, MAINTENANCE, 
							   UTILITIES, PROPERTY_TAXES, INSURANCE, 
							   MGT_FEES, DOWN_PAYMENT, CLOSING_COSTS, 
							   PURCHASE_PRICE, CAP_RATE, LOAN1_AMOUNT, 
							   LOAN1_TYPE, LOAN1_TERM, LOAN1_RATE, 
							   LOAN2_AMOUNT, LOAN2_TYPE, LOAN2_TERM, 
							   LOAN2_RATE, NOTES, CHECKSUM
						  from RNT_PROPERTY_ESTIMATES_V
						  where PROPERTY_ESTIMATES_ID = :var1", $propertyEstimateID);
    }
    
    public function loadParams($propertyID)
    {
        return 	$this->sql2array("
    	        select 0         PAYMENT_TYPE_ID,
              'avg rent'    as PAYMENT_TYPE_NAME, 
              sum(max_rent) as AMOUNT_NEED,
              0             as AMOUNT_RECEIVED
              FROM (select UNIT_NAME,
                        round(max(AMOUNT*decode(AMOUNT_PERIOD, '2WEEKS', 2, 'BI-MONTH', 0.5, 'MONTH', 1, 'WEEK', 4)), 2) 
                              as max_rent
                        from RNT_TENANCY_AGREEMENT ta, 
                             RNT_PROPERTY_UNITS u
                        where u.PROPERTY_ID = :var1
                          and u.UNIT_ID = ta.UNIT_ID                                        
                          and (    
                                 (DATE_AVAILABLE  >= add_months(SYSDATE, -12) and DATE_AVAILABLE  < SYSDATE)  
                                 or 
                                 (    DATE_AVAILABLE < add_months(SYSDATE, -12)
                                  and not exists (select 1 
                                                  from RNT_TENANCY_AGREEMENT t1
                                                  where t1.AGREEMENT_ID = ta.AGREEMENT_ID
                                                    and t1.DATE_AVAILABLE >= add_months(SYSDATE, -12) 
                                                 ) 
                                 )
                              )
                      group by UNIT_NAME)
                union all 	
    	        SELECT
		                PT.PAYMENT_TYPE_ID,
		                PT.PAYMENT_TYPE_NAME,
		                SUM(PA.AMOUNT) AMOUNT_RECEIVED,
		                SUM(AR.AMOUNT) AMOUNT_NEED
                FROM RNT_PAYMENT_TYPES PT,
                     RNT_ACCOUNTS_RECEIVABLE AR,
                    (select AR_ID, sum(AMOUNT) as AMOUNT from RNT_PAYMENT_ALLOCATIONS group by AR_ID) PA
                WHERE AR.PAYMENT_PROPERTY_ID = :var1
                  and AR.PAYMENT_TYPE = PT.PAYMENT_TYPE_ID
                  and AR.AR_ID = PA.AR_ID (+)
                  and ar.payment_due_date >= add_months(SYSDATE, -12)
                  and ar.payment_due_date < SYSDATE
                group by PT.PAYMENT_TYPE_NAME,PT.PAYMENT_TYPE_ID
                union all
                select  
		                0 as PAYMENT_TYPE_ID,
		                case 
                           when SERVICE_LIFE = 0 then PAYMENT_TYPE_NAME
                           when SERVICE_LIFE > 0 and SERVICE_LIFE < 3 then 'Maintenance'
                           when SERVICE_LIFE >= 3 and SERVICE_LIFE < 5 then '3 Year Replacements'
                           when SERVICE_LIFE >= 5 and SERVICE_LIFE < 12 then '5 Year Replacements'
                           else  '12 Year Replacements'
                        end as PAYMENT_TYPE_NAME,
		                SUM(AP.AMOUNT) AMOUNT_NEED,
		                SUM(PA.AMOUNT) AMOUNT_RECEIVED
                FROM RNT_PAYMENT_TYPES PT,
                     RNT_ACCOUNTS_PAYABLE AP,
                     (select AP_ID, sum(AMOUNT) as AMOUNT from RNT_PAYMENT_ALLOCATIONS group by AP_ID) PA
                WHERE AP.PAYMENT_PROPERTY_ID = :var1
                  AND AP.PAYMENT_TYPE_ID = PT.PAYMENT_TYPE_ID
                  AND AP.AP_ID = PA.AP_ID (+)
                  and ap.payment_due_date >= add_months(SYSDATE, -12)
                  and ap.payment_due_date < SYSDATE
                group by case 
                           when SERVICE_LIFE = 0 then PT.PAYMENT_TYPE_NAME
                           when SERVICE_LIFE > 0 and SERVICE_LIFE < 3 then 'Maintenance'
                           when SERVICE_LIFE >= 3 and SERVICE_LIFE < 5 then '3 Year Replacements'
                           when SERVICE_LIFE >= 5 and SERVICE_LIFE < 12 then '5 Year Replacements'
                           else  '12 Year Replacements'
                        end
                union all
                select 1000, 'Purchase Price', PURCHASE_PRICE, 0
                from RNT_PROPERTIES
                where PROPERTY_ID = :var1
    	        union all
    	        select 1001, 'Closing Costs', NVL(sum(CLOSING_COSTS), 0) CLOSING_COSTS, 0
                from RNT_LOANS
                where loan_date >= add_months(SYSDATE, -12)
                  and loan_date < SYSDATE
                  and PROPERTY_ID = :var1
                ", $propertyID);
    	
    }
    
    public function getLOANS($propertyID)
    {
        return 	$this->sql2array(
    	        "
				select max(decode(POSITION, 1, LOAN_AMOUNT, NULL)) as LOAN1_AMOUNT, 
				       max(decode(POSITION, 1, TERM, NULL)) as LOAN1_TERM,
				       max(decode(POSITION, 1, INTEREST_RATE, NULL)) as LOAN1_RATE,
				       max(decode(POSITION, 2, LOAN_AMOUNT, NULL)) as LOAN2_AMOUNT, 
				       max(decode(POSITION, 2, TERM, NULL)) as LOAN2_TERM,
				       max(decode(POSITION, 2, INTEREST_RATE, NULL)) as LOAN2_RATE
				from RNT_LOANS
				where PROPERTY_ID = :var1
				  and POSITION in (1, 2)
                ",   $propertyID
			);
    }

    private function Operation(&$value, $operation)
    {
       $proc = "";
       switch($operation )
       {
        case (RNTBase::UPDATE_ROW) : $proc = "UPDATE_ROW"; break;
        case (RNTBase::INSERT_ROW) : $proc = "INSERT_ROW"; break;
        default : throw new Exception("Value not allowed.");
       }

       $statement = "";
       if ($operation == RNTBase::UPDATE_ROW)
               $statement = "
                 begin
                  RNT_PROPERTY_ESTIMATES_PKG.$proc(
                     X_PROPERTY_ESTIMATES_ID => :var1,";
       else if ($operation == RNTBase::INSERT_ROW)
         $statement = "
                 begin
                  :var1 := RNT_PROPERTY_ESTIMATES_PKG.$proc(";

       $statement .= 
	"  X_PROPERTY_ID                    => :var2".
	", X_BUSINESS_ID                    => :var3".
	", X_ESTIMATE_YEAR                  => :var4".
	", X_ESTIMATE_TITLE                 => :var5".
	", X_MONTHLY_RENT                   => :var6".
	", X_OTHER_INCOME                   => :var7".
	", X_VACANCY_PCT                    => :var8".
	", X_REPLACE_3YEARS                 => :var9".
	", X_REPLACE_5YEARS                 => :var10".
	", X_REPLACE_12YEARS                => :var11".
	", X_MAINTENANCE                    => :var12".
	", X_UTILITIES                      => :var13".
	", X_PROPERTY_TAXES                 => :var14".
	", X_INSURANCE                      => :var15".
	", X_MGT_FEES                       => :var16".
	", X_DOWN_PAYMENT                   => :var17".
	", X_CLOSING_COSTS                  => :var18".
	", X_PURCHASE_PRICE                 => :var19".
	", X_CAP_RATE                       => :var20".
	", X_LOAN1_AMOUNT                   => :var21".
	", X_LOAN1_TYPE                     => :var22".
	", X_LOAN1_TERM                     => :var23".
	", X_LOAN1_RATE                     => :var24".
	", X_LOAN2_AMOUNT                   => :var25".
	", X_LOAN2_TYPE                     => :var26".
	", X_LOAN2_TERM                     => :var27".
	", X_LOAN2_RATE                     => :var28".
	", X_NOTES                          => :var29"
             ;

        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= ",X_CHECKSUM => :var30";

        $statement .= "); end;";

        $prepare = $this->connection->prepareStatement($statement);

        if ($operation == RNTBase::INSERT_ROW)
           // blank value for initial
           $prepare->set(1, '23423423123');
        else if ($operation == RNTBase::UPDATE_ROW)
           $prepare->setInt(1, $value["PROPERTY_ESTIMATES_ID"]);
        
		$prepare->set(2, $value["PROPERTY_ID"]);
		$prepare->set(3, $value["BUSINESS_ID"]);
		$prepare->set(4, UtlConvert::displayToDBDate('01/01/'.$value["ESTIMATE_YEAR"]));
		$prepare->setString(5, $value["ESTIMATE_TITLE"]);
		$prepare->set(6, UtlConvert::DisplayNumericToDB($value["MONTHLY_RENT"]));
		$prepare->set(7, UtlConvert::DisplayNumericToDB($value["OTHER_INCOME"]));
		$prepare->set(8, UtlConvert::DisplayNumericToDB($value["VACANCY_PCT"]));
		$prepare->set(9, UtlConvert::DisplayNumericToDB($value["REPLACE_3YEARS"]));
		$prepare->set(10, UtlConvert::DisplayNumericToDB($value["REPLACE_5YEARS"]));
		$prepare->set(11, UtlConvert::DisplayNumericToDB($value["REPLACE_12YEARS"]));
		$prepare->set(12, UtlConvert::DisplayNumericToDB($value["MAINTENANCE"]));
		$prepare->set(13, UtlConvert::DisplayNumericToDB($value["UTILITIES"]));
		$prepare->set(14, UtlConvert::DisplayNumericToDB($value["PROPERTY_TAXES"]));
		$prepare->set(15, UtlConvert::DisplayNumericToDB($value["INSURANCE"]));
		$prepare->set(16, UtlConvert::DisplayNumericToDB($value["MGT_FEES"]));
		$prepare->set(17, UtlConvert::DisplayNumericToDB($value["DOWN_PAYMENT"]));
		$prepare->set(18, UtlConvert::DisplayNumericToDB($value["CLOSING_COSTS"]));
		$prepare->set(19, UtlConvert::DisplayNumericToDB($value["PURCHASE_PRICE"]));
		$prepare->set(20, UtlConvert::DisplayNumericToDB($value["CAP_RATE"]));
		$prepare->set(21, UtlConvert::DisplayNumericToDB($value["LOAN1_AMOUNT"]));
		$prepare->set(22, $value["LOAN1_TYPE"]);
		$prepare->set(23, UtlConvert::DisplayNumericToDB(@$value["LOAN1_TERM"]));
		$prepare->set(24, UtlConvert::DisplayNumericToDB($value["LOAN1_RATE"]));
		$prepare->set(25, UtlConvert::DisplayNumericToDB($value["LOAN2_AMOUNT"]));
		$prepare->set(26, $value["LOAN2_TYPE"]);
		$prepare->set(27, UtlConvert::DisplayNumericToDB(@$value["LOAN2_TERM"]));
		$prepare->set(28, UtlConvert::DisplayNumericToDB($value["LOAN2_RATE"]));
		$prepare->set(29, $value["NOTES"]);
		
        if ($operation == RNTBase::UPDATE_ROW)
             $prepare->set(30, $value["CHECKSUM"]);

        @$prepare->executeUpdate();

        if ($operation == RNTBase::INSERT_ROW)
          return OCI8PreparedStatementVars::getVar($prepare, 1);
    }

    public function Update(&$values)
    {
        $this->Operation($values, RNTBase::UPDATE_ROW);
    }

    public function Insert(&$values)
    {
        return $this->Operation($values, RNTBase::INSERT_ROW);
    }
    
    public function delete($id)
    {
        if ($id == null) {
            return;
        }
        $statement = "begin RNT_PROPERTY_ESTIMATES_PKG.DELETE_ROW(X_PROPERTY_ESTIMATES_ID  => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $id);
        @$prepare->executeUpdate();
    }

  } // ---- class...

?>
