declare
  cursor cur_prop is 
  select  parcel_number          source_pk
  , prop_id
  , sale_date    
  , sale_price   
  , deed_type    
  , qu_code      
  , iv_code      
  , instrument_number 
  , sale_date1        
  , sale_price1       
  , deed_type1        
  , qu_code1          
  , iv_code1          
  , instrument_number1
  , sale_date2        
  , sale_price2       
  , deed_type2        
  , qu_code2          
  , iv_code2          
  , instrument_number2
  , sale_date3        
  , sale_price3       
  , deed_type3        
  , qu_code3          
  , iv_code3          
  , instrument_number3
  , sale_date4        
  , sale_price4       
  , deed_type4        
  , qu_code4          
  , iv_code4          
  , instrument_number4
  from orange_properties
  ,    pr_properties
  where rtrim(sale_date) != '0'
  and source_pk =  parcel_number
  order by  parcel_number;
  

  v_prop_id           PR_PROPERTIES.PROP_ID%TYPE;
  v_owner_id          PR_OWNERS.OWNER_ID%type;
  v_counter           pls_integer;
  v_old_owner         PR_OWNERS.OWNER_ID%type := 898931;
  v_max_date          date;

  function get_deed_id(p_deed in varchar2)  return varchar2 is
    v_count  pls_integer;
	v_deed   varchar2(4);
  begin
    if p_deed = 'SW' 
	  then v_deed := 'SM'; 
	end if;
    select count(*)
    into v_count
    from pr_deed_codes
    where deed_code = v_deed;

    if v_count = 1 then
       return v_deed;
    else
       return 'AM';
    end if;
  end get_deed_id;
  
  
  

begin
  for p_rec in cur_prop loop
	 v_prop_id := p_rec.prop_id;
	 select nvl(max(sale_date), '01-JAN-70') into v_max_date
	 from pr_property_sales
	 where prop_id = v_prop_id;

    begin		  
      select owner_id
	  into v_owner_id
	  from pr_property_owners
	  where prop_id = v_prop_id;
	exception
	  when others then v_owner_id := v_old_owner;
	end;

	begin
	 if  to_date(p_rec.sale_date, 'yyyymmdd') > v_max_date then
       pr_records_pkg.insert_property_sale( X_PROP_ID      => v_prop_id
                                          , X_NEW_OWNER_ID => v_owner_id
                                          , X_SALE_DATE    => to_date(p_rec.sale_date, 'yyyymmdd')
                                          , X_DEED_CODE    => get_deed_id(p_rec.deed_type)
                                          , X_PRICE        => to_number(p_rec.sale_price)
                                          , X_OLD_OWNER_ID => v_old_owner
				  						  , X_PLAT_BOOK    => null
                                          , X_PLAT_PAGE    => null
                                        );
	  end if;
										
     if rtrim(p_rec.sale_date1) != '0' 
	    and to_date(p_rec.sale_date1, 'yyyymmdd') > v_max_date then
       pr_records_pkg.insert_property_sale( X_PROP_ID      => v_prop_id
                                          , X_NEW_OWNER_ID => v_old_owner
                                          , X_SALE_DATE    => to_date(p_rec.sale_date1, 'yyyymmdd')
                                          , X_DEED_CODE    => get_deed_id(p_rec.deed_type1)
                                          , X_PRICE        => p_rec.sale_price1
                                          , X_OLD_OWNER_ID => v_old_owner
										  , X_PLAT_BOOK    => null
                                          , X_PLAT_PAGE    => null
                                          );
     end if;										  
     if rtrim(p_rec.sale_date2) != '0' 
	 	and to_date(p_rec.sale_date2, 'yyyymmdd') > v_max_date then
       pr_records_pkg.insert_property_sale( X_PROP_ID      => v_prop_id
                                          , X_NEW_OWNER_ID => v_old_owner
                                          , X_SALE_DATE    => to_date(p_rec.sale_date2, 'yyyymmdd')
                                          , X_DEED_CODE    => get_deed_id(p_rec.deed_type2)
                                          , X_PRICE        => p_rec.sale_price2
                                          , X_OLD_OWNER_ID => v_old_owner
										  , X_PLAT_BOOK    => null
                                          , X_PLAT_PAGE    => null
                                          );
     end if;										  
     if rtrim(p_rec.sale_date3) != '0' 
	 	and to_date(p_rec.sale_date3, 'yyyymmdd') > v_max_date then
       pr_records_pkg.insert_property_sale( X_PROP_ID      => v_prop_id
                                          , X_NEW_OWNER_ID => v_old_owner
                                          , X_SALE_DATE    => to_date(p_rec.sale_date3, 'yyyymmdd')
                                          , X_DEED_CODE    => get_deed_id(p_rec.deed_type3)
                                          , X_PRICE        => p_rec.sale_price3
                                          , X_OLD_OWNER_ID => v_old_owner
										  , X_PLAT_BOOK    => null
                                          , X_PLAT_PAGE    => null
                                          );
     end if;										  
     if rtrim(p_rec.sale_date4) != '0' 
	 	and to_date(p_rec.sale_date4, 'yyyymmdd') > v_max_date then
       pr_records_pkg.insert_property_sale( X_PROP_ID      => v_prop_id
                                          , X_NEW_OWNER_ID => v_old_owner
                                          , X_SALE_DATE    => to_date(p_rec.sale_date4, 'yyyymmdd')
                                          , X_DEED_CODE    => get_deed_id(p_rec.deed_type4)
                                          , X_PRICE        => p_rec.sale_price4
                                          , X_OLD_OWNER_ID => v_old_owner
 										  , X_PLAT_BOOK    => null
                                          , X_PLAT_PAGE    => null
                                          );
     end if;										  
     commit;
    exception
	  when others then null;
	end;
   
  end loop;
end;
/  