<?
  require_once dirname(__FILE__)."/../LOV.class.php";
  require_once dirname(__FILE__)."/../UtlConvert.class.php";
  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";

class RNTSection8 extends RNTBase
{

    public function __construct($connection){
         parent::__construct($connection);
    }

    public function defineSection8BU_ID($section8ID, $businessID)
    {
        $query = "select SECTION8_BUSINESS_ID
                  from   RNT_SECTION8_OFFICES_V
                  where  BUSINESS_ID = :var1
                  and    SECTION8_ID = :var2";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $businessID);
        $stmt->setInt(2, $section8ID);
        $rs = $stmt->executeQuery();
        
        $r = array();
        while($rs->next()) {
            $r = $rs->getRow();
        }
        $rs->close();
        return @$r["SECTION8_BUSINESS_ID"];

    }

    public function getList($businessID)
    {
        $r = array();
        
        if ($businessID == null) {
            return $r;
        }
        
        $query = "select SECTION8_ID, SECTION_NAME, BUSINESS_ID, SECTION8_BUSINESS_ID,
                         CHECKSUM
                  from   RNT_SECTION8_OFFICES_V
                  where  BUSINESS_ID = :var1
                  order  by SECTION_NAME";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $businessID);
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $r[] = $rs->getRow();
        }
        $rs->close();
        return $r;
    }

    public function getSection8($id)
    {
        $r = array();
        
        if ($id == null) {
            return $r;
        }
        
        $query = "select SECTION8_ID, SECTION_NAME, BUSINESS_ID, SECTION8_BUSINESS_ID, CHECKSUM
                  from   RNT_SECTION8_OFFICES_V
                  where  SECTION8_ID = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $id);
        $rs = $stmt->executeQuery();
        
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
                "begin RNT_SECTION8_OFFICES_PKG.$proc(X_SECTION8_ID => :var1,";
       else if ($operation == RNTBase::INSERT_ROW)
         $statement = " begin :var1 := RNT_SECTION8_OFFICES_PKG.$proc(";

        $statement .=
                      "X_SECTION_NAME      => :var2,".
                      "X_BUSINESS_ID     => :var3,".
                      "X_SECTION8_BUSINESS_ID => :var4";

        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= " , X_CHECKSUM => :var5";

        $statement .= "); end;";
        $prepare = $this->connection->prepareStatement($statement);

        if ($operation == RNTBase::INSERT_ROW)
           // blank value for initial
           $prepare->set(1, '23423423123123123');
        else if ($operation == RNTBase::UPDATE_ROW)
           $prepare->setInt(1, $value["SECTION8_ID"]);

        $prepare->setString(2, $value["SECTION_NAME"]);
        $prepare->set(3, $value["BUSINESS_ID"]);
        $prepare->set(4, $value["SECTION8_BUSINESS_ID"]);

        if ($operation == RNTBase::UPDATE_ROW)
            $prepare->setString(5, $value["CHECKSUM"]);

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
        $statement = "begin RNT_SECTION8_OFFICES_PKG.DELETE_ROW(X_SECTION8_ID => :var1, X_BUSINESS_ID => :var2, X_SECTION8_BUSINESS_ID => :var3); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $values["SECTION8_ID"]);
        $prepare->setInt(2, $values["BUSINESS_ID"]);
        $prepare->setInt(3, $values["SECTION8_BUSINESS_ID"]);
        @$prepare->executeUpdate();
    }

    public function getIncludingBU($sectionID)
    {
        $query = "select bu.BUSINESS_ID, bu.BUSINESS_NAME, decode(sbu.BUSINESS_ID, NULL, 'N', 'Y') as IS_INCLUDED
                  from   (select BUSINESS_ID from RNT_SECTION8_OFFICES_BU where SECTION8_ID = :var1) sbu,
                         RNT_BUSINESS_UNITS_V bu
                  where  bu.PARENT_BUSINESS_ID != 0
                  and    bu.BUSINESS_ID = sbu.BUSINESS_ID(+)
                  order  by BUSINESS_NAME";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $sectionID);
        $rs = $stmt->executeQuery();
        
        $r = array();
        while($rs->next()) {
            $r[] = $rs->getRow();
        }
        $rs->close();
        return $r;
    }

    public function findForIncluding($value)
    {
        $query = "select SECTION8_ID, SECTION_NAME
                  from   RNT_SECTION8_OFFICES
                  where  SECTION_NAME like :var1
                  order  by SECTION_NAME";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $value);
        $rs = $stmt->executeQuery();
        
        $r = array();
        while($rs->next())
        {
            $c = $rs->getRow();
            $c["BUSINESS_UNITS"] = $this->getIncludingBU($c["SECTION8_ID"]);
            $r[] = $c;
        }
        $rs->close();
        return $r;
    }


    function isExistsBU4Section8($business_id, $section8_id)
    {
        $query = "select 'Y' as IS_INCLUDED
                  from    RNT_SECTION8_OFFICES_V
                  where   BUSINESS_ID = :var1
                  and     SECTION8_ID = :var2";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $business_id);
        $stmt->setInt(2, $section8_id);
        $rs = $stmt->executeQuery();
        
        $r = array();
        while($rs->next()) {
            $r = $rs->getRow();
        }
        $rs->close();
        return count($r) > 0;
    }

    public function insertOfficesBU($business_id, $section8_id)
    {
        $statement =
                "begin :var1 := RNT_SECTION8_OFFICES_PKG.INSERT_SECTION8_BUSINESS_UNIT(X_SECTION8_ID => :var2,".
                        "X_BUSINESS_ID     => :var3);".
                "end;";

        $prepare = $this->connection->prepareStatement($statement);

        // blank value for initial
        $prepare->set(1, '23423423123123123');
        $prepare->set(2, $section8_id);
        $prepare->set(3, $business_id);

        @$prepare->executeUpdate();

        return OCI8PreparedStatementVars::getVar($prepare, 1);
    }

    public function getBUCount($section8_id)
    {
        $query = "select count(*) as CNT
                  from   RNT_SECTION8_OFFICES_BU bu
                  where  bu.SECTION8_ID = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $section8_id);
        $rs = $stmt->executeQuery();
        
        $r = array();
        while($rs->next()) {
            $r = $rs->getRow();
        }
        $rs->close();
        return $r["CNT"];
    }
}

?>