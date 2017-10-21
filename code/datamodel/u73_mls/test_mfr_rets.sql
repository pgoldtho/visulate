set serveroutput on size 1000000
set define ^
declare

  global_errors    pls_integer   := 0;
  global_login     varchar2(256) := 'http://mfr.rets.interealty.com/Login.asmx/Login';
  global_user      varchar2(16)  := 'RETS534';
  global_passwd    varchar2(16)  := '7+Er+7aqeD';
  global_base      varchar2(256) := 'http://mfr.rets.interealty.com/Search.asmx/Search?SearchType=Property';



    v_realm       varchar2(256);
    v_nonce       varchar2(256);
    v_seq         integer;
    v_opaque      varchar2(256);
    v_url         varchar2(4000);
    v_resp        UTL_HTTP.RESP;
    x_content     xmltype;
    x_content2    xmltype;
    v_str         varchar2(256);
    str_found     integer;
    v_value       varchar2(256);

 begin
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
          , p_opaque  => v_opaque);
    --
    -- Get Active listing ID's
    --
    v_url := global_base
           ||'&Class=4&Format=COMPACT-DECODED'
           ||'&QueryType=DMQL2&Query=(178=ACT),(19=OC)'
		   ||'&Select=sysid';
    
    pr_rets_pkg.put_line(to_char(sysdate, 'hh24:mi:ss')||' Request');
    v_resp := pr_rets_pkg.get_resp( p_url     => v_url);
    pr_rets_pkg.put_line(to_char(sysdate, 'hh24:mi:ss')||' Response');
    x_content := pr_rets_pkg.get_xml(v_resp);

    --
    -- Get First Active Listing 
    -- 
   
    v_str := '/RETS/DATA[1]';
    str_found := x_content.existsnode(v_str);
    if str_found = 1 then
      v_value := x_content.extract(v_str||'/text()').getStringVal();
      v_value := regexp_substr(v_value, '[0-9]+');
    
      v_url := global_base
	       ||'&Class=4'
	       ||'&Format=COMPACT-DECODED&QueryType=DMQL2'
	       ||'&Query=(sysid='||v_value||')'
               ||'&Select=sysid,175,32,108,2294,2296,3010,176,15,2368,2346,1709,3186,2497,3187';
     v_resp := pr_rets_pkg.get_resp( p_url     => v_url);
     
     x_content2 := pr_rets_pkg.get_xml( p_resp  => v_resp
                        , p_debug => true);
   else
     pr_rets_pkg.put_line('No listings Found');
   end if;
    
end;
/
