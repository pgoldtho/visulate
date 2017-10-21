declare
  cursor cur_parcel is
   select * 
   from Web_Parcel_View_volcoit@volusia
   where situs_zip_code is not null;
   
   v_bedrooms   number;
   v_bathrooms  number;
begin
  for p_rec in cur_parcel loop
     begin
	   select sum(bedrooms) into v_bedrooms
	   from "Web_Res_Bld_View"@volusia
	   where alt_key = p_rec.alt_key;
	 exception
	   when no_data_found then 
	      v_bedrooms := 0;
	   when others then raise;
	 end;
     begin
	   select sum(total_bath_count) into v_bathrooms
	   from "Web_Bldg_View"@volusia
	   where alt_key = p_rec.alt_key;
	 exception
	   when no_data_found then 
	      v_bedrooms := 0;
	   when others then raise;
	 end;
	 
     insert into vol_properties
      ( source_pk
      , owner_name
      , address1
      , address2
      , city
      , zipcode
      , mail_address1
      , mail_address2
      , mail_city
      , mail_zipcode
      , ucode
	  , millage_code
	  , tax_value
	  , tax_year
	  , total_bedrooms
      , total_bathrooms )
     values
      (	p_rec.alt_key
      ,	p_rec.owner_name
      , p_rec.situs_street_nbr||' '||p_rec.situs_street_direction
	                          ||' '||p_rec.situs_street_name||' '||p_rec.situs_street_type
      , p_rec.situs_suite_nbr
      , p_rec.situs_city
      , p_rec.situs_zip_code
      , p_rec.owner_addr_1	  
	  , p_rec.owner_addr_2
	  , p_rec.owner_addr_3
	  , p_rec.zipcode
	  , volusia_functions.get_ucode(p_rec.alt_key)
	  , p_rec.millage_cd
	  , p_rec.TOT_TAXABLE
	  , p_rec.roll_year
	  , v_bedrooms
	  , v_bathrooms);
  end loop;
  commit;
end;
/