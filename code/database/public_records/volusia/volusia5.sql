declare 
  type mcode_t is table of number index by pls_integer;
  mcode mcode_t;
  
  cursor cur_prop is
  select p.prop_id
  ,      v.millage_code
  ,      v.tax_year
  ,      v.tax_value
  from vol_properties v
  ,    pr_properties p
  where p.source_id = 4
  and p.source_pk = v.source_pk;
  
  
  v_millage      number;
  v_school       number := 0.00823700;
  v_non_school   number;
  v_tax          number;
  v_prop_id      number;
  
  
begin
  mcode(204) := 0.02403740; -- Daytona Beach
  mcode(214) := 0.02503740; -- Daytona Beach
  mcode(885) := 0.02391120; -- Daytona Beach
  mcode(403) := 0.02511270; -- Daytona Beach Shores 
  mcode(015) := 0.01994230; -- Debary
  mcode(012) := 0.02335620; -- Deland
  mcode(016) := 0.02344920; -- Deltona
  mcode(604) := 0.02517920; -- Edgewater
  mcode(205) := 0.02149300; -- Flagler Beach
  mcode(203) := 0.02385020; -- Holly Hill
  mcode(013) := 0.02592110; -- Lake Helen
  mcode(601) := 0.02261470; -- New Smyrna Beach
  mcode(603) := 0.02863010; -- Oak Hill 
  mcode(014) := 0.02341610; -- Orange City
  mcode(201) := 0.02110030; -- Ormond Beach
  mcode(011) := 0.02604450; -- Pierson
  mcode(405) := 0.02174620; -- Ponce Inlet
  mcode(402) := 0.02280160; -- Port Orange
  mcode(602) := 0.02405160; -- Port Orange
  mcode(401) := 0.02319070; -- South Daytona
  mcode(200) := 0.02278320; -- Unincorporated/Northeast
  mcode(660) := 0.02404950; -- Unincorporated/Silver Sands
  mcode(600) := 0.02403320; -- Unincorporated/Southeast
  mcode(100) := 0.02256410; -- Unincorporated/Westside

  for t_rec in cur_prop loop
   
	
    v_millage := mcode(t_rec.millage_code);
	v_non_school := v_millage - v_school;
	v_tax := round((t_rec.tax_value * v_non_school) + (t_rec.tax_value * v_school), 2);
	insert into pr_taxes
	(prop_id, tax_year, tax_value, tax_amount)
	values
	(t_rec.prop_id, t_rec.tax_year, t_rec.tax_value, v_tax);
  end loop;  
  
end;
/  
