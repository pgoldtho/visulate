<?php
 require_once dirname(__FILE__)."/../classes/SmartyInit.class.php";
 require_once dirname(__FILE__)."/../classes/SQLExceptionMessage.class.php";
 require_once dirname(__FILE__)."/../classes/database/rnt_menus.class.php";

Class Menu_Controller
{
    private $smarty;
    
    function __construct()
    {
        $this->smarty = new SmartyInit();
    }
    
    public function getErrMsg($e)
    {
        $de =  new DatabaseError($this->smarty->connection);
        return $de->getErrorFromException($e);
    }
    
    public function save($post_data)
    {
        // adapt post array
        $menu_pattern = "/MENU\[(.*)\]\[(.*)\]/";
        $menu_items_pattern = "/MENU_ITEMS\[(.*)\]\[(.*)\]/";
        
        $menus = array();
        $menu_items = array();
        foreach($post_data as $key=>$value)
        {
            preg_match($menu_pattern, $key, $menu_matches);
            list($menu_key, $k1, $k2) = $menu_matches;
            if ($menu_key) {
                $menus[$k1][$k2] = $value;
            }
            
            preg_match($menu_items_pattern, $key, $menu_items_matches);
            list($menu_items_key, $k1, $k2) = $menu_items_matches;
            if ($menu_items_key) {
                $menu_items[$k1][$k2] = $value;
            }
        }
        
        $RNTMenu = new RNTMenu($this->smarty->connection);
        $RNTMenu->saveMenusL3($menus);
        $RNTMenu->saveMenuItemsL3($menu_items);        
    }
    
    public function delete_menu($post_data)
    {
        // adapt post array
        $pattern = "/\[(.*)\]\[(.*)\]/";
        $data = array();
        foreach($post_data as $key=>$value)
        {
            preg_match($pattern, $key, $matches);
            $key = $matches[2];
            if ($key) {
                $data[$key] = $value;
            }
        }
        
        $RNTMenu = new RNTMenu($this->smarty->connection);
        $RNTMenu->deleteMenuL3($data);
    }

    public function delete_menu_item($post_data)
    {
        // adapt post array
        $pattern = "/\[(.*)\]\[(.*)\]/";
        $data = array();
        foreach($post_data as $key=>$value)
        {
            preg_match($pattern, $key, $matches);
            $key = $matches[2];
            if ($key) {
                $data[$key] = $value;
            }
        }
        
        $RNTMenu = new RNTMenu($this->smarty->connection);
        $RNTMenu->deleteMenuItemL3($data);
    }
    
    public function menu_html($tab_name)
    {
        $result = "";
        if (empty($tab_name)) {
            return $result;    
        }
        
        $RNTMenu = new RNTMenu($this->smarty->connection);
        $menus   = $RNTMenu->getMenuL3($tab_name);
        $menus[] = array("TAB_NAME"=>$tab_name);
        ob_start();
?>
        <table class="datatable" cellpadding="0" cellspacing="0" onclick="highlight_row(arguments[0]); refresh_menu_items();">
          <tr id="highlight_ignore">
            <th>Display Seq.</th>
            <th>Menu Name</th>
            <th>Menu Title</th>
            <th>&nbsp;</th>
          </tr>
<?php   foreach ($menus as $k=>$menu) { 
          $menu_items = $RNTMenu->getMenuItemsL3($menu["TAB_NAME"], $menu["MENU_NAME"]);
          $has_items  = ! empty($menu_items);
?>
          <tr>
            <td>
              <input type="text" size="7" name="MENU[<?php echo $k;?>][DISPLAY_SEQ]" value="<?php echo $menu["DISPLAY_SEQ"]?>"> 
            </td>
            <td>
<?php     $disabled = empty($menu["MENU_NAME"]) ? "" : "disabled"; ?>
              <input type="text" name="MENU[<?php echo $k;?>][MENU_NAME]" value="<?php echo $menu["MENU_NAME"]?>" <?php echo $disabled;?> > 
            </td>
            <td>
              <input type="text" size="60" name="MENU[<?php echo $k;?>][MENU_TITLE]" value="<?php echo $menu["MENU_TITLE"]?>"> 
              
              <input type="hidden" name="MENU[<?php echo $k;?>][TAB_NAME]" value="<?php echo $menu["TAB_NAME"]?>"> 
              <input type="hidden" name="MENU[<?php echo $k;?>][CHECKSUM]" value="<?php echo $menu["CHECKSUM"]?>"> 
            </td>
            <td>
<?php     if ($menu["CHECKSUM"] && (!$has_items)) { ?>
              <a href="#" onclick="delete_menu(this); return false;">Delete</a>
<?php     } ?>              
            </td>
          </tr>
<?php   } ?>
        </table>
<?php     
        $result = ob_get_contents();
        ob_end_clean();
        
        return $result;
    }
    
    public function items_html($tab_name, $menu_name)
    {
        $result = "";
        if (empty($tab_name) || empty($menu_name)) {
            return $result;    
        }
        
        $RNTMenu = new RNTMenu($this->smarty->connection);
        $menu_items = $RNTMenu->getMenuItemsL3($tab_name, $menu_name);
        $menu_items[] = array("TAB_NAME"=>$tab_name, "MENU_NAME"=>$menu_name);
     
        ob_start();
?> 
        <table class="datatable" cellpadding="0" cellspacing="0">
          <tr id="highlight_ignore">
            <th>Display Seq.</th>
            <th>Type</th>
            <th>Attributes</th>
            <th>&nbsp;</th>
          </tr>
<?php   foreach ($menu_items as $k=>$item) { ?>
          <tr>
            <td>
              <input type="text" size="7" name="MENU_ITEMS[<?php echo $k;?>][DISPLAY_SEQ]" value="<?php echo $item["DISPLAY_SEQ"];?>"> 
            </td>
            <td>
<?php     if (! empty($item["PAGE_NAME"])) { ?>
              Page
<?php     } elseif(! empty($item["LINK_TITLE"])) {?>
              Link
<?php     } else {?>
              <select name="menu_type" onchange="set_menu_element_attrs(this, this.value);">";
                <option value="" selected>-Select-</option>";
                <option value="link_attrs">Link</option>";
                <option value="page_attrs">Page</option>";
              </select>
<?php     }?>
            </td>
            <td>
<?php     $page_items_style = "display:none;";
          $link_items_style = "display:none;";
          if (! empty($item["PAGE_NAME"])) {
              $page_items_style = "display:block;";
          } elseif(! empty($item["LINK_TITLE"])) {
              $link_items_style = "display:block;";
          } else {
          } ?>
              <table id="page_attrs" class="datatable1" style="margin-bottom:0px;<?php echo $page_items_style;?>" width="100%">
                <tr>
                  <th>Name</th>
                  <td><input type="text" size="20" name="MENU_ITEMS[<?php echo $k;?>][PAGE_NAME]" value="<?php echo $item["PAGE_NAME"];?>"> </td>
                  <th>Sub Page</th>
                  <td><input type="text" size="20" name="MENU_ITEMS[<?php echo $k;?>][SUB_PAGE]" value="<?php echo $item["SUB_PAGE"];?>"> </td>
                  <th>Title</th>
                  <td><input type="text" size="20" name="MENU_ITEMS[<?php echo $k;?>][PAGE_TITLE]" value="<?php echo $item["PAGE_TITLE"];?>"></td>
                </tr>
              </table>
              <table id="link_attrs" class="datatable1" style="margin-bottom:0px;<?php echo $link_items_style;?>" width="100%">
                <tr>
                  <th>Title</th>
                  <td><input type="text" size="20" name="MENU_ITEMS[<?php echo $k;?>][LINK_TITLE]" value="<?php echo $item["LINK_TITLE"];?>"> </td>
                  <th>URL</th>
                  <td><input type="text" size="60" name="MENU_ITEMS[<?php echo $k;?>][LINK_URL]" value="<?php echo $item["LINK_URL"];?>"> </td>
                </tr>
              </table>

              <input type="hidden" name="MENU_ITEMS[<?php echo $k;?>][MENU_NAME]" value="<?php echo $item["MENU_NAME"];?>"> 
              <input type="hidden" name="MENU_ITEMS[<?php echo $k;?>][TAB_NAME]"  value="<?php echo $item["TAB_NAME"];?>"> 
              <input type="hidden" name="MENU_ITEMS[<?php echo $k;?>][CHECKSUM]"  value="<?php echo $item["CHECKSUM"];?>"> 
            </td>
            <td>
<?php     if ($item["CHECKSUM"]) { ?>
              <a href="#" onclick="delete_menu_item(this); return false;">Delete</a>
<?php     } ?>              
            </td>
          </tr>
<?php   } ?>
        </table>  
<?php           
        $result = ob_get_contents();
        ob_end_clean();
        
        return $result;
    }
}

$menu = new Menu_Controller();
if ($_POST["json"]) {
    $post_data = json_decode($_POST["json"], true);
    $action    = strtoupper($post_data["action"]);
    
    $err = "";
    try {
        if ($action == "DELETE_MENU") {
            $menu->delete_menu($post_data);
        }
        elseif ($action == "DELETE_MENU_ELEMENT") {
            $menu->delete_menu_item($post_data);
        }
        elseif ($action == "SAVE_DATA") {
            $menu->save($post_data);    
        }   
    } catch (SQLException $e) {
        $err = $menu->getErrMsg($e);
    } catch (Exception $e) {
        $err = $e->getMessage();
    }
    echo json_encode(array("errmsg"=>$err)); 
} else {
    $menus_html = $menu->menu_html($_POST["tab_name"]);
    $menu_items_html = $menu->items_html($_POST["tab_name"], $_POST["menu_name"]);
    $result = array("menus_html"=>$menus_html, "menu_items_html"=>$menu_items_html);
    echo json_encode($result);
}
?>