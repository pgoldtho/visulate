INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
   VALUES ('RNT_CITIES', 'GEO_LOCATION',
   SDO_DIM_ARRAY
     (SDO_DIM_ELEMENT('LONG', -180.0, 180.0, 0.5),
     SDO_DIM_ELEMENT('LAT', -90.0, 90.0, 0.5)),
   8307);

CREATE INDEX rnt_cities_sidx ON rnt_cities(geo_location)
  INDEXTYPE IS mdsys.spatial_index
  parameters ('tablespace=spatial_index2');

  SQL> conn sys/manager as sysdba
Connected.
SQL> alter user rntmgr2 quota unlimited on spatial_index2;
