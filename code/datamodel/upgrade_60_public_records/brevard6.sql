declare

  cursor cur_prop is 
  select prop_id
  ,      source_pk
  from pr_properties p
  where source_pk is not null
  and not exists (select 1 
                  from pr_taxes t
                  where t.prop_id = p.prop_id);

  cursor cur_taxes(p_source_pk in pr_properties.source_pk%type) is
  select "MarketValue" value
  ,      "BilledCounty" + "BilledSchool" + "BilledCityMSTU" + "BilledWasteMgmt" +
         "BilledSPDistrict" + "BilledDebtPay" + "BilledSWDisposal" + "BilledSWCollection" +
         "BilledRecycling" + "BilledEMSAmbulance" + "BilledStormwater" +
         "BilledHPKBFOOT" + "BilledWTRControl" amount
  from brd_properties p
  ,    brd_proposed_taxes t
  where p."TaxAcct" = p_source_pk
  and p."TaxAcct" = t."TaxAcct";


  v_value    PR_TAXES.TAX_VALUE%TYPE;
  v_amount   PR_TAXES.TAX_AMOUNT%TYPE;

begin

  for p_rec in cur_prop loop
   for t_rec in cur_taxes(p_rec.source_pk) loop
     v_value := t_rec.value;
     v_amount := t_rec.amount;
   end loop;
   pr_records_pkg.insert_taxes( x_prop_id    => p_rec.prop_id
                              , x_tax_year   => 2009
                              , x_tax_value  => v_value
                              , x_tax_amount => v_amount);
 
  end loop;

end;
/
