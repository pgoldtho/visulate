<?

 require_once dirname(__FILE__)."/database/rnt_users.class.php";

 class User
 {
     private $userid;
     private $isSubscribe = false;
     const NO_LOGIN = -1;
     const DEFAULT_PASSWORD = "changeme";
     private $dbUserObj;
     private $role = "";

     public function __construct($connection)
     {
         $this->userid = User::NO_LOGIN;
         session_start();
         $this->init();
         $this->dbUserObj = new RntUser($connection);
     }

     function getUserID()
     {
        return $this->userid;
     }

     public function isSubscribed(){
        return $this->isSubscribe;
     }

     public function getUserInfo(){
        return $this->dbUserObj->getUser($this->userid);
     }

     public function init()
     {
  /*
      //$idleTimeout = 1410; // timeout after 23 minutes</span>
      if(isset($_SESSION['timeout_idle']) && $_SESSION['timeout_idle'] > time()) 
      {
       //Zend_Session::destroy();
       //Zend_Session::regenerateId();
       header('Location: /rental/login.php?destroy=On');
       exit();
      }
      $_SESSION['timeout_idle'] = time() + $idleTimeout;
    */  
      
      if (@$_SESSION["user_id"])
         {
            $this->userid      = @Context::readValue("user_id");
            $this->role        = @Context::readValue("role");
            $this->isSubscribe = @Context::readValue("is_subscribed");
         }
     else
            $this->userid = User::NO_LOGIN;
     }

     public function isLogin()
     {
         return ($this->userid != User::NO_LOGIN);
     }

     public function login($login, $password)
     {
         // $password = md5($password);
          $is_admin = 'N';
          $userid = $this->dbUserObj->loginUser($login, $password);
          Context::clearContext();
          if ($userid != -1)
          {
              $this->userid = $userid;
              Context::writeValue("user_id", $this->userid);
              $this->isSubscribe = $this->dbUserObj->isSubscriptionUser($userid);
              Context::writeValue("is_subscribed", $this->isSubscribe);
              return true;
          }
          return false;
     }

     public function isPublic()
     {
         return $this->role == "PUBLIC";
     }

	 
     public function isManager()
     {
         return $this->role == "MANAGER";
     }

     public function isOwner()
     {
         return $this->role == "OWNER";
     }

     public function isAdmin()
     {
         return $this->role == "ADMIN";
     }

     public function isManagerOwner()
     {
         return $this->role == "MANAGER_OWNER";
     }

     public function isBusinessOwner()
     {
         return $this->role == "BUSINESS_OWNER";
     }

     public function isBookKeeping()
     {
         return $this->role == "BOOKKEEPING";
     }
     
     public function isAdvertise()
     {
         return $this->role == "ADVERTISE";
     }

     public function isBuyer()
     {
         return $this->role == "BUYER";
     }

     public function isSiteEditor()
     {
         return $this->role == "SITE_EDITOR";
     }
     
     public function getRole()
     {
         return $this->role;
     }

     public function setRole($role)
     {
         if ($role != "MANAGER" 
				  && $role != "OWNER" 
					&& $role != "ADMIN" 
					&& $role != "MANAGER_OWNER" 
					&& $role != "BUSINESS_OWNER" 
					&& $role != "BOOKKEEPING"
					&& $role != "BUYER"
					&& $role != "ADVERTISE"
					&& $role != "PUBLIC"
					&& $role != "SITE_EDITOR" )
           throw new Exception("Unknown role.");
         $this->role = $role;
         Context::writeValue("role", $role);
         Context::clearContext();
     }

     public function set_database_user()
     {
         $this->dbUserObj->set_database_user($this->userid, $this->role);
     }

     public function destroy()
     {
          session_destroy();
          $this->userid = User::NO_LOGIN;
          $this->role = "";
          $this->isSubscribe = false;
     }

     public function isHasAssignment()
     {
         return $this->dbUserObj->getAssignmentCount() > 0;
     }

     public function getRoles()
     {
         // define roles for user
         return $this->dbUserObj->get_roles();
     }

     public function getRoleNames()
     {
         // define roles for user
         return $this->dbUserObj->get_role_names();
     }

     public function needChooseRoles()
     {
         $roles = $this->getRoles();
         $x = intval(array_key_exists("MANAGER", $roles)) +
              intval(array_key_exists("OWNER", $roles)) +
              intval(array_key_exists("MANAGER_OWNER", $roles)) +
              intval(array_key_exists("BUSINESS_OWNER", $roles)) +
              intval(array_key_exists("ADMIN", $roles))+
              intval(array_key_exists("ADVERTISE", $roles))+
              intval(array_key_exists("BUYER", $roles))+
              intval(array_key_exists("BOOKKEEPING", $roles));
         return $x > 1;
     }

     public function changePassword($oldPassword, $newPassword)
     {
          if ($newPassword == "")
            throw new Exception("New password require the value.");
          //$newPassword = md5($newPassword);
          //$oldPassword = md5($oldPassword);
          return $this->dbUserObj->changePassword($this->userid, $oldPassword, $newPassword);
     }

     public function getWrappedPassword($pass)
     {
         //return md5($pass);
         return  $this->dbUserObj->encryptPassword($pass);
     }

     public function recover_password($login){
         $this->dbUserObj->recover_password($login);
     }

     public function getRoleLevel(){
         if ($this->role == "MANAGER" 
				        || $role == "OWNER" 
				        || $role == "ADVERTISE"
				        || $role == "BUYER"
					      || $role == "BOOKKEEPING" )
            return 2;
         if ($role == "MANAGER_OWNER" 
				  || $role == "BUSINESS_OWNER")
            return 1;
         if ($role == "ADMIN")
            return 0;

         throw new Exception("Unknown role.");
     }

     public function verifyBUAccess($businessID){

       if (!$this->dbUserObj->verifyBUAccess($businessID))
          throw new Exception("Security error. You do not have permission to access to this business unit.");
     }

     public function verifyPropertyAccess($propertyID){
        if (!$this->dbUserObj->verifyPropertyAccess($propertyID))
          throw new Exception("Security error. You do not have permission to access to this property.");
     }

     public function isExistsUser($login){
        return $this->dbUserObj->isExistsUser($login);
     }

     public function registerAccount($userName, $lastName, $firstName, $inviteUserID, $telephone){
        $userRegistryID = $this->dbUserObj->registerAccount($userName, $lastName, $firstName, $inviteUserID, $telephone);
        $this->dbUserObj->sendMailAccount($userRegistryID);
     }

     public function firstRegistration($userLogin, $password, $hashCode){
        $this->dbUserObj->firstRegistration($userLogin, $password, $hashCode);
     }

     public function isExistsBULevel2(){
        return $this->dbUserObj->isExistsBU2();
     }

     public function updateUserData($name, $lastName, $primaryPhone, $secondaryPhone){
       $this->dbUserObj->updateUserData($this->userid, $name, $lastName, $primaryPhone, $secondaryPhone);
     }
 }


?>
