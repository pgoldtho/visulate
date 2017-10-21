declare
  cursor cur_prop is
    select p.prop_id
    , n.parcel_id
    ,      n.grp_no           value_group
    ,      '90'||n.dor_uc     ucode
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
    ,      n.census_bk
    ,      g.geom
    ,      g.geom_point
    from pr_properties p
    ,    pr_nal n
    ,    pr_geo g
    where p.source_id = 3
    and n.parcel_id = p.alt_key
    and n.parcel_id = g.parcelno
    and n.co_no = '15';

  v_class  varchar2(1);
begin
  for p_rec in cur_prop loop

    if p_rec.quality_code in (1, 2) then
      v_class := 'C';
    elsif p_rec.quality_code in (3, 4) then
      v_class := 'B';
    elsif p_rec.quality_code in (5, 6) then
      v_class := 'A';
    else
      v_class := 'L';
    end if;

    update pr_properties set
     PROP_CLASS         = v_class,
     GEO_LOCATION       = p_rec.geom_point,
     GEO_FOUND_YN       = 'Y',
     PARCEL_ID          = p_rec.parcel_id,
     VALUE_GROUP        = p_rec.value_group,
     QUALITY_CODE       = p_rec.quality_code,
     YEAR_BUILT         = p_rec.year_built,
     BUILDING_COUNT     = p_rec.building_count,
     RESIDENTIAL_UNITS  = p_rec.residential_units,
     LEGAL_DESC         = p_rec.legal_desc,
     MARKET_AREA        = p_rec.market_area_code,
     NEIGHBORHOOD_CODE  = p_rec.neighborhood_code,
     CENSUS_BK          = p_rec.census_bk,
     GEO_COORDINATES    = p_rec.geom
     where prop_id = p_rec.prop_id;

     update pr_property_usage
     set ucode = p_rec.ucode
     where prop_id = p_rec.prop_id;

     commit;
   end loop;
end;
/
