declare

  -- 
  --  Runs very slowly.  Review structure before re-running.
  -- 
  type mcode_t is table of number index by varchar2(4);
  mcode  mcode_t;
  
  cursor cur_prop is 
  select prop_id
  ,      source_pk
  from pr_properties p
  where source_pk is not null
  and source_id = 3
  and not exists (select 1 
                  from pr_taxes t
                  where t.prop_id = p.prop_id
				  and t.tax_year = 2010);

  cursor cur_taxes(p_source_pk in pr_properties.source_pk%type) is
  select  "AssessedValue" tax_value
  ,       "MillageCode"   millage_code
  from pr_brvd_properties_mv 
  where "TaxAcct" = p_source_pk;


  v_value    PR_TAXES.TAX_VALUE%TYPE;
  v_amount   PR_TAXES.TAX_AMOUNT%TYPE;
 
  v_millrate number;

begin
-- Refresh using:
-- select '     mcode('''||"MillageCode"||''') := '||"TaxRate"||';' from "MillageRates"@brvd;
     mcode('1000') := 15.0514;
     mcode('1300') := 15.9320;
     mcode('1400') := 15.1439;
     mcode('14A0') := 20.5378;
     mcode('14D0') := 18.7513;
     mcode('1800') := 15.0514;
     mcode('1900') := 15.6152;
     mcode('2100') := 14.9801;
     mcode('2200') := 15.4072;
     mcode('2300') := 14.8876;
     mcode('23D0') := 18.6588;
     mcode('2400') := 15.4072;
     mcode('2500') := 14.5151;
     mcode('25D0') := 18.7513;
     mcode('2600') := 14.5151;
     mcode('26G0') := 15.7255;
     mcode('26H0') := 16.9284;
     mcode('2700') := 12.8951;
     mcode('2800') := 15.4072;
     mcode('3400') := 15.3096;
     mcode('34K0') := 18.4861;
     mcode('34L0') := 15.9774;
     mcode('34S0') := 19.0856;
     mcode('34U0') := 20.1739;
     mcode('34V0') := 16.4141;
     mcode('34X0') := 17.7456;
     mcode('34Z0') := 15.6425;
     mcode('4100') := 15.1506;
     mcode('41M0') := 21.0643;
     mcode('41P0') := 18.0147;
     mcode('4200') := 15.2392;
     mcode('420Y') := 15.2392;
     mcode('4300') := 14.9127;
     mcode('430Y') := 14.9127;
     mcode('43E0') := 18.9259;
     mcode('43J0') := 14.9774;
     mcode('43K0') := 18.4861;
     mcode('4700') := 14.5402;
     mcode('4800') := 15.0809;
     mcode('51K0') := 18.3737;
     mcode('51P0') := 18.0147;
     mcode('51R0') := 20.7737;
     mcode('52P0') := 18.1271;
     mcode('52V0') := 16.4141;
     mcode('5300') := 15.3371;
     mcode('53K0') := 18.4861;
     mcode('54U0') := 20.1739;
	 
	 
  for p_rec in cur_prop loop
   for t_rec in cur_taxes(p_rec.source_pk) loop
     v_value := t_rec.tax_value;
	 begin
	   v_millrate := mcode(t_rec.millage_code);
	 exception when others then
	   dbms_output.put_line('Missing code: '||t_rec.millage_code);
	   v_millrate := 16.5;
	 end;
	 
     v_amount := round(t_rec.tax_value/1000 * v_millrate, 2);
   end loop;
   pr_records_pkg.insert_taxes( x_prop_id    => p_rec.prop_id
                              , x_tax_year   => 2010
                              , x_tax_value  => nvl(v_value, 0)
                              , x_tax_amount => nvl(v_amount, 0));
   commit;							  
 
  end loop;

end;
/
