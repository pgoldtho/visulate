# Public Records City Data Generation and Management

This directory contains SQL scripts and supporting documents responsible for managing and generating descriptive, metadata, and linked content for individual cities within the Visulate public records application. The primary goal is to enrich the `RNT_CITIES` table with comprehensive, SEO-friendly text, external links, RSS feeds, and associated media to enhance user experience and search engine visibility.

The scripts dynamically generate or update city-specific content based on various data sources, including census information, geographic proximity to other major cities, and quick facts. It supports both static updates and programmatic text generation, often involving Oracle Spatial (`SDO_NN`) for geographical calculations.

## Files & Component Responsibilities

| Filename                          | Description                                                                                                                                                                                                                              |
| :-------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Brevard City paragraphs.rtf`     | A rich text format document likely containing static text paragraphs or source material for descriptions related to cities in Brevard County. This content is presumed to be manually authored and then integrated into SQL scripts.     |
| `North Florida cities.docx`       | A Microsoft Word document likely containing static text or source material for descriptions related to cities in North Florida. This content is presumed to be manually authored and then integrated into SQL scripts.                |
| `afiedt.buf`                      | A buffer file containing the definition for an Oracle object type `pr_corp_loc_type`, which is a programmatic data structure for corporate location information. While present, its direct use by other files in this directory is not explicit. |
| `city_desc.sql`                   | Contains SQL `UPDATE` statements to populate the `DESCRIPTION` column of the `RNT_CITIES` table with static, pre-generated HTML text for numerous cities, often including census data and references to nearby locations.             |
| `city_links.sql`                  | Contains SQL `UPDATE` statements to append external links (e.g., Wikipedia, official city websites) to the `DESCRIPTION` column of the `RNT_CITIES` table.                                                                            |
| `gen_city_text.sql`               | An Oracle PL/SQL script that dynamically generates detailed descriptive text for individual cities, combining static text snippets with data from various public records and demographic tables.                                     |
| `gen_county_text.sql`             | An Oracle PL/SQL script that dynamically generates descriptive text for counties, similarly combining static content with data from public records and demographic tables.                                                             |
| `gen_fl_text.sql`                 | An Oracle PL/SQL script that generates state-level overview text for Florida, including search forms and images, utilizing data from `RNT_CITIES` and `RNT_REGIONS`.                                                                |
| `insert_media.sql`                | An Oracle PL/SQL script that inserts records into the `RNT_CITY_MEDIA` table, associating image files (e.g., `city-name-1.jpg`) with specific cities or regions.                                                                   |
| `metadesc.sql`                    | Contains SQL `UPDATE` statements to set the `META_DESCRIPTION` column in the `RNT_CITIES` table with static, pre-generated short descriptions for SEO purposes.                                                                     |
| `remove_orange_from_brevard.sql`  | A data cleanup script that corrects data by reassigning media entries from one city ID to another and deleting a specific "ORLANDO" city entry from Brevard County.                                                               |
| `seed_rss.sql`                    | An Oracle PL/SQL script that updates the `RNT_CITIES` table with RSS news feed URLs, sources, and names for various cities.                                                                                                        |
| `spool_city_metadesc.sql`         | An Oracle PL/SQL script designed to `SPOOL` (generate) SQL `UPDATE` statements for `META_DESCRIPTION` in `RNT_CITIES`. It dynamically creates descriptions by finding nearest major cities using Oracle Spatial (`SDO_NN`).          |
| `spool_city_text.sql`             | An Oracle PL/SQL script designed to `SPOOL` SQL `UPDATE` statements for the main `DESCRIPTION` field in `RNT_CITIES`, dynamically generating content, often incorporating nearest neighbor information with HTML links.              |
| `spool_county_short_desc.sql`     | An Oracle PL/SQL script designed to `SPOOL` SQL `UPDATE` statements for short county descriptions, potentially using nearest neighbor logic.                                                                                         |
| `views.sql`                       | Defines several Oracle database views (`RNT_CITY_MEDIA_V`, `RNT_REGIONS_V`, `RNT_CITIES_V`) to provide simplified and checksummed access to the underlying tables `RNT_CITY_MEDIA`, `RNT_REGIONS`, and `RNT_CITIES`.           |

## Database Dependencies & Interactions

This directory heavily interacts with the `RNT_CITIES` table, which serves as the central repository for city-specific information. It also leverages several auxiliary tables for data sourcing and media management.

*   **`RNT_CITIES`** (TABLE, Owner: `RNTMGR2`)
    *   **Description**: The core table storing comprehensive information about cities in the application, including population, descriptions, meta descriptions, geographical data, and RSS feed details.
    *   **Interactions**:
        *   `city_desc.sql`, `city_links.sql`, `metadesc.sql`, `seed_rss.sql`, `remove_orange_from_brevard.sql`: Directly `UPDATE` this table to set or modify city attributes.
        *   `gen_city_text.sql`, `gen_county_text.sql`, `gen_fl_text.sql`: Select from and `UPDATE` this table to generate and store dynamic textual content.
        *   `insert_media.sql`: Selects `city_id` and `region_id` to link media correctly.
        *   `spool_city_metadesc.sql`, `spool_city_text.sql`, `spool_county_short_desc.sql`: Select from this table (especially `GEO_LOCATION` and `POPULATION`) to generate `UPDATE` scripts that will later modify `DESCRIPTION` and `META_DESCRIPTION` columns. These scripts also extensively use `SDO_NN` (Oracle Spatial Nearest Neighbor) functionality.
        *   `views.sql`: Defines `RNT_CITIES_V` which provides a view over this table.

*   **`RNT_CITY_MEDIA`** (TABLE, Owner: `RNTMGR2`)
    *   **Description**: Stores metadata for images and other media associated with cities.
    *   **Interactions**:
        *   `insert_media.sql`: `INSERT`s new media records.
        *   `remove_orange_from_brevard.sql`: `UPDATE`s existing `city_id` values and may implicitly `DELETE` related media if `RNT_CITIES` is deleted with cascade constraints.
        *   `views.sql`: Defines `RNT_CITY_MEDIA_V` which provides a view over this table.

*   **`RNT_REGIONS`** (TABLE, Owner: `RNTMGR2`)
    *   **Description**: Stores information about geographical regions, which cities belong to.
    *   **Interactions**:
        *   `gen_fl_text.sql`: Selects from this table for regional context in generating Florida-level text.
        *   `metadesc.sql`: Selects from this table for regional context in generating meta descriptions.
        *   `views.sql`: Defines `RNT_REGIONS_V` which provides a view over this table.

*   **`LDR_COUNTY_DATA`** (TABLE, Owner: `RNTMGR2`)
    *   **Description**: Contains loaded data related to counties, likely demographic or economic statistics.
    *   **Interactions**:
        *   `gen_city_text.sql`, `gen_county_text.sql`: Selects from this table as a source for dynamic text generation.

*   **`LDR_CITY_QFACTS`** (TABLE, Owner: `RNTMGR2`)
    *   **Description**: Contains quick facts or summary data for cities.
    *   **Interactions**:
        *   `gen_city_text.sql`: Selects from this table as a source for dynamic text generation.

*   **`PR_UCODE_DATA`** (TABLE, Owner: `RNTMGR2`)
    *   **Description**: Contains data related to universal codes or demographic statistics used in public records.
    *   **Interactions**:
        *   `gen_city_text.sql`, `gen_county_text.sql`: Selects from this table as a source for dynamic text generation.

*   **`PR_PROPERTY_SALES`** (TABLE, Owner: `RNTMGR2`)
    *   **Description**: Stores detailed records of property sales.
    *   **Interactions**:
        *   `gen_city_text.sql`: Selects from this table, likely for deriving statistics or trends incorporated into city descriptions.

*   **`LDR_COUNTIES`** (TABLE, Owner: `RNTMGR2`)
    *   **Description**: Contains loaded data about counties.
    *   **Interactions**:
        *   `gen_city_text.sql`, `gen_county_text.sql`: Selects from this table as a source for dynamic text generation.

*   **`PR_COUNTY_SUMMARY_MV`** (TABLE, Owner: `RNTMGR2`)
    *   **Description**: A materialized view or table containing summary data for counties.
    *   **Interactions**:
        *   `gen_county_text.sql`: Selects from this table as a source for dynamic text generation.

*   **`RNT_CITY_MEDIA_V`**, **`RNT_REGIONS_V`**, **`RNT_CITIES_V`** (VIEWS, Owner: `RNTMGR2`)
    *   **Description**: These views provide a standardized interface to the respective tables, often including checksums for change detection.
    *   **Interactions**: Defined by `views.sql`. Used by other modules (e.g., PHP classes) for reading data.

## Submodules / Subdirectories

This directory does not contain any subdirectories.

## Maintenance & Modernization Notes

*   **Mixed Content Generation Strategies**: The directory employs a mix of static SQL updates (`city_desc.sql`, `metadesc.sql`) and dynamic PL/SQL generation (`gen_city_text.sql`, `spool_city_text.sql`). While flexible, this can lead to potential inconsistencies or difficulties in maintaining a unified content strategy. A centralized content generation framework could streamline this.
*   **`SPOOL` Scripts for Data Updates**: The use of `spool_*.sql` scripts to generate other SQL `UPDATE` scripts is a powerful but potentially complex pattern. It requires careful management to ensure the generated scripts are always current and correctly applied. Consider if these dynamic updates could be performed directly via PL/SQL procedures without an intermediate spooling step, or integrate them into an ETL pipeline.
*   **Reliance on Oracle Spatial (`SDO_NN`)**: Geographic descriptions and nearest neighbor calculations are central to `spool_city_metadesc.sql`, `spool_city_text.sql`, and `spool_county_short_desc.sql`. Any migration away from Oracle or changes to spatial data handling would require significant refactoring.
*   **Manual Content Sources**: The presence of `.rtf` and `.docx` files suggests a workflow where some content originates from word processing documents. This manual step could be a bottleneck or source of errors; exploring ways to automate content ingestion or manage these as templates within the database might be beneficial.
*   **Data Cleanup Scripts**: `remove_orange_from_brevard.sql` indicates the need for specific data correction, which suggests potential issues in the initial data loading or ongoing data integrity processes that might need to be addressed at the source.
