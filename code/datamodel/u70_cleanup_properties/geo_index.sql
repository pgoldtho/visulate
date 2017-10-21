drop index customers_sidx
   
CREATE INDEX pr_properties_sidx ON pr_properties(geo_location)
  INDEXTYPE IS mdsys.spatial_index;   