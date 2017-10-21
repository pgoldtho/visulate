<?php
require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
require_once dirname(__FILE__)."/rnt_base.class.php";

require_once 'creole/util/Clob.php';

class RNTMenuPages extends RNTBase
{
    public function __construct($connection)
    {
        parent::__construct($connection);
    }

    /**
     * Get menu's first page info
     *
     * @param  string $tab_name
     * @param  string $menu_name
     * @return array of menu's first page attributes
     */
    public function getFirstPage($tab_name, $menu_name)
    {

        $result = array();

        $query = "select tab_name, menu_name, page_name, sub_page,
                         page_title, display_seq, header_content, body_content
                  from   rnt_menu_pages_v
                  where  tab_name  = :var1
                  and    menu_name = :var2
                  order  by display_seq";
        $stmt  = $this->connection->prepareStatement($query);

        $stmt->setString(1, $tab_name);
        $stmt->setString(2, $menu_name);
        $rs    = $stmt->executeQuery();

        if($rs->next()) {
            $result = $rs->getRow();
        }
        
        $rs->close();

        return $result;
    }


    /**
     * Get sub pages for sub menu
     *
     * @param  string $tab_name
     * @param  string $menu_name
     * @param  string $page_name
     * @return array of sub pages
     */
    public function getSubPages($tab_name, $menu_name, $page_name)
    {
        $result = array();

        $query = "select tab_name, menu_name, page_name, sub_page,
                         page_title, display_seq, header_content, body_content
                  from   rnt_menu_pages_v
                  where  tab_name  = :var1
                  and    menu_name = :var2
                  and    page_name = :var3
                  order  by display_seq";
        $stmt  = $this->connection->prepareStatement($query);

        $stmt->setString(1, $tab_name);
        $stmt->setString(2, $menu_name);
        $stmt->setString(3, $page_name);
        $rs    = $stmt->executeQuery();

        while($rs->next()) {
            $r = $rs->getRow();
            $result[] = $r;
        }
        $rs->close();

        return $result;
    }


    /**
     * Get page info
     *
     * @param string $tab_name
     * @param string $menu_name
     * @param string $page_name
     * @param string $subpage
     * @return array of page attributes
     */
    public function getPage($tab_name, $menu_name, $page_name, $subpage)
    {
        $resulr = array();
        $query = "select p.tab_name, p.menu_name, p.page_name, p.sub_page,
                         p.page_title, p.display_seq, p.header_content, p.body_content,
                         p.header_content.extract('/head/*').getstringval() as extra_head
                         , p.checksum
                  from   rnt_menu_pages_v p
                  where  tab_name  = :var1
                  and    menu_name = :var2
                  and    page_name = :var3
                  and    sub_page  = :var4";
        $stmt  = $this->connection->prepareStatement($query);

        $stmt->setString(1, $tab_name);
        $stmt->setString(2, $menu_name);
        $stmt->setString(3, $page_name);
        $stmt->setString(4, $subpage);
        $rs    = $stmt->executeQuery();

        if ($rs->next()) {
            $result["TAB_NAME"]    = $rs->getString("TAB_NAME");
            $result["MENU_NAME"]   = $rs->getString("MENU_NAME");
            $result["PAGE_NAME"]   = $rs->getString("PAGE_NAME");
            $result["SUB_PAGE"]    = $rs->getString("SUB_PAGE");
            $result["PAGE_TITLE"]  = $rs->getString("PAGE_TITLE");
            $result["DISPLAY_SEQ"] = $rs->getString("DISPLAY_SEQ");
            $result["EXTRA_HEAD"]  = $rs->getString("EXTRA_HEAD");
            $result["CHECKSUM"]    = $rs->getString("CHECKSUM");
            //
            $header_content = $rs->getClob("HEADER_CONTENT");
            $result["HEADER_CONTENT"] = empty($header_content) ? null : $header_content->getContents();
            //
            $body_content = $rs->getClob("BODY_CONTENT");
            $result["BODY_CONTENT"]   = empty($body_content) ? null : $body_content->getContents();
        }

        $rs->close();

        /**** USE NATIVE OCI CALL ****
         
        $conn = oci_connect(DB_USER, DB_PASS, '//localhost/XE');
        $statement = oci_parse ($conn,
                   "select tab_name, menu_name, page_name, sub_page,
                           page_title, display_seq, header_content, body_content,
                           checksum
                    from   rnt_menu_pages_v
                    where  tab_name  = :var1
                    and    menu_name = :var2
                    and    page_name = :var3
                    and    sub_page  = :var4");

        oci_bind_by_name($statement, ':var1', $tab_name, SQLT_CHR );
        oci_bind_by_name($statement, ':var2', $menu_name, SQLT_CHR );
        oci_bind_by_name($statement, ':var3', $page_name, SQLT_CHR );
        oci_bind_by_name($statement, ':var4', $subpage, SQLT_CHR );

        oci_execute($statement, OCI_DEFAULT);
        $result = oci_fetch_assoc($statement);
        */

        return $result;
    }

    /**
     * Save page header and body content
     *
     * @param array $values
     * @return bool operation was completed with success?
     */
    public function updatePageContent($values)
    {
        $check_str = $values["TAB_NAME"]  || $values["MENU_NAME"]
                  || $values["PAGE_NAME"] || $values["SUB_PAGE"];

        if (empty($check_str)) {
            return false;
        }

        // construct DML operation
        $statement  = "begin "
                    . "    RNT_MENU_PAGES_PKG.UPDATE_ROW( "
                    . "          X_TAB_NAME       => :var1 "
                    . "        , X_MENU_NAME      => :var2 "
                    . "        , X_PAGE_NAME      => :var3 "
                    . "        , X_SUB_PAGE       => :var4 "
                    . "        , X_PAGE_TITLE     => :var5 "
                    . "        , X_DISPLAY_SEQ    => :var6 "
                    . "        , X_HEADER_CONTENT => XMLType(:var7) "
                    . "        , X_BODY_CONTENT   => to_clob(:var8) "
                    . "        , X_CHECKSUM       => :var9 "
                    . "    ); "
                    . "end;";

        // prepare DML operation
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setString(1, $values["TAB_NAME"]);
        $prepare->setString(2, $values["MENU_NAME"]);
        $prepare->setString(3, $values["PAGE_NAME"]);
        $prepare->setString(4, $values["SUB_PAGE"]);
        $prepare->setString(5, $values["PAGE_TITLE"]);
        $prepare->set(6, $values["DISPLAY_SEQ"]);
        $prepare->setString(7, $values["HEADER_CONTENT"]);
        $prepare->setString(8, $values["BODY_CONTENT"]);
        $prepare->setString(9, $values["CHECKSUM"]);

        // execute DML operation
        $prepare->executeUpdate();

        return true;
    }
    
    /**
     * Enter description here...
     *
     * @param unknown_type $values
     */
    public function save($values)
    {
        $failed_data = empty($values["TAB_NAME"])
                    || empty($values["MENU_NAME"])
                    || empty($values["PAGE_NAME"])
                    || empty($values["SUB_PAGE"])
                    || empty($values["PAGE_TITLE"]);
                  
        if ($failed_data) {
            return;
            //throw new Exception('Failed data!');
        }
        
        // construct DML operation
        $statement = "begin RNT_MENU_PAGES_PKG.INSERT_ROW2(";
        if (!empty($values["CHECKSUM"])) {
            $statement = "begin RNT_MENU_PAGES_PKG.UPDATE_ROW2(";
        }
            
        $statement .= "  X_TAB_NAME    => :var1 "
                   .  ", X_MENU_NAME   => :var2 "
                   .  ", X_PAGE_NAME   => :var3 "
                   .  ", X_SUB_PAGE    => :var4 "
                   .  ", X_PAGE_TITLE  => :var5 "
                   .  ", X_DISPLAY_SEQ => :var6 ";
                       
        if (! empty($values["CHECKSUM"])) {
            $statement .= ", X_CHECKSUM    => :var7 ";
        }
        $statement .= "); end;";
        
        // prepare DML operation
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setString(1, $values["TAB_NAME"]);
        $prepare->setString(2, $values["MENU_NAME"]);
        $prepare->setString(3, $values["PAGE_NAME"]);
        $prepare->setString(4, $values["SUB_PAGE"]);
        $prepare->setString(5, $values["PAGE_TITLE"]);
        $prepare->set(6, $values["DISPLAY_SEQ"]);
        if (!empty($values["CHECKSUM"])) {
            $prepare->setString(7, $values["CHECKSUM"]);
        }

        // execute DML operation
        @$prepare->executeUpdate();        
    }

    /**
     * Enter description here...
     *
     * @param unknown_type $values
     */
    public function delete($values)
    {
        $failed_data = empty($values["TAB_NAME"])
                    || empty($values["MENU_NAME"])
                    || empty($values["PAGE_NAME"])
                    || empty($values["SUB_PAGE"]);
                  
        if ($failed_data) {
            return;
            //throw new Exception('Failed data!');
        }
        
        // construct DML operation
        $statement = "begin "
                   . " RNT_MENU_PAGES_PKG.DELETE_ROW("
                   . "     X_TAB_NAME  => :var1 "
                   . "   , X_MENU_NAME => :var2 "
                   . "   , X_PAGE_NAME => :var3 "
                   . "   , X_SUB_PAGE  => :var4 "
                   . " ); end;";
                   
        // prepare DML operation
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setString(1, $values["TAB_NAME"]);
        $prepare->setString(2, $values["MENU_NAME"]);
        $prepare->setString(3, $values["PAGE_NAME"]);
        $prepare->setString(4, $values["SUB_PAGE"]);

        // execute DML operation
        @$prepare->executeUpdate();
    }
    
}
?>
