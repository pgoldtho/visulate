<?php
    require_once dirname(__FILE__)."/../LOV.class.php";
    require_once dirname(__FILE__)."/../UtlConvert.class.php";
    require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
    require_once dirname(__FILE__)."/rnt_base.class.php";
    require_once dirname(__FILE__)."/pr_reports.class.php";

    class LISTSearch extends RNTBase
    {
        public function __construct($connection){
            parent::__construct($connection);
        }

        public function getMlsCredentials($source_id)
        {
          $str_query = "select rets_login_url, rets_username, rets_password
                        from pr_sources
                        where source_id = :var1";
          $stmt = $this->connection->prepareStatement($str_query);
          $stmt->setInt(1, $source_id);
          
          $rs   = $stmt->executeQuery();
          while($rs->next())
          {
          $arr_results= $rs->getRow();

          }
          $rs->close();
          return $arr_results;              
        }

        public function getMlsNumbers($source_id, $status, $qtype = null)
        {
          $arr_results = array();
        
          $str_query = "select mls_number
                        from  mls_listings
                        where listing_status = nvl(:var2, 'ACTIVE')
                        and source_id = :var1";

          if (count(func_get_args())== 3) {
            $str_query.= " and query_type = :var3";
          }


          $stmt = $this->connection->prepareStatement($str_query);
          $stmt->setInt(1, $source_id);
          $stmt->setString(2, $status);

          if (count(func_get_args())== 3) {
            $stmt->setString(3, $qtype);
          }

          $rs   = $stmt->executeQuery();
          while($rs->next())
          {
           $r = $rs->getRow();
           $arr_results[] = $r["MLS_NUMBER"];

          }


          $rs->close();
          return $arr_results;
       }

       public function countMlsPhotos($source_id, $mls_number){
          $arr_results = array();

          $str_query = "select count(*) photo_count 
                        from  mls_listings l
                        ,     mls_photos p
                        where l.mls_number = :var2
                        and l.mls_id = p.mls_id
                        and source_id = :var1";

          $stmt = $this->connection->prepareStatement($str_query);
          $stmt->setInt(1, $source_id);
          $stmt->setString(2, $mls_number);
          

          $rs   = $stmt->executeQuery();
          while($rs->next())
          {
           $r = $rs->getRow();
           $arr_results[] = $r["PHOTO_COUNT"];

          }
          $rs->close();
          return $arr_results[0];
       }
        
        public function getStateCountList()
        {
         $str_query = "select c.state           location
                       ,      'STATE'           location_type
                       ,      'US'              location_context
                       ,      lv.lookup_value   display_location
                       ,      '14'              zoom_level
                       ,      c.state
                       ,      'ANY'             county
                       ,      'ANY'             agreement_id
                       ,      count(*)          location_count
                       from rnt_cities            c
                       ,    rnt_city_zipcodes     cz
                       ,    rnt_zipcodes          z
                       ,    rnt_properties        p
                       ,    rnt_property_units    pu
                       ,    rnt_tenancy_agreement ta
                       ,    rnt_lookup_values     lv
                       where c.city_id        = cz.city_id
                       and cz.zipcode         = z.zipcode
                       and to_char(z.zipcode) = p.zipcode
                       and p.property_id      = pu.property_id
                       and pu.unit_id         = ta.unit_id
                       and ta.agreement_date is null
                       and upper(ta.ad_publish_yn) = 'Y'
                       and lv.lookup_type_id  = 1 
                       and lv.lookup_code     = c.state
                       group by c.state, lv.lookup_value";
                      
        $rs = $this->connection->executeQuery($str_query);
        while($rs->next())
          {
           $arr_results[] = $rs->getRow();
          }
        $rs->close();
        return $arr_results;

        }
        
        public function getStateCountListings($ltype)
        {
         $str_query = "select c.state           location
                       ,      'STATE'           location_type
                       ,      'US'              location_context
                       ,      lv.lookup_value   display_location
                       ,      '14'              zoom_level
                       ,      c.state
                       ,      'ANY'             county
                       ,      'ANY'             agreement_id
                       ,      count(*)          location_count
                       from rnt_cities            c
                       ,    pr_city_zipcodes      z
                       ,    pr_properties         p
                       ,    mls_listings          ml
                       ,    rnt_lookup_values     lv
                       where c.city_id        = z.city_id
                       and z.zipcode          = p.zipcode
                       and p.prop_id          = ml.prop_id
                       and ml.idx_yn          = 'Y'
                       and ml.listing_status  = 'ACTIVE' ";
             if ($ltype=='COMMERCIAL')
             {$str_query .=
             "and (ml.query_type = :var1 or
                             ml.query_type = :var2)";}
             else
             {$str_query .=
             "and ml.listing_type = :var1
                        and ml.query_type = :var2 ";
             }
             $str_query .=
                       " and lv.lookup_type_id  = 1 
                       and lv.lookup_code     = c.state
                       group by c.state, lv.lookup_value";

        $stmt = $this->connection->prepareStatement($str_query);
    if ($ltype=='LAND')
      {
        $stmt->setString(1, 'Sale');
        $stmt->setString(2, 'VacantLand');
      }
    elseif ($ltype=='COMMERCIAL')
      {
        $stmt->setString(1, 'CommercialProperty');
        $stmt->setString(2, 'IncomeProperty');
      }
    elseif ($ltype=='RENTAL')
      {
        $stmt->setString(1, 'Rent');
        $stmt->setString(2, 'Rental');
      }
    else
      {
        $stmt->setString(1, 'Sale');
        $stmt->setString(2, 'ResidentialProperty');
      }
  
        $rs = $stmt->executeQuery(); 
        while($rs->next())
          {
           $arr_results[] = $rs->getRow();
          }
        $rs->close();
        return $arr_results;

        }        
     
     public function getCountyList($state)
        {
         $str_query = "select c.county||' COUNTY, '||c.state   location
                       ,      'CNTY'                           location_type
                       ,      c.state                          location_context
                       ,      initcap(c.county)||' County'     display_location
                       ,      '12'                             zoom_level
                       ,      c.county                    
                       ,      c.state
                       ,      count(*)                         location_count
                       ,      'ANY'                            agreement_id
                       from rnt_cities            c
                       ,    rnt_city_zipcodes     cz
                       ,    rnt_zipcodes          z
                       ,    rnt_properties        p
                       ,    rnt_property_units    pu
                       ,    rnt_tenancy_agreement ta
                       where c.city_id        = cz.city_id
                       and c.state            = :var1
                       and cz.zipcode         = z.zipcode
                       and to_char(z.zipcode) = p.zipcode
                       and p.property_id      = pu.property_id
                       and pu.unit_id         = ta.unit_id
                       and ta.agreement_date is null
                       and upper(ta.ad_publish_yn) = 'Y'
                       group by c.state, c.county                       
                       order by c.state, c.county";
        $stmt = $this->connection->prepareStatement($str_query);
      $stmt->setString(1, $state);
  
        $rs   = $stmt->executeQuery();  
        while($rs->next())
          {
           $arr_results[] = $rs->getRow();
          }
        $rs->close();
        return $arr_results;
       }                

    public function getCountyStats($state, $region_id)
        {
         $str_query = "select c.county||' COUNTY, '||c.state   location
                       ,      'CNTY'                           location_type
                       ,      c.state                          location_context
                       ,      initcap(c.county)||' County'     display_location
                       ,      initcap(r.name)                  region_name
                       ,      c.region_id
                       ,      '12'                             zoom_level
                       ,      c.county                    
                       ,      c.state
                       ,      count(*)                         location_count
                       from rnt_cities            c  
                       ,    rnt_regions           r
                       where c.city_id  = c.city_id
                       and r.region_id = c.region_id
                       and c.state      = :var1 ";
         if ($region_id)
           {$str_query = $str_query ." and c.region_id = :var2 ";}
         $str_query = $str_query .
                       "and exists (select 1
                                   from pr_values v
                                   where c.city_id    = v.city_id)
                       group by c.state, c.county, r.name, c.region_id                       
                       order by c.state, c.region_id, c.county";
        $stmt = $this->connection->prepareStatement($str_query);
        $stmt->setString(1, $state);
        if ($region_id) {$stmt->setString(2, $region_id);}
          
        $rs   = $stmt->executeQuery();  
        while($rs->next())
          {
           $arr_results[] = $rs->getRow();
          }
        $rs->close();
        return $arr_results;
       }               
  
    public function getCountyCities($county, $state)
        {
         $str_query = "select c.name||', '||c.state   location
                       ,      'CNTY'                   location_type
                       ,      c.county||', '||c.state  location_context
                       ,      initcap(c.name)          display_location
                       ,      '9'                             zoom_level
                       ,      c.county                    
                       ,      c.state
                       ,      c.name                     city
                       ,      ''                         location_count
                       ,      c.region_id
                       from rnt_cities            c  
                       where c.city_id  = c.city_id
                       and c.state      = :var1
                       and c.county     = :var2
                       and exists (select 1
                                   from pr_values v
                             where c.city_id    = v.city_id)
                       order by c.name";
        $stmt = $this->connection->prepareStatement($str_query);
        $stmt->setString(1, $state);
      $stmt->setString(2, $county);
        $rs   = $stmt->executeQuery();  
        while($rs->next())
          {
           $arr_results[] = $rs->getRow();
          }
        $rs->close();
        return $arr_results;
       }    
  
     public function getCityData($city, $county, $state, $ucode)
      {
      $join_condition = "";

        if ($ucode)
    {
         if ($city)
         {
          $join_condition = $join_condition."
        and   c.name = :var4 ";
        }
      $str_query = " select u2.description prop_usage
                    ,       u2.ucode
                    ,       sum(d.property_count) prop_count
                    ,       sum(d.total_sqft) total_sqft
                       from rnt_cities c
                       ,   pr_ucode_data d
                       ,  pr_usage_codes u2
                       where c.state = :var1 
           and   c.county = :var2
           and   u2.parent_ucode = :var3 ".
           $join_condition."
                       and c.city_id = d.city_id
                       and d.ucode = u2.ucode
                       group by u2.description, u2.ucode
           order by u2.description, u2.ucode";
  
            $stmt = $this->connection->prepareStatement($str_query);
      $stmt->setString(1, $state);
      $stmt->setString(2, $county);
      $stmt->setString(3, $ucode);
      if ($city) $stmt->setString(4, $city);
  
      }
    else
    {
       if ($city)
       {
          $join_condition = $join_condition."
        and   c.name = :var3 ";
       }
           $str_query = " select u2.description prop_usage
                   ,       u2.ucode
                       ,       sum(d.property_count) prop_count
                       ,       sum(d.total_sqft) total_sqft
                       from rnt_cities c
                       ,   pr_ucode_data d
                       ,  pr_usage_codes u
                       ,  pr_usage_codes u2
                       where c.state = :var1 
           and   c.county = :var2 ".
           $join_condition."
                       and c.city_id = d.city_id
                       and d.ucode = u.ucode
                       and u2.ucode = u.parent_ucode
                       group by u2.description, u2.ucode
             order by u2.description, u2.ucode";
  
            $stmt = $this->connection->prepareStatement($str_query);
      $stmt->setString(1, $state);
      $stmt->setString(2, $county);
      if ($city) $stmt->setString(3, $city);
  
    }
         


        $rs   = $stmt->executeQuery();  
        while($rs->next())
          {
           $arr_results[] = $rs->getRow();
          }
        $rs->close();
    $r_value = array();
    $r_value['TAB-DATA'] = $arr_results;
  
  
        return $arr_results;
       }  
  
  public function getCityValues($city, $county, $state, $ucode)
      {
    $join_condition = "";

        if ($ucode)
      { $join_condition = $join_condition."
        and   u.ucode = :var4 ";
      }
  
         $str_query = " select v.prop_class
                        ,      u.description
                        ,      u.ucode
                        ,      v.year
                        ,      round(v.median_price) median_price
                        ,      round(v.rent) rent
                        ,      v.cap_rate
                       from rnt_cities c
                       ,  pr_usage_codes u
                       ,  pr_values v
                       where c.state = :var1 
             and c.county = :var2
             and v.current_yn='Y'
             and c.name = :var3 ".
             $join_condition ."
                       and c.city_id = v.city_id
                       and v.ucode = u.ucode
             and v.year + 10 > to_char(sysdate, 'yyyy')
             order by u.description
             ,       v.year desc
             ,       v.prop_class";
        $stmt = $this->connection->prepareStatement($str_query);
      $stmt->setString(1, $state);
      $stmt->setString(2, $county);
      $stmt->setString(3, $city);
      if ($ucode) $stmt->setString(4, $ucode);

        $rs   = $stmt->executeQuery();  
        while($rs->next())
          {
           $arr_results[] = $rs->getRow();
          }
        $rs->close();
  
        return $arr_results;
       }    
  
   public function getCitySalesData($city, $county, $state, $year, $ucode)
      {
         $str_query = " select p.prop_id
                        ,      initcap(p.address1) address1
                        ,      to_char(ps.sale_date, 'mm/dd/yyyy') sale_date
                        ,      ps.price
                        ,      p.sq_ft
                        ,      round(ps.price/p.sq_ft, 2) sqft_price
                        from rnt_cities c
                        ,  rnt_city_zipcodes cz
                        ,  pr_property_usage pu
                        ,  pr_properties p
                        ,  pr_property_sales ps
                        ,  rnt_zipcodes z
                        where c.state = :var1
                        and c.county = :var2
                        and c.name = :var3
                        and cz.city_id = c.city_id
                        and cz.zipcode = z.zipcode
                        and to_char(z.zipcode) = p.zipcode
                        and p.prop_id = pu.prop_id
                        and nvl(p.sq_ft, 0) > 1
                        and (pu.ucode = :var4 or
                             pu.ucode in (select ucode from pr_usage_codes where parent_ucode = :var4))
                        and ps.prop_id = p.prop_id
                        and to_char(ps.sale_date, 'yyyy') = :var5
                        and ps.price > 200
                        order by ps.price/p.sq_ft";
        $stmt = $this->connection->prepareStatement($str_query);
      $stmt->setString(1, $state);
      $stmt->setString(2, $county);
      $stmt->setString(3, $city);
      $stmt->setString(4, $ucode);
      $stmt->setString(5, $year);

        $rs   = $stmt->executeQuery();  
        while($rs->next())
          {
           $arr_results[] = $rs->getRow();
          }
        $rs->close();
  
        return $arr_results;
       }    
  
   public function getCountyListings($ltype, $state)
        {
         $str_query = "select c.county||' COUNTY, '||c.state   location
                       ,      'CNTY'                           location_type
                       ,      c.state                          location_context
                       ,      initcap(c.county)||' County'     display_location
                       ,      '12'                             zoom_level
                       ,      c.county                    
                       ,      c.state
                       ,      count(*)                         location_count
                       ,      'ANY'                            agreement_id
                       from rnt_cities            c
                       ,    pr_city_zipcodes      z
                       ,    pr_properties         p
                       ,    mls_listings          ml
                       where c.city_id        = z.city_id
                       and c.state            = :var1
                       and z.zipcode          = to_number(p.zipcode)
                       and p.prop_id          = ml.prop_id
                       and ml.idx_yn          = 'Y'
                       and ml.listing_status  = 'ACTIVE' ";
             if ($ltype=='COMMERCIAL')
             {$str_query .=
             "and (ml.query_type = :var2 or
                             ml.query_type = :var3) ";}

             elseif ($ltype=='LATEST')
             {$str_query .=
               " and ml.listing_date > (select max(listing_date) - 1
                                 from  mls_listings l
                                 , pr_properties p
                                 , pr_sources s
                                 , rnt_cities c
                                 where p.prop_id = l.prop_id
                                 and s.source_id = p.source_id
                                 and s.county_id=c.city_id
                                 and listing_date < sysdate)";

             }
             else
             {$str_query .=
             "and ml.listing_type = :var2
                        and ml.query_type = :var3 ";
             }
             $str_query .=
                       "group by c.state, c.county
                       order by c.state, c.county";
        $stmt = $this->connection->prepareStatement($str_query);
      $stmt->setString(1, $state);
    if ($ltype=='LAND')
      {
        $stmt->setString(2, 'Sale');
        $stmt->setString(3, 'VacantLand');
      }
    elseif ($ltype=='RENTAL')
      {
        $stmt->setString(2, 'Rent');
        $stmt->setString(3, 'Rental');
      }
     elseif ($ltype=='COMMERCIAL')
      {
        $stmt->setString(2, 'CommercialProperty');
        $stmt->setString(3, 'IncomeProperty');
      }
     elseif ($ltype=='LATEST') { }
     else
      {
        $stmt->setString(2, 'Sale');
        $stmt->setString(3, 'ResidentialProperty');
      }
    $arr_results = array();
        $rs   = $stmt->executeQuery();  
        while($rs->next())
          {
           $arr_results[] = $rs->getRow();
          }
        $rs->close();
        return $arr_results;
       }     
       
   public function getStreetAddress($addr, $cityZip, $zipcodeFlag = false)
   {
       if ($zipcodeFlag){ $str_cityZip_query = " and p.zipcode = :var2 "; }
       else { $str_cityZip_query = " and upper(city) = upper(:var2) ";}

       $str_query = "select score(1) search_score
,      p.prop_id
,      p.address1
,      p.address2
,      p.city
,      u.ucode
,      uc.description
,      p.sq_ft
,      p.acreage
,      p.PROP_CLASS
,      p.geo_location.sdo_point.x lon
,      p.geo_location.sdo_point.y lat
,      p.TOTAL_BEDROOMS
,      p.TOTAL_BATHROOMS
,      p.GEO_FOUND_YN   
,      p.PARCEL_ID      
,      p.ALT_KEY        
,      p.VALUE_GROUP
,      p.QUALITY_CODE   
,      p.YEAR_BUILT     
,      p.BUILDING_COUNT
,      p.RESIDENTIAL_UNITS 
,      p.LEGAL_DESC        
,      p.MARKET_AREA       
,      p.NEIGHBORHOOD_CODE 
,      p.CENSUS_BK         
,      p.PUMA          
,      p.PUMA_PERCENTILE
,      p.RENTAL_PERCENTILE
,      p.HIDDEN
,      to_char(inc.value_amount, '$999,999,999') hh_income
,      to_char(trunc(rent.value_amount/1000), '$99,999') rent_estimate
from pr_properties p
,    pr_property_usage u
,    pr_usage_codes uc
,    (select puma, percentile, value_amount
                from pr_pums_values
                where value_type = 'HH-INCOME') inc
,    (select puma, percentile, value_amount
                from pr_pums_values
                where value_type = 'RR-RENT') rent                
where contains(address1, pr_records_pkg.standard_suffix(upper(:var1)), 1) >0
and u.prop_id = p.prop_id
and u.ucode = uc.ucode". $str_cityZip_query .
"and inc.puma (+) = p.puma
and inc.percentile (+) = p.puma_percentile
and rent.puma (+) = p.puma
and rent.percentile (+) = p.rental_percentile    
order by score(1) desc, address1, address2";
      
      $stmt = $this->connection->prepareStatement($str_query);
      $stmt->setString(1, $addr);
      $stmt->setString(2, $cityZip);
      
      
      $rs   = $stmt->executeQuery();  
      $arr_results = array();
      while($rs->next())
          {
           $arr_results[] = $rs->getRow();
          }
        $rs->close();
        return $arr_results;
   }

   public function getGeoLocProperties($lat, $long)
        {
    $str_query = "SELECT /*+ordered*/ initcap(p.address1) address1
                      ,   p.geo_location.sdo_point.x lon
                      ,   p.geo_location.sdo_point.y lat
          ,   p.prop_id
          ,   p.sq_ft
          ,   uc.description
          ,   p.puma
          ,   p.puma_percentile
          ,   p.prop_class
          ,   to_char(inc.value_amount, '$999,999,999') hh_income
          ,   p.rental_percentile
          ,   to_char(trunc(rent.value_amount/1000), '$99,999') rent_estimate
          ,   SDO_NN_DISTANCE(1) dist
          FROM pr_properties p
          ,    pr_property_usage pu
          ,    pr_usage_codes uc
          ,    (select puma, percentile, value_amount
                from pr_pums_values
                where value_type = 'HH-INCOME') inc
          ,    (select puma, percentile, value_amount
                from pr_pums_values
                where value_type = 'RR-RENT') rent
          WHERE sdo_nn
                         ( geo_location
                         , SDO_GEOMETRY(2001, 8307,
                                        SDO_POINT_TYPE (:var1, :var2 ,NULL), NULL, NULL)
                         , 'distance=150 unit=Meter sdo_num_res=50', 1) = 'TRUE'
            AND p.prop_id = pu.prop_id
            AND pu.ucode = uc.ucode
            and inc.puma (+) = p.puma 
            and inc.percentile (+) = p.puma_percentile
            and rent.puma (+) = p.puma
            and rent.percentile (+) = p.rental_percentile
      order by dist";
  
    $stmt = $this->connection->prepareStatement($str_query);
      $stmt->setString(1, $long);
      $stmt->setString(2, $lat);
        $rs   = $stmt->executeQuery();  
    $arr_results = array();
        while($rs->next())
          {
           $arr_results[] = $rs->getRow();
          }
        $rs->close();
        //print_r($arr_results);
        return $arr_results;
       }
       
   public function getPumaSummary($puma)
   {
    $str_query = "select rent_income_ratio
                  ,      insurance
                  ,      vacancy_rate
                  ,      puma
                  from pr_pums_data
                  where puma = :var1";

    $stmt = $this->connection->prepareStatement($str_query);
    $stmt->setString(1, $puma);
    $rs   = $stmt->executeQuery();

    while($rs->next())
     {
      $pumaValues = $rs->getRow();
     }
    $rs->close();

    $str_query = "select percentile
                  ,      value_amount
                  from pr_pums_values
                  where puma = :var1
                  and value_type = :var2
                  order by percentile";

    $stmt = $this->connection->prepareStatement($str_query);
    $stmt->setInt(1, $puma);
    $stmt->setString(2, 'HH-INCOME');
    $rs   = $stmt->executeQuery();

    $hh_income = array();
    while($rs->next())
     {
      $r = $rs->getRow();
      $hh_income[$r["PERCENTILE"]] = $r["VALUE_AMOUNT"];
     }
    $rs->close();

    $stmt = $this->connection->prepareStatement($str_query);
    $stmt->setInt(1, $puma);
    $stmt->setString(2, 'RR-RENT');
    $rs   = $stmt->executeQuery();

    $rr_rent = array();
    while($rs->next())
     {
      $r = $rs->getRow();
      $rr_rent[$r["PERCENTILE"]] = round($r["VALUE_AMOUNT"]/1000, 0);
     }
    $rs->close();

    $stmt = $this->connection->prepareStatement($str_query);
    $stmt->setInt(1, $puma);
    $stmt->setString(2, 'RR-INCOME');
    $rs   = $stmt->executeQuery();

    $rr_income = array();
    while($rs->next())
     {
      $r = $rs->getRow();
      $rr_income[$r["PERCENTILE"]] = round($r["VALUE_AMOUNT"]/(12 * $pumaValues["RENT_INCOME_RATIO"]), 0);
     }
    $rs->close();
    


    $results = array("PUMA"   => $pumaValues
                   , "INCOME" => $hh_income
                   , "RENT"   => $rr_rent
                   , "RENTER" => $rr_income);

    return $results;

   }

   public function getGeoCorp($lat, $long)
   {
        $query = "SELECT corp_name name
        ,   corp_number
        ,   address1
        ,   lat
        ,   lon
        ,   prop_id
        FROM  table(pr_geo_utils_pkg.get_nearby_corps(". $lat.", ". $long."))
        where loc_type = 'PRIN'";

    $loop_counter = 0;
    $stmt = $this->connection->prepareStatement($query);
    $rs   = $stmt->executeQuery();
    $arr_results = array();

    while($rs->next())
     {
       $arr_results[] = $rs->getRow();
     }
     $rs->close();
     return $arr_results;
   }

     public function getPropertyList($county, $state)
       {
         $str_query = "select p.address1||', '||p.address2||', '||
                        p.city||', '||p.state||' '||p.zipcode    location
                       ,      'ADDR'                                   location_type
                       ,      c.county||' County, '||c.state         location_context
                       ,      pu.bedrooms||' bed, '||pu.bathrooms||' bath '||p.city         display_location
                       ,      '9'                                      zoom_level
                 ,      '$'||ta.amount                           location_count
                 ,      c.county
                       ,      c.state
                 ,      ta.agreement_id
                       from rnt_cities            c
                       ,    rnt_city_zipcodes     cz
                       ,    rnt_zipcodes          z
                       ,    rnt_properties        p
                       ,    rnt_property_units    pu
                       ,    rnt_tenancy_agreement ta
                       where c.city_id        = cz.city_id
                       and c.county           = :var1
                       and c.state            = :var2
                       and cz.zipcode         = z.zipcode
                       and to_char(z.zipcode) = p.zipcode
                       and p.property_id      = pu.property_id
                       and pu.unit_id         = ta.unit_id
                       and ta.agreement_date is null
                       and upper(ta.ad_publish_yn) = 'Y'
                       order by p.city, ta.amount";
        $stmt = $this->connection->prepareStatement($str_query);
        $stmt->setString(1, $county);
        $stmt->setString(2, $state);
        $rs   = $stmt->executeQuery();  
    $arr_results = array();
        while($rs->next())
          {
           $arr_results[] = $rs->getRow();
          }
        $rs->close();
        return $arr_results;
       }      

     public function getPropertyListings($county, $state)
       {
         $str_query = "select p.address1||', '||p.address2||', '||
                      p.city||', '||p.state||' '||p.zipcode       location
                       ,      'ADDR'                                      location_type
                       ,      c.county||' County, '||c.state              location_context
                       ,      initcap(p.address1)||', '||initcap(p.city)  display_location
                       ,      '9'                                         zoom_level
           ,      to_char(pl.price, '$999,999,999')           location_count
                 ,      c.county
                       ,      c.state
           ,      p.prop_id                                   agreement_id
           from rnt_cities            c
                       ,    rnt_city_zipcodes     cz
                       ,    rnt_zipcodes          z
                       ,    pr_properties         p
                       ,    pr_property_listings  pl
                       where c.city_id        = cz.city_id
                       and c.county           = :var1
                       and c.state            = :var2
                       and cz.zipcode         = z.zipcode
                       and to_char(z.zipcode) = p.zipcode
                       and p.prop_id          = pl.prop_id
                       and pl.publish_yn      = 'Y'
                       and pl.sold_yn         = 'N'
                       order by p.city, pl.price";
        $stmt = $this->connection->prepareStatement($str_query);
        $stmt->setString(1, $county);
        $stmt->setString(2, $state);
        $rs   = $stmt->executeQuery();  
        while($rs->next())
          {
           $arr_results[] = $rs->getRow();
          }
        $rs->close();
        return $arr_results;
       }      
      
      
       public function getAgreement($agreement_id)
        {
         $str_query = "select p.address1||', '||p.address2||', '||
                              p.city||', '||p.state||' '||p.zipcode    location
                       ,      'ADDR'                                   location_type
                       ,      c.county||' County, '||c.state           location_context
                       ,      pu.bedrooms||' bed, '||pu.bathrooms||
            ' bath '||p.city||' $'||ta.amount          display_location
                       ,      '4'                                      zoom_level
                       ,      ta.amount
                       ,      initcap(ta.amount_period)                amount_period
                       ,      ta.deposit
                       ,      ta.last_month
                       ,      ta.discount_amount
                       ,      ta.discount_period
                       ,      pu.bedrooms
                       ,      pu.bathrooms
                       ,      ta.ad_title
                       ,      ta.ad_contact
                       ,      ta.ad_email
                       ,      ta.ad_phone
                       ,      pu.unit_size
                       ,      pu.description                            unit_desc
                       ,      p.description                             property_desc
                       ,      ta.agreement_id
                       ,      p.property_id
                       from rnt_cities            c
                       ,    rnt_city_zipcodes     cz
                       ,    rnt_zipcodes          z
                       ,    rnt_properties        p
                       ,    rnt_property_units    pu
                       ,    rnt_tenancy_agreement ta
                       where c.city_id        = cz.city_id
                       and cz.zipcode         = z.zipcode
                       and to_char(z.zipcode) = p.zipcode
                       and p.property_id         = pu.property_id
                       and pu.unit_id              = ta.unit_id
                       and ta.agreement_date       is null
                       and upper(ta.ad_publish_yn) = 'Y'
                       and ta.agreement_id         = :var1
                       order by p.city, ta.amount";
        $stmt = $this->connection->prepareStatement($str_query);
        $stmt->setString(1, $agreement_id);
        $rs   = $stmt->executeQuery();  
    $arr_results = array();
        while($rs->next())
          {
           $arr_results[] = $rs->getRow();
          }
        $rs->close();
        return $arr_results;
       }      
       
    public function getSalesFeed()
       {
       $prReport = new PRReports($this->connection);
       $str_query = "select initcap(p.address1)||', '||initcap(p.city)||', '||p.state||', '||p.zipcode       location
                     ,      initcap(p.address1)||', '||initcap(p.city)||': '||to_char(pl.price, '$999,999,999')  title
                     ,      p.prop_id
                     ,      pl.price
                     ,      c.county
                     ,      c.state
                     ,      uc.description||', '||p.sq_ft||'sq ft, '||p.acreage||' acres. '||pl.description   description
                     from pr_property_listings pl
                     ,    pr_properties        p
                     ,    pr_property_usage    pu
                     ,    pr_usage_codes       uc
                     ,    rnt_cities           c
                     ,    rnt_city_zipcodes     cz
                     ,    rnt_zipcodes          z
                     where pl.publish_yn = 'Y'
                     and pl.prop_id = p.prop_id
                     and p.prop_id = pu.prop_id
                     and pu.ucode = uc.ucode
                     and c.city_id        = cz.city_id
                     and cz.zipcode         = z.zipcode
                     and to_char(z.zipcode) = p.zipcode
                    order by p.city, pl.price";
        $rs = $this->connection->executeQuery($str_query);
        while($rs->next())
          {
           $r = $rs->getRow();
           $arr_results[] = array( "LISTING" => $r
                                 , "PHOTOS"  => $prReport->getPropPhotos($r["PROP_ID"]));
          }
        $rs->close();
        
        return $arr_results;
       }  


     public function getRentalFeed()
       {
       $str_query = "select p.address1||', '||p.city||', '||p.state||', '||p.zipcode    location
                     ,      pu.bedrooms||' bed, '||pu.bathrooms||' bath '||p.city                      display_location
                     ,      '$'||ta.amount                           location_count
                     ,      c.county
                     ,      c.state
                     ,      ta.agreement_id
                     ,      ta.amount
                     ,      initcap(ta.amount_period)                amount_period
                     ,      ta.deposit
                     ,      ta.last_month
                     ,      ta.discount_amount
                     ,      ta.discount_period
                     ,      pu.bedrooms
                     ,      trunc(pu.bathrooms) bathrooms
                     ,      ta.ad_title
                     ,      ta.ad_contact
                     ,      ta.ad_email
                     ,      ta.ad_phone
                     ,      pu.unit_size
                     ,      pu.description                            unit_desc
                     ,      p.description                             property_desc
                     ,      ta.agreement_id
                     ,      p.property_id
                     ,      to_char(date_available, 'yyyy-mm-dd')||'T00:00:00Z'      date_available
                     from rnt_cities            c
                     ,    rnt_city_zipcodes     cz
                     ,    rnt_zipcodes          z
                     ,    rnt_properties        p
                     ,    rnt_property_units    pu
                     ,    rnt_tenancy_agreement ta
                     where c.city_id        = cz.city_id
                     and cz.zipcode         = z.zipcode
                     and to_char(z.zipcode) = p.zipcode
                     and p.property_id      = pu.property_id
                     and pu.unit_id         = ta.unit_id
                     and ta.agreement_date is null
                     and upper(ta.ad_publish_yn) = 'Y'
                     order by p.city, ta.amount";
        $rs = $this->connection->executeQuery($str_query);
        while($rs->next())
          {
           $r = $rs->getRow();
           $arr_results[] = array( "AGREEMENT" => $r
                                 , "PHOTOS"   => $this->getPhotos($r["PROPERTY_ID"]));
          }
        $rs->close();
        
        return $arr_results;
       }   
    

  
     public function getPhotos($property_id)
       {
       $str_query = "select photo_title
                     ,      '/upload_files/'||property_id||'/'||photo_filename             photo_filename
                     ,      '/upload_files/'||property_id||'/vga_'||photo_filename         vga_filename
                     ,      '/upload_files/'||property_id||'/thumbnail_'||photo_filename   photo_thumbnail
                     from rnt_property_photos
                     where property_id = :var1
                     order by photo_id";
        $stmt = $this->connection->prepareStatement($str_query);
        $stmt->setString(1, $property_id);
        $rs   = $stmt->executeQuery();  
        while($rs->next())
          {
           $arr_results[] = $rs->getRow();
          }
        $rs->close();
        return $arr_results;
       }      
    
    public function getListingDetails($prop_id)
      {
      $listing   = array();
      $links     = array();
      $cashflow  = array();
      $repairs   = array();
      $photos    = array();
      $results   = array();
      $arr_results = array();

      $str_query = "select photo_title
                     ,      '/upload_files/'||p.property_id||'/'||photo_filename             photo_filename
                     ,      '/upload_files/'||p.property_id||'/vga_'||photo_filename         vga_filename
                     ,      '/upload_files/'||p.property_id||'/thumbnail_'||photo_filename   photo_thumbnail
                     from rnt_property_photos pp
                     ,    rnt_properties p
                     where p.prop_id = :var1
                     and p.property_id = pp.property_id
                     order by photo_id";
      $stmt = $this->connection->prepareStatement($str_query);
      $stmt->setString(1, $prop_id);
      $rs   = $stmt->executeQuery();  
      while($rs->next())
          {
           $arr_results[] = $rs->getRow();
          }
      $rs->close();
      $photos = $arr_results;
      $arr_results = array();

      $str_query = "select to_char(pl.listing_date, 'mm/dd/yyyy') listing_date
                    ,      bu.business_name
                    ,      pl.business_id
                    ,      pl.price
                    ,      pl.description
                    ,      pl.agent_name
                    ,      pl.agent_phone
                    ,      pl.agent_email
                    ,      pl.source
                    ,      pl.agent_website
                    from pr_property_listings pl
                    ,    rnt_business_units bu
                    where pl.prop_id = :var1
                    and pl.business_id = bu.business_id
                    and pl.publish_yn  = 'Y'
                    and pl.sold_yn     = 'N'
                    order by pl.listing_date, bu.business_name";
        $stmt = $this->connection->prepareStatement($str_query);
        $stmt->setString(1, $prop_id);
        $rs   = $stmt->executeQuery();  
        while($rs->next())
          {
           $arr_results[] = $rs->getRow();
          }
        $rs->close();
        $listing = $arr_results;
        $arr_results = array();

      $str_query = "select link_title
                    ,      link_url
                    from rnt_property_links l
                    ,    rnt_properties p
                    where p.prop_id = :var1
                    and p.property_id = l.property_id
                    order by link_title";
      $stmt = $this->connection->prepareStatement($str_query);
      $stmt->setString(1, $prop_id);
      $rs   = $stmt->executeQuery();  
      while($rs->next())
          {
           $arr_results[] = $rs->getRow();
          }
      $rs->close();
      $links = $arr_results;
      $arr_results = array();


      $str_query = "select 
                         pe.property_estimates_id,
                         nvl(pe.estimate_title, 'Pro-forma Estimate')           as title,
                         nvl(pe.purchase_price, 0)                              as price,
                         nvl(pe.monthly_rent, 0)                                as monthly_rent,
                         nvl(pe.monthly_rent * 12, 0)                           as annual_rent,
                         perf.income_amount,
                         perf.expense_amount,
                         perf.income_amount - perf.expense_amount               as NOI,
                         pe.cap_rate,
                         (nvl(pe.down_payment, 0) + nvl(pe.closing_costs, 0) )  as cash_invested,
                         round((((perf.income_amount - perf.expense_amount)
                           -(rnt_loans_pkg.get_mortgage_payment( nvl(pe.loan1_amount, 0)
                                                               , nvl(pe.loan1_rate, 0)
                                                               , nvl(pe.loan1_term, 0)
                                                               , decode(pe.loan1_type, 'Interest Only', 'I'
                                                                                     , 'Amortizing',    'A')) * 12)
                           -(rnt_loans_pkg.get_mortgage_payment( nvl(pe.loan2_amount, 0)
                                                               , nvl(pe.loan2_rate, 0)
                                                               , nvl(pe.loan2_term, 0)
                                                               , decode(pe.loan2_type, 'Interest Only', 'I'
                                                                                     , 'Amortizing',    'A'))* 12))
                           / (0.0001 + (nvl(pe.down_payment, 0) + nvl(pe.closing_costs, 0) )) *100), 2)            as cash_on_cash
                     from rnt_properties   p,
                          rnt_property_estimates  pe,
                          pr_properties    pr,
                          pr_property_listings pl,
                   (select p2.property_id,
                           pe2.property_estimates_id,
                         round((nvl(pe2.monthly_rent * 12, 0) + nvl(pe2.other_income, 0)), 2) as income_amount,
                         round(((nvl(pe2.monthly_rent * 12, 0)* nvl(pe2.vacancy_pct, 0)/100) +
                          (nvl(pe2.replace_3years, 0)/3) +
                          (nvl(pe2.replace_5years, 0)/5) +
                          (nvl(pe2.replace_12years, 0)/12) +
                           nvl(pe2.maintenance, 0) +
                           nvl(pe2.utilities, 0) +
                           nvl(pe2.property_taxes, 0) +
                           nvl(pe2.insurance, 0) +
                           nvl(pe2.mgt_fees, 0) ), 2) as expense_amount
                        from  rnt_properties   p2,
                        rnt_property_estimates  pe2
                        where pe2.property_id = p2.property_id)  perf
                  where  pe.property_id       = p.property_id
                  and    perf.property_id     = p.property_id
                  and    perf.property_estimates_id = pe.property_estimates_id
                  and    pr.prop_id        = :var1
                  and    pr.prop_id        = p.prop_id
                  and    pr.prop_id        = pl.prop_id
                  and    pl.publish_yn     = 'Y'
                  and    pl.sold_yn        = 'N'
                  order by pe.purchase_price";

        $stmt = $this->connection->prepareStatement($str_query);
        $stmt->setString(1, $prop_id);
        $rs   = $stmt->executeQuery();  
        while($rs->next())
          {
           $arr_results[] = $rs->getRow();
          }
        $rs->close();
        $cashflow = $arr_results;
        $arr_results = array();
        
        
        $str_query = "select 
                         p.building_size         as sqft,
                         nvl(pv.asking_price, 0) as asking_price,
                         nvl(pv.offer_price, 0)  as offer_price,
                         nvl(e.estimates, 0)     as cost_estimates,
                         nvl(pv.offer_price, 0) + nvl(e.estimates, 0) as cost_basis,
                         round((nvl(pv.offer_price, 0) + nvl(e.estimates, 0))
            /greatest(pr.sq_ft, 1),2) as price_sqft,
                         round((nvl(pv.offer_price, 0) + nvl(e.estimates, 0))
           /greatest(pr.acreage, 0.01),2) as price_acre,
                         nvl(pv.arv, 0)  as arv,
                         nvl(pv.arv, 0) - nvl(pv.offer_price, 0) - nvl(e.estimates, 0) as profit_loss
                  from   rnt_properties   p,
                         pr_properties    pr,
                         pr_property_listings pl,
                         (select pe.property_id,
                                 sum(pei.item_cost * pei.estimate) as estimates
                          from   rnt_property_expenses   pe,
                                 rnt_expense_items    pei
                          where  pei.expense_id  = pe.expense_id
                          and    pei.accepted_yn = 'Y'
                          group  by pe.property_id
                         )   e,
                         (select t.property_id,
                                 max(decode(t.value_method, 'ASK',  t.value, to_number(null))) as asking_price,
                                 max(decode(t.value_method, 'OFFER',t.value, to_number(null))) as offer_price,
                                 max(decode(t.value_method, 'ARV',  t.value, to_number(null))) as arv
                          from   rnt_property_value t,
                                 (select property_id,
                                         value_method,
                                         max(value_date) as last_value_date 
                                  from   rnt_property_value
                                  group  by property_id, value_method
                                 ) x
                          where  t.property_id  = x.property_id
                          and    t.value_method = x.value_method
                          and    t.value_date   = x.last_value_date
                          group  by t.property_id
                         )   pv
                  where  e.property_id  (+)= p.property_id
                  and    pv.property_id (+)= p.property_id
                  and    pr.prop_id        = :var1
                  and    pr.prop_id        = p.prop_id
                  and    pr.prop_id        = pl.prop_id
                  and    pl.publish_yn     = 'Y'
                  and    pl.business_id    = p.business_id
                  and    pl.sold_yn        = 'N'";        
                  
        $stmt = $this->connection->prepareStatement($str_query);
        $stmt->setString(1, $prop_id);
        $rs   = $stmt->executeQuery();  
        while($rs->next())
          {
           $arr_results[] = $rs->getRow();
          }
        $rs->close();
        $repairs = $arr_results;                  
        
        $results = array( "PHOTOS"     => $photos
            , "LISTING"    => $listing
      , "LINKS"      => $links
      , "CASHFLOW"   => $cashflow
      , "REPAIRS"    => $repairs );

        return $results;
      }
/*
  Code to generate sitemap entries.  Relies on the following entries in the 
  Apache  httpd.conf file:
  
  RewriteRule /property/([0-9]+)$ /rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID=$1
  RewriteRule /sitemap\.xml$ /rental/visulate_feeds.php?REPORT_CODE=SITE_MAP&MAP_LEVEL=sitemapindex
  RewriteRule /sitemap-([A-Za-z0-9-]+)\.xml$ /rental/visulate_feeds.php?REPORT_CODE=SITE_MAP&MAP_LEVEL=$1
*/
  
  public function getSiteMap($map_level)
  {
    if ($map_level == "sitemapindex")
      {
       $base_url = $GLOBALS["HTTP_PATH_FROM_ROOT"]."sitemap-";
       $doc_type = "sitemapindex";
       $entry_type = "sitemap";
       $loc = array("public.xml");
       $str_query = "select max(prop_id) max_prop_id
                     ,      min(prop_id) min_prop_id
                     from pr_properties";
           $stmt = $this->connection->prepareStatement($str_query);
           $rs   = $stmt->executeQuery();  
           while($rs->next())
            {
             $r = $rs->getRow();
             $max_prop_id = $r["MAX_PROP_ID"];
             $prop_id     = $r["MIN_PROP_ID"];
            }
           $rs->close();
           while ($prop_id < $max_prop_id)
            {
             $c = $this->getSingleRow("select count(*) as COUNT
                                       from pr_properties
                                       where prop_id > (".$prop_id." - 1)
                                       and prop_id < (".$prop_id." + 15000)");
             if ($c["COUNT"] != 0)  $loc[] = $prop_id.".xml";
             $prop_id = $prop_id + 15000; 
            }
           $str_query ="select round(count(*)/10000) c_count
                        from pr_corporations";
           $stmt = $this->connection->prepareStatement($str_query);
           $rs   = $stmt->executeQuery();  
           while($rs->next())
            {
             $r = $rs->getRow();
             $c_count = $r["C_COUNT"];
            } 
            $rs->close();
           for ( $count = 1; $count < $c_count; $count ++)
             {
              $loc[] = $count.".xml";
             }
             $loc[] = $c_count.".xml";
           }
         elseif (ereg('^[0-9]+$', $map_level)) // $map_level is numeric  
           {
      $doc_type = "urlset";
      $entry_type = "url";
      $loc = array();
            if ($map_level > 500)
              {
                $base_url = $GLOBALS["HTTP_PATH_FROM_ROOT"]."property/";
    $min_prop_id = $map_level - 1;
    $max_prop_id = $map_level + 15000;
                $str_query = "select prop_id
                              from pr_properties
              where prop_id > :var1
            and prop_id < :var2
            order by prop_id";
                $stmt = $this->connection->prepareStatement($str_query);
      $stmt->setString(1, $min_prop_id);
      $stmt->setString(2, $max_prop_id);
                $rs   = $stmt->executeQuery();  
                while($rs->next())
                {
                 $row = $rs->getRow();
                 $loc[] = $row["PROP_ID"];
                }
                $rs->close();
             }
           else
             {
                $base_url = $GLOBALS["HTTP_PATH_FROM_ROOT"]."rental/visulate_search.php?CORP_ID=";
       $min_row = $map_level * 10000;
    $max_row = ($map_level + 1) * 10000;
                $str_query = "select corp_number
                              from (select a.corp_number, rownum rnum
                                    from (select corp_number from pr_corporations order by corp_number) a
                                    where rownum <= :var1)
                              where rnum >= :var2";
                $stmt = $this->connection->prepareStatement($str_query);        
                $stmt->setString(1, $max_row);
      $stmt->setString(2, $min_row);
                $rs   = $stmt->executeQuery();  
                while($rs->next())
                {
                 $row = $rs->getRow();
                 $loc[] = $row["CORP_NUMBER"];
                }
                $rs->close();
             }
          }
         else
          {
           $base_url = $GLOBALS["HTTP_PATH_FROM_ROOT"]."rental/";
           $doc_type = "urlset";
           $entry_type = "url";
           $loc = array( 'visulate_search.php?REPORT_CODE=SALES'
                 , 'visulate_search.php?REPORT_CODE=COMMERCIAL'
           , 'visulate_search.php?REPORT_CODE=LAND'
           , 'visulate_search.php?REPORT_CODE=PROPERTY_DETAILS'           
           , 'visulate_search.php?REPORT_CODE=LISTINGS'
           , 'visulate_search.php?REPORT_CODE=CITY&amp;state=FL');


           $str_query = "select 'visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;region_id='
           ||region_id url from rnt_regions";
          $stmt = $this->connection->prepareStatement($str_query);
          $rs   = $stmt->executeQuery();
           while($rs->next())
             {
              $row = $rs->getRow();
              $loc[] = $row["URL"];
             }
           $rs->close();

           $str_query = "select 
           'visulate_search.php?REPORT_CODE=CITY&amp;state=FL&amp;county='||c.county
           ||'&amp;city='||c.name||'&amp;region_id='||r.region_id url
           from rnt_regions r
           ,    rnt_cities c
           where c.region_id=r.region_id
           order by 1";
          $stmt = $this->connection->prepareStatement($str_query);
          $rs   = $stmt->executeQuery();
           while($rs->next())
             {
              $row = $rs->getRow();
              $loc[] = $row["URL"];
             }
           $rs->close();


           $str_query = "select '?m2='||mp.tab_name
                          ||'&amp;menu='||mp.menu_name
              ||'&amp;page='||mp.page_name
              ||'&amp;subpage='||replace(mp.sub_page, ' ', '%20')   url
                         from rnt_menu_pages mp
                         ,    rnt_user_roles ur
                         ,    rnt_menu_roles mr
                         where ur.role_code = 'PUBLIC'
                         and ur.role_id = mr.role_id
                         and mr.tab_name = mp.tab_name
                         order by mp.tab_name, mp.menu_name, mp.page_name, display_seq";
          $stmt = $this->connection->prepareStatement($str_query);
          $rs   = $stmt->executeQuery();  
           while($rs->next())
             {
              $row = $rs->getRow();
              $loc[] = $row["URL"];
             }
           $rs->close();
          
          }
         $result = array( "DOC_TYPE"   => $doc_type
                        , "ENTRY_TYPE" => $entry_type
                        , "BASE_URL"   => $base_url
                        , "LOC"        => $loc );
  
         return $result;
      }
    }
?>