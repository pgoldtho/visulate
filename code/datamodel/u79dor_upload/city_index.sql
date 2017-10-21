create index pr_properties_n3 on pr_properties(city)  tablespace  PR_PROPERTY_DATA2;
create index pr_locations_n2 on pr_locations(prop_id) tablespace pr_corp_data2;