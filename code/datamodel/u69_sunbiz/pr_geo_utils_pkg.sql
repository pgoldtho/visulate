create or replace package pr_geo_utils_pkg as

 function get_nearby_corps( p_lat in number
                   , p_lon in number )
   return pr_corp_loc_set PIPELINED;
end    pr_geo_utils_pkg;
/

create or replace package body pr_geo_utils_pkg as

 function get_nearby_corps( p_lat in number
                   , p_lon in number )
   return pr_corp_loc_set PIPELINED is
   
   cursor cur_loc( p_lat in number
                 , p_lon in number) is
   SELECT loc_id
   ,   initcap(address1) address1
   ,   initcap(address2) address2
   ,   initcap(city) city
   ,   state
   ,   zipcode
   ,   p.geo_location.sdo_point.x lon
   ,   p.geo_location.sdo_point.y lat
   ,   prop_id
   FROM pr_locations p
   WHERE sdo_within_distance
           ( geo_location
           , SDO_GEOMETRY(2001, 8307,
                          SDO_POINT_TYPE (p_lon, p_lat ,NULL), NULL, NULL)
           , 'distance=100 unit=Meter') = 'TRUE';

   cursor cur_corp(p_loc_id in number) is
   select replace(initcap(c.name),'Llc', 'LLC') name
   ,      c.corp_number
   ,      cl.loc_type
   from pr_corporate_locations cl
   ,    pr_corporations c
   where cl.loc_id = p_loc_id
   and cl.corp_number = c.corp_number;   
   
  begin
    for p_rec in cur_loc(p_lat, p_lon) loop
	  for c_rec in cur_corp(p_rec.loc_id) loop
	    pipe row
		  (pr_corp_loc_type( c_rec.corp_number
		                   , c_rec.name
		                   , c_rec.loc_type
						   , p_rec.loc_id
						   , p_rec.prop_id
						   , p_rec.address1 
						   , p_rec.address2
						   , p_rec.city 
						   , p_rec.state 
						   , p_rec.zipcode 
						   , p_rec.lat 
						   , p_rec.lon 
						   ));
	  end loop;
	end loop;
   
   
  end get_nearby_corps;   
end  pr_geo_utils_pkg;
/
show errors package pr_geo_utils_pkg;
show errors package body pr_geo_utils_pkg;
