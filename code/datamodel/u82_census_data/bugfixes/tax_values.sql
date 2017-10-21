declare
  cursor cur_tax is
  select prop_id, tax_amount/1000 tax, tax_year
  from pr_taxes
  where current_yn = 'Y';
begin
  for t_rec in cur_tax loop
    update pr_taxes
    set tax_amount = t_rec.tax
    where prop_id = t_rec.prop_id
    and current_yn = 'Y'
    and tax_year = t_rec.tax_year;
    commit;    
  end loop;
end;
/
  