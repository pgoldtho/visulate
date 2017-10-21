declare
  v  pr_rets_pkg.value_table;
begin
  for r_Rec in (select *  from mls_rets_responses where rownum<30) loop
    v:= pr_rets_pkg.get_compact_values(r_Rec.RESPONSE, true);
    pr_rets_pkg.put_line(v('validResponse'));
  end loop;
end;
/

