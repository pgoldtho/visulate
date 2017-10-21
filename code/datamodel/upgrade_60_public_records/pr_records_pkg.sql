create or replace package pr_records_pkg as
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
           return pr_owners.owner_id%type;

  function get_prop_id( x_address1        in pr_properties.address1%type
                      , x_address2        in pr_properties.address2%type
                      , x_zipcode         in pr_properties.zipcode%type)
           return pr_properties.prop_id%type;


  function insert_source( X_SOURCE_NAME IN PR_SOURCES.SOURCE_NAME%TYPE
                       , X_SOURCE_TYPE IN PR_SOURCES.SOURCE_TYPE%TYPE
                       , X_BASE_URL IN PR_SOURCES.BASE_URL%TYPE
                       , X_PHOTO_URL IN PR_SOURCES.PHOTO_URL%TYPE
                       , X_PROPERTY_URL IN PR_SOURCES.PROPERTY_URL%TYPE
                       , X_PLATBOOK_URL IN PR_SOURCES.PLATBOOK_URL%TYPE
                       , X_TAX_URL IN PR_SOURCES.TAX_URL%TYPE
                       , X_PK_COLUMN_NAME IN PR_SOURCES.PK_COLUMN_NAME%TYPE)
             return PR_SOURCES.SOURCE_ID%TYPE;

  function insert_property( X_SOURCE_ID IN PR_PROPERTIES.SOURCE_ID%TYPE
                          , X_SOURCE_PK IN PR_PROPERTIES.SOURCE_PK%TYPE
                          , X_ADDRESS1 IN PR_PROPERTIES.ADDRESS1%TYPE
                          , X_ADDRESS2 IN PR_PROPERTIES.ADDRESS2%TYPE
                          , X_CITY IN PR_PROPERTIES.CITY%TYPE
                          , X_STATE IN PR_PROPERTIES.STATE%TYPE
                          , X_ZIPCODE IN PR_PROPERTIES.ZIPCODE%TYPE
                          , X_ACREAGE IN PR_PROPERTIES.ACREAGE%TYPE
                          , X_SQ_FT IN PR_PROPERTIES.SQ_FT%TYPE)
              return PR_PROPERTIES.PROP_ID%TYPE;

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
                                , X_OLD_OWNER_ID IN PR_PROPERTY_SALES.OLD_OWNER_ID%TYPE
                                , X_PLAT_BOOK    IN PR_PROPERTY_SALES.PLAT_BOOK%TYPE
                                , X_PLAT_PAGE    IN PR_PROPERTY_SALES.PLAT_PAGE%TYPE);

  function insert_owner( X_OWNER_NAME IN PR_OWNERS.OWNER_NAME%TYPE
                       , X_OWNER_TYPE IN PR_OWNERS.OWNER_TYPE%TYPE)
              return PR_OWNERS.OWNER_ID%TYPE;

  procedure insert_property_owner( X_OWNER_ID   IN PR_PROPERTY_OWNERS.OWNER_ID%TYPE
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

  function get_prop_id( x_address1        in pr_properties.address1%type
                      , x_address2        in pr_properties.address2%type
                      , x_zipcode         in pr_properties.zipcode%type)
           return pr_properties.prop_id%type is

    cursor cur_prop( x_address1        in pr_properties.address1%type
                   , x_address2        in pr_properties.address2%type
                   , x_zipcode         in pr_properties.zipcode%type) is
     select prop_id
     from pr_properties
     where address1 = x_address1
     and   nvl(address2, ' ') = nvl(x_address2, ' ')
     and   zipcode  = nvl(x_zipcode, 'XXXXX');

    v_return   pr_properties.prop_id%type := '';

 begin
   for p_rec in cur_prop(x_address1, x_address2, x_zipcode) loop
     v_return := p_rec.prop_id;
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


  function insert_property( X_SOURCE_ID IN PR_PROPERTIES.SOURCE_ID%TYPE
                          , X_SOURCE_PK IN PR_PROPERTIES.SOURCE_PK%TYPE
                          , X_ADDRESS1 IN PR_PROPERTIES.ADDRESS1%TYPE
                          , X_ADDRESS2 IN PR_PROPERTIES.ADDRESS2%TYPE
                          , X_CITY IN PR_PROPERTIES.CITY%TYPE
                          , X_STATE IN PR_PROPERTIES.STATE%TYPE
                          , X_ZIPCODE IN PR_PROPERTIES.ZIPCODE%TYPE
                          , X_ACREAGE IN PR_PROPERTIES.ACREAGE%TYPE
                          , X_SQ_FT IN PR_PROPERTIES.SQ_FT%TYPE)
              return PR_PROPERTIES.PROP_ID%TYPE
  is
     x          number;
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
     , SQ_FT)
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
     , X_SQ_FT)
     returning PROP_ID into x;

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
                                , X_OLD_OWNER_ID IN PR_PROPERTY_SALES.OLD_OWNER_ID%TYPE
                                , X_PLAT_BOOK    IN PR_PROPERTY_SALES.PLAT_BOOK%TYPE
                                , X_PLAT_PAGE    IN PR_PROPERTY_SALES.PLAT_PAGE%TYPE)
  is
  begin

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

  end insert_property_sale;


  function insert_owner( X_OWNER_NAME IN PR_OWNERS.OWNER_NAME%TYPE
                       , X_OWNER_TYPE IN PR_OWNERS.OWNER_TYPE%TYPE)
              return PR_OWNERS.OWNER_ID%TYPE
  is
     x          number;
  begin

     insert into PR_OWNERS
     ( OWNER_ID
     , OWNER_NAME
     , OWNER_TYPE)
     values
     ( PR_OWNERS_SEQ.NEXTVAL
     , X_OWNER_NAME
     , X_OWNER_TYPE)
     returning OWNER_ID into x;

     return x;
  end insert_owner;

  procedure insert_property_owner( X_OWNER_ID   IN PR_PROPERTY_OWNERS.OWNER_ID%TYPE
                                 , X_PROP_ID    IN PR_PROPERTY_OWNERS.PROP_ID%TYPE
                                 , X_MAILING_ID IN PR_PROPERTY_OWNERS.MAILING_ID%TYPE)
  is
  begin

     insert into PR_PROPERTY_OWNERS
     ( OWNER_ID
     , PROP_ID
     , MAILING_ID)
     values
     ( X_OWNER_ID
     , X_PROP_ID
     , X_MAILING_ID);

  end insert_property_owner;

  procedure insert_taxes( X_PROP_ID     IN PR_TAXES.PROP_ID%TYPE
                        , X_TAX_YEAR    IN PR_TAXES.TAX_YEAR%TYPE
                        , X_TAX_VALUE   IN PR_TAXES.TAX_VALUE%TYPE
                        , X_TAX_AMOUNT  IN PR_TAXES.TAX_AMOUNT%TYPE)
  is
  begin

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
  begin

     insert into PR_PROPERTY_USAGE
     ( UCODE
     , PROP_ID)
     values
     ( X_UCODE
     , X_PROP_ID);
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
                          , X_SQ_FT IN PR_BUILDINGS.SQ_FT%TYPE)
              return PR_BUILDINGS.BUILDING_ID%TYPE
  is
     x          number;
  begin

     insert into PR_BUILDINGS
     ( BUILDING_ID
     , PROP_ID
     , BUILDING_NAME
     , YEAR_BUILT
     , SQ_FT)
     values
     ( PR_BUILDINGS_SEQ.NEXTVAL
     , X_PROP_ID
     , X_BUILDING_NAME
     , X_YEAR_BUILT
     , X_SQ_FT)
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


end pr_records_pkg;
/
show errors package pr_records_pkg
show errors package body pr_records_pkg