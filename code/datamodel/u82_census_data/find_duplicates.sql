  select source_id, p.prop_id, count(*) counter
    from pr_properties p
    ,    asc_tax_values t
    where t.prop_id = p.prop_id
    group by source_id, p.prop_id having count(*) > 1
/
