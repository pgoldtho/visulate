<?php

  require_once dirname(__FILE__)."/../LOV.class.php";
  require_once dirname(__FILE__)."/../UtlConvert.class.php";
  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";

  class RNTAccountReceiveable extends RNTBase
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
    public function getPtAccountsList($businessID) {
        $result = array();

        if (!empty($businessID)) {
            $query = "select payment_type_id,
                             max(decode(transaction_type, 'ARP', debit_account, null))  as arp_debit_account,
                             max(decode(transaction_type, 'ARS', credit_account, null)) as ars_credit_account
                      from   rnt_pt_rules
                      where  business_id = :var1
                      and    transaction_type in ('ARP', 'ARS')
                      group  by payment_type_id";
            $stmt = $this->connection->prepareStatement($query);
            $stmt->setInt(1, $businessID);
            $rs   = $stmt->executeQuery();

            while($rs->next()) {
                $row = $rs->getRow();
                $result[$row["PAYMENT_TYPE_ID"]] = array(
                    "DEBIT_ACCOUNT"  => $row["ARP_DEBIT_ACCOUNT"],
                    "CREDIT_ACCOUNT" => $row["ARS_CREDIT_ACCOUNT"]
                );
            }
        }

        return $result;
    }


    /**
     * Get payment type accounts
     *
     * @param  int $businessID
     * @param  int $paymentTypeId
     * @return list of accounts
     */
    public function getPtAccounts($businessID, $paymentTypeId) {
        $result = array();

        if (!empty($businessID) and !empty($paymentTypeId)) {
            $query = "select transaction_type,
                             debit_account,
                             credit_account
                      from   rnt_pt_rules
                      where  business_id     = :var1
                      and    payment_type_id = :var2";
            $stmt = $this->connection->prepareStatement($query);
            $stmt->setInt(1, $businessID);
            $stmt->setInt(2, $paymentTypeId);
            $rs   = $stmt->executeQuery();

            while($rs->next()) {
                $row = $rs->getRow();
                $result[$row["TRANSACTION_TYPE"]] = array(
                    "DEBIT_ACCOUNT"  => $row["DEBIT_ACCOUNT"],
                    "CREDIT_ACCOUNT" => $row["CREDIT_ACCOUNT"]
                );
            }
        }

        return $result;
    }


    public function getList($businessID, $YearMonth)
    {
       $return = array();
       if ($businessID == NULL) {
         return $return;
       }

       if (!empty($YearMonth)) {
           $query =
                 "select ar.AR_ID, PAYMENT_DUE_DATE, AMOUNT,
                         PAYMENT_TYPE, TENANT_ID, AGREEMENT_ID,
                         LOAN_ID, CHECKSUM, BUSINESS_ID, ar.PROPERTY_ID,
                         RECEIVABLE_TYPE_NAME,
                         UNIT_NAME, ADDRESS1, ZIPCODE, UNITS,
                         TENANT_NAME, le.debit_account, le.credit_account
                  from   RNT_ACCOUNTS_RECEIVABLE_V ar,
                         rnt_ledger_entries le
                  where  ar.BUSINESS_ID = :var1
                  and    to_char(ar.PAYMENT_DUE_DATE, 'RRRRMM') = :var2
                  and    ar.AR_ID = le.ar_id (+)
                  and    le.pay_alloc_id is null
                  order  by ZIPCODE, ADDRESS1, UNIT_NAME, TENANT_NAME, PAYMENT_DUE_DATE, RECEIVABLE_TYPE_NAME";
       } else {
           $query =
                 "select ar.AR_ID, PAYMENT_DUE_DATE, AMOUNT,
                         PAYMENT_TYPE, TENANT_ID, AGREEMENT_ID,
                         LOAN_ID, CHECKSUM, BUSINESS_ID, ar.PROPERTY_ID,
                         RECEIVABLE_TYPE_NAME,
                         UNIT_NAME, ADDRESS1, ZIPCODE, UNITS,
                         TENANT_NAME, le.debit_account, le.credit_account
                  from   (select * from RNT_ACCOUNTS_RECEIVABLE_V
                          where  BUSINESS_ID = :var1
                         ) ar,
                         (select * from rnt_ledger_entries
                          where  pay_alloc_id  is null
                         ) le,
                         (select ar_id,
                                 nvl(sum(amount), 0) as allocated_amount
                          from   rnt_payment_allocations
                          group  by ar_id
                         ) ap
                  where  ar.AR_ID  = le.ar_id(+)
                  and    ar.ar_id  = ap.ar_id(+)
                  and    ar.amount > nvl(ap.allocated_amount, 0)
                  order  by PAYMENT_DUE_DATE, ZIPCODE, ADDRESS1, UNIT_NAME, TENANT_NAME, RECEIVABLE_TYPE_NAME";
       }

       $stmt = $this->connection->prepareStatement($query);
       $stmt->setInt(1, $businessID);
       if (!empty($YearMonth)) {
           $stmt->setString(2, $YearMonth);
       }
       $rs = $stmt->executeQuery();

       while($rs->next()) {
           $return[] = $rs->getRow();
       }

       return $return;
    }

    public function getReceivable($arID)
    {
        $return = array();
        if ($arID == NULL) {
            return $return;
        }
        $query = "select ar.AR_ID, PAYMENT_DUE_DATE, AMOUNT,
                         PAYMENT_TYPE, TENANT_ID, AGREEMENT_ID,
                         LOAN_ID, CHECKSUM, BUSINESS_ID, ar.PROPERTY_ID,
                         RECEIVABLE_TYPE_NAME,
                         UNIT_NAME, ADDRESS1, ZIPCODE, UNITS,
                         TENANT_NAME, le.debit_account, le.credit_account
                  from   RNT_ACCOUNTS_RECEIVABLE_V ar,
                         rnt_ledger_entries le
                  where  ar.AR_ID = le.ar_id
                  and    ar.AR_ID = :var1
                  and    le.pay_alloc_id is null";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $arID);
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
                      from   RNT_ACCOUNTS_RECEIVABLE
                      where  BUSINESS_ID = :var1
                      union
                      select 'Unpaid' as VALUE, null as CODE from dual
                     ) x
              order  by code desc", true, $businessID);
    }

    public function getListProp($businessID, $YearMonth)
    {
        $return = array();
        if ($businessID == NULL) {
            return $return;
        }

        if (!empty($YearMonth)) {
            $query = "
                select
                   arp.AR_ID, PAYMENT_DUE_DATE, AMOUNT,
                   PAYMENT_TYPE, TENANT_ID, AGREEMENT_ID,
                   LOAN_ID, CHECKSUM, arp.BUSINESS_ID,
                   PAYMENT_PROPERTY_ID, PAYMENT_DATE,
                   le.debit_account, le.credit_account
                from RNT_ACCOUNTS_RECEIVABLE_PROP_V arp,
                     (select ar_id,
                             max(debit_account) as debit_account,
                             max(credit_account) as credit_account
                      from   (select ar_id, debit_account, null as credit_account
                              from   rnt_ledger_entries
                              where  pay_alloc_id is not null
                              union
                              select ar_id,  null as debit_account, credit_account
                              from   rnt_ledger_entries
                              where  pay_alloc_id is null
                             ) x
                      group  by x.ar_id
                     ) le
                  where  arp.BUSINESS_ID = :var1
                  and    to_char(arp.PAYMENT_DUE_DATE, 'RRRRMM') = :var2
                  and    arp.AR_ID = le.ar_id (+)
                order by PAYMENT_DUE_DATE desc";
        } else {
            $query = "
                select arp.AR_ID, PAYMENT_DUE_DATE, AMOUNT,
                       PAYMENT_TYPE, TENANT_ID, AGREEMENT_ID,
                       LOAN_ID, CHECKSUM, arp.BUSINESS_ID,
                       PAYMENT_PROPERTY_ID, PAYMENT_DATE,
                       le.debit_account, le.credit_account
                from   RNT_ACCOUNTS_RECEIVABLE_PROP_V arp,
                       (select ar_id,
                               max(debit_account) as debit_account,
                               max(credit_account) as credit_account
                        from   (select pa.ar_id,  rle.debit_account, null as credit_account
                                from   rnt_ledger_entries rle,
                                       rnt_payment_allocations pa
                                where  rle.pay_alloc_id = pa.pay_alloc_id
                                union
                                select ar_id,  null as debit_account, credit_account
                                from   rnt_ledger_entries
                                where  pay_alloc_id is null
                               ) x
                        group  by x.ar_id
                       ) le
                where  arp.BUSINESS_ID = :var1
                and    arp.AR_ID = le.ar_id(+)
                and    arp.PAYMENT_DATE is null
                order  by PAYMENT_DUE_DATE desc";
       }
       $stmt = $this->connection->prepareStatement($query);
       $stmt->setInt(1, $businessID);
       if (!empty($YearMonth)) {
           $stmt->setString(2, $YearMonth);
       }
       $rs = $stmt->executeQuery();

       while($rs->next()) {
           $return[] = $rs->getRow();
       }
       return $return;
    }

    public function getAmountAndDate($arID)
    {
        $return = array();
        if ($arID == NULL) {
            return $return;
        }

        $query = "select AMOUNT, PAYMENT_DUE_DATE
                  from   RNT_ACCOUNTS_RECEIVABLE
                  where  AR_ID = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $arID);
        $rs = $stmt->executeQuery();

        if($rs->next()) {
           $return = $rs->getRow();
        }
        $rs->close();
        return $return;
    }

    public function getPropList($businessID)
    {
        $lov = new DBLov($this->connection);
        return $lov->HTMLSelectArray("
            select PROPERTY_ID as CODE, ADDRESS1 as VALUE
            from RNT_PROPERTIES
            where BUSINESS_ID = :var1
            order by ADDRESS1", true, $businessID);
    }

    public function getPropListWithNull($businessID)
    {
        $lov = new DBLov($this->connection);
        return $lov->HTMLSelectArray("
            select PROPERTY_ID as CODE, ADDRESS1 as VALUE
            from RNT_PROPERTIES
            where BUSINESS_ID = :var1
            order by ADDRESS1", false, $businessID);
    }

    public function getPaymentPropTypeList()
    {
        $lov = new DBLov($this->connection);
        return $lov->HTMLSelectArray("
            select PAYMENT_TYPE_ID as CODE, PAYMENT_TYPE_NAME as VALUE
            from RNT_PAYMENT_TYPES
            where RECEIVABLE_YN = 'Y'
            order by PAYMENT_TYPE_NAME");

    }

    public function getListAllocations($arID)
    {
        $return = array();
        if ($arID == NULL) {
            return $return;
        }

        $query = "select pa.PAY_ALLOC_ID, PAYMENT_DATE, AMOUNT,
                         pa.AR_ID, pa.AP_ID, PAYMENT_ID,
                         CHECKSUM, le.debit_account, le.credit_account
                  from   RNT_PAYMENT_ALLOCATIONS_V pa,
                         rnt_ledger_entries le
                  where  pa.PAY_ALLOC_ID = le.pay_alloc_id(+)
                  and    pa.AR_ID = le.ar_id(+)
                  and    pa.AR_ID = :var1
                  order  by PAYMENT_DATE, AMOUNT";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $arID);
        $rs   = $stmt->executeQuery();

        while($rs->next()) {
            $return[] = $rs->getRow();
        }
        return $return;
    }

    // return payment due list for balance agreement-tenant balance table
    public function getListTenantPaymentDue($tenant_id)
    {
        $return = array();
        if ($tenant_id == NULL) {
            return $return;
        }

        $query = "select PAYMENT_DUE_DATE, AMOUNT, RECEIVABLE_TYPE_NAME
                  from   RNT_ACCOUNTS_RECEIVABLE_V
                  where  TENANT_ID = :var1
                  order  by PAYMENT_DUE_DATE, RECEIVABLE_TYPE_NAME";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $tenant_id);
        $rs   = $stmt->executeQuery();

        while($rs->next()) {
            $return[] = $rs->getRow();
        }
        return $return;
    }

    public function getListTenantPaymentMade($tenant_id)
    {
        $return = array();
        if ($tenant_id == NULL) {
            return $return;
        }

        $query = "select pa.PAYMENT_DATE, pa.AMOUNT
                  from   RNT_ACCOUNTS_RECEIVABLE_V ar,
                         RNT_PAYMENT_ALLOCATIONS pa
                  where  ar.TENANT_ID = :var1
                  and    ar.AR_ID = pa.AR_ID
                  order  by pa.PAYMENT_DATE";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $tenant_id);
        $rs   = $stmt->executeQuery();

        while($rs->next()) {
            $return[] = $rs->getRow();
        }
        return $return;
    }

    function InsertAllocation($values)
    {
        $statement =
             "begin :var1 := RNT_PAYMENT_ALLOCATIONS_PKG.INSERT_ROW(X_PAYMENT_DATE => :var2".
                ", X_AMOUNT => :var3".
                ", X_AR_ID => :var4".
                ", X_AP_ID => :var5".
                ", X_PAYMENT_ID => :var6); end;";
        $prepare = $this->connection->prepareStatement($statement);

        // blank value for initial
        $prepare->set(1, '12345678901234567890');

        $prepare->setDate(2, UtlConvert::displayToDBDate($values["PAYMENT_DATE"]));
        $prepare->set(3, UtlConvert::DisplayNumericToDB($values["AMOUNT"]));
        $prepare->setInt(4, $values["AR_ID"]);
        $prepare->set(5,'');
        $prepare->set(6, '');
        @$prepare->executeUpdate();
        return OCI8PreparedStatementVars::getVar($prepare, 1);
    }

    function UpdateAllocAccounts($values)
    {
        $statement =
        "begin ".
            "update rnt_ledger_entries ".
            "set    debit_account  = :var1, ".
            "       credit_account = :var2 ".
            "where  pay_alloc_id = :var4; ".
            "if SQL%ROWCOUNT = 0 then ".
            "    insert into rnt_ledger_entries ".
            "           (LEDGER_ID, ".
            "            ENTRY_DATE, ".
            "            DESCRIPTION, ".
            "            DEBIT_ACCOUNT, ".
            "            CREDIT_ACCOUNT, ".
            "            AR_ID, ".
            "            AP_ID, ".
            "            PAY_ALLOC_ID, ".
            "            PAYMENT_TYPE_ID, ".
            "            PROPERTY_ID) ".
            "    select RNT_LEDGER_ENTRIES_SEQ.NEXTVAL as LEDGER_ID, ".
            "           :var5 as ENTRY_DATE, ".
            "           DESCRIPTION||' - paid!' as DESCRIPTION, ".
            "           :var1 as DEBIT_ACCOUNT, ".
            "           :var2 as CREDIT_ACCOUNT, ".
            "           AR_ID, ".
            "           AP_ID, ".
            "           :var4 as PAY_ALLOC_ID, ".
            "           PAYMENT_TYPE_ID, ".
            "           PROPERTY_ID ".
            "    from   rnt_ledger_entries ".
            "    where  ar_id        = :var3 ".
            "    and    pay_alloc_id is null; ".
            "end if; ".
        "end;";
        $prepare = $this->connection->prepareStatement($statement);

        // blank value for initial
        if ($values["PAYMENT_DATE"] != ""){
        $prepare->set(1, $values["DEBIT_ACCOUNT"]);
        $prepare->set(2, $values["CREDIT_ACCOUNT"]);
        $prepare->set(3, $values["AR_ID"]);
        $prepare->set(4, $values["PAY_ALLOC_ID"]);
        $prepare->setDate(5, UtlConvert::displayToDBDate($values["PAYMENT_DATE"]));

        $prepare->executeUpdate();
        }
    }

    function InsertAccReceivable($values)
    {
        $statement =
             "begin :var1 := RNT_ACCOUNTS_RECEIVABLE_PKG.INSERT_ROW(".
                "  X_PAYMENT_DUE_DATE => :var2".
                ", X_AMOUNT => :var3".
                ", X_PAYMENT_TYPE => :var4".
                ", X_TENANT_ID => NULL".
                ", X_AGREEMENT_ID => NULL".
                ", X_LOAN_ID => NULL".
                ", X_BUSINESS_ID => :var5".
                ", X_IS_GENERATED_YN => 'N'".
                ", X_AGREEMENT_ACTION_ID  => NULL".
                ", X_PAYMENT_PROPERTY_ID => :var6".
                ", X_RECORD_TYPE => :var7); end;";
        $prepare = $this->connection->prepareStatement($statement);

        // blank value for initial
        $prepare->set(1, '12345678901234567890');

        $prepare->setDate(2, UtlConvert::displayToDBDate($values["PAYMENT_DUE_DATE"]));
        $prepare->set(3, UtlConvert::DisplayNumericToDB($values["AMOUNT"]));
        $prepare->setInt(4, $values["PAYMENT_TYPE"]);
        $prepare->set(5, $values["BUSINESS_ID"]);
        $prepare->set(6, $values["PAYMENT_PROPERTY_ID"]);
        $prepare->set(7, $values["RECORD_TYPE"]);
        @$prepare->executeUpdate();
        return OCI8PreparedStatementVars::getVar($prepare, 1);
    }

    function DeleteAllocation($id)
    {
        if ($id == null) {
            return;
        }
        $statement = "begin RNT_PAYMENT_ALLOCATIONS_PKG.DELETE_ROW(X_PAY_ALLOC_ID => :var1);  end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $id);
        @$prepare->executeUpdate();
    }

    function DeleteAllocDetails($id)
    {
        if ($id == null) {
            return;
        }
        $statement = "begin ".
                         "delete from rnt_ledger_entries ".
                         "where  pay_alloc_id = :var1; ".
                     "end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->set(1, $id);
        @$prepare->executeUpdate();
    }

    public function generateReceivableList($businessID, $need_date, $is_late_fee)
    {
        $statement = "begin RNT_ACCOUNTS_RECEIVABLE_PKG.GENERATE_PAYMENTS_LIST(X_BUSINESS_UNIT => :var1, X_EFFECTIVE_DATE => :var2, x_generate_late => ".($is_late_fee ? "true" : "false")."); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $businessID);
        $prepare->set(2, UtlConvert::DisplayToDBDate($need_date));
       // $prepare->setBoolean(3, $is_late_fee ? "true" : "false");
        @$prepare->executeUpdate();
    }

   public function deleteReceivableList($businessID, $date_from_delete)
   {
        $statement = "begin RNT_ACCOUNTS_RECEIVABLE_PKG.DELETE_PAYMENTS_LIST_FROM(X_BUSINESS_UNIT => :var1, X_DATE_FROM => :var2); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $businessID);
        $prepare->set(2, UtlConvert::DisplayToDBDate($date_from_delete));
        @$prepare->executeUpdate();
   }

   public function Update($value)
    {
        $statement =
             "begin RNT_ACCOUNTS_RECEIVABLE_PKG.UPDATE_ROW_AMOUNT(".
                     "  X_AR_ID => :var1".
                     ", X_AMOUNT  => :var2".
                     ", X_CHECKSUM => :var3); end;";

        $prepare = $this->connection->prepareStatement($statement);

        $prepare->setInt(1, $value["AR_ID"]);
        $prepare->set(2, UtlConvert::DisplayNumericToDB($value["AMOUNT"]));
        $prepare->setString(3, $value["CHECKSUM"]);

        $prepare->executeUpdate();
    }

    public function UpdateAccounts($values)
    {
        $statement ="update rnt_ledger_entries
                     set    credit_account = :var1
                     where  ar_id          = :var2
                     and    pay_alloc_id is null";

        $prepare = $this->connection->prepareStatement($statement);

        // blank value for initial
        if ($values["CREDIT_ACCOUNT"] != "") {
            $prepare->setInt(1, $values["CREDIT_ACCOUNT"]);
            $prepare->setInt(2, $values["AR_ID"]);
            $prepare->executeUpdate();
        }
    }

    private function Operation(&$value, $operation)
    {
        $proc = "";
        switch($operation )
        {
            case (RNTBase::UPDATE_ROW) : $proc = "UPDATE_ROW2"; break;
            case (RNTBase::INSERT_ROW) : $proc = "INSERT_ROW2"; break;
            default : throw new Exception("Not allowed value");
        }

        $statement = "";
        if ($operation == RNTBase::UPDATE_ROW) {
            $statement =
                "begin RNT_ACCOUNTS_RECEIVABLE_PKG.$proc(X_AR_ID => :var1,";
        } else if ($operation == RNTBase::INSERT_ROW) {
            $statement = " begin :var1 := RNT_ACCOUNTS_RECEIVABLE_PKG.$proc(";
        }

        $statement .= "  X_PAYMENT_DUE_DATE => :var2".
                      ", X_AMOUNT => :var3 ".
                      ", X_PAYMENT_TYPE => :var4 ".
                      ", X_TENANT_ID => :var5 ".
                      ", X_AGREEMENT_ID => :var6 ".
                      ", X_LOAN_ID => :var7 ".
                      ", X_BUSINESS_ID => :var8 ".
                      ", X_IS_GENERATED_YN => :var9 ".
                      ", X_AGREEMENT_ACTION_ID => :var10 ".
                      ", X_PAYMENT_PROPERTY_ID => :var11 ".
                      ", X_PAYMENT_DATE => :var12 ".
                      ", X_DEBIT_ACCOUNT => :var13 ".
                      ", X_CREDIT_ACCOUNT => :var14 ";

        if ($operation == RNTBase::UPDATE_ROW) {
            $statement .= " , X_CHECKSUM => :var15";
        } else {
            $statement .= " , X_RECORD_TYPE => :var15";
        }

        $statement .= "); end;";
        $prepare = $this->connection->prepareStatement($statement);

        if ($operation == RNTBase::INSERT_ROW) {
           // blank value for initial
           $prepare->set(1, '23423423123123123');
        } else if ($operation == RNTBase::UPDATE_ROW) {
           $prepare->setInt(1, $value["AR_ID"]);
        }

        $prepare->set(2, UtlConvert::displayToDBDate($value["PAYMENT_DUE_DATE"]));
        $prepare->set(3, UtlConvert::DisplayNumericToDB($value["AMOUNT"]));
        $prepare->set(4, $value["PAYMENT_TYPE"]);
        $prepare->set(5, $value["TENANT_ID"]);
        $prepare->set(6, $value["AGREEMENT_ID"]);
        $prepare->set(7, $value["LOAN_ID"]);
        $prepare->set(8, $value["BUSINESS_ID"]);
        $prepare->set(9, "N");
        $prepare->set(10, @$value["AGREEMENT_ACTION_ID"]);
        $prepare->set(11, $value["PAYMENT_PROPERTY_ID"]);
        $prepare->set(12, UtlConvert::displayToDBDate($value["PAYMENT_DATE"]));
        $prepare->set(13, $value["DEBIT_ACCOUNT"]);
        $prepare->set(14, $value["CREDIT_ACCOUNT"]);

        if ($operation == RNTBase::UPDATE_ROW) {
            $prepare->setString(15, $value["CHECKSUM"]);
        } else {
            $prepare->setString(15, $value["RECORD_TYPE"]);
        }

        @$prepare->executeUpdate();

        if ($operation == RNTBase::INSERT_ROW)
          return OCI8PreparedStatementVars::getVar($prepare, 1);
    }

    public function UpdateRow2(&$values)
    {
        $this->Operation($values, RNTBase::UPDATE_ROW);
    }

    public function InsertRow2(&$values)
    {
        return $this->Operation($values, RNTBase::INSERT_ROW);
    }

    public function DeleteRow2($ar_id)
    {
        if ($ar_id == null) {
            return;
        }
        $statement = "begin RNT_ACCOUNTS_RECEIVABLE_PKG.DELETE_ROW2(X_AR_ID => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $ar_id);
        $prepare->executeUpdate();
    }

    public function getSum($YearMonth, $business_id)
    {
        $return = array();
        if ($business_id == NULL) {
            return $return;
        }

        if ($YearMonth) {
            $query = "
                select NVL(sum(ar.AMOUNT), 0) as RECEIVABLE_AMOUNT, NVL(sum(pa.AMOUNT), 0) as ALLOCATED_AMOUNT
                from   RNT_ACCOUNTS_RECEIVABLE ar,
                       (select AR_ID, sum(AMOUNT) as AMOUNT from RNT_PAYMENT_ALLOCATIONS group by AR_ID) pa
                where  BUSINESS_ID = :var1
                and    pa.AR_ID(+) = ar.AR_ID
                and    to_char(PAYMENT_DUE_DATE, 'RRRRMM') = :var2";
        } else {
            $query = "
                select NVL(sum(ar.AMOUNT), 0) as RECEIVABLE_AMOUNT,
                       sum(nvl(ap.allocated_amount, 0)) as ALLOCATED_AMOUNT
                from   (select * from RNT_ACCOUNTS_RECEIVABLE_V
                        where  BUSINESS_ID = :var1
                       ) ar,
                       (select ar_id,
                               sum(nvl(amount, 0)) as allocated_amount
                        from   rnt_payment_allocations
                        group  by ar_id
                       ) ap
                where  ar.ar_id  = ap.ar_id(+)
                and    ar.amount > nvl(ap.allocated_amount, 0)";
        }

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $business_id);
        if ($YearMonth) {
            $stmt->setString(2, $YearMonth);
        }
        $rs   = $stmt->executeQuery();

        while($rs->next()) {
            $return = $rs->getRow();
        }
        $return["BALANCE_AMOUNT"] = strval($return["RECEIVABLE_AMOUNT"] - $return["ALLOCATED_AMOUNT"]);

        return $return;
    }

    public function getOtherTypeVal(){
       $rs =  $this->connection->executeQuery("select RNT_ACC_RECEIVABLE_CONST_PKG.CONST_OTHER_TYPE_VAL as XX from DUAL");
       while($rs->next())
           $return = $rs->getRow();
        return $return["XX"];
    }

 }
?>