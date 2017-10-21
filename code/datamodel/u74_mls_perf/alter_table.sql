alter table mls_listings
add (geo_location SDO_GEOMETRY);

INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
   VALUES ('MLS_LISTINGS', 'GEO_LOCATION', 
   SDO_DIM_ARRAY 
     (SDO_DIM_ELEMENT('LONG', -180.0, 180.0, 0.5), 
     SDO_DIM_ELEMENT('LAT', -90.0, 90.0, 0.5)), 
   8307);

COMMIT;
   
CREATE INDEX mls_listings_sidx ON mls_listings(geo_location)
  INDEXTYPE IS mdsys.spatial_index;  
