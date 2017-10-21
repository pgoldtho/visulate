===============================
Updates to geo coordinate data
===============================
Large volume updates to geo coordinates run very slowly if the column has a spatial index.  
The index must be dropped before the update and then recreated after it.  Unfortunately 
this will cause any spatial queries that rely on the index to fail with an Oracle error.

1. Create tables called pr_properties_geo and pr_locations_geo
2. Edit config.php set define('MAINTENANCE_MODE', 'Y');
3. Run drop_spatial.sql 
4. Run update_prop.sql
5. Run update_loc.sql
6. Run cr_spatial.sql 
7. Edit config.php set define('MAINTENANCE_MODE', 'N');
8. Drop tables pr_properties_geo and pr_locations_geo cascade