alter table pr_properties add
( prop_class            varchar2(1) default 'B' not null 
, constraint  pr_properties_r2 foreign key (prop_class) references pr_prop_class(prop_class));

alter table pr_values add 
(vacancy_percent number);

alter table pr_values add 
(utilities       number);

alter table rnt_cities add
(description  clob);