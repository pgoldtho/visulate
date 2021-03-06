set define ^
create or replace package pr_records_pkg as
/*******************************************************************************
   Copyright (c) Visulate 2009, 2012        All rights reserved worldwide
    Name:      PR_RECORDS_PKG
    Purpose:   Public record tables API's 
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        05-JUL-09   Peter Goldthorp   Initial Version
    1.1        06-May-10   Peter Goldthorp   Add find_comps function
    1.2        02-APR-11   Peter Goldthorp   Added source_pk to get_prop_id  
    1.2        12-DEC-11   Peter Goldthorp   Added source_id to get_prop_id(2) 
    1.3        25-FEB-12   Peter Goldthorp   Add test to prevent duplicates in 	insert_property_sale
                                             add bedrooms and baths to insert_property
    1.4       24-MAR-13                      NOI estimater
*******************************************************************************/
  
  function get_owner_id( x_owner_name     in pr_owners.owner_name%type
                       , x_mailing_id     in pr_properties.prop_id%type)
           return pr_owners.owner_id%type;

  function get_prop_id( x_address1        in pr_properties.address1%type
                      , x_address2        in pr_properties.address2%type
                      , x_zipcode         in pr_properties.zipcode%type
					  , x_source_id       in pr_properties.source_id%type := null
					  , x_source_pk       in pr_properties.source_pk%type := null)
           return pr_properties.prop_id%type;

  function standard_suffix( x_address1    in pr_properties.address1%type)
            return pr_properties.address1%type deterministic;
			
  function insert_source( X_SOURCE_NAME IN PR_SOURCES.SOURCE_NAME%TYPE
                       , X_SOURCE_TYPE IN PR_SOURCES.SOURCE_TYPE%TYPE
                       , X_BASE_URL IN PR_SOURCES.BASE_URL%TYPE
                       , X_PHOTO_URL IN PR_SOURCES.PHOTO_URL%TYPE
                       , X_PROPERTY_URL IN PR_SOURCES.PROPERTY_URL%TYPE
                       , X_PLATBOOK_URL IN PR_SOURCES.PLATBOOK_URL%TYPE
                       , X_TAX_URL IN PR_SOURCES.TAX_URL%TYPE
                       , X_PK_COLUMN_NAME IN PR_SOURCES.PK_COLUMN_NAME%TYPE)
             return PR_SOURCES.SOURCE_ID%TYPE;
             
  function insert_property( X_SOURCE_ID          IN PR_PROPERTIES.SOURCE_ID%TYPE
                          , X_SOURCE_PK          IN PR_PROPERTIES.SOURCE_PK%TYPE
                          , X_ADDRESS1           IN PR_PROPERTIES.ADDRESS1%TYPE
                          , X_ADDRESS2           IN PR_PROPERTIES.ADDRESS2%TYPE
                          , X_CITY               IN PR_PROPERTIES.CITY%TYPE
                          , X_STATE              IN PR_PROPERTIES.STATE%TYPE
                          , X_ZIPCODE            IN PR_PROPERTIES.ZIPCODE%TYPE
                          , X_ACREAGE            IN PR_PROPERTIES.ACREAGE%TYPE
                          , X_SQ_FT              IN PR_PROPERTIES.SQ_FT%TYPE
                          , x_geo_location       in pr_properties.geo_location%type := null
                          , x_geo_coordinates    in pr_properties.geo_coordinates%type := null
                          , x_geo_found_yn       in pr_properties.geo_found_yn%type := 'N'
                          , x_total_bedrooms     in pr_properties.total_bedrooms%type := null
                          , x_total_bathrooms    in pr_properties.total_bathrooms%type := null
                          , x_PARCEL_ID          in pr_properties.PARCEL_ID%type := null
                          , x_alt_key            in pr_properties.alt_key%type := null
                          , x_value_group        in pr_properties.value_group%type := null
                          , x_quality_code       in pr_properties.quality_code%type := null
                          , x_year_built         in pr_properties.year_built%type := null
                          , x_building_count     in pr_properties.building_count%type := null
                          , x_residential_units  in pr_properties.residential_units%type := null
                          , x_legal_desc         in pr_properties.legal_desc%type := null
                          , x_market_area        in pr_properties.market_area%type := null
                          , x_neighborhood_code  in pr_properties.neighborhood_code%type := null
                          , x_census_bk          in pr_properties.census_bk%type := null
                          ) return PR_PROPERTIES.PROP_ID%TYPE;

  procedure insert_property_links( X_PROP_ID IN PR_PROPERTY_LINKS.PROP_ID%TYPE
                                 , X_URL     IN PR_PROPERTY_LINKS.URL%TYPE
                                 , X_TITLE   IN PR_PROPERTY_LINKS.TITLE%TYPE);


  procedure insert_deed_code( X_DEED_CODE   IN PR_DEED_CODES.DEED_CODE%TYPE
                            , X_DESCRIPTION IN PR_DEED_CODES.DESCRIPTION%TYPE
                            , X_DEFINITION  IN PR_DEED_CODES.DEFINITION%TYPE);


  procedure insert_property_sale( X_PROP_ID      IN PR_PROPERTY_SALES.PROP_ID%TYPE
                                , X_NEW_OWNER_ID IN PR_PROPERTY_SALES.NEW_OWNER_ID%TYPE
                                , X_SALE_DATE    IN PR_PROPERTY_SALES.SALE_DATE%TYPE
                                , X_DEED_CODE    IN PR_PROPERTY_SALES.DEED_CODE%TYPE
                                , X_PRICE        IN PR_PROPERTY_SALES.PRICE%TYPE
                                , X_OLD_OWNER_ID IN PR_PROPERTY_SALES.OLD_OWNER_ID%TYPE := 898931
                                , X_PLAT_BOOK    IN PR_PROPERTY_SALES.PLAT_BOOK%TYPE
                                , X_PLAT_PAGE    IN PR_PROPERTY_SALES.PLAT_PAGE%TYPE);

  function insert_owner( X_OWNER_NAME IN PR_OWNERS.OWNER_NAME%TYPE
                       , X_OWNER_TYPE IN PR_OWNERS.OWNER_TYPE%TYPE)
              return PR_OWNERS.OWNER_ID%TYPE;

  procedure insert_property_owner( X_OWNER_ID   IN PR_PROPERTY_OWNERS.OWNER_ID%TYPE
                                 , X_PROP_ID    IN PR_PROPERTY_OWNERS.PROP_ID%TYPE
                                 , X_MAILING_ID IN PR_PROPERTY_OWNERS.MAILING_ID%TYPE);
								 
  procedure change_property_owner( X_OWNER_ID   IN PR_PROPERTY_OWNERS.OWNER_ID%TYPE
                                 , X_PROP_ID    IN PR_PROPERTY_OWNERS.PROP_ID%TYPE
                                 , X_MAILING_ID IN PR_PROPERTY_OWNERS.MAILING_ID%TYPE);
  
  procedure insert_taxes( X_PROP_ID     IN PR_TAXES.PROP_ID%TYPE
                        , X_TAX_YEAR    IN PR_TAXES.TAX_YEAR%TYPE
                        , X_TAX_VALUE   IN PR_TAXES.TAX_VALUE%TYPE
                        , X_TAX_AMOUNT  IN PR_TAXES.TAX_AMOUNT%TYPE);

  procedure insert_usage_code( X_UCODE        IN PR_USAGE_CODES.UCODE%TYPE
                             , X_DESCRIPTION  IN PR_USAGE_CODES.DESCRIPTION%TYPE
                             , X_PARENT_UCODE IN PR_USAGE_CODES.PARENT_UCODE%TYPE);


  procedure insert_property_usage( X_UCODE   IN PR_PROPERTY_USAGE.UCODE%TYPE
                                 , X_PROP_ID IN PR_PROPERTY_USAGE.PROP_ID%TYPE);

  procedure insert_feature_code( X_FCODE       IN PR_FEATURE_CODES.FCODE%TYPE
                               , X_DESCRIPTION IN PR_FEATURE_CODES.DESCRIPTION%TYPE
                               , X_PARENT_FCODE IN PR_FEATURE_CODES.PARENT_FCODE%TYPE);

  function insert_building( X_PROP_ID IN PR_BUILDINGS.PROP_ID%TYPE
                          , X_BUILDING_NAME IN PR_BUILDINGS.BUILDING_NAME%TYPE
                          , X_YEAR_BUILT IN PR_BUILDINGS.YEAR_BUILT%TYPE
                          , X_SQ_FT IN PR_BUILDINGS.SQ_FT%TYPE)
              return PR_BUILDINGS.BUILDING_ID%TYPE;

  procedure insert_building_usage( X_UCODE       IN PR_BUILDING_USAGE.UCODE%TYPE
                                 , X_BUILDING_ID IN PR_BUILDING_USAGE.BUILDING_ID%TYPE);

  procedure insert_building_feature( X_FCODE       IN PR_BUILDING_FEATURES.FCODE%TYPE
                                  , X_BUILDING_ID IN PR_BUILDING_FEATURES.BUILDING_ID%TYPE);

  function get_prop_id( x_source_id   in pr_properties.source_pk%type
                      , x_source      in pr_properties.source_id%type := null)
       return pr_properties.prop_id%type;

  function sqft_class(p_size in number) return varchar2 DETERMINISTIC;
  function price_class(p_price in number) return varchar2 DETERMINISTIC;
  function acre_class(p_size in number) return varchar2;
  function year_class(p_year in number) return varchar2;
  function find_comps(p_prop_id in pr_properties.prop_id%type)        
       return property_list_t;       
  function last_sold(p_prop_id in pr_properties.prop_id%type) 
     return date;
  function year_built(p_prop_id in pr_properties.prop_id%type) 
     return number;	   
  function get_year_class(p_prop_id in pr_properties.prop_id%type) return varchar2;

  function get_rent( p_base  in number
                   , p_wt    in number
                   , p_size  in number
                   , p_class in varchar2) return number;

  function get_noi_estimates(p_prop_id in pr_properties.prop_id%type)
          return pr_noi_sets PIPELINED;

  function get_property_details(p_address in varchar2, p_city in varchar2)
    return property_details_rec PIPELINED;

	 
end pr_records_pkg;
/


create or replace package body pr_records_pkg as
/*******************************************************************************
   Copyright (c) Visulate 2009        All rights reserved worldwide
    Name:      PR_RECORDS_PKG
    Purpose:   Public record tables API's 
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        05-JUL-09   Peter Goldthorp   Initial Version
*******************************************************************************/

  function get_owner_id( x_owner_name     in pr_owners.owner_name%type
                       , x_mailing_id     in pr_properties.prop_id%type)
           return pr_owners.owner_id%type  is

    cursor cur_owner( x_owner_name     in pr_owners.owner_name%type
                    , x_mailing_id     in pr_properties.prop_id%type) is
    select owner_id
    from pr_owners o
    where o.owner_name = x_owner_name
    and exists (select 1
                from pr_property_owners po
                where po.mailing_id = x_mailing_id);

    v_return        pr_owners.owner_id%type := '';
 
  begin

    for o_rec in cur_owner(x_owner_name,  x_mailing_id) loop
      v_return := o_rec.owner_id;
    end loop;

    return v_return;

  end get_owner_id;
  
  function standard_suffix( x_address1    in pr_properties.address1%type)
            return pr_properties.address1%type deterministic is
	v_suffix            varchar2(64);
	v_standard_suffix   varchar2(64);
	v_return_address     pr_properties.address1%type;
  begin
    
    v_return_address := upper(replace(x_address1, '.', ''));
	v_return_address := replace(v_return_address, ',', '');
	v_return_address := rtrim(v_return_address);
	
	if regexp_like(v_return_address, '[A-Z]+\s+[A-Z]+$') then
	  v_suffix := regexp_substr(v_return_address, '\s+[A-Z]+$');
	  v_suffix := replace(v_suffix, ' ', '');
	else -- Address string does not have a street suffix
	  return v_return_address;
	end if;
	
	if v_suffix = 'ALLEE' then v_standard_suffix := 'ALY';
    elsif v_suffix = 'ALLEY' then v_standard_suffix := 'ALY';
    elsif v_suffix = 'ALLY' then v_standard_suffix := 'ALY';
    elsif v_suffix = 'ALY' then v_standard_suffix := 'ALY';
    elsif v_suffix = 'ANEX' then v_standard_suffix := 'ANX';
    elsif v_suffix = 'ANNEX' then v_standard_suffix := 'ANX';
    elsif v_suffix = 'ANNX' then v_standard_suffix := 'ANX';
    elsif v_suffix = 'ANX' then v_standard_suffix := 'ANX';
    elsif v_suffix = 'ARC' then v_standard_suffix := 'ARC';
    elsif v_suffix = 'ARCADE' then v_standard_suffix := 'ARC';
    elsif v_suffix = 'AV' then v_standard_suffix := 'AVE';
    elsif v_suffix = 'AVE' then v_standard_suffix := 'AVE';
    elsif v_suffix = 'AVEN' then v_standard_suffix := 'AVE';
    elsif v_suffix = 'AVENU' then v_standard_suffix := 'AVE';
    elsif v_suffix = 'AVENUE' then v_standard_suffix := 'AVE';
    elsif v_suffix = 'AVN' then v_standard_suffix := 'AVE';
    elsif v_suffix = 'AVNUE' then v_standard_suffix := 'AVE';
    elsif v_suffix = 'BAYOO' then v_standard_suffix := 'BYU';
    elsif v_suffix = 'BAYOU' then v_standard_suffix := 'BYU';
    elsif v_suffix = 'BCH' then v_standard_suffix := 'BCH';
    elsif v_suffix = 'BEACH' then v_standard_suffix := 'BCH';
    elsif v_suffix = 'BEND' then v_standard_suffix := 'BND';
    elsif v_suffix = 'BND' then v_standard_suffix := 'BND';
    elsif v_suffix = 'BLF' then v_standard_suffix := 'BLF';
    elsif v_suffix = 'BLUF' then v_standard_suffix := 'BLF';
    elsif v_suffix = 'BLUFF' then v_standard_suffix := 'BLF';
    elsif v_suffix = 'BLUFFS' then v_standard_suffix := 'BLFS';
    elsif v_suffix = 'BOT' then v_standard_suffix := 'BTM';
    elsif v_suffix = 'BOTTM' then v_standard_suffix := 'BTM';
    elsif v_suffix = 'BOTTOM' then v_standard_suffix := 'BTM';
    elsif v_suffix = 'BTM' then v_standard_suffix := 'BTM';
    elsif v_suffix = 'BLVD' then v_standard_suffix := 'BLVD';
    elsif v_suffix = 'BOUL' then v_standard_suffix := 'BLVD';
    elsif v_suffix = 'BOULEVARD' then v_standard_suffix := 'BLVD';
    elsif v_suffix = 'BOULV' then v_standard_suffix := 'BLVD';
    elsif v_suffix = 'BR' then v_standard_suffix := 'BR';
    elsif v_suffix = 'BRANCH' then v_standard_suffix := 'BR';
    elsif v_suffix = 'BRNCH' then v_standard_suffix := 'BR';
    elsif v_suffix = 'BRDGE' then v_standard_suffix := 'BRG';
    elsif v_suffix = 'BRG' then v_standard_suffix := 'BRG';
    elsif v_suffix = 'BRIDGE' then v_standard_suffix := 'BRG';
    elsif v_suffix = 'BRK' then v_standard_suffix := 'BRK';
    elsif v_suffix = 'BROOK' then v_standard_suffix := 'BRK';
    elsif v_suffix = 'BROOKS' then v_standard_suffix := 'BRKS';
    elsif v_suffix = 'BURG' then v_standard_suffix := 'BG';
    elsif v_suffix = 'BURGS' then v_standard_suffix := 'BGS';
    elsif v_suffix = 'BYP' then v_standard_suffix := 'BYP';
    elsif v_suffix = 'BYPA' then v_standard_suffix := 'BYP';
    elsif v_suffix = 'BYPAS' then v_standard_suffix := 'BYP';
    elsif v_suffix = 'BYPASS' then v_standard_suffix := 'BYP';
    elsif v_suffix = 'BYPS' then v_standard_suffix := 'BYP';
    elsif v_suffix = 'CAMP' then v_standard_suffix := 'CP';
    elsif v_suffix = 'CMP' then v_standard_suffix := 'CP';
    elsif v_suffix = 'CP' then v_standard_suffix := 'CP';
    elsif v_suffix = 'CANYN' then v_standard_suffix := 'CYN';
    elsif v_suffix = 'CANYON' then v_standard_suffix := 'CYN';
    elsif v_suffix = 'CNYN' then v_standard_suffix := 'CYN';
    elsif v_suffix = 'CYN' then v_standard_suffix := 'CYN';
    elsif v_suffix = 'CAPE' then v_standard_suffix := 'CPE';
    elsif v_suffix = 'CPE' then v_standard_suffix := 'CPE';
    elsif v_suffix = 'CAUSEWAY' then v_standard_suffix := 'CSWY';
    elsif v_suffix = 'CAUSWAY' then v_standard_suffix := 'CSWY';
    elsif v_suffix = 'CSWY' then v_standard_suffix := 'CSWY';
    elsif v_suffix = 'CEN' then v_standard_suffix := 'CTR';
    elsif v_suffix = 'CENT' then v_standard_suffix := 'CTR';
    elsif v_suffix = 'CENTER' then v_standard_suffix := 'CTR';
    elsif v_suffix = 'CENTR' then v_standard_suffix := 'CTR';
    elsif v_suffix = 'CENTRE' then v_standard_suffix := 'CTR';
    elsif v_suffix = 'CNTER' then v_standard_suffix := 'CTR';
    elsif v_suffix = 'CNTR' then v_standard_suffix := 'CTR';
    elsif v_suffix = 'CTR' then v_standard_suffix := 'CTR';
    elsif v_suffix = 'CENTERS' then v_standard_suffix := 'CTRS';
    elsif v_suffix = 'CIR' then v_standard_suffix := 'CIR';
    elsif v_suffix = 'CIRC' then v_standard_suffix := 'CIR';
    elsif v_suffix = 'CIRCL' then v_standard_suffix := 'CIR';
    elsif v_suffix = 'CIRCLE' then v_standard_suffix := 'CIR';
    elsif v_suffix = 'CRCL' then v_standard_suffix := 'CIR';
    elsif v_suffix = 'CRCLE' then v_standard_suffix := 'CIR';
    elsif v_suffix = 'CIRCLES' then v_standard_suffix := 'CIRS';
    elsif v_suffix = 'CLF' then v_standard_suffix := 'CLF';
    elsif v_suffix = 'CLIFF' then v_standard_suffix := 'CLF';
    elsif v_suffix = 'CLFS' then v_standard_suffix := 'CLFS';
    elsif v_suffix = 'CLIFFS' then v_standard_suffix := 'CLFS';
    elsif v_suffix = 'CLB' then v_standard_suffix := 'CLB';
    elsif v_suffix = 'CLUB' then v_standard_suffix := 'CLB';
    elsif v_suffix = 'COMMON' then v_standard_suffix := 'CMN';
    elsif v_suffix = 'COR' then v_standard_suffix := 'COR';
    elsif v_suffix = 'CORNER' then v_standard_suffix := 'COR';
    elsif v_suffix = 'CORNERS' then v_standard_suffix := 'CORS';
    elsif v_suffix = 'CORS' then v_standard_suffix := 'CORS';
    elsif v_suffix = 'COURSE' then v_standard_suffix := 'CRSE';
    elsif v_suffix = 'CRSE' then v_standard_suffix := 'CRSE';
    elsif v_suffix = 'COURT' then v_standard_suffix := 'CT';
    elsif v_suffix = 'CRT' then v_standard_suffix := 'CT';
    elsif v_suffix = 'CT' then v_standard_suffix := 'CT';
    elsif v_suffix = 'COURTS' then v_standard_suffix := 'CTS';
    elsif v_suffix = 'CTS' then v_standard_suffix := 'CTS';
    elsif v_suffix = 'COVE' then v_standard_suffix := 'CV';
    elsif v_suffix = 'CV' then v_standard_suffix := 'CV';
    elsif v_suffix = 'COVES' then v_standard_suffix := 'CVS';
    elsif v_suffix = 'CK' then v_standard_suffix := 'CRK';
    elsif v_suffix = 'CR' then v_standard_suffix := 'CRK';
    elsif v_suffix = 'CREEK' then v_standard_suffix := 'CRK';
    elsif v_suffix = 'CRK' then v_standard_suffix := 'CRK';
    elsif v_suffix = 'CRECENT' then v_standard_suffix := 'CRES';
    elsif v_suffix = 'CRES' then v_standard_suffix := 'CRES';
    elsif v_suffix = 'CRESCENT' then v_standard_suffix := 'CRES';
    elsif v_suffix = 'CRESENT' then v_standard_suffix := 'CRES';
    elsif v_suffix = 'CRSCNT' then v_standard_suffix := 'CRES';
    elsif v_suffix = 'CRSENT' then v_standard_suffix := 'CRES';
    elsif v_suffix = 'CRSNT' then v_standard_suffix := 'CRES';
    elsif v_suffix = 'CREST' then v_standard_suffix := 'CRST';
    elsif v_suffix = 'CROSSING' then v_standard_suffix := 'XING';
    elsif v_suffix = 'CRSSING' then v_standard_suffix := 'XING';
    elsif v_suffix = 'CRSSNG' then v_standard_suffix := 'XING';
    elsif v_suffix = 'XING' then v_standard_suffix := 'XING';
    elsif v_suffix = 'CROSSROAD' then v_standard_suffix := 'XRD';
    elsif v_suffix = 'CURVE' then v_standard_suffix := 'CURV';
    elsif v_suffix = 'DALE' then v_standard_suffix := 'DL';
    elsif v_suffix = 'DL' then v_standard_suffix := 'DL';
    elsif v_suffix = 'DAM' then v_standard_suffix := 'DM';
    elsif v_suffix = 'DM' then v_standard_suffix := 'DM';
    elsif v_suffix = 'DIV' then v_standard_suffix := 'DV';
    elsif v_suffix = 'DIVIDE' then v_standard_suffix := 'DV';
    elsif v_suffix = 'DV' then v_standard_suffix := 'DV';
    elsif v_suffix = 'DVD' then v_standard_suffix := 'DV';
    elsif v_suffix = 'DR' then v_standard_suffix := 'DR';
    elsif v_suffix = 'DRIV' then v_standard_suffix := 'DR';
    elsif v_suffix = 'DRIVE' then v_standard_suffix := 'DR';
    elsif v_suffix = 'DRV' then v_standard_suffix := 'DR';
    elsif v_suffix = 'DRIVES' then v_standard_suffix := 'DRS';
    elsif v_suffix = 'EST' then v_standard_suffix := 'EST';
    elsif v_suffix = 'ESTATE' then v_standard_suffix := 'EST';
    elsif v_suffix = 'ESTATES' then v_standard_suffix := 'ESTS';
    elsif v_suffix = 'ESTS' then v_standard_suffix := 'ESTS';
    elsif v_suffix = 'EXP' then v_standard_suffix := 'EXPY';
    elsif v_suffix = 'EXPR' then v_standard_suffix := 'EXPY';
    elsif v_suffix = 'EXPRESS' then v_standard_suffix := 'EXPY';
    elsif v_suffix = 'EXPRESSWAY' then v_standard_suffix := 'EXPY';
    elsif v_suffix = 'EXPW' then v_standard_suffix := 'EXPY';
    elsif v_suffix = 'EXPY' then v_standard_suffix := 'EXPY';
    elsif v_suffix = 'EXT' then v_standard_suffix := 'EXT';
    elsif v_suffix = 'EXTENSION' then v_standard_suffix := 'EXT';
    elsif v_suffix = 'EXTN' then v_standard_suffix := 'EXT';
    elsif v_suffix = 'EXTNSN' then v_standard_suffix := 'EXT';
    elsif v_suffix = 'EXTENSIONS' then v_standard_suffix := 'EXTS';
    elsif v_suffix = 'EXTS' then v_standard_suffix := 'EXTS';
    elsif v_suffix = 'FALL' then v_standard_suffix := 'FALL';
    elsif v_suffix = 'FALLS' then v_standard_suffix := 'FLS';
    elsif v_suffix = 'FLS' then v_standard_suffix := 'FLS';
    elsif v_suffix = 'FERRY' then v_standard_suffix := 'FRY';
    elsif v_suffix = 'FRRY' then v_standard_suffix := 'FRY';
    elsif v_suffix = 'FRY' then v_standard_suffix := 'FRY';
    elsif v_suffix = 'FIELD' then v_standard_suffix := 'FLD';
    elsif v_suffix = 'FLD' then v_standard_suffix := 'FLD';
    elsif v_suffix = 'FIELDS' then v_standard_suffix := 'FLDS';
    elsif v_suffix = 'FLDS' then v_standard_suffix := 'FLDS';
    elsif v_suffix = 'FLAT' then v_standard_suffix := 'FLT';
    elsif v_suffix = 'FLT' then v_standard_suffix := 'FLT';
    elsif v_suffix = 'FLATS' then v_standard_suffix := 'FLTS';
    elsif v_suffix = 'FLTS' then v_standard_suffix := 'FLTS';
    elsif v_suffix = 'FORD' then v_standard_suffix := 'FRD';
    elsif v_suffix = 'FRD' then v_standard_suffix := 'FRD';
    elsif v_suffix = 'FORDS' then v_standard_suffix := 'FRDS';
    elsif v_suffix = 'FOREST' then v_standard_suffix := 'FRST';
    elsif v_suffix = 'FORESTS' then v_standard_suffix := 'FRST';
    elsif v_suffix = 'FRST' then v_standard_suffix := 'FRST';
    elsif v_suffix = 'FORG' then v_standard_suffix := 'FRG';
    elsif v_suffix = 'FORGE' then v_standard_suffix := 'FRG';
    elsif v_suffix = 'FRG' then v_standard_suffix := 'FRG';
    elsif v_suffix = 'FORGES' then v_standard_suffix := 'FRGS';
    elsif v_suffix = 'FORK' then v_standard_suffix := 'FRK';
    elsif v_suffix = 'FRK' then v_standard_suffix := 'FRK';
    elsif v_suffix = 'FORKS' then v_standard_suffix := 'FRKS';
    elsif v_suffix = 'FRKS' then v_standard_suffix := 'FRKS';
    elsif v_suffix = 'FORT' then v_standard_suffix := 'FT';
    elsif v_suffix = 'FRT' then v_standard_suffix := 'FT';
    elsif v_suffix = 'FT' then v_standard_suffix := 'FT';
    elsif v_suffix = 'FREEWAY' then v_standard_suffix := 'FWY';
    elsif v_suffix = 'FREEWY' then v_standard_suffix := 'FWY';
    elsif v_suffix = 'FRWAY' then v_standard_suffix := 'FWY';
    elsif v_suffix = 'FRWY' then v_standard_suffix := 'FWY';
    elsif v_suffix = 'FWY' then v_standard_suffix := 'FWY';
    elsif v_suffix = 'GARDEN' then v_standard_suffix := 'GDN';
    elsif v_suffix = 'GARDN' then v_standard_suffix := 'GDN';
    elsif v_suffix = 'GDN' then v_standard_suffix := 'GDN';
    elsif v_suffix = 'GRDEN' then v_standard_suffix := 'GDN';
    elsif v_suffix = 'GRDN' then v_standard_suffix := 'GDN';
    elsif v_suffix = 'GARDENS' then v_standard_suffix := 'GDNS';
    elsif v_suffix = 'GDNS' then v_standard_suffix := 'GDNS';
    elsif v_suffix = 'GRDNS' then v_standard_suffix := 'GDNS';
    elsif v_suffix = 'GATEWAY' then v_standard_suffix := 'GTWY';
    elsif v_suffix = 'GATEWY' then v_standard_suffix := 'GTWY';
    elsif v_suffix = 'GATWAY' then v_standard_suffix := 'GTWY';
    elsif v_suffix = 'GTWAY' then v_standard_suffix := 'GTWY';
    elsif v_suffix = 'GTWY' then v_standard_suffix := 'GTWY';
    elsif v_suffix = 'GLEN' then v_standard_suffix := 'GLN';
    elsif v_suffix = 'GLN' then v_standard_suffix := 'GLN';
    elsif v_suffix = 'GLENS' then v_standard_suffix := 'GLNS';
    elsif v_suffix = 'GREEN' then v_standard_suffix := 'GRN';
    elsif v_suffix = 'GRN' then v_standard_suffix := 'GRN';
    elsif v_suffix = 'GREENS' then v_standard_suffix := 'GRNS';
    elsif v_suffix = 'GROV' then v_standard_suffix := 'GRV';
    elsif v_suffix = 'GROVE' then v_standard_suffix := 'GRV';
    elsif v_suffix = 'GRV' then v_standard_suffix := 'GRV';
    elsif v_suffix = 'GROVES' then v_standard_suffix := 'GRVS';
    elsif v_suffix = 'HARB' then v_standard_suffix := 'HBR';
    elsif v_suffix = 'HARBOR' then v_standard_suffix := 'HBR';
    elsif v_suffix = 'HARBR' then v_standard_suffix := 'HBR';
    elsif v_suffix = 'HBR' then v_standard_suffix := 'HBR';
    elsif v_suffix = 'HRBOR' then v_standard_suffix := 'HBR';
    elsif v_suffix = 'HARBORS' then v_standard_suffix := 'HBRS';
    elsif v_suffix = 'HAVEN' then v_standard_suffix := 'HVN';
    elsif v_suffix = 'HAVN' then v_standard_suffix := 'HVN';
    elsif v_suffix = 'HVN' then v_standard_suffix := 'HVN';
    elsif v_suffix = 'HEIGHT' then v_standard_suffix := 'HTS';
    elsif v_suffix = 'HEIGHTS' then v_standard_suffix := 'HTS';
    elsif v_suffix = 'HGTS' then v_standard_suffix := 'HTS';
    elsif v_suffix = 'HT' then v_standard_suffix := 'HTS';
    elsif v_suffix = 'HTS' then v_standard_suffix := 'HTS';
    elsif v_suffix = 'HIGHWAY' then v_standard_suffix := 'HWY';
    elsif v_suffix = 'HIGHWY' then v_standard_suffix := 'HWY';
    elsif v_suffix = 'HIWAY' then v_standard_suffix := 'HWY';
    elsif v_suffix = 'HIWY' then v_standard_suffix := 'HWY';
    elsif v_suffix = 'HWAY' then v_standard_suffix := 'HWY';
    elsif v_suffix = 'HWY' then v_standard_suffix := 'HWY';
    elsif v_suffix = 'HILL' then v_standard_suffix := 'HL';
    elsif v_suffix = 'HL' then v_standard_suffix := 'HL';
    elsif v_suffix = 'HILLS' then v_standard_suffix := 'HLS';
    elsif v_suffix = 'HLS' then v_standard_suffix := 'HLS';
    elsif v_suffix = 'HLLW' then v_standard_suffix := 'HOLW';
    elsif v_suffix = 'HOLLOW' then v_standard_suffix := 'HOLW';
    elsif v_suffix = 'HOLLOWS' then v_standard_suffix := 'HOLW';
    elsif v_suffix = 'HOLW' then v_standard_suffix := 'HOLW';
    elsif v_suffix = 'HOLWS' then v_standard_suffix := 'HOLW';
    elsif v_suffix = 'INLET' then v_standard_suffix := 'INLT';
    elsif v_suffix = 'INLT' then v_standard_suffix := 'INLT';
    elsif v_suffix = 'IS' then v_standard_suffix := 'IS';
    elsif v_suffix = 'ISLAND' then v_standard_suffix := 'IS';
    elsif v_suffix = 'ISLND' then v_standard_suffix := 'IS';
    elsif v_suffix = 'ISLANDS' then v_standard_suffix := 'ISS';
    elsif v_suffix = 'ISLNDS' then v_standard_suffix := 'ISS';
    elsif v_suffix = 'ISS' then v_standard_suffix := 'ISS';
    elsif v_suffix = 'ISLE' then v_standard_suffix := 'ISLE';
    elsif v_suffix = 'ISLES' then v_standard_suffix := 'ISLE';
    elsif v_suffix = 'JCT' then v_standard_suffix := 'JCT';
    elsif v_suffix = 'JCTION' then v_standard_suffix := 'JCT';
    elsif v_suffix = 'JCTN' then v_standard_suffix := 'JCT';
    elsif v_suffix = 'JUNCTION' then v_standard_suffix := 'JCT';
    elsif v_suffix = 'JUNCTN' then v_standard_suffix := 'JCT';
    elsif v_suffix = 'JUNCTON' then v_standard_suffix := 'JCT';
    elsif v_suffix = 'JCTNS' then v_standard_suffix := 'JCTS';
    elsif v_suffix = 'JCTS' then v_standard_suffix := 'JCTS';
    elsif v_suffix = 'JUNCTIONS' then v_standard_suffix := 'JCTS';
    elsif v_suffix = 'KEY' then v_standard_suffix := 'KY';
    elsif v_suffix = 'KY' then v_standard_suffix := 'KY';
    elsif v_suffix = 'KEYS' then v_standard_suffix := 'KYS';
    elsif v_suffix = 'KYS' then v_standard_suffix := 'KYS';
    elsif v_suffix = 'KNL' then v_standard_suffix := 'KNL';
    elsif v_suffix = 'KNOL' then v_standard_suffix := 'KNL';
    elsif v_suffix = 'KNOLL' then v_standard_suffix := 'KNL';
    elsif v_suffix = 'KNLS' then v_standard_suffix := 'KNLS';
    elsif v_suffix = 'KNOLLS' then v_standard_suffix := 'KNLS';
    elsif v_suffix = 'LAKE' then v_standard_suffix := 'LK';
    elsif v_suffix = 'LK' then v_standard_suffix := 'LK';
    elsif v_suffix = 'LAKES' then v_standard_suffix := 'LKS';
    elsif v_suffix = 'LKS' then v_standard_suffix := 'LKS';
    elsif v_suffix = 'LAND' then v_standard_suffix := 'LAND';
    elsif v_suffix = 'LANDING' then v_standard_suffix := 'LNDG';
    elsif v_suffix = 'LNDG' then v_standard_suffix := 'LNDG';
    elsif v_suffix = 'LNDNG' then v_standard_suffix := 'LNDG';
    elsif v_suffix = 'LA' then v_standard_suffix := 'LN';
    elsif v_suffix = 'LANE' then v_standard_suffix := 'LN';
    elsif v_suffix = 'LANES' then v_standard_suffix := 'LN';
    elsif v_suffix = 'LN' then v_standard_suffix := 'LN';
    elsif v_suffix = 'LGT' then v_standard_suffix := 'LGT';
    elsif v_suffix = 'LIGHT' then v_standard_suffix := 'LGT';
    elsif v_suffix = 'LIGHTS' then v_standard_suffix := 'LGTS';
    elsif v_suffix = 'LF' then v_standard_suffix := 'LF';
    elsif v_suffix = 'LOAF' then v_standard_suffix := 'LF';
    elsif v_suffix = 'LCK' then v_standard_suffix := 'LCK';
    elsif v_suffix = 'LOCK' then v_standard_suffix := 'LCK';
    elsif v_suffix = 'LCKS' then v_standard_suffix := 'LCKS';
    elsif v_suffix = 'LOCKS' then v_standard_suffix := 'LCKS';
    elsif v_suffix = 'LDG' then v_standard_suffix := 'LDG';
    elsif v_suffix = 'LDGE' then v_standard_suffix := 'LDG';
    elsif v_suffix = 'LODG' then v_standard_suffix := 'LDG';
    elsif v_suffix = 'LODGE' then v_standard_suffix := 'LDG';
    elsif v_suffix = 'LOOP' then v_standard_suffix := 'LOOP';
    elsif v_suffix = 'LOOPS' then v_standard_suffix := 'LOOP';
    elsif v_suffix = 'MALL' then v_standard_suffix := 'MALL';
    elsif v_suffix = 'MANOR' then v_standard_suffix := 'MNR';
    elsif v_suffix = 'MNR' then v_standard_suffix := 'MNR';
    elsif v_suffix = 'MANORS' then v_standard_suffix := 'MNRS';
    elsif v_suffix = 'MNRS' then v_standard_suffix := 'MNRS';
    elsif v_suffix = 'MDW' then v_standard_suffix := 'MDW';
    elsif v_suffix = 'MEADOW' then v_standard_suffix := 'MDW';
    elsif v_suffix = 'MDWS' then v_standard_suffix := 'MDWS';
    elsif v_suffix = 'MEADOWS' then v_standard_suffix := 'MDWS';
    elsif v_suffix = 'MEDOWS' then v_standard_suffix := 'MDWS';
    elsif v_suffix = 'MEWS' then v_standard_suffix := 'MEWS';
    elsif v_suffix = 'MILL' then v_standard_suffix := 'ML';
    elsif v_suffix = 'ML' then v_standard_suffix := 'ML';
    elsif v_suffix = 'MILLS' then v_standard_suffix := 'MLS';
    elsif v_suffix = 'MLS' then v_standard_suffix := 'MLS';
    elsif v_suffix = 'MISSION' then v_standard_suffix := 'MSN';
    elsif v_suffix = 'MISSN' then v_standard_suffix := 'MSN';
    elsif v_suffix = 'MSN' then v_standard_suffix := 'MSN';
    elsif v_suffix = 'MSSN' then v_standard_suffix := 'MSN';
    elsif v_suffix = 'MOTORWAY' then v_standard_suffix := 'MTWY';
    elsif v_suffix = 'MNT' then v_standard_suffix := 'MT';
    elsif v_suffix = 'MOUNT' then v_standard_suffix := 'MT';
    elsif v_suffix = 'MT' then v_standard_suffix := 'MT';
    elsif v_suffix = 'MNTAIN' then v_standard_suffix := 'MTN';
    elsif v_suffix = 'MNTN' then v_standard_suffix := 'MTN';
    elsif v_suffix = 'MOUNTAIN' then v_standard_suffix := 'MTN';
    elsif v_suffix = 'MOUNTIN' then v_standard_suffix := 'MTN';
    elsif v_suffix = 'MTIN' then v_standard_suffix := 'MTN';
    elsif v_suffix = 'MTN' then v_standard_suffix := 'MTN';
    elsif v_suffix = 'MNTNS' then v_standard_suffix := 'MTNS';
    elsif v_suffix = 'MOUNTAINS' then v_standard_suffix := 'MTNS';
    elsif v_suffix = 'NCK' then v_standard_suffix := 'NCK';
    elsif v_suffix = 'NECK' then v_standard_suffix := 'NCK';
    elsif v_suffix = 'ORCH' then v_standard_suffix := 'ORCH';
    elsif v_suffix = 'ORCHARD' then v_standard_suffix := 'ORCH';
    elsif v_suffix = 'ORCHRD' then v_standard_suffix := 'ORCH';
    elsif v_suffix = 'OVAL' then v_standard_suffix := 'OVAL';
    elsif v_suffix = 'OVL' then v_standard_suffix := 'OVAL';
    elsif v_suffix = 'OVERPASS' then v_standard_suffix := 'OPAS';
    elsif v_suffix = 'PARK' then v_standard_suffix := 'PARK';
    elsif v_suffix = 'PK' then v_standard_suffix := 'PARK';
    elsif v_suffix = 'PRK' then v_standard_suffix := 'PARK';
    elsif v_suffix = 'PARKS' then v_standard_suffix := 'PARK';
    elsif v_suffix = 'PARKWAY' then v_standard_suffix := 'PKWY';
    elsif v_suffix = 'PARKWY' then v_standard_suffix := 'PKWY';
    elsif v_suffix = 'PKWAY' then v_standard_suffix := 'PKWY';
    elsif v_suffix = 'PKWY' then v_standard_suffix := 'PKWY';
    elsif v_suffix = 'PKY' then v_standard_suffix := 'PKWY';
    elsif v_suffix = 'PARKWAYS' then v_standard_suffix := 'PKWY';
    elsif v_suffix = 'PKWYS' then v_standard_suffix := 'PKWY';
    elsif v_suffix = 'PASS' then v_standard_suffix := 'PASS';
    elsif v_suffix = 'PASSAGE' then v_standard_suffix := 'PSGE';
    elsif v_suffix = 'PATH' then v_standard_suffix := 'PATH';
    elsif v_suffix = 'PATHS' then v_standard_suffix := 'PATH';
    elsif v_suffix = 'PIKE' then v_standard_suffix := 'PIKE';
    elsif v_suffix = 'PIKES' then v_standard_suffix := 'PIKE';
    elsif v_suffix = 'PINE' then v_standard_suffix := 'PNE';
    elsif v_suffix = 'PINES' then v_standard_suffix := 'PNES';
    elsif v_suffix = 'PNES' then v_standard_suffix := 'PNES';
    elsif v_suffix = 'PL' then v_standard_suffix := 'PL';
    elsif v_suffix = 'PLACE' then v_standard_suffix := 'PL';
    elsif v_suffix = 'PLAIN' then v_standard_suffix := 'PLN';
    elsif v_suffix = 'PLN' then v_standard_suffix := 'PLN';
    elsif v_suffix = 'PLAINES' then v_standard_suffix := 'PLNS';
    elsif v_suffix = 'PLAINS' then v_standard_suffix := 'PLNS';
    elsif v_suffix = 'PLNS' then v_standard_suffix := 'PLNS';
    elsif v_suffix = 'PLAZA' then v_standard_suffix := 'PLZ';
    elsif v_suffix = 'PLZ' then v_standard_suffix := 'PLZ';
    elsif v_suffix = 'PLZA' then v_standard_suffix := 'PLZ';
    elsif v_suffix = 'POINT' then v_standard_suffix := 'PT';
    elsif v_suffix = 'PT' then v_standard_suffix := 'PT';
    elsif v_suffix = 'POINTS' then v_standard_suffix := 'PTS';
    elsif v_suffix = 'PTS' then v_standard_suffix := 'PTS';
    elsif v_suffix = 'PORT' then v_standard_suffix := 'PRT';
    elsif v_suffix = 'PRT' then v_standard_suffix := 'PRT';
    elsif v_suffix = 'PORTS' then v_standard_suffix := 'PRTS';
    elsif v_suffix = 'PRTS' then v_standard_suffix := 'PRTS';
    elsif v_suffix = 'PR' then v_standard_suffix := 'PR';
    elsif v_suffix = 'PRAIRIE' then v_standard_suffix := 'PR';
    elsif v_suffix = 'PRARIE' then v_standard_suffix := 'PR';
    elsif v_suffix = 'PRR' then v_standard_suffix := 'PR';
    elsif v_suffix = 'RAD' then v_standard_suffix := 'RADL';
    elsif v_suffix = 'RADIAL' then v_standard_suffix := 'RADL';
    elsif v_suffix = 'RADIEL' then v_standard_suffix := 'RADL';
    elsif v_suffix = 'RADL' then v_standard_suffix := 'RADL';
    elsif v_suffix = 'RAMP' then v_standard_suffix := 'RAMP';
    elsif v_suffix = 'RANCH' then v_standard_suffix := 'RNCH';
    elsif v_suffix = 'RANCHES' then v_standard_suffix := 'RNCH';
    elsif v_suffix = 'RNCH' then v_standard_suffix := 'RNCH';
    elsif v_suffix = 'RNCHS' then v_standard_suffix := 'RNCH';
    elsif v_suffix = 'RAPID' then v_standard_suffix := 'RPD';
    elsif v_suffix = 'RPD' then v_standard_suffix := 'RPD';
    elsif v_suffix = 'RAPIDS' then v_standard_suffix := 'RPDS';
    elsif v_suffix = 'RPDS' then v_standard_suffix := 'RPDS';
    elsif v_suffix = 'REST' then v_standard_suffix := 'RST';
    elsif v_suffix = 'RST' then v_standard_suffix := 'RST';
    elsif v_suffix = 'RDG' then v_standard_suffix := 'RDG';
    elsif v_suffix = 'RDGE' then v_standard_suffix := 'RDG';
    elsif v_suffix = 'RIDGE' then v_standard_suffix := 'RDG';
    elsif v_suffix = 'RDGS' then v_standard_suffix := 'RDGS';
    elsif v_suffix = 'RIDGES' then v_standard_suffix := 'RDGS';
    elsif v_suffix = 'RIV' then v_standard_suffix := 'RIV';
    elsif v_suffix = 'RIVER' then v_standard_suffix := 'RIV';
    elsif v_suffix = 'RIVR' then v_standard_suffix := 'RIV';
    elsif v_suffix = 'RVR' then v_standard_suffix := 'RIV';
    elsif v_suffix = 'RD' then v_standard_suffix := 'RD';
    elsif v_suffix = 'ROAD' then v_standard_suffix := 'RD';
    elsif v_suffix = 'RDS' then v_standard_suffix := 'RDS';
    elsif v_suffix = 'ROADS' then v_standard_suffix := 'RDS';
    elsif v_suffix = 'ROUTE' then v_standard_suffix := 'RTE';
    elsif v_suffix = 'ROW' then v_standard_suffix := 'ROW';
    elsif v_suffix = 'RUE' then v_standard_suffix := 'RUE';
    elsif v_suffix = 'RUN' then v_standard_suffix := 'RUN';
    elsif v_suffix = 'SHL' then v_standard_suffix := 'SHL';
    elsif v_suffix = 'SHOAL' then v_standard_suffix := 'SHL';
    elsif v_suffix = 'SHLS' then v_standard_suffix := 'SHLS';
    elsif v_suffix = 'SHOALS' then v_standard_suffix := 'SHLS';
    elsif v_suffix = 'SHOAR' then v_standard_suffix := 'SHR';
    elsif v_suffix = 'SHORE' then v_standard_suffix := 'SHR';
    elsif v_suffix = 'SHR' then v_standard_suffix := 'SHR';
    elsif v_suffix = 'SHOARS' then v_standard_suffix := 'SHRS';
    elsif v_suffix = 'SHORES' then v_standard_suffix := 'SHRS';
    elsif v_suffix = 'SHRS' then v_standard_suffix := 'SHRS';
    elsif v_suffix = 'SKYWAY' then v_standard_suffix := 'SKWY';
    elsif v_suffix = 'SPG' then v_standard_suffix := 'SPG';
    elsif v_suffix = 'SPNG' then v_standard_suffix := 'SPG';
    elsif v_suffix = 'SPRING' then v_standard_suffix := 'SPG';
    elsif v_suffix = 'SPRNG' then v_standard_suffix := 'SPG';
    elsif v_suffix = 'SPGS' then v_standard_suffix := 'SPGS';
    elsif v_suffix = 'SPNGS' then v_standard_suffix := 'SPGS';
    elsif v_suffix = 'SPRINGS' then v_standard_suffix := 'SPGS';
    elsif v_suffix = 'SPRNGS' then v_standard_suffix := 'SPGS';
    elsif v_suffix = 'SPUR' then v_standard_suffix := 'SPUR';
    elsif v_suffix = 'SPURS' then v_standard_suffix := 'SPUR';
    elsif v_suffix = 'SQ' then v_standard_suffix := 'SQ';
    elsif v_suffix = 'SQR' then v_standard_suffix := 'SQ';
    elsif v_suffix = 'SQRE' then v_standard_suffix := 'SQ';
    elsif v_suffix = 'SQU' then v_standard_suffix := 'SQ';
    elsif v_suffix = 'SQUARE' then v_standard_suffix := 'SQ';
    elsif v_suffix = 'SQRS' then v_standard_suffix := 'SQS';
    elsif v_suffix = 'SQUARES' then v_standard_suffix := 'SQS';
    elsif v_suffix = 'STA' then v_standard_suffix := 'STA';
    elsif v_suffix = 'STATION' then v_standard_suffix := 'STA';
    elsif v_suffix = 'STATN' then v_standard_suffix := 'STA';
    elsif v_suffix = 'STN' then v_standard_suffix := 'STA';
    elsif v_suffix = 'STRA' then v_standard_suffix := 'STRA';
    elsif v_suffix = 'STRAV' then v_standard_suffix := 'STRA';
    elsif v_suffix = 'STRAVE' then v_standard_suffix := 'STRA';
    elsif v_suffix = 'STRAVEN' then v_standard_suffix := 'STRA';
    elsif v_suffix = 'STRAVENUE' then v_standard_suffix := 'STRA';
    elsif v_suffix = 'STRAVN' then v_standard_suffix := 'STRA';
    elsif v_suffix = 'STRVN' then v_standard_suffix := 'STRA';
    elsif v_suffix = 'STRVNUE' then v_standard_suffix := 'STRA';
    elsif v_suffix = 'STREAM' then v_standard_suffix := 'STRM';
    elsif v_suffix = 'STREME' then v_standard_suffix := 'STRM';
    elsif v_suffix = 'STRM' then v_standard_suffix := 'STRM';
    elsif v_suffix = 'ST' then v_standard_suffix := 'ST';
    elsif v_suffix = 'STR' then v_standard_suffix := 'ST';
    elsif v_suffix = 'STREET' then v_standard_suffix := 'ST';
    elsif v_suffix = 'STRT' then v_standard_suffix := 'ST';
    elsif v_suffix = 'STREETS' then v_standard_suffix := 'STS';
    elsif v_suffix = 'SMT' then v_standard_suffix := 'SMT';
    elsif v_suffix = 'SUMIT' then v_standard_suffix := 'SMT';
    elsif v_suffix = 'SUMITT' then v_standard_suffix := 'SMT';
    elsif v_suffix = 'SUMMIT' then v_standard_suffix := 'SMT';
    elsif v_suffix = 'TER' then v_standard_suffix := 'TER';
    elsif v_suffix = 'TERR' then v_standard_suffix := 'TER';
    elsif v_suffix = 'TERRACE' then v_standard_suffix := 'TER';
    elsif v_suffix = 'THROUGHWAY' then v_standard_suffix := 'TRWY';
    elsif v_suffix = 'TRACE' then v_standard_suffix := 'TRCE';
    elsif v_suffix = 'TRACES' then v_standard_suffix := 'TRCE';
    elsif v_suffix = 'TRCE' then v_standard_suffix := 'TRCE';
    elsif v_suffix = 'TRACK' then v_standard_suffix := 'TRAK';
    elsif v_suffix = 'TRACKS' then v_standard_suffix := 'TRAK';
    elsif v_suffix = 'TRAK' then v_standard_suffix := 'TRAK';
    elsif v_suffix = 'TRK' then v_standard_suffix := 'TRAK';
    elsif v_suffix = 'TRKS' then v_standard_suffix := 'TRAK';
    elsif v_suffix = 'TRAFFICWAY' then v_standard_suffix := 'TRFY';
    elsif v_suffix = 'TRFY' then v_standard_suffix := 'TRFY';
    elsif v_suffix = 'TR' then v_standard_suffix := 'TRL';
    elsif v_suffix = 'TRAIL' then v_standard_suffix := 'TRL';
    elsif v_suffix = 'TRAILS' then v_standard_suffix := 'TRL';
    elsif v_suffix = 'TRL' then v_standard_suffix := 'TRL';
    elsif v_suffix = 'TRLS' then v_standard_suffix := 'TRL';
    elsif v_suffix = 'TUNEL' then v_standard_suffix := 'TUNL';
    elsif v_suffix = 'TUNL' then v_standard_suffix := 'TUNL';
    elsif v_suffix = 'TUNLS' then v_standard_suffix := 'TUNL';
    elsif v_suffix = 'TUNNEL' then v_standard_suffix := 'TUNL';
    elsif v_suffix = 'TUNNELS' then v_standard_suffix := 'TUNL';
    elsif v_suffix = 'TUNNL' then v_standard_suffix := 'TUNL';
    elsif v_suffix = 'TPK' then v_standard_suffix := 'TPKE';
    elsif v_suffix = 'TPKE' then v_standard_suffix := 'TPKE';
    elsif v_suffix = 'TRNPK' then v_standard_suffix := 'TPKE';
    elsif v_suffix = 'TRPK' then v_standard_suffix := 'TPKE';
    elsif v_suffix = 'TURNPIKE' then v_standard_suffix := 'TPKE';
    elsif v_suffix = 'TURNPK' then v_standard_suffix := 'TPKE';
    elsif v_suffix = 'UNDERPASS' then v_standard_suffix := 'UPAS';
    elsif v_suffix = 'UN' then v_standard_suffix := 'UN';
    elsif v_suffix = 'UNION' then v_standard_suffix := 'UN';
    elsif v_suffix = 'UNIONS' then v_standard_suffix := 'UNS';
    elsif v_suffix = 'VALLEY' then v_standard_suffix := 'VLY';
    elsif v_suffix = 'VALLY' then v_standard_suffix := 'VLY';
    elsif v_suffix = 'VLLY' then v_standard_suffix := 'VLY';
    elsif v_suffix = 'VLY' then v_standard_suffix := 'VLY';
    elsif v_suffix = 'VALLEYS' then v_standard_suffix := 'VLYS';
    elsif v_suffix = 'VLYS' then v_standard_suffix := 'VLYS';
    elsif v_suffix = 'VDCT' then v_standard_suffix := 'VIA';
    elsif v_suffix = 'VIA' then v_standard_suffix := 'VIA';
    elsif v_suffix = 'VIADCT' then v_standard_suffix := 'VIA';
    elsif v_suffix = 'VIADUCT' then v_standard_suffix := 'VIA';
    elsif v_suffix = 'VIEW' then v_standard_suffix := 'VW';
    elsif v_suffix = 'VW' then v_standard_suffix := 'VW';
    elsif v_suffix = 'VIEWS' then v_standard_suffix := 'VWS';
    elsif v_suffix = 'VWS' then v_standard_suffix := 'VWS';
    elsif v_suffix = 'VILL' then v_standard_suffix := 'VLG';
    elsif v_suffix = 'VILLAG' then v_standard_suffix := 'VLG';
    elsif v_suffix = 'VILLAGE' then v_standard_suffix := 'VLG';
    elsif v_suffix = 'VILLG' then v_standard_suffix := 'VLG';
    elsif v_suffix = 'VILLIAGE' then v_standard_suffix := 'VLG';
    elsif v_suffix = 'VLG' then v_standard_suffix := 'VLG';
    elsif v_suffix = 'VILLAGES' then v_standard_suffix := 'VLGS';
    elsif v_suffix = 'VLGS' then v_standard_suffix := 'VLGS';
    elsif v_suffix = 'VILLE' then v_standard_suffix := 'VL';
    elsif v_suffix = 'VL' then v_standard_suffix := 'VL';
    elsif v_suffix = 'VIS' then v_standard_suffix := 'VIS';
    elsif v_suffix = 'VIST' then v_standard_suffix := 'VIS';
    elsif v_suffix = 'VISTA' then v_standard_suffix := 'VIS';
    elsif v_suffix = 'VST' then v_standard_suffix := 'VIS';
    elsif v_suffix = 'VSTA' then v_standard_suffix := 'VIS';
    elsif v_suffix = 'WALK' then v_standard_suffix := 'WALK';
    elsif v_suffix = 'WALKS' then v_standard_suffix := 'WALK';
    elsif v_suffix = 'WALL' then v_standard_suffix := 'WALL';
    elsif v_suffix = 'WAY' then v_standard_suffix := 'WAY';
    elsif v_suffix = 'WY' then v_standard_suffix := 'WAY';
    elsif v_suffix = 'WAYS' then v_standard_suffix := 'WAYS';
    elsif v_suffix = 'WELL' then v_standard_suffix := 'WL';
    elsif v_suffix = 'WELLS' then v_standard_suffix := 'WLS';
    elsif v_suffix = 'WLS' then v_standard_suffix := 'WLS';
	else v_standard_suffix := v_suffix;
	end if;
	
	
	if v_standard_suffix != v_suffix then
		v_return_address := regexp_replace
		                     ( v_return_address
							 , v_suffix||'$'
							 , v_standard_suffix);
	end if;
    return v_return_address;
  end standard_suffix;


  function get_prop_id( x_address1        in pr_properties.address1%type
                      , x_address2        in pr_properties.address2%type
                      , x_zipcode         in pr_properties.zipcode%type
                      , x_source_id       in pr_properties.source_id%type := null
                      , x_source_pk       in pr_properties.source_pk%type := null)
           return pr_properties.prop_id%type is

    cursor cur_prop( x_address1        in pr_properties.address1%type
                   , x_address2        in pr_properties.address2%type
                   , x_zipcode         in pr_properties.zipcode%type) is
     select prop_id
     ,      source_id
     ,      source_pk
     from pr_properties
     where address1 = x_address1
     and   nvl(address2, ' ') = nvl(x_address2, ' ')
     and   (zipcode  = nvl(x_zipcode, 'XXXXX')
            or zipcode = nvl(x_zipcode, 00000));

    v_return   pr_properties.prop_id%type := '';

 begin
   for p_rec in cur_prop( standard_suffix(x_address1)
                        , x_address2
			, x_zipcode) loop
     if (x_source_id is not null and
	     x_source_pk is not null) then
		 if (p_rec.source_id = x_source_id and
		     p_rec.source_pk = x_source_pk) then
			 v_return := p_rec.prop_id;
	     end if;
	 else	 
       v_return := p_rec.prop_id;
	 end if;
   end loop;
   return v_return;
 end get_prop_id;
   



 function insert_source( X_SOURCE_NAME IN PR_SOURCES.SOURCE_NAME%TYPE
                       , X_SOURCE_TYPE IN PR_SOURCES.SOURCE_TYPE%TYPE
                       , X_BASE_URL IN PR_SOURCES.BASE_URL%TYPE
                       , X_PHOTO_URL IN PR_SOURCES.PHOTO_URL%TYPE
                       , X_PROPERTY_URL IN PR_SOURCES.PROPERTY_URL%TYPE
                       , X_PLATBOOK_URL IN PR_SOURCES.PLATBOOK_URL%TYPE
                       , X_TAX_URL IN PR_SOURCES.TAX_URL%TYPE
                       , X_PK_COLUMN_NAME IN PR_SOURCES.PK_COLUMN_NAME%TYPE)
             return PR_SOURCES.SOURCE_ID%TYPE
 is
    x          number;
 begin

    insert into PR_SOURCES
    ( SOURCE_ID
    , SOURCE_NAME
    , SOURCE_TYPE
    , BASE_URL
    , PHOTO_URL
    , PROPERTY_URL
    , PLATBOOK_URL
    , TAX_URL
    , PK_COLUMN_NAME)
    values
    ( PR_SOURCES_SEQ.NEXTVAL
    , X_SOURCE_NAME
    , X_SOURCE_TYPE
    , X_BASE_URL
    , X_PHOTO_URL
    , X_PROPERTY_URL
    , X_PLATBOOK_URL
    , X_TAX_URL
    , X_PK_COLUMN_NAME)
    returning SOURCE_ID into x;

    return x;
 end insert_source;


  function insert_property( X_SOURCE_ID          IN PR_PROPERTIES.SOURCE_ID%TYPE
                          , X_SOURCE_PK          IN PR_PROPERTIES.SOURCE_PK%TYPE
                          , X_ADDRESS1           IN PR_PROPERTIES.ADDRESS1%TYPE
                          , X_ADDRESS2           IN PR_PROPERTIES.ADDRESS2%TYPE
                          , X_CITY               IN PR_PROPERTIES.CITY%TYPE
                          , X_STATE              IN PR_PROPERTIES.STATE%TYPE
                          , X_ZIPCODE            IN PR_PROPERTIES.ZIPCODE%TYPE
                          , X_ACREAGE            IN PR_PROPERTIES.ACREAGE%TYPE
                          , X_SQ_FT              IN PR_PROPERTIES.SQ_FT%TYPE
                          , x_geo_location       in pr_properties.geo_location%type := null
                          , x_geo_coordinates    in pr_properties.geo_coordinates%type := null
                          , x_geo_found_yn       in pr_properties.geo_found_yn%type := 'N'
                          , x_total_bedrooms     in pr_properties.total_bedrooms%type := null
                          , x_total_bathrooms    in pr_properties.total_bathrooms%type := null
                          , x_PARCEL_ID          in pr_properties.PARCEL_ID%type := null
                          , x_alt_key            in pr_properties.alt_key%type := null
                          , x_value_group        in pr_properties.value_group%type := null
                          , x_quality_code       in pr_properties.quality_code%type := null
                          , x_year_built         in pr_properties.year_built%type := null
                          , x_building_count     in pr_properties.building_count%type := null
                          , x_residential_units  in pr_properties.residential_units%type := null
                          , x_legal_desc         in pr_properties.legal_desc%type := null
                          , x_market_area        in pr_properties.market_area%type := null
                          , x_neighborhood_code  in pr_properties.neighborhood_code%type := null
                          , x_census_bk          in pr_properties.census_bk%type := null
                          ) return PR_PROPERTIES.PROP_ID%TYPE
  is
     x          number;
     v_count    pls_integer;
     v_address2 pr_properties.address2%type;
  begin
  /*
     select count(*) into v_count
     from pr_properties
     where address1 = x_address1
     and zipcode = x_zipcode
     and nvl(source_pk, 99) != x_source_pk; 
    
     if v_count > 0 then
       v_count := v_count + 1;
       v_address2 := 'PARCEL '||v_count||' '||x_address2;
     else
       v_address2 := x_address2;
     end if;
*/     
     select count(*) into v_count
     from pr_properties
     where (source_pk = x_source_pk or
            source_pk = x_alt_key)
     and source_id = X_SOURCE_ID;

     
     if v_count = 0 then

   begin
       insert into PR_PROPERTIES
       ( PROP_ID
       , SOURCE_ID
       , SOURCE_PK
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
       , census_bk             
       )
       values
       ( PR_PROPERTIES_SEQ.NEXTVAL
       , X_SOURCE_ID
       , X_SOURCE_PK
       , X_ADDRESS1
       , X_ADDRESS2
       , X_CITY
       , X_STATE
       , X_ZIPCODE
       , X_ACREAGE
       , X_SQ_FT
       , x_geo_location
       , x_geo_coordinates
       , x_geo_found_yn  
       , x_total_bedrooms
       , x_total_bathrooms
       , x_PARCEL_ID
       , x_alt_key
       , x_value_group     
       , x_quality_code    
       , x_year_built      
       , x_building_count  
       , x_residential_units 
       , x_legal_desc        
       , x_market_area       
       , x_neighborhood_code 
       , x_census_bk         
       )
       returning PROP_ID into x;
     exception
       when others then x := null;
    end;

     elsif v_count = 1 then
       select prop_id into x
       from pr_properties
       where (source_pk = x_source_pk or
              source_pk = x_alt_key)
       and source_id = X_SOURCE_ID;
       
       update pr_properties set
          PARCEL_ID          = x_PARCEL_ID
        , value_group        = x_value_group
        , quality_code       = x_quality_code
        , year_built         = x_year_built
        , building_count     = x_building_count
        , residential_units  = x_residential_units
        , legal_desc         = x_legal_desc
        , market_area        = x_market_area     
        , neighborhood_code  = x_neighborhood_code
        , census_bk          = x_census_bk
        where prop_id = x;
       

/*       
       update pr_properties set
          geo_location       = x_geo_location
        , geo_coordinates    = x_geo_coordinates
        , geo_found_yn       = x_geo_found_yn
        , PARCEL_ID          = x_PARCEL_ID
        , value_group        = x_value_group
        , quality_code       = x_quality_code
        , year_built         = x_year_built
        , building_count     = x_building_count
        , residential_units  = x_residential_units
        , legal_desc         = x_legal_desc
        , market_area        = x_market_area     
        , neighborhood_code  = x_neighborhood_code
        , census_bk          = x_census_bk
        where prop_id = x;
*/        
     else
       x:= null;
     end if;

     return x;
  end insert_property;

  procedure insert_property_links( X_PROP_ID IN PR_PROPERTY_LINKS.PROP_ID%TYPE
                                 , X_URL     IN PR_PROPERTY_LINKS.URL%TYPE
                                 , X_TITLE   IN PR_PROPERTY_LINKS.TITLE%TYPE)
            
  is
  begin

     insert into PR_PROPERTY_LINKS
     ( PROP_ID
     , URL
     , TITLE)
     values
     ( X_PROP_ID
     , X_URL
     , X_TITLE);

  end insert_property_links;


  procedure insert_deed_code( X_DEED_CODE   IN PR_DEED_CODES.DEED_CODE%TYPE
                            , X_DESCRIPTION IN PR_DEED_CODES.DESCRIPTION%TYPE
                            , X_DEFINITION  IN PR_DEED_CODES.DEFINITION%TYPE)
  is
  begin

     insert into PR_DEED_CODES
     ( DEED_CODE
     , DESCRIPTION
     , DEFINITION)
     values
     ( X_DEED_CODE
     , X_DESCRIPTION
     , X_DEFINITION);

  end insert_deed_code;



  procedure insert_property_sale( X_PROP_ID      IN PR_PROPERTY_SALES.PROP_ID%TYPE
                                , X_NEW_OWNER_ID IN PR_PROPERTY_SALES.NEW_OWNER_ID%TYPE 
                                , X_SALE_DATE    IN PR_PROPERTY_SALES.SALE_DATE%TYPE
                                , X_DEED_CODE    IN PR_PROPERTY_SALES.DEED_CODE%TYPE
                                , X_PRICE        IN PR_PROPERTY_SALES.PRICE%TYPE
                                , X_OLD_OWNER_ID IN PR_PROPERTY_SALES.OLD_OWNER_ID%TYPE := 898931
                                , X_PLAT_BOOK    IN PR_PROPERTY_SALES.PLAT_BOOK%TYPE
                                , X_PLAT_PAGE    IN PR_PROPERTY_SALES.PLAT_PAGE%TYPE)
  is
    v_counter   pls_integer;
  begin
    select count(*) into v_counter
	from PR_PROPERTY_SALES
	where PROP_ID = X_PROP_ID
	and NEW_OWNER_ID = X_NEW_OWNER_ID
	and SALE_DATE = X_SALE_DATE;
	
	if v_counter = 0 then
     insert into PR_PROPERTY_SALES
     ( PROP_ID
     , NEW_OWNER_ID
     , SALE_DATE
     , DEED_CODE
     , PRICE
     , OLD_OWNER_ID
     , PLAT_BOOK
     , PLAT_PAGE)
     values
     ( X_PROP_ID
     , X_NEW_OWNER_ID
     , X_SALE_DATE
     , X_DEED_CODE
     , X_PRICE
     , X_OLD_OWNER_ID
     , X_PLAT_BOOK
     , X_PLAT_PAGE);
	end if;

  end insert_property_sale;


  function insert_owner( X_OWNER_NAME IN PR_OWNERS.OWNER_NAME%TYPE
                       , X_OWNER_TYPE IN PR_OWNERS.OWNER_TYPE%TYPE)
              return PR_OWNERS.OWNER_ID%TYPE
  is
     x          number;
     v_count    pls_integer;
  begin
     if X_OWNER_NAME is null then 
       x := 898931; -- not recorded
     else
       select count(*) into v_count
       from pr_owners
       where owner_name = X_OWNER_NAME;
     
       if v_count > 0 then
         select owner_id into x
         from pr_owners
         where owner_name = X_OWNER_NAME
         and rownum = 1;
       else
        insert into PR_OWNERS
        ( OWNER_ID
        , OWNER_NAME
        , OWNER_TYPE)
        values
        ( PR_OWNERS_SEQ.NEXTVAL
        , X_OWNER_NAME
        , X_OWNER_TYPE)
        returning OWNER_ID into x;
      end if;
     end if;

     return x;
  end insert_owner;

  procedure insert_property_owner( X_OWNER_ID   IN PR_PROPERTY_OWNERS.OWNER_ID%TYPE
                                 , X_PROP_ID    IN PR_PROPERTY_OWNERS.PROP_ID%TYPE
                                 , X_MAILING_ID IN PR_PROPERTY_OWNERS.MAILING_ID%TYPE)
  is
    v_counter  pls_integer;
  begin
  
    select count(*) into v_counter
    from PR_PROPERTY_OWNERS
    where owner_id = x_OWNER_ID
    and prop_id = x_PROP_ID;

    if v_counter = 0 then
     insert into PR_PROPERTY_OWNERS
     ( OWNER_ID
     , PROP_ID
     , MAILING_ID)
     values
     ( X_OWNER_ID
     , X_PROP_ID
     , X_MAILING_ID);
   end if;

  end insert_property_owner;
  
  procedure change_property_owner( X_OWNER_ID   IN PR_PROPERTY_OWNERS.OWNER_ID%TYPE
                                 , X_PROP_ID    IN PR_PROPERTY_OWNERS.PROP_ID%TYPE
                                 , X_MAILING_ID IN PR_PROPERTY_OWNERS.MAILING_ID%TYPE)
  is
  begin
  
     delete from pr_property_owners where prop_id = X_PROP_ID;

     insert into PR_PROPERTY_OWNERS
     ( OWNER_ID
     , PROP_ID
     , MAILING_ID)
     values
     ( X_OWNER_ID
     , X_PROP_ID
     , X_MAILING_ID);

  end change_property_owner;

  procedure insert_taxes( X_PROP_ID     IN PR_TAXES.PROP_ID%TYPE
                        , X_TAX_YEAR    IN PR_TAXES.TAX_YEAR%TYPE
                        , X_TAX_VALUE   IN PR_TAXES.TAX_VALUE%TYPE
                        , X_TAX_AMOUNT  IN PR_TAXES.TAX_AMOUNT%TYPE)
  is
    v_count pls_integer;
  begin
     select count(*)
     into v_count 
     from pr_taxes 
     where prop_id = x_prop_id
     and tax_year = x_tax_year;

     if v_count = 0 then
      insert into PR_TAXES
      ( PROP_ID
      , TAX_YEAR
      , TAX_VALUE
      , TAX_AMOUNT)
      values
      ( X_PROP_ID
      , X_TAX_YEAR
      , X_TAX_VALUE
      , X_TAX_AMOUNT);
     else
      update pr_taxes
      set TAX_AMOUNT = X_TAX_AMOUNT
      where prop_id = x_prop_id
      and tax_year = x_tax_year;
     end if;

  end insert_taxes;


  procedure insert_usage_code( X_UCODE        IN PR_USAGE_CODES.UCODE%TYPE
                             , X_DESCRIPTION  IN PR_USAGE_CODES.DESCRIPTION%TYPE
                             , X_PARENT_UCODE IN PR_USAGE_CODES.PARENT_UCODE%TYPE)
  is
  begin

     insert into PR_USAGE_CODES
     ( UCODE
     , DESCRIPTION
     , PARENT_UCODE)
     values
     ( X_UCODE
     , X_DESCRIPTION
     , X_PARENT_UCODE);

  end insert_usage_code;



  procedure insert_property_usage( X_UCODE   IN PR_PROPERTY_USAGE.UCODE%TYPE
                                 , X_PROP_ID IN PR_PROPERTY_USAGE.PROP_ID%TYPE)
  is
    v_ucode  PR_PROPERTY_USAGE.UCODE%TYPE;
  begin
   begin
     select ucode
     into v_ucode
     from PR_PROPERTY_USAGE
     where prop_id = x_prop_id;
     
     if v_ucode != x_ucode then
       update PR_PROPERTY_USAGE
       set ucode = v_ucode
       where prop_id = x_prop_id;
     end if;
   exception when no_data_found then
     insert into PR_PROPERTY_USAGE
     ( UCODE
     , PROP_ID)
     values
     ( X_UCODE
     , X_PROP_ID);
   when others  then raise;
   end;
  end insert_property_usage;


  procedure insert_feature_code( X_FCODE       IN PR_FEATURE_CODES.FCODE%TYPE
                               , X_DESCRIPTION IN PR_FEATURE_CODES.DESCRIPTION%TYPE
                               , X_PARENT_FCODE IN PR_FEATURE_CODES.PARENT_FCODE%TYPE)
  is
  begin

     insert into PR_FEATURE_CODES
     ( FCODE
     , DESCRIPTION
     , PARENT_FCODE)
     values
     ( x_FCODE
     , X_DESCRIPTION
     , X_PARENT_FCODE);

  end insert_feature_code;



  function insert_building( X_PROP_ID IN PR_BUILDINGS.PROP_ID%TYPE
                          , X_BUILDING_NAME IN PR_BUILDINGS.BUILDING_NAME%TYPE
                          , X_YEAR_BUILT IN PR_BUILDINGS.YEAR_BUILT%TYPE
                          , X_SQ_FT IN PR_BUILDINGS.SQ_FT%TYPE
						  )
              return PR_BUILDINGS.BUILDING_ID%TYPE
  is
     x          number;
  begin

     insert into PR_BUILDINGS
     ( BUILDING_ID
     , PROP_ID
     , BUILDING_NAME
     , YEAR_BUILT
     , SQ_FT
	 )
     values
     ( PR_BUILDINGS_SEQ.NEXTVAL
     , X_PROP_ID
     , X_BUILDING_NAME
     , X_YEAR_BUILT
     , X_SQ_FT
	 )
     returning BUILDING_ID into x;

     return x;
  end insert_building;


  procedure insert_building_usage( X_UCODE       IN PR_BUILDING_USAGE.UCODE%TYPE
                                 , X_BUILDING_ID IN PR_BUILDING_USAGE.BUILDING_ID%TYPE)
  is
  begin

     insert into PR_BUILDING_USAGE
     ( UCODE
     , BUILDING_ID)
     values
     ( X_UCODE
     , X_BUILDING_ID);
  end insert_building_usage;



 procedure insert_building_feature( X_FCODE       IN PR_BUILDING_FEATURES.FCODE%TYPE
                                  , X_BUILDING_ID IN PR_BUILDING_FEATURES.BUILDING_ID%TYPE)
 is
 begin

    insert into PR_BUILDING_FEATURES
    ( FCODE
    , BUILDING_ID)
    values
    ( X_FCODE
    , X_BUILDING_ID);
 end insert_building_feature;

 function get_prop_id( x_source_id   in pr_properties.source_pk%type
                     , x_source      in pr_properties.source_id%type := null)
       return pr_properties.prop_id%type is

  cursor cur_prop( x_source_id   in pr_properties.source_id%type) is
    select prop_id
	,      source_id
    from  pr_properties
    where source_pk = x_source_id;

  v_prop_id       pr_properties.prop_id%type;
 begin
   for c_rec in cur_prop(x_source_id) loop
     if ((x_source is not null and
          c_rec.source_id = x_source) or
                  (x_source is null)) then
       v_prop_id := c_rec.prop_id;
     end if;
   end loop;
   return v_prop_id;
 end get_prop_id;

 
   function sqft_class(p_size in number) return varchar2 DETERMINISTIC is
    v_return   varchar2(16);
  begin
    if p_size < 1000 then v_return := 'Under 1000';
    elsif p_size < 1500  then v_return := '1000 - 1499';
    elsif p_size < 2000  then v_return := '1500 - 1999';
    elsif p_size < 2500  then v_return := '2000 - 2499';
    elsif p_size < 3000  then v_return := '2500 - 2999';
    elsif p_size < 4000  then v_return := '3000 - 3999';
    elsif p_size < 5000  then v_return := '4000 - 4999';
    elsif p_size < 6000  then v_return := '5000 - 5999';
    elsif p_size < 10000 then v_return := '6000 - 9999';
    else v_return := 'over 10000';
    end if;
    return v_return;
  end sqft_class;
  
  function price_class(p_price in number) return varchar2 DETERMINISTIC is
    v_return   varchar2(32);
  begin
    if p_price < 5 then v_return := 'Under 5';
    elsif p_price < 10  then v_return := '5 - 10';
    elsif p_price < 15  then v_return := '10 - 15';
    elsif p_price < 20  then v_return := '15 - 20';
    elsif p_price < 30  then v_return := '20 - 30';
    elsif p_price < 40  then v_return := '30 - 40';
    elsif p_price < 50  then v_return := '40 - 50';
	elsif p_price < 75  then v_return := '50 - 75';
	elsif p_price < 100 then v_return := '75 - 100';
	elsif p_price < 250 then v_return := '100 - 249';
	elsif p_price < 500 then v_return := '250 - 499';
	elsif p_price < 600 then v_return := '500 - 599';
	elsif p_price < 700 then v_return := '600 - 699';
	elsif p_price < 800 then v_return := '700 - 799';
	elsif p_price < 900 then v_return := '800 - 899';
	elsif p_price < 1000 then v_return := '900 - 999';
	elsif p_price < 1100 then v_return := '1,000 - 1,099';
	elsif p_price < 1250 then v_return := '1,100 - 1,249';
	elsif p_price < 1500 then v_return := '1,250 - 1,499';
	elsif p_price < 2000 then v_return := '1,500 - 1,999';
	elsif p_price < 2500 then v_return := '2,000 - 2,499';
	elsif p_price < 3000 then v_return := '2,500 - 2,999';
	elsif p_price < 4000 then v_return := '3,000 - 3,999';
	elsif p_price < 5000 then v_return := '4,000 - 4,999';
	elsif p_price < 10000 then v_return := '5,000 - 9,999';
	elsif p_price < 30000 then v_return := '10,000 - 29,999';
	elsif p_price < 40000 then v_return := '30,000 - 39,999';
	elsif p_price < 50000 then v_return := '40,000 - 49,999';
	elsif p_price < 75000 then v_return := '50,000 - 74,999';
	elsif p_price < 100000 then v_return := '75,000 - 99,999';
	elsif p_price < 150000 then v_return := '100,000 - 149,000';
	elsif p_price < 200000 then v_return := '150,500 - 199,999';
	elsif p_price < 250000 then v_return := '200,000 - 249,999';
	elsif p_price < 300000 then v_return := '250,000 - 299,999';
	elsif p_price < 350000 then v_return := '300,000 - 349,999';
	elsif p_price < 450000 then v_return := '350,000 - 449,999';
	elsif p_price < 650000 then v_return := '450,000 - 649,999';
	elsif p_price < 850000 then v_return := '650,000 - 849,999';
	elsif p_price < 1250000 then v_return := '850,000 - 1,249,999';
	else v_return := 'over 1,250,000';
    end if;
    return v_return;
  end price_class;  
   function acre_class(p_size in number) return varchar2 is
    v_return   varchar2(16);
  begin
    if p_size < 0.2 then v_return := 'Less than 0.2';
    elsif p_size < 0.3  then v_return := '0.2 - 0.29';
    elsif p_size < 0.5  then v_return := '0.3 - 0.49';
    elsif p_size < 1    then v_return := '0.5 - 0.99';
    elsif p_size < 2    then v_return := '1.0 - 1.99';
    elsif p_size < 4    then v_return := '2.0 - 3.99';
    elsif p_size < 8    then v_return := '4.0 - 7.99';
    elsif p_size < 16   then v_return := '8.0 - 15.99';
    elsif p_size < 32   then v_return := '16.0 - 31.99';
    else v_return := 'over 32';
    end if;
    return v_return;
  end acre_class;  
 
   function year_class(p_year in number) return varchar2 is
    v_return          varchar2(16);
    v_current_year    pls_integer := to_number(to_char(sysdate, 'yyyy'));
    v_age             pls_integer;
  begin
    v_age := v_current_year - p_year;
    if v_age < 5 then v_return := 'Under 5';
    elsif v_age < 10  then v_return := '5 - 9';
    elsif v_age < 20  then v_return := '10 - 19';
    elsif v_age < 40  then v_return := '20 - 39';
    elsif v_age < 80  then v_return := '40 - 79';
    elsif v_age < 160  then v_return := '80 - 159';
    else v_return := 'over 159';
    end if;
    return v_return;
  end year_class;
 
  function last_sold(p_prop_id in pr_properties.prop_id%type) 
     return date is
    v_return     date;

    begin
    select nvl(max(sale_date), '01-JAN-1800')
    into v_return
    from pr_property_sales
    where deed_code = 'WD'
    and prop_id = p_prop_id
	and price > 1000;
    
    return v_return;
  end last_sold;
  
   function year_built(p_prop_id in pr_properties.prop_id%type) 
     return number is
      v_return     number;

    begin
    select avg(year_built)
    into v_return
    from pr_buildings
    where prop_id = p_prop_id;
    
    return v_return;
  end year_built;
  
  function count_hits( p_sql     in varchar2
                     , p_prop_id in pr_properties.prop_id%type)
    return pls_integer is
    v_return       pls_integer;
  begin
    execute immediate p_sql
    into v_return
    using p_prop_id;
	
	return v_return;
  end count_hits;
  
  function find_comps(p_prop_id in pr_properties.prop_id%type) 
    return property_list_t is
  
    v_property_list      property_list_t;
    v_property           pr_properties%rowtype;
    v_query              varchar2(4000);
    v_sql                varchar2(4000);
    v_count              pls_integer;
  begin
    select * 
    into v_property
    from pr_properties
    where prop_id = p_prop_id;
    
    -- Find properties with the same ucode
    v_query := 
    'from pr_properties p
    ,     pr_property_usage pu
    ,     pr_properties p2
    ,     pr_property_usage pu2
    where p.prop_id  = :prop_id
    and pu.prop_id   = p.prop_id
    and pu.ucode     = pu2.ucode
    and pu2.prop_id  = p2.prop_id
	and p.prop_id != p2.prop_id';
    
    v_sql := 'select count(*) '||v_query;
	v_count := count_hits(v_sql, v_property.prop_id);

    if v_count > 20 then
    -- Find properties in the same zipcode 
      v_query := v_query ||chr(10)
      ||'and p.zipcode = p2.zipcode';
    
      v_sql := 'select count(*) '||v_query;
	  v_count := count_hits(v_sql, v_property.prop_id);    
	end if;
	
    if v_count > 20 then
      -- Find properties with the same sqft_class
      v_query := v_query ||chr(10)
      ||'and pr_records_pkg.sqft_class(p.sq_ft) = pr_records_pkg.sqft_class(p2.sq_ft)';
    
      v_sql := 'select count(*) '||v_query;
	  v_count := count_hits(v_sql, v_property.prop_id);
    end if;
   
    if v_count > 20 then
    -- Find properties with the same age_class
        v_query := v_query ||chr(10)
        ||'and pr_records_pkg.year_class(pr_records_pkg.year_built(p.prop_id)) 
	       = pr_records_pkg.year_class(pr_records_pkg.year_built(p2.prop_id))';
    
        v_sql := 'select count(*) '||v_query;
	    v_count := count_hits(v_sql, v_property.prop_id);
	end if;

    if v_count > 20 then
      -- Find properties with the same acre_class
      v_query := v_query ||chr(10)
      ||'and pr_records_pkg.acre_class(p.acreage) = pr_records_pkg.acre_class(p2.acreage)';
    
      v_sql := 'select count(*) '||v_query;
	  v_count := count_hits(v_sql, v_property.prop_id);
    end if;
	
    if v_count > 20 then
    -- show the first 20 rows
       v_query := v_query ||chr(10)
	   ||'and rownum < 21';
	end if;
	
    -- Order by sale date.
    v_query := v_query ||chr(10)
    ||'order by pr_records_pkg.last_sold(p2.prop_id) desc';

	if v_count != 0 then
      v_sql :=
      'select property_rec(p2.prop_id, initcap(p2.address1)) '||v_query;
    
      execute immediate v_sql
      bulk collect into v_property_list
      using v_property.prop_id;
	end if;
    
    return v_property_list;
    
  end find_comps;
  
  function get_year_class(p_prop_id in pr_properties.prop_id%type) 
  return varchar2 is
  begin
    return pr_records_pkg.year_class(pr_records_pkg.year_built(p_prop_id));
  end get_year_class;

  function get_rent( p_base  in number
                   , p_wt    in number
                   , p_size  in number
                   , p_class in varchar2) return number is
     v_monthly   number;
     v_rent      number;

     vc       number := 550;   -- vc to vcc     = C class  < 1,000 sq ft
     vcc      number := 750;   -- vcc to vccc   = C class    1,000 sq ft and over
     vccc     number := 850;   -- vccc to vb    = B class  < 1,200 sq ft
     vb       number := 1000;  -- vb to vbb     = B class  < 1,600 sq ft
     vbb      number := 1200;  -- vbb to vbbb   = B class  > 2,000 sq ft
     vbbb     number := 1600;  -- vbbb to va    = B class    2,000 sq ft and over
     va       number := 2225;  -- va to vaa     = A class  < 3,000 sq ft
     vaa      number := 3000;  -- vaa to vaaa   = A class    3,000 sq ft and over
     vaaa     number := 6000;  -- Max value

  begin
    
    v_monthly := round(p_base * p_wt * p_size / 12);
    if p_class = 'C' then
      if v_monthly < vc then
        v_monthly := vc;
      elsif v_monthly > vcc and p_size < 1000 then
        v_monthly := vcc;
      elsif v_monthly > vccc then
        v_monthly := vccc;
      end if;
    elsif p_class = 'A' then
      if v_monthly < va then
        v_monthly := va;
      elsif v_monthly > vaa and p_size < 3000 then
        v_monthly := vaa;
      elsif v_monthly > vaaa then
        v_monthly := vaaa;
      end if;
    else
      if v_monthly < vccc then
        v_monthly := vccc;
      elsif v_monthly > vb and p_size < 1200 then
        v_monthly := vb;
      elsif v_monthly > vbb and p_size < 1600 then
        v_monthly := vbb;
      elsif v_monthly > vbbb and p_size < 2000 then
        v_monthly := vbbb;
      elsif v_monthly > va then
        v_monthly := va;
      end if;
    end if;
    if p_size > 0 then
      v_rent := round(v_monthly * 12/p_size, 2);
    else
      v_rent := 0;
    end if;
    return v_rent;
  end get_rent;

  function get_noi_estimates(p_prop_id in pr_properties.prop_id%type)
          return pr_noi_sets PIPELINED is

  /*
   This function needs to be refactored.
  */
    cursor cur_commercial(p_prop_id in pr_properties.prop_id%type) is
      select round(v.rent * p.sq_ft/12 )      monthly_rent
                         ,      round(v.rent * p.sq_ft )          annual_rent
                         ,      round(v.rent * p.sq_ft * v.vacancy_percent/100) vacancy_amount
                         ,      v.vacancy_percent
                         ,      round(v.replacement * p.sq_ft)  insurance
                         ,      round(t.tax_amount)  TAX
                         ,      round(v.maintenance * p.sq_ft)  maintenance
                         ,      round(v.utilities * p.sq_ft)  utilities
                         ,      v.cap_rate
                         ,      v.mgt_percent
                         ,      round(((v.rent*  p.sq_ft) - ((v.rent  * p.sq_ft) * v.vacancy_percent/100)) *  v.mgt_percent/100 ) mgt_amount
                         ,      round(v.median_price *  p.sq_ft) median_market_value
                         ,      round(v.min_price *  p.sq_ft) low_market_value
                         ,      round(v.max_price *  p.sq_ft) high_market_value
                         ,      v.rent  rent
                         ,      v.prop_class
                         ,      v.min_price
                         ,      v.median_price
                         ,      v.max_price
                         ,      v.year
                         ,      c.name city
                         ,      c.county
                         ,      c.state
                         ,      p.prop_class pclass
                     from pr_properties p
                     ,    pr_property_usage pu
                     ,    rnt_city_zipcodes cz
                     ,    rnt_cities c
                     ,    pr_values v
                     ,    pr_usage_codes uc
                     ,    pr_taxes t
                     ,    rnt_zipcodes z
                     where p.prop_id = p_prop_id
                     and p.prop_id = pu.prop_id
                      and (v.ucode = uc.ucode or
                           v.ucode = uc.parent_ucode)
                      and uc.ucode = pu.ucode
                      and z.zipcode = cz.zipcode
                      and to_number(p.zipcode) = z.zipcode
                      and cz.city_id = c.city_id
                      and v.city_id = c.city_id
                      and t.prop_id = p.prop_id
                      and p.sq_ft > 0
                      and v.year = (select max(year)
                                    from pr_values v2
                                    where v2.prop_class = v.prop_class
                                    and v2.ucode = v.ucode
                                    and v2.city_id = v.city_id);

    cursor cur_residential(p_prop_id in pr_properties.prop_id%type) is 
    select round(pr_records_pkg.get_rent(v.rent, z.county_wt, p.sq_ft, p.prop_class) * p.sq_ft/12 )      monthly_rent
    ,      round(pr_records_pkg.get_rent(v.rent, z.county_wt, p.sq_ft, p.prop_class) * p.sq_ft )          annual_rent
    ,      v.rent  raw_rent
    ,      round(pr_records_pkg.get_rent(v.rent, z.county_wt, p.sq_ft, p.prop_class) * p.sq_ft * v.vacancy_percent/100) vacancy_amount
    ,      v.vacancy_percent
    ,      round(v.replacement * p.sq_ft)  insurance
    ,      round(t.tax_amount)  TAX
    ,      round(v.maintenance * p.sq_ft)  maintenance
    ,      round(v.utilities * p.sq_ft)  utilities
    ,      v.cap_rate
    ,      v.mgt_percent
    ,      round(((pr_records_pkg.get_rent(v.rent, z.county_wt, p.sq_ft, p.prop_class) * p.sq_ft)
              - ((pr_records_pkg.get_rent(v.rent, z.county_wt, p.sq_ft, p.prop_class) * p.sq_ft) * v.vacancy_percent/100)) *  v.mgt_percent/100 ) mgt_amount
    ,      round(v.median_price * z.city_wt * p.sq_ft) median_market_value
    ,      round(v.min_price * z.city_wt * p.sq_ft) low_market_value
    ,      round(v.max_price * z.city_wt * p.sq_ft) high_market_value
    ,      pr_records_pkg.get_rent(v.rent, z.county_wt, p.sq_ft, p.prop_class) rent
    ,      v.prop_class
    ,      v.min_price
    ,      v.median_price
    ,      v.max_price
    ,      v.year
    ,      c.name city
    ,      c.county
    ,      c.state
    ,      p.prop_class pclass
    ,      p.puma
    ,      p.puma_percentile
    ,      p.rental_percentile
    ,      p.sq_ft
    from pr_properties p
    ,    pr_property_usage pu
    ,    rnt_city_zipcodes cz
    ,    rnt_cities c
    ,    pr_values v
    ,    pr_usage_codes uc
    ,    pr_taxes t
    ,    rnt_zipcodes z
    where p.prop_id = p_prop_id
    and p.prop_id = pu.prop_id
    and (v.ucode = uc.ucode or
         v.ucode = uc.parent_ucode)
    and uc.ucode = pu.ucode
    and z.zipcode = cz.zipcode
    and to_number(p.zipcode) = z.zipcode
    and cz.city_id = c.city_id
    and v.city_id = c.city_id
    and t.prop_id = p.prop_id
    and t.current_yn = 'Y'
    and p.sq_ft > 0
    and v.year = (select max(year)
                  from pr_values v2
                  where v2.prop_class = v.prop_class
                  and v2.ucode = v.ucode
                  and v2.city_id = v.city_id);

    cursor cur_public(p_prop_id in pr_properties.prop_id%type) is
    select rpe.monthly_rent
    ,   rpe.monthly_rent * 12 annual_rent
    ,   v.rent  raw_rent
    ,   round(rpe.monthly_rent * 12 * rpe.vacancy_pct/100) vacancy_amount
    ,   rpe.vacancy_pct vacancy_percent
    ,   rpe.insurance
    ,   rpe.property_taxes  TAX
    ,   round(rpe.maintenance + (nvl(replace_3years, 0)/3)+ (nvl(replace_5years, 0)/5)+ (nvl(replace_12years, 0)/12)) maintenance
    ,   rpe.utilities
    ,   rpe.cap_rate
    ,   v.mgt_percent
    ,   rpe.mgt_fees mgt_amount
    ,   round(v.median_price * z.city_wt * p.sq_ft) median_market_value
    ,   round(v.min_price * z.city_wt * p.sq_ft) low_market_value
    ,   round(v.max_price * z.city_wt * p.sq_ft) high_market_value
    ,   pr_records_pkg.get_rent(v.rent, z.county_wt, p.sq_ft, p.prop_class) rent
    ,   v.prop_class
    ,   v.min_price
    ,   v.median_price
    ,   v.max_price
    ,   v.year
    ,   c.name city
    ,   c.county
    ,   c.state
    ,   p.prop_class pclass
    ,   p.puma
    ,   p.puma_percentile
    ,   p.rental_percentile
    ,   p.sq_ft
    from pr_properties p
    ,    pr_property_usage pu
    ,    rnt_city_zipcodes cz
    ,    rnt_cities c
    ,    pr_values v
    ,    pr_usage_codes uc
    ,    pr_taxes t
    ,    rnt_zipcodes z
    ,    rnt_property_estimates rpe
    ,    rnt_business_units rbu
    ,    rnt_properties rp
    where p.prop_id = p_prop_id
    and p.prop_id = pu.prop_id
    and rp.prop_id = p.prop_id
    and rp.property_id = rpe.property_id
    and rpe.business_id = rbu.business_id
    and rbu.business_name = 'Public'
    and rpe.estimate_title = 'Cashflow Estimate'
    and (v.ucode = uc.ucode or
         v.ucode = uc.parent_ucode)
    and uc.ucode = pu.ucode
    and z.zipcode = cz.zipcode
    and to_number(p.zipcode) = z.zipcode
    and cz.city_id = c.city_id
    and v.city_id = c.city_id
    and t.prop_id = p.prop_id
    and t.current_yn = 'Y'
    and p.sq_ft > 0
    and v.year = (select max(year)
                  from pr_values v2
                  where v2.prop_class = v.prop_class
                  and v2.ucode = v.ucode
                  and v2.city_id = v.city_id);

    v_ucode              pr_usage_codes.ucode%type;
    v_puma               pr_properties.puma%type;
    v_puma_percentile    pr_properties.puma_percentile%type;
    v_rental_percentile  pr_properties.rental_percentile%type;
    v_hh_income          number;
    v_rr_income          number;
    v_rr_rent            number;
    v_summary            varchar2(32767);
    v_summary2           varchar2(4000);
    v_rent_income_ratio  number;
    v_insurance          number;
    v_vacancy_rate       number;
    v_address1           pr_properties.address1%type;
    v_sqft               number;
    v_pclass             pr_properties.prop_class%type;
    v_tax                number;
    v_found              number := 0;
    v_row                pr_noi_type;

    v_hh_rent            number;
    v_select_rent        number;
    v_delta              number;

  begin

    select ucode, p.puma, puma_percentile, nvl(rental_percentile, puma_percentile) rental_percentile
    ,      rent_income_ratio, insurance, vacancy_rate, address1
    into v_ucode, v_puma, v_puma_percentile, v_rental_percentile
    ,    v_rent_income_ratio, v_insurance, v_vacancy_rate, v_address1
    from pr_property_usage pu
    ,    pr_properties p
    ,    pr_pums_data pd
    where p.prop_id = p_prop_id
    and p.prop_id = pu.prop_id
    and p.puma = pd.puma
    and rownum = 1;
                 
    if v_ucode in (110, 113, 121, 135, 212, 213, 214, 414, 90001, 90002, 90004) then
      v_hh_income := pr_pums_pkg.get_value(v_puma, 'HH-INCOME', v_puma_percentile);
      v_rr_income := pr_pums_pkg.get_value(v_puma, 'RR-INCOME', v_rental_percentile);
      v_rr_rent := pr_pums_pkg.get_value(v_puma, 'RR-RENT', v_rental_percentile);

      v_summary := '<p>The income value of a property identifies its value as a rental property,
Value = Rent - Expenses / Cap Rate.  The following table shows four different
rent estimates for '||initcap(v_address1)||':</p>
<ul>
<li>The <i>Household Income</i> estimate assumes the
tenant has a total household income of '||to_char(v_hh_income, '$99,999,999')||' and spends '
||v_rent_income_ratio||'% of this on rent.  The household income estimate is derived from census
data and tax records.</li>
<li>The <i>Household Income - Renters</i> estimate performs a similar calculation based
on the household income of renters rather than all households.</li>
<li>The <i>Market Rents</i> estimate evaluates this property in comparison to rental properties in the area.</li>
<li>The <i>Price/Ft</i> estimate uses the size of the property to estimate its rent.</li>
</ul>
<p>Click on a rent value to download a spreadsheet that estimates the NOI
(net operating income), cash on cash return, income value and IRR (internal rate of return)
for this property.</p>';

      v_summary := v_summary || '<table class="datatable">'
               ||'<tr><th>Valuation Model</th><th>Monthly Rent</th></tr>'

               ||'<tr><th>Household Income - All Households</th>'
               ||'<td><a href="/rental/pages/get_spreadsheet.php?PROP_ID='||p_prop_id||'&RENT='
               ||round(v_rent_income_ratio * v_hh_income/1200)||'" target="_blank" rel="nofollow">'
               ||'<img heigth="16" width="16" src="/rental/images/excel-icon-16.gif">  '
               ||to_char(round(v_rent_income_ratio * v_hh_income/1200),'$99,999')
               ||'</a></td></tr>'

               ||'<tr><th>Household Income - Renters</th>'
               ||'<td><a href="/rental/pages/get_spreadsheet.php?PROP_ID='||p_prop_id||'&RENT='
               ||round(v_rr_income/1200)||'" target="_blank" rel="nofollow">'
               ||'<img heigth="16" width="16" src="/rental/images/excel-icon-16.gif">  '
               ||to_char(round(v_rr_income/1200),'$99,999')
               ||'</a></td></tr>'
               

               ||'<tr><th>Market Rents</th>'
               ||'<td><a href="/rental/pages/get_spreadsheet.php?PROP_ID='||p_prop_id||'&RENT='
               ||round(v_rr_rent/1000)||'" target="_blank" rel="nofollow" >'
               ||'<img heigth="16" width="16" src="/rental/images/excel-icon-16.gif">  '
               ||to_char(round(v_rr_rent/1000),'$99,999')
               ||'</a></td></tr>';

      v_summary2 := '<p>Expense Estimates:</p>
<ul>
<li>Census data records show '||v_vacancy_rate||'% of the rental properties
in this area are vacant.  We''ve added a 5% bad dept allowance to this.</li>
<li>Maintenance costs are estimated based on the size of the property.</li>
<li>The property tax estimate uses the
average millage rate for the county.  It does not include adjustments for city or unincorporated
areas.  Actual taxes may vary.</li>
<li>Insurance estimates are based on the size and location of the
property.  They are not adjusted for age, flood zone or other risk factors</li>
<li>We don''t have a way to estimate HOA fees.  These should be added manually</li>
</ul>
<p>The following table shows a income valuation estimate for '||initcap(v_address1)||'.
<a href="/rental/pages/get_spreadsheet.php?PROP_ID='||p_prop_id||'">
Download a spreadsheet</a> or click on the Estimate Cashflow link to change its estimates and
assumptions. Alternatively, click on the Save button to upload a copy of the spreadsheet to
Google Drive.</p>';
      v_found := 0;

      for e_rec in cur_public(p_prop_id) loop
        v_found := v_found + 1;
        pipe row (pr_noi_type( monthly_rent        => e_rec.monthly_rent
                             , annual_rent         => e_rec.annual_rent
                             , vacancy_amount      => e_rec.vacancy_amount
                             , vacancy_percent     => e_rec.vacancy_percent
                             , insurance           => e_rec.insurance
                             , tax                 => e_rec.tax
                             , maintenance         => e_rec.maintenance
                             , utilities           => e_rec.utilities
                             , cap_rate            => e_rec.cap_rate
                             , mgt_percent         => e_rec.mgt_percent
                             , mgt_amount          => e_rec.mgt_amount
                             , median_market_value => e_rec.median_market_value
                             , low_market_value    => e_rec.low_market_value
                             , high_market_value   => e_rec.high_market_value
                             , sqft_rent           => round(e_rec.annual_rent/e_rec.sq_ft)
                             , prop_class          => e_rec.prop_class
                             , min_price           => e_rec.min_price
                             , median_price        => e_rec.median_price
                             , max_price           => e_rec.max_price
                             , estimate_year       => e_rec.year
                             , noi                 => null
                             , city                => e_rec.city
                             , county              => e_rec.county
                             , state               => e_rec.state
                             , pclass              => e_rec.pclass
                             , summary             => v_summary
                             ||'<tr><th>Price/Ft</th>'
                             ||'<td><a href="/rental/pages/get_spreadsheet.php?PROP_ID='||p_prop_id||'&RENT='
                             ||e_rec.monthly_rent||'" target="_blank" rel="nofollow">'
                             ||'<img heigth="16" width="16" src="/rental/images/excel-icon-16.gif">'
                             ||to_char(round(e_rec.monthly_rent),'$99,999')
                             ||'</a></td></tr>'
                             ||'</table>'||v_summary2));
      end loop;
      
      if v_found = 0 then
        for e_rec in cur_residential(p_prop_id) loop
          v_found := v_found + 1;
          if e_rec.pclass = 'A' then
            v_select_rent := v_rr_income/1000;
          else
            v_select_rent := v_rr_rent/1000;
          end if;
          pipe row (pr_noi_type( monthly_rent        => v_select_rent
                               , annual_rent         => v_select_rent * 12
                               , vacancy_amount      => round((v_vacancy_rate + 5) * v_select_rent * 12/100)
                               , vacancy_percent     => v_vacancy_rate + 5
                               , insurance           => round(v_insurance * e_rec.sq_ft)
                               , tax                 => e_rec.tax
                               , maintenance         => e_rec.maintenance
                               , utilities           => e_rec.utilities
                               , cap_rate            => e_rec.cap_rate
                               , mgt_percent         => e_rec.mgt_percent
                               , mgt_amount          => round(v_select_rent * 12 * e_rec.mgt_percent/100)
                               , median_market_value => e_rec.median_market_value
                               , low_market_value    => e_rec.low_market_value
                               , high_market_value   => e_rec.high_market_value
                               , sqft_rent           => round(v_select_rent * 12/e_rec.sq_ft) 
                               , prop_class          => e_rec.prop_class
                               , min_price           => e_rec.min_price
                               , median_price        => e_rec.median_price
                               , max_price           => e_rec.max_price
                               , estimate_year       => e_rec.year
                               , noi                 => null
                               , city                => e_rec.city
                               , county              => e_rec.county
                               , state               => e_rec.state
                               , pclass              => e_rec.pclass
                               , summary             => v_summary
                               ||'<tr><th>Price/Ft</th>'
                               ||'<td><a href="/rental/pages/get_spreadsheet.php?PROP_ID='||p_prop_id||'&RENT='
                               ||e_rec.monthly_rent||'" target="_blank" rel="nofollow">'
                               ||'<img heigth="16" width="16" src="/rental/images/excel-icon-16.gif">'
                               ||to_char(round(e_rec.monthly_rent),'$99,999')
                               ||'</a></td></tr>'
                               ||'</table>'||v_summary2));
        end loop;
      end if;
      
      if v_found = 0 then
        select sq_ft, prop_class, tax_amount
        into v_sqft, v_pclass, v_tax
        from pr_properties p
        ,    pr_taxes t
        where t.prop_id = p.prop_id
        and p.prop_id = p_prop_id
        and t.current_yn='Y'
        and rownum=1;

        if v_pclass = 'A' then
          v_select_rent := round(v_rr_income/1000);
        else
          v_select_rent := round(v_rr_rent/1000);
        end if;
        
        v_row := pr_noi_type(null, null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null );
        
        v_row.monthly_rent        := v_select_rent;
        v_row.annual_rent         := v_select_rent * 12;
        v_row.vacancy_amount      := round((v_vacancy_rate + 5) * v_select_rent * 12/100);
        v_row.vacancy_percent     := v_vacancy_rate + 5;
        if v_sqft> 0 then
          v_row.insurance         := round(v_insurance * v_sqft);
          v_row.sqft_rent         := round(v_select_rent * 12/v_sqft);
        else
          v_row.insurance         := v_tax;
        end if;
        v_row.tax                 := v_tax;
        v_row.maintenance         := v_sqft * 0.5;
        v_row.utilities           := 0;
        v_row.cap_rate            := 6;
        v_row.mgt_percent         := 10;
        v_row.mgt_amount          := round(v_select_rent * 120 /100);
        v_row.median_market_value := 0;
        v_row.low_market_value    := 0;
        v_row.high_market_value   := 0;
        v_row.prop_class          := 'A';
        v_row.min_price           := 0;
        v_row.median_price        := 0;
        v_row.max_price           := 10;
        v_row.estimate_year       := to_char(sysdate, 'YYYY');
        v_row.noi                 := null;
        v_row.city                := null;
        v_row.county              := null;
        v_row.state               := null;
        v_row.pclass              := v_pclass;
        v_row.summary             := v_summary||'</table>'||v_summary2;
        

        pipe row(v_row);
        v_row.prop_class          := 'B';
        v_row.cap_rate            := 7;
        pipe row(v_row);
        v_row.prop_class          := 'C';
        v_row.cap_rate            := 9;
        pipe row(v_row);
      end if;
    else
     v_summary := 
     '<p>The following table shows a income valuation estimate for '||initcap(v_address1)||'.
      <a href="/rental/pages/get_spreadsheet.php?PROP_ID='||p_prop_id||'">
      Download a spreadsheet</a>  or click on the Estimate Cashflow link to change its estimates and
      assumptions.   Alternatively, click on the Save button to upload a copy of the spreadsheet to Google Drive.</p>';

      for e_rec in cur_public(p_prop_id) loop
        v_found := v_found + 1;
        pipe row (pr_noi_type( monthly_rent        => e_rec.monthly_rent
                             , annual_rent         => e_rec.annual_rent
                             , vacancy_amount      => e_rec.vacancy_amount
                             , vacancy_percent     => e_rec.vacancy_percent
                             , insurance           => e_rec.insurance
                             , tax                 => e_rec.tax
                             , maintenance         => e_rec.maintenance
                             , utilities           => e_rec.utilities
                             , cap_rate            => e_rec.cap_rate
                             , mgt_percent         => e_rec.mgt_percent
                             , mgt_amount          => e_rec.mgt_amount
                             , median_market_value => e_rec.median_market_value
                             , low_market_value    => e_rec.low_market_value
                             , high_market_value   => e_rec.high_market_value
                             , sqft_rent           => round(e_rec.annual_rent/e_rec.sq_ft)
                             , prop_class          => e_rec.prop_class
                             , min_price           => e_rec.min_price
                             , median_price        => e_rec.median_price
                             , max_price           => e_rec.max_price
                             , estimate_year       => e_rec.year
                             , noi                 => null
                             , city                => e_rec.city
                             , county              => e_rec.county
                             , state               => e_rec.state
                             , pclass              => e_rec.pclass
                             , summary             => v_summary
                             ));
      end loop;

      if v_found =  0 then
        for e_rec in cur_commercial(p_prop_id) loop
          pipe row (pr_noi_type( monthly_rent        => e_rec.monthly_rent
                             , annual_rent         => e_rec.annual_rent
                             , vacancy_amount      => e_rec.vacancy_amount
                             , vacancy_percent     => e_rec.vacancy_percent
                             , insurance           => e_rec.insurance
                             , tax                 => e_rec.tax
                             , maintenance         => e_rec.maintenance
                             , utilities           => e_rec.utilities
                             , cap_rate            => e_rec.cap_rate
                             , mgt_percent         => e_rec.mgt_percent
                             , mgt_amount          => e_rec.mgt_amount
                             , median_market_value => e_rec.median_market_value
                             , low_market_value    => e_rec.low_market_value
                             , high_market_value   => e_rec.high_market_value
                             , sqft_rent           => e_rec.rent
                             , prop_class          => e_rec.prop_class
                             , min_price           => e_rec.min_price
                             , median_price        => e_rec.median_price
                             , max_price           => e_rec.max_price
                             , estimate_year       => e_rec.year
                             , noi                 => null
                             , city                => e_rec.city
                             , county              => e_rec.county
                             , state               => e_rec.state
                             , pclass              => e_rec.pclass
                             , summary             => v_summary
                             ));
        end loop;
      end if;
    end if;
  
  end get_noi_estimates;

  function get_property_details(p_address in varchar2, p_city in varchar2)
    return property_details_rec PIPELINED is
    v_sql_statement       varchar2(4000);
    v_property_details    property_details_rec;
    c                     sys_refcursor;
    
  begin
    v_sql_statement :=
'select property_details_type(score(1)
, p.PROP_ID
, p.SOURCE_ID
, p.SOURCE_PK
, p.ADDRESS1
, p.ADDRESS2
, p.CITY
, p.STATE
, p.ZIPCODE
, p.ACREAGE
, p.SQ_FT
, p.PROP_CLASS
, p.GEO_LOCATION
, p.TOTAL_BEDROOMS
, p.TOTAL_BATHROOMS
, p.GEO_FOUND_YN
, p.PARCEL_ID
, p.ALT_KEY
, p.VALUE_GROUP
, p.QUALITY_CODE
, p.YEAR_BUILT
, p.BUILDING_COUNT
, p.RESIDENTIAL_UNITS
, p.LEGAL_DESC
, p.MARKET_AREA
, p.NEIGHBORHOOD_CODE
, p.CENSUS_BK
, p.GEO_COORDINATES
, p.PUMA
, p.PUMA_PERCENTILE
, p.RENTAL_PERCENTILE
, p.HIDDEN
, u.UCODE
, uc.DESCRIPTION
, uc.PARENT_UCODE)
from pr_properties p
,    pr_property_usage u
,    pr_usage_codes uc
where contains(address1, pr_records_pkg.standard_suffix(upper(:1)), 1) >0
and u.prop_id = p.prop_id
and u.ucode = uc.ucode
and upper(city) = upper(:2)';
     open c for v_sql_statement using p_address, p_city;
     loop
       fetch c bulk collect into v_property_details;
       for i in 1 .. v_property_details.count loop
         pipe row (v_property_details(i));
       end loop;
       exit when c%notfound;
     end loop;
     close c;

  end get_property_details;

end pr_records_pkg;
/
show errors package pr_records_pkg
show errors package body pr_records_pkg
