declare

  cursor cur_sales1 is
  SELECT "SaleDate"               sale_date
  ,      to_number("SaleAmount")  price
  ,      "DeedType"               deed_code
  ,      "PriorOwner"             old_owner
  ,      "OwnerName"              current_owner
  ,      substr("BookPg", 1, 4)   plat_book
  ,      substr("BookPg", 5, 4)   plat_page
  ,      prop_id
  FROM BRD_SALES s
  where not exists (select 1
                    from pr_property_sales ps
                    where ps.plat_book = substr("BookPg", 1, 4)
                    and   ps.plat_page = substr("BookPg", 5, 4)
                    and   ps.prop_id   = s.prop_id)
  and s.prop_id is not null
  and exists (select 1 from pr_property_sales ps2 where s.prop_id = ps2.prop_id)
  order by prop_id, "SaleDate" desc;

  cursor cur_prop is 
  select p.prop_id
  ,      p.source_pk
  ,      po.owner_id
  from pr_properties p
  ,    pr_property_owners po
  where source_pk is not null
  and po.prop_id = p.prop_id
  and source_id = 3
  and not exists (select 1 
                  from pr_property_sales ps
                  where ps.prop_id = p.prop_id);

  cursor cur_sales(p_source_pk in pr_properties.source_pk%type) is
  select "SaleDate"               sale_date
  ,      "DeedType"               deed_code
  ,      to_number("SaleAmount")  price
  ,      "PriorOwner"             old_owner
  ,      substr("BookPg", 1, 4)   plat_book
  ,      substr("BookPg", 5, 4)   plat_page
  from brd_sales
  where "TaxAcct" = p_source_pk
  order by "SaleDate" desc;

  v_new_owner      pr_owners.owner_id%type;
  v_old_owner      pr_owners.owner_id%type;

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
    if (s_rec.current_owner != v_owner_name) then
      v_new_owner   := get_owner_id(s_rec.current_owner);
      v_owner_name  := s_rec.current_owner;
    end if;
    v_old_owner := get_owner_id(s_rec.old_owner);
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
            dbms_output.put_line('skipped '||s_rec.prop_id||' '||s_rec.sale_date);
            null;
          when others then 
              dbms_output.put_line(s_rec.current_owner ||' - '||s_rec.prop_id);
              raise;
         end;
    end if;
    v_new_owner := v_old_owner;
    commit;
  end loop;    
end;
/
