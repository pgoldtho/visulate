declare

  procedure put(p_text in varchar2) is
  begin
   dbms_output.put_line(p_text);
  end put;

  procedure print_property(p_prop_id in pr_properties.prop_id%type) is

   cursor cur_property(p_prop_id in pr_properties.prop_id%type) is 
   select p.address1
   ,      p.address2
   ,      p.city
   ,      p.state
   ,      p.zipcode
   ,      p.acreage
   ,      p.sq_ft
   from pr_properties p
   where prop_id = p_prop_id;

 begin
   for p_rec in cur_property(p_prop_id) loop
      put(p_rec.address1||', '||p_rec.city);
--      put(p_rec.address2);
--      put(p_rec.city);
--      put(p_rec.state||p_rec.zipcode);
   end loop;
 end print_property;

 

 procedure print_owner(p_owner_id in pr_owners.owner_id%type) is

  cursor cur_transactions(p_owner_id in pr_owners.owner_id%type) is
  select s.sale_date, 'Purchased' buy_sell, p.address1, p.city, to_char(s.price, '999,999,999') price
  from pr_property_sales s
  ,    pr_properties p
  where s.new_owner_id = p_owner_id
  and p.prop_id = s.prop_id
  and s.deed_code = 'WD'
--  and s.sale_date > sysdate - 1460
  UNION
  select s.sale_date, 'Sold' buy_sell, p.address1, p.city, to_char(s.price, '9,999,999') price
  from pr_property_sales s
  ,    pr_properties p
  where s.old_owner_id = p_owner_id
  and p.prop_id = s.prop_id
  and s.deed_code = 'WD'
--  and s.sale_date > sysdate - 1460
  order by 1;

  cursor cur_props(p_owner_id in pr_owners.owner_id%type) is
  select o.prop_id
  ,      s.sale_date
  ,      to_char(s.price, '999,999,999') price
  from pr_property_owners o
  ,    pr_property_sales s
  where o.owner_id = p_owner_id
  and s.new_owner_id = o.owner_id
  and s.prop_id = o.prop_id;

  cursor cur_mail_address(p_owner_id in pr_owners.owner_id%type) is
  select distinct(mailing_id) mailing_id
  from pr_property_owners
  where owner_id = p_owner_id;
  
  v_name       pr_owners.owner_name%type;

 begin
  select owner_name
  into v_name
  from pr_owners
  where owner_id = p_owner_id;
  put('============================================================');
  put(v_name);
  put('________________');
  put('Mailing Address');

  for m_rec in cur_mail_address(p_owner_id) loop
    print_property(m_rec.mailing_id);
  end loop;
  put('___________________');
  put('Transaction History');

  for t_Rec in cur_transactions(p_owner_id) loop
   put(t_Rec.sale_date||' '|| t_Rec.buy_sell||' '|| t_Rec.address1||', '|| t_Rec.city||' $'||t_Rec.price);
  end loop;
  put('__________________');
  put('Current Properties');

  for m_rec in cur_props(p_owner_id) loop
    print_property(m_rec.prop_id);
    put('Purchased for $'||m_rec.price||' on '||m_rec.sale_date);
  end loop;
  put('============================================================');
 end print_owner;



 procedure find_sellers is

   cursor cur_seller is
   select o.owner_name, owner_id, count(*) p_count
   from pr_owners o
   ,    pr_property_sales ps
   where o.owner_id = ps.old_owner_id
   and ps.sale_date > sysdate -365
   and ps.deed_code = 'WD'
   group by owner_name, owner_id  having count(*) > 2
   order by owner_name, owner_id;

 begin
  for s_rec in cur_seller loop
    print_owner(s_rec.owner_id);
  end loop;
 end find_sellers;



begin
  find_sellers;
end;
/
 

