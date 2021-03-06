<?
  require_once dirname(__FILE__)."/classes/SmartyInit.class.php";
  require_once dirname(__FILE__)."/classes/Menu.class.php";
  require_once dirname(__FILE__)."/classes/Menu3.class.php";

  $is_redirect = false;
  $smarty = new SmartyInit();
  
  
  if (!$smarty->user->getRole())
  {
    $smarty->user->setRole("PUBLIC");
  }
  
  if ((!$smarty->user->isLogin()) && (!$smarty->user->isPublic()))
  {
       // goto login page
       header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."login.php");
       exit;
  }
  $mobile_device = is_mobile_browser();
  Context::setMobileDevice($mobile_device);



  // retrive menu data from database
  require_once dirname(__FILE__)."/classes/database/rnt_menus.class.php";
  $rnt_menu  = new RNTMenu($smarty->connection);
  $is_mobile_browser = Context::getMobileDevice();
  $menu_data = $is_mobile_browser
             ? $rnt_menu->getConfigMenuMobi()
             : $rnt_menu->getConfigMenuPC();


  $item_menu1 = @$_REQUEST[REQUEST_MENU_LEVEL1];
  $item_menu2 = @$_REQUEST[REQUEST_MENU_LEVEL2];

if ($item_menu1=="visulate_search")
  {
       header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."visulate_search.php");
       exit;
  }

  $menu = new Menu($item_menu1, $item_menu2, $menu_data/*$global_menu_data*/, $smarty->user);
  
  if ($smarty->user->isLogin()) {
      // set current user_id
      $smarty->user->set_database_user();

      $smarty->assign("manyRoles", "false");
      if ($smarty->user->needChooseRoles()) {
          $smarty->assign("manyRoles", "true");
      }
      
      $smarty->assign("role",  $smarty->user->getRole());
  }
  
  // Initial data for menu third level
  $menu3 = new Menu3($smarty->connection);
  $propertyID = @$_REQUEST[REQUEST_PROPERTY_ID];

  if (@!$_REQUEST["withoutContext"]){
	  if ($propertyID == null)
	    $propertyID = Context::getPropertyID();
	  else
	    Context::setPropertyID($propertyID);
  }

  $menu3->build($propertyID, ($menu->current_level2 == "property_details")
                          || ($menu->current_level2 == "property_home_summary"));
  if ($menu3->data && (!$propertyID)
                   && ($menu->current_level2 != "property_details")
			       && ($menu->current_level2 != "property_home_summary"))
  {			       
	 // if exists property which assigned for user
     $smarty->user->verifyPropertyAccess($menu3->current_property_id);
  }


  $template_name = "page-".$menu->current_level2.'.tpl';
  
  if (in_array(strtolower($menu->current_level1), array('public', 'm_public'))) {
      $template_name = 'page-dbcontent.tpl';
  } 

//  if $smarty->user->
  try
  {
  if ($smarty->user->isLogin()) {
 
    // We have not a assignments.
    if ($menu3->current_property_id == NULL
		            && !$smarty->user->isHasAssignment()
								&& !$smarty->user->isAdmin())
        throw new Exception("You have not assignment. Address to administrator.");

    // We have not a business units.
    if ($menu3->current_property_id == NULL
		            && $menu->current_level2 != "property_business_units"
								&& !$smarty->user->isAdmin()
								&& !$smarty->user->isManagerOwner()
								&& !$smarty->user->isBusinessOwner())
    {
       include dirname(__FILE__)."/classes/database/rnt_business_units.class.php";
       $bu = new RNTBusinessUnit($smarty->connection);
       if (!$bu->isBusinessUnits())
       {
          if ( $smarty->user->isManager() || $smarty->user->isManagerOwner()
					                                || $smarty->user->isBusinessOwner())
             throw new Exception("You have no business units. Define first <a href=\"?".$menu->request_menu_level2."=property_business_units\">it</a>.");
          else
             throw new Exception("You have no business units. Manager must define it.");
       }
    }

    if (!$smarty->user->isSubscribed() && !$smarty->user->isAdmin()){
      switch($menu->current_level2) {
        case "property_home_summary" :
        case "property_business_units" :
        case "property_partners" :
        case "property_supplier" :
        case "property_details" :
        case "property_finance" :
        case "tenant_agreements" :
    break;
        default : {
                     // redirect to subscribe page
                     //header("Location: ".get_basepath()."/cgi-bin/home.cgi?TF=subscribe");
                     //exit;
               throw new Exception("<b>Your Visulate Subscription Has Expired.</b><br/><br/>
							 Click on the Subscribe button on the right of the screen to setup
							 your subscription.<br/><br/>

               <b>Please call Sue on (321) 698 5198 if you need help with your subscription.</b>");
                   }
      }
    }
    // we have not a properties
    if (   $menu3->current_property_id == NULL
	    && $menu->current_level2 != "property_details"
	    && $menu->current_level2 != "property_business_units"
	    && $menu->current_level2 != "property_home_summary"
	    && !$smarty->user->isAdmin())
    {
       $isExistsBULevel2 = $smarty->user->isExistsBULevel2();

       if (!$isExistsBULevel2){
           if ($smarty->user->isManagerOwner() || $smarty->user->isBusinessOwner())
               throw new Exception("You have no Business SubUnits (Business Unit of second level).
							  <a href=\"?".$menu->request_menu_level2."=property_business_units\">Define first Sub Business Units</a>.");
           else
               // its manager
               throw new Exception("You have Business SubUnits. OwnerManager or BusinessOwner must defined it.");

       }
       else{
           if ( $smarty->user->isOwner()
					       || $smarty->user->isManagerOwner()
								 || $smarty->user->isManager()
								 || $smarty->user->isAdvertise()
								 || $smarty->user->isBusinessOwner())
               throw new Exception("<a href=\"?".$menu->request_menu_level2."=property_details\">
							 Create a property for this business unit</a>.");
           else
               // its manager
               throw new Exception("This business unit has no properties and your
							 role does not allow you to create one.
							 Please open the <a href=\"login2.php\">change role</a> screen and select a
							 manager or business owner role");
       }
    }
    
  }// if $smarty->user->isLogin
   
    if ($menu->current_level1 == 'public') {
        include dirname(__FILE__)."/pages/dbcontent.php";
    }
    else {
        $php_file =   $rnt_menu->getPHPfilename($menu->current_level2);
        include dirname(__FILE__)."/pages/".$php_file;
    }
        
  }  
  catch(Exception $e)
  {
    $template_name = "Exception.tpl";
    $smarty->assign("ExceptionMessage", $e->getMessage());
  }

  if (!$is_redirect)
  {
      // assign object to Smarty
      $smarty->assign('menuObj',$menu);
      $smarty->assign('menu3Obj',$menu3);

      $smarty->display($template_name);
  }
  $smarty->connection->close();

/*
  echo "URL to server root = ".$GLOBALS["PATH_FORM_ROOT"]."<br>";
  echo "Upload dir = ".UPLOAD_DIR."<br>";
  echo "Upload URL (for read via http) = ".UPLOAD_URL;
*/
?>
