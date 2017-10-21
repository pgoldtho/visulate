drop type property_details_rec;
drop type property_details_type;

create type property_details_type as object
( SCORE                                                                             NUMBER
, PROP_ID                                                                           NUMBER
, SOURCE_ID                                                                         NUMBER
, SOURCE_PK                                                                         VARCHAR2(32)
, ADDRESS1                                                                          VARCHAR2(60)
, ADDRESS2                                                                          VARCHAR2(60)
, CITY                                                                              VARCHAR2(30)
, STATE                                                                             VARCHAR2(2)
, ZIPCODE                                                                           VARCHAR2(7)
, ACREAGE                                                                           NUMBER
, SQ_FT                                                                             NUMBER(8)
, PROP_CLASS                                                                        VARCHAR2(1)
, GEO_LOCATION                                                                      MDSYS.SDO_GEOMETRY
, TOTAL_BEDROOMS                                                                    NUMBER
, TOTAL_BATHROOMS                                                                   NUMBER
, GEO_FOUND_YN                                                                      VARCHAR2(1)
, PARCEL_ID                                                                         VARCHAR2(26)
, ALT_KEY                                                                           VARCHAR2(26)
, VALUE_GROUP                                                                       NUMBER(1)
, QUALITY_CODE                                                                      NUMBER(1)
, YEAR_BUILT                                                                        NUMBER(4)
, BUILDING_COUNT                                                                    NUMBER(4)
, RESIDENTIAL_UNITS                                                                 NUMBER(4)
, LEGAL_DESC                                                                        VARCHAR2(30)
, MARKET_AREA                                                                       VARCHAR2(3)
, NEIGHBORHOOD_CODE                                                                 VARCHAR2(10)
, CENSUS_BK                                                                         VARCHAR2(16)
, GEO_COORDINATES                                                                   MDSYS.SDO_GEOMETRY
, PUMA                                                                              NUMBER
, PUMA_PERCENTILE                                                                   NUMBER
, RENTAL_PERCENTILE                                                                 NUMBER
, HIDDEN                                                                            VARCHAR2(1)
, UCODE                                                                             NUMBER
, DESCRIPTION                                                                       VARCHAR2(128)
, PARENT_UCODE                                                                      NUMBER);
/
create type property_details_rec as table of property_details_type;
/