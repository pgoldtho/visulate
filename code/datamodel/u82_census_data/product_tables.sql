create table pr_pums_data
( puma                number not null
, rent_income_ratio   number
, insurance           number
, vacancy_rate        number
, constraint pr_pums_data_pk primary key (puma))
tablespace pr_property_data1;

create table pr_pums_values
( puma               number not null
, value_type         varchar2(16) not null
, percentile         number not null
, value_amount       number not null
, constraint pr_pums_values_pk primary key (puma, value_type, percentile)
, constraint pr_pums_values_fk1 foreign key (puma) references pr_pums_data(puma))
tablespace pr_property_data1;

create index pr_pums_values_n1 on pr_pums_values (puma) tablespace pr_property_data1;

alter table pr_properties add
( puma               number
, puma_percentile    number
, rental_percentile  number
, constraint pr_properties_fk2 foreign key (puma) references pr_pums_data(puma));

create index pr_properties_n3 on pr_properties (puma) tablespace pr_property_data1;

alter table pr_taxes  add ( current_yn      varchar2(1) default 'N' not null );
alter table pr_values add ( current_yn      varchar2(1) default 'N' not null );

create table tmp_prop_pums tablespace pr_property_data1  as
select prop_id, puma, puma_percentile, rental_percentile
from pr_properties;


