declare
  cursor cur_addr is 
  select prop_id
  from pr_properties p
  where address1 != pr_records_pkg.standard_suffix(address1);
begin
  for a_rec in cur_addr loop
    update pr_properties 
    set address1 = pr_records_pkg.standard_suffix(address1)
	where prop_id = a_rec.prop_id;
	commit;
  end loop;
end;
/  