declare
  cursor cur_addr is
  select p.phy_addr1        address1
  ,      p.phy_addr2        address2
  ,      pp.prop_id
  from pr_nal p
  ,    pr_properties pp
  where (pp.source_pk = p.parcel_id or pp.source_pk = p.alt_key)
  and pp.source_id = to_number(p.co_no) 
  and pp.source_id = 28
  and regexp_like(phy_addr1, '\d');
begin
  for p_rec in cur_addr loop
    begin
      update pr_properties 
      SET address1 = p_rec.address1
      ,   address2 = p_rec.address2
      where prop_id = p_rec.prop_id;
    exception
      when dup_val_on_index then
        dbms_output.put_line(p_rec.prop_id||' '||p_rec.address1);
      when others then raise;
    end;
  end loop;
end;
/
