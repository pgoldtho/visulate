<?php

require_once dirname(__FILE__)."/../LOV.class.php";
require_once dirname(__FILE__)."/../UtlConvert.class.php";
require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
require_once dirname(__FILE__)."/rnt_base.class.php";

    class RNTSummary extends RNTBase
    {
        public function __construct($connection){
            parent::__construct($connection);
        }
        public function getBusinessIdByPropertyId($payment_property_id)
        {
            $arr_results = array();
            if ($payment_property_id == NULL)
            {
                return $arr_results;
            }

            $query = "SELECT BUSINESS_ID FROM RNT_PROPERTIES WHERE PROPERTY_ID=:var1";
            $stmt = $this->connection->prepareStatement($query);
            $stmt->setInt(1, $payment_property_id);
            $rs = $stmt->executeQuery();

            while($rs->next()) {
                $arr_results[] = $rs->getRow();
            }
            $rs->close();

            $int_result = 0;
            if(!isset($arr_results[0])){}
            else {
                $int_result = $arr_results[0]["BUSINESS_ID"];
            }
            return $int_result;
        }
        public function getResultsAtCenter($payment_property_id,$year)
        {
            $arr_results = array("RECEIVABLE"=>array(),"PAYABLE"=>array(),);
            if ($payment_property_id == NULL)
            {
                return $arr_results;
            }

            //
            $query = "select DISTINCT
                             TO_CHAR(AR.PAYMENT_DUE_DATE,'YYYY') YEAR_
                      from   RNT_ACCOUNTS_RECEIVABLE AR
                      WHERE  AR.PAYMENT_PROPERTY_ID = :var1
                      ORDER  BY YEAR_ DESC";
            $stmt = $this->connection->prepareStatement($query);
            $stmt->setInt(1, $payment_property_id);
            $rs = $stmt->executeQuery();

            while($rs->next())
            {
                $row = $rs->getRow();
                $arr_results["RECEIVABLE"]["years"][] = $row["YEAR_"];
            }
            $rs->close();

            
            //
            $query = "SELECT DISTINCT
                             TO_CHAR(AP.PAYMENT_DUE_DATE,'YYYY') YEAR_
                      FROM   RNT_ACCOUNTS_PAYABLE AP
                      WHERE  AP.PAYMENT_PROPERTY_ID = :var1
                      ORDER  BY YEAR_ DESC";
            $stmt = $this->connection->prepareStatement($query);
            $stmt->setInt(1, $payment_property_id);
            $rs = $stmt->executeQuery();

            while($rs->next())
            {
                $row = $rs->getRow();
                $arr_results["PAYABLE"]["years"][] = $row["YEAR_"];
            }
            $rs->close();

            $query = "SELECT PT.PAYMENT_TYPE_ID,
                             PT.PAYMENT_TYPE_NAME,
                             SUM(AR.AMOUNT) AMOUNT_OWED,
                             SUM(PA.AMOUNT) AMOUNT_RECEIVED
                      FROM   RNT_PAYMENT_TYPES PT,
                             RNT_ACCOUNTS_RECEIVABLE AR,
                             (select AR_ID, sum(AMOUNT) as AMOUNT from RNT_PAYMENT_ALLOCATIONS group by AR_ID) PA
                      WHERE  AR.PAYMENT_PROPERTY_ID = :var1
                      AND    AR.PAYMENT_TYPE = PT.PAYMENT_TYPE_ID
                      AND    AR.AR_ID = PA.AR_ID (+)
                      AND    TO_CHAR(AR.PAYMENT_DUE_DATE,'YYYY') = :var2
                      GROUP  BY PT.PAYMENT_TYPE_NAME,PT.PAYMENT_TYPE_ID";
            $stmt = $this->connection->prepareStatement($query);
            $stmt->setInt(1, $payment_property_id);
            $stmt->setString(2, $year);
            $rs = $stmt->executeQuery();

            while($rs->next())
            {
                $arr_results["RECEIVABLE"]["types"][] = $rs->getRow();
            }
            $rs->close();

            
            //
            $query = "SELECT PT.PAYMENT_TYPE_ID,
                             PT.PAYMENT_TYPE_NAME,
                             SUM(AP.AMOUNT) AMOUNT_OWED,
                             SUM(PA.AMOUNT) AMOUNT_RECEIVED
                      FROM   RNT_PAYMENT_TYPES PT,
                             RNT_ACCOUNTS_PAYABLE AP,
                             (select AP_ID, sum(AMOUNT) as AMOUNT from RNT_PAYMENT_ALLOCATIONS group by AP_ID) PA
                      WHERE  AP.PAYMENT_PROPERTY_ID = :var1
                      AND    AP.PAYMENT_TYPE_ID = PT.PAYMENT_TYPE_ID
                      AND    AP.AP_ID = PA.AP_ID (+)
                      AND    TO_CHAR(AP.PAYMENT_DUE_DATE,'YYYY') = :var2
                      GROUP  BY PT.PAYMENT_TYPE_NAME,PT.PAYMENT_TYPE_ID";
            $stmt = $this->connection->prepareStatement($query);
            $stmt->setInt(1, $payment_property_id);
            $stmt->setString(2, $year);
            $rs = $stmt->executeQuery();

            while($rs->next()) {
                $arr_results["PAYABLE"]["types"][] = $rs->getRow();
            }
            $rs->close();

            return $arr_results;
        }
        public function getResultsAtRight($payment_property_id,$payment_type,$year,$type)
        {
            $arr_results = array();
            if ($payment_property_id == NULL)
            {
                return $arr_results;
            }

            if($type=="RECEIVABLE")
            {
                $query = "SELECT TO_CHAR(AR.PAYMENT_DUE_DATE,'MM/DD/YYYY') DATE_,
                                 --AR.AMOUNT AMOUNT_OWED,
                                 AR.AMOUNT - NVL((select sum(AMOUNT) from RNT_PAYMENT_ALLOCATIONS where AR_ID = AR.AR_ID and NVL(PAY_ALLOC_ID, -1) != NVL(PA.PAY_ALLOC_ID, -2)), 0) AMOUNT_OWED,
                                 PA.PAYMENT_DATE,
                                 PA.AMOUNT AMOUNT_RECEIVED
                          FROM   RNT_ACCOUNTS_RECEIVABLE AR,
                                 RNT_PAYMENT_ALLOCATIONS PA
                          WHERE  AR.PAYMENT_PROPERTY_ID = :var1
                          AND    AR.PAYMENT_TYPE        = :var2
                          AND    TO_CHAR(AR.PAYMENT_DUE_DATE,'YYYY') = :var3
                          AND    AR.AR_ID = PA.AR_ID (+)
                          ORDER  BY AR.PAYMENT_DUE_DATE ASC";
                $stmt = $this->connection->prepareStatement($query);
                $stmt->setInt(1, $payment_property_id);
                $stmt->setInt(2, $payment_type);
                $stmt->setString(3, $year);
                $rs = $stmt->executeQuery();

                while($rs->next()) {
                    $arr_results[] = $rs->getRow();
                }
                $rs->close();
            }
            if($type=="PAYABLE")
            {
                $query = "SELECT TO_CHAR(AP.PAYMENT_DUE_DATE,'MM/DD/YYYY') DATE_,
                                 AP.AMOUNT AMOUNT_OWED,
                                 TO_CHAR(PA.PAYMENT_DATE, 'MM/DD/YYYY') DATE_PAID,
                                 PA.AMOUNT AMOUNT_RECEIVED
                          FROM   RNT_ACCOUNTS_PAYABLE AP,
                                 RNT_PAYMENT_ALLOCATIONS PA
                          WHERE  AP.PAYMENT_PROPERTY_ID = :var1
                          AND    AP.PAYMENT_TYPE_ID     = :var2
                          AND    TO_CHAR(AP.PAYMENT_DUE_DATE,'YYYY') = :var3
                          AND    AP.AP_ID = PA.AP_ID (+)
                          ORDER  BY AP.PAYMENT_DUE_DATE ASC";
                $stmt = $this->connection->prepareStatement($query);
                $stmt->setInt(1, $payment_property_id);
                $stmt->setInt(2, $payment_type);
                $stmt->setString(3, $year);
                $rs = $stmt->executeQuery();

                while($rs->next()) {
                    $arr_results[] = $rs->getRow();
                }
                $rs->close();
            }

            return $arr_results;
        }
    }
?>