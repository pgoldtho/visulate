Declare
  cursor cur_tax is
  select taxid, ltrim(pdf) pdf
  from Brvd_pdf;

  cursor cur_prop(p_taxid in varchar2) is
  select prop_id
  , initcap (address1) address1
  from pr_properties
  where source_id=3 
  and source_pk=p_taxid
  order by prop_id;

begin
  for u_rec in cur_tax loop
    --dbms_output.put_line (u_rec.taxid);
    for u_rec2 in cur_prop(u_rec.taxid) loop
      insert into pr_property_links
        (prop_id, url, title)
      values
        (u_rec2.prop_id
        , 'http://visulate.com/brevard'||u_rec.pdf
        , u_rec2.address1||' Building Footprint');
   --   dbms_output.put_line (u_rec2.address1);
    end loop;
  end loop;

end;
/
