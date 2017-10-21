declare 
  type mcode_t is table of number index by pls_integer;
  mcode  mcode_t;
  mcode2 mcode_t;
  type ccode_t is table of mcode_t index by varchar2(1);
  ccode ccode_t;
  
  cursor cur_prop is
  select p.prop_id
  ,      v.millage_code
  ,      v.taxable_value
  ,      v.city_code
  from orange_properties v
  ,    pr_properties p
  where p.source_id = 5
  and p.source_pk = v.parcel_number
  and not exists (select 1
                  from pr_taxes t
				  where t.prop_id = p.prop_id);
  
  v_tax          number;
  v_prop_id      number;
  v_millrate     number;
  v_year         number := '2010';
begin
-- Seed Millage Code Table
-- U=ORG (Unincorporated)
  mcode(10) := 17.3755;
  mcode(11) := 17.1673;
  mcode(12) := 17.1673;
  mcode(13) := 18.2241;
  mcode(14) := 18.0159;
  mcode(15) := 17.6309;
  mcode(16) := 17.4227;
  mcode(17) := 17.6673;
  mcode(18) := 19.3790;
  mcode(19) := 18.7858;
  mcode(20) := 17.5780;
  mcode(21) := 18.5304;
  mcode(23) := 17.6673;
  mcode(24) := 17.3755;
  mcode(29) := 17.3755;
  mcode(30) := 17.1673;
  mcode(31) := 18.6673;
  mcode(32) := 17.1673;
  mcode(33) := 17.9353;
  mcode(35) := 17.3755;
  mcode(37) := 17.5133;
  mcode(38) := 17.7873;
  mcode(39) := 18.1673;
  mcode(41) := 19.7010;
  mcode(42) := 20.5496;
  mcode(43) := 19.9564;
  mcode(45) := 18.9270;
  mcode(47) := 18.3583;
  mcode(53) := 17.3807;
  mcode(54) := 17.1673;
  mcode(55) := 17.1673;
  mcode(65) := 17.1673;
  mcode(66) := 17.8954;
  mcode(67) := 17.6872;
  mcode(68) := 18.1482;
  mcode(70) := 26.0427;
  mcode(75) := 17.6283;
  mcode(82) := 17.8218;
  mcode(83) := 18.1673;
  mcode(84) := 18.6704;
  mcode(85) := 18.0772;
  mcode(88) := 17.6345;
  mcode(89) := 17.6345;
  mcode(90) := 18.4793;
  mcode(92) := 18.6394;
  mcode(93) := 18.4793;
  mcode(94) := 17.7946;
  mcode(96) := 17.1673;
  mcode(99) := 17.1673;
  ccode('U') := mcode;
  
-- A=ORL (Orlando)
  mcode(7) := 19.7693;
  mcode(8) := 18.7693;
  mcode(22) := 18.9775;
  mcode(25) := 18.9775;
  mcode(26) := 18.9775;
  mcode(27) := 18.9775;
  mcode(28) := 18.7693;
  mcode(36) := 18.9775;
  mcode(71) := 18.7693;
  mcode(77) := 19.7693;
  mcode(78) := 18.7693;
  mcode(88) := 19.2365;
  mcode(89) := 19.2365;
  mcode(90) := 20.0813;
  mcode(91) := 20.2414;
  mcode(92) := 20.2414;
  mcode(93) := 20.0813;
  mcode(94) := 19.3966;
  mcode(95) := 18.9775;
  ccode('A') := mcode;

-- B=WP (Winter Park)
  mcode(2) := 17.1781;
  mcode(4) := 17.1781;
  mcode(6) := 17.1781;
  ccode('B') := mcode;

-- C=WG (Winter Garden)
  mcode(11) := 17.3693;
  mcode(63) := 17.3693;
  mcode(64) := 17.3693;
  mcode(65) := 17.3693;
  ccode('C') := mcode;

-- D=APK (Apopka)
  mcode(5) := 16.6359;
  mcode(11) := 16.6359;
  mcode(65) := 16.6359;
  ccode('D') := mcode;

-- E=MTL (Maitland)
  mcode(6) := 17.1245;
  ccode('E') := mcode;

-- F=OCO (Ocoee)
  mcode(35) := 18.8849;
  mcode(65) := 18.6767;
  ccode('F') := mcode;

-- G=WND (Windermere)
  mcode(35) := 16.5555;
  mcode(75) := 16.8083;
  ccode('G') := mcode;

-- H=OAK (Oakland)
  mcode(65) := 19.8693;
  ccode('H') := mcode;

-- J=EVL (Eatonville)
  mcode(11) := 20.0233;
  mcode(34) := 20.0233;
  ccode('J') := mcode;

-- K=BAY (Bay Lake)
  mcode(70) := 25.4203;
  ccode('K') := mcode;

-- L=LBV (Lake Buena Vista)
  mcode(35) := 25.4072;
  mcode(70) := 25.4072;
  ccode('L') := mcode;

-- M=BI (Belle Isle)
  mcode(11) := 17.5211;
  mcode(20) := 17.9318;
  ccode('M') := mcode;

-- N=EDG (Edgewood)
  mcode(11) := 17.0693;
  mcode(20) := 17.4800;
  mcode(83) := 18.0693;
  mcode(87) := 17.7238;
  ccode('N') := mcode;

  for t_rec in cur_prop loop
  
    begin
      mcode2 := ccode(t_rec.city_code);	
	exception 
	  when others then
	  mcode2 := ccode('E');
	end;
	begin
      v_millrate := mcode2(t_rec.millage_code);
	exception
	  when others then 
	    v_millrate := 18;
	end;

	v_tax := round(t_rec.taxable_value/1000 * v_millrate, 2);
	
--dbms_output.put_line(t_rec.city_code||' value = '||t_rec.taxable_value||' tax = '||v_tax);	

	insert into pr_taxes
	(prop_id, tax_year, tax_value, tax_amount)
	values
	(t_rec.prop_id, v_year, t_rec.taxable_value, v_tax);
	commit;

  end loop;  
  
end;
/  
