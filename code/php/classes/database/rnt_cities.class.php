<?
require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
require_once dirname(__FILE__)."/../SQLExceptionMessage.class.php";
require_once dirname(__FILE__)."/rnt_base.class.php";

class RNTCities extends RNTBase
{
    // this value accessible inside the formatting function
    private $_menu_tree_last = null;
    
    
    public function __construct($connection)
    {
        parent::__construct($connection);
    }

    /**
     * Get cities tree menu data
     *
     * @return  array  tree of cities
     */
    public function getCitiesTreeMenuData()
    {
        $result = array();

        $query = 
        "select pid, cid as item_title, item_level, item_isleaf,
                substr(xpath, 2) as xpath, city_id
         from   (
                 select substr(pid, instr(pid, '$') + 1) as pid, 
                        substr(cid, instr(cid, '$') + 1) as cid,
                        level-1  as item_level,
                        city_id,
                        sys_connect_by_path(substr(cid, instr(cid, '$') + 1), ',') as xpath,
                        connect_by_isleaf as item_isleaf
                 from   (
                         select distinct to_char(null)   as pid,
                                         state           as cid,
                                         to_number(null) as city_id
                         from   rnt_cities c1
                         where  exists (select 1 from PR_VALUES v1 
                                        where  v1.city_id = c1.city_id)
                         union all
                         select distinct state              as pid,
                                         state||'$'||county as cid,
                                         to_number(null)    as city_id
                         from   rnt_cities c2
                         where  exists (select 1 from PR_VALUES v2 
                                        where  v2.city_id = c2.city_id)
                         union all
                         select distinct state||'$'||county as pid,
                                         name               as cid,
                                         city_id
                         from   rnt_cities c3
                         where  exists (select 1 from PR_VALUES v3 
                                        where  v3.city_id = c3.city_id)
                        )  
                 start   with     pid is null
                 connect by prior cid = pid     
                ) x
         order  by x.xpath";
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
     * Format menu tree level
     *
     * @param  array  $current   current level of hierarchical menu data
     *         require format: 
     *             array(
     *                   "ITEM_LEVEL"  => ...
     *                   "ITEM_TITLE"  => ...
     *                   "ITEM_ISLEAF" => {0 | 1}
     *             )
     * @return string
     */
    private function formatCitiesMenuTreeLevel($current)
    {
        // the previous row's level, or null on the first row
        $last = $this->_menu_tree_last;
        
        // structural elements
        $openItem  = '<li>';
        $closeItem = '</li>';
        $openChildren  = '<ul>';
        $closeChildren = '</ul>';
        
        $icon = ($current['ITEM_ISLEAF'] == 1) ? 'file' : 'folder';
        $structure = "";
        
        if( ! isset($current['ITEM_LEVEL']))
        {
            // add closing structure(s) equal to the very last
            // row's level; this will only fire for the "dummy"
            return str_repeat($closeItem.$closeChildren, $last);
        }
        
        // add the item itself
        $href = '?m2=city_data';
        if (! empty($current['CITY_ID']))
        {
            $href .= '&city_id='.$current['CITY_ID'];
        }
        else
        {
            $href .= '&location='.$current['XPATH'];
        }
        //$href = urlencode($href);
        $item = "<span class='$icon'><a href='$href'>".$current["ITEM_TITLE"]."</a></span>";
        
        if (is_null($last))
        {
            // add the opening structure in the case of the first row
            $structure .= "<ul id='browser'>"; //$openChildren; 
        }
        elseif ($last < $current['ITEM_LEVEL'])
        {
            // add the structure to start new branches
            $structure .= $openChildren;
        }
        elseif ($last > $current['ITEM_LEVEL'])
        {
            // add the structure to close branches equal to the 
            // difference between the previous and current levels
            $structure .= $closeItem
                       .  str_repeat($closeChildren.$closeItem, $last - $current['ITEM_LEVEL']);
        }
        else
        {
            $structure .= $closeItem;
        }
        
        // add the item structure
        $structure .= $openItem;
        
        // update $last so the next row knows whether this row is really its parent
        $this->_menu_tree_last = $current['ITEM_LEVEL'];
        
        return $structure.$item;
    }
    
    /**
     * Build html source code for cities menu tree
     *
     * @param   array    $cities_menu_data
     * @param   integer  $current_city_id
     * @return  string   html source code
     */
    public function buildCitiesMenuTreeHtml($cities_menu_data)
    {
        $result = "";

        if (empty($cities_menu_data))
        {
            return $result;
        }

        // set a value not possible in a LEVEL column to allow the
        // first row to know it's "firstness"
        $this->_menu_tree_last = null;

        // add a dummy "row" to cap off formatting
        $cities_menu_data[] = array();

        // invoke our formatting function via callback
        $formatted = array_map(array(&$this, "formatCitiesMenuTreeLevel"), $cities_menu_data);
        $result    = implode("\n", $formatted);

        return $result;
    }    
    
    /**
     * Get city description
     *
     * @param  integer $city_id
     * @return string  text of city description
     */
    public function getCityData($city_id)
    {
        $query = " select city_id, name, county, state, description, checksum,  "
               . " c.geo_location.sdo_point.y lat, c.geo_location.sdo_point.x lon, "
               . " report_data"
               . " from   rnt_cities_v c"
               . " where  city_id = :var1";
        
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $city_id);
        $rs   = $stmt->executeQuery();
        
        $result = array();
        if ($rs->next())
        {
            $result["CITY_ID"]  = $rs->getInt("CITY_ID");
            $result["NAME"]     = $rs->getString("NAME");
            $result["COUNTY"]   = $rs->getString("COUNTY");
            $result["STATE"]    = $rs->getString("STATE");
            $result["CHECKSUM"] = $rs->getString("CHECKSUM");
            $result["LAT"]      = $rs->getString("LAT");
            $result["LON"]      = $rs->getString("LON");
            
            $clob   = $rs->getClob("DESCRIPTION");
            $result["DESCRIPTION"] = empty($clob) ? null : $clob->getContents();

            $clob   = $rs->getClob("REPORT_DATA");
            $result["REPORT_DATA"] = empty($clob) ? null : $clob->getContents();

            
        }
        $rs->close();
        
        return $result;		            
    }

     /**
     * Get State or County description
     *
     * @param  string $location examples FL or FL,BREVARD
     * @return string  text of city description
     */
    public function getCountyData($location)
      {
        $args = explode(',', $location);

        if (! $args[1]) $args[1] = "ANY";
        if (! $args[2]) $args[2] = "ANY";

        $query = " select city_id, name, county, state, description, checksum, initcap(name) display_name,"
               . " c.geo_location.sdo_point.y lat, c.geo_location.sdo_point.x lon, "
               . " report_data"
               . " from   rnt_cities_v c"
               . " where  state  = :var1 "
               . " and    county = :var2 "
               . " and    name   = :var3 ";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $args[0]);
        $stmt->setString(2, $args[1]);
        $stmt->setString(3, $args[2]);
        $rs   = $stmt->executeQuery();

        $result = array();
        if ($rs->next())
        {
            $result["CITY_ID"]  = $rs->getInt("CITY_ID");
            $result["NAME"]     = $rs->getString("NAME");
            $result["DISPLAY_NAME"] = $rs->getString("DISPLAY_NAME");
            $result["COUNTY"]   = $rs->getString("COUNTY");
            $result["STATE"]    = $rs->getString("STATE");
            $result["CHECKSUM"] = $rs->getString("CHECKSUM");
            $result["LAT"]      = $rs->getString("LAT");
            $result["LON"]      = $rs->getString("LON");
            

            $clob   = $rs->getClob("DESCRIPTION");
            $result["DESCRIPTION"] = empty($clob) ? null : $clob->getContents();

            $clob   = $rs->getClob("REPORT_DATA");
            $result["REPORT_DATA"] = empty($clob) ? null : $clob->getContents();
            
        }
        $rs->close();

        return $result;
    }

    public function getRandomImage()
    {
     $query = "select m.name, c.name city, c.county, c.state, c.region_id, r.name region
     from rnt_city_media m
     ,    rnt_cities c
     ,    rnt_regions r
     where m.city_id = c.city_id
     and r.region_id = c.region_id
     order by dbms_random.value";

     $stmt = $this->connection->prepareStatement($query);
     $rs   = $stmt->executeQuery();

     $image = array();
     if ($rs->first())
     {
       $image["NAME"] = $rs->getString("NAME");
       $image["CITY"] = $rs->getString("CITY");
       $image["COUNTY"] = $rs->getString("COUNTY");
       $image["STATE"] = $rs->getString("STATE");
       $image["REGION_ID"] = $rs->getInt("REGION_ID");
       $image["REGION"] = $rs->getString("REGION");
     }
     return $image;     
    }


      
    /**
     * Get city description
     *
     * @param  City name, County name and State name
     * @return string  text of city description
     */
    public function getCityDesc($city, $county, $state)
    {
        $query = " select city_id, name, county, state, description, checksum, "
               . " c.geo_location.sdo_point.y lat, c.geo_location.sdo_point.x lon, "
               . " report_data, population, region_name, meta_description, "
               . " rss_news, rss_source, rss_name"
               . " from   rnt_cities_v c"
               . " where  name = :var1"
               . " and  county = :var2"
               . " and  state  = :var3";
        
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $city);
		$stmt->setString(2, $county);
		$stmt->setString(3, $state);
        $rs   = $stmt->executeQuery();
        
        $result = array();
        if ($rs->next())
        {
            $result["CITY_ID"]  = $rs->getInt("CITY_ID");
            $result["NAME"]     = $rs->getString("NAME");
            $result["COUNTY"]   = $rs->getString("COUNTY");
            $result["STATE"]    = $rs->getString("STATE");
            $result["CHECKSUM"] = $rs->getString("CHECKSUM");
            $result["LAT"]      = $rs->getString("LAT");
            $result["LON"]      = $rs->getString("LON");
            $result["POPULATION"] = $rs->getString("POPULATION");
            $result["REGION_NAME"] = $rs->getString("REGION_NAME");
            $result["META_DESCRIPTION"] = $rs->getString("META_DESCRIPTION");
            $result["RSS_NEWS"]    = $rs->getString("RSS_NEWS");
            $result["RSS_SOURCE"]  = $rs->getString("RSS_SOURCE");
            $result["RSS_NAME"]    = $rs->getString("RSS_NAME");


            
            $clob   = $rs->getClob("DESCRIPTION");
            $result["DESCRIPTION"] = empty($clob) ? null : $clob->getContents();

            $clob   = $rs->getClob("REPORT_DATA");
            $result["REPORT_DATA"] = empty($clob) ? null : $clob->getContents();
            
        }
        $rs->close();

       $images = array();
       $pimages = array();

       if ($city == 'ANY')
        { $query = "select m.name, m.title, m.aspect_ratio,
                initcap(c.name)||' in '||initcap(c.county)||' County '||c.state alt_text
                from rnt_city_media m
                ,    rnt_cities c
                where m.city_id = c.city_id
                and c.state = :var1
                and c.county = :var2
                and m.media_type like 'image%'
                and m.county_yn = 'Y'
                order by m.name";

          $stmt = $this->connection->prepareStatement($query);
          $stmt->setString(1, $state);
          $stmt->setString(2, $county);
         }
       else
        { $query = "select m.name, m.title, m.aspect_ratio,
                initcap(c.name)||' in '||initcap(c.county)||' County '||c.state||' ('||m.title||')' alt_text
                from rnt_city_media m
                ,    rnt_cities c
                where m.city_id = :var1
                and m.media_type like 'image%'
                and m.city_id = c.city_id
                order by m.name";

          $stmt = $this->connection->prepareStatement($query);
          $stmt->setString(1, $result["CITY_ID"]);
        }


       $rs   = $stmt->executeQuery();
       while($rs->next())
          {
           if ($rs->getString("ASPECT_RATIO") == "10x16")
             $pimages[]= $rs->getRow();
           else
             $images[] = $rs->getRow();
          }
        $rs->close();
      $result["IMG_LIST"] = $images;
      $result["10x16_IMAGES"] = $pimages;



      if ($city == 'ANY')
        {
          $stmt = $this->connection->prepareStatement($query);
          $stmt->setString(1, $state);
          $stmt->setString(2, $county);

          $query = "select city_id, county, name, initcap(name) display_name,
                 c.geo_location.sdo_point.y lat, c.geo_location.sdo_point.x lon
                 from rnt_cities c
                 where state = :var1
                 and  county = :var2
                 and name != 'ANY'
                 order by name";

       $cities = array();
       $stmt = $this->connection->prepareStatement($query);
       $stmt->setString(1, $state);
       $stmt->setString(2, $county);

       $rs   = $stmt->executeQuery();
       while($rs->next())
          {
           $cities[] = $rs->getRow();
          }
        $rs->close();
        $result["CITY_LIST"] = $cities;
        $result["DISPLAY_NAME"] =  ucwords(strtolower($county)) . " County";
       }


        
        return $result;		            
    }

    public function getRegionDesc($region_id)
     {
       $query = "select name, description, report_data, initcap(name) display_name,
                 meta_description
                 from rnt_regions
                 where region_id = :var1";

       $stmt = $this->connection->prepareStatement($query);
       $stmt->setInt(1, $region_id);
       $rs   = $stmt->executeQuery();

       $result = array();
       if ($rs->next())
        {
         $result["NAME"]  = $rs->getString("NAME");
         $result["DISPLAY_NAME"]  = $rs->getString("DISPLAY_NAME");
         $result["META_DESCRIPTION"]  = $rs->getString("META_DESCRIPTION");
         $clob   = $rs->getClob("DESCRIPTION");
         $result["DESCRIPTION"] = empty($clob) ? null : $clob->getContents();

         $clob   = $rs->getClob("REPORT_DATA");
         $result["REPORT_DATA"] = empty($clob) ? null : $clob->getContents();
        }
       $rs->close();

       $query = "select city_id, county, name, initcap(name) display_name,
                 c.geo_location.sdo_point.y lat, c.geo_location.sdo_point.x lon
                 from rnt_cities c
                 where region_id = :var1
                 and name != 'ANY'
                 order by name";

       $cities = array();
       $stmt = $this->connection->prepareStatement($query);
       $stmt->setInt(1, $region_id);
       $rs   = $stmt->executeQuery();
       while($rs->next())
          {
           $cities[] = $rs->getRow();
          }
        $rs->close();
      $result["CITY_LIST"] = $cities;

      $query = "select city_id, county name,
                 c.geo_location.sdo_point.y lat, c.geo_location.sdo_point.x lon
                 from rnt_cities c
                 where region_id = :var1
                 and name = 'ANY'
                 order by name";

       $cities = array();
       $stmt = $this->connection->prepareStatement($query);
       $stmt->setInt(1, $region_id);
       $rs   = $stmt->executeQuery();
       while($rs->next())
          {
           $cities[] = $rs->getRow();
          }
        $rs->close();
      $result["COUNTY_LIST"] = $cities;

      $query = "select name, title
                from rnt_city_media
                where region_id = :var1
                and media_type like 'image%'
                order by name";

       $images = array();
       $stmt = $this->connection->prepareStatement($query);
       $stmt->setInt(1, $region_id);
       $rs   = $stmt->executeQuery();
       while($rs->next())
          {
           $images[] = $rs->getRow();
          }
        $rs->close();
      $result["REGION_IMG_LIST"] = $images;
      
      
      return $result;
     }
    
    /**
     * Save city data's changes
     *
     * @param  array $value
     * @return boolean
     */
    public function updateCityData($values)
    {
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt   (1, $values["CITY_ID"]);

        // Use native oci call because Creole LOB implementation is buggy
        $c = oci_connect(DB_USER, DB_PASS, DB_TNS);
        $statement = oci_parse ($c,
                     "update rnt_cities
                      set description =  EMPTY_CLOB()
                      where city_id = :var2
                      returning description into :var1");

        $lob = oci_new_descriptor($c, OCI_D_LOB);
        oci_bind_by_name($statement, ':var2', OCI8PreparedStatementVars::getVar($prepare, 1));
        oci_bind_by_name($statement, ':var1', $lob, -1, OCI_B_CLOB);

        oci_execute($statement, OCI_DEFAULT); // use OCI_DEFAULT so $lob->save() works
        $lob->save($values["DESCRIPTION"]);
        oci_commit($c);
        $lob->close();
        
        return true;
	}
	
   public function getRegions()
   {
      $str_query = "select region_id, name
                    from rnt_regions
                    order by name";

        $rs = $this->connection->executeQuery($str_query);
        while($rs->next())
          {
           $arr_results[] = $rs->getRow();
          }
        $rs->close();
        return $arr_results;

   }


    public function getGeoCity($lat, $long, $city)
        {
         $str_query = "select c.name, c.county, c.state, c.description, c.region_id
                       , initcap(c.name) display_name, cy.description county_description
                       , c.city_id, sdo_nn_distance(1) distance
                       from rnt_cities c
                       ,    rnt_cities cy
                       where c.name != 'ANY'
                       and c.county != 'ANY'
                       and sdo_nn ( c.geo_location
                                  , SDO_GEOMETRY(2001, 8307,
                                    SDO_POINT_TYPE( nvl(:var1, 0)
                                                  , nvl(:var2, 0)
                                                  ,NULL), NULL, NULL)
                                  , 'sdo_num_res=5', 1) = 'TRUE'
                       and sdo_nn_distance(1) < 50000
                       and cy.name = 'ANY'
                       and cy.county = c.county
                       and cy.state = c.state
                       order by distance desc";

        $stmt = $this->connection->prepareStatement($str_query);
        $stmt->setString(1, $long);
        $stmt->setString(2, $lat);
        $rs   = $stmt->executeQuery();
        $result = array();

        $found = 'N';
        while($rs->next())
          {
            if ($found == 'N')
              {
              $result["NAME"]      = $rs->getString("NAME");
              $result["DISPLAY_NAME"] = $rs->getString("DISPLAY_NAME");
              $result["COUNTY"]    = $rs->getString("COUNTY");
              $result["STATE"]     = $rs->getString("STATE");
              $result["CITY_ID"]   = $rs->getInt("CITY_ID");
              $result["REGION_ID"] = $rs->getInt("REGION_ID");
              $clob   = $rs->getClob("DESCRIPTION");
              $result["DESCRIPTION"] = empty($clob) ? null : $clob->getContents();

              $clob   = $rs->getClob("COUNTY_DESCRIPTION");
              $result["COUNTY_DESCRIPTION"] = empty($clob) ? null : $clob->getContents();

              if ($result["DISPLAY_NAME"] == $city) $found = 'Y';
              }
           }

        $rs->close();


        $query = "select m.name, m.title, m.aspect_ratio,
         initcap(c.name)||' in '||initcap(c.county)||' County '||c.state||' ('||m.title||')' alt_text
                from rnt_city_media m
                ,    rnt_cities c
                where m.city_id = c.city_id
                and c.state = :var1
                and c.county = :var2
                and c.name   = :var3
                and m.media_type like 'image%'
                order by m.name";

          $stmt = $this->connection->prepareStatement($query);
          $stmt->setString(1, $result["STATE"]);
          $stmt->setString(2, $result["COUNTY"]);
          $stmt->setString(3, $result["NAME"]);

          $result["IMG_TYPE"] = 'CITY';

       $rs   = $stmt->executeQuery();
       while($rs->next())
          {
           if ($rs->getString("ASPECT_RATIO") == "10:16")
             $pimages[]= $rs->getRow();
           else
             $images[] = $rs->getRow();
          }

       if (! $images)
       {
        $query = "select m.name, m.title, m.aspect_ratio,
         initcap(c.name)||' in '||initcap(c.county)||' County '||c.state||' ('||m.title||')' alt_text
                from rnt_city_media m
                ,    rnt_cities c
                where m.city_id = c.city_id
                and c.state = :var1
                and c.county = :var2
                and m.media_type like 'image%'
                and county_yn = 'Y'
                order by m.name";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $result["STATE"]);
        $stmt->setString(2, $result["COUNTY"]);

        $result["IMG_TYPE"] = 'COUNTY';

       $rs   = $stmt->executeQuery();
       while($rs->next())
          {
           if ($rs->getString("ASPECT_RATIO") == "10:16")
             $pimages[]= $rs->getRow();
           else
             $images[] = $rs->getRow();
          }
          
       }
       $rs->close();
       $result["IMG_LIST"] = $images;
       $result["10x16_IMAGES"] = $pimages;

       return $result;
        
       }
}
?>