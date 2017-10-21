<?
  require_once dirname(__FILE__)."/../LOV.class.php";
  require_once dirname(__FILE__)."/../UtlConvert.class.php";
  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";

class RNTExpenseItems extends RNTBase
{

    public function __construct($connection){
         parent::__construct($connection);
    }

    public function getExpenseItems($expense_id, $supplier_id)
	   {
	    $r = array();
		$sql = "select
				   EXPENSE_ID,
				   SUPPLIER_ID,
				   ORDER_ROW,
				   ITEM_NAME,
				   ITEM_COST,
				   ESTIMATE,
				   ACTUAL,
				   round(ITEM_COST*ESTIMATE, 2) as ESTIMATE_COST,
				   round(ITEM_COST*ACTUAL, 2) as ACTUAL_COST,
				   EXPENSE_ITEM_ID,
				   ITEM_UNIT,
				   CHECKSUM
				from RNT_EXPENSE_ITEMS_V
				where SUPPLIER_ID = :var1
				and EXPENSE_ID = :var2
				order by ORDER_ROW";
		  $stmt = $this->connection->prepareStatement($sql);
          $stmt->setString(1, $supplier_id);
		  $stmt->setString(2, $expense_id);
		  $rs = $stmt->executeQuery();
		
		while($rs->next())
             $r[] = $rs->getRow();
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
                "begin RNT_EXPENSE_ITEMS_PKG.$proc(X_EXPENSE_ITEM_ID => :var1,";
       else if ($operation == RNTBase::INSERT_ROW)
         $statement = " begin :var1 := RNT_EXPENSE_ITEMS_PKG.$proc(";

        $statement .=
                  "X_SUPPLIER_ID => :var2, ".
                  "X_ITEM_NAME => :var3,".
                  "X_ITEM_COST => :var4,".
                  "X_ESTIMATE => :var5,".
                  "X_ACTUAL => :var6,".
                  "X_EXPENSE_ID => :var7,".
                  "X_ORDER_ROW => :var8,".
                  "X_ITEM_UNIT => :var9";


        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= " , X_CHECKSUM => :var10";

        $statement .= "); end;";
        $prepare = $this->connection->prepareStatement($statement);

        if ($operation == RNTBase::INSERT_ROW)
           // blank value for initial
           $prepare->set(1, '23423423123');
        else if ($operation == RNTBase::UPDATE_ROW)
           $prepare->setInt(1, $value["EXPENSE_ITEM_ID"]);

        $prepare->setInt(2, $value["SUPPLIER_ID"]);
        $prepare->setString(3, $value["ITEM_NAME"]);
        $prepare->set(4, UtlConvert::DisplayNumericToDB($value["ITEM_COST"]));
        $prepare->set(5, UtlConvert::DisplayNumericToDB($value["ESTIMATE"]));
        $prepare->set(6, UtlConvert::DisplayNumericToDB($value["ACTUAL"]));
        $prepare->set(7, $value["EXPENSE_ID"]);
        $prepare->set(8, $value["ORDER_ROW"]);
        $prepare->set(9, $value["ITEM_UNIT"]);

        if ($operation == RNTBase::UPDATE_ROW)
            $prepare->setString(10, $value["CHECKSUM"]);

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

    public function Updates(&$values)
    {
        if (!array_key_exists("ITEMS", $values))
          return;

        $recs = $values["ITEMS"];
        $result = 0;

        foreach($recs as $v)
        {
           if (!$v["EXPENSE_ITEM_ID"]){
              // then insert
              $this->Operation($v, RNTBase::INSERT_ROW);
              $result = $v['SUPPLIER_ID'];

           }
           else
              $this->Operation($v, RNTBase::UPDATE_ROW);
        }
        return $result;
    }

    public function Delete($id)
    {
        if ($id == null) {
            return;
        }
        $statement = "begin RNT_EXPENSE_ITEMS_PKG.DELETE_ROW(X_EXPENSE_ITEM_ID => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $id);
        @$prepare->executeUpdate();
    }

    public function UpdateItemsAcceptedFlag($expenseID, $supplierID, $new_value)
    {
        $is_params_ok = ! is_null($expenseID)
                      && ! is_null($supplierID)
                      && ! is_null($new_value);
        if (!$is_params_ok) {
            return;
        }
        
        $statement = "UPDATE rnt_expense_items
                      SET    accepted_yn = :var1
                      WHERE  expense_id  = :var2
                      AND    supplier_id = :var3";
        $prepare   = $this->connection->prepareStatement($statement);
        $prepare->setString(1, $new_value);
        $prepare->setInt(2, $expenseID);
        $prepare->setInt(3, $supplierID);
        $prepare->executeUpdate();
    }



}

?>