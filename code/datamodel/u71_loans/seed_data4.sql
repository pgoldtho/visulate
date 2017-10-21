declare
  cursor cur_late_payments is
   select pa.payment_date
   ,      ap.payment_due_date
   ,      pa.pay_alloc_id
   from rnt_payment_allocations pa
   ,    rnt_accounts_payable ap
   ,    rnt_property_expenses pe
   ,    rnt_payment_types pt
   ,    rnt_loans l
   where pe.expense_id = ap.expense_id
   and ap.ap_id = pa.ap_id
   and ap.payment_type_id = pt.payment_type_id
   and pt.payment_type_name like '%Mortgage%'
   and l.loan_id = pe.loan_id
   and pa.payment_date > add_months( ap.payment_due_date, 1)
   order by pa.payment_date;
begin
  for l_rec in cur_late_payments loop
    update rnt_payment_allocations
	set payment_date = l_rec.payment_due_date
	where pay_alloc_id = l_rec.pay_alloc_id;
  end loop;
end;
/