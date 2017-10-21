set define ~
create or replace package mls_sef_pkg as
/*******************************************************************************
   Copyright (c) Visulate 2013        All rights reserved worldwide
    Name:      mls_sef_pkg
    Purpose:   MLS Replication API's 
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0         1-SEP-13   Peter Goldthorp  Initial Version
*******************************************************************************/
  global_errors    pls_integer   := 0;
  global_login     varchar2(256) := 'http://sef.rets.interealty.com/Login.asmx/Login';
  global_logout    varchar2(256) := 'http://sef.rets.interealty.com/Logout.asmx/Logout';
  global_user      varchar2(16)  := 'sRuSanW';
  global_passwd    varchar2(16)  := 'fds83b43';
  global_base      varchar2(256) := 'http://sef.rets.interealty.com/Search.asmx/Search?SearchType=Property';
  global_src       number := 8; -- South East Florida MLS
  global_agent     varchar2(16)  := global_user;
  
 

  type tax_rec_type is record
  ( source_id           number
  , display_name        varchar2(256)
  , link_name           varchar2(32));
  
  function get_select_vals return pr_rets_pkg.value_table;

  function get_id( p_source_id  in mls_listings.source_id%type
                 , p_mls_number in mls_listings.mls_number%type)
                     return mls_listings.mls_id%type;

  function get_tax_id( p_mls_tax_id  in varchar2
                     , p_county      in varchar2)  
               return varchar2;
  function get_tax_source( p_county      in varchar2)  
               return tax_rec_type;
               
  procedure get_by_type( p_type in varchar2
                       , p_county  in varchar2
                       , p_mode in varchar2 := 'update');
  
  procedure get_listings( p_ltype     in varchar2
                        , p_county    in varchar2
                        , p_mode      in varchar2 := 'update');

  procedure set_listing( p_query_type  in mls_rets_responses.query_type%type
                       , p_values      in pr_rets_pkg.value_table
                       , p_prop_id     in pr_properties.prop_id%type
                       , p_verified    in varchar2);                        

  procedure get_photos( p_sysid       in varchar2
                      , p_photo_count in number
                      , p_mls_id      in number);
                            

  procedure update_price_ranges;
  procedure update_mls;
end mls_sef_pkg;
/  
                                   
create or replace package body mls_sef_pkg as
/*******************************************************************************
   Copyright (c) Visulate 2013        All rights reserved worldwide
    Name:      mls_sef_pkg
    Purpose:   MLS Replication API's 
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0         1-SEP-13   Peter Goldthorp  Initial Version
*******************************************************************************/
  function get_select_vals return pr_rets_pkg.value_table is
    v_select pr_rets_pkg.value_table;
  begin
    /* Class 1 = Residential Property Codes
        #Beds (25)
        Folio Number (264)
        #Bathrooms(92)
        Senior High School (893)
        #HBaths (109)
        IDX (195)
        ML# (157)
        Short Sale (1465)
        Address on Internet (1488)
        Map Coordinates (250)
        Virtual Tour (1223)
        Association Fee (93)
        Internet Remarks (115)
        Middle School (891)
        sysid (sysid)
        Assumable (22)
        List Date (135)
        Office Name (165)
        Elementary School (886)
        List Price (137)
        REO (1473)
        Last Transaction Date (131)
    */
    v_select('ResidentialProperty') :=
      'sysid,22,25,92,93,109,113,114,115,131,135,137,146,157,165,195,214,250,264,886,891,893,1223,1465,1488,1473';
      
   /* Class 2 = Condos
        #Beds (25)
        Folio Number (264)
        Maintenance Charge/Month (348)
        REO (1473)
        #Carport Spaces (59)
        IDX (195)
        Maintenance Includes (347)
        Remarks (214)
        #Garage Spaces (102)
        Middle School (891)
        Senior High School (893)
        #HBaths (109)
        Internet Remarks (115)
        Office Name (165)
        Short Sale (1465)
        Approx. Sqft Total Area (261)
        List Price (137)
        Pet Restrictions (180)
        Virtual Tour (1223)
        Elementary School (886)
        ML# (157)
        Pets Allowed (181)
        sysid (sysid)
        Last Transaction Date (131)
   */
    v_select('Condos') :=
      'sysid,25,59,92,102,109,113,114,115,131,137,157,165,180,181,195,214,261,264,347,348,886,891,893,1223,1465,1473';

   /* Class 3 = Income Property Codes

        #Parking Spaces (417)
        IDX (195)
        REO (1473)
        #Stories (163)
        Internet Remarks (115)
        Remarks (214)
        Approx. Sqft Total Area (261)
        List Price (137)
        Rent Includes (429)
        Assumable (22)
        ML# (157)
        Terms Considered (444)
        Folio Number (264)
        Map Coordinates (250)
        Virtual Tour (1223)
        Geographic Area (106)
        Office Name (165)
        sysid (sysid)
        Gross Rent Income (404)
        Pool (191)
        Last Transaction Date (131)
    */     
    v_select('IncomeProperty') :=
      'sysid,22,106,113,115,131,137,157,163,165,417,191,195,214,250,261,264,404,429,444,1223,1473';
      

     /* Class 4 = Residential Land
        #Parcels (477)
        Front Exposure (90)
        Municipal Code (150)
        Type of Soil (487)
        Agent Phone (18)
        IDX (195)
        Office Name (165)
        Type of Trees (495)
        Approximate Lot Size (145)
        Internet Remarks (115)
        On-Site Utilities (478)
        Usage Description (499)
        Development (462)
        List Price (137)
        Photo Instructions (184)
        Utilities Available (500)
        Development Name (466)
        Location (474)
        Rail Description (484)
        Zoning Information (318)
        Elevation Above Sea Level (467)
        ML# (157)
        Road Description (485)
        sysid (sysid)
        Folio Number (264)
        Min. SF Living Area Req'mt (475)
        Total Acreage (455)
        Last Transaction Date (131)
    */
    v_select('ResidentialLand') :=
     'sysid,90,113,115,131,137,145,157,165,184,195,214,264,318,455,462,466,467,474,475,477,478,484,485,487,495,499,500';

     /* Class 5 = Commercial Land
        #Parcels (477)
        Land Improvements (516)
        Special Information (538)
        Usage (545)
        Elevation Above Sea Level (508)
        List Price (137)
        Terms Considered (543)
        Utilities Available (546)
        Environmental Audit (509)
        ML# (157)
        Total Acreage (455)
        Virtual Tour (1223)
        Fill Description (469)
        Office Name (165)
        Type of Property (544)
        Zoning Information (318)
        Folio Number (264)
        On-Site Utilities (526)
        Type of Soil (487)
        IDX (195)
        Remarks (214)
        Type of Trees (542)
        Last Transaction Date (131)
    */     
    v_select('CommercialLand') :=
    'sysid,113,115,131,137,157,165,195,214,264,318,455,469,477,487,508,509,516,526,538,542,543,544,545,546,1223';
     /* Class 6 Residential Rental Properties */

     /* Class 7 = Commercial Property Codes
        #Buildings (642)
        #Units (671)
        List Price (137)
        Other Income Expense (527)
        #Floors (643)
        Folio Number (264)
        Lot Frontage (616)
        Real Estate Taxes (533)
        #Offices (646)
        Gross Operating Income (510)
        ML# (157)
        Zoning Information (318)
        #Parking Spaces (651)
        Gross Scheduled Income (512)
        Management Expense (619)
        sysid (sysid)
        #Stories (573)
        IDX (195)
        Miscellaneous Expense (632)
        #Tenants (647)
        Insurance Expense (514)
        Net Operating Income (416)
        #Toilets (648)
        Internet Remarks (115)
        Office Name (165)
        Remarks (214)
        Last Transaction Date (131)
    */
    v_select('CommercialProperty') :=
      'sysid,113,115,131,137,157,165,195,214,264,318,416,510,512,514,527,533,573,616,619,632,642,643,646,647,648,651,671';

     /* Class 8 = Business Opportunity
        #Employees (737)
        Folio Number (264)
        Net Operating Income (416)
        #Offices (646)
        IDX (195)
        Office Name (165)
        #Parking Spaces (651)
        Internet Remarks (115)
        Remarks (214)
        #Tenants (647)
        List Price (137)
        Virtual Tour (1223)
        #Toilets (648)
        ML# (157)
        sysid (sysid)
        Last Transaction Date (131)
    */
    v_select('Business') :=
      'sysid,113,115,131,137,157,165,195,214,264,416,646,647,648,651,737,1223';
      
     return v_select;
  end get_select_vals;

  function get_class_id(p_ltype in varchar2) return number is
    v_return number;
  begin
    if p_ltype = 'ResidentialProperty' then
       v_return := 1;
     elsif p_ltype = 'Condos' then
       v_return := 2;
     elsif p_ltype = 'IncomeProperty' then
       v_return := 3;
     elsif p_ltype = 'ResidentialLand' then
       v_return := 4;
     elsif p_ltype = 'CommercialLand' then
       v_return := 5;
     elsif p_ltype = 'CommercialProperty' then
       v_return := 7;
     elsif p_ltype = 'Business' then
       v_return := 8;
     else
       v_return := null;
     end if;
     return v_return;
  end get_class_id;

  function get_id( p_source_id  in mls_listings.source_id%type
                 , p_mls_number in mls_listings.mls_number%type)
                     return mls_listings.mls_id%type is
     
     cursor cur_mls( p_source_id  in mls_listings.source_id%type
                  , p_mls_number in mls_listings.mls_number%type) is
     select mls_id
     from mls_listings
     where source_id = p_source_id
     and mls_number = p_mls_number;
     
     v_return  mls_listings.mls_id%type := null;
  begin
    for m_rec in cur_mls(p_source_id, p_mls_number) loop
       v_return := m_rec.mls_id;
     end loop;
     return v_return;
  end get_id;
  
  function get_tax_id( p_mls_tax_id  in varchar2
                     , p_county      in varchar2)  
               return varchar2 is
     v_text        varchar2(32);
     v_tax_id      varchar2(32) := '';

  begin
    if p_county = 'DADE' then
      v_tax_id := replace(p_mls_tax_id, '-');
    else
      v_tax_id := p_mls_tax_id;
    end if;
    
     return v_tax_id;
  end get_tax_id;  

  function get_tax_source( p_county      in varchar2)  
               return tax_rec_type is
     v_text        varchar2(32);
     v_tax_id      varchar2(32);
     v_return      tax_rec_type;
  begin
    if p_county = 'BROWARD' then
         v_return.source_id :=  16; -- Broward Property Appraiser
          v_return.display_name := 'Broward County';
       v_return.link_name := 'BROWARD';
     elsif p_county = 'DADE' then
         v_return.source_id :=  23; -- Miami Dade Property Appraiser
          v_return.display_name := 'Miami Dade County';
       v_return.link_name := 'MIAMI-DADE';
        elsif p_county = 'PALMBCH' then
          v_return.source_id :=  60; -- Palm Beach Property Appraiser
          v_return.display_name := 'Palm Beach County';
          v_return.link_name := 'PALM BEACH';
     else
           v_return.source_id :=  null;
          v_return.display_name := null;
       v_return.link_name := null;
     end if;
     return v_return;
  end get_tax_source;

  procedure get_by_type( p_type    in varchar2
                       , p_county  in varchar2
                       , p_mode    in varchar2 := 'update') is
  begin
    delete from mls_rets_responses
    where source_id = global_src;
    commit;

    get_listings(p_type,     p_county, p_mode);
  end get_by_type;

  procedure process_listing ( p_mls_number   in varchar2
                            , p_query_type   in varchar2
                            , p_response     in xmltype
                            , p_county       in varchar2) is

     v_values            pr_rets_pkg.value_table;
     v_mls_id            MLS_LISTINGS.MLS_ID%TYPE;
     v_id                number;
     v_prop_id           pr_properties.prop_id%type;
     v_tax_id            varchar2(32);
     v_tax_rec           tax_rec_type;
     v_count             pls_integer;



  begin
    v_tax_rec := get_tax_source(p_county);

    if p_response is not null then
      v_values := pr_rets_pkg.get_compact_values(p_response, false);
    else
      v_values('validResponse') := 'N';
    end if;

    if v_values('validResponse') = 'Y' then

      --
      -- Find the property with matching Tax ID
      --
      begin
         v_tax_id := get_tax_id(v_values('264'), p_county);
         select prop_id
         into v_prop_id
         from pr_properties
         where source_pk = v_tax_id
         and source_id = v_tax_rec.source_id
         and regexp_like(zipcode,'^[[:digit:]]+$')
         and rownum = 1;
       exception
         when others then v_prop_id := null;
     end;
   else
      v_prop_id := null;
      pr_rets_pkg.put_line('Error in process_listing '||p_mls_number||' is invalid');
   end if;

   --
   -- Insert or update listing data for the property
   --
   if v_prop_id is not null then

      set_listing( p_query_type => p_query_type
                 , p_values     => v_values
                 , p_prop_id    => v_prop_id
                 , p_verified   => to_char(sysdate, 'mm/dd/yyyy  hh:mipm'));
   end if;

   --
   -- Insert or update listing data for the property
   --
   /*
    if v_prop_id is not null then
      select count(*)  into v_count
      from mls_listings
      where prop_id = v_prop_id;

      if (v_count = 1 and
           get_date_from_xml(v_values('MatrixModifiedDT')) < sysdate - 1) then
         set_active_listing(v_prop_id);
      else
         if p_query_type = 'CommercialProperty'
            then v_values('mfrID') := null;
         else
            v_values('mfrID') := get_mfr_id(v_values('MLSNumber'));
         end if;

         set_listing( p_query_type => p_query_type
                    , p_values     => v_values
                    , p_prop_id    => v_prop_id
                    , p_verified   => to_char(sysdate, 'mm/dd/yyyy  hh:mipm'));
      end if;
    end if;
    */
    commit;

  end process_listing;
  
  procedure get_listings( p_ltype     in varchar2
                        , p_county    in varchar2
                        , p_mode      in varchar2 := 'update') is
                        
    cursor cur_responses( p_query_type in varchar2
                        , p_source_id  in number) is
    select mls_number
    from mls_rets_responses
    where query_type = p_query_type
    and   source_id  = p_source_id;
    
    v_realm       varchar2(256);
    v_nonce       varchar2(256);
    v_seq         integer;
    v_opaque      varchar2(256);
    v_url         varchar2(4000);
    v_resp        UTL_HTTP.RESP;
    v_value       varchar2(256);
    x_content     xmltype;
    x_content2    xmltype;
    i             integer;
    v_str         varchar2(256);
    str_found     integer;
    v_values      pr_rets_pkg.value_table;
    v_select      pr_rets_pkg.value_table;
    v_ltype       pls_integer;
    v_mls_id      mls_listings.mls_id%type;
    v_session     varchar2(4000);
    v_xslt        xmltype;
    x_multi       xmltype;
    v_sysid       pls_integer;
    v_valid_response    boolean;
    v_data        varchar2(32767);
    x_data        xmltype;
    x_data2       xmltype;
     
    unsupported_county  exception;


  begin
    if p_county not in ('BROWARD', 'DADE', 'PALMBCH') then
       raise unsupported_county;
     end if;
    --
     -- Populate an array of Select values
     --
    v_select := get_select_vals;
     --
     -- Open a new RETS session
     --
--    pr_rets_pkg.put_line(to_char(sysdate, 'hh24:mi:ss')||' open connection');
    pr_rets_pkg.rets_login
          ( p_url     => global_login
          , p_user    => global_user
          , p_passwd  => global_passwd
          , p_realm   => v_realm
          , p_nonce   => v_nonce
          , p_seq     => v_seq
          , p_opaque  => v_opaque
          , p_session => v_session
          , p_uagent   => global_agent
          , p_uapasswd => global_passwd);
     --
     -- Get Active listing ID's
     --
     v_ltype := get_class_id(p_ltype);
     v_url := global_base
           ||'&Class='||v_ltype||'&Format=COMPACT-DECODED'
           ||'&QueryType=DMQL2&Query=(246=|A),(61=|'||p_county||')'
           ||'&Select='||v_select(p_ltype);
--           ||'&Select=sysid';

    v_resp := pr_rets_pkg.get_resp
               ( p_url     => v_url
               , p_session => v_session
               , p_uagent   => global_agent
               , p_uapasswd => global_passwd);
    x_content := pr_rets_pkg.get_xml(v_resp, false);

    v_xslt := xmltype(
'<?xml version=''1.0''?>
  <xsl:stylesheet version="1.0"
       xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml"
     omit-xml-declaration="no"/>

  <xsl:template match="/RETS">
    <RETS>
       <xsl:attribute name="ReplyCode">
           <xsl:value-of select="@ReplyCode"/>
       </xsl:attribute>

       <xsl:attribute name="ReplyText">
           <xsl:value-of select="@ReplyText"/>
       </xsl:attribute>

       <xsl:apply-templates select="//DELIMITER"/>
       <xsl:apply-templates select="//COLUMNS"/>
    </RETS>
  </xsl:template>

  <xsl:template match="DELIMITER">
       <DELIMITER>
         <xsl:attribute name="value">
           <xsl:value-of select="@value"/>
         </xsl:attribute>
      </DELIMITER>
  </xsl:template>

  <xsl:template match="COLUMNS">
       <COLUMNS>
         <xsl:value-of select="."/>
      </COLUMNS>
  </xsl:template>
  </xsl:stylesheet>
     ');

    --begin
      x_content2 := x_content.transform(xsl => v_xslt);
      v_valid_response := true;
 --   exception when others then
   --   v_valid_response := false;
    --end;

    if v_valid_response then
      pr_rets_pkg.put_line(to_char(sysdate, 'hh24:mi:ss')||' Loop XML');
      i := 1;
      v_str := '//RETS/DATA['||i||']';
      str_found := x_content.existsnode(v_str);
      while str_found = 1 loop
        x_data := x_content.extract(v_str);
        v_data := x_content.extract(v_str||'/text()').getStringVal();
        -- Extract sysid, first character is a tab, find 2nd tab and substr
        -- everything in between.
        v_sysid := substr(v_data,2, (instr(v_data, chr(9), 1, 2)-2));

        select APPENDCHILDXML(x_content2, '/RETS', x_data)
        into x_data2
        from dual;

        process_listing ( p_mls_number => v_sysid
                        , p_query_type => p_ltype
                        , p_response   => x_data2
                        , p_county     => p_county);

        i := i + 1;
        v_str := '//RETS/DATA['||i||']';
        str_found := x_content.existsnode(v_str);
      end loop;
    end if;

  end get_listings;
  
  procedure set_listing( p_query_type  in mls_rets_responses.query_type%type
                       , p_values      in pr_rets_pkg.value_table
                       , p_prop_id     in pr_properties.prop_id%type
                       , p_verified    in varchar2) is
     
    v_display_price     varchar2(32);
     v_listing_type      varchar2(32);
     v_broker            varchar2(64);
     v_short_desc        varchar2(4000);
     v_link_text         varchar2(128);
     v_desc              varchar2(4000);
     v_idx               varchar2(1);
     v_photo             varchar2(256);
     v_price             number;
     unknown_query_type  exception;
     null_values         exception;
     v_photo_count       pls_integer;
     v_mls_photo_count   pls_integer;
     v_list_date         date;
     v_geo_location      MLS_LISTINGS.GEO_LOCATION%TYPE;
     v_mls_id            mls_listings.mls_id%type;
     v_checksum          MLS_LISTINGS_V.CHECKSUM%TYPE;
     v_date_str          varchar2(32);
  begin
    --
     -- Check to see if broker has opted out of IDX
     --
     if p_values('195') like 'N%'  then
        v_idx := 'N';
     else
        v_idx := 'Y';
     end if;
     --
     -- Assemble listing data by query type
     --
     begin
       v_date_str := p_values('131');
       v_date_str := replace (v_date_str, 'T', ' ');
       v_list_date := to_date(v_date_str, 'yyyy-mm-dd hh24:mi:ss');
     exception
       when others then v_list_date := null;
     end;

     if p_query_type = 'ResidentialProperty' then
       v_display_price := to_char(p_values('137'), '$999,999,999');
       v_listing_type := 'Sale';
       v_broker := p_values('165');
       v_price := p_values('137');
       v_short_desc := substr(p_values('115'), 1, 128);
       v_desc := '<p>'||p_values('214')||'</p>'
                || '<table class="datatable">'
                || '<tr><th>Bedrooms</th><td>'||p_values('25')||'</td></tr>'
                || '<tr><th>Full Bathrooms</th><td>'||p_values('92')||'</td></tr>'
                || '<tr><th>Half Bathrooms</th><td>'||p_values('109')||'</td></tr>'
                || '<tr><th>High School</th><td>'||p_values('893')||'</td></tr>'
                || '<tr><th>Middle School</th><td>'||p_values('891')||'</td></tr>'
                || '<tr><th>Elementary School</th><td>'||p_values('886')||'</td></tr>'
                || '<tr><th>MLS Number</th><td>'||p_values('157')||'</td></tr>';
     
       if p_values('1223') is not null then
         v_desc := v_desc || '<tr><th>Virtual Tour</th><td><a href="'
                          ||p_values('1223')||'">'
                                ||p_values('1223')||'</a></td></tr>';
       end if;
       v_desc := v_desc|| '<tr><th>Verified</th><td>'||p_verified||'</td></tr>'
                      ||'</table>';
     elsif p_query_type = 'Condos' then
       v_display_price := to_char(p_values('137'), '$999,999,999');
       v_listing_type := 'Sale';
       v_broker := p_values('165');
       v_price := p_values('137');
       v_short_desc := substr(p_values('115'), 1, 128);
       v_desc := '<p>'||p_values('214')||'</p>'
                || '<table class="datatable">'
                || '<tr><th>Sq Ft</th><td>'||p_values('261')||'</td></tr>'
                || '<tr><th>Bedrooms</th><td>'||p_values('25')||'</td></tr>'
                || '<tr><th>Full Bathrooms</th><td>'||p_values('92')||'</td></tr>'
                || '<tr><th>Half Bathrooms</th><td>'||p_values('109')||'</td></tr>'
                || '<tr><th>Maintenance Charge/Month</th><td>'||p_values('348')||'</td></tr>'
                || '<tr><th>Maintenance Includes</th><td>'||p_values('347')||'</td></tr>'
                || '<tr><th>Carport Spaces</th><td>'||p_values('59')||'</td></tr>'
                || '<tr><th>Garage Spaces</th><td>'||p_values('102')||'</td></tr>'
                || '<tr><th>Pets Allowed</th><td>'||p_values('181')||'</td></tr>'
                || '<tr><th>Pet Restrictions</th><td>'||p_values('180')||'</td></tr>'
                || '<tr><th>High School</th><td>'||p_values('893')||'</td></tr>'
                || '<tr><th>Middle School</th><td>'||p_values('891')||'</td></tr>'
                || '<tr><th>Elementary School</th><td>'||p_values('886')||'</td></tr>'
                || '<tr><th>MLS Number</th><td>'||p_values('157')||'</td></tr>';

       if p_values('1223') is not null then
         v_desc := v_desc || '<tr><th>Virtual Tour</th><td><a href="'
                          ||p_values('1223')||'">'
                                ||p_values('1223')||'</a></td></tr>';
       end if;
       v_desc := v_desc|| '<tr><th>Verified</th><td>'||p_verified||'</td></tr>'
                      ||'</table>';
     elsif p_query_type = 'IncomeProperty' then
       v_display_price := to_char(p_values('137'), '$999,999,999');
       v_listing_type := 'Sale';
       v_broker := p_values('165');
       v_price := p_values('137');
       v_short_desc := substr(p_values('115'), 1, 128);
       v_desc := '<p>'||p_values('214')||'</p>'
                || '<table class="datatable">'
                || '<tr><th>Sq Ft</th><td>'||p_values('261')||'</td></tr>'
                || '<tr><th>Gross Rent</th><td>'||p_values('404')||'</td></tr>'
                || '<tr><th>Rent Includes</th><td>'||p_values('429')||'</td></tr>'
                || '<tr><th>Pool</th><td>'||p_values('191')||'</td></tr>'
                || '<tr><th>Assumable</th><td>'||p_values('22')||'</td></tr>'
                || '<tr><th>Terms Considered</th><td>'||p_values('444')||'</td></tr>'
                || '<tr><th>MLS Number</th><td>'||p_values('157')||'</td></tr>'
                || '<tr><th>Verified</th><td>'||p_verified||'</td></tr>'
                ||'</table>';
     elsif p_query_type = 'ResidentialLand' then
       v_display_price := to_char(p_values('137'), '$999,999,999');
       v_listing_type := 'Sale';
       v_broker := p_values('165');
       v_price := p_values('137');
       v_short_desc := substr(p_values('115'), 1, 128);
       v_desc := '<p>'||p_values('214')||'</p>'
                || '<table class="datatable">'
                || '<tr><th>Total Acreage</th><td>'||p_values('455')||'</td></tr>'
                || '<tr><th>Usage</th><td>'||p_values('499')||'</td></tr>'
                || '<tr><th>Zoning</th><td>'||p_values('318')||'</td></tr>'
                || '<tr><th>Elevation Above Sea Level</th><td>'||p_values('467')||'</td></tr>'
                || '<tr><th>Utilities Available</th><td>'||p_values('500')||'</td></tr>'
                || '<tr><th>On-Site Utilities</th><td>'||p_values('478')||'</td></tr>'
                || '<tr><th>Front Exposure</th><td>'||p_values('90')||'</td></tr>'
                || '<tr><th>Type of Soil</th><td>'||p_values('487')||'</td></tr>'
                || '<tr><th>Type of Trees</th><td>'||p_values('495')||'</td></tr>'
                || '<tr><th>MLS Number</th><td>'||p_values('157')||'</td></tr>'
                || '<tr><th>Verified</th><td>'||p_verified||'</td></tr>'
                ||'</table>';
     elsif p_query_type = 'CommercialLand' then
       v_display_price := to_char(p_values('137'), '$999,999,999');
       v_listing_type := 'Sale';
       v_broker := p_values('165');
       v_price := p_values('137');
       v_short_desc := substr(p_values('115'), 1, 128);
       v_desc := '<p>'||p_values('214')||'</p>'
                || '<table class="datatable">'
                || '<tr><th>Total Acreage</th><td>'||p_values('455')||'</td></tr>'
                || '<tr><th>Usage</th><td>'||p_values('545')||'</td></tr>'
                || '<tr><th>Zoning</th><td>'||p_values('318')||'</td></tr>'
                || '<tr><th>Elevation Above Sea Level</th><td>'||p_values('508')||'</td></tr>'
                || '<tr><th>Utilities Available</th><td>'||p_values('546')||'</td></tr>'
                || '<tr><th>On-Site Utilities</th><td>'||p_values('526')||'</td></tr>'
                || '<tr><th>Environmental Audit</th><td>'||p_values('509')||'</td></tr>'
                || '<tr><th>Type of Soil</th><td>'||p_values('487')||'</td></tr>'
                || '<tr><th>Fill Description</th><td>'||p_values('469')||'</td></tr>'
                || '<tr><th>Type of Trees</th><td>'||p_values('542')||'</td></tr>'
                || '<tr><th>MLS Number</th><td>'||p_values('157')||'</td></tr>'
                || '<tr><th>Verified</th><td>'||p_verified||'</td></tr>'
                ||'</table>';
     elsif p_query_type = 'CommercialProperty' then
       v_display_price := to_char(p_values('137'), '$999,999,999');
       v_listing_type := 'Sale/Lease';
       v_broker := p_values('165');
       v_price := p_values('137');
       v_short_desc := substr(p_values('115'), 1, 128);
       v_desc := '<p>'||p_values('214')||'</p>'
                || '<table class="datatable">'
                || '<tr><th>Zoning</th><td>'||p_values('318')||'</td></tr>'
                || '<tr><th>NOI Estimate</th><td>'||p_values('416')||'</td></tr>'
                || '<tr><th>Lot Frontage</th><td>'||p_values('616')||'</td></tr>'
                || '<tr><th>MLS Number</th><td>'||p_values('157')||'</td></tr>'
                || '<tr><th>Verified</th><td>'||p_verified||'</td></tr>'
                ||'</table>';
     elsif p_query_type = 'Business' then
       v_display_price := to_char(p_values('137'), '$999,999,999');
       v_listing_type := 'Sale/Lease';
       v_broker := p_values('165');
       v_price := p_values('137');
       v_short_desc := substr(p_values('115'), 1, 128);
       v_desc := '<p>'||p_values('214')||'</p>'
                || '<table class="datatable">'
                || '<tr><th>Net Operating Income</th><td>'||p_values('416')||'</td></tr>'
                || '<tr><th>MLS Number</th><td>'||p_values('157')||'</td></tr>'
                || '<tr><th>Verified</th><td>'||p_verified||'</td></tr>'
                ||'</table>';
     else
       raise unknown_query_type;
     end if;
     
     --
     -- Assemble the link text and geo coordinates
     --
     begin
       select initcap(address1), geo_location
       into v_link_text, v_geo_location
       from pr_properties
       where prop_id = p_prop_id;
       v_link_text := v_link_text||', '||v_display_price;
     exception
       when others then
         v_link_text := null;
     end;

     if v_short_desc is null then
       v_short_desc := 'Offered for '||v_listing_type||' at '||v_display_price;
     end if;
     --
     -- Verify we have data for all of the listing items
     --
    if (p_values('157') is null or
         v_listing_type        is null or
         v_price               is null or
         v_broker              is null or
         v_list_date           is null or
         v_short_desc          is null or
         v_link_text           is null or
         v_desc                is null) then
         raise null_values;
    end if;
     --
     -- Insert or update a record
     --
     
     
    v_mls_id := mls_listings_pkg.get_mls_id(global_src, p_values('sysid'));
     if v_mls_id is null then
        v_mls_id := mls_listings_pkg.insert_row
                      ( X_PROP_ID        => p_prop_id
                     , X_SOURCE_ID      => global_src
                     , X_MLS_NUMBER     => p_values('sysid')
                     , X_QUERY_TYPE     => p_query_type
                     , X_LISTING_TYPE   => v_listing_type
                     , X_LISTING_STATUS => 'ACTIVE'
                     , X_PRICE          => v_price
                     , X_IDX_YN         => v_idx
                     , X_LISTING_BROKER => v_broker
                     , X_LISTING_DATE   => v_list_date
                     , X_SHORT_DESC     => v_short_desc
                     , X_LINK_TEXT      => v_link_text
                     , X_DESCRIPTION    => v_desc
                     , X_LAST_ACTIVE    => sysdate
                     , X_GEO_LOCATION   => v_geo_location);
     
     else
       v_checksum := mls_listings_pkg.get_checksum(v_mls_id);
       mls_listings_pkg.update_row
                      ( X_MLS_ID         => v_mls_id
                      , X_PROP_ID        => p_prop_id
                      , X_SOURCE_ID      => global_src
                      , X_MLS_NUMBER     => p_values('sysid')
                      , X_QUERY_TYPE     => p_query_type
                      , X_LISTING_TYPE   => v_listing_type
                      , X_LISTING_STATUS => 'ACTIVE'
                      , X_PRICE          => v_price
                      , X_IDX_YN         => v_idx
                      , X_LISTING_BROKER => v_broker
                      , X_LISTING_DATE   => v_list_date - 1
                      , X_SHORT_DESC     => v_short_desc
                      , X_LINK_TEXT      => v_link_text
                      , X_DESCRIPTION    => v_desc
                      , X_LAST_ACTIVE    => sysdate
                      , X_CHECKSUM       => v_checksum);
     end if;
     --
     -- Find photos for the listing
     --
     v_mls_photo_count := to_number(nvl(p_values('113'), 0));
     select count(*)
     into v_photo_count
     from mls_photos
     where mls_id = v_mls_id;
     
     if v_photo_count !=  v_mls_photo_count then
       get_photos(p_values('sysid'), v_mls_photo_count, v_mls_id);
     end if;
     

     
     exception
       when unknown_query_type then
         pr_rets_pkg.put_line('Unknown query type: "'||p_query_type||'"');
          raise;
       when null_values then
         pr_rets_pkg.put_line('Found null values in: "'||p_values('sysid')||'"');
       when others then
         global_errors := global_errors + 1;
            if global_errors > 20 then
              raise;
            end if;
      
     end set_listing;
 
  procedure get_photos( p_sysid       in varchar2
                      , p_photo_count in number
                      , p_mls_id      in number) is

    v_photo_seq   pls_integer;

    v_url    varchar2(256);
    v_line   varchar2(4000);
  begin
    v_photo_seq := 0;
    delete from mls_photos
    where mls_id = p_mls_id;
    if p_photo_count > 0 then
      for i in 1 .. p_photo_count loop
        mls_photos_pkg.insert_row
                ( X_MLS_ID     => p_mls_id
                , X_PHOTO_SEQ  => i
                , X_PHOTO_URL  => 'https://visulate.com/images/mls/8/'||p_sysid||'-'||i||'.jpg'
                , X_PHOTO_DESC => null);
      end loop;
    end if;

  end get_photos;
  
  procedure update_price_ranges is
  begin
    mls_price_ranges_pkg.set_price_ranges('BROWARD', global_src);
    mls_price_ranges_pkg.set_price_ranges('MIAMI-DADE', global_src);
    mls_price_ranges_pkg.set_price_ranges('PALM BEACH', global_src);
  end update_price_ranges;
  
 
  
  procedure update_mls is
  begin
--    mls_price_ranges_pkg.update_static_pages;
    update_price_ranges;
    pr_rets_pkg.set_inactive(global_src);
     
  end update_mls;
 end mls_sef_pkg;
/  
show errors package mls_sef_pkg
show errors package body mls_sef_pkg

