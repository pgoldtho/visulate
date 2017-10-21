declare

  cursor cur_sales1 is
  SELECT s.sale_date
  ,      s.price
  ,      s.deed_code
  ,      s.plat_book
  ,      s.plat_page
  ,      s.alt_key
  ,      p.prop_id
  FROM vol_SALES s
  ,    pr_properties p  
  where s.alt_key = p.source_pk
  and p.source_id = 4
  order by p.prop_id, s.sale_date desc;

  cursor cur_prop is 
  select p.prop_id
  ,      p.source_pk
  ,      po.owner_id
  from pr_properties p
  ,    pr_property_owners po
  where source_pk is not null
  and po.prop_id = p.prop_id
  and source_id = 4
  and not exists (select 1 
                  from pr_property_sales ps
                  where ps.prop_id = p.prop_id);

  cursor cur_sales(p_source_pk in pr_properties.source_pk%type) is
  select sale_date
  ,      deed_code
  ,      price
  ,      plat_book
  ,      plat_page
  from vol_sales
  where alt_key = p_source_pk
  order by sale_date desc;

  v_new_owner      pr_owners.owner_id%type;
  v_old_owner      pr_owners.owner_id%type;
  v_max_price      number;
  v_plat_book      pr_property_sales.plat_book%type;
  v_plat_page      pr_property_sales.plat_page%type;

  v_owner_name     varchar2(50) := 'make me diff first time';

  function get_deed_id(p_deed in varchar2)  return varchar2 is
    v_count  pls_integer;
  begin
    select count(*)
    into v_count
    from pr_deed_codes
    where deed_code = p_deed;

    if v_count = 1 then
       return p_deed;
    else
       return null;
    end if;
  end get_deed_id;


  function get_owner_id(p_name in pr_owners.owner_name%type) 
          return pr_owners.owner_id%type is

    cursor cur_owner_id(p_name in pr_owners.owner_name%type) is
    select o.owner_id
    ,      count(*) property_count
    from pr_owners o
    ,    pr_property_owners po
    where o.owner_name = p_name
    and o.owner_id = po.owner_id
    group by o.owner_id;

    v_ocount   pls_integer;
    v_return   pr_owners.owner_id%type;

  begin
    v_ocount := 0;
    v_return := null;
    for o_rec in cur_owner_id(p_name) loop
      if o_rec.property_count > v_ocount then
         v_ocount := o_rec.property_count;
         v_return := o_rec.owner_id;
      end if;
    end loop;
    if (v_ocount = 0 and p_name is not null) then
       v_return := pr_records_pkg.insert_owner( x_owner_name => p_name
                                              , x_owner_type => 'HISTORY');
    end if;
    return v_return;
  end get_owner_id;


begin

  for s_rec in cur_sales1 loop
    select owner_id
    into v_new_owner
    from pr_owners	
    where owner_name  = 'Not Recorded';

    v_old_owner := v_new_owner;
    if (v_new_owner is not null and s_rec.prop_id is not null) then
         begin
           pr_records_pkg.insert_property_sale( X_PROP_ID      => s_rec.prop_id
                                              , X_NEW_OWNER_ID => v_new_owner
                                              , X_SALE_DATE    => s_rec.sale_date
                                              , X_DEED_CODE    => get_deed_id(s_rec.deed_code)
                                              , X_PRICE        => s_rec.price
                                              , X_OLD_OWNER_ID => v_old_owner
                                              , X_PLAT_BOOK    => s_rec.plat_book
                                              , X_PLAT_PAGE    => s_Rec.plat_page);
         exception
          when DUP_VAL_ON_INDEX then
		  
		    rollback;
			
		    select max(price)
			into v_max_price
			from vol_sales
			where alt_key = s_rec.alt_key
			and sale_date = s_rec.sale_date;
			
			begin
			  select plat_book, plat_page
			  into v_plat_book, v_plat_page
			  from vol_sales
			  where alt_key = s_rec.alt_key
			  and sale_date = s_rec.sale_date
			  and price = v_max_price
			  and rownum = 1;
			exception
			  when NO_DATA_FOUND then 
			     v_plat_book := '99999999';
		      when others then raise;
			end;
			if v_plat_book != '99999999' then
			 begin
			   pr_records_pkg.insert_property_sale( X_PROP_ID      => s_rec.prop_id
                                              , X_NEW_OWNER_ID => v_new_owner
                                              , X_SALE_DATE    => s_rec.sale_date
                                              , X_DEED_CODE    => get_deed_id(s_rec.deed_code)
                                              , X_PRICE        => v_max_price
                                              , X_OLD_OWNER_ID => v_old_owner
                                              , X_PLAT_BOOK    => v_plat_book
                                              , X_PLAT_PAGE    => v_plat_page);
             exception
               when DUP_VAL_ON_INDEX then											  
		           dbms_output.put_line('skipped '||s_rec.alt_key||' '||s_rec.sale_date);
		     end;
		   end if;
          when others then 
              dbms_output.put_line(s_rec.prop_id);
              raise;
         end;
    end if;
    v_new_owner := v_old_owner;
    commit;
  end loop;    
end;
/
