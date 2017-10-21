create or replace package volusia_functions as

  function decode_propty_class(p_pclass in varchar2) return number;
  function get_ucode(p_alt_key in number) return number;
  
end volusia_functions;
/

create or replace package body volusia_functions as
  function decode_propty_class(p_pclass in varchar2) return number is
    v_return   number;
  begin
    case p_pclass
	when '00' then v_return := 10;
	when '01' then v_return := 110;
	when '02' then v_return := 4;
	when '03' then v_return := 11;
	when '04' then v_return := 414;
	when '05' then v_return := 514;
	when '06' then v_return := 18;
	when '07' then v_return := 1;
	when '08' then v_return := 11;
	when '10' then v_return := 1000;
	when '11' then v_return := 1100;
	when '12' then v_return := 1210;
	when '13' then v_return := 1300;
	when '14' then v_return := 1400;
	when '15' then v_return := 1600;
	when '16' then v_return := 1610;
	when '17' then v_return := 1700;
	when '18' then v_return := 1810;
	when '19' then v_return := 1940;
	when '20' then v_return := 2010;
	when '21' then v_return := 2100;
	when '22' then v_return := 2100;
	when '23' then v_return := 2300;
	when '24' then v_return := 2400;
	when '25' then v_return := 2500;
	when '26' then v_return := 2600;
	when '27' then v_return := 2700;
	when '28' then v_return := 2800;
	when '29' then v_return := 2900;
	when '30' then v_return := 3000;
	when '31' then v_return := 3100;
	when '32' then v_return := 3200;
	when '33' then v_return := 3300;
	when '34' then v_return := 3400;
	when '35' then v_return := 3500;
	when '36' then v_return := 3600;
	when '37' then v_return := 3700;
	when '38' then v_return := 3800;
	when '39' then v_return := 3900;
	when '40' then v_return := 4000;
	when '41' then v_return := 4100;
	when '42' then v_return := 4200;
	when '43' then v_return := 4300;
	when '44' then v_return := 4400;
	when '45' then v_return := 4500;
	when '46' then v_return := 4600;
	when '47' then v_return := 4700;
	when '48' then v_return := 4800;
	when '49' then v_return := 4900;
	when '50' then v_return := 5110;
	when '51' then v_return := 5100;
	when '52' then v_return := 5200;
	when '53' then v_return := 5300;
	when '54' then v_return := 5400;
	when '55' then v_return := 5500;
	when '56' then v_return := 5600;
	when '57' then v_return := 5700;
	when '58' then v_return := 5800;
	when '59' then v_return := 5900;
	when '60' then v_return := 6000;
	when '61' then v_return := 6100;
	when '62' then v_return := 6200;
	when '63' then v_return := 6300;
	when '64' then v_return := 6400;
	when '65' then v_return := 6500;
	when '66' then v_return := 6600;
	when '67' then v_return := 6700;
	when '68' then v_return := 6820;
	when '69' then v_return := 6900;
	when '70' then v_return := 7000;
	when '71' then v_return := 7100;
	when '72' then v_return := 7200;
	when '73' then v_return := 7300;
	when '74' then v_return := 7400;
	when '75' then v_return := 7510;
	when '76' then v_return := 7600;
	when '77' then v_return := 7700;
	when '78' then v_return := 7841;
	when '79' then v_return := 7700;
	when '81' then v_return := 8100;
	when '82' then v_return := 8200;
	when '83' then v_return := 8300;
	when '84' then v_return := 8400;
	when '85' then v_return := 8500;
	when '86' then v_return := 8600;
	when '87' then v_return := 8700;
	when '88' then v_return := 8800;
	when '89' then v_return := 8900;
	when '90' then v_return := 9000;
	when '91' then v_return := 9100;
	when '92' then v_return := 9200;
	when '93' then v_return := 9300;
	when '94' then v_return := 9400;
  	when '95' then v_return := 9500;
	when '96' then v_return := 9600;
	when '97' then v_return := 9700;
	when '98' then v_return := 9800;
	when '99' then v_return := 9900;
    end case;
	
	return v_return;

  end decode_propty_class;
  
  function get_pcode(p_alt_key in number) return number is  
    v_return       number;
	v_count        number := 0;
  begin
    select count(*)
	into v_count
	from Web_Condo_Bld_View@volusia
	where alt_key = p_alt_key;
	
	if v_count > 0 then
	  v_return := 414;
	end if;
	
    v_count := 0;
	select count(*)
	into v_count
	from Web_Comm_Area_View@volusia
	where alt_key = p_alt_key;
	
	if v_count > 0 then
	  v_return := 2;	
	end if;

    v_count := 0;
	select count(*)
	into v_count
	from Web_Bldg_View@volusia
	where alt_key = p_alt_key;
	
	if v_count > 0 then
	  v_return := 1;	
	else
	  v_return := 3;
	end if;
	  
	return v_return;
  end get_pcode;
	  
	  
  function get_ucode(p_alt_key in number) return number is
    v_pclass    varchar2(10);
    v_return    number;
  begin
    select propty_class
	into v_pclass
	from Web_Parcel_View_volcoit@volusia
	where alt_key = p_alt_key;
	
	if length(v_pclass) = 2 then
	   v_return := decode_propty_class(v_pclass);
	end if;
	
	if v_return is null then
	   v_return := get_pcode(p_alt_key);
	end if;
	
	return v_return;
  end get_ucode;
	
end volusia_functions;
/

show errors package volusia_functions
show errors package body volusia_functions
  