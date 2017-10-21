create table rnt_regions
( region_id          number        not null
, name               varchar2(128) not null
, description        clob
, report_data        clob
, constraint rnt_regions_pk primary key (region_id) using index tablespace mgt_data2
, constraint rnt_regions_u1 unique (name) using index tablespace mgt_data2
) tablespace mgt_data2;

create table rnt_city_media
( media_id          number        not null
, name              varchar2(256) not null
, media_type        varchar2(32)  not null
, county_yn         varchar2(1)   not null
, city_id           number
, region_id         number
, title             varchar2(256)
, aspect_ratio      varchar2(16)
, constraint rnt_city_media_pk primary key (media_id) using index tablespace mgt_data2
, constraint rnt_city_media_u1 unique (name) using index tablespace mgt_data2
, constraint rnt_city_media_r1 foreign key (city_id) references rnt_cities (city_id)
, constraint rnt_city_media_r2 foreign key (region_id) references rnt_regions (region_id)
) tablespace mgt_data2;

alter table rnt_cities add
( report_data        clob
, region_id          number
, constraint rnt_cities_r1 foreign key (region_id) references rnt_regions (region_id));