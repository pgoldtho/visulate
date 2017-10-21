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
    '<form method="POST"  action="http://www.lafayettepa.com/GIS/Search_F.asp"  name="TaxPASearch" target="_blank" >
       <input type="HIDDEN" name="PIN" value="[[SOURCE_PK]]">
       <INPUT type="SUBMIT" value="Property Appraiser">
    </form>'
    where source_id = 44;
    commit;
  end seed_links;
  
begin
  --seed_photos;
  seed_links;
end;
/