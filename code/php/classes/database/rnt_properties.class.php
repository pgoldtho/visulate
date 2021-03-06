<?
  require_once dirname(__FILE__)."/../LOV.class.php";
  require_once dirname(__FILE__)."/../UtlConvert.class.php";
  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";

class RNTProperties extends RNTBase {

    public function __construct($connection){
         parent::__construct($connection);
    }

    public function getProperty($id)
    {
        if ($id == NULL) {
            $id = 0;
        }
        
        $r = array();
        
        $query = "select PROPERTY_ID, BUSINESS_ID, UNITS, BUSINESS_NAME,
                         initcap(ADDRESS1) as ADDRESS1,
                         initcap(ADDRESS2) as ADDRESS2,
                         initcap(CITY)     as CITY,
                         STATE, STATE_NAME,
                         ZIPCODE, DATE_PURCHASED,
                         PURCHASE_PRICE, LAND_VALUE,
                         DEPRECIATION_TERM,
                         YEAR_BUILT, BUILDING_SIZE, LOT_SIZE,
                         DATE_SOLD, SALE_AMOUNT, NOTE_YN, DESCRIPTION, NAME, STATUS,
                         PROP_ID, COUNT_UNITS, CHECKSUM
                  from   RNT_PROPERTIES_V
                  where  PROPERTY_ID = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $id);
        $rs = $stmt->executeQuery();
            
        while($rs->next()) {
            $r = $rs->getRow();
        }
        // append to array keys PROP_
        $return = array();
        foreach($r as $k=>$v) {
            $return["PROP_".$k] = $v;
        }

        return $return;
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

    public function getBusinessUnitList()
    {
       $lov = new DBLov($this->connection);
       return $lov->HTMLSelectArray("
            select BUSINESS_ID as CODE, BUSINESS_NAME as VALUE
            from RNT_BUSINESS_UNITS
            order by BUSINESS_NAME");
    }

    public function getUnitsList($propertyID, $isRequire = TRUE)
    {
        if ($propertyID == NULL) {
         $propertyID = 0;
        }
        $lov = new DBLov($this->connection);
        return $lov->HTMLSelectArray("
                select
                   UNIT_ID as CODE, UNIT_NAME as VALUE
                from RNT_PROPERTY_UNITS
                where PROPERTY_ID = :var1
                order by lpad(UNIT_NAME, 32, '0')", $isRequire, $propertyID);
    }

    public function getStatusList()
    {
       $lov = new DBLov($this->connection);
       return $lov->HTMLSelectArray("
            select LOOKUP_CODE as CODE, LOOKUP_VALUE as VALUE
            from   RNT_LOOKUP_VALUES_V
            where  LOOKUP_TYPE_CODE = 'PROPERTY_STATUS'
            order  by LOOKUP_CODE");
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
               $statement = "
                 begin
                  RNT_PROPERTIES_PKG.$proc(
                     X_PROPERTY_ID => :var1,";
       else if ($operation == RNTBase::INSERT_ROW)
         $statement = "
                 begin
                  :var1 := RNT_PROPERTIES_PKG.$proc(";

       $statement .= "
                     X_BUSINESS_ID => :var2,
                     X_UNITS => :var19,
                     X_NAME => :var20,
                     X_ADDRESS1 => :var3,
                     X_ADDRESS2 => :var4,
                     X_CITY => :var5,
                     X_STATE => :var6,
                     X_ZIPCODE => :var7,
                     X_STATUS => :var21,
                     X_DATE_PURCHASED => :var8,
                     X_PURCHASE_PRICE => :var9,
                     X_LAND_VALUE => :var10,
                     X_DEPRECIATION_TERM => :var11,
                     X_YEAR_BUILT => :var12,
                     X_BUILDING_SIZE => :var13,
                     X_LOT_SIZE => :var14,
                     X_DATE_SOLD => :var15,
                     X_SALE_AMOUNT => :var16,
                     X_NOTE_YN => :var17";

        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= ",X_CHECKSUM => :var18";

        $statement .= "); end;";

        $prepare = $this->connection->prepareStatement($statement);

        if ($operation == RNTBase::INSERT_ROW)
           // blank value for initial
           $prepare->set(1, '23423423123');
        else if ($operation == RNTBase::UPDATE_ROW)
           $prepare->setInt(1, $value["PROP_PROPERTY_ID"]);

        $prepare->setInt(2, $value["PROP_BUSINESS_ID"]);
        $prepare->setInt(19, $value["PROP_UNITS"]);
        $prepare->setString(20, $value["PROP_NAME"]);
        $prepare->setString(3, $value["PROP_ADDRESS1"]);
        $prepare->setString(4, $value["PROP_ADDRESS2"]);
        $prepare->setString(5, $value["PROP_CITY"]);
        $prepare->setString(6, $value["PROP_STATE"]);
        $prepare->setString(7, $value["PROP_ZIPCODE"]);
        $prepare->setString(21, $value["PROP_STATUS"]);

        $prepare->setDate(8, UtlConvert::displayToDBDate($value["PROP_DATE_PURCHASED"]));
        // float
        $prepare->set(9, UtlConvert::DisplayNumericToDB($value["PROP_PURCHASE_PRICE"]));
        // float
        $prepare->set(10, UtlConvert::DisplayNumericToDB($value["PROP_LAND_VALUE"]));
        // float
        $prepare->set(11, UtlConvert::DisplayNumericToDB($value["PROP_DEPRECIATION_TERM"]));
        // int
        $prepare->set(12, $value["PROP_YEAR_BUILT"]);
        // float
        $prepare->set(13, UtlConvert::DisplayNumericToDB($value["PROP_BUILDING_SIZE"]));
        // float
        $prepare->set(14, UtlConvert::DisplayNumericToDB($value["PROP_LOT_SIZE"]));
        $prepare->setDate(15,  UtlConvert::displayToDBDate($value["PROP_DATE_SOLD"]));
        // float
        $prepare->set(16, UtlConvert::DisplayNumericToDB($value["PROP_SALE_AMOUNT"]));
        // checkbox
        $prepare->setString(17, ($value["PROP_NOTE_YN"] ==  1)  ? "Y" : "N");
        if ($operation == RNTBase::UPDATE_ROW)
            $prepare->setString(18, $value["PROP_CHECKSUM"]);

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


    public function getPropertyUnitsList($id)
    {
        $return = array();
        if ($id == NULL) {
            return $return;
        }
        
        $query = "select UNIT_ID, PROPERTY_ID,  UNIT_NAME, UNIT_SIZE, BEDROOMS,
                         BATHROOMS, DESCRIPTION,
                         CHECKSUM
                  from   RNT_PROPERTY_UNITS_V
                  where PROPERTY_ID  = :var1
                  order by lpad(UNIT_NAME, 32, '0')";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $id);
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $r = $rs->getRow();
            $r1 = array();
            
            foreach($r as $k=>$v) {
                $r1["UNIT_".$k] = $v;
            }
            $return[] = $r1;
        }
        return $return;
    }

    public function getPropertyUnit($id)
    {
        $return = array();
        if ($id == NULL) {
            return $return;
        }
        
        $query = "select UNIT_ID, PROPERTY_ID, UNIT_NAME, UNIT_SIZE, BEDROOMS,
                         BATHROOMS, DESCRIPTION,
                         CHECKSUM
                  from   RNT_PROPERTY_UNITS_V
                  where  UNIT_ID = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $id);
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $r = $rs->getRow();
            $r1 = array();
            
            foreach($r as $k=>$v) {
                $r1["UNIT_".$k] = $v;
            }
            $return = $r1;
        }
        return $return;
    }

    private function OperationUnit(&$value, $operation, $num_units, $prop_size)
    {
       $proc = "";
       switch($operation )
       {
        case (RNTBase::UPDATE_ROW) : $proc = "UPDATE_ROW"; break;
        case (RNTBase::INSERT_ROW) : $proc = "INSERT_ROW"; break;
        default : throw new Exception("Not allowed value");
       }

       $statement = '';
       if ($operation == RNTBase::UPDATE_ROW)
               $statement =
                 "begin
                  RNT_PROPERTY_UNITS_PKG.$proc(
                     X_UNIT_ID => :var1,";
       else if ($operation == RNTBase::INSERT_ROW)
         $statement = "
                 begin
                  :var1 := RNT_PROPERTY_UNITS_PKG.$proc(";

       $statement .= "
                     X_PROPERTY_ID => :var2,
                     X_UNIT_NAME => :var3,
                     X_UNIT_SIZE => :var4,
                     X_BEDROOMS => :var5,
                     X_BATHROOMS => :var6";

        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= ",X_CHECKSUM => :var7";

        $statement .= "); end;";

        $prepare = $this->connection->prepareStatement($statement);

        if ($operation == RNTBase::INSERT_ROW)
           // blank value for initial
           $prepare->set(1, '23423423123');
        else if ($operation == RNTBase::UPDATE_ROW)
           $prepare->setInt(1, $value["UNIT_UNIT_ID"]);

        $prepare->setInt(2, $value["UNIT_PROPERTY_ID"]);
        if ($num_units == 1)
           $value["UNIT_UNIT_NAME"] = 'Single Unit';

        $prepare->setString(3, $value["UNIT_UNIT_NAME"]);
        if ($num_units == 1)
            $value["UNIT_UNIT_SIZE"] = $prop_size;
        $prepare->set(4, $value["UNIT_UNIT_SIZE"]);
        // int
        $prepare->set(5, $value["UNIT_BEDROOMS"]);
        // int
        $prepare->set(6, $value["UNIT_BATHROOMS"]);

        if ($operation == RNTBase::UPDATE_ROW)
            $prepare->setString(7, $value["UNIT_CHECKSUM"]);

        @$prepare->executeUpdate();

        if ($operation == RNTBase::INSERT_ROW)
          return OCI8PreparedStatementVars::getVar($prepare, 1);
    }

    public function updateUnits(&$values)
    {
/*        echo "<pre>";
        print_r($values);*/
        if (!array_key_exists("UNITS", $values))
          return;

        $num_units = $values["PROP_UNITS"];
        $prop_size = UtlConvert::DisplayNumericToDB($values["PROP_BUILDING_SIZE"]);
        $units = $values["UNITS"];

        foreach($units as $v)
        {
           if (!$v["UNIT_UNIT_ID"])
              // then insert
              $this->OperationUnit($v, RNTBase::INSERT_ROW, $num_units, $prop_size);
           else
              $this->OperationUnit($v, RNTBase::UPDATE_ROW, $num_units, $prop_size);
        }
    }

    public function deleteUnit($id)
    {
          if ($id == NULL)
            return;
          $statement = "begin RNT_PROPERTY_UNITS_PKG.DELETE_ROW(X_UNIT_ID => :var1); end;";
          $prepare = $this->connection->prepareStatement($statement);
          $prepare->setInt(1, $id);
          @$prepare->executeUpdate();
    }

    public function deleteProperty($id)
    {
          if ($id == NULL)
            return;
          $statement = "begin RNT_PROPERTIES_PKG.DELETE_ROW(X_PROPERTY_ID => :var1); end;";
          $prepare = $this->connection->prepareStatement($statement);
          $prepare->setInt(1, $id);
          @$prepare->executeUpdate();
    }

    public function getBusinessUnit($propertyID)
    {
        $result = 0;
        
        $query = "select BUSINESS_ID
                  from   RNT_PROPERTIES
                  where  PROPERTY_ID = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $propertyID);
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $x = $rs->getRow();
            $result = $x["BUSINESS_ID"];
        }
        
        $rs->close();
        return $result;
     }

    public function getPropertyLOV($businessID = "")
    {
       $sql = "select p.PROPERTY_ID CODE, p.ADDRESS1 VALUE
			   from RNT_PROPERTIES p,
				     RNT_BUSINESS_UNITS_V bu
			   where p.BUSINESS_ID = bu.BUSINESS_ID
				 and PARENT_BUSINESS_ID != 0
				 ".($businessID ? "and bu.BUSINESS_ID = :var1" : "")."
			   order by bu.BUSINESS_NAME, p.ZIPCODE, p.ADDRESS1, p.ADDRESS2
               ";
       $lov = new DBLov($this->connection);
       return $lov->HTMLSelectArray($sql, TRUE, $businessID);

    }

    public function getPropertiesList($businessID = "")
    {
        if ($businessID == "") {
            $businessID = 0;
        }

        $result = array();

        $query  = "select p.*,
                          p.STATUS as STATUS_OLD,
                          RNT_PROPERTIES_PKG.GET_CKECKSUM(p.PROPERTY_ID) as checksum
		           from   RNT_PROPERTIES p
		           where  p.BUSINESS_ID = :var1
                   order  by p.ADDRESS1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $businessID);
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $result[] = $rs->getRow();
        }
        return $result;
    }

   public function getActivePropertiesList($businessID = "")
    {
        if ($businessID == "") {
            $businessID = 0;
        }

        $result = array();

        $query  = "select p.PROPERTY_ID
                   ,      p.BUSINESS_ID
                   ,      p. UNITS
                   ,      initcap(p.ADDRESS1) ADDRESS1
                   ,      initcap(p.ADDRESS2) ADDRESS2
                   ,      initcap(p.CITY)     CITY
                   ,      p.STATE
                   ,      p.ZIPCODE
                   ,      p.DATE_PURCHASED
                   ,      p.PURCHASE_PRICE
                   ,      p.LAND_VALUE
                   ,      p.DEPRECIATION_TERM
                   ,      p.YEAR_BUILT
                   ,      p.BUILDING_SIZE
                   ,      p.LOT_SIZE
                   ,      p.DATE_SOLD
                   ,      p.SALE_AMOUNT
                   ,      p.NOTE_YN
                   ,      p.DESCRIPTION
                   ,      p.NAME
                   ,      p.STATUS
                   ,      p.PROP_ID
                   ,      u.total_beds
                   ,      u.total_baths
                   ,      p.STATUS as STATUS_OLD,
                          RNT_PROPERTIES_PKG.GET_CKECKSUM(p.PROPERTY_ID) as checksum
                           from   RNT_PROPERTIES p
                           ,      (select property_id
                                   ,      sum(bedrooms)  total_beds
                                   ,      sum(bathrooms) total_baths
                                   from  rnt_property_units u
                                   group by property_id) u
                           where  p.BUSINESS_ID = :var1
                           and status != 'REJECTED'
                           and status != 'SOLD'
                           and u.property_id = p.property_id
                   order  by p.ADDRESS1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $businessID);
        $rs = $stmt->executeQuery();

        while($rs->next()) {
            $result[] = $rs->getRow();
        }
        return $result;
    }

    public function getPropertyBusinessUnits($businessID, $propertyID = "")
    {
        if ($businessID == "") {
            $businessID = 0;
        }
        
        $r = array();
        
        $query = "select PROPERTY_ID, BUSINESS_ID, UNITS, BUSINESS_NAME, ADDRESS1,
                         ADDRESS2, CITY, STATE, STATE_NAME,
                         ZIPCODE, DATE_PURCHASED,
                         PURCHASE_PRICE, LAND_VALUE,
                         DEPRECIATION_TERM,
                         YEAR_BUILT, BUILDING_SIZE, LOT_SIZE,
                         DATE_SOLD, SALE_AMOUNT, NOTE_YN, DESCRIPTION, NAME, STATUS,
                         COUNT_UNITS, CHECKSUM
                  from   RNT_PROPERTIES_V
                  where  BUSINESS_ID = :var1 ".
                         ($propertyID ? " and PROPERTY_ID = :var2 " : "").
                 "order  by ADDRESS1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $businessID);
        if ($propertyID) {
            $stmt->setInt(2, $propertyID);
        }
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $r[] = $rs->getRow();
        }
        return $r;
    }


    public function updatePropertyDescription($propertyID, $value)
    {
        $statement =
        "declare
          l_checksum    varchar2(32);
         begin
             RNT_PROPERTIES_PKG.lock_row(:var1);
             l_checksum := RNT_PROPERTIES_PKG.get_ckecksum(:var1);
             if :var2 != l_checksum then
                 RAISE_APPLICATION_ERROR(-20002, 'Record was changed another user.');
             end if;
             UPDATE rnt_properties
             SET    description = :var3
             WHERE  property_id = :var1;
         end;";

        $prepare = $this->connection->prepareStatement($statement);

        $prepare->setInt(1, $propertyID);
        $prepare->setString(2, $value["property_checksum"]);
        $prepare->setString(3, $value["property_description"]);

        $numaffected = $prepare->executeUpdate();

        return $numaffected;
    }//end func updatePropertyDescription

    public function updateUnitDescription($unitID, $value)
    {
        $statement =
        "declare
          l_checksum    varchar2(32);
         begin
             RNT_PROPERTY_UNITS_PKG.lock_row(:var1);
             l_checksum := RNT_PROPERTY_UNITS_PKG.get_checksum(:var1);
             if :var2 != l_checksum then
                 RAISE_APPLICATION_ERROR(-20002, 'Record was changed another user.');
             end if;
             UPDATE rnt_property_units
             SET    description = :var3
             WHERE  unit_id = :var1;
         end;";

        $prepare = $this->connection->prepareStatement($statement);

        $prepare->setInt(1, $unitID);
        $prepare->setString(2, $value["unit_checksum"]);
        $prepare->setString(3, $value["unit_description"]);

        $numaffected = $prepare->executeUpdate();

        return $numaffected;
    }//end func updateUnitDescription


    public function updatePropertyStatus($propertyID, $new)
    {
        $statement =
        "declare
          l_checksum    varchar2(32);
         begin
             RNT_PROPERTIES_PKG.lock_row(:var1);
             l_checksum := RNT_PROPERTIES_PKG.get_ckecksum(:var1);
             if :var2 != l_checksum then
                 RAISE_APPLICATION_ERROR(-20002, 'Record was changed another user.');
             end if;
             UPDATE rnt_properties
             SET    status      = :var3
             WHERE  property_id = :var1;
         end;";

        $prepare = $this->connection->prepareStatement($statement);

        $prepare->setInt(1, $propertyID);
        $prepare->setString(2, $new["checksum"]);
        $prepare->setString(3, $new["status"]);

        $numaffected = $prepare->executeUpdate();

        return $numaffected;
    }//end func updatePropertyStatus


    /**
     * Repair Estimates data for "Buyer" Business->Snapshot screen
     *
     * @param    number    $businessID
     * @return   array
     */
    public function getRepairEstimates($businessID)
    {
        if ($businessID == "") {
            $businessID = 0;
        }

        $result = array();
        //
        $query = "select p.property_id,
                         p.address1              as address,
                         p.building_size         as sqft,
                         nvl(pv.asking_price, 0) as asking_price,
                         nvl(pv.offer_price, 0)  as offer_price,
                         nvl(e.estimates, 0)     as cost_estimates,
                         nvl(pv.offer_price, 0) + nvl(e.estimates, 0) as cost_basis,
                         round((nvl(pv.offer_price, 0) + nvl(e.estimates, 0))/greatest(p.building_size, 1),2) as price_sqft,
                         nvl(pv.arv, 0)  as arv,
                         nvl(pv.arv, 0) - nvl(pv.offer_price, 0) - nvl(e.estimates, 0) as profit_loss
                  from   rnt_properties   p,
                         (select pe.property_id,
                                 sum(pei.item_cost * pei.estimate) as estimates
                          from   rnt_property_expenses   pe,
                                 rnt_expense_items    pei
                          where  pei.expense_id  = pe.expense_id
                          and    pei.accepted_yn = 'Y'
                          group  by pe.property_id
                         )   e,
                         (select t.property_id,
                                 max(decode(t.value_method, 'ASK',  t.value, to_number(null))) as asking_price,
                                 max(decode(t.value_method, 'OFFER',t.value, to_number(null))) as offer_price,
                                 max(decode(t.value_method, 'ARV',  t.value, to_number(null))) as arv
                          from   rnt_property_value t,
                                 (select property_id,
                                         value_method,
                                         max(value_date) as last_value_date 
                                  from   rnt_property_value
                                  group  by property_id, value_method
                                 ) x
                          where  t.property_id  = x.property_id
                          and    t.value_method = x.value_method
                          and    t.value_date   = x.last_value_date
                          group  by t.property_id
                         )   pv
                  where  e.property_id  (+)= p.property_id
                  and    pv.property_id (+)= p.property_id
                  and    p.business_id     = :var1
                  and    p.status in ('CANDIDATE','OFFER_MADE','OFFER_ACCEPTED')";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $businessID);
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $result[] = $rs->getRow();
        }
        return $result;
    }//end func getRepairEstimates

    /**
     * Cash Flow Estimates data for "Buyer" Business->Snapshot screen
     *
     * @param     number    $businessID
     * @param     string    $need_date
     * @return    array
     */
    public function getCashFlowEstimates($businessID, $need_date = '01/01/2009')
    {
        if ($businessID == "") {
            $businessID = 0;
        }

        $result = array();

        //
        $query = "select p.property_id,
                         p.address1                                             as address,
                         pe.property_estimates_id,
                         nvl(pe.estimate_title, 'Pro-forma Estimate')           as title,
                         nvl(pe.purchase_price, 0)                              as price,
                         nvl(pe.monthly_rent, 0)                                as monthly_rent,
                         nvl(pe.monthly_rent * 12, 0)                           as annual_rent,
                         perf.income_amount,
                         perf.expense_amount,
                         perf.income_amount - perf.expense_amount               as NOI,
                         pe.cap_rate,
                         (nvl(pe.down_payment, 0) + nvl(pe.closing_costs, 0) )  as cash_invested,
                         round((((perf.income_amount - perf.expense_amount)
                           -(rnt_loans_pkg.get_mortgage_payment( nvl(pe.loan1_amount, 0)
                                                               , nvl(pe.loan1_rate, 0)
                                                               , nvl(pe.loan1_term, 0)
                                                               , decode(pe.loan1_type, 'Interest Only', 'I'
                                                                                     , 'Amortizing',    'A')) * 12)
                           -(rnt_loans_pkg.get_mortgage_payment( nvl(pe.loan2_amount, 0)
                                                               , nvl(pe.loan2_rate, 0)
                                                               , nvl(pe.loan2_term, 0)
                                                               , decode(pe.loan2_type, 'Interest Only', 'I'
                                                                                     , 'Amortizing',    'A'))* 12))
                           / (0.0001 + (nvl(pe.down_payment, 0) + nvl(pe.closing_costs, 0) )) *100), 2)            as cash_on_cash
                     from rnt_properties   p,
                          rnt_property_estimates  pe,
	                 (select p2.property_id,
	                         pe2.property_estimates_id,
                         round((nvl(pe2.monthly_rent * 12, 0) + nvl(pe2.other_income, 0)), 2) as income_amount,
                         round(((nvl(pe2.monthly_rent * 12, 0)* nvl(pe2.vacancy_pct, 0)/100) +
                          (nvl(pe2.replace_3years, 0)/3) +
                          (nvl(pe2.replace_5years, 0)/5) +
                          (nvl(pe2.replace_12years, 0)/12) +
                           nvl(pe2.maintenance, 0) +
                           nvl(pe2.utilities, 0) +
                           nvl(pe2.property_taxes, 0) +
                           nvl(pe2.insurance, 0) +
                           nvl(pe2.mgt_fees, 0) ), 2) as expense_amount
                        from  rnt_properties   p2,
                        rnt_property_estimates  pe2
                        where pe2.property_id = p2.property_id)  perf
                  where  pe.property_id       = p.property_id
                  and    perf.property_id     = p.property_id
                  and    perf.property_estimates_id = pe.property_estimates_id
                  and    p.business_id        = :var1
                  and    p.status in ('CANDIDATE','OFFER_MADE','OFFER_ACCEPTED', 'PURCHASED')
									order by p.status, p.name";
        //
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $businessID);
        $rs = $stmt->executeQuery();
        
        $property_address = "$$$$$$$";
        while($rs->next()) {
            $r = $rs->getRow();
            if ($r["ADDRESS"] != $property_address) {
                $property_address = $r["ADDRESS"];
             	//$result[$property_address] = array();
            }
            $result[$property_address][] = $r;
        }

        return $result;
    }//end func getCashFlowEstimates
     
    
    /**
     * Check rows in the child tables for property
     *
     * @param     $property_id    ID of property
     * 
     * @return    true  - if property has rows in child tables,
     *            false - if no.
     */
    public function has_details($property_id)
    {
        if (is_null($property_id)) {
            return;
        }

        $result = FALSE;
        
        $query  = "select 1 as retval
                   from   (select property_id from rnt_property_links 
                           union select property_id from rnt_property_photos 
                           union select property_id from rnt_property_value
                           union select property_id from rnt_property_expenses
                           union select property_id from rnt_property_estimates
                           union select property_id from rnt_loans
                           union select payment_property_id as property_id 
                                 from   rnt_accounts_receivable
                           union select payment_property_id as property_id
                                 from   rnt_accounts_payable
                           union select p.property_id
                                 from   rnt_properties        p,
                                        rnt_property_units    pu,
                                        rnt_tenancy_agreement ta
                                 where  pu.property_id = p.property_id
                                 and    ta.unit_id     = pu.unit_id      
                          ) t
                   where  t.property_id = :var1"; 
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $property_id);
        $rs = $stmt->executeQuery();
        
        if ($rs->next()) {
            $r  = $rs->getRow();
            if ( ! is_null($r["RETVAL"])) {
                $result = TRUE;
            }
        }
        
        return $result;
    }// func has_details
    
    
    /**
     * Copy property to another business unit
     * 
     * @param    $property_id    copied property
     * @param    $buID_from      from business unit
     * @param    $buID_to        to business unit
     */
    public function copy($property_id, $buID_from, $buID_to)
    {
        $statement = "begin RNT_PROPERTIES_PKG.copy(:var1, :var2, :var3); end;";

        $prepare = $this->connection->prepareStatement($statement);

        $prepare->setInt(1, $property_id);
        $prepare->setInt(2, $buID_from);
        $prepare->setInt(3, $buID_to);

        $numaffected = $prepare->executeUpdate();
        
        return $numaffected;
    }// func copy

    
    /**
     * Move property to another business unit
     * 
     * @param    $property_id    moved property
     * @param    $buID_from      from business unit
     * @param    $buID_to        to business unit
     */
    public function move($property_id, $buID_from, $buID_to)
    {
        $statement = "begin RNT_PROPERTIES_PKG.move(:var1, :var2, :var3); end;";

        $prepare = $this->connection->prepareStatement($statement);

        $prepare->setInt(1, $property_id);
        $prepare->setInt(2, $buID_from);
        $prepare->setInt(3, $buID_to);

        $numaffected = $prepare->executeUpdate();
        return $numaffected;        
    }// func move


    // -------------------------------------------------------------------------

    /**
     * Is property already registered in business unit?
     *
     * @param   int     $businessID
     * @param   string  $address1
     * @param   string  $city
     * @param   string  $state
     * @param   string  $zipCode
     * @return  bool
     */
    public function isPropertyRegistered($businessID, $address1, $city, $state, $zipCode)
    {
        $stmt = $this->connection->prepareStatement(
            "select property_id
             from   rnt_properties
             where  business_id     = :var1
             and    upper(address1) = upper(:var2)
             and    upper(city)     = upper(:var3)
             and    upper(state)    = upper(:var4)
             and    upper(zipCode)  = upper(:var5)"
        );
        $stmt->setInt(1, $businessID);
        $stmt->setString(2, $address1);
        $stmt->setString(3, $city);
        $stmt->setString(4, $state);
        $stmt->setString(5, $zipCode);
        $rowSet = $stmt->executeQuery();

        $result = FALSE;
        if ($rowSet->next()) {
            $row    = $rowSet->getRow();
            $result = isset($row["PROPERTY_ID"]) && ( ! empty($row["PROPERTY_ID"]) );
        }

        return $result;
    }

    // -------------------------------------------------------------------------

    /**
     * Load property data from spreadsheet document into DB.
     *
     * @param  int    $businessID
     * @param  array  $spreadsheetData
     * @return bool
     */
    public function loadPropertyDataFromSpreadsheet($businessID, $spreadsheetData)
    {
        if (empty($businessID) || empty($spreadsheetData))
        {
            return FALSE;
        }

        if ($this->isPropertyRegistered(
                $businessID,
                $spreadsheetData['ADDRESS1'],
                $spreadsheetData['CITY'],
                $spreadsheetData['STATE'],
                $spreadsheetData['ZIPCODE']
        ))
        {
            return FALSE;
        }

        $stmt = $this->connection->prepareStatement(
            "begin :var1 := RNT_PROPERTIES_PKG.INSERT_ROW (
                 X_BUSINESS_ID       => :var2,
                 X_UNITS             => :var3,
                 X_NAME              => :var4,
                 X_ADDRESS1          => :var5,
                 X_ADDRESS2          => :var6,
                 X_CITY              => :var7,
                 X_STATE             => :var8,
                 X_ZIPCODE           => :var9,
                 X_STATUS            => :var10,
                 X_DATE_PURCHASED    => :var11,
                 X_PURCHASE_PRICE    => :var12,
                 X_LAND_VALUE        => :var13,
                 X_DEPRECIATION_TERM => :var14,
                 X_YEAR_BUILT        => :var15,
                 X_BUILDING_SIZE     => :var16,
                 X_LOT_SIZE          => :var17,
                 X_DATE_SOLD         => :var18,
                 X_SALE_AMOUNT       => :var19,
                 X_NOTE_YN           => :var20);
            end;"
        );

        $stmt->set(1, '23423423123');
        $stmt->setInt(2, $businessID);
        $stmt->setInt(3, $spreadsheetData["UNITS"]);
        $stmt->setNull(4);
        $stmt->setString(5, $spreadsheetData["ADDRESS1"]);
        $stmt->setString(6, $spreadsheetData["ADDRESS2"]);
        $stmt->setString(7, $spreadsheetData["CITY"]);
        $stmt->setString(8, $spreadsheetData["STATE"]);
        $stmt->setString(9, $spreadsheetData["ZIPCODE"]);
        $stmt->setString(10, 'CANDIDATE');
        $stmt->setNull(11);
        $stmt->setNull(12);
        $stmt->setNull(13);
        $stmt->set(14, 27.5);
        $stmt->set(15, $spreadsheetData["YEAR_BUILT"]);
        $stmt->set(16, $spreadsheetData["BUILDING_SIZE"]);
        $stmt->setNull(17);
        $stmt->setNull(18);
        $stmt->setNull(19);
        $stmt->setString(20, "N");

        @$stmt->executeUpdate();

        return OCI8PreparedStatementVars::getVar($stmt, 1);
    }

    /**
     * Get property estimates for spreadsheet.
     *
     * @param  int   $property_id
     * @return array
     */
    public function getPropertyEstimatesForSpreadsheet($property_id)
    {
        $query  = "select *
                   from   (
                            select t.*, dense_rank() over(order by ESTIMATE_YEAR desc) as dr
                            from   RNT_PROPERTY_ESTIMATES_V t
                            where  PROPERTY_ID = :var1
                          )
                   where  dr = 1";
        return 	$this->sql2array($query, $property_id);
    }
}

?>
