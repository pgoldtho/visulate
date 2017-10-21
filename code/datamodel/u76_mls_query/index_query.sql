declare
  v_page      varchar2(32767);
  function get_price_dist( l_type in varchar2
                        , q_type in varchar2) return varchar2 is
						
    cursor cur_price_dist( l_type in varchar2
                         , q_type in varchar2) is
    select initcap(c.name)||', '||c.state||' '||z.zipcode name
    ,      max(price) a_max
    ,      round(PERCENTILE_DISC(0.875) within group (order by price), 2) a_median
    ,      round(PERCENTILE_DISC(0.75) within group (order by price), 2) a_min
    ,      round(median(price), 2) b_median
    ,      round(PERCENTILE_DISC(0.25) within group (order by price), 2) c_max
    ,      round(PERCENTILE_DISC(0.125) within group (order by price), 2) c_median
    ,      min(price) c_min
	,      count(*) total
    from mls_listings m
    ,  pr_properties p
    ,  pr_city_zipcodes z
    ,  rnt_cities c
    where p.prop_id = m.prop_id
    and listing_type = l_type
    and query_type = q_type
    and c.city_id = z.city_id
    and z.zipcode = p.zipcode
    and m.idx_yn = 'Y'
    and m.listing_status = 'ACTIVE'
    group by initcap(c.name)||', '||c.state||' '||z.zipcode
    order by initcap(c.name)||', '||c.state||' '||z.zipcode;
  
    v_return       varchar2(32767);
  
  begin
    v_return := '<table class="datatable">
	<tr><th>City, Zipcode</th><th colspan="6">Price Range (up to) </th><th>Properties</th></tr>'
	||chr(10);
	
    for p_rec in cur_price_dist(l_type, q_type) loop
	  v_return := v_return ||'<tr><th>'
	                        ||p_rec.name||'</th>'||chr(10)
							||'<td><a href="#">'
							||to_char(p_rec.a_max,'999,999,999')||'</td>'||chr(10)
							||'<td><a href="#">'
							||to_char(p_rec.a_median,'999,999,999')||'</td>'||chr(10)
							||'<td><a href="#">'
							||to_char(p_rec.a_min,'999,999,999')||'</td>'||chr(10)
							||'<td><a href="#">'
							||to_char(p_rec.b_median,'999,999,999')||'</td>'||chr(10)
							||'<td><a href="#">'
							||to_char(p_rec.c_max,'999,999,999')||'</td>'||chr(10)
							||'<td><a href="#">'
							||to_char(p_rec.c_median,'999,999,999')||'</td>'||chr(10)
							|| '<td>'||p_rec.total||'</td></tr>'||chr(10);
	end loop;
	v_return := v_return ||'</table>'||chr(10)||chr(10);
	return v_return;
  end get_price_dist;
	

begin
  v_page := '<h1>Search Brevard MLS Listings</h1>
  <img src="/images/banner.jpg"
  <p>Click on a value in one of the tables below to search for a home, 
   rental or land by city, zipcode and maximum price
  </a><h3>Homes for Sale</h3>'||chr(10);
  v_page := v_page||get_price_dist('Sale', 'ResidentialProperty');
  
  v_page := v_page||'<a name="rentals"></a><h3>Homes for Rent (Monthly)</h3>'||chr(10);
  v_page := v_page||get_price_dist('Rent', 'Rental');
  
  v_page := v_page||'<a name="land"></a><h3>Land for Sale</h3>'||chr(10);
  v_page := v_page||get_price_dist('Sale', 'VacantLand');
  pr_rets_pkg.put_line(v_page);
end;
/
  