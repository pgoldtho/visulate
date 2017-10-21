<?

  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/../LOV.class.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";


  class RNTUser extends RNTBase
  {

    public function __construct($connection){
         parent::__construct($connection);
    }

    // return user id or -1 if user and password not valid
    public function loginUser($login, $userPassword)
    {
         $statement = "begin :var1 := RNT_USERS_PKG.LOGIN(X_LOGIN => :var2, X_PASSWORD => :var3); end;";
         $prepare = $this->connection->prepareStatement($statement);
         $prepare->set(1, "12345678901234567890");
         $prepare->setString(2, $login);
         $prepare->setString(3, $userPassword);
         $prepare->executeUpdate();
         $userid = OCI8PreparedStatementVars::getVar($prepare, 1);
         return $userid;
    }

    public function changePassword($userid, $oldPassword, $newPassword)
    {
         $statement = "begin :var1 := RNT_USERS_PKG.CHANGE_PASSWORD(X_USER_ID => :var2, X_NEW_PASSWORD => :var3, X_OLD_PASSWORD => :var4); end;";
         $prepare = $this->connection->prepareStatement($statement);
         $prepare->set(1, "12345678901234567890");
         $prepare->setInt(2, $userid);
         $prepare->setString(3, $newPassword);
         $prepare->setString(4, $oldPassword);
         @$prepare->executeUpdate();
         $success = OCI8PreparedStatementVars::getVar($prepare, 1);
         return ($success == 'Y');
    }

    function set_database_role($db_role)
    {
        if ($db_role == NULL|| $db_role == 'PUBLIC') {
            return;
        }
        $statement = "begin RNT_USERS_PKG.SET_ROLE(X_ROLE_CODE => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->set(1, $db_role);
        $prepare->executeUpdate();
    }

    function set_database_user($db_user_id, $db_role)
    {
         $statement = "begin RNT_USERS_PKG.SET_USER(X_USER_ID => :var1); end;";
         $prepare = $this->connection->prepareStatement($statement);
         $prepare->set(1, $db_user_id);
         $prepare->executeUpdate();
         $this->set_database_role($db_role);
    }

    function getAssignmentCount()
    {
        $r = $this->getSingleRow("select count(*) as CNT from RNT_USER_ASSIGNMENTS_V 
	                          where USER_ID = RNT_USERS_PKG.GET_USER()");
        return $r["CNT"];
    }

    function get_roles()
    {
        $rs =  $this->connection->executeQuery(
                      "select ROLE_CODE
                       from RNT_USER_ASSIGNMENTS_V
                       where USER_ID = RNT_USERS_PKG.GET_USER()
                       group by ROLE_CODE");
        $r = array();
        while($rs->next()) {
            $x = $rs->getRow();
            $r[$x["ROLE_CODE"]] = "yes";
        }
        $rs->close();
        return $r;
    }

    function get_role_name($id)
    {
        if (!$id) {
            return "";
        }
        
        $query = "select ROLE_NAME from RNT_USER_ROLES where ROLE_ID = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $id);
        $rs = $stmt->executeQuery();
        
        $r = "";
        if($rs->next()) {
            $x = $rs->getRow();
            $r = $x["ROLE_NAME"];
        }
        $rs->close();
        return $r;
    }

    function get_role_names()
    {
        $rs =  $this->connection->executeQuery(
                      "select ROLE_CODE, ROLE_NAME
                       from RNT_USER_ASSIGNMENTS_V
                       where USER_ID = RNT_USERS_PKG.GET_USER()
                       group by ROLE_CODE, ROLE_NAME
                       order by ROLE_CODE");
        $r = array();
        while($rs->next()) {
            $x = $rs->getRow();
            $r[$x["ROLE_CODE"]] = $x["ROLE_NAME"];
        }
        $rs->close();
        return $r;
    }

    function getUserList()
    {
        $rs =  $this->connection->executeQuery(
                      "select USER_ID, USER_LOGIN, USER_NAME, IS_ACTIVE_YN,
                              USER_LASTNAME, PRIMARY_PHONE, SECONDARY_PHONE, IS_SUBSCRIBED_YN,
                              CHECKSUM
                       from RNT_USERS_V
                       order by USER_NAME");
        $r = array();
        while($rs->next()) {
            $r[] = $rs->getRow();
        }
        $rs->close();
        return $r;
    }

    public function changeActive($userID)
    {
        if ($userID == NULL) {
            return;
        }
        $statement = "begin RNT_USERS_PKG.change_active_flag(X_USER_ID => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->set(1, $userID);
        @$prepare->executeUpdate();
    }


    public function setPassword($userID, $pass)
    {
        if ($userID == NULL) {
            return;
        }
        $statement = "begin RNT_USERS_PKG.SET_PASSWORD(X_USER_ID => :var1, X_NEW_PASSWORD => :var2); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->set(1, $userID);
        $prepare->set(2, $pass);
        @$prepare->executeUpdate();
    }

    function getRandomPassword()
    {
        $password = "";
        for($i=0; $i < 8; $i++)
        {
            switch (mt_rand(0, 5)){
                case 3 : $password .= chr(mt_rand(ord("0"), ord("9"))); break;
                case 0 :
                case 1 :
                case 4 :
                case 5 : $password .= chr(mt_rand(ord("a"), ord("z"))); break;
                case 2 : $password .= chr(mt_rand(ord("A"), ord("Z"))); break;
            }
        }
        return $password;
    }

    function getUser($id)
    {
        if ($id == NULL) {
            return array();
        }
        
        $query = "select USER_ID, USER_LOGIN, USER_NAME, IS_ACTIVE_YN,
                         USER_LASTNAME, PRIMARY_PHONE, SECONDARY_PHONE,
                         IS_SUBSCRIBED_YN, CHECKSUM
                  from   RNT_USERS_V
                  where  USER_ID = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $id);
        $rs = $stmt->executeQuery();
        
        $r = array();
        if($rs->next()) {
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
               $statement = "begin RNT_USERS_PKG.$proc(X_USER_ID => :var1,";
       else if ($operation == RNTBase::INSERT_ROW)
         $statement = " begin :var1 := RNT_USERS_PKG.$proc(";

       $statement .= "X_USER_LOGIN => :var2,".
                     "X_USER_NAME => :var3,".
                     "X_IS_ACTIVE_YN => :var4,".
                     "X_USER_LASTNAME => :var5,".
                     "X_PRIMARY_PHONE => :var6,".
                     "X_SECONDARY_PHONE => :var7,".
                     "X_IS_SUBSCRIBED_YN => :var8";

        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= ",X_CHECKSUM => :var9";
        else
             $statement .= ", X_USER_PASSWORD => :var9";

        $statement .= "); end;";

        $prepare = $this->connection->prepareStatement($statement);

        if ($operation == RNTBase::INSERT_ROW)
           // blank value for initial
           $prepare->set(1, '23423423123');
        else if ($operation == RNTBase::UPDATE_ROW)
           $prepare->setInt(1, $value["USER_ID"]);

        $prepare->setString(2, $value["USER_LOGIN"]);
        $prepare->setString(3, $value["USER_NAME"]);
        // checkbox
        $prepare->setString(4, ($value["IS_ACTIVE_YN"] ==  1)  ? "Y" : "N");

        $prepare->setString(5, $value["USER_LASTNAME"]);
        $prepare->setString(6, $value["PRIMARY_PHONE"]);
        $prepare->setString(7, $value["SECONDARY_PHONE"]);
        $prepare->setString(8, (@$value["IS_SUBSCRIBED_YN"] == 1) ? "Y" : "N");

        if ($operation == RNTBase::UPDATE_ROW)
            $prepare->setString(9, $value["CHECKSUM"]);
        else
            $prepare->setString(9, $this->getRandomPassword());

        $prepare->executeUpdate();

        if ($operation == RNTBase::INSERT_ROW)
          return OCI8PreparedStatementVars::getVar($prepare, 1);
    }

    public function Update(&$values)
    {
        $this->Operation($values, RNTBase::UPDATE_ROW);
        if (trim(@$values["NEW_PASSWORD"]) != "")
           $this->setPassword($values["USER_ID"], User:: getWrappedPassword($values["NEW_PASSWORD"]));

    }

    public function Insert(&$values)
    {
        return $this->Operation($values, RNTBase::INSERT_ROW);
    }

    public function getUserAssignmentsList()
    {
        $rs =  $this->connection->executeQuery(
                      "select USER_ID, USER_LOGIN, USER_NAME, USER_LASTNAME, IS_SUBSCRIBED_YN,
                              IS_ACTIVE_YN, ROLE_CODE, ROLE_NAME,
                              ROLE_ID, USER_ASSIGN_ID, BUSINESS_ID,
                              BUSINESS_NAME, PARENT_BUSINESS_ID,
                              CHECKSUM
                       from RNT_USER_ASSIGNMENTS_V
                       order by USER_NAME, BUSINESS_NAME, ROLE_NAME");
        $r = array();
        while($rs->next()) {
            $r[] = $rs->getRow();
        }
        $rs->close();
        return $r;
   }

   public function isExistsBU2()
   {
       $rs =  $this->connection->executeQuery(
                     "select BUSINESS_ID
                      from RNT_BUSINESS_UNITS_V
                      where PARENT_BUSINESS_ID != 0");
       $r = array();
       while($rs->next()) {
          $r[] = $rs->getRow();
       }
       $rs->close();
	   
       return count($r) > 0;
   }

   public function getUserListLOV()
   {
        $lov = new DBLOV($this->connection);
        return $lov->arrayFromSQL("select USER_ID as CODE, USER_LOGIN||' - '||USER_LASTNAME||' '||USER_NAME as VALUE
                                   from RNT_USERS_V
                                   order by USER_LOGIN");
   }

   public function getRolesLOV()
   {
        $lov = new DBLOV($this->connection);
        return $lov->arrayFromSQL("select ROLE_ID as CODE, ROLE_NAME as VALUE
                                   from RNT_USER_ROLES
                                   order by ROLE_NAME");
   }

   public function getRoleCode($id)
   {
       if ($id == null) {
           return "";
       }
       
       $query = "select ROLE_CODE from RNT_USER_ROLES where ROLE_ID = :var1";
       $stmt = $this->connection->prepareStatement($query);
       $stmt->setInt(1, $id);
       $rs = $stmt->executeQuery();
       
       $r1 = "";
       if($rs->next()) {
           $r = $rs->getRow();
           $r1 = $r["ROLE_CODE"];
       }
       $rs->close();
       return $r1;
   }

   public function addAssignment($values)
   {
       $statement = " begin :var1 := RNT_USER_ASSIGNMENTS_PKG.INSERT_ROW(".
                    "X_USER_ID => :var2,".
                    "X_ROLE_ID => :var3,".
                    "X_BUSINESS_ID => :var4); end;";

        $prepare = $this->connection->prepareStatement($statement);

        // blank value for initial
        $prepare->set(1, '23423423123');
        $prepare->setInt(2, $values["USER_ID"]);
        $prepare->setInt(3, $values["ROLE_ID"]);
        $prepare->setInt(4, $values["BUSINESS_ID"]);
        @$prepare->executeUpdate();
        return OCI8PreparedStatementVars::getVar($prepare, 1);
   }

   public function deleteAssignment($id)
   {
       if ($id == NULL) {
           return;
       }
       $statement = " begin RNT_USER_ASSIGNMENTS_PKG.DELETE_ROW(".
                    "X_USER_ASSIGN_ID => :var1); end;";
       $prepare = $this->connection->prepareStatement($statement);
       // blank value for initial
       $prepare->setInt(1, $id);
       @$prepare->executeUpdate();
   }

   // User assignment list for Partners Page
   public function getUserAssignmentList($businessID)
   {
       $query = "select distinct USER_ID, USER_LASTNAME||' '||USER_NAME as USER_FULLNAME
                 from   RNT_USER_ASSIGNMENTS_V
                 where  (BUSINESS_ID = :var1 or PARENT_BUSINESS_ID = :var1)
                 order  by USER_LASTNAME||' '||USER_NAME";
       // and USER_ID != RNT_USERS_PKG.GET_USER()
       $stmt = $this->connection->prepareStatement($query);
       $stmt->setInt(1, $businessID);
       $rs = $stmt->executeQuery();
       
       $r = array();
       while($rs->next()) {
           $r[] = $rs->getRow();
       }
       $rs->close();
       return $r;
   }


   public function getOwerManagerRoles()
   {
       $rs =  $this->connection->executeQuery(
                     "select ROLE_ID, ROLE_NAME, ROLE_CODE
                      from RNT_USER_ROLES
                      where ROLE_CODE not in ('ADMIN', 'BUSINESS_OWNER', 'MANAGER_OWNER')
                      order by 1
                     ");
       $r = array();
       while($rs->next()) {
           $r[] = $rs->getRow();
       }
       $rs->close();
       return $r;
   }

   public function getRolesForLevel1()
   {
       $rs =  $this->connection->executeQuery(
                     "select ROLE_ID, ROLE_NAME, ROLE_CODE
                      from RNT_USER_ROLES
                      where ROLE_CODE not in ('ADMIN')
                      order by 1
                     ");
       $r = array();
       while($rs->next()) {
           $r[] = $rs->getRow();
       }
       $rs->close();
       return $r;
   }

   public function getUserAssignments($userID)
   {
       $query = "select ROLE_CODE, ROLE_NAME,
                        ROLE_ID, USER_ASSIGN_ID, BUSINESS_ID,
                        BUSINESS_NAME
                 from   RNT_USER_ASSIGNMENTS_V
                 where  USER_ID = :var1
                 order  by BUSINESS_NAME, ROLE_NAME";
       $stmt = $this->connection->prepareStatement($query);
       $stmt->setInt(1, $userID);
       $rs = $stmt->executeQuery();
       
       $r = array();
       while($rs->next()) {
           $r[] = $rs->getRow();
       }
       $rs->close();
       return $r;
   }

    public function getUserAssignmentsForBusinessOwner($userID)
    {
        $query = "select ROLE_CODE, ROLE_NAME,
                              ROLE_ID, USER_ASSIGN_ID, BUSINESS_ID,
                              BUSINESS_NAME
                  from   RNT_USER_ASSIGNMENTS_V
                  where  USER_ID = :var1
                  and    ROLE_CODE not in ('ADMIN')
                  and    BUSINESS_ID in (select BUSINESS_ID from  RNT_BUSINESS_UNITS_V)
                  order  by BUSINESS_NAME, ROLE_NAME";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $userID);
        $rs = $stmt->executeQuery();
        
        $r = array();
        while($rs->next()) {
            $r[] = $rs->getRow();
        }
        $rs->close();
        return $r;
   }

   public function sendEmailAndActivateAccount($userID){
       $statement = " begin RNT_USER_MAIL_PKG.EMAIL_ENABLED_ACCOUNT(X_USER_ID => :var1); end;";

        $prepare = $this->connection->prepareStatement($statement);

        // blank value for initial
        $prepare->set(1, $userID);
        @$prepare->executeUpdate();
   }

   public function activateAccountGetPasswd($userID)
    {
     $statement = "begin update RNT_USERS set IS_ACTIVE_YN = 'Y' where USER_ID = :var1; end;";
     $prepare = $this->connection->prepareStatement($statement);
     $prepare->set(1, $userID);
     @$prepare->executeUpdate();
/*
     $query =  "select  RNT_OBFURCATION_PASSWORD_PKG.DECRYPT(USER_PASSWORD) passwd
                from RNT_USERS
                where USER_ID = :var1";

     $stmt = $this->connection->prepareStatement($query);
     $stmt->setInt(1, $userID);
     $rs = $stmt->executeQuery();
     $r = array();
        while($rs->next()) {
            $r[] = $rs->getRow();
        }
     $rs->close();
     return $r;
*/
            $x = $this->getSingleRow(
             "select  RNT_OBFURCATION_PASSWORD_PKG.DECRYPT(USER_PASSWORD) passwd
                from RNT_USERS
                where USER_ID = :var1", $userID);
       return $x;
   }

   public function disableAccount($userID)
    {
     $statement = "begin update RNT_USERS set IS_ACTIVE_YN = 'N' where USER_ID = :var1; end;";
     $prepare = $this->connection->prepareStatement($statement);
     $prepare->set(1, $userID);
     @$prepare->executeUpdate();
    }

   public function encryptPassword($pass)
   {
        $statement = " begin var1 := RNT_USERS_PKG.ENCRIPT_PASSWORD(INPUT_STRING => :var2); end;";

        $prepare = $this->connection->prepareStatement($statement);

        // blank value for initial
        $prepare->set(2, $pass);

        // blank value for initial
        $prepare->set(1, '1234567890123456789012345678901234567890123456789012345678901234567890');
        @$prepare->executeUpdate();
        return OCI8PreparedStatementVars::getVar($prepare, 1);
   }

   public function recover_password($login){
        $statement = " begin RNT_USERS_PKG.RECOVER_PASSWORD(X_USER_LOGIN => :var1); end;";

        $prepare = $this->connection->prepareStatement($statement);

        // blank value for initial
        $prepare->set(1, $login);
        @$prepare->executeUpdate();
   }

   public function verifyBUAccess($businessID)
   {
       if ($businessID == NULL) {
           return FALSE;
       }
       $x = $this->getSingleRow(
             "select BUSINESS_ID
              from RNT_BUSINESS_UNITS_V
              where BUSINESS_ID = :var1", $businessID);
       return count($x) > 0;
   }

   public function verifyPropertyAccess($propertyID)
   {
       if ($propertyID == NULL) {
           return FALSE;
       }
       $x = $this->getSingleRow(
             "select PROPERTY_ID
              from RNT_BUSINESS_UNITS_V bu,
                   RNT_PROPERTIES p
              where bu.BUSINESS_ID = p.BUSINESS_ID
                and p.PROPERTY_ID = :var1",  $propertyID);
      return count($x) > 0;
    }

   function getBusinessAssigments($user_id)
   {
       $query = "select ROLE_ID, ROLE_NAME, BUSINESS_ID, BUSINESS_NAME
                 from   RNT_USER_ASSIGNMENTS_V
                 where  USER_ID = :var1
                 and    BUSINESS_ID in (select BUSINESS_ID from RNT_BUSINESS_UNITS_V)
                 order  by ROLE_NAME, BUSINESS_NAME";
       $stmt = $this->connection->prepareStatement($query);
       $stmt->setInt(1, $user_id);
       $rs = $stmt->executeQuery();
       
       $r = array();
       $last_role_id = -1;
       $c = array("ROLE_NAME"=>"", "BUSINESS_NAMES"=>"");
       $x = "";
       $f = "";
       while($rs->next()) {
           $x = $rs->getRow();
           if (@$x["ROLE_ID"] != $last_role_id) {
               if ($last_role_id != -1) {
                   $r[] = $c;
               }
               $last_role_id = $x["ROLE_ID"];
               $c = array("ROLE_NAME"=>$x["ROLE_NAME"], "BUSINESS_NAMES"=>"");
               $f = "";
           }
           $c["BUSINESS_NAMES"] .= $f.$x["BUSINESS_NAME"];
           $f = ", ";
       }
       if ($x) {
          if (@$x["ROLE_ID"] != $last_role_id) {
              if ($last_role_id != -1) {
                  $r[] = $c;
              }
          }
       }
       $rs->close();
       
       return $r;
   }

   function findForIncluding($e_mail)
   {
       $query = "select USER_ID, USER_LOGIN as USER_EMAIL, USER_NAME||' '||USER_LASTNAME as USER_NAME
                 from   RNT_USERS
                 where  UPPER(USER_LOGIN) = UPPER(:var1)
                 order  by USER_NAME||' '||USER_LASTNAME";
       $stmt = $this->connection->prepareStatement($query);
       $stmt->setString(1, $e_mail);
       $rs = $stmt->executeQuery();
       
       $r = array();
       while($rs->next()) {
           $x = $rs->getRow();
           $x["BUSINESS_UNITS"] = $this->getBusinessAssigments($x["USER_ID"]);
           $r[] = $x;
       }
       $rs->close();
       return $r;
   }

   function isExistsUser($login)
   {
       $query = "select USER_ID from RNT_USERS 
                 where  UPPER(USER_LOGIN) = UPPER(:var1)";
       $stmt = $this->connection->prepareStatement($query);
       $stmt->setString(1, $login);
       $rs = $stmt->executeQuery();
       
       $r = array();
       while($rs->next()) {
           $x = $rs->getRow();
           $r[] = $x;
       }
       $rs->close();
       return count($r) > 0;
   }

   function registerAccount($userNameEmail, $lastName, $firstName, $inviteUserID, $telephone)
   {
       $statement = "begin :var1 := RNT_USERS_PKG.REGISTER_ACCOUNT(X_USER_LOGIN_EMAIL => :var2,".
                                                            "X_USER_LAST_NAME => :var3,".
                                                            "X_USER_NAME      => :var4,".
                                                            "X_USER_PASSWORD  => :var5,".
                                                            "X_INVITE_USER_ID => :var6,".
                                                            "X_TELEPHONE       => :var7); end;";

       $prepare = $this->connection->prepareStatement($statement);

       $prepare->set(2, $userNameEmail);
       $prepare->set(3, $lastName);
       $prepare->set(4, $firstName);
       $prepare->set(5, $this->getRandomPassword());
       $prepare->set(6, $inviteUserID);
       $prepare->set(7, $telephone);
      
        // blank value for initial
       $prepare->set(1, str_repeat('x', 100));
       @$prepare->executeUpdate();
       return OCI8PreparedStatementVars::getVar($prepare, 1);
   }

   function sendMailAccount($userRegistryID){
        $statement = "begin RNT_USER_MAIL_PKG.REGISTER_ACCOUNT_MSG(X_USER_REGISTRY_ID => :var1); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->set(1, $userRegistryID);
        @$prepare->executeUpdate();
   }

   function firstRegistration($userLogin, $password, $hashCode){
        $statement = "begin RNT_USERS_PKG.REGISTY_LOGIN(X_USER_LOGIN_EMAIL => :var2, ".
                                                        "X_USER_PASSWORD => :var3, ".
                                                        "X_USER_HASH_VALUE => :var4); end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->set(2, $userLogin);
        $prepare->set(3, $password);
        $prepare->set(4, $hashCode);
        @$prepare->executeUpdate();
   }

  function isSubscriptionUser($user_id)
  {
      $query = "select IS_SUBSCRIBED_YN from RNT_USERS
                where  USER_ID = :var1";
      $stmt = $this->connection->prepareStatement($query);
      $stmt->setInt(1, $user_id);
      $rs = $stmt->executeQuery();
      
      while($rs->next()) {
          $x = $rs->getRow();
          $r = $x;
      }
      $rs->close();
      return @$r["IS_SUBSCRIBED_YN"] == "Y";
  }

  function updateUserData($userid, $name, $lastName, $primaryPhone, $secondaryPhone){
         $statement = "begin RNT_USERS_PKG.UPDATE_USER_DATA(".
                                           "X_USER_ID => :var1,".
                                           "X_USER_NAME => :var2,".
                                           "X_USER_LASTNAME => :var3,".
                                           "X_PRIMARY_PHONE => :var4,".
                                           "X_SECONDARY_PHONE => :var5); end;";
         $prepare = $this->connection->prepareStatement($statement);
         $prepare->set(1, $userid);
         $prepare->set(2, $name);
         $prepare->set(3, $lastName);
         $prepare->set(4, $primaryPhone);
         $prepare->set(5, $secondaryPhone);
         @$prepare->executeUpdate();
   }
 }
?>