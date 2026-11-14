# `code/database/db_build`

## Functional Overview

This directory contains a comprehensive set of SQL scripts and Oracle Data Pump parameter files essential for the initial setup, configuration, and data management of the Visulate Oracle database. It provides the foundational components for provisioning new database instances, including user creation, tablespace definition, network access control (ACL) configuration, sequence generation, spatial indexing, and mechanisms for exporting and importing core application data. The scripts suggest support for different environments or configurations (e.g., `RNTMGR1` vs `RNTMGR2` schemas, various tablespace paths like `/ssd1`, `/ssd2`, `/ssd01`).

## Files & Component Responsibilities

| File Name                    | Description                                                                                                                                                                                                            |
| :--------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `acl.sql`                    | Configures Oracle Network Access Control List (ACL) permissions for the `RNTMGR1` user, allowing it to connect to specific external hosts (e.g., MLS and Property Appraiser sites) via `UTL_HTTP`.                         |
| `acl2.sql`                   | Similar to `acl.sql`, but configures ACL permissions for the `RNTMGR2` user and `WEBACCESS2` role, granting network connectivity privileges to external hosts.                                                             |
| `create_centos_pc_ts2.sql`   | Creates a set of BIGFILE tablespaces (`PR_PROPERTY_DATA2`, `PR_CORP_DATA2`, `MLS_DATA2`, `RNT_DATA2`, `MGT_DATA2`, `SPATIAL_INDEX2`, `SPATIAL_WORK2`) on a `/ssd01` path, likely for a specific CentOS PC environment.     |
| `create_seq_user.sql`        | Creates the `RNTMGR_SEQ` user with privileges to create sequences and tables, along with read/write access to the `dpump_dir1` directory, centralizing sequence management.                                               |
| `create_ts.sql`              | Defines and creates core BIGFILE tablespaces (`PR_PROPERTY_DATA1`, `PR_CORP_DATA1`, `MLS_DATA1`, `RNT_DATA1`, `MGT_DATA1`, `SPATIAL_INDEX1`, `SPATIAL_WORK1`) using a `/ssd1` data file path.                         |
| `create_ts2.sql`             | Defines and creates core BIGFILE tablespaces (`PR_PROPERTY_DATA2`, `PR_CORP_DATA2`, `MLS_DATA2`, `RNT_DATA2`, `MGT_DATA2`, `SPATIAL_INDEX2`, `SPATIAL_WORK2`) using a `/ssd2` data file path.                         |
| `create_user.sql`            | Creates the `RNTMGR1` database user, granting essential privileges (session, table, procedure, sequence, view, type, synonym, trigger, materialized view) and unlimited quotas on `RNT_DATA1`, `MLS_DATA1`, etc.         |
| `create_user2.sql`           | Creates the `RNTMGR2` database user, similar to `create_user.sql`, but granting quotas on the `*2` tablespaces, including spatial ones (`SPATIAL_INDEX2`, `SPATIAL_WORK2`).                                            |
| `mls_export.par`             | Oracle Data Pump parameter file for exporting key MLS-related tables (`MLS_BROKERS`, `MLS_LISTINGS`, `MLS_PHOTOS`, etc.) into `mls_data.dmp`.                                                                           |
| `mls_import.par`             | Oracle Data Pump parameter file for importing MLS data from `rnt_data.dmp` (note: seems to be a typo/mismatch, usually `mls_data.dmp` would be imported here).                                                         |
| `pr_corp_data.par`           | Oracle Data Pump parameter file for exporting corporate data tables (`PR_CORPORATE_LOCATIONS`, `PR_CORPORATIONS`, `PR_PRINCIPALS`, etc.) into `pr_corp_data.dmp`. (Identical to `pr_corp_export.par`).               |
| `pr_corp_export.par`         | Oracle Data Pump parameter file for exporting corporate data tables (`PR_CORPORATE_LOCATIONS`, `PR_CORPORATIONS`, `PR_PRINCIPALS`, etc.) into `pr_corp_data.dmp`.                                                      |
| `pr_corp_import.par`         | Oracle Data Pump parameter file for importing corporate data from `pr_corp_data.dmp`.                                                                                                                                  |
| `pr_mls_export.par`          | Oracle Data Pump parameter file for exporting MLS tables (same set as `mls_export.par`) into `pr_mls_data.dmp`.                                                                                                          |
| `pr_property_export.par`     | Oracle Data Pump parameter file for exporting a large collection of public records property-related tables (`PR_BUILDINGS`, `PR_PROPERTIES`, `PR_OWNERS`, `PR_PROPERTY_SALES`, etc.) into `pr_property_data.dmp`.        |
| `pr_property_import.par`     | Oracle Data Pump parameter file for importing public records property data from `pr_property_data.dmp`.                                                                                                                |
| `readme.txt`                 | An older, informal text README providing manual setup instructions, schema compilation commands, and steps for dropping/recreating materialized views. Some content is superseded by this `README.md`.                 |
| `rnt_export.par`             | Oracle Data Pump parameter file for exporting all RNT (rental management) application tables (`RNT_ACCOUNTS`, `RNT_PROPERTIES`, `RNT_PEOPLE`, `RNT_TENANCY_AGREEMENT`, etc.) into `rnt_data.dmp`.                     |
| `rnt_import.par`             | Oracle Data Pump parameter file for importing RNT data from `rnt_data.dmp`.                                                                                                                                            |
| `schema_import.par`          | Oracle Data Pump parameter file for importing schema objects (excluding tables) from `schema_objects.dmp`.                                                                                                             |
| `schema_objects.par`         | Oracle Data Pump parameter file for exporting all schema objects *except* tables into `schema_objects.dmp`. Useful for schema-only backups.                                                                          |
| `sequence_gen.sql`           | Script to generate `CREATE SEQUENCE` statements for various application tables (MLS, PR, RNT) and set their `START WITH` values based on existing data, also includes `RNTMGR_SEQ` user creation and grants.            |
| `setup_datapump.sql`         | Creates the `dpump_dir1` Oracle directory, mapping it to a file system path (`/home/app/dpump1`), and grants read/write permissions to `RNTMGR1` (and implicitly, other users via other scripts).                     |
| `spatial_indexes.sql`        | Creates spatial indexes (`mdsys.spatial_index`) on key geographical tables (`PR_PROPERTIES`, `PR_LOCATIONS`, `RNT_ZIPCODES`, `MLS_LISTINGS`) using `SPATIAL_INDEX1` and `SPATIAL_WORK1` tablespaces.                  |
| `spatial_indexes2.sql`       | Similar to `spatial_indexes.sql`, but creates spatial indexes using `SPATIAL_INDEX2` and `SPATIAL_WORK2` tablespaces.                                                                                                |
| `test_spatial.sql`           | A SQL query demonstrating the usage of spatial indexes by finding properties (`PR_PROPERTIES`) geographically near a specified `prop_id`.                                                                              |
| `types.sql`                  | Defines several Oracle object types (`T2REC_DATE`, `T_SUMMARY_REC1`, `T_SUMMARY_REC2`, `T_SUMMARY_REC3`, `PROPERTY_REC`) used for structured data manipulation within PL/SQL procedures or complex views.            |

## Database Dependencies & Interactions

This directory heavily interacts with the Oracle database to perform schema creation, configuration, and data operations.

*   **Users & Roles**: Creates `RNTMGR1`, `RNTMGR2`, `RNTMGR_SEQ` users and `WEBACCESS`, `WEBACCESS2` roles.
*   **Tablespaces**: Defines and uses numerous tablespaces: `PR_PROPERTY_DATA1/2`, `PR_CORP_DATA1/2`, `MLS_DATA1/2`, `RNT_DATA1/2`, `MGT_DATA1/2`, `SPATIAL_INDEX1/2`, `SPATIAL_WORK1/2`.
*   **Network ACLs**: Configures `visulate1-acl.xml` and `visulate2-acl.xml` for `UTL_HTTP` access.
*   **Oracle Text**: Grants `CTX_*` privileges to `RNTMGR1` and `RNTMGR2`.
*   **Oracle Data Pump**: Utilizes `dpump_dir1` directory for import/export operations involving a wide array of tables across `MLS_`, `PR_`, and `RNT_` schemas.
*   **Sequences**: Generates and manages sequences for critical tables like `MLS_LISTINGS_SEQ`, `PR_PROPERTIES_SEQ`, `RNT_PROPERTIES_SEQ`, and many others.
*   **Spatial Indexes**: Creates indexes on geographical columns, specifically `PR_PROPERTIES.geo_location`, `PR_LOCATIONS.geo_location`, `RNT_ZIPCODES.geo_location`, and `MLS_LISTINGS.geo_location`.
*   **Database Objects**: Defines custom Oracle object types (`T2REC_DATE`, `PROPERTY_REC`, etc.) for complex data structures.

### Specific Object Interactions:

*   `PR_PROPERTIES`: This table is central to property-related operations. It is involved in:
    *   **Data Pump**: Exported/imported via `pr_property_export.par` and `pr_property_import.par`.
    *   **Spatial Indexing**: `spatial_indexes.sql` and `spatial_indexes2.sql` create spatial indexes on `PR_PROPERTIES.geo_location`.
    *   **Testing**: `test_spatial.sql` queries `PR_PROPERTIES` to test spatial proximity.

## Submodules / Subdirectories

*   **`aws`**: This directory provides a suite of SQL scripts and Oracle Data Pump configuration files for the initial setup and population of an Oracle database instance, configuring user accounts, tablespaces, network access controls, and data import mechanisms relevant for the Visulate application, likely within an AWS environment.
*   **`fresh_install`**: This directory contains the `SETUP.txt` document, which provides detailed instructions and specifications for manually provisioning a new database server environment, including hardware, OS installation, and disk setup.

## Maintenance & Modernization Notes

*   **Environment Specificity**: Be aware of the `*1` and `*2` suffixes for users, tablespaces, and spatial indexes, as well as different file paths (`/ssd1`, `/ssd2`, `/ssd01`). These indicate configurations for distinct environments or instances. When deploying or updating, ensure the correct scripts are used for the target environment.
*   **Data Pump Parameter Files**: The `.par` files are critical for data migration, backup, and restoration. Ensure they are kept up-to-date with schema changes (e.g., new tables) and that the `DIRECTORY` paths are correctly configured on the database server.
*   **Sequence Management**: `sequence_gen.sql` is vital for setting initial sequence values. After importing data, this script or similar logic must be run to ensure sequences continue from the correct next value, preventing primary key collisions.
*   **ACLs**: Network ACLs (`acl.sql`, `acl2.sql`) control outbound database connections. Any new external service endpoints required by the application will necessitate updates to these ACLs.
*   **Invalid Objects**: The old `readme.txt` hints at issues with invalid objects (`exec dbms_utility.compile_schema`, `select object_name, object_type from user_objects where status='INVALID'`). After any major import or schema change, a full schema recompilation and check for invalid objects is recommended.
*   **Materialized Views**: The `readme.txt` also suggests dropping and recreating materialized views. This indicates that some MVs may be dependent on the underlying data loads and might need refreshment or recreation during specific data import cycles.
