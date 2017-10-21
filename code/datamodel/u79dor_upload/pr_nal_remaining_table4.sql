create table pr_nal_remaining as
   select  co_no, parcel_id
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
    ,      own_addr1        address1
    ,      own_addr2        address2
    ,      own_city         city
    ,      cz.zipcode
    ,      alt_key
    ,      asmnt_yr
    ,      'N'              processed_yn
    ,     geom_point
    from pr_nal n
    ,    rnt_cities c
    ,    rnt_city_zipcodes cz
    ,    pr_geo g
    where own_addr1 is not null
    and n.own_city = c.name
    and c.city_id = cz.city_id
    and cz.zipcode = n.own_zipcd
    and c.state = 'FL'
    and phy_zipcd is null
    and phy_city is null
    and g.parcelno = n.parcel_id;


create index pr_nal_remaining_n1 on pr_nal_remaining (co_no, parcel_id);
create index pr_nal_remaining_n2 on pr_nal_remaining (zipcode);

