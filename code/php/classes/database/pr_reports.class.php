    <?php

require_once dirname(__FILE__) . "/../LOV.class.php";
require_once dirname(__FILE__) . "/../UtlConvert.class.php";
require_once dirname(__FILE__) . "/../OCI8PreparedStatementVars.php";
require_once dirname(__FILE__) . "/rnt_base.class.php";

class PRReports extends RNTBase {

    public function __construct($connection) {
        parent::__construct($connection);
    }

    public function getTaxFt($prop_id) {
        $query = "select 'Tax Value: '||to_char(t.tax_value, '$999,999,999')
                        ||' Sq Ft: '||to_char(p.sq_ft, '999,999')
                        ||' Value/Ft: '||round(t.tax_value/p.sq_ft)
                        ||' Tax/Yr: '||to_char(t.tax_amount, '$999,999,999')
                        ||' Tax/Ft: '||to_char(t.tax_amount/p.sq_ft, '$9,999.99')
                        price
                   from pr_properties p
                   ,    pr_taxes t
                   where t.prop_id = p.prop_id
                   and t.current_yn = 'Y'
                   and p.prop_id = :var1
                   and p.sq_ft != 0
                   and p.sq_ft is not null";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $prop_id);

        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $r = $rs->getRow();
            $result = $r["PRICE"];
        }
        return $result;
    }

    public function getLeaseType($prop_id) {
        $return = 'Residential/Gross';
        $ucode = "";

        /*
          $query = "select u.ucode, u.parent_ucode
          from pr_usage_codes u
          ,    pr_property_usage pu
          where pu.prop_id = :var1
          and pu.ucode = u.ucode";
          $stmt = $this->connection->prepareStatement($query);
          $stmt->setString(1, $prop_id);

          $rs   = $stmt->executeQuery();
          while($rs->next())
          {
          $r = $rs->getRow();
          $ucode = $r["UCODE"];
          $parent_ucode = $r["PARENT_UCODE"];
          }

          if ((($ucode == 1) or ($parent_ucode == 1)) or
          (($ucode == 11) or ($parent_ucode == 11) or ($parent_ucode == 91000)) or
          (($ucode == 4) or ($parent_ucode == 4)) or
          (($ucode == 91000) or ($ucode == 90002) or ($ucode == 90004)))  $return = "Residential/Gross";
          else  $return = 'Triple Net';
         */
        return $return;
    }

    public function getUcodeDesc($ucode) {
        $result = "";

        $query = "select description
                   from pr_usage_codes
                   where ucode = ?";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $ucode);

        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $r = $rs->getRow();
            $result = $r["DESCRIPTION"];
        }

        return $result;
    }

    public function getCounty($zipcode) {
        $result = array();
        $query = "select initcap(c.county) county
                ,      c.state
                from rnt_cities c
                ,    rnt_city_zipcodes cz
                where cz.zipcode = ?
                and cz.city_id = c.city_id";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $zipcode);

        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $result = $rs->getRow();
        }

        return $result;
    }

    public function getOwnerDesc($owner_id) {
        $result = "";

        $query = "select initcap(owner_name) OWNER_NAME
                  from pr_owners
                  where owner_id = ?";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $owner_id);

        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $r = $rs->getRow();
            $result = $r["OWNER_NAME"];
        }
        return $result;
    }

    public function getPropDesc($prop_id) {
        $result = "";
        $query = "select address1||', '||city||', FL '||zipcode  addr
                  from pr_properties
                  where prop_id = ?";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $prop_id);
        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $r = $rs->getRow();
            $result = $r["ADDR"];
        }
        return $result;
    }

    public function getPropSummary($prop_id) {
        $result = "";
        $query = "select to_char(p.sq_ft, '999,999') sq_ft
                  ,      to_char(p.acreage, '9,999.99') acreage
                  ,      initcap(p.address1) addr
                  ,      initcap(p.city) city
                  ,      p.state
                  ,      uc.description
                  from pr_properties p
                  ,    pr_property_usage pu
                  ,    pr_usage_codes uc
                  where p.prop_id = ?
                  and pu.prop_id = p.prop_id
                  and pu.ucode = uc.ucode";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $prop_id);
        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $r = $rs->getRow();
            $result = $r["ADDR"] . " is a " . $r["SQ_FT"] . " sq ft " . $r["DESCRIPTION"] . " located in " . $r["CITY"] . ", " . $r["STATE"] . " on " . $r["ACREAGE"] . " acres.";
        }
        return $result;
    }

    public function get_streetview_url($lat, $lon) {
        $endpoint = "https://maps.google.com/cbk?output=json&hl=en&ll=" . $lat . "," . $lon . "&radius=50&cb_client=maps_sv&v=4";
        $handler = curl_init();

        curl_setopt($handler, CURLOPT_HEADER, 0);
        curl_setopt($handler, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($handler, CURLOPT_URL, $endpoint);
        $data = curl_exec($handler);
        curl_close($handler);
        // if data value is an empty json document ('{}') , the panorama is not available for that point

        if ($data === '{}') {
            $url = null;
        } else {
            $url = "https://maps.googleapis.com/maps/api/streetview?size=640x380&location=" . $lat . "," . $lon . "&sensor=false&key=AIzaSyAu0Z0MCoAZ0RYkPNDgR2Zy5yZNoitv3nU";
        }
        return $url;
    }

    public function getPropPhotos($prop_id) {
        $query = "SELECT url, filename FROM pr_property_photos WHERE prop_id = :var1 AND rownum < 5";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $prop_id);
        $rs = $stmt->executeQuery();

        $result = array();
        while ($rs->next()) {
            $r = $rs->getRow();
            $result[] = array("URL" => $r["URL"], "FILENAME" => $r["FILENAME"]);
        }
        return $result;
    }

    public function getDefaults($prop_id, $ucode) {
        $str_query = "select monthly_rent
                          ,      annual_rent
                          ,      vacancy_amount
                          ,      vacancy_percent
                          ,      insurance
                          ,      TAX
                          ,      maintenance
                          ,      utilities
                          ,      cap_rate
                          ,      mgt_percent
                          ,      mgt_amount
                          ,      median_market_value
                          ,      low_market_value
                          ,      high_market_value
                          ,      sqft_rent rent
                          ,      prop_class
                          ,      min_price
                          ,      median_price
                          ,      max_price
                          ,      estimate_year year
                          ,      city
                          ,      county
                          ,      state
                          ,      pclass
                          ,      summary
                     from table (pr_records_pkg.get_noi_estimates(:var1))";


        $stmt = $this->connection->prepareStatement($str_query);
        $stmt->setString(1, $prop_id);
        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $r = $rs->getRow();
            $arr_results[$r["PROP_CLASS"]] = $r;
        }
        $rs->close();
        return $arr_results;
    }

    public function getSimilar($prop_id) {
        $result = null;
        if (MAINTENANCE_MODE != "Y") {

            $query = "select p2.prop_id
                     ,      initcap(p2.address1) address1
                     ,      sdo_nn_distance(1)
                     from pr_properties p
               ,     pr_properties p2
               where p.prop_id  = :var1
               and p.prop_id != p2.prop_id
               and sdo_nn
                        ( p2.geo_location
                        , p.geo_location
                        , 'sdo_num_res=10', 1) = 'TRUE'
                                 order by 3";

            $loop_counter = 0;
            $stmt = $this->connection->prepareStatement($query);
            $stmt->setInt(1, $prop_id);
            $rs = $stmt->executeQuery();
            while ($rs->next()) {
                $r = $rs->getRow();
                $loop_counter = $loop_counter + 1;
                $result[$loop_counter] = array("PROP_ID" => $r["PROP_ID"]
                            , "ADDRESS1" => $r["ADDRESS1"]);
            }
        }
        return $result;
    }

    public function getMLS($prop_id) {
        $l_counter = 0;
        $result = array();
        $query = "select mls_id
                   ,      mls_number
                           ,      query_type
                           ,      listing_type
                           ,      to_char(ml.price, '$999,999,999') price
                           ,      listing_broker
                           ,      listing_date
                           ,      short_desc
                           ,      link_text
                           ,      description
                           ,      source_id
                           from mls_listings ml
                           where ml.prop_id  = :var1
                           and ml.listing_status = 'ACTIVE'
                           and ml.idx_yn = 'Y'";

        $query2 = "select photo_seq
                    ,      photo_url
                                ,      photo_desc
                                from mls_photos
                                where mls_id = :var1
                                order by photo_seq";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $prop_id);
        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $l_counter = $l_counter + 1;
            $r = $rs->getRow();
            $stmt2 = $this->connection->prepareStatement($query2);
            $stmt2->setInt(1, $r["MLS_ID"]);
            $rs2 = $stmt2->executeQuery();
            $loop_counter = 0;
            $photo = array();

            while ($rs2->next()) {
                $r2 = $rs2->getRow();
                $loop_counter = $loop_counter + 1;
                $photo[$loop_counter] = array("SEQ" => $r2["PHOTO_SEQ"]
                            , "PHOTO" => $r2["PHOTO_URL"]
                            , "DESC" => $r2["PHOTO_DESC"]);
            }
            $result[$l_counter] = array("MLS_NUMBER" => $r["MLS_NUMBER"]
                , "PRICE" => $r["PRICE"]
                , "TYPE" => $r["LISTING_TYPE"]
                , "LISTING_DATE" => $r["LISTING_DATE"]
                , "BROKER" => $r["LISTING_BROKER"]
                , "TITLE" => $r["SHORT_DESC"]
                , "DESCRIPTION" => $r["DESCRIPTION"]
                , "LINK_TEXT" => $r["LINK_TEXT"]
                , "SOURCE_ID" => $r["SOURCE_ID"]
                , "IMG" => $photo);
        }
        return $result;
    }

    public function getSimilarMLS($prop_id) {
        $query = "select ml.prop_id
                                , to_char(ml.price, '$999,999,999') price
                                , ml.link_text
                                , mp.photo_url
                                , sdo_nn_distance(1)
                                , p2.address1
                                , p2.zipcode
                                , p2.geo_location.sdo_point.y lat
                                , p2.geo_location.sdo_point.x lon
                                from pr_properties p
                                ,    pr_properties p2
                                ,     mls_listings ml
                                ,     mls_photos mp
                                where p.prop_id  = :var1
                                and p.prop_id != ml.prop_id
                                and ml.prop_id = p2.prop_id
                                and mp.mls_id = ml.mls_id
                                and ml.listing_status = 'ACTIVE'
                                and ml.idx_yn = 'Y'
                                and mp.photo_seq = 1
                                and sdo_nn( ml.geo_location
                                          , p.geo_location
                                          , 'sdo_num_res=30', 1) = 'TRUE'
                                and rownum < 16
                                and sdo_nn_distance(1) < 5000
                                order by 5 ";



        $loop_counter = 0;
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $prop_id);
        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $r = $rs->getRow();
            $loop_counter = $loop_counter + 1;
            $result[$loop_counter] = array("PROP_ID" => $r["PROP_ID"]
                        , "PRICE" => $r["PRICE"]
                        , "LINK_TEXT" => $r["LINK_TEXT"]
                        , "PHOTO" => $r["PHOTO_URL"]
                        , "ADDRESS1" => $r["ADDRESS1"]
                        , "ZIPCODE" => $r["ZIPCODE"]
                        , "LAT" => $r["LAT"]
                        , "LON" => $r["LON"]);
        }
        return $result;
    }

    public function getGeoListings($lat, $long) {
        $str_query = "select ml.prop_id
                                , to_char(ml.price, '$999,999,999') price
                                , ml.link_text
                                , mp.photo_url
                                , sdo_nn_distance(1)
                                , round((sdo_nn_distance(1) * 0.000621371), 2) miles
                                , initcap(p2.address1) address1
                                , p2.sq_ft
                                , p2.zipcode
                                , initcap(p2.city) city
                                , p2.geo_location.sdo_point.y lat
                , p2.geo_location.sdo_point.x lon
                                from  pr_properties p2
                                ,     mls_listings ml
                                ,     mls_photos mp
                                where ml.prop_id = p2.prop_id
                                and mp.mls_id = ml.mls_id
                                and ml.listing_status = 'ACTIVE'
                                and ml.idx_yn = 'Y'
                                and mp.photo_seq = 1
                                and sdo_nn
                                         ( ml.geo_location
                         , SDO_GEOMETRY(2001, 8307,
                                        SDO_POINT_TYPE( nvl(:var1, 0)
                                                      , nvl(:var2, 0)
                                                  ,NULL), NULL, NULL)
                         , 'sdo_num_res=30', 1) = 'TRUE'
                                and sdo_nn_distance(1) < 5000
                                and rownum < 16
                                order by 5";

        $stmt = $this->connection->prepareStatement($str_query);
        $stmt->setString(1, $long);
        $stmt->setString(2, $lat);
        $rs = $stmt->executeQuery();
        $arr_results = array();
        while ($rs->next()) {
            $arr_results[] = $rs->getRow();
        }
        $rs->close();

        return $arr_results;
    }

    public function AllSales($county) {
        $result = array();
        $query = "select  year
                   ,      sales_count
                   ,      total_sales
                   ,      avg_price
                  from pr_sales_summary_mv
                  where county = :var1
                  order by year desc";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $county);
        $rs = $stmt->executeQuery();

        while ($rs->next()) {
            $r = $rs->getRow();
            $result[$r["YEAR"]] = array("SALES_COUNT" => $r["SALES_COUNT"]
                , "TOTAL_SALES" => $r["TOTAL_SALES"]
                , "AVG_PRICE" => $r["AVG_PRICE"]);
        }
        return $result;
    }

    public function YearSales($year, $county) {
        $result = array();
        $query = "select  month_year
                  ,       display_date
                  ,       city
                  ,       display_city
                  ,       total_sales
                  ,       avg_price
                  ,       sales_count
                  from    pr_sales_mv
                  where   year = :var1
                  and     county = :var2
                  order   by month_year
                  ,       city";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $year);
        $stmt->setString(2, $county);
        $rs = $stmt->executeQuery();
        $i = 0;
        $display_month = "make_me_diff";
        while ($rs->next()) {
            $i = $i + 1;
            $r = $rs->getRow();
            if ($r["DISPLAY_DATE"] == $display_month) {
                $display_date = "";
            } else {
                $display_month = $r["DISPLAY_DATE"];
                $display_date = $display_month;
            }

            $result[$i] = array("DISPLAY_DATE" => $display_date
                , "CITY" => $r["CITY"]
                , "DISPLAY_CITY" => $r["DISPLAY_CITY"]
                , "SALES_COUNT" => $r["SALES_COUNT"]
                , "MONTH_YEAR" => $r["MONTH_YEAR"]
                , "TOTAL_SALES" => $r["TOTAL_SALES"]
                , "AVG_PRICE" => $r["AVG_PRICE"]);
        }

        return $result;
    }

    public function MonthSales($month_year, $city, $county) {
        $result = array();
        $query = "select to_char(sale_date, 'mm/dd/yyyy') sale_date
                  ,      initcap(p.address1)              address
                  ,      ps.price
                  ,      p.prop_id
                  from   pr_property_sales ps
                  ,      pr_properties p
                  ,      rnt_zipcodes z
                  where  p.prop_id = ps.prop_id
                  and    price > 0
                  and    to_char(sale_date, 'mm-yyyy') = :var1
                  and    p.city = :var2
                  and    to_char(z.zipcode) = p.zipcode
                  and    upper(z.county) = :var3
                  order  by price";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $month_year);
        $stmt->setString(2, $city);
        $stmt->setString(3, $county);
        $rs = $stmt->executeQuery();

        while ($rs->next()) {
            $r = $rs->getRow();
            $result[$r["PROP_ID"]] = array("SALE_DATE" => $r["SALE_DATE"]
                        , "ADDRESS" => $r["ADDRESS"]
                        , "PRICE" => $r["PRICE"]);
        }

        return $result;
    }

    public function CommercialSales($county) {
        $result = array();
        $query = "select year
                  ,      sales_count
                  ,      total_sales
                  ,      avg_price
                  from   pr_commercial_summary_mv
                  where county = :var1
                  order  by year desc";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $county);
        $rs = $stmt->executeQuery();


        while ($rs->next()) {
            $r = $rs->getRow();
            $result[$r["YEAR"]] = array("SALES_COUNT" => $r["SALES_COUNT"]
                , "TOTAL_SALES" => $r["TOTAL_SALES"]
                , "AVG_PRICE" => $r["AVG_PRICE"]);
        }

        return $result;
    }

    public function CommercialSalesYear($year, $county) {
        $result = array();
        $query = "select description
                  ,      ucode
                  ,      sales_count
                  ,      total_sales
                  ,      avg_price
                  from   pr_commercial_sales_mv
                  where  sales_year = :var1
                  and    county = :var2
                  order  by description, ucode";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $year);
        $stmt->setString(2, $county);
        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $r = $rs->getRow();
            $result[$r["UCODE"]] = array("DESCRIPTION" => $r["DESCRIPTION"]
                , "SALES_COUNT" => $r["SALES_COUNT"]
                , "TOTAL_SALES" => $r["TOTAL_SALES"]
                , "AVG_PRICE" => $r["AVG_PRICE"]);
        }
        return $result;
    }

    public function CommercialClassSales($ucode, $year, $county) {
        $result = array();
        $query = "select to_char(sale_date, 'mm/dd/yyyy') sale_date
                  ,      initcap(p.address1)||', '
                         ||initcap(p.city)||', '||p.state||' '||p.zipcode  as address
                  ,      ps.price
                  ,      p.prop_id
                  ,      p.acreage
                  ,      p.sq_ft
                  from   pr_property_sales ps
                  ,      pr_properties p
                  ,      pr_property_usage pu
                  ,      rnt_zipcodes z
                  where  p.prop_id = ps.prop_id
                  and    p.prop_id = pu.prop_id
                  and    pu.ucode = :var1
                  and    price > 0
                  and    to_char(sale_date, 'yyyy') = :var2
                  and    to_char(z.zipcode) = p.zipcode
                  and    upper(z.county) = :var3
                  order  by price";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $ucode);
        $stmt->setString(2, $year);
        $stmt->setString(3, $county);

        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $r = $rs->getRow();
            $result[$r["PROP_ID"]] = array("SALE_DATE" => $r["SALE_DATE"]
                        , "ADDRESS" => $r["ADDRESS"]
                        , "SQ_FT" => $r["SQ_FT"]
                        , "ACREAGE" => $r["ACREAGE"]
                        , "PRICE" => $r["PRICE"]);
        }

        return $result;
    }

    public function LandSales($county) {
        $result = array();
        $query = "select year
                  ,      sales_count
                  ,      total_sales
                  ,      avg_price
                  from   pr_land_summary_mv
                  where county = :var1
                  order  by year desc";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $county);

        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $r = $rs->getRow();
            $result[$r["YEAR"]] = array("SALES_COUNT" => $r["SALES_COUNT"]
                , "TOTAL_SALES" => $r["TOTAL_SALES"]
                , "AVG_PRICE" => $r["AVG_PRICE"]);
        }

        return $result;
    }

    public function LandSalesYear($year, $county) {
        $result = array();
        $query = "select description
                  ,      ucode
                  ,      sales_count
                  ,      total_sales
                  ,      avg_price
                  from   pr_land_sales_mv
                  where  sales_year = :var1
                  and    county     = :var2
                  order  by description, ucode";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $year);
        $stmt->setString(2, $county);
        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $r = $rs->getRow();
            $result[$r["UCODE"]] = array("DESCRIPTION" => $r["DESCRIPTION"]
                , "SALES_COUNT" => $r["SALES_COUNT"]
                , "TOTAL_SALES" => $r["TOTAL_SALES"]
                , "AVG_PRICE" => $r["AVG_PRICE"]);
        }
        return $result;
    }

    public function MultiplePropertyOwners($city, $zipcode) {
        $result = array();
        if ($city || $zipcode) {
            $query = "select initcap(o.owner_name) owner_name
                      ,      o.owner_id
                      ,      puc.description
                      ,      count(*) property_count
                      from pr_owners o
                      ,    pr_property_owners po
                      ,    pr_properties p
                      ,    pr_property_usage pu
                      ,    pr_usage_codes uc
                      ,    pr_usage_codes puc
                      where o.owner_id = po.owner_id
                      and po.prop_id = p.prop_id
                      and p.zipcode = nvl(:var1, p.zipcode)
                      and p.city = nvl(upper(:var2), p.city)               
                      and p.prop_id = pu.prop_id
                      and pu.ucode = uc.ucode
                      and uc.parent_ucode = puc.ucode
                      group by o.owner_name, o.owner_id, puc.description having count(*) > 4
                      order by o.owner_name, o.owner_id, puc.description";

            $stmt = $this->connection->prepareStatement($query);
            $stmt->setString(1, $zipcode);
            $stmt->setString(2, $city);
        } else {
            $query = "select initcap(o.owner_name) owner_name
                      ,      o.owner_id
                      ,      'Single Family Rental' description
                      ,      count(*) property_count
                      from pr_owners o
                      ,    pr_property_owners po
                      ,    pr_properties p
                      ,    pr_property_usage pu
                      where po.owner_id = o.owner_id
                      and po.prop_id = p.prop_id
                      and p.prop_id = pu.prop_id
                      and pu.ucode in (110, 90001)
                      and p.year_built > 1994
                      and p.sq_ft > 1100
                      group by o.owner_name, o.owner_id, 3 having count(*) > 25
                      order by o.owner_name";

            $stmt = $this->connection->prepareStatement($query);
        }


        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $r = $rs->getRow();
            $result[$r["OWNER_ID"]] = array("OWNER_NAME" => $r["OWNER_NAME"]
                , "DESCRIPTION" => $r["DESCRIPTION"]
                , "PROPERTY_COUNT" => $r["PROPERTY_COUNT"]);
        }


        return $result;
    }

    public function over15years($city, $zipcode) {
        $result = array();
        if ($city || $zipcode) {
            $query = "select initcap(o.owner_name) owner_name
                      ,      o.owner_id
                      ,      puc.description
                      ,      count(*) property_count
                      from pr_owners o
                      ,    pr_property_owners po
                      ,    pr_properties p
                      ,    pr_property_usage pu
                      ,    pr_usage_codes uc
                      ,    pr_usage_codes puc
                      where o.owner_id = po.owner_id
                      and po.prop_id = p.prop_id
                      and p.zipcode = nvl(:var1, p.zipcode)
                      and p.city = nvl(upper(:var2), p.city)               
                      and p.prop_id = pu.prop_id
                      and pu.ucode = uc.ucode
                      and uc.parent_ucode = puc.ucode
                      and exists (select 1
                                  from pr_property_owners po2
                                  ,    pr_property_sales ps
                                  where po2.prop_id = po.prop_id
                                  and po2.prop_id = ps.prop_id
                                  and ps.new_owner_id = po2.owner_id
                                  and po2.owner_id = po.owner_id
                                  and ps.sale_date < add_months(sysdate, -180))
                      group by o.owner_name, o.owner_id, puc.description 
                      order by o.owner_name, o.owner_id, puc.description";

            $stmt = $this->connection->prepareStatement($query);
            $stmt->setString(1, $zipcode);
            $stmt->setString(2, $city);

            $rs = $stmt->executeQuery();
            while ($rs->next()) {
                $r = $rs->getRow();
                $result[$r["OWNER_ID"]] = array("OWNER_NAME" => $r["OWNER_NAME"]
                    , "DESCRIPTION" => $r["DESCRIPTION"]
                    , "PROPERTY_COUNT" => $r["PROPERTY_COUNT"]);
            }
        }

        return $result;
    }

    public function RecentTransactions($city, $zipcode, $deed_code) {
        $result = array();
        if ($deed_code && ($city || $zipcode)) {
            $query = "select initcap(o.owner_name)       owner_name
                      ,      o.owner_id
                      ,      initcap(p.address1)         address1
                      ,      initcap(p.city)             city
                      ,      p.state
                      ,      p.zipcode
                      ,      p.prop_id
                      from   pr_owners o
                      ,      pr_property_owners po
                      ,      pr_properties p
                      ,      pr_property_sales ps
                      where po.owner_id = o.owner_id
                      and p.prop_id = po.prop_id
                      and p.zipcode = nvl(:var1, p.zipcode)
                      and p.city = nvl(upper(:var2), p.city)               
                      and ps.prop_id = p.prop_id
                      and ps.sale_date > (sysdate - 90)
                      and ps.deed_code = :var3
                      order by o.owner_name,  p.address1";
            $stmt = $this->connection->prepareStatement($query);
            $stmt->setString(1, $zipcode);
            $stmt->setString(2, $city);
            $stmt->setString(3, $deed_code);

            $rs = $stmt->executeQuery();
            while ($rs->next()) {
                $r = $rs->getRow();
                $result[$r["OWNER_ID"]] = array("OWNER_NAME" => $r["OWNER_NAME"]
                            , "ADDRESS1" => $r["ADDRESS1"]
                            , "CITY" => $r["CITY"]
                            , "STATE" => $r["STATE"]
                            , "ZIPCODE" => $r["ZIPCODE"]
                            , "PROP_ID" => $r["PROP_ID"]);
            }
        } elseif ($city || $zipcode) {
            $query = "select d.deed_code, d.description, count(*) deed_count
                      from   pr_deed_codes d
                      ,      pr_property_sales ps
                      ,      pr_properties p
                      where  ps.deed_code = d.deed_code
                      and    ps.sale_date > (sysdate - 90)
                      and    p.prop_id = ps.prop_id
                      and    p.zipcode = nvl(:var1, p.zipcode)
                      and    p.city = nvl(upper(:var2), p.city)               
                      group  by d.deed_code, d.description
                      order  by d.deed_code, d.description";
            $stmt = $this->connection->prepareStatement($query);
            $stmt->setString(1, $zipcode);
            $stmt->setString(2, $city);

            $rs = $stmt->executeQuery();
            while ($rs->next()) {
                $r = $rs->getRow();
                $result[$r["DEED_CODE"]] = array("DESCRIPTION" => $r["DESCRIPTION"]
                            , "DEED_COUNT" => $r["DEED_COUNT"]);
            }
        }

        return $result;
    }

    public function getOutStateOwner($city, $zipcode) {
        $result = array();

        if ($city || $zipcode) {

            $query = "select initcap(o.owner_name)       owner_name
               ,      o.owner_id
               ,      initcap(p.address1)         address1
               ,      initcap(p.city)             city
               ,      p.state
               ,      p.zipcode
               ,      p.prop_id
               ,      initcap(p2.address1)        m_address1
               ,      initcap(p2.city)            m_city
               ,      p2.state                    m_state
               ,      p2.zipcode                  m_zipcode
               ,      uc.description              usage
               from pr_owners o
               ,    pr_property_owners po
               ,    pr_properties p
               ,    pr_properties p2
               ,    pr_usage_codes uc
               ,    pr_property_usage pu
               where po.owner_id = o.owner_id
               and p.prop_id = po.prop_id
               and p.state != p2.state
               and p.zipcode = nvl(:var1, p.zipcode)
               and p.city = nvl(upper(:var2), p.city)               
               and po.mailing_id = p2.prop_id
               and pu.prop_id = p.prop_id
               and pu.ucode = uc.ucode
               order by o.owner_name,  p.address1";

            $stmt = $this->connection->prepareStatement($query);
            $stmt->setString(1, $zipcode);
            $stmt->setString(2, $city);
            $rs = $stmt->executeQuery();
            while ($rs->next()) {
                $r = $rs->getRow();
                $result[$r["OWNER_ID"]] = array("OWNER_NAME" => $r["OWNER_NAME"]
                            , "ADDRESS1" => $r["ADDRESS1"]
                            , "CITY" => $r["CITY"]
                            , "STATE" => $r["STATE"]
                            , "ZIPCODE" => $r["ZIPCODE"]
                            , "PROP_ID" => $r["PROP_ID"]
                            , "M_ADDRESS1" => $r["M_ADDRESS1"]
                            , "M_CITY" => $r["M_CITY"]
                            , "M_STATE" => $r["M_STATE"]
                            , "M_ZIPCODE" => $r["M_ZIPCODE"]
                            , "USAGE" => $r["USAGE"]
                );
            }
        }
        return $result;
    }

    public function getOwner($owner_name) {
        $result = array();

        if ($owner_name) {

            $query = "select initcap(o.owner_name)       owner_name
               ,      o.owner_id
               ,      initcap(p.address1)         address1
               ,      initcap(p.city)             city
               ,      p.state
               ,      p.zipcode
               ,      p.prop_id
               from pr_owners o
               ,    pr_property_owners po
               ,    pr_properties p
               where po.owner_id = o.owner_id
               and catsearch(o.owner_name, :var1, null) > 0
               and po.mailing_id = p.prop_id
               order by o.owner_name,  p.address1";

            $stmt = $this->connection->prepareStatement($query);
            $stmt->setString(1, $owner_name);

            $rs = $stmt->executeQuery();

            while ($rs->next()) {
                $r = $rs->getRow();
                $result[$r["OWNER_ID"]] = array("OWNER_NAME" => $r["OWNER_NAME"]
                            , "ADDRESS1" => $r["ADDRESS1"]
                            , "CITY" => $r["CITY"]
                            , "STATE" => $r["STATE"]
                            , "ZIPCODE" => $r["ZIPCODE"]
                            , "PROP_ID" => $r["PROP_ID"]
                );
            }
        }
        return $result;
    }

    public function getProperty($address, $city) {
        $result = array();
        $city = htmlentities($city, ENT_QUOTES);
        if ($address) {
            if ($city) {
                $city_query = " and city = upper(''$city'')";
            } else {
                $city_query = " ";
            }

            $query = "select initcap(o.owner_name)       owner_name
               ,      o.owner_id
               ,      initcap(p.address1)||', '||p.address2   address1
               ,      initcap(p.city)             city
               ,      p.state
               ,      p.zipcode
               ,      p.prop_id
               from pr_owners o
               ,    pr_property_owners po
               ,    pr_properties p
               where po.owner_id = o.owner_id
               and contains( p.address1
                        , pr_records_pkg.standard_suffix(:var1)
                        , 1) > 0
               and po.prop_id = p.prop_id" . $city_query . "
               order by o.owner_name,  p.address1";

            $stmt = $this->connection->prepareStatement($query);
            $stmt->setString(1, $address);


            $rs = $stmt->executeQuery();

            while ($rs->next()) {
                $r = $rs->getRow();
                $result[$r["OWNER_ID"]] = array("OWNER_NAME" => $r["OWNER_NAME"]
                            , "ADDRESS1" => $r["ADDRESS1"]
                            , "CITY" => $r["CITY"]
                            , "STATE" => $r["STATE"]
                            , "ZIPCODE" => $r["ZIPCODE"]
                            , "PROP_ID" => $r["PROP_ID"]
                );
            }
        }
        return $result;
    }

    public function getCorpDetails($corp_number) {
        $corp = array();
        $query = "select replace(initcap(name),'Llc', 'LLC') name
           ,      status
           ,      filing_type
           ,      filing_date
           ,      fei_number
           from pr_corporations
           where corp_number = :var1";

        $query1 = "select initcap(l.address1) address1
           ,       initcap(l.address2) address2
           ,       initcap(l.city)     city
           ,       l.state
           ,       l.zipcode
           ,       l.prop_id
           ,       l.loc_id
           ,       l.geo_location.sdo_point.x lon
           ,       l.geo_location.sdo_point.y lat
           ,       l.geo_found_yn
           from pr_locations l
           ,    pr_corporate_locations cl
           where cl.corp_number = :var1
           and cl.loc_id = l.loc_id
           and cl.loc_type = 'PRIN'
           and rownum < 2";

        $query2 = "select initcap(l.address1) address1
           ,       initcap(l.address2) address2
           ,       initcap(l.city)     city
           ,       l.state
           ,       l.zipcode
           ,       l.prop_id
           from pr_properties l
           ,    pr_property_owners po
           ,    pr_owners o
           ,    pr_corporations c
           where c.corp_number = :var1
           and c.owner_id = o.owner_id
           and o.owner_id = po.owner_id
           and po.prop_id = l.prop_id
           order by l.address1";


        $stmt = $this->connection->prepareStatement($query1);
        $stmt->setString(1, $corp_number);
        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $r = $rs->getRow();
            $county = $this->getCounty($r["ZIPCODE"]);
            $addr = array("ADDRESS1" => $r["ADDRESS1"]
                        , "ADDRESS2" => $r["ADDRESS2"]
                        , "CITY" => $r["CITY"]
                        , "STATE" => $r["STATE"]
                        , "ZIPCODE" => $r["ZIPCODE"]
                        , "PROP_ID" => $r["PROP_ID"]
                        , "LAT" => $r["LAT"]
                        , "LON" => $r["LON"]
                        , "GEO_FOUND" => $r["GEO_FOUND_YN"]
                        , "COUNTY" => $county["COUNTY"]);
            $lat = $r["LAT"];
            $long = $r["LON"];
            $geo_found = $r["GEO_FOUND_YN"];
        }

        $addr2 = array();
        $stmt = $this->connection->prepareStatement($query2);
        $stmt->setString(1, $corp_number);
        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $r = $rs->getRow();
            $addr2[] = array("ADDRESS1" => $r["ADDRESS1"]
                        , "ADDRESS2" => $r["ADDRESS2"]
                        , "CITY" => $r["CITY"]
                        , "STATE" => $r["STATE"]
                        , "ZIPCODE" => $r["ZIPCODE"]
                        , "PROP_ID" => $r["PROP_ID"]);
        }

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $corp_number);
        $rs = $stmt->executeQuery();

        while ($rs->next()) {
            $r = $rs->getRow();
            $corp["SUNBIZ-ID"] = array("NAME" => $r["NAME"]
                        , "CORP_NUMBER" => $corp_number
                        , "STATUS" => $r["STATUS"]
                        , "FILING_TYPE" => $r["FILING_TYPE"]
                        , "FILING_DATE" => $r["FILING_DATE"]
                        , "FEI_NUMBER" => $r["FEI_NUMBER"]
                        , "ADDR" => $addr
                        , "PROPERTIES" => $addr2);
        }

        $query = "select p.pn_id
           ,       p.pn_type
           ,       initcap(p.pn_name) name
           ,       cp.title_code
           ,       regexp_substr(lower(p.pn_name),
                                  '[^ ]+\w+',1,2) first_name
           ,       regexp_substr(lower(p.pn_name),
                                  '^\w+{1}') last_name
           ,       cp.title_code
           from pr_corporate_positions cp
           ,    pr_principals p
           where cp.corp_number = :var1
           and cp.pn_id = p.pn_id
           order by cp.title_code, p.pn_name";

        $query2 = "select replace(initcap(c.name),'Llc', 'LLC') name
           ,       c.corp_number
           ,       cp.title_code
           from pr_corporate_positions cp
           ,    pr_corporations c
           where cp.pn_id = :var1
           and cp.corp_number = c.corp_number
           and cp.corp_number != :var2
           and rownum < 50
           order by c.name";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $corp_number);
        $rs = $stmt->executeQuery();

        $query3 = "select initcap(l.address1) address1
           ,       initcap(l.address2) address2
           ,       initcap(l.city)     city
           ,       l.state
           ,       l.zipcode
           ,       l.prop_id
           ,       l.loc_id
           from pr_principal_locations pl
           ,    pr_locations l
           where pl.pn_id = :var1
           and pl.loc_id = l.loc_id
           order by l.prop_id, l.address1";


        while ($rs->next()) {
            $r = $rs->getRow();
            $pnid = $r["TITLE_CODE"] . $r["PN_ID"];
            //   if ($r["TITLE_CODE"] != "R")
            {
                $corp2 = array();
                $stmt2 = $this->connection->prepareStatement($query2);
                $stmt2->setInt(1, $r["PN_ID"]);
                $stmt2->setString(2, $corp_number);
                $rs2 = $stmt2->executeQuery();

                while ($rs2->next()) {
                    $r2 = $rs2->getRow();
                    $corp2[$r2["CORP_NUMBER"]] = array("CORP_NUMBER" => $r2["CORP_NUMBER"]
                                , "NAME" => $r2["NAME"]
                                , "TITLE_CODE" => $r2["TITLE_CODE"]);
                }
            }

            $corp3 = array();
            $stmt3 = $this->connection->prepareStatement($query3);
            $stmt3->setInt(1, $r["PN_ID"]);
            $rs3 = $stmt3->executeQuery();

            while ($rs3->next()) {
                $r3 = $rs3->getRow();
                $county = $this->getCounty($r3["ZIPCODE"]);
                $corp3[$r3["LOC_ID"]] = array("ADDRESS1" => $r3["ADDRESS1"]
                            , "ADDRESS2" => $r3["ADDRESS2"]
                            , "CITY" => $r3["CITY"]
                            , "STATE" => $r3["STATE"]
                            , "ZIPCODE" => $r3["ZIPCODE"]
                            , "PROP_ID" => $r3["PROP_ID"]
                            , "COUNTY" => $county["COUNTY"]);
            }



            $corp[$r["PN_ID"]] = array("NAME" => $r["NAME"]
                        , "TITLE_CODE" => $r["TITLE_CODE"]
                        , "PN_ID" => $r["PN_ID"]
                        , "PN_TYPE" => $r["PN_TYPE"]
                        , "FIRST_NAME" => $r["FIRST_NAME"]
                        , "LAST_NAME" => $r["LAST_NAME"]
                        , "ADDR" => $corp3
                        , "CORP" => $corp2);
        }

        if ($geo_found == 'Y' && MAINTENANCE_MODE != "Y") {
            $query = "SELECT corp_name name
        ,   corp_number
        ,   address1
        ,   lat
        ,   lon
        ,   prop_id
        FROM  table(pr_geo_utils_pkg.get_nearby_corps(" . $lat . ", " . $long . "))
        where loc_type = 'PRIN'";

            $loop_counter = 0;
            $stmt = $this->connection->prepareStatement($query);
            $rs = $stmt->executeQuery();

            while ($rs->next()) {
                $r = $rs->getRow();
                $corp["NEARBY"][] = array("CORP_NUMBER" => $r["CORP_NUMBER"]
                            , "CORP_NAME" => $r["NAME"]
                            , "ADDRESS1" => $r["ADDRESS1"]
                            , "LAT" => $r["LAT"]
                            , "LON" => $r["LON"]
                            , "PROP_ID" => $r["PROP_ID"]);
            }
        }

        return $corp;
    }

    public function getOwnerDetails($owner_id) {
        $mailing_address = array();
        $transactions = array();
        $properties = array();
        $result = array();
        $corp = array();
        $query = "select c.corp_number
               ,      o.owner_name name
               from pr_corporations c
               ,    pr_owners o
               where o.owner_name = c.name(+)
               and o.owner_id=:var1";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $owner_id);
        $rs = $stmt->executeQuery();

        while ($rs->next()) {
            $r = $rs->getRow();
            $corp = array("NAME" => $r["NAME"]
                , "NUMBER" => $r["CORP_NUMBER"]);
        }

        $query = "select distinct(po.mailing_id) mailing_id
               ,      initcap(o.owner_name)   owner_name
               ,      initcap(p.address1)     address1
               ,      initcap(p.address2)     address2
               ,      initcap(p.city)         city
               ,      p.state||p.zipcode      state_zip
               from pr_property_owners po
               ,    pr_properties p
               ,    pr_owners o
               where po.owner_id = :var1
               and po.owner_id = o.owner_id
               and po.mailing_id = p.prop_id(+)";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $owner_id);
        $rs = $stmt->executeQuery();

        while ($rs->next()) {
            $r = $rs->getRow();
            $mailing_address[$r["MAILING_ID"]] = array("OWNER_NAME" => $r["OWNER_NAME"]
                        , "OWNER_ID" => $owner_id
                        , "ADDRESS1" => $r["ADDRESS1"]
                        , "ADDRESS2" => $r["ADDRESS2"]
                        , "CITY" => $r["CITY"]
                        , "STATE_ZIP" => $r["STATE_ZIP"]);
        }
        $query = "select s.sale_date
                     ,      to_char(s.sale_date, 'mm/dd/yyyy') display_date
                     ,      'Purchased'                        buy_sell
                     ,      p.prop_id
                     ,      initcap(p.address1)                address1
                     ,      initcap(p.city)                    city
                     ,      d.description                      deed_desc
                     ,      d.definition                       deed_def
                     ,      s.price
                     from pr_property_sales s
                     ,    pr_properties p
                     ,    pr_deed_codes d
                     where s.new_owner_id = :var1
                     and p.prop_id = s.prop_id
                     and s.deed_code = d.deed_code
                    UNION
                    select s.sale_date
                    ,      to_char(s.sale_date, 'mm/dd/yyyy') display_date
                    ,      'Sold'                        buy_sell
                    ,      p.prop_id
                    ,      initcap(p.address1)                address1
                    ,      initcap(p.city)                    city
                    ,      d.description                      deed_desc
                    ,      d.definition                       deed_def
                    ,      s.price
                    from pr_property_sales s
                    ,    pr_properties p
                    ,    pr_deed_codes d
                    where s.old_owner_id = :var2 
                    and p.prop_id = s.prop_id
                    and s.deed_code = d.deed_code(+)
                    order by 1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $owner_id);
        $stmt->setInt(2, $owner_id);
        $rs = $stmt->executeQuery();

        $loop_counter = 0;
        while ($rs->next()) {
            $r = $rs->getRow();
            $loop_counter = $loop_counter + 1;
            $transactions[$loop_counter] = array("SALE_DATE" => $r["DISPLAY_DATE"]
                        , "BUY_SELL" => $r["BUY_SELL"]
                        , "PROP_ID" => $r["PROP_ID"]
                        , "ADDRESS1" => $r["ADDRESS1"]
                        , "CITY" => $r["CITY"]
                        , "PRICE" => $r["PRICE"]
                        , "DEED_DESC" => $r["DEED_DESC"]
                        , "DEED_DEF" => $r["DEED_DEF"]);
        }

        $query = "select s.sale_date
               ,      to_char(s.sale_date, 'mm/dd/yyyy') display_date
               ,      p.prop_id
               ,      initcap(p.address1)     address1
               ,      initcap(p.city)         city
               ,      s.price
               from pr_property_owners po
               ,    pr_properties p
               ,    pr_property_sales s
               where po.owner_id = :var1
               and po.prop_id = p.prop_id
               and p.prop_id  = s.prop_id(+)
               order by s.sale_date";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $owner_id);
        $rs = $stmt->executeQuery();

        while ($rs->next()) {
            $r = $rs->getRow();
            $properties[$r["PROP_ID"]] = array("ADDRESS1" => $r["ADDRESS1"]
                        , "CITY" => $r["CITY"]
                        , "SALE_DATE" => $r["DISPLAY_DATE"]
                        , "PRICE" => $r["PRICE"]);
        }

        $result = array("CORP" => $corp
            , "MAILING_ADDRESS" => $mailing_address
            , "TRANSACTIONS" => $transactions
            , "PROPERTIES" => $properties);

        return $result;
    }

    public function getZipcodeData($zipcode) {
        $query = "select ZIPCODE
                 ,      PLACE_NAME
                 ,      STATE_NAME
                 ,      COUNTY
                 ,      z.GEO_LOCATION.sdo_point.x LON
                 ,      z.GEO_LOCATION.sdo_point.y LAT
                 ,      to_char(COUNTY_WT * 100, '999') COUNTY_WT
                 ,      to_char(CITY_WT * 100, '999') city_wt
                 ,      ZIP_WT
                 from rnt_zipcodes z
                 where zipcode = :var1";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $zipcode);
        $rs = $stmt->executeQuery();

        while ($rs->next()) {
            $r = $rs->getRow();
        }

        $query = "select ZIPCODE
                 from rnt_zipcodes z
                 where PLACE_NAME = :var1
                 and   STATE_NAME = :var2
                 order by ZIPCODE";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $r["PLACE_NAME"]);
        $stmt->setString(2, $r["STATE_NAME"]);
        $rs = $stmt->executeQuery();

        while ($rs->next()) {
            $z[] = $rs->getRow();
        }
        $r["ZIPCODES"] = $z;

        $query = "select count(*) agent_count
                from  pr_licensed_agents
                where zipcode = :var1
                and secondary_status='Active'";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $zipcode);
        $rs = $stmt->executeQuery();

        while ($rs->next()) {
            $a = $rs->getRow();
        }
        $r["AGENT_COUNT"] = $a["AGENT_COUNT"];


        return $r;
    }

    public function getCourses($zipcode) {
        $query = "select c.Course_Number
                ,      initcap(c.course_name) course_name
                ,      count(*) course_count
                from pr_courses c
                ,    pr_agent_courses ac
                ,    pr_licensed_agents a
                where a.zipcode = :var1
                and a.secondary_status='Active'
                and a.License_Number = ac.License_Number
                and ac.Course_Number = c.Course_Number
                group by c.Course_Number, c.course_name
                order by c.course_name";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $zipcode);
        $rs = $stmt->executeQuery();

        while ($rs->next()) {
            $r = $rs->getRow();
            $result[] = $r;
        }
        return $result;
    }

    public function getAgentList($zipcode, $course) {
        $query = "select a.License_Number
                ,      initcap(a.Licensee_Name) Licensee_Name
                ,      ac.Course_Date
                ,      initcap(c.course_name) course_name
                from pr_courses c
                ,    pr_agent_courses ac
                ,    pr_licensed_agents a
                where a.zipcode = :var1
                and c.course_number = :var2
                and a.secondary_status='Active'
                and a.License_Number = ac.License_Number
                and ac.Course_Number = c.Course_Number
                order by a.licensee_name, ac.Course_Date desc";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $zipcode);
        $stmt->setString(2, $course);
        $rs = $stmt->executeQuery();

        while ($rs->next()) {
            $r = $rs->getRow();
            $result[] = $r;
        }
        return $result;
    }

    public function getAgent($license) {
        $query = "select a.license_Number
               ,       initcap(a.Licensee_Name) name
               ,       regexp_substr(a.Licensee_Name, '[^, .]+', 1, 2) first_name
               ,       regexp_substr(a.Licensee_Name, '[^, .]+', 1, 1) last_name
               ,       a.DBA_Name
               ,       a.license_type
               ,       initcap(a.Address1) address1
               ,       a.Address2
               ,       a.Address3
               ,       initcap(a.City) city
               ,       a.State
               ,       a.zipcode
               ,       a.Primary_Status
               ,       a.Secondary_Status
               ,       a.license_date
               ,       a.Sole_Proprietor
               ,       a.Employer_License_Number
               ,       initcap(b.Licensee_Name)         brokerage
               from pr_licensed_agents a
               ,    pr_licensed_agents b
               where a.License_Number= :var1
               and a.Employer_License_Number = b.license_Number(+)";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $license);
        $rs = $stmt->executeQuery();

        while ($rs->next()) {
            $r = $rs->getRow();
        }

        $query = "select license_Number
               ,       initcap(Licensee_Name) name
               ,       license_type
               ,       initcap(City) city
               ,       State
               ,       zipcode
               ,       Primary_Status
               ,       Secondary_Status
               ,       license_date
               from pr_licensed_agents
               where Employer_License_Number= :var1
               order by Licensee_Name";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $license);
        $rs = $stmt->executeQuery();

        while ($rs->next()) {
            $agent[] = $rs->getRow();
        }

        $r["AGENTS"] = $agent;

        $query = "select initcap(c.course_name) course_name
                ,      ac.Course_Date
                ,      ac.course_number
                ,      ac.course_credit_hours
                from pr_courses c
                ,    pr_agent_courses ac
                where ac.License_Number = :var1
                and ac.Course_Number = c.Course_Number
                order by ac.Course_Date desc,  c.course_name";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $license);
        $rs = $stmt->executeQuery();

        while ($rs->next()) {
            $course[] = $rs->getRow();
        }

        $r["COURSES"] = $course;

        return $r;
    }

    public function getSellers($start_date, $end_date, $owner_name, $sale_count) {
        $date_fmt = "mm/dd/yyyy";
        $sale_count = $sale_count - 1;

        $result = array();
        $query = "select initcap(o.owner_name) owner_name
                           ,      o.owner_id
                                                         ,      count(*) p_count
               from pr_owners o
               ,    pr_property_sales ps
               where o.owner_id = ps.old_owner_id
               and ps.sale_date >= to_date(:var1, '$date_fmt')
                                                         and ps.sale_date <= to_date(:var2, '$date_fmt')
                                                         and o.owner_name like upper('%'||:var3||'%')
               group by owner_name, owner_id  having count(*) > :var4
               order by owner_name, owner_id";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $start_date);
        $stmt->setString(2, $end_date);
        $stmt->setString(3, $owner_name);
        $stmt->setInt(4, $sale_count);
        $rs = $stmt->executeQuery();

        while ($rs->next()) {
            $r = $rs->getRow();
            $result[$r["OWNER_ID"]] = array("OWNER_NAME" => $r["OWNER_NAME"]
                        , "PROPERTY_COUNT" => $r["P_COUNT"]);
        }
        return $result;
    }

    public function getBuyers($start_date, $end_date, $owner_name, $sale_count) {
        $date_fmt = "mm/dd/yyyy";
        $sale_count = $sale_count - 1;

        $result = array();
        $query = "select initcap(o.owner_name) owner_name
                           ,      o.owner_id
                                                         ,      count(*) p_count
               from pr_owners o
               ,    pr_property_sales ps
               where o.owner_id = ps.new_owner_id
               and ps.sale_date >= to_date(:var1, '$date_fmt')
                                                         and ps.sale_date <= to_date(:var2, '$date_fmt')
                                                         and o.owner_name like upper('%'||:var3||'%')
               group by owner_name, owner_id  having count(*) > :var4
               order by owner_name, owner_id";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $start_date);
        $stmt->setString(2, $end_date);
        $stmt->setString(3, $owner_name);
        $stmt->setInt(4, $sale_count);
        $rs = $stmt->executeQuery();

        while ($rs->next()) {
            $r = $rs->getRow();
            $result[$r["OWNER_ID"]] = array("OWNER_NAME" => $r["OWNER_NAME"]
                        , "PROPERTY_COUNT" => $r["P_COUNT"]);
        }

        return $result;
    }

    public function getPropertyDetails($prop_id) {
        $result = array();
        $property_usage = array();
        $buildings = array();
        $building_usage = array();
        $building_features = array();
        $owner = array();
        $corporations = array();
        $taxes = array();
        $sales_history = array();
        $property_photos = array();
        $documents = array();

        $query = "SELECT initcap(p.ADDRESS1) address1
               ,      initcap(p.ADDRESS2) address2
               ,      initcap(p.CITY)     city
               ,      p.STATE
               ,      p.ZIPCODE
               ,      p.ACREAGE
               ,      p.SQ_FT
               ,      s.SOURCE_NAME
               ,      s.SOURCE_TYPE
               ,      s.BASE_URL
               ,      replace(replace(s.PHOTO_URL, '[[SOURCE_PK]]', p.SOURCE_PK), '[[ALT_KEY]]', p.alt_key)    photo_url
               ,      replace(replace(s.PROPERTY_URL, '[[SOURCE_PK]]', p.SOURCE_PK), '[[ALT_KEY]]', p.alt_key) property_url
               ,      replace(replace(s.TAX_URL, '[[SOURCE_PK]]', p.SOURCE_PK), '[[ALT_KEY]]', p.alt_key)      tax_url
               ,      p.PROP_ID
               ,      p.geo_location.sdo_point.x lon
               ,      p.geo_location.sdo_point.y lat
               ,      p.TOTAL_BEDROOMS
               ,      p.TOTAL_BATHROOMS
               ,      p.geo_found_yn
               ,      p.prop_class
               ,      p.quality_code
               ,      p.year_built
               ,      p.value_group
               ,      p.puma
               ,      p.puma_percentile
               ,      p.rental_percentile
               ,      mls_price_ranges_pkg.get_county_desc(s.source_name) county_desc
               ,      nvl(p.hidden, 'N') hidden
               ,      p.building_count
               ,      p.residential_units
               FROM PR_PROPERTIES p
                 ,    PR_SOURCES s
                 where p.prop_id = :var1
                 and p.source_id = s.source_id";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $prop_id);
        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $r = $rs->getRow();
            $property = array("ADDRESS1" => $r["ADDRESS1"]
                , "ADDRESS2" => $r["ADDRESS2"]
                , "CITY" => $r["CITY"]
                , "STATE" => $r["STATE"]
                , "ZIPCODE" => $r["ZIPCODE"]
                , "ACREAGE" => $r["ACREAGE"]
                , "SQ_FT" => $r["SQ_FT"]
                , "SOURCE" => $r["SOURCE_NAME"]
                , "SOURCE_TYPE" => $r["SOURCE_TYPE"]
                , "SOURCE_URL" => $r["BASE_URL"]
                , "PHOTO_URL" => $r["PHOTO_URL"]
                , "PROPERTY_URL" => $r["PROPERTY_URL"]
                , "TAX_URL" => $r["TAX_URL"]
                , "PROP_ID" => $prop_id
                , "LAT" => $r["LAT"]
                , "LON" => $r["LON"]
                , "TOTAL_BEDROOMS" => $r["TOTAL_BEDROOMS"]
                , "TOTAL_BATHROOMS" => $r["TOTAL_BATHROOMS"]
                , "GEO_FOUND_YN" => $r["GEO_FOUND_YN"]
                , "PROP_CLASS" => $r["PROP_CLASS"]
                , "QUALITY_CODE" => $r["QUALITY_CODE"]
                , "YEAR_BUILT" => $r["YEAR_BUILT"]
                , "PUMA" => $r["PUMA"]
                , "PUMA_PERCENTILE" => $r["PUMA_PERCENTILE"]
                , "RENTAL_PERCENTILE" => $r["RENTAL_PERCENTILE"]
                , "HIDDEN" => $r["HIDDEN"]
                , "BUILDING_COUNT" => $r["BUILDING_COUNT"]
                , "RESIDENTIAL_UNITS" => $r["RESIDENTIAL_UNITS"]
                , "COUNTY_DESC" => $r["COUNTY_DESC"]);
        }
        if ($property) {
            $query = "SELECT u.UCODE
               ,      uc.DESCRIPTION
               FROM PR_PROPERTY_USAGE u
               ,    PR_USAGE_CODES UC
               WHERE u.PROP_ID = :var1
               AND uc.UCODE    = u.UCODE
               ORDER BY u.UCODE";

            $stmt = $this->connection->prepareStatement($query);
            $stmt->setInt(1, $prop_id);
            $rs = $stmt->executeQuery();
            while ($rs->next()) {
                $r = $rs->getRow();
                $property_usage[$r["UCODE"]] = $r["DESCRIPTION"];
            }

            $query = "SELECT BUILDING_ID
               ,      BUILDING_NAME
               ,      YEAR_BUILT
               ,      SQ_FT
               FROM PR_BUILDINGS
               WHERE PROP_ID = :var1
               ORDER BY BUILDING_NAME";

            $stmt = $this->connection->prepareStatement($query);
            $stmt->setInt(1, $prop_id);
            $rs = $stmt->executeQuery();
            while ($rs->next()) {
                $r = $rs->getRow();
                $building_id = $r["BUILDING_ID"];

                $subquery = "SELECT u.UCODE
                    ,      uc.DESCRIPTION
                    FROM PR_BUILDING_USAGE u
                    ,    PR_USAGE_CODES UC
                    WHERE u.BUILDING_ID = :var1
                    AND uc.UCODE    = u.UCODE
                    ORDER BY u.UCODE";
                $stmt2 = $this->connection->prepareStatement($subquery);
                $stmt2->setInt(1, $building_id);
                $srs = $stmt2->executeQuery();
                while ($srs->next()) {
                    $sr = $srs->getRow();
                    $building_usage[$sr["UCODE"]] = $sr["DESCRIPTION"];
                }

                $subquery = "SELECT f.FCODE
                    ,      fc.DESCRIPTION
                    FROM PR_BUILDING_FEATURES f
                    ,    PR_FEATURE_CODES fc
                    WHERE f.BUILDING_ID = :var1
                    AND fc.FCODE    = f.FCODE
                    ORDER BY f.FCODE";
                $stmt2 = $this->connection->prepareStatement($subquery);
                $stmt2->setInt(1, $building_id);
                $srs = $stmt2->executeQuery();

                while ($srs->next()) {
                    $sr = $srs->getRow();
                    $building_features[$sr["FCODE"]] = $sr["DESCRIPTION"];
                }


                $buildings[$building_id] = array("BUILDING_NAME" => $r["BUILDING_NAME"]
                            , "YEAR_BUILT" => $r["YEAR_BUILT"]
                            , "SQ_FT" => $r["SQ_FT"]
                            , "USAGE" => $building_usage
                            , "FEATURES" => $building_features);
            }

            $query = "SELECT TAX_YEAR
              ,      TAX_VALUE
              ,      TAX_AMOUNT
              FROM PR_TAXES
              WHERE PROP_ID =:var1
              ORDER BY TAX_YEAR";

            $stmt = $this->connection->prepareStatement($query);
            $stmt->setInt(1, $prop_id);
            $rs = $stmt->executeQuery();
            while ($rs->next()) {
                $r = $rs->getRow();
                $taxes[$r["TAX_YEAR"]] = array("TAX_VALUE" => $r["TAX_VALUE"]
                    , "TAX_AMOUNT" => $r["TAX_AMOUNT"]);
            }

            $query = "select PROP_ID
             ,       URL
             ,       TITLE
                         from pr_property_links
                         where prop_id = :var1";

            $stmt = $this->connection->prepareStatement($query);
            $stmt->setInt(1, $prop_id);
            $rs = $stmt->executeQuery();
            while ($rs->next()) {
                $r = $rs->getRow();
                $documents[] = array("URL" => $r["URL"]
                    , "TITLE" => $r["TITLE"]);
            }

            $query = "SELECT initcap(p.ADDRESS1) address1
               ,      initcap(p.ADDRESS2) address2
               ,      initcap(p.CITY)     city
               ,      p.STATE
               ,      p.ZIPCODE
               ,      initcap(o.owner_name) owner
               ,      p.prop_id             mailing_id
               ,      o.owner_id
               FROM PR_PROPERTIES p
               ,    PR_owners o
               ,    PR_PROPERTY_OWNERS po
               where po.prop_id = :var1
               and p.prop_id = po.mailing_id
               and po.owner_id = o.owner_id
               order by o.owner_name";

            $stmt = $this->connection->prepareStatement($query);
            $stmt->setInt(1, $prop_id);
            $rs = $stmt->executeQuery();
            while ($rs->next()) {
                $r = $rs->getRow();
                $owner = array("ADDRESS1" => $r["ADDRESS1"]
                    , "ADDRESS2" => $r["ADDRESS2"]
                    , "CITY" => $r["CITY"]
                    , "STATE" => $r["STATE"]
                    , "ZIPCODE" => $r["ZIPCODE"]
                    , "OWNER" => $r["OWNER"]
                    , "MAILING_ID" => $r["MAILING_ID"]
                    , "OWNER_ID" => $r["OWNER_ID"]);
            }

            $query = "SELECT s.NEW_OWNER_ID
               ,      initcap(o1.owner_name)             new_owner
               ,      to_char(s.SALE_DATE, 'mm/dd/yyyy') display_date
               ,      s.SALE_DATE
               ,      s.DEED_CODE
               ,      d.DESCRIPTION                      deed_desc
               ,      s.PRICE
               ,      s.OLD_OWNER_ID
               ,      initcap(o2.owner_name)             old_owner
               ,      s.PLAT_BOOK
               ,      s.PLAT_PAGE
              FROM PR_PROPERTY_SALES s
              ,    PR_OWNERS o1
              ,    PR_OWNERS o2
              ,    PR_DEED_CODES d
              WHERE d.DEED_CODE = s.DEED_CODE
              AND s.PROP_ID = :var1
              AND s.NEW_OWNER_ID = o1.OWNER_ID
              AND S.OLD_OWNER_ID = o2.OWNER_ID
              ORDER BY s.SALE_DATE";
            $loop_counter = 0;
            $stmt = $this->connection->prepareStatement($query);
            $stmt->setInt(1, $prop_id);
            $rs = $stmt->executeQuery();
            while ($rs->next()) {
                $r = $rs->getRow();
                $loop_counter = $loop_counter + 1;
                $sales_history[$loop_counter] = array("NEW_OWNER_ID" => $r["NEW_OWNER_ID"]
                            , "NEW_OWNER" => $r["NEW_OWNER"]
                            , "SALE_DATE" => $r["DISPLAY_DATE"]
                            , "DEED_CODE" => $r["DEED_CODE"]
                            , "DEED_DESC" => $r["DEED_DESC"]
                            , "PRICE" => $r["PRICE"]
                            , "OLD_OWNER_ID" => $r["OLD_OWNER_ID"]
                            , "OLD_OWNER" => $r["OLD_OWNER"]
                            , "PLAT_BOOK" => $r["PLAT_BOOK"]
                            , "PLAT_PAGE" => $r["PLAT_PAGE"]);
            }


            $query = "select replace(initcap(c.name),'Llc', 'LLC') name
                  ,      c.corp_number
                          ,      l.address1
                          ,      decode( cl.loc_type, 'MAIL', 'Mailing Address'
                                                    , 'PRIN', 'Principal Address') loc_type
                          from pr_corporations c
                          ,    pr_corporate_locations cl
                          ,    pr_locations l
                          where l.prop_id = :var1
                          and l.loc_id = cl.loc_id
                          and cl.corp_number = c.corp_number
                          order by loc_type desc, name";
            $loop_counter = 0;
            $stmt = $this->connection->prepareStatement($query);
            $stmt->setInt(1, $prop_id);
            $rs = $stmt->executeQuery();
            while ($rs->next()) {
                $r = $rs->getRow();
                $loop_counter = $loop_counter + 1;
                $corporations[$loop_counter] = array("CORP_NUMBER" => $r["CORP_NUMBER"]
                            , "CORP_NAME" => $r["NAME"]
                            , "LOC_TYPE" => $r["LOC_TYPE"]);
            }
            if ($property["LAT"] && MAINTENANCE_MODE != "Y") {
                $query ="SELECT corp_name name
        ,   corp_number
        ,   address1
        ,   lat
        ,   lon
        ,   prop_id
        FROM  table(pr_geo_utils_pkg.get_nearby_corps(" . $property["LAT"] . ", " . $property["LON"] . "))
        where loc_type = 'PRIN'";

                $loop_counter = 0;
                $stmt = $this->connection->prepareStatement($query);
                $rs = $stmt->executeQuery();

                while ($rs->next()) {
                    $r = $rs->getRow();
                    $loop_counter = $loop_counter + 1;
                    $corporations2[$loop_counter] = array("CORP_NUMBER" => $r["CORP_NUMBER"]
                                , "CORP_NAME" => $r["NAME"]
                                , "ADDRESS1" => $r["ADDRESS1"]
                                , "LAT" => $r["LAT"]
                                , "LON" => $r["LON"]
                                , "PROP_ID" => $r["PROP_ID"]);
                }
            }
        } else { //it's not a real property id
            $property = array("ADDRESS1" => "1600 Pennsylvania Avenue NW"
                , "ADDRESS2" => ""
                , "CITY" => "Washington"
                , "STATE" => "DC"
                , "ZIPCODE" => "20500"
                , "ACREAGE" => "18"
                , "SQ_FT" => "55000"
                , "SOURCE" => ""
                , "SOURCE_TYPE" => ""
                , "SOURCE_URL" => ""
                , "PHOTO_URL" => ""
                , "PROPERTY_URL" => ""
                , "TAX_URL" => ""
                , "PROP_ID" => $prop_id
                , "LAT" => "38 53' 51.61"
                , "LON" => "77 2' 11.58"
                , "CHECKSUM" => "");
        }
        $result = array("PROPERTY_USAGE" => $property_usage
            , "PROPERTY" => $property
            , "DOCUMENTS" => $documents
            , "BUILDINGS" => $buildings
            , "TAXES" => $taxes
            , "OWNER" => $owner
            , "CORPORATIONS" => $corporations
            , "CORP2" => $corporations2
            , "SALES_HISTORY" => $sales_history
            , "PROP_ID" => $prop_id
        );
//print_r($result);
        return $result;
    }

    public function getMLSzipcodes($city, $county, $state) {
        $query = "select z.zipcode zcode
      ,    rz.place_name
      from pr_city_zipcodes z
      ,  rnt_cities c
      ,  rnt_zipcodes rz
      where c.state = :var1
      and c.county = :var2 ";
        if ($city != 'ANY') {
            $query .= " and c.name   = :var3 ";
        }
        $query .= " and c.city_id = z.city_id
      and z.zipcode = rz.zipcode
      and exists (select 1 
                  from mls_price_ranges m
                  where z.zipcode = m.zcode
                  and m.current_yn = 'Y')
      order by 2,1";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $state);
        $stmt->setString(2, $county);
        if ($city != 'ANY') {
            $stmt->setString(3, $city);
        }
        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $result[] = $rs->getRow();
        }

        return $result;
    }

    public function getMLScommercial($county, $state) {
        $query = "select m.name
      ,      m.zcode
      ,      m.a_max
      ,      m.a_median
      ,      m.a_min
      ,      m.b_median
      ,      m.c_max
      ,      m.c_median
      ,      m.c_min
      ,      m.total
      from mls_price_ranges m
      where (m.query_type = 'CommercialProperty' or
             m.query_type = 'IncomeProperty')
      and m.state = :var1
      and m.county = :var2
      and m.current_yn = 'Y'
      order by replace(m.zcode,'Lease', 'Z')";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $state);
        $stmt->setString(2, $county);


        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $result[] = $rs->getRow();
        }

        return $result;
    }

    public function getMLSlatest($county, $state) {
        $query = "select p.prop_id
           , initcap(p.city) ||' '|| initcap(p.address1) address1
           , to_char(m.price, '$999,999,999') price
           , mp.photo_url
           , p.geo_location.sdo_point.y lat
           , p.geo_location.sdo_point.x lon
           , to_char(m.listing_date, 'Day Month dd, YYYY') listing_date
           , initcap(p.city) city
           from mls_listings m
           ,  pr_properties p
           ,  mls_photos mp
           ,  pr_sources s
           ,  rnt_cities c
           where p.prop_id = m.prop_id
           and s.source_id = p.source_id
           and s.county_id = c.city_id
           and c.county = :var2
           and c.state = :var1
           and m.idx_yn = 'Y'
           and m.listing_status = 'ACTIVE'
           and m.mls_id = mp.mls_id (+)
           and mp.photo_seq (+) = 1
           and m.listing_date > (select max(listing_date) - 1
                                 from  mls_listings l
                                 , pr_properties p
                                 , pr_sources s
                                 , rnt_cities c
                                 where p.prop_id = l.prop_id
                                 and s.source_id = p.source_id
                                 and s.county_id=c.city_id
                                 and c.county=:var2
                                 and c.state = :var1
                                 and listing_date < sysdate)
           and rownum < 500
           order by p.city, price";

        $stmt = $this->connection->prepareStatement($query);
        $stmt->setString(1, $state);
        $stmt->setString(2, $county);


        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $result[] = $rs->getRow();
        }

        return $result;
    }

    public function getLatestCommercial() {
        $query = "select p.prop_id
           , initcap(p.city) ||': '|| initcap(uc.description) address1
           , to_char(m.price, '$999,999,999') price
           , mp.photo_url
           , p.geo_location.sdo_point.y lat
           , p.geo_location.sdo_point.x lon
           , to_char(m.listing_date, 'Day Month dd, YYYY') listing_date
           , initcap(p.city) city
           from mls_listings m
           ,  pr_properties p
           ,  mls_photos mp
           ,  pr_sources s
           ,  rnt_cities c
           ,  pr_property_usage pu
           ,  pr_usage_codes uc
           where p.prop_id = m.prop_id
           and s.source_id = p.source_id
           and s.county_id = c.city_id
           and m.idx_yn = 'Y'
           and m.listing_status = 'ACTIVE'
           and m.mls_id = mp.mls_id (+)
           and mp.photo_seq (+) = 1
           and (m.query_type = 'CommercialProperty' or
                m.query_type = 'IncomeProperty')
           and p.prop_id = pu.prop_id
           and pu.ucode = uc.ucode
           and m.listing_date > (select max(listing_date) - 1
                                 from  mls_listings l
                                 , pr_properties p
                                 , pr_sources s
                                 , rnt_cities c
                                 where p.prop_id = l.prop_id
                                 and s.source_id = p.source_id
                                 and s.county_id=c.city_id
                                 and listing_date < sysdate
                                 and l.query_type = 'CommercialProperty')
           and rownum < 500
           order by p.city, price";

        $stmt = $this->connection->prepareStatement($query);

        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $result[] = $rs->getRow();
        }

        return $result;
    }

    public function getFloridaPriceRange() {
        $query = "select m.name
      ,      m.zcode
      ,      m.a_max
      ,      m.a_median
      ,      m.a_min
      ,      m.b_median
      ,      m.c_max
      ,      m.c_median
      ,      m.c_min
      ,      m.total
      ,      m.county
      from mls_price_ranges m
      where (m.query_type = 'CommercialProperty' or
             m.query_type = 'IncomeProperty')
      and m.state = 'FL'
      and m.current_yn = 'Y'
      order by 1, replace(m.zcode,'Lease', 'Z')";

        $stmt = $this->connection->prepareStatement($query);
        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $r = $rs->getRow();
            $result[$r["ZCODE"] . '&county=' . $r["COUNTY"]] = array
                ("NAME" => $r["NAME"]
                , "A_MAX" => $r["A_MAX"]
                , "A_MEDIAN" => $r["A_MEDIAN"]
                , "A_MIN" => $r["A_MIN"]
                , "B_MEDIAN" => $r["B_MEDIAN"]
                , "C_MAX" => $r["C_MAX"]
                , "C_MEDIAN" => $r["C_MEDIAN"]
                , "C_MIN" => $r["C_MIN"]
                , "TOTAL" => $r["TOTAL"]
                , "COUNTY" => $r["COUNTY"]);
        }

        return $result;
    }

    public function getPriceRange($ltype, $county, $state) {
        $result = "";
        if ($ltype == 'COMMERCIAL') {
            $query = "select m.name
      ,      m.zcode
      ,      m.a_max
      ,      m.a_median
      ,      m.a_min
      ,      m.b_median
      ,      m.c_max
      ,      m.c_median
      ,      m.c_min
      ,      m.total
      from mls_price_ranges m
      where (m.query_type = :var1 or
             m.query_type = :var2)
      and m.state = :var3
      and m.county = :var4
      and m.current_yn = 'Y'
      order by replace(m.zcode,'Lease', 'Z')";
        } else {
            $query = "select rz.zipcode||' - '||rz.place_name name
      ,      z.zipcode zcode
      ,      m.a_max
      ,      m.a_median
      ,      m.a_min
      ,      m.b_median
      ,      m.c_max
      ,      m.c_median
      ,      m.c_min
      ,      m.total
      ,      rz.place_name
      from mls_price_ranges m
      ,  pr_city_zipcodes z
      ,  rnt_cities c
      ,  rnt_zipcodes rz
      where m.listing_type = :var1
      and m.query_type = :var2
      and c.state = :var3
      and c.county = :var4
      and c.city_id = z.city_id
      and z.zipcode = m.zcode
      and z.zipcode = rz.zipcode
      and m.current_yn = 'Y'
      order by rz.place_name";
        }
        $stmt = $this->connection->prepareStatement($query);

        if ($ltype == 'LAND') {
            $stmt->setString(1, 'Sale');
            $stmt->setString(2, 'VacantLand');
        } elseif ($ltype == 'RENTAL') {
            $stmt->setString(1, 'Rent');
            $stmt->setString(2, 'Rental');
        } elseif ($ltype == 'COMMERCIAL') {
            $stmt->setString(1, 'CommercialProperty');
            $stmt->setString(2, 'IncomeProperty');
        } else {
            $stmt->setString(1, 'Sale');
            $stmt->setString(2, 'ResidentialProperty');
        }
        $stmt->setString(3, $state);
        $stmt->setString(4, $county);


        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $r = $rs->getRow();
            $result[$r["ZCODE"]] = array
                ("NAME" => $r["NAME"]
                , "A_MAX" => $r["A_MAX"]
                , "A_MEDIAN" => $r["A_MEDIAN"]
                , "A_MIN" => $r["A_MIN"]
                , "B_MEDIAN" => $r["B_MEDIAN"]
                , "C_MAX" => $r["C_MAX"]
                , "C_MEDIAN" => $r["C_MEDIAN"]
                , "C_MIN" => $r["C_MIN"]
                , "TOTAL" => $r["TOTAL"]);
        }

        return $result;
    }

    public function getPriceRangeListings($ltype, $zcode, $maxval, $minval, $county) {
        $result = "";
        if ($ltype == 'COMMERCIAL') {
            $query = "select p.prop_id
           , initcap(p.address1)||', '||initcap(p.city) address1
           , to_char(m.price, '$999,999,999') price
           , mp.photo_url
           , p.geo_location.sdo_point.y lat
           , p.geo_location.sdo_point.x lon
           , m.description
           , m.short_desc
           , initcap(p.city) city           
           from mls_listings m
           ,  pr_properties p
           ,  pr_property_usage pu
           ,  pr_usage_codes u
           ,  mls_photos mp
           ,  rnt_zipcodes z
           where p.prop_id = m.prop_id
           and (m.query_type = 'CommercialProperty' or
                m.query_type = 'IncomeProperty')
           and m.listing_type = :var1
           and m.price <= :var2
           and m.price >  :var3
           and u.parent_ucode = :var4
           and u.ucode = pu.ucode
           and pu.prop_id = p.prop_id
           and m.idx_yn = 'Y'
           and m.listing_status = 'ACTIVE'
           and m.mls_id = mp.mls_id (+)
           and mp.photo_seq (+) = 1
           and z.zipcode = to_number(p.zipcode)
           and upper(z.county) = :var5
           order by m.price";
        } else {
            $query = "select p.prop_id
           , initcap(p.address1) address1
           , to_char(m.price, '$999,999,999') price
           , mp.photo_url
           , p.geo_location.sdo_point.y lat
           , p.geo_location.sdo_point.x lon
           , m.description
           , m.short_desc
           , initcap(p.city) city
           from mls_listings m
           ,  pr_properties p
           ,  mls_photos mp
           where p.prop_id = m.prop_id
           and m.listing_type = :var1
           and m.query_type = :var2
           and m.price <= :var3
           and m.price >  :var4
           and p.zipcode = :var5
           and m.idx_yn = 'Y'
           and m.listing_status = 'ACTIVE'
           and m.mls_id = mp.mls_id (+)
           and mp.photo_seq (+) = 1
           order by m.price";
        }

        $stmt = $this->connection->prepareStatement($query);

        if ($ltype == 'LAND') {
            $stmt->setString(1, 'Sale');
            $stmt->setString(2, 'VacantLand');
            $stmt->setString(3, $maxval);
            $stmt->setString(4, $minval);
            $stmt->setString(5, $zcode);
        } elseif ($ltype == 'RENTAL') {
            $stmt->setString(1, 'Rent');
            $stmt->setString(2, 'Rental');
            $stmt->setString(3, $maxval);
            $stmt->setString(4, $minval);
            $stmt->setString(5, $zcode);
        } elseif ($ltype == 'COMMERCIAL') {
            $code = explode(':', $zcode);
            $stmt->setString(1, $code[0]);
            $stmt->setString(2, $maxval);
            $stmt->setString(3, $minval);
            $stmt->setString(4, $code[1]);
            $stmt->setString(5, $county);
        } else {
            $stmt->setString(1, 'Sale');
            $stmt->setString(2, 'ResidentialProperty');
            $stmt->setString(3, $maxval);
            $stmt->setString(4, $minval);
            $stmt->setString(5, $zcode);
        }

        $rs = $stmt->executeQuery();
        while ($rs->next()) {
            $r = $rs->getRow();
            $result[] = array
                ("PROP_ID" => $r["PROP_ID"]
                , "ADDRESS1" => $r["ADDRESS1"]
                , "PRICE" => $r["PRICE"]
                , "PHOTO_URL" => $r["PHOTO_URL"]
                , "LAT" => $r["LAT"]
                , "LON" => $r["LON"]
                , "CITY" => $r["CITY"]
                , "DESCRIPTION" => $r["DESCRIPTION"]
                , "SHORT_DESC" => $r["SHORT_DESC"]);
        }

        return $result;
    }

}

?>