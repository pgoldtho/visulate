http://www.leepa.org/Display/DisplayParcel.aspx?strap=03-48-26-b3-01100.5490 -- lee	46 Lee Property Appraiser


http://fl-martin-appraiser.governmax.com/propertymax/Standard/list_proval.asp?sid=28688F2C1B484065BBEF0DC65078A727&l_nm=parcelid&l_wc=|name_search=CONTAINS|p.parcelid=34-38-42-335-000-00130-0&name_search=CONTAINS&p.parcelid=34-38-42-335-000-00130-0   -- Martin (didn't work)

http://www.sc-pa.com/search/parcel_detail.asp?propid=0057-04-0050  -- Sarasota	68 Sarasota Property Appraiser


http://appraiser.pascogov.com/search/parcel.aspx?sec=03&twn=24&rng=18&sbb=0010&blk=00000&lot=0802&action=Submit -- Pasco	61 Pasco Property Appraiser

Unmapped:
	46 Lee Property Appraiser
	53 Martin Property Appraiser
	54 Monroe Property Appraiser
	25 Dixie Property Appraiser
	61 Pasco Property Appraiser
	68 Sarasota Property Appraiser
	38 Highlands Property Appraiser



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
