<?

  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";


  class RNTBusinessUnit extends RNTBase
  {

    public function __construct($connection){
         parent::__construct($connection);
    }

    public function getTreeForUser()
    {
        $return = array();
        
        $rs =  $this->connection->executeQuery("
             select BUSINESS_ID
						 ,      BUSINESS_NAME
						 ,      PARENT_BUSINESS_ID
						 ,      level as LEVEL_BUSINESS
             from RNT_BUSINESS_UNITS_V
             start with BUSINESS_ID in (select BUSINESS_ID
                                               from RNT_USER_ASSIGNMENTS_V
                                               where USER_ID = RNT_USERS_PKG.GET_USER()
                                               and ROLE_CODE = RNT_USERS_PKG.GET_ROLE()
                                              )
              connect by prior BUSINESS_ID = PARENT_BUSINESS_ID
              order siblings by BUSINESS_NAME");
        
        while($rs->next()) {
            $r = $rs->getRow();
            $return[] = $r;
        }
        $rs->close();
        return $return;
    }

    public function getTreeForAdmin()
    {
        $return = array();
        $rs =  $this->connection->executeQuery("
             select BUSINESS_ID
						 ,      BUSINESS_NAME
						 ,      PARENT_BUSINESS_ID
						 ,      level as LEVEL_BUSINESS
             from RNT_BUSINESS_UNITS_V
             start with BUSINESS_ID = 0
              connect by prior BUSINESS_ID = PARENT_BUSINESS_ID
              order siblings by BUSINESS_NAME");
        
        while($rs->next()) {
            $r = $rs->getRow();
            $return[] = $r;
        }
        $rs->close();
        return $return;
    }

    public function getListForLOV()
    {
         $result = array();
         $rs =  $this->connection->executeQuery("
             select  BUSINESS_ID, BUSINESS_NAME, PARENT_BUSINESS_ID, level as LEVEL_BUSINESS
             from    RNT_BUSINESS_UNITS_V
             start   with PARENT_BUSINESS_ID in (select BUSINESS_ID
                                                 from   RNT_USER_ASSIGNMENTS_V
                                                 where  USER_ID   = RNT_USERS_PKG.GET_USER()
                                                 and    ROLE_CODE = RNT_USERS_PKG.GET_ROLE()
                                                )
                     or   BUSINESS_ID in (select BUSINESS_ID
                                          from   RNT_USER_ASSIGNMENTS_V
                                          where  USER_ID   = RNT_USERS_PKG.GET_USER()
                                          and    ROLE_CODE = RNT_USERS_PKG.GET_ROLE()
                                          and    RNT_USERS_PKG.GET_ROLE() in ('OWNER',
                                                                              'MANAGER',
                                                                              'BOOKKEEPING',
                                                                              'ADVERTISE',
                                                                              'BUYER',
                                                                              'PUBLIC',
                                                                              'BUSINESS_OWNER')
                                         )
             connect by prior BUSINESS_ID = PARENT_BUSINESS_ID
             order   siblings by BUSINESS_NAME");
			 
         while($rs->next()) {
             $r = $rs->getRow();
             $result[$r["BUSINESS_ID"]] = str_pad("", ($r["LEVEL_BUSINESS"] - 1)*12, "&nbsp;").$r["BUSINESS_NAME"];
         }
         $rs->close();
         return $result;
    }

    public function getBusinessUnit($id)
    {
        if ($id == NULL) {
            $id = 0;
        }
        
        return $this->getSingleRow(
             "select BUSINESS_ID, BUSINESS_NAME, PARENT_BUSINESS_ID, CHECKSUM
              from RNT_BUSINESS_UNITS_V
              where BUSINESS_ID = :var1", $id);
    }

    public function isBusinessUnits()
    {
        $r = $this->getListForLOV();
        return count($r) > 0;
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
            $statement = "begin RNT_BUSINESS_UNITS_PKG.$proc(".
                            "X_BUSINESS_ID => :var1,";
        else if ($operation == RNTBase::INSERT_ROW)
            $statement = " begin :var1 := RNT_BUSINESS_UNITS_PKG.$proc(";
        
        $statement .= "X_BUSINESS_NAME      => :var2,".
                      "X_PARENT_BUSINESS_ID => :var3";

        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= ",X_CHECKSUM => :var4";

        $statement .= "); end;";

        $prepare = $this->connection->prepareStatement($statement);

        if ($operation == RNTBase::INSERT_ROW)
           // blank value for initial
           $prepare->set(1, '23423423123');
        else if ($operation == RNTBase::UPDATE_ROW)
           $prepare->setInt(1, $value["BUSINESS_ID"]);

        $prepare->setString(2, $value["BUSINESS_NAME"]);
        $prepare->setInt(3, $value["PARENT_BUSINESS_ID"]);

        if ($operation == RNTBase::UPDATE_ROW)
            $prepare->setString(4, $value["CHECKSUM"]);

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
        
        $statement = "begin RNT_BUSINESS_UNITS_PKG.DELETE_ROW(X_BUSINESS_ID => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt(1, $id);
        @$prepare->executeUpdate();
    }

    public function getBusinessUnitsFullLOV($role_id)
    {
        $return = array();
        $rs =  $this->connection->executeQuery("
            select BUSINESS_ID, BUSINESS_NAME, PARENT_BUSINESS_ID, level as LEVEL_BUSINESS
            from RNT_BUSINESS_UNITS
            start with BUSINESS_ID = 0
            connect by prior BUSINESS_ID = PARENT_BUSINESS_ID
            order siblings by BUSINESS_NAME");
        $prev_name = "";
        while($rs->next()) {
           $r = $rs->getRow();
           if (($role_id == "ADMIN")&& $r["BUSINESS_ID"] != 0) continue;
           if (($role_id == "MANAGER_OWNER" 
					   || $role_id == "BUSINESS_OWNER")&& $r["LEVEL_BUSINESS"] != 2) continue;
           if (($role_id == "OWNER" 
					   || $role_id == "MANAGER" 
					   || $role_id == "ADVERTISE"
					   || $role_id == "BOOKKEEPING")&& $r["LEVEL_BUSINESS"] != 3)
           {
               if ($r["LEVEL_BUSINESS"] == 2)
                 $prev_name = $r["BUSINESS_NAME"]." ]-> ";
               continue;
           }
           /*
           $name = $r["BUSINESS_NAME"];
           if ($role_id == "OWNER")
              $name = str_pad("", ($r["LEVEL_BUSINESS"] - 2)*24, "&nbsp;", STR_PAD_LEFT).$name;
           */
           $return[$r["BUSINESS_ID"]] = $prev_name.$r["BUSINESS_NAME"];
        }
        $rs->close();
        return $return;
     }

     function getBusinessUnits()
     {
         $result = array();
         $rs =  $this->connection->executeQuery("
                select BUSINESS_ID, BUSINESS_NAME
                from RNT_BUSINESS_UNITS_V b
                where exists (select 1
                              from RNT_PROPERTIES
                              where BUSINESS_ID = b.BUSINESS_ID)
                order by BUSINESS_NAME
                ");
         while($rs->next()) {
             $result[] = $rs->getRow();
         }
         $rs->close();
         return $result;
     }
     
     function getAllBusinessUnits()
     {
         $result = array();
         $rs =  $this->connection->executeQuery("
                select BUSINESS_ID, BUSINESS_NAME
                from RNT_BUSINESS_UNITS_V b
                where PARENT_BUSINESS_ID != 0
                order by BUSINESS_NAME
                ");
         while($rs->next()) {
             $result[] = $rs->getRow();
         }
         $rs->close();
         return $result;
     }

    public function getBusinessUnitsList()
    {
       $lov = new DBLov($this->connection);
       return $lov->HTMLSelectArray("
            select BUSINESS_ID as CODE, BUSINESS_NAME as VALUE
            from RNT_BUSINESS_UNITS_V
            where PARENT_BUSINESS_ID != 0
            order by BUSINESS_NAME
       ");
    }
         
     function getBusinessUnits2()
     {
         $result = array();
         $rs =  $this->connection->executeQuery("
                select BUSINESS_ID, BUSINESS_NAME
                from RNT_BUSINESS_UNITS_V b
                where PARENT_BUSINESS_ID = 0
                order by BUSINESS_NAME
                ");
         while($rs->next()) {
             $result[] = $rs->getRow();
         }
         $rs->close();
         return $result;
     }

     function getBusinessUnitsLevel2()
     {
         $result = array();
         $rs =  $this->connection->executeQuery("
                select BUSINESS_ID, BUSINESS_NAME
                from RNT_BUSINESS_UNITS_V b
                where PARENT_BUSINESS_ID != 0
                order by BUSINESS_NAME
                ");
         while($rs->next()) {
             $result[] = $rs->getRow();
         }
         $rs->close();
         return $result;
     }

     
     function getBULevel2List()
     {
         $result = array('Select a Business Unit');
         $rs =  $this->connection->executeQuery("
                select BUSINESS_ID, BUSINESS_NAME
                from RNT_BUSINESS_UNITS_V b
                where PARENT_BUSINESS_ID != 0
                order by BUSINESS_NAME
                ");

//         $result['999999'] = ['Select a Business Unit'];
         while($rs->next()) {
             $r = $rs->getRow();
             $result[$r["BUSINESS_ID"]] = $r["BUSINESS_NAME"];
         }
         $rs->close();
         return $result;
     }

     function getBusinessUnitByRole($roleCode/*, $businessID*/)
     {
         $result = array();
         
         $query = "select BUSINESS_ID, BUSINESS_NAME
                   from   RNT_BUSINESS_UNITS_V
                   where  (
                           (PARENT_BUSINESS_ID = 0  and :var1 in ('MANAGER_OWNER', 'BUSINESS_OWNER'))
                           or
                           (PARENT_BUSINESS_ID != 0 and :var1 in ('MANAGER',
                                                                  'OWNER',
                                                                  'ADVERTISE',
                                                                  'BOOKKEEPING',
                                                                  'BUYER'))
                          )";
         $stmt = $this->connection->prepareStatement($query);
         $stmt->setString(1, $roleCode);
         $rs = $stmt->executeQuery();
         
         while($rs->next()) {
             $result[] = $rs->getRow();
         }
         $rs->close();
         return $result;
     }
     
     function isExistsProperties($businessID)
     {
         $r = $this->getSingleRow("select 1 as X from DUAL
                                   where  exists(select 1 from RNT_PROPERTIES
                                                 where BUSINESS_ID = :var1)", $businessID);
         return @$r["X"] == 1;      	
     }

  }
?>