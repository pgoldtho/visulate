<?php
    require_once dirname(__FILE__)."/../LOV.class.php";
    require_once dirname(__FILE__)."/../UtlConvert.class.php";
    require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
    require_once dirname(__FILE__)."/rnt_base.class.php";

class RNTSupplier extends RNTBase
{
    public function __construct($connection)
    {
         parent::__construct($connection);
    }

    public function getList($business_id)
    {
        $r = array();
        
        $query = "select SUPPLIER_ID, NAME, replace(PHONE1, ' ', '') PHONE1
                  from   RNT_SUPPLIERS_ALL s
                  where  exists (select 1
                                 from RNT_BU_SUPPLIERS b
                                 where s.SUPPLIER_ID = b.SUPPLIER_ID
                                 and b.BUSINESS_ID   = :var1)
                  order by NAME";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $business_id);
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $r[] = $rs->getRow();
        }
        $rs->close();
        return $r;
    }

    public function getListByFilter($business_id, $nameFilter)
    {
        $r = array();
        
        $query = "select SUPPLIER_ID, NAME, replace(PHONE1, ' ', '') PHONE1
                  from   RNT_SUPPLIERS_ALL s
                  where  exists (select 1
                                 from RNT_BU_SUPPLIERS b
                                 where s.SUPPLIER_ID = b.SUPPLIER_ID
                                 and b.BUSINESS_ID   = :var1)
                  and    NAME like :var2
                  order  by NAME";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $business_id);
        $stmt->setString(2, $nameFilter);
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $r[] = $rs->getRow();
        }
        $rs->close();
        return $r;
    }

    public function getAllNeededData($SUPPLIER_ID,$BUSINESS_ID,$YEAR)
    {
        $arr_results = array(
            "ROWS"    =>    array(),
            "YEARS"    =>    array(),
        );
        
        
        $query = "SELECT DISTINCT TO_CHAR(AP.PAYMENT_DUE_DATE,'YYYY') YEAR_
                  from   RNT_ACCOUNTS_PAYABLE AP
                  where  BUSINESS_ID = :var1
                  order  by YEAR_ DESC";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $BUSINESS_ID);
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $row = $rs->getRow();
            $arr_results["YEARS"][] = $row["YEAR_"];
        }
        $rs->close();

        
        $query =
        "select
                P.ADDRESS1 PROPERTY_,
                PE.DESCRIPTION EXPENSE_,
                AP.PAYMENT_DUE_DATE,
                TO_CHAR(AP.PAYMENT_DUE_DATE,'MM/DD/YYYY') DATE_,
                AP.AMOUNT OWED_,
                PA.AMOUNT PAID_,
                PT.PAYMENT_TYPE_NAME,
                AP.INVOICE_NUMBER
        from
                RNT_PROPERTIES P,
                RNT_ACCOUNTS_PAYABLE AP,
                RNT_PROPERTY_EXPENSES PE,
                RNT_PAYMENT_ALLOCATIONS PA,
                RNT_PAYMENT_TYPES PT
        where AP.SUPPLIER_ID     = :var1 
          AND PE.PROPERTY_ID     = P.PROPERTY_ID (+)
          AND PE.EXPENSE_ID      = AP.EXPENSE_ID (+)
          AND AP.AP_ID           = PA.AP_ID (+)
          AND AP.PAYMENT_TYPE_ID = PT.PAYMENT_TYPE_ID
          AND AP.RECORD_TYPE     IN ('G', 'E')
          AND TO_CHAR(AP.PAYMENT_DUE_DATE,'YYYY') = :var2
          and p.BUSINESS_ID  = :var3 
          and ap.BUSINESS_ID = :var3
        UNION ALL
        SELECT  P.ADDRESS1 PROPERTY_,
            'Other Payment' EXPENSE_,
            AP.PAYMENT_DUE_DATE,
            TO_CHAR(AP.PAYMENT_DUE_DATE,'MM/DD/YYYY') DATE_,
            AP.AMOUNT OWED_,
            PA.AMOUNT PAID_,
            PT.PAYMENT_TYPE_NAME,
            AP.INVOICE_NUMBER
        FROM
            RNT_PROPERTIES P,
            RNT_ACCOUNTS_PAYABLE    AP,
            RNT_PAYMENT_ALLOCATIONS PA,
            RNT_PAYMENT_TYPES       PT
        WHERE
            AP.SUPPLIER_ID         = :var1
            AND AP.AP_ID           = PA.AP_ID (+)
            AND AP.PAYMENT_TYPE_ID = PT.PAYMENT_TYPE_ID
            AND AP.RECORD_TYPE     = 'O'
            AND AP.PAYMENT_PROPERTY_ID  = P.PROPERTY_ID (+)
            AND TO_CHAR(AP.PAYMENT_DUE_DATE,'YYYY') = :var2
            and p.BUSINESS_ID  = :var3
            and ap.BUSINESS_ID = :var3
        ORDER BY 3";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $SUPPLIER_ID);
        $stmt->setString(2, $YEAR);
        $stmt->setInt(3, $BUSINESS_ID);
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $arr_row = $rs->getRow();
            $arr_results["ROWS"][] = $arr_row;
        }
        $rs->close();
        return $arr_results;
    }

    public function getSupplier($id)
    {
        $r = array();
        if ($id == null) {
            return $r;
        }
        
        $query = "select SUPPLIER_ID, NAME, PHONE1, PHONE2,
                         ADDRESS1, ADDRESS2, CITY, STATE,
                         ZIPCODE, EMAIL_ADDRESS,
                         COMMENTS, SUPPLIER_TYPE_ID, CHECKSUM
                  from   RNT_SUPPLIERS_ALL_V
                  where  SUPPLIER_ID = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $id);
        $rs = $stmt->executeQuery();
        
        if($rs->next()) {
            $r = $rs->getRow();
        }
        $rs->close();
        return $r;
    }

    public function getBusinessUnitsList(){
       $lov = new DBLov($this->connection);
       return $lov->HTMLSelectArray("
            select BUSINESS_ID as CODE, BUSINESS_NAME as VALUE
            from RNT_BUSINESS_UNITS_V
            where PARENT_BUSINESS_ID != 0
            order by BUSINESS_NAME
       ");
    }


    public function getSupplierBusinessUnits($id)
    {
        $r = array();
        if ($id == null) {
            return $r;
        }
        
        $query = "select BU_SUPPLIER_ID, BUSINESS_ID, SUPPLIER_ID,
                         TAX_IDENTIFIER, NOTES, CHECKSUM
                  from   RNT_BU_SUPPLIERS_V s
                  where  SUPPLIER_ID = :var1
                  and    exists (select 1
                                 from   RNT_BUSINESS_UNITS_V
                                 where BUSINESS_ID = s.BUSINESS_ID)
                  order  by (select BUSINESS_NAME from RNT_BUSINESS_UNITS where BUSINESS_ID = s.BUSINESS_ID)";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $id);
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $r[] = $rs->getRow();
        }
        $rs->close();
        return $r;
    }

    public function getStatesList()
    {
       $lov = new DBLov($this->connection);
       return $lov->HTMLSelectArray("
            select LOOKUP_CODE as CODE, LOOKUP_VALUE as VALUE
            from RNT_LOOKUP_VALUES_V
            where LOOKUP_TYPE_CODE = 'STATES'
            order by LOOKUP_CODE");

    }

    public function getSupplierTypes()
    {
       $lov = new DBLov($this->connection);

       return $lov->HTMLSelectArray("
            select SUPPLIER_TYPE_ID as CODE, SUPPLIER_TYPE_NAME as VALUE
            from RNT_SUPPLIER_TYPES
            order by 2");

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
               $statement = "begin RNT_SUPPLIERS_ALL_PKG.$proc( X_SUPPLIER_ID => :var1,";
       else if ($operation == RNTBase::INSERT_ROW)
         $statement = " begin :var1 := RNT_SUPPLIERS_ALL_PKG.$proc(";
          $statement .="X_NAME => :var2,".
                       "X_PHONE1 => :var3,".
                       "X_PHONE2 => :var4,".
                       "X_ADDRESS1 => :var5,".
                       "X_ADDRESS2 => :var6,".
                       "X_STATE => :var7,".
                       "X_CITY => :var8,".
                       "X_ZIPCODE => :var9,".
                       "X_SUPPLIER_TYPE_ID => :var10,".
                       "X_EMAIL_ADDRESS => :var11,".
                       "X_COMMENTS => :var12"
                       //."X_BUSINESS_ID => :var13"
                       ;
        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= ", X_CHECKSUM => :var14";
        $statement .= "); end;";
        $prepare = $this->connection->prepareStatement($statement);
        if ($operation == RNTBase::INSERT_ROW)
           $prepare->set(1, '23423423123123123');
        else if ($operation == RNTBase::UPDATE_ROW)
           $prepare->setInt(1, $value["SUPPLIER_ID"]);
        $prepare->setString(2, $value["NAME"]);
        $prepare->setString(3, $value["PHONE1"]);
        $prepare->setString(4, $value["PHONE2"]);
        $prepare->setString(5, $value["ADDRESS1"]);
        $prepare->setString(6, $value["ADDRESS2"]);
        $prepare->setString(7, $value["STATE"]);
        $prepare->setString(8, $value["CITY"]);
        $prepare->set(9, $value["ZIPCODE"]);
        $prepare->set(10, $value["SUPPLIER_TYPE_ID"]);
        $prepare->setString(11, $value["EMAIL_ADDRESS"]);
        $prepare->setString(12, $value["COMMENTS"]);
        //$prepare->setInt(13, $value["BUSINESS_ID"]);
        if ($operation == RNTBase::UPDATE_ROW)
             $prepare->setString(14, $value["CHECKSUM"]);

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

    public function Delete($id)
    {
        if ($id == null)
            return;
          $statement = "begin RNT_SUPPLIERS_ALL_PKG.DELETE_ROW(X_SUPPLIER_ID => :var1); end;";
          $prepare = $this->connection->prepareStatement($statement);
          $prepare->setInt(1, $id);
          @$prepare->executeUpdate();
     }


    private function OperationBUSupplier(&$value, $supplierID, $operation)
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
               $statement = "begin RNT_BU_SUPPLIERS_PKG.$proc( X_BU_SUPPLIER_ID => :var1,";
       else if ($operation == RNTBase::INSERT_ROW)
         $statement = " begin :var1 := RNT_BU_SUPPLIERS_PKG.$proc(";

       $statement .="X_BUSINESS_ID => :var2,".
                    "X_SUPPLIER_ID => :var3,".
                    "X_TAX_IDENTIFIER => :var4,".
                    "X_NOTES => :var5";
        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= ", X_CHECKSUM => :var6";
        $statement .= "); end;";
        $prepare = $this->connection->prepareStatement($statement);
        if ($operation == RNTBase::INSERT_ROW)
           $prepare->set(1, '23423423123123123');
        else if ($operation == RNTBase::UPDATE_ROW)
           $prepare->setInt(1, $value["BU_SUPPLIER_ID"]);

        $prepare->set(2, $value["BUSINESS_ID"]);
        $prepare->set(3, $supplierID);
        $prepare->setString(4, $value["TAX_IDENTIFIER"]);
        $prepare->setString(5, $value["NOTES"]);
        if ($operation == RNTBase::UPDATE_ROW)
             $prepare->setString(6, $value["CHECKSUM"]);

        @$prepare->executeUpdate();

        if ($operation == RNTBase::INSERT_ROW)
          return OCI8PreparedStatementVars::getVar($prepare, 1);

    }
     public function UpdateBusinessUnits($values, $supplierID){
        foreach($values as $v){
            if (!@$v["BU_SUPPLIER_ID"])
               $this->OperationBUSupplier($v, $supplierID, RNTBase::INSERT_ROW);
            else
               $this->OperationBUSupplier($v, $supplierID, RNTBase::UPDATE_ROW);
         }
     }

     public function DeleteBusinessUnits($ID)
     {
         if ($ID == null) {
             return;
         }
         $statement = "begin RNT_BU_SUPPLIERS_PKG.DELETE_ROW(X_BU_SUPPLIER_ID => :var1); end;";
         $prepare = $this->connection->prepareStatement($statement);
         $prepare->setInt(1, $ID);
         @$prepare->executeUpdate();
     }

     public function getSupplierForAdd($business_id) {
       $lov = new DBLov($this->connection);
       return $lov->HTMLSelectArray("
                    select SUPPLIER_ID as CODE, NAME||' '||ADDRESS1||' ('||st.SUPPLIER_TYPE_NAME||')' as VALUE
                    from RNT_SUPPLIERS_ALL s,
                         RNT_SUPPLIER_TYPES st
                    where
                          st.SUPPLIER_TYPE_ID = s.SUPPLIER_TYPE_ID
                      and exists (select SUPPLIER_ID
                                  from RNT_BU_SUPPLIERS b,
                                       RNT_BUSINESS_UNITS_V bu
                                  where b.BUSINESS_ID = bu.BUSINESS_ID
                                    and s.SUPPLIER_ID = b.SUPPLIER_ID
                                 )
                      and not exists (select 1
                                      from RNT_BU_SUPPLIERS b
                                      where s.SUPPLIER_ID = b.SUPPLIER_ID
                                        and b.BUSINESS_ID = (select PARENT_BUSINESS_ID from RNT_BUSINESS_UNITS where BUSINESS_ID = $business_id))
                    order by NAME, ADDRESS1, SUPPLIER_TYPE_NAME");
     }

   public function findList($text)
   {
       $cond = "like";
       if (strpos($text, '%') === FALSE) {
           $cond = "=";
       }
       
       $r = array();
       
       //$text = str_replace("'", "''", $text);
       
       $query = "select SUPPLIER_ID, NAME, CITY, ADDRESS1, st.SUPPLIER_TYPE_NAME
                 from   RNT_SUPPLIERS_ALL s,
                        RNT_SUPPLIER_TYPES st
                 where  s.NAME||s.PHONE1||s.PHONE2||s.ADDRESS1||s.ADDRESS2
                        ||s.CITY||s.STATE||s.ZIPCODE||s.EMAIL_ADDRESS
                        ||s.COMMENTS||st.SUPPLIER_TYPE_NAME $cond :var1
                 and    st.SUPPLIER_TYPE_ID = s.SUPPLIER_TYPE_ID
                 and    exists (select 1
                                from   RNT_BU_SUPPLIERS b
                                where  s.SUPPLIER_ID = b.SUPPLIER_ID
                                and    b.BUSINESS_ID in  (select BUSINESS_ID
                                                          from RNT_BUSINESS_UNITS_V)
                               )
                 order  by NAME, CITY, ADDRESS1, st.SUPPLIER_TYPE_NAME";
       $stmt = $this->connection->prepareStatement($query);
       $stmt->setString(1, $text);
       $rs = $stmt->executeQuery();
       
       while($rs->next()) {
           $r[] = $rs->getRow();
       }
       $rs->close();
       return $r;
   }

   public function getIncludingBU($supplier_id)
   {
       $query = "select bu.BUSINESS_ID,
                        bu.BUSINESS_NAME,
                        sbu.TAX_IDENTIFIER,
                        sbu.NOTES,
                        decode(sbu.BUSINESS_ID, NULL, 'N', 'Y') as IS_INCLUDED
                 from   (select BUSINESS_ID, TAX_IDENTIFIER, NOTES  
                         from   RNT_BU_SUPPLIERS where SUPPLIER_ID = :var1) sbu,
                        RNT_BUSINESS_UNITS_V bu
                 where  bu.PARENT_BUSINESS_ID != 0
                 and    bu.BUSINESS_ID         = sbu.BUSINESS_ID(+)
                 order by BUSINESS_NAME";
       $stmt = $this->connection->prepareStatement($query);
       $stmt->setInt(1, $supplier_id);
       $rs = $stmt->executeQuery();
       
       $r = array();
       while($rs->next()) {
           $r[] = $rs->getRow();
       }
       $rs->close();
       return $r;
   }

   public function findForIncluding($NameValue, $PhoneValue, $EmailValue, $Address,
                                     $CityValue, $StateValue, $ZipCodeValue, $SupplierTypeIDValue)
   {
       $whereCond = "";
       /*
       if ($NameValue)
           $whereCond = " and NAME like '".$NameValue."'";
       if ($PhoneValue)
           $whereCond = " and (PHONE1 like '".$PhoneValue."' or PHONE2 like '".$PhoneValue."')";
       if ($EmailValue)
           $whereCond = " and EMAIL_ADDRESS ='".$EmailValue."'";
       if ($Address)
           $whereCond = " and (ADDRESS1 like '".$Address."' or ADDRESS2 like '".$Address."')";
       if ($CityValue)
           $whereCond = " and (CITY like '".$CityValue."')";
       if ($StateValue)
           $whereCond = " and (STATE = '".$StateValue."' )";
       if ($ZipCodeValue)
           $whereCond = " and (ZIPCODE like '".$ZipCodeValue."')";
       if ($SupplierTypeIDValue != "")
           $whereCond = " and (s.SUPPLIER_TYPE_ID = ".$SupplierTypeIDValue.")";
       */
       if ($NameValue) {
           $whereCond = " and NAME like :var1";
       }
       if ($PhoneValue) {
           $whereCond = " and (PHONE1 like :var1 or PHONE2 like :var1)";
       }
       if ($EmailValue) {
           $whereCond = " and EMAIL_ADDRESS = :var1";
       }
       if ($Address) {
           $whereCond = " and (ADDRESS1 like :var1 or ADDRESS2 like :var1)";
       }
       if ($CityValue) {
           $whereCond = " and (CITY like :var1)";
       }
       if ($StateValue) {
           $whereCond = " and (STATE = :var1)";
       }
       if ($ZipCodeValue) {
           $whereCond = " and (ZIPCODE like :var1)";
       }
       if ($SupplierTypeIDValue != "") {
           $whereCond = " and (s.SUPPLIER_TYPE_ID = :var1)";
       }

       $query = "select s.SUPPLIER_ID,
                        s.NAME,
                        s.EMAIL_ADDRESS,
                        s.PHONE1,
                        s.PHONE2,
                        s.ADDRESS1,
                        s.ADDRESS2,
                        s.CITY,
                        s.STATE,
                        s.ZIPCODE,
                        lv.LOOKUP_VALUE as STATE_NAME,
                        st.SUPPLIER_TYPE_NAME
                 from   RNT_SUPPLIERS_ALL s,
                        RNT_SUPPLIER_TYPES st,
                        RNT_LOOKUP_VALUES_V lv
                 where  s.SUPPLIER_TYPE_ID = st.SUPPLIER_TYPE_ID
                 and    lv.LOOKUP_TYPE_CODE = 'STATES'
                 and    lv.LOOKUP_CODE = s.STATE
                     $whereCond
                 order by s.NAME";
       $stmt = $this->connection->prepareStatement($query);
       if ($NameValue) {
           $bind_value = $NameValue;
       }
       if ($PhoneValue) {
           $bind_value = $PhoneValue;
       }
       if ($EmailValue) {
           $bind_value = $EmailValue;
       }
       if ($Address) {
           $bind_value = $Address;
       }
       if ($CityValue) {
           $bind_value = $CityValue;
       }
       if ($StateValue) {
           $bind_value = $StateValue;
       }
       if ($ZipCodeValue) {
           $bind_value = $ZipCodeValue;
       }
       if ($SupplierTypeIDValue != "") {
           $bind_value = $SupplierTypeIDValue;
       }
       $stmt->set(1, $bind_value);
       $rs = $stmt->executeQuery();
       
       $r = array();
       while($rs->next()) {
           $c = $rs->getRow();
           $c["BUSINESS_UNITS"] = $this->getIncludingBU($c["SUPPLIER_ID"]);
           $r[] = $c;
       }
       $rs->close();
       return $r;
   }

    function isExistsBU4Supplier($business_id, $supplier_id)
    {
        $query = "select 'Y' as IS_INCLUDED
                  from   RNT_BU_SUPPLIERS_V
                  where  BUSINESS_ID = :var1 
                  and    SUPPLIER_ID = :var2";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $business_id);
        $stmt->setInt(2, $supplier_id);
        $rs = $stmt->executeQuery();
        
        $r = array();
        while($rs->next()) {
            $r = $rs->getRow();
        }
        $rs->close();
        return count($r) > 0;
    }

    function getSearchBusinessUnit($business_id, $supplier_id)
    {
        $query = "select bs.TAX_IDENTIFIER, bu.BUSINESS_NAME
                  from   RNT_BU_SUPPLIERS_V bs,
                         RNT_BUSINESS_UNITS bu
                  where  bs.BUSINESS_ID = :var1
                  and    bs.SUPPLIER_ID = :var2
                  and    bu.BUSINESS_ID = bs.BUSINESS_ID";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $business_id);
        $stmt->setInt(2, $supplier_id);
        $rs = $stmt->executeQuery();
        
        $r = array();
        while($rs->next()) {
            $r = $rs->getRow();
        }
        $rs->close();
        return $r;
    }
}
?>