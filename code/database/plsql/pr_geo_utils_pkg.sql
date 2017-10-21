create or replace package pr_geo_utils_pkg as

 function get_nearby_corps( p_lat in number
                   , p_lon in number )
   return pr_corp_loc_set PIPELINED;
   
 procedure geocode_addr( p_addr  in varchar2
                       , p_lat   out number
                       , p_lon   out number);
                       
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
           , 'distance=150 unit=Meter') = 'TRUE';

   cursor cur_corp(p_loc_id in number) is
   select replace(initcap(c.name),'Llc', 'LLC') name
   ,      c.corp_number
   ,      cl.loc_type
   from pr_corporate_locations cl
   ,    pr_corporations c
   where cl.loc_id = p_loc_id
   and cl.corp_number = c.corp_number
   and c.status = 'A';   
   
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
                           , p_rec.lon));
    end loop;
  end loop;
   
   
  end get_nearby_corps;   
  
  procedure geocode_addr( p_addr  in varchar2
                        , p_lat   out number
                        , p_lon   out number) is
                        
    v_cdoc           clob;
    v_line           varchar2(32767);
    http401exception exception;
    v_xdoc           xmltype;   
    v_req            utl_http.req;
    v_resp           utl_http.resp;
    v_addr           varchar2(4000);                    
                        

    v_base       varchar2(1024) := 'http://visulate.com/cgi-bin/geocode.cgi?address=';

  BEGIN
    v_addr := replace(p_addr, ' ', '+');
    DBMS_LOB.createtemporary(v_cdoc, FALSE);
    v_req := utl_http.begin_request(v_base||v_addr);
    utl_http.set_header(v_req, 'User-Agent', 'Mozilla/4.0');
    v_resp := utl_http.get_response(v_req);
    BEGIN
      LOOP
        utl_http.read_text(v_resp, v_line, 16384);
        DBMS_LOB.writeappend (v_cdoc, LENGTH(v_line), v_line);
      END LOOP;
    EXCEPTION
      WHEN utl_http.end_of_body THEN
            utl_http.end_response(v_resp);
      when others then raise;
    END;
    
    if length(v_cdoc) = 0 then
      p_lat := 0;
      p_lon := 0;
    else
      begin
        v_xdoc := xmltype(v_cdoc);      
        p_lat := v_xdoc.extract('/entry/lat/text()').getStringVal();
        p_lon := v_xdoc.extract('/entry/lon/text()').getStringVal();
      exception
        when others then
          p_lat := 0;
          p_lon := 0;
          pr_rets_pkg.put_line(v_line);
      end;  
    end if;
    DBMS_LOB.freetemporary(v_cdoc);


  
  end geocode_addr;
  
end  pr_geo_utils_pkg;
/
show errors package pr_geo_utils_pkg;
show errors package body pr_geo_utils_pkg;
