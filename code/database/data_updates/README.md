# Data Updates

This directory (`code/database/data_updates`) contains SQL scripts primarily intended for one-off data maintenance, bug fixes, data seeding, or specific data cleanup operations within the Visulate application's public records and MLS databases. These scripts are typically executed manually or as part of a controlled deployment process rather than being integrated into the regular application logic.

## Functional Overview

The scripts in this directory address various data integrity and initialization needs, ranging from correcting specific data errors and removing duplicate records to calculating and seeding estimated property values and implementing database triggers for data management.

## Files & Component Responsibilities

| File Name                       | Description                                                                                                                                                                                                                                                                                                                                 |
| :------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `bugfix_GIS.sql`                | Contains SQL statements to correct specific GIS data anomalies in the `PR_LOCATIONS` table, setting `geo_location` to `NULL` and `geo_found_yn` to 'N' for invalid entries. It also includes a specific `UPDATE` statement to correct a `PR_CORPORATIONS` name based on its corporation number.                                            |
| `delete_osceola_duplicates.sql` | A comprehensive script designed to identify and remove duplicate property records associated with Osceola County (`source_id = 59`). It cleans duplicates across multiple related tables (`PR_PROPERTIES`, `PR_PROPERTY_OWNERS`, `PR_TAXES`, `PR_PROPERTY_PHOTOS`, `PR_PROPERTY_LINKS`, `PR_PROPERTY_USAGE`, `PR_LOCATIONS`, `PR_PROPERTY_SALES`, `MLS_PHOTOS`, `MLS_LISTINGS`) by ensuring only the oldest `ROWID` for a given `parcel_id` is retained. It also standardizes `parcel_id` format. |
| `seed_estimate_values.sql`      | An anonymous PL/SQL block that calculates estimated property values (e.g., min, max, median, and various percentiles for price per square foot) based on historical `PR_PROPERTY_SALES` data. These calculated values are then inserted into the `PR_VALUES` table, categorized by year, usage code, and city, to provide benchmarks for property valuation. |
| `trigger.sql`                   | Defines an Oracle `BEFORE UPDATE` trigger named `mls_listings_bur_trg` on the `MLS_LISTINGS` table. This trigger automatically populates the `LAST_ACTIVE` column with `SYSDATE` when an MLS listing's `listing_status` transitions from 'ACTIVE' to any non-active status, or if `LAST_ACTIVE` is `NULL` and the new status is not 'ACTIVE'. |

## Database Dependencies & Interactions

The scripts in this directory interact with several core database tables, primarily within the `RNTMGR2` schema, to perform their designated data updates and maintenance tasks.

*   **`bugfix_GIS.sql`**
    *   **`PR_LOCATIONS`**: Updated to correct `geo_location` and `geo_found_yn` values.
    *   **`PR_CORPORATIONS`**: Updated to correct a specific corporation name.
*   **`delete_osceola_duplicates.sql`**
    *   **`PR_PROPERTIES`**: Updated (`parcel_id`) and used as the primary table to identify duplicate property records.
    *   **`PR_PROPERTY_OWNERS`**: Records are deleted based on duplicate `prop_id` or `mailing_id` from `PR_PROPERTIES`.
    *   **`PR_TAXES`**: Records are deleted based on duplicate `prop_id` from `PR_PROPERTIES`.
    *   **`PR_PROPERTY_PHOTOS`**: Records are deleted based on duplicate `prop_id` from `PR_PROPERTIES`.
    *   **`PR_PROPERTY_LINKS`**: Records are deleted based on duplicate `prop_id` from `PR_PROPERTIES`.
    *   **`PR_PROPERTY_USAGE`**: Records are deleted based on duplicate `prop_id` from `PR_PROPERTIES`.
    *   **`PR_LOCATIONS`**: Records are deleted based on `location_id` associated with duplicate properties.
    *   **`PR_PROPERTY_SALES`**: Records are deleted based on duplicate `prop_id` from `PR_PROPERTIES`.
    *   **`MLS_PHOTOS`**: Records are deleted based on duplicate `prop_id` from `PR_PROPERTIES`.
    *   **`MLS_LISTINGS`**: Records are deleted based on duplicate `prop_id` from `PR_PROPERTIES`.
*   **`seed_estimate_values.sql`**
    *   **`PR_PROPERTY_SALES`**: Queried to retrieve historical sales data for value calculations.
    *   **`PR_VALUES`**: Inserted into (or updated) with the calculated estimated property values.
*   **`trigger.sql`**
    *   **`MLS_LISTINGS`**: The target table for the `mls_listings_bur_trg` trigger, which updates the `LAST_ACTIVE` column during updates.

## Submodules / Subdirectories

There are no subdirectories within `code/database/data_updates`.

## Maintenance & Modernization Notes

*   **Execution Order and Idempotence**: Most scripts here are designed for one-time execution. When running `delete_osceola_duplicates.sql`, ensure a backup is available, and understand the cascade effects of deleting property records.
*   **`seed_estimate_values.sql` Logic**: The logic for calculating percentiles and medians (`PERCENTILE_DISC`, `MEDIAN`) for property values is sophisticated. Any changes to how property value estimates are derived should thoroughly test the impact on these calculations.
*   **Trigger Logic**: The `mls_listings_bur_trg` trigger's logic for `LAST_ACTIVE` involves careful handling of `NULL` values and preventing unnecessary updates if a new value is identical to the old. Ensure this logic remains robust if listing status workflows change.
*   **Source IDs**: The `delete_osceola_duplicates.sql` script specifically targets `source_id = 59`. If similar cleanup is needed for other counties or data sources, the `source_id` condition would need to be parameterized or duplicated.
*   **GIS Bug Fixes**: `bugfix_GIS.sql` targets specific data issues. Future GIS data integrity issues might require similar targeted fixes, but this script is not a generic solution.

---
