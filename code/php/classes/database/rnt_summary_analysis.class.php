<?php
  require_once dirname(__FILE__)."/../UtlConvert.class.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";

  class RNTSummaryAnalysis extends RNTBase
  {

    public function __construct($connection){
         parent::__construct($connection);
    }

    private function getDataList($businessID, $sql)
    {
	  
        $return = array();
        if ($businessID == NULL) {
            return $return;
        }
  	    $stmt = $this->connection->prepareStatement($sql);
        $stmt->setString(1, $businessID);
		$rs = $stmt->executeQuery();

        
        while($rs->next()) {
            $return[] = $rs->getRow();
        }
        return $return;
    }

    public function getCashFlow($businessID)
    {
        return $this->getDataList($businessID,
                                "select to_char(month_date, 'RRRRMM') as YEAR_MONTH,
                                        to_char(month_date, 'Mon') as MONTH_NAME,
                                        INCOME_AMOUNT,
                                        EXPENSE_AMOUNT,
                                        CASH_FLOW
                                 from table(RNT_SUMMARY_PKG.GET_SUMMARY1(:var1))
                                 order by MONTH_DATE");

    }

    public function getUncollectedIncome($businessID)
    {
        return $this->getDataList($businessID,
                                "select to_char(month_date, 'RRRRMM') as YEAR_MONTH,
                                        to_char(month_date, 'Mon') as MONTH_NAME,
                                        UNCOLLECTED_INCOME
                                 from table(RNT_SUMMARY_PKG.GET_SUMMARY1(:var1))
                                 order by MONTH_DATE");
    }

    public function getUnpaidInvoices($businessID)
    {
        return $this->getDataList($businessID,
                                "select to_char(month_date, 'RRRRMM') as YEAR_MONTH,
                                        to_char(month_date, 'Mon') as MONTH_NAME,
                                        UNPAID_INVOICES
                                 from table(RNT_SUMMARY_PKG.GET_SUMMARY1(:var1))
                                 order by MONTH_DATE");
    }

    public function getPeriodAnalysesValues($businessID)
    {
        return $this->getDataList($businessID,
                                "select to_char(month_date, 'RRRRMM') as YEAR_MONTH,
                                        to_char(month_date, 'Mon') as MONTH_NAME,
                                        BUSINESS_ID,
                                        INCOME_AMOUNT,
                                        EXPENSE_AMOUNT,
                                        CASH_FLOW,
                                        OWED_AMOUNT,
                                        UNCOLLECTED_INCOME,
                                        INVOICED_AMOUNT,
                                        UNPAID_INVOICES
                                 from table(RNT_SUMMARY_PKG.GET_SUMMARY1(:var1))
                                 order by MONTH_DATE");
    }

    function getCurrentMonthCashFlow($businessID)
    {
        return $this->getDataList($businessID,
              " select to_char(interval_days.MONTH_DAY, 'dd') as MONTH_DAY,
                       NVL(income.INCOME_AMOUNT, 0) as INCOME_AMOUNT,
                       NVL(expense.EXPENSE_AMOUNT, 0) as EXPENSE_AMOUNT,
                       NVL(income.INCOME_AMOUNT, 0) - NVL(expense.EXPENSE_AMOUNT, 0) as CASH_FLOW,
                       to_char(interval_days.MONTH_DAY, 'RRRRMM') YEAR_MONTH
                from (
                      select trunc(SYSDATE, 'MM')+level-1 as MONTH_DAY
                      from dual
                      connect by level <= to_number(to_char(SYSDATE, 'DD'))
                     ) interval_days,
                    (
                      select trunc(pa.payment_date) MONTH_DAY, sum(pa.amount) INCOME_AMOUNT
                      from rnt_accounts_receivable ar
                         , rnt_payment_allocations pa
                      where ar.ar_id = pa.ar_id
                        and ar.BUSINESS_ID = :var1
                        and to_char(ar.payment_due_date, 'MON-YYYY') = to_char(sysdate, 'MON-YYYY')
                      group by trunc(pa.payment_date)
                     )  income,
                    (
                      select trunc(pa.payment_date) as MONTH_DAY, sum(pa.amount)  EXPENSE_AMOUNT
                      from rnt_accounts_payable ap
                         , rnt_payment_allocations pa
                      where ap.ap_id = pa.ap_id
                        and ap.BUSINESS_ID = :var1
                        and to_char(ap.payment_due_date, 'MON-YYYY') = to_char(sysdate, 'MON-YYYY')
                      group by trunc(pa.payment_date)
                    ) expense
                where interval_days.MONTH_DAY = income.MONTH_DAY(+)
                  and interval_days.MONTH_DAY = expense.MONTH_DAY(+)
                order by interval_days.MONTH_DAY");
    }


    function getCurrentYearCashFlow($businessID)
    {
        return $this->getDataList($businessID,
              "  select to_char(interval_days.MONTH_DAY, 'MON') as MONTH_NAME,
                       NVL(income.INCOME_AMOUNT, 0) as INCOME_AMOUNT,
                       NVL(expense.EXPENSE_AMOUNT, 0) as EXPENSE_AMOUNT,
                       NVL(income.INCOME_AMOUNT, 0) - NVL(expense.EXPENSE_AMOUNT, 0) as CASH_FLOW,
                       to_char(interval_days.MONTH_DAY, 'RRRRMM') YEAR_MONTH
                from (
                      select ADD_MONTHS(trunc(SYSDATE, 'RRRR'), level-1) as MONTH_DAY
                      from dual
                      connect by level <= MONTHS_BETWEEN(trunc(SYSDATE, 'MM'), trunc(SYSDATE, 'RRRR'))+1
                     ) interval_days,
                    (
                      select trunc(ar.payment_due_date, 'MM') MONTH_DAY, sum(pa.amount) INCOME_AMOUNT
                      from rnt_accounts_receivable ar
                         , rnt_payment_allocations pa
                      where ar.ar_id = pa.ar_id
                        and ar.BUSINESS_ID = :var1
                      group by trunc(payment_due_date, 'MM')
                     )  income,
                    (
                      select trunc(payment_due_date, 'MM') as MONTH_DAY, sum(pa.amount)  EXPENSE_AMOUNT
                      from rnt_accounts_payable ap
                         , rnt_payment_allocations pa
                      where ap.ap_id = pa.ap_id
                        and ap.BUSINESS_ID = :var1
                      group by trunc(payment_due_date, 'MM')
                    ) expense
                where interval_days.MONTH_DAY = income.MONTH_DAY(+)
                  and interval_days.MONTH_DAY = expense.MONTH_DAY(+)
                order by interval_days.MONTH_DAY");
    }

    public function getNOI($businessID)
    {
        return $this->getDataList($businessID,
                                "select PROPERTY_ID,
                                        ADDRESS1,
                                        NOI_VALUE,
                                        CAP_RATE_VALUE
                                 from table(RNT_SUMMARY_PKG.GET_NOI(:var1))
                                 order by ADDRESS1");
    }

    public function getAlertList($businessID)
    {
        return $this->getDataList($businessID,
                               "select PROPERTY_ID, UNIT_ID, BUSINESS_ID,
                                       DESCRIPTION, PAYMENT_DUE_MONTH, AGREEMENT_ID,
                                       TENANT_ID,
                                       decode(RECORD_TYPE, RNT_SUMMARY_PKG.FLAG_AGR_EXPIRED_VALUE, 'Y', 'N')         as IS_AGREEMENT_EXPIRED,
                                       decode(RECORD_TYPE, RNT_SUMMARY_PKG.FLAG_VACANT_VALUE, 'Y', 'N')              as IS_VACANT,
                                       decode(RECORD_TYPE, RNT_SUMMARY_PKG.FLAG_TENANT_OWED_VALUE, 'Y', 'N')         as IS_TENANT_OWED,
                                       decode(RECORD_TYPE, RNT_SUMMARY_PKG.FLAG_UNPAID_BALANCE_VALUE, 'Y', 'N')      as IS_UNPAID_BALANCE,
                                       decode(RECORD_TYPE, RNT_SUMMARY_PKG.FLAG_UNCOLLECTED_INCOME_VALUE, 'Y', 'N')  as IS_UNCOLLECTED_INCOME,
                                       decode(RECORD_TYPE, RNT_SUMMARY_PKG.FLAG_NOT_PROPERTIES_VALUE, 'Y', 'N')      as IS_NO_PROPERTIES,
                                       decode(RECORD_TYPE, RNT_SUMMARY_PKG.FLAG_UNINVOICED_EXPENSE, 'Y', 'N')       as IS_UNINVOICED
                                from table(rnt_summary_pkg.get_alerts(:var1))");
    }

    public function getSummaryTable($businessID)
    {
        return $this->getDataList($businessID,
               "    select PROPERTY_ID, ADDRESS1, BUSINESS_ID, INCOME_AMOUNT,
                           EXPENSE_AMOUNT, CASH_FLOW, OWED_AMOUNT,
                           UNCOLLECTED_INCOME, INVOICED_AMOUNT,
                           UNPAID_INVOICES, NOI_VALUE, CAP_RATE_VALUE
                    from table(RNT_SUMMARY_PKG.GET_SUMMARY3(:var1))
                    order by ADDRESS1");
    }

    function getDataCashFlowSummary($businessID, $dateCond)
    {
        return $this->getDataList($businessID,
        "select
               NVL(income_received.INCOME_AMOUNT, 0) as INCOME_AMOUNT_RECEIVED,
               NVL(expense_paid.EXPENSE_AMOUNT, 0) as EXPENSE_AMOUNT_PAID,
               NVL(income_received.INCOME_AMOUNT, 0) - NVL(expense_paid.EXPENSE_AMOUNT, 0) as CASH_FLOW,
               NVL(income_owed.OWED_AMOUNT, 0) as INCOME_OWED_AMOUNT,
               NVL(expense_owed.INVOICED_AMOUNT, 0) as INVOICED_AMOUNT,
               NVL(income_owed.OWED_AMOUNT, 0) - NVL(expense_owed.INVOICED_AMOUNT, 0) as OWED_CASH_FLOW
        from  (
                select sum(pa.amount) INCOME_AMOUNT
                from rnt_accounts_receivable ar
                   , rnt_payment_allocations pa
                where ar.ar_id = pa.ar_id
                  and ar.BUSINESS_ID = :var1
                  and payment_due_date between $dateCond and SYSDATE
              )  income_received,
              (
                select sum(pa.amount)  EXPENSE_AMOUNT
                from rnt_accounts_payable ap
                ,    rnt_payment_allocations pa
                where ap.ap_id = pa.ap_id
                  and ap.BUSINESS_ID = :var1
                  and payment_due_date between $dateCond and SYSDATE
              ) expense_paid,
              (select sum(ar.amount)  OWED_AMOUNT
               from rnt_accounts_receivable ar
               where ar.BUSINESS_ID = :var1
                 and payment_due_date between $dateCond and SYSDATE
              ) income_owed,
              (
                select sum(ap.amount)  INVOICED_AMOUNT
                from rnt_accounts_payable ap
                where BUSINESS_ID = :var1
                  and payment_due_date between $dateCond and SYSDATE
              ) expense_owed");
    }


    function getCashFlowSum($businessID)
    {
        $a = array("LAST12MONTH" => "trunc(ADD_MONTHS(SYSDATE, -12))",
                   "LAST_MONTH" => "trunc(SYSDATE, 'MM')",
                   "YEAR_TO_DATE" => "trunc(SYSDATE, 'RRRR')");
        $retVal = array();
        foreach($a as $k=>$v) {
            $x = $this->getDataCashFlowSummary($businessID, $v);
            $x = @$x[0];
            $retVal[$k] = array("OWED" => array("t1"=>$x["INCOME_OWED_AMOUNT"], "t2"=>$x["INVOICED_AMOUNT"], "t3"=>$x["OWED_CASH_FLOW"]),
                                "RECEIVED_PAID" => array("t1"=>$x["INCOME_AMOUNT_RECEIVED"], "t2"=>$x["EXPENSE_AMOUNT_PAID"], "t3"=>$x["CASH_FLOW"]),
                                "TOTAL" => array("t1"=>($x["INCOME_OWED_AMOUNT"]-$x["INCOME_AMOUNT_RECEIVED"]), "t2"=>($x["INVOICED_AMOUNT"]-$x["EXPENSE_AMOUNT_PAID"]), "t3"=>($x["OWED_CASH_FLOW"]-$x["CASH_FLOW"])));
        }
       return $retVal;
    }
    
    function getBUwhereNotProperties($business_id)
    {
        if (!$business_id) {
            return array();
        }
    	return $this->sql2array("select BUSINESS_ID, BUSINESS_NAME 
								 from RNT_BUSINESS_UNITS_V bu
								 where BUSINESS_ID = :var1
								   and not exists (select 1 
								                   from RNT_PROPERTIES p
								                   where p.BUSINESS_ID = bu.BUSINESS_ID)
								 order by bu.BUSINESS_NAME", $business_id);
    }
  }
?>