declare
  cursor cur_properties is
  select p.prop_id
  ,      p.address1
  ,      'http://map.brevardpropertyappraiser.com/Map2/Photos.aspx?taxAcct='||source_pk  url
  from pr_properties p
  where source_id = 3
  and exists (select 1
              from pr_property_usage pu
              where pu.prop_id = p.prop_id)
  and not exists (select 1
                    from pr_property_photos pp
                               where pp.prop_id = p.prop_id)
order by p.prop_id;

  webpage         varchar2(32767);
  pieces          utl_http.html_pieces;
  pictures_found  boolean;
  picture         varchar2(200);
  p_counter       pls_integer;
  base_url        varchar2(200) := 'http://map.brevardpropertyappraiser.com';
  photo_url       varchar2(256);
  loop_max        pls_integer;
  
begin
  for p_rec in cur_properties loop
--    dbms_output.put_line(p_rec.address1);
    pieces := utl_http.request_pieces(p_rec.url);
	webpage := '';
	loop_max := 16;
	if pieces.count < 16 then
    	loop_max :=  pieces.count;
    end if;
    for i in 1 .. loop_max loop
      webpage := webpage||pieces(i);
    end loop;
    pictures_found := regexp_like(webpage, 'img src=".*jpg');
    if pictures_found then
      p_counter := 1;
      loop
        picture := regexp_substr(webpage,
                                 'img src=".*jpg',
                                  1, p_counter);
        exit when picture is null;
        photo_url :=  replace(picture, 'img src="', base_url);
        p_counter := p_counter + 1;
		begin
		  insert into pr_property_photos(prop_id, url)
		  values (p_rec.prop_id, photo_url);
		  commit;		  
		exception
		  when DUP_VAL_ON_INDEX then 
		    dbms_output.put_line(p_rec.address1);
		  when others then 
		    dbms_output.put_line(p_rec.address1);
		    raise;
	    end;
      end loop;
    end if;
  end loop;
 end;
/
