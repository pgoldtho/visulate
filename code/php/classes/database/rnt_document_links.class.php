<?

  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";


  class RNTDocumentLinks extends RNTBase
  {

    public function __construct($connection){
         parent::__construct($connection);
    }

    public function getList($propertyID)
    {
        if (is_null($propertyID)) {
            return NULL;       
        }
        else{
            return $this->sql2array("select 
								   PROPERTY_LINK_ID, PROPERTY_ID, LINK_TITLE, 
								   LINK_URL, CREATION_DATE
								from RNT_PROPERTY_LINKS
								where PROPERTY_ID = :var1
								order by CREATION_DATE", $propertyID); 
								}
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
               $statement = "begin RNT_PROPERTY_LINKS_PKG.$proc(".
                            "X_PROPERTY_LINK_ID => :var1,";
       else if ($operation == RNTBase::INSERT_ROW)
         $statement = " begin :var1 := RNT_PROPERTY_LINKS_PKG.$proc(";

       $statement .= "X_PROPERTY_ID  => :var2,".
                     "X_LINK_TITLE   => :var3,".
                     "X_LINK_URL     => :var4";
                     

        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= ",X_CHECKSUM => :var5";

        $statement .= "); end;";

        $prepare = $this->connection->prepareStatement($statement);

        if ($operation == RNTBase::INSERT_ROW)
           // blank value for initial
           $prepare->set(1, '23423423123');
        else if ($operation == RNTBase::UPDATE_ROW)
           $prepare->setInt(1, $value["PROPERTY_LINK_ID"]);

        $prepare->set(2, $value["PROPERTY_ID"]);
        $prepare->set(3, $value["LINK_TITLE"]);
        $prepare->set(4, $value["LINK_URL"]);

        if ($operation == RNTBase::UPDATE_ROW)
            $prepare->setString(5, $value["CHECKSUM"]);

        @$prepare->executeUpdate();

        if ($operation == RNTBase::INSERT_ROW)
          return OCI8PreparedStatementVars::getVar($prepare, 1);
    }
/*
    public function Update(&$values)
    {
        $this->Operation($values, RNTBase::UPDATE_ROW);
    }
*/
    public function Insert(&$values)
    {
        return $this->Operation($values, RNTBase::INSERT_ROW);
    }

    public function Delete($id)
    {
        if ($id == null) {
            return;
        }
        $statement = "begin RNT_PROPERTY_LINKS_PKG.DELETE_ROW(X_PROPERTY_LINK_ID => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $id);
        @$prepare->executeUpdate();
    }

  }
?>