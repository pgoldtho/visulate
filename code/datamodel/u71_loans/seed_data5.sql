declare
 -- 27 Mortgage Interest
 -- 12 Mortgage Payment P&I
 -- 26 Mortgage Payment Principal

  cursor cur_payments is
   select pa.payment_date
   ,      ap.payment_due_date
   ,      pa.pay_alloc_id
   ,      pa.amount
   ,      ap.expense_id
   ,      ap.ap_id
   from rnt_payment_allocations pa
   ,    rnt_accounts_payable ap
   ,    rnt_property_expenses pe
   ,    rnt_payment_types pt
   ,    rnt_loans l
   where pe.expense_id = ap.expense_id
   and pe.loan_id = 201
   and ap.ap_id = pa.ap_id
   and ap.payment_type_id = pt.payment_type_id
   and pt.payment_type_name like '%Mortgage%'
   and l.loan_id = pe.loan_id
   and pa.payment_date > to_date('28-FEB-2010', 'dd-MON-yyyy')
   order by pa.payment_date;
   
   v_expense_id  number;
begin
  for l_rec in cur_payments loop
    if l_rec.payment_date > to_date('31-MAR-2010', 'dd-MON-yyyy') then
      update rnt_payment_allocations
	  set amount = 391.34
	  where pay_alloc_id = l_rec.pay_alloc_id;
	
	  if l_rec.expense_id = 126 then
	    v_expense_id := 15587;
	  elsif l_rec.expense_id = 127 then
	    v_expense_id := 15588;
	  elsif l_rec.expense_id = 128 then
	    v_expense_id := 15589;
	  else
	    v_expense_id := l_rec.expense_id;
	  end if;
	  update rnt_accounts_payable
	  set expense_id = v_expense_id
	  ,   payment_type_id = 12
	  where ap_id = l_rec.ap_id;
--	else
--      update rnt_payment_allocations
--	  set amount = 58400
--	  where pay_alloc_id = l_rec.pay_alloc_id;

--	  update rnt_accounts_payable
--	  set payment_type_id = 26
--	  where ap_id = l_rec.ap_id;
	end if;
  end loop;
  update rnt_loans
  set PRINCIPAL_BALANCE = 0
  where loan_id = 201;
  
  update rnt_property_expenses
  set RECURRING_ENDDATE = to_date('31-MAR-2010', 'dd-MON-yyyy')
  where expense_id in (126, 127, 128);
end;
/