set define ~
create or replace package mls_brevard_pkg as
/*******************************************************************************
   Copyright (c) Visulate 2011, 2013        All rights reserved worldwide
    Name:      mls_brevard_pkg
    Purpose:   MLS Replication API's 
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        24-MAR-12   Peter Goldthorp  Initial Version
    1.1        13-JUL-13                    Commercial Listings
    2.0         3-Aug-13                    Converted from MFR
*******************************************************************************/
  global_errors    pls_integer   := 0;
  global_login     varchar2(256) := 'http://retsgw.flexmls.com:80/rets2_0/Login';
  global_user      varchar2(16)  := 'spc.rets.3222516';
  global_passwd    varchar2(16)  := 'enapt-ulent90';
  global_base      varchar2(256) := 'http://retsgw.flexmls.com/rets2_0/Search?SearchType=Property';
  global_src       number := 6; -- Brevard MLS
 

  type tax_rec_type is record
  ( source_id           number
  , display_name        varchar2(256)
  , link_name           varchar2(32));
  
  function get_select_vals return pr_rets_pkg.value_table;

  function get_id( p_source_id  in mls_listings.source_id%type
                 , p_mls_number in mls_listings.mls_number%type)
                     return mls_listings.mls_id%type;

  function get_tax_source
               return tax_rec_type;
               
  procedure get_by_type( p_type in varchar2
                       , p_mode in varchar2 := 'update');
  procedure get_listings;
  procedure process_listings;
  
  procedure get_listings( p_ltype     in varchar2
                        , p_mode      in varchar2 := 'update');
                        
  procedure process_listings( p_ltype   in varchar2);
  procedure get_photos( p_prop_id in number
                      , p_mls_id  in number);     

  procedure update_price_ranges;
  procedure update_mls;
end mls_brevard_pkg;
/  
                                   
create or replace package body mls_brevard_pkg as
/*******************************************************************************
   Copyright (c) Visulate 2011        All rights reserved worldwide
    Name:      mls_brevard_pkg
    Purpose:   MLS Replication API's 
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        7-AUG-13   Peter Goldthorp   Copied from MFR MLS
*******************************************************************************/


  function get_select_vals return pr_rets_pkg.value_table is
    v_select pr_rets_pkg.value_table;
  begin
    /* 
     LIST_1   = Internal Listing ID
     LIST_87  = Modification Timestamp
     LIST_104 = Display on Public Wesites
     LIST_105 = ListingID
     LIST_133 = Picture Count
     LIST_10  = Listing Date
     LIST_15  = Listing Status
     LIST_21  = Original Price
     LIST_22  = List Price
     LIST_46  = Geo Lat
     LIST_47  = Geo Lon
     LIST_48  = Living SqFt
     LIST_66  = Bedrooms
     LIST_67  = Bathrooms
     LIST_69  = Half Baths
     LIST_78  = Public Comments
     listing_office_name
     FEAT20130303191402055377000000 - HOA amount
     FEAT20130303191418283689000000 - HOA period
     GF20130226183428681591000000   - HOA Includes
     GF20130606024608499268000000   - Finance Options
     GF20130614153345482319000000   - Rental Restrictions
     UNBRANDEDIDXVIRTUALTOUR        - Virtual Tour

     LIST_73 = Tax Account
     LIST_80 = Tax ID
     LIST_9  = Commercial Prop Type
     LIST_74 = Zoning
     LIST_75 = Taxes
     LIST_57=Lot Acres
     LIST_31  = Street Number
     LIST_33  = Street Direction Prefix
     LIST_34  = Street Name
     LIST_35  = Unit Number
     LIST_37  = Street Suffix
     LIST_39  = City
     LIST_43  = Zipcode
    */

    -- A = ResidentialProperty
    v_select('A') := 'LIST_105,LIST_73,LIST_80,LIST_87,LIST_104,LIST_1,LIST_133,LIST_10,LIST_21,LIST_22,LIST_48,LIST_66,LIST_67,LIST_69,LIST_78,listing_office_name,FEAT20130303191402055377000000,FEAT20130303191418283689000000,GF20130226183428681591000000,GF20130606024608499268000000,GF20130614153345482319000000,UNBRANDEDIDXVIRTUALTOUR';
    
    -- B=MultiFamily 
    v_select('B') := 'LIST_105,LIST_73,LIST_80,LIST_74,LIST_87,LIST_104,LIST_1,LIST_133,LIST_10,LIST_21,LIST_22,LIST_48,LIST_78,listing_office_name';
    
    -- E=CommonInterest 
    v_select('E') := 'LIST_105,LIST_73,LIST_80,LIST_9,LIST_74,LIST_75,LIST_87,LIST_104,LIST_1,LIST_133,LIST_10,LIST_21,LIST_22,LIST_48,LIST_78,listing_office_name';
    
    -- C=LotsAndLand
    v_select('C') := 'LIST_105,LIST_73,LIST_80,LIST_74,LIST_87,LIST_104,LIST_1,LIST_133,LIST_10,LIST_21,LIST_22,LIST_57,LIST_78,listing_office_name,LIST_75';
    


     return v_select;
  end get_select_vals;

  function get_query_vals return pr_rets_pkg.value_table is
    v_query pr_rets_pkg.value_table;
  begin
    -- A = ResidentialProperty
    v_query('A')  := '(LIST_15=|1536QBU2R0NU)';
    -- B=MultiFamily
    v_query('B')  := '(LIST_15=|153ZGBGME03J)';
    -- E=CommonInterest
    v_query('E')  := '(LIST_15=|1541KRF6YST9)';
    -- C=LotsAndLand
    v_query('C')  := '(LIST_15=|154185HUKG4P)';
    return v_query;
  end get_query_vals;


  function get_class_id(p_ltype in varchar2) return varchar2 is
    v_return varchar2(1);
  begin
    if p_ltype = 'ResidentialProperty' then
       v_return := 'A';
     elsif p_ltype = 'CommercialProperty' then
       v_return := 'E';
     elsif p_ltype = 'IncomeProperty' then
       v_return := 'B';
     elsif p_ltype = 'VacantLand' then
       v_return := 'C';
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
  

  function get_tax_source  
               return tax_rec_type is
     v_text        varchar2(32);
     v_tax_id      varchar2(32);
     v_return      tax_rec_type;
  begin
     v_return.source_id :=  3; -- Brevard County Property Appraiser
     v_return.display_name := 'Brevard County';
     v_return.link_name := 'BREVARD';
     return v_return;
  end get_tax_source;

  procedure get_by_type( p_type in varchar2
                       , p_mode in varchar2 := 'update') is
  begin
    delete from mls_rets_responses
    where source_id = global_src;
    commit;

    get_listings(p_type, p_mode);
    process_listings(p_type);

  end get_by_type;

  
  procedure get_listings is
  begin
    delete from mls_rets_responses
     where source_id = global_src;
     commit;
     get_listings('ResidentialProperty');
     get_listings('CommercialProperty');
     get_listings('IncomeProperty');
     get_listings('VacantLand');

  end get_listings;
  
  procedure process_listings is
  begin
     process_listings('ResidentialProperty');
     process_listings('CommercialProperty');
     process_listings('IncomeProperty');
     process_listings('VacantLand');

  end process_listings;
  
  procedure get_listings( p_ltype     in varchar2
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
    v_query       pr_rets_pkg.value_table;
    v_ltype       varchar2(1);
    v_mls_id      mls_listings.mls_id%type;
    v_session     varchar2(4000);
    v_xslt        xmltype;
    x_multi       xmltype;
     
    unsupported_county  exception;


  begin
    --
     -- Populate an array of Select values
     --
    v_select := get_select_vals;
    v_query  := get_query_vals;
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
          , p_session => v_session);
     --
     -- Get Active listing ID's
     --
     v_ltype := get_class_id(p_ltype);
     v_url := global_base
           ||'&Class='||v_ltype||'&Format=COMPACT-DECODED'
           ||'&QueryType=DMQL2&Query='||v_query(v_ltype)
           ||'&Select=LIST_105';

           v_resp := pr_rets_pkg.get_resp
                     ( p_url     => v_url
                     , p_user    => global_user
                     , p_passwd  => global_passwd
                     , p_realm   => v_realm
                     , p_nonce   => v_nonce
                     , p_seq     => v_seq
                     , p_opaque  => v_opaque
                     , p_session => v_session);        

 --   v_resp := pr_rets_pkg.get_resp( p_url     => v_url
 --                                  , p_session => v_session);
    x_content := pr_rets_pkg.get_xml(v_resp, true);
     --
     -- Loop through each Listing ID and find the listing details.
     -- Write the result in mls_rets_responses
     --
    i := 1;
    v_str := '/RETS/DATA['||i||']';
    str_found := x_content.existsnode(v_str);
    v_seq := 2;
    while str_found = 1 loop  
      v_value := x_content.extract(v_str||'/text()').getStringVal();
      v_value := regexp_substr(v_value, '[0-9]+');
      
      begin
        select mls_id into v_mls_id
        from mls_listings
        where mls_number = v_value
        and   query_type = p_ltype
        and   source_id  = global_src;

        update mls_listings
        set last_active = sysdate
        where mls_id = v_mls_id;
        commit;
      exception
        when no_data_found then null;
        when others then raise;
      end;
      
      insert into mls_rets_responses( mls_number
                                    , date_found
                                    , query_type
                                    , processed_yn
                                    , source_id)
      values (v_value, sysdate, p_ltype, 'N', global_src);
      commit;

      
      i := i + 1;
      v_str := '/RETS/DATA['||i||']';
      str_found := x_content.existsnode(v_str);
          -- Uncomment the following line for testing
      -- if i > 30 then str_found := 0; end if;
    end loop;
/*
    if p_mode = 'update' then -- Query new listings only
        v_url := global_base
               ||'&Class='||v_ltype
               ||'&Format=COMPACT-DECODED&QueryType=DMQL2'
               ||'&Query=(LIST_15=|1536QBU2R0NU),(LIST_87='
               ||to_char((sysdate - 1),'yyyy-mm-dd')||'T00:00:00%2B)'
               ||'&Select='||v_select(v_ltype);
        v_seq := v_seq + 1;
        v_resp := pr_rets_pkg.get_resp
                     ( p_url     => v_url
                     , p_user    => global_user
                     , p_passwd  => global_passwd
                     , p_realm   => v_realm
                     , p_nonce   => v_nonce
                     , p_seq     => v_seq
                     , p_opaque  => v_opaque
                     , p_session => v_session);
        x_multi := pr_rets_pkg.get_xml(v_resp, false);
    else
*/    
        v_url := global_base -- Pull all active listings
               ||'&Class='||v_ltype
               ||'&Format=COMPACT-DECODED&QueryType=DMQL2'
               ||'&Query='||v_query(v_ltype)
               ||'&Select='||v_select(v_ltype);
        v_seq := v_seq + 1;
        v_resp := pr_rets_pkg.get_resp
                     ( p_url     => v_url
                     , p_user    => global_user
                     , p_passwd  => global_passwd
                     , p_realm   => v_realm
                     , p_nonce   => v_nonce
                     , p_seq     => v_seq
                     , p_opaque  => v_opaque
                     , p_session => v_session);                               
        x_multi := pr_rets_pkg.get_xml(v_resp, false);
/*        
    end if;
*/
      
    for l_rec in cur_responses(p_ltype, global_src) loop
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
       <xsl:apply-templates select="//DATA"/>
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

  <xsl:template match="DATA">
       <xsl:variable name="mls_data" select="normalize-space()"/>
       <xsl:if test="starts-with($mls_data, '''||l_rec.mls_number||''')">
       <DATA>

         <xsl:value-of select="."/>
      </DATA>
      </xsl:if>
  </xsl:template>
  </xsl:stylesheet>
     ');

      x_content2 := x_multi.transform(xsl => v_xslt);
      
      if x_content2 is not null then
            update mls_rets_responses
            set response = x_content2
            where mls_number = l_rec.mls_number
            and query_type   = p_ltype
            and source_id    = global_src;
      else
            update mls_rets_responses
            set processed_yn = 'Y'
            where mls_number = l_rec.mls_number
            and query_type   = p_ltype
            and source_id    = global_src;
            pr_rets_pkg.put_line('skipped mls # '||l_rec.mls_number);
      end if;
      commit;
    end loop;      
  end get_listings;
  
  procedure set_listing( p_query_type  in mls_rets_responses.query_type%type
                       , p_values      in pr_rets_pkg.value_table
                       , p_prop_id     in pr_properties.prop_id%type
                       , p_verified    in varchar2) is
     
    v_display_price     varchar2(32);
     v_listing_type      varchar2(32);
     v_broker            varchar2(64);
     v_short_desc        varchar2(128);
     v_link_text         varchar2(128);
     v_desc              varchar2(4000);
     v_idx               varchar2(1);
     v_photo             varchar2(256);
     v_price             number;
     unknown_query_type  exception;
     null_values         exception;
     v_photo_count       pls_integer;
     v_list_date         date;
     v_geo_location      MLS_LISTINGS.GEO_LOCATION%TYPE;
     v_mls_id            mls_listings.mls_id%type;
     v_checksum          MLS_LISTINGS_V.CHECKSUM%TYPE;
     v_date_str          varchar2(32);
  begin
    --
     -- Check to see if broker has opted out of IDX
     --
     if p_values('LIST_104') like 'N%'  then
        v_idx := 'N';
     else
        v_idx := 'Y';
     end if;
     --
     -- Assemble listing data by query type
     --
     begin
       v_date_str := p_values('LIST_87');

       v_date_str := replace (v_date_str, 'T', ' ');
       v_list_date := to_date(substr(v_date_str, 1, 19), 'yyyy-mm-dd hh24:mi:ss');
     exception
       when others then
       pr_rets_pkg.put_line (substr(v_date_str, 1, 19));

       raise;
       --v_list_date := null;
     end;
     v_display_price := to_char(p_values('LIST_22'), '$99,999,999');
     if p_query_type = 'ResidentialProperty' then
       
       v_listing_type := 'Sale';
       v_broker := p_values('listing_office_name');
       v_price := to_number(replace(p_values('LIST_22'), ','));
       v_short_desc := p_values('LIST_66')||' bedroom '
                     ||p_values('LIST_67')||' bath '
                         ||to_char(p_values('LIST_48'),'999,999')||' Sq Ft';
       v_desc := '<p>'||p_values('LIST_78')||'</p>'
              || '<table class="datatable">'
              || '<tr><th>Bedrooms</th><td>'||p_values('LIST_66')||'</td></tr>'
              || '<tr><th>Full Bathrooms</th><td>'||p_values('LIST_67')||'</td></tr>'
              || '<tr><th>Half Bathrooms</th><td>'||p_values('LIST_69')||'</td></tr>'
              || '<tr><th>Finance Options</th><td>'||p_values('GF20130606024608499268000000')||'</td></tr>'
              || '<tr><th>MLS Number</th><td>'||p_values('LIST_105')||'</td></tr>';

       if p_values('GF20130614153345482319000000') is not null then
           v_desc := v_desc  
              || '<tr><th>Rental Restrictions</th><td>'||p_values('GF20130614153345482319000000')||'</td></tr>';
       end if;

       if p_values('FEAT20130303191402055377000000') is not null then
           v_desc := v_desc
              || '<tr><th>HOA amount</th><td>'||p_values('FEAT20130303191402055377000000')||'</td></tr>'
              || '<tr><th>HOA period</th><td>'||p_values('FEAT20130303191418283689000000')||'</td></tr>'
              || '<tr><th>HOA Includes</th><td>'||p_values('GF20130226183428681591000000')||'</td></tr>';
       end if;
       v_desc := v_desc|| '<tr><th>Last Updated</th><td>'||p_verified||'</td></tr>'
                      ||'</table>';
     elsif p_query_type = 'CommercialProperty' then
       v_listing_type := 'Sale/Lease';
       v_broker := p_values('listing_office_name');
       v_price := to_number(replace(p_values('LIST_22'), ','));
       v_short_desc := to_char(p_values('LIST_48'),'999,999')
                       ||' Sq Ft '||p_values('LIST_9');
       v_desc := '<p>'||p_values('LIST_78')||'</p>'
              || '<table class="datatable">'
                || '<tr><th>Current Use</th><td>'||p_values('LIST_9')||'</td></tr>'
                || '<tr><th>Zoning</th><td>'||p_values('LIST_74')||'</td></tr>'
                || '<tr><th>Sq.Ft. Gross</th><td>'||p_values('LIST_48')||'</td></tr>'
                || '<tr><th>Taxes</th><td>'||p_values('LIST_75')||'</td></tr>'
                || '<tr><th>Last Updated</th><td>'||p_verified||'</td></tr>'
                || '<tr><th>MLS Number</th><td>'||p_values('LIST_105')||'</td></tr>'
                ||'</table>';
     elsif p_query_type = 'IncomeProperty' then
       v_listing_type := 'Sale';
       v_broker := p_values('listing_office_name');
       v_price := to_number(replace(p_values('LIST_22'), ','));
       v_short_desc := 'Investment Property';
       v_desc := '<p>'||p_values('LIST_78')||'</p>'
              || '<table class="datatable">'
              || '<tr><th>Zoning</th><td>'||p_values('LIST_74')||'</td></tr>'
              || '<tr><th>MLS Number</th><td>'||p_values('LIST_105')||'</td></tr>'
              || '<tr><th>Last Updated</th><td>'||p_verified||'</td></tr>'
              ||'</table>';
     elsif p_query_type = 'VacantLand' then
       v_listing_type := 'Sale';
       v_broker := p_values('listing_office_name');
       v_price := to_number(replace(p_values('LIST_22'), ','));
       v_short_desc := to_char(p_values('LIST_57'),'999,999.99')||' Acre ';
       v_desc := '<p>'||p_values('LIST_78')||'</p>'
              || '<table class="datatable">'
                || '<tr><th>Taxes</th><td>'||p_values('LIST_75')||'</td></tr>'
                || '<tr><th>MLS Number</th><td>'||p_values('LIST_105')||'</td></tr>'
                || '<tr><th>Last Updated</th><td>'||p_verified||'</td></tr>'
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
     
     --
     -- Verify we have data for all of the listing items
     --
     
    if (p_values('LIST_105') is null or
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
     
     
    v_mls_id := mls_listings_pkg.get_mls_id(global_src, p_values('LIST_105'));
     if v_mls_id is null then
        v_mls_id := mls_listings_pkg.insert_row
                      ( X_PROP_ID        => p_prop_id
                      , X_SOURCE_ID      => global_src
                      , X_MLS_NUMBER     => p_values('LIST_105')
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
                      , X_MLS_NUMBER     => p_values('LIST_105')
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
                      , X_CHECKSUM       => v_checksum);
     end if;
     --
     -- Find photos for the listing
     --
     
        select count(*)
        into v_photo_count
        from mls_photos
        where mls_id = v_mls_id;
     
        if v_photo_count < 1 then
         get_photos(p_prop_id, v_mls_id);
        end if;
     
     /*
     exception
       when unknown_query_type then
         pr_rets_pkg.put_line('Unknown query type: "'||p_query_type||'"');
          raise;
       when null_values then
         pr_rets_pkg.put_line('Found null values in: "'||p_values('LIST_105')||'"');
       when others then
--         global_errors := global_errors + 1;
--            if global_errors > 20 then
              raise;
--            end if;
*/
     end set_listing;
 
  
  procedure get_photos( p_prop_id in number
                      , p_mls_id  in number) is

    cursor cur_photos(p_prop_id in number) is
    select url
    from pr_property_photos
    where prop_id = p_prop_id;
    v_photo_seq   pls_integer;
  
  begin
    v_photo_seq := 0;
    delete from mls_photos
    where mls_id = p_mls_id;

    for p_rec in cur_photos(p_prop_id) loop
      v_photo_seq := v_photo_seq + 1;
      mls_photos_pkg.insert_row
            ( X_MLS_ID     => p_mls_id
            , X_PHOTO_SEQ  => v_photo_seq
            , X_PHOTO_URL  => p_rec.url
            , X_PHOTO_DESC => null);
    end loop;
     
  end get_photos;




  procedure process_listings( p_ltype  in varchar2) is
    cursor cur_listings(p_ltype  in varchar2) is
       select mls_number
       ,      date_found
       ,      query_type
       ,      response
       from mls_rets_responses
       where query_type = p_ltype
       and processed_yn = 'N'
       and source_id = global_src;
     
     v_values      pr_rets_pkg.value_table;
     v_mls_id      MLS_LISTINGS.MLS_ID%TYPE;
     v_id          number;
     v_prop_id     pr_properties.prop_id%type;
     v_tax_id      varchar2(32);
     v_tax_rec     tax_rec_type;
     v_found       boolean := false;
     no_listings_found exception;

     v_count       pls_integer;

  begin
    v_tax_rec := get_tax_source;
    for l_rec in cur_listings(p_ltype) loop
       --
       -- Read a record from mls_rets_responses
       --
       v_values := pr_rets_pkg.get_compact_values(l_rec.response, false);
       v_id := l_rec.mls_number;
       --
       -- Mark it as processed
       --
       update mls_rets_responses
       set processed_yn = 'Y'
       where mls_number = l_rec.mls_number
       and source_id = global_src;

       --
       -- Find the property with matching Tax ID
       --
       begin
         v_tax_id := v_values('LIST_73');
       exception
         when others then v_tax_id := 'NO TAX ID';
       end;

       select count(*)
       into v_count
       from pr_properties
       where source_pk = v_tax_id
       and source_id = v_tax_rec.source_id;

       if v_count > 0 then
            select prop_id
            into v_prop_id
            from pr_properties
            where source_pk = v_tax_id
            and source_id = v_tax_rec.source_id
            and rownum = 1;
      else
        v_prop_id := null;
      end if;

       --
       -- Insert or update listing data for the property
       --
       if v_prop_id is not null then
         v_found := true;
         set_listing( p_query_type => l_rec.query_type
                    , p_values     => v_values
                    , p_prop_id    => v_prop_id
                    , p_verified   => to_char(l_rec.date_found, 'mm/dd/yyyy  hh:mipm'));
       end if;
      commit;
    end loop;
    if v_found then
      null;
    else
      raise no_listings_found;
    end if;
     
  exception
    when no_listings_found then
      pr_rets_pkg.put_line('No listings found');
    when others then
     pr_rets_pkg.put_line('Error in process_listings on MLS# '||v_id);
     raise;
  end process_listings;
  
  procedure update_price_ranges is
  begin
    mls_price_ranges_pkg.set_price_ranges('BREVARD', global_src);
  end update_price_ranges;
  
 
  
  procedure update_mls is
  begin
    get_by_type('CommercialProperty');
    get_by_type('ResidentialProperty');
    get_by_type('IncomeProperty');
    get_by_type('VacantLand');
    
    update_price_ranges;
     --
     -- Mark old listings as inactive
     --
    pr_rets_pkg.set_inactive(global_src);
     
  end update_mls;
 end mls_brevard_pkg;
/  
show errors package mls_brevard_pkg
show errors package body mls_brevard_pkg

