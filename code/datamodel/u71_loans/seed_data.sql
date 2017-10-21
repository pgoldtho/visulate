declare
  procedure loan_query is 
    cursor cur_expenses is
    select b.business_name
    ,      p.address1
    ,      e.description
    ,      e.expense_id
    ,      p.property_id
    ,      e.event_date
    from rnt_business_units b
    ,    rnt_properties p
    ,    rnt_property_expenses e
    where b.business_id = p.business_id
    and p.property_id = e.property_id
	and e.loan_id is null
    and exists (select 1
              from rnt_accounts_payable ap
			  where ap.expense_id = e.expense_id
			  and ap.payment_type_id in (12, 26, 27))
    order by property_id;
			  
    cursor cur_loans(p_prop_id in number) is 
    select position 
    ,      loan_id
    ,      loan_amount
	,      loan_date
    ,      credit_line_yn
    ,      arm_yn
    ,      settlement_date
    from rnt_loans
    where property_id = p_prop_id
    order by position;
  begin
    for e_rec in cur_expenses loop
      dbms_output.put_line('Expense->'||e_rec.expense_id||'='||e_rec.address1||' - '||e_rec.description||' ('||e_rec.event_date||') ');
	  for l_rec in cur_loans(e_rec.property_id) loop
	    dbms_output.put_line('Loan----->'||l_rec.loan_id||'='||l_rec.position||' $'||l_rec.loan_amount 
	                                     ||' Credit: '||l_rec.credit_line_yn||' ARM: '||l_rec.arm_yn||' '
										 ||l_rec.loan_date||' - '||l_rec.settlement_date);
	  end loop;
    end loop;
  end loan_query;

	
  procedure map_loan( p_expense_id in number
                    , p_loan_id    in number) is
  begin
    update rnt_property_expenses
	set loan_id = p_loan_id
	where expense_id = p_expense_id;
  end map_loan;

begin
  map_loan(125, 161);
  map_loan(414, 281);
  map_loan(121, 182);
  map_loan(4847, 281);
  map_loan(10214, 281);
  map_loan(81, 102);
  map_loan(105, 261);
  map_loan(422, 242);
  map_loan(161, 242);
  map_loan(162, 121);
  map_loan(4823, 121);
  map_loan(342, 141);
  map_loan(141, 101);
  map_loan(144, 181);
  map_loan(5241, 102);
  map_loan(5261, 102);
  map_loan(5281, 242);
  map_loan(5282, 121);
  map_loan(5242, 242);
  map_loan(5243, 121);
  map_loan(85, 141);
  map_loan(5283, 141);
  map_loan(5245, 141);
  map_loan(126, 201);
  map_loan(15587, 541);
  map_loan(5321, 201);
  map_loan(15588, 541);
  map_loan(128, 201);
  map_loan(5322, 201);
  map_loan(5323, 201);
  map_loan(15589, 541);
  map_loan(127, 201);
  map_loan(5301, 241);
  map_loan(10211, 241);
  map_loan(15586, 241);
  map_loan(4846, 241);
  map_loan(2721, 241);
  map_loan(441, 241);
  map_loan(164, 222);
  map_loan(5284, 222);
  map_loan(4806, 222);
  map_loan(163, 221);
  map_loan(5285, 221);
  map_loan(4804, 221);
  map_loan(2641, 301);
  map_loan(3241, 361);
  map_loan(15585, 362);
  map_loan(3242, 362);
  map_loan(15583, 361);
  map_loan(5135, 362);
  map_loan(5134, 361);
  map_loan(10521, 361);
  map_loan(10621, 523);
  map_loan(13342, 523);
  map_loan(10622, 521);
  map_loan(13343, 521);
  loan_query;  
  
end;
/