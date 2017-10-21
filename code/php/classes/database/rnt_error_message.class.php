<?
  require_once dirname(__FILE__)."/../LOV.class.php";
  require_once dirname(__FILE__)."/../UtlConvert.class.php";
  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";

class RNTErrorMessage extends RNTBase
{

    public function __construct($connection){
         parent::__construct($connection);
    }

    public function getList($filter)
    {
        $r = array();
        $condition = "";
        if ($filter != "") {
            $condition = "where CLASSIFIED_DESCRIPTION = :var1";
        }
        if ($filter == "no  category") {
            $condition = "where CLASSIFIED_DESCRIPTION is null";
        }
        
        $query = "select ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION,
                         LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN,
                         CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN,
                         CHECKSUM
                  from RNT_ERROR_DESCRIPTION_V
                  $condition
                  order by ERROR_CODE";
        
        $stmt = $this->connection->prepareStatement($query);
        if ($filter != "") {
            $stmt->setString(1, $filter);
        }
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $r[] = $rs->getRow();
        }
        $rs->close();
        return $r;
    }

    function getCategoryName($name)
    {
        if ($name == "no  category" || $name == "") {
            return "";
        }
        return $name;
    }

    public function getMessage($errorID)
    {
        $r = array();
        
        $query = "select ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION,
                         LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN,
                         DISPLAY_SHORT_DESCRIPTION_YN,
                         CLASSIFIED_DESCRIPTION, CHECKSUM
                  from   RNT_ERROR_DESCRIPTION_V
                  where ERROR_ID = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $errorID);
        $rs = $stmt->executeQuery();
        
        while($rs->next()) {
            $r = $rs->getRow();
        }
        $rs->close();
        return $r;
    }

    public function getCategoryList()
    {
        $r = array();
        $rs =  $this->connection->executeQuery("
                select distinct NVL(CLASSIFIED_DESCRIPTION, 'no  category') as value
                from RNT_ERROR_DESCRIPTION
                order by NVL(CLASSIFIED_DESCRIPTION, 'no  category')
        ");
        
        while($rs->next()) {
            $r[] = $rs->getRow();
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
                "begin RNT_ERROR_DESCRIPTION_PKG.$proc(X_ERROR_ID => :var1,";
       else if ($operation == RNTBase::INSERT_ROW)
         $statement = " begin :var1 := RNT_ERROR_DESCRIPTION_PKG.$proc(";

        $statement .=
                      "X_ERROR_CODE                => :var2,".
                      "X_SHORT_DESCRIPTION         => :var3,".
                      "X_LONG_DESCRIPTION          => :var4,".
                      "X_SHOW_LONG_DESCRIPTION_YN  => :var5,".
                      "X_CLASSIFIED_DESCRIPTION    => :var6,".
                      "X_DISPLAY_SHORT_DESCRIPTION_YN => :var7";

        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= " , X_CHECKSUM => :var8";

        $statement .= "); end;";
        $prepare = $this->connection->prepareStatement($statement);

        if ($operation == RNTBase::INSERT_ROW)
           // blank value for initial
           $prepare->set(1, '23423423123123123');
        else if ($operation == RNTBase::UPDATE_ROW)
           $prepare->setInt(1, $value["ERROR_ID"]);

        $prepare->setInt(2, $value["ERROR_CODE"]);
        $prepare->setString(3, $value["SHORT_DESCRIPTION"]);
        $prepare->setString(4, $value["LONG_DESCRIPTION"]);
        $prepare->setString(5,  ($value["SHOW_LONG_DESCRIPTION_YN"] ==  1)  ? "Y" : "N");
        $prepare->setString(6, $value["CLASSIFIED_DESCRIPTION"]);
        $prepare->setString(7,  ($value["DISPLAY_SHORT_DESCRIPTION_YN"] ==  1)  ? "Y" : "N");

        if ($operation == RNTBase::UPDATE_ROW)
            $prepare->setString(8, $value["CHECKSUM"]);

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
        if ($id == null) {
            return;
        }
        $statement = "begin RNT_ERROR_DESCRIPTION_PKG.DELETE_ROW(X_ERROR_ID => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $id);
        $prepare->executeUpdate();
    }

    public function getLongDescription($errorCode)
    {
	
        $r = array();
		$sql = "select LONG_DESCRIPTION
               from RNT_ERROR_DESCRIPTION_V
               where ERROR_CODE = :var1";
        $stmt = $this->connection->prepareStatement($sql);
        $stmt->setInt(1, $errorCode);
        $rs = $stmt->executeQuery();		
       
        while($rs->next()) {
            $r = $rs->getRow();
        }
        $rs->close();
        return @$r["LONG_DESCRIPTION"];
    }
}

?>