<?

 function make_thumbnail($dir, $file_base_name, $file_ext, $file_maxsize, $file_new_name)
 {
      $file_ext = strtolower($file_ext);
      $img = 0;
      $filename = $dir.$file_base_name;
      if ($file_ext == "jpg" || $file_ext == "jpeg")
         $img = imagecreatefromjpeg($filename);
      else if ($file_ext == "gif")
         $img = imagecreatefromgif($filename);
      else if ($file_ext == "png")
         $img = imagecreatefrompng($filename);
      else if ($file_ext == "bmp")
         $img = imagecreatefromwbmp($filename);
      $w = imagesx($img);
      $h = imagesy($img);
      $x = $w;
      if ($x < $h)
         $x = $h;
      // coef to resize
      $k = 1;
      if ($x > $file_maxsize)
          $k = $file_maxsize / $x;
      $w1 = round($w*$k, 0);
      $h1 = round($h*$k, 0);
      $thumb = imagecreatetruecolor($w1, $h1);
      imagecopyresized($thumb, $img, 0, 0, 0, 0, $w1, $h1, $w, $h);
      $dest_filename = $dir.$file_new_name;
      if ($file_ext == "jpg" || $file_ext == "jpeg")
         imagejpeg($thumb, $dest_filename);
      else if ($file_ext == "gif")
         imagegif($thumb, $dest_filename);
      else if ($file_ext == "png")
         imagepng($thumb, $dest_filename);
      else if ($file_ext == "bmp")
         imagewbmp($thumb, $dest_filename);
 }

 $href = $GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2();
 $submenu3 = array(array("href" => $href, "value"=>"Details"),
                   array("href" => $href."&type=map", "value" => "Photos and Documents"),
          );
          
 $mobile_device = Context::getMobileDevice();          
 
 if ($mobile_device)
   {
    $template_name = "mobile-page-property.tpl";
   }
 else
   {
   $type = @$_REQUEST["type"];
   if ($type != "" && $type != "map" )
     $type = "";

   if ($type == ""){
     $template_name = "page-property_details.tpl";
     $skey = 0;
   }
   else if ($type == "map"){
     $template_name = "page-property_map.tpl";
     $skey = 1;
   }
   else
     echo "error";
  }

 $smarty->assign("submenu2_1", $submenu3);
 $smarty->assign("skey", $skey);

  /* Page has included for /../index.php */
 require_once dirname(__FILE__)."/../classes/database/rnt_properties.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_business_units.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_document_links.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_property_photos.class.php";
 require_once dirname(__FILE__)."/../classes/UtlConvert.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
 require_once "HTML/QuickForm.php";

 if (! ( $smarty->user->isOwner()
      || $smarty->user->isManager()
      || $smarty->user->isManagerOwner()
      || $smarty->user->isBookkeeping()
      || $smarty->user->isAdvertise()
      || $smarty->user->isBuyer()
      || $smarty->user->isPublic()	  
      || $smarty->user->isBusinessOwner()))
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]);
    exit;
 }

 $isEdit = ($smarty->user->isOwner()
         || $smarty->user->isManager()
         || $smarty->user->isManagerOwner()
         || $smarty->user->isAdvertise()
         || $smarty->user->isBuyer()
         || $smarty->user->isPublic()	  		 
         || $smarty->user->isBusinessOwner());

 if (!defined("PROPERTY_DETAILS"))
 {
    define("PROPERTY_DETAILS",       "1");
    define("UPDATE_ACTION",          "UPDATE");
    define("INSERT_ACTION_PROPERTY", "INSERT_PROPERTY");
    define("INSERT_ACTION_UNIT",     "INSERT_UNIT");
    define("DELETE_ACTION_UNIT",     "DELETE_UNIT");
    define("DELETE_ACTION_PROPERTY", "DELETE_PROPERTY");
    define("CANCEL_ACTION",          "CANCEL");
    
    define("TRANSFER_ACTION_PROPERTY", "TRANSFER_ACTION");
 }


 $form = new HTML_QuickForm('formProp', 'POST');
 $IsPost = $form->isSubmitted();

 $dates_elements = array();

 if (!$isEdit)
   $form->freeze();


 $action = UPDATE_ACTION;
 $delete_id = -1;

 if (@$_REQUEST["FORM_ACTION"] == INSERT_ACTION_PROPERTY)
   $action = INSERT_ACTION_PROPERTY;
 else if (@$_REQUEST["FORM_ACTION"] == INSERT_ACTION_UNIT)
   $action = INSERT_ACTION_UNIT;
 else if (@$_REQUEST["action"] == "del_unit")
 {
   $action = DELETE_ACTION_UNIT;
   $delete_id = $_REQUEST["unit_id"];
 }
 else if (@$_POST["delete_prop"])
 {
   $action = DELETE_ACTION_PROPERTY;
   $delete_id = $_POST["PROP_PROPERTY_ID"];
 }
 else if ($_POST["transfer_prop"])
 {
   $action = TRANSFER_ACTION_PROPERTY;
 }
 else
 {
    if ($menu3->current_property_id == NULL)
       // no properties in menu
       $action = INSERT_ACTION_PROPERTY;
    else
       $action = UPDATE_ACTION;
 }
 
 if (@$_POST["cancel"])
   $action = CANCEL_ACTION;

 if ($action == CANCEL_ACTION)
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&".$menu3->getParams());
    exit;
 }

 $dbProp = new RNTProperties($smarty->connection);
 $dbDocLinks = new RNTDocumentLinks($smarty->connection);
 $dbPropertyPhotos = new RNTPropertyPhotos($smarty->connection);

 // --------------- START PHOTO UPLOAD

 if (@$_REQUEST['IS_PHOTO_UPLOAD'] && $isEdit){

     if (@$_REQUEST['action'] == "DELETE"){
         $dbPropertyPhotos->Delete($_REQUEST['PHOTO_ID']);
         header("Location: ?".$menu->getParam2().'&PROPERTY_ID='.@$_REQUEST['PROPERTY_ID'].'&type=map#photos');
        exit;
     }

     $smarty->assign('uploadPhotoTitle', @$_REQUEST['photoTitle']);
     $error = false;
     if (@trim($_REQUEST['photoTitle']) == ''){
        $smarty->assign('uploadPhotoTitleError', 'Title must specified');
        $error = true;
     }
/*
     if (!isset($_FILES['photoFile'])){
        $smarty->assign('uploadPhotoFileError', 'Photo must be specified');
        $error = true;
     }
*/
    $name_tmp = $_FILES['photoFile']['tmp_name'];
     $name = $_FILES['photoFile']['name'];
     $file_error = $_FILES['photoFile']['error'];

     if (trim($name) == ''){
         $error = true;
         $smarty->assign('uploadPhotoFileError', 'Photo file not loaded');
     }
     if ($file_error != 0)
       $error = true;

     if ($file_error == 0){
             $dir = UPLOAD_DIR.'/'.$menu3->current_property_id.'/';
             if (!file_exists($dir)){
                mkdir($dir);
                chmod($dir, 0777);
                //$dir .= '/';
             }
             $dir .= '/';

             $m = array();
             preg_match('/(.*)\\.(.+$)/', $name, $m);
             list(, $file_name, $file_ext) = $m;

             if (!in_array(strtolower($file_ext), $CONFIG_ALLOWED_PHOTO_EXTENSIONS)) {
                 $smarty->assign('uploadPhotoFileError',
								  'Please select a file of type: <b>'.implode(', ', $CONFIG_ALLOWED_PHOTO_EXTENSIONS)."</b>.");
                 $error = true;
             } else if (!$error){
                     $file_base_name = $name;
                     if (file_exists($dir.$file_base_name)){
                         for($i=1; $i<20; $i++){
                             $file_base_name = $file_name.'__'.$i.'.'.$file_ext;
                             if (file_exists($dir.$file_base_name))
                                continue;
                             break;
                         }
                     }

                     // try to moving file
                     if (is_uploaded_file($name_tmp)){
                         move_uploaded_file($name_tmp, $dir.$file_base_name);
                         // make thumbnail and vga sized image

                         make_thumbnail($dir, $file_base_name, $file_ext
                                                             , THUMBNAIL_PHOTO_MAX_SIZE
                                                             , "thumbnail_".$file_base_name);
                         make_thumbnail($dir, $file_base_name, $file_ext
                                                             , VGA_PHOTO_MAX_SIZE
                                                             , "vga_".$file_base_name);

                     }
                     else
                       $smarty->assign('uploadPhotoFileError', 'Problem in upload file');
             }
     }
     else if ($file_error == 1)
        $smarty->assign('uploadPhotoFileError', 'Maximum allowed file size is '.ini_get('upload_max_filesize').' bytes.');
     else if ($file_error == 2)
        $smarty->assign('uploadPhotoFileError', 'Maximum allowed file size is '.$_REQUEST['MAX_FILE_SIZE'].' bytes.');
     else if ($file_error == 3)
        $smarty->assign('uploadPhotoFileError', 'File loaded is partial');
     else if ($file_error == 4)
        $smarty->assign('uploadPhotoFileError', 'Photo file not loaded');



     $IsPost = false;
     $action = UPDATE_ACTION;

     if (!$error){
         // write info to database
        $values = array('PROPERTY_ID' => $_REQUEST['PROPERTY_ID'],
                                          'PHOTO_TITLE'  => $_REQUEST['photoTitle'],
                                          'PHOTO_FILENAME' => $file_base_name
                                                   );
        $dbPropertyPhotos->Insert($values);
         header("Location: ?".$menu->getParam2().'&PROPERTY_ID='.$_REQUEST['PROPERTY_ID'].'&type=map#photos');
        exit;
    }
 } // if (@$_REQUEST['IS_PHOTO_UPLOAD']){ ...


 $form->registerRule('vdate', 'function', 'validateDate');
 $form->registerRule('vnumeric', 'function', 'validateNumeric');
 $form->registerRule('vinteger', 'function', 'validateInteger');
 $property_data = $dbProp->getProperty($menu3->current_property_id);

 if (($action == UPDATE_ACTION || $action == INSERT_ACTION_UNIT || $action == DELETE_ACTION_UNIT) && !$IsPost)
 {
    $property_units = $dbProp->getPropertyUnitsList($menu3->current_property_id);
    if ($action == INSERT_ACTION_UNIT)
    {
       if ($property_data["PROP_UNITS"] == count($property_units))
       {
          $de = new DatabaseError($smarty->connection);
          $smarty->assign("errorObj", $de->setNonDatabaseMessage(0, "Cannot append unit. Record of property have ".$property_data["PROP_UNITS"].
                         " units. Added record is the ".($property_data["PROP_UNITS"]+1)."."));
       }
       else
         $property_units[] = array("UNIT_PROPERTY_ID"=>$menu3->current_property_id);
    }
 }

 // --------------- END PHOTO UPLOAD

 if (@$_REQUEST['IS_UPLOAD'] && $isEdit){
     if (@$_REQUEST['action'] == "DELETE"){
         $dbDocLinks->Delete($_REQUEST['PROPERTY_LINK_ID']);
         header("Location: ?".$menu->getParam2().'&PROPERTY_ID='.$_REQUEST['PROPERTY_ID'].'&type=map#upload');
        exit;
     }

     $smarty->assign('uploadTitle', @$_REQUEST['uploadTitle']);
     $error = false;
     if (@$_REQUEST['uploadTitle'] == ''){
        $smarty->assign('uploadTitleError', 'Title must specified');
        $error = true;
     }
     if (@$_REQUEST['uploadFile'] == ''){
        $smarty->assign('uploadFileError', 'Document link must be specified');
        $error = true;
     } else if (!preg_match('/^(http|https|ftp):\/\/(([A-Z0-9][A-Z0-9_)*(\.[A-Z0-9][A-Z0-9_]*)+.*)/i', $_REQUEST['uploadFile'], $m)){
        $smarty->assign('uploadFileError', 'Document link must be valid url string');
        $smarty->assign('uploadFile', $_REQUEST['uploadFile']);
        $error = true;
     }
     $IsPost = false;
     $action = UPDATE_ACTION;

     if (!$error){
            $values = array('PROPERTY_ID' => $_REQUEST['PROPERTY_ID'],
                            'LINK_TITLE'  => $_REQUEST['uploadTitle'],
                            'LINK_URL'    => $_REQUEST['uploadFile']
                            );
            $dbDocLinks->Insert($values);
            header("Location: ?".$menu->getParam2().'&PROPERTY_ID='.$_REQUEST['PROPERTY_ID'].'&type=map#upload');
            exit;
    }

 } // if (@$_REQUEST['IS_UPLOAD']){ ...


 $form->registerRule('vdate', 'function', 'validateDate');
 $form->registerRule('vnumeric', 'function', 'validateNumeric');
 $form->registerRule('vinteger', 'function', 'validateInteger');
 $property_data = $dbProp->getProperty($menu3->current_property_id);

 if (($action == UPDATE_ACTION
   || $action == INSERT_ACTION_UNIT
	 || $action == DELETE_ACTION_UNIT) && !$IsPost)
 {
    $property_units = $dbProp->getPropertyUnitsList($menu3->current_property_id);
    if ($action == INSERT_ACTION_UNIT)
    {
       if ($property_data["PROP_UNITS"] == count($property_units))
       {
          $de = new DatabaseError($smarty->connection);
          $smarty->assign("errorObj", $de->setNonDatabaseMessage(0, "Cannot append unit. Record of property have ".$property_data["PROP_UNITS"].
                         " units. Added record is the ".($property_data["PROP_UNITS"]+1)."."));
       }
       else
         $property_units[] = array("UNIT_PROPERTY_ID"=>$menu3->current_property_id);
    }
 }

 $num_units = 0;
 if (@$IsPost)
     $num_units = count(@$_POST["UNITS"]);
 else
     $num_units = count(@$property_units);

 $prop_num_units = @$property_data["PROP_UNITS"];
 // property_id for page menu level 3
 $form->AddElement("hidden", $menu3->request_property_id, $menu3->current_property_id);
 // menu 2 level
 $form->AddElement("hidden", $menu->request_menu_level2, $menu->current_level2);
 $form->AddElement("hidden", "PROP_CHECKSUM");
 $form->AddElement("hidden", "PROP_PROPERTY_ID");

 $form->AddElement("hidden", "FORM_ACTION", $action);

 $business_units = new RNTBusinessUnit($smarty->connection);
 /**
  * Business Unit field should default if user only has one L2 business unit.
  * (e.g. most users will have a L1 BU of email@domain with a L2 of email@domain Properties).
  */
 $BUList     = $business_units->getListForLOV($smarty->user->getRole());
 $bu_first   = each($BUList);
 $bu_default = (count($BUList) == 1)
             ? array("value" => $bu_first["key"])
             : array();
/*
 $BULovData = new LovData("data", $BUList);
 $form->AddElement("lov", "PROP_BUSINESS_ID", "Business unit", $bu_default,
  array("nameCode"  => "PROP_BUSINESS_ID__CODE",
        "imagePath" => $GLOBALS["PATH_FORM_ROOT"]."images/lov.gif",
        "sizeCode"  => 40
  ), $BULovData);
*/

 
 $prop_has_details = ($action != INSERT_ACTION_PROPERTY)
                   ? $dbProp->has_details($menu3->current_property_id)
                   : FALSE;    

 $attributes = array(
     'id' => 'PROP_BUSINESS_ID_CODE',
     'onchange'=>"var mylist = document.getElementById('PROP_BUSINESS_ID_CODE'); ".
                 "var prop_bu_id = document.getElementsByName('PROP_BUSINESS_ID'); ".
                 "prop_bu_id[0].value = mylist.options[mylist.selectedIndex].value;"
 );
 if ($prop_has_details) {
     $attributes['disabled'] = 'disabled';
 }
		
 $form->AddElement("hidden", "PROP_BUSINESS_ID");
 $form->AddElement(
     "select", "PROP_BUSINESS_ID_CODE", "Business unit",
     //$business_units->getListForLOV($smarty->user->getRole()),
     $business_units->getBULevel2List(),
     $attributes
 );


 /* Items 'FROM_BUSINESS_ID' and 'TO_BUSINESS_ID'
  * for transfer business unit utility only!
  */ 
 
 // 'FROM_BUSINESS_ID'
 $form->AddElement("hidden", "FROM_BUSINESS_ID");            
 $attributes= array(
     'id' => 'FROM_BUSINESS_ID_CODE',
     'onchange'=>"var mylist = document.getElementById('FROM_BUSINESS_ID_CODE'); ".
                 "var prop_bu_id = document.getElementsByName('FROM_BUSINESS_ID'); ".
                 "prop_bu_id[0].value = mylist.options[mylist.selectedIndex].value;",
     'disabled' => 'disabled'
 );
 $form->AddElement(
     "select", "FROM_BUSINESS_ID_CODE", "Business unit",
     $business_units->getBULevel2List(),
     $attributes
 );
 
 // 'TO_BUSINESS_ID'
 $form->AddElement(
     "select", "TO_BUSINESS_ID", "Business unit",
     $business_units->getBULevel2List()
 );
 
 // End block
 
 
 $form->AddElement("text", "PROP_UNITS", "Rentable Units", array('size'=>4,'maxlength' => 60));
 $form->AddElement("text", "PROP_NAME",  "Property Name", array('size'=>20,'maxlength' => 60));
 $form->AddElement("text", "PROP_ADDRESS1", "Address line 1", array('maxlength' => 60));
 $form->AddElement("text", "PROP_ADDRESS2", "Address line 2", array('maxlength' => 60));
 $form->AddElement("text", "PROP_CITY", "City", array('maxlength' => 60));

 
 $StatesLovData = new LovData("dataStates", $dbProp->getStatesList());
 $form->AddElement("lov", "PROP_STATE", "State", array(),
  array("nameCode"=>"PROP_STATE__CODE",
  "imagePath"=>$GLOBALS["PATH_FORM_ROOT"]."images/lov.gif", "sizeCode"=>20), $StatesLovData);

 $form->AddElement("text", "PROP_ZIPCODE", "Zipcode");

 $StatusLovData = new LovData("dataStatus", $dbProp->getStatusList());
 $form->AddElement(
     "lov", "PROP_STATUS", "Status", array(),
     array("nameCode"  => "PROP_STATUS__CODE]",
           "imagePath" => $GLOBALS["PATH_FORM_ROOT"]."images/lov.gif",
           "sizeCode"  => 20),
     $StatusLovData
 );

 $form->AddElement("text", "PROP_DATE_PURCHASED", "Date purchased", array('size' => 8));
 $dates_elements[] = "PROP_DATE_PURCHASED";
 $form->AddElement("text", "PROP_PURCHASE_PRICE", "Purchase Price", array('size' => 20));
 $form->AddElement("text", "PROP_LAND_VALUE", "Land value", array('size' => 18));
 $form->AddElement("select", "PROP_DEPRECIATION_TERM", "Depreciation Term", array('27.5' => '27.5', '39' => '39'));
 $form->AddElement("text", "PROP_YEAR_BUILT", "Year build", array('size' => 6));
 $form->AddElement("text", "PROP_BUILDING_SIZE", "Bulding size (sq ft)", array('size' => 6));
 $form->AddElement("text", "PROP_LOT_SIZE", "Lot size (acres)", array('size' => 6));
 $form->AddElement("text", "PROP_DATE_SOLD", "Date sold", array('size' => 8));
 $dates_elements[] = "PROP_DATE_SOLD";
 $form->AddElement("text", "PROP_SALE_AMOUNT", "Sale amount", array('size' => 8));
 $form->AddElement("advcheckbox", "PROP_NOTE_YN", "Note", "", array("N", "Y"));

if ($action != INSERT_ACTION_PROPERTY)
 {
     $unts = array();
     if (@$IsPost)
       $unts = @$_POST["UNITS"];
     else
       $unts = @$property_units;

     for($i=0; $i<$num_units; $i++)
     {
        if ($prop_num_units != 1)
        {
          $form->AddElement("text", "UNITS[$i][UNIT_UNIT_NAME]", "Unit name", array("size"=>10));
          $form->AddElement("text", "UNITS[$i][UNIT_UNIT_SIZE]", "Size", array("size"=>5));
        }
        else
        {
          $form->AddElement("hidden", "UNITS[$i][UNIT_UNIT_NAME]");
          $form->AddElement("hidden", "UNITS[$i][UNIT_UNIT_SIZE]");
        }
        $form->AddElement("text", "UNITS[$i][UNIT_BEDROOMS]", "Bedrooms", array("size"=>3));
        $form->AddElement("text", "UNITS[$i][UNIT_BATHROOMS]", "Bathrooms", array("size"=>3));
        $form->AddElement("hidden", "UNITS[$i][UNIT_CHECKSUM]");
        $form->AddElement("hidden", "UNITS[$i][UNIT_UNIT_ID]");
        $form->AddElement("hidden", "UNITS[$i][UNIT_PROPERTY_ID]");
        if ($prop_num_units != 1 && ($isEdit))
        {
            if (@$unts[$i]["UNIT_UNIT_ID"])
              $form->addElement('link',   "UNITS[$i][UNIT_UNIT_ID_LINK]", "delete",
                      "?".$menu3->getParams()."&".$menu->getParam2()."&action=del_unit&unit_id=".$unts[$i]["UNIT_UNIT_ID"], $smarty->deleteImage, $smarty->deleteAttr);
            else
              $form->addElement('link', "UNITS[$i][UNIT_UNIT_ID_LINK]", "delete");
        }
        // require
        $form->addRule("UNITS[$i][UNIT_UNIT_NAME]", 'Please set Unit name.', 'required');
        // rule for validate
        $form->addRule("UNITS[$i][UNIT_UNIT_SIZE]", 'Size value must be integer.', 'numeric');

        /**
         * Building size and should be mandatory if the user role is ADVERTISE
         */
        if ($smarty->user->isAdvertise()) {
            $form->addRule("UNITS[$i][UNIT_BEDROOMS]", 'Please enter a value for the number of bedrooms.', 'required');
            $form->addRule("UNITS[$i][UNIT_BATHROOMS]", 'Please enter a value for the number of bathrooms.', 'required');
        }
        $form->addRule("UNITS[$i][UNIT_BEDROOMS]", 'Bedrooms value must be an integer.', 'vinteger');
        $form->addRule("UNITS[$i][UNIT_BATHROOMS]", 'Bathrooms value must be numeric.', 'numeric');
     }
   }

 // Apply filter for all data cells
 $form->applyFilter('__ALL__', 'trim');
 
 $form->addRule('PROP_BUSINESS_ID_CODE', 'Please select a Business unit.', 'nonzero');
 

 // Append rule REUIQRED
 $form->addRule('PROP_BUSINESS_ID', 'Please select a Business unit.', 'required');
 $form->addRule('PROP_ADDRESS1', 'Please enter Address line 1.', 'required');
 $form->addRule('PROP_CITY', 'Please enter City.', 'required');
 $form->addRule('PROP_STATE', 'Please selectState.', 'required');
 $form->addRule('PROP_ZIPCODE', 'Please enter Zipcode.', 'required');
 $form->addRule('PROP_STATUS', 'Please enter Status.', 'required');

 //$form->addRule('PROP_DATE_PURCHASED', 'Please enter Date purchased.', 'required');
 //$form->addRule('PROP_DATE_PURCHASED', 'Please enter Date purchased.', 'required', null, 'client');

 //$form->addRule('PROP_PURCHASE_PRICE', 'Please enter Purchase price.', 'required');
 //$form->addRule('PROP_PURCHASE_PRICE', 'Please enter Purchase price.', 'required', null, 'client');

 //$form->addRule('PROP_LAND_VALUE', 'Please enter the Land value (typically 10% of the purchase price).', 'required');
 //$form->addRule('PROP_LAND_VALUE', 'Please enter the Land value (typically 10% of the purchase price).', 'required', null, 'client');

 $form->addRule('PROP_DEPRECIATION_TERM', 'Please select Depreciation Term.', 'required');
 $form->addRule('PROP_UNITS', 'Please enter the number of rentable units.', 'required');
 // Append rule for NUMBERIC
 //$form->addRule('PROP_ZIPCODE', 'Zipcode must be number.', 'vinteger');
 $form->addRule('PROP_PURCHASE_PRICE', "Purchage price must be a number.", 'vnumeric');
 $form->addRule('PROP_LAND_VALUE', 'Land value must be a number.', 'vnumeric');
 $form->addRule('PROP_DEPRECIATION_TERM', 'Depreciation Term must be a number.', 'vnumeric');
 $form->addRule('PROP_YEAR_BUILT', 'Year build must be a number.', 'vinteger');

 /**
  * Building size and should be mandatory if the user role is ADVERTISE
  */
 if ($smarty->user->isAdvertise()) {
     $form->addRule("PROP_BUILDING_SIZE", "Bulding size must be a number.", 'required');
 }
 $form->addRule("PROP_BUILDING_SIZE", "Bulding size must be a number.", 'vnumeric');

 $form->addRule("PROP_LOT_SIZE", "Lot size must be a number.", 'vnumeric');
 $form->addRule("PROP_SALE_AMOUNT", "Sale amount must be a number.", 'vnumeric');
 $form->addRule("PROP_UNITS", "Units must be a number.", 'vinteger');
 // Append fule for DATE
 $form->addRule("PROP_DATE_PURCHASED", UtlConvert::ErrorDateMsg, 'vdate');
 $form->addRule("PROP_DATE_SOLD", UtlConvert::ErrorDateMsg, 'vdate');

 $validation_scripts = "";
 if ($isEdit)
 {
     $validation_scripts =
         "<script type='text/javascript'>
              function check_purchased_items() {
                  var frm = document.getElementById('formProp');
                  var value = '';
                  var _qfMsg = '';

                  value = frm.elements['PROP_DATE_PURCHASED'].value;
                  if (value == '') {
                      _qfMsg = _qfMsg + '\\n - Please enter Date purchased.';
                  }

                  value = frm.elements['PROP_PURCHASE_PRICE'].value;
                  if (value == '') {
                      _qfMsg = _qfMsg + '\\n - Please enter Purchase price.';
                  }

                  value = frm.elements['PROP_LAND_VALUE'].value;
                  if (value == '') {
                      _qfMsg = _qfMsg + '\\n - Please enter the Land value (typically 10% of the purchase price).';
                  }

                  value = frm.elements['PROP_STATUS'].value;
                  if (value == 'PURCHASED') {
                      if (_qfMsg != '') {
                          _qfMsg = 'Invalid information entered.' + _qfMsg;
                          alert(_qfMsg);
                          return false;
                      }
                  }

                  return true;
              }
           </script>";
    $r = array();
    $r["onclick"] = "return check_purchased_items();";
    $form->AddElement("submit", "accept", "Save", $r);

    $form->AddElement("submit", "cancel", "Cancel", array());
    $form->AddElement("submit", "new_property", "Add another property");

    $r = array();
    if ($action == INSERT_ACTION_PROPERTY || $prop_num_units == 1) {
       $r["disabled"] = "disabled";
    }
    $form->AddElement("submit", "new_unit", "New unit", $r);

    $r = array();
    if ($action == INSERT_ACTION_PROPERTY) {
       $r["disabled"] = "disabled";
    }
    $r["onclick"] = "return confirm('Delete this property?')";
    $form->AddElement("submit", "delete_prop", "Delete property", $r);
 }

 if (( ($IsPost && $form->validate()) || $action == DELETE_ACTION_UNIT) && $isEdit ) {
    // save form to database
    $values = $form->getSubmitValues();
    $newID = -1;
    $IsError = 0;
    try
    {
        if ($action == UPDATE_ACTION)
        {
           $dbProp->Update($values);
           $dbProp->UpdateUnits($values);
        }
        else if ($action == INSERT_ACTION_UNIT)
        {
           $dbProp->Update($values);
           $dbProp->UpdateUnits($values);
        }
        else if ($action == INSERT_ACTION_PROPERTY)
           $newID = $dbProp->Insert($values);
        else if ($action == DELETE_ACTION_UNIT)
           $dbProp->DeleteUnit($delete_id);
        else if ($action == DELETE_ACTION_PROPERTY)
           $dbProp->DeleteProperty($delete_id);
        else if ($action == TRANSFER_ACTION_PROPERTY)
        {
            if ($_POST["transfer_type"] == "prop_move")
            {
                $dbProp->move(
                    $_POST["PROP_PROPERTY_ID"],
                    $_POST["FROM_BUSINESS_ID"],
                    $_POST["TO_BUSINESS_ID"]
                );
            }
            else if ($_POST["transfer_type"] == "prop_copy")
            {
                $dbProp->copy(
                    $_POST["PROP_PROPERTY_ID"],
                    $_POST["FROM_BUSINESS_ID"],
                    $_POST["TO_BUSINESS_ID"]
                );
            }           
        }
        else
           throw new Exception('Unknown operation');


        $smarty->connection->commit();
    }
    catch(SQLException $e)
    {
          $IsError = 1;
          $smarty->connection->rollback();
          $de =  new DatabaseError($smarty->connection);
          $smarty->assign("errorObj", $de->getErrorFromException($e));
    }


    if ($newID > -1 && !$IsError)
      $menu3->current_property_id = $newID;

    if (!$IsError)
    {
         if (@$_REQUEST["new_property"])
              header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&".$menu3->getParams().'&FORM_ACTION='.INSERT_ACTION_PROPERTY."#top");
         else
         if (@$_REQUEST["new_unit"])
              header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&".$menu3->getParams().'&FORM_ACTION='.INSERT_ACTION_UNIT."#top");
         else  if (@$action == DELETE_ACTION_UNIT)
              header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&".$menu3->getParams()."#top");
         else
              header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&".$menu3->getParams()."#top");
         exit;
    }
 }

 if (@$_REQUEST["new_property"])
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]
           ."?".$menu->getParam2()
           ."&".$menu3->getParams()
           .'&FORM_ACTION='.INSERT_ACTION_PROPERTY);
    exit;
 }

 // create new unit, redirect to page with action INSERT_UNIT
 if (@$_REQUEST["new_unit"])
 {
    header("Location: ".$GLOBALS["PATH_FORM_ROOT"]."?".$menu->getParam2()."&".$menu3->getParams().'&FORM_ACTION='.INSERT_ACTION_UNIT);
    exit;
 }

 if (($action == UPDATE_ACTION
   || $action == INSERT_ACTION_UNIT
	 || $action == DELETE_ACTION_UNIT) && !$IsPost && $property_data)
 {
     // inital data for form
     foreach($property_units as $k1=>$v1)
       foreach($v1 as $k2=>$v2)
          $property_data["UNITS[$k1][$k2]"] = $v2;
     // correct values
     $nums = array("PROP_PURCHASE_PRICE", "PROP_LAND_VALUE", "PROP_DEPRECIATION_TERM", "PROP_BUILDING_SIZE",
                  "PROP_LOT_SIZE", "PROP_SALE_AMOUNT");
     foreach($nums as $v)
        $property_data[$v] = UtlConvert::dbNumericToDisplay($property_data[$v]);

     $property_data["PROP_DATE_PURCHASED"] = @UtlConvert::dbDateToDisplay($property_data["PROP_DATE_PURCHASED"]);
     $property_data["PROP_DATE_SOLD"] = UtlConvert::dbDateToDisplay($property_data["PROP_DATE_SOLD"]);
     $property_data["PROP_NOTE_YN"] = ($property_data["PROP_NOTE_YN"] == "Y");
     
     $property_data["PROP_BUSINESS_ID_CODE"] = $property_data["PROP_BUSINESS_ID"];
     $property_data["FROM_BUSINESS_ID"]      = $property_data["PROP_BUSINESS_ID"];
     $property_data["FROM_BUSINESS_ID_CODE"] = $property_data["PROP_BUSINESS_ID"];
     
     $form->setDefaults($property_data);
     $header_title = $property_data["PROP_ADDRESS1"];
 }
 else
    $header_title = "New Property";


 $doc_list = $dbDocLinks->getList($menu3->current_property_id);
 $i = 1;
 foreach($doc_list as $k=>$v){
     $doc_list[$k]['CREATION_DATE'] = UtlConvert::dbDateToDisplay($v['CREATION_DATE']);
     $doc_list[$k]['order'] = $i++;
     $doc_list[$k]["linkDel"] = "<a onclick=\"return confirm('Delete this record?')\" href=\"?".$menu3->getParams()."&".$menu->getParam2()."&IS_UPLOAD=true&PROPERTY_LINK_ID=".$v['PROPERTY_LINK_ID']."&action=DELETE&type=map\">".
                              $smarty->deleteImage."</a>";
 }

 // photos
 $photo_list = $dbPropertyPhotos->getList($menu3->current_property_id);
 foreach ($photo_list as $k => $v){
     $photo_list[$k]['PHOTO_FILENAME'] = UPLOAD_URL.'/'.$menu3->current_property_id.'/thumbnail_'.$v['PHOTO_FILENAME'];
     $photo_list[$k]['VGA_FILENAME'] = UPLOAD_URL.'/'.$menu3->current_property_id.'/vga_'.$v['PHOTO_FILENAME'];
     $photo_list[$k]['LARGE_PHOTO_FILENAME'] = UPLOAD_URL.'/'.$menu3->current_property_id.'/'.$v['PHOTO_FILENAME'];
     $photo_list[$k]["linkDel"] = "<a onclick=\"return confirm('Delete this photo?')\" href=\"?".$menu3->getParams()."&".$menu->getParam2()."&IS_PHOTO_UPLOAD=true&PHOTO_ID=".$v['PHOTO_ID']."&action=DELETE&type=map&PROPERTY_ID=".$menu3->current_property_id."\">".
                              $smarty->deleteImage."</a>";
 }

 $element = &$form->getElement("PROP_DATE_PURCHASED");
 // create renderer
 $renderer = new HTML_QuickForm_Renderer_ArraySmarty($tpl);
 // generate code
 $form->accept($renderer);
 // send form data to Smarty
 $smarty->assign('action', $action);
 $smarty->assign('form_data', $renderer->toArray());
 $smarty->assign('num_units',  $prop_num_units);
 $smarty->assign("header_title", $header_title);
 $smarty->assign("isEdit", ($isEdit) ? "true" : "false");
 $smarty->assign("script", /*$BULovData->display().*/
                           $StatesLovData->display()
                          .$StatusLovData->display()
                          .$form->getValidationScript()
                          .$validation_scripts
 );
 $smarty->assign('property_id', $menu3->current_property_id);
 $smarty->assign("PATH_FORM_ROOT", $GLOBALS["PATH_FORM_ROOT"]);
 $smarty->assign('doc_list', $doc_list);
 $smarty->assign('photos_list', $photo_list);
 
 $smarty->assign('prop_has_details', $prop_has_details);
 

 $advertise_next_onclick = (count($photo_list) == 0)
                         ? "onclick=\"var result=false;"
                          ." if (confirm('This property has no pictures. Do you want to continue?'))"
                          ." {"
                          ."     result = true; "
                          ." }"
                          ." return result;\""
                         : "";

 $advertise_photo_onclick = "onmouseover=\"formProp.submit();\"";

  // Next/Prior for advertising
 $smarty->assign("advertise_prev",
                 "<a href='?m2=ad_property_details' style='float: left;'>Previous Page - Property Details</a>");
 $smarty->assign("advertise_next",
                 "<a href='?m2=ad_tenancy_agreements' style='float: right;' $advertise_next_onclick>Next Page - Agreement Details</a>");
 $smarty->assign("advertise_photo",
                 "<a href='?m2=ad_property_details&type=map' style='float: right;' $advertise_photo_onclick>Next Page - Upload Photos</a>");


 // passed array of names for dates
 if ($isEdit)
    $smarty->assign("dates", $dates_elements);
 else
    $smarty->assign("dates", array());

?>
