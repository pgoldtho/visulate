<?php

  require_once dirname(__FILE__)."/../LOV.class.php";
  require_once dirname(__FILE__)."/../UtlConvert.class.php";
  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/../SQLExceptionMessage.class.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";

  class RNTAccountPayable extends RNTBase
  {

    public function __construct($connection){
         parent::__construct($connection);
    }


    /**
     * Get list of payment types with accounts
     *
     * @param  int $businessID
     * @return list in format: payment_type:(debit_account,credit_account)
     */
    public function getPtAccountsList($businessID)
    {
        $result = array();

        if (!empty($businessID))
        {
            $query = "select payment_type_id,
                             max(decode(transaction_type, 'APS', debit_account, null))  as aps_debit_account,
                             max(decode(transaction_type, 'APP', credit_account, null)) as app_credit_account
                      from   rnt_pt_rules
                      where  business_id       = :var1
                      and    transaction_type in ('APP', 'APS')
                      group  by payment_type_id";
            $stmt = $this->connection->prepareStatement($query);
            $stmt->setInt(1, $businessID);
            $rs   = $stmt->executeQuery();

            while($rs->next()) {
                $row = $rs->getRow();
                $result[$row["PAYMENT_TYPE_ID"]] = array(
                    "DEBIT_ACCOUNT"  => $row["APS_DEBIT_ACCOUNT"],
                    "CREDIT_ACCOUNT" => $row["APP_CREDIT_ACCOUNT"]
                );
            }
        }

        return $result;
    }

    /**
     * Enter description here...
     *
     * @param unknown_type $expenseID
     * @return unknown
     */
    public function getList($expenseID)
    {
        $return = array();
        if ($expenseID == NULL) {
            return $return;
        }

        $query = "select ap_id, payment_due_date, amount,
                         payment_type_id, expense_id, loan_id,
                         supplier_id, checksum, supplier_name, payment_property_id,
                         business_id, record_type, invoice_number
                  from   RNT_ACCOUNTS_PAYABLE_V
                  where  EXPENSE_ID = :var1
                  order  by payment_due_date";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $expenseID);
        $rs   = $stmt->executeQuery();

        while($rs->next())
        {
           $return[] = $rs->getRow();
        }
        return $return;
    }
    
		
    /**
     * Enter description here...
     *
     * @param unknown_type $businessID
     * @return unknown
     */
    function getSupplierList($businessID)
    {
       $lov = new DBLov($this->connection);
       return $lov->HTMLSelectArray("
            select CODE, VALUE
            from   (select 0 as CODE, '- No Vendor -' as VALUE
                    from dual
                    union
                    select SUPPLIER_ID as CODE, NAME as VALUE
                    from   RNT_SUPPLIERS_V
                    where  BUSINESS_ID = :var1
                   ) x
            order  by VALUE", true, $businessID);
    }

    function getPaymentTypeList()
    {
       $lov = new DBLov($this->connection);
       return $lov->HTMLSelectArray("
            select PAYMENT_TYPE_ID as CODE, PAYMENT_TYPE_NAME as VALUE
            from   RNT_PAYMENT_TYPES
            where  PAYABLE_YN = 'Y'
            order  by PAYMENT_TYPE_NAME ");
    }
    
   private function Operation(&$value, $operation)
    {
       $proc = "";
       switch($operation )
       {
        case (RNTBase::UPDATE_ROW) : $proc = "UPDATE_ROW"; break;
        case (RNTBase::INSERT_ROW) : $proc = "INSERT_ROW2"; break;
        default : throw new Exception("Not allowed value");
       }

       $statement = '';
       if ($operation == RNTBase::UPDATE_ROW)
       {
            $statement = "begin RNT_ACCOUNTS_PAYABLE_PKG.$proc( X_AP_ID => :var1,";
       }
       else if ($operation == RNTBase::INSERT_ROW)
       {
            $statement = "begin :var1 := RNT_ACCOUNTS_PAYABLE_PKG.$proc(";
       }
       $statement .= "  X_PAYMENT_DUE_DATE => :var2".
                     ", X_AMOUNT  => :var3".
                     ", X_PAYMENT_TYPE_ID  => :var4".
                     ", X_EXPENSE_ID  => :var5".
                     ", X_LOAN_ID  => :var6".
                     ", X_SUPPLIER_ID  => :var7";

        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= ",X_CHECKSUM => :var8";
        else if ($operation == RNTBase::INSERT_ROW)
         {
				  $statement .= ",  X_PAYMENT_DATE   => null".
                        ",  X_DEBIT_ACCOUNT  => null".
                        ",  X_CREDIT_ACCOUNT => null";
				 }


        $statement .= ", X_PAYMENT_PROPERTY_ID => :var9".
                      ", X_BUSINESS_ID => :var10, X_RECORD_TYPE => :var11, X_INVOICE_NUMBER => :var12 ); end;";

        $prepare = $this->connection->prepareStatement($statement);

        if ($operation == RNTBase::INSERT_ROW)
           // blank value for initial
           $prepare->set(1, '12345678901234567890');
        else if ($operation == RNTBase::UPDATE_ROW)
           $prepare->setInt(1, $value["AP_ID"]);

        $prepare->setDate(2, UtlConvert::displayToDBDate($value["PAYMENT_DUE_DATE"]));
        $prepare->set(3, UtlConvert::DisplayNumericToDB($value["AMOUNT"]));
        $prepare->set(4, $value["PAYMENT_TYPE_ID"]);
        $prepare->set(5, $value["EXPENSE_ID"]);
        $prepare->set(6, @$value["LOAN_ID"]);
        $prepare->set(7, $value["SUPPLIER_ID"]);
        $prepare->set(9, @$value["PAYMENT_PROPERTY_ID"]);
        $prepare->set(10, @$value["BUSINESS_ID"]);
        $prepare->set(11, $value["RECORD_TYPE"]);
        $prepare->set(12, $value["INVOICE_NUMBER"]);
        if ($operation == RNTBase::UPDATE_ROW)
            $prepare->setString(8, $value["CHECKSUM"]);

        $prepare->executeUpdate();

        if ($operation == RNTBase::INSERT_ROW)
          return OCI8PreparedStatementVars::getVar($prepare, 1);
    }

    public function Updates(&$values)
    {
        if (!array_key_exists("ACCOUNTS", $values))
          return;

        $recs = $values["ACCOUNTS"];

        foreach($recs as $v)
        {
           if (!$v["AP_ID"]) { // then insert
               $this->Operation($v, RNTBase::INSERT_ROW);
           } else {
              $this->Operation($v, RNTBase::UPDATE_ROW);
           }
        }
    }

    public function verifyChecksum($sumval, $apID)
    {
        if ($apID == null) {
            return;
        }

        $statement = "begin RNT_ACCOUNTS_PAYABLE_PKG.VERIFY_CHECKSUM(X_AP_ID => :var1, X_CHECKSUM => :var2); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $apID);
        $prepare->set(2, $sumval);
        $prepare->executeUpdate();
    }

    public function checkChecksumUpdates(&$values)
    {
        if (!array_key_exists("ACCOUNTS", $values)) {
          return;
        }

        $recs = $values["ACCOUNTS"];
        foreach($recs as $v)
        {
           if ($v["AP_ID"]) {
              $this->verifyChecksum($v["CHECKSUM"], $v["AP_ID"]);
           }
        }
    }

    public function Delete($id)
    {
        if ($id == null) {
            return;
        }

        $statement = "begin RNT_ACCOUNTS_PAYABLE_PKG.DELETE_ROW2(X_AP_ID => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $id);
        $prepare->executeUpdate();
     }


    public function getPaymentList($businessID, $YearMonth)
    {
        $return = array();
        if ($businessID == NULL) {
            return $return;
        }

        $query = "select ap.AP_ID, PAYMENT_DUE_DATE, AMOUNT,
                         ap.PAYMENT_TYPE_ID, EXPENSE_ID, LOAN_ID,
                         SUPPLIER_ID, CHECKSUM,
                         ap.PROPERTY_ID, PROPERTY_NAME||' - '||SUPPLIER_NAME as PROPERTY_SUPPLIER_NAME,
                         BUSINESS_ID,
                         PAYMENT_PROPERTY_ID,
                         PAYMENT_TYPE_NAME,
                         PAYMENT_DATE, RECORD_TYPE, INVOICE_NUMBER,
                         le.debit_account, le.credit_account
                  from   RNT_ACCNTS_PAYABLE_EXPENSES_V ap,
                         (select ap_id,
                                 max(debit_account) as debit_account,
                                 max(credit_account) as credit_account
                          from   (select ap_id, debit_account, null as credit_account
                                  from   rnt_ledger_entries
                                  where  pay_alloc_id is null
                                  union
                                  select pa.ap_id,  null as debit_account, rle.credit_account
                                  from   rnt_ledger_entries rle,
                                         rnt_payment_allocations pa
                                  where  rle.pay_alloc_id = pa.pay_alloc_id
                                 ) x
                          group  by x.ap_id
                         ) le
                  where  ap.BUSINESS_ID = :var1
                  and    ap.ap_id = le.ap_id (+)";

        if (!empty($YearMonth)) {
            $query .= " and    to_char(ap.PAYMENT_DUE_DATE, 'RRRRMM') = :var2 ";
        } else {
            $query .= " and    ap.payment_date is null ";
        }
        $query .= " order  by payment_due_date desc, property_name||' - '||supplier_name, payment_type_name";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $businessID);
        if (!empty($YearMonth)) {
            $stmt->setString(2, $YearMonth);
        }

        $rs =  $stmt->executeQuery();

        while($rs->next()) {
           $return[] = $rs->getRow();
        }

        return $return;
    }

    public function getPaymentByIDExpense($ap_id)
    {
        $return = array();
        if ($ap_id == null) {
            return $return;
        }

        $query = "select AP_ID, PAYMENT_DUE_DATE, AMOUNT,
                         PAYMENT_TYPE_ID, EXPENSE_ID, LOAN_ID,
                         SUPPLIER_ID, CHECKSUM,
                         PAYMENT_PROPERTY_ID,
                         PROPERTY_NAME||' - '||SUPPLIER_NAME as PROPERTY_SUPPLIER_NAME,
                         BUSINESS_ID,
                         PAYMENT_TYPE_NAME,
                         INVOICE_NUMBER
                  from   RNT_ACCNTS_PAYABLE_EXPENSES_V
                  where  AP_ID = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $ap_id);
        $rs   = $stmt->executeQuery();

        while($rs->next()) {
            $return = $rs->getRow();
        }

        return $return;
    }

    public function getPaymentByID($ap_id)
    {
        $return = array();
        if ($ap_id == null) {
            return $return;
        }

        $query = "select AP_ID, PAYMENT_DUE_DATE, AMOUNT,
                         PAYMENT_TYPE_ID, EXPENSE_ID, LOAN_ID,
                         SUPPLIER_ID, CHECKSUM,
                         PAYMENT_PROPERTY_ID,
                         PROPERTY_NAME||' - '||SUPPLIER_NAME as PROPERTY_SUPPLIER_NAME,
                         BUSINESS_ID,
                         PAYMENT_TYPE_NAME,
                         INVOICE_NUMBER
                  from   RNT_ACCOUNTS_PAYABLE_V
                  where  AP_ID = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $ap_id);
        $rs   = $stmt->executeQuery();

        while($rs->next()) {
            $return = $rs->getRow();
        }

        return $return;
    }

    function getMonthList($businessID)
    {
        if (!$businessID) {
            return array();
        }
        $lov = new DBLov($this->connection);

        return $lov->HTMLSelectArray("
            select x.*
            from   (select distinct
                           to_char(PAYMENT_DUE_DATE, 'RRRR-MON') as VALUE,
                           to_char(PAYMENT_DUE_DATE, 'RRRRMM') as CODE
                    from   RNT_ACCOUNTS_PAYABLE ap,
                           RNT_PROPERTIES p
                    where  ap.PAYMENT_PROPERTY_ID = p.PROPERTY_ID
                    and    ap.BUSINESS_ID = :var1
                    union
                    select 'Unpaid' as VALUE, null as CODE from dual
                   ) x
            order  by code desc", true, $businessID);
    }

    /// update for payable record
    public function Update(&$value)
    {
        $statement =
                 "begin RNT_ACCOUNTS_PAYABLE_PKG.UPDATE_ROW2( X_AP_ID => :var1,".
                     "  X_PAYMENT_DUE_DATE => :var2".
                     ", X_AMOUNT  => :var3".
                     ", X_PAYMENT_TYPE_ID  => :var4".
                     ", X_EXPENSE_ID  => :var5".
                     ", X_LOAN_ID  => :var6".
                     ", X_SUPPLIER_ID  => :var7".
                     ", X_CHECKSUM => :var8".
                     ", X_PAYMENT_DATE => :var9".
                     ", X_PAYMENT_PROPERTY_ID => :var10".
                     ", X_BUSINESS_ID => :var11".
                     ", X_RECORD_TYPE => :var12".
                     ", X_INVOICE_NUMBER => :var13".
                     ", X_DEBIT_ACCOUNT => :var14 ".
                     ", X_CREDIT_ACCOUNT => :var15 ".
                  "); end;";
        $prepare = $this->connection->prepareStatement($statement);

        $prepare->setInt(1, $value["AP_ID"]);
        $prepare->setDate(2, UtlConvert::displayToDBDate($value["PAYMENT_DUE_DATE"]));
        $prepare->set(3, UtlConvert::DisplayNumericToDB($value["AMOUNT"]));
        $prepare->setInt(4, $value["PAYMENT_TYPE_ID"]);
        $prepare->set(5, $value["EXPENSE_ID"]);
        $prepare->set(6, @$value["LOAN_ID"]);
        $prepare->setInt(7, $value["SUPPLIER_ID"]);
        $prepare->setString(8, $value["CHECKSUM"]);
        $prepare->setDate(9, UtlConvert::displayToDBDate($value["PAYMENT_DATE"]));
        $prepare->set(10, @$value["PAYMENT_PROPERTY_ID"]);
        $prepare->set(11, @$value["BUSINESS_ID"]);
        $prepare->set(12, @$value["RECORD_TYPE"]);
        $prepare->set(13, $value["INVOICE_NUMBER"]);
        //
        $prepare->set(14, $value["DEBIT_ACCOUNT"]);
        $prepare->set(15, $value["CREDIT_ACCOUNT"]);

        $prepare->executeUpdate();
    }

    // return list for other payments
    public function getListProp($businessID, $YearMonth)
    {
        $return = array();
        if ($businessID == NULL) {
            return $return;
        }

        $query = "select ap.AP_ID, PAYMENT_DUE_DATE, AMOUNT,
                         PAYMENT_TYPE_ID, EXPENSE_ID, LOAN_ID,
                         SUPPLIER_ID, PAYMENT_PROPERTY_ID, CHECKSUM,
                         PAYMENT_DATE, BUSINESS_ID, INVOICE_NUMBER,
                         le.debit_account, le.credit_account
                  from   rnt_accounts_payable_prop_v  ap,
                         (select ap_id,
                                 max(debit_account) as debit_account,
                                 max(credit_account) as credit_account
                          from   (select ap_id, debit_account, null as credit_account
                                  from   rnt_ledger_entries
                                  where  pay_alloc_id is null
                                  union
                                  select pa.ap_id,  null as debit_account, rle.credit_account
                                  from   rnt_ledger_entries rle,
                                         rnt_payment_allocations pa
                                  where  rle.pay_alloc_id = pa.pay_alloc_id
                                 ) x
                          group  by x.ap_id
                         ) le
                  where  ap.BUSINESS_ID = :var1
                  and    ap.ap_id = le.ap_id  ";

        if (!empty($YearMonth)) {
            $query .= " and    to_char(ap.PAYMENT_DUE_DATE, 'RRRRMM') = :var2 ";
        } else {
            $query .= " and    ap.payment_date is null ";
        }
        $query .= " order  by payment_due_date desc";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $businessID);
        if (!empty($YearMonth)) {
            $stmt->setString(2, $YearMonth);
        }

        $rs  = $stmt->executeQuery();
        while($rs->next()) {
            $return[] = $rs->getRow();
        }

        return $return;
    }


    private function OtherOperation(&$value, $operation)
    {
        $proc = "";
        switch($operation )
        {
            case (RNTBase::UPDATE_ROW) : $proc = "UPDATE_ROW2"; break;
            case (RNTBase::INSERT_ROW) : $proc = "INSERT_ROW2"; break;
            default : throw new Exception("Not allowed value");
        }

        $statement = '';
        if ($operation == RNTBase::UPDATE_ROW)
        {
            $statement = "begin RNT_ACCOUNTS_PAYABLE_PKG.$proc( X_AP_ID => :var1,";
        }
        else if ($operation == RNTBase::INSERT_ROW)
        {
            $statement = "begin :var1 := RNT_ACCOUNTS_PAYABLE_PKG.$proc(";
        }

        $statement .= "  X_PAYMENT_DUE_DATE => :var2".
                     ", X_AMOUNT  => :var3".
                     ", X_PAYMENT_TYPE_ID  => :var4".
                     ", X_EXPENSE_ID  => :var5".
                     ", X_LOAN_ID  => :var6".
                     ", X_SUPPLIER_ID  => :var7";

        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= ",X_CHECKSUM => :var8";

        $statement .= ", X_PAYMENT_PROPERTY_ID => :var9".
                      ", X_PAYMENT_DATE => :var10".
                      ", X_BUSINESS_ID => :var11".
                      ", X_RECORD_TYPE => RNT_ACCOUNTS_PAYABLE_CONST_PKG.CONST_OTHER_TYPE_VAL()".
                      ", X_INVOICE_NUMBER => :var12 ".
                      ", X_DEBIT_ACCOUNT => :var13 ".
                      ", X_CREDIT_ACCOUNT => :var14); ".
                 "end;";

        $prepare = $this->connection->prepareStatement($statement);

        if ($operation == RNTBase::INSERT_ROW)
           // blank value for initial
           $prepare->set(1, '12345678901234567890');
        else if ($operation == RNTBase::UPDATE_ROW)
           $prepare->setInt(1, $value["AP_ID"]);

        $prepare->setDate(2, UtlConvert::displayToDBDate($value["PAYMENT_DUE_DATE"]));
        $prepare->set(3, UtlConvert::DisplayNumericToDB($value["AMOUNT"]));
        $prepare->set(4, $value["PAYMENT_TYPE_ID"]);
        $prepare->set(5, $value["EXPENSE_ID"]);
        $prepare->set(6, @$value["LOAN_ID"]);
        $prepare->set(7, $value["SUPPLIER_ID"]);
        $prepare->set(9, @$value["PAYMENT_PROPERTY_ID"]);
        $prepare->set(10, UtlConvert::displayToDBDate(@$value["PAYMENT_DATE"]));
        $prepare->set(11, @$value["BUSINESS_ID"]);
        $prepare->set(12, $value["INVOICE_NUMBER"]);
        //
        $prepare->set(13, $value["DEBIT_ACCOUNT"]);
        $prepare->set(14, $value["CREDIT_ACCOUNT"]);

        if ($operation == RNTBase::UPDATE_ROW) {
            $prepare->setString(8, $value["CHECKSUM"]);
        }

        @$prepare->executeUpdate();

        if ($operation == RNTBase::INSERT_ROW)
          return OCI8PreparedStatementVars::getVar($prepare, 1);
    }

    public function OtherUpdates(&$values)
    {
        foreach($values as $v)
        {
           if (!$v["AP_ID"])
              // then insert
              $this->OtherOperation($v, RNTBase::INSERT_ROW);
           else
              $this->OtherOperation($v, RNTBase::UPDATE_ROW);
        }
    }

    public function OtherDelete($id)
    {
        if ($id == null) {
            return;
        }

        $statement = "begin RNT_ACCOUNTS_PAYABLE_PKG.DELETE_ROW2(X_AP_ID => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $id);
        @$prepare->executeUpdate();
    }

    public function getSum($YearMonth, $business_id)
    {
        $return = array();

        if ($business_id == NULL) {
            return $return;
        }

        $query = "select NVL(sum(ap.AMOUNT), 0) as PAYABLE_AMOUNT,
                         NVL(sum(pa.AMOUNT), 0) as ALLOCATED_AMOUNT
                  from   RNT_ACCOUNTS_PAYABLE ap,
                         RNT_PAYMENT_ALLOCATIONS pa
                  where  ap.AP_ID = pa.Ap_ID(+)
                  and    ap.loan_id is null
                  and    BUSINESS_ID = :var1 ";
        if (!empty($YearMonth)) {
             $query .= " and    to_char(PAYMENT_DUE_DATE, 'RRRRMM') = :var2 ";
        } else {
             $query .= " and    pa.amount is null";
        }

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $business_id);
        if (!empty($YearMonth)) {
            $stmt->setString(2, $YearMonth);
        }

        $rs   = $stmt->executeQuery();

        while($rs->next()) {
            $return = $rs->getRow();
        }
        $return["BALANCE_AMOUNT"] = strval($return["PAYABLE_AMOUNT"] - $return["ALLOCATED_AMOUNT"]);
        return $return;
    }

    public function generatePayableList($businessID, $need_date)
    {
        $statement = "begin RNT_ACCOUNTS_PAYABLE_PKG.GENERATE_PAYMENT_LIST(X_BUSINESS_ID => :var1, X_NEED_DATE => :var2); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $businessID);
        $prepare->set(2, UtlConvert::DisplayToDBDate($need_date));
        @$prepare->executeUpdate();
    }

    public function getSupplierListForItems($expense_id) {
    	return $this->sql2array(
    	              "select items.SUPPLIER_ID, "
    	            . "       items.SUPPLIER_NAME, "
    	            . "       items.ESTIMATE, "
    	            . "       items.ACTUAL, "
    	            . "       nvl(apv.INVOICE, 0) as INVOICE, "
    	            . "       items.accepted_yn "           //TODO: need test!!!
    	            . "from   (select all_items.SUPPLIER_ID, "
    	            . "               all_items.SUPPLIER_NAME, "
    	            . "               ea.accepted_yn, "     //TODO: need test!!!
    	            . "               sum(NVL(ea.ESTIMATE * ea.ITEM_COST, 0))as ESTIMATE, "
    	            . "               sum(NVL(ea.ACTUAL * ea.ITEM_COST, 0))  as ACTUAL "
    	            . "        from   (select distinct SUPPLIER_ID, SUPPLIER_NAME, EXPENSE_ID "
    	            . "                from   RNT_ACCOUNTS_PAYABLE_V "
    	            . "                where  EXPENSE_ID = :var1"
    	            . "                union "
    	            . "                select distinct SUPPLIER_ID, SUPPLIER_NAME, EXPENSE_ID "
    	            . "                from   RNT_EXPENSE_ITEMS_V "
    	            . "                where  EXPENSE_ID = :var1" 
    	            . "               ) all_items, "
    	            . "               RNT_EXPENSE_ITEMS ea "
    	            . "        where  ea.EXPENSE_ID  (+)= all_items.EXPENSE_ID "
    	            . "        and    ea.SUPPLIER_ID (+)= all_items.SUPPLIER_ID "
    	            . "        group  by all_items.SUPPLIER_ID, "
    	            . "                  all_items.SUPPLIER_NAME, "
    	            . "                  ea.accepted_yn  "  //TODO: need test!!!
    	            . "       ) items, "
    	            . "       (select SUPPLIER_ID, SUPPLIER_NAME, sum(NVL(AMOUNT, 0)) as INVOICE "
    	            . "        from   RNT_ACCOUNTS_PAYABLE_V "
    	            . "        where  EXPENSE_ID = :var1" 
    	            . "        group  by SUPPLIER_ID, SUPPLIER_NAME "
    	            . "       ) apv "
    	            . "where  apv.supplier_id (+)= items.supplier_id "
    	            . "order  by items.SUPPLIER_NAME", $expense_id);
    }

  }
?>