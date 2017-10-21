declare

  procedure set_addr( p_prop_id  in number
                    , p_addr     in varchar2) is
    v_old_id    number;
    v_found     boolean;
  begin
    begin
      select p.prop_id into v_old_id
      from pr_properties p
      ,    pr_properties p2
      where p.address1 = p_addr
      and p.zipcode = p2.zipcode
      and p2.prop_id = p_prop_id;
      v_found := true;
    exception
      when others then v_found := false;
    end;
    
    if v_found then
      update pr_property_owners
      set mailing_id = p_prop_id
      where mailing_id = v_old_id;
      
      delete from pr_property_usage where prop_id=v_old_id;
      delete from pr_taxes where prop_id=v_old_id;
      delete from pr_properties where prop_id = v_old_id;
    end if;
    
    update pr_properties
    set address1=p_addr
    where prop_id=p_prop_id;
  end set_addr;
    

  procedure set_addresses is
  begin
--    set_addr(14527097, 'WOODSTONE LN');
--    set_addr(14527098, 'WOODSTONE LN');
--    set_addr(14527099, 'WOODSTONE LN');
--    set_addr(14527100, 'WOODSTONE LN');
    set_addr(14783590, '29 CLERMONT CT');
    set_addr(14783690, '153 WELLSTONE DR');
    set_addr(14783871, '47 PRESIDENT LN');
    set_addr(14783921, '7 BENNETT LN');
    set_addr(14784385, '4 COTTAGE WAY');
    set_addr(14784390, '71 CIMMARON DR');
    set_addr(14784686, '41 CLEVELAND CT');
    set_addr(14784725, 'WHITE DOVE LN');
    set_addr(14784728, '6 WILD ROSE PL');
    set_addr(14784833, '81 BROCKTON LN');
    set_addr(14784872, '71 COLECHESTER LN');
    set_addr(14785261, '6 CEDARWOOD CT');
    set_addr(14785840, '34 WESTFORD LN');
    set_addr(14785915, '136 PINE GROVE DR');
    set_addr(14786220, '5 WAKEFIELD PL');
    set_addr(14786511, '49 BERKSHIRE LN');
    set_addr(14786693, '50 WEYANOKE LN');
    set_addr(14786983, '10 COLLINGVILLE CT');
    set_addr(14787096, '26 WELLER LN');
    set_addr(14787741, '48 WOODHOLLOW LN');
    set_addr(14787846, '139 BARRINGTON DR');
    set_addr(14787955, '5 CLEAR CT');
    set_addr(14788365, '24 CORNING CT');
    set_addr(14789176, '8 CROSSGATE CT E');
    set_addr(14789202, '3 CRAMPTON CT');
    set_addr(14789276, '18 WEBWOOD PL');
    set_addr(14789314, '8 WHITTING PL');
    set_addr(14789424, '59 PENNSYLVANIA LN');
    set_addr(14789854, '220 PINE GROVE DR');
    set_addr(14790054, '65 WYNNFIELD DR');
    set_addr(14790240, '13 WOODSTONE LN');
    set_addr(14790634, '5868 WALNUT AVE');
    set_addr(14791228, '1860 CR 2006');
    set_addr(14791243, '3 HARGROVE GRADE');
    set_addr(14791544, 'STATE ST N');
    set_addr(14791989, '1158 CR 305');
    set_addr(14792309, '10 AVENUE MONET');
    set_addr(14792793, 'DEEN RD');
    set_addr(14793347, '57 FARRAGUT DR');
    set_addr(14793544, 'OLD BRICK ROAD');
    set_addr(14793721, '26 FERNHAM LN');
    set_addr(14793837, '65 FERNDALE LN');
    set_addr(14793932, '7 APACHE ST');
    set_addr(14794120, '12 FIELDSTONE LN');
    set_addr(14794308, '11 OCEAN RIDGE BLVD S');
    set_addr(14794532, '54 OCEAN ST');
    set_addr(14794885, '5 DEERWOOD ST');
    set_addr(14794987, '50 CYPRESS POINT PKWY');
    set_addr(14795131, '39 FARMSWORTH DR');
    set_addr(14795398, '10 FLINTSTONE CT');
    set_addr(14795535, '95 FRONTIER DR');
    set_addr(14795805, '32 FREEMONT TURN');
    set_addr(14795913, '10406 SR 11');
    set_addr(14795969, '20 VIA ROMA');
    set_addr(14795974, '21 VIA ROMA');
    set_addr(14797080, '140 ISLAND ESTATES PKWY');
    set_addr(14798269, '13 KATSURA TREE PL');
    set_addr(14799056, '44 BLAINE DR');
    set_addr(14799177, '17 WINDWARD DR');
    set_addr(14799324, 'MEDICAL CT');
    set_addr(14799443, '53 BLAINE DR');
    set_addr(14799680, '180 ULLIAN TRL');
    set_addr(14799778, '1 CREEKSIDE CT');
    set_addr(14800130, '5507 JOHN ANDERSON HWY');
    set_addr(14800137, '5403 JOHN ANDERSON HWY');
    set_addr(14800216, '614 JOHN ANDERSON HWY');
    set_addr(14800462, '3806 JOHN ANDERSON HWY');
    set_addr(14800464, '5105 JOHN ANDERSON HWY');
    set_addr(14800477, '605 JOHN ANDERSON HWY');
    set_addr(14800751, '348 PALM CIR');
    set_addr(14801202, '3032 PAINTERS WALK');
    set_addr(14801447, '3063 PAINTERS WALK');
    set_addr(14801869, '19 BULOW WOODS CIR');
    set_addr(14801925, '21 KAFFIR LILY PL');
    set_addr(14802157, 'MEDICAL CT');
    set_addr(14802348, 'CENTRAL AVE');
    set_addr(14802354, 'CITY PL');
    set_addr(14802531, 'SECRETARY TRL');
    set_addr(14803022, '3 EAGLE CREST PATH');
    set_addr(14803023, '7 EAGLE CREST PATH');
    set_addr(14803048, '64 ETHAN ALLEN DR');
    set_addr(14803200, '12 RALEIGH DR');
    set_addr(14803855, '14 BURNABY LN');
    set_addr(14804206, '24 LONGFELLOW DR');
    set_addr(14804463, '45 LONDONDERRY DR');
    set_addr(14804937, '13 RYMER LN');
    set_addr(14805022, '94 EASTWOOD DR');
    set_addr(14805689, '8 BURNLEY PL');
    set_addr(14806166, '29 POTTERS LN');
    set_addr(14806406, '8 BISHOP LN');
    set_addr(14806581, '44 ROSE DR');
    set_addr(14806675, '18 LUTHER DR');
    set_addr(14806716, '2 BIRD HAVEN PL');
    set_addr(14807783, '1 TRAIL RUN');
--    set_addr(14808275, 'AIRPORT RD');
    set_addr(14808526, '78 BRIDGEWATER LN');
    set_addr(14808586, '600 SPRINGDALE DR');
    set_addr(14808729, '46 WINCHESTER RD');
    set_addr(14808736, '30 WINCHESTER RD');
    set_addr(14808839, '16 WINCHESTER RD');

  end set_addresses;
begin
  set_addresses;
end;
/
