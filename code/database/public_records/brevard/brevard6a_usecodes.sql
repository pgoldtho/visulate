declare 
  cursor cur_ucodes is
  select p.prop_id
  ,      u.usecode
  from pr_properties p
  ,     brd_usecodes u
  ,     pr_usage_codes uc
  where u.source_pk = p.source_pk
  and u.usecode = uc.ucode
  and p.source_id = 3;
begin
  for u_rec in cur_ucodes loop
    update pr_property_usage
    set ucode = u_rec.usecode	
	where prop_id = u_rec.prop_id;
	
	commit;
  end loop;
end;
/