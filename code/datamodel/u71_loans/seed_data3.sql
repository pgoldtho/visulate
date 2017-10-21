declare
  cursor cur_loans is
  select LOAN_ID, PROPERTY_ID, POSITION,
         LOAN_DATE, LOAN_AMOUNT, TERM,
         INTEREST_RATE, CREDIT_LINE_YN, ARM_YN, INTEREST_ONLY_YN,
         BALLOON_DATE, CLOSING_COSTS, SETTLEMENT_DATE, balance_date, principal_balance,
		 rnt_loans_pkg.get_mortgage_payment( loan_amount
                                           , interest_rate
                                           , term
                                           , replace(interest_only_yn, 'N', 'A')) payment
  from   RNT_LOANS
  where loan_date < to_date('1-JAN-2007', 'dd-MON-yyyy');
  v_date      date;
  v_amount    number(12,2);
  v_interest  number(12,2);
  v_end_date  date;
begin
  for l_rec in cur_loans loop
    v_date := l_rec.balance_date;
	v_amount := l_rec.principal_balance;
	dbms_output.put_line(l_rec.loan_id||' ('||l_rec.loan_amount||') '||l_rec.payment);
	v_date := add_months(v_date, 1);
	if l_rec.property_id = 881 then
	  v_end_date := to_date('1-JAN-2008', 'dd-MON-yyyy');
	else 
	  v_end_date := to_date('1-JAN-2007', 'dd-MON-yyyy');
	end if;
	while v_date < v_end_date loop
	  v_interest := v_amount * l_rec.interest_rate / 1200;
	  v_amount := v_amount + v_interest;
	  v_amount := v_amount - l_rec.payment;
	  dbms_output.put_line(v_date||' interest = '||v_interest||' balance = '||v_amount);
	  update rnt_loans
	  set balance_date = v_date
	  ,   principal_balance = v_amount
	  where loan_id = l_rec.loan_id;
	  if (v_amount < 0) or (v_date < l_rec.settlement_date) then
	    v_date := sysdate;
      else
	    v_date := add_months(v_date, 1);
	  end if;
	end loop;
	update rnt_loans 
	set balance_date = v_end_date
	where loan_id = l_rec.loan_id;
  end loop;
  commit;
end;
/