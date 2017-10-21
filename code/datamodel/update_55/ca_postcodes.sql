create table zipcode_data as
select property_id
,      zipcode
from rnt_properties;

alter table rnt_properties modify zipcode null;
update rnt_properties set zipcode = '';
alter table rnt_properties modify zipcode varchar2(7);

declare 
  cursor cur_zips is
  select property_id
  ,      zipcode
  from zipcode_data
  order by property_id;
begin
  for z_rec in cur_zips loop
    update rnt_properties
    set zipcode = z_rec.zipcode
    where property_id = z_rec.property_id;
  end loop;
end;
/

alter table rnt_properties modify zipcode varchar2(7) not null;
exec dbms_utility.compile_schema(schema=>'RNTMGR')
