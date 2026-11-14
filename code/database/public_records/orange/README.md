# Orange County Public Records Database Scripts

## Functional Overview
This directory contains a collection of SQL scripts and a setup guide (`orange_setup.txt`) specifically designed for importing, processing, and maintaining public records data for Orange County, Florida. These scripts are crucial for populating and updating the core `PR_` (Public Records) schema tables within the Visulate database, including property details, owner information, sales history, tax assessments, and property usage classifications, all sourced from Orange County's public records.

The scripts collectively handle:
*   Initial data seeding for source and deed codes.
*   Importing new property and owner records.
*   Updating existing property details such as city, zipcode, bedrooms, and bathrooms.
*   Recording property sales transactions.
*   Assigning and updating property usage codes.
*   Calculating and storing tax assessment data.
*   Generating aggregated usage statistics.
*   Performing complex calculations for property valuation estimates.

## Files & Component Responsibilities

| File Name           | Description                                                                                                                                                                                                                                                            |
| :------------------ | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `current_owner.sql` | PL/SQL script that identifies and sets the current owner for properties in `PR_PROPERTY_OWNERS` and `PR_PROPERTY_SALES`. It also handles the removal of duplicate sales records for the most recent sale of a property.                                                     |
| `orange1.sql`       | The primary script for the initial import of Orange County property data. It reads from the `orange_properties` staging table to insert new records into `PR_PROPERTIES`, `PR_PROPERTY_OWNERS`, and `PR_PROPERTY_USAGE`, parsing addresses and determining initial usage. |
| `orange1_fix_city.sql`| Updates the `ADDRESS1`, `CITY`, and `ZIPCODE` fields in `PR_PROPERTIES` for existing Orange County properties where discrepancies are found between the source data and the current database records.                                                                   |
| `orange2.sql`       | Imports sales transaction data from the `orange_properties` staging table into `PR_PROPERTY_SALES`. It handles multiple potential sales records per property, including details like sale date, price, deed type, and instrument number.                                 |
| `orange2_beds.sql`  | Updates `PR_PROPERTIES` with `TOTAL_BEDROOMS` and `TOTAL_BATHROOMS` information, sourced from the `orange_properties` staging table.                                                                                                                                    |
| `orange3.sql`       | Imports and calculates tax assessment data for Orange County properties, populating the `PR_TAXES` table. It uses a predefined set of millage rates (hardcoded per millage code and city code) for a specific year (2010 in the sample).                                   |
| `orange3_ucode.sql` | Updates `PR_PROPERTY_USAGE` records for existing Orange County properties, mapping raw `property_use_code` values from the source to standardized `ucode` values.                                                                                                        |
| `orange_setup.txt`  | A text-based procedural guide outlining the steps for a full setup or update cycle of Orange County public records data. It specifies the order of operations, including database imports, script executions, and materialized view refreshes.                         |
| `seed_data.sql`     | Seeds initial data into `PR_SOURCES` to register Orange County as a data source and inserts various `DEED_CODE` definitions into `PR_DEED_CODES`.                                                                                                                      |
| `seed_values.sql`   | Calculates and inserts estimated property values per square foot into `PR_PROPERTY_SALES`. This script groups sales data by year, usage code, and city to derive statistical metrics like min, max, median, and percentile-based class valuations (A, B, C).           |
| `ucode_data.sql`    | Aggregates and inserts statistical data into `PR_UCODE_DATA`, providing counts and total square footage per city and usage code for Orange County properties. It also includes specific `DELETE` statements and calls `prop_class_pkg.process_sales`.                  |

## Database Dependencies & Interactions

The scripts in this directory interact extensively with several tables within the `RNTMGR2` schema, primarily for storing and managing public records data. The data is initially sourced from a staging table, typically named `orange_properties`, which is populated by an external data dump (`orange.dmp` as indicated in `orange_setup.txt`).

**Tables Accessed:**

*   **`PR_PROPERTIES`**: (TABLE - RNTMGR2)
    *   **Usage**: Central table for property information. `orange1.sql` inserts new properties. `orange1_fix_city.sql`, `orange2_beds.sql`, `ucode_data.sql`, `current_owner.sql` (implicitly via `prop_id` lookups), and `seed_values.sql` all read from or update property details like address, city, zipcode, bedrooms, bathrooms, and square footage.
*   **`PR_PROPERTY_OWNERS`**: (TABLE - RNTMGR2)
    *   **Usage**: Stores owner information linked to properties. `orange1.sql` inserts owner records. `current_owner.sql` updates owner status.
*   **`PR_PROPERTY_SALES`**: (TABLE - RNTMGR2)
    *   **Usage**: Records property sales transactions. `orange2.sql` inserts new sales. `current_owner.sql` removes duplicate sales. `seed_values.sql` reads sales data to calculate estimated values.
*   **`PR_TAXES`**: (TABLE - RNTMGR2)
    *   **Usage**: Stores tax assessment details. `orange3.sql` inserts calculated tax records.
*   **`PR_PROPERTY_USAGE`**: (TABLE - RNTMGR2)
    *   **Usage**: Classifies properties by use code. `orange1.sql` inserts initial usage. `orange3_ucode.sql` updates usage codes. `ucode_data.sql` and `seed_values.sql` read usage information for aggregation and valuation.
*   **`PR_UCODE_DATA`**: (TABLE - RNTMGR2)
    *   **Usage**: Stores aggregated statistics about property usage per city. `ucode_data.sql` populates this table.
*   **`PR_OWNERS`**: (TABLE - RNTMGR2)
    *   **Usage**: Stores distinct owner details. `current_owner.sql` references this to manage owners.
*   **`PR_SOURCES`**: (TABLE - RNTMGR2)
    *   **Usage**: Defines the source of public records data. `seed_data.sql` inserts the entry for Orange County.
*   **`PR_DEED_CODES`**: (TABLE - RNTMGR2)
    *   **Usage**: Stores descriptions for various deed types. `seed_data.sql` and `orange2.sql` interact with this table.
*   **`RNT_CITY_ZIPCODES`**: (TABLE - RNTMGR2)
    *   **Usage**: Used for geographical lookups, primarily to determine city and state from zip codes. `orange1.sql` and `seed_values.sql` utilize this.
*   **`RNT_CITIES`**: (Implicitly via `RNT_CITY_ZIPCODES` and `seed_values.sql`): Provides city names and IDs.
*   **`RNT_ZIPCODES`**: (Implicitly via `RNT_CITY_ZIPCODES` and `seed_values.sql`): Provides zip code details.
*   **`PR_USAGE_CODES`**: (Implicitly via `PR_PROPERTY_USAGE`, `orange3_ucode.sql`, `seed_values.sql`, `ucode_data.sql`): Provides descriptions and hierarchy for use codes.
*   **`prop_class_pkg`**: (PACKAGE)
    *   **Usage**: `ucode_data.sql` explicitly calls `prop_class_pkg.process_sales`, indicating reliance on business logic encapsulated in this package.
*   **Materialized Views**: `orange_setup.txt` indicates that several materialized views (`PR_COMMERCIAL_SALES_MV`, `PR_COMMERCIAL_SUMMARY_MV`, `PR_SALES_MV`, `PR_SALES_SUMMARY_MV`, `PR_LAND_SALES_MV`, `PR_LAND_SUMMARY_MV`) are refreshed after data processing, signifying downstream dependencies for reporting and analytics.

## Submodules / Subdirectories
This directory does not contain any subdirectories.

## Maintenance & Modernization Notes
*   **Procedural Execution**: The `orange_setup.txt` file is critical. It defines a manual, ordered execution flow for data processing. Any changes to the data pipeline require careful consideration of this sequence. Modernization might involve automating this flow with an orchestrator or integrating it into a more robust ETL framework.
*   **PL/SQL Anonymous Blocks**: Most scripts are self-contained PL/SQL anonymous blocks. While functional, encapsulating common logic (e.g., owner management, sales processing) into reusable procedures or packages could improve maintainability and testability.
*   **Hardcoded Source ID**: The `source_id = 5` is frequently hardcoded throughout the scripts, tying them directly to Orange County. If similar processes were to be generalized for other counties, this would need to become a parameter or configurable value.
*   **Staging Table Dependency**: The reliance on an `orange_properties` staging table (populated via `imp orange.dmp`) is a foundational dependency. Changes to the source data schema or import process would require updates to these scripts.
*   **Hardcoded Millage Rates**: The `orange3.sql` script contains hardcoded millage rates and city codes, making it year and region-specific. For future years or other counties, this data would need to be updated or sourced dynamically.
*   **Data Quality & Error Handling**: While some `EXCEPTION` blocks are present, comprehensive error logging and robust data validation beyond basic checks might be beneficial for larger-scale or automated runs.
*   **`seed_values.sql` Logic**: The statistical calculations for property valuation are sophisticated. Any changes to valuation methodology would require careful modification of this script.
