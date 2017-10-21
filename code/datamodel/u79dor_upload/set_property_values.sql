declare
  procedure seed_prop_value(p_prop_id) is
    v_prop_class     pr_prop_classes.prop_class%type;
    v_sq_ft          number;
    v_quality_code   pr_properties.quality_code%type;
    v_city_id        rnt_cities.city_id%type;
    v_zipcode        rnt_city_zipcodes.zipcode%type;
    v_ucode          pr_usage_codes.ucode%type;
    v_parent_ucode   pr_usage_codes.ucode%type;    
    
    v_rent           number;
    v_sqft           number;
    v_vacancy_pct    number;
    v_lease_type     varchar2(8);
    v_maintenance    number;
    v_utilities      number;
    v_property_tax   number;
    v_insurance      number;
    v_mgt_percent    number;
    v_cap_rate       number;
    v_min_val        number;
    v_max_val        number;
    v_median_val     number;
    v_year           number;
    v_zcode_vals     pr_zipcode_summary_mv%rowtype;
    
  begin
    select p.prop_class
    ,      p.sq_ft
    ,      p.quality_code
    ,      cz.city_id
    ,      cz.zipcode
    ,      pu.ucode
    ,      uc.parent_ucode
    into v_prop_class
    ,    v_sqft
    ,    v_quality_code
    ,    v_city_id
    ,    v_zipcode
    ,    v_ucode
    ,    v_parent_ucode
    from pr_properties p
    ,    pr_property_usage pu
    ,    pr_usage_codes uc
    ,    rnt_city_zipcodes cz
    where p.prop_id = p_prop_id
    and p.prop_id = pu.prop_id
    and pu.ucode = uc.ucode
    and p.zipcode = cz.zipcode;
    
    if (v_ucode = 1     or v_parent_ucode = 1 or 
        v_ucode = 91000 or v_parent_ucode = 91000 or
        v_ucode = 11    or v_parent_ucode = 11 or
        v_ucoce = 4     or v_parent_ucode = 4 )then
       v_lease_type := 'GROSS';
    else
      v_lease_type := 'NET';
    end if;
    
    select min_price
    ,      max_price
    ,      median_price
    ,      rent
    ,      replacement
    ,      maintenance
    ,      mgt_percentage
    ,      cap_rate
    ,      vacancy_percent
    ,      utilities
    ,      year
    into v_min_val      
    ,    v_max_val      
    ,    v_median_val 
    ,    v_rent   
    ,    v_insurance
    ,    v_maintenance  
    ,    v_mgt_percent  
    ,    v_cap_rate     
    ,    v_vacancy_pct  
    ,    v_utilities  
    ,    v_year
    from pr_values
    where city_id = v_city_id
    and ucode = v_ucode
    and prop_class = v_prop_class
    and year = (select max(year)
                from pr_values
                where city_id = v_city_id
                and ucode = v_ucode
                and prop_class = v_prop_class);
                
    -- Adjust effective sq ft for property class
    if v_lease_type = 'GROSS' and v_prop_class = 'A' and v_sqft < 2000 then
       v_sqft := 2000;
    end if;

    if v_lease_type = 'GROSS' and v_prop_class = 'C' and v_sqft > 1000 then
       v_sqft := 1000;
    end if;

    v_zipfound := false;
    begin
      select *
      into v_zcode_values
      from pr_zipcode_summary_mv
      where zipcode= v_zipcode
      and ucode = v_ucode
      and sale_yr = v_year
      and sales_count > 15;
      v_zipfound := true;
    exception when others then 
      v_zipfound := false;
    end;
    
    if v_zipfound
      if v_prop_class = 'A' then
        v_rent := v_rent * v_zcode_vals.a_median / v_median;
        v_max  := v_zcode_vals.a_max
        v_min  := v_zcode_vals.a_min
        v_median := v_zcode_vals.a_median
      elsif v_prop_class = 'C' then
        v_rent := v_rent * v_zcode_vals.c_median / v_median;
        v_max  := v_zcode_vals.c_max
        v_min  := v_zcode_vals.c_min
        v_median := v_zcode_vals.c_median
      else
        v_rent := v_rent * v_zcode_vals.b_median / v_median;
        v_max  := v_zcode_vals.a_min
        v_min  := v_zcode_vals.c_max
        v_median := v_zcode_vals.c_median
      end if;
    end if;

    
    
    
     
    
 , val_rent           number 
 , val_sqft           number 
 , val_vacancy_pct    number 
 , val_lease_type     varchar2(8) 
 , val_maintenance    number 
 , val_utilities      number 
 , val_property_tax   number 
 , val_insurance      number 
 , val_mgt_fees       number 
 , val_cap_rate       number 
 , val_min_val        number 
 , val_max_val        number 
 , val_median_val 
    
  end seed_prop_value;
 
 
    
      v_lcount := v_lcount + 1;
      if v_lcount > 100 then
        commit;
        v_lcount := 0;
      end if;
    end loop;
    dbms_stats.gather_schema_stats('RNTMGR');
  end seed_properties;
  
  procedure exec_seeding is
  begin
    --seed_properties(11);
    --seed_properties(44); --  'Lafayette'
    --seed_properties(59); --  'Osceola'
    seed_properties(15);
    seed_properties(58);
    seed_properties(74);
/*        
    seed_properties(12); --  'Baker'
    seed_properties(45); --  'Lake'
    seed_properties(13); --  'Bay'
    seed_properties(46); --  'Lee'
    seed_properties(14); --  'Bradford'
    seed_properties(47); --  'Leon'
    seed_properties(48); --  'Levy'
    seed_properties(16); --  'Broward'
    seed_properties(49); --  'Liberty'
    seed_properties(17); --  'Calhoun'
    seed_properties(50); --  'Madison'
    seed_properties(18); --  'Charlotte'
    seed_properties(51); --  'Manatee'
    seed_properties(19); --  'Citrus'
    seed_properties(52); --  'Marion'
    seed_properties(20); --  'Clay'
    seed_properties(53); --  'Martin'
    seed_properties(21); --  'Collier'
    seed_properties(54); --  'Monroe'
    seed_properties(22); --  'Columbia'
    seed_properties(55); --  'Nassau'
    seed_properties(23); --  'Miami Dade'
    seed_properties(56); --  'Okaloosa'
    seed_properties(24); --  'Desoto'
    seed_properties(57); --  'Okeechobee'
    seed_properties(25); --  'Dixie'
    seed_properties(26); --  'Duval'
    seed_properties(59); --  'Osceola'
    seed_properties(27); --  'Escambia'
    seed_properties(60); --  'Palm Beach'
    seed_properties(28); --  'Flagler'
    seed_properties(61); --  'Pasco'
    seed_properties(29); --  'Franklin'
    seed_properties(62); --  'Pinellas'
    seed_properties(30); --  'Gadsden'
    seed_properties(63); --  'Polk'
    seed_properties(31); --  'Gilchrist'
    seed_properties(64); --  'Putnam'
    seed_properties(32); --  'Glades'
    seed_properties(65); --  'St. Johns'
    seed_properties(33); --  'Gulf'
    seed_properties(66); --  'St. Lucie'
    seed_properties(34); --  'Hamilton'
    seed_properties(67); --  'Santa Rosa'
    seed_properties(35); --  'Hardee'
    seed_properties(68); --  'Sarasota'
    seed_properties(36); --  'Hendry'
    seed_properties(69); --  'Seminole'
    seed_properties(37); --  'Hernando'
    seed_properties(70); --  'Sumter'
    seed_properties(38); --  'Highlands'
    seed_properties(71); --  'Suwannee'
    seed_properties(39); --  'Hillsborough'
    seed_properties(72); --  'Taylor'
    seed_properties(40); --  'Holmes'
    seed_properties(73); --  'Union'
    seed_properties(41); --  'Indian River'
    seed_properties(42); --  'Jackson'
    seed_properties(75); --  'Wakulla'
    seed_properties(43); --  'Jefferson'
    seed_properties(76); --  'Walton'
    seed_properties(77); --  'Washington'
*/    
  end exec_seeding;
  
begin
  exec_seeding;
end;
/


  

