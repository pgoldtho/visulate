<?
require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
require_once dirname(__FILE__)."/../SQLExceptionMessage.class.php";
require_once dirname(__FILE__)."/rnt_base.class.php";

require_once dirname(__FILE__)."/rnt_menu_pages.class.php";
require_once dirname(__FILE__)."/rnt_menu_links.class.php";

class RNTMenu extends RNTBase
{
    public function __construct($connection)
    {
        parent::__construct($connection);
    }

    /**
     * Retrive tab roles
     *
     * @param  string  $tab_name
     * @return array   tab roles
     */
    private function getConfigMenuRoles($tab_name)
    {
        $result = array();

        $query = "select ur.role_code
                  from   rnt_menu_roles_v mr,
                         rnt_user_roles   ur
                  where  mr.role_id  = ur.role_id
                  and    mr.tab_name = :var1
                  order  by ur.role_code";
        $stmt  = $this->connection->prepareStatement($query);

        $stmt->setString(1, $tab_name);
        $rs    = $stmt->executeQuery();

        while($rs->next()) {
            $r = $rs->getRow();
            $result[] = $r["ROLE_CODE"];
        }
        $rs->close();

        return $result;
    }


    /**
     * Build config menu tabs
     *
     * @param  string $root_tab  - one from {'pc', 'mobi'}
     * @return array  config menu of tabs
     */
    private function buildConfigMenu($root_tab)
    {
        $result = array();
        $query = "select tab_name, tab_title, parent_tab,
                         'L'||(level - 1) as tab_type,
                         level - 1 as level_menu,
                         display_seq, tab_href, checksum,
                         sys_connect_by_path(tab_title, '->') as path,
                         connect_by_isleaf as is_leaf
                  from    rnt_menu_tabs_v
                  start   with     parent_tab = :var1
                  connect by prior tab_name   = parent_tab
                  order   siblings by display_seq";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $root_tab);
        $rs   = $stmt->executeQuery();

        $tab = "";
        while($rs->next()) {
            $r = $rs->getRow();

            $roles = $this->getConfigMenuRoles($r["TAB_NAME"]);

            if ($tab != $r["PARENT_TAB"]) {
                $tab = $r["TAB_NAME"];
                $result["$tab"] = array(
                    "title" => $r["TAB_TITLE"],
                    "href"  => $r["TAB_HREF"],
                    "role"  => $roles,
                    "items" => array()
                );
            } else {
                $page = $r["TAB_NAME"];
                $result["$tab"]["items"]["$page"] = array(
                    "title" => $r["TAB_TITLE"],
                    "href"  => $r["TAB_HREF"],
                    "role"  => $roles
                );
            }
        }
        $rs->close();

        return $result;
    }


    /**
     * Build config menu tabs for PC
     *
     * @return array config menu tabs
     */
    public function getConfigMenuPC()
    {
        return $this->buildConfigMenu('pc');
    }


    /**
     * Build config menu tabs for mobile
     *
     * @return array config menu tabs
     */
    public function getConfigMenuMobi()
    {
        return $this->buildConfigMenu('mobi');
    }

    public function getPHPfilename($tab_name)
    {
        $result = 'dbcontent.php';

        $query = "select tab_href
                  from   rnt_menu_tabs_v
                  where  tab_name  = :var1 ";
        $stmt  = $this->connection->prepareStatement($query);

        $stmt->setString(1, $tab_name);
        $rs    = $stmt->executeQuery();

        if($rs->next()) {
           $r = $rs->getRow();
           $result = $r["TAB_HREF"];
        }
        $rs->close();

        return $result;
    }

    /**
     * Build tree of menu tabs
     *
     * @return  array  tree of menu tabs
     */
    public function getTreeForAdmin()
    {
        $result = array();

        $query = "select tab_name, to_char(display_seq)||' '||tab_title as tab_title,
                         parent_tab, 'L'||(level - 1) as tab_type,
                         level - 1 as level_menu,
                         display_seq, tab_href, checksum,
                         sys_connect_by_path(tab_title, '->') as path,
                         connect_by_isleaf as is_leaf
                  from    rnt_menu_tabs_v
                  start   with     parent_tab is null
                  connect by prior tab_name = parent_tab
                  order   siblings by display_seq";
        $stmt  = $this->connection->prepareStatement($query);
        $rs    = $stmt->executeQuery();

        while($rs->next()) {
            $r = $rs->getRow();
            $result[] = $r;
        }
        $rs->close();

        return $result;
    }

    /**
     * Retrive tab menu types
     *
     * @return array list of tab menu types
     */
    public function getTabTypeList()
    {
        $query = "select 'L1' as code, 'Level 1 Tab' as value from dual union
                  select 'L2' as code, 'Level 2 Tab' as value from dual";
        //
        $lov = new DBLov($this->connection);
        return $lov->HTMLSelectArray($query, true);
    }

    /**
     * Retrive list of parent tabs
     *
     * @return array  format: array("CODE"=>"VALUE")
     */
    public function getParentTabList()
    {
        $query = "select tab_name as CODE , path as VALUE
                  from   (select tab_name, tab_title, parent_tab,
                                 'L'||(level - 1) as tab_type,
                                 level - 1 as level_menu,
                                 display_seq, tab_href, checksum,
                                 sys_connect_by_path(tab_title, '->') as path,
                                 connect_by_isleaf as is_leaf
                          from    rnt_menu_tabs_v
                          start   with     parent_tab is null
                          connect by prior tab_name = parent_tab
                          order   siblings by display_seq)";
       //
       $lov   = new DBLov($this->connection);
       return $lov->HTMLSelectArray($query, false);
    }


    /**
     * Retrive menu tab information
     *
     * @param  string $tab_name
     * @return array  tab information
     */
    public function getTabInfo($tab_name) {
        $result = array();

        if (empty($tab_name)) {
            return $result;
        }

        $query = "select tab_name, tab_title, parent_tab, tab_type,
                         display_seq, tab_href, checksum,
                         path, is_leaf
                  from   (select tab_name, tab_title, parent_tab,
                                 'L'||(level - 1) as tab_type,
                                 level - 1 as level_menu,
                                 display_seq, tab_href, checksum,
                                 sys_connect_by_path(tab_title, '->') as path,
                                 connect_by_isleaf as is_leaf
                          from    rnt_menu_tabs_v
                          start   with     parent_tab is null
                          connect by prior tab_name = parent_tab
                          order   siblings by display_seq
                         )
                  where  tab_name = :var1";
        $stmt  = $this->connection->prepareStatement($query);

        $stmt->setString(1, $tab_name);
        $rs  = $stmt->executeQuery();

        if ($rs->next()) {
            $result = $rs->getRow();
        }
        $rs->close();

        return $result;
    }


    /**
     * Retrive tab roles information
     *
     * @param  string $tab_name
     * @return array  tab's roles
     */
    public function getTabRoles($tab_name) {
        $result = array();

        $query = "select ur.role_id, ur.role_code, ur.role_name,
                         decode(mr.role_id, null, 'N','Y') as is_allowed_yn,
                         mr.checksum
                  from   rnt_menu_roles_v mr,
                         rnt_user_roles   ur
                  where  mr.role_id  (+)= ur.role_id
                  and    mr.tab_name (+)= :var1
                  order  by ur.role_code";
        $stmt  = $this->connection->prepareStatement($query);

        $stmt->setString(1, $tab_name);
        $rs    = $stmt->executeQuery();

        while($rs->next()) {
            $result[] = $rs->getRow();
        }
        $rs->close();

        return $result;
    }


    /**
     * Save menu tab data
     *
     * @param  array $tab_data
     * @return bool  true  - if operation successfully completed
     *               false - in otherwise
     */
    private function saveMenuTab($tab_data)
    {
        if (empty($tab_data)) {
            return false;
        }

        $operation = empty($tab_data["CHECKSUM"])
                   ? RNTBase::INSERT_ROW : RNTBase::UPDATE_ROW;

        // construct DML operation
        $statement = "";

        if ($operation == RNTBase::UPDATE_ROW) {
            $statement = "begin RNT_MENU_TABS_PKG.UPDATE_ROW(";
        }
        else if ($operation == RNTBase::INSERT_ROW) {
            $statement = "begin RNT_MENU_TABS_PKG.INSERT_ROW(";
        }

        $statement .= "X_TAB_NAME    => :var1"
                   .", X_TAB_TITLE   => :var2"
                   .", X_PARENT_TAB  => :var3"
                   .", X_DISPLAY_SEQ => :var4"
                   .", X_TAB_HREF    => :var5";

        if ($operation == RNTBase::UPDATE_ROW) {
            $statement .= ", X_CHECKSUM => :var6";
        }
        $statement .= "); end;";

        // prepare DML operation
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setString(1, $tab_data["TAB_NAME"]);
        $prepare->setString(2, $tab_data["TAB_TITLE"]);
        $prepare->setString(3, $tab_data["PARENT_TAB"]);
        $prepare->set(4, $tab_data["DISPLAY_SEQ"]);
        $prepare->setString(5, $tab_data["TAB_HREF"]);

        if ($operation == RNTBase::UPDATE_ROW) {
            $prepare->setString(6, $tab_data["CHECKSUM"]);
        }

        // execute DML operation
        @$prepare->executeUpdate();

        return true;
    }


    /**
     * Save menu tab roles data
     *
     * @param  string $tab_name
     * @param  array  $tab_roles
     * @return bool
     */
    private function saveMenuTabRole($tab_name, $tab_role)
    {
        if (empty($tab_role) || empty($tab_name)) {
            return false;
        }

        // construct DML operation
        $statement = null;
        if ($tab_role["IS_ALLOWED_YN"] == 1) {
            if (empty($tab_role["CHECKSUM"]))
            {
                $statement = "begin "
                           . "    RNT_MENU_ROLES_PKG.INSERT_ROW( "
                           . "        X_TAB_NAME => :var1, "
                           . "        X_ROLE_ID  => :var2 "
                           . "    ); "
                           . "end;";
            }
        } else {
            $statement = "begin "
                       . "    RNT_MENU_ROLES_PKG.DELETE_ROW( "
                       . "        X_TAB_NAME => :var1, "
                       . "        X_ROLE_ID  => :var2 "
                       . "    ); "
                       . "end;";
        }


        if (! empty($statement)) {
            // prepare DML operation
            $prepare = $this->connection->prepareStatement($statement);
            $prepare->setString(1, $tab_name);
            $prepare->setInt(2, $tab_role["ROLE_ID"]);

            // execute DML operation
            @$prepare->executeUpdate();
        }

        return true;
    }


    /**
     * Update menu
     *
     * @param unknown_type $values
     */
    public function Update(&$values)
    {
        $tab_data  = array("TAB_NAME"    => $values["TAB_NAME"],
                           "TAB_TITLE"   => $values["TAB_TITLE"],
                           "PARENT_TAB"  => $values["PARENT_TAB"],
                           "DISPLAY_SEQ" => $values["DISPLAY_SEQ"],
                           "TAB_HREF"    => $values["TAB_HREF"],
                           "CHECKSUM"    => $values["CHECKSUM"]);
        $tab_roles = $values["TAB_ROLES"];
 
        $this->saveMenuTab($tab_data);
        
        foreach ($tab_roles as $role) {
            $this->saveMenuTabRole($tab_data["TAB_NAME"], $role);
        }
    }


    /**
     * Check subordinate elements on tab
     *
     * @param  string  $tab_name
     * @return bool    true  - if tab has subordinate elements
     *                 false - in otherwise
     */
    private function has_subordinate_tabs($tab_name)
    {
        $result = false;
        
        $query = "select 1 as has_details  from rnt_menu_tabs_v t 
                  where  t.PARENT_TAB = :var1
                  union
                  select 1 as has_details  from rnt_menus_v m 
                  where  m.TAB_NAME   = :var1";
        
        $stmt  = $this->connection->prepareStatement($query);
        $stmt->setString(1, $tab_name);
        $rs    = $stmt->executeQuery();
        
        if ($rs->next()) {
            $result = true;
        }
        $rs->close();
        
        return $result;
    }


    /**
     * Delete menu
     *
     * @param unknown_type $id
     */
    public function Delete($tab_name)
    {
        if (empty($tab_name)) {
            return;
        }

        $has_subtabs = $this->has_subordinate_tabs($tab_name);
        if ($has_subtabs) {
            throw new Exception("Cann't delete tab. Tab has subordinates.");
        }
        
        // Steps:
        // 1. delete tab roles
        // 2. delete tab
        $sql  = "begin "
              . "    DELETE FROM rnt_menu_roles WHERE tab_name = :var1; "
              . "    "
              . "    RNT_MENU_TABS_PKG.delete_row(X_TAB_NAME  => :var1); "
              . "end;";
        $stmt = $this->connection->prepareStatement($sql);
        $stmt->setString(1, $tab_name);
        
        $rs   = $stmt->executeUpdate();
    }


    /**
     * Retrive navigation menu tree for public part of project
     *
     * @param  string $tab_name
     * @return array  menu tree
     */
    public function getTreeMenuL3($tab_name)
    {
        $result = array();

        $query = "select tab_name, menu, parent_menu,
                         title, href, display_seq,
                         level as level_menu,
                         type_menu
                  from   (select tab_name,
                                 menu_name     as menu,
                                 to_char(null) as parent_menu,
                                 menu_title    as title,
                                 to_char(null) as href,
                                 display_seq,
                                 'menu' as type_menu
                          from   rnt_menus_v
                          union
                          select tab_name,
                                 link_title as menu,
                                 menu_name  as parent_menu,
                                 link_title as title,
                                 link_url   as href,
                                 display_seq,
                                 'link' as type_menu
                          from   rnt_menu_links
                          union
                          select tab_name, menu, parent_menu,
                                 title, href, display_seq, 'page' as type_menu
                          from   (select tab_name,
                                         sub_page   as menu,
                                         menu_name  as parent_menu,
                                         page_title as title,
                                         '?m2='||tab_name||'&'||
                                         'menu='||menu_name||'&'||
                                         'page='||page_name||'&'||
                                         'subpage='||sub_page  as href,
                                         display_seq,
                                         row_number() over (partition by tab_name, page_name
                                                            order by display_seq) as rnum
                                  from   rnt_menu_pages)
                          where  rnum = 1
                         ) x
                  start   with   parent_menu is null 
                          and    tab_name = :var1
                  connect by prior menu = parent_menu
                          and    tab_name = :var1
                  order   siblings by display_seq";
        $stmt  = $this->connection->prepareStatement($query);
        $stmt->setString(1, $tab_name);
        $rs    = $stmt->executeQuery();

        while($rs->next()) {
            $r = $rs->getRow();
            $result[] = $r;
        }
        $rs->close();

        return $result;
    }
    
    /**
     * Retrive menu level 3 data for admin
     *
     * @param  string $tab_name
     * @return array  menus level 3 data
     */
    public function getMenuL3($tab_name)
    {
        $result = array();

        $query = "select tab_name, menu_name, menu_title, display_seq, checksum
                  from   rnt_menus_v
                  where  tab_name = :var1
                  order  by display_seq";
        
        $stmt  = $this->connection->prepareStatement($query);
        $stmt->setString(1, $tab_name);
        $rs    = $stmt->executeQuery();

        while($rs->next()) {
            $r = $rs->getRow();
            $result[] = $r;
        }
        $rs->close();

        return $result;
    }
    
    /**
     * Retrive menu level 3 elements - links and pages
     *
     * @param  string $tab_name
     * @param  string $menu_name
     * @return array
     */
    public function getMenuItemsL3($tab_name, $menu_name)
    {
        $result = array();

        $query = "select tab_name, menu_name, display_seq, 
                         page_name, sub_page, page_title, 
                         link_title, link_url,
                         checksum
                  from   (select tab_name, menu_name, display_seq, 
                                 page_name, sub_page, page_title, 
                                 to_char(null) as link_title, to_char(null) as link_url,
                                 checksum  
                          from   rnt_menu_pages_v
                          union
                          select tab_name, menu_name, display_seq,
                                 to_char(null) as page_name, to_char(null) as sub_page, to_char(null) as page_title,
                                 link_title, link_url,
                                 checksum 
                          from   rnt_menu_links_v
                         ) x
                  where  tab_name  = :var1
                  and    menu_name = :var2
                  order  by display_seq";
        
        $stmt  = $this->connection->prepareStatement($query);
        $stmt->setString(1, $tab_name);
        $stmt->setString(2, $menu_name);
        $rs    = $stmt->executeQuery();

        while($rs->next()) {
            $r = $rs->getRow();
            $result[] = $r;
        }
        $rs->close();

        return $result;
    }
    
    /**
     * Save (update/add) menus information 
     *
     * @param array $values  an array with menus information
     */
    public function saveMenusL3($values)
    {
        foreach($values as $key=>$menu)
        {
            $failed_data = empty($menu["TAB_NAME"])
                        || empty($menu["MENU_NAME"])
                        || empty($menu["MENU_TITLE"]);
                     
            if (! $failed_data) {
                // construct DML operation
                $statement = "begin RNT_MENUS_PKG.INSERT_ROW(";
                if (! empty($menu["CHECKSUM"])) {
                    $statement = "begin RNT_MENUS_PKG.UPDATE_ROW(";
                }
            
                $statement .= "  X_TAB_NAME    => :var1 "
                           .  ", X_MENU_NAME   => :var2 "
                           .  ", X_MENU_TITLE  => :var3 "
                           .  ", X_DISPLAY_SEQ => :var4 ";
                       
                if (! empty($menu["CHECKSUM"])) {
                    $statement .= ", X_CHECKSUM    => :var5 ";
                }
                $statement .= "); end;";
        
                // prepare DML operation
                $prepare = $this->connection->prepareStatement($statement);
                $prepare->setString(1, $menu["TAB_NAME"]);
                $prepare->setString(2, $menu["MENU_NAME"]);
                $prepare->setString(3, $menu["MENU_TITLE"]);
                $prepare->set(4, $menu["DISPLAY_SEQ"]);
                if (! empty($menu["CHECKSUM"])) {
                    $prepare->setString(5, $menu["CHECKSUM"]);
                }

                // execute DML operation
                @$prepare->executeUpdate();
            }
        }
    }

    /**
     * Delete menu level 3
     *
     * @param  array   $values  menu level 3 data
     */
    public function deleteMenuL3($values)
    {
        $failed_data = empty($menu["TAB_NAME"]) || empty($menu["MENU_NAME"]);
                     
        if (! $failed_data) {
            return;
        }
        
        //TODO: check details
        //      do not delete if exists pages or links
        
        // construct DML operation
        $statement = "begin "
                   . " RNT_MENUS_PKG.DELETE_ROW("
                   . "     X_TAB_NAME    => :var1 "
                   . "   , X_MENU_NAME   => :var2 "
                   . " ); end;";
        
        // prepare DML operation
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setString(1, $values["TAB_NAME"]);
        $prepare->setString(2, $values["MENU_NAME"]);

        // execute DML operation
        @$prepare->executeUpdate();
    }
    
    /**
     * Save (update/add) menus items information 
     *
     * @param array $values  an array with menus items information
     */
    public function saveMenuItemsL3($values)
    {
        foreach($values as $key=>$menu_item)
        {
            // check item type
            $type = !empty($menu_item["PAGE_NAME"]) ? "PAGE" : "LINK";
            if ($type == 'PAGE') {
                $RNTMenuPages = new RNTMenuPages($this->connection);
                $RNTMenuPages->save($menu_item);
            } elseif ($type == 'LINK') {
                $RNTMenuLinks = new RNTMenuLinks($this->connection);
                $RNTMenuLinks->save($menu_item);
            }
        }
    }
        
    /**
     * Delete item (link or page) of menu level 3
     *
     * @param  array   $values  item data of menu level 3
     */
    public function deleteMenuItemL3($values)
    {
        // check item type
        $type = !empty($values["PAGE_NAME"]) ? "PAGE" : "LINK";
        if ($type == 'PAGE') {
            $RNTMenuPages = new RNTMenuPages($this->connection);
            $RNTMenuPages->delete($values);
        } elseif ($type == 'LINK') {
            $RNTMenuLinks = new RNTMenuLinks($this->connection);
            $RNTMenuLinks->delete($values);
        }
    }

}
?>