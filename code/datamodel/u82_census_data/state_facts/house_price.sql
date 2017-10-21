select z.county, median(ps.price)
from rnt_zipcodes z
,    pr_properties p
,    pr_property_usage pu
,    pr_property_sales ps
where z.zipcode = p.zipcode
and p.prop_id = pu.prop_id
and pu.ucode = 90001
and p.prop_id = ps.prop_id
and ps.sale_date > '01-JAN-2012'
and ps.price > 3000
group by z.county
order by median(ps.price);

select median(ps.price)
from rnt_zipcodes z
,    pr_properties p
,    pr_property_usage pu
,    pr_property_sales ps
where z.zipcode = p.zipcode
and p.prop_id = pu.prop_id
and pu.ucode = 90001
and p.prop_id = ps.prop_id
and ps.sale_date > '01-JAN-2012'
and ps.price > 3000;

select prop_id from pr_property_sales
where price = 120000
and sale_date > '01-JAN-2012'
and rownum < 20;


select p.prop_id
from rnt_zipcodes z
,    pr_properties p
,    pr_property_usage pu
,    pr_property_sales ps
where to_char(z.zipcode) = p.zipcode
and p.prop_id = pu.prop_id
and pu.ucode = 90001
and p.prop_id = ps.prop_id
and ps.sale_date > '01-JAN-2012'
and ps.price > &price1
and ps.price < &price2
and z.county = '&county'
and rownum < 20
/
