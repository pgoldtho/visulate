CREATE INDEX pr_properties_sidx ON pr_properties(geo_location)
  INDEXTYPE IS mdsys.spatial_index; 

CREATE INDEX pr_locations_sidx ON pr_locations(geo_location)
  INDEXTYPE IS mdsys.spatial_index; 

CREATE INDEX mls_listings_sidx ON mls_listings(geo_location)
  INDEXTYPE IS mdsys.spatial_index; 