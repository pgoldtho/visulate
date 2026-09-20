# DOR Notes Materialized View Refresh

## Functional Overview
This directory contains SQL scripts primarily responsible for refreshing materialized views (MVs) related to public records data, likely pertaining to land, commercial properties, and county-level summaries. The scripts ensure that the aggregated and summarized data in these materialized views is up-to-date, supporting reporting and analytical functions within the Visulate application, particularly concerning Department of Revenue (DOR) related public records notes or data.

## Files & Component Responsibilities

| File Name         | Description                                                                                             |
| :---------------- | :------------------------------------------------------------------------------------------------------ |
| `refresh_mviews.sql` | An Oracle SQL script containing an anonymous PL/SQL block to perform a complete refresh of several public records-related materialized views. This script updates key summary and sales data. |

## Database Dependencies & Interactions

This directory primarily interacts with the Oracle database to manage materialized views.

-   **Oracle `DBMS_MVIEW` Package**: The `refresh_mviews.sql` script utilizes the `dbms_mview.refresh` procedure to update the materialized views.
-   **Materialized Views (MVs) Refreshed**:
    -   `PR_LAND_SUMMARY_MV`: Refreshes summarized land property data.
    -   `PR_LAND_SALES_MV`: Refreshes land property sales data.
    -   `PR_COMMERCIAL_SUMMARY_MV`: Refreshes summarized commercial property data.
    -   `PR_COMMERCIAL_SALES_MV`: Refreshes commercial property sales data.
    -   `PR_COUNTY_SUMMARY_MV`: Refreshes county-level summary data.
-   **Commented-out MVs**: The script also contains commented-out lines for `PR_SALES_MV` and `PR_SALES_SUMMARY_MV`, indicating they might have been part of the refresh cycle previously or are candidates for inclusion.

## Submodules / Subdirectories
This directory contains no subdirectories.

## Maintenance & Modernization Notes

*   **Refresh Strategy**: The current script uses a 'C' (COMPLETE) refresh method. For very large materialized views or frequently updated base tables, consider exploring 'F' (FAST) refreshes if the underlying data sources support it and logging is enabled. This could significantly reduce refresh times.
*   **Performance Monitoring**: Monitor the refresh duration of these materialized views, especially for `PR_LAND_SUMMARY_MV` and `PR_COMMERCIAL_SUMMARY_MV`, as they are likely to be large.
*   **Error Handling**: The current script lacks explicit error handling. For production environments, consider adding `EXCEPTION` blocks to log failures or notify administrators if a refresh operation fails.
*   **Dependency Chain**: Understand the base tables and views that these materialized views depend on. Changes to those base objects might necessitate a full refresh or impact the validity of a fast refresh strategy.
*   **Orphaned Refresh Logic**: The commented-out `PR_SALES_MV` and `PR_SALES_SUMMARY_MV` lines suggest potential historical refresh requirements or MVs that are no longer actively maintained. Verify if these MVs are still needed and if their refresh logic should be reinstated or formally removed.
