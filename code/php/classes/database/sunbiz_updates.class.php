<?
  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/../LOV.class.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";


  class PRSunbiz extends RNTBase
  {

    public function __construct($connection){
         parent::__construct($connection);
    }

    function rm_officer($corpID, $pnID, $code){
         $statement = "begin sunbiz_pkg.remove_officer(".
                                           "p_corp => :var1,".
                                           "p_id   => :var2,".
                                           "p_code => :var3); end;";
         $prepare = $this->connection->prepareStatement($statement);
         $prepare->set(1, $corpID);
         $prepare->set(2, $pnID);
         $prepare->set(3, $code);
         @$prepare->executeUpdate();
   }
   
   function add_officer($corpID, $name, $type, $title_code, $address1, $address2, $city, $state, $zipcode)
   {            
     $statement = "begin
                    sunbiz_pkg.add_officer
                       ( p_CORP         => :var1
                       , p_NAME         => :var2
                       , p_PN_TYPE      => :var3
                       , p_TITLE_CODE   => :var4
                       , p_ADDRESS1     => :var5
                       , p_ADDRESS2     => :var6
                       , p_CITY         => :var7
                       , p_STATE        => :var8
                       , p_ZIPCODE      => :var9
                       , p_ZIP4         => null 
                       , p_COUNTRY      => 'US'
                       , p_geo_location => null
                       , p_geo_found_yn => 'N');
                    end;";
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->set(1, $corpID);
        $prepare->set(2, $name);
        $prepare->set(3, $type);
        $prepare->set(4, $title_code);
        $prepare->set(5, $address1);
        $prepare->set(6, $address2);
        $prepare->set(7, $city);
        $prepare->set(8, $state);
        $prepare->set(9, $zipcode);
        @$prepare->executeUpdate();                    
   }
  
   
   function update_corp($corpID, $name, $status, $filing_type, $filing_date, $fei_number)
   { 
     $statement = "begin
                   update pr_corporations
                   set name        = :var1
                   ,   status      = :var2
                   ,   filing_type = :var3
                   ,   filing_date = to_date(:var4, 'YYYY-MM-DD hh24:MI:SS')
                   ,   fei_number  = :var5
                   where corp_number = :var6;
                   end;";
                   
     $prepare = $this->connection->prepareStatement($statement);
     $prepare->set(1, $name);
     $prepare->set(2, $status);
     $prepare->set(3, $filing_type);
     $prepare->set(4, $filing_date);
     $prepare->set(5, $fei_number);
     $prepare->set(6, $corpID);
     @$prepare->executeUpdate();  
     
   }     
   
   function update_corp_addr($corpID, $address1, $address2, $city, $state, $zipcode, $prop_id, $lat, $lon)
   {
     if ($lat != NULL && $lon != NULL)
       $geo =  "     , x_geo_location =>  SDO_GEOMETRY(2001, 8307,
                                                SDO_POINT_TYPE ($lon, $lat ,NULL), NULL, NULL)
                     , x_geo_found_yn => 'Y'";
     else
       {
        $geo = "     , x_geo_location => null
                     , x_geo_found_yn => 'N'";
        }             


     $statement = "begin
                   pr_locations_pkg.update_corp_location
                     ( X_ADDRESS1 => :var1
                     , X_ADDRESS2 => :var2
                     , X_CITY     => :var3
                     , X_STATE    => :var4
                     , X_ZIPCODE  => :var5
                     , X_ZIP4     => ''
                     , x_prop_id  => :var6
                     , X_COUNTRY  => 'US'
                     , X_CORP_NUMBER => :var7
                     , X_LOC_TYPE => 'PRIN'".
                     $geo .");
                     end;";
                     
     $prepare = $this->connection->prepareStatement($statement);
     $prepare->set(1, $address1);
     $prepare->set(2, $address2);
     $prepare->set(3, $city);
     $prepare->set(4, $state);
     $prepare->set(5, $zipcode);
     $prepare->set(6, $prop_id);
     $prepare->set(7, $corpID);
     @$prepare->executeUpdate();                   
    
   }
  
   
  }
?>   