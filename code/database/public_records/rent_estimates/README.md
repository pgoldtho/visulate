# Rent Estimates Data and Requirements

## Functional Overview
This directory contains foundational data and a requirements specification related to the generation of property rent estimates within the Visulate application, specifically focusing on public records for income valuation. It includes historical Fair Market Rent (FMR) data and a mapping of ZIP codes to counties, which are essential inputs for calculating pro-forma income statements and valuations for properties, particularly for inclusion in REO Rental offerings. The `requirements.txt` outlines the logic and business needs for these estimations, emphasizing the use of Census and Department of Revenue (DOR) data.

## Files & Component Responsibilities

| File Name                    | Description                                                                                                                                                                                                                                                                 |
| :--------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `FY2012_FMRS_50_County.csv`  | Contains Fair Market Rent (FMR) data, likely sourced from HUD, for various counties. This dataset specifies FMRs for different bedroom counts (e.g., 0-bedroom, 1-bedroom, 2-bedroom, etc.) for Fiscal Year 2012, along with county and metropolitan statistical area (MSA) identifiers. |
| `ZIP_COUNTY_122011.csv`      | Provides a mapping between ZIP codes and corresponding counties. It also includes ratio columns (`RES_RATIO`, `BUS_RATIO`, `OTH_RATIO`, `TOT_RATIO`), which might indicate the proportion of residential, business, or other property types within a ZIP code, potentially used for weighted calculations. |
| `requirements.txt`           | A detailed specification document outlining the rules, logic, and functional requirements for income valuation estimates within Visulate. It describes the problem, proposed solution, business need, and new functionalities such as using Census and sales data for rent seeding and adjustments. |

## Database Dependencies & Interactions
While the files directly within this directory are data sources and a requirements document, the `requirements.txt` specifies that the *system* (Visulate's income valuation logic) interacts with database tables. Specifically:
*   **`pr_values`**: Mentioned as the table where "seed values are stored for city, ucode, class and year."
*   **`pr_properties`**: Mentioned for retrieving the "DOR property class" to refine estimates.

These files themselves do not contain direct SQL queries or ORM configurations for database access; rather, they provide the data (`.csv` files) or the conceptual framework (`requirements.txt`) that guides how Visulate's backend code would interact with these database tables to process and store rent estimates.

## Submodules / Subdirectories
This directory does not contain any subdirectories.

## Maintenance & Modernization Notes
*   **Data Freshness**: The FMR data (`FY2012_FMRS_50_County.csv`) is from Fiscal Year 2012. For current and accurate rent estimates, this data source should be updated with more recent FMR data from HUD or similar sources. The `ZIP_COUNTY_122011.csv` is also dated, and while less volatile, should be reviewed for current accuracy.
*   **Model Refinement**: The `requirements.txt` outlines a logic for adjusting base values with median sales prices and adding "circuit breaker" logic. When modernizing, evaluate if these rules are still optimal or if more advanced statistical models (e.g., regression analysis, machine learning) could provide more accurate and robust estimates.
*   **Integration with External APIs**: Consider replacing static CSV data with dynamic lookups via APIs for FMR, Census data, and sales data to ensure real-time accuracy and reduce manual updates.
*   **Scalability**: Ensure that the data processing and estimation logic can scale efficiently with a growing number of properties and users.
