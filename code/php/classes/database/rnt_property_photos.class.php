<?

  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";


  class RNTPropertyPhotos extends RNTBase
  {

    public function __construct($connection){
         parent::__construct($connection);
    }

    public function getList($propertyID)
    {
        if (is_null($propertyID)) {
            return NULL;       
        }
        else {
            return $this->sql2array("select PHOTO_ID, PROPERTY_ID, PHOTO_TITLE, 
                                            PHOTO_FILENAME
                                     from   RNT_PROPERTY_PHOTOS
                                     where  PROPERTY_ID = :var1
                                     order  by PHOTO_ID", $propertyID); 
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
               $statement = "begin RNT_PROPERTY_PHOTOS_PKG.$proc(".
                            "X_PHOTO_ID => :var1,";
       else if ($operation == RNTBase::INSERT_ROW)
         $statement = " begin :var1 := RNT_PROPERTY_PHOTOS_PKG.$proc(";

       $statement .= "X_PROPERTY_ID  => :var2,".
                     "X_PHOTO_TITLE   => :var3,".
                     "X_PHOTO_FILENAME     => :var4";
                     

        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= ",X_CHECKSUM => :var5";

        $statement .= "); end;";

        $prepare = $this->connection->prepareStatement($statement);

        if ($operation == RNTBase::INSERT_ROW)
           // blank value for initial
           $prepare->set(1, '23423423123');
        else if ($operation == RNTBase::UPDATE_ROW)
           $prepare->setInt(1, $value["PHOTO_ID"]);

        $prepare->set(2, $value["PROPERTY_ID"]);
        $prepare->set(3, $value["PHOTO_TITLE"]);
        $prepare->set(4, $value["PHOTO_FILENAME"]);

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
        $statement = "begin RNT_PROPERTY_PHOTOS_PKG.DELETE_ROW(X_PHOTO_ID => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $id);
        @$prepare->executeUpdate();
    }

  }
?>