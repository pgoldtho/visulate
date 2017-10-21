declare
  cursor cur_multi is
  select source_id, source_pk
  ,      count(*) p_count
  from pr_properties p
  group by source_id, source_pk
  having count(*) > 1;
  
  cursor cur_prop( p_source_id  in number
                 , p_source_pk in number) is
  select address1
  ,      prop_id
  ,      sq_ft
  from pr_properties p
  where source_pk = p_source_pk
  and source_id = p_source_id;
  
  
  v_count  pls_integer := 0; 
begin
  for m_rec in cur_multi loop
    dbms_output.put_line(m_rec.source_pk||' ('||m_rec.p_count||')');
    for p_rec in cur_prop(m_rec.source_id, m_rec.source_pk) loop
	  dbms_output.put_line(p_rec.address1 ||' - '||round(nvl(p_rec.sq_ft, 1)/m_rec.p_count));
      execute immediate
      'update pr_properties
       set sq_ft = '||round(nvl(p_rec.sq_ft, 1)/m_rec.p_count)||'
	   where prop_id = '||p_rec.prop_id;
     end loop;
  end loop;
  
end;
/  