<?php

/**
 * For each page must be give params REQUEST_PROPERTY_ID = <property_id>
 *
 * @version $Id$
 * @copyright 2007
 **/

define("REQUEST_PROPERTY_ID", "prop_id");

class Menu3
{
    // object database connection
    private $connection;
    // array for data 2 level
    public $data;
    // current ID of property
    public $current_property_id;
    // var name for request
    public $request_property_id = REQUEST_PROPERTY_ID;

    public function __construct($db_connection)
    {
        $this->connection = $db_connection;
    }

    public function getParams()
    {
        return REQUEST_PROPERTY_ID."=".$this->current_property_id;
    }

    /* build the properties list. Array have 2 level.
       $current_id - id current property
       array look so:
            <business_name> => array("address"=>, "id"=>)

    */
    public function build($current_id, $isPropertyEdit = false)
    {
        if ($current_id == NULL)
          $current_id = 0;
        $s = "";
        if ($isPropertyEdit)
            $s = "(+)";
        $resultSet = $this->connection->executeQuery(
            "select bu.BUSINESS_NAME, p.ADDRESS1, p.PROPERTY_ID ".
            "from   RNT_PROPERTIES p, ".
            "       RNT_BUSINESS_UNITS_V bu ".
            "where  p.BUSINESS_ID = bu.BUSINESS_ID ".
            "and    PARENT_BUSINESS_ID != 0 ".
            "and    nvl(p.STATUS, 'PURCHASED') != 'REJECTED' ".
            "order  by bu.BUSINESS_NAME, p.NAME,".
            "          p.ADDRESS1, p.ADDRESS2, p.ZIPCODE");
         $currentBusinessUnit = "";
         $this->data = array();
         $current = "";
         $this->current_property_id = -1;

         while($resultSet->next())
         {
            $r = $resultSet->getRow();

            if ($currentBusinessUnit != $r["BUSINESS_NAME"])
            {
                $this->data[$r["BUSINESS_NAME"]] = array();
                $current = &$this->data[$r["BUSINESS_NAME"]];
                $currentBusinessUnit = $r["BUSINESS_NAME"];
            }
            $current[] = array("address" => $r["ADDRESS1"], "id" => $r["PROPERTY_ID"]);
            if ($r["PROPERTY_ID"] == $current_id)
              $this->current_property_id = $current_id;
         }

         // Not find property. Set first property as current.
         if ($this->current_property_id == -1)
         {
           reset($this->data);
           $item = current($this->data);
           $this->current_property_id = $item[0]["id"];
         }
    }

}

?>