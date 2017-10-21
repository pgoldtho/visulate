create or replace package pr_rets_pkg as
/*******************************************************************************
   Copyright (c) Visulate 2011        All rights reserved worldwide
    Name:      PR_RETS_PKG
    Purpose:   MLS Replication API's 
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        12-DEC-11   Peter Goldthorp   Initial Version
    1.1        21-APR-12                     Modify for MFR MLS
    1.11        1-SEP-13                     Support for RETS-UA-Authorization
*******************************************************************************/
  --
  -- Package Types
  -- 
  type name_value_type  is record ( name  varchar2(256)
                                  , value varchar2(4048));
  type name_value_table is table of name_value_type 
     index by pls_integer;

  type value_table is table of varchar2(4048)
     index by varchar2(256);

  --
  -- Print http headers using dbms_output
  --
  procedure prn_http_headers(p_resp in out UTL_HTTP.resp);
  
  --
  -- Extract parameter value from response values.  For example,
  -- get_str( 'Digest realm="rets.offutt-innovia.com",nonce="2bb321aeba9"'
  --        , 'realm');
  -- returns 'rets.offutt-innovia.com'
  --
  function get_str( p_str   in varchar2
                  , p_param in varchar2) return varchar2;
  --
  -- Generate a lowercase md5 hash for a given input string.
  --
  function getMD5(in_string in varchar2)  return varchar2;
  
  --
  -- Login to a RETS server
  --
  procedure rets_login( p_url        in varchar2
                      , p_user       in varchar2
                      , p_passwd     in varchar2
                      , p_realm      out varchar2
                      , p_nonce      out varchar2
                      , p_seq        out integer
                      , p_opaque     out varchar2
                      , p_session    out varchar2
                      , p_uagent     in  varchar2 := null
                      , p_uapasswd   in  varchar2 := null);

  --
  -- Make an http request to a server that uses Digest Authentication
  --
  function get_resp( p_url        in varchar2
                   , p_user       in varchar2
                   , p_passwd     in varchar2
                   , p_realm      in varchar2
                   , p_nonce      in varchar2
                   , p_seq        in integer
                   , p_opaque     in varchar2
                   , p_session    in varchar2
                   , p_uagent     in varchar2 := null
                   , p_uapasswd   in varchar2 := null)
     return UTL_HTTP.resp;
  --
  -- Make an http request to a server without using Digest Authentication
  --
  function get_resp( p_url        in varchar2
                   , p_session    in varchar2 := null
                   , p_uagent     in varchar2 := null
                   , p_uapasswd   in varchar2 := null)
    return UTL_HTTP.resp; 
  --
  -- Read the http response and convert to xml. Close the response and 
  -- optionally display the xml via dbms_output.put_line.  
  -- Note: Wraps <DATA> content in CDATA section for use with COMPACT responses.
  -- Should only be used for STANDARD documents that are known to be well formed.
  --
  function get_xml( p_resp    in out UTL_HTTP.resp
                  , p_debug   in boolean  := FALSE) return xmltype;
        
  --
  -- Convert Compact XML into a table of name:value pairs.
  --
  function read_compact_xml( p_xml in xmltype
                           , p_debug in boolean := FALSE)
    return name_value_table;
  --
  -- Wrapper for read_compact_xml.  Returns x(name) = value.
  --
  function get_compact_values( p_xml   in xmltype
                             , p_debug in boolean := FALSE)
    return value_table;
        
  --
  -- Print long lines via dbms_output
  --
  procedure put_line(p_data in varchar2);

  
  
  --
  -- Read the http response for a COMPACT or COMPACT-DECODED
  -- RETS request.  Return as a table of name:value pairs.
  --
  function read_compact_request( p_resp  in out UTL_HTTP.resp
                               , p_debug in boolean := FALSE)
    return name_value_table;

  --
  -- Wrapper for read_compact_request.  Returns x(name) = value.
  --
  function read_compact_values( p_resp  in out UTL_HTTP.resp
                              , p_debug in boolean := FALSE)
    return value_table;
        
  --
  -- Archive old listings
  --
  procedure set_inactive(p_source_id in mls_listings.source_id%type);

  function soap_request( p_url in varchar2
                       , p_soap_request in varchar2) return xmltype;
end pr_rets_pkg;
/

create or replace package body pr_rets_pkg as
/*******************************************************************************
   Copyright (c) Visulate 2011        All rights reserved worldwide
    Name:      PR_RETS_PKG
    Purpose:   MLS Replication API's 
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        12-DEC-11   Peter Goldthorp   Initial Version
*******************************************************************************/

  procedure prn_http_headers(p_resp in out UTL_HTTP.resp) is
    v_name     varchar2(4000);
    v_value    varchar2(4000);
  begin
    put_line('------------------------------------------');
        FOR i IN 1..UTL_HTTP.GET_HEADER_COUNT(p_resp) LOOP
      UTL_HTTP.GET_HEADER(p_resp, i, v_name, v_value);
      PUT_LINE(v_name || ': ' || v_value);
    END LOOP;
  end prn_http_headers;
  
  function get_str( p_str   in varchar2
                  , p_param in varchar2) return varchar2 is
    v_extract  varchar2(4000);
  begin
    v_extract := regexp_substr(p_str, p_param||'=("[^"]*"|[^,"]*)');
    v_extract := replace(v_extract, '"', '');
    v_extract := replace(v_extract, p_param||'=', '');
        put_line(p_param||' = '||v_extract);
    return(v_extract);
  end get_str;

  function get_jsessionid( p_str   in varchar2) return varchar2 is
    v_extract  varchar2(4000);
  begin
    v_extract := regexp_substr(p_str, 'JSESSIONID=\w+');
    return(v_extract);
  end get_jsessionid;
  

  function getMD5(in_string in varchar2)  return varchar2 as
    cln_md5raw raw(2000);
    out_raw raw(16);
  begin
    cln_md5raw := utl_raw.cast_to_raw(in_string);
    dbms_obfuscation_toolkit.md5(input=>cln_md5raw,checksum=>out_raw);
    -- return hex version (32 length)
    return lower(rawtohex(out_raw));
  end getMD5;
  
  procedure rets_login( p_url        in varchar2
                      , p_user       in varchar2
                      , p_passwd     in varchar2
                      , p_realm      out varchar2
                      , p_nonce      out varchar2
                      , p_seq        out integer
                      , p_opaque     out varchar2
                      , p_session    out varchar2
                      , p_uagent     in  varchar2 := null
                      , p_uapasswd   in  varchar2 := null) is
        v_req         UTL_HTTP.req;
        v_resp        UTL_HTTP.resp;
        v_auth_str    varchar2(4048);
        v_cookie_str  varchar2(4048);
        v_ua_auth_str varchar2(4048);

  begin
    p_seq := 1;
    v_req := utl_http.begin_request( p_url, 'GET', utl_http.HTTP_VERSION_1_1 );
    if p_uagent is not null then
      utl_http.set_header( v_req, 'User-Agent', p_uagent );
      v_ua_auth_str := getMD5(p_uagent||':'||p_uapasswd);
      utl_http.set_header( v_req, 'RETS-UA-Authorization'
                         , 'Digest '||getMD5(v_ua_auth_str||':VIS2013::RETS/1.5'));
    else
      utl_http.set_header( v_req, 'User-Agent', 'RETSConnector/1.0' );
    end if;

    utl_http.set_header( v_req, 'Content-Length', '0');
    utl_http.set_header( v_req, 'Connection', 'keep-alive');
    utl_http.set_header( v_req, 'RETS-Version', 'RETS/1.5');
    utl_http.set_header( v_req, 'RETS-Request-ID', 'VIS2013');
    
    v_resp := UTL_HTTP.GET_RESPONSE(v_req);
    --prn_http_headers(v_resp);
    
    IF (v_resp.status_code = UTL_HTTP.HTTP_UNAUTHORIZED) THEN
       if lower(p_url) like '%rets.interealty.com%' then
         utl_http.get_header_by_name(v_resp, 'WWW-Authenticate', v_auth_str, 2);
       else
         utl_http.get_header_by_name(v_resp, 'WWW-Authenticate', v_auth_str, 1);
         utl_http.get_header_by_name(v_resp, 'Set-Cookie', v_cookie_str, 1);
       end if;
    END IF;
        
    p_realm   := get_str(v_auth_str, 'realm');
    p_nonce   := get_str(v_auth_str, 'nonce');
    p_opaque  := get_str(v_auth_str, 'opaque');
    p_session := get_jsessionid(v_cookie_str);

    IF (v_resp.status_code = UTL_HTTP.HTTP_UNAUTHORIZED) THEN
          --prn_http_headers(v_resp);
          UTL_HTTP.end_response(v_resp);
          v_resp := pr_rets_pkg.get_resp
                     ( p_url      => p_url
                     , p_user     => p_user
                     , p_passwd   => p_passwd
                     , p_realm    => p_realm
                     , p_nonce    => p_nonce
                     , p_seq      => p_seq
                     , p_opaque   => p_opaque
                     , p_session  => p_session
                     , p_uagent   => p_uagent
                     , p_uapasswd => p_uapasswd );

       if lower(p_url) like '%rets.interealty.com%' then
         utl_http.get_header_by_name(v_resp, 'Set-Cookie', v_cookie_str, 2);
         p_session := v_cookie_str;         
       end if;

    END IF;
        
    --prn_http_headers(v_resp);
    UTL_HTTP.end_response(v_resp);

  end rets_login;

  function get_resp( p_url        in varchar2
                   , p_user       in varchar2
                   , p_passwd     in varchar2
                   , p_realm      in varchar2
                   , p_nonce      in varchar2
                   , p_seq        in integer
                   , p_opaque     in varchar2
                   , p_session    in varchar2
                   , p_uagent     in varchar2 := null
                   , p_uapasswd   in varchar2 := null)
     return UTL_HTTP.resp is
        v_nc        varchar2(256);
        v_cnonce    varchar2(256);
        v_response  varchar2(256);
        v_ha1       varchar2(256);
        v_ha2       varchar2(256);
        v_req       UTL_HTTP.req;
        v_resp      UTL_HTTP.resp;
        v_hash_str  varchar2(4048);
        v_ua_auth_str varchar2(4048);        
  begin
    v_nc := lower(UTL_RAW.CAST_FROM_BINARY_INTEGER(p_seq ));
    v_cnonce := lower(dbms_crypto.randombytes(8));

    v_ha1 := getMD5(p_user||':'||p_realm||':'||p_passwd);
    v_ha2 := getMD5('GET:'||p_url);
    -- if qop != auth then
    -- v_hash_str := v_ha1||':'||v_nonce||':'||v_ha2;
    v_hash_str := v_ha1||':'||p_nonce||':'||v_nc||':'||v_cnonce||':auth:'||v_ha2;
    v_response := getMD5(v_hash_str);
    
    UTL_HTTP.SET_TRANSFER_TIMEOUT(360);
    v_req := utl_http.begin_request( p_url, 'GET', utl_http.HTTP_VERSION_1_1 );
    if p_uagent is not null then
      utl_http.set_header( v_req, 'User-Agent', p_uagent );
      v_ua_auth_str := getMD5(p_uagent||':'||p_uapasswd);
      utl_http.set_header( v_req, 'RETS-UA-Authorization'
                         , 'Digest '||getMD5(v_ua_auth_str||':VIS2013::RETS/1.5'));
    else
      utl_http.set_header( v_req, 'User-Agent', 'RETSConnector/1.0' );
    end if;
    utl_http.set_header( v_req, 'Content-Length', '0');
    utl_http.set_header( v_req, 'Connection', 'keep-alive');
    utl_http.set_header( v_req, 'RETS-Version', 'RETS/1.5');
    utl_http.set_header( v_req, 'RETS-Request-ID', 'VIS2013');
    utl_http.set_header( v_req, 'Cookie', p_session);
    utl_http.set_header( v_req, 'Authorization'
                       , 'Digest username="'||p_user||'", realm="'||p_realm||'", nonce="'||p_nonce||'",'
                                            ||'uri="'||p_url||'", qop=auth, nc='||v_nc||','
                                            ||'cnonce="'||v_cnonce||'", response="'||v_response||'",'
                                            ||'opaque="'||p_opaque||'"');


    v_resp := UTL_HTTP.GET_RESPONSE(v_req);
    return v_resp;
  end get_resp;
  
  
  function get_resp( p_url        in varchar2
                   , p_session    in varchar2 := null
                   , p_uagent     in varchar2 := null
                   , p_uapasswd   in varchar2 := null)
    return UTL_HTTP.resp is
          v_req       UTL_HTTP.req;
        v_resp      UTL_HTTP.resp;
        v_status    varchar2(1024);
        v_ua_auth_str varchar2(4048);        
  begin
    UTL_HTTP.SET_TRANSFER_TIMEOUT(360);
    v_req := utl_http.begin_request( p_url, 'GET', utl_http.HTTP_VERSION_1_1 );
    if p_uagent is not null then
      utl_http.set_header( v_req, 'User-Agent', p_uagent );
      v_ua_auth_str := getMD5(p_uagent||':'||p_uapasswd);
      utl_http.set_header( v_req, 'RETS-UA-Authorization'
                         , 'Digest '||getMD5(v_ua_auth_str||':VIS2013:'||p_session||':RETS/1.5'));
    else
      utl_http.set_header( v_req, 'User-Agent', 'RETSConnector/1.0' );
    end if;
    utl_http.set_header( v_req, 'Content-Length', '0');
    utl_http.set_header( v_req, 'Connection', 'keep-alive');
    utl_http.set_header( v_req, 'RETS-Version', 'RETS/1.5');
    utl_http.set_header( v_req, 'RETS-Request-ID', 'VIS2013');
        
    utl_http.set_response_error_check(enable => TRUE);
    utl_http.set_detailed_excp_support(enable => TRUE);
    
    if p_session is not null then
      utl_http.set_header( v_req, 'Cookie', p_session);
    end if;
    v_resp := UTL_HTTP.GET_RESPONSE(v_req);
--    v_status := v_resp.status_code;
    return v_resp;
  exception
    WHEN utl_http.request_failed THEN
      put_line('Request Failed: ' || utl_http.get_detailed_sqlerrm);
    WHEN utl_http.http_server_error THEN
      put_line('Server Error: ' || utl_http.get_detailed_sqlerrm);
    WHEN utl_http.http_client_error THEN
      put_line('Client Error: ' || utl_http.get_detailed_sqlerrm);
    when others then
      put_line('Call to '||p_url||' with '||p_session);
      put_line('Failed with '||utl_http.get_detailed_sqlerrm);
      put_line('Response Status: '|| v_status);
      raise;     
  end get_resp;
        
  
  function get_xml( p_resp  in out UTL_HTTP.resp
                  , p_debug in boolean    := FALSE) return xmltype is
    v_return         xmltype;
    v_cdoc           clob;
    v_line           varchar2(32767);
    http401exception exception;
    v_xtest          xmltype;
  begin
    DBMS_LOB.createtemporary(v_cdoc, FALSE);
    BEGIN
      LOOP
        utl_http.read_text(p_resp, v_line, 16384);
        --utl_http.read_line(p_resp, v_line, true);
        --v_line := replace(v_line, '<DATA>', '<DATA><![CDATA[');
        --v_line := replace(v_line, '</DATA>', ']]></DATA>');
        if v_line like '%HTTP Status 401%' then
          raise http401exception;
        end if;

        if p_debug = TRUE then
           put_line(v_line);
        end if;
        -- verify v_line is a valid XML element before appending to response
        begin
          if v_line like '%</%' then
            DBMS_LOB.writeappend (v_cdoc, LENGTH(v_line), v_line);
          end if;
        exception
          when others then 
            put_line('Skipped'||chr(10)||v_line);
        end;
      END LOOP;
    EXCEPTION
       WHEN utl_http.end_of_body THEN
            utl_http.end_response(p_resp);
       when http401exception then
            utl_http.end_response(p_resp);
            v_cdoc := '<RETS ReplyCode="20207" ReplyText="Unauthorized Query"/>';
    END;
    if length(v_cdoc) = 0 then
        v_cdoc := '<RETS ReplyCode="20201" ReplyText="No Records Found"/>';
        put_line('<RETS ReplyCode="20201" ReplyText="No Records Found"/>');
    end if;

    begin
        v_return := xmltype(v_cdoc);
    exception
     when others then
       v_cdoc := '<RETS ReplyCode="20201" ReplyText="Invalid XML"/>';
       put_line('<RETS ReplyCode="20201" ReplyText="Invalid XML"/>');
    end;
    DBMS_LOB.freetemporary(v_cdoc);
    return v_return;
  end get_xml;

   procedure put_line(p_data in varchar2) is
     ln_chars_to_print   pls_integer;
     ln_print_posn       pls_integer;
     ln_linefeed_posn    pls_integer;
     ln_print_offset     pls_integer;
   begin
      --
      -- Split data at each chr(10) (line feed character) or 250 char
      --
      ln_chars_to_print := length(p_data);
      ln_print_posn := 1;
      while ln_chars_to_print > 0 loop
        ln_linefeed_posn := instr(p_data, chr(10), ln_print_posn);
        if ln_linefeed_posn = 0 then
           ln_linefeed_posn := ln_print_posn + 250;
        end if;
        ln_print_offset := ln_linefeed_posn - ln_print_posn;
        dbms_output.put_line(substr(p_data, ln_print_posn, ln_print_offset));
        ln_print_posn := ln_linefeed_posn + 1;
        ln_chars_to_print := ln_chars_to_print - ln_print_offset;
      end loop;
   end put_line;  

  function read_compact_xml( p_xml in xmltype
                           , p_debug in boolean := FALSE)
    return name_value_table is
    v_retsxml         xmltype;
    v_delimiter       varchar2(40);
    cstr              varchar2(32767);
    dstr              varchar2(32767);
    i                 number := 1;
    search_start      number := 1;
    total_char        number;
    pattern_occurence number;
        v_res             name_value_table;
        MISSING_XDATA     exception;
  begin
    v_retsxml := p_xml;
        -- Check for //DELIMITER, COLUMNS and DATA
        if (v_retsxml.existsnode('/RETS/DELIMITER') = 0 or
            v_retsxml.existsnode('/RETS/COLUMNS') = 0 or
            v_retsxml.existsnode('/RETS/DATA') = 0 ) then
          v_res(i).name  := 'validResponse';
          v_res(i).value := 'N';
          raise MISSING_XDATA;
        else
          v_res(i).name  := 'validResponse';
          v_res(i).value := 'Y';
        end if;
        
        i := 2;
    v_delimiter := v_retsxml.extract('/RETS/DELIMITER/@value').getStringVal();
    cstr := v_retsxml.extract('/RETS/COLUMNS/text()').getStringVal();
    dstr := v_retsxml.extract('/RETS/DATA/text()').getStringVal();
    dstr := replace(dstr, '<![CDATA[', '');
    dstr := replace(dstr, ']]>', '');
    loop
      pattern_occurence := instr(cstr, chr(to_number(v_delimiter, 'xxxx')), search_start);
      if (pattern_occurence = 0) then
         v_res(i).name := substr(cstr, search_start);
      else
         total_char := pattern_occurence - search_start;
         v_res(i).name := substr(cstr, search_start, total_char);
      end if;
      exit when (pattern_occurence = 0);

      search_start := pattern_occurence + length(chr(to_number(v_delimiter, 'xxxx')));
      i := i + 1;
   end loop;
   i := 2;
   search_start    := 1;
   loop
      pattern_occurence := instr(dstr, chr(to_number(v_delimiter, 'xxxx')), search_start);
      if (pattern_occurence = 0) then
         v_res(i).value := substr(dstr, search_start);
      else
         total_char := pattern_occurence - search_start;
         v_res(i).value := substr(dstr, search_start, total_char);
      end if;
      exit when (pattern_occurence = 0);

      search_start := pattern_occurence + length(chr(to_number(v_delimiter, 'xxxx')));
      i := i + 1;
   end loop;
   if p_debug = TRUE then  
          for i in v_res.first .. v_res.last loop
                put_line (i||'=>'||v_res(i).name||'="'||v_res(i).value||'"');
          end loop;
   end if;
   return v_res;
  exception
    when MISSING_XDATA then 
           return v_res;
        when others then raise;
  end read_compact_xml;
  
  function get_compact_values( p_xml   in xmltype
                             , p_debug in boolean := FALSE)
    return value_table is
        v_res             name_value_table;
        v_return          value_table;
  begin
    v_res := read_compact_xml(p_xml, p_debug);
        for i in v_res.first .. v_res.last loop
          if v_res(i).name is not null then
            v_return(v_res(i).name) := v_res(i).value;
          end if;
        end loop;
        return v_return;
  end get_compact_values;  

  function read_compact_request( p_resp  in out UTL_HTTP.resp
                               , p_debug in boolean := FALSE)
    return name_value_table is
    v_retsxml         xmltype;
  begin
    v_retsxml := get_xml(p_resp, p_debug);
        return read_compact_xml(v_retsxml, p_debug);
  end read_compact_request;

  
  function read_compact_values( p_resp  in out UTL_HTTP.resp
                               , p_debug in boolean := FALSE)
    return value_table is
        v_res             name_value_table;
        v_return          value_table;
  begin
    v_res := read_compact_request(p_resp, p_debug);
        for i in v_res.first .. v_res.last loop
          if v_res(i).name is not null then
            v_return(v_res(i).name) := v_res(i).value;
          end if;
        end loop;
        return v_return;
  end read_compact_values;
  
  
  procedure set_inactive(p_source_id in mls_listings.source_id%type) is
    cursor cur_listings(p_source_id in mls_listings.source_id%type) is
        select MLS_ID
    ,      PROP_ID
    ,      SOURCE_ID
    ,      MLS_NUMBER
    ,      QUERY_TYPE
    ,      LISTING_TYPE
    ,      LISTING_STATUS
    ,      PRICE
    ,      IDX_YN
    ,      LISTING_BROKER
    ,      LISTING_DATE
    ,      SHORT_DESC
    ,      LINK_TEXT
    ,      DESCRIPTION
    ,      LAST_ACTIVE
    ,      GEO_LOCATION
        from mls_listings
        where listing_status = 'INACTIVE'
        and source_id = p_source_id
        and to_date(last_active, 'dd-mon-yyyy') < (to_date(sysdate, 'dd-mon-yyyy') - 7);
        
  begin
        update mls_listings
        set listing_status = 'INACTIVE'
        where source_id = p_source_id
        and to_date(last_active, 'dd-mon-yyyy') < to_date(sysdate, 'dd-mon-yyyy');
        commit;
        
        for l_rec in cur_listings(p_source_id) loop
          delete from mls_photos
          where mls_id = l_rec.mls_id;
          commit;
        end loop;
        
        delete from mls_listings
        where listing_status = 'INACTIVE'
        and to_date(last_active, 'dd-mon-yyyy') < (to_date(sysdate, 'dd-mon-yyyy') - 7)
        and source_id = p_source_id;
        commit;
  end set_inactive;

    function soap_request( p_url in varchar2
                         , p_soap_request in varchar2) return xmltype IS
    soap_request  VARCHAR2(30000);
    soap_respond  CLOB;
    http_req      utl_http.req;
    http_resp     utl_http.resp;
    resp          XMLType;
    soap_err      exception;
    v_code        VARCHAR2(200);
    v_msg         VARCHAR2(1800);
    v_len number;
    v_txt Varchar2(32767);
  BEGIN
    http_req:= utl_http.begin_request
              ( p_url
              , 'POST'
              , 'HTTP/1.1'
              );
    utl_http.set_header(http_req, 'Content-Type', 'text/xml');
    utl_http.set_header(http_req, 'Content-Length', length(p_soap_request));
    UTL_HTTP.SET_TRANSFER_TIMEOUT(http_req, 3600);

    utl_http.write_text(http_req, p_soap_request);
    http_resp:= utl_http.get_response(http_req);
     -- Obtain the length of the response
    utl_http.get_header_by_name(http_resp, 'Content-Length', v_len, 1);

    FOR i in 1..CEIL(v_len/32767) -- obtain response in 32K blocks just in case it is greater than 32K
    LOOP
        utl_http.read_text(http_resp, v_txt, case when i < CEIL(v_len/32767) then 32767 else mod(v_len,32767) end);
          -- Strip namespace references from the result set.
          v_txt := replace(v_txt, 'soap:', '');
          v_txt := replace(v_txt, 'xmlns="http://tempuri.org/"', '');

        soap_respond := soap_respond || v_txt; -- build up CLOB
    END LOOP;
    utl_http.end_response(http_resp);
    
    begin
      resp:= XMLType.createXML(soap_respond); -- Convert CLOB to XMLTYPE
    exception
      when others then
        resp := xmltype.createxml('<?xml version="1.0" encoding="utf-8"?><SOAPRequestFailed />');
    end;
    return resp;
  END soap_request;      
  
end pr_rets_pkg;
/
show errors package pr_rets_pkg
show errors package body pr_rets_pkg
