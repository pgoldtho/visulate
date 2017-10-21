<?
  require_once dirname(__FILE__)."/../LOV.class.php";
  require_once dirname(__FILE__)."/../UtlConvert.class.php";
  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";

class RNTLedger extends RNTBase
{

    public function __construct($connection){
         parent::__construct($connection);
    }

    public function newPeriod($business_id, $start_date)
    {
        $statement =
        "begin :var1 := RNT_ACCOUNT_PERIODS_PKG.INSERT_ROW( X_BUSINESS_ID => :var2"
                                                        .", X_START_DATE  => to_date(:var3, 'mm/dd/yyyy')"
                                                        .", X_CLOSED_YN   => 'N');".
        "end;";
        
        $prepare = $this->connection->prepareStatement($statement);

        // blank value for initial
        $prepare->set(1, '23423423123123123');
        $prepare->set(2, $business_id);
        $prepare->set(3, $start_date);
        
        @$prepare->executeUpdate();

        return OCI8PreparedStatementVars::getVar($prepare, 1);
    }
    
    public function deletePeriod($period_id)
    {
        if ($period_id == null) {
            return;
        }
        $statement = "begin RNT_ACCOUNT_PERIODS_PKG.DELETE_ROW(X_PERIOD_ID  => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $period_id);
        @$prepare->executeUpdate();
    }

    public function getPeriodDates($period_id)
    {
        $result = array();
        $query = "select to_char(p.start_date, 'mm/dd/yyyy') start_date
                  ,      to_char(nvl(min(pe.start_date - 1), sysdate + 365), 'mm/dd/yyyy') end_date
                  from rnt_account_periods p
                  ,    rnt_account_periods pe
                  where p.period_id = :var1
                  and  pe.business_id (+) = p.business_id 
                  and pe.start_date   (+) > p.start_date
                  group by p.start_date";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $period_id);
        $rs = $stmt->executeQuery();
        
        while($rs->next()) 
        {
            $r = $rs->getRow();
            $result = array( "PERIOD_START" => $r["START_DATE"]
                           , "PERIOD_END"   => $r["END_DATE"]);
        }
        return $result;
    }	  
	  
    public function getAccountList($business_id)
    {
        $result = array();
        $query = "select account_id
                  ,      account_number ||' - '||name account_name
                  from rnt_accounts
                  where business_id = :var1
                  order by account_number";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $business_id);
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $r = $rs->getRow();
            $result[$r["ACCOUNT_ID"]] =  $r["ACCOUNT_NAME"];  
        }
        return $result;
    }    
}

?>