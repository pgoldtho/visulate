declare

  procedure seed_photos is
    cursor cur_prop is
    select prop_id
    ,      source_pk
    from pr_properties
    where building_count > 0
    and source_id = 59;

    v_base  varchar2(256) := 'http://ira.property-appraiser.org/PropertySearch_services/PropertyPhoto/PropertyPhoto.aspx?pid=';
  begin
    for p_rec in cur_prop loop
      insert into pr_property_photos (prop_id, url)
      values (p_rec.prop_id, v_base||p_rec.source_pk);
      commit;
    end loop;
  end seed_photos;
  
  procedure seed_links is
  
  begin
    update pr_sources
    set property_url =
    '<a href="http://www.pcpao.org/clik.html?pg=http://www.pcpao.org/general.php?strap=[[ALT_KEY]]">[Property Apprasier]</a>'
    where source_id = 62;
    commit;
  end seed_links;
  
   procedure set_alt_keys is
    cursor cur_prop(p_source     in number) is
    select prop_id
    ,      source_pk
    from pr_properties
    where source_id = p_source;

    v_alt_key   pr_properties.alt_key%type;
  begin
    for p_rec in cur_prop(62) loop
      -- remove spaces 
      v_alt_key := replace(p_rec.source_pk, ' ', '');
      update pr_properties
      set alt_key = v_alt_key
      where prop_id = p_rec.prop_id;
    end loop;
    commit;
  end set_alt_keys;
  
begin
  --seed_photos;
  set_alt_keys;
  seed_links;
end;
/
