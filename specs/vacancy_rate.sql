declare

cursor cur_business_units is
select business_id
,      business_name
from rnt_business_units
order by business_name;

cursor cur_properties(n_business_id in rnt_properties.business_id%type) is
select p.property_id
,      p.address1
,      p.date_purchased
,      p.date_sold
,      u.unit_id
,      u.unit_name
from rnt_properties p
,    rnt_property_units u
where business_id = n_business_id
and p.property_id = u.property_id
order by address1;

cursor cur_agreements(n_unit in rnt_tenancy_agreement.unit_id%type) is
select agreement_date
,      end_date
from rnt_tenancy_agreement
where unit_id = n_unit
order by agreement_date;


begin
  for b_rec in cur_business_units loop
    dbms_output.put_line(b_rec.business_name);
    for p_rec in cur_properties(b_rec.business_id) loop
      dbms_output.put_line(p_rec.address1||' '||p_rec.unit_name||': '||
                           p_rec.date_purchased||' - '||
                           p_rec.date_sold);
      for a_rec in cur_agreements(p_rec.unit_id) loop
        dbms_output.put_line(a_rec.agreement_date||' - '||a_rec.end_date);
      end loop;
    end loop;
  end loop;
end;
/