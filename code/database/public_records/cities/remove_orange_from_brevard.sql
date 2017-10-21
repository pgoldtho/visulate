update rnt_city_media
set city_id = 9894
where city_id = 9895;

delete from rnt_cities
where name='ORLANDO'
and county = 'BREVARD';