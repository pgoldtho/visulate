create index pr_nal_n1 on pr_nal(co_no) tablespace pr_loader;
create index pr_sdf_n1 on pr_sdf(co_no, parcel_id) tablespace pr_loader;      
create index pr_geo_n1 on pr_geo(parcelno) tablespace pr_loader;      
