create index pr_properties_fb1 on pr_properties(pr_records_pkg.standard_suffix(address1));
ANALYZE INDEX pr_properties_fb1 COMPUTE STATISTICS;
ANALYZE TABLE pr_properties COMPUTE STATISTICS;