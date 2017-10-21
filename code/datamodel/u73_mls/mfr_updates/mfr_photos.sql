declare
  v_photo_list  xmltype;
  i             pls_integer;
  v_str         varchar2(256);
  str_found     number;
  v_value       varchar2(256);
  v_namespace   varchar2(256) := 'xmlns="http://tempuri.org"';
  
  function get_photos(p_sysid in number) return xmltype IS
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
    -- Define the SOAP request according the the definition of the web service being called
    soap_request:= '<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetAuxPhotos xmlns="http://tempuri.org/">
      <Source>MFR</Source>
      <SysID>'||p_sysid||'</SysID>
    </GetAuxPhotos>
  </soap:Body>
</soap:Envelope>';
    http_req:= utl_http.begin_request
              ( 'http://myfloridahomesmls.com/MyAjaxService.asmx'
              , 'POST'
              , 'HTTP/1.1'
              );
    utl_http.set_header(http_req, 'Content-Type', 'text/xml');
    utl_http.set_header(http_req, 'Content-Length', length(soap_request));
    
    utl_http.write_text(http_req, soap_request);
    http_resp:= utl_http.get_response(http_req);
    utl_http.get_header_by_name(http_resp, 'Content-Length', v_len, 1); -- Obtain the length of the response
--	dbms_output.put_line( v_len);
--	pr_rets_pkg.prn_http_headers(http_resp);
    FOR i in 1..CEIL(v_len/32767) -- obtain response in 32K blocks just in case it is greater than 32K
    LOOP
        utl_http.read_text(http_resp, v_txt, case when i < CEIL(v_len/32767) then 32767 else mod(v_len,32767) end);
		-- Strip namespace references from the result set.
		v_txt := replace(v_txt, 'soap:', '');
		v_txt := replace(v_txt, 'xmlns="http://tempuri.org/"', '');
--		dbms_output.put_line( v_txt);
        soap_respond := soap_respond || v_txt; -- build up CLOB
    END LOOP;
    utl_http.end_response(http_resp);
    resp:= XMLType.createXML(soap_respond); -- Convert CLOB to XMLTYPE
	return resp;
  END get_photos;  
begin
    v_photo_list := get_photos(39862451);
	 --v_str := ;
	 --pr_rets_pkg.put_line(v_photo_list.extract(v_str).getStringVal());
	
    i := 1;
    v_str := '//GetAuxPhotosResult/string['||i||']';
    str_found := v_photo_list.existsnode(v_str);
    while str_found = 1 loop
      v_value := v_photo_list.extract(v_str||'/text()').getStringVal();
	  v_value := regexp_replace(v_value, ';.*$');
      dbms_output.put_line(v_value);
      i := i + 1;
      v_str := '//GetAuxPhotosResult/string['||i||']';
      str_found := v_photo_list.existsnode(v_str);
    end loop;
	
end;
/  


