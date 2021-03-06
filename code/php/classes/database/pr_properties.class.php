<?php
  require_once dirname(__FILE__)."/../UtlConvert.class.php";
  require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
  require_once dirname(__FILE__)."/rnt_base.class.php";

class PRProperties extends RNTBase {

    public function __construct($connection){
         parent::__construct($connection);
    }

    public function getBUProperties($buid)
    {
      if ($buid == null)
          $buid = 0;
      $r = array();
      $return = array();            
      $query = "select  p.PROP_ID
                  ,       initcap(p.ADDRESS1) ADDRESS1
                  ,       initcap(p.CITY) CITY
                  from pr_properties p
                  ,    pr_property_listings pl
                  where pl.business_id = :var1
                  and pl.sold_yn       = 'N'
                  and p.prop_id = pl.prop_id
                  order by p.ADDRESS1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $buid);
        $rs = $stmt->executeQuery();

        while($rs->next()) {
            $r = $rs->getRow();
            $return[$r["PROP_ID"]] = 
		           array( "ADDRESS1"       => $r["ADDRESS1"]
                    , "CITY"           => $r["CITY"]
                    , "PROP_ID"        => $r["PROP_ID"]);
        }
        
        return $return;
    }
    
    public function getListing($id, $buid)
    {
        if ($id == null) {
            $id = 0;
        }
        
        $r = array();
        $query = "select  PROP_ID
				  ,       BUSINESS_ID
                  ,       LISTING_DATE
                  ,       PRICE
                  ,       PUBLISH_YN
                  ,       SOLD_YN
                  ,       DESCRIPTION
                  ,       SOURCE
                  ,       AGENT_NAME
                  ,       AGENT_PHONE
                  ,       AGENT_EMAIL
                  ,       AGENT_WEBSITE
                  ,       CHECKSUM
                  from   PR_PROPERTY_LISTINGS_V
                  where  PROP_ID = :var1
                  and    BUSINESS_ID = :var2
									order by listing_date";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $id);
        $stmt->setInt(2, $buid);
        
        $rs = $stmt->executeQuery();
            
        while($rs->next()) {
            $r = $rs->getRow();
        }
        // append to array keys PL_
        $return = array();
        foreach($r as $k=>$v) {
            $return["PL_".$k] = $v;
        }

        return $return;
    }

    
    private function Operation(&$value, $operation)
    {
       $proc = "";
       switch($operation )
       {
        case (RNTBase::UPDATE_ROW) : $proc = "UPDATE_ROW"; break;
        case (RNTBase::INSERT_ROW) : $proc = "INSERT_ROW"; break;
        default : throw new Exception("Not allowed value");
       }

       $statement = "
                 begin
                  PR_PROPERTY_LISTINGS_PKG.$proc(
                     X_PROP_ID          => :var1,
                     X_BUSINESS_ID      => :var2,
                     X_LISTING_DATE     => to_date(:var3, 'mm/dd/yyyy'),
										 X_PRICE            => :var4,
										 X_PUBLISH_YN       => :var5,
										 X_SOLD_YN          => :var6,
										 X_DESCRIPTION      => :var7,
										 X_SOURCE           => :var8,
										 X_AGENT_NAME       => :var9,
										 X_AGENT_PHONE      => :var10,
										 X_AGENT_EMAIL      => :var11,
										 X_AGENT_WEBSITE    => :var12";

        if ($operation == RNTBase::UPDATE_ROW)
             $statement .= ",X_CHECKSUM => :var13";

        $statement .= "); end;";

        $prepare = $this->connection->prepareStatement($statement);


        $prepare->setInt(1, $value["PL_PROP_ID"]);
        $prepare->setInt(2, $value["PL_BUSINESS_ID"]);
        $prepare->setDate(3, $value["PL_LISTING_DATE"]);
        $prepare->set(4, UtlConvert::DisplayNumericToDB($value["PL_PRICE"]));
        $prepare->setString(5, ($value["PL_PUBLISH_YN"] ==  1)  ? "Y" : "N");
        $prepare->setString(6, ($value["PL_SOLD_YN"] ==  1)  ? "Y" : "N");
        $prepare->setString(7, $value["PL_DESCRIPTION"]);
        $prepare->setString(8, $value["PL_SOURCE"]);
        $prepare->setString(9, $value["PL_AGENT_NAME"]);
        $prepare->setString(10, $value["PL_AGENT_PHONE"]);
        $prepare->setString(11, $value["PL_AGENT_EMAIL"]);
        $prepare->setString(12, $value["PL_AGENT_WEBSITE"]);
        
        if ($operation == RNTBase::UPDATE_ROW)
            $prepare->setString(13, $value["PL_CHECKSUM"]);

        @$prepare->executeUpdate();

    }

    public function UpdateListing(&$values)
    {
        $this->Operation($values, RNTBase::UPDATE_ROW);        
    }

    public function InsertListing(&$values)
    {
        $this->Operation($values, RNTBase::INSERT_ROW);
        $statement = "
                 begin
                  :var1 := RNT_PROPERTIES_PKG.COPY_PUBLIC_RECORD(
                             P_PROP_ID          => :var2,
                             P_BUSINESS_ID      => :var3);
								 end;";
								 
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->set(1, '23423423123');
        $prepare->setInt(2, $values["PL_PROP_ID"]);
        $prepare->setInt(3, $values["PL_BUSINESS_ID"]);
        @$prepare->executeUpdate();
        
        $prop_id = OCI8PreparedStatementVars::getVar($prepare, 1);				 
        $statement = "
          begin
            :var1 := RNT_PROPERTY_VALUE_PKG.insert_row( X_PROPERTY_ID   => :var2
                                                      , X_VALUE_DATE    => sysdate
                                                      , X_VALUE_METHOD  => 'ASK'
                                                      , X_VALUE         => :var3
                                                      , X_CAP_RATE      => null); 
				  end;";

        $prepare = $this->connection->prepareStatement($statement);
        $prepare->set(1, '23423423123');
        $prepare->setInt(2, $prop_id);
        $prepare->setInt(3, $values["PL_PRICE"]);
        
        
        @$prepare->executeUpdate();
        
    }
    
    public function SetListing(&$values)
    {
        $result = 0;
        $query  = "select count(*) counter
                   from pr_property_listings
                   where prop_id = :var1
									 and business_id = :var2";
        $stmt = $this->connection->prepareStatement($query);
	      $stmt->setInt(1, $values["PL_PROP_ID"]);
	      $stmt->setInt(2, $values["PL_BUSINESS_ID"]);
	    
	    $rs   = $stmt->executeQuery();  
	    while($rs->next())
	    {
	        $r = $rs->getRow();                
          $result = $r["COUNTER"];
      }
		 
      if ($result == 0)
        $this->InsertListing($values);
      else
        $this->UpdateListing($values);
      
    }

    public function InsProperty(&$values)    
		{
		  $statement = "
                 begin
                  :var1 := PR_PROPERTIES_PKG.INSERT_ROW( X_SOURCE_ID  => :var2
                                                       , X_SOURCE_PK  => :var3
                                                       , X_ADDRESS1   => :var4
                                                       , X_ADDRESS2   => :var5
                                                       , X_CITY       => upper(:var6)
                                                       , X_STATE      => :var7
                                                       , X_ZIPCODE    => :var8
                                                       , X_ACREAGE    => :var9
                                                       , X_SQ_FT      => :var10);
								 end;";
												 
     $prepare = $this->connection->prepareStatement($statement);
     $prepare->set(1, '23423423123');
     $prepare->setInt(2, '1');
     $prepare->setString(3, '');
     $prepare->setString(4, $values["PR_ADDRESS1"]);
     $prepare->setString(5, $values["PR_ADDRESS2"]);
     $prepare->setString(6, $values["PR_CITY"]);
     $prepare->setString(7, $values["PR_STATE"]);
     $prepare->setString(8, $values["PR_ZIPCODE"]);
     $prepare->setString(9, $values["PR_ACREAGE"]);
     $prepare->setString(10, $values["PR_SQ_FT"]);
         
     @$prepare->executeUpdate();
     $prop_id = OCI8PreparedStatementVars::getVar($prepare, 1);				 
     $statement = "begin
                    PR_PROPERTY_USAGE_PKG.INSERT_ROW( x_prop_id  => :var1
                                                    , x_ucode    => :var2);
                   end;";
     $prepare = $this->connection->prepareStatement($statement);                    
     $prepare->setInt(1, $prop_id);
     $prepare->setInt(2, $values["PR_UCODE"]);
     @$prepare->executeUpdate();
     
     return $prop_id;
		}    

    public function updateProperty(&$values)    
    {
    $statement = "
                 begin
                          PR_PROPERTIES_PKG.UPDATE_ROW( X_PROP_ID    => :var1
									                                     , X_SOURCE_ID  => :var2
                                                       , X_SOURCE_PK  => :var3
                                                       , X_ADDRESS1   => :var4
                                                       , X_ADDRESS2   => :var5
                                                       , X_CITY       => upper(:var6)
                                                       , X_STATE      => :var7
                                                       , X_ZIPCODE    => :var8
                                                       , X_ACREAGE    => :var9
                                                       , X_SQ_FT      => :var10
																											 , X_CHECKSUM   => :var11);
								 end;";
												 
     $prepare = $this->connection->prepareStatement($statement);
     $prepare->setInt(1, $values["PL_PROP_ID"]);
     $prepare->setInt(2, '1');
     $prepare->setString(3, '');
     $prepare->setString(4, $values["PR_ADDRESS1"]);
     $prepare->setString(5, $values["PR_ADDRESS2"]);
     $prepare->setString(6, $values["PR_CITY"]);
     $prepare->setString(7, $values["PR_STATE"]);
     $prepare->setString(8, $values["PR_ZIPCODE"]);
     $prepare->setString(9, $values["PR_ACREAGE"]);
     $prepare->setString(10, $values["PR_SQ_FT"]);
     $prepare->setString(11, $values["PR_CHECKSUM"]);
         
     @$prepare->executeUpdate();
     
     $statement = "update pr_property_usage
                   set ucode = :var1
                   where prop_id = :var2";

     $prepare = $this->connection->prepareStatement($statement);
     $prepare->setInt(1, $values["PR_UCODE"]);
     $prepare->setInt(2, $values["PL_PROP_ID"]);

     @$prepare->executeUpdate();                   
                   
    }
    
    public function InsertProperty(&$values)    
    {
    // Check to make sure property has not been inserted by someone else
      $prop_id = 0;
      $city = (htmlentities($values["PR_CITY"], ENT_QUOTES));
 			if($city) {$city = "'city = upper(''$city'')'";}
			     else {$city = "null";}        
        
        
      $query  = "select prop_id
                 from pr_properties p
                 where  catsearch(p.address1, :var1, $city) > 0";
      $stmt = $this->connection->prepareStatement($query);
	    $stmt->setInt(1, $values["PR_ADDRESS1"]);
	    
	    $rs   = $stmt->executeQuery();  
	    while($rs->next())
	    {
	        $r = $rs->getRow();                
          $prop_id = $r["PROP_ID"];
      }
		 
      if ($prop_id == 0) 
       {
        // Insert a new property
        $prop_id = $this->InsProperty($values);
        $values["PL_PROP_ID"] = $prop_id;
        $this->setListing($values);
       }
      else 
       {
        //update an existing property 
        $values["PL_PROP_ID"] = $prop_id;
        $this->setListing($values);
       }
    }
    
    public function getSource($prop_id)
    {
     $source = null;
     $query = "select s.source_name
               from pr_sources s
               ,    pr_properties p
               where p.source_id = s.source_id
               and p.prop_id = :var1";
     $stmt = $this->connection->prepareStatement($query);
     $stmt->setInt(1, $prop_id);
	   $rs   = $stmt->executeQuery();  
	    while($rs->next())
	    {
	        $r = $rs->getRow();                
          $source = $r["SOURCE_NAME"];
      }     
     return $source;
    }
    
    public function getUseCodesList($mode)
    {
       $lov = new DBLov($this->connection);
       if ($mode == "INSERT")
       {
          return $lov->HTMLSelectArray("
            select ucode as CODE
						,      description as VALUE
            from pr_usage_codes
            where parent_ucode is null
            order by ucode");
       }
       else
       {
       return $lov->HTMLSelectArray("
            select ucode as CODE
						,      description as VALUE
            from pr_usage_codes
            order by ucode");
       }

    }

    public function getPropPhotos($prop_id)
    {
        $query = "SELECT url, filename
                  FROM   pr_property_photos
                  WHERE  prop_id = :var1";
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $prop_id);
        $rs   = $stmt->executeQuery();

        $result = array();
        while($rs->next())
        {
            $r = $rs->getRow();
            $result[] = array("URL" => $r["URL"], "FILENAME" => $r["FILENAME"]);
        }
        return $result;
    }

}

?>
