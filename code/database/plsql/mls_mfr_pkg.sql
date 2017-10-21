set define ~
create or replace package mls_mfr_pkg as
/*******************************************************************************
   Copyright (c) Visulate 2011        All rights reserved worldwide
    Name:      mls_mfr_pkg
    Purpose:   MLS Replication API's 
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        24-MAR-12   Peter Goldthorp  Initial Version
    1.1        13-JUL-13                    Commercial Listings
    1.2        10-MAY-14                    Convert to Matrix
*******************************************************************************/
  global_errors    pls_integer   := 0;
  global_login     varchar2(256) := 'http://rets.mfrmls.com/contact/rets/login';
  global_user      varchar2(16)  := 'RETS534';
  global_passwd    varchar2(16)  := '7+Er+7aqeD';
  global_base      varchar2(256) := 'http://rets.mfrmls.com/contact/rets/search?SearchType=Property';
  global_src       number := 7; -- Florida Regional MLS
 

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
                       , p_mode in varchar2 := 'all');
  procedure get_listings(p_county in varchar2);
  
  procedure get_listings( p_ltype     in varchar2
                        , p_county    in varchar2
                        , p_mode      in varchar2 := 'all');
                        
  procedure set_listing( p_query_type  in varchar2
                       , p_values      in pr_rets_pkg.value_table
                       , p_prop_id     in pr_properties.prop_id%type
                       , p_verified    in varchar2) ;                       
                        
  procedure download_photos( p_sysid       in varchar2
                           , p_photo_count in number
                           , p_mls_id      in number) ;

  procedure get_photo_urls( p_mfr_id in varchar2
                          , p_mls_id in mls_photos.mls_id%type);

  procedure update_price_ranges;
  procedure update_mls;
end mls_mfr_pkg;
/  
                                   
create or replace package body mls_mfr_pkg as
/*******************************************************************************
   Copyright (c) Visulate 2011        All rights reserved worldwide
    Name:      mls_mfr_pkg
    Purpose:   MLS Replication API's 
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        31-MAR-12   Peter Goldthorp   Initial Version
*******************************************************************************/

  function get_mfr_id(p_mls_number in varchar2) return varchar2 is
   --
   -- Find the MFR ID
   --
     v_soap_request      varchar2(4000);
     x_mfr_id            xmltype;
     mfr_id              varchar2(256) := null;

  begin   
     v_soap_request:= '<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <PropertyMLLookup xmlns="http://tempuri.org/">
      <MLNum>'||p_mls_number||'</MLNum>
      <RectCoord>0,0,0,0</RectCoord>
    </PropertyMLLookup>
  </soap:Body>
</soap:Envelope>';
  
     x_mfr_id := pr_rets_pkg.soap_request( 'http://www.myfloridahomesmls.com/MyAjaxService.asmx'
                                              , v_soap_request);
     if  x_mfr_id.existsnode('//PropertyMLLookupResult') = 1 then   
         begin                                       
            mfr_id := x_mfr_id.extract('//PropertyMLLookupResult/text()').getStringVal();
            mfr_id := replace(mfr_id, 'MFR,');
            mfr_id := SUBSTR(mfr_id, 1 ,INSTR(mfr_id, ',', 1, 1)-1);
         exception
              when others then null;
         end;
     end if;
     return mfr_id;
   end get_mfr_id;
     

  function get_date_from_xml(p_date_str  in varchar2) return date is
    v_date_str  varchar2(32);
    v_date      date;
  begin
    v_date_str := replace(p_date_str, 'T', ' ');
    v_date_str := substr(v_date_str, 1, 19);
    v_date := to_date(v_date_str, 'yyyy-mm-dd hh24:mi:ss');
    return v_date;
  end get_date_from_xml;
  
  procedure set_active_listing(p_prop_id in pr_properties.prop_id%type) is
  begin
    update mls_listings
    set listing_status = 'ACTIVE'
    ,   last_active = sysdate
    where prop_id = p_prop_id;
  end set_active_listing;



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
         v_tax_id := get_tax_id(v_values('ParcelNumber'), p_county);
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
    commit;

  end process_listing;



  function get_select_vals return pr_rets_pkg.value_table is
    v_select pr_rets_pkg.value_table;
  begin
    v_select('ResidentialProperty') :=
'Matrix_Unique_ID,MLSNumber,BedsTotal,ListingContractDate,BathsFull,BathsHalf,ShowPropAddrOnInternetYN,ListPrice,ParcelNumber,ListOfficeName,SqFtHeated,FinancingAvailable,Pool,VirtualTourLink,PublicRemarksNew,MatrixModifiedDT,PhotoCount';
       
    v_select('CommercialProperty') :=
'Matrix_Unique_ID,MLSNumber,ParcelNumber,NetLeasableSqFt,SqFtGross,PropertyUse,ListingContractDate,ListPrice,RoadFrontage,LeasePrice,Zoning,ListOfficeName,ShowPropAddrOnInternetYN,PublicRemarksNew,MatrixModifiedDT,PhotoCount';
     
    v_select('IncomeProperty') :=
'Matrix_Unique_ID,MLSNumber,ParcelNumber,ListingContractDate,ListPrice,Zoning,ListOfficeName,VirtualTourLink,ShowPropAddrOnInternetYN,PublicRemarksNew,MatrixModifiedDT,FinancingAvailable,PhotoCount';

    v_select('VacantLand') :=
'Matrix_Unique_ID,MLSNumber,ParcelNumber,ListingContractDate,ListPrice,FinancingAvailable,ListOfficeName,LotSizeAcres,RoadFrontage,ShowPropAddrOnInternetYN,PublicRemarksNew,MatrixModifiedDT,PhotoCount';
     
    v_select('Rental') :=
'Matrix_Unique_ID,MLSNumber,ParcelNumber,BedsTotal,BathsFull,BathsHalf,DateAvailable,ListPrice,ListOfficeName,ShowPropAddrOnInternetYN,PublicRemarksNew,MatrixModifiedDT,PhotoCount';
     return v_select;
  end get_select_vals;

  function get_class_id(p_ltype in varchar2) return varchar2 is
    v_return varchar2(4);
  begin
    if p_ltype = 'ResidentialProperty' then
       v_return := 'RES';
     elsif p_ltype = 'CommercialProperty' then
       v_return := 'COM';
     elsif p_ltype = 'IncomeProperty' then
       v_return := 'INC';
     elsif p_ltype = 'Rental' then
       v_return := 'REN';
     elsif p_ltype = 'VacantLand' then
       v_return := 'VAC';
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
    if p_county = 'Orange' then
       v_text := replace(p_mls_tax_id, ' ', '');
       v_text := replace(p_mls_tax_id, '-', '');
       v_tax_id := substr(v_text, 5, 2);
       v_tax_id := v_tax_id||substr(v_text, 3, 2);
       v_tax_id := v_tax_id||substr(v_text, 1, 2);
       v_tax_id := v_tax_id||substr(v_text, 7);
     elsif p_county = 'Volusia' then
       select alt_key into v_tax_id
       from pr_volusia_ids
       where FULL_PARCEL_ID = replace(p_mls_tax_id, ' ', '')
       and rownum = 1;
     elsif p_county= 'Lake' then
       v_tax_id := replace(p_mls_tax_id, ' ', '');
     elsif p_county= 'Sarasota' then
       v_tax_id := replace(p_mls_tax_id, ' ', '-');
     elsif p_county= 'Hillsborough' then
       -- Convert P 35 28 21 ZZZ 000005 975400
       -- to        21 28 35 ZZZ 000005 975400P
       -- or      U-02-29-20-272-000001-00001.0
       -- to      202902272000001000010U
       -- then    212835ZZZ000005975400P
       v_text := replace(p_mls_tax_id, ' ', '');
       v_text := replace(p_mls_tax_id, '-', '');
       v_text := replace(p_mls_tax_id, '.', '');
       v_tax_id := substr(v_text, 6, 2);
       v_tax_id := v_tax_id||substr(v_text, 4, 2);
       v_tax_id := v_tax_id||substr(v_text, 2, 2);
       v_tax_id := v_tax_id||substr(v_text, 8);
       v_tax_id := v_tax_id||substr(v_text, 1, 1);
     elsif p_county= 'Pinellas' then
       -- Convert 10 29 15 22518 000 0630
       -- to      15 29 10 22518 000 0630
       -- then    152910225180000630
       v_text := p_mls_tax_id;
       v_tax_id := substr(v_text, 7, 3);
       v_tax_id := v_tax_id||substr(v_text, 4, 3);
       v_tax_id := v_tax_id||substr(v_text, 1, 3);
       v_tax_id := v_tax_id||substr(v_text, 9);
       v_tax_id := replace(v_tax_id, '-', ' ');                     
       v_tax_id := replace(v_tax_id, '  ', ' ');     
     elsif p_county= 'Pasco' then
       -- Convert 27 24 16 0000 04000 0020
       -- to      16 24 27 0000 04000 0020
       -- then    1624270000040000020
       v_text := replace(p_mls_tax_id, ' ', '');
       v_tax_id := substr(v_text, 5, 2);
       v_tax_id := v_tax_id||substr(v_text, 3, 2);
       v_tax_id := v_tax_id||substr(v_text, 1, 2);
       v_tax_id := v_tax_id||substr(v_text, 7);
     elsif p_county= 'Charlotte' then
       v_tax_id := p_mls_tax_id;
     elsif p_county= 'Polk' then
       v_tax_id := replace(p_mls_tax_id, ' ', '');
     elsif p_county= 'DeSoto' then
       v_tax_id := replace(p_mls_tax_id, ' ', '-');
     elsif p_county= 'Manatee' then
       v_tax_id := p_mls_tax_id;
     elsif p_county= 'Seminole' then
       v_tax_id := replace(p_mls_tax_id, ' ', '');
     elsif p_county= 'Hernando' then
       -- Has dirty data in MLS
       v_tax_id := p_mls_tax_id;
     elsif p_county= 'Sumter' then
       v_tax_id := p_mls_tax_id;
     elsif p_county= 'Marion' then
       v_tax_id := p_mls_tax_id;
     elsif p_county= 'Lee' then
       v_tax_id := replace(p_mls_tax_id, ' ', '');
     elsif p_county= 'Highlands' then
       v_tax_id := p_mls_tax_id;
     else
       v_tax_id := replace(p_mls_tax_id, ' ', '-');
     end if;
     
     return v_tax_id;
  end get_tax_id;  

  function get_tax_source( p_county      in varchar2)  
               return tax_rec_type is
     v_text        varchar2(32);
     v_tax_id      varchar2(32);
     v_return      tax_rec_type;
  begin
    if p_county = 'Orange' then
         v_return.source_id :=  5; -- Orange County Property Appraiser
          v_return.display_name := 'Orange County';
       v_return.link_name := 'ORANGE';
     elsif p_county = 'Volusia' then
         v_return.source_id :=  4; -- Volusia County Property Appraiser
          v_return.display_name := 'Volusia County';
       v_return.link_name := 'VOLUSIA';
        elsif p_county = 'Osceola' then
          v_return.source_id :=  59; -- Osceola County Property Appraiser
          v_return.display_name := 'Osceola County';
          v_return.link_name := 'OSCEOLA';
        elsif p_county = 'Brevard' then
          v_return.source_id :=  3; -- Brevard County Property Appraiser
          v_return.display_name := 'Brevard County';
          v_return.link_name := 'BREVARD';
        elsif p_county = 'Lake' then
          v_return.source_id := 45 ; -- Lake County Property Appraiser
          v_return.display_name := 'Lake County';
          v_return.link_name := 'LAKE';
         elsif p_county = 'Sarasota' then
          v_return.source_id := 68 ; -- Sarasota County Property Appraiser
          v_return.display_name := 'Sarasota County';
          v_return.link_name := 'SARASOTA';
         elsif p_county = 'Hillsborough' then
          v_return.source_id := 39; -- Hillsborough County Property Appraiser
          v_return.display_name := 'Hillsborough County';
          v_return.link_name := 'HILLSBOROUGH';
         elsif p_county = 'Pasco' then
          v_return.source_id := 61; -- Pasco County Property Appraiser
          v_return.display_name := 'Pasco County';
          v_return.link_name := 'PASCO';
         elsif p_county = 'Charlotte' then
          v_return.source_id := 18; -- Charlotte County Property Appraiser
          v_return.display_name := 'Charlotte County';
          v_return.link_name := 'CHARLOTTE';
        elsif p_county = 'Polk' then
          v_return.source_id := 63; -- Polk County Property Appraiser
          v_return.display_name := 'Polk County';
          v_return.link_name := 'POLK';
        elsif p_county = 'DeSoto' then
          v_return.source_id := 24; -- DeSoto County Property Appraiser
          v_return.display_name := 'DeSoto County';
          v_return.link_name := 'DESOTO';
         elsif p_county = 'Manatee' then
          v_return.source_id := 51; -- Manatee County Property Appraiser
          v_return.display_name := 'Manatee County';
          v_return.link_name := 'MANATEE';
         elsif p_county = 'Seminole' then
          v_return.source_id := 69; -- Seminole County Property Appraiser
          v_return.display_name := 'Seminole County';
          v_return.link_name := 'SEMINOLE';
         elsif p_county = 'Hernando' then
          v_return.source_id := 37; -- Hernando County Property Appraiser
          v_return.display_name := 'Hernando County';
          v_return.link_name := 'HERNANDO';
         elsif p_county = 'Sumter' then
          v_return.source_id := 70; -- Sumter County Property Appraiser
          v_return.display_name := 'Sumter County';
          v_return.link_name := 'SUMTER';
        elsif p_county = 'Marion' then
          v_return.source_id := 52; -- Marion County Property Appraiser
          v_return.display_name := 'Marion County';
          v_return.link_name := 'MARION';  
        elsif p_county = 'Lee' then
          v_return.source_id := 46; -- Lee County Property Appraiser
          v_return.display_name := 'Lee County';
          v_return.link_name := 'LEE';
         elsif p_county = 'Highlands' then
          v_return.source_id := 38; -- Highlands County Property Appraiser
          v_return.display_name := 'Highlands County';
          v_return.link_name := 'HIGHLANDS';
         elsif p_county = 'Pinellas' then
          v_return.source_id := 62; -- Pinellas County Property Appraiser
          v_return.display_name := 'Pinellas County';
          v_return.link_name := 'PINELLAS';
         
     else
           v_return.source_id :=  null;
          v_return.display_name := null;
       v_return.link_name := null;
     end if;
     return v_return;
  end get_tax_source;

  procedure get_by_type( p_type in varchar2
                       , p_mode in varchar2 := 'all') is
  begin
    get_listings(p_type,     'Orange', p_mode);
    get_listings(p_type,     'Osceola', p_mode);
    get_listings(p_type,     'Lake', p_mode);
    get_listings(p_type,     'Sarasota', p_mode);
    get_listings(p_type,     'Hillsborough', p_mode);
    get_listings(p_type,     'Pinellas', p_mode);
    get_listings(p_type,     'Pasco', p_mode);
    get_listings(p_type,     'Charlotte', p_mode);
    get_listings(p_type,     'Polk', p_mode);
    get_listings(p_type,     'DeSoto', p_mode);
    get_listings(p_type,     'Manatee', p_mode);
    get_listings(p_type,     'Seminole', p_mode);
    get_listings(p_type,     'Hernando', p_mode);
    get_listings(p_type,     'Sumter', p_mode);
    get_listings(p_type,     'Marion', p_mode);
    get_listings(p_type,     'Lee', p_mode);
    get_listings(p_type,     'Highlands', p_mode);
    get_listings(p_type,     'Volusia', p_mode);
  end get_by_type;



  
  procedure get_listings(p_county      in varchar2) is
  begin
     get_listings('ResidentialProperty', p_county);
     get_listings('CommercialProperty', p_county);
     get_listings('IncomeProperty', p_county);
     get_listings('VacantLand', p_county);
     -- get_listings('Rental', p_county);
  end get_listings;
  
  
  procedure get_listings( p_ltype     in varchar2
                        , p_county    in varchar2
                        , p_mode      in varchar2 := 'all') is
                        
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
    v_ltype       varchar2(4);
    v_mls_id      mls_listings.mls_id%type;
    v_session     varchar2(4000);
    v_xslt        xmltype;
    x_multi       xmltype;
    x_data        xmltype;
    x_data2       xmltype;
    v_data        varchar2(32767);
    v_Matrix_Unique_ID  pls_integer;
    v_valid_response    boolean;
     
    unsupported_county  exception;


  begin
    if p_county not in ('Orange', 'Volusia', 'Brevard', 'Osceola', 'Lake', 'Sarasota', 'Hillsborough', 'Pinellas',
                        'Pasco', 'Charlotte', 'Polk', 'DeSoto', 'Manatee', 'Seminole', 'Hernando', 'Sumter',
                        'Marion', 'Lee', 'Highlands') then
       raise unsupported_county;
     end if;
    --
     -- Populate an array of Select values
     --
    v_select := get_select_vals;
     --
     -- Open a new RETS session
     --
    pr_rets_pkg.put_line(to_char(sysdate, 'hh24:mi:ss')||' open connection');
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

     v_url := global_base -- Pull all active listings
               ||'&Class=Listing&PropertyType='||v_ltype
               ||'&Format=COMPACT-DECODED&QueryType=DMQL2'
               ||'&Query=(Status=ACT),(CountyorParish='||p_county||')'
               ||',(PropertyType='||v_ltype||')'
               ||'&Select='||v_select(p_ltype);
     v_seq := v_seq + 1;
     v_resp := pr_rets_pkg.get_resp
                   ( p_url        => v_url
                   , p_user       => global_user
                   , p_passwd     => global_passwd
                   , p_realm      => v_realm
                   , p_nonce      => v_nonce
                   , p_seq        => v_seq
                   , p_opaque     => v_opaque
                   , p_session    => v_session);
                                      
     x_multi := pr_rets_pkg.get_xml(v_resp, false);

    
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

    begin
      x_content2 := x_multi.transform(xsl => v_xslt);
      v_valid_response := true;
    exception when others then
      v_valid_response := false;
    end;
    
    if v_valid_response then
      pr_rets_pkg.put_line(to_char(sysdate, 'hh24:mi:ss')||' Loop XML');     
      i := 1;
      v_str := '//RETS/DATA['||i||']';
      str_found := x_multi.existsnode(v_str);
      while str_found = 1 loop
        x_data := x_multi.extract(v_str);
        v_data := x_multi.extract(v_str||'/text()').getStringVal();
        -- Extract Matrix ID, first character is a tab, find 2nd tab and substr
        -- everything in between.
        v_Matrix_Unique_ID := substr(v_data,2, (instr(v_data, chr(9), 1, 2)-2));
      
      
        select APPENDCHILDXML(x_content2, '/RETS', x_data)
        into x_data2
        from dual;
      
        process_listing ( p_mls_number => v_Matrix_Unique_ID
                        , p_query_type => p_ltype 
                        , p_response   => x_data2
                        , p_county     => p_county);

        i := i + 1;
        v_str := '//RETS/DATA['||i||']';
        str_found := x_multi.existsnode(v_str);
      end loop;
    end if;
    
    pr_rets_pkg.put_line(p_ltype||' '||p_county||' '||i||' Listings found');
    commit;
    
    pr_rets_pkg.put_line(to_char(sysdate, 'hh24:mi:ss')||' End XSLT');                   
  end get_listings;
  
  procedure set_listing( p_query_type  in varchar2
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
     if p_values('ShowPropAddrOnInternetYN') like 'N%'  then
        v_idx := 'N';
     else
        v_idx := 'Y';
     end if;
     --
     -- Assemble listing data by query type
     --
     begin
       if p_query_type = 'Rental' then
         v_date_str := p_values('DateAvailable');
       else
         v_date_str := p_values('ListingContractDate');
       end if;
       v_date_str := replace (v_date_str, 'T', ' ');
       v_date_str := substr(v_date_str, 1, 19);
       v_list_date := to_date(v_date_str, 'yyyy-mm-dd hh24:mi:ss');
       /*
     exception
       when others then v_list_date := null;*/
     end;

     if p_query_type = 'ResidentialProperty' then
       v_display_price := '$'||p_values('ListPrice');
       v_listing_type := 'Sale';
       v_broker := p_values('ListOfficeName');
       v_price := to_number(replace(p_values('ListPrice'), ','));
       v_short_desc := p_values('BedsTotal')||' bedroom '
                     ||p_values('BathsFull')||' bath '
                         ||to_char(p_values('SqFtHeated'),'999,999')||' Sq Ft';
       v_desc := '<p>'||p_values('PublicRemarksNew')||'</p>'
                || '<table class="datatable">'
                || '<tr><th>Bedrooms</th><td>'||p_values('BedsTotal')||'</td></tr>'
                || '<tr><th>Full Bathrooms</th><td>'||p_values('BathsFull')||'</td></tr>'
                || '<tr><th>Half Bathrooms</th><td>'||p_values('BathsHalf')||'</td></tr>'
                || '<tr><th>Finance Options</th><td>'||p_values('FinancingAvailable')||'</td></tr>'
                || '<tr><th>MFH ID</th><td><a style="text-decoration: none;" href="http://www.myfloridahomesmls.com/SiteContent/PropDetail.aspx?N=0&S=MFR&ID='
                ||p_values('mfrID')||'"><span style="text-decoration: none; color: black;">'||p_values('MLSNumber')||'</span></a></td></tr>';
     
       if p_values('VirtualTourLink') is not null then
         v_desc := v_desc || '<tr><th>Virtual Tour</th><td><a href="'
                          ||p_values('VirtualTourLink')||'">'
                                ||p_values('VirtualTourLink')||'</a></td></tr>';
       end if;
       v_desc := v_desc|| '<tr><th>Last Updated</th><td>'||p_verified||'</td></tr>'
                      ||'</table>';
     elsif p_query_type = 'CommercialProperty' then
       v_display_price := '$'||p_values('ListPrice');
       v_listing_type := 'Sale/Lease';
       v_broker := p_values('ListOfficeName');
       v_price := to_number(replace(p_values('ListPrice'), ','));
       v_short_desc := to_char(p_values('SqFtGross'),'999,999')
                       ||' Sq Ft '||p_values('PropertyUse');
       v_desc := '<p>'||p_values('PublicRemarksNew')||'</p>'
              || '<table class="datatable">'
                || '<tr><th>Current Use</th><td>'||p_values('PropertyUse')||'</td></tr>'
                || '<tr><th>Zoning</th><td>'||p_values('Zoning')||'</td></tr>'
                || '<tr><th>Sq.Ft. Gross</th><td>'||p_values('SqFtGross')||'</td></tr>'
                || '<tr><th>Net Leasable Sq.Ft</th><td>'||p_values('NetLeasableSqFt')||'</td></tr>'
                || '<tr><th>Road Frontage</th><td>'||p_values('RoadFrontage')||'</td></tr>'
                || '<tr><th>Last Updated</th><td>'||p_verified||'</td></tr>'
                ||'</table>';
     elsif p_query_type = 'IncomeProperty' then
       v_display_price := '$'||p_values('ListPrice');
       v_listing_type := 'Sale';
       v_broker := p_values('ListOfficeName');
       v_price := to_number(replace(p_values('ListPrice'), ','));
       v_short_desc := 'Investment Property';
       v_desc := '<p>'||p_values('PublicRemarksNew')||'</p>'
              || '<table class="datatable">'
                || '<tr><th>Finance Options</th><td>'||p_values('879')||'</td></tr>'
                || '<tr><th>Zoning</th><td>'||p_values('Zoning')||'</td></tr>'
                || '<tr><th>Last Updated</th><td>'||p_verified||'</td></tr>'
                ||'</table>';
     elsif p_query_type = 'VacantLand' then
       v_display_price := '$'||p_values('ListPrice');
       v_listing_type := 'Sale';
       v_broker := p_values('ListOfficeName');
       v_price := to_number(replace(p_values('ListPrice'), ','));
       v_short_desc := to_char(p_values('LotSizeAcres'),'999,999.99')||' Acre ';
       v_desc := '<p>'||p_values('PublicRemarksNew')||'</p>'
              || '<table class="datatable">'
              || '<tr><th>Road Frontage</th><td>'||p_values('RoadFrontage')||'</td></tr>'
              || '<tr><th>MFH ID</th><td><a style="text-decoration: none;" href="http://www.myfloridahomesmls.com/SiteContent/PropDetail.aspx?N=0&S=MFR&ID='
                ||p_values('mfrID')||'"><span style="text-decoration: none; color: black;">'||p_values('MLSNumber')||'</span></a></td></tr>'
                || '<tr><th>Last Updated</th><td>'||p_verified||'</td></tr>'
                ||'</table>';
     elsif p_query_type = 'Rental' then
       v_display_price := '$'||p_values('ListPrice')||'/ month';
       v_listing_type := 'Rent';
       v_broker := p_values('ListOfficeName');
       v_price := to_number(replace(p_values('ListPrice'), ','));
       v_short_desc := p_values('BedsTotal')||' bedroom '
                     ||p_values('BathsFull')||' bath ';
       v_desc := '<p>'||p_values('PublicRemarksNew')||'</p>'
              || '<table class="datatable">'
--                || '<tr><th>Available</th><td>'||to_char(p_values('DateAvailable'), 'mm/dd/yyyy')||'</td></tr>'
                || '<tr><th>Bedrooms</th><td>'||p_values('BedsTotal')||'</td></tr>'
                || '<tr><th>Full Bathrooms</th><td>'||p_values('BathsFull')||'</td></tr>'
                || '<tr><th>Half Bathrooms</th><td>'||p_values('BathsHalf')||'</td></tr>'
                || '<tr><th>MFH ID</th><td><a style="text-decoration: none;" href="http://www.myfloridahomesmls.com/SiteContent/PropDetail.aspx?N=0&S=MFR&ID='
                ||p_values('mfrID')||'"><span style="text-decoration: none; color: black;">'||p_values('MLSNumber')||'</span></a></td></tr>'
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
    if (p_values('MLSNumber') is null or 
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
     
     
    v_mls_id := mls_listings_pkg.get_mls_id(global_src, p_values('Matrix_Unique_ID'));
     if v_mls_id is null then
        v_mls_id := mls_listings_pkg.insert_row
                      ( X_PROP_ID        => p_prop_id
                     , X_SOURCE_ID      => global_src
                     , X_MLS_NUMBER     => p_values('Matrix_Unique_ID')
                     , X_QUERY_TYPE     => p_query_type
                     , X_LISTING_TYPE   => v_listing_type
                     , X_LISTING_STATUS => 'ACTIVE'
                     , X_PRICE          => v_price
                     , X_IDX_YN         => v_idx
                     , X_LISTING_BROKER => v_broker
                     , X_LISTING_DATE   => sysdate
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
                     , X_MLS_NUMBER     => p_values('Matrix_Unique_ID')
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

     v_mls_photo_count := to_number(nvl(p_values('PhotoCount'), 0));
     select nvl(count(*), 0)
     into v_photo_count
     from mls_photos
     where mls_id = v_mls_id;

     if v_photo_count !=  v_mls_photo_count then

 download_photos(p_values('Matrix_Unique_ID'), v_mls_photo_count, v_mls_id);
/*
       if p_query_type = 'CommercialProperty' then
         download_photos(p_values('Matrix_Unique_ID'), v_mls_photo_count, v_mls_id);
       elsif (v_photo_count < 2 and
              p_values('mfrID') is not null) then
         get_photo_urls(p_values('mfrID'), v_mls_id);
       end if;*/
     end if;
/*     
        select count(*)
        into v_photo_count
        from mls_photos
        where mls_id = v_mls_id;
     
        if (v_photo_count < 2 and 
            p_values('mfrID') is not null) then
         get_photos(p_values('mfrID'), v_mls_id);
        end if;
     */
     exception
       when unknown_query_type then
         pr_rets_pkg.put_line('Unknown query type: "'||p_query_type||'"');
          raise;
       when null_values then
         pr_rets_pkg.put_line('Found null values in: "'||p_values('Matrix_Unique_ID')||'"');
       when others then
         pr_rets_pkg.put_line(SUBSTR(SQLERRM, 1, 64)||' in '||p_values('Matrix_Unique_ID')||'"');       
     end set_listing;
     


  procedure download_photos( p_sysid       in varchar2
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
                , X_PHOTO_URL  => 'https://visulate.com/images/mls/7/'||p_sysid||'-'||i||'.jpg'
                , X_PHOTO_DESC => null);
      end loop;
    end if;

  end download_photos;
  
  
  procedure get_photo_urls( p_mfr_id in varchar2
                          , p_mls_id in mls_photos.mls_id%type) is
  v_photo_list   xmltype;
  i              pls_integer;
  v_str          varchar2(256);
  str_found      number;
  v_value        varchar2(1024);
  v_photo_seq    pls_integer;
  v_mfr_id       pls_integer;
  v_soap_request varchar2(4000);
  
  
  begin

    v_soap_request:= '<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetAuxPhotos xmlns="http://tempuri.org/">
      <Source>MFR</Source>
      <SysID>'||p_mfr_id||'</SysID>
    </GetAuxPhotos>
  </soap:Body>
</soap:Envelope>';
  
    v_photo_list := pr_rets_pkg.soap_request( 'http://www.myfloridahomesmls.com/MyAjaxService.asmx'
                                            , v_soap_request);
  
    delete from mls_photos
    where mls_id = p_mls_id;
    i := 1;
    v_photo_seq := 0;
    v_str := '//GetAuxPhotosResult/string['||i||']';
    str_found := v_photo_list.existsnode(v_str);
    while str_found = 1 loop
      v_value := v_photo_list.extract(v_str||'/text()').getStringVal();
       v_value := replace(v_value, '&amp;', '&');
       v_value := replace(v_value, '|');
       if length(v_value) < 246 then
         v_photo_seq := v_photo_seq + 1;
        mls_photos_pkg.insert_row
            ( X_MLS_ID     => p_mls_id
            , X_PHOTO_SEQ  => v_photo_seq
            , X_PHOTO_URL  => 'http://'||v_value
            , X_PHOTO_DESC => null);
       end if;
      i := i + 1;
      v_str := '//GetAuxPhotosResult/string['||i||']';
      str_found := v_photo_list.existsnode(v_str);
    end loop;
     
  end get_photo_urls;

  procedure update_price_ranges is
  begin
    mls_price_ranges_pkg.set_price_ranges('ORANGE', global_src);
    mls_price_ranges_pkg.set_price_ranges('LAKE', global_src);
    mls_price_ranges_pkg.set_price_ranges('SARASOTA', global_src);
    mls_price_ranges_pkg.set_price_ranges('HILLSBOROUGH', global_src);
    mls_price_ranges_pkg.set_price_ranges('PINELLAS', global_src);
    mls_price_ranges_pkg.set_price_ranges('PASCO', global_src);
    mls_price_ranges_pkg.set_price_ranges('CHARLOTTE', global_src);
    mls_price_ranges_pkg.set_price_ranges('POLK', global_src);
    mls_price_ranges_pkg.set_price_ranges('DESOTO', global_src);
    mls_price_ranges_pkg.set_price_ranges('MANATEE', global_src);
    mls_price_ranges_pkg.set_price_ranges('SEMINOLE', global_src);
    mls_price_ranges_pkg.set_price_ranges('HERNANDO', global_src);
    mls_price_ranges_pkg.set_price_ranges('SUMTER', global_src);
    mls_price_ranges_pkg.set_price_ranges('MARION', global_src);
    mls_price_ranges_pkg.set_price_ranges('LEE', global_src);
    mls_price_ranges_pkg.set_price_ranges('HIGHLANDS', global_src);
    mls_price_ranges_pkg.set_price_ranges('ALACHUA', global_src);
    mls_price_ranges_pkg.set_price_ranges('VOLUSIA', global_src);
  end update_price_ranges;
  
 
  
  procedure update_mls is
  begin
    get_by_type('CommercialProperty');
    get_by_type('ResidentialProperty');
    get_by_type('IncomeProperty');
    get_by_type('VacantLand');
--    mls_price_ranges_pkg.get_rentals;
    mls_price_ranges_pkg.update_static_pages('MFR');

    update_price_ranges;
    pr_rets_pkg.set_inactive(global_src);
     
  end update_mls;
 end mls_mfr_pkg;
/  
show errors package mls_mfr_pkg
show errors package body mls_mfr_pkg

