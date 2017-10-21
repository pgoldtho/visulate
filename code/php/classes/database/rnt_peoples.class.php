<?
  require_once dirname(__FILE__)."/../LOV.class.php";
  require_once dirname(__FILE__)."/../UtlConvert.class.php";
  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";

class RNTPeoples extends RNTBase
{

    public function __construct($connection){
         parent::__construct($connection);
    }

    public function getList($businessID)
    {
        $r = array();
        
        if ($businessID == NULL) {
            return $r;
        }
        
        $query = "select PEOPLE_ID, FIRST_NAME, LAST_NAME,
                         PHONE1, PHONE2, DATE_OF_BIRTH, EMAIL_ADDRESS,
                         SSN, DRIVERS_LICENSE, BUSINESS_ID,
                         CHECKSUM, PEOPLE_BUSINESS_ID
                  from   RNT_PEOPLE_LIST_V p
                  where  BUSINESS_ID = :var1
                  and    not exists (
                              select 1 from RNT_LEADS_V l
                              where  l.PEOPLE_BUSINESS_ID = p.PEOPLE_BUSINESS_ID
                              and    upper(l.LEAD_STATUS) = 'INACTIVE'
                         )
                  order  by LAST_NAME, FIRST_NAME";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $businessID);
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $r[] = $rs->getRow();
        }
        $rs->close();
        return $r;
    }

    public function getPeople($id, $businessID)
    {
        $r = array();
        if ($id == NULL) {
            return $r;
        }
        
        $query = "select PEOPLE_ID, FIRST_NAME, LAST_NAME,
                         PHONE1, PHONE2, DATE_OF_BIRTH, EMAIL_ADDRESS,
                         SSN, DRIVERS_LICENSE, BUSINESS_ID,
                         CHECKSUM, PEOPLE_BUSINESS_ID
                  from   RNT_PEOPLE_LIST_V
                  where  PEOPLE_ID   = :var1 
                  and    BUSINESS_ID = :var2";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $id);
        $stmt->setInt(2, $businessID);
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $r = $rs->getRow();
        }
        $rs->close();
        return $r;
    }

    public function getPeopleByName($lastName, $firstName)
    {
        if (empty($lastName)) {
            return NULL;
        }
        if (empty($firstName)) {
            return NULL;
        }

        $query = "select PEOPLE_ID, FIRST_NAME, LAST_NAME,
                         PHONE1, PHONE2, DATE_OF_BIRTH, EMAIL_ADDRESS,
                         SSN, DRIVERS_LICENSE, BUSINESS_ID,
                         CHECKSUM, PEOPLE_BUSINESS_ID
                  from   RNT_PEOPLE_LIST_V
                  where  upper(LAST_NAME)  = upper(:var1)
                  and    upper(FIRST_NAME) = upper(:var2)";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $lastName);
        $stmt->setString(2, $firstName);
        $rs = $stmt->executeQuery();

        $r = array();
        while($rs->next()) {
            $r = $rs->getRow();
        }
        $rs->close();
        return $r;
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
                "begin RNT_PEOPLE_PKG.$proc(X_PEOPLE_ID => :var1,";
       else if ($operation == RNTBase::INSERT_ROW)
         $statement = " begin :var1 := RNT_PEOPLE_PKG.$proc(";

        $statement .=
                      "X_FIRST_NAME      => :var2,".
                      "X_LAST_NAME       => :var3,".
                      "X_PHONE1          => :var4,".
                      "X_PHONE2          => :var5,".
                      "X_EMAIL_ADDRESS   => :var6,".
                      "X_SSN             => :var7,".
                      "X_DRIVERS_LICENSE => :var8,".
                      "X_PEOPLE_BUSINESS_ID => :var9,".
                      "X_DATE_OF_BIRTH   => :var10,".
                      "X_BUSINESS_ID     => :var12";

        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= " , X_CHECKSUM => :var11";

        $statement .= "); end;";
        $prepare = $this->connection->prepareStatement($statement);

        if ($operation == RNTBase::INSERT_ROW)
           // blank value for initial
           $prepare->set(1, '23423423123123123');
        else if ($operation == RNTBase::UPDATE_ROW)
           $prepare->setInt(1, $value["PEOPLE_ID"]);

        $prepare->setString(2, $value["FIRST_NAME"]);
        $prepare->setString(3, $value["LAST_NAME"]);
        $prepare->setString(4, $value["PHONE1"]);
        $prepare->setString(5, $value["PHONE2"]);
        $prepare->setString(6, $value["EMAIL_ADDRESS"]);
        $prepare->setString(7, $value["SSN"]);
        $prepare->setString(8, $value["DRIVERS_LICENSE"]);
        $prepare->setString(9, $value["PEOPLE_BUSINESS_ID"]);
/*        $val = "N";
        if ($value["IS_ENABLED_YN"] == 1)
           $val = "Y";
        $prepare->setString(9, $val);
        */
        $prepare->setDate(10, UtlConvert::displayToDBDate($value["DATE_OF_BIRTH"]));
        $prepare->setInt(12, $value["BUSINESS_ID"]);

        if ($operation == RNTBase::UPDATE_ROW)
            $prepare->setString(11, $value["CHECKSUM"]);

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

    public function Delete($values)
    {
        $statement = "begin RNT_PEOPLE_PKG.DELETE_ROW(X_PEOPLE_ID => :var1, X_BUSINESS_ID => :var2, X_PEOPLE_BUSINESS_ID => :var3); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->set(1, $values["PEOPLE_ID"]);
        $prepare->set(2, $values["BUSINESS_ID"]);
        $prepare->set(3, $values["PEOPLE_BUSINESS_ID"]);
        $prepare->executeUpdate();
    }

    public function getIncludingBU($peopleID)
    {
//        $query = "select bu.BUSINESS_ID
//                  ,      bu.BUSINESS_NAME
//                  ,      decode(sbu.BUSINESS_ID, NULL, 'N', 'Y') as IS_INCLUDED
//                  from   RNT_BUSINESS_UNITS_V  bu
//                  left   outer join (select BUSINESS_ID from RNT_PEOPLE_BU where PEOPLE_ID = :var1) sbu
//                  on     (bu.BUSINESS_ID = sbu.BUSINESS_ID)
//                  where  bu.PARENT_BUSINESS_ID != 0
//                  order  by bu.BUSINESS_NAME";

        $query = "SELECT bu.business_id
                  ,      bu.business_name
                  ,      DECODE(sbu.business_id, null, 'N', 'Y') as is_included
                  ,      DECODE(tnt.business_id, null, 'N', 'Y') as is_tenant
                  ,      DECODE(ld.lead_id,      null, 'N', 'Y') as is_lead
                  FROM   rnt_business_units_v bu
                  LEFT   OUTER JOIN (SELECT * FROM rnt_people_bu WHERE people_id = :var1) sbu
                         ON         (bu.business_id = sbu.business_id)
                  LEFT   OUTER JOIN rnt_leads ld
                         ON         (sbu.people_business_id = ld.people_business_id)
                  LEFT   OUTER JOIN (SELECT business_id, count(*) as cnt
                                     FROM   rnt_tenant_v1
                                     WHERE  people_id = :var1
                                     GROUP  BY business_id) tnt
                         ON         (bu.business_id = tnt.business_id)
                  WHERE  bu.parent_business_id != 0
                  ORDER  BY bu.business_name";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $peopleID);
        $rs = $stmt->executeQuery();
        
        $r = array();
        while($rs->next()) {
            $r[] = $rs->getRow();
        }
        $rs->close();
        return $r;
    }


    public function findForIncluding($NameValue, $PhoneValue, $EmailValue, $SSN)
    {
        $whereCond = "";
        if ($NameValue) {
           $whereCond = " and LAST_NAME||' '||FIRST_NAME like :var1";
        }
        if ($PhoneValue) {
           $whereCond = " and (PHONE1 like :var1 or PHONE2 like :var1)";
        }
        if ($EmailValue) {
           $whereCond = " and EMAIL_ADDRESS = :var1";
        }
        if ($SSN) {
           $whereCond = " and SSN like :var1";
        }

        $query = "select PEOPLE_ID, LAST_NAME, FIRST_NAME, EMAIL_ADDRESS
                  from   RNT_PEOPLE
                  where  1 = 1
                    $whereCond
                  order by LAST_NAME, FIRST_NAME";
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
        if ($SSN) {
            $bind_value = $SSN;
        }

        if (! empty($bind_value)) {
            $stmt->setString(1, $bind_value);
        }
        $rs = $stmt->executeQuery();
        
        $r = array();
        while($rs->next()) {
            $c = $rs->getRow();
            $c["BUSINESS_UNITS"] = $this->getIncludingBU($c["PEOPLE_ID"]);
            $r[] = $c;
        }
        $rs->close();
        return $r;
    }


    function isExistsBU4People($business_id, $people_id)
    {
        $query = "select 'Y' as IS_INCLUDED
                  from   RNT_PEOPLE_LIST_V
                  where  BUSINESS_ID = :var1 
                  and    PEOPLE_ID   = :var2";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $business_id);
        $stmt->setInt(2, $people_id);
        $rs = $stmt->executeQuery();
        
        $r = array();
        while($rs->next())
            $r = $rs->getRow();
        $rs->close();
        return count($r) > 0;
    }

    public function insertPeopleBU($business_id, $people_id)
    {
        $statement = "begin :var1 := RNT_PEOPLE_PKG.INSERT_PEOPLE_BUSINESS_UNIT(X_PEOPLE_ID => :var2, X_BUSINESS_ID => :var3); end;";
        $prepare   = $this->connection->prepareStatement($statement);

        // blank value for initial
        $prepare->set(1, '23423423123123123');
        $prepare->set(2, $people_id);
        $prepare->set(3, $business_id);

        @$prepare->executeUpdate();

        return OCI8PreparedStatementVars::getVar($prepare, 1);
    }

    public function getBUCount($people_id)
    {
        $query = "select count(*) as CNT
                  from   RNT_PEOPLE_BU bu
                  where  PEOPLE_ID = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $people_id);
        $rs = $stmt->executeQuery();
        
        $r = array();
        while($rs->next()) {
            $r = $rs->getRow();
        }
        $rs->close();
        return $r["CNT"];
    }


    /**
     * Get "Tenancy Agreements" list for People
     *
     * @param number $people_id
     * @param number $business_id
     * @return array
     */
    public function getTenancyAgreements($people_id, $business_id)
    {
        $result = array();

        if (!is_null($people_id))
        {
            $query =
                "select p.business_id, p.property_id, ta.agreement_id, pu.unit_id,
                        t.people_id, t.tenant_id, p.address1, pu.unit_name,
                        ta.agreement_date, ta.end_date, a.amount_due, a.amount_paid
                 from   RNT_TENANCY_AGREEMENT   ta,
                        RNT_PROPERTY_UNITS   pu,
                        (select * from rnt_tenant
                         where  people_id = :var1 
                        ) t,
                        (select * from rnt_properties "
                ."      ) p,
                        (select xar.agreement_id,
                                xar.amount_due,
                                xpa.amount_paid
                         from   (select agreement_id,
                                        sum(AMOUNT) as amount_due
                                 from   RNT_ACCOUNTS_RECEIVABLE
                                 group  by agreement_id
                                )  xar,
                                (select ar.agreement_id,
                                        sum(nvl(pa.amount, 0)) as amount_paid
                                 from   rnt_accounts_receivable  ar,
                                        rnt_payment_allocations  pa
                                 where  pa.ar_id = ar.ar_id
                                 group  by ar.agreement_id
                                ) xpa
                         where  xpa.agreement_id = xar.agreement_id
                        ) a
                 where  p.property_id   = pu.property_id
                 and    pu.unit_id      = ta.unit_id
                 and    ta.agreement_id = t.agreement_id
                 and    t.agreement_id  = a.agreement_id
                 order  by ta.agreement_date desc";
            
            $stmt = $this->connection->prepareStatement($query);
            $stmt->setInt(1, $people_id);
            $rs = $stmt->executeQuery();
            
            while($rs->next()) {
                $result[] = $rs->getRow();
            }
            $rs->close();
        }

        return $result;
    }

}

?>