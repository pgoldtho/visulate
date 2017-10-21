MFR Support - April 22, 2012

New Features

- Support for Mid Florida MLS IDX listings
- Open Streetmap maps via mapquest tile server
- additional ads on company listing page
- geo coordinates in zipcode table

Setup and Installation

1.  Data model and Seed Data Setup:

@mfr_seed_data.sql
@alter_table.sql

2.  Add new domains to ACL

begin
   DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
    acl          => 'visulate-acl.xml',                
    host         => '*.rets.interealty.com',
	lower_port   => 1,
    upper_port   => 9999);
   DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
    acl          => 'visulate-acl.xml',                
    host         => '*.myfloridahomesmls.com',
	lower_port   => 1,
    upper_port   => 9999);
   COMMIT;
end;
/


3.  Install new MLS packages from /visulate/visulate/code/database/plsql

@pr_rets_pkg.sql
@mls_price_ranges_pkg.sql
@mls_mfr_pkg.sql
@mls_brevard_pkg.sql

4.  PHP Updates
- classes/database/pr_reports.class.php 
- _smarty/templates/visulate_search.tpl
- _smarty/templates/visulate-property-details.tpl
- _smarty/templates/visulate-property-detail-main.tpl
- _smarty/templates/visulate-corp-details.tpl

5. Test Upgrade

exec mls_mfr_pkg.update_mls
exec mls_brevard_pkg.update_mls

select SOURCE_ID, PROCESSED_YN, count(*)
from mls_rets_responses
group by SOURCE_ID, PROCESSED_YN

6. Create cron job to run mls_mfr_pkg.update_mls


