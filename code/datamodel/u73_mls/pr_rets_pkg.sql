create or replace package pr_rets_pkg as
/*******************************************************************************
   Copyright (c) Visulate 2011        All rights reserved worldwide
    Name:      PR_RETS_PKG
    Purpose:   MLS Replication API's 
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        12-DEC-11   Peter Goldthorp   Initial Version
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
				      , p_opaque     out varchar2);

  --
  -- Make an http request to a server that uses Digest Authentication
  --
  function get_resp( p_url        in varchar2
                   , p_user       in varchar2
				   , p_passwd     in varchar2
				   , p_realm      in varchar2
				   , p_nonce      in varchar2
				   , p_seq        in integer
				   , p_opaque     in varchar2)
     return UTL_HTTP.resp;
  --
  -- Read the http response and convert to xml. Close the response and 
  -- optionally display the xml via dbms_output.put_line.  
  -- Note: Wraps <DATA> content in CDATA section for use with COMPACT responses.
  -- Should only be used for STANDARD documents that are known to be well formed.
  --
  function get_xml( p_resp  in out UTL_HTTP.resp
                  , p_debug in boolean := FALSE) return xmltype;
				  
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
				      , p_opaque     out varchar2) is
	v_req       UTL_HTTP.req;
	v_resp      UTL_HTTP.resp;
	v_auth_str  varchar2(4048);
  begin
    p_seq := 1;
    v_req := utl_http.begin_request( p_url, 'GET', utl_http.HTTP_VERSION_1_1 );
    utl_http.set_header( v_req, 'User-Agent', 'Oracle/11.2' );  
	v_resp := UTL_HTTP.GET_RESPONSE(v_req);
	IF (v_resp.status_code = UTL_HTTP.HTTP_UNAUTHORIZED) THEN
       utl_http.get_header_by_name(v_resp, 'WWW-Authenticate', v_auth_str, 1);
    END IF;
	p_realm  := get_str(v_auth_str, 'realm');
	p_nonce  := get_str(v_auth_str, 'nonce');
	p_opaque := get_str(v_auth_str, 'opaque');
	IF (v_resp.status_code = UTL_HTTP.HTTP_UNAUTHORIZED) THEN
	  -- prn_http_headers(v_resp);
	  UTL_HTTP.end_response(v_resp);
	  v_resp := pr_rets_pkg.get_resp
                     ( p_url     => p_url
                     , p_user    => p_user
				     , p_passwd  => p_passwd
				     , p_realm   => p_realm
				     , p_nonce   => p_nonce
				     , p_seq     => p_seq
				     , p_opaque  => p_opaque);
	END IF;
	-- prn_http_headers(v_resp);
	UTL_HTTP.end_response(v_resp);

  end rets_login;

  function get_resp( p_url        in varchar2
                   , p_user       in varchar2
				   , p_passwd     in varchar2
				   , p_realm      in varchar2
				   , p_nonce      in varchar2
				   , p_seq        in integer
				   , p_opaque     in varchar2)
     return UTL_HTTP.resp is
    v_nc        varchar2(256);
	v_cnonce    varchar2(256);
	v_response  varchar2(256);
	v_ha1       varchar2(256);
	v_ha2       varchar2(256);
	v_req       UTL_HTTP.req;
	v_resp      UTL_HTTP.resp;
	v_hash_str  varchar2(4048);
  begin
    v_nc := lower(UTL_RAW.CAST_FROM_BINARY_INTEGER(p_seq ));
	v_cnonce := lower(dbms_crypto.randombytes(8));
	
	v_ha1 := getMD5(p_user||':'||p_realm||':'||p_passwd);
	v_ha2 := getMD5('GET:'||p_url);
	-- if qop != auth then
	-- v_hash_str := v_ha1||':'||v_nonce||':'||v_ha2;
	v_hash_str := v_ha1||':'||p_nonce||':'||v_nc||':'||v_cnonce||':auth:'||v_ha2;
	v_response := getMD5(v_hash_str);
	
    v_req := utl_http.begin_request( p_url, 'GET', utl_http.HTTP_VERSION_1_1 );
    utl_http.set_header( v_req, 'User-Agent', 'Oracle/11.2' );
    utl_http.set_header( v_req, 'Authorization'
					   , 'Digest username="'||p_user||'", realm="'||p_realm||'", nonce="'||p_nonce||'",'
                                            ||'uri="'||p_url||'", qop=auth, nc='||v_nc||','
                                            ||'cnonce="'||v_cnonce||'", response="'||v_response||'",'
                                            ||'opaque="'||p_opaque||'"');

	UTL_HTTP.SET_TRANSFER_TIMEOUT(v_req, 3600);
	v_resp := UTL_HTTP.GET_RESPONSE(v_req);
	
	return v_resp;
  end get_resp;
  
  function get_xml( p_resp  in out UTL_HTTP.resp
                  , p_debug in boolean := FALSE) return xmltype is
	v_return     xmltype;
    v_cdoc       clob;
	v_line       varchar2(32767);
  begin
    DBMS_LOB.createtemporary(v_cdoc, FALSE);
    BEGIN
      LOOP
        utl_http.read_line(p_resp, v_line, TRUE);
		v_line := replace(v_line, '<DATA>', '<DATA><![CDATA[');
		v_line := replace(v_line, '</DATA>', ']]></DATA>');
		if p_debug = TRUE then
           put_line(v_line);
		end if;
	    DBMS_LOB.writeappend (v_cdoc, LENGTH(v_line), v_line);
      END LOOP;
    EXCEPTION
       WHEN utl_http.end_of_body THEN
            utl_http.end_response(p_resp);
    END;  
    v_return := xmltype(v_cdoc);
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
  
end pr_rets_pkg;
/
show errors package pr_rets_pkg
show errors package body pr_rets_pkg