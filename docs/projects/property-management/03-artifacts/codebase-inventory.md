# Deterministic Codebase Inventory & Database Coupling Baseline

- **Dialect Profile**: `oracle->postgres`

## Repository: `visulate`
- **Source Files Scanned**: `644` (`146,674` lines)
- **README Coverage**: `86` README.md file(s) across `65` code directories (`3` directories missing READMEs)
- **Build / Config Manifests**: `code/database/public_records/rent_estimates/requirements.txt`
- **Framework / Pattern Signals**: Legacy Procedural / Include PHP (192 files), Smarty Templates (86 files)

### Language Breakdown

| Language | Files | Lines |
| :--- | ---: | ---: |
| PHP | 237 | 61,486 |
| Template | 179 | 17,290 |
| SQL | 144 | 49,714 |
| HTML | 37 | 4,705 |
| CSS | 30 | 6,972 |
| JavaScript | 14 | 1,446 |
| JSON | 3 | 5,061 |

### Database Driver Coupling

| Driver / API | Files | Sample Paths |
| :--- | ---: | :--- |
| PHP OCI8 (oci_connect / oci_parse) | 7 | `code/php/classes/database/rnt_agreement.class.php`, `code/php/classes/database/rnt_cities.class.php`, `code/php/classes/database/rnt_menu_pages.class.php`, `specs/creole/drivers/oracle/OCI8Connection.php`, `specs/creole/drivers/oracle/OCI8PreparedStatement.php` |

### Embedded Source-Dialect SQL Idioms

| Construct | Files | Sample Paths |
| :--- | ---: | :--- |
| SYSDATE | 39 | `code/database/mviews.sql`, `code/database/data_updates/trigger.sql`, `code/database/plsql/mls_brevard_pkg.sql`, `code/database/plsql/mls_mfr_pkg.sql`, `code/database/plsql/mls_mfr_pkg_v2.sql` |
| TO_DATE / TO_CHAR | 52 | `code/database/mviews.sql`, `code/database/data_updates/seed_estimate_values.sql`, `code/database/plsql/mls_brevard_pkg.sql`, `code/database/plsql/mls_mfr_pkg.sql`, `code/database/plsql/mls_mfr_pkg_v2.sql` |
| ROWNUM | 30 | `code/database/reclaim-sysaux.sql`, `code/database/plsql/CENTROID_Package.sql`, `code/database/plsql/mls_brevard_pkg.sql`, `code/database/plsql/mls_mfr_pkg.sql`, `code/database/plsql/mls_mfr_pkg_v2.sql` |
| Anonymous PL/SQL Block | 96 | `code/database/admin/drcp.sql`, `code/database/data_updates/seed_estimate_values.sql`, `code/database/db_build/acl.sql`, `code/database/db_build/acl2.sql`, `code/database/db_build/aws/acl.sql` |
| NVL / NVL2 | 54 | `code/database/data_updates/trigger.sql`, `code/database/plsql/mls_mfr_pkg.sql`, `code/database/plsql/mls_sef_pkg.sql`, `code/database/plsql/mls_sef_pkg2.sql`, `code/database/plsql/mls_sef_pkg3.sql` |
| FROM DUAL | 39 | `code/database/db_build/sequence_gen.sql`, `code/database/plsql/CENTROID_Package.sql`, `code/database/plsql/mls_mfr_pkg.sql`, `code/database/plsql/mls_mfr_pkg_v2.sql`, `code/database/plsql/mls_sef_pkg.sql` |
| Sequence .NEXTVAL / .CURRVAL | 44 | `code/database/db_build/sequence_gen.sql`, `code/database/plsql/mls_listings_pkg.sql`, `code/database/plsql/pr_locations_pkg.sql`, `code/database/plsql/pr_records_pkg.sql`, `code/database/plsql/rnt_account_periods_pkg.sql` |
| DECODE() | 24 | `code/database/plsql/rnt_accounts_receivable_pkg.sql`, `code/database/plsql/rnt_payments_pkg.sql`, `code/database/plsql/rnt_summary_pkg.sql`, `code/database/public_records/cities/spool_city_metadesc.sql`, `code/database/public_records/cities/spool_city_text.sql` |
| Legacy (+) Outer Join | 28 | `code/database/plsql/rnt_accounts_receivable_pkg.sql`, `code/database/plsql/rnt_ledger_pkg.sql`, `code/database/plsql/rnt_payments_pkg.sql`, `code/database/plsql/rnt_properties_pkg.sql`, `code/database/plsql/rnt_summary_pkg.sql` |
| CONNECT BY | 5 | `code/database/plsql/rnt_summary_pkg.sql`, `code/php/classes/database/rnt_business_units.class.php`, `code/php/classes/database/rnt_cities.class.php`, `code/php/classes/database/rnt_menus.class.php`, `code/php/classes/database/rnt_summary_analysis.class.php` |
