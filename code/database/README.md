# `code/database`

## Functional Overview
This directory serves as the foundational root for all Visulate application database management, development, and maintenance scripts. It encompasses the core SQL and PL/SQL codebase for setting up the database, performing administrative tasks, managing data (including ETL processes for public records, data updates, and bug fixes), implementing business logic, and generating reports. The immediate files within this directory focus on optimizing data access through materialized views and maintaining database performance by reclaiming system tablespace.

## Files & Component Responsibilities

| File Name           | Description                                                                                                                                                                                                                                                                                                                                                                                                         |
| :------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `mviews.sql`        | Creates and drops key materialized views (`pr_sales_summary_mv`, `pr_sales_mv`). These views pre-aggregate and summarize public records sales data from tables like `PR_PROPERTY_SALES`, `PR_PROPERTIES`, and `RNT_ZIPCODES`. They are designed to improve query performance for analytical and reporting features within the Visulate application by providing pre-computed summaries based on county, year, month, and city. |
| `reclaim-sysaux.sql` | Contains SQL commands and scripts for managing and reclaiming space within the Oracle `SYSAUX` tablespace. This includes identifying large segments, rebuilding indexes associated with Oracle's internal components such as the `Scheduler` and the `Automatic Workload Repository` (AWR), and other operations aimed at reducing space consumption and improving overall database performance.                          |

## Database Dependencies & Interactions

The scripts in this directory interact with several key database objects:

*   **`PR_PROPERTY_SALES` (TABLE, owner: `RNTMGR2`)**: This table, storing public property sales records, is a primary source for the materialized views defined in `mviews.sql`. The views aggregate sales data from this table to provide summarized insights.
*   **`PR_USAGE_CODES` (TABLE, owner: `RNTMGR2`)**: Although not directly visible in the `mviews.sql` sample, `PR_USAGE_CODES` is often used in conjunction with `PR_PROPERTY_SALES` and `PR_PROPERTIES` for filtering or categorizing data in public records contexts, and its data might be implicitly or explicitly referenced by the underlying queries for materialized views or related data processing.
*   **System Objects (`dba_extents`, `dba_data_files`, `dba_tablespaces`, `SCHEDULER$_INSTANCE_PK`, `WRH$_SEG_STAT_PK`, `WRH$_FILESTATXS_PK`, etc.)**: `reclaim-sysaux.sql` directly queries Oracle's data dictionary views and performs maintenance operations (e.g., `ALTER INDEX REBUILD`) on system-level indexes and partitions within the `SYSAUX` tablespace, such as those related to the Database Scheduler and the Automatic Workload Repository (AWR).

## Submodules / Subdirectories

*   **`admin`**: This directory contains SQL scripts and related configuration notes for administering Oracle Database Resident Connection Pooling (DRCP), optimizing application performance by managing shared database connections.
*   **`data_updates`**: This directory contains SQL scripts for one-off data maintenance, bug fixes, and data seeding operations, including a comprehensive script to remove duplicate Osceola County property records, a procedure to calculate and seed estimated property values, and a trigger for managing MLS listing activity statuses.
*   **`db_build`**: This directory houses SQL scripts and Data Pump parameter files for the complete initial build and ongoing data management of the Visulate Oracle database, covering user setup, tablespace creation, network access, spatial indexing, sequence management, and data import/export for various application schemas and environments.
*   **`plsql`**: This directory contains the extensive PL/SQL codebase for Visulate, encompassing core business logic for public records, MLS integrations, and a comprehensive rental property management system, including accounting, user management, and various utilities.
*   **`public_records`**: This directory manages core public records database operations, including county-specific ETL processes, generating unique property keys, maintaining external data source URLs, and providing foundational scripts for schema and data updates for the Visulate application.
*   **`reports`**: This directory houses SQL*Plus scripts and sample outputs for generating detailed financial reports, specifically payment summaries for income and expenses across properties.

## Maintenance & Modernization Notes
*   **Materialized Views**: Ensure that the refresh strategies for materialized views (`mviews.sql`) are appropriate for data volatility and application performance requirements. Consider using fast refresh where possible. Any changes to underlying tables (`PR_PROPERTY_SALES`, `PR_PROPERTIES`) might necessitate recreating or modifying these views.
*   **SYSAUX Management**: The `reclaim-sysaux.sql` script is for critical database maintenance. Exercise caution and thorough testing before running such scripts in production environments, as they interact with core Oracle components. Always review Oracle's documentation for recommended `SYSAUX` management practices.
*   **SQL Standards**: When modifying or adding new SQL, adhere to consistent coding standards for readability, performance, and maintainability.
