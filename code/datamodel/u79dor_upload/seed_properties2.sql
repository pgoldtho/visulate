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
    from pr_nal n
    where co_no = p_cid
    and phy_addr1 is not null
    and phy_city is not null
    and phy_zipcd is not null
    and not exists (select 1 from pr_properties p
                    where p.source_pk = n.parcel_id);
    
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

        if p_rec.owner_name is not null then
          v_owner := pr_records_pkg.insert_owner(p_rec.owner_name, null);
          pr_records_pkg.insert_property_owner(v_owner, v_prop_id, v_mailid);
        end if;
      
        pr_records_pkg.insert_taxes( X_PROP_ID     => v_prop_id
                                   , X_TAX_YEAR    => p_rec.asmnt_yr
                                   , X_TAX_VALUE   => p_rec.tax_value
                                   , X_TAX_AMOUNT  => p_rec.tax_value * v_millage/1000);
                                 
        for s_rec in  cur_sales(p_cid, p_rec.parcel_id) loop
          begin
            pr_records_pkg.insert_property_sale
                                ( X_PROP_ID      => v_prop_id
                                , X_NEW_OWNER_ID => v_owner
                                , X_SALE_DATE    => to_date(s_rec.sale_yr||'/'||s_rec.sale_mo, 'YYYY/MM')
                                , X_DEED_CODE    => null
                                , X_PRICE        => s_rec.price
                                , X_OLD_OWNER_ID => 898931
                                , X_PLAT_BOOK    => null
                                , X_PLAT_PAGE    => null);
         exception
           when others then null;
         end;
        end loop;
      end if;
    
      v_lcount := v_lcount + 1;
      if v_lcount > 100 then
        commit;
        v_lcount := 0;
      end if;
    end loop;
--    dbms_stats.gather_schema_stats('RNTMGR');
  end seed_properties;
  
  procedure exec_seeding is
  begin
  /*
    --seed_properties(11);
    --seed_properties(44); --  'Lafayette'
    --seed_properties(59); --  'Osceola'
--     seed_properties(23); --  'Miami Dade'
     seed_properties(60); --  'Palm Beach'
        
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
--    seed_properties(23); --  'Miami Dade'
    seed_properties(56); --  'Okaloosa'
    seed_properties(24); --  'Desoto'
    seed_properties(57); --  'Okeechobee'
    seed_properties(25); --  'Dixie'
    seed_properties(26); --  'Duval'
--    seed_properties(59); --  'Osceola'
    seed_properties(27); --  'Escambia'
--    seed_properties(60); --  'Palm Beach'

    seed_properties(28); --  'Flagler'
    seed_properties(61); --  'Pasco'
    seed_properties(29); --  'Franklin'
    seed_properties(62); --  'Pinellas' -- incomplete
    
    seed_properties(30); --  'Gadsden'
    seed_properties(63); --  'Polk'
    seed_properties(31); --  'Gilchrist'
    seed_properties(64); --  'Putnam'
    seed_properties(32); --  'Glades'
    seed_properties(65); --  'St. Johns' -- redo 
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
    seed_properties(41); --  'Indian River' -- date issue line 164 
    seed_properties(42); --  'Jackson'
    seed_properties(75); --  'Wakulla'
    seed_properties(43); --  'Jefferson'
    seed_properties(76); --  'Walton'
    seed_properties(77); --  'Washington'*/
    
    seed_properties(53);
    seed_properties(19);
    seed_properties(16); 
    seed_properties(65);
    seed_properties(62);
    seed_properties(23); --  'Miami Dade'
    seed_properties(27); --  'Escambia'
  end exec_seeding;
  
begin
  exec_seeding;
end;
/


  

