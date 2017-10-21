<?php
require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
require_once dirname(__FILE__)."/rnt_base.class.php";

class RNTMenuLinks extends RNTBase
{
    public function __construct($connection)
    {
        parent::__construct($connection);
    }
    
    /**
     * Save menu link
     *
     * @param array $values  menu link data attributes
     */
    public function save($values)
    {
        $failed_data = empty($values["TAB_NAME"])
                    || empty($values["MENU_NAME"])
                    || empty($values["LINK_TITLE"])
                    || empty($values["LINK_URL"]);
                  
        if ($failed_data) {
            return;
            //throw new Exception('Failed data!');
        }
        
        // construct DML operation
        $statement = "begin RNT_MENU_LINKS_PKG.INSERT_ROW(";
        if (!empty($values["CHECKSUM"])) {
            $statement = "begin RNT_MENU_LINKS_PKG.UPDATE_ROW(";
        }
            
        $statement .= "  X_TAB_NAME    => :var1 "
                   .  ", X_MENU_NAME   => :var2 "
                   .  ", X_LINK_TITLE  => :var3 "
                   .  ", X_LINK_URL    => :var4 "
                   .  ", X_DISPLAY_SEQ => :var5 ";
                       
        if (! empty($values["CHECKSUM"])) {
            $statement .= ", X_CHECKSUM    => :var6 ";
        }
        $statement .= "); end;";
        
        // prepare DML operation
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setString(1, $values["TAB_NAME"]);
        $prepare->setString(2, $values["MENU_NAME"]);
        $prepare->setString(3, $values["LINK_TITLE"]);
        $prepare->setString(4, $values["LINK_URL"]);
        $prepare->set(5, $values["DISPLAY_SEQ"]);
        if (!empty($values["CHECKSUM"])) {
            $prepare->setString(6, $values["CHECKSUM"]);
        }

        // execute DML operation
        @$prepare->executeUpdate();
    }
    
    /**
     * Delete menu link
     *
     * @param array $values  menu link data attributes
     */
    public function delete($values)
    {
        $failed_data = empty($values["TAB_NAME"])
                    || empty($values["MENU_NAME"])
                    || empty($values["LINK_TITLE"]);
                  
        if ($failed_data) {
            return;
            //throw new Exception('Failed data!');
        }
        
        // construct DML operation
        $statement = "begin "
                   . " RNT_MENU_LINKS_PKG.DELETE_ROW("
                   . "     X_TAB_NAME   => :var1 "
                   . "   , X_MENU_NAME  => :var2 "
                   . "   , X_LINK_TITLE => :var3 "
                   . " ); end;";
                   
        // prepare DML operation
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setString(1, $values["TAB_NAME"]);
        $prepare->setString(2, $values["MENU_NAME"]);
        $prepare->setString(3, $values["LINK_TITLE"]);

        // execute DML operation
        @$prepare->executeUpdate();
    }

}
?>