select p.prop_id
,      p.puma_percentile
,      to_char(t.tax_value, '$999,999') tax_value
,      pd.rent_income_ratio
,      to_char(l.price, '$99,999') rent_ask
,      to_char(round(pv.value_amount /1200), '$99,999')  rent_est
,      round((pv.value_amount /1200)/l.price*100) delta
from pr_properties p
,    pr_pums_data pd
,    pr_pums_values pv
,    mls_listings l
,    pr_taxes t
where p.puma_percentile = pv.percentile
and pv.value_type = 'RR-INCOME'
and pv.puma = pd.puma
and pd.puma = p.puma
and p.prop_id=l.prop_id
and l.query_type='Rental'
and t.prop_id = p.prop_id
and t.current_yn = 'Y'
order by 7;
