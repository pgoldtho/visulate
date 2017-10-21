declare
  cursor cur_loans is
  select loan_id, loan_date, loan_amount
  from rnt_loans;
begin
  for l_rec in cur_loans loop
    update rnt_loans
	set principal_balance = l_rec.loan_amount
	,   balance_date = add_months(l_rec.loan_date, 1)
	where loan_id = l_rec.loan_id;
  end loop;
end;
/