# Volusia County Public Records Database Integration

This directory contains the SQL scripts and processes specifically designed for extracting, transforming, and loading (ETL) public records data from Volusia County into the Visulate database. It is a critical component for populating and maintaining property, owner, sales, tax, and usage information for Volusia County within the `RNTMGR2` schema.

The process involves several stages:
1.  **Extraction**: Raw data is pulled from external Volusia County property appraiser database views (via a database link `@volusia`).
2.  **Staging**: Extracted data is temporarily stored in local staging tables (e.g., `vol_properties`, `vol_sqft`, `vol_sales`).
3.  **Transformation & Loading**: A series of PL/SQL scripts process the staged data, applying business rules and transformations, and then loading it into the main `PR_` (Public Records) tables.
4.  **Maintenance**: Utility scripts for data cleanup and specific updates.

This module ensures that the Visulate application has up-to-date and structured public records information for Volusia County properties.

## Files & Component Responsibilities

| Filename                     | Description                                                                                                                                                                                                                                                                                                                            |
| :--------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `afiedt.buf`                 | A scratchpad SQL query that retrieves corporate names based on geographical location by querying `PR_LOCATIONS` and `PR_CORPORATIONS`. It is not part of the core Volusia ETL process but demonstrates interaction with populated tables.                                                                                                   |
| `cleanup_invalid_sales.sql`  | SQL script to remove `PR_PROPERTY_SALES` records where the `new_owner_id` is linked to an owner named 'Not Recorded', ensuring data integrity for sales.                                                                                                                                                                                |
| `current_owner.sql`          | Utility script that updates the `PR_PROPERTY_OWNERS` and `PR_PROPERTY_SALES` tables to reflect the current owner for properties, also handling potential duplicate sales records for the most recent transaction.                                                                                                                         |
| `extract1.sql`               | The primary extraction script. It queries external Volusia County views (e.g., `Web_Parcel_View_volcoit@volusia`, `Web_Res_Bld_View@volusia`, `Web_Bldg_View@volusia`) and populates the `vol_properties` staging table with raw property, owner, and basic building information.                                                       |
| `process.txt`                | A plain text file detailing the manual, step-by-step instructions for executing the entire Volusia data load process, including running SQL scripts, exporting/importing data, and refreshing materialized views.                                                                                                                      |
| `setup_volusia.sql`          | An orchestrator script that sequentially calls the main Volusia data loading scripts (`volusia1.sql` through `volusia5.sql`), automating the loading phase after extraction and staging.                                                                                                                                             |
| `vol_seed_data.sql`          | Inserts or updates essential seed data specific to Volusia County into system tables like `PR_USAGE_CODES` (property use types), `PR_SOURCES` (metadata about Volusia County as a data source, including URL templates), and `PR_DEED_CODES`.                                                                                         |
| `vol_tables.sql`             | Script to drop and recreate the temporary staging tables (`vol_properties`, `vol_sqft`, `vol_sales`) used to hold extracted raw data from Volusia County before transformation and loading into the `PR_` tables.                                                                                                                        |
| `volusia1.sql`               | The first main loading script. It processes data from `vol_properties` to create or update records in `PR_PROPERTIES` (core property details) and `PR_PROPERTY_OWNERS`, linking owners to properties and handling mailing addresses. It also utilizes `RNT_CITY_ZIPCODES` for state lookup.                                               |
| `volusia2.sql`               | Updates the `PR_PROPERTY_USAGE` table by setting or updating the `ucode` (usage code) for properties based on the extracted `ucode` from `vol_properties`.                                                                                                                                                                            |
| `volusia3.sql`               | Updates the `SQ_FT` (square footage) column in `PR_PROPERTIES` for Volusia properties, deriving this information from the aggregated data stored in the `vol_sqft` staging table.                                                                                                                                                      |
| `volusia4.sql`               | Processes sales data from the `vol_sales` staging table. It populates `PR_PROPERTY_SALES` with detailed sales records (date, price, deed code, plat book/page) and ensures `PR_OWNERS` records exist for all associated parties.                                                                                                         |
| `volusia4a.sql`              | Refines the sales and ownership data by updating the `new_owner_id` in `PR_PROPERTY_SALES` for the most recent sale of each property to correctly link to the `owner_id` from `PR_PROPERTY_OWNERS`.                                                                                                                                        |
| `volusia5.sql`               | Calculates and inserts/updates property tax information into the `PR_TAXES` table. It uses `millage_code` and `tax_value` from `vol_properties`, applying predefined (and some hardcoded) millage rates for different Volusia County jurisdictions.                                                                                     |
| `volusia_functions.sql`      | Defines the `VOLUSIA_FUNCTIONS` PL/SQL package, which includes utility functions such as `decode_propty_class` and `get_ucode` to translate Volusia's specific property classification and usage codes into the Visulate system's standardized formats.                                                                                   |

## Database Dependencies & Interactions

The scripts in this directory extensively interact with the `RNTMGR2` schema, primarily populating and updating tables prefixed with `PR_` (Public Records). They also rely on external data sources via database links.

*   **Staging Tables (Created by `vol_tables.sql`)**:
    *   `vol_properties`: Stores raw property, owner, and attribute data extracted from Volusia County.
    *   `vol_sqft`: Stores raw square footage data extracted from Volusia County.
    *   `vol_sales`: Stores raw sales data extracted from Volusia County.
*   **Core Public Records Tables (Populated/Updated)**:
    *   `PR_PROPERTIES`: Stores the main property records (addresses, square footage, bedrooms, bathrooms, source links).
    *   `PR_PROPERTY_OWNERS`: Links properties to their current and historical owners.
    *   `PR_OWNERS`: Stores details about individual and corporate owners.
    *   `PR_PROPERTY_SALES`: Stores historical sales transaction data for properties.
    *   `PR_TAXES`: Stores annual tax assessment values and calculated tax amounts.
    *   `PR_PROPERTY_USAGE`: Stores the primary usage codes for each property.
    *   `PR_LOCATIONS`: May be implicitly populated or used by related geographic data processes, though direct writes aren't explicit in these Volusia scripts, `afiedt.buf` queries it.
*   **Reference/Metadata Tables (Populated/Updated by `vol_seed_data.sql` and used for lookups)**:
    *   `PR_USAGE_CODES`: Defines standardized property usage codes.
    *   `PR_SOURCES`: Stores metadata for public records data sources, including specific URL patterns for Volusia County.
    *   `PR_DEED_CODES`: Stores explanations for various deed types in sales transactions.
    *   `RNT_CITY_ZIPCODES`: Used by `volusia1.sql` to derive state information from zip codes.
*   **External Data Source**:
    *   Volusia County Property Appraiser Database (`@volusia` database link): `Web_Parcel_View_volcoit`, `Web_Res_Bld_View`, `Web_Bldg_View`, `Web_Comm_Area_View`, `Web_Condo_Bld_View`. These are the initial source of raw data.

## Submodules / Subdirectories

This directory does not contain any child subdirectories.

## Maintenance & Modernization Notes

*   **External Data Link (`@volusia`)**: The reliability and performance of the `@volusia` database link are crucial. Any changes to the external database schema or access permissions would break the extraction process.
*   **Manual Process Flow (`process.txt`)**: The `process.txt` indicates a largely manual process involving exports, imports, and sequential script execution. This could be a candidate for automation using shell scripts, cron jobs, or a dedicated ETL tool to improve reliability and reduce operational overhead.
*   **Hardcoded Millage Rates**: `volusia5.sql` contains hardcoded millage rates. These rates change periodically and require manual updates, which is prone to error and can lead to outdated tax calculations. Consider externalizing these rates into a reference table for easier management.
*   **Data Validation and Error Handling**: While there are `EXCEPTION` blocks, extensive logging and detailed error reporting might be beneficial for large-scale data loads to quickly identify and troubleshoot issues.
*   **Redundancy**: `current_owner.sql` appears to perform similar functions to parts of `volusia1.sql` and `volusia4a.sql`. A review could consolidate or clarify its role.
*   **`afiedt.buf`**: This file is likely a leftover temporary file. It should be reviewed to determine if its content is still relevant for any utility purpose or if it can be safely removed. If kept, it should be renamed to something more descriptive.
*   **Performance**: For very large datasets, cursor-based processing (`FOR p_rec IN cur_prop LOOP`) can be slow. Bulk collection (`BULK COLLECT`) and `FORALL` statements could offer significant performance improvements where applicable.

---
