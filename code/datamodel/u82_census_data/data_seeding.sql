@/home/pgoldtho/visulate/visulate/code/database/plsql/pr_pums_pkg
exec pr_pums_pkg.seed_pums_data
exec pr_pums_pkg.set_property_pumas
exec pr_pums_pkg.set_insurance_rate

delete from pr_taxes t1
where tax_year = 2012
and exists (select 1 from pr_taxes t2 where tax_year=2011 and t1.prop_id=t2.prop_id);

update pr_taxes
set tax_year = 2011
where tax_year = 2012;

create unique index asc_millage_rates_pk on asc_millage_rates(id)
tablespace mgt_data1;

delete from asc_tax_values t1
where t1.tax_value < (select max(t2.tax_value)
                      from asc_tax_values t2
                      where t2.prop_id = t1.prop_id)

create unique index asc_tax_values_pk on asc_tax_values(prop_id)
tablespace mgt_data1;