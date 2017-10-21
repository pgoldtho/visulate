declare
    p_year  constant number := 2013;
    p_acap  number := 6;
    p_bcap  number := 7;
    p_ccap  number := 9;
    p_ins   number := 0.97;
    p_maint number := 0.52;
    p_vaca  number := 12.5;
    p_vacb  number := 15;
    p_vacc  number := 22.5;
    p_mgt1  number := 4;
    p_mgt2  number := 6;
    p_mgt3  number := 10;

    p_retail_vac     number := 7.2;
    p_office_vac     number := 18.2;
    p_industrial_vac number := 8.3;  
  

  procedure update_sales is
    TYPE min_id_rt IS RECORD
     ( owner_id   pr_owners.owner_id%TYPE
     , min_id        pr_owners.owner_id%TYPE );
    TYPE update_t IS TABLE OF min_id_rt;

    l_update_list   update_t;
  begin
    select owner_id, min_id BULK COLLECT INTO l_update_list from
      (select owner_id, min(owner_id) over (partition by owner_name) min_id
       , owner_name, count(owner_id) over (partition by owner_name) cnt
       from pr_owners  poext ) po
    where owner_id <> min_id
    and cnt >1;
    
    dbms_output.put_line('overall count: ' || l_update_list.COUNT);
    
    FORALL i IN 1 .. l_update_list.COUNT
      UPDATE pr_property_sales pps
      set new_owner_id=l_update_list(i).min_id
      WHERE new_owner_id = l_update_list(i).owner_id
      and not exists (select null
                      from pr_property_sales ppsin
                      where ppsin.new_owner_id=pps.new_owner_id
                      and ppsin.prop_id = pps.prop_id
                      and ppsin.sale_date = pps.sale_date);
  
    FORALL i IN 1 .. l_update_list.COUNT
       UPDATE pr_property_sales pps
       set old_owner_id=l_update_list(i).min_id
       WHERE old_owner_id = l_update_list(i).owner_id;

    FORALL i IN 1 .. l_update_list.COUNT
       UPDATE pr_property_owners pps
       set owner_id=l_update_list(i).min_id
       WHERE owner_id = l_update_list(i).owner_id
       and not exists (select null
                       from pr_property_owners ppsin
                       where ppsin.owner_id=pps.owner_id
                       and ppsin.prop_id = pps.prop_id);

    FORALL i IN 1 .. l_update_list.COUNT
       UPDATE pr_corporations pps
       set owner_id=l_update_list(i).min_id
       WHERE owner_id = l_update_list(i).owner_id;

    DELETE FROM pr_property_owners
    where owner_id in (select owner_id
                       from (select owner_id, min(owner_id) over (partition by owner_name) min_id
                             ,      owner_name, count(owner_id) over (partition by owner_name) cnt
                            from pr_owners  poext) po
                       where owner_id <> min_id
                       and cnt >1);

    DELETE FROM pr_property_sales
    where new_owner_id in (select owner_id
                           from (select owner_id, min(owner_id) over (partition by owner_name) min_id
                                 ,       owner_name, count(owner_id) over (partition by owner_name) cnt
                                 from pr_owners  poext) po
                           where owner_id <> min_id
                           and cnt >1);

    delete from pr_owners
    where owner_id in (select owner_id
                       from (select owner_id, min(owner_id) over (partition by owner_name) min_id
                            , owner_name, count(owner_id) over (partition by owner_name) cnt
                            from pr_owners  poext) po
                       where owner_id <> min_id
                       and cnt >1);

  end update_sales;


  procedure update_sequences is
    l_diff pls_integer;
    l_int  pls_integer;
    i  pls_integer;
  begin
    select max(prop_id)
    into l_diff
    from pr_properties;
    
    select l_diff - PR_PROPERTIES_SEQ.NEXTVAL
    into l_diff
    from dual;
    
    for i in 1..l_diff loop
      select PR_PROPERTIES_SEQ.NEXTVAL
      into l_int
      from dual;
    end loop;

    select max(owner_id)
    into l_diff
    from pr_owners;
    
    select l_diff - PR_OWNERS_SEQ.NEXTVAL
    into l_diff
    from dual;
    
    for i in 1..l_diff loop
      select PR_OWNERS_SEQ.NEXTVAL into l_int from dual;
    end loop;
  end update_sequences;

  procedure update_properties is

  begin
    merge into pr_properties ppext
    using (select pp.prop_id, count(*) over (partition by prop_id) as cnt
           , count(*) over (partition by address1, address2, zipcode) as addr_cnt
           , p.parcel_id
           , case when co_no = '15' then 3
                  when co_no = '58' then 5
                  when co_no = '74' then 4
                  else to_number(p.co_no) end as v_source
           , case when p.imp_qual in (1, 2) then  'C'
                  when p.imp_qual in (3, 4) then 'B'
                  when p.imp_qual in (5, 6) then 'A'
                  else 'L' end as v_class
           ,      p.grp_no           value_group
           ,      '90'||case when p.dor_uc='990' then '099'
                        else p.dor_uc end      ucode
           ,      p.jv               tax_value
           ,      p.lnd_sqfoot/43560 acreage
           ,      p.imp_qual         quality_code
           ,      p.act_yr_blt       year_built
           ,      p.tot_lvg_area     sq_ft
           ,      p.no_buldng        building_count
           ,      p.no_res_unts      residential_units
           ,      p.own_name         owner_name
           ,      p.own_addr1        owner_addr1
           ,      p.s_legal          legal_desc
           ,      p.mkt_ar           market_area_code
           ,      p.nbrhd_cd         neighborhood_code
           ,      p.census_bk
           ,      p.phy_addr1        address1
           ,      p.phy_addr2        address2
           ,      p.phy_city         city
           ,      p.phy_zipcd        zipcode
           ,      p.alt_key
           ,      p.asmnt_yr
           from pr_nal p
           ,    pr_properties pp
           where (pp.source_pk = p.parcel_id or pp.source_pk = p.alt_key)
           and pp.source_id = case when co_no = '15' then  3
                                   when co_no = '58' then  5
                                   when co_no = '74' then 4
                                   else to_number(p.co_no) end
           and phy_addr1 is not null
           and phy_city is not null
           and phy_zipcd is not null) s 
    on (ppext.prop_id = s.prop_id
        and s.cnt < 2
        and s.addr_cnt < 2 )
    WHEN MATCHED THEN UPDATE
    SET PARCEL_ID        = s.PARCEL_ID
    , PROP_CLASS         = s.v_class
    , value_group        = s.value_group
    , quality_code       = s.quality_code
    , year_built         = s.year_built
    , building_count     = s.building_count
    , residential_units  = s.residential_units
    , legal_desc         = s.legal_desc
    , market_area        = s.market_area_code
    , neighborhood_code  = s.neighborhood_code
    , census_bk          = s.census_bk;

    INSERT INTO PR_PROPERTIES
       ( PROP_ID
       , SOURCE_ID
       , SOURCE_PK
       , PROP_CLASS
       , ADDRESS1
       , ADDRESS2
       , CITY
       , STATE
       , ZIPCODE
       , ACREAGE
       , SQ_FT
       , geo_location
       , geo_coordinates
       , geo_found_yn
       , total_bedrooms
       , total_bathrooms
       , PARCEL_ID
       , alt_key  
       , value_group 
       , quality_code
       , year_built  
       , building_count
       , residential_units 
       , legal_desc        
       , market_area       
       , neighborhood_code 
       , census_bk )
     select PR_PROPERTIES_SEQ.NEXTVAL
       , s.v_source
       , s.parcel_id
       , s.v_class
       , s.ADDRESS1
       , s.ADDRESS2
       , s.CITY
       , 'FL'
       , s.ZIPCODE
       , s.ACREAGE
       , s.SQ_FT
       , NULL
       , NULL
       , 'N'  
       , NULL
       , NULL
       , s.PARCEL_ID
       , s.alt_key
       , s.value_group     
       , s.quality_code    
       , s.year_built      
       , s.building_count  
       , s.residential_units 
       , s.legal_desc        
       , s.market_area_code       
       , s.neighborhood_code 
       , s.census_bk
     from ( select NVL(min(p.parcel_id)
            over (partition by p.phy_addr1, p.phy_addr2, p.phy_zipcd), p.alt_key) as min_parcel
          , p.parcel_id
          , case when co_no = '15' then  3
                 when co_no = '58' then  5
                 when co_no = '74' then 4
                 else to_number(p.co_no) end as v_source
          , case when p.imp_qual in (1, 2) then  'C'
                 when p.imp_qual in (3, 4) then 'B'
                 when p.imp_qual in (5, 6) then 'A'
                 else 'L' end as v_class
          ,      p.grp_no           value_group
          ,      '90'||case when p.dor_uc='990' then '099'
                            else p.dor_uc end      ucode
          ,      p.jv               tax_value
          ,      p.lnd_sqfoot/43560 acreage
          ,      p.imp_qual         quality_code
          ,      p.act_yr_blt       year_built
          ,      p.tot_lvg_area     sq_ft
          ,      p.no_buldng        building_count
          ,      p.no_res_unts      residential_units
          ,      p.own_name         owner_name
          ,      p.own_addr1        owner_addr1
          ,      p.s_legal          legal_desc
          ,      p.mkt_ar           market_area_code
          ,      p.nbrhd_cd         neighborhood_code
          ,      p.census_bk
          ,      p.phy_addr1        address1
          ,      p.phy_addr2        address2
          ,      p.phy_city         city
          ,      p.phy_zipcd        zipcode
          ,      p.alt_key
          ,      p.asmnt_yr
          from pr_nal p
          WHERE NOT EXISTS (SELECT NULL
                            FROM pr_properties pp
                            where (pp.source_pk = p.parcel_id or
                                   pp.source_pk = p.alt_key)
                            and pp.source_id = case when co_no = '15' then  3
                                                    when co_no = '58' then  5
                                                    when co_no = '74' then 4
                                                    else to_number(p.co_no) end )
         and phy_addr1 is not null
         and phy_city is not null
         and phy_zipcd is not null) s
    WHERE NOT EXISTS (SELECT null
                      from pr_properties pp2
                      where pp2.address1 = s.address1
                      and NVL(pp2.address2, ' ') = NVL(s.address2, ' ' )
                      and pp2.zipcode = s.zipcode)
    AND parcel_id = min_parcel
    --AND min_parcel IS NOT NULL
    --AND rownum <20;
    ;


    merge into PR_PROPERTY_USAGE ppuext
    using (select pp.prop_id ,'90'||p.dor_uc ucode      
           from pr_nal p
           ,    pr_properties pp
           where (pp.source_pk = p.parcel_id or
                  pp.source_pk = p.alt_key)
           and pp.source_id = case when co_no = '15' then  3
                                   when co_no = '58' then  5
                                   when co_no = '74' then 4
                                   else to_number(p.co_no) end 
           and phy_addr1 is not null
           and phy_city is not null
           and phy_zipcd is not null) s
    on  (ppuext.prop_id = s.prop_id)
    WHEN MATCHED THEN 
    UPDATE  SET ucode = s.ucode
    WHERE ucode <> s.ucode;

    INSERT into PR_PROPERTY_USAGE (PROP_ID, ucode) 
    select distinct prop_id, ucode
    from (select NVL(min(p.parcel_id)
          over (partition by p.phy_addr1, p.phy_addr2, p.phy_zipcd), p.alt_key) as min_parcel
          ,  p.parcel_id
          ,  pp.prop_id ,'90'||case when p.dor_uc='990' then '099'
                                    else p.dor_uc end ucode
          from pr_nal p
          ,    pr_properties pp
          where (pp.source_pk = p.parcel_id or
                 pp.source_pk = p.alt_key)
          and pp.source_id = case when co_no = '15' then  3
                                  when co_no = '58' then  5
                                  when co_no = '74' then 4
                                  else to_number(p.co_no) end
         and phy_addr1 is not null
         and phy_city is not null
         and phy_zipcd is not null) s
    WHERE parcel_id = min_parcel
    AND ucode IS NOT NULL
    AND NOT EXISTS (SELECT NULL
                    FROM PR_PROPERTY_USAGE ppu
                    where ppu.prop_id = s.prop_id
                    and ppu.ucode = s.ucode);

    insert into PR_OWNERS( OWNER_ID, OWNER_NAME, OWNER_TYPE)
    SELECT PR_OWNERS_SEQ.NEXTVAL as OWNER_ID, OWN_NAME, NULL
    FROM (select distinct own_name
          from pr_nal
          where own_name is not null
          and not exists (select null
                          from pr_owners
                          where owner_name=own_name));

    insert into PR_PROPERTY_OWNERS( OWNER_ID, PROP_ID, MAILING_ID)
    SELECT distinct OWNER_ID, PROP_ID, v_MAILING_ID
    FROM (select pp.prop_id
          ,  NVL(po.OWNER_ID, 898931) as owner_id
          ,  count(*) over (partition by prop_id, NVL(po.OWNER_ID, 898931)) as cnt
          ,  case when p.phy_addr1 = p.own_addr1 then pp.prop_id
                  else null end as v_mailing_id
          from pr_nal p
          ,    pr_properties pp
          ,    pr_owners po
          where (pp.source_pk = p.parcel_id or
                 pp.source_pk = p.alt_key)
          and pp.source_id = case when co_no = '15' then 3
                                  when co_no = '58' then 5
                                  when co_no = '74' then 4
                                  else to_number(p.co_no) end
          and phy_addr1 is not null
          and phy_city is not null
          and phy_zipcd is not null
          and p.own_name=po.owner_name(+)) p
    where not exists (select null
                      from PR_PROPERTY_OWNERS ppo
                      where ppo.owner_id = p.owner_id
                      and ppo.prop_id = p.prop_id)
    and cnt < 2;


    insert into PR_PROPERTY_SALES (sale_date, price, new_owner_id, prop_id, deed_code, old_owner_id)
    select x_sal_date, price, new_owner_id, x_prop_id, x_deed_code, old_owner_id
    from (select to_date(s.sale_yr||'/'||s.sale_mo, 'YYYY/MM') as x_sal_date
          ,      s.price
          ,      case when s.dr=s.cnt then (select NVL(min(owner_id), 898931)
                                            from pr_owners
                                            where owner_name=s.own_name)
                      else 898931 end  as new_owner_id
          ,     s.prop_id as x_prop_id
          ,    'AM' as x_deed_code
          ,    case when s.dr=1 then NVL((select distinct first_value (new_owner_id)
                                          over (order by sale_date desc)
                                          from pr_property_sales
                                          where prop_id=s.prop_id
                                          and sale_date < to_date(s.sale_yr||'/'||s.sale_mo, 'YYYY/MM') ), 898931)
                    else 898931 end  as old_owner_id
         from (select distinct ss.prop_id
               , ps.co_no
               , ps.parcel_id
               , ss.own_name
               , sale_yr
               , sale_mo
               , max(sale_prc)
               over (partition by  ss.prop_id, ps.co_no, ps.parcel_id, ss.own_name, sale_yr, sale_mo) price
               , dense_rank() over(partition by prop_id order by sale_yr, sale_mo) dr
               , count(distinct sale_yr || sale_mo) over(partition by prop_id) cnt
               from (select pp.prop_id
                     ,      p.parcel_id
                     ,      p.own_name
                     ,      case when p.co_no = '15' then  3
                                 when p.co_no = '58' then  5
                                 when p.co_no = '74' then 4
                                 else to_number(p.co_no) end as cid
                     , count(*) over (partition by prop_id) as cnt
                     from pr_nal p
                     ,    pr_properties pp
                     where (pp.source_pk = p.parcel_id or
                            pp.source_pk = p.alt_key)
                     and pp.source_id = case when p.co_no = '15' then 3
                                             when p.co_no = '58' then 5
                                             when p.co_no = '74' then 4
                                             else to_number(p.co_no) end
                     and phy_addr1 is not null
                     and phy_city is not null
                     and phy_zipcd is not null) ss
               , pr_sdf ps
               where ss.cnt =1
               and case when ps.co_no = '15' then  3
                        when ps.co_no = '58' then  5
                        when ps.co_no = '74' then 4
                        else to_number(ps.co_no) end = ss.cid
               and ps.parcel_id = ss.parcel_id) s ) ss
    where 1=1
    and not exists (select null
                    from PR_PROPERTY_SALES pps
                    where pps.prop_id = ss.x_prop_id
    and pps.NEW_OWNER_ID = ss.new_owner_id
    and pps.SALE_DATE = ss.x_sal_date);
  end update_properties;

  procedure update_mviews is
  begin

    dbms_mview.refresh('PR_COMMERCIAL_SALES_MV', 'C');
    dbms_mview.refresh('PR_LAND_SUMMARY_MV', 'C');
    dbms_mview.refresh('PR_LAND_SALES_MV', 'C');
    dbms_mview.refresh('PR_COMMERCIAL_SUMMARY_MV', 'C');
    dbms_mview.refresh('PR_COUNTY_SUMMARY_MV', 'C');
    dbms_mview.refresh('PR_SALES_MV', 'C');
    dbms_mview.refresh('PR_SALES_SUMMARY_MV', 'C');
  end update_mviews;

  procedure update_tax_values is

  begin
    update pr_taxes
    set current_yn = 'N';

    insert into pr_taxes (PROP_ID, TAX_YEAR, TAX_VALUE, TAX_AMOUNT, CURRENT_YN)
    select prop_id, p_year, tax_value, tax_amount, 'Y'
    from tmp_tax_values;
    
  end update_tax_values;

  procedure set_ucode_summary is
    cursor cur_summary is
    select c.city_id
    ,      u.ucode
    ,      count(*)              property_count
    ,      sum(nvl(p.sq_ft, 0))  total_area
    from rnt_cities c
    ,    pr_properties p
    ,    rnt_city_zipcodes cz
    ,    pr_property_usage u
    where  c.city_id = cz.city_id
    and to_char(cz.zipcode) = p.zipcode
    and c.state = 'FL'
    and u.prop_id = p.prop_id
    group by c.city_id, u.ucode
    order by c.city_id, u.ucode;

    v_count     pls_integer;
    v_ucode     pr_usage_codes.ucode%type;
    v_current   rnt_cities.city_id%type;
  begin
    v_current := 99999999999999;
    for s_rec in cur_summary loop
      if v_current != s_rec.city_id then
        v_current := s_rec.city_id;
        delete from pr_ucode_data
        where city_id = s_rec.city_id;
      end if;
      
      select count(*) into v_count
      from pr_ucode_data
      where city_id = s_rec.city_id
      and ucode = s_rec.ucode;

      if v_count = 0 then
        insert into pr_ucode_data
          (city_id, ucode, property_count, total_sqft)
        values
          (s_rec.city_id, s_rec.ucode, s_rec.property_count, nvl(s_rec.total_area, 0));
      else
        update pr_ucode_data
        set property_count = s_rec.property_count
        ,   total_sqft     = nvl(s_rec.total_area, 0)
        where
        city_id = s_rec.city_id
        and ucode = s_rec.ucode;

      end if;
    end loop;
  end set_ucode_summary;

  function get_rent( p_price   in number
                   , p_class   in varchar2
                   , p_millage in number) return number is
    v_noi     number;
    v_cap     number;
    v_pct     number;
    v_rent    number;
    v_tax     number;
    v_exp     number;
  begin
    if p_class = 'A' then
      v_cap := p_acap;
      v_pct := p_mgt1 + p_vaca;
    elsif p_class = 'C' then
      v_cap := p_ccap;
      v_pct := p_mgt2 + p_vacc;
    else
      v_cap := p_bcap;
      v_pct := p_mgt1 + p_vacb;
    end if;

    v_tax := p_price * p_millage/1000;
    v_noi := p_price * v_cap/100;
    v_exp := v_tax + p_maint + p_ins;
    v_rent := ((v_noi + v_exp) * 100)/(100 - v_pct);

    return v_rent;
  end get_rent;

  FUNCTION get_caprate( p_gross  in number
                      , p_maint  in number
                      , p_ins    in number
                      , p_mgt    in number
                      , p_vac    in number
                      , p_tax    in number
                      , p_value  in number
                      , p_ltype  in varchar2) return number is
    v_caprate    number;
    v_expense    number;
  begin
    if (p_ltype = 'GROSS' and p_value > 0) then
      v_expense := p_maint + p_ins + p_tax + (p_gross * p_vac/100) + (p_gross * p_mgt/100);
      v_caprate := round(((p_gross - v_expense) * 100/p_value), 1);
    elsif (p_ltype = 'NNN' and p_value > 0)then
      v_expense := ((p_maint + p_ins + p_tax) * p_vac/100) + (p_gross * p_vac/100) + (p_gross * p_mgt/100);
      v_caprate := round(((p_gross - v_expense) * 100/p_value), 1);
    else
      v_caprate := 0;
    end if;
    return v_caprate;
  end get_caprate;

  procedure set_value_estimates is


  cursor cur_cities is
    select c.city_id, m.year sale_yr, ud.ucode, uc.description
    , uc.parent_ucode, m.rent_rate, c.name, m.millage
    from pr_ucode_data ud
    ,    pr_usage_codes uc
    ,    rnt_cities c
    ,    pr_millage_rates m
    where ud.ucode = uc.ucode
    and c.city_id = ud.city_id
    and c.county = upper(m.county)
    and c.state = 'FL'
    order by 1, 2, 3;


  type lrate_type is record
      ( a_median         number
      , b_median         number
      , c_median         number
      , prop_count       number);
  type lrate_tab_type is table of lrate_type index by varchar2(256);
  lrate        lrate_tab_type;
  
  cursor cur_lease_rates is
    select u2.ucode
    ,      s.tax_year
    ,      round(PERCENTILE_DISC(0.8) within group (order by s.tax_amount/nvl(p.sq_ft, p.acreage)) * 10, 2) a_median
    ,      round(PERCENTILE_DISC(0.5) within group (order by s.tax_amount/nvl(p.sq_ft, p.acreage)) * 10, 2) b_median
    ,      round(PERCENTILE_DISC(0.2) within group (order by s.tax_amount/nvl(p.sq_ft, p.acreage)) * 10, 2) c_median
    ,      count(*) prop_count
    from pr_properties p
    ,    pr_taxes s
    ,    pr_property_usage pu
    ,    pr_usage_codes u
    ,    rnt_city_zipcodes cz
    ,    rnt_cities c
    ,    pr_usage_codes u2
    where c.city_id = cz.city_id
    and to_char(cz.zipcode) = p.zipcode
    and c.state='FL'
    and pu.prop_id = p.prop_id
    and p.prop_id = s.prop_id
    and u.ucode = pu.ucode
    and u.parent_ucode = u2.ucode
    and p.sq_ft != 0
    and nvl(p.sq_ft, p.acreage) != 0
    and (s.tax_amount/nvl(p.sq_ft, p.acreage) < 25)
    group by  u2.ucode, s.tax_year having count(*) > 20
    order by  u2.ucode, s.tax_year;

    type city_values_type is record
      ( a_max            number
      , a_median         number
      , a_min            number
      , b_median         number
      , c_max            number
      , c_median         number
      , c_min            number
      , sales_count      number);
    type city_values_tab_type is table of city_values_type index by varchar2(256);
    city_value           city_values_tab_type;
    county_value         city_values_tab_type;

      
    cursor cur_city_values is
    select c.city_id
    ,      pu.ucode
    ,      to_char(s.sale_date, 'YYYY') sale_yr
    ,      round(max (s.price/nvl(p.sq_ft, p.acreage)), 2) a_max
    ,      round(PERCENTILE_DISC(0.875) within group (order by s.price/nvl(p.sq_ft, p.acreage)), 2) a_median
    ,      round(PERCENTILE_DISC(0.75) within group (order by s.price/nvl(p.sq_ft, p.acreage)), 2) a_min
    ,      round(PERCENTILE_DISC(0.5) within group (order by s.price/nvl(p.sq_ft, p.acreage)), 2) b_median
    ,      round(PERCENTILE_DISC(0.25) within group (order by s.price/nvl(p.sq_ft, p.acreage)), 2) c_max
    ,      round(PERCENTILE_DISC(0.175) within group (order by s.price/nvl(p.sq_ft, p.acreage)), 2) c_median
    ,      round(min (s.price/nvl(p.sq_ft, p.acreage)), 2) c_min
    ,      count(*) sales_count
    from pr_properties p
    ,    pr_property_sales s
    ,    pr_property_usage pu
    ,    rnt_city_zipcodes cz
    ,    rnt_cities c
    where c.city_id = cz.city_id
    and to_char(cz.zipcode) = p.zipcode
    and c.state='FL'
    and pu.prop_id = p.prop_id
    and p.prop_id = s.prop_id
    and s.price > 200
    and nvl(p.sq_ft, p.acreage) > 0
    and s.price/nvl(p.sq_ft, p.acreage) < 1000
    and s.price/nvl(p.sq_ft, p.acreage) > 10
    group by c.city_id, pu.ucode, to_char(s.sale_date, 'YYYY')
    order by c.city_id, pu.ucode, to_char(s.sale_date, 'YYYY');

    cursor cur_county_values is
      select c.county, c.state
          ,      uc.parent_ucode ucode
          ,      to_char(s.sale_date, 'YYYY') sale_yr
          ,      round(max (s.price/nvl(p.sq_ft, p.acreage)), 2) a_max
          ,      round(PERCENTILE_DISC(0.875) within group (order by s.price/nvl(p.sq_ft, p.acreage)), 2) a_median
          ,      round(PERCENTILE_DISC(0.75) within group (order by s.price/nvl(p.sq_ft, p.acreage)), 2) a_min
          ,      round(PERCENTILE_DISC(0.5) within group (order by s.price/nvl(p.sq_ft, p.acreage)), 2) b_median
          ,      round(PERCENTILE_DISC(0.25) within group (order by s.price/nvl(p.sq_ft, p.acreage)), 2) c_max
          ,      round(PERCENTILE_DISC(0.175) within group (order by s.price/nvl(p.sq_ft, p.acreage)), 2) c_median
          ,      round(min (s.price/nvl(p.sq_ft, p.acreage)), 2) c_min
          ,      count(*) sales_count
          from pr_properties p
          ,    pr_property_sales s
          ,    pr_property_usage pu
          ,    rnt_city_zipcodes cz
          ,    rnt_cities c
          ,    pr_usage_codes uc
          where c.city_id = cz.city_id
          and to_char(cz.zipcode) = p.zipcode
          and c.state='FL'
          and pu.prop_id = p.prop_id
          and p.prop_id = s.prop_id
          and s.price > 200
          and nvl(p.sq_ft, p.acreage) > 0
          and s.price/nvl(p.sq_ft, p.acreage) < 1000
          and s.price/nvl(p.sq_ft, p.acreage) > 10
          and uc.ucode = pu.ucode
          group by c.county, c.state, uc.parent_ucode, to_char(s.sale_date, 'YYYY')
     order by c.county, uc.parent_ucode, sale_yr;


    type v_values_type is record
      ( min_price    number
      , max_price    number
      , median_price number
      , rent         number
      , replacement  number
      , maintenance  number
      , mgt_percent  number
      , cap_rate     number
      , vacancy_pct  number
      , utilities    number );
    type v_values_tab is table of v_values_type
      index by varchar2(1);

    v_values        v_values_tab;
    v_parent_ucode  pr_usage_codes.ucode%type;
    v_ucode         pr_usage_codes.ucode%type;
    v_millage       number;
    v_rent_rate     number;
    v_counter       pls_integer;
    v_row           varchar2(256);
    v_row2          varchar2(256);
    v_lease_indx    varchar2(256);
    v_ltype         varchar2(16);
    va_rent         number;
    vb_rent         number;
    vc_rent         number;
    
  begin
  dbms_output.put_line(to_char(sysdate,'hh24:mi'));
    for v_rec in cur_lease_rates loop
      lrate(v_rec.ucode||':'||v_rec.tax_year).a_median := v_rec.a_median;
      lrate(v_rec.ucode||':'||v_rec.tax_year).b_median := v_rec.b_median;
      lrate(v_rec.ucode||':'||v_rec.tax_year).c_median := v_rec.c_median;
    end loop;
  dbms_output.put_line(to_char(sysdate,'hh24:mi'));   
    for v_rec in cur_city_values loop
      city_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).a_max := v_rec.a_max;
      city_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).a_median := v_rec.a_median;
      city_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).a_min := v_rec.a_min;
      city_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).b_median := v_rec.b_median;
      city_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).c_max := v_rec.c_max;
      city_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).c_median := v_rec.c_median;
      city_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).c_min := v_rec.c_min;
      city_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).sales_count := v_rec.sales_count;
    end loop;
  dbms_output.put_line(to_char(sysdate,'hh24:mi'));
    for v_rec in cur_city_values loop
      county_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).a_max := v_rec.a_max;
      county_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).a_median := v_rec.a_median;
      county_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).a_min := v_rec.a_min;
      county_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).b_median := v_rec.b_median;
      county_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).c_max := v_rec.c_max;
      county_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).c_median := v_rec.c_median;
      county_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).c_min := v_rec.c_min;
      county_value(v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr).sales_count := v_rec.sales_count;
    end loop;
  dbms_output.put_line(to_char(sysdate,'hh24:mi'));

    for v_rec in cur_cities loop

      v_ucode := v_rec.ucode;
      v_parent_ucode := v_rec.parent_ucode;
      v_row := v_rec.city_id||':'||v_rec.ucode||':'||v_rec.sale_yr;
      v_row2 := v_rec.city_id||':'||v_rec.parent_ucode||':'||v_rec.sale_yr;
      v_lease_indx := v_rec.parent_ucode||':'||v_rec.sale_yr;

      
      v_millage := v_rec.millage;
      v_rent_rate := v_rec.rent_rate;
      

      if city_value.exists(v_row) then
        if (city_value(v_row).sales_count < 16
            and county_value.exists(v_row2)) then
          v_values('A').min_price := county_value(v_row2).a_min;
          v_values('B').min_price := county_value(v_row2).c_max + 0.01;
          v_values('C').min_price := county_value(v_row2).c_min;

          v_values('A').median_price := county_value(v_row2).a_median;
          v_values('B').median_price := county_value(v_row2).b_median;
          v_values('C').median_price := county_value(v_row2).c_median;

          v_values('A').max_price := county_value(v_row2).a_max;
          v_values('B').max_price := county_value(v_row2).a_min - 0.01;
          v_values('C').max_price := county_value(v_row2).c_max;
        else
          v_values('A').min_price := city_value(v_row).a_min;
          v_values('B').min_price := city_value(v_row).c_max + 0.01;
          v_values('C').min_price := city_value(v_row).c_min;

          v_values('A').median_price := city_value(v_row).a_median;
          v_values('B').median_price := city_value(v_row).b_median;
          v_values('C').median_price := city_value(v_row).c_median;

          v_values('A').max_price := city_value(v_row).a_max;
          v_values('B').max_price := city_value(v_row).a_min - 0.01;
          v_values('C').max_price := city_value(v_row).c_max;
        end if;
      end if;
    
      if v_parent_ucode = 3 then -- land
        v_values('A').rent        := 0;
        v_values('A').replacement := 0;
        v_values('A').maintenance := 0;
        v_values('A').mgt_percent := 0;
        v_values('A').cap_rate    := 0;
        v_values('A').vacancy_pct := 0;
        v_values('A').utilities   := 0;
        v_values('B').rent        := 0;
        v_values('B').replacement := 0;
        v_values('B').maintenance := 0;
        v_values('B').mgt_percent := 0;
        v_values('B').cap_rate    := 0;
        v_values('B').vacancy_pct := 0;
        v_values('B').utilities   := 0;
        v_values('C').rent        := 0;
        v_values('C').replacement := 0;
        v_values('C').maintenance := 0;
        v_values('C').mgt_percent := 0;
        v_values('C').cap_rate    := 0;
        v_values('C').vacancy_pct := 0;
        v_values('C').utilities   := 0;
        v_ltype := 'LAND';
      elsif v_parent_ucode in (91000, 1) then -- residential
        v_values('A').rent        := v_rent_rate;
        v_values('A').replacement := p_ins;
        v_values('A').maintenance := p_maint;
        v_values('A').mgt_percent := p_mgt3;
        v_values('A').cap_rate    := p_acap;
        v_values('A').vacancy_pct := p_vaca;
        v_values('A').utilities   := 0;
        v_values('B').rent        := v_rent_rate;
        v_values('B').replacement := p_ins;
        v_values('B').maintenance := p_maint;
        v_values('B').mgt_percent := p_mgt3;
        v_values('B').cap_rate    := p_bcap;
        v_values('B').vacancy_pct := p_vacb;
        v_values('B').utilities   := 0;
        v_values('C').rent        := v_rent_rate;
        v_values('C').replacement := p_ins;
        v_values('C').maintenance := p_maint;
        v_values('C').mgt_percent := p_mgt3;
        v_values('C').cap_rate    := p_ccap;
        v_values('C').vacancy_pct := p_vacc;
        v_values('C').utilities   := 0;
        v_ltype := 'GROSS';
      else -- commercial and industrial
        va_rent := get_rent(v_values('A').median_price, 'A',v_millage);
        vb_rent := get_rent(v_values('B').median_price, 'B',v_millage);
        vc_rent := get_rent(v_values('C').median_price, 'C',v_millage);
      
        if lrate.exists(v_lease_indx) then
          v_values('A').rent  := lrate(v_lease_indx).a_median;
          v_values('B').rent  := lrate(v_lease_indx).b_median;
          v_values('C').rent  := lrate(v_lease_indx).c_median;
        else
          v_values('A').rent  := va_rent;
          v_values('B').rent  := vb_rent;
          v_values('C').rent  := vc_rent;
        end if;
/*
        if v_values('A').rent > va_rent + (va_rent * 0.15) then
          v_values('A').rent := va_rent + (va_rent * 0.15);
        elsif v_values('A').rent < va_rent - (va_rent * 0.15) then
          v_values('A').rent := va_rent - (va_rent * 0.15);
        end if;

        if v_values('B').rent > vb_rent + (vb_rent * 0.15) then
          v_values('B').rent := vb_rent + (vb_rent * 0.15);
        elsif v_values('B').rent < vb_rent - (vb_rent * 0.15) then
          v_values('B').rent := vb_rent - (vb_rent * 0.15);
        end if;

        if v_values('C').rent > vc_rent + (vc_rent * 0.15) then
          v_values('C').rent := vc_rent + (vc_rent * 0.15);
        elsif v_values('C').rent < vc_rent - (vc_rent * 0.15) then
          v_values('C').rent := vc_rent - (vc_rent * 0.15);
        end if;
*/ 
        if v_parent_ucode = 11 then -- multifamily
          v_values('A').vacancy_pct := 15;
          v_values('B').vacancy_pct := 15;
          v_values('C').vacancy_pct := 20;
        elsif v_parent_ucode = 12 then -- office
          v_values('A').vacancy_pct := p_office_vac;
          v_values('B').vacancy_pct := p_office_vac;
          v_values('C').vacancy_pct := p_office_vac;
        elsif v_parent_ucode in (13, 93000) then -- industrial
          v_values('A').vacancy_pct := p_industrial_vac;
          v_values('B').vacancy_pct := p_industrial_vac;
          v_values('C').vacancy_pct := p_industrial_vac;
        elsif v_parent_ucode in (14, 15) then -- retail
          v_values('A').vacancy_pct := p_retail_vac;
          v_values('B').vacancy_pct := p_retail_vac;
          v_values('C').vacancy_pct := p_retail_vac;
        elsif v_parent_ucode = 17 then -- hotel
          v_values('A').vacancy_pct := 35;
          v_values('B').vacancy_pct := 35;
          v_values('C').vacancy_pct := 35;
        else
          v_values('A').vacancy_pct := 8;
          v_values('B').vacancy_pct := 8;
          v_values('C').vacancy_pct := 8;
        end if;
          
          
          
        v_values('A').replacement := p_ins;
        v_values('A').maintenance := p_maint;
        v_values('A').mgt_percent := p_mgt1;
        v_values('A').cap_rate    := p_acap;
        
        v_values('A').utilities   := 0;
        
        v_values('B').replacement := p_ins;
        v_values('B').maintenance := p_maint;
        v_values('B').mgt_percent := p_mgt1;
        v_values('B').cap_rate    := p_bcap;
        
        v_values('B').utilities   := 0;
        
        v_values('C').replacement := p_ins;
        v_values('C').maintenance := p_maint;
        v_values('C').mgt_percent := p_mgt2;
        v_values('C').cap_rate    := p_ccap;
        
        v_values('C').utilities   := 0;
        v_ltype := 'NNN';
      end if;
/*
      v_values('A').cap_rate := get_caprate( p_gross  => v_values('A').rent
                                           , p_maint  => v_values('A').maintenance
                                           , p_ins    => v_values('A').replacement
                                           , p_mgt    => v_values('A').mgt_percent
                                           , p_vac    => v_values('A').vacancy_pct 
                                           , p_tax    => v_values('A').rent/10
                                           , p_value  => v_values('A').median_price
                                           , p_ltype  => v_ltype);

      v_values('B').cap_rate := get_caprate( p_gross  => v_values('B').rent
                                           , p_maint  => v_values('B').maintenance
                                           , p_ins    => v_values('B').replacement
                                           , p_mgt    => v_values('B').mgt_percent
                                           , p_vac    => v_values('B').vacancy_pct
                                           , p_tax    => v_values('B').rent/10
                                           , p_value  => v_values('B').median_price
                                           , p_ltype  => v_ltype);

      v_values('C').cap_rate := get_caprate( p_gross  => v_values('C').rent
                                           , p_maint  => v_values('C').maintenance
                                           , p_ins    => v_values('C').replacement
                                           , p_mgt    => v_values('C').mgt_percent
                                           , p_vac    => v_values('C').vacancy_pct
                                           , p_tax    => v_values('C').rent/10
                                           , p_value  => v_values('C').median_price
                                           , p_ltype  => v_ltype);
*/
           
      select count(*)
      into v_counter
      from pr_values
      where city_id =  v_rec.city_id
      and ucode = v_ucode
      and year =  v_rec.sale_yr;

      if (v_counter = 0 and
          v_parent_ucode != 3 )then
        pr_values_pkg.insert_row( X_CITY_ID         => v_rec.city_id
                              , X_UCODE           => v_ucode
                              , X_PROP_CLASS      => 'A'
                              , X_YEAR            => v_rec.sale_yr
                              , X_MIN_PRICE       => v_values('A').min_price
                              , X_MAX_PRICE       => v_values('A').max_price
                              , X_MEDIAN_PRICE    => v_values('A').median_price
                              , X_RENT            => v_values('A').rent
                              , X_VACANCY_PERCENT => v_values('A').vacancy_pct
                              , X_REPLACEMENT     => v_values('A').replacement
                              , X_MAINTENANCE     => v_values('A').maintenance
                              , X_MGT_PERCENT     => v_values('A').mgt_percent
                              , X_CAP_RATE        => v_values('A').cap_rate
                              , X_UTILITIES       => v_values('A').utilities);

        pr_values_pkg.insert_row( X_CITY_ID         => v_rec.city_id
                              , X_UCODE           => v_ucode
                              , X_PROP_CLASS      => 'B'
                              , X_YEAR            => v_rec.sale_yr
                              , X_MIN_PRICE       => v_values('B').min_price
                              , X_MAX_PRICE       => v_values('B').max_price
                              , X_MEDIAN_PRICE    => v_values('B').median_price
                              , X_RENT            => v_values('B').rent
                              , X_VACANCY_PERCENT => v_values('B').vacancy_pct
                              , X_REPLACEMENT     => v_values('B').replacement
                              , X_MAINTENANCE     => v_values('B').maintenance
                              , X_MGT_PERCENT     => v_values('B').mgt_percent
                              , X_CAP_RATE        => v_values('B').cap_rate
                              , X_UTILITIES       => v_values('B').utilities);

        pr_values_pkg.insert_row( X_CITY_ID         => v_rec.city_id
                              , X_UCODE           => v_ucode
                              , X_PROP_CLASS      => 'C'
                              , X_YEAR            => v_rec.sale_yr
                              , X_MIN_PRICE       => v_values('C').min_price
                              , X_MAX_PRICE       => v_values('C').max_price
                              , X_MEDIAN_PRICE    => v_values('C').median_price
                              , X_RENT            => v_values('C').rent
                              , X_VACANCY_PERCENT => v_values('C').vacancy_pct
                              , X_REPLACEMENT     => v_values('C').replacement
                              , X_MAINTENANCE     => v_values('C').maintenance
                              , X_MGT_PERCENT     => v_values('C').mgt_percent
                              , X_CAP_RATE        => v_values('C').cap_rate
                              , X_UTILITIES       => v_values('C').utilities);
      elsif v_counter > 0 then
        pr_values_pkg.update_row( X_CITY_ID         => v_rec.city_id
                              , X_UCODE           => v_ucode
                              , X_PROP_CLASS      => 'A'
                              , X_YEAR            => v_rec.sale_yr
                              , X_MIN_PRICE       => v_values('A').min_price
                              , X_MAX_PRICE       => v_values('A').max_price
                              , X_MEDIAN_PRICE    => v_values('A').median_price
                              , X_RENT            => v_values('A').rent
                              , X_VACANCY_PERCENT => v_values('A').vacancy_pct
                              , X_REPLACEMENT     => v_values('A').replacement
                              , X_MAINTENANCE     => v_values('A').maintenance
                              , X_MGT_PERCENT     => v_values('A').mgt_percent
                              , X_CAP_RATE        => v_values('A').cap_rate
                              , X_UTILITIES       => v_values('A').utilities
                              , X_CHECKSUM        => pr_values_pkg.get_checksum( v_rec.city_id, v_ucode, 'A', v_rec.sale_yr));

        pr_values_pkg.update_row( X_CITY_ID         => v_rec.city_id
                              , X_UCODE           => v_ucode
                              , X_PROP_CLASS      => 'B'
                              , X_YEAR            => v_rec.sale_yr
                              , X_MIN_PRICE       => v_values('B').min_price
                              , X_MAX_PRICE       => v_values('B').max_price
                              , X_MEDIAN_PRICE    => v_values('B').median_price
                              , X_RENT            => v_values('B').rent
                              , X_VACANCY_PERCENT => v_values('B').vacancy_pct
                              , X_REPLACEMENT     => v_values('B').replacement
                              , X_MAINTENANCE     => v_values('B').maintenance
                              , X_MGT_PERCENT     => v_values('B').mgt_percent
                              , X_CAP_RATE        => v_values('B').cap_rate
                              , X_UTILITIES       => v_values('B').utilities
                              , X_CHECKSUM        => pr_values_pkg.get_checksum( v_rec.city_id, v_ucode, 'B', v_rec.sale_yr));

        pr_values_pkg.update_row( X_CITY_ID         => v_rec.city_id
                              , X_UCODE           => v_ucode
                              , X_PROP_CLASS      => 'C'
                              , X_YEAR            => v_rec.sale_yr
                              , X_MIN_PRICE       => v_values('C').min_price
                              , X_MAX_PRICE       => v_values('C').max_price
                              , X_MEDIAN_PRICE    => v_values('C').median_price
                              , X_RENT            => v_values('C').rent
                              , X_VACANCY_PERCENT => v_values('C').vacancy_pct
                              , X_REPLACEMENT     => v_values('C').replacement
                              , X_MAINTENANCE     => v_values('C').maintenance
                              , X_MGT_PERCENT     => v_values('C').mgt_percent
                              , X_CAP_RATE        => v_values('C').cap_rate
                              , X_UTILITIES       => v_values('C').utilities
                              , X_CHECKSUM        => pr_values_pkg.get_checksum( v_rec.city_id, v_ucode, 'C', v_rec.sale_yr));
      end if;
      commit;
    end loop;

    --TO DO update PR_PROPERTIES: puma_percentile, rental_percentile
    
   merge into pr_values v1
     using (select city_id, ucode, prop_class, max(year) yr
            from pr_values
            group by city_id, ucode, prop_class) v2
     on (v1.city_id = v2.city_id and
         v1.ucode = v2.ucode and
         v1.prop_class = v2.prop_class and
         v1.year = v2.yr)
     when matched then
     update set v1.current_yn = 'Y';


  end set_value_estimates;

begin

--  update_sales;
--  commit;
--  update_sequences;
--  update_properties;
--  commit;
--  update_mviews;
--  set_ucode_summary;
--   update_tax_values;
--   set_ucode_summary;
   set_value_estimates;
null;
end;
/


