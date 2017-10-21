<?
 require_once dirname(__FILE__)."/config_menu.php";
/************************************************************
*
*     Initial parameter for database
*
**************************************************************/
if (1)
{
// database user
define("DB_USER", "rntmgr");
// Localhost
define("DB_PASS", "rntmgr");
define("DB_TNS", "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=centos-pc)
       (PORT=1521))(CONNECT_DATA=(SERVER=POOLED)(SERVICE_NAME=vis11)))");
       
date_default_timezone_set('America/New_York');

// Absolute path for root of application
$GLOBALS["PATH_FORM_ROOT"] = "http://centos-pc/rental/";
$GLOBALS["HTTP_PATH_FROM_ROOT"] = "http://centos-pc/";

// Upload file directory without slash at the end
define('UPLOAD_DIR', '/usr/local/zend/upload_files');
// Access via HTTP to upload file directory without slash at the end
define('UPLOAD_URL', 'http://centos-pc/upload_files');
// Spreadsheet template's file directory without slash at the end
define('TEMPLATE_DIR', '/home/simon/visulate/visulate/code/php/template_files');
}

$CONFIG_ALLOWED_PHOTO_EXTENSIONS = array('jpg', 'jpeg', 'gif', 'png', 'bmp');
define("THUMBNAIL_PHOTO_MAX_SIZE", 150);
define("VGA_PHOTO_MAX_SIZE", 640);

// Allowed spreadsheet extensions
$CONFIG_ALLOWED_SPREADSHEET_EXTENSIONS = array('xls', 'xlsx');

//
define('MAINTENANCE_MODE', 'N');

//
ini_set('session.name', 'PHPSESSID_DEV');
?>

