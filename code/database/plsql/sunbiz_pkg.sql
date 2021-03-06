create or replace package sunbiz_pkg as
  procedure delete_duplicate_seed_data;
  procedure seed_corps;
  procedure set_inactive;
  procedure del_inactive;
  procedure seed_locations;
  procedure del_duplicates;
  procedure match_properties;
  procedure match_owners;
--  procedure update_geoloc;
  
  procedure remove_officer( p_corp  in pr_corporations.corp_number%type
                          , p_name  in pr_principals.pn_name%type
                          , p_code  in pr_corporate_positions.title_code%type := null);

  procedure remove_officer( p_corp  in pr_corporations.corp_number%type
                          , p_id    in pr_principals.pn_id%type
                          , p_code  in pr_corporate_positions.title_code%type := null);

                      
  procedure add_officer( p_CORP         IN PR_CORPORATIONS.CORP_NUMBER%TYPE
                       , p_NAME         IN PR_PRINCIPALS.PN_NAME%TYPE
                       , p_PN_TYPE      IN PR_PRINCIPALS.PN_TYPE%TYPE
	  	       , p_TITLE_CODE   IN PR_CORPORATE_POSITIONS.TITLE_CODE%TYPE
                       , p_ADDRESS1     IN PR_LOCATIONS.ADDRESS1%TYPE
                       , p_ADDRESS2     IN PR_LOCATIONS.ADDRESS2%TYPE
                       , p_CITY         IN PR_LOCATIONS.CITY%TYPE
                       , p_STATE        IN PR_LOCATIONS.STATE%TYPE
                       , p_ZIPCODE      IN   varchar2
                       , p_ZIP4         IN   varchar2
                       , p_COUNTRY      IN PR_LOCATIONS.COUNTRY%TYPE := 'US'
                       , p_geo_location in PR_LOCATIONS.GEO_LOCATION%TYPE := null
                       , p_geo_found_yn in PR_LOCATIONS.GEO_FOUND_YN%TYPE := 'N');
                       
                          
end sunbiz_pkg;
/

create or replace package body sunbiz_pkg as
procedure delete_duplicate_seed_data is
begin
  delete from sunbiz a
  where rowid > (select min(rowid)
                 from sunbiz b
                 where b.cor_number = a.cor_number);
end delete_duplicate_seed_data;

procedure seed_corps is
/*
  cursor cur_corps is
  select cor_number
  ,      cor_name
  ,      cor_status
  ,      cor_filing_type
  ,      cor_file_date
  ,      cor_fei_number
  from sunbiz
  where not exists
   (select 1
    from pr_corporations
        where corp_number = cor_number);
  c_number      varchar2(20);
*/
begin
  merge into pr_corporations pc using (
    select cor_number
  ,      cor_name
  ,      cor_status
  ,      cor_filing_type
  ,      cor_file_date
  ,      cor_fei_number
  from sunbiz
  WHERE substr(cor_file_date, 1, 2)  in ('01','02','03','04','05','06','07','08','09','10','11','12')
  and cor_name is not null
   ) s on
  (s.cor_number = pc.corp_number)
  WHEN NOT MATCHED THEN INSERT ( corp_number
     , name
     , status
     , filing_type
     , filing_date
     , fei_number)
  VALUES ( s.cor_number
         , s.cor_name
         , s.cor_status
         , s.cor_filing_type
         , to_date(s.cor_file_date, 'MMDDYYYY')
         , s.cor_fei_number);

end seed_corps;

  procedure set_inactive is
    cursor cur_inactive is
    select corp_number
    from pr_corporations
    where not exists
    (select 1 from sunbiz
     where corp_number = cor_number);
  begin
  update pr_corporations
  set status = 'I'
  where not exists
    (select 1 from sunbiz
     where corp_number = cor_number);
  commit;

  end set_inactive;

  procedure del_inactive is
    TYPE t_pr_tab IS TABLE OF pr_corporations.corp_number%TYPE;
    l_pr_num_list t_pr_tab;
    cursor cur_inactive is
        select corp_number
        from pr_corporations
        where status = 'I';
  begin
    delete from pr_corporations
        where status = 'I'
    returning corp_number BULK COLLECT INTO l_pr_num_list;
    forall  i in l_pr_num_list.first.. l_pr_num_list.last
          delete from pr_corporate_positions
          where corp_number = l_pr_num_list(i);

    forall  i in l_pr_num_list.first.. l_pr_num_list.last
          delete from pr_corporate_locations
          where corp_number = l_pr_num_list(i);

    commit;

  end del_inactive;

procedure seed_locations is

begin
  insert ALL
        INTO pr_principals_tmp(CORP_NUMBER, PN_TYPE, PN_NAME, TITLE_CODE)
        VALUES (COR_NUMBER, RA_NAME_TYPE, RA_NAME, 'R')
        INTO pr_principals_tmp(CORP_NUMBER, PN_TYPE, PN_NAME, TITLE_CODE)
        VALUES (COR_NUMBER, PRINC1_NAME_TYPE, PRINC1_NAME, PRINC1_TITLE)
        INTO pr_principals_tmp(CORP_NUMBER, PN_TYPE, PN_NAME, TITLE_CODE)
        VALUES (COR_NUMBER, PRINC2_NAME_TYPE, PRINC2_NAME, PRINC2_TITLE)
        INTO pr_principals_tmp(CORP_NUMBER, PN_TYPE, PN_NAME, TITLE_CODE)
        VALUES (COR_NUMBER, PRINC3_NAME_TYPE, PRINC3_NAME, PRINC3_TITLE)
        INTO pr_principals_tmp(CORP_NUMBER, PN_TYPE, PN_NAME, TITLE_CODE)
        VALUES (COR_NUMBER, PRINC4_NAME_TYPE, PRINC4_NAME, PRINC4_TITLE)
        INTO pr_principals_tmp(CORP_NUMBER, PN_TYPE, PN_NAME, TITLE_CODE)
        VALUES (COR_NUMBER, PRINC5_NAME_TYPE, PRINC5_NAME, PRINC5_TITLE)
        INTO pr_principals_tmp(CORP_NUMBER, PN_TYPE, PN_NAME, TITLE_CODE)
        VALUES (COR_NUMBER, PRINC6_NAME_TYPE, PRINC6_NAME, PRINC6_TITLE)
    INTO pr_locations_tmp(CORP_NUMBER, ADDRESS1, ADDRESS2, CITY, STATE, ZIPCODE, ZIP4, COUNTRY, LOC_TYPE)
        VALUES(COR_NUMBER, COR_PRINC_ADD_1,COR_PRINC_ADD_2,COR_PRINC_CITY,COR_PRINC_STATE,BCOR_PRINC_ZIP5,
                BCOR_PRINC_ZIP4, COR_PRINC_COUNTRY, 'PRIN')
    INTO pr_locations_tmp(CORP_NUMBER, ADDRESS1, ADDRESS2, CITY, STATE, ZIPCODE, ZIP4, COUNTRY, LOC_TYPE)
        VALUES(COR_NUMBER, COR_MAIL_ADD_1,COR_MAIL_ADD_2,COR_MAIL_CITY,COR_MAIL_STATE,COR_MAIL_ZIP5,
                COR_MAIL_ZIP4, COR_MAIL_COUNTRY, 'MAIL')
    INTO pr_locations_tmp(CORP_NUMBER, ADDRESS1, ADDRESS2, CITY, STATE, ZIPCODE, ZIP4, COUNTRY, PN_TYPE, PN_NAME)
        VALUES(COR_NUMBER, RA_ADD_1,'',RA_CITY,RA_STATE,RA_ZIP5,RA_ZIP4, 'US', RA_NAME_TYPE, RA_NAME)
    INTO pr_locations_tmp(CORP_NUMBER, ADDRESS1, ADDRESS2, CITY, STATE, ZIPCODE, ZIP4, COUNTRY, PN_TYPE, PN_NAME)
        VALUES(COR_NUMBER, PRINC1_ADD_1,'',PRINC1_CITY,PRINC1_STATE,PRINC1_ZIP5,PRINC1_ZIP4, 'US', PRINC1_NAME_TYPE, PRINC1_NAME)
    INTO pr_locations_tmp(CORP_NUMBER, ADDRESS1, ADDRESS2, CITY, STATE, ZIPCODE, ZIP4, COUNTRY, PN_TYPE, PN_NAME)
        VALUES(COR_NUMBER, PRINC2_ADD_1,'',PRINC2_CITY,PRINC2_STATE,PRINC2_ZIP5,PRINC2_ZIP4, 'US', PRINC2_NAME_TYPE, PRINC2_NAME)
    INTO pr_locations_tmp(CORP_NUMBER, ADDRESS1, ADDRESS2, CITY, STATE, ZIPCODE, ZIP4, COUNTRY, PN_TYPE, PN_NAME)
        VALUES(COR_NUMBER, PRINC3_ADD_1,'',PRINC3_CITY,PRINC3_STATE,PRINC3_ZIP5,PRINC3_ZIP4, 'US', PRINC3_NAME_TYPE, PRINC3_NAME)
    INTO pr_locations_tmp(CORP_NUMBER, ADDRESS1, ADDRESS2, CITY, STATE, ZIPCODE, ZIP4, COUNTRY, PN_TYPE, PN_NAME)
        VALUES(COR_NUMBER, PRINC4_ADD_1,'',PRINC4_CITY,PRINC4_STATE,PRINC4_ZIP5,PRINC4_ZIP4, 'US', PRINC4_NAME_TYPE, PRINC4_NAME)
    INTO pr_locations_tmp(CORP_NUMBER, ADDRESS1, ADDRESS2, CITY, STATE, ZIPCODE, ZIP4, COUNTRY, PN_TYPE, PN_NAME)
        VALUES(COR_NUMBER, PRINC5_ADD_1,'',PRINC5_CITY,PRINC5_STATE,PRINC5_ZIP5,PRINC5_ZIP4, 'US', PRINC5_NAME_TYPE, PRINC5_NAME)
    INTO pr_locations_tmp(CORP_NUMBER, ADDRESS1, ADDRESS2, CITY, STATE, ZIPCODE, ZIP4, COUNTRY, PN_TYPE, PN_NAME)
        VALUES(COR_NUMBER, PRINC6_ADD_1,'',PRINC6_CITY,PRINC6_STATE,PRINC6_ZIP5,PRINC6_ZIP4, 'US', PRINC6_NAME_TYPE, PRINC6_NAME)
 select    COR_NUMBER  ,         COR_NAME
  ,         COR_STATUS  ,         COR_FILING_TYPE
  ,         COR_PRINC_ADD_1  ,         COR_PRINC_ADD_2
  ,         COR_PRINC_CITY  ,         COR_PRINC_STATE
  ,         substr(BCOR_PRINC_ZIP, 1, 5) BCOR_PRINC_ZIP5
  ,         substr(BCOR_PRINC_ZIP, 7, 10) BCOR_PRINC_ZIP4
  ,         COR_PRINC_COUNTRY,  COR_MAIL_ADD_1, COR_MAIL_ADD_2, COR_MAIL_CITY, COR_MAIL_STATE
  ,         substr(COR_MAIL_ZIP, 1, 5) COR_MAIL_ZIP5
  ,         substr(COR_MAIL_ZIP, 7, 10) COR_MAIL_ZIP4
  ,         COR_MAIL_COUNTRY  ,         COR_FILE_DATE
  ,         COR_FEI_NUMBER  ,         MORE_THAN_SIX_OFF_FLAG
  ,         LAST_TRX_DATE  ,         STATE_COUNTRY
  ,         REPORT_YEAR_1  ,         HOUSE_FLAG_1
  ,         REPORT_DATE_1  ,         REPORT_YEAR_2
  ,         HOUSE_FLAG_2  ,         REPORT_DATE_2
  ,         REPORT_YEAR_3  ,         HOUSE_FLAG_3
  ,         REPORT_DATE_3  ,         RA_NAME
  ,         RA_NAME_TYPE  ,         RA_ADD_1
  ,         RA_CITY  ,         RA_STATE
  ,         RA_ZIP5  ,         RA_ZIP4
  ,         PRINC1_TITLE  ,         PRINC1_NAME_TYPE
  ,         PRINC1_NAME  ,         PRINC1_ADD_1
  ,         PRINC1_CITY  ,         PRINC1_STATE
  ,         PRINC1_ZIP5  ,         PRINC1_ZIP4
  ,         PRINC2_TITLE  ,         PRINC2_NAME_TYPE
  ,         PRINC2_NAME  ,         PRINC2_ADD_1
  ,         PRINC2_CITY  ,         PRINC2_STATE
  ,         PRINC2_ZIP5  ,         PRINC2_ZIP4
  ,         PRINC3_TITLE  ,         PRINC3_NAME_TYPE
  ,         PRINC3_NAME  ,         PRINC3_ADD_1
  ,         PRINC3_CITY  ,         PRINC3_STATE
  ,         PRINC3_ZIP5  ,         PRINC3_ZIP4
  ,         PRINC4_TITLE  ,         PRINC4_NAME_TYPE
  ,         PRINC4_NAME  ,         PRINC4_ADD_1
  ,         PRINC4_CITY  ,         PRINC4_STATE
  ,         PRINC4_ZIP5  ,         PRINC4_ZIP4
  ,         PRINC5_TITLE  ,         PRINC5_NAME_TYPE
  ,         PRINC5_NAME  ,         PRINC5_ADD_1
  ,         PRINC5_CITY  ,         PRINC5_STATE
  ,         PRINC5_ZIP5  ,         PRINC5_ZIP4
  ,         PRINC6_TITLE  ,         PRINC6_NAME_TYPE
  ,         PRINC6_NAME  ,         PRINC6_ADD_1
  ,         PRINC6_CITY  ,         PRINC6_STATE
  ,         PRINC6_ZIP5  ,         PRINC6_ZIP4
  from sunbiz s
  WHERE substr(cor_file_date, 1, 2)  in ('01','02','03','04','05','06','07','08','09','10','11','12');

  INSERT INTO PR_PRINCIPALS(PN_ID, PN_TYPE, PN_NAME)
   SELECT PR_PRINCIPALS_SEQ.NEXTVAL, PN_TYPE, PN_NAME  FROM (
        SELECT distinct  PN_TYPE, PN_NAME FROM PR_PRINCIPALS_TMP
        WHERE PN_TYPE IS NOT NULL AND PN_NAME IS NOT NULL
        MINUS
        SELECT  PN_TYPE, PN_NAME FROM PR_PRINCIPALS
        );

 INSERT INTO PR_LOCATIONS(LOC_ID, ADDRESS1, ADDRESS2, CITY, STATE, ZIPCODE, ZIP4, COUNTRY, geo_found_yn)
   SELECT PR_LOCATIONS_SEQ.NEXTVAL, ADDRESS1, ADDRESS2, CITY, STATE, ZIPCODE, ZIP4, COUNTRY, 'N' FROM (
     SELECT address1, address2, zipcode, max(city) as city, max(state) as state, max(zip4) as zip4, max(country) as country from (
                SELECT distinct upper(trim( both ' ' from regexp_replace(pr_records_pkg.standard_suffix(ADDRESS1), '[[:space:]]+', chr(32)))) as address1,
                        upper(trim( both ' ' from regexp_replace(ADDRESS2, '[[:space:]]+', chr(32)))) as address2,
                        upper(CITY) as city, upper(STATE) as state,
                        to_number(ZIPCODE) as zipcode, to_number(ZIP4) as zip4, upper(COUNTRY) as country
                FROM PR_LOCATIONS_TMP
                WHERE ADDRESS1 IS NOT NULL AND CITY IS NOT NULL AND STATE IS NOT NULL AND LENGTH(ZIPCODE)=5
                        AND length(translate(ZIPCODE,'A0123456789','A')) IS NULL
                        AND (length(translate(ZIP4,'A0123456789','A')) IS NULL OR ZIP4 IS NULL)
                MINUS
                SELECT  ADDRESS1, ADDRESS2, CITY, STATE, ZIPCODE, ZIP4, COUNTRY FROM PR_LOCATIONS
                ) where address1 is not null
        GROUP BY address1, address2, zipcode
        ) t
        where not exists (select null
                from pr_locations
                where address1=t.address1 and NVL(address2, ' ')=NVL(t.address2,' ') and zipcode=t.zipcode);

  UPDATE PR_PRINCIPALS_TMP prt SET PN_ID = (select PN_ID from PR_PRINCIPALS pp
        where pp.PN_TYPE=prt.PN_TYPE AND pp.PN_NAME = prt.PN_NAME);
  UPDATE PR_LOCATIONS_TMP prt SET PN_ID = (select PN_ID from PR_PRINCIPALS pp
        where pp.PN_TYPE=prt.PN_TYPE AND pp.PN_NAME = prt.PN_NAME)
  WHERE PN_TYPE IS NOT NULL AND PN_NAME IS NOT NULL;

  UPDATE PR_LOCATIONS_TMP plt SET LOC_ID = (SELECT LOC_ID FROM PR_LOCATIONS pl WHERE
        pl.address1 = upper(trim( both ' ' from regexp_replace(pr_records_pkg.standard_suffix(plt.ADDRESS1), '[[:space:]]+', chr(32)))) and
        NVL(pl.address2, ' ') = NVL(plt.address2, ' ') and
        pl.zipcode = to_number(plt.zipcode)
        )
  WHERE ADDRESS1 IS NOT NULL AND CITY IS NOT NULL AND STATE IS NOT NULL AND LENGTH(ZIPCODE)=5
                AND length(translate(ZIPCODE,'A0123456789','A')) IS NULL;

  delete from PR_CORPORATE_POSITIONS where corp_number in (select corp_number from PR_PRINCIPALS_TMP);

  INSERT INTO PR_CORPORATE_POSITIONS(CORP_NUMBER, PN_ID, TITLE_CODE)
        select CORP_NUMBER, PN_ID, max(TITLE_CODE) FROM (
        SELECT CORP_NUMBER, PN_ID, TITLE_CODE FROM PR_PRINCIPALS_TMP WHERE PN_ID IS NOT NULL
        AND TITLE_CODE IS NOT NULL AND CORP_NUMBER IS NOT NULL
        ) t
        group by CORP_NUMBER, PN_ID;

  delete from PR_CORPORATE_LOCATIONS where corp_number in (select corp_number from PR_LOCATIONS_TMP);

  INSERT INTO PR_CORPORATE_LOCATIONS(LOC_ID, CORP_NUMBER, LOC_TYPE)
    SELECT LOC_ID, CORP_NUMBER, LOC_TYPE FROM (
        SELECT LOC_ID, CORP_NUMBER, LOC_TYPE FROM PR_LOCATIONS_TMP
                WHERE LOC_ID IS NOT NULL AND LOC_TYPE IS NOT NULL
        );

  INSERT INTO PR_PRINCIPAL_LOCATIONS(LOC_ID, PN_ID)
    SELECT LOC_ID, PN_ID FROM (
        SELECT LOC_ID, PN_ID FROM PR_LOCATIONS_TMP
                WHERE LOC_ID IS NOT NULL AND PN_ID IS NOT NULL
        MINUS
        SELECT LOC_ID, PN_ID FROM PR_PRINCIPAL_LOCATIONS
        );

   COMMIT;

end seed_locations;

  procedure del_duplicates is
  cursor cur_duplicates is
  select  pr_records_pkg.standard_suffix(address1) address1
  ,       address2
  ,       zipcode
  from pr_locations p
  group by pr_records_pkg.standard_suffix(address1)
  ,       address2
  ,       zipcode
  having count(*) > 1;

  cursor cur_locs ( p_address1 in varchar2
                  , p_address2 in varchar2
                                  , p_zipcode in number) is
        select loc_id
        from pr_locations
        where pr_records_pkg.standard_suffix(address1) = p_address1
        and nvl(address2, 'x') = nvl(p_address2, 'x')
        and zipcode = p_zipcode
        order by loc_id;

  v_primary_id    number;
  v_secondary_id  number;
  v_count         pls_integer := 0;
begin
  for d_rec in cur_duplicates loop

    v_primary_id := null;
        for l_rec in cur_locs(d_rec.address1
                             , d_rec.address2
                                                 , d_rec.zipcode) loop
          if v_primary_id is null then
            v_primary_id := l_rec.loc_id;
          else
            begin
              update pr_principal_locations
                  set loc_id = v_primary_id
                  where loc_id = l_rec.loc_id;

                  update pr_corporate_locations
                  set loc_id = v_primary_id
                  where loc_id = l_rec.loc_id;
                exception
                  when DUP_VAL_ON_INDEX then null;
                  when others then raise;
                end;

                delete from pr_principal_locations
                where loc_id = l_rec.loc_id;

                delete from pr_corporate_locations
                where loc_id = l_rec.loc_id;

                delete from pr_locations
                where loc_id = l_rec.loc_id;

                v_count := v_count + 1;
                commit;
          end if;
        end loop;

  end loop;
  dbms_output.put_line('Updated '||v_count||' rows');
end del_duplicates;

procedure match_properties is

begin
  update pr_locations pl set prop_id = NVL(
        (select prop_id
        from pr_properties
        where address1 = pl.address1
        and NVL(address2, ' ') = NVL(pl.address1, ' ')
        and zipcode = to_char(nvl(pl.zipcode, 0000))
        )
                , prop_id);

end match_properties;

procedure match_owners is
  cursor cur_owners is
  select o.owner_id
  ,      c.corp_number
  from pr_owners o
  ,    pr_corporations c
  where c.name = o.owner_name;
begin
  for o_rec in cur_owners loop
   update pr_corporations
   set owner_id = o_rec.owner_id
   where corp_number = o_rec.corp_number;
  end loop;
  COMMIT;
end match_owners;
/*
  procedure update_geoloc is
    cursor cur_geo is
    select ADDRESS1
    ,      ADDRESS2
    ,      CITY
    ,      STATE
    ,      COR_NUMBER
    ,      SDO_GEOMETRY(2001, 8307,
                      SDO_POINT_TYPE ( nvl(to_number(regexp_substr(g.LONGITUDE,'^-[0-9]+.[0-9]+')),0)
                                     , to_number(g.LATITUDE)
                                     ,NULL), NULL, NULL)  geo_location
    ,     z.geo_location zip_location
    ,     z.zipcode
    from sunbiz_geo g
    ,    rnt_zipcodes z
    where to_number(regexp_substr(g.zipcode,'[0-9]+')) = z.zipcode;

    v_loc   pr_locations.loc_id%type;
  begin
    for g_rec in cur_geo loop
      begin
      select loc_id into v_loc
      from pr_corporate_locations
      where corp_number = g_rec.cor_number
      and loc_type = 'PRIN';
      if SDO_GEOM.sdo_distance
        (g_rec.zip_location, g_rec.geo_location, 0.005,'unit=KM') < 15 then
          update pr_locations
          set geo_location = g_rec.geo_location
          ,   geo_found_yn = 'Y'
          ,   address1 = g_rec.address1
          ,   address2 = g_rec.address2
          ,   city     = g_rec.city
          ,   state    = g_rec.state
          ,   zipcode  = g_rec.zipcode
          where loc_id = v_loc;
       end if;
       exception
         when others then null;

      end;
      commit;
    end loop;
  end update_geoloc;

*/
  procedure remove_officer( p_corp  in pr_corporations.corp_number%type
                          , p_id    in pr_principals.pn_id%type
                          , p_code  in pr_corporate_positions.title_code%type := null) is

  begin

    if p_code is not null then
      delete from pr_corporate_positions
      where corp_number = p_corp
      and pn_id = p_id
      and title_code = p_code;
    else
      delete from pr_corporate_positions
      where corp_number = p_corp
      and pn_id = p_id;
    end if;

  end remove_officer;



  procedure remove_officer( p_corp  in pr_corporations.corp_number%type
                          , p_name  in pr_principals.pn_name%type
                          , p_code  in pr_corporate_positions.title_code%type := null) is

    v_pn_id      pr_principals.pn_id%type;
  begin
    select p.pn_id
    into v_pn_id
    from pr_principals p
    ,    pr_corporate_positions cp
    where replace(p.pn_name, ' ', '') = replace(upper(p_name), ' ', '')
    and p.pn_id = cp.pn_id
    and cp.corp_number = p_corp;

    remove_officer(p_corp, v_pn_id, p_code);
  end remove_officer;

  procedure add_officer( p_CORP         IN PR_CORPORATIONS.CORP_NUMBER%TYPE
                       , p_NAME         IN PR_PRINCIPALS.PN_NAME%TYPE
                       , p_PN_TYPE      IN PR_PRINCIPALS.PN_TYPE%TYPE
                       , p_TITLE_CODE   IN PR_CORPORATE_POSITIONS.TITLE_CODE%TYPE
                       , p_ADDRESS1     IN PR_LOCATIONS.ADDRESS1%TYPE
                       , p_ADDRESS2     IN PR_LOCATIONS.ADDRESS2%TYPE
                       , p_CITY         IN PR_LOCATIONS.CITY%TYPE
                       , p_STATE        IN PR_LOCATIONS.STATE%TYPE
                       , p_ZIPCODE      IN   varchar2
                       , p_ZIP4         IN   varchar2
                       , p_COUNTRY      IN PR_LOCATIONS.COUNTRY%TYPE := 'US'
                       , p_geo_location in PR_LOCATIONS.GEO_LOCATION%TYPE := null
                       , p_geo_found_yn in PR_LOCATIONS.GEO_FOUND_YN%TYPE := 'N') is

  begin
     PR_LOCATIONS_PKG.insert_principal_location
                     ( X_ADDRESS1     => upper(p_ADDRESS1)
                     , X_ADDRESS2     => upper(p_ADDRESS2)
                     , X_CITY         => upper(p_CITY)
                     , X_STATE        => upper(p_STATE)
                     , X_ZIPCODE      => p_ZIPCODE
                     , X_ZIP4         => p_ZIP4
                     , X_COUNTRY      => upper(p_COUNTRY)
                     , X_PN_TYPE      => upper(p_PN_TYPE)
                     , X_PN_NAME      => replace(upper(p_NAME), ',','')
                     , X_CORP_NUMBER  => upper(p_CORP)
                     , X_TITLE_CODE   => upper(p_TITLE_CODE)
                     , x_geo_location => p_geo_location
                     , x_geo_found_yn => upper(p_geo_found_yn));
  end add_officer;

end sunbiz_pkg;
/

show errors package sunbiz_pkg
show errors package body sunbiz_pkg
