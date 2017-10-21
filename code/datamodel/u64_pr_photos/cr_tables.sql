create table pr_property_photos
( prop_id           number         not null
, url               varchar2(256)  not null
, filename          varchar2(32)
, constraint        pr_property_photos_pk primary key (prop_id, url)
, constraint        pr_property_photos_r1 foreign key (prop_id) 
                    references pr_properties(prop_id));