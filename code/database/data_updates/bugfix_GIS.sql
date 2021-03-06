select count(*) from pr_locations where geo_location is null;
select count(*) from pr_locations where geo_location is not null;
update pr_locations set geo_found_yn='N' where geo_location is null;

update pr_corporations 
set name = 'PRODUCT FABRICATION AND SUPPLY, LLC'
where corp_number = 'L11000025522';



update pr_locations l
set geo_location = null
,   geo_found_yn = 'N'
where length(TRIM(TRANSLATE(l.geo_location.sdo_point.y, ' +-.0123456789', ' '))) is not null
or    length(TRIM(TRANSLATE(l.geo_location.sdo_point.x, ' +-.0123456789', ' '))) is not null;
