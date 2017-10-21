<?php
require_once 'Smarty.class.php';
require_once 'creole/Creole.php';
require_once dirname(__FILE__).'/config.php';
require_once dirname(__FILE__).'/User.class.php';
require_once dirname(__FILE__).'/Context.class.php';
require_once dirname(__FILE__)."/DatabaseError.class.php";
require_once dirname(__FILE__)."/LovData.class.php";


function is_mobile_browser(){
  $useragent=$_SERVER['HTTP_USER_AGENT'];
  $mobile_browser = false;
  // go to  http://detectmobilebrowser.com/ to download the latest version of this test

if(preg_match('/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i',$useragent)||preg_match('/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i',substr($useragent,0,4)))
  {$mobile_browser = true;}
  //$mobile_browser = true;
  return $mobile_browser;
}

function is_rest_request(){
  $rest_request = false;
  foreach (getallheaders() as $name => $value) {
    if (($name == "X-Data-Type") && ($value == "application/json")) {$rest_request = true;}
   }
  return $rest_request;
}

function to_log($e, $smarty){
    $uInfo = $smarty->user->getUserInfo();
    $x = $smarty->user->getUserID() ==User::NO_LOGIN ? "User >>> Anonymous" :
         "User >>>\nID=".$uInfo["USER_ID"].", LOGIN=".$uInfo["USER_LOGIN"].", ROLE=".$smarty->user->getRole().
         "\nMessage >>>\n".
         $e->getMessage().
         "\nStack >>>\n".$e->getTraceAsString()."\n".
         "-------------------------------------------------------------------------------------------------------\n\n";
    $filename = dirname(__FILE__)."/../error.log";
    $f = fopen($filename, 'a+');
    fputs($f, $x);
    fclose($f);
}
/*
    Accept next parameters:
      form - form name
      elements - names of form elements
      current - current element name
*/
function smarty_show_calendar($params)
{
  if (in_array($params["current"], $params["elements"]))
  // its $params["form"]
  //  return "<a href=\"javascript: void(0);\" onmouseover=\"if (timeoutId) clearTimeout(timeoutId);window.status='Show Calendar';return true;\" onmouseout=\"if (timeoutDelay) calendarTimeout();window.status='';\" onclick=\"g_Calendar.show(event,'".$params["current"]."',true,'mm/dd/yyyy'); return false;\"><img src=\"images/calendar.gif\" name=\"imgCalendar\" width=\"34\" height=\"21\" border=\"0\" alt=\"\" class=\"nomargin\"></a>";
  return "<script type=\"text/javascript\">{jQuery('input[name=\"".$params["current"]."\"]').datepicker();}</script>";
}

/*
    Accept next parameters:
      number - a number that must convert to string
*/
function smarty_show_number($params)
{
    $result = "";
    if (isset($params["number"]))
    {
        $result = number_format($params["number"], 2, '.', ',');
    }

    return $result;
}

/**
 * Enter description here...
 *
 * @param  array  $current  hierarchical query result's row
 * @return string formated string
 */
function treeFunc($current)
{
	// the previous row's level, or null on the first row
	global $last;
	
	// structural elements
	$openItem  = '<li>';
	$closeItem = '</li>';
	$openChildren  = '<ul>';
	$closeChildren = '</ul>';
	
	$icon = ($current['IS_LEAF'] == 1) ? 'file' : 'folder';
	$structure = "";
	
	if( !isset( $current['LEVEL_MENU'] ) ){
		// add closing structure(s) equal to the very last
		// row's level; this will only fire for the "dummy"
		return str_repeat($closeItem.$closeChildren, $last);
	}
	
	// add the item itself
	$href = '?m2=admin_menus&TAB_NAME='.$current['TAB_NAME'];
    $item = "<span class='$icon'><a href='$href'>".$current["TAB_TITLE"]."</a></span>";
	
	if ( is_null( $last ) ) {
		// add the opening structure in the case of the first row
		$structure .= "<ul id='browser'>"; //$openChildren; 
	} elseif ( $last < $current['LEVEL_MENU'] ) {
		// add the structure to start new branches
		$structure .= $openChildren;
	} elseif ( $last > $current['LEVEL_MENU'] ){
		// add the structure to close branches equal to the 
		// difference between the previous and current levels
		$structure .= $closeItem
		           .  str_repeat($closeChildren.$closeItem, 
		                         $last - $current['LEVEL_MENU']);
	} else {
		$structure .= $closeItem;
	}
	
	// add the item structure
	$structure .= $openItem;
	
	// update $last so the next row knows whether this row is really its parent
	$last = $current['LEVEL_MENU'];
	
	return $structure.$item;
}


/**
 * Show tree as "list with <ul><li>..."
 *
 * @param   array   $params - array with keys "LEVEL_MENU" and "TAB_TITLE"
 * @return  string  <ul><li> tree structure
 */
function smarty_show_tree($params)
{
    $result = "";
    
    $data = $params["data"];
    if (empty($data))
    {
        return $result;
    }
    
    // you need this value accessible inside the formatting 
    // function; in an object-oriented approach, this can
    // be a class variable
    global $last;

    // set a value not possible in a LEVEL column to allow the 
    // first row to know it's "firstness"
    $last = null;
    
    // add a dummy "row" to cap off formatting
    $data[] = array();
    
    // invoke our formatting function via callback
    $formatted = array_map("treeFunc", $data);
    $result    = implode("\n", $formatted);
    
    //return the result
    return $result;
}

/**
 * Check position of first occurrence of a string
 *
 * @param  array    $params   parameters in format: [haystack, needle]
 * @return boolean
 */
function smarty_instr($params, &$smarty)
{
    $var      = $params["var"];
    $haystack = $params["haystack"];
    $needle   = $params["needle"];
    
    $pos      = strpos($haystack, $needle);
    // Note we use of !==
    $smarty->assign($var, ($pos !== false));
}

/*
   Acccept parameters:
      array("code" => ,
            "short" => ,
            "islong" => )
*/
function smarty_show_error($params)
{
    if (!$params["info"])
       return;
    $prefix = "Error :";
    if ($params["prefix"])
       $prefix = $params["prefix"];
    $class = "error";
    if ($params["class"])
      $class = $params["class"];
    $text = "<a name='".$params["info"]["code"]."'></a><p class=\"$class\"><b>$prefix</b> ".$params["info"]["short"];
     if ($params["info"]["islong"] == "Y")
       $text .= " <a class=\"error\" href=\"javascript:void(0);\" onclick=\"window.open('".$GLOBALS["PATH_FORM_ROOT"]."/help/err/?code=".$params["info"]["code"]."', 'errlong', 'height=400,width=600,status=no,toolbar=no,menubar=no,location=no');\">Details</a>";
    $text .= "</p>";
    return $text;
}

/*
  $params["href"]
*/
function smarty_delete_link($params)
{
   return "<a href=\"".$params["href"]."\" onclick=\"return confirm('Delete this record?');\"></a>";
}

function get_basepath(){
 $m = array();
 preg_match("/https?:\/\/[^\/]+/", $GLOBALS["PATH_FORM_ROOT"], $m);
 $basepath = $m[0];
 return $basepath;
}

class SmartyInit extends Smarty {
   public $deleteImage = "<img border=\"0\" width=\"14\" height=\"14\" src=\"images/delete.gif\">";
   public $deleteAttr = array("onclick"=>"return confirm('Delete this record?');", 'class' => 'nomargin');
   public $connection;
   public $user;

   function SmartyInit($protocol="https")
   {
        $this->Smarty();

        // ---- start parameter for debugging
//        $this->debugging = true;
        // ---- end parameter for debugging

        $dir = dirname(__FILE__)."/../_smarty/";
        $this->template_dir  = $dir.'templates/';
        $this->compile_dir   = $dir.'templates_c/';
        $this->config_dir    = $dir.'config/';
        $this->cache_dir     = $dir.'cache/';
        $this->plugins_dir[] = $dir.'plugins/';
//        define('SMARTY_PLUGINS_DIR', $dir.'plugins/');
//        define('SMARTY_TXT_IMG', dirname(__FILE__).'/../txt_img/');
        $this->caching = false;
        $this->assign('app_name', 'Visulate');
        // from config
        if ($protocol == 'http'){
          $this->assign('PATH_FROM_ROOT', $GLOBALS["HTTP_PATH_FROM_ROOT"]);
          }
        else{
          $this->assign('PATH_FROM_ROOT', $GLOBALS["PATH_FORM_ROOT"]);
          }

        $this->register_function("calendar", "smarty_show_calendar");
        $this->register_function("delete_link", "smarty_delete_link");
        $this->register_function("show_error", "smarty_show_error");

        $this->register_function("show_number", "smarty_show_number");

        $this->register_function("show_tree", "smarty_show_tree");
        
        $this->register_function("instr", "smarty_instr");

        // create database connection
        Creole::registerDriver("oracle", Creole::getDriver("oracle"));
        //$this->connection = Creole::getConnection("oracle://".DB_USER.":".DB_PASS."@".DB_HOST."/".DB_NAME);
		$this->connection = Creole::getConnection("oracle://".DB_USER.":".DB_PASS."@".DB_TNS);

        $this->user = new User($this->connection);
   }
}
?>