declare
 cursor cur_urls is
 select prop_id
 ,      url     old_url
 from  pr_property_photos
 where url like 'http://www.brevardpropertyappraiser.com/building/%';
 
  v_new_url  varchar2(256);
  v_count    integer;
  
  function new_url(p_url in varchar2) return varchar2 is
    v_return varchar2(256);
  begin
   v_return := replace( p_url
                      , 'http://www.brevardpropertyappraiser.com/building/'
					  , 'http://map.brevardpropertyappraiser.com/');
   return v_return;
 end new_url;
 

 
begin
  update pr_sources
  set photo_url=
'<form>
 <a href="http://map.brevardpropertyappraiser.com/Map2/Photos.aspx?taxAcct=[[SOURCE_PK]]">[Property Photos]</a><br/>
 <a href="http://www.brevardpropertyappraiser.com/NewPictoBasic/PictoView.aspx?renum=[[SOURCE_PK]]">[Aerial Photo]</a><br/>
 <a href="http://map.brevardpropertyappraiser.com/Map2/default.aspx?taxacct=[[SOURCE_PK]]">[Aerial Plot]</a>
</form>'
  where source_id=3;
  commit;
  for u_rec in cur_urls loop
    v_new_url := new_url(u_rec.old_url);
	select count(*)
	into v_count
	from pr_property_photos
	where url = v_new_url
    and prop_id = u_rec.prop_id;
	
	if v_count = 0 then
	 update pr_property_photos
     set url = v_new_url
     where url = u_rec.old_url
     and prop_id = u_rec.prop_id;
	else
	 delete from pr_property_photos
	 where url =  u_rec.old_url
     and prop_id = u_rec.prop_id;
	end if;
	commit;
  end loop;
end;
/  
   