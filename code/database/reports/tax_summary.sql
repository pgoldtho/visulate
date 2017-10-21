col "Property" format a30

Prompt Payment Summary for Goldthorp Properties

Prompt Income

break on "Property"  skip 1
compute Sum of "Amount" on property


select nvl(p.address1  , 'Business Unit')     "Property"
,      pt.payment_type_name                   "Payment Type"
,      sum(pa.amount)                         "Amount"
from rnt_payment_types       pt
,    rnt_accounts_receivable ar
,    rnt_payment_allocations pa
,    rnt_properties          p
where pt.payment_type_id = ar.payment_type
and   ar.ar_id           = pa.ar_id
and   ar.payment_property_id     = p.property_id (+)
and to_char(ar.payment_due_date, 'YYYY') = '2007'
and ar.business_id = 21
group by p.address1, pt.payment_type_name
order by p.address1, pt.payment_type_name;


break on report  skip 1
compute sum of "Amount" on report

select pt.payment_type_name "Payment Type"
,      sum(pa.amount) "Amount"
from rnt_payment_types pt
,    rnt_accounts_receivable ar
,    rnt_payment_allocations pa
where pt.payment_type_id = ar.payment_type
and   ar.ar_id = pa.ar_id
and to_char(ar.payment_due_date, 'YYYY') = '2007'
and ar.business_id = 21
group by  pt.payment_type_name
order by pt.payment_type_name;




Prompt Expenses:

break on "Property"  skip 1
compute Sum of "Amount" on property


select nvl(p.address1  , 'Business Unit')     "Property"
,      pt.payment_type_name                   "Payment Type"
,      sum(pa.amount)                         "Amount"
from rnt_payment_types       pt
,    rnt_accounts_payable    ap
,    rnt_payment_allocations pa
,    rnt_properties          p
where pt.payment_type_id = ap.payment_type_id
and   ap.ap_id           = pa.ap_id
and   ap.payment_property_id     = p.property_id (+)
and to_char(ap.payment_due_date, 'YYYY') = '2007'
and ap.business_id = 21
group by p.address1, pt.payment_type_name
order by p.address1, pt.payment_type_name;


break on report  skip 1
compute sum of "Amount" on report

select pt.payment_type_name "Payment Type"
,      sum(pa.amount) "Amount"
from rnt_payment_types pt
,    rnt_accounts_payable ap
,    rnt_payment_allocations pa
where pt.payment_type_id = ap.payment_type_id
and   ap.ap_id = pa.ap_id
and to_char(ap.payment_due_date, 'YYYY') = '2007'
and ap.business_id = 21
group by  pt.payment_type_name
order by pt.payment_type_name;

