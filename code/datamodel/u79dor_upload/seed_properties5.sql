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
    ,      value_group
    ,      ucode
    ,      tax_value
    ,      acreage
    ,      quality_code
    ,      year_built
    ,      sq_ft
    ,      building_count
    ,      residential_units
    ,      owner_name
    ,      owner_addr1
    ,      legal_desc
    ,      market_area_code
    ,      neighborhood_code
    ,      census_bk
    ,      address1
    ,      address2
    ,      city
    ,      n.zipcode
    ,      alt_key
    ,      asmnt_yr 
    from pr_nal_remaining n
    ,    rnt_zipcodes z
    where co_no = p_cid
    and processed_yn = 'N'
    and n.zipcode = z.zipcode
    and sdo_within_distance
       ( z.geo_location, n.geom_point, 'distance=15000 unit=Meter') = 'TRUE';
    
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
                          
      update pr_nal_remaining
      set processed_yn = 'Y'
      where co_no = p_cid
      and parcel_id = p_rec.parcel_id;

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
      commit;
    end loop;
--    dbms_stats.gather_schema_stats('RNTMGR');
  end seed_properties;

  procedure exec_seeding is
    cursor cur_pcid is
      select distinct co_no
      from pr_nal_remaining n
      where co_no not in (15, 58, 74)
      and processed_yn = 'N'
      order by co_no;
  begin
    for p_rec in cur_pcid loop
      seed_properties(p_rec.co_no);
    end loop;
  end exec_seeding;
  
begin
  exec_seeding;
end;
/


  

