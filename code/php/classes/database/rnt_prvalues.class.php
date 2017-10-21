<?
require_once dirname(__FILE__)."/../LOV.class.php";
require_once dirname(__FILE__)."/../OCI8PreparedStatementVars.php";
require_once dirname(__FILE__)."/../SQLExceptionMessage.class.php";
require_once dirname(__FILE__)."/rnt_base.class.php";

class RNTPRValues extends RNTBase
{
    // this value accessible inside the formatting function
    private $_menu_tree_last = null;
    
    
    public function __construct($connection)
    {
        parent::__construct($connection);
    }
    
    /**
     * Get city PR values
     *
     * @param  integer $city_id
     * @param  integer $ucode
     * @param  integer $year
     * @return array
     */
    public function getCityPRValues($city_id, $ucode, $year)
    {
        $query = " select city_id, ucode, prop_class, year, "
               . "        min_price, max_price, median_price, "
               . "        rent, vacancy_percent, replacement, maintenance, "
               . "        mgt_percent, cap_rate, utilities, " 
               . "        checksum "
               . " from  pr_values_v "
               . " where city_id = :var1 "
               . " and   ucode   = :var2 "
               . " and   year    = :var3 "
               . " order by prop_class";
        
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $city_id);
        $stmt->setInt(2, $ucode);
        $stmt->setInt(3, $year);
        $rs   = $stmt->executeQuery();
        
        $result = array();
        while($rs->next())
        {
            $r = $rs->getRow();
            $result["{$r["PROP_CLASS"]}"] = $r;
        }        
        $rs->close();
        
        return $result;
    }
    
    /**
     * Get list of usage codes of icty by year
     *
     * @param  integer   $city_id
     * @param  integer   $year
     * @return array     list of usage codes of city by year
     */
    public function getCityUsageCodesLOV($city_id, $year)
    {
        $query = " select code, value "
               . " from  ( "
               . "        select distinct prval.ucode as code, pruc.description as value "
               . "        from   pr_values_v prval, "
               . "               pr_usage_codes pruc "
               . "        where  prval.ucode   = pruc.ucode "
               . "        and    prval.city_id = :var1 "
               . "        and    (prval.year = :var2 or :var2 is null) "
               . "        union all"
               . "        select to_number(null) as code, 'Available usage codes' as value from dual "
               . "       ) "
               . " order  by code nulls first";
        
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $city_id);
        if (! empty($year))
        {
            $stmt->setInt(2, $year);
        }
        else
        {
            $stmt->setNull(2);
        }
        $rs   = $stmt->executeQuery();
           
        $result = array();
        while($rs->next())
        {
            $r = $rs->getRow();
            $result["{$r["CODE"]}"] = $r["VALUE"];
        }        
        $rs->close();
        
        return $result;
    }
    
    /**
     * Get list of years of city by usage code
     *
     * @param  integer  $city_id
     * @param  integer  $ucode
     * @return array    list of years of city by usage code
     */
    public function getCityYearsLOV($city_id, $ucode)
    {
        $query = " select code, value "
               . " from  ( "
               . "        select distinct year as code, to_char(year) as value "
               . "        from   pr_values_v "
               . "        where  city_id = :var1 "
               . "        and    (ucode = :var2 or :var2 is null) "
               . "        union all "
               . "        select to_number(null) as code, 'Available years' as value from dual "
               . "       ) "
               . " order  by code desc";
     
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $city_id);
        if (! empty($ucode))
        {
            $stmt->setInt(2, $ucode);
        }
        else
        {
            $stmt->setNull(2);
        }
        $rs   = $stmt->executeQuery();
           
        $result = array();
        while($rs->next())
        {
            $r = $rs->getRow();
            $result["{$r["CODE"]}"] = $r["VALUE"];
        }        
        $rs->close();
        
        return $result;
    }
    
    /**
     * Get next year for PR values by usage code
     *
     * @param   integer  $city_id
     * @param   integer  $ucode
     * @return  integer  next year for PR values by usage code
     */
    public function getCityNextYear($city_id, $ucode)
    {
        $query = " select nvl2(max(year), max(year)+1, to_number(to_char(sysdate, 'yyyy'))) as next_year "
               . " from   pr_values_v "
               . " where  city_id = :var1 "
               . " and    ucode   = :var2 ";
     
        $stmt = $this->connection->prepareStatement($query);
        $stmt->setInt(1, $city_id);
        if (! empty($ucode))
        {
            $stmt->setInt(2, $ucode);
        }
        else
        {
            $stmt->setNull(2);
        }
        $rs   = $stmt->executeQuery();
        
        $result = null;
        if ($rs->next())
        {
            $result = $rs->getInt("NEXT_YEAR");
        }
        $rs->close();
        
        return $result;	
    }
    
    /**
     * Add new city PR values
     *
     * @param  array    $values
     * @return boolean
     */
    public function insertRow($values)
    {
        // construct DML operation
        $statement  = "begin "
                    . "    PR_VALUES_PKG.INSERT_ROW( "
                    . "        X_CITY_ID      => :var1 "
                    . "      , X_UCODE        => :var2 "
                    . "      , X_PROP_CLASS   => :var3 "
                    . "      , X_YEAR         => :var4 "
                    . "      , X_MIN_PRICE    => :var5 "
                    . "      , X_MAX_PRICE    => :var6 "
                    . "      , X_MEDIAN_PRICE => :var7 "
                    . "      , X_RENT         => :var8 "
                    . "      , X_REPLACEMENT  => :var9 "
                    . "      , X_MAINTENANCE  => :var10 "
                    . "      , X_MGT_PERCENT  => :var11 "
                    . "      , X_CAP_RATE     => :var12 "
                    . "      , X_UTILITIES    => :var13 "
					. "      , X_VACANCY_PERCENT => :var14 "
                    . "    ); "
                    . "end;";
        // prepare DML operation
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt   (1, $values["CITY_ID"]);
        $prepare->setInt   (2, $values["UCODE"]);
        $prepare->setString(3, $values["PROP_CLASS"]);
        $prepare->setInt   (4, $values["YEAR"]);
        $prepare->setFloat (5, UtlConvert::DisplayNumericToDB($values["MIN_PRICE"]));
        $prepare->setFloat (6, UtlConvert::DisplayNumericToDB($values["MAX_PRICE"]));
        $prepare->setFloat (7, UtlConvert::DisplayNumericToDB($values["MEDIAN_PRICE"]));
        $prepare->setFloat (8, UtlConvert::DisplayNumericToDB($values["RENT"]));
        $prepare->setFloat (9, UtlConvert::DisplayNumericToDB($values["REPLACEMENT"]));
        $prepare->setFloat (10, UtlConvert::DisplayNumericToDB($values["MAINTENANCE"]));
        $prepare->setFloat (11, UtlConvert::DisplayNumericToDB($values["MGT_PERCENT"]));
        $prepare->setFloat (12, UtlConvert::DisplayNumericToDB($values["CAP_RATE"]));
        $prepare->setFloat (13, UtlConvert::DisplayNumericToDB($values["UTILITIES"]));
		$prepare->setFloat (14, UtlConvert::DisplayNumericToDB($values["VACANCY_PERCENT"]));

        // execute DML operation
        $prepare->executeUpdate();
        
        return true;
    }
    
    public function insertCityPRValues($values)
    {
        foreach ($values as $prop_class => $data)
        {
            $this->insertRow($data);
        }
    }
    
    /**
     * Update city PR values
     *
     * @param  array    $values
     * @return boolean
     */
    public function updateRow($values)
    {
        // construct DML operation
        $statement  = "begin "
                    . "    PR_VALUES_PKG.UPDATE_ROW( "
                    . "        X_CITY_ID      => :var1 "
                    . "      , X_UCODE        => :var2 "
                    . "      , X_PROP_CLASS   => :var3 "
                    . "      , X_YEAR         => :var4 "
                    . "      , X_MIN_PRICE    => :var5 "
                    . "      , X_MAX_PRICE    => :var6 "
                    . "      , X_MEDIAN_PRICE => :var7 "
                    . "      , X_RENT         => :var8 "
                    . "      , X_REPLACEMENT  => :var9 "
                    . "      , X_MAINTENANCE  => :var10 "
                    . "      , X_MGT_PERCENT  => :var11 "
                    . "      , X_CAP_RATE     => :var12 "
                    . "      , X_UTILITIES    => :var13 "
                    . "      , X_CHECKSUM     => :var14 "
					. "      , X_VACANCY_PERCENT => :var15 "
                    . "    ); "
                    . "end;";

        // prepare DML operation
        $prepare = $this->connection->prepareStatement($statement);
        $prepare->setInt   (1, $values["CITY_ID"]);
        $prepare->setInt   (2, $values["UCODE"]);
        $prepare->setString(3, $values["PROP_CLASS"]);
        $prepare->setInt   (4, $values["YEAR"]);
        $prepare->setFloat (5, UtlConvert::DisplayNumericToDB($values["MIN_PRICE"]));
        $prepare->setFloat (6, UtlConvert::DisplayNumericToDB($values["MAX_PRICE"]));
        $prepare->setFloat (7, UtlConvert::DisplayNumericToDB($values["MEDIAN_PRICE"]));
        $prepare->setFloat (8, UtlConvert::DisplayNumericToDB($values["RENT"]));
        $prepare->setFloat (9, UtlConvert::DisplayNumericToDB($values["REPLACEMENT"]));
        $prepare->setFloat (10, UtlConvert::DisplayNumericToDB($values["MAINTENANCE"]));
        $prepare->setFloat (11, UtlConvert::DisplayNumericToDB($values["MGT_PERCENT"]));
        $prepare->setFloat (12, UtlConvert::DisplayNumericToDB($values["CAP_RATE"]));
        $prepare->setFloat (13, UtlConvert::DisplayNumericToDB($values["UTILITIES"]));
        $prepare->setString(14, $values["CHECKSUM"]);
		$prepare->setFloat (15, UtlConvert::DisplayNumericToDB($values["VACANCY_PERCENT"]));

        // execute DML operation
        $prepare->executeUpdate();
        
        return true;
    }
    
    public function updateCityPRValues($values)
    {
        foreach ($values as $prop_class => $data)
        {
            $this->updateRow($data);
        }
    }
}
?>