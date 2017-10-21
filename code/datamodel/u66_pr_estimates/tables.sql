create table pr_prop_class
( prop_class       varchar2(1) not null
, description      varchar2(4000)
, constraint pr_prop_class_pk primary key (prop_class));

create table pr_values
( city_id          number not null
, ucode            number not null
, prop_class       varchar2(1) not null
, year             number(4) not null
, min_price        number
, max_price        number
, median_price     number
, rent             number 
, replacement      number 
, maintenance      number 
, mgt_percent      number 
, cap_rate         number 
, constraint pr_values_pk primary key (city_id, ucode, prop_class, year)
, constraint pr_values_r1 foreign key (prop_class) references pr_prop_class(prop_class)
, constraint pr_values_r2 foreign key (ucode) references pr_usage_codes(ucode)
, constraint pr_values_r3 foreign key (city_id) references rnt_cities(city_id)
);

create table pr_ucode_data
( city_id         number not null
, ucode           number not null
, property_count  number not null
, total_sqft      number not null
, constraint pr_ucode_data_pk primary key (city_id, ucode)
, constraint pr_ucode_data_r1 foreign key (city_id) references rnt_cities (city_id)
, constraint pr_ucode_data_r2 foreign key (ucode) references pr_usage_codes (ucode)
);