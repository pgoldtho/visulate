declare
  cursor cur_prop is 
  select  rtrim(situs_street_number)||' '||
          rtrim(situs_street_name)||' '||
		  rtrim(situs_street_type)||' '||
		  rtrim(situs_street_direction)  site_address1
  ,       nvl(situs_city, 'ORLANDO') site_city
  ,       nvl(situs_zip, '32801') site_zipcode
  ,       rtrim(address1)        mail_address1		  
  ,       rtrim(address2)        mail_address2
  ,       rtrim(city)            mail_city
  ,       state                  mail_state
  ,       substr(zip_code, 1, 5) mail_zipcode
  ,       total_cama_area        sqft
  ,       rtrim(owner1)          owner
  ,       property_use_code
  ,       parcel_number          source_pk
  ,       total_acreage 
  ,       total_bedroom
  ,       total_bath/100 total_bath
  from orange_properties op
  where situs_street_name is not null
  and not exists (select 1
                  from pr_properties
				  where source_id = 5
				  and source_pk = op.parcel_number)
  order by  parcel_number;
  
  v_source_id         PR_SOURCES.SOURCE_ID%TYPE;
  v_prop_id           PR_PROPERTIES.PROP_ID%TYPE;
  v_mail_id           PR_PROPERTIES.PROP_ID%TYPE;
  v_owner_id          PR_OWNERS.OWNER_ID%type;
  v_address2          pr_properties.address2%type;
  v_counter           pls_integer;
  v_city              pr_properties.city%type;
  v_ucode             pr_usage_codes.ucode%type;
  

  function get_state(p_zipcode in varchar2) return varchar2 is
    v_return varchar2(2);
  begin
    dbms_output.put_line(p_zipcode);
    select distinct c.state
	into v_return
	from rnt_city_zipcodes z
	,    rnt_cities c
	where c.city_id = z.city_id
	and z.zipcode = p_zipcode;
	
	return v_return;
	
  exception
    when no_data_found then return 'XX';
	when others then return 'XX';
  end get_state;
  
  function get_city(p_zipcode in varchar2) return varchar2 is
    v_return varchar2(60);
  begin
    select distinct c.name
	into v_return
	from rnt_city_zipcodes z
	,    rnt_cities c
	where c.city_id = z.city_id
	and z.zipcode = p_zipcode;
	
	return v_return;
  end get_city;  
  
function get_ucode(p_code in number) 
  return number is
   r_code       number; 
begin   
   if p_code =   0  then r_code :=  10; end if; 
   if p_code =   1  then r_code :=  10; end if; 
   if p_code =   4  then r_code :=  40; end if; 
   if p_code =  19  then r_code :=  9; end if;
   if p_code =  20  then r_code :=  4; end if;
   if p_code =  30  then r_code :=  9500; end if;
   if p_code =  31  then r_code :=  10; end if;
   if p_code =  35  then r_code :=  10; end if;
   if p_code =  40  then r_code :=  10; end if;
   if p_code =  49  then r_code :=  10; end if;
   if p_code = 100  then r_code :=  110; end if;
   if p_code = 101  then r_code :=  110; end if;
   if p_code = 102  then r_code :=  110; end if;
   if p_code = 103  then r_code :=  110; end if;
   if p_code = 104  then r_code :=  110; end if;
   if p_code = 105  then r_code :=  110; end if;
   if p_code = 119  then r_code :=  133; end if;
   if p_code = 120  then r_code :=  135; end if;
   if p_code = 121  then r_code :=  135; end if;
   if p_code = 130  then r_code :=  110; end if;
   if p_code = 131  then r_code :=  110; end if;
   if p_code = 135  then r_code :=  110; end if;
   if p_code = 140  then r_code :=  110; end if;
   if p_code = 150  then r_code :=  110; end if;
   if p_code = 175  then r_code :=  700; end if;
   if p_code = 181  then r_code :=  820; end if;
   if p_code = 182  then r_code :=  820; end if;
   if p_code = 200  then r_code :=  4; end if;
   if p_code = 201  then r_code :=  4; end if;
   if p_code = 202  then r_code :=  4; end if;
   if p_code = 299  then r_code :=  4; end if;
   if p_code = 300  then r_code :=  11; end if;
   if p_code = 301  then r_code :=  11; end if;
   if p_code = 310  then r_code :=  11; end if;
   if p_code = 311  then r_code :=  11; end if;
   if p_code = 315  then r_code :=  355; end if;
   if p_code = 400  then r_code :=  414; end if;
   if p_code = 401  then r_code :=  414; end if;
   if p_code = 410  then r_code :=  1940; end if;
   if p_code = 411  then r_code :=  1940; end if;
   if p_code = 412  then r_code :=  1710; end if;
   if p_code = 417  then r_code :=  1810; end if;
   if p_code = 419  then r_code :=  1940; end if;
   if p_code = 420  then r_code :=  19; end if;
   if p_code = 421  then r_code :=  2104; end if;
   if p_code = 425  then r_code :=  1210; end if;
   if p_code = 430  then r_code :=  421; end if;
   if p_code = 439  then r_code :=  17; end if;
   if p_code = 448  then r_code :=  4804; end if;
   if p_code = 450  then r_code :=  422; end if;
   if p_code = 471  then r_code :=  414; end if;
   if p_code = 472  then r_code :=  414; end if;
   if p_code = 473  then r_code :=  414; end if;
   if p_code = 474  then r_code :=  414; end if;
   if p_code = 475  then r_code :=  414; end if;
   if p_code = 494  then r_code :=  414; end if;
   if p_code = 499  then r_code :=  433; end if;
   if p_code = 500  then r_code :=  514; end if;
   if p_code = 550  then r_code :=  522; end if;
   if p_code = 600  then r_code :=  616; end if;
   if p_code = 610  then r_code :=  7500; end if;
   if p_code = 800  then r_code :=  11; end if;
   if p_code = 805  then r_code :=  850; end if;
   if p_code = 812  then r_code :=  820; end if;
   if p_code = 813  then r_code :=  830; end if;
   if p_code = 814  then r_code :=  840; end if;
   if p_code = 822  then r_code :=  820; end if;
   if p_code = 823  then r_code :=  830; end if;
   if p_code = 824  then r_code :=  840; end if;
   if p_code =1000  then r_code :=  1000; end if;
   if p_code =1003  then r_code :=  7; end if;
   if p_code =1004  then r_code :=  40; end if;
   if p_code =1019  then r_code :=  1033; end if;
   if p_code =1100  then r_code :=  1100; end if;
   if p_code =1101  then r_code :=  1104; end if;
   if p_code =1102  then r_code :=  1104; end if;
   if p_code =1103  then r_code :=  1104; end if;
   if p_code =1110  then r_code :=  1125; end if;
   if p_code =1119  then r_code :=  1233; end if;
   if p_code =1200  then r_code :=  1210; end if;
   if p_code =1300  then r_code :=  1300; end if;
   if p_code =1400  then r_code :=  1400; end if;
   if p_code =1500  then r_code :=  1500; end if;
   if p_code =1600  then r_code :=  1600; end if;
   if p_code =1700  then r_code :=  1700; end if;
   if p_code =1701  then r_code :=  1940; end if;
   if p_code =1702  then r_code :=  1704; end if;
   if p_code =1703  then r_code :=  1704; end if;
   if p_code =1704  then r_code :=  1704; end if;
   if p_code =1705  then r_code :=  1704; end if;
   if p_code =1706  then r_code :=  19; end if;
   if p_code =1707  then r_code :=  19; end if;
   if p_code =1710  then r_code :=  1910; end if;
   if p_code =1711  then r_code :=  1910; end if;
   if p_code =1712  then r_code :=  1910; end if;
   if p_code =1715  then r_code :=  1704; end if;
   if p_code =1716  then r_code :=  1704; end if;
   if p_code =1717  then r_code :=  1704; end if;
   if p_code =1800  then r_code :=  1810; end if;
   if p_code =1801  then r_code :=  355; end if;
   if p_code =1802  then r_code :=  1940; end if;
   if p_code =1900  then r_code :=  1940; end if;
   if p_code =1910  then r_code :=  1950; end if;
   if p_code =2010  then r_code :=  24; end if;
   if p_code =2100  then r_code :=  2100; end if;
   if p_code =2101  then r_code :=  2104; end if;
   if p_code =2200  then r_code :=  2100; end if;
   if p_code =2300  then r_code :=  2300; end if;
   if p_code =2400  then r_code :=  2400; end if;
   if p_code =2500  then r_code :=  2500; end if;
   if p_code =2504  then r_code :=  2500; end if;
   if p_code =2510  then r_code :=  1238; end if;
   if p_code =2600  then r_code :=  2600; end if;
   if p_code =2700  then r_code :=  2700; end if;
   if p_code =2710  then r_code :=  2700; end if;
   if p_code =2720  then r_code :=  2710; end if;
   if p_code =2730  then r_code :=  2715; end if;
   if p_code =2740  then r_code :=  2710; end if;
   if p_code =2800  then r_code :=  2800; end if;
   if p_code =2801  then r_code :=  2890; end if;
   if p_code =2802  then r_code :=  2810; end if;
   if p_code =2810  then r_code :=  2800; end if;
   if p_code =2900  then r_code :=  2900; end if;
   if p_code =3200  then r_code :=  3200; end if;
   if p_code =3300  then r_code :=  3300; end if;
   if p_code =3400  then r_code :=  3220; end if;
   if p_code =3419  then r_code :=  133; end if;
   if p_code =3500  then r_code :=  3500; end if;
   if p_code =3505  then r_code :=  3500; end if;
   if p_code =3506  then r_code :=  3500; end if;
   if p_code =3507  then r_code :=  3500; end if;
   if p_code =3508  then r_code :=  3500; end if;
   if p_code =3511  then r_code :=  3500; end if;
   if p_code =3700  then r_code :=  3700; end if;
   if p_code =3800  then r_code :=  3800; end if;
   if p_code =3900  then r_code :=  3900; end if;
   if p_code =3901  then r_code :=  17; end if;
   if p_code =3902  then r_code :=  17; end if;
   if p_code =3903  then r_code :=  17; end if;
   if p_code =3904  then r_code :=  17; end if;
   if p_code =3905  then r_code :=  3930; end if;
   if p_code =3910  then r_code :=  3910; end if;
   if p_code =3920  then r_code :=  3920; end if;
   if p_code =3925  then r_code :=  3940; end if;
   if p_code =4000  then r_code :=  4000; end if;
   if p_code =4100  then r_code :=  4100; end if;
   if p_code =4200  then r_code :=  4200; end if;
   if p_code =4210  then r_code :=  4200; end if;
   if p_code =4300  then r_code :=  4300; end if;
   if p_code =4400  then r_code :=  4400; end if;
   if p_code =4500  then r_code :=  4500; end if;
   if p_code =4600  then r_code :=  4600; end if;
   if p_code =4610  then r_code :=  4600; end if;
   if p_code =4700  then r_code :=  4700; end if;
   if p_code =4800  then r_code :=  4800; end if;
   if p_code =4801  then r_code :=  4804; end if;
   if p_code =4802  then r_code :=  4804; end if;
   if p_code =4805  then r_code :=  4804; end if;
   if p_code =4806  then r_code :=  4804; end if;
   if p_code =4810  then r_code :=  4800; end if;
   if p_code =4820  then r_code :=  4810; end if;
   if p_code =4830  then r_code :=  4800; end if;
   if p_code =4840  then r_code :=  4800; end if;
   if p_code =4900  then r_code :=  4900; end if;
   if p_code =5001  then r_code :=  3; end if;
   if p_code =5100  then r_code :=  5100; end if;
   if p_code =5200  then r_code :=  5200; end if;
   if p_code =5400  then r_code :=  5400; end if;
   if p_code =5410  then r_code :=  5410; end if;
   if p_code =5411  then r_code :=  5900; end if;
   if p_code =5420  then r_code :=  5900; end if;
   if p_code =5421  then r_code :=  5900; end if;
   if p_code =6100  then r_code :=  6100; end if;
   if p_code =6101  then r_code :=  3; end if;
   if p_code =6200  then r_code :=  6200; end if;
   if p_code =6300  then r_code :=  3; end if;
   if p_code =6600  then r_code :=  6600; end if;
   if p_code =6610  then r_code :=  6600; end if;
   if p_code =6611  then r_code :=  6600; end if;
   if p_code =6612  then r_code :=  6600; end if;
   if p_code =6613  then r_code :=  6600; end if;
   if p_code =6614  then r_code :=  6600; end if;
   if p_code =6615  then r_code :=  6600; end if;
   if p_code =6620  then r_code :=  6600; end if;
   if p_code =6623  then r_code :=  6600; end if;
   if p_code =6630  then r_code :=  6600; end if;
   if p_code =6631  then r_code :=  6600; end if;
   if p_code =6632  then r_code :=  6600; end if;
   if p_code =6634  then r_code :=  6600; end if;
   if p_code =6637  then r_code :=  6600; end if;
   if p_code =6700  then r_code :=  6700; end if;
   if p_code =6716  then r_code :=  6700; end if;
   if p_code =6730  then r_code :=  6730; end if;
   if p_code =6801  then r_code :=  3030; end if;
   if p_code =6900  then r_code :=  6900; end if;
   if p_code =6910  then r_code :=  6900; end if;
   if p_code =6917  then r_code :=  6900; end if;
   if p_code =6920  then r_code :=  6900; end if;
   if p_code =6930  then r_code :=  6920; end if;
   if p_code =6940  then r_code :=  6900; end if;
   if p_code =6952  then r_code :=  6900; end if;
   if p_code =6953  then r_code :=  6900; end if;
   if p_code =7000  then r_code :=  7000; end if;
   if p_code =7100  then r_code :=  7100; end if;
   if p_code =7200  then r_code :=  7200; end if;
   if p_code =7300  then r_code :=  7300; end if;
   if p_code =7400  then r_code :=  7400; end if;
   if p_code =7500  then r_code :=  7500; end if;
   if p_code =7600  then r_code :=  7600; end if;
   if p_code =7610  then r_code :=  7610; end if;
   if p_code =7700  then r_code :=  7700; end if;
   if p_code =7900  then r_code :=  7700; end if;
   if p_code =8100  then r_code :=  8100; end if;
   if p_code =8200  then r_code :=  8200; end if;
   if p_code =8210  then r_code :=  8210; end if;
   if p_code =8286  then r_code :=  8600; end if;
   if p_code =8287  then r_code :=  8700; end if;
   if p_code =8289  then r_code :=  8800; end if;
   if p_code =8300  then r_code :=  8300; end if;
   if p_code =8400  then r_code :=  8400; end if;
   if p_code =8500  then r_code :=  8500; end if;
   if p_code =8600  then r_code :=  8600; end if;
   if p_code =8620  then r_code :=  8620; end if;
   if p_code =8630  then r_code :=  9610; end if;
   if p_code =8640  then r_code :=  3; end if;
   if p_code =8650  then r_code :=  9510; end if;
   if p_code =8660  then r_code :=  3; end if;
   if p_code =8670  then r_code :=  9700; end if;
   if p_code =8700  then r_code :=  8700; end if;
   if p_code =8730  then r_code :=  9630; end if;
   if p_code =8740  then r_code :=  3; end if;
   if p_code =8750  then r_code :=  9510; end if;
   if p_code =8760  then r_code :=  3; end if;
   if p_code =8800  then r_code :=  8800; end if;
   if p_code =8900  then r_code :=  8900; end if;
   if p_code =8910  then r_code :=  8930; end if;
   if p_code =8920  then r_code :=  9110; end if;
   if p_code =8930  then r_code :=  9630; end if;
   if p_code =8950  then r_code :=  9510; end if;
   if p_code =8960  then r_code :=  3; end if;
   if p_code =8970  then r_code :=  9700; end if;
   if p_code =9000  then r_code :=  9000; end if;
   if p_code =9017  then r_code :=  9010; end if;
   if p_code =9048  then r_code :=  9010; end if;
   if p_code =9100  then r_code :=  9100; end if;
   if p_code =9110  then r_code :=  9910; end if;
   if p_code =9300  then r_code :=  9300; end if;
   if p_code =9400  then r_code :=  9400; end if;
   if p_code =9500  then r_code :=  9500; end if;
   if p_code =9520  then r_code :=  9500; end if;
   if p_code =9530  then r_code :=  9500; end if;
   if p_code =9600  then r_code :=  9600; end if;
   if p_code =9700  then r_code :=  9700; end if;
   if p_code =9710  then r_code :=  9700; end if;
   if p_code =9770  then r_code :=  9700; end if;
   if p_code =9780  then r_code :=  9700; end if;
   if p_code =9800  then r_code :=  9800; end if;
   if p_code =9900  then r_code :=  9900; end if;
   if p_code =9912  then r_code :=  9900; end if;
   if p_code =9915  then r_code :=  9900; end if;
   if p_code =9920  then r_code :=  9900; end if;
   if p_code =9930  then r_code :=  9900; end if;
   if p_code =9935  then r_code :=  9900; end if;
   if p_code =9950  then r_code :=  9900; end if;
   if p_code =9960  then r_code :=  9900; end if;
   if p_code =9990  then r_code :=  9900; end if;
   
   return r_code; 
end get_ucode; 

begin
  v_source_id := 5;
  for p_rec in cur_prop loop
     begin
	 dbms_output.put_line (p_rec.site_address1);
        v_prop_id := PR_RECORDS_PKG.insert_property
          ( X_SOURCE_ID => v_source_id
          , X_SOURCE_PK => p_rec.source_pk
          , X_ADDRESS1  => p_rec.site_address1
          , X_ADDRESS2  => null
          , X_CITY      => p_rec.site_city
          , X_STATE     => 'FL'
          , X_ZIPCODE   => p_rec.site_zipcode
          , X_ACREAGE   => p_rec.total_acreage 
          , X_SQ_FT     => p_rec.sqft
		  , x_total_bedrooms  => p_rec.total_bedroom
		  , x_total_bathrooms => p_rec.total_bath);
	 exception
	   when DUP_VAL_ON_INDEX then
	     select prop_id into v_prop_id
		 from pr_properties
		 where address1 = p_rec.site_address1
	     and   zipcode = p_rec.site_zipcode;
		 
		 update pr_properties
		 set source_id = v_source_id
		 ,   source_pk = p_rec.source_pk
		 , total_bedrooms = p_rec.total_bedroom
		 , total_bathrooms = p_rec.total_bath
		 where prop_id = v_prop_id;
	  when others then raise;
	 end;
  
     begin
        v_mail_id := PR_RECORDS_PKG.insert_property
          ( X_SOURCE_ID => v_source_id
          , X_SOURCE_PK => null
          , X_ADDRESS1  => p_rec.mail_address1
          , X_ADDRESS2  => p_rec.mail_address2
          , X_CITY      => nvl(p_rec.mail_city, 'XXXXX')
          , X_STATE     => nvl(get_state(p_rec.mail_zipcode), 'XX')
          , X_ZIPCODE   => nvl(p_rec.mail_zipcode, 'XXXXX')
          , X_ACREAGE   => null
          , X_SQ_FT     => null);
     exception
	   when DUP_VAL_ON_INDEX then
	     v_mail_id := v_prop_id;
      when others then raise;
     end;
 
	  if p_rec.owner is not null then
       v_owner_id := pr_records_pkg.get_owner_id(p_rec.owner, v_prop_id);

       if v_owner_id is null then
          v_owner_id := pr_records_pkg.insert_owner
                      ( x_owner_name => p_rec.owner
                      , x_owner_type => '');
       end if;

       select count(*)
       into v_counter
       from pr_property_owners
       where owner_id = v_owner_id
       and   prop_id = v_prop_id;

       if v_counter = 0 then
         pr_records_pkg.insert_property_owner
             ( x_owner_id   => v_owner_id
             , x_prop_id    => v_prop_id
             , x_mailing_id => v_mail_id);
--       else
--         dbms_output.put_line('found dup');
       end if;
     end if;
	 
	 v_ucode := get_ucode(rtrim(p_rec.property_use_code));
	 if v_ucode is not null then
	   select count(*)
	   into v_counter
	   from pr_property_usage
	   where prop_id = v_prop_id;
	   if v_counter = 0 then
	     pr_records_pkg.insert_property_usage( v_ucode
	                                         , v_prop_id);
	   else
	     update pr_property_usage
	     set ucode = v_ucode
	     where prop_id = v_prop_id;
	   end if;
     end if;										   
     commit;
   
  end loop;
end;
/  