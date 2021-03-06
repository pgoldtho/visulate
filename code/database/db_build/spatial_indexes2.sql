drop index pr_properties_sidx;
CREATE INDEX pr_properties_sidx ON pr_properties(geo_location) INDEXTYPE IS mdsys.spatial_index
PARAMETERS ('sdo_dml_batch_size=5000 tablespace=SPATIAL_INDEX2 work_tablespace=SPATIAL_WORK2'); 

drop index PR_LOCATIONS_SIDX;
CREATE INDEX pr_locations_sidx ON pr_locations(geo_location) INDEXTYPE IS mdsys.spatial_index
PARAMETERS ('sdo_dml_batch_size=5000 tablespace=SPATIAL_INDEX2 work_tablespace=SPATIAL_WORK2'); 


drop index ZIPCODE_SIDX;
CREATE INDEX zipcode_sidx ON rnt_zipcodes(geo_location) INDEXTYPE IS mdsys.spatial_index
PARAMETERS ('sdo_dml_batch_size=5000 tablespace=SPATIAL_INDEX2 work_tablespace=SPATIAL_WORK2'); 


drop index MLS_LISTINGS_SIDX;
CREATE INDEX mls_listings_sidx ON mls_listings(geo_location) INDEXTYPE IS mdsys.spatial_index
PARAMETERS ('sdo_dml_batch_size=5000 tablespace=SPATIAL_INDEX2 work_tablespace=SPATIAL_WORK2'); 
