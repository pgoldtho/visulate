INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
   VALUES ('PR_PROPERTIES', 'GEO_LOCATION', 
   SDO_DIM_ARRAY 
     (SDO_DIM_ELEMENT('LONG', -180.0, 180.0, 0.5), 
     SDO_DIM_ELEMENT('LAT', -90.0, 90.0, 0.5)), 
   8307);
   
CREATE INDEX pr_properties_sidx ON pr_properties(geo_location)  INDEXTYPE IS mdsys.spatial_index;   
