<?

 class DatabaseError
 {
     protected $connection;
     protected $errorCode;

     public function __construct($connection, $errorCode = -1){
         $this->connection = $connection;
         $this->errorCode = -1;
         if ($errorCode != -1)
           $this->errorCode = $errorCode;
     } // ----

	 public function getSingleRow($sqlQuery, $bindVar)
     {
	    if ($bindVar)
		  {
		  $stmt = $this->connection->prepareStatement($sqlQuery);
          $stmt->setString(1, $bindVar);
		  $rs = $stmt->executeQuery();
		  }
		else
		  {
          $rs =  $this->connection->executeQuery($sqlQuery);
		  }
        $r = array();
        while($rs->next())
        {
             $r = $rs->getRow();
             break;
        }
        $rs->close();
        return $r;
     }

     function getLongDesciption($errorCode = -1)
     {
       if ($errorCode == -1)
         $errorCode = $this->errorCode;
       $r = $this->getSingleRow("select RNT_ERROR_DESCRIPTION_PKG.GET_LONG_DESCRIPTION(:var1) as XX 
	                             from DUAL", $errorCode*-1 );
       return $r["XX"];
     }

     function getShortDesciption($errorCode = -1)
     {
       if ($errorCode == -1)
         $errorCode = $this->errorCode;
       $r = $this->getSingleRow("select NVL(RNT_ERROR_DESCRIPTION_PKG.GET_SHORT_DESCRIPTION(:var1), '') as XX 
	                             from DUAL", $errorCode*-1);
       return $r["XX"];
     }
     /*
       Return TRUE if show long description is allowed, otherwise FALSE.
     */
     function isShowLong($errorCode = -1)
     {
       if ($errorCode == -1)
         $errorCode = $this->errorCode;

       $statement = "begin :var1 := RNT_ERROR_DESCRIPTION_PKG.IS_SHOW_LONG(:var2); end;";
       $prepare = $this->connection->prepareStatement($statement);
       $prepare->set(1, '1');
       $prepare->set(2, $errorCode*-1);
       $prepare->executeUpdate();
       $x = OCI8PreparedStatementVars::getVar($prepare, 1);
       return $x == "Y";
     }

     function isShowShort($errorCode = -1)
     {
       if ($errorCode == -1)
         $errorCode = $this->errorCode;

       $statement = "begin :var1 := RNT_ERROR_DESCRIPTION_PKG.IS_SHOW_SHORT(:var2); end;";
       $prepare = $this->connection->prepareStatement($statement);
       $prepare->set(1, '1');
       $prepare->set(2, $errorCode*-1);
       $prepare->executeUpdate();
       $x = OCI8PreparedStatementVars::getVar($prepare, 1);
       return $x == "Y";
     }


     function setNonDatabaseMessage($code, $message)
     {
           return array("code" => $code,
                         "short" => $message,
                         "islong" => "N");
     }

     function getArray($errorCode, $errorInfo = "")
     {
       if ($errorCode == -1){
              $x = array("code" => $errorCode,
                         "short" => $errorInfo,
                         "islong" => "N");
              return $x;
       }


       $x =  array("code" => $errorCode,
                   "short" => $this->getShortDesciption($errorCode),
                   "islong" => $this->isShowLong($errorCode) == "Y" ? "Y" : "N" );

       if (!$this->isShowShort($errorCode))
         $x["short"] = $errorInfo;
       else
       if (($x["short"] == "" || strlen($x["short"]) == 0)){
          $x["short"] = $errorInfo;
       }
       return $x;
    }

    function getErrorFromExceptionMessage($emsg)
    {
       return $this->getArray($emsg->getCode(), $emsg->getMessage());
    }

    function getMessageInfo($emsg){
       $info = $this->getErrorFromExceptionMessage($emsg);
       return $info["short"];
    }

    function getErrorFromException($sqlException)
    {
       $e = new SQLExceptionMessage($sqlException);
       return $this->getErrorFromExceptionMessage($e);
    }

 }
?>