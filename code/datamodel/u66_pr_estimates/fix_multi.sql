declare
  cursor cur_multi is
  select sale_date
  ,      price
  ,      count(*) sales_count
  from pr_property_sales s
  ,    pr_properties p
  where p.prop_id = s.prop_id
  and p.sq_ft > 0
  and s.price/p.sq_ft > 500
  group by sale_date, price
  having count(*) > 1
  order by sale_date, price;
  
  v_count  pls_integer := 0; 
begin
  for s_rec in cur_multi loop
    v_count := v_count + 1;
	dbms_output.put_line(s_rec.sale_date||' '||s_rec.price
	                     ||' -> '||round(s_rec.price/s_rec.sales_count, 2));
    execute immediate
    'update pr_property_sales
     set price = '||round(s_rec.price/s_rec.sales_count, 2)||'
	 where price = '||s_rec.price||'
	 and sale_date = '''||s_rec.sale_date||'''';
  end loop;
  dbms_output.put_line(v_count||' rows');
end;
/  