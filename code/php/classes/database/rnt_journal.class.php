<?php

  require_once dirname(__FILE__)."/../LOV.class.php";
  require_once dirname(__FILE__)."/../UtlConvert.class.php";
  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";

  class RNTJournal extends RNTBase
  {

    public function __construct($connection){
         parent::__construct($connection);
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
                             to_char(PAYMENT_DATE, 'RRRR-MON') as VALUE,
                             to_char(PAYMENT_DATE, 'RRRRMM') as CODE
                      from   RNT_PAYMENTS
                      where  BUSINESS_ID = :var1
                     ) x
              order  by code desc", true, $businessID);
    }

    public function generateContraEntries($businessID, $need_date)
    {
        $statement = "begin 
		                RNT_LEDGER_PKG.GENERATE_CONTRA_ENTRIES(P_BUSINESS_ID => :var1
		                                                     , P_DATE => to_date(:var2, 'mm/dd/yyyy')); end;";

        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $businessID);
		$prepare->set(2, $need_date);
        //$prepare->set(2, UtlConvert::DisplayToDBDate($need_date));
		 
        @$prepare->executeUpdate();
    }
    
    
    public function getList($businessID, $YearMonth)
    {
        $return = array();
        if ($businessID == NULL) {
            return $return;
        }
        
        if (!empty($YearMonth)) 
        {
            $query = "select p.PAYMENT_ID,
                             p.PAYMENT_DATE,
                             l.DESCRIPTION,
                             p.AMOUNT,
                             l.payment_type_id,
                             l.DEBIT_ACCOUNT,
                             l.CREDIT_ACCOUNT,
                             l.property_id,
                             pr.address1,
                             p.business_id
                      from   rnt_payments p,
                             rnt_payment_allocations pa,
                             rnt_ledger_entries l,
                             rnt_properties pr
                      where  l.pay_alloc_id = pa.pay_alloc_id
                      and    pa.payment_id  = p.payment_id
                      and    p.business_id  = :var1
                      and    to_char(p.PAYMENT_DATE, 'RRRRMM') = :var2
                      and    l.property_id = pr.property_id (+)
                      order  by p.payment_date, l.description";
            $stmt = $this->connection->prepareStatement($query);
            $stmt->setInt(1, $businessID);
            $stmt->setString(2, $YearMonth);
            $rs = $stmt->executeQuery();
            
            while($rs->next()) {
                $return[] = $rs->getRow();
            }
        }
        
        return $return;
    }   
    
    
    /**
     * Insert in journal entries for items which 
     * do not involve accounts payable or receivable
     *
     * @param     array    $values
     */
    public function insertPayment($values) 
    {
        $statement =
        "declare ".
        "  v_payment_id    rnt_payments.payment_id%TYPE; ".
        "  v_pay_alloc_id  rnt_payment_allocations.pay_alloc_id%TYPE; ".
        "  v_ledger_id     rnt_ledger_entries.ledger_id%TYPE; ".
        "  v_payment_type  rnt_payment_types.payment_type_id%TYPE; ".
        "begin ".
        "    v_payment_id := rnt_payments_pkg.insert_row( ".
        "        X_PAYMENT_DATE     => :var1,  ".
        "        X_DESCRIPTION      => :var2,  ".
        "        X_PAID_OR_RECEIVED => 'PAID', ".
        "        X_AMOUNT           => :var3,  ".
        "        X_TENANT_ID        => to_number(null), ".
        "        X_BUSINESS_ID      => :var4); ".
              
        "    v_pay_alloc_id := rnt_payment_allocations_pkg.insert_row( ".
        "        X_PAYMENT_DATE => :var1, ".
        "        X_AMOUNT       => :var3, ".
        "        X_AR_ID        => to_number(null), ".
        "        X_AP_ID        => to_number(null), ".
        "        X_PAYMENT_ID   => v_payment_id); ".

        "    v_payment_type := rnt_ledger_pkg.get_payment_type_id('Building Purchase'); ".
        "    v_ledger_id := rnt_ledger_entries_pkg.insert_row( ".
        "        X_ENTRY_DATE     => :var1, ".
        "        X_DESCRIPTION    => :var2, ".
        "        X_DEBIT_ACCOUNT  => :var5, ".
        "        X_CREDIT_ACCOUNT => :var6, ".
        "        X_AR_ID => to_number(null), ".
        "        X_AP_ID => to_number(null), ".
        "        X_PAY_ALLOC_ID    => v_pay_alloc_id, ".
        "        X_PAYMENT_TYPE_ID => v_payment_type, ".
        "        X_PROPERTY_ID     => :var7); ".
        
        "end;";
        
        $prepare = $this->connection->prepareStatement($statement);
        
        $prepare->setDate(1, UtlConvert::displayToDBDate($values["PAYMENT_DATE"]));
        $prepare->set(2, $values["DESCRIPTION"]);
        $prepare->set(3, UtlConvert::DisplayNumericToDB($values["AMOUNT"]));
        $prepare->set(4, $values["BUSINESS_ID"]);
        $prepare->set(5, $values["DEBIT_ACCOUNT"]);
        $prepare->set(6, $values["CREDIT_ACCOUNT"]);
        $prepare->set(7, $values["PROPERTY_ID"]);
        
        $prepare->executeUpdate();        
    }
    
    public function updatePayment($values)
    {
        $statement =
        "declare ".
        "   v_pay_alloc_id    rnt_payment_allocations.pay_alloc_id%TYPE; ".
        "begin ".
        "    update  rnt_payments ".
        "    set     PAYMENT_DATE = :var1, ".
        "            AMOUNT       = :var2  ".
        "    where   payment_id   = :var3; ".
        
        "    update rnt_payment_allocations ".
        "    set    PAYMENT_DATE = :var1, ".
        "           AMOUNT       = :var2 ".
        "    where  payment_id   = :var3 ".
        "    returning pay_alloc_id into v_pay_alloc_id; ".
        
        "    update rnt_ledger_entries ".
        "    set    ENTRY_DATE     = :var1, ".
        "           DESCRIPTION    = :var4, ".
        "           DEBIT_ACCOUNT  = :var5, ".
        "           CREDIT_ACCOUNT = :var6, ".
        "           PROPERTY_ID    = :var7 ".
        "    where  pay_alloc_id   = v_pay_alloc_id ".
        "    and    ar_id is null ".
        "    and    ap_id is null; ".
        "end;";
        
        $prepare = $this->connection->prepareStatement($statement);
        
        $prepare->setDate(1, UtlConvert::displayToDBDate($values["PAYMENT_DATE"]));
        $prepare->set(2, UtlConvert::DisplayNumericToDB($values["AMOUNT"]));
        $prepare->set(3, $values["PAYMENT_ID"]);
        $prepare->set(4, $values["DESCRIPTION"]);
        $prepare->set(5, $values["DEBIT_ACCOUNT"]);
        $prepare->set(6, $values["CREDIT_ACCOUNT"]);
        $prepare->set(7, $values["PROPERTY_ID"]);
        //$prepare->set(8, $values["BUSINESS_ID"]);
     
        $prepare->executeUpdate();
    }
      
    public function Updates(&$values)
    {
        foreach($values as $v)
        {
           if (!$v["PAYMENT_ID"]) {
              $this->insertPayment($v);
           }
           else {
              $this->updatePayment($v);
           }
        }
    }
    
    public function deletePayment($paymentId) 
    {
        if (empty($paymentId)) {
            return;
        }
        
        $statement = 
        "declare ".
        "  cursor pay_alloc_cur(cp_payment_id in number) ".
        "  is     select pay_alloc_id  ".
        "         from   rnt_payment_allocations ".
        "         where  payment_id = cp_payment_id; ".
        "  v_pay_alloc_id  rnt_payment_allocations.pay_alloc_id%TYPE; ".
        "begin ".
        "    open  pay_alloc_cur(:var1); ".
        "    fetch pay_alloc_cur into v_pay_alloc_id; ".
        "    close pay_alloc_cur; ".
             
        "    delete from rnt_ledger_entries ".
        "    where pay_alloc_id = v_pay_alloc_id; ".
             
        "    delete from rnt_payment_allocations   ".
        "    where  pay_alloc_id = v_pay_alloc_id; ".
            
        "    delete from rnt_payments   ".
        "    where  payment_id = :var1; ".
        "end;";

        $prepare = $this->connection->prepareStatement($statement);
        $prepare->set(1, $paymentId);
        $prepare->executeUpdate();
    }
    
 }
?>