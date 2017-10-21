declare

  cursor cur_duplicate is
  select pay_alloc_id, count(*)
  from rnt_ledger_entries
  group by pay_alloc_id having count(*) > 1
  order by pay_alloc_id;

  cursor cur_ledger(p_alloc_id in number) is
  select l.ledger_id
  ,      l.ar_id
  ,      l.ap_id
  ,      pa.amount
  ,      pa.payment_id
  ,      pa.payment_date
  from rnt_ledger_entries l
  ,    rnt_payment_allocations pa
  where l.pay_alloc_id = p_alloc_id
  and l.pay_alloc_id = pa.pay_alloc_id
  order by ledger_id;

  v_first       boolean := TRUE;

begin
  for d_rec in cur_duplicate loop
    for l_rec in cur_ledger(d_rec.pay_alloc_id) loop
      if v_first then
         dbms_output.put_line('-- payment_id = '||l_rec.payment_id);
         dbms_output.put_line('-- amount = '||l_rec.amount);
         dbms_output.put_line('-- Date = '||l_rec.payment_date);
         v_first := FALSE;
      else
         dbms_output.put_line('-- pay_alloc_id = '||d_rec.pay_alloc_id);
         dbms_output.put_line('-- ar_id = '||l_rec.ar_id);
         dbms_output.put_line('delete from rnt_ledger_entries where ledger_id = '||l_rec.ledger_id||';');
      end if;
    end loop;
    v_first := TRUE;
  end loop;
end;
/