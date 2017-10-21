declare

  cursor cur_prop is 
  select prop_id
  ,      source_pk
  from pr_properties p
  where source_pk in (select "TaxAcct" from brd_properties)
  and not exists (select 1 
                  from pr_buildings b
                  where b.prop_id = p.prop_id);

  cursor cur_buildings(p_source_pk in pr_properties.source_pk%type) is
  select distinct
         "PDCNo"            building_no
  ,      "UseCode"          ucode
  ,      "YearBuilt"        year_built
  ,      "ExteriorCode"     exterior_code
  ,      "RoofType"        roof_type
  ,      "RoofMaterial"    roof_material
  ,      "GarageArea"       garage
  ,      "CarPort"          car_port
  ,      "ScreenedPorches"  screen_rm
  ,      "UtilityRooms"     util_rm
  ,      "EnclosedPorches"  porch
  ,      "Basements"        basement
  ,      "Attics"           attic  
  ,      "TotAreaUnderRoof" sq_ft
  ,      "Pool"             pool
  ,      "Fireplace"        fireplace
  ,      "Fence"            fence
  ,      "LawnIrr"          lawn_irr
  ,      "Dock"             dock
  ,      "Seawall"          seawall
  ,      "RVCARPORT"        rv_port
  ,      "RVGARAGE"         rv_garage
  ,      "FrameCode"        frame_code
  FROM BRD_BUILDINGS
  where "TaxAcct" = p_source_pk;



  v_building_id    pr_buildings.building_id%type;
  v_code           number;


  procedure ins_feature( p_code        in varchar2
                       , p_type        in varchar2
                       , p_building_id in number) is

    v_length    pls_integer;
    v_posn      pls_integer;
    v_extract   varchar2(2);
    v_ncode     pls_integer;
    v_loop      pls_integer;
  begin

    v_length := length(p_code);
    v_loop   := v_length / 3;
    v_posn   := 1;

-- dbms_output.put_line(v_length);
    for i in 1 .. v_loop loop
      v_extract := substr(p_code, v_posn, 2);


      if p_type = 'EXTR' then
          if v_extract = 'MU' then
             v_ncode := 19;
          else 
             v_ncode := to_number(v_extract);
          end if;
          if (v_ncode < 20 or v_ncode=99) then
             pr_records_pkg.insert_building_feature( x_fcode       => v_ncode
                                                   , x_building_id => p_building_id);
          else
            dbms_output.put_line('code='||v_ncode||' type='||p_type||' building='||p_building_id);
          end if;

      elsif p_type = 'RTYPE' then
          if v_extract = 'MU' then
             v_ncode := 66;
          else
             v_ncode := to_number(v_extract) + 50;
          end if;
          if (v_ncode > 50 and v_ncode < 67) then
             pr_records_pkg.insert_building_feature( x_fcode       => v_ncode
                                                   , x_building_id => p_building_id);
          else
            dbms_output.put_line('code='||v_ncode||' type='||p_type||' building='||p_building_id);
          end if;

      elsif p_type = 'RMATR' then
         if v_extract = 'MU' then
             v_ncode := 44;
          else
             v_ncode := to_number(v_extract) + 30;
          end if;
          if (v_ncode > 30 and v_ncode < 45) then
            pr_records_pkg.insert_building_feature( x_fcode       => v_ncode
                                                  , x_building_id => p_building_id);
          else
            dbms_output.put_line('code='||v_ncode||' type='||p_type||' building='||p_building_id);
          end if;
      else
          if v_extract = 'MU' then
             v_ncode := 26;
          else
             v_ncode := to_number(v_extract) + 20;
          end if;
          if (v_ncode > 20 and v_ncode < 27) then
            pr_records_pkg.insert_building_feature( x_fcode       => v_ncode
                                                  , x_building_id => p_building_id);
          else
            dbms_output.put_line('code='||v_ncode||' type='||p_type||' building='||p_building_id);
          end if;
      end if;
      v_posn := v_posn + 3; 

    end loop;

  exception
    when DUP_VAL_ON_INDEX then
        return;
    when others then 
            dbms_output.put_line('Error on code='||v_ncode||' type='||p_type||' building='||p_building_id);
            raise;
  end ins_feature;

begin

  for p_rec in cur_prop loop
    for b_rec in cur_buildings(p_rec.source_pk) loop

       v_building_id := pr_records_pkg.insert_building
                             ( x_prop_id       => p_rec.prop_id
                             , x_building_name => 'Building '||b_rec.building_no
                             , x_year_built    => b_rec.year_built
                             , x_sq_ft         => b_rec.sq_ft);

       pr_records_pkg.insert_building_usage ( x_ucode       => b_rec.ucode
                                            , x_building_id => v_building_id);

       if b_rec.exterior_code is not null then
         ins_feature( p_code        => b_rec.exterior_code
                    , p_type        => 'EXTR'
                    , p_building_id => v_building_id);
       end if;

       
       if b_rec.roof_type is not null then 
         ins_feature( p_code        => b_rec.roof_type
                    , p_type        => 'RTYPE'
                    , p_building_id => v_building_id);

       end if;

       
       if b_rec.roof_material is not null then
         ins_feature( p_code        => b_rec.roof_material
                    , p_type        => 'RMATR'
                    , p_building_id => v_building_id);

       end if;

         
       if b_rec.frame_code is not null then  
         ins_feature( p_code        => b_rec.frame_code
                    , p_type        => 'FCODE'
                    , p_building_id => v_building_id);

       end if;

       if (b_rec.garage != 0 and b_rec.garage is not null) then
          v_code := 70;
          pr_records_pkg.insert_building_feature( x_fcode       => v_code
                                                , x_building_id => v_building_id);
       end if;

       if (b_rec.car_port != 0 and b_rec.car_port is not null) then
          v_code := 71;

          pr_records_pkg.insert_building_feature( x_fcode       => v_code
                                                , x_building_id => v_building_id);
       end if;

       if (b_rec.screen_rm != 0 and b_rec.screen_rm is not null) then
          v_code := 72;
          pr_records_pkg.insert_building_feature( x_fcode       => v_code
                                                , x_building_id => v_building_id);
       end if;

       if (b_rec.util_rm != 0 and b_rec.util_rm is not null) then
          v_code := 73;
          pr_records_pkg.insert_building_feature( x_fcode       => v_code
                                                , x_building_id => v_building_id);
       end if;

       if (b_rec.porch != 0 and b_rec.porch is not null) then
          v_code := 74;
          pr_records_pkg.insert_building_feature( x_fcode       => v_code
                                                , x_building_id => v_building_id);
       end if;

       if (b_rec.basement != 0 and b_rec.basement is not null) then
          v_code := 75;
          pr_records_pkg.insert_building_feature( x_fcode       => v_code
                                                , x_building_id => v_building_id);
       end if;

       if (b_rec.attic != 0 and b_rec.attic is not null) then
          v_code := 76;
          pr_records_pkg.insert_building_feature( x_fcode       => v_code
                                                , x_building_id => v_building_id);
       end if;

       if (b_rec.pool != 0 and b_rec.pool is not null) then
          v_code := 77;
          pr_records_pkg.insert_building_feature( x_fcode       => v_code
                                                , x_building_id => v_building_id);
       end if;

       if (b_rec.fireplace != 0 and b_rec.fireplace is not null) then
          v_code := 78;
          pr_records_pkg.insert_building_feature( x_fcode       => v_code
                                                , x_building_id => v_building_id);
       end if;

       if (b_rec.fence != 0 and b_rec.fence is not null) then
          v_code := 79;
          pr_records_pkg.insert_building_feature( x_fcode       => v_code
                                                , x_building_id => v_building_id);
       end if;

       if (b_rec.lawn_irr != 0 and b_rec.lawn_irr is not null) then
          v_code := 80;
          pr_records_pkg.insert_building_feature( x_fcode       => v_code
                                                , x_building_id => v_building_id);
       end if;

       if (b_rec.dock != 0 and b_rec.dock is not null) then
          v_code := 81;
          pr_records_pkg.insert_building_feature( x_fcode       => v_code
                                                , x_building_id => v_building_id);
       end if;

       if (b_rec.seawall != 0 and b_rec.seawall is not null) then
          v_code := 82;
          pr_records_pkg.insert_building_feature( x_fcode       => v_code
                                                , x_building_id => v_building_id);
       end if;

       if (b_rec.rv_port != 0 and b_rec.rv_port is not null) then
          v_code := 83;
          pr_records_pkg.insert_building_feature( x_fcode       => v_code
                                                , x_building_id => v_building_id);
       end if;

       if (b_rec.rv_garage != 0 and b_rec.rv_garage is not null) then
          v_code := 84;
          pr_records_pkg.insert_building_feature( x_fcode       => v_code
                                                , x_building_id => v_building_id);

       end if;

    end loop;
    commit;
  end loop;

end;
/
