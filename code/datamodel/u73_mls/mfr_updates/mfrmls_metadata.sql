set define ^
declare
  global_login     varchar2(256) := 'mfr.rets.interealty.com/Login.asmx/Login';
  global_user      varchar2(16)  := 'RETS534';
  global_passwd    varchar2(16)  := '7+Er+7aqeD';
  global_base      varchar2(256) := 'mfr.rets.interealty.com/Search.asmx/Search?SearchType=Property';
   v_realm       varchar2(256);
	v_nonce       varchar2(256);
	v_seq         integer;
	v_opaque      varchar2(256);
	v_url         varchar2(4000);
	v_req       UTL_HTTP.req;
	
    v_resp        UTL_HTTP.RESP;
    v_value       varchar2(256);
    x_content     xmltype;
    x_content2    xmltype;
	i             integer;
	v_str         varchar2(256);
	str_found     integer;
	v_values      pr_rets_pkg.value_table;
	v_select      pr_rets_pkg.value_table;
	



  v_metadata xmltype;

begin
    pr_rets_pkg.rets_login
          ( p_url     => global_login
          , p_user    => global_user
		  , p_passwd  => global_passwd
		  , p_realm   => v_realm
	      , p_nonce   => v_nonce
		  , p_seq     => v_seq
		  , p_opaque  => v_opaque);
		  
   v_url := 'mfr.rets.interealty.com/GetMetadata.asmx/GetMetadata?Type=METADATA-TABLE&ID=Property';
	-- pr_rets_pkg.put_line(v_url);

  v_req := utl_http.begin_request( v_url, 'GET', utl_http.HTTP_VERSION_1_1 );
  utl_http.set_header( v_req, 'User-Agent', 'RETSConnector/1.0' );
  utl_http.set_header( v_req, 'Content-Length', '0');

  	UTL_HTTP.SET_TRANSFER_TIMEOUT(v_req, 3600);
	v_resp := UTL_HTTP.GET_RESPONSE(v_req);
	
	pr_rets_pkg.prn_http_headers(v_resp);
	pr_rets_pkg.put_line('Auth='||v_resp.status_code);
    x_content := pr_rets_pkg.get_xml(v_resp);
	
  for j in 1 .. 6 loop
    dbms_output.put_line('Class = '||j);
    i := 1;
    v_str := '/RETS/METADATA/METADATA-TABLE[@Class='||j||']/Field['||i||']';
    str_found := x_content.existsnode(v_str);
    while str_found = 1 loop
      v_value := x_content.extract(v_str||'/SystemName/text()').getStringVal();
      v_value := v_value ||' = '||x_content.extract(v_str||'/LongName/text()').getStringVal();
     dbms_output.put_line(v_value);
      i := i + 1;
      v_str := '/RETS/METADATA/METADATA-TABLE[@Class='||j||']/Field['||i||']';
      str_found := x_content.existsnode(v_str);
     -- Uncomment the following line for testing
      --if i > 30 then str_found := 0; end if;
    end loop;
   end loop;
   
   
		  
end;
/  