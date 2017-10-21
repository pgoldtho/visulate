<?
class RNTBase
{
    protected $connection;
    const UPDATE_ROW = 1;
    const INSERT_ROW = 2;

     public function __construct($connection){
         $this->connection = $connection;
     }

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
     
     function sql2array($sql, $bindVar){
     	
        $r = array();
		if ($bindVar)
		  {
		  $stmt = $this->connection->prepareStatement($sql);
          $stmt->setString(1, $bindVar);
		  $rs = $stmt->executeQuery();
		  }
		else
		  {	
          $rs =  $this->connection->executeQuery($sql);
		  }
        while($rs->next())
             $r[] = $rs->getRow();
        $rs->close();
        return $r;
     }
}
?>