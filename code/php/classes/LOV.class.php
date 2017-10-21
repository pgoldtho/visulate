<?

class DBLOV
{
  private $connection;
  function __construct($connection)
  {
        $this->connection = $connection;
  }

  function arrayFromSQL($sqlText, $isRequired = true, $bindVar)
  {
    if ($bindVar)
		  {
		  $stmt = $this->connection->prepareStatement($sqlText);
          $stmt->setString(1, $bindVar);
		  $rs = $stmt->executeQuery();
		  }
	else
	  {
       $rs = $this->connection->executeQuery($sqlText);
	  }
     $return = array();
     if (!$isRequired)
        $return[""] = "";
     while($rs->next())
     {
       $r = $rs->getRow();
       $return[$r["CODE"]] = $r["VALUE"];
     }
     $rs->close();
     return $return;
  }

  function HTMLSelectArray($sqlQuery, $isRequired = true, $bindVar = null)
  {
      $a = $this->arrayFromSQL($sqlQuery, $isRequired, $bindVar);
      if (!$isRequired)
      {
        $b = array("" => "");
        foreach($a as $k=>$v)
           $b[$k] = $v;
        $a = $b;
      }
      return $a;
  }

  private function privFromLookup($type_code, $order_by, $isRequired = true)
  {
       $order_by = htmlentities($order_by, ENT_QUOTES);
        return $this->HTMLSelectArray(
         "select
               LOOKUP_CODE as CODE, LOOKUP_VALUE as VALUE
            from RNT_LOOKUP_VALUES_V
            where LOOKUP_TYPE_CODE = :var1
            order by $order_by
         ", $isRequired, $type_code);

  }

  function LOVFromLookup($type_code, $isRequired = true)
  {
      return $this->privFromLookup($type_code, "LOOKUP_VALUE", $isRequired);
  }

  function LOVFromLookupOrdered($type_code, $isRequired = true)
  {
      return $this->privFromLookup($type_code, "LOOKUP_VALUE_ID", $isRequired);
  }

}


?>
