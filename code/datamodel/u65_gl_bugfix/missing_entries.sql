select b.business_name, pt.payment_type_name, sum(amount)
from rnt_business_units b
,    rnt_accounts_receivable ar
,    rnt_payment_types pt
where pt.payment_type_id = ar.payment_type
and ar.business_id = b.business_id
and not exists (select 1 from rnt_ledger_entries l
                where l.ar_id = ar.ar_id)
group by b.business_name, pt.payment_type_name
order by b.business_name, pt.payment_type_name;


select b.business_name, pt.payment_type_name, sum(pa.amount)
from rnt_business_units b
,    rnt_accounts_receivable ar
,    rnt_payment_types pt
,    rnt_payment_allocations pa
where pt.payment_type_id = ar.payment_type
and ar.business_id = b.business_id
and pa.ar_id = ar.ar_id
and not exists (select 1 from rnt_ledger_entries l
                where l.ar_id = ar.ar_id)
group by b.business_name, pt.payment_type_name
order by b.business_name, pt.payment_type_name;



select b.business_name, pt.payment_type_name, sum(amount)
from rnt_business_units b
,    rnt_accounts_payable ap
,    rnt_payment_types pt
where pt.payment_type_id = ap.payment_type_id
and ap.business_id = b.business_id
and not exists (select 1 from rnt_ledger_entries l
                where l.ap_id = ap.ap_id)
group by b.business_name, pt.payment_type_name
order by b.business_name, pt.payment_type_name;


select b.business_name, pt.payment_type_name, amount
from rnt_business_units b
,    rnt_accounts_receivable ar
,    rnt_payment_types pt
where pt.payment_type_id = ar.payment_type
and ar.business_id = b.business_id
and not exists (select 1 from rnt_ledger_entries l
                where l.ar_id = ar.ar_id)
order by b.business_name, pt.payment_type_name