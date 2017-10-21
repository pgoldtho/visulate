create table pr_city_zipcodes
( city_id     number not null
, zipcode     varchar2(7) not null
, constraint pr_city_zipcodes_pk primary key (city_id, zipcode)
, constraint pr_city_zipcodes_r1 foreign key (city_id)
  references rnt_cities (city_id));
  
create index pr_city_zipcodes_n1 on pr_city_zipcodes (zipcode);  
create index pr_properties_n2 on pr_properties (zipcode);  

