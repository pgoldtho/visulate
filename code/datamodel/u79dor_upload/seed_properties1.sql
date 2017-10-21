declare
  procedure set_property_class( p_prop_id      in number
                              , p_quality_code in number) is
    v_class    PR_PROP_CLASS.PROP_CLASS%type;
  begin
    if p_quality_code in (1, 2) then 
      v_class := 'C';
    elsif p_quality_code in (3, 4) then
      v_class := 'B';  
    elsif p_quality_code in (5, 6) then
      v_class := 'A';
    else 
      v_class := 'L';
    end if;
    update pr_properties 
    set PROP_CLASS = v_class
    where prop_id = p_prop_id;
  end set_property_class;
    

 
 
  procedure seed_properties(p_cid in number) is
    cursor cur_prop(p_cid in number) is
    select parcel_id
    ,      grp_no           value_group
    ,      '90'||dor_uc     ucode      
    ,      jv               tax_value
    ,      lnd_sqfoot/43560 acreage
    ,      imp_qual         quality_code
    ,      act_yr_blt       year_built
    ,      tot_lvg_area     sq_ft
    ,      no_buldng        building_count
    ,      no_res_unts      residential_units
    ,      own_name         owner_name
    ,      own_addr1        owner_addr1
    ,      s_legal          legal_desc
    ,      mkt_ar           market_area_code
    ,      nbrhd_cd         neighborhood_code
    ,      census_bk
    ,      phy_addr1        address1
    ,      phy_addr2        address2
    ,      phy_city         city
    ,      phy_zipcd        zipcode
    ,      alt_key
    ,      asmnt_yr 
    from pr_nal
    where co_no = p_cid
    and phy_addr1 is not null
    and phy_city is not null
    and phy_zipcd is not null;
    
    cursor cur_sales(p_cid in number, p_parcel in varchar2) is
    select sale_yr
    ,      sale_mo
    ,      max(sale_prc) price
    from pr_sdf
    where co_no = p_cid
    and parcel_id = p_parcel
    group by sale_yr, sale_mo
    order by sale_yr, sale_mo;
    
    v_geo_found_yn     varchar2(1);
    v_geo_location     pr_geo.geom_point%type;
    v_geo_coordinates  pr_geo.geom%type;
    v_count            pls_integer;
    v_lcount           pls_integer;
    v_mailid           pr_properties.prop_id%type;
    v_prop_id          pr_properties.prop_id%type;
    v_owner            pr_owners.owner_id%type;
    v_parcel_id        pr_nal.parcel_id%type;
    v_millage          number;
    
  begin
    v_lcount := 0;
    select millage
    into v_millage
    from pr_millage_rates
    where id = p_cid
    and year = (select max(year) 
                from pr_millage_rates
                where id = p_cid);
    
    for p_rec in cur_prop(p_cid) loop
      v_parcel_id := p_rec.parcel_id;
      
      select count(*) into v_count
      from pr_geo
      where parcelno = v_parcel_id;
      
      if v_count = 0 then
        v_parcel_id := replace(v_parcel_id, '-', '');
        select count(*) into v_count
        from pr_geo
        where parcelno = v_parcel_id;
      end if;
      
      if v_count = 1 then
        select geom_point, geom
        into v_geo_location, v_geo_coordinates
        from pr_geo
        where parcelno = v_parcel_id;
        v_geo_found_yn := 'Y';
     else
       v_geo_location := null;
       v_geo_coordinates := null;
       v_geo_found_yn := 'N';
     end if;
     
    
    
      v_prop_id := pr_records_pkg.insert_property
                          ( X_SOURCE_ID          => p_cid
                          , X_SOURCE_PK          => p_rec.parcel_id
                          , X_ADDRESS1           => p_rec.address1 
                          , X_ADDRESS2           => p_rec.address2
                          , X_CITY               => p_rec.city
                          , X_STATE              => 'FL'
                          , X_ZIPCODE            => p_rec.zipcode
                          , X_ACREAGE            => p_rec.acreage
                          , X_SQ_FT              => p_rec.sq_ft
                          , x_geo_location       => v_geo_location
                          , x_geo_coordinates    => v_geo_coordinates
                          , x_geo_found_yn       => v_geo_found_yn
                          , x_total_bedrooms     => null
                          , x_total_bathrooms    => null
                          , x_PARCEL_ID          => p_rec.parcel_id
                          , x_alt_key            => p_rec.alt_key
                          , x_value_group        => p_rec.value_group
                          , x_quality_code       => p_rec.quality_code
                          , x_year_built         => p_rec.year_built
                          , x_building_count     => p_rec.building_count
                          , x_residential_units  => p_rec.residential_units
                          , x_legal_desc         => p_rec.legal_desc
                          , x_market_area        => p_rec.market_area_code
                          , x_neighborhood_code  => p_rec.neighborhood_code
                          , x_census_bk          => p_rec.census_bk
                          );     
                          

      if v_prop_id is not null then
      
        set_property_class( p_prop_id      => v_prop_id
                          , p_quality_code => p_rec.quality_code);
      
        pr_records_pkg.insert_property_usage(p_rec.ucode, v_prop_id);                      
        
        if p_rec.address1 = p_rec.owner_addr1 then
          v_mailid := v_prop_id;
        else
          v_mailid := null;
        end if;
      
        v_owner := pr_records_pkg.insert_owner(p_rec.owner_name, null);
        pr_records_pkg.insert_property_owner(v_owner, v_prop_id, v_mailid);
      
        pr_records_pkg.insert_taxes( X_PROP_ID     => v_prop_id
                                   , X_TAX_YEAR    => p_rec.asmnt_yr
                                   , X_TAX_VALUE   => p_rec.tax_value
                                   , X_TAX_AMOUNT  => p_rec.tax_value * v_millage/1000);
                                 
        for s_rec in  cur_sales(p_cid, p_rec.parcel_id) loop
      
          pr_records_pkg.insert_property_sale
                                ( X_PROP_ID      => v_prop_id
                                , X_NEW_OWNER_ID => v_owner
                                , X_SALE_DATE    => to_date(s_rec.sale_yr||'/'||s_rec.sale_mo, 'YYYY/MM')
                                , X_DEED_CODE    => null
                                , X_PRICE        => s_rec.price
                                , X_OLD_OWNER_ID => 898931
                                , X_PLAT_BOOK    => null
                                , X_PLAT_PAGE    => null);
        end loop;
      end if;
    
      v_lcount := v_lcount + 1;
      if v_lcount > 100 then
        commit;
        v_lcount := 0;
      end if;
    end loop;
    --dbms_stats.gather_schema_stats('RNTMGR');
  end seed_properties;
  
  procedure exec_seeding is
  begin
      /* 
    seed_properties(12); --  'Baker'
    seed_properties(45); --  'Lake'
    seed_properties(13); --  'Bay'
    seed_properties(46); --  'Lee'
    seed_properties(14); --  'Bradford'
    seed_properties(47); --  'Leon'
    seed_properties(48); --  'Levy'
    seed_properties(16); --  'Broward' -- needs redo 50% complete
    seed_properties(49); --  'Liberty'
    seed_properties(17); --  'Calhoun'
    seed_properties(50); --  'Madison'
    seed_properties(18); --  'Charlotte'
    seed_properties(51); --  'Manatee'
    seed_properties(19); --  'Citrus' -- redo 
    seed_properties(52); --  'Marion'
    seed_properties(20); --  'Clay'
    seed_properties(53); --  'Martin' -- null owner */
    seed_properties(21); --  'Collier'
    seed_properties(54); --  'Monroe'
    seed_properties(22); --  'Columbia'
    seed_properties(55); --  'Nassau'
    seed_properties(56); --  'Okaloosa'
    seed_properties(24); --  'Desoto'
    seed_properties(57); --  'Okeechobee'
    seed_properties(25); --  'Dixie'
    seed_properties(26); --  'Duval'
    seed_properties(27); --  'Escambia'

  end exec_seeding;
  
begin
  exec_seeding;
end;
/


  
