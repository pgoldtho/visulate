select score(1), p.prop_id, p.address1, p.city
from pr_properties p
where contains(address1, pr_records_pkg.standard_suffix(upper('&address')), 1) >0
and exists (select 1 from pr_property_usage u where u.prop_id = p.prop_id)
and city = upper('&city')
order by score(1) desc;
