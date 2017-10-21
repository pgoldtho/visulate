<?
  require_once dirname(__FILE__)."/../LOV.class.php";
  require_once dirname(__FILE__)."/../UtlConvert.class.php";
  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";

class RNTAgreement extends RNTBase
{
    private $agr_in_unit = array();
    private $currentAgreementID = -1;

    public function __construct($connection){
         parent::__construct($connection);
    }

    private function append_prefix_agr($array)
    {
        $return = array();
        foreach($array as $k=>$v)
          $return["AGR_".$k] = $v;
        return $return;
    }

    public function getAgreement($agreement_id)
    {
        $r = array();
        if ($agreement_id == NULL) {
            return $r;
        }
        
        $query = "select AGREEMENT_ID, UNIT_ID, AGREEMENT_DATE, 
                         TERM, AMOUNT, AMOUNT_PERIOD,
                         DATE_AVAILABLE, DEPOSIT, LAST_MONTH,
                         DISCOUNT_AMOUNT, DISCOUNT_TYPE, DISCOUNT_PERIOD, END_DATE,
                         ad_publish_yn, ad_title, ad_contact, ad_email, ad_phone,
                         CHECKSUM,
                         UNIT_NAME, AMOUNTH_PERIOD_NAME, DISCOUNT_TYPE_NAME
                  from   RNT_TENANCY_AGREEMENT_V
                  where  AGREEMENT_ID = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $agreement_id);
        $rs   = $stmt->executeQuery();
        
        while($rs->next()) {
            $r = $rs->getRow();
        }
        $rs->close();
        // append to array keys AGR_ prefix
        return $this->append_prefix_agr($r);
    }

    public function getFirstAgreementForUnit($unit_id)
    {
        $r = array();
        if ($unit_id == NULL) {
            return $r;
        }
        
        $query = "select AGREEMENT_ID, UNIT_ID, AGREEMENT_DATE,
                         TERM, AMOUNT, AMOUNT_PERIOD,
                         DATE_AVAILABLE, DEPOSIT, LAST_MONTH,
                         DISCOUNT_AMOUNT, DISCOUNT_TYPE, DISCOUNT_PERIOD,
                         END_DATE,
                         ad_publish_yn, ad_title, ad_contact, ad_email, ad_phone,
                         UNIT_NAME, AMOUNTH_PERIOD_NAME, DISCOUNT_TYPE_NAME,
                         CHECKSUM,
                         row_number() over (partition by UNIT_ID order by AGREEMENT_DATE) as ROW_NUM_IN_UNIT,
                         count(*) over (partition by UNIT_ID) as ROW_COUNT_IN_UNIT
                  from   RNT_TENANCY_AGREEMENT_V a
                  where  a.UNIT_ID = :var1
                  order by DATE_AVAILABLE desc";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $unit_id);
        $rs   = $stmt->executeQuery();
        
        while($rs->next()) {
             $r = $rs->getRow();
             break;
        }
        
        if (!$r) {
            return array();
        }
        $rs->close();
        // append to array keys AGR_
        return $this->append_prefix_agr($r);
    }

    public function getRentPeriodList()
    {
        $lov = new DBLov($this->connection);
        return $lov->HTMLSelectArray("
            select LOOKUP_CODE as CODE, LOOKUP_VALUE as VALUE
            from RNT_LOOKUP_VALUES_V
            where LOOKUP_TYPE_CODE = 'RENT_PERIOD'
            order by LOOKUP_CODE");
    }

    public function getFeeTypeList($required)
    {
        $lov = new DBLov($this->connection);
        return $lov->HTMLSelectArray("
            select LOOKUP_CODE as CODE, LOOKUP_VALUE as VALUE
            from RNT_LOOKUP_VALUES_V
            where LOOKUP_TYPE_CODE = 'FEE_TYPE'
            order by LOOKUP_CODE", $required);
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
        
        $statement = "";
        if ($operation == RNTBase::UPDATE_ROW)
            $statement =
                "begin RNT_TENANCY_AGREEMENT_PKG.$proc(X_AGREEMENT_ID => :var1,";
        else if ($operation == RNTBase::INSERT_ROW)
            $statement = " begin :var1 := RNT_TENANCY_AGREEMENT_PKG.$proc(";

        $statement .=
                  "X_UNIT_ID => :var2, ".
                  "X_AGREEMENT_DATE => :var3,".
                  "X_TERM => :var4,".
                  "X_AMOUNT => :var5,".
                  "X_AMOUNT_PERIOD => :var6,".
                  "X_DATE_AVAILABLE => :var7,".
                  "X_DEPOSIT => :var8,".
                  "X_LAST_MONTH => :var9,".
                  "X_DISCOUNT_AMOUNT => :var10,".
                  "X_DISCOUNT_TYPE => :var11,".
                  "X_DISCOUNT_PERIOD => :var12,".
                  "X_END_DATE => :var13";


        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= " , X_CHECKSUM => :var14";

        $statement .= "); end;";
        $prepare = $this->connection->prepareStatement($statement);

        if ($operation == RNTBase::INSERT_ROW)
           // blank value for initial
           $prepare->set(1, '23423423123');
        else if ($operation == RNTBase::UPDATE_ROW)
           $prepare->setInt(1, $value["AGR_AGREEMENT_ID"]);

        $prepare->setInt(2, $value["AGR_UNIT_ID"]);

        $prepare->setDate(3, UtlConvert::displayToDBDate($value["AGR_AGREEMENT_DATE"]));
        // int
        $prepare->set(4, $value["AGR_TERM"]);
        // float
        $prepare->set(5, UtlConvert::DisplayNumericToDB($value["AGR_AMOUNT"]));
        $prepare->setString(6, $value["AGR_AMOUNT_PERIOD"]);
        $prepare->setDate(7, UtlConvert::displayToDBDate($value["AGR_DATE_AVAILABLE"]));
        // float
        $prepare->set(8, UtlConvert::DisplayNumericToDB($value["AGR_DEPOSIT"]));
        // float
        $prepare->set(9, UtlConvert::DisplayNumericToDB($value["AGR_LAST_MONTH"]));
        // float
        $prepare->set(10, UtlConvert::DisplayNumericToDB($value["AGR_DISCOUNT_AMOUNT"]));
        $prepare->setString(11, $value["AGR_DISCOUNT_TYPE"]);
        // int
        $prepare->set(12, $value["AGR_DISCOUNT_PERIOD"]);
        $prepare->setDate(13, UtlConvert::displayToDBDate($value["AGR_END_DATE"]));
        if ($operation == RNTBase::UPDATE_ROW)
            $prepare->setString(14, $value["AGR_CHECKSUM"]);

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

    public function setAgreementID($id)
    {
      $this->currentAgreementID = $id;
      $this->setAgreementList();
    }

    public function setAgreementList($currentID = -1)
    {
        if ($currentID == -1) {
            $currentID = $this->currentAgreementID;
        }
        
        $result = array();
        
        $query = "select AGREEMENT_ID
                  from   RNT_TENANCY_AGREEMENT_V
                  where  UNIT_ID = (select UNIT_ID from RNT_TENANCY_AGREEMENT_V where AGREEMENT_ID = :var1)
                  order  by DATE_AVAILABLE desc";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $currentID);
        $rs   = $stmt->executeQuery();
            
        while($rs->next()) {
            $r = $rs->getRow();
            $result[] = $r["AGREEMENT_ID"];
        }
        $rs->close();
        $this->agr_in_unit = $result;
    }

    public function getAgrCountForUnit()
    {
       return count($this->agr_in_unit);
    }

    private function getForDirection($currentID, $direction)
    {
        if ($currentID == NULL)
           return 0;
        if ($currentID == -1)
          $currentID = $this->currentAgreementID;
        $key = array_search($currentID, $this->agr_in_unit);
        if ($key === FALSE)
           return $currentID;
        $key += $direction;

        if ($key < 0 || $key > count($this->agr_in_unit))
            return $currentID;

        return $this->agr_in_unit[$key];
    }

    public function getCurrentRowNum($currentID = -1)
    {
        if ($currentID == -1)
          $currentID = $this->currentAgreementID;
        $key = array_search($currentID, $this->agr_in_unit);
        if ($key === FALSE)
           return 0;
        return $key+1;
    }

    // return prev agreement
    public function getPrevID($currentID = -1)
    {
       return $this->getForDirection($currentID, -1);
    }


    // return next agreement
    public function getNextID($currentID = -1)
    {
       return $this->getForDirection($currentID, 1);
    }

    // return true if agreement has next agreement in order sequence
    public function isHasNext()
    {
        return ($this->getCurrentRowNum() < $this->getAgrCountForUnit());
    }

    // return true if agreement has prev agreement in order sequence
    public function isHasPrev()
    {
        return ($this->getCurrentRowNum() > 1);
    }

    public function Delete($id)
    {
        if ($id == null) {
            return;
        }
        
        $statement = "begin RNT_TENANCY_AGREEMENT_PKG.DELETE_ROW(X_AGREEMENT_ID => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $id);
        @$prepare->executeUpdate();
    }

     public function getTenantList4Action($agreement_id)
     {
         $result = array();
         if ($agreement_id == null) {
             return $result;
         }
         
         $query = "select t.TENANT_ID, t.TENANT_NAME, t.DEPOSIT_BALANCE, t.LAST_MONTH_BALANCE,
                          r.RECEIVE_AMOUNT - r.ALLOCATED_AMOUNT as ARREAR_AMOUNT
                   from   RNT_TENANT_V t,
                          (select  AGREEMENT_ID, TENANT_ID, NVL(sum(AMOUNT), 0) as RECEIVE_AMOUNT, NVL(sum(ALLOCATED), 0) as ALLOCATED_AMOUNT
                           from    (select AGREEMENT_ID, TENANT_ID, r.AMOUNT, NVL(sum(pa.AMOUNT), 0) as ALLOCATED
                                    from   RNT_ACCOUNTS_RECEIVABLE r,
                                           RNT_PAYMENT_ALLOCATIONS pa
                                    where  pa.AR_ID(+) = r.AR_ID
                                    group  by r.AGREEMENT_ID, r.TENANT_ID, r.AMOUNT, r.AR_ID
                                   )
                           group by AGREEMENT_ID, TENANT_ID) r
                   where  t.AGREEMENT_ID = :var1
                   and    t.AGREEMENT_ID = r.AGREEMENT_ID
                   and    t.TENANT_ID    = r.TENANT_ID
                   order  by TENANT_NAME";
         $stmt = $this->connection->prepareStatement($query);
         $stmt->setInt(1, $agreement_id);
         $rs   = $stmt->executeQuery();
         
         while($rs->next()) {
             $result[] = $rs->getRow();
         }
         $rs->close();
         return $result;
     }

     function getTenantRunningTotal($agreement_id)
     {
        
         $query = "select periods.START_DATE, periods.END_DATE,
                          p.LAST_NAME||' '||p.FIRST_NAME as TENANT_NAME,
                          receivables.TENANT_ID,
                          receivables.DUE_AMOUNT,
                          receivables.PAYMENT_DUE_DATE,
                          receivables.PAYMENT_DATE,
                          receivables.ALLOCATED as ALLOCATED_AMOUNT,
                          sum(NVL(receivables.DUE_AMOUNT, 0) - NVL(receivables.ALLOCATED, 0)) over(order by periods.START_DATE, receivables.PAYMENT_DUE_DATE, receivables.PAYMENT_DATE) as ARREARS,
                          sum(receivables.ALLOCATED) over(partition by periods.START_DATE order by receivables.PAYMENT_DUE_DATE, receivables.PAYMENT_DATE) as ALLOCATED_IN_PERIOD
                   from   (table(rnt_gen_periods_pkg.gen_period_rows(
                                     (select NVL(min(PAYMENT_DUE_DATE), SYSDATE) from RNT_ACCOUNTS_RECEIVABLE where AGREEMENT_ID = :var1),
                                     (select NVL(max(PAYMENT_DUE_DATE), SYSDATE) from RNT_ACCOUNTS_RECEIVABLE where AGREEMENT_ID = :var1),
                                     (select AMOUNT_PERIOD from RNT_TENANCY_AGREEMENT where AGREEMENT_ID = :var1)
                                 )
                          )) periods,
                          (select AGREEMENT_ID,
                                  TENANT_ID,
                                  decode(row_number() over(partition by AR_ID order by PAYMENT_DUE_DATE), 1, DUE_AMOUNT, NULL) as DUE_AMOUNT,
                                  ALLOCATED,
                                  PAYMENT_DUE_DATE,
                                  PAYMENT_DATE
                           from   (select r.AR_ID,
                                          r.AGREEMENT_ID,
                                          r.TENANT_ID,
                                          r.AMOUNT as DUE_AMOUNT,
                                          sum(pa.AMOUNT) as ALLOCATED,
                                          r.PAYMENT_DUE_DATE,
                                          pa.PAYMENT_DATE
                                   from   RNT_ACCOUNTS_RECEIVABLE r,
                                          RNT_PAYMENT_ALLOCATIONS pa
                                   where  pa.AR_ID(+) = r.AR_ID
                                   and    r.AGREEMENT_ID  = :var1
                                   group  by r.AR_ID, r.AGREEMENT_ID, r.TENANT_ID, r.PAYMENT_DUE_DATE, r.AMOUNT, r.AR_ID, pa.PAYMENT_DATE
                                   )
                          ) receivables,
                          RNT_TENANT ta,
                          RNT_PEOPLE p
                   where  receivables.PAYMENT_DUE_DATE between periods.start_date and periods.end_date
                   and    ta.TENANT_ID = receivables.TENANT_ID
                   and    p.PEOPLE_ID = ta.PEOPLE_ID
                   order by p.LAST_NAME||' '||p.FIRST_NAME, periods.start_date, receivables.PAYMENT_DUE_DATE, receivables.PAYMENT_DATE";
         $stmt = $this->connection->prepareStatement($query);
         $stmt->setInt(1, $agreement_id);
         $rs   = $stmt->executeQuery();
         
         $result = array();
         while($rs->next()) {
             $result[] = $rs->getRow();
         }
         $rs->close();
         return $result;
     }

     function getActionList($agreement_id)
     {
         $result = array();
         if ($agreement_id == null) {
             return $result;
         }
         
         $query = "select ACTION_ID, AGREEMENT_ID, ACTION_DATE,
                          ACTION_TYPE, RECOVERABLE_YN,
                          ACTION_COST, 
                          CHECKSUM, ACTION_TYPE_NAME
                   from   RNT_AGREEMENT_ACTIONS_V
                   where  AGREEMENT_ID = :var1 
                   order  by ACTION_DATE desc";

         $stmt = $this->connection->prepareStatement($query);
         $stmt->setInt(1, $agreement_id);
         $rs   = $stmt->executeQuery();
         
         while($rs->next()) {
            $r = $rs->getRow();
           
            $result[$r["ACTION_ID"]] = 
                    array( "ACTION_ID"        => $r["ACTION_ID"]
                                                 , "AGREEMENT_ID"     => $r["AGREEMENT_ID"]
                         , "ACTION_DATE"      => $r["ACTION_DATE"]
                         , "ACTION_TYPE"      => $r["ACTION_TYPE"]
                         , "COMMENTS"         => ""
                         , "RECOVERABLE_YN"   => $r["RECOVERABLE_YN"]
                         , "ACTION_COST"      => $r["ACTION_COST"]
                         , "CHECKSUM"         => $r["CHECKSUM"]
                         , "ACTION_TYPE_NAME" => $r["ACTION_TYPE_NAME"]);
         }
         $rs->close();

         return $result;
     }

     function getBUTemplateList($business_id)
     {
      $result = array();
      $query = "select dt.template_id, dt.name
                from rnt_doc_templates  dt
                where dt.business_id = :var1
                order by dt.name";

      $stmt = $this->connection->prepareStatement($query);
      $stmt->setInt(1, $business_id);
      $rs   = $stmt->executeQuery();
         $result[0] = "New Agreement Template";  
      while($rs->next()) {
         $r = $rs->getRow();
         $result[$r["TEMPLATE_ID"]] = $r["NAME"];
         }
      $rs->close();
      return $result;
    }
  
  
     function getTemplateList($property_id)
     {
      $result = array();
      $query = "select dt.template_id, dt.name
                from rnt_doc_templates  dt
                ,    rnt_properties     p
                ,    rnt_business_units b
                where dt.business_id = b.business_id
                and b.business_id = p.business_id
                and p.property_id = :var1
                UNION
                select template_id, name
                from rnt_doc_templates 
                where business_id is null
                order by 2";

      $stmt = $this->connection->prepareStatement($query);
      $stmt->setInt(1, $property_id);
      $rs   = $stmt->executeQuery();

      $result[0] = "No Template";         
      while($rs->next()) {
         $r = $rs->getRow();
         $result[$r["TEMPLATE_ID"]] = $r["NAME"];
         }
      $rs->close();
      return $result;
    }

    function getTemplateName($template_id)
     {
      $query = "select name, RNT_DOC_TEMPLATES_PKG.get_checksum(:var1) checksum
                from rnt_doc_templates
                where template_id = :var2";
  

      $stmt = $this->connection->prepareStatement($query);
      $stmt->setInt(1, $template_id);
      $stmt->setInt(2, $template_id);  
      $rs   = $stmt->executeQuery();
      while($rs->next()) {
         $r = $rs->getRow();
         $result = array( "NAME"      => $r["NAME"]
                    , "CHECKSUM"  => $r["CHECKSUM"]);
         }
      $rs->close();
      return $result;  
  
     }
  
     function getTemplateText($template_id)
     {
      $query = "select content
                from rnt_doc_templates
                where template_id = :var1";
  

      $stmt = $this->connection->prepareStatement($query);
      $stmt->setInt(1, $template_id);
      $rs   = $stmt->executeQuery();
      while($rs->next()) {
         $r = $rs->getRow();
         $result = $r["CONTENT"];
         }
      $rs->close();
      return $result;  
  
  }
  
  function insertNewTemplate($value)
  {
    $statement = "begin :var1 := RNT_DOC_TEMPLATES_PKG.insert_row "
                    . "( X_NAME         => :var2 "
                              . ", X_BUSINESS_ID  => :var3 "
                . ", X_CONTENT      => :var4); "
              . "end;";
  
      $prepare = $this->connection->prepareStatement($statement);
      $prepare->set(1, '23423423123');
      $prepare->setString(2, $value["TEMPLATE_NAME"]);
      $prepare->setInt(3, $value["BUSINESS_ID"]);  
    $prepare->set(4, null);
      @$prepare->executeUpdate();  

    // Use native oci call because Creole LOB implementation is buggy
      $c = oci_connect(DB_USER, DB_PASS, DB_TNS);
      $statement = oci_parse ($c, 
                      "update rnt_doc_templates set content =  EMPTY_CLOB() ".
                              "where template_id = :var2 returning content into :var1");

        $lob = oci_new_descriptor($c, OCI_D_LOB);
    oci_bind_by_name($statement, ':var2', OCI8PreparedStatementVars::getVar($prepare, 1));
        oci_bind_by_name($statement, ':var1', $lob, -1, OCI_B_CLOB);  
    oci_execute($statement, OCI_DEFAULT); // use OCI_DEFAULT so $lob->save() works
        $lob->save($value["T_CONTENT"]);
        oci_commit($c);
        $lob->close();  
  
    return OCI8PreparedStatementVars::getVar($prepare, 1);
  
  }
  
  function updateTemplate($value)
  {
    $statement = "begin ".
                 "    RNT_DOC_TEMPLATES_PKG.update_row".
           "         ( X_TEMPLATE_ID  => :var1".
           "     , X_NAME         => :var2".
                   "         , X_BUSINESS_ID  => :var3".
           "         , X_CONTENT      => :var4".
           "     , X_CHECKSUM     => :var5);".
             " end;";
      $prepare = $this->connection->prepareStatement($statement);
      $prepare->setInt(1, $value["TEMPLATE_ID"]);
      $prepare->setString(2, $value["TEMPLATE_NAME"]);
      $prepare->setInt(3, $value["BUSINESS_ID"]);
    $prepare->set(4, null);
      $prepare->setString(5, $value["T_CHECKSUM"]);  
      @$prepare->executeUpdate();  
    // Use native oci call because Creole LOB implementation is buggy
      $c = oci_connect(DB_USER, DB_PASS, DB_TNS);
      $statement = oci_parse ($c, 
                      "update rnt_doc_templates ".
                              " set content    =  EMPTY_CLOB() ".
                              " where template_id = :var2 ".
                " returning content into :var1");

        $lob = oci_new_descriptor($c, OCI_D_LOB);
        oci_bind_by_name($statement, ':var2', OCI8PreparedStatementVars::getVar($prepare, 1));
        oci_bind_by_name($statement, ':var1', $lob, -1, OCI_B_CLOB);  
  
        oci_execute($statement, OCI_DEFAULT); // use OCI_DEFAULT so $lob->save() works
        $lob->save($value["T_CONTENT"]);
        oci_commit($c);
        $lob->close();  
  }

     function getActionData($action_id)
     {
         $result = array();
         if ($action_id == null) {
             return $result;
         }
         
         $query = "select ACTION_ID, AGREEMENT_ID, ACTION_DATE,
                          ACTION_TYPE, COMMENTS, RECOVERABLE_YN,
                          ACTION_COST,
                          CHECKSUM, ACTION_TYPE_NAME
                   from   RNT_AGREEMENT_ACTIONS_V
                   where  ACTION_ID = :var1";

         $stmt = $this->connection->prepareStatement($query);
         
         
         $stmt->setInt(1, $action_id);
         $rs   = $stmt->executeQuery();
         
         if($rs->next()) {
             $result = $rs->getRow();
         }
         $rs->close();



         return $result;
     }

     function getActionTypes()
     {
         $lov = new DBLov($this->connection);
         return $lov->LOVFromLookup("ACTION_TYPES");
     }


    private function OperationAction($value, $operation)
    {
        $proc = "";
        switch($operation )
        {
            case (RNTBase::UPDATE_ROW) : $proc = "UPDATE_ROW"; break;
            case (RNTBase::INSERT_ROW) : $proc = "INSERT_ROW"; break;
            default : throw new Exception("Not allowed value");
        }
        
        $statement = "";
        if ($operation == RNTBase::UPDATE_ROW)
            $statement =
                "begin RNT_AGREEMENT_ACTIONS_PKG.$proc(X_ACTION_ID => :var1,";
        else if ($operation == RNTBase::INSERT_ROW)
            $statement = " begin :var1 := RNT_AGREEMENT_ACTIONS_PKG.$proc(";

        $statement .= "X_AGREEMENT_ID   => :var2,".
                      "X_ACTION_DATE    => nvl(:var3, sysdate),".
                      "X_ACTION_TYPE    => :var4,".
                      "X_ACTION_COST    => nvl(:var5, 0),".
                      "X_COMMENTS       => :var6,".
                      "X_RECOVERABLE_YN => :var7";

        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= " , X_CHECKSUM => :var8";

        $statement .= "); end;";
        $prepare = $this->connection->prepareStatement($statement);

        if ($operation == RNTBase::INSERT_ROW)
           // blank value for initial
           $prepare->set(1, '23423423123');
        else if ($operation == RNTBase::UPDATE_ROW)
           $prepare->setInt(1, $value["ACTION_ID"]);

        $prepare->setInt(2, $value["AGREEMENT_ID"]);
        $prepare->setDate(3, UtlConvert::displayToDBDate($value["ACTION_DATE"]));
        $prepare->setString(4, $value["ACTION_TYPE"]);
        // float
        $prepare->set(5, UtlConvert::DisplayNumericToDB($value["ACTION_COST"]));
        $prepare->set(6, null);
        $prepare->setString(7, ($value["RECOVERABLE_YN"]) ? "Y" : "N");

        if ($operation == RNTBase::UPDATE_ROW)
            $prepare->setString(8, $value["CHECKSUM"]);

        @$prepare->executeUpdate();
        
        // Use native oci call because Creole LOB implementation is buggy
        $c = oci_connect(DB_USER, DB_PASS, DB_TNS);
        $statement = oci_parse ($c, 
                      "update rnt_agreement_actions
                      set comments    =  EMPTY_CLOB()
                      where action_id = :var2
                      returning comments into :var1");

        $lob = oci_new_descriptor($c, OCI_D_LOB);
        oci_bind_by_name($statement, ':var2', OCI8PreparedStatementVars::getVar($prepare, 1));
        oci_bind_by_name($statement, ':var1', $lob, -1, OCI_B_CLOB);
  
        oci_execute($statement, OCI_DEFAULT); // use OCI_DEFAULT so $lob->save() works
        $lob->save($value["COMMENTS"]);
        oci_commit($c);
        $lob->close();  


  
  
        if ($operation == RNTBase::INSERT_ROW)
          return OCI8PreparedStatementVars::getVar($prepare, 1);
    }

    public function UpdateAction($values)
    {
        $this->OperationAction($values, RNTBase::UPDATE_ROW);
    }

    public function InsertAction($values)
    {
        return $this->OperationAction($values, RNTBase::INSERT_ROW);
    }

    public function DeleteAction($id)
    {
        if ($id == null) {
            return;
        }
        $statement = "begin RNT_AGREEMENT_ACTIONS_PKG.DELETE_ROW(X_ACTION_ID => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $id);
        @$prepare->executeUpdate();
    }

  private function execStatement($proc, $id, &$exceptionList)
  {
     try
     {
        $statement = "begin RNT_TENANCY_AGREEMENT_PKG.$proc(X_AGREEMENT_ID => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $id);
        @$prepare->executeUpdate();
      }
      catch(SQLException $e)
      {
           $exceptionList[] = new SQLExceptionMessage($e);
      }
   }

   public function getIssuesList($agreementID)
   {
       $exceptionList = array();
       $this->execStatement("validate_primary_tenants", $agreementID, $exceptionList);
       $this->execStatement("validate_start_date_is_null", $agreementID, $exceptionList);
       $this->execStatement("validate_start_date_in_future", $agreementID, $exceptionList);
       $this->execStatement("validate_overlap_date", $agreementID, $exceptionList);
       $this->execStatement("validate_end_date_less30days", $agreementID, $exceptionList);
       $this->execStatement("validate_end_date_less60days", $agreementID, $exceptionList);
       $this->execStatement("validate_has_expired", $agreementID, $exceptionList);
       $this->execStatement("validate_end_date_less_start", $agreementID, $exceptionList);
       $this->execStatement("validate_tenant_section8", $agreementID, $exceptionList);
       $this->execStatement("validate_late_fee", $agreementID, $exceptionList);
       if (count($exceptionList) > 0)
       {
           // generate special exeption for desciption
           $ee = new SQLException("See details", "20472: ORA-20472:  ");
           $e = new SQLExceptionMessage($ee);
           $exceptionList[] = $e;
       }

       return $exceptionList;
   }

   function getAgreementsForProp($propertyID){
        $lov = new DBLov($this->connection);
        $sql = "select distinct
              a.AGREEMENT_ID CODE, a.UNIT_NAME||'    / '||t.TENANT_NAME||' /  from '||to_char(a.AGREEMENT_DATE, 'MM-DD-RRRR') as VALUE,
              a.UNIT_NAME, t.TENANT_NAME
         from   RNT_TENANCY_AGREEMENT_V a,
              RNT_TENANT_V t
         where  a.PROPERTY_ID = :var1
         and    t.AGREEMENT_ID = a.AGREEMENT_ID
         order  by lpad(a.UNIT_NAME, 20, '0'), t.TENANT_NAME";
       return $lov->HTMLSelectArray($sql, true, $propertyID);
   }

   function getAgreementsForProp2($propertyID, $agreementID = "")
   {
       $r = array();
       
       $query = "select distinct a.AGREEMENT_ID,
                        a.UNIT_NAME, /*t.TENANT_NAME,*/ to_char(a.AGREEMENT_DATE, 'MM-DD-RRRR') as AGREEMENT_DATE
                 from   RNT_TENANCY_AGREEMENT_V a,
                        RNT_TENANT_V t
                 where  a.PROPERTY_ID = :var1
                 and    t.AGREEMENT_ID = a.AGREEMENT_ID";
       if ($agreementID) {
           $query .= " and a.AGREEMENT_ID = :var2 ";
       }
       $query .=  " order by lpad(a.UNIT_NAME, 20, '0')";
       
       $stmt = $this->connection->prepareStatement($query);
       $stmt->setInt(1, $propertyID);
       if ($agreementID) {
           $stmt->setInt(2, $agreementID);
       }
       $rs = $stmt->executeQuery();
       
       while($rs->next()) {
           $r[] = $rs->getRow();
       }
       $rs->close();
       return $r;
   }


   function getAgreementsForProp3($propertyID, $agreementID = "")
   {
       $r = array();
       
       $query = "select distinct a.AGREEMENT_ID,
                        a.UNIT_NAME, /*t.TENANT_NAME,*/ to_char(a.AGREEMENT_DATE, 'MM-DD-RRRR') as AGREEMENT_DATE
                 from   RNT_TENANCY_AGREEMENT_V a,
                        RNT_TENANT_V t
                 where  a.PROPERTY_ID = :var1 
                 and    t.AGREEMENT_ID = a.AGREEMENT_ID ";
       if ($agreementID) {
           $query .= " and a.AGREEMENT_ID = :var2 ";
       } else {
           $query .= " and exists (select 1 from rnt_tenancy_agreement_v rta
                                   where  (rta.END_DATE > SYSDATE or rta.END_DATE is null)
                                   and    rta.AGREEMENT_ID = a.AGREEMENT_ID )";
       }
       $query .= " order by lpad(a.UNIT_NAME, 20, '0')";
       
       $stmt = $this->connection->prepareStatement($query);
       $stmt->setInt(1, $propertyID);
       if ($agreementID) {
           $stmt->setInt(2, $agreementID);
       }
       $rs = $stmt->executeQuery();
       
       while($rs->next()) {
           $r[] = $rs->getRow();
       }
       $rs->close();
       return $r;
   }

   public function updateAgreementAd($agreementID, $values)
   {
       $statement = "declare "
                  . "  l_checksum    varchar2(32); "
                  . "begin "
                  . "    RNT_TENANCY_AGREEMENT_PKG.lock_row(:var1); "
                  . "    l_checksum := RNT_TENANCY_AGREEMENT_PKG.get_checksum(:var1); "
                  . "    if :var2 != l_checksum then "
                  . "        RAISE_APPLICATION_ERROR(-20002, 'Record was changed another user.'); "
                  . "    end if; "
                  . "    UPDATE rnt_tenancy_agreement "
                  . "    SET    ad_title      = :var3, "
                  . "           ad_contact    = :var4, "
                  . "           ad_email      = :var5, "
                  . "           ad_publish_yn = :var6, "
                  . "           ad_phone      = :var7 "
                  . "    WHERE  agreement_id  = :var1; "
                  . "end;";
        $prepare  = $this->connection->prepareStatement($statement);

        $prepare->setInt(1, $agreementID);
        $prepare->setString(2, $values['agreement_checksum']);
        $prepare->setString(3, $values['ad_title']);
        $prepare->setString(4, $values['ad_contact']);
        $prepare->setString(5, $values['ad_email']);
        $prepare->setString(6, $values['ad_publish_yn']);
        $prepare->setString(7, $values['ad_phone']);

        $numaffected = $prepare->executeUpdate();
        return $numaffected;
   }// updateAgreementAd
}

?>