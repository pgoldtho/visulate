drop table vol_properties purge;
drop table vol_sqft purge;
drop table vol_sales purge;


create table vol_properties
( source_pk           number
, owner_name          varchar2(128)
, address1            varchar2(60)
, address2            varchar2(60)
, city                varchar2(60)
, zipcode             varchar2(60)
, mail_address1       varchar2(60)
, mail_address2       varchar2(60)
, mail_city           varchar2(60)
, mail_zipcode        varchar2(60)
, ucode               number 
, millage_code        number
, tax_value           number
, tax_year            number
, total_bedrooms      number
, total_bathrooms     number);
create index vol_properties_n1 on vol_properties(source_pk);


--alter table pr_sources modify property_url  varchar2(512);
--alter table pr_sources modify photo_url  varchar2(512);
--alter table pr_sources modify tax_url  varchar2(512);



create table vol_sqft as
select alt_key, sum(section_area) sqft
from web_res_area_view@volusia
where section_code = 'BAS'
group by alt_key
UNION
select alt_key, com_floor_area sqft
from web_comm_area_view@volusia
union
select alt_key, model_sqft
from web_condo_bld_view@volusia;

create index vol_sqft_n1 on vol_sqft(alt_key);


create table vol_sales as
select alt_key
,      sale_date
,      sale_instrumt     deed_code
,      sales_price       price
,      sale_book_nbr     plat_book
,      sale_page_nbr     plat_page
from web_sales_view@volusia;

create index vol_sales_n1 on vol_sales(alt_key, sale_date);