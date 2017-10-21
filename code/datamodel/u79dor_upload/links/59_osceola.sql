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
    '<a href="http://ira.property-appraiser.org/PropertySearch/ajax/ParcelSearch.aspx?parcelid=[[SOURCE_PK]]">[Property Apprasier]</a>
     <a href="http://ira.property-appraiser.org/PropertySearch_services/parcelPdf/?pin=[[SOURCE_PK]]">[Download PDF Data Sheet]</a>'
    , tax_url = 
    '<a href="https://www.osceola.county-taxes.com/public/real_estate/parcels/[[SOURCE_PK]]">[Tax Record]</a>'
    where source_id = 59;
    commit;
  end seed_links;
  
begin
  --seed_photos;
  seed_links;
end;
/